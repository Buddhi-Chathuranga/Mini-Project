-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentIntrastat
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220117  ShVese  SC21R2-3145, Modified Find_Intrastat_Data to handle undo delivery transactions.
--  211217  Hahalk  Bug 161186(SC21R2-6469), Modified Find_Intrastat_Data() to change the notc 31 into 32 for Denmark.
--  211210  ShVese  SC21R2-642, Added company fetching from sender site for import shipment orders in Find_Intrastat_Data.
--  211208  ShVese  SC21R2-642, Added receiver_contract_ to  Find_Intrastat_Data and added logic to set company id and description for shipment orders.
--  211115  ShVese  SC21R2-642, Modified Find_Intrastat_Data to fetch the shipment id from inventory transaction history.
--  211115  ShVese  Added opponent type for the Shipment orders export scenario.
--  201012  ShVese  SC2020R1-649, Modified Find_Intrastat_Data() to support 'SHIPMENT_ORDER' for cancel receipts.
--  201006  ShVese  SC2020R1-649, Modified Find_Intrastat_Data() to support 'SHIPMENT_ORDER' for both delivery and receipt.
--  200904  RasDlk  SC2020R1-649, Modified Find_Intrastat_Data() to get the part description for source_ref_type 'SHIPMENT_ORDER'.
--  200211  ErFelk  Bug 149159(SCZ-5814), Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Get_Part_Info___ (
   unit_of_measure_         OUT VARCHAR2,
   country_of_origin_       OUT VARCHAR2,
   region_of_origin_        OUT VARCHAR2,
   customs_stat_no_         OUT VARCHAR2,
   intrastat_alt_unit_meas_ OUT VARCHAR2,   
   intrastat_alt_qty_       OUT NUMBER,   
   part_no_                 IN  VARCHAR2,
   contract_                IN  VARCHAR2,
   language_                IN  VARCHAR2,
   transaction_id_          IN  NUMBER,
   intrastat_id_            IN  NUMBER )
IS
    inv_part_rec_   Inventory_Part_API.Public_Rec;   
    info_           VARCHAR2(2000);
BEGIN    
    inv_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);
   
    unit_of_measure_  := inv_part_rec_.unit_meas;
    country_of_origin_:= inv_part_rec_.country_of_origin;
    region_of_origin_ := inv_part_rec_.region_of_origin;
    customs_stat_no_  := inv_part_rec_.customs_stat_no;

    -- Not mandatory in application, but should be entered for report.
    IF (customs_stat_no_ IS NULL) THEN
        info_ := Language_SYS.Translate_Constant(lu_name_,
                'NO_CUST_STAT_INV: Customs statistics number for inventory part :P1 on site :P2 must be entered.',
                                            language_, part_no_, contract_);
        Set_Status_Info___(transaction_id_, intrastat_id_, language_, info_);
    ELSE
        intrastat_alt_unit_meas_ := Customs_Statistics_Number_API.Get_Customs_Unit_Meas(inv_part_rec_.customs_stat_no);
    END IF;

    intrastat_alt_qty_ := nvl(inv_part_rec_.intrastat_conv_factor, 0);
 END Get_Part_Info___; 
 
PROCEDURE Set_Status_Info___ (
   transaction_id_ IN NUMBER,
   intrastat_id_   IN NUMBER,
   language_       IN VARCHAR2,
   info_           IN VARCHAR2 )
IS
   transaction_info_   VARCHAR2(2000);
   process_info_flag_  BOOLEAN := FALSE;
BEGIN

   -- Write information about the current transaction being processed
   -- to the background job log
   transaction_info_ := Language_SYS.Translate_Constant(lu_name_,
                        'TRANS_ERROR: Error when processing Inventory Transaction Id :P1.',
                                                        language_, to_char(transaction_id_));
   Transaction_SYS.Set_Status_Info(transaction_info_);

   IF info_ IS NOT NULL THEN
      -- Write additional error information
      Transaction_SYS.Set_Status_Info(info_);
   END IF;

   -- Set error flag on Intrastat header.
   Intrastat_Manager_API.Check_Process_Info(process_info_flag_, intrastat_id_);
END Set_Status_Info___;

PROCEDURE Get_Transaction_Info___ (
   notc_                OUT VARCHAR2,
   intrastat_direction_ OUT VARCHAR2,
   transaction_         IN  VARCHAR2,
   transaction_table_   IN  Intrastat_Manager_API.mpccom_transaction_type )
IS
BEGIN
   Intrastat_Manager_API.Get_Notc(notc_, intrastat_direction_, transaction_table_, transaction_);
END Get_Transaction_Info___;

FUNCTION Is_Eu_Country___ (
   country_          IN VARCHAR2,
   eu_country_table_ IN Intrastat_Manager_API.eu_country_type ) RETURN BOOLEAN
IS
BEGIN
   -- Check if the current country is a memeber of the EU.
   RETURN (Intrastat_Manager_API.Eu_Country(country_, eu_country_table_));
END Is_Eu_Country___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Find_Intrastat_Data (
   intrastat_id_      IN NUMBER,
   begin_date_        IN DATE,
   end_date_          IN DATE,
   invoice_date_      IN DATE,
   company_           IN VARCHAR2,
   report_country_    IN VARCHAR2,
   language_          IN VARCHAR2,
   receiver_contract_ IN VARCHAR2,
   transaction_id_    IN NUMBER,
   eu_country_table_  IN Intrastat_Manager_API.eu_country_type,
   transaction_table_ IN Intrastat_Manager_API.mpccom_transaction_type )
IS   
   inv_trans_hist_rec_           Inventory_Transaction_Hist_API.Public_Rec;   
   unit_of_measure_              VARCHAR2(10);
   customs_stat_no_              VARCHAR2(15);
   intrastat_alt_unit_meas_      VARCHAR2(10);
   country_of_origin_            VARCHAR2(3);
   region_of_origin_             VARCHAR2(10);
   notc_                         VARCHAR2(2);
   intrastat_direction_          VARCHAR2(20);  
   intrastat_quantity_           NUMBER;
   intrastat_alt_qty_            NUMBER;
   mode_of_transport_            VARCHAR2(200);
   shipment_id_                  NUMBER;
   sender_receiver_country_      VARCHAR2(3);
   sender_receiver_id_           VARCHAR2(50);
   sender_receiver_name_         VARCHAR2(100);      
   delivery_terms_               VARCHAR2(5);   
   triangulation_flag_           VARCHAR2(20) := 'NO TRIANGULATION';   
   shipment_rec_                 Shipment_API.Public_Rec;
   create_intrastat_             BOOLEAN := FALSE;
   part_description_             VARCHAR2(200);
   source_ref3_                  VARCHAR2(50);
   source_ref4_                  VARCHAR2(50);
   weight_unit_code_             VARCHAR2(10);
   net_unit_weight_              NUMBER;
   order_unit_price_             NUMBER;
   opponent_type_                VARCHAR2(20);
BEGIN   
   inv_trans_hist_rec_ := Inventory_Transaction_Hist_API.Get(transaction_id_);
   intrastat_quantity_ := inv_trans_hist_rec_.quantity;
    --TODO: After shipment id is stored on the inventory transaction for all scenarios we need to revisit this code. Then we can fetch the exact shipment and even
    --for the receipt transaction or cancel receipt transaction we can find the connected shipment and fetch all the required data from it
    -- Also we need to consider if the receipt and cancel receipt related code (IMPORT) should be moved to the Receipt side.
 
   -- For Project Deliverables we will handle the delivery transaction for intrastat export reporting
   -- For Shipment Order we will handle both the delivery(export) and receipt(import) transaction. The Shipment will be the basis
   -- for fetching information even for the import transaction. To find a related shipment we will use the shipment order reference bur ignore
   -- source_ref3 which would be a receipt no
   IF (inv_trans_hist_rec_.source_ref_type != Order_Type_API.DB_SHIPMENT_ORDER) THEN
       source_ref3_ := inv_trans_hist_rec_.source_ref3;
       source_ref4_ := inv_trans_hist_rec_.source_ref4;
       -- price is considered to be 0 for Project Deliverables
       order_unit_price_ := 0;
   ELSE
       -- For Shipment Order we consider the cost of the transaction as it is an internal movement
       order_unit_price_ :=  Inventory_Transaction_Cost_API.Get_Sum_Unit_Cost(transaction_id_);
   END IF;
   
   shipment_id_ := Nvl(To_Number(inv_trans_hist_rec_.source_ref5) ,Shipment_Line_API.Fetch_Shipment_Id_By_Source(inv_trans_hist_rec_.source_ref1, 
                                                                 inv_trans_hist_rec_.source_ref2,
                                                                 source_ref3_,
                                                                 source_ref4_,
                                                                 inv_trans_hist_rec_.source_ref_type));

   
   IF (shipment_id_ IS NOT NULL) THEN 
      Get_Transaction_Info___(notc_, intrastat_direction_, inv_trans_hist_rec_.transaction_code, transaction_table_);
      -- Only inventory parts are handled for Project Deliverables and Shipment Order so the assumption is that it is an inventory part.
      -- May need to revisit when we handle non-inventory parts
      Get_Part_Info___(unit_of_measure_, country_of_origin_, region_of_origin_, customs_stat_no_,
                       intrastat_alt_unit_meas_, intrastat_alt_qty_, inv_trans_hist_rec_.part_no, inv_trans_hist_rec_.contract, language_,
                       transaction_id_, intrastat_id_); 

      shipment_rec_  := Shipment_API.Get(shipment_id_);
      
      IF (intrastat_direction_ = Intrastat_Direction_API.DB_EXPORT) THEN      
         sender_receiver_id_ := shipment_rec_.receiver_id;
         sender_receiver_name_ := Shipment_Source_Utility_API.Get_Receiver_Name(shipment_rec_.receiver_id,shipment_rec_.receiver_type); 
         sender_receiver_country_  := shipment_rec_.receiver_country;        
         IF (inv_trans_hist_rec_.direction = '+' AND inv_trans_hist_rec_.qty_reversed > 0 AND inv_trans_hist_rec_.original_transaction_id IS NOT NULL) THEN
            -- undo delivery transaction        
            -- This is the only case when the sign of the qty needs to be changed i.e. when the delivery transaction is within the same intrastat period
            -- since qty_ is always a positive value.
            -- For shipment orders and project deliverables the delivery and undo delivery transactions will be EXPORT transactions
            intrastat_quantity_ := intrastat_quantity_ * -1;
            intrastat_alt_qty_ := intrastat_alt_qty_ * -1;
         END IF;
         IF (inv_trans_hist_rec_.source_ref_type = Order_Type_API.DB_SHIPMENT_ORDER) THEN
            opponent_type_ := 'COMPANY';
            -- For shipment order the opponent_number_ should be the Company Id of the receiver site
            sender_receiver_id_ := Site_API.Get_Company(receiver_contract_);
            -- For shipment order the opponent_name_ should be the Company description
            sender_receiver_name_ := Company_Finance_API.Get_Description(sender_receiver_id_); 
         END IF;   
      ELSIF (intrastat_direction_ = Intrastat_Direction_API.DB_IMPORT) THEN 
         -- receipt transactions
         sender_receiver_id_ := shipment_rec_.sender_id;
         sender_receiver_name_ := Shipment_Source_Utility_API.Get_Sender_Name(shipment_rec_.sender_id,shipment_rec_.sender_type); 
         sender_receiver_country_  := shipment_rec_.sender_country;
         IF (inv_trans_hist_rec_.direction = '-' AND inv_trans_hist_rec_.qty_reversed > 0 AND inv_trans_hist_rec_.original_transaction_id IS NOT NULL) THEN
            -- cancel receipt transaction        
            -- This is the only case when the sign of the qty needs to be changed i.e. when the receipt transaction is within the same intrastat period
            -- since qty_ is always a positive value.
            -- For shipment orders the receipt and cancel receipt transactions will be IMPORT transactions
            intrastat_quantity_ := intrastat_quantity_ * -1;
            intrastat_alt_qty_ := intrastat_alt_qty_ * -1;
         END IF;
         IF (inv_trans_hist_rec_.source_ref_type = Order_Type_API.DB_SHIPMENT_ORDER) THEN
            opponent_type_ := 'COMPANY';
            -- For shipment order the opponent_number_ should be the Company Id of the xender site
            sender_receiver_id_ := Site_API.Get_Company(inv_trans_hist_rec_.contract);
            -- For shipment order the opponent_name_ should be the Company description
            sender_receiver_name_ := Company_Finance_API.Get_Description(sender_receiver_id_); 
         END IF;   
      END IF;
      
      mode_of_transport_ := Mpccom_Ship_Via_API.Get_Mode_Of_Transport(shipment_rec_.ship_via_code);
      delivery_terms_    := shipment_rec_.delivery_terms;
      create_intrastat_  := TRUE; 
      
      IF sender_receiver_country_ IN ('MC', 'IM') THEN
         sender_receiver_country_ := Intrastat_Manager_API.Get_Including_Country(sender_receiver_country_);
      END IF; 
   
       -- Transaction should only be included in Intrastat report if the delivery address is in another EU-country
       IF (Is_Eu_Country___(sender_receiver_country_, eu_country_table_) AND create_intrastat_ ) THEN
          IF (sender_receiver_country_ != report_country_) THEN
             -- take part description from shipment line.
              part_description_ := Shipment_Line_API.Get_Source_Part_Desc_By_Source(shipment_id_,
                                                                               inv_trans_hist_rec_.source_ref1, 
                                                                               inv_trans_hist_rec_.source_ref2,
                                                                               source_ref3_,
                                                                               source_ref4_,
                                                                               inv_trans_hist_rec_.source_ref_type);         
                                                                               
              Inventory_Part_Config_API.Get_Net_Weight_And_Unit_Code(net_unit_weight_,
                                                                     weight_unit_code_,
                                                                     inv_trans_hist_rec_.contract,
                                                                     inv_trans_hist_rec_.part_no,
                                                                     inv_trans_hist_rec_.configuration_id);
   
              IF (weight_unit_code_ != 'kg') THEN            
                 -- When having Base UoM other than kg as the Company weight UoM it cannot be define the conversion with kg.
                 -- With that data set up it allows to create lines. 
                 BEGIN                  
                    net_unit_weight_ := Iso_Unit_API.Convert_Unit_Quantity(net_unit_weight_,
                                                                           weight_unit_code_,
                                                                           'kg');                  
                 EXCEPTION
                 WHEN OTHERS THEN
                    NULL;
                 END;            
              END IF;
              
               IF (report_country_ = 'DK') THEN
                  IF (notc_ = 31) THEN
                     notc_ := 32;
                  END IF;
               END IF;
          
              -- Create Intrastat line.
              Intrastat_Line_API.New_Intrastat_Line(intrastat_id_,
                                               transaction_id_,
                                               inv_trans_hist_rec_.transaction_code,
                                               inv_trans_hist_rec_.source_ref_type,
                                               inv_trans_hist_rec_.contract,
                                               inv_trans_hist_rec_.part_no,
                                               part_description_,
                                               inv_trans_hist_rec_.configuration_id,
                                               inv_trans_hist_rec_.lot_batch_no,
                                               inv_trans_hist_rec_.serial_no,
                                               inv_trans_hist_rec_.source_ref1,
                                               inv_trans_hist_rec_.source_ref2,
                                               inv_trans_hist_rec_.source_ref3,
                                               inv_trans_hist_rec_.source_ref4,
                                               inv_trans_hist_rec_.direction,
                                               intrastat_quantity_,
                                               inv_trans_hist_rec_.qty_reversed,
                                               unit_of_measure_,
                                               inv_trans_hist_rec_.reject_code,
                                               inv_trans_hist_rec_.date_applied,
                                               inv_trans_hist_rec_.userid,
                                               net_unit_weight_, 
                                               customs_stat_no_,
                                               intrastat_alt_qty_,
                                               intrastat_alt_unit_meas_,
                                               notc_,
                                               intrastat_direction_,
                                               country_of_origin_,
                                               'AUTOMATIC',
                                               sender_receiver_country_, -- opposite_country_
                                               sender_receiver_id_, -- opponent_number_
                                               sender_receiver_name_, -- opponent_name_
                                               order_unit_price_, -- order_unit_price_                                             
                                               NULL,
                                               NULL,
                                               mode_of_transport_,
                                               NULL, -- invoice_series_,
                                               NULL, -- invoice_number_,
                                               NULL, -- invoiced_unit_price_,
                                               NULL,
                                               NULL,
                                               delivery_terms_,
                                               triangulation_flag_,
                                               'DELIVERY',
                                               NULL,
                                               region_of_origin_,
                                               NULL,
                                               NULL,
                                               NULL,
                                               opponent_type_,
                                               NULL);
          END IF;                                               
       END IF;  
   END IF;
END Find_Intrastat_Data;    

-------------------- LU  NEW METHODS -------------------------------------

