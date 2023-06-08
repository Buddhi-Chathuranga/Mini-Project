-----------------------------------------------------------------------------
--
--  Logical unit: TaxDocument
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220815  MaEelk  SCDEV-13062, Mofidied Create_Inbound_Tax_Document___ to create postings when the Manual Process Incoming NF is set to FALSE
--  220815          Modified Set_Posted___. Removed the call to created Incoming Tax Document and allowed the Tax Document with zero cost allowed parts to go to posted state.   
--  220812  HasTlk  SCDEV-13093, Modified the Tax_Document_Header_Rec, Create_Tax_Document_Header___ and Get_Tax_Documnt_Header_Info___ by adding Official Document Number related attributes.
--  220801  MaEelk  SCDEV-13009, Added Shipment_Delivered.
--  220801  MaEelk  SCDEV-11408, Added Cancel_Tax_Document
--  220801  HasTlk  SCDEV-12990, Updated the Sender_Receiver_Exist method to get contract_, warehouse_id_ using Get_Keys_By_Global_Id method. Updated the Create_Tax_Document_Header___
--  220801          method to fetch values to the branch when sender_type is a Remote Warehouse.
--  220731  ApWilk  SCDEV-12176, Modified Set_Posted___(), Create_Inbound_Tax_Document___() and added Create_Incoming_Tax_Document().
--  220728  MaEelk  SCDEV-10873, Added Active_Tax_Document_Exist. Rewrote Create_Tax_Document_Allowed and made a call to Active_Tax_Document_Exist inside it. 
--  220727  DhAplk  SCDEV-11396, Added Get_Sender_Doc_Address_Id function to get document address id for different sender types.
--  220727  MaEelk  SCDEV-10915, Added Undo_Delivery___ to undo the Shipment Delivery when the outgoing Tax Document goes to Cancelled state
--  220724  MaEelk  SCDEV-11408, Added Print_Tax_Document to print and create postings for a Preliminary Outgoing Tax Document.
--  220719  HasTlk  SCDEV-11381, Added Get_Sender_Receiver_Names and Sender_Receiver_Exist methods.
--  220716  MaEelk  SCDEV-12651, Removed Fetch_External_Tax.
--  220713  MaEelk  SCDEV-11672, Added Create_Tax_Document_Allowed to check if it is allowed to create a new Tax Document. 
--  220706  HasTlk  SCDEV-11491, Added the Check_Component_A_Ref___, Modify_Official_Doc_No_Info methods and create Fetch_Component_A___ to fetch the value for component_a.
--  220610  MaEelk  SCDEV-6571, Added Get_Address_Information and Fetch_External_Tax to support fetch Avalara Tax
--  220429  HasTlk  SCDEV-7909, Added new function Tax_Lines_Exist() for check all the tax document lines have tax info.
--  220404  ApWilk  SCDEV-8105, Modified Get_Tax_Documnt_Header_Info___,Tax_Document_Header_Rec and Create_Tax_Document_Header___ to fix minor issues found when testing.
--  220329  ApWilk  SCDEV-8105, Modified Tax_Document_Header_Rec, Create_Tax_Document_Header___, Set_Posted___ and added Create_Inbound_Tax_Document___, Get_Tax_Documnt_Header_Info___,
--  220329          Get_Tax_Documnt_Line_Info___, Create_Inbound_Tax_Doc_Header___ to handle the creation logic for the Inbound Tax Document.
--  220325  NiRalk  SCDEV-8156, Added Check_Tax_Document_Exist Method.
--  220321  HasTlk  SCDEV-5603, Removed Print_Tax_Document___ method.
--  220311  MaEelk  SCDEV-6521, Modified Create_Postings___ and handled logic to correct erroneous postings too.
--  220124  MaEelk  SC21R2-4998, Added Ignore Unit Testing Annotation to Create_Postings___
--  220117  NiRalk  SC21R2-7056, Added new function Tax_Amount_Information().
--  220112  MaEelk  SC21R2-6744, Created Date was trucated before saving.
--  220110  MaEelk  SC21R2-6501, Created new methods for Create_Postings___ and Create_Vouchers___ to create postings and
--  220110          Modified Set_Posted___ to change the status to Posted if the vouches are created for the Tax Document.
--  211215  ApWilk  SC21R2-6311, Modified Create_Tax_Document_Header___() to add the contract when creating the document header.
--  211208  MaEelk  SC21R2-6474, Create_Outbound_Tax_Document as renamed as Create_Outbound_Tax_Doc_Header
--                  Create_Tax_Document___ was renamed as Create_Tax_Document_Header___.
--                  Made changes to Tax_Document_Header_Rec, Create_Outbound_Tax_Doc_Header and Create_Tax_Document_Header___.
--  211203  MaEelk  SC21R2-5544, Added methods related to state Machine.
--  211112  MaEelk  SC21R2-5533, Added logic to create to Outound Tax Document originated from a Shipment Order
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Tax_Document_Header_Rec IS RECORD (
      contract                  VARCHAR2(5),
      source_ref_type           tax_document_tab.source_ref_type%TYPE,
      source_ref1               tax_document_tab.source_ref1%TYPE,
      sender_type               tax_document_tab.sender_type%TYPE,
      sender_id                 tax_document_tab.sender_id%TYPE,
      sender_addr_id            tax_document_tab.sender_addr_id%TYPE,
      receiver_type             tax_document_tab.receiver_type%TYPE,
      receiver_id               tax_document_tab.receiver_id%TYPE,
      receiver_addr_id          tax_document_tab.receiver_addr_id%TYPE,
      receiver_address_name     tax_document_tab.receiver_address_name%TYPE,
      receiver_address1         tax_document_tab.receiver_address1%TYPE,
      receiver_address2         tax_document_tab.receiver_address2%TYPE,
      receiver_address3         tax_document_tab.receiver_address3%TYPE,
      receiver_address4         tax_document_tab.receiver_address4%TYPE,
      receiver_address5         tax_document_tab.receiver_address5%TYPE,
      receiver_address6         tax_document_tab.receiver_address6%TYPE,
      receiver_zip_code         tax_document_tab.receiver_zip_code%TYPE,
      receiver_city             tax_document_tab.receiver_city%TYPE,
      receiver_state            tax_document_tab.receiver_state%TYPE,
      receiver_county           tax_document_tab.receiver_county%TYPE,
      receiver_country          tax_document_tab.receiver_country%TYPE,
      addr_flag                 tax_document_tab.addr_flag%TYPE,      
      document_addr_id          tax_document_tab.document_addr_id%TYPE,
      original_source_ref_type  VARCHAR2(4000),
      originating_tax_doc_no    tax_document_tab.originating_tax_doc_no%TYPE,
      tax_document_text         tax_document_tab.tax_document_text%TYPE,
      business_transaction_id   tax_document_tab.business_transaction_id%TYPE,
      component_a               tax_document_tab.component_a%TYPE,
      component_b               tax_document_tab.component_b%TYPE,
      component_c               tax_document_tab.component_c%TYPE,
      serial_number             tax_document_tab.serial_number%TYPE,
      official_document_no      tax_document_tab.official_document_no%TYPE);

TYPE tax_amount_rec  IS RECORD (
      net_amount     NUMBER,
      tax_amount     NUMBER,
      gross_amount   NUMBER);

TYPE tax_amount_arr IS TABLE OF tax_amount_rec;

TYPE Tax_Document_Addr_Rec IS RECORD (
      receiver_id               tax_document_tab.receiver_id%TYPE, 
      receiver_addr_id          tax_document_tab.receiver_addr_id%TYPE,
      receiver_address_name     tax_document_tab.receiver_address_name%TYPE,
      receiver_address1         tax_document_tab.receiver_address1%TYPE,
      receiver_address2         tax_document_tab.receiver_address2%TYPE,
      receiver_address3         tax_document_tab.receiver_address3%TYPE,
      receiver_address4         tax_document_tab.receiver_address4%TYPE,
      receiver_address5         tax_document_tab.receiver_address5%TYPE,
      receiver_address6         tax_document_tab.receiver_address6%TYPE,
      receiver_zip_code         tax_document_tab.receiver_zip_code%TYPE,
      receiver_city             tax_document_tab.receiver_city%TYPE,
      receiver_state            tax_document_tab.receiver_state%TYPE,
      receiver_county           tax_document_tab.receiver_county%TYPE,
      receiver_country          tax_document_tab.receiver_country%TYPE,
      addr_flag                 tax_document_tab.addr_flag%TYPE,
      sender_id                 tax_document_tab.sender_id%TYPE,
      sender_addr_id            tax_document_tab.sender_addr_id%TYPE,
      sender_address_name       VARCHAR2(100),
      sender_address1           VARCHAR2(35),   
      sender_address2           VARCHAR2(100),
      sender_address3           VARCHAR2(100),
      sender_address4           VARCHAR2(100),
      sender_address5           VARCHAR2(100),
      sender_address6           VARCHAR2(100),
      sender_zip_code           VARCHAR2(35),
      sender_city               VARCHAR2(35),
      sender_state              VARCHAR2(35),
      sender_county             VARCHAR2(35),
      sender_country            VARCHAR2(2),
      document_addr_id          tax_document_tab.document_addr_id%TYPE,
      document_address_name     VARCHAR2(100),      
      document_address1         VARCHAR2(35),   
      document_address2         VARCHAR2(100),
      document_address3         VARCHAR2(100),
      document_address4         VARCHAR2(100),
      document_address5         VARCHAR2(100),
      document_address6         VARCHAR2(100),
      document_zip_code         VARCHAR2(35),
      document_city             VARCHAR2(35),
      document_state            VARCHAR2(35),
      document_county           VARCHAR2(35),
      document_country          VARCHAR2(2));

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@DynamicComponentDependency INVOIC
PROCEDURE Check_Component_A_Ref___ (
   newrec_ IN OUT NOCOPY tax_document_tab%ROWTYPE )
IS
BEGIN
   IF (NOT Off_Inv_Num_Comp_Type_Val_API.Exists(newrec_.company, 'Component A', newrec_.component_a))THEN
      Error_SYS.Record_General(lu_name_, 'COMPNOTEXISTS: The entered :P1 does not exist in Official Invoice Number Components.', Off_Inv_Num_Comp_Type_API.Get_Name(newrec_.company, 'Component A'));
   END IF;
END Check_Component_A_Ref___;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Next_Tax_Document_No___ RETURN NUMBER
IS
   tax_document_no_    NUMBER;
BEGIN
  SELECT TAX_DOCUMENT_NO_SEQ.NEXTVAL INTO tax_document_no_ FROM dual; 
  RETURN tax_document_no_;
END Get_Next_Tax_Document_No___;

PROCEDURE Create_Tax_Document_Header___ (
   tax_document_no_          OUT NUMBER,   
   company_                  IN  VARCHAR2,
   tax_document_header_rec_  IN  Tax_Document_Header_Rec,
   direction_db_             IN  VARCHAR2 )
IS
   newrec_                   tax_document_tab%ROWTYPE;
   contract_                 warehouse_tab.contract%TYPE;
   warehouse_id_             warehouse_tab.warehouse_id%TYPE;   
BEGIN
   IF (tax_document_header_rec_.source_ref_type IN ('SHIPMENT')) THEN
      IF ((direction_db_ = Tax_Document_Direction_API.DB_OUTBOUND AND tax_document_header_rec_.original_source_ref_type IN ('^SHIPMENT_ORDER^'))
         OR (direction_db_ = Tax_Document_Direction_API.DB_INBOUND))THEN
         newrec_.company               := company_;
         newrec_.tax_document_no       := Get_Next_Tax_Document_No___;
         newrec_.direction             := direction_db_;
         newrec_.contract              := tax_document_header_rec_.contract;
         newrec_.source_ref_type       := tax_document_header_rec_.source_ref_type;
         newrec_.source_ref1           := tax_document_header_rec_.source_ref1;
         newrec_.created_date          := TRUNC(Site_API.Get_Site_Date(tax_document_header_rec_.contract));
         newrec_.sender_type           := tax_document_header_rec_.sender_type;
         newrec_.sender_id             := tax_document_header_rec_.sender_id;
         newrec_.sender_addr_id        := tax_document_header_rec_.sender_addr_id;
         
         IF (newrec_.sender_type = Sender_Receiver_Type_API.DB_SITE) THEN 
            contract_  :=   tax_document_header_rec_.contract;
         ELSIF (newrec_.sender_type = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
            Warehouse_API.Get_Keys_By_Global_Id(contract_, warehouse_id_, tax_document_header_rec_.sender_id);
         END IF;
         
         newrec_.branch                := Site_Discom_Info_API.Get_Branch(contract_);
         newrec_.receiver_type         := tax_document_header_rec_.receiver_type;
         newrec_.receiver_id           := tax_document_header_rec_.receiver_id;
         newrec_.receiver_addr_id      := tax_document_header_rec_.receiver_addr_id;
         newrec_.receiver_address_name := tax_document_header_rec_.receiver_address_name;
         newrec_.receiver_address1     := tax_document_header_rec_.receiver_address1;
         newrec_.receiver_address2     := tax_document_header_rec_.receiver_address2;
         newrec_.receiver_address3     := tax_document_header_rec_.receiver_address3;
         newrec_.receiver_address4     := tax_document_header_rec_.receiver_address4;
         newrec_.receiver_address5     := tax_document_header_rec_.receiver_address5;
         newrec_.receiver_address6     := tax_document_header_rec_.receiver_address6;
         newrec_.receiver_zip_code     := tax_document_header_rec_.receiver_zip_code;
         newrec_.receiver_city         := tax_document_header_rec_.receiver_city;
         newrec_.receiver_state        := tax_document_header_rec_.receiver_state;
         newrec_.receiver_county       := tax_document_header_rec_.receiver_county;
         newrec_.receiver_country      := tax_document_header_rec_.receiver_country;
         newrec_.addr_flag             := tax_document_header_rec_.addr_flag;
         newrec_.document_addr_id      := tax_document_header_rec_.document_addr_id;
         IF(direction_db_ = Tax_Document_Direction_API.DB_INBOUND) THEN
            newrec_.originating_tax_doc_no   := tax_document_header_rec_.originating_tax_doc_no;
            newrec_.tax_document_text        := tax_document_header_rec_.tax_document_text;
            newrec_.business_transaction_id  := tax_document_header_rec_.business_transaction_id;
            newrec_.component_a              := tax_document_header_rec_.component_a;
            newrec_.component_b              := tax_document_header_rec_.component_b;
            newrec_.component_c              := tax_document_header_rec_.component_c;
            newrec_.serial_number            := tax_document_header_rec_.serial_number;
            newrec_.official_document_no     := tax_document_header_rec_.official_document_no;
         END IF; 
         newrec_.component_a := Fetch_Component_A___(company_, newrec_.branch);         
         
         New___(newrec_);
         tax_document_no_              := newrec_.tax_document_no;
      ELSE
         Error_SYS.Record_General(lu_name_, 'OUTBOUNDNOTSUPPORT: Create Outbound Tax Document for :P1 is not supported', Logistics_Source_Ref_Type_API.Decode_List(tax_document_header_rec_.original_source_ref_type));        
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, 'OUTBOUNDNOTSUPPORT: Create Outbound Tax Document for :P1 is not supported', Logistics_Source_Ref_Type_API.Decode_List(tax_document_header_rec_.original_source_ref_type));
   END IF;
END Create_Tax_Document_Header___;

@IgnoreUnitTest TrivialFunction
FUNCTION Outbound_Tax_Document___ (
   rec_  IN     tax_document_tab%ROWTYPE ) RETURN BOOLEAN
IS
   
BEGIN
   RETURN (rec_.direction = Tax_Document_Direction_API.DB_OUTBOUND);
END Outbound_Tax_Document___;


@IgnoreUnitTest TrivialFunction
FUNCTION Inbound_Tax_Document___ (
   rec_  IN     tax_document_tab%ROWTYPE ) RETURN BOOLEAN
IS   
BEGIN
   RETURN (rec_.direction = Tax_Document_Direction_API.DB_INBOUND);
END Inbound_Tax_Document___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Postings___ (
   rec_  IN OUT NOCOPY tax_document_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   CURSOR get_tax_document_lines IS
   SELECT line_no
   FROM tax_document_line_tab
   WHERE tax_document_no = rec_.tax_document_no;
   
   source_ref_type_db_ VARCHAR2(20) := Tax_Source_API.DB_TAX_DOCUMENT_LINE;
   tax_direction_db_   VARCHAR2(20);
   date_applied_       DATE;
BEGIN
   IF (rec_.direction = Tax_Document_Direction_API.DB_OUTBOUND) THEN
      tax_direction_db_ := Part_Move_Tax_Direction_API.DB_SENDER;
   ELSIF (rec_.direction = Tax_Document_Direction_API.DB_INBOUND) THEN
      tax_direction_db_ := Part_Move_Tax_Direction_API.DB_RECEIVER;
   END IF;

   date_applied_ := Site_API.Get_Site_Date(rec_.contract);
   
   IF Part_Move_Tax_Accounting_API.Accounting_Have_Errors(rec_.tax_document_no,
                                                          Tax_Source_API.DB_TAX_DOCUMENT_LINE) = 'TRUE' THEN
      FOR line_rec_ IN get_tax_document_lines LOOP
         Part_Move_Tax_Accounting_API.Correct_Erroneous_Postings(rec_.tax_document_no,
                                                                 line_rec_.line_no,
                                                                 source_ref_type_db_,
                                                                 rec_.company,
                                                                 tax_direction_db_,
                                                                 rec_.contract,
                                                                 date_applied_ );
      END LOOP;
   ELSE
      FOR line_rec_ IN get_tax_document_lines LOOP         
         Part_Move_Tax_Accounting_API.Create_Postings(rec_.tax_document_no,
                                                      line_rec_.line_no,
                                                      source_ref_type_db_,
                                                      rec_.company,
                                                      tax_direction_db_,
                                                      rec_.contract,
                                                      date_applied_ );
      END LOOP;     
   END IF;
END Create_Postings___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Vouchers___ (
   rec_  IN OUT NOCOPY tax_document_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   
BEGIN
   Part_Move_Tax_Accounting_API.Create_Vouchers (rec_.company,
                                                rec_.tax_document_no,
                                                Tax_Source_API.DB_TAX_DOCUMENT_LINE );
END Create_Vouchers___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Set_Posted___ (
   rec_  IN OUT NOCOPY tax_document_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   IF (Part_Move_Tax_Accounting_API.Accounting_Have_Errors(rec_.tax_document_no,
                                                          Tax_Source_API.DB_TAX_DOCUMENT_LINE) = 'FALSE') THEN  
      Finite_State_Set___(rec_, 'Posted');
   END IF;   
END Set_Posted___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Inbound_Tax_Document___(
   incoming_tax_document_no_ OUT NUMBER,
   rec_                      IN  tax_document_tab%ROWTYPE)
IS
   tax_document_header_rec_   Tax_Document_API.Tax_Document_Header_Rec;
   incoming_tax_document_rec_ tax_document_tab%ROWTYPE;
   attr_                      VARCHAR2(2000);
BEGIN
   IF(rec_.company IS NOT NULL)THEN
      tax_document_header_rec_ := Get_Tax_Documnt_Header_Info___(rec_); 
      Create_Inbound_Tax_Doc_Header___(incoming_tax_document_no_,
                                  rec_.company,
                                  tax_document_header_rec_);
      IF (incoming_tax_document_no_ IS NOT NULL)  THEN                                                       
         Tax_Document_Line_API.Create_Inbound_Tax_Doc_Line(rec_.company,
                                                     incoming_tax_document_no_,
                                                     rec_.source_ref1,
                                                     rec_.tax_document_no);
         $IF Component_Invoic_SYS.INSTALLED $THEN
            IF (Company_Invoice_Info_API.Get_Man_Process_Incoming_Nf_Db(rec_.company) = Fnd_Boolean_API.DB_FALSE) THEN
               incoming_tax_document_rec_ := Get_Object_By_Keys___(rec_.company, incoming_tax_document_no_);
               Create_Postings___(incoming_tax_document_rec_, attr_);
               Create_Vouchers___(incoming_tax_document_rec_, attr_);
               Set_Posted___(incoming_tax_document_rec_, attr_);
            END IF;
         $ELSE
            NULL;
         $END                                                    
      END IF;                                               
   END IF;
END Create_Inbound_Tax_Document___;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Tax_Documnt_Header_Info___ (
   rec_  IN  tax_document_tab%ROWTYPE ) RETURN Tax_Document_Header_Rec
IS
   tax_document_header_rec_    Tax_Document_Header_Rec;
   warehouse_rec_              Warehouse_API.Public_Rec;
   db_site_                    VARCHAR2(20) := Sender_Receiver_Type_API.DB_SITE;
   db_warehouse_               VARCHAR2(20) := Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE;
BEGIN   
   IF(rec_.receiver_type = db_site_) THEN
      tax_document_header_rec_.contract := rec_.receiver_id;
   ELSIF(rec_.receiver_type = db_warehouse_) THEN 
      warehouse_rec_  := Warehouse_API.Get(rec_.receiver_id);
      tax_document_header_rec_.contract := warehouse_rec_.contract;
   END IF;   
   tax_document_header_rec_.source_ref_type           := rec_.source_ref_type;
   tax_document_header_rec_.source_ref1               := rec_.source_ref1;
   tax_document_header_rec_.sender_type               := rec_.sender_type;
   tax_document_header_rec_.sender_id                 := rec_.sender_id;
   tax_document_header_rec_.sender_addr_id            := rec_.sender_addr_id;
   tax_document_header_rec_.receiver_type             := rec_.receiver_type;
   tax_document_header_rec_.receiver_id               := rec_.receiver_id;
   tax_document_header_rec_.receiver_addr_id          := rec_.receiver_addr_id;
   tax_document_header_rec_.receiver_address_name     := rec_.receiver_address_name;
   tax_document_header_rec_.receiver_address1         := rec_.receiver_address1;
   tax_document_header_rec_.receiver_address2         := rec_.receiver_address2;
   tax_document_header_rec_.receiver_address3         := rec_.receiver_address3;
   tax_document_header_rec_.receiver_address4         := rec_.receiver_address4;
   tax_document_header_rec_.receiver_address5         := rec_.receiver_address5;
   tax_document_header_rec_.receiver_address6         := rec_.receiver_address6;
   tax_document_header_rec_.receiver_zip_code         := rec_.receiver_zip_code;
   tax_document_header_rec_.receiver_city             := rec_.receiver_city;
   tax_document_header_rec_.receiver_state            := rec_.receiver_state;
   tax_document_header_rec_.receiver_county           := rec_.receiver_county;
   tax_document_header_rec_.receiver_country          := rec_.receiver_country;
   tax_document_header_rec_.addr_flag                 := rec_.addr_flag;    
   tax_document_header_rec_.document_addr_id          := rec_.document_addr_id;
   tax_document_header_rec_.originating_tax_doc_no    := rec_.tax_document_no;
   tax_document_header_rec_.tax_document_text         := rec_.tax_document_text;
   tax_document_header_rec_.business_transaction_id   := rec_.business_transaction_id;
   tax_document_header_rec_.component_a               := rec_.component_a;
   tax_document_header_rec_.component_b               := rec_.component_b;
   tax_document_header_rec_.component_c               := rec_.component_c;
   tax_document_header_rec_.serial_number             := rec_.serial_number;
   tax_document_header_rec_.official_document_no      := rec_.official_document_no;
   RETURN tax_document_header_rec_;
END Get_Tax_Documnt_Header_Info___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Inbound_Tax_Doc_Header___ (
   tax_document_no_          OUT NUMBER,
   company_                  IN VARCHAR2, 
   tax_document_header_rec_  IN  Tax_Document_Header_Rec )
IS
BEGIN
   Create_Tax_Document_Header___ (tax_document_no_,
                                     company_,
                                     tax_document_header_rec_,
                                     Tax_Document_Direction_API.DB_INBOUND);
   
END Create_Inbound_Tax_Doc_Header___;

@IgnoreUnitTest TrivialFunction
FUNCTION Fetch_Component_A___(
   company_           IN VARCHAR2,
   branch_            IN VARCHAR2) RETURN VARCHAR2
IS
   component_a_       VARCHAR2(50);
BEGIN
   $IF Component_Invoic_SYS.INSTALLED $THEN  
      component_a_ := Off_Inv_Num_Comp_Series_API.Get_Default_Component(company_, branch_);
      RETURN component_a_; 
   $ELSE
      RETURN NULL;
   $END 
END Fetch_Component_A___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Undo_Delivery___ (
   rec_  IN OUT NOCOPY tax_document_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   
BEGIN
   IF (rec_.source_ref_type = 'SHIPMENT') THEN
      $IF Component_Shpmnt_SYS.INSTALLED $THEN
         IF (Shipment_API.Shipment_Delivered(to_number(rec_.source_ref1)) = 'TRUE') THEN
            Shipment_API.Undo_Shipment_Delivery(to_number(rec_.source_ref1));
         END IF;
      $ELSE
         NULL;
      $END  
   END IF;
END Undo_Delivery___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Outbound_Tax_Doc_Header (
   company_                  OUT VARCHAR2,
   tax_document_id_          OUT NUMBER,   
   tax_document_header_rec_  IN  Tax_Document_Header_Rec )
IS
BEGIN
   company_ := Site_API.Get_Company(tax_document_header_rec_.contract);
   IF (Company_Tax_Discom_Info_API.Get_Create_Tax_Document(company_) = 'TRUE') THEN
      Create_Tax_Document_Header___ (tax_document_id_,
                                     company_,
                                     tax_document_header_rec_,
                                     Tax_Document_Direction_API.DB_OUTBOUND);
   END IF;
END Create_Outbound_Tax_Doc_Header;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Incoming_Tax_Document (
   company_             IN VARCHAR2,
   fiscal_note_id_      IN NUMBER,
   outgoing_tax_doc_no_ IN NUMBER)
IS
   incoming_tax_document_no_  NUMBER;
   tax_document_header_rec_   tax_document_tab%ROWTYPE; 
   CURSOR get_outgoing_tax_header IS
      SELECT *
      FROM  tax_document_tab
      WHERE company = company_
      AND   tax_document_no = outgoing_tax_doc_no_;       
BEGIN
   OPEN get_outgoing_tax_header;
   FETCH get_outgoing_tax_header INTO tax_document_header_rec_;
   CLOSE get_outgoing_tax_header;
   
   IF(tax_document_header_rec_.company IS NOT NULL)THEN
      Create_Inbound_Tax_Document___(incoming_tax_document_no_, tax_document_header_rec_);
      IF(incoming_tax_document_no_ IS NOT NULL)THEN
         $IF Component_Erep_SYS.INSTALLED $THEN
            Fiscal_Note_Head_Incoming_API.Modify_Object_Ref1(company_, fiscal_note_id_, TO_CHAR(incoming_tax_document_no_));
         $ELSE
            Error_SYS.Component_Not_Exist('EREP');
         $END   
      END IF;
   END IF;  
END Create_Incoming_Tax_Document;

@IgnoreUnitTest PipelinedFunction
@UncheckedAccess
FUNCTION Tax_Amount_Information(
   company_         IN VARCHAR2,
   tax_document_no_ IN NUMBER)  RETURN tax_amount_arr PIPELINED
IS 
   rec_             tax_amount_rec;
BEGIN
   Tax_Document_Line_API.Get_Amounts (rec_.net_amount,
                                      rec_.tax_amount,
                                      rec_.gross_amount,
                                      company_,
                                      tax_document_no_);
   PIPE ROW (rec_);
END Tax_Amount_Information;


FUNCTION Check_Tax_Document_Exist(
   source_ref1_         IN VARCHAR2,
   company_             IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   direction_db_        IN VARCHAR2) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR get_tax_documents IS
      SELECT 1
      FROM   tax_document_tab
      WHERE  source_ref1 = source_ref1_
         AND company = company_
         AND source_ref_type = source_ref_type_db_
         AND direction = direction_db_;
BEGIN
   OPEN get_tax_documents;
   FETCH get_tax_documents INTO temp_;
   IF get_tax_documents%FOUND THEN
      CLOSE get_tax_documents;
      RETURN 'TRUE';
   END IF;
   CLOSE get_tax_documents;
   RETURN 'FALSE'; 
END Check_Tax_Document_Exist;

@IgnoreUnitTest TrivialFunction
FUNCTION Create_Tax_Document_Allowed(
   source_ref1_         IN VARCHAR2,
   company_             IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   direction_db_        IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   IF (Company_Tax_Discom_Info_API.Get_Create_Tax_Document(company_) = 'TRUE') THEN
      IF (Active_Tax_Document_Exist( source_ref1_, company_, source_ref_type_db_, direction_db_) = 'TRUE') THEN
         RETURN 'FALSE';   
      END IF;
      RETURN 'TRUE';
   END IF;
   RETURN 'FALSE'; 
END Create_Tax_Document_Allowed;

FUNCTION Tax_Lines_Exist (
   company_          IN VARCHAR2,
   tax_document_no_  IN NUMBER) RETURN VARCHAR2
IS
   tax_lines_exist_  VARCHAR2(5) := 'TRUE';
   
   CURSOR get_tax_document_lines IS
      SELECT line_no
      FROM   tax_document_line_tab
      WHERE  company = company_
      AND    tax_document_no = tax_document_no_;
BEGIN
   FOR rec_ IN get_tax_document_lines LOOP     
      IF Source_Tax_Item_API.Tax_Items_Exist(company_, Tax_Source_API.DB_TAX_DOCUMENT_LINE, tax_document_no_, rec_.line_no, '*', '*', '*') = 'FALSE' THEN
         tax_lines_exist_ := 'FALSE';
         EXIT;
      END IF;
   END LOOP;
   
   RETURN tax_lines_exist_;
   
END Tax_Lines_Exist;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Address_Information (
   company_           IN VARCHAR2,
   tax_document_no_   IN NUMBER) RETURN Tax_Document_Addr_Rec
IS
   CURSOR get_address_info IS
   SELECT   source_ref_type, 
            source_ref1,
            sender_id,
            receiver_id,
            receiver_type,
            receiver_addr_id, 
            receiver_address_name, 
            receiver_address1,
            receiver_address2,
            receiver_address3,
            receiver_address4,
            receiver_address5,
            receiver_address6,
            receiver_zip_code,
            receiver_city,
            receiver_state,
            receiver_county,
            receiver_country,
            addr_flag,
            document_addr_id
   FROM tax_document_tab
   WHERE  company = company_
   AND    tax_document_no = tax_document_no_;
      
      
   source_ref_type_       TAX_DOCUMENT_TAB.source_ref_type%TYPE;
   source_ref1_           TAX_DOCUMENT_TAB.source_ref1%TYPE;
   receiver_id_           TAX_DOCUMENT_TAB.receiver_id%TYPE;
   receiver_type_         TAX_DOCUMENT_TAB.receiver_type%TYPE;
   
   tax_document_addr_rec_ Tax_Document_Addr_Rec;
   comp_doc_addr_         Company_Address_API.Public_Rec;
   country_desc_          VARCHAR2(100);
   reference_             VARCHAR2(100);
BEGIN
   OPEN get_address_info;
   FETCH get_address_info INTO
      source_ref_type_,
      source_ref1_,
      tax_document_addr_rec_.sender_id,
      tax_document_addr_rec_.receiver_id,
      receiver_type_,
      tax_document_addr_rec_.receiver_addr_id,
      tax_document_addr_rec_.receiver_address_name,
      tax_document_addr_rec_.receiver_address1,
      tax_document_addr_rec_.receiver_address2,
      tax_document_addr_rec_.receiver_address3,
      tax_document_addr_rec_.receiver_address4,
      tax_document_addr_rec_.receiver_address5,
      tax_document_addr_rec_.receiver_address6,
      tax_document_addr_rec_.receiver_zip_code,
      tax_document_addr_rec_.receiver_city,
      tax_document_addr_rec_.receiver_state,
      tax_document_addr_rec_.receiver_county,
      tax_document_addr_rec_.receiver_country,
      tax_document_addr_rec_.addr_flag,
      tax_document_addr_rec_.document_addr_id;
   CLOSE get_address_info; 
   
   -- Sender Address Information
   IF (source_ref_type_ = 'SHIPMENT') THEN
      $IF Component_Shpmnt_SYS.INSTALLED $THEN  
         Shipment_API.Get_Sender_Address (tax_document_addr_rec_.sender_addr_id,
                                          tax_document_addr_rec_.sender_address_name,
                                          tax_document_addr_rec_.sender_address1,
                                          tax_document_addr_rec_.sender_address2,
                                          tax_document_addr_rec_.sender_address3,
                                          tax_document_addr_rec_.sender_address4,
                                          tax_document_addr_rec_.sender_address5,
                                          tax_document_addr_rec_.sender_address6,
                                          tax_document_addr_rec_.sender_zip_code,
                                          tax_document_addr_rec_.sender_city,
                                          tax_document_addr_rec_.sender_state,
                                          tax_document_addr_rec_.sender_county,
                                          tax_document_addr_rec_.sender_country,
                                          to_number(source_ref1_));
      $ELSE
         NULL;
      $END  
   END IF;
   
   -- Document Address Information
   IF (receiver_type_ = Sender_Receiver_Type_API.DB_SITE) THEN 
      comp_doc_addr_ := Company_Address_API.Get(company_, tax_document_addr_rec_.document_addr_id);
      tax_document_addr_rec_.document_address1 := comp_doc_addr_.address1;
      tax_document_addr_rec_.document_address2 := comp_doc_addr_.address2;
      tax_document_addr_rec_.document_address3 := comp_doc_addr_.address3;
      tax_document_addr_rec_.document_address4 := comp_doc_addr_.address4;
      tax_document_addr_rec_.document_address5 := comp_doc_addr_.address5;
      tax_document_addr_rec_.document_address6 := comp_doc_addr_.address6;
      tax_document_addr_rec_.document_zip_code := comp_doc_addr_.zip_code;
      tax_document_addr_rec_.document_city     := comp_doc_addr_.city;
      tax_document_addr_rec_.document_state    := comp_doc_addr_.state;
      tax_document_addr_rec_.document_county   := comp_doc_addr_.county;
      tax_document_addr_rec_.document_country  := comp_doc_addr_.country;
   ELSIF (receiver_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      Whse_Shipment_Receipt_Info_API.Get_Remote_Warehouse_Addr_Info(
         tax_document_addr_rec_.document_address_name,
         tax_document_addr_rec_.document_address1, 
         tax_document_addr_rec_.document_address2,  
         tax_document_addr_rec_.document_address3, 
         tax_document_addr_rec_.document_address4,  
         tax_document_addr_rec_.document_address5, 
         tax_document_addr_rec_.document_address6,  
         tax_document_addr_rec_.document_zip_code, 
         tax_document_addr_rec_.document_city, 
         tax_document_addr_rec_.document_state, 
         tax_document_addr_rec_.document_county, 
         tax_document_addr_rec_.document_country, 
         country_desc_,
         reference_,
         receiver_id_);
   END IF;
   RETURN tax_document_addr_rec_;
END Get_Address_Information;

@IgnoreUnitTest TrivialFunction
PROCEDURE Modify_Official_Doc_No_Info (
   company_                IN VARCHAR2,
   tax_document_no_        IN NUMBER,
   component_b_            IN VARCHAR2,
   component_c_            IN VARCHAR2,
   serial_number_          IN VARCHAR2,
   official_document_no_   IN VARCHAR2)
IS
   newrec_                 tax_document_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(company_, tax_document_no_);
   newrec_.component_b          := component_b_;
   newrec_.component_c          := component_c_;
   newrec_.serial_number        := serial_number_;
   newrec_.official_document_no := official_document_no_;
   Modify___(newrec_);
END Modify_Official_Doc_No_Info; 

@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Sender_Receiver_Names(
   sender_name_      OUT VARCHAR2,
   receiver_name_    OUT VARCHAR2,
   source_ref_type_  IN  VARCHAR2,
   sender_id_        IN  VARCHAR2,
   receiver_id_      IN  VARCHAR2,
   sender_type_      IN  VARCHAR2,
   receiver_type_    IN  VARCHAR2)
IS  
BEGIN
   IF (source_ref_type_ = 'SHIPMENT')THEN 
      $IF Component_Shpmnt_SYS.INSTALLED $THEN
         sender_name_   := Shipment_Source_Utility_API.Get_Sender_Name(sender_id_, sender_type_);
         receiver_name_ := Shipment_Source_Utility_API.Get_Receiver_Name(receiver_id_, receiver_type_);
      $ELSE
         NULL;
      $END
   END IF;
END Get_Sender_Receiver_Names;

@IgnoreUnitTest TrivialFunction
PROCEDURE Sender_Receiver_Exist(
   sender_id_        IN  VARCHAR2,
   receiver_id_      IN  VARCHAR2,
   sender_type_      IN  VARCHAR2,
   receiver_type_    IN  VARCHAR2)
IS  
   contract_         warehouse_tab.contract%TYPE;
   warehouse_id_     warehouse_tab.warehouse_id%TYPE;
BEGIN
   IF (sender_type_ = 'SITE')THEN 
      Site_API.Exist(sender_id_);
   ELSIF (sender_type_ = 'REMOTE_WAREHOUSE') THEN
      Warehouse_API.Get_Keys_By_Global_Id(contract_, warehouse_id_, sender_id_);
      Warehouse_API.Exist(contract_, warehouse_id_);
   END IF;

   IF (receiver_type_ = 'SITE')THEN 
      Site_API.Exist(receiver_id_);
   ELSIF (receiver_type_ = 'REMOTE_WAREHOUSE') THEN     
      Warehouse_API.Get_Keys_By_Global_Id(contract_, warehouse_id_, receiver_id_);
      Warehouse_API.Exist(contract_, warehouse_id_);   
   END IF;
END Sender_Receiver_Exist;

@IgnoreUnitTest TrivialFunction
PROCEDURE Print_Tax_Document (
   company_                IN VARCHAR2,
   tax_document_no_        IN NUMBER )
IS
   newrec_              tax_document_tab%ROWTYPE; 
   parameter_attr_      VARCHAR2(32000);
   report_attr_         VARCHAR2(1000);
   result_key_          NUMBER;
   attr_                VARCHAR2(2000);
BEGIN
   newrec_ := Get_Object_By_Keys___(company_, tax_document_no_);
   
   IF ((newrec_.direction = Tax_Document_Direction_API.DB_OUTBOUND) AND (newrec_.rowstate = 'Preliminary'))  THEN
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Clear_Attr(report_attr_);

      Client_SYS.Add_To_Attr('TAX_DOCUMENT_NO', tax_document_no_, parameter_attr_);
      Client_SYS.Add_To_Attr('COMPANY', company_, parameter_attr_);
      Client_SYS.Add_To_Attr('REPORT_ID', 'TAX_DOCUMENT_REP', report_attr_);

      result_key_ := Report_Format_API.Create_New_Report(report_attr_, parameter_attr_, Fnd_Session_API.Get_Fnd_User);

      Finite_State_Machine___(newrec_, 'SetPrinted', attr_);
   END IF;
END Print_Tax_Document; 

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Sender_Doc_Address_Id (
   sender_id_        IN  VARCHAR2,
   sender_type_db_   IN  VARCHAR2) RETURN VARCHAR2
IS
   doc_address_id_   SITE_DISCOM_INFO_TAB.document_address_id%TYPE;
   contract_         VARCHAR2(5);
   warehouse_id_     VARCHAR2(15);
BEGIN
   IF(sender_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN     
      doc_address_id_ := Site_Discom_Info_API.Get_Document_Address_Id(sender_id_);
   ELSIF (sender_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      Warehouse_API.Get_Keys_By_Global_Id(contract_, warehouse_id_, sender_id_);
      doc_address_id_ := Site_Discom_Info_API.Get_Document_Address_Id(contract_);     
   END IF;
   RETURN doc_address_id_;
END Get_Sender_Doc_Address_Id;

FUNCTION Active_Tax_Document_Exist(
   source_ref1_         IN VARCHAR2,
   company_             IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   direction_db_        IN VARCHAR2) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR get_tax_document IS
      SELECT 1
      FROM   tax_document_tab
      WHERE  source_ref1 = source_ref1_
         AND company = company_
         AND source_ref_type = source_ref_type_db_
         AND direction = direction_db_
         AND rowstate IN ('Preliminary', 'Printed', 'Posted');
BEGIN
   OPEN get_tax_document;
   FETCH get_tax_document INTO temp_;
   IF get_tax_document%FOUND THEN
      CLOSE get_tax_document;
      RETURN 'TRUE';
   END IF;
   CLOSE get_tax_document;
   RETURN 'FALSE'; 
END Active_Tax_Document_Exist;  

@IgnoreUnitTest TrivialFunction
PROCEDURE Cancel_Tax_Document (
   company_                IN VARCHAR2,
   tax_document_no_        IN NUMBER )
IS
   newrec_              tax_document_tab%ROWTYPE; 
   attr_                VARCHAR2(2000);
BEGIN
   newrec_ := Get_Object_By_Keys___(company_, tax_document_no_);
   
   IF ((newrec_.direction = Tax_Document_Direction_API.DB_OUTBOUND) AND (newrec_.rowstate = 'Preliminary'))  THEN
      Finite_State_Machine___(newrec_, 'SetCancelled', attr_);
   END IF;
END Cancel_Tax_Document; 

@IgnoreUnitTest TrivialFunction
FUNCTION Shipment_Delivered (
   source_ref_type_db_ IN VARCHAR2,
   source_ref1_        IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   IF (source_ref_type_db_ = 'SHIPMENT') THEN
      $IF Component_Shpmnt_SYS.INSTALLED $THEN
         RETURN Shipment_API.Shipment_Delivered(source_ref1_);
      $ELSE
         RETURN 'FALSE';
      $END  
   END IF;
   RETURN 'FALSE';  
END Shipment_Delivered;
