-----------------------------------------------------------------------------
--
--  Logical unit: WhseShipmentReceiptInfo
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210928  Aabalk  SC21R2-2608, Modified Validate_Address_Type___, New, Get_Address_Type_Id, Get_Address_Type_Address_Id,
--  210928          Get_Warehouse_Address, Get_Warehouses_For_Address, Get_Warehouse_Address_Name, Get_Remote_Warehouse_Addr_Info to support project address.
--  210927  PamPlk  SC21R2-2985, Removed redundant parameter, 'addr_id_' from the method Get_Remote_Warehouse_Addr_Info.
--  210914  PamPlk  SC21R2-2341, Added the method Get_Remote_Warehouse_Addr_Info.
--  210817  PamPlk  SC21R2-2286, Added the method Get_Warehouse_Address_Name.
--  210614  SBalLK  SC21R2-1204, Added New(), Is_Warehouse_In_Address(), Get_Warehouses_For_Address() method to support auto creation of remote warehouse from service task.
--  210515  SBalLK  SC21R2-1169, Removed PartyType, PartyTypeId and PartyTypeAddressId derived columns and added AddressType, GeolocationId and GeolocationAddressIdcolumns.
--  210515          Restructured the code to make use of existing attributes instead derived attribute and make use of generated validation instead custom designed validations.
--  210211  AsZelk  SC2020R1-12405, Removed fetching * as the hard coded value for DELIVERY_TERMS, SHIP_VIA_CODE.
--  200813  AsZelk  SC2020R1-7066, Removed dynamic dependency to Invent.
--  050420  ErRalk  SC2020R1-6859, Modified Get_Remote_Wh_Receive_Case method by adding dynamic dependency for Invent.
--  191102  ErRalk  Moved code in WarehousePurchInfo.plsql into WhseShipmentReceiptInfo.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Warehouse_Id_Tab IS TABLE OF VARCHAR2(15) INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN            whse_shipment_receipt_info_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY whse_shipment_receipt_info_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   Validate_Address_Type___(oldrec_, newrec_, indrec_);
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

PROCEDURE Validate_Address_Type___(
   oldrec_                 IN            whse_shipment_receipt_info_tab%ROWTYPE,
   newrec_                 IN OUT NOCOPY whse_shipment_receipt_info_tab%ROWTYPE,
   indrec_                 IN OUT NOCOPY Indicator_Rec )
IS
   address_type_id_        VARCHAR2(30);
   address_id_             VARCHAR2(50);
BEGIN
   IF (indrec_.address_type AND Validate_SYS.Is_Changed(oldrec_.address_type, newrec_.address_type)) THEN
      SELECT 
         DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_PERSON,      newrec_.person_id,              NULL),
         DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_PERSON,      newrec_.person_address_id,      NULL),
         DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_COMPANY,     newrec_.company,                NULL),
         DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_COMPANY,     newrec_.company_address_id,     NULL),
         DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_CUSTOMER,    newrec_.customer_id,            NULL),
         DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_CUSTOMER,    newrec_.customer_address_id,    NULL),
         DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_SUPPLIER,    newrec_.supplier_id,            NULL),
         DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_SUPPLIER,    newrec_.supplier_address_id,    NULL),
         DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_GEOLOCATION, newrec_.geolocation_id,         NULL),
         TO_NUMBER(DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_GEOLOCATION, newrec_.geolocation_address_id, NULL)),
         DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_PROJECT,     newrec_.project_id,             NULL),
         DECODE(newrec_.address_type, Warehouse_Address_Type_API.DB_PROJECT,     newrec_.project_address_id,     NULL)
      INTO
         newrec_.person_id,
         newrec_.person_address_id,
         newrec_.company,
         newrec_.company_address_id,
         newrec_.customer_id,
         newrec_.customer_address_id,
         newrec_.supplier_id,
         newrec_.supplier_address_id,
         newrec_.geolocation_id,
         newrec_.geolocation_address_id,
         newrec_.project_id,
         newrec_.project_address_id
      FROM dual;
   END IF;
   
   address_type_id_  := COALESCE(newrec_.person_id, newrec_.company, newrec_.customer_id, newrec_.geolocation_id, newrec_.project_id);
   address_id_       := COALESCE(newrec_.person_address_id, newrec_.company_address_id, newrec_.customer_address_id, TO_CHAR(newrec_.geolocation_address_id), newrec_.project_address_id);
   
   IF(newrec_.address_type IS NULL AND (address_type_id_ IS NOT NULL OR address_id_ IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_,'NULLPARTYTYPE: The address type must have value.');
   END IF;
   IF (address_type_id_ IS NOT NULL AND address_id_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_,'PARTYIDWITHOUTADDRESS: A delivery address has to be specified for the :P1 entered.', Warehouse_Address_Type_API.Decode(newrec_.address_type));
   END IF;
END Validate_Address_Type___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PICKING_LEAD_TIME', 0, attr_);
   Client_SYS.Add_To_Attr('EXT_TRANSPORT_LEAD_TIME', 0, attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_LEADTIME', 0, attr_);
   Client_SYS.Add_To_Attr('INT_TRANSPORT_LEAD_TIME', 0, attr_);
   Client_SYS.Add_To_Attr('SEND_AUTO_DIS_ADV_DB', 'FALSE', attr_);
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New(
   contract_            IN VARCHAR2,
   warehouse_id_        IN VARCHAR2,
   address_type_db_     IN VARCHAR2,
   identity_            IN VARCHAR2,
   identity_address_id_ IN VARCHAR2,
   receive_case_db_     IN VARCHAR2 DEFAULT NULL,
   ship_via_code_       IN VARCHAR2 DEFAULT NULL,
   delivery_terms_      IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       whse_shipment_receipt_info_tab%ROWTYPE;
   indrec_       Indicator_Rec;
   attr_         VARCHAR2(32000);
BEGIN
   Prepare_Insert___(attr_);
   Unpack___(newrec_, indrec_, attr_);
   
   newrec_.contract     := contract_;
   newrec_.warehouse_id := warehouse_id_;
   newrec_.address_type := address_type_db_;
   
   IF (address_type_db_ = Warehouse_Address_Type_API.DB_COMPANY) THEN
      newrec_.company                := identity_;
      newrec_.company_address_id     := identity_address_id_;
   ELSIF (address_type_db_ = Warehouse_Address_Type_API.DB_CUSTOMER) THEN
      newrec_.customer_id            := identity_;
      newrec_.customer_address_id    := identity_address_id_;
   ELSIF (address_type_db_ = Warehouse_Address_Type_API.DB_PERSON) THEN
      newrec_.person_id              := identity_;
      newrec_.person_address_id      := identity_address_id_;
   ELSIF (address_type_db_ = Warehouse_Address_Type_API.DB_SUPPLIER) THEN
      newrec_.supplier_id            := identity_;
      newrec_.supplier_address_id    := identity_address_id_;
   ELSIF (address_type_db_ = Warehouse_Address_Type_API.DB_GEOLOCATION) THEN
      newrec_.geolocation_id         := identity_;
      newrec_.geolocation_address_id := identity_address_id_;
   ELSIF (address_type_db_ = Warehouse_Address_Type_API.DB_PROJECT) THEN
      newrec_.project_id             := identity_;
      newrec_.project_address_id     := identity_address_id_;
   END IF;
   
   newrec_.receive_case    := receive_case_db_;
   newrec_.ship_via_code   := ship_via_code_;
   newrec_.delivery_terms  := delivery_terms_;
   
   New___(newrec_);
END New;

@UncheckedAccess
FUNCTION Get_Address_Type_Id (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   address_type_id_ VARCHAR2(30);
   whse_rec_        Public_Rec;
BEGIN
   whse_rec_ := Get(contract_, warehouse_id_);
   IF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_COMPANY) THEN
      address_type_id_ := whse_rec_.company;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_CUSTOMER) THEN
      address_type_id_ := whse_rec_.customer_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_PERSON) THEN
      address_type_id_ := whse_rec_.person_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_SUPPLIER) THEN
      address_type_id_ := whse_rec_.supplier_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_GEOLOCATION) THEN
      address_type_id_ := whse_rec_.geolocation_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_PROJECT) THEN
      address_type_id_ := whse_rec_.project_id;
   END IF;
   RETURN address_type_id_;
END Get_Address_Type_Id;

@UncheckedAccess
FUNCTION Get_Address_Type_Address_Id (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   address_id_ VARCHAR2(50);
   whse_rec_   Public_Rec;
BEGIN
   whse_rec_ := Get(contract_, warehouse_id_);
   IF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_COMPANY) THEN
      address_id_ := whse_rec_.company_address_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_CUSTOMER) THEN
      address_id_ := whse_rec_.customer_address_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_PERSON) THEN
      address_id_ := whse_rec_.person_address_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_SUPPLIER) THEN
      address_id_ := whse_rec_.supplier_address_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_GEOLOCATION) THEN
      address_id_ := whse_rec_.geolocation_address_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_PROJECT) THEN
      address_id_ := whse_rec_.project_address_id;
   END IF;
   RETURN address_id_;
END Get_Address_Type_Address_Id;

@UncheckedAccess  
PROCEDURE Get_Warehouse_Address (
   address_type_  OUT VARCHAR2,
   identity_      OUT VARCHAR2,
   address_id_    OUT VARCHAR2,
   contract_      IN VARCHAR2,
   warehouse_id_  IN VARCHAR2 ) 
IS
   whse_rec_    Public_Rec;
BEGIN
   whse_rec_ := Get(contract_, warehouse_id_);
   IF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_COMPANY) THEN
      address_type_ := Warehouse_Address_Type_API.Decode(Warehouse_Address_Type_API.DB_COMPANY);
      identity_     := whse_rec_.company;
      address_id_   := whse_rec_.company_address_id;
  ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_CUSTOMER) THEN
      address_type_ := Warehouse_Address_Type_API.Decode(Warehouse_Address_Type_API.DB_CUSTOMER);
      identity_     := whse_rec_.customer_id;
      address_id_   := whse_rec_.customer_address_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_PERSON) THEN
      address_type_ := Warehouse_Address_Type_API.Decode(Warehouse_Address_Type_API.DB_PERSON);
      identity_     := whse_rec_.person_id;
      address_id_   := whse_rec_.person_address_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_SUPPLIER) THEN
      address_type_ := Warehouse_Address_Type_API.Decode(Warehouse_Address_Type_API.DB_SUPPLIER);
      identity_     := whse_rec_.supplier_id;
      address_id_   := whse_rec_.supplier_address_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_GEOLOCATION) THEN
      address_type_ := Warehouse_Address_Type_API.Decode(Warehouse_Address_Type_API.DB_GEOLOCATION);
      identity_     := whse_rec_.geolocation_id;
      address_id_   := whse_rec_.geolocation_address_id;
   ELSIF (whse_rec_.address_type = Warehouse_Address_Type_API.DB_PROJECT) THEN
      address_type_ := Warehouse_Address_Type_API.Decode(Warehouse_Address_Type_API.DB_PROJECT);
      identity_     := whse_rec_.project_id;
      address_id_   := whse_rec_.project_address_id;
   ELSE
      address_type_ := NULL;
      identity_     := NULL;
      address_id_   := NULL;
   END IF;
END Get_Warehouse_Address;

@UncheckedAccess
FUNCTION Get_Remote_Wh_Receive_Case (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   receive_case_db_ VARCHAR2(20) := NULL;
   receive_case_    VARCHAR2(100) := NULL;
   
   CURSOR get_recieve_case IS
      SELECT receive_case
      FROM   whse_shipment_receipt_info_tab
      WHERE  contract = contract_
      AND    warehouse_id = warehouse_id_;
BEGIN
   IF (Warehouse_API.Is_Remote(contract_, warehouse_id_) = 'TRUE') THEN
      OPEN get_recieve_case;
      FETCH get_recieve_case INTO receive_case_db_;
      CLOSE get_recieve_case;      
      receive_case_ := Receive_Case_API.Decode(receive_case_db_);
   END IF; 
   
   RETURN receive_case_;
END Get_Remote_Wh_Receive_Case;

FUNCTION Is_Warehouse_In_Address(
   contract_         IN VARCHAR2,
   warehouse_id_     IN VARCHAR2,
   address_type_db_  IN VARCHAR2,
   address_type_id_  IN VARCHAR2,
   address_id_       IN VARCHAR2 ) RETURN BOOLEAN
IS
   warehouse_id_tab_    Warehouse_Id_Tab;
   warehouse_in_address_ BOOLEAN := FALSE;
BEGIN
   warehouse_id_tab_ := Get_Warehouses_For_Address(contract_, address_type_db_, address_type_id_, address_id_);
   IF (warehouse_id_tab_.COUNT > 0) THEN
      FOR i_ IN warehouse_id_tab_.FIRST..warehouse_id_tab_.LAST LOOP
         IF(warehouse_id_tab_(i_) = warehouse_id_) THEN
            warehouse_in_address_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN warehouse_in_address_;
END Is_Warehouse_In_Address;

FUNCTION Get_Warehouses_For_Address(
   contract_         IN VARCHAR2,
   address_type_db_  IN VARCHAR2,
   address_type_id_  IN VARCHAR2,
   address_id_       IN VARCHAR2 ) RETURN Warehouse_Id_Tab
IS
   CURSOR get_warehouses_for_company IS
      SELECT warehouse_id
      FROM  whse_shipment_receipt_info_tab
      WHERE contract           = contract_
      AND   address_type       = Warehouse_Address_Type_API.DB_COMPANY
      AND   company            = address_type_id_
      AND   company_address_id = address_id_;
      
   CURSOR get_warehouses_for_person IS
      SELECT warehouse_id
      FROM  whse_shipment_receipt_info_tab
      WHERE contract          = contract_
      AND   address_type      = Warehouse_Address_Type_API.DB_PERSON
      AND   person_id         = address_type_id_
      AND   person_address_id = address_id_;
      
   CURSOR get_warehouses_for_customer IS
      SELECT warehouse_id
      FROM  whse_shipment_receipt_info_tab
      WHERE contract            = contract_
      AND   address_type        = Warehouse_Address_Type_API.DB_CUSTOMER
      AND   customer_id         = address_type_id_
      AND   customer_address_id = address_id_;
      
   CURSOR get_warehouses_for_supplier IS
      SELECT warehouse_id
      FROM  whse_shipment_receipt_info_tab
      WHERE contract            = contract_
      AND   address_type        = Warehouse_Address_Type_API.DB_SUPPLIER
      AND   supplier_id         = address_type_id_
      AND   supplier_address_id = address_id_;
        
   CURSOR get_warehouses_for_geolocation IS
      SELECT warehouse_id
      FROM  whse_shipment_receipt_info_tab
      WHERE contract               = contract_
      AND   address_type           = Warehouse_Address_Type_API.DB_GEOLOCATION
      AND   geolocation_id         = address_type_id_
      AND   geolocation_address_id = address_id_;
      
   CURSOR get_warehouses_for_project IS
      SELECT warehouse_id
      FROM  whse_shipment_receipt_info_tab
      WHERE contract               = contract_
      AND   address_type           = Warehouse_Address_Type_API.DB_PROJECT
      AND   project_id             = address_type_id_
      AND   project_address_id     = address_id_;

   warehouse_id_list_ Warehouse_Id_Tab;
BEGIN
   IF (address_type_db_ = Warehouse_Address_Type_API.DB_COMPANY) THEN
      OPEN get_warehouses_for_company;
      FETCH get_warehouses_for_company BULK COLLECT INTO warehouse_id_list_;
      CLOSE get_warehouses_for_company;
   ELSIF (address_type_db_ = Warehouse_Address_Type_API.DB_PERSON) THEN
      OPEN get_warehouses_for_person;
      FETCH get_warehouses_for_person BULK COLLECT INTO warehouse_id_list_;
      CLOSE get_warehouses_for_person;
   ELSIF (address_type_db_ = Warehouse_Address_Type_API.DB_CUSTOMER) THEN
      OPEN get_warehouses_for_customer;
      FETCH get_warehouses_for_customer BULK COLLECT INTO warehouse_id_list_;
      CLOSE get_warehouses_for_customer;
   ELSIF (address_type_db_ = Warehouse_Address_Type_API.DB_SUPPLIER) THEN
      OPEN get_warehouses_for_supplier;
      FETCH get_warehouses_for_supplier BULK COLLECT INTO warehouse_id_list_;
      CLOSE get_warehouses_for_supplier;
   ELSIF (address_type_db_ = Warehouse_Address_Type_API.DB_GEOLOCATION) THEN
      OPEN get_warehouses_for_geolocation;
      FETCH get_warehouses_for_geolocation BULK COLLECT INTO warehouse_id_list_;
      CLOSE get_warehouses_for_geolocation;
   ELSIF (address_type_db_ = Warehouse_Address_Type_API.DB_PROJECT) THEN
      OPEN get_warehouses_for_project;
      FETCH get_warehouses_for_project BULK COLLECT INTO warehouse_id_list_;
      CLOSE get_warehouses_for_project;
   END IF;

   RETURN warehouse_id_list_;
END Get_Warehouses_For_Address;

FUNCTION Get_Warehouse_Address_Name (
   warehouse_id_  IN VARCHAR2,
   addr_id_       IN VARCHAR2) RETURN VARCHAR2
IS 
   addr_name_            VARCHAR2(100);
   addr_type_            VARCHAR2(100);
   addr_type_db_         VARCHAR2(100);
   addr_type_identity_   VARCHAR2(20);
   remote_wh_addr_id_    VARCHAR2(50);
   warehouse_rec_        Warehouse_API.Public_Rec;
BEGIN
   warehouse_rec_ := Warehouse_API.Get(warehouse_id_);  
   Get_Warehouse_Address(addr_type_, addr_type_identity_, remote_wh_addr_id_, warehouse_rec_.contract, warehouse_rec_.warehouse_id);
   addr_type_db_ := Warehouse_Address_Type_API.Encode(addr_type_); 
   IF (addr_type_db_ = Warehouse_Address_Type_API.DB_COMPANY) THEN
      addr_name_ :=   Company_Address_Deliv_Info_API.Get_Address_Name(addr_type_identity_, addr_id_);
   ELSIF (addr_type_db_ = Warehouse_Address_Type_API.DB_CUSTOMER) THEN
      addr_name_ := Customer_Info_Address_API.Get_Name(addr_type_identity_, addr_id_);
   ELSIF (addr_type_db_ = Warehouse_Address_Type_API.DB_SUPPLIER) THEN
      addr_name_ := Supplier_Info_Address_API.Get_Name(addr_type_identity_, addr_id_);
   ELSIF (addr_type_db_ = Warehouse_Address_Type_API.DB_PERSON) THEN
      addr_name_ := Person_Info_API.Get_Name(addr_type_identity_);
   ELSIF (addr_type_db_ = Warehouse_Address_Type_API.DB_GEOLOCATION) THEN
      $IF Component_Loc_SYS.INSTALLED $THEN
         addr_name_ := Location_API.Get_Name(addr_type_identity_);
      $ELSE
         NULL;
      $END
   ELSIF (addr_type_db_ = Warehouse_Address_Type_API.DB_PROJECT) THEN
      $IF Component_Proj_SYS.INSTALLED $THEN
         addr_name_ := Project_Address_API.Get_Address_Name(addr_type_identity_, addr_id_);
      $ELSE
         NULL;
      $END
   END IF; 
   RETURN addr_name_;
END Get_Warehouse_Address_Name;

PROCEDURE  Get_Remote_Warehouse_Addr_Info(
   name_                OUT VARCHAR2,
   address1_            OUT VARCHAR2, 
   address2_            OUT VARCHAR2,  
   address3_            OUT VARCHAR2, 
   address4_            OUT VARCHAR2,  
   address5_            OUT VARCHAR2, 
   address6_            OUT VARCHAR2,  
   zip_code_            OUT VARCHAR2, 
   city_                OUT VARCHAR2, 
   state_               OUT VARCHAR2, 
   county_              OUT VARCHAR2, 
   country_             OUT VARCHAR2, 
   country_desc_        OUT VARCHAR2,
   reference_           OUT VARCHAR2,
   global_warehouse_id_ IN  VARCHAR2)
IS
   company_addr_deliv_info_rec_  Company_Address_Deliv_Info_API.Public_Rec;
   warehouse_rec_                Warehouse_API.Public_Rec;
   addr_type_                    VARCHAR2(100);
   addr_type_db_                 VARCHAR2(100);
   addr_type_identity_           VARCHAR2(20);
   remote_wh_addr_id_            VARCHAR2(50);
BEGIN
    warehouse_rec_ := Warehouse_API.Get(global_warehouse_id_);
           
         Get_Warehouse_Address(addr_type_, addr_type_identity_, remote_wh_addr_id_, warehouse_rec_.contract, warehouse_rec_.warehouse_id);   

         addr_type_db_ := Warehouse_Address_Type_API.Encode(addr_type_);
        
         IF (addr_type_db_ = Warehouse_Address_Type_API.DB_COMPANY) THEN
            DECLARE 
               addr_rec_    Company_Address_API.Public_Rec;
            BEGIN
               addr_rec_                    := Company_Address_API.Get(addr_type_identity_, remote_wh_addr_id_);
               company_addr_deliv_info_rec_ := Company_Address_Deliv_Info_API.Get(addr_type_identity_, remote_wh_addr_id_);
               name_                        := company_addr_deliv_info_rec_.address_name;
               address1_                    := addr_rec_.address1;
               address2_                    := addr_rec_.address2;
               address3_                    := addr_rec_.address3;
               address4_                    := addr_rec_.address4;
               address5_                    := addr_rec_.address5;
               address6_                    := addr_rec_.address6;
               city_                        := addr_rec_.city;
               zip_code_                    := addr_rec_.zip_code;
               state_                       := addr_rec_.state;
               county_                      := addr_rec_.county;
               country_                     := addr_rec_.country;
               reference_                   := company_addr_deliv_info_rec_.contact;
            END;
         ELSIF (addr_type_db_ = Warehouse_Address_Type_API.DB_CUSTOMER) THEN
            DECLARE 
               addr_rec_    Customer_Info_Address_API.Public_Rec;
            BEGIN
               addr_rec_            := Customer_Info_Address_API.Get(addr_type_identity_, remote_wh_addr_id_);
               name_                := NVL(addr_rec_.name, Customer_Info_API.Get_Name(addr_type_identity_));
               address1_            := addr_rec_.address1;
               address2_            := addr_rec_.address2;         
               address3_            := addr_rec_.address3;
               address4_            := addr_rec_.address4;         
               address5_            := addr_rec_.address5;
               address6_            := addr_rec_.address6;         
               city_                := addr_rec_.city;
               state_               := addr_rec_.state;
               zip_code_            := addr_rec_.zip_code;
               county_              := addr_rec_.county;
               country_             := addr_rec_.country;
               reference_           := NVL(addr_rec_.primary_contact, addr_rec_.secondary_contact);
            END;
         ELSIF (addr_type_db_ = Warehouse_Address_Type_API.DB_SUPPLIER) THEN
            DECLARE 
               addr_rec_    Supplier_Info_Address_API.Public_Rec;
            BEGIN
               addr_rec_            := Supplier_Info_Address_API.Get(addr_type_identity_, remote_wh_addr_id_);
               name_                := NVL(addr_rec_.name, Supplier_Info_API.Get_Name(addr_type_identity_));
               address1_            := addr_rec_.address1;
               address2_            := addr_rec_.address2;         
               address3_            := addr_rec_.address3;
               address4_            := addr_rec_.address4;         
               address5_            := addr_rec_.address5;
               address6_            := addr_rec_.address6;         
               city_                := addr_rec_.city;
               state_               := addr_rec_.state;
               zip_code_            := addr_rec_.zip_code;
               county_              := addr_rec_.county;
               country_             := addr_rec_.country;
               reference_           := addr_rec_.comm_id;
            END;
         ELSIF (addr_type_db_ = Warehouse_Address_Type_API.DB_PERSON) THEN
            DECLARE 
                  addr_rec_    Person_Info_Address_API.Public_Rec;
               BEGIN
                  addr_rec_  := Person_Info_Address_API.Get(addr_type_identity_, remote_wh_addr_id_);
                  name_      := Person_Info_API.Get_Name(addr_type_identity_);
                  address1_  := addr_rec_.address1;
                  address2_  := addr_rec_.address2;         
                  address3_  := addr_rec_.address3;
                  address4_  := addr_rec_.address4;         
                  address5_  := addr_rec_.address5;
                  address6_  := addr_rec_.address6;         
                  city_      := addr_rec_.city;
                  state_     := addr_rec_.state;
                  zip_code_  := addr_rec_.zip_code;
                  county_    := addr_rec_.county;
                  country_   := addr_rec_.country;
                  reference_ := addr_rec_.person_id;
               END;    
         ELSIF (addr_type_db_= Warehouse_Address_Type_API.DB_GEOLOCATION) THEN
            DECLARE 
               $IF Component_Loc_SYS.INSTALLED $THEN 
                  addr_rec_    Location_Party_Address_API.Public_Rec;
               $END
            BEGIN  
               $IF Component_Loc_SYS.INSTALLED $THEN 
                  addr_rec_  := Location_Party_Address_API.Get_Address(addr_type_identity_, remote_wh_addr_id_);
                  name_      := Location_API.Get_Name(addr_type_identity_);
                  address1_  := addr_rec_.address1;
                  address2_  := addr_rec_.address2;         
                  address3_  := addr_rec_.address3;
                  address4_  := addr_rec_.address4;         
                  address5_  := addr_rec_.address5;
                  address6_  := addr_rec_.address6;         
                  city_      := addr_rec_.city;
                  state_     := addr_rec_.state;
                  zip_code_  := addr_rec_.zip_code;
                  county_    := addr_rec_.county;
                  country_   := addr_rec_.country_code;
                  reference_ := addr_rec_.location_id;
               $ELSE
                  NULL;
               $END  
            END;
         ELSIF (addr_type_db_= Warehouse_Address_Type_API.DB_PROJECT) THEN
            DECLARE 
               $IF Component_Proj_SYS.INSTALLED $THEN 
                  addr_rec_    Project_Address_API.Public_Rec;
               $END
            BEGIN  
               $IF Component_Proj_SYS.INSTALLED $THEN 
                  addr_rec_  := Project_Address_API.Get(addr_type_identity_, remote_wh_addr_id_);
                  name_      := addr_rec_.address_name;
                  address1_  := addr_rec_.address1;
                  address2_  := addr_rec_.address2;         
                  address3_  := addr_rec_.address3;
                  address4_  := addr_rec_.address4;         
                  address5_  := addr_rec_.address5;
                  address6_  := addr_rec_.address6;         
                  city_      := addr_rec_.city;
                  state_     := addr_rec_.state;
                  zip_code_  := addr_rec_.zip_code;
                  county_    := addr_rec_.county;
                  country_   := addr_rec_.country;
                  reference_ := addr_rec_.project_id;
               $ELSE
                  NULL;
               $END  
            END;
         END IF;  
END  Get_Remote_Warehouse_Addr_Info;