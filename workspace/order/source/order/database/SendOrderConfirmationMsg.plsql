-----------------------------------------------------------------------------
--
--  Logical unit: SendOrderConfirmationMsg
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211025  NiDalk   Bug 161320(SC21R2-5441), Modified Get_Message_Line_Status___ to set row_changed_ as true when lines are cancelled as well.
--  210331  MaEelk   SCZ-14235(Bug 158620), Passed the correct buy_qty_due and price_conv_factor values instead of the hard corded vaalue 1 
--  210331           to the call Cust_Order_Line_Discount_API.Get_Total_Line_Discount inside Get_Line_Amounts_And_Discounts___.
--  210202  ChBnlk   SC2020R1-12378, Moved methods related to SendOrderConfirmation from the utility CustomerOrderTransfer.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-- Send_Order_Confirmation
--   Generate an order response (ORDERSP) EDI/MHS/ITS message for the specified order.
PROCEDURE Send_Order_Confirmation (
   order_no_   IN VARCHAR2,
   media_code_ IN VARCHAR2 )
IS
BEGIN
   IF (media_code_ != 'INET_TRANS') THEN
      Send_Order_Conf_Mhs_Edi___(order_no_, media_code_);            
   ELSE
      Send_Order_Conf_Inet_Trans___(order_no_, media_code_);
   END IF;
END Send_Order_Confirmation;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Send_Order_Conf_Inet_Trans___
-- this method is used to send the customer order confirmation
-- using Inet_Trans.
-- If a change is done inside this method please visit Send_Order_Conf_Mhs_Edi___
-- to check if the relevant correction is required for EDI/MHS flow.
PROCEDURE Send_Order_Conf_Inet_Trans___ (
       order_no_   IN VARCHAR2,
       media_code_ IN VARCHAR2)
   IS      
      cust_ord_strcut_rec_    Customer_Order_Struct_Rec; 
      msg_id_                 NUMBER;         
      receiver_address_       VARCHAR2(2000);      
      order_conf_flag_        VARCHAR2(1);
      order_conf_             VARCHAR2(1);
      json_clob_  CLOB; 
      json_obj_   JSON_OBJECT_T;
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ITS') THEN 
      Set_Order_Conf_Struct_Rec___(cust_ord_strcut_rec_, order_conf_, order_conf_flag_, order_no_, media_code_); 
      
      receiver_address_ := Customer_Info_Msg_Setup_API.Get_Address(cust_ord_strcut_rec_.customer_no, cust_ord_strcut_rec_.media_code, cust_ord_strcut_rec_.message_type);      
            
      json_obj_ := Customer_Order_Struct_Rec_To_Json___(cust_ord_strcut_rec_);
      json_clob_ := json_obj_.to_clob;

      Plsqlap_Server_API.Post_Outbound_Message(json_clob_,
                   msg_id_, 
                   cust_ord_strcut_rec_.company,
                   receiver_address_, 
                   message_type_ => 'APPLICATION_MESSAGE',
                   message_function_ => 'SEND_CUST_ORD_CONF_INET_TRANS',
                   is_json_ => true);
                   
      Post_Send_Order_Conf___(cust_ord_strcut_rec_.order_no, cust_ord_strcut_rec_.sequence_no, cust_ord_strcut_rec_.version_no,
                     order_conf_, order_conf_flag_, media_code_ );
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
   END IF;
END Send_Order_Conf_Inet_Trans___;


  
-- Send_Order_Conf_Mhs_Edi___
-- this method is used to send the customer order confirmation
-- using Mhs/Edi.
-- If a change is done inside this method please visit Send_Order_Conf_Inet_Trans___
-- to check if the relevant correction is required for INET_TRANS flow.
PROCEDURE Send_Order_Conf_Mhs_Edi___ (
   order_no_   IN VARCHAR2,
   media_code_ IN VARCHAR2)
IS 
   attr_                   VARCHAR2(32000);
   org_message_id_         NUMBER;
   message_id_             NUMBER;
   message_line_           NUMBER;
   message_type_           VARCHAR2(30);
   message_name_           VARCHAR2(255);
   customer_po_no_         VARCHAR2(50);
   receiver_address_       VARCHAR2(2000);
   sender_address_         VARCHAR2(2000);   
   company_country_        VARCHAR2(35);
   postal_address_         VARCHAR2(2000);
   ean_doc_addr_           VARCHAR2(2000);
   ean_del_addr_           VARCHAR2(2000);
   ean_pay_addr_           VARCHAR2(2000);
   row_changed_            BOOLEAN := FALSE;
   row_added_              BOOLEAN := FALSE;
   status_                 VARCHAR2(100);
   agreement_note_id_      NUMBER;
   salesman_name_          VARCHAR2(100);
   authorize_name_         VARCHAR2(100);
   company_                VARCHAR2(20);
   price_unit_meas_        VARCHAR2(10);   
   sequence_no_            NUMBER;
   version_no_             NUMBER;
   cross_ref_rec_          Cust_Addr_Cross_reference_API.Public_Rec;
   address_rec_            Customer_Order_Address_API.Cust_Ord_Addr_Rec;   
   tot_disc_               NUMBER;    
   net_curr_amount_        NUMBER;
   gross_curr_amount_      NUMBER;
   discount_amount_        NUMBER;      
   pay_term_desc_          VARCHAR2(100);
   process_online_         BOOLEAN := FALSE;   
   fax_no_                 VARCHAR2(200);
   phone_no_               VARCHAR2(200);
   email_id_               VARCHAR2(200);
   ext_buy_qty_due_        NUMBER;
   ext_wanted_del_date_    DATE;  
   
   CURSOR get_line_info IS
      SELECT order_no, line_no, rel_no, catalog_no, catalog_desc, buy_qty_due, revised_qty_due,
             sales_unit_meas, sale_unit_price, unit_price_incl_tax, base_sale_unit_price, base_unit_price_incl_tax,
             contract,
             price_conv_factor, currency_rate, discount, planned_delivery_date, wanted_delivery_date,
             note_id, customer_part_no, customer_part_buy_qty, customer_part_unit_meas,
             order_discount, rowstate,line_item_no,additional_discount, 
             classification_standard, classification_part_no, classification_unit_meas,
             input_unit_meas, input_qty, rental, delivery_leadtime, demand_code, ship_via_code, forward_agent_id,
             picking_leadtime, route_id, packing_instruction_id, ext_transport_calendar_id, delivery_terms, del_terms_location
      FROM customer_order_line_tab col
      WHERE order_no = order_no_
      AND    line_item_no <= 0
      AND NOT EXISTS (SELECT message_id
                  FROM ext_cust_order_line_change_tab
                  WHERE ord_chg_state = 'DELETED'
                  AND rel_no = col.rel_no
                  AND line_no = col.line_no
                  AND message_id IN (SELECT message_id
                                     FROM ext_cust_order_change_tab
                                     WHERE order_no = order_no_))
      ORDER BY order_no, to_number(line_no), to_number(rel_no);

   CURSOR get_external_info(message_id_ NUMBER, item_no_ NUMBER, line_no_ NUMBER, rel_no_ NUMBER) IS 
         SELECT line_no, rel_no, catalog_no, buy_qty_due, wanted_delivery_date, customer_part_no,
                customer_quantity, classification_standard, classification_part_no, classification_unit_meas, 
                gtin_no, input_qty, ship_via_code, forward_agent_id, picking_leadtime,
                route_id, packing_instruction_id, ext_transport_calendar_id, delivery_terms, del_terms_location
         FROM external_cust_order_line_tab eol
         WHERE eol.message_id = message_id_
         AND NOT EXISTS (SELECT 1
                         FROM customer_order_line_tab col
                         WHERE col.order_no = order_no_
                         AND col.line_no = eol.line_no
                         AND col.rel_no = eol.rel_no
                         AND col.line_item_no = item_no_)
         AND eol.rowstate = 'Created'
         AND eol.line_no = line_no_
         AND eol.rel_no  = rel_no_
         UNION ALL
         SELECT line_no, rel_no, catalog_no, buy_qty_due, wanted_delivery_date,
                customer_part_no, customer_quantity, classification_standard, classification_part_no, classification_unit_meas, 
                gtin_no, input_qty, ship_via_code, forward_agent_id, picking_leadtime,
                route_id, packing_instruction_id, ext_transport_calendar_id, delivery_terms, del_terms_location
         FROM ext_cust_order_line_change_tab eolc
         WHERE eolc.message_id IN (SELECT message_id
                                   FROM ext_cust_order_change_tab
                                   WHERE order_no = order_no_
                                   AND rowstate != 'Stopped')
         AND eolc.ord_chg_state = 'ADDED'
         AND eolc.rowstate     != 'Cancelled'
         AND NOT EXISTS (SELECT 1
                         FROM customer_order_line_tab col
                         WHERE col.order_no = order_no_
                         AND col.line_no = eolc.line_no
                         AND col.rel_no = eolc.rel_no
                         AND col.line_item_no = item_no_);                         
   
   org_rental_start_date_     DATE;
   org_rental_end_date_       DATE;
   planned_rental_start_date_ DATE;
   planned_rental_end_date_   DATE;
   acquisition_site_      VARCHAR2(5);
   tax_id_                VARCHAR2(50);
   delivery_terms_desc_   VARCHAR2(35);
   ship_via_terms_desc_   VARCHAR2(35);
   company_association_no_ VARCHAR2(50);
   customer_association_no_ VARCHAR2(50);
   company_name_         VARCHAR2(35);
   supplier_id_          VARCHAR2(20);
   header_note_          VARCHAR2(2000);
   agreement_note_       VARCHAR2(2000); 
   customer_note_        VARCHAR2(2000);
   customer_conv_factor_ NUMBER;
   inverted_conv_factor_ NUMBER;
   gtin_no_              VARCHAR2(14);
   line_note_            VARCHAR2(2000); 
   customer_no_          VARCHAR2(20);
   wanted_delivery_date_ DATE;
   del_terms_location_   VARCHAR2(100);
   order_conf_           VARCHAR2(1);
   order_conf_flag_      VARCHAR2(1);
   delivery_leadtime_    NUMBER;
   currency_code_        VARCHAR2(3);
   cust_ref_             VARCHAR2(100);
   date_entered_         DATE;
   label_note_           VARCHAR2(50);
   salesman_code_        VARCHAR2(20);
   authorize_code_       VARCHAR2(20);
   contract_             VARCHAR2(5);
   pay_term_id_          VARCHAR2(20);
   internal_po_no_       VARCHAR2(12);
   language_code_        VARCHAR2(2);
   delivery_terms_       VARCHAR2(5);
   ship_via_code_        VARCHAR2(3);
   note_id_              NUMBER;
   agreement_id_         VARCHAR2(10);
   bill_addr_no_         VARCHAR2(50);
   ship_addr_no_         VARCHAR2(50);
   customer_no_pay_      VARCHAR2(20);
   customer_no_pay_addr_no_ VARCHAR2(50);
   forward_agent_id_     VARCHAR2(20); 
BEGIN
   message_type_ := 'ORDRSP';

   Get_Order_Confirmation_Header___(org_message_id_, cross_ref_rec_, address_rec_, salesman_name_, authorize_name_, company_, pay_term_desc_, 
         customer_po_no_, wanted_delivery_date_, del_terms_location_, order_conf_, order_conf_flag_, delivery_leadtime_, 
         currency_code_, cust_ref_, date_entered_, label_note_, tax_id_, delivery_terms_desc_, ship_via_terms_desc_, company_association_no_, 
         customer_association_no_, company_name_, supplier_id_, header_note_, agreement_note_, customer_note_, ean_doc_addr_, ean_del_addr_, ean_pay_addr_,
         salesman_code_, authorize_code_, contract_, pay_term_id_, customer_no_, internal_po_no_, language_code_, delivery_terms_, ship_via_code_,
         note_id_, agreement_id_, bill_addr_no_, ship_addr_no_, customer_no_pay_, customer_no_pay_addr_no_, forward_agent_id_, order_no_);

   acquisition_site_ := Cust_Ord_Customer_API.Get_Acquisition_Site(customer_no_);
  
   receiver_address_ := Customer_Info_Msg_Setup_API.Get_Address(customer_no_, media_code_, message_type_);
   
   -- Retrieve postal address of company (recipient) from Enterprise
   sender_address_   := Company_Msg_Setup_API.Get_Address(company_, media_code_, message_type_);
   
   IF Site_Discom_Info_API.Get_Exec_Ord_Change_Online_Db(acquisition_site_) = 'TRUE' THEN
      process_online_ := TRUE;
   END IF;
   
   -- Create OUT_MESSAGE
   IF NOT process_online_ THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CLASS_ID', message_type_, attr_);
      Client_SYS.Add_To_Attr('MEDIA_CODE', media_code_, attr_);
      Client_SYS.Add_To_Attr('RECEIVER', receiver_address_, attr_);
      Client_SYS.Add_To_Attr('SENDER', sender_address_, attr_);
      Client_SYS.Add_To_Attr('APPLICATION_MESSAGE_ID', order_no_, attr_);
      Client_SYS.Add_To_Attr('APPLICATION_RECEIVER_ID', customer_no_, attr_);

      Connectivity_SYS.Create_Message(message_id_, attr_);
   ELSE
      message_id_ := Connectivity_SYS.Get_Next_In_Message_Id();      
   END IF;

   Trace_SYS.Field('ORG_MESSAGE_ID', org_message_id_);

   -- Create OUT_MESSAGE_LINE (for lines)
   message_name_ := 'ROW';
   message_line_ := 1; -- reserve line 1 for HEADER

   FOR linerec_ IN get_line_info LOOP
      
      message_line_ := message_line_ + 1;
      Trace_SYS.Field('Creating message ROW', message_line_);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
      Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
      Client_SYS.Add_To_Attr('NAME', message_name_, attr_);
      Client_SYS.Add_To_Attr('C00', linerec_.order_no, attr_);
      Client_SYS.Add_To_Attr('C01', customer_po_no_, attr_);
      Client_SYS.Add_To_Attr('C02', linerec_.line_no, attr_);
      Client_SYS.Add_To_Attr('C03', linerec_.rel_no, attr_);
      Client_SYS.Add_To_Attr('C04', linerec_.catalog_no, attr_);
      Client_SYS.Add_To_Attr('C05', linerec_.catalog_desc, attr_);
      Client_SYS.Add_To_Attr('N00', linerec_.buy_qty_due, attr_);
      
      Get_Order_Conf_Line_Rec___(price_unit_meas_, customer_conv_factor_, inverted_conv_factor_, planned_rental_start_date_, planned_rental_end_date_, 
                         line_note_, gtin_no_, customer_no_, contract_, linerec_.rental, linerec_.customer_part_no, 
                        linerec_.catalog_no, linerec_.input_unit_meas, linerec_.note_id, order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
         
      Client_SYS.Add_To_Attr('N14', customer_conv_factor_, attr_);
      Client_SYS.Add_To_Attr('N22', inverted_conv_factor_, attr_);
      
      Get_Message_Line_Status___(row_changed_, row_added_, status_, org_rental_start_date_, org_rental_end_date_, ext_buy_qty_due_, 
            ext_wanted_del_date_, org_message_id_, linerec_.order_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no,
            linerec_.rowstate, internal_po_no_, linerec_.customer_part_buy_qty, linerec_.buy_qty_due, linerec_.ship_via_code,
            linerec_.delivery_terms, linerec_.del_terms_location,
            linerec_.forward_agent_id, linerec_.ext_transport_calendar_id, linerec_.packing_instruction_id, 
            linerec_.route_id, linerec_.picking_leadtime, linerec_.delivery_leadtime, linerec_.planned_delivery_date, linerec_.sale_unit_price, linerec_.rental );
      
      Get_Line_Amounts_and_Discounts___(net_curr_amount_, gross_curr_amount_, tot_disc_, discount_amount_, 
                              company_, currency_code_, linerec_.order_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no,
                              linerec_.buy_qty_due, linerec_.price_conv_factor,  linerec_.unit_price_incl_tax, 
                              linerec_.sale_unit_price, linerec_.additional_discount, linerec_.order_discount);
                              
      Client_SYS.Add_To_Attr('C06', linerec_.sales_unit_meas, attr_);
      Client_SYS.Add_To_Attr('C07', price_unit_meas_, attr_);
      Client_SYS.Add_To_Attr('C08', currency_code_, attr_);
      Client_SYS.Add_To_Attr('C09', line_note_, attr_);
      Client_SYS.Add_To_Attr('C10', '', attr_); -- blanket detail note
      Client_SYS.Add_To_Attr('C11', linerec_.customer_part_no, attr_);
      Client_SYS.Add_To_Attr('C12', linerec_.customer_part_unit_meas, attr_);
      Client_SYS.Add_To_Attr('C13', status_, attr_);
      Client_SYS.Add_To_Attr('D00', linerec_.planned_delivery_date, attr_);
      Client_SYS.Add_To_Attr('D01', ext_wanted_del_date_, attr_);
      Client_SYS.Add_To_Attr('N01', ext_buy_qty_due_, attr_);
      Client_SYS.Add_To_Attr('N02', linerec_.sale_unit_price, attr_);
      Client_SYS.Add_To_Attr('N16', linerec_.unit_price_incl_tax, attr_);
      Client_SYS.Add_To_Attr('N03', linerec_.base_sale_unit_price, attr_);
      Client_SYS.Add_To_Attr('N17', linerec_.base_unit_price_incl_tax, attr_);
      Client_SYS.Add_To_Attr('N04', linerec_.price_conv_factor, attr_);
      Client_SYS.Add_To_Attr('N05', linerec_.currency_rate, attr_);
      Client_SYS.Add_To_Attr('N06', linerec_.discount, attr_);
      Client_SYS.Add_To_Attr('N07', linerec_.customer_part_buy_qty, attr_);
      Client_SYS.Add_To_Attr('N08', net_curr_amount_, attr_);
      Client_SYS.Add_To_Attr('N18', gross_curr_amount_, attr_);
      Client_SYS.Add_To_Attr('N09', linerec_.order_discount, attr_); -- Group Discount %
      Client_SYS.Add_To_Attr('N10', linerec_.additional_discount, attr_); -- Additional Discount %
      Client_SYS.Add_To_Attr('N11', discount_amount_, attr_); -- Discount Amount
      Client_SYS.Add_To_Attr('N12', tot_disc_, attr_); -- Total Discount %
      Client_SYS.Add_To_Attr('N13', linerec_.input_qty, attr_);
      Client_SYS.Add_To_Attr('C14', linerec_.classification_standard, attr_);
      Client_SYS.Add_To_Attr('C15', linerec_.classification_part_no, attr_);
      Client_SYS.Add_To_Attr('C16', linerec_.classification_unit_meas, attr_);
      Client_SYS.Add_To_Attr('C17', gtin_no_, attr_);
      
      IF (linerec_.demand_code IN ('PD', 'IPD', 'IPT')) THEN
         Client_SYS.Add_To_Attr('C18', linerec_.ship_via_code, attr_);
         Client_SYS.Add_To_Attr('C19', linerec_.forward_agent_id, attr_);
      END IF;
      
      IF (linerec_.demand_code IS NULL) THEN
         Client_SYS.Add_To_Attr('C18', linerec_.ship_via_code, attr_);
         Client_SYS.Add_To_Attr('C19', linerec_.forward_agent_id, attr_);
         Client_SYS.Add_To_Attr('C22', linerec_.ext_transport_calendar_id, attr_);
      END IF;   
           
      IF (linerec_.demand_code IN ('IPD', 'IPT')) THEN
         Client_SYS.Add_To_Attr('C23', linerec_.delivery_terms, attr_);
         Client_SYS.Add_To_Attr('C24', linerec_.del_terms_location, attr_);
      END IF;

      IF (linerec_.demand_code = 'IPD') THEN
         Client_SYS.Add_To_Attr('N15', linerec_.delivery_leadtime, attr_);
         Client_SYS.Add_To_Attr('N19', linerec_.picking_leadtime, attr_);
         Client_SYS.Add_To_Attr('C20', linerec_.route_id, attr_);
         Client_SYS.Add_To_Attr('C21', linerec_.packing_instruction_id, attr_);
         Client_SYS.Add_To_Attr('C22', linerec_.ext_transport_calendar_id, attr_);
      END IF;
      
      IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
         $IF Component_Rental_SYS.INSTALLED $THEN
            Client_SYS.Add_To_Attr('D02', planned_rental_start_date_, attr_);
            Client_SYS.Add_To_Attr('D03', planned_rental_end_date_, attr_);
            IF org_rental_start_date_ IS NOT NULL THEN
               Client_SYS.Add_To_Attr('D04', org_rental_start_date_, attr_);
            END IF;
            IF org_rental_end_date_ IS NOT NULL THEN
               Client_SYS.Add_To_Attr('D05', org_rental_end_date_, attr_);
            END IF;
         $ELSE
            Error_SYS.Component_Not_Exist('RENTAL');         
         $END
      END IF;
      
      IF process_online_ THEN
         Intersite_Data_Transfer_API.Create_Message_Line(attr_);      
      ELSE
         Connectivity_SYS.Create_Message_Line(attr_);
      END IF;      

      -- The loop below is for deleted rows. They will have status 'Not accepted'.
      IF ((linerec_.line_item_no = 0) OR (linerec_.line_item_no = -1)) THEN    
         FOR external_ IN get_external_info(org_message_id_, linerec_.line_item_no, linerec_.line_no, linerec_.rel_no) LOOP
            row_changed_ := TRUE;
            message_name_ := 'ROW';
            message_line_ := message_line_ + 1;
            Trace_SYS.Field('Creating message External ROW', message_line_);
            Client_SYS.Clear_Attr(attr_);
            -- The record only contain the most important data.
            Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
            Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
            Client_SYS.Add_To_Attr('NAME', message_name_, attr_);
            Client_SYS.Add_To_Attr('C00', order_no_, attr_);
            Client_SYS.Add_To_Attr('C01', customer_po_no_, attr_);
            Client_SYS.Add_To_Attr('C02', external_.line_no, attr_);
            Client_SYS.Add_To_Attr('C03', external_.rel_no, attr_);
            Client_SYS.Add_To_Attr('C04', external_.catalog_no, attr_);
            Client_SYS.Add_To_Attr('C08', currency_code_, attr_);
            Client_SYS.Add_To_Attr('C11', external_.customer_part_no, attr_);
            Client_SYS.Add_To_Attr('C13', 'Not accepted', attr_);
            Client_SYS.Add_To_Attr('C14', linerec_.classification_standard, attr_);
            Client_SYS.Add_To_Attr('C15', linerec_.classification_part_no, attr_);
            Client_SYS.Add_To_Attr('C16', linerec_.classification_unit_meas, attr_);
            Client_SYS.Add_To_Attr('C17', external_.gtin_no, attr_);
            Client_SYS.Add_To_Attr('D01', external_.wanted_delivery_date, attr_);
            Client_SYS.Add_To_Attr('N00', external_.buy_qty_due, attr_);
            Client_SYS.Add_To_Attr('N01', external_.buy_qty_due, attr_);
            Client_SYS.Add_To_Attr('N07', external_.customer_quantity, attr_);
            Client_SYS.Add_To_Attr('N13', external_.input_qty, attr_);
            Client_SYS.Add_To_Attr('C18', external_.ship_via_code, attr_);
            Client_SYS.Add_To_Attr('C19', external_.forward_agent_id, attr_);
            Client_SYS.Add_To_Attr('N19', external_.picking_leadtime, attr_);
            Client_SYS.Add_To_Attr('C20', external_.route_id, attr_);
            Client_SYS.Add_To_Attr('C21', external_.packing_instruction_id, attr_);
            Client_SYS.Add_To_Attr('C22', external_.ext_transport_calendar_id, attr_);            
            Client_SYS.Add_To_Attr('C23', external_.delivery_terms, attr_);
            Client_SYS.Add_To_Attr('C24', external_.del_terms_location, attr_);
            IF process_online_ THEN
               Intersite_Data_Transfer_API.Create_Message_Line(attr_);      
            ELSE
               Connectivity_SYS.Create_Message_Line(attr_);
            END IF;             
         END LOOP;
      END IF;
   Customer_Order_Line_Hist_API.New(order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, Language_SYS.Translate_Constant(lu_name_, 'ORDERCONFSENT: Order confirmation sent via :P1', NULL, media_code_));
   END LOOP;

   Trace_SYS.Message('Finished loop ROW');
   Trace_SYS.Message('Creating message HEADER');
   
   -- Create OUT_MESSAGE_LINE (for header)   
   message_name_ := 'HEADER';
   message_line_ := 1;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
   Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
   Client_SYS.Add_To_Attr('NAME', message_name_, attr_);
   Client_SYS.Add_To_Attr('C00', order_no_, attr_);
   Client_SYS.Add_To_Attr('C01', customer_po_no_, attr_);
   Client_SYS.Add_To_Attr('C02', acquisition_site_, attr_);
   Client_SYS.Add_To_Attr('C03', salesman_name_, attr_);
   Client_SYS.Add_To_Attr('C04', authorize_name_, attr_);
   Client_SYS.Add_To_Attr('C05', customer_no_, attr_);
   Client_SYS.Add_To_Attr('C06', tax_id_, attr_);
   Client_SYS.Add_To_Attr('C07', bill_addr_no_, attr_);
   Client_SYS.Add_to_Attr('C08', currency_code_, attr_);
   
   Set_Order_Conf_Header_Status___( status_, sequence_no_, version_no_,  order_no_, customer_no_, row_changed_, row_added_, media_code_, message_type_ );
    
   Client_SYS.Add_To_Attr('C09', address_rec_.addr_1, attr_);
   Client_SYS.Add_To_Attr('C10', address_rec_.address1, attr_);
   Client_SYS.Add_To_Attr('C11', address_rec_.address2, attr_);
   Client_SYS.Add_To_Attr('C12', address_rec_.zip_code, attr_);
   Client_SYS.Add_To_Attr('C13', address_rec_.city, attr_);
   Client_SYS.Add_To_Attr('C14', address_rec_.state, attr_);
   Client_SYS.Add_To_Attr('C43', address_rec_.county, attr_);
   Client_SYS.Add_To_Attr('C15', address_rec_.country_code, attr_);
   Client_SYS.Add_To_Attr('C50', address_rec_.address3, attr_);
   Client_SYS.Add_To_Attr('C51', address_rec_.address4, attr_);
   Client_SYS.Add_To_Attr('C52', address_rec_.address5, attr_);
   Client_SYS.Add_To_Attr('C53', address_rec_.address6, attr_);
   Client_SYS.Add_To_Attr('C16', customer_no_pay_, attr_);
   Client_SYS.Add_To_Attr('C17', customer_no_pay_addr_no_, attr_);
   Client_SYS.Add_To_Attr('C18', cust_ref_, attr_);
   Client_SYS.Add_To_Attr('C19', pay_term_id_, attr_);
   Client_SYS.Add_To_Attr('C86', pay_term_desc_, attr_);
   Client_SYS.Add_To_Attr('C20', delivery_terms_desc_, attr_);
   Client_SYS.Add_To_Attr('C21', ship_via_terms_desc_, attr_);
   Client_SYS.Add_To_Attr('C22', forward_agent_id_, attr_);
   Client_SYS.Add_To_Attr('C23', label_note_, attr_);
   Client_SYS.Add_To_Attr('C95', company_association_no_, attr_);
   Client_SYS.Add_To_Attr('C96', customer_association_no_, attr_);
   Get_Order_Conf_Comm_Methods___(fax_no_, phone_no_, email_id_, postal_address_, company_country_, company_, contract_, language_code_);
   
   Client_SYS.Add_To_Attr('C25', fax_no_, attr_);
   Client_SYS.Add_To_Attr('C26', phone_no_, attr_);  
   Client_SYS.Add_To_Attr('C94', email_id_, attr_);
   Client_SYS.Add_To_Attr('C27', postal_address_, attr_);
   Client_SYS.Add_To_Attr('C28', '', attr_); -- post
   Client_SYS.Add_To_Attr('C29', '', attr_); -- bank ------ 
   Client_SYS.Add_To_Attr('C30', company_name_, attr_);
   Client_SYS.Add_To_Attr('C31', company_country_, attr_);
   Client_SYS.Add_To_Attr('C32', supplier_id_, attr_);
   
   -- Retrieve note info and agreement info
   Client_SYS.Add_To_Attr('C33', header_note_, attr_);

   agreement_note_id_ := Customer_Agreement_API.Get_Note_Id(agreement_id_);
   Trace_SYS.Field('AGREEMENT_NOTE_ID', agreement_note_id_);

   Client_SYS.Add_To_Attr('C34', agreement_note_, attr_);
   Client_SYS.Add_To_Attr('C35', customer_note_, attr_); -- customer note
   Client_SYS.Add_To_Attr('C37', message_type_, attr_);
   Client_SYS.Add_To_Attr('C38', media_code_, attr_);   
   
   Trace_SYS.Field('EAN_DOC_ADDRESS_ID', bill_addr_no_);   
   Trace_SYS.Field('EAN_DOC_ADDR', ean_doc_addr_);
   Client_SYS.Add_To_Attr('C39', ean_doc_addr_, attr_);

   Trace_SYS.Field('EAN_DEL_ADDRESS_ID', ship_addr_no_);  
   Trace_SYS.Field('EAN_DEL_ADDR', ean_del_addr_);
   Client_SYS.Add_To_Attr('C40', ean_del_addr_, attr_);
  
   IF (customer_no_pay_ IS NOT NULL) THEN
      Trace_SYS.Field('EAN_PAY_ADDRESS_ID', customer_no_pay_addr_no_);
      Trace_SYS.Field('EAN_PAY_ADDR', ean_pay_addr_);
      Client_SYS.Add_To_Attr('C41', ean_pay_addr_, attr_);    
   END IF;
   
   Client_SYS.Add_To_Attr('C42', status_, attr_);
   Trace_SYS.Field('HEADER STATUS', status_);
   
   Client_SYS.Add_To_Attr('C44', cross_ref_rec_.cross_reference_info_1, attr_);
   Client_SYS.Add_To_Attr('C45', cross_ref_rec_.cross_reference_info_2, attr_); 
   Client_SYS.Add_To_Attr('C46', cross_ref_rec_.cross_reference_info_3, attr_); 
   Client_SYS.Add_To_Attr('C47', cross_ref_rec_.cross_reference_info_4, attr_); 
   Client_SYS.Add_To_Attr('C48', cross_ref_rec_.cross_reference_info_5, attr_);
   Client_SYS.Add_To_Attr('C49', del_terms_location_, attr_);

   Client_SYS.Add_To_Attr('D00', date_entered_, attr_);
   Client_SYS.Add_To_Attr('D01', wanted_delivery_date_, attr_);

   Client_SYS.Add_To_Attr('N00', delivery_leadtime_, attr_);
    
            
   Client_SYS.Add_To_Attr('N20', sequence_no_, attr_);
   Client_SYS.Add_To_Attr('N21', version_no_, attr_);
   
   IF process_online_ THEN
      Intersite_Data_Transfer_API.Create_Message_Line(attr_);      
   ELSE
      Connectivity_SYS.Create_Message_Line(attr_);
   END IF;

   IF NOT process_online_ THEN
      -- 'RELEASE' the message in the Out_Message box
      Connectivity_SYS.Release_Message(message_id_);
   ELSE
      $IF (Component_Purch_SYS.INSTALLED)$THEN
         Purchase_Order_Transfer_API.Receive_Order_Response(message_id_);
      $ELSE
         NULL;
      $END   
   END IF;
   
   Post_Send_Order_Conf___(order_no_, sequence_no_, version_no_, order_conf_, order_conf_flag_, media_code_);
   
END Send_Order_Conf_Mhs_Edi___;


-- Get_Order_Conf_Comm_Methods___
-- this method is used to get the communication methods
-- related to the send order confirmation.
PROCEDURE Get_Order_Conf_Comm_Methods___ (
   fax_no_           IN OUT VARCHAR2,
   phone_no_         IN OUT VARCHAR2,
   email_id_         IN OUT VARCHAR2,
   postal_address_   IN OUT VARCHAR2,
   company_country_  IN OUT VARCHAR2,
   company_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   language_code_    IN VARCHAR2   )
IS
   addr_id_                VARCHAR2(50);      
   
BEGIN
   addr_id_ := Site_Discom_Info_API.Get_Document_Address_Id(contract_, 'TRUE');
   company_country_ := substr(Iso_Country_API.Get_Description(Iso_Country_API.Encode(Company_Address_API.Get_Country(company_, addr_id_)),
                                 Iso_Language_API.Decode(language_code_)), 1, 35);
   postal_address_ := Company_Address_API.Get_Line(company_, addr_id_, 1) || ', ' ||
                         Company_Address_API.Get_Line(company_, addr_id_, 2) || ', ' ||
                         Company_Address_API.Get_Line(company_, addr_id_, 3) || ', ' ||
                         Company_Address_API.Get_Line(company_, addr_id_, 4) || ', ' ||
                         Company_Address_API.Get_Line(company_, addr_id_, 5) || ', ' ||
                         Company_Address_API.Get_Line(company_, addr_id_, 6) || ', ' ||
                         Company_Address_API.Get_Line(company_, addr_id_, 7) || ', ' ||
                         Company_Address_API.Get_Line(company_, addr_id_, 8) || ', ' ||
                         Company_Address_API.Get_Line(company_, addr_id_, 10) || ', ' ||
                         company_country_;
                         
   fax_no_ := Comm_Method_API.Get_Value('COMPANY', company_, Comm_Method_Code_API.Decode('FAX'), 1, addr_id_, sysdate);
   phone_no_ := Comm_Method_API.Get_Value('COMPANY', company_, Comm_Method_Code_API.Decode('PHONE'), 1, addr_id_, sysdate);
   email_id_ := Comm_Method_API.Get_Value('COMPANY', company_, Comm_Method_Code_API.Decode('E_MAIL'), 1, addr_id_, sysdate);
                         
END Get_Order_Conf_Comm_Methods___;



-- Set_Order_Conf_Header_Status___
-- This method is used to get the status
-- related to the customer order confirmation header
-- disregard of the media code.
PROCEDURE Set_Order_Conf_Header_Status___ (     
     header_status_     IN OUT VARCHAR2,
     sequence_no_       IN OUT NUMBER,
     version_no_        IN OUT NUMBER,
     order_no_          IN     VARCHAR2,
     customer_no_       IN     VARCHAR2,
     row_changed_       IN     BOOLEAN,
     row_added_         IN     BOOLEAN,     
     media_code_        IN     VARCHAR2,
     message_type_      IN     VARCHAR2     )
IS 
   order_rec_            Customer_Order_API.Public_Rec;
BEGIN    
   order_rec_ := Customer_Order_API.Get(order_no_);
   IF (order_rec_.rowstate = 'Cancelled') THEN
       header_status_ := 'Not accepted';
   ELSIF (row_changed_ OR row_added_) THEN
      header_status_:= 'Changed';
   ELSE
      header_status_ := 'Accepted without amendment';
   END IF;
   
   sequence_no_ := order_rec_.msg_sequence_no;
   IF (sequence_no_ IS NULL) THEN
      -- This is the first time the order confirmation is being sent. 
      -- Obtain a new sequence_no and set the version_no to 0.
         sequence_no_ := Customer_Info_Msg_Setup_API.Increase_Sequence_No(customer_no_, media_code_, message_type_);   
         version_no_ := 0; 
   ELSE
      -- The invoice is being resent
      -- Reuse the existing sequence_no and increment the version.
         version_no_ := order_rec_.msg_version_no + 1; 
   END IF;    
     
END Set_Order_Conf_Header_Status___;  

-- Post_Send_Order_Conf___
-- this method is used for the tasks
-- done after sending the customer order confirmation.
PROCEDURE Post_Send_Order_Conf___(
   order_no_         IN VARCHAR2,
   sequence_no_      IN NUMBER,  
   version_no_       IN NUMBER,
   order_conf_       IN VARCHAR2,
   order_conf_flag_  IN VARCHAR2,
   media_code_       IN VARCHAR2)
IS
BEGIN
   Customer_Order_API.Set_Msg_Sequence_And_Version (order_no_, sequence_no_ , version_no_);

   IF ((order_conf_ = 'N') AND (order_conf_flag_ = 'Y')) THEN
      -- Set the report confirmation printed flag in the order header
      Customer_Order_API.Set_Order_Conf__(order_no_);
   END IF;

   -- Add a new entry to Customer Order History
   Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'ORDERCONFSENT: Order confirmation sent via :P1', NULL, media_code_));
END Post_Send_Order_Conf___;

-- Get_Order_Conf_Line_Rec___
-- This method is used to set the attributes related to the 
-- customer order line, in the ITS message SendCustomerOrderResponse.
PROCEDURE Get_Order_Conf_Line_Rec___ (   
   price_uom_                    IN OUT VARCHAR2, 
   customer_conv_factor_         IN OUT NUMBER,
   inv_conv_factor_              IN OUT NUMBER,
   planned_rental_start_date_    IN OUT VARCHAR2,
   planned_rental_end_date_      IN OUT VARCHAR2,
   line_note_                    IN OUT VARCHAR2,
   gtin_no_                      IN OUT VARCHAR2,
   customer_no_                  IN VARCHAR2,
   contract_                     IN VARCHAR2, 
   rental_                       IN VARCHAR2,
   customer_part_no_             IN VARCHAR2,
   catalog_no_                   IN VARCHAR2,
   input_unit_meas_              IN VARCHAR2,
   note_id_                      IN VARCHAR2,
   order_no_                     IN VARCHAR2,
   line_no_                      IN VARCHAR2,
   rel_no_                       IN VARCHAR2,
   line_item_no_                 IN NUMBER  )
IS      
   sales_part_cross_ref_rec_      Sales_Part_Cross_Reference_API.Public_Rec;
   $IF Component_Rental_SYS.INSTALLED $THEN
      rental_rec_            RENTAL_OBJECT_API.Public_Rec;         
   $END
   
BEGIN 
   price_uom_ := Sales_Part_API.Get_Price_Unit_Meas(contract_, catalog_no_);         
   
   sales_part_cross_ref_rec_ := Sales_Part_Cross_Reference_API.Get(customer_no_, contract_, customer_part_no_);
   customer_conv_factor_ := sales_part_cross_ref_rec_.conv_factor;
   inv_conv_factor_ := sales_part_cross_ref_rec_.inverted_conv_factor;   
               
   line_note_ := substr(Document_Text_API.Get_All_Notes(note_id_, '1'), 1, 2000);
   gtin_no_ := Sales_Part_API.Get_Gtin_No(contract_, catalog_no_, input_unit_meas_);

   IF (rental_ = 'TRUE' ) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         rental_rec_  := Rental_Object_API.Get_Rental_Rec(order_no_, 
                                                          line_no_, 
                                                          rel_no_, 
                                                          line_item_no_,
                                                          Rental_Type_API.DB_CUSTOMER_ORDER);

         planned_rental_start_date_ := rental_rec_.planned_rental_start_date;
         planned_rental_end_date_ := rental_rec_.planned_rental_end_date;
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');         
      $END
   END IF;  
             
END Get_Order_Conf_Line_Rec___;

 
-- Set_Order_Conf_Struct_Rec___
-- This method is used to create the message header
-- which is sent in send order confirmation ITS message.
-- If a change is done inside this method please visit Send_Order_Conf_Mhs_Edi___
-- to check if the relevant correction is required for EDI/MHS flow.
PROCEDURE Set_Order_Conf_Struct_Rec___(
    return_rec_      OUT Customer_Order_Struct_Rec,
    order_conf_      OUT VARCHAR2, 
    order_conf_flag_ OUT VARCHAR2, 
    order_no_        IN  VARCHAR2,
    media_code_      IN  VARCHAR2 ) 
IS   
   row_changed_            BOOLEAN := FALSE;
   row_added_              BOOLEAN := FALSE;
   address_rec_            Customer_Order_Address_API.Cust_Ord_Addr_Rec; 
   cross_ref_rec_          Cust_Addr_Cross_reference_API.Public_Rec;
   ship_addr_no_         VARCHAR2(50);
   internal_po_no_       VARCHAR2(12);
   org_message_id_       NUMBER;
BEGIN
   return_rec_.message_type := 'ORDRSP';
   return_rec_.media_code := media_code_;
   return_rec_.order_no := order_no_;
   
   Get_Order_Confirmation_Header___(org_message_id_, cross_ref_rec_, address_rec_, return_rec_.sales_person_name, return_rec_.coordinator_name, return_rec_.company, return_rec_.payment_terms_description,  
          return_rec_.customer_po_no, return_rec_.wanted_delivery_date, return_rec_.del_terms_location, order_conf_, order_conf_flag_, return_rec_.delivery_leadtime, 
          return_rec_.currency_code, return_rec_.cust_ref, return_rec_.date_entered, return_rec_.external_co_label_note, return_rec_.tax_id, return_rec_.delivery_terms_description,
          return_rec_.ship_via_description, return_rec_.company_association_no, return_rec_.customer_association_no , return_rec_.company_name, return_rec_.supplier_id,
          return_rec_.header_note, return_rec_.agreement_header_note, return_rec_.customer_note, return_rec_.ean_location_doc_addr, return_rec_.ean_location_del_addr, return_rec_.ean_location_doc_addr_for_payer,
          return_rec_.salesman_code, return_rec_.authorize_code, return_rec_.contract, return_rec_.pay_term_id, return_rec_.customer_no, internal_po_no_, return_rec_.language_code, return_rec_.delivery_terms, return_rec_.ship_via_code,
          return_rec_.note_id, return_rec_.agreement_id, return_rec_.bill_addr_no, ship_addr_no_, return_rec_.customer_no_pay, return_rec_.customer_no_pay_addr_no, return_rec_.forward_agent_id, order_no_);

   return_rec_.cust_ord_lines := Customer_Order_Struct_Customer_Order_Line_Arr();
   Set_Order_Conf_Line_Struct_Arr___(row_changed_, row_added_, return_rec_.cust_ord_lines, order_no_,
                                                internal_po_no_, return_rec_.customer_po_no, return_rec_.company, 
                                                return_rec_.currency_code, return_rec_.contract, org_message_id_);

   
   Set_Order_Conf_Header_Status___( return_rec_.header_status, return_rec_.sequence_no,
      return_rec_.version_no,  order_no_, return_rec_.customer_no, row_changed_, row_added_, 'INET_TRANS', return_rec_.message_type  );

   return_rec_.receiver_name := address_rec_.addr_1;
   return_rec_.address1 := address_rec_.address1;
   return_rec_.address2 := address_rec_.address2;
   return_rec_.zip_code := address_rec_.zip_code;
   return_rec_.city := address_rec_.city;
   return_rec_.state := address_rec_.state;
   return_rec_.county := address_rec_.county;
   return_rec_.country_code := address_rec_.country_code;
   return_rec_.address3 := address_rec_.address3;
   return_rec_.address4 := address_rec_.address4;
   return_rec_.address5 := address_rec_.address5;
   return_rec_.address6 := address_rec_.address6;  
   
   Get_Order_Conf_Comm_Methods___(return_rec_.fax_no, return_rec_.phone_no, return_rec_.email_id, return_rec_.postal_address,
                   return_rec_.company_country, return_rec_.company, return_rec_.contract, return_rec_.language_code);  
   
   return_rec_.cross_reference_info1 := cross_ref_rec_.cross_reference_info_1;
   return_rec_.cross_reference_info2 := cross_ref_rec_.cross_reference_info_2;
   return_rec_.cross_reference_info3 := cross_ref_rec_.cross_reference_info_3;
   return_rec_.cross_reference_info4 := cross_ref_rec_.cross_reference_info_4;
   return_rec_.cross_reference_info5 := cross_ref_rec_.cross_reference_info_5;
   
END Set_Order_Conf_Struct_Rec___;

-- Get_Order_Confirmation_Header___
-- This is a common method used in both EDI and ITS flows 
-- to fetch the order confirmation header data.
PROCEDURE Get_Order_Confirmation_Header___ ( 
   org_message_id_            OUT NUMBER,
   cross_ref_rec_             OUT Cust_Addr_Cross_reference_API.Public_Rec,
   address_rec_               OUT Customer_Order_Address_API.Cust_Ord_Addr_Rec,
   sales_person_name_         OUT VARCHAR2,
   coordinator_name_          OUT VARCHAR2,
   company_                   OUT VARCHAR2,
   payment_terms_description_ OUT VARCHAR2,    
   customer_po_no_            OUT VARCHAR2,
   wanted_delivery_date_      OUT DATE,
   del_terms_location_        OUT VARCHAR2,
   order_conf_                OUT VARCHAR2,
   order_conf_flag_           OUT VARCHAR2,
   delivery_leadtime_         OUT VARCHAR2,
   currency_code_             OUT VARCHAR2, 
   cust_ref_                  OUT VARCHAR2,
   date_entered_              OUT DATE,
   external_co_label_note_    OUT VARCHAR2,
   tax_id_                    OUT VARCHAR2,
   delivery_terms_desc_       OUT VARCHAR2,
   ship_via_desc_             OUT VARCHAR2, 
   company_association_no_    OUT VARCHAR2,
   customer_association_no_   OUT VARCHAR2,
   company_name_              OUT VARCHAR2,
   supplier_id_               OUT VARCHAR2,
   header_note_               OUT VARCHAR2,
   agreement_note_            OUT VARCHAR2, 
   customer_note_             OUT VARCHAR2,
   ean_location_doc_addr_     OUT VARCHAR2,
   ean_location_del_addr_     OUT VARCHAR2,
   ean_location_doc_addr_for_payer_   OUT VARCHAR2,
   salesman_code_             OUT  VARCHAR2,
   authorize_code_            OUT  VARCHAR2,
   contract_                  OUT  VARCHAR2,
   pay_term_id_               OUT  VARCHAR2,
   customer_no_               OUT  VARCHAR2,
   internal_po_no_            OUT  VARCHAR2,   
   language_code_             OUT  VARCHAR2,
   delivery_terms_            OUT  VARCHAR2,
   ship_via_code_             OUT  VARCHAR2,
   note_id_                   OUT   VARCHAR2,
   agreement_id_              OUT  VARCHAR2,
   bill_addr_no_              OUT  VARCHAR2, 
   ship_addr_no_              OUT  VARCHAR2,
   customer_no_pay_           OUT  VARCHAR2,
   customer_no_pay_addr_no_   OUT  VARCHAR2,
   forward_agent_id_          OUT  VARCHAR2,
   order_no_                  IN  VARCHAR2 )
IS
   CURSOR get_order_info IS
      SELECT order_no, customer_no, contract, internal_po_no, customer_po_no,
             salesman_code, authorize_code, date_entered, bill_addr_no,
             currency_code, customer_no_pay, customer_no_pay_addr_no, cust_ref,
             pay_term_id, delivery_terms, del_terms_location, wanted_delivery_date,
             delivery_leadtime, ship_via_code, forward_agent_id, NVL(internal_po_label_note, label_note) label_note,
             language_code, note_id, agreement_id, order_conf, order_conf_flag,
             rowstate, ship_addr_no
      FROM customer_order_tab
      WHERE order_no = order_no_;
   attribute_rec_  get_order_info%ROWTYPE;
  
   CURSOR get_message_id(order_no_ VARCHAR2) IS
         SELECT message_id
         FROM external_customer_order_tab
         WHERE order_no = order_no_
         AND   rowstate = 'Created';
BEGIN
   OPEN get_message_id(order_no_);
   FETCH get_message_id INTO org_message_id_;
   IF (get_message_id%NOTFOUND) THEN
      org_message_id_ := NULL;
   END IF;
   CLOSE get_message_id;
      
   OPEN get_order_info;
   FETCH get_order_info INTO attribute_rec_;          
   delivery_terms_ := attribute_rec_.delivery_terms;
   language_code_ := attribute_rec_.language_code;
   note_id_ := attribute_rec_.note_id;
   pay_term_id_ := attribute_rec_.pay_term_id;
   customer_po_no_ := attribute_rec_.customer_po_no;
   wanted_delivery_date_ := attribute_rec_.wanted_delivery_date;
   internal_po_no_ := attribute_rec_.internal_po_no;
   agreement_id_ := attribute_rec_.agreement_id;
   del_terms_location_ := attribute_rec_.del_terms_location;   
   customer_no_ := attribute_rec_.customer_no;
   order_conf_ := attribute_rec_.order_conf;
   order_conf_flag_ := attribute_rec_.order_conf_flag;
   authorize_code_ := attribute_rec_.authorize_code;
   customer_no_pay_ := attribute_rec_.customer_no_pay;
   contract_ := attribute_rec_.contract;
   customer_no_pay_addr_no_ := attribute_rec_.customer_no_pay_addr_no;
   salesman_code_ := attribute_rec_.salesman_code;
   ship_addr_no_ := attribute_rec_.ship_addr_no;
   ship_via_code_ := attribute_rec_.ship_via_code;
   delivery_leadtime_ := attribute_rec_.delivery_leadtime;
   forward_agent_id_ := attribute_rec_.forward_agent_id;
   bill_addr_no_ := attribute_rec_.bill_addr_no;
   currency_code_ := attribute_rec_.currency_code;
   cust_ref_ := attribute_rec_.cust_ref; 
   date_entered_ := attribute_rec_.date_entered; 
   external_co_label_note_ := attribute_rec_.label_note; 
   CLOSE get_order_info;
   sales_person_name_    := Sales_Part_Salesman_API.Get_Name(salesman_code_);
   coordinator_name_   := Order_Coordinator_API.Get_Name(authorize_code_);
   company_         := Site_API.Get_Company(contract_);
   payment_terms_description_    := Payment_Term_API.Get_Description(company_, pay_term_id_ );  
   
   IF (internal_po_no_ IS NOT NULL) THEN
      customer_po_no_ := internal_po_no_;
   END IF;
   
   address_rec_ := Customer_Order_Address_API.Get_Cust_Ord_Addr(order_no_); 
   
   tax_id_ := Customer_Document_Tax_Info_API.Default_Vat_No(customer_no_, company_, Company_API.Get_Country_Db(company_), Customer_Info_Address_API.Get_Delivery_Country_Db(customer_no_), SYSDATE);
   delivery_terms_desc_ := Order_Delivery_Term_API.Get_Description(delivery_terms_, language_code_);
   ship_via_desc_   := Mpccom_Ship_Via_API.Get_Description(ship_via_code_, language_code_);
   company_association_no_ := Company_API.Get_Association_No(company_);
   customer_association_no_  := Customer_Info_API.Get_Association_No(customer_no_);
   company_name_ := substr(Company_API.Get_Name(company_), 1, 35);
   supplier_id_  := Customer_Order_Transfer_API.Get_Supplier_Id(company_, contract_, customer_no_, NULL);
   header_note_ := substr(Document_Text_API.Get_All_Notes(note_id_, '1'), 1, 2000);
   agreement_note_ := substr(Document_Text_API.Get_All_Notes(Customer_Agreement_API.Get_Note_Id(agreement_id_), '1'), 1, 2000);  
   customer_note_ := substr(Document_Text_API.Get_All_Notes(Cust_Ord_Customer_API.Get_Note_Id(customer_no_), '1'), 1, 2000);
    IF bill_addr_no_ IS NOT NULL  THEN
      ean_location_doc_addr_ := Customer_Info_Address_API.Get_Ean_Location(customer_no_, bill_addr_no_);      
   END IF;
   IF (ship_addr_no_ IS NOT NULL) THEN
      ean_location_del_addr_ := Customer_Info_Address_API.Get_Ean_Location(customer_no_, ship_addr_no_);
   END IF;
   IF ((customer_no_pay_ IS NOT NULL) AND (customer_no_pay_addr_no_ IS NOT NULL)) THEN
      ean_location_doc_addr_for_payer_ := Customer_Info_Address_API.Get_Ean_Location(customer_no_pay_, customer_no_pay_addr_no_);         
   END IF;
   
   cross_ref_rec_ := Cust_Addr_Cross_Reference_API.Get(customer_no_, ship_addr_no_);
   
END Get_Order_Confirmation_Header___;

-- Set_Order_Conf_Line_Struct_Arr___
-- This method is used to create the message line array
-- which is sent in send order confirmation ITS message.
-- If a change is done inside this method please visit Send_Order_Conf_Mhs_Edi___
-- to check if the relevant correction is required for EDI/MHS flow.
PROCEDURE Set_Order_Conf_Line_Struct_Arr___ (   
   row_changed_      OUT BOOLEAN,
   row_added_        OUT BOOLEAN,
   return_arr_       IN  OUT Customer_Order_Struct_Customer_Order_Line_Arr,
   order_no_         IN VARCHAR2,
   internal_po_no_   IN VARCHAR2,
   customer_po_no_   IN VARCHAR2,
   company_          IN VARCHAR2,
   currency_code_    IN VARCHAR2,
   contract_         IN VARCHAR2,
   org_message_id_   IN NUMBER )
IS
   CURSOR get_attributes IS
      SELECT order_no, line_no, rel_no, catalog_no, catalog_desc, buy_qty_due, revised_qty_due,
                sales_unit_meas, sale_unit_price, unit_price_incl_tax, base_sale_unit_price, base_unit_price_incl_tax,
                customer_no, price_conv_factor, currency_rate, discount, planned_delivery_date, wanted_delivery_date,
                note_id, customer_part_no, customer_part_buy_qty, customer_part_unit_meas,
                order_discount, rowstate,line_item_no,additional_discount, 
                classification_standard, classification_part_no, classification_unit_meas,
                input_unit_meas, input_qty, rental, delivery_leadtime, demand_code, ship_via_code, forward_agent_id,
                picking_leadtime, route_id, packing_instruction_id, ext_transport_calendar_id, delivery_terms, del_terms_location
         FROM customer_order_line_tab col
         WHERE order_no = order_no_
         AND    line_item_no <= 0
         AND NOT EXISTS (SELECT message_id
                     FROM ext_cust_order_line_change_tab
                     WHERE ord_chg_state = 'DELETED'
                     AND rel_no = col.rel_no
                     AND line_no = col.line_no
                     AND message_id IN (SELECT message_id
                                        FROM ext_cust_order_change_tab
                                        WHERE order_no = order_no_))
         ORDER BY order_no, to_number(line_no), to_number(rel_no); 
   
   -- Checked the rowstate to exclude Cancelled records from ext_cust_order_line_change_tab.
   -- this cursor fetches all lines removed from CustomerOrderLine for a specific order
   CURSOR get_external_info(message_id_ NUMBER, item_no_ NUMBER, line_no_ NUMBER, rel_no_ NUMBER) IS 
      SELECT line_no, rel_no, catalog_no, buy_qty_due, wanted_delivery_date, customer_part_no,
                customer_quantity, classification_standard, classification_part_no, classification_unit_meas, 
                gtin_no, input_qty, ship_via_code, forward_agent_id, picking_leadtime,
                route_id, packing_instruction_id, ext_transport_calendar_id, delivery_terms, del_terms_location
         FROM external_cust_order_line_tab eol
         WHERE eol.message_id = message_id_
         AND NOT EXISTS (SELECT 1
                         FROM customer_order_line_tab col
                         WHERE col.order_no = order_no_
                         AND col.line_no = eol.line_no
                         AND col.rel_no = eol.rel_no
                         AND col.line_item_no = item_no_)
         AND eol.rowstate = 'Created'
         AND eol.line_no = line_no_
         AND eol.rel_no  = rel_no_
         UNION ALL
         SELECT line_no, rel_no, catalog_no, buy_qty_due, wanted_delivery_date,
                customer_part_no, customer_quantity, classification_standard, classification_part_no, classification_unit_meas, 
                gtin_no, input_qty, ship_via_code, forward_agent_id, picking_leadtime,
                route_id, packing_instruction_id, ext_transport_calendar_id, delivery_terms, del_terms_location
         FROM ext_cust_order_line_change_tab eolc
         WHERE eolc.message_id IN (SELECT message_id
                                   FROM ext_cust_order_change_tab
                                   WHERE order_no = order_no_
                                   AND rowstate != 'Stopped')
         AND eolc.ord_chg_state = 'ADDED'
         AND eolc.rowstate     != 'Cancelled'
         AND NOT EXISTS (SELECT 1
                         FROM customer_order_line_tab col
                         WHERE col.order_no = order_no_
                         AND col.line_no = eolc.line_no
                         AND col.rel_no = eolc.rel_no
                         AND col.line_item_no = item_no_);
   
   
   rental_         VARCHAR2(5);
   demand_code_    VARCHAR2(20);   
BEGIN   
      
   FOR attribute_rec_ IN get_attributes LOOP
      return_arr_.extend;
      return_arr_(return_arr_.last).order_no := attribute_rec_.order_no;
      return_arr_(return_arr_.last).line_no := attribute_rec_.line_no;
      return_arr_(return_arr_.last).rel_no := attribute_rec_.rel_no;   
      return_arr_(return_arr_.last).line_item_no := attribute_rec_.line_item_no; 
      return_arr_(return_arr_.last).contract := contract_;
      return_arr_(return_arr_.last).note_id := attribute_rec_.note_id;      
      return_arr_(return_arr_.last).currency_rate := attribute_rec_.currency_rate;
      return_arr_(return_arr_.last).discount := attribute_rec_.discount;
      return_arr_(return_arr_.last).price_conv_factor := attribute_rec_.price_conv_factor;
      return_arr_(return_arr_.last).customer_part_no := attribute_rec_.customer_part_no;
      return_arr_(return_arr_.last).route_id := attribute_rec_.route_id;
      return_arr_(return_arr_.last).delivery_terms := attribute_rec_.delivery_terms;
      return_arr_(return_arr_.last).delivery_leadtime := attribute_rec_.delivery_leadtime;
      return_arr_(return_arr_.last).additional_discount := attribute_rec_.additional_discount;
      return_arr_(return_arr_.last).input_qty := attribute_rec_.input_qty;
      return_arr_(return_arr_.last).del_terms_location := attribute_rec_.del_terms_location;
      return_arr_(return_arr_.last).classification_part_no := attribute_rec_.classification_part_no;
      return_arr_(return_arr_.last).classification_unit_meas := attribute_rec_.classification_unit_meas;
      return_arr_(return_arr_.last).classification_standard := attribute_rec_.classification_standard;
      rental_ := attribute_rec_.rental;
      return_arr_(return_arr_.last).picking_leadtime := attribute_rec_.picking_leadtime;
      return_arr_(return_arr_.last).packing_instruction_id := attribute_rec_.packing_instruction_id;      
      return_arr_(return_arr_.last).catalog_no := attribute_rec_.catalog_no;
      return_arr_(return_arr_.last).sales_unit_meas := attribute_rec_.sales_unit_meas;
      return_arr_(return_arr_.last).planned_delivery_date := attribute_rec_.planned_delivery_date;
      return_arr_(return_arr_.last).wanted_delivery_date := attribute_rec_.wanted_delivery_date;
      return_arr_(return_arr_.last).customer_part_unit_meas := attribute_rec_.customer_part_unit_meas;
      return_arr_(return_arr_.last).customer_part_buy_qty := attribute_rec_.customer_part_buy_qty;
      return_arr_(return_arr_.last).forward_agent_id := attribute_rec_.forward_agent_id;
      return_arr_(return_arr_.last).ship_via_code := attribute_rec_.ship_via_code;
      return_arr_(return_arr_.last).ext_transport_calendar_id := attribute_rec_.ext_transport_calendar_id;
      return_arr_(return_arr_.last).catalog_desc := attribute_rec_.catalog_desc;      
      return_arr_(return_arr_.last).buy_qty_due := attribute_rec_.buy_qty_due;      
      return_arr_(return_arr_.last).sale_unit_price := attribute_rec_.sale_unit_price;
      return_arr_(return_arr_.last).unit_price_incl_tax := attribute_rec_.unit_price_incl_tax;
      return_arr_(return_arr_.last).base_sale_unit_price := attribute_rec_.base_sale_unit_price;
      return_arr_(return_arr_.last).base_unit_price_incl_tax := attribute_rec_.base_unit_price_incl_tax;      
      return_arr_(return_arr_.last).order_discount := attribute_rec_.order_discount;
      return_arr_(return_arr_.last).input_unit_meas := attribute_rec_.input_unit_meas;
      
      Get_Order_Conf_Line_Rec___(return_arr_(return_arr_.last).price_uom, return_arr_(return_arr_.last).customer_conv_factor, return_arr_(return_arr_.last).customer_inv_conv_factor,
         return_arr_(return_arr_.last).planned_rental_start_date, return_arr_(return_arr_.last).planned_rental_end_date, return_arr_(return_arr_.last).line_note, return_arr_(return_arr_.last).gtin_no,
         attribute_rec_.customer_no, contract_, rental_, attribute_rec_.customer_part_no, attribute_rec_.catalog_no, attribute_rec_.input_unit_meas, attribute_rec_.note_id,
         order_no_, attribute_rec_.line_no, attribute_rec_.rel_no, attribute_rec_.line_item_no);
                                    
      return_arr_(return_arr_.last).customer_po_no := customer_po_no_;
      return_arr_(return_arr_.last).line_currency := currency_code_;

      Get_Message_Line_Status___(row_changed_, row_added_, return_arr_(return_arr_.last).status, return_arr_(return_arr_.last).org_rental_start_date, return_arr_(return_arr_.last).org_rental_end_date,
                     return_arr_(return_arr_.last).original_sales_qty, return_arr_(return_arr_.last).wanted_delivery_date, org_message_id_, attribute_rec_.order_no, attribute_rec_.line_no, 
                     attribute_rec_.rel_no, attribute_rec_.line_item_no, Customer_Order_Line_API.Get_Objstate(order_no_, attribute_rec_.line_no, attribute_rec_.rel_no, attribute_rec_.line_item_no), 
                     internal_po_no_, return_arr_(return_arr_.last).customer_part_buy_qty, attribute_rec_.buy_qty_due, attribute_rec_.ship_via_code,
                     attribute_rec_.delivery_terms, attribute_rec_.del_terms_location, attribute_rec_.forward_agent_id, attribute_rec_.ext_transport_calendar_id, attribute_rec_.packing_instruction_id, 
                     attribute_rec_.route_id, attribute_rec_.picking_leadtime, attribute_rec_.delivery_leadtime, attribute_rec_.planned_delivery_date,
                     attribute_rec_.sale_unit_price, rental_);
                     
      Get_Line_Amounts_and_Discounts___(return_arr_(return_arr_.last).net_amount_curr, return_arr_(return_arr_.last).gross_amount_curr, return_arr_(return_arr_.last).total_order_line_discount, return_arr_(return_arr_.last).discount_amount, 
                        company_, currency_code_, attribute_rec_.order_no, attribute_rec_.line_no, attribute_rec_.rel_no, attribute_rec_.line_item_no,
                        attribute_rec_.buy_qty_due, attribute_rec_.price_conv_factor,  attribute_rec_.unit_price_incl_tax, 
                        attribute_rec_.sale_unit_price, attribute_rec_.additional_discount, attribute_rec_.order_discount);
      
      demand_code_ := attribute_rec_.demand_code;
      IF ((demand_code_ NOT IN ('IPD', 'IPT')) OR demand_code_ IS NULL) THEN
         return_arr_(return_arr_.last).delivery_terms := NULL;
         return_arr_(return_arr_.last).del_terms_location := NULL;               
      END IF;             

      IF ((demand_code_ != 'IPD') OR (demand_code_ IS NULL)) THEN
         return_arr_(return_arr_.last).delivery_leadtime := NULL;
         return_arr_(return_arr_.last).picking_leadtime := NULL;
         return_arr_(return_arr_.last).route_id := NULL;
         return_arr_(return_arr_.last).packing_instruction_id := NULL;               
      END IF;           

      IF ((demand_code_ IS NOT NULL) AND (demand_code_ != 'IPD')) THEN
         return_arr_(return_arr_.last).ext_transport_calendar_id := NULL;
      END IF;

      IF ((demand_code_ IS NOT NULL) AND (demand_code_ NOT IN ('PD', 'IPD', 'IPT') )) THEN
         return_arr_(return_arr_.last).ship_via_code := NULL;
         return_arr_(return_arr_.last).forward_agent_id := NULL;
      END IF; 
   
      IF ((attribute_rec_.line_item_no = 0) OR (attribute_rec_.line_item_no = -1)) THEN
         FOR ext_rec_ IN get_external_info(org_message_id_, attribute_rec_.line_item_no, attribute_rec_.line_no, attribute_rec_.rel_no) LOOP
            return_arr_.extend; 
            return_arr_(return_arr_.last).order_no :=  order_no_;
            return_arr_(return_arr_.last).customer_po_no := customer_po_no_;
            return_arr_(return_arr_.last).line_no := ext_rec_.line_no;
            return_arr_(return_arr_.last).rel_no := ext_rec_.rel_no;
            return_arr_(return_arr_.last).catalog_no := ext_rec_.catalog_no;
            return_arr_(return_arr_.last).line_currency :=  currency_code_;
            return_arr_(return_arr_.last).customer_part_no := ext_rec_.customer_part_no;
            return_arr_(return_arr_.last).status := 'Not accepted';            
            return_arr_(return_arr_.last).classification_part_no :=  attribute_rec_.classification_part_no;
            return_arr_(return_arr_.last).classification_unit_meas := attribute_rec_.classification_unit_meas;
            return_arr_(return_arr_.last).classification_standard :=  attribute_rec_.classification_standard;
            return_arr_(return_arr_.last).gtin_no := ext_rec_.gtin_no;
            return_arr_(return_arr_.last).wanted_delivery_date := ext_rec_.wanted_delivery_date;            
            return_arr_(return_arr_.last).buy_qty_due := ext_rec_.buy_qty_due;
            return_arr_(return_arr_.last).original_sales_qty :=  ext_rec_.buy_qty_due;            
            return_arr_(return_arr_.last).customer_part_buy_qty := ext_rec_.customer_quantity;            
            return_arr_(return_arr_.last).input_qty := ext_rec_.input_qty;
            return_arr_(return_arr_.last).ship_via_code := ext_rec_.ship_via_code;
            return_arr_(return_arr_.last).forward_agent_id := ext_rec_.forward_agent_id;
            return_arr_(return_arr_.last).picking_leadtime := ext_rec_.picking_leadtime;
            return_arr_(return_arr_.last).route_id := ext_rec_.route_id;
            return_arr_(return_arr_.last).packing_instruction_id := ext_rec_.packing_instruction_id;
            return_arr_(return_arr_.last).ext_transport_calendar_id := ext_rec_.ext_transport_calendar_id;            
            return_arr_(return_arr_.last).delivery_terms := ext_rec_.delivery_terms;
            return_arr_(return_arr_.last).del_terms_location := ext_rec_.del_terms_location;            
         END LOOP;
      END IF;
      Customer_Order_Line_Hist_API.New(order_no_, attribute_rec_.line_no, attribute_rec_.rel_no, attribute_rec_.line_item_no, Language_SYS.Translate_Constant(lu_name_, 'ORDERCONFSENT: Order confirmation sent via :P1', NULL, 'INET_TRANS'));         
   END LOOP;   
END Set_Order_Conf_Line_Struct_Arr___;

  
-- Get_Line_Amounts_and_Discounts___
-- This method is used to calculate the discount amounts
-- used in sending the order confirmation.   
PROCEDURE  Get_Line_Amounts_And_Discounts___ (
   net_amount_curr_     IN OUT NUMBER,
   gross_amount_curr_   IN OUT NUMBER,
   total_order_line_discount_ IN OUT NUMBER,
   discount_amount_     IN OUT NUMBER,
   company_             IN VARCHAR2,
   currency_code_       IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   buy_qty_due_         IN NUMBER,
   price_conv_factor_   IN NUMBER,
   unit_price_incl_tax_ IN NUMBER,
   sale_unit_price_     IN NUMBER,
   line_additional_discount_ IN NUMBER,
   line_order_discount_ IN NUMBER ) 
IS
   currency_rounding_   NUMBER;      
   sales_price_         NUMBER;
   additional_disc_amount_ NUMBER;
   group_disc_amount_      NUMBER;
BEGIN
   net_amount_curr_ := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, line_no_, rel_no_, line_item_no_);
   gross_amount_curr_ := Customer_Order_Line_API.Get_Sale_Price_Incl_Tax_Total(order_no_, line_no_, rel_no_, line_item_no_);
   total_order_line_discount_ := Customer_Order_Line_API.Get_Total_Discount_Percentage(order_no_, line_no_, rel_no_, line_item_no_);

   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   discount_amount_     := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_, line_no_, rel_no_, line_item_no_,
                                                                                   buy_qty_due_, price_conv_factor_,  currency_rounding_);
   IF (Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_) = 'TRUE') THEN
      sales_price_ := buy_qty_due_ * price_conv_factor_ * unit_price_incl_tax_;
   ELSE
      sales_price_ := buy_qty_due_ * price_conv_factor_ * sale_unit_price_;
   END IF;                                                                          
   additional_disc_amount_ := ROUND((sales_price_ - discount_amount_) * line_additional_discount_/100, currency_rounding_);
   group_disc_amount_      := ROUND((sales_price_ - discount_amount_) * line_order_discount_/100, currency_rounding_);
   discount_amount_        := discount_amount_ + additional_disc_amount_ + group_disc_amount_;
  
END Get_Line_Amounts_And_Discounts___;


-- Get_Message_Line_Status___
-- This method is used to get the status of the 
-- order confirmation message line. This method is common
-- for EDI and INET_TRANS.
PROCEDURE Get_Message_Line_Status___ (
row_changed_               IN OUT BOOLEAN,
row_added_                 IN OUT BOOLEAN,
status_                    IN OUT VARCHAR2,
org_rental_start_date_     IN OUT DATE,
org_rental_end_date_       IN OUT DATE,
ext_buy_qty_due_           IN OUT NUMBER,
ext_wanted_del_date_       IN OUT DATE,
org_message_id_            IN NUMBER,
order_no_                  IN VARCHAR2,
line_no_                   IN VARCHAR2,
rel_no_                    IN VARCHAR2,
line_item_no_              IN NUMBER,
rowstate_                  IN VARCHAR2,
internal_po_no_            IN VARCHAR2,
customer_part_buy_qty_     IN NUMBER,
buy_qty_due_               IN NUMBER,
ship_via_code_             IN VARCHAR2,
delivery_terms_            IN VARCHAR2,
del_terms_location_        IN VARCHAR2,
forward_agent_id_          IN VARCHAR2,
ext_transport_calendar_id_ IN VARCHAR2,
packing_instruction_id_    IN VARCHAR2, 
route_id_                  IN VARCHAR2,
picking_leadtime_          IN NUMBER,
delivery_leadtime_         IN NUMBER,
planned_delivery_date_     IN DATE,
sale_unit_price_           IN NUMBER,
rental_                    IN VARCHAR2 )
IS
   CURSOR get_external_line(message_id_ NUMBER, line_no_ VARCHAR2, rel_no_ VARCHAR2) IS
      SELECT message_id, message_line, 'ORDERS' message_type, buy_qty_due, wanted_delivery_date, original_buy_qty_due,
             original_plan_deliv_date, sale_unit_price, ship_via_code, forward_agent_id, ext_transport_calendar_id,
             packing_instruction_id, route_id, picking_leadtime, delivery_leadtime, delivery_terms, del_terms_location
      FROM external_cust_order_line_tab
      WHERE message_id = message_id_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   rowstate = 'Created'
      UNION ALL
      SELECT message_id, message_line, 'ORDCHG' message_type, buy_qty_due, wanted_delivery_date, original_buy_qty_due,
             original_plan_deliv_date, sale_unit_price, ship_via_code, forward_agent_id, ext_transport_calendar_id,
             packing_instruction_id, route_id, picking_leadtime, delivery_leadtime, delivery_terms, del_terms_location
      FROM ext_cust_order_line_change_tab
      WHERE message_id IN (SELECT message_id
                           FROM ext_cust_order_change_tab
                           WHERE order_no = order_no_
                           AND rowstate != 'Stopped')
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   ord_chg_state = 'ADDED';
   extrec_  get_external_line%ROWTYPE;

   CURSOR get_external_line_change(line_no_ VARCHAR2, rel_no_ VARCHAR2) IS
      SELECT message_id, message_line, buy_qty_due, wanted_delivery_date, original_buy_qty_due, original_plan_deliv_date, sale_unit_price,
             ship_via_code, forward_agent_id, ext_transport_calendar_id, picking_leadtime, route_id, packing_instruction_id, delivery_leadtime,
             delivery_terms, del_terms_location
         FROM ext_cust_order_line_change_tab
         WHERE message_id IN (SELECT message_id
                              FROM ext_cust_order_change_tab
                              WHERE order_no = order_no_
                              AND rowstate != 'Stopped')
         AND   line_no = line_no_
         AND   rel_no = rel_no_
         AND   ord_chg_state IN ('CHANGED', 'NOT AMENDED')
      ORDER BY message_id DESC;

   extchgrec_  get_external_line_change%ROWTYPE;
   chg_req_exists_         VARCHAR2(5) := 'FALSE';
   $IF Component_Rental_SYS.INSTALLED $THEN
      rental_rec_            RENTAL_OBJECT_API.Public_Rec;
      ext_message_rec_       External_Pur_Order_Message_API.Public_Rec;
   $END     

BEGIN  
   status_ := 'Accepted without amendment';
   OPEN get_external_line(org_message_id_, line_no_, rel_no_);
   FETCH get_external_line INTO extrec_;
   -- if external record not found - this line has been added
   IF get_external_line%NOTFOUND THEN
      row_added_ := TRUE;
      status_ := 'Added';
   END IF;
   CLOSE get_external_line;

   -- If change request lines exist, the latest message with state changed or not amended is fetched.
   OPEN get_external_line_change(line_no_, rel_no_);
   FETCH get_external_line_change INTO extchgrec_;
   IF get_external_line_change%FOUND THEN
      chg_req_exists_ := 'TRUE';
   ELSE
      chg_req_exists_ := 'FALSE';
   END IF;
   CLOSE get_external_line_change;

   IF (rowstate_ = 'Cancelled') THEN
      status_ := 'Not accepted';
      row_changed_ := TRUE;
      -- When the status_ is Added and there is an Internal Purchase Order added the following to change the
      -- planned_delivery_date,planned_receipt_date or quantity of internal purchase order lines according to the
      -- change of planned_delivery_date or quantity  of customer order lines in Intersite Ordering.
   ELSIF (status_ != 'Added') THEN
      IF (internal_po_no_ IS NOT NULL) THEN
         -- Logic was changed to work both for internal orders and order within different database.
         -- System should check if the value currently stored on the CO line is different from the value passed
         -- in for the line in the last sent ORDCHG message containing the line or in the ORDERS message
         -- if the line is not present on any ORDCHG message and change the status on the line.
      IF chg_req_exists_ = 'FALSE' THEN
         IF ((NVL(customer_part_buy_qty_, buy_qty_due_) != extrec_.original_buy_qty_due) OR
                (Validate_SYS.Is_Changed(extrec_.delivery_terms, delivery_terms_)) OR
                (Validate_SYS.Is_Changed(extrec_.del_terms_location, del_terms_location_)) OR
                (Validate_SYS.Is_Changed(extrec_.ship_via_code, ship_via_code_)) OR 
                ((extrec_.forward_agent_id IS NOT NULL) AND Validate_SYS.Is_Changed(extrec_.forward_agent_id, forward_agent_id_)) OR
                ((extrec_.ext_transport_calendar_id IS NOT NULL) AND Validate_SYS.Is_Changed(extrec_.ext_transport_calendar_id, ext_transport_calendar_id_)) OR
                ((extrec_.packing_instruction_id IS NOT NULL) AND Validate_SYS.Is_Changed(extrec_.packing_instruction_id, packing_instruction_id_)) OR
                ((extrec_.route_id IS NOT NULL) AND Validate_SYS.Is_Changed(extrec_.route_id, route_id_)) OR 
                ((extrec_.picking_leadtime IS NOT NULL) AND Validate_SYS.Is_Changed(extrec_.picking_leadtime, picking_leadtime_)) OR
                ((extrec_.delivery_leadtime IS NOT NULL) AND Validate_SYS.Is_Changed(extrec_.delivery_leadtime, delivery_leadtime_)) OR
                 (TRUNC(planned_delivery_date_) != TRUNC(extrec_.original_plan_deliv_date))) THEN
            row_changed_ := TRUE;
            status_      := 'Changed';
         END IF;

         IF (extrec_.sale_unit_price IS NOT NULL) THEN
            IF (sale_unit_price_ != extrec_.sale_unit_price) THEN
               row_changed_ := TRUE;
               status_ := 'Changed';
            END IF;
         END IF;

         IF (rental_ = Fnd_Boolean_API.DB_TRUE) THEN
            $IF Component_Rental_SYS.INSTALLED $THEN
            rental_rec_  := Rental_Object_API.Get_Rental_Rec(order_no_,
                                                                      line_no_,
                                                                      rel_no_,
                                                                      line_item_no_,
                                                                      Rental_Type_API.DB_CUSTOMER_ORDER);
            ext_message_rec_ := External_Pur_Order_Message_API.Get(extrec_.message_id,
                                                                            extrec_.message_line,
                                                                            extrec_.message_type);
            org_rental_start_date_ := ext_message_rec_.planned_rental_start_date;
            org_rental_end_date_ := ext_message_rec_.planned_rental_end_date;
            IF (rental_rec_.planned_rental_start_date != org_rental_start_date_) THEN
               row_changed_ := TRUE;
               status_ := 'Changed';
            END IF;
            IF (rental_rec_.planned_rental_end_date != org_rental_end_date_) THEN
               row_changed_ := TRUE;
               status_ := 'Changed';
            END IF;
            $ELSE
               Error_SYS.Component_Not_Exist('RENTAL');
            $END
            END IF; 
         ELSE
            IF ((NVL(customer_part_buy_qty_, buy_qty_due_) != extchgrec_.original_buy_qty_due) OR 
                   (Validate_SYS.Is_Changed(extchgrec_.delivery_terms, delivery_terms_)) OR
                   (Validate_SYS.Is_Changed(extchgrec_.del_terms_location, del_terms_location_)) OR
                   (Validate_SYS.Is_Changed(extchgrec_.ship_via_code, ship_via_code_)) OR 
                   ((extchgrec_.forward_agent_id IS NOT NULL) AND Validate_SYS.Is_Changed(extchgrec_.forward_agent_id, forward_agent_id_)) OR
                   ((extchgrec_.ext_transport_calendar_id IS NOT NULL) AND Validate_SYS.Is_Changed(extchgrec_.ext_transport_calendar_id, ext_transport_calendar_id_)) OR
                   ((extchgrec_.packing_instruction_id IS NOT NULL) AND Validate_SYS.Is_Changed(extchgrec_.packing_instruction_id, packing_instruction_id_)) OR
                   ((extchgrec_.route_id IS NOT NULL) AND Validate_SYS.Is_Changed(extchgrec_.route_id, route_id_)) OR 
                   ((extchgrec_.picking_leadtime IS NOT NULL) AND Validate_SYS.Is_Changed(extchgrec_.picking_leadtime, picking_leadtime_)) OR
                   ((extchgrec_.delivery_leadtime IS NOT NULL) AND Validate_SYS.Is_Changed(extchgrec_.delivery_leadtime, delivery_leadtime_)) OR
                   (TRUNC(planned_delivery_date_) != TRUNC(extchgrec_.original_plan_deliv_date))) THEN
               row_changed_ := TRUE;
               status_      := 'Changed';
            END IF;

            IF (extchgrec_.sale_unit_price IS NOT NULL) THEN
               IF (sale_unit_price_ != extchgrec_.sale_unit_price) THEN
                  row_changed_ := TRUE;
                  status_ := 'Changed';
               END IF;
            END IF;

            IF (rental_ = Fnd_Boolean_API.DB_TRUE) THEN
               $IF Component_Rental_SYS.INSTALLED $THEN
                  rental_rec_  := Rental_Object_API.Get_Rental_Rec(order_no_,
                                                                      line_no_,
                                                                      rel_no_,
                                                                      line_item_no_,
                                                                      Rental_Type_API.DB_CUSTOMER_ORDER);
                  ext_message_rec_ := External_Pur_Order_Message_API.Get(extchgrec_.message_id,
                                                                            extchgrec_.message_line,
                                                                            'ORDCHG');
                  org_rental_start_date_ := ext_message_rec_.planned_rental_start_date;
                  org_rental_end_date_ := ext_message_rec_.planned_rental_end_date;
                  IF (rental_rec_.planned_rental_start_date != org_rental_start_date_) THEN
                     row_changed_ := TRUE;
                     status_ := 'Changed';
                  END IF;
                  IF (rental_rec_.planned_rental_end_date != org_rental_end_date_) THEN
                     row_changed_ := TRUE;
                     status_ := 'Changed';
                  END IF;
               $ELSE
                  Error_SYS.Component_Not_Exist('RENTAL');
               $END
            END IF;

         END IF;
      ELSIF ((NVL(customer_part_buy_qty_, buy_qty_due_) != extrec_.buy_qty_due) OR 
         (planned_delivery_date_ != extrec_.wanted_delivery_date)) THEN
         row_changed_ := TRUE;
         status_ := 'Changed';
      END IF;
   END IF;
   Trace_SYS.Field('ROW STATUS', status_);

   ext_wanted_del_date_ := extrec_.wanted_delivery_date;
   ext_buy_qty_due_ := extrec_.buy_qty_due;

END Get_Message_Line_Status___;
   
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU  NEW METHODS -------------------------------------
