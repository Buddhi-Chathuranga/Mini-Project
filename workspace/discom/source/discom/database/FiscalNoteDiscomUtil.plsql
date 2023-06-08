-----------------------------------------------------------------------------
--
--  Logical unit: FiscalNoteDiscomUtil
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220815  HasTlk  SCDEV-13088, Modified Create_Outgoing_Fiscal_Note_Lines___ by passing the Db value for the gtin_series.
--  220809  HasTlk  SCDEV-13048, Modified Create_Outgoing_Fiscal_Note_Lines___ and Create_Incoming_Fiscal_Note_Lines___ for set values for tax_code.
--  220803  ApWilk  SCDEV-13043, Modified Create_Incoming_Fiscal_Note and  Create_Incoming_Fiscal_Note_Head___ to adjust the logic of creation and removed dynamic 
--  220803          dependency annotation from the method signature.
--  220802  ApWilk  SCDEV-13026, Handled unit testing ignore annotation and dynamic dependency for methods.
--  220731  ApWilk  SCDEV-12176, Modified Create_Incoming_Fiscal_Note_Head___, Create_Incoming_Fiscal_Note_Lines___ and added Incoming_Tax_Document_Exist().
--  220730  HasTlk  SCDEV-12931, Added Create_Outgoing_Fiscal_Note method and modified existing Create_Outgoing_Fiscal_Note method for Handle automatic creation 
--  220730          of outgoing nota fiscal based on company parameter.
--  220729  ApWilk  SCDEV-12974, Removed all DynamicDependency annotations in method signatures and used conditional compilation in the body instead where 
--  220729          possible and added method Create_Incoming_Fiscal_Note_Line_Taxes___.
--  220729  MalLlk  SCDEV-12957, Modified Create_Outgoing_Fiscal_Note_Lines___ to pass price_incl_tax correctly when creating Outgoing Fiscal Note line.
--  220728  HasTlk  SCDEV-12962, Added changes for fetch the value to sender_document_addr_id.
--  220727  HasTlk  SCDEV-9648, Added Get_Transport_Related_Info___ and Get_Weight_And_Volume_Info___ for fetching transport related attributes and Weight, 
--  220727          Volume to the Outgoing Fiscal Note.
--  220719  HasTlk  SCDEV-11381, Added the Create_Outgoing_Fiscal_Note_Head___, Create_Outgoing_Fiscal_Note_Lines___, Create_Outgoing_Fiscal_Note_Line_Taxes___,
--  220719          Get_Tax_Document_Status and Fiscal_Note_Exists methods and modified the Create_Outgoing_Fiscal_Note method. 
--  220706  HasTlk  SCDEV-11491, Created and added the Generate_And_Update_Off_Inv_No___ and Create_Outgoing_Fiscal_Note methods.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Outgoing_Fiscal_Note_Head___ (
   fiscal_note_id_    OUT NUMBER,
   company_           IN  VARCHAR2,
   tax_document_no_   IN  NUMBER)
IS
   tax_document_rec_          Tax_Document_API.Public_Rec;
   tax_amount_rec_            Tax_Document_API.Tax_Amount_Rec;
   tax_document_addr_rec_     Tax_Document_API.Tax_Document_Addr_Rec;
   company_address_rec_       Company_Address_API.public_rec;   
   $IF Component_Erep_SYS.INSTALLED $THEN
      rec_                       Fiscal_Note_Head_API.Fiscal_Note_Head_Rec;
   $END
   forwarder_address_rec_     Forwarder_Info_Address_API.Public_Rec;
   forwarders_supp_addr_rec_  Supplier_Info_Address_API.Public_Rec;
   false_                     VARCHAR2(5):= Fnd_Boolean_API.DB_FALSE;
BEGIN
   $IF Component_Erep_SYS.INSTALLED $THEN
      tax_document_rec_  := Tax_Document_API.Get(company_, tax_document_no_);
      
      IF (tax_document_rec_.direction = Tax_Document_Direction_API.DB_OUTBOUND)THEN 

         Tax_Document_Line_API.Get_Amounts (tax_amount_rec_.net_amount,
                                            tax_amount_rec_.tax_amount,
                                            tax_amount_rec_.gross_amount,
                                            company_,
                                            tax_document_no_);
         Tax_Document_API.Get_Sender_Receiver_Names(rec_.sender_name, 
                                                    rec_.receiver_name, 
                                                    tax_document_rec_.source_ref_type, 
                                                    tax_document_rec_.sender_id,
                                                    tax_document_rec_.receiver_id,
                                                    tax_document_rec_.sender_type, 
                                                    tax_document_rec_.receiver_type);                                                   
         tax_document_addr_rec_         := Tax_Document_API.Get_Address_Information(company_, tax_document_no_);
         company_address_rec_           := Company_Address_API.Get(company_, tax_document_rec_.sender_addr_id);
         rec_.currency_code             := Company_Finance_API.Get_Currency_Code(company_);   

         Currency_Rate_API.Get_Currency_Rate(rec_.div_factor,
                                             rec_.currency_rate,
                                             company_,
                                             rec_.currency_code,
                                             Currency_Type_API.Get_Default_Type(company_),
                                             tax_document_rec_.created_date);         
         rec_.company                   := company_;
         rec_.fiscal_note_series        := tax_document_rec_.component_a;
         rec_.fiscal_note_no            := tax_document_rec_.serial_number;      
         rec_.object_type               := Fiscal_Note_Object_Type_API.DB_OUTGOING_TAX_DOCUMENT;
         rec_.object_ref1               := TO_CHAR(tax_document_no_);
         rec_.creation_date             := SYSDATE;
         rec_.invoice_date              := tax_document_rec_.created_date;     
         rec_.sender_type               := tax_document_rec_.sender_type;
         rec_.sender_id                 := tax_document_rec_.sender_id;
         rec_.sender_delivery_addr_id   := tax_document_addr_rec_.sender_addr_id;
         rec_.sender_address_name       := tax_document_addr_rec_.sender_address_name;
         rec_.sender_address1           := tax_document_addr_rec_.sender_address1;
         rec_.sender_address2           := tax_document_addr_rec_.sender_address2;
         rec_.sender_address3           := tax_document_addr_rec_.sender_address3;
         rec_.sender_address4           := tax_document_addr_rec_.sender_address4;
         rec_.sender_address5           := tax_document_addr_rec_.sender_address5;
         rec_.sender_address6           := tax_document_addr_rec_.sender_address6;
         rec_.sender_street             := company_address_rec_.street;
         rec_.sender_house_no           := company_address_rec_.house_no;
         rec_.sender_district           := company_address_rec_.district;
         rec_.sender_zip_code           := tax_document_addr_rec_.sender_zip_code;
         rec_.sender_city               := tax_document_addr_rec_.sender_city;
         rec_.sender_state              := tax_document_addr_rec_.sender_state;
         rec_.sender_county             := tax_document_addr_rec_.sender_county;
         rec_.sender_country            := tax_document_addr_rec_.sender_country;
         rec_.sender_document_addr_id   := Tax_Document_API.Get_Sender_Doc_Address_Id(tax_document_rec_.sender_id, tax_document_rec_.sender_type);

         $IF Component_Invoic_SYS.INSTALLED $THEN
            rec_.sender_cnpj            := Company_Address_Tax_Number_API.Get_Tax_Id_Number(company_, rec_.sender_delivery_addr_id, Iso_Country_API.Decode('BR'), 'CNPJ');
            rec_.sender_state_reg       := Company_Address_Tax_Number_API.Get_Tax_Id_Number(company_, rec_.sender_delivery_addr_id, Iso_Country_API.Decode('BR'), 'STATE_REG');
         $ELSE
            NULL;
         $END
         rec_.receiver_type             := tax_document_rec_.receiver_type;
         rec_.receiver_id               := tax_document_rec_.receiver_id;
         rec_.receiver_delivery_addr_id := tax_document_rec_.receiver_addr_id;
         rec_.receiver_address_name     := tax_document_addr_rec_.receiver_address_name;
         rec_.receiver_address1         := tax_document_addr_rec_.receiver_address1;
         rec_.receiver_address2         := tax_document_addr_rec_.receiver_address2;
         rec_.receiver_address3         := tax_document_addr_rec_.receiver_address3;
         rec_.receiver_address4         := tax_document_addr_rec_.receiver_address4;
         rec_.receiver_address5         := tax_document_addr_rec_.receiver_address5;
         rec_.receiver_address6         := tax_document_addr_rec_.receiver_address6;
         rec_.receiver_zip_code         := tax_document_addr_rec_.receiver_zip_code;
         rec_.receiver_city             := tax_document_addr_rec_.receiver_city;
         rec_.receiver_state            := tax_document_addr_rec_.receiver_state;
         rec_.receiver_county           := tax_document_addr_rec_.receiver_county;
         rec_.receiver_country          := tax_document_addr_rec_.receiver_country;
         rec_.receiver_addr_flag        := false_;     
         rec_.receiver_document_addr_id := tax_document_rec_.document_addr_id;

         $IF Component_Invoic_SYS.INSTALLED $THEN
            rec_.receiver_cnpj          := Company_Address_Tax_Number_API.Get_Tax_Id_Number(company_, rec_.receiver_delivery_addr_id, Iso_Country_API.Decode('BR'), 'CNPJ');
            rec_.receiver_state_reg     := Company_Address_Tax_Number_API.Get_Tax_Id_Number(company_, rec_.receiver_delivery_addr_id, Iso_Country_API.Decode('BR'), 'STATE_REG');
         $ELSE
            NULL;
         $END
         rec_.net_curr_amount           := tax_amount_rec_.net_amount;
         rec_.net_dom_amount            := tax_amount_rec_.net_amount;
         rec_.tax_curr_amount           := tax_amount_rec_.tax_amount;
         rec_.tax_dom_amount            := tax_amount_rec_.tax_amount;     
         rec_.tax_currency_rate         := rec_.currency_rate;      
         rec_.business_transaction_id   := tax_document_rec_.business_transaction_id;
         rec_.final_consumer            := false_;
         rec_.final_consumer_inv_series := false_;
         rec_.icms_tax_payer            := false_;
         rec_.contract                  := tax_document_rec_.contract;
         rec_.branch                    := tax_document_rec_.branch;
         rec_.fiscal_note_text          := tax_document_rec_.tax_document_text;
         
         Get_Transport_Related_Info___(rec_.ship_via_description, 
                                       rec_.delivery_terms_description, 
                                       rec_.forwarder_id, 
                                       rec_.forwarder_address_id, 
                                       rec_.forwarders_supp_id, 
                                       rec_.forwarders_supp_address_id, 
                                       tax_document_rec_.source_ref1, 
                                       tax_document_rec_.source_ref_type);
         
         forwarder_address_rec_         := Forwarder_Info_Address_API.Get(rec_.forwarder_id, rec_.forwarder_address_id);
         forwarders_supp_addr_rec_      := Supplier_Info_Address_API.Get(rec_.forwarders_supp_id, rec_.forwarders_supp_address_id);

         rec_.forwarder_address1        := forwarder_address_rec_.address1;
         rec_.forwarder_address2        := forwarder_address_rec_.address2;
         rec_.forwarder_address3        := forwarder_address_rec_.address3;
         rec_.forwarder_address4        := forwarder_address_rec_.address4;
         rec_.forwarder_address5        := forwarder_address_rec_.address5;
         rec_.forwarder_address6        := forwarder_address_rec_.address6;      
         rec_.forwarder_zip_code        := forwarder_address_rec_.zip_code;
         rec_.forwarder_city            := forwarder_address_rec_.city;
         rec_.forwarder_state           := forwarder_address_rec_.state;
         rec_.forwarder_county          := forwarder_address_rec_.county;
         rec_.forwarder_country         := forwarder_address_rec_.country;         
         rec_.forwarders_supp_address1  := forwarders_supp_addr_rec_.address1;
         rec_.forwarders_supp_address2  := forwarders_supp_addr_rec_.address2;
         rec_.forwarders_supp_address3  := forwarders_supp_addr_rec_.address3;
         rec_.forwarders_supp_address4  := forwarders_supp_addr_rec_.address4;
         rec_.forwarders_supp_address5  := forwarders_supp_addr_rec_.address5;
         rec_.forwarders_supp_address6  := forwarders_supp_addr_rec_.address6;
         rec_.forwarders_supp_zip_code  := forwarders_supp_addr_rec_.zip_code;
         rec_.forwarders_supp_city      := forwarders_supp_addr_rec_.city;
         rec_.forwarders_supp_state     := forwarders_supp_addr_rec_.state;
         rec_.forwarders_supp_county    := forwarders_supp_addr_rec_.county;
         rec_.forwarders_supp_country   := forwarders_supp_addr_rec_.country;

         Get_Weight_And_Volume_Info___(rec_.net_weight, 
                                       rec_.gross_weight, 
                                       rec_.volume, 
                                       rec_.uom_for_weight, 
                                       rec_.uom_for_volume, 
                                       company_, 
                                       tax_document_rec_.source_ref1, 
                                       tax_document_rec_.source_ref_type);
         Fiscal_Note_Head_Outgoing_API.Create_Fiscal_Note(rec_);

         fiscal_note_id_ := rec_.fiscal_note_id;
      END IF;
   $ELSE
      Error_SYS.Component_Not_Exist('EREP');
   $END   
END Create_Outgoing_Fiscal_Note_Head___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Outgoing_Fiscal_Note_Lines___ (
   company_          IN VARCHAR2,
   tax_document_no_  IN NUMBER,
   fiscal_note_id_   IN NUMBER )
IS
   $IF Component_Erep_SYS.INSTALLED $THEN
      line_rec_         Fiscal_Note_Line_API.Fiscal_Note_Line_Rec;
   $END
   gtin_no_          VARCHAR2(20);
   contract_         VARCHAR2(10);
   
   CURSOR get_tax_document_line_info IS  
      SELECT * 
      FROM   tax_document_line_info
      WHERE  company         = company_
      AND    tax_document_no = tax_document_no_;
         
BEGIN
   $IF Component_Erep_SYS.INSTALLED $THEN
      contract_ := Tax_Document_API.Get_Contract(company_, tax_document_no_);
      FOR line_ IN get_tax_document_line_info LOOP
         $IF Component_Order_SYS.INSTALLED $THEN
            gtin_no_ := Sales_Part_API.Get_Gtin_No(contract_, line_.part_no, line_.unit_meas);
         $ELSE
            NULL;
         $END           

         line_rec_.company                  := company_;
         line_rec_.fiscal_note_id           := fiscal_note_id_;
         line_rec_.object_ref1              := TO_CHAR(tax_document_no_);       
         line_rec_.object_ref2              := TO_CHAR(line_.line_no);       
         line_rec_.alt_object_ref1          := line_.source_ref1;
         line_rec_.alt_object_ref2          := line_.source_ref2;        
         line_rec_.alt_object_ref3          := NULL;     
         line_rec_.part_no                  := line_.part_no;         
         line_rec_.part_description         := line_.part_description;         
         line_rec_.gtin_series              := Part_Gtin_API.Get_Gtin_Series_Db(line_.part_no, gtin_no_);
         line_rec_.cest_code                := Part_Br_Spec_Attrib_API.Get_Cest_Code(line_.part_no);
         line_rec_.gtin_no                  := gtin_no_;         
         line_rec_.statistical_code         := line_.statistical_code;
         line_rec_.business_operation       := line_.business_operation;
         line_rec_.acquisition_origin       := line_.acquisition_origin;     
         line_rec_.sales_uom                := line_.unit_meas;      
         line_rec_.inventory_uom            := line_.unit_meas;
         line_rec_.tax_code                 := line_.tax_code;
         line_rec_.tax_calc_structure_id    := line_.tax_calc_structure_id;      
         line_rec_.quantity                 := line_.qty;
         line_rec_.price                    := line_.price;         
         line_rec_.price_incl_tax           := Tax_Handling_Discom_Util_API.Get_Price_Incl_Tax(company_, tax_document_no_, line_.line_no, line_.tax_code, line_.tax_calc_structure_id, line_.price);      
         line_rec_.net_curr_amount          := line_.net_amount;
         line_rec_.net_dom_amount           := line_.net_amount;
         line_rec_.tax_curr_amount          := line_.tax_amount;
         line_rec_.tax_dom_amount           := line_.tax_amount_acc_curr;         
         line_rec_.tax_document_line_text   := line_.tax_document_line_text;

         Fiscal_Note_Line_Outgoing_API.Create_Fiscal_Note_Line(line_rec_);

         Create_Outgoing_Fiscal_Note_Line_Taxes___(company_, tax_document_no_, line_.line_no, fiscal_note_id_, line_rec_.fiscal_note_line_id);
      END LOOP;
   $ELSE
      Error_SYS.Component_Not_Exist('EREP');
   $END   
END Create_Outgoing_Fiscal_Note_Lines___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Outgoing_Fiscal_Note_Line_Taxes___ (
   company_               IN VARCHAR2,
   tax_document_no_       IN NUMBER,
   tax_document_line_no_  IN NUMBER,
   fiscal_note_id_        IN NUMBER,
   fiscal_note_line_id_   IN NUMBER )
IS
BEGIN
   $IF Component_Erep_SYS.INSTALLED $THEN
      Tax_Handling_Erep_Util_API.Transfer_Tax_lines(company_, 
                                                   Tax_Source_API.DB_TAX_DOCUMENT_LINE, 
                                                   TO_CHAR(tax_document_no_), 
                                                   TO_CHAR(tax_document_line_no_), 
                                                   '*', 
                                                   '*', 
                                                   '*',
                                                   Tax_Source_API.DB_FISCAL_NOTE, 
                                                   TO_CHAR(fiscal_note_id_), 
                                                   TO_CHAR(fiscal_note_line_id_),  
                                                   '*', 
                                                   '*', 
                                                   '*');
   $ELSE
      Error_SYS.Component_Not_Exist('EREP');
   $END   
END Create_Outgoing_Fiscal_Note_Line_Taxes___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Incoming_Fiscal_Note_Line_Taxes___ (
   company_                   IN VARCHAR2,
   outgoing_fiscal_note_id_   IN NUMBER,
   outgoing_fn_line_id_       IN NUMBER,
   fiscal_note_id_            IN NUMBER,
   fiscal_note_line_id_       IN NUMBER )
IS
   db_fiscal_note_            VARCHAR2(15) := Tax_Source_API.DB_FISCAL_NOTE;
BEGIN
   $IF Component_Erep_SYS.INSTALLED $THEN
      Tax_Handling_Erep_Util_API.Transfer_Tax_lines(company_, db_fiscal_note_, TO_CHAR(outgoing_fiscal_note_id_), TO_CHAR(outgoing_fn_line_id_), '*', '*', '*',
                                                              db_fiscal_note_, TO_CHAR(fiscal_note_id_), TO_CHAR(fiscal_note_line_id_),  '*', '*', '*');
   $ELSE
      Error_SYS.Component_Not_Exist('EREP');
   $END
END Create_Incoming_Fiscal_Note_Line_Taxes___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Generate_And_Update_Off_Inv_No___ (
   company_             IN VARCHAR2,
   tax_document_no_     IN NUMBER )
IS
   tax_document_rec_    Tax_Document_API.Public_Rec;
   
BEGIN
   $IF Component_Erep_SYS.INSTALLED $THEN
      tax_document_rec_ := Tax_Document_API.Get(company_, tax_document_no_);   
      $IF Component_Invoic_SYS.INSTALLED $THEN
         IF (tax_document_rec_.official_document_no IS NULL) THEN
            Off_Inv_Num_comp_Series_API.Get_Next_Alt_Inv_Number(tax_document_rec_.component_b, 
                                                               tax_document_rec_.component_c, 
                                                               tax_document_rec_.serial_number, 
                                                               company_, 
                                                               tax_document_rec_.branch, 
                                                               tax_document_rec_.component_a);
            tax_document_rec_.official_document_no := Off_Inv_Num_Comp_Series_API.Get_Official_Number(company_, 
                                                                                                      NULL, 
                                                                                                      tax_document_rec_.component_a, 
                                                                                                      tax_document_rec_.component_b, 
                                                                                                      tax_document_rec_.component_c, 
                                                                                                      tax_document_rec_.serial_number);
            Tax_Document_API.Modify_Official_Doc_No_Info(company_, 
                                                         tax_document_no_, 
                                                         tax_document_rec_.component_b, 
                                                         tax_document_rec_.component_c, 
                                                         tax_document_rec_.serial_number,
                                                         tax_document_rec_.official_document_no);
         END IF;
      $END
   $ELSE
     NULL;
   $END  
END Generate_And_Update_Off_Inv_No___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Transport_Related_Info___ (
   ship_via_description_         OUT VARCHAR2,
   delivery_terms_description_   OUT VARCHAR2,
   forward_agent_id_             OUT VARCHAR2,
   forwarder_address_id_         OUT VARCHAR2,
   forwarders_supp_id_           OUT VARCHAR2,
   forwarders_supp_address_id_   OUT VARCHAR2,
   source_ref1_                  IN  VARCHAR2,
   source_ref_type_              IN  VARCHAR2)
IS
   $IF Component_Shpmnt_SYS.INSTALLED $THEN
      shipment_rec_     Shipment_API.Public_Rec;
   $END
BEGIN   
   IF (source_ref_type_ = 'SHIPMENT') THEN
      $IF Component_Shpmnt_SYS.INSTALLED $THEN
         shipment_rec_                 :=  Shipment_API.Get(to_number(source_ref1_));         
         ship_via_description_         :=  Mpccom_Ship_Via_API.Get_Description (shipment_rec_.ship_via_code);
         delivery_terms_description_   :=  Order_Delivery_Term_API.Get_Description (shipment_rec_.delivery_terms);    
         forward_agent_id_             :=  shipment_rec_.forward_agent_id;
         
         IF(forward_agent_id_ IS NOT NULL )THEN 
            forwarder_address_id_           :=  Forwarder_Info_Address_API.Get_Default_Address(forward_agent_id_, Address_Type_Code_API.Decode('DELIVERY'));
            forwarders_supp_id_             :=  Forwarder_Info_API.Get_Supplier_Id(forward_agent_id_);
            forwarders_supp_address_id_     :=  Supplier_Info_Address_API.Get_Default_Address(forwarders_supp_id_, Address_Type_Code_API.Decode('DELIVERY'));
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
END Get_Transport_Related_Info___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Weight_And_Volume_Info___ (
   net_weight_       OUT NUMBER,
   gross_weight_     OUT NUMBER,
   volume_           OUT NUMBER,
   uom_for_weight_   OUT VARCHAR2,
   uom_for_volume_   OUT VARCHAR2,
   company_          IN  VARCHAR2,
   source_ref1_      IN  VARCHAR2,
   source_ref_type_  IN  VARCHAR2)
IS
   company_inv_info_rec_   Company_Invent_Info_API.Public_Rec; 
   base_unit_weight_       iso_unit_tab.base_unit%TYPE;
   base_unit_volume_       iso_unit_tab.base_unit%TYPE;       
BEGIN   
   company_inv_info_rec_   := Company_Invent_Info_API.Get(company_);   
   uom_for_weight_         := company_inv_info_rec_.uom_for_weight;
   uom_for_volume_         := company_inv_info_rec_.uom_for_volume;
   base_unit_weight_       := Iso_Unit_API.Get_Base_Unit(uom_for_weight_);
   base_unit_volume_       := Iso_Unit_API.Get_Base_Unit(uom_for_volume_);
   
   IF (source_ref_type_ = 'SHIPMENT') THEN
      $IF Component_Shpmnt_SYS.INSTALLED $THEN
         net_weight_       := Shipment_API.Get_Net_Weight(to_number(source_ref1_), base_unit_weight_, 'FALSE');
         gross_weight_     := Shipment_API.Get_Operational_Gross_Weight(to_number(source_ref1_), base_unit_weight_, 'FALSE');
         volume_           := Shipment_API.Get_Operational_Volume(to_number(source_ref1_), base_unit_volume_);
      $ELSE
         NULL;
      $END
   END IF;     
END Get_Weight_And_Volume_Info___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Incoming_Fiscal_Note_Head___ (
   incoming_fiscal_note_id_   OUT NUMBER,
   company_                   IN VARCHAR2,
   outgoing_fiscal_note_id_   IN NUMBER)
IS
   $IF Component_Erep_SYS.INSTALLED $THEN
      outgoing_fiscal_note_rec_  Fiscal_Note_Head_Outgoing_API.Public_Rec;
      fiscal_note_head_rec_      Fiscal_Note_Head_API.Fiscal_Note_Head_Rec;
   $END   
     
BEGIN
   $IF Component_Erep_SYS.INSTALLED $THEN
      outgoing_fiscal_note_rec_                         := Fiscal_Note_Head_Outgoing_API.Get(company_, outgoing_fiscal_note_id_);
      fiscal_note_head_rec_.company                     := outgoing_fiscal_note_rec_.company;
      fiscal_note_head_rec_.fiscal_note_series          := outgoing_fiscal_note_rec_.fiscal_note_series;
      fiscal_note_head_rec_.fiscal_note_no              := outgoing_fiscal_note_rec_.fiscal_note_no;      
      fiscal_note_head_rec_.object_type                 := Fiscal_Note_Object_Type_API.DB_INCOMING_TAX_DOCUMENT;    
      fiscal_note_head_rec_.object_ref1                 := NULL;
      fiscal_note_head_rec_.alt_object_type             := Order_Type_API.DB_OUTGOING_FISCAL_NOTE;
      fiscal_note_head_rec_.alt_object_ref1             := TO_CHAR(outgoing_fiscal_note_rec_.fiscal_note_id);
      fiscal_note_head_rec_.creation_date               := SYSDATE;
      fiscal_note_head_rec_.invoice_date                := outgoing_fiscal_note_rec_.invoice_date;     
      fiscal_note_head_rec_.sender_type                 := outgoing_fiscal_note_rec_.sender_type;
      fiscal_note_head_rec_.sender_id                   := outgoing_fiscal_note_rec_.sender_id;      
      fiscal_note_head_rec_.sender_name                 := outgoing_fiscal_note_rec_.sender_name;      
      fiscal_note_head_rec_.sender_delivery_addr_id     := outgoing_fiscal_note_rec_.sender_delivery_addr_id;
      fiscal_note_head_rec_.sender_address1             := outgoing_fiscal_note_rec_.sender_address1;
      fiscal_note_head_rec_.sender_address2             := outgoing_fiscal_note_rec_.sender_address2;
      fiscal_note_head_rec_.sender_address3             := outgoing_fiscal_note_rec_.sender_address3;
      fiscal_note_head_rec_.sender_address4             := outgoing_fiscal_note_rec_.sender_address4;
      fiscal_note_head_rec_.sender_address5             := outgoing_fiscal_note_rec_.sender_address5;
      fiscal_note_head_rec_.sender_address6             := outgoing_fiscal_note_rec_.sender_address6;
      fiscal_note_head_rec_.sender_street               := outgoing_fiscal_note_rec_.sender_street;
      fiscal_note_head_rec_.sender_house_no             := outgoing_fiscal_note_rec_.sender_house_no;
      fiscal_note_head_rec_.sender_district             := outgoing_fiscal_note_rec_.sender_district;
      fiscal_note_head_rec_.sender_zip_code             := outgoing_fiscal_note_rec_.sender_zip_code;
      fiscal_note_head_rec_.sender_city                 := outgoing_fiscal_note_rec_.sender_city;
      fiscal_note_head_rec_.sender_state                := outgoing_fiscal_note_rec_.sender_state;
      fiscal_note_head_rec_.sender_county               := outgoing_fiscal_note_rec_.sender_county;
      fiscal_note_head_rec_.sender_country              := outgoing_fiscal_note_rec_.sender_country;
      fiscal_note_head_rec_.sender_document_addr_id     := outgoing_fiscal_note_rec_.sender_document_addr_id;
      fiscal_note_head_rec_.sender_cnpj                 := outgoing_fiscal_note_rec_.sender_cnpj;                
      fiscal_note_head_rec_.sender_state_reg            := outgoing_fiscal_note_rec_.sender_state_reg;      
      fiscal_note_head_rec_.receiver_type               := outgoing_fiscal_note_rec_.receiver_type;
      fiscal_note_head_rec_.receiver_id                 := outgoing_fiscal_note_rec_.receiver_id;      
      fiscal_note_head_rec_.receiver_name               := outgoing_fiscal_note_rec_.receiver_name;
      fiscal_note_head_rec_.receiver_delivery_addr_id   := outgoing_fiscal_note_rec_.receiver_delivery_addr_id;
      fiscal_note_head_rec_.receiver_address1           := outgoing_fiscal_note_rec_.receiver_address1;
      fiscal_note_head_rec_.receiver_address2           := outgoing_fiscal_note_rec_.receiver_address2;
      fiscal_note_head_rec_.receiver_address3           := outgoing_fiscal_note_rec_.receiver_address3;
      fiscal_note_head_rec_.receiver_address4           := outgoing_fiscal_note_rec_.receiver_address4;
      fiscal_note_head_rec_.receiver_address5           := outgoing_fiscal_note_rec_.receiver_address5;
      fiscal_note_head_rec_.receiver_address6           := outgoing_fiscal_note_rec_.receiver_address6;
      fiscal_note_head_rec_.receiver_zip_code           := outgoing_fiscal_note_rec_.receiver_zip_code;
      fiscal_note_head_rec_.receiver_city               := outgoing_fiscal_note_rec_.receiver_city;
      fiscal_note_head_rec_.receiver_state              := outgoing_fiscal_note_rec_.receiver_state;
      fiscal_note_head_rec_.receiver_county             := outgoing_fiscal_note_rec_.receiver_county;
      fiscal_note_head_rec_.receiver_country            := outgoing_fiscal_note_rec_.receiver_country;      
      fiscal_note_head_rec_.receiver_addr_flag          := outgoing_fiscal_note_rec_.receiver_addr_flag;
      fiscal_note_head_rec_.receiver_document_addr_id   := outgoing_fiscal_note_rec_.receiver_document_addr_id;
      fiscal_note_head_rec_.receiver_cnpj               := outgoing_fiscal_note_rec_.receiver_cnpj;
      fiscal_note_head_rec_.receiver_state_reg          := outgoing_fiscal_note_rec_.receiver_state_reg;
      fiscal_note_head_rec_.net_curr_amount             := outgoing_fiscal_note_rec_.net_curr_amount;
      fiscal_note_head_rec_.net_dom_amount              := outgoing_fiscal_note_rec_.net_dom_amount;
      fiscal_note_head_rec_.tax_curr_amount             := outgoing_fiscal_note_rec_.tax_curr_amount;
      fiscal_note_head_rec_.tax_dom_amount              := outgoing_fiscal_note_rec_.tax_dom_amount;     
      fiscal_note_head_rec_.currency_code               := outgoing_fiscal_note_rec_.currency_code;   
      fiscal_note_head_rec_.currency_rate               := outgoing_fiscal_note_rec_.currency_rate;      
      fiscal_note_head_rec_.tax_currency_rate           := outgoing_fiscal_note_rec_.tax_currency_rate;      
      fiscal_note_head_rec_.div_factor                  := outgoing_fiscal_note_rec_.div_factor; 
      fiscal_note_head_rec_.business_transaction_id     := outgoing_fiscal_note_rec_.business_transaction_id;
      fiscal_note_head_rec_.final_consumer              := outgoing_fiscal_note_rec_.final_consumer;
      fiscal_note_head_rec_.final_consumer_inv_series   := outgoing_fiscal_note_rec_.final_consumer_inv_series;
      fiscal_note_head_rec_.icms_tax_payer              := outgoing_fiscal_note_rec_.icms_tax_payer;
      fiscal_note_head_rec_.forwarder_id                := outgoing_fiscal_note_rec_.forwarder_id;
      fiscal_note_head_rec_.forwarder_address_id        := outgoing_fiscal_note_rec_.forwarder_address_id;
      fiscal_note_head_rec_.forwarder_address1          := outgoing_fiscal_note_rec_.forwarder_address1;
      fiscal_note_head_rec_.forwarder_address2          := outgoing_fiscal_note_rec_.forwarder_address2;
      fiscal_note_head_rec_.forwarder_address3          := outgoing_fiscal_note_rec_.forwarder_address3;
      fiscal_note_head_rec_.forwarder_address4          := outgoing_fiscal_note_rec_.forwarder_address4;
      fiscal_note_head_rec_.forwarder_address5          := outgoing_fiscal_note_rec_.forwarder_address5;
      fiscal_note_head_rec_.forwarder_address6          := outgoing_fiscal_note_rec_.forwarder_address6;      
      fiscal_note_head_rec_.forwarder_zip_code          := outgoing_fiscal_note_rec_.forwarder_zip_code;
      fiscal_note_head_rec_.forwarder_city              := outgoing_fiscal_note_rec_.forwarder_city;
      fiscal_note_head_rec_.forwarder_state             := outgoing_fiscal_note_rec_.forwarder_state;
      fiscal_note_head_rec_.forwarder_county            := outgoing_fiscal_note_rec_.forwarder_county;
      fiscal_note_head_rec_.forwarder_country           := outgoing_fiscal_note_rec_.forwarder_country;
      fiscal_note_head_rec_.forwarders_supp_address_id  := outgoing_fiscal_note_rec_.forwarders_supp_address_id;
      fiscal_note_head_rec_.forwarders_supp_address1    := outgoing_fiscal_note_rec_.forwarders_supp_address1;
      fiscal_note_head_rec_.forwarders_supp_address2    := outgoing_fiscal_note_rec_.forwarders_supp_address2;
      fiscal_note_head_rec_.forwarders_supp_address3    := outgoing_fiscal_note_rec_.forwarders_supp_address3;
      fiscal_note_head_rec_.forwarders_supp_address4    := outgoing_fiscal_note_rec_.forwarders_supp_address4;
      fiscal_note_head_rec_.forwarders_supp_address5    := outgoing_fiscal_note_rec_.forwarders_supp_address5;
      fiscal_note_head_rec_.forwarders_supp_address6    := outgoing_fiscal_note_rec_.forwarders_supp_address6;
      fiscal_note_head_rec_.forwarders_supp_zip_code    := outgoing_fiscal_note_rec_.forwarders_supp_zip_code;
      fiscal_note_head_rec_.forwarders_supp_city        := outgoing_fiscal_note_rec_.forwarders_supp_city;
      fiscal_note_head_rec_.forwarders_supp_state       := outgoing_fiscal_note_rec_.forwarders_supp_state;
      fiscal_note_head_rec_.forwarders_supp_county      := outgoing_fiscal_note_rec_.forwarders_supp_county;
      fiscal_note_head_rec_.forwarders_supp_country     := outgoing_fiscal_note_rec_.forwarders_supp_country;
      fiscal_note_head_rec_.ship_via_description        := outgoing_fiscal_note_rec_.ship_via_description;
      fiscal_note_head_rec_.delivery_terms_description  := outgoing_fiscal_note_rec_.delivery_terms_description;
      fiscal_note_head_rec_.net_weight                  := outgoing_fiscal_note_rec_.net_weight;
      fiscal_note_head_rec_.gross_weight                := outgoing_fiscal_note_rec_.gross_weight;
      fiscal_note_head_rec_.volume                      := outgoing_fiscal_note_rec_.volume;
      fiscal_note_head_rec_.uom_for_weight              := outgoing_fiscal_note_rec_.uom_for_weight;
      fiscal_note_head_rec_.uom_for_volume              := outgoing_fiscal_note_rec_.uom_for_volume;
      fiscal_note_head_rec_.contract                    := outgoing_fiscal_note_rec_.contract;
      fiscal_note_head_rec_.branch                      := outgoing_fiscal_note_rec_.branch;
      fiscal_note_head_rec_.fiscal_note_text            := outgoing_fiscal_note_rec_.fiscal_note_text;

      Fiscal_Note_Head_Incoming_API.Create_Fiscal_Note(fiscal_note_head_rec_);
      incoming_fiscal_note_id_ := fiscal_note_head_rec_.fiscal_note_id; 
   $ELSE
      Error_SYS.Component_Not_Exist('EREP');
   $END
   
END Create_Incoming_Fiscal_Note_Head___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Incoming_Fiscal_Note_Lines___ (
   company_                  IN VARCHAR2,
   outgoing_fiscal_note_id_  IN NUMBER,
   incoming_fiscal_note_id_  IN NUMBER )
IS
   $IF Component_Erep_SYS.INSTALLED $THEN
      fiscal_note_line_rec_     Fiscal_Note_Line_API.Fiscal_Note_Line_Rec;

      CURSOR get_fiscal_note_line_info IS  
         SELECT * 
         FROM fiscal_note_line_tab
         WHERE company = company_
         AND fiscal_note_id = outgoing_fiscal_note_id_;
   $END      
BEGIN
   $IF Component_Erep_SYS.INSTALLED $THEN
      FOR line_ IN get_fiscal_note_line_info LOOP         
         fiscal_note_line_rec_.company                  := line_.company;
         fiscal_note_line_rec_.fiscal_note_id           := incoming_fiscal_note_id_;
         fiscal_note_line_rec_.fiscal_note_line_id      := Fiscal_Note_Line_API.Get_Max_Fiscal_Note_Line_Id(company_, incoming_fiscal_note_id_) + 1;
         fiscal_note_line_rec_.object_ref1              := line_.object_ref1;       
         fiscal_note_line_rec_.object_ref2              := line_.object_ref2;       
         fiscal_note_line_rec_.alt_object_ref1          := outgoing_fiscal_note_id_;
         fiscal_note_line_rec_.alt_object_ref2          := NULL;         
         fiscal_note_line_rec_.alt_object_ref3          := NULL;     
         fiscal_note_line_rec_.part_no                  := line_.part_no;         
         fiscal_note_line_rec_.part_description         := line_.part_description;         
         fiscal_note_line_rec_.gtin_series              := line_.gtin_series;
         fiscal_note_line_rec_.cest_code                := line_.cest_code;
         fiscal_note_line_rec_.gtin_no                  := line_.gtin_no;         
         fiscal_note_line_rec_.statistical_code         := line_.statistical_code;
         fiscal_note_line_rec_.business_operation       := line_.business_operation;
         fiscal_note_line_rec_.acquisition_origin       := line_.acquisition_origin;     
         fiscal_note_line_rec_.sales_uom                := line_.sales_uom;      
         fiscal_note_line_rec_.inventory_uom            := line_.inventory_uom; 
         fiscal_note_line_rec_.tax_code                 := line_.tax_code;
         fiscal_note_line_rec_.tax_calc_structure_id    := line_.tax_calc_structure_id;      
         fiscal_note_line_rec_.quantity                 := line_.quantity;
         fiscal_note_line_rec_.price                    := line_.price;         
         fiscal_note_line_rec_.price_incl_tax           := line_.price_incl_tax;      
         fiscal_note_line_rec_.net_curr_amount          := line_.net_curr_amount;
         fiscal_note_line_rec_.net_dom_amount           := line_.net_dom_amount;
         fiscal_note_line_rec_.tax_curr_amount          := line_.tax_curr_amount;
         fiscal_note_line_rec_.tax_dom_amount           := line_.tax_dom_amount;         
         fiscal_note_line_rec_.tax_document_line_text   := line_.tax_document_line_text;

         Fiscal_Note_Line_Incoming_API.Create_Fiscal_Note_Line(fiscal_note_line_rec_);
         
         Create_Incoming_Fiscal_Note_Line_Taxes___(company_, outgoing_fiscal_note_id_, line_.fiscal_note_line_id, incoming_fiscal_note_id_, fiscal_note_line_rec_.fiscal_note_line_id);
      END LOOP;
   $ELSE
      Error_SYS.Component_Not_Exist('EREP');
   $END  
END Create_Incoming_Fiscal_Note_Lines___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Creates the Outgoing Financial Note when using Manual process.
@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Outgoing_Fiscal_Note (
   company_         IN VARCHAR2,
   tax_document_no_ IN NUMBER)
IS
   fiscal_note_id_  NUMBER;
BEGIN
   $IF Component_Erep_SYS.INSTALLED $THEN
      Generate_And_Update_Off_Inv_No___(company_, tax_document_no_);
      Create_Outgoing_Fiscal_Note_Head___(fiscal_note_id_, company_, tax_document_no_);
      IF (fiscal_note_id_ IS NOT NULL) THEN 
         Create_Outgoing_Fiscal_Note_Lines___(company_, tax_document_no_, fiscal_note_id_);
         $IF Component_Invoic_SYS.INSTALLED $THEN
            IF Company_Invoice_Info_API.Get_Man_Process_Outgoing_Nf_Db(company_) = Fnd_Boolean_API.DB_FALSE THEN
               Fiscal_Note_Head_Outgoing_API.Send_Fiscal_Note(company_, fiscal_note_id_);
            END IF;
         $END
      END IF;
   $ELSE
      Error_SYS.Component_Not_Exist('EREP');
   $END 
END Create_Outgoing_Fiscal_Note;

@IgnoreUnitTest TrivialFunction
FUNCTION Fiscal_Note_Exists (
   company_             IN VARCHAR2,
   tax_document_no_     IN VARCHAR2,
   object_type_db_      IN VARCHAR2) RETURN VARCHAR2
IS
   fiscal_note_exists_  VARCHAR2(20) := 'FALSE';
BEGIN
   $IF Component_Erep_SYS.INSTALLED $THEN
      fiscal_note_exists_ := Fiscal_Note_Head_API.Fiscal_Note_Exists(company_, tax_document_no_, object_type_db_);
   $END
   RETURN fiscal_note_exists_;
END Fiscal_Note_Exists;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Tax_Document_Status (
   company_         IN VARCHAR2,
   tax_document_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Tax_Document_API.Get_State(company_, tax_document_no_);
END Get_Tax_Document_Status;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Incoming_Fiscal_Note (
   company_                   IN VARCHAR2,
   outgoing_fiscal_note_id_   IN NUMBER)
IS
   incoming_fiscal_note_id_  NUMBER;
BEGIN
   $IF Component_Erep_SYS.INSTALLED $THEN
      Create_Incoming_Fiscal_Note_Head___(incoming_fiscal_note_id_, company_, outgoing_fiscal_note_id_);
      IF(incoming_fiscal_note_id_ IS NOT NULL)THEN
         Create_Incoming_Fiscal_Note_Lines___(company_, outgoing_fiscal_note_id_, incoming_fiscal_note_id_);
      END IF;
   $ELSE
      Error_SYS.Component_Not_Exist('EREP');
   $END    
END Create_Incoming_Fiscal_Note;

-- Automatically creates the Outgoing Financial Note when 'Manually process outgoing nota fiscal' parameter is false.
@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Outgoing_Fiscal_Note (
   source_ref1_          IN  VARCHAR2,
   source_ref_type_db_   IN  VARCHAR2)
IS
   company_           VARCHAR2(20);
   true_              VARCHAR2(5):= Fnd_Boolean_API.DB_TRUE;
   tax_document_no_   NUMBER;
   
   CURSOR get_tax_document_keys IS  
      SELECT company, tax_document_no 
      FROM   tax_document_tab
      WHERE  source_ref1      = source_ref1_
      AND    source_ref_type  = source_ref_type_db_
      AND    rowstate         = 'Preliminary';
BEGIN
   $IF Component_Invoic_SYS.INSTALLED $THEN
      OPEN  get_tax_document_keys;
      FETCH get_tax_document_keys INTO company_, tax_document_no_;
      CLOSE get_tax_document_keys;
   
      IF(company_ IS NOT NULL)THEN 
         IF(Company_Invoice_Info_API.Get_Man_Process_Outgoing_Nf_Db(company_) != true_ AND Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'OUTGOING_FISCAL_NOTE') = true_
            AND Fiscal_Note_Exists(company_, TO_CHAR(tax_document_no_), 'OUT_TAX_DOCUMENT') != true_ AND Tax_Document_API.Tax_Lines_Exist(company_, tax_document_no_) = true_)THEN 
               Create_Outgoing_Fiscal_Note(company_, tax_document_no_);
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Outgoing_Fiscal_Note;

@IgnoreUnitTest TrivialFunction
FUNCTION Incoming_Tax_Document_Exist (
   company_             IN VARCHAR2,
   fiscal_note_id_      IN VARCHAR2) RETURN VARCHAR2   
IS
   outgoing_tax_doc_no_     NUMBER;
   outgoing_tax_rec_        Tax_Document_API.Public_Rec;
   $IF Component_Erep_SYS.INSTALLED $THEN
      fiscal_note_rec_         Fiscal_Note_Head_API.Public_Rec;
   $END
   incoming_tax_doc_exist_  VARCHAR2(5) := 'FALSE';
BEGIN
   $IF Component_Erep_SYS.INSTALLED $THEN
      fiscal_note_rec_ := Fiscal_Note_Head_API.Get(company_, fiscal_note_id_);
      IF(fiscal_note_rec_.object_type = Fiscal_Note_Object_Type_API.DB_INCOMING_TAX_DOCUMENT)THEN
         outgoing_tax_doc_no_    := to_number(Fiscal_Note_Head_Outgoing_API.Get_Object_Ref1(company_, to_number(fiscal_note_rec_.alt_object_ref1)));
         outgoing_tax_rec_       := Tax_Document_API.Get(company_, outgoing_tax_doc_no_);
         incoming_tax_doc_exist_ := Tax_Document_API.Check_Tax_Document_Exist(outgoing_tax_rec_.source_ref1, company_, outgoing_tax_rec_.source_ref_type, Tax_Document_Direction_API.DB_INBOUND);
      END IF;      
   $ELSE
      NULL;
   $END
   RETURN incoming_tax_doc_exist_;
END Incoming_Tax_Document_Exist;

-------------------- LU  NEW METHODS -------------------------------------
