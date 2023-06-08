-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentFreight
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170126  MaIklk  LIM-10461, Removed currency_code mandatory check from Check_Insert___(),
--  170126          becuase it should be allowed to enter a receiver id with out order specific attributes in shipment.
--  160620  MaRalk  LIM-7770, Modified method Post_Create_Auto_Ship in order to pass use_price_incl_tax_ value of the CO,
--  160620          when Site - Use Freight Charges for Shipment check box is not selected. Removed parameter receiver_id_ 
--  160620          and added use_price_incl_tax_ in Create_Default___. Modified Post_Create_Manual_Ship accordingly.
--  160607  MaRalk  LIM-7399, Added method Modify and modified Update___ in order to update the Shipment Freight record 
--  160607          when ship via code get changed.
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160606  MaRalk  LIM-7402, Removed parameters forward_agent_, forwarder_changed_ from Fetch_Freight_Info___.
--  160530  MaRalk  LIM-7402, Removed parameter forward_agent_id_ from Fetch_Freight_Info___.
--  160519  RoJalk  LIM-7467, Added Create_Freight_Info___, Create_Default___, Create_Freight_Info___, removed New and Modify.
--  160519  RoJalk  LIM-7467, Renamed Create_Or_Update to Post_Create_Auto_Ship and added Post_Create_Manual_Ship.
--  160518  RoJalk  LIM-7467, Added the method Create_Or_Update.
--  160509  MaRalk  LIM-6531, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Unpack___ (
   newrec_ IN OUT shipment_freight_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   ptr_             NUMBER;
   name_            VARCHAR2(30);
   value_           VARCHAR2(32000);
   invoice_found_   VARCHAR2(5); 
BEGIN
   IF (Shipment_API.Get_Objstate(newrec_.shipment_id) = 'Closed') THEN
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         
         IF name_ NOT IN ('FREIGHT_CHG_INVOICED_DB') THEN
           Shipment_Source_Utility_API.Validate_Update_Closed_Shipmnt(invoice_found_, newrec_.shipment_id, 'TRUE'); 
         END IF;
      END LOOP;
   END IF;
   super(newrec_, indrec_, attr_);   
END Unpack___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT shipment_freight_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   shipment_rec_        Shipment_API.Public_Rec; 
   automatic_creation_  VARCHAR2(5);
BEGIN
   shipment_rec_       := Shipment_API.Get(newrec_.shipment_id); 
   automatic_creation_ := NVL(Client_SYS.Get_Item_Value('AUTOMATIC_CREATION', attr_), 'FALSE');
   
   IF (indrec_.supply_country = FALSE) THEN
      newrec_.supply_country := Company_Site_API.Get_Country_Db(shipment_rec_.contract);
   END IF;   
   IF (indrec_.use_price_incl_tax = FALSE) OR (newrec_.use_price_incl_tax IS NULL)THEN
      newrec_.use_price_incl_tax := 'FALSE';
   END IF;   
   IF (indrec_.currency_code = FALSE) THEN
      newrec_.currency_code := Shipment_Source_Utility_API.Get_Currency_Code(shipment_rec_.receiver_id, shipment_rec_.receiver_type);
   END IF;  
   IF (indrec_.apply_fix_deliv_freight = FALSE) THEN
      newrec_.apply_fix_deliv_freight := 'FALSE';
   END IF;
   IF (indrec_.freight_chg_invoiced = FALSE) THEN
      newrec_.freight_chg_invoiced := 'FALSE';
   END IF;
   
   super(newrec_, indrec_, attr_);     
   
   IF (automatic_creation_ = 'TRUE') THEN
      Fetch_Freight_Info___(newrec_.freight_map_id,
                            newrec_.zone_id,
                            newrec_.price_list_no,
                            shipment_rec_.shipment_id,                            
                            'TRUE',                           
                            newrec_.use_price_incl_tax);                          
   END IF;
   
END Check_Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     shipment_freight_tab%ROWTYPE,
   newrec_ IN OUT shipment_freight_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS 
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);   
   IF (Shipment_API.Get_Shipment_Category_Db(newrec_.shipment_id) = 'NORMAL') THEN      
      Error_SYS.Check_Not_Null(lu_name_, 'CURRENCY_CODE', newrec_.currency_code); 
   END IF;   
   
   IF (newrec_.apply_fix_deliv_freight != oldrec_.apply_fix_deliv_freight) THEN 
      Val_Apply_Fix_Deliv_Freight(newrec_.shipment_id, Shipment_API.Get_Delivery_Terms(newrec_.shipment_id));      
   END IF;   
   
END Check_Update___;


PROCEDURE Fetch_Freight_Info___ (     
     freight_map_id_             IN OUT VARCHAR2,
     zone_id_                    IN OUT VARCHAR2,
     price_list_no_              IN OUT VARCHAR2,    
     shipment_id_                IN NUMBER,     
     fetch_from_supply_chain_    IN     VARCHAR2,
     use_price_incl_tax_         IN     VARCHAR2 )
IS
   delivery_leadtime_         NUMBER;
   freight_map_               shipment_freight_tab.freight_map_id%TYPE;
   zone_                      shipment_freight_tab.zone_id%TYPE;
   price_list_                shipment_freight_tab.price_list_no%TYPE;
   zone_info_exist_           VARCHAR2(5) := 'FALSE';
   ext_transport_calendar_id_ VARCHAR2(10);
   picking_leadtime_          NUMBER;     
   shipment_rec_              Shipment_API.Public_Rec;
   forward_agent_             VARCHAR2(20); 
BEGIN
   shipment_rec_ := Shipment_API.Get(shipment_id_); 
   IF (shipment_rec_.addr_flag = 'N') AND (fetch_from_supply_chain_ = 'TRUE') THEN
      Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes(shipment_rec_.route_id, 
                                                             forward_agent_, 
                                                             delivery_leadtime_,
                                                             ext_transport_calendar_id_,
                                                             freight_map_,
                                                             zone_,
                                                             picking_leadtime_,
                                                             shipment_rec_.shipment_type,
                                                             shipment_rec_.ship_inventory_location_no,
                                                             shipment_rec_.delivery_terms,
                                                             shipment_rec_.del_terms_location,
                                                             shipment_rec_.contract,
                                                             shipment_rec_.receiver_id,                                                             
                                                             shipment_rec_.receiver_addr_id,
                                                             shipment_rec_.addr_flag,                                                             
                                                             shipment_rec_.ship_via_code);    
   
   END IF;

   IF (freight_map_ IS NULL OR (shipment_rec_.addr_flag = 'Y')) THEN
      Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(freight_map_,
                                                        zone_,
                                                        zone_info_exist_,
                                                        shipment_rec_.contract,
                                                        shipment_rec_.ship_via_code,
                                                        shipment_rec_.receiver_zip_code,
                                                        shipment_rec_.receiver_city,
                                                        shipment_rec_.receiver_county,
                                                        shipment_rec_.receiver_state,
                                                        shipment_rec_.receiver_country);   
                                                                  
   END IF;
   IF (freight_map_ IS NOT NULL AND zone_ IS NOT NULL) THEN
      price_list_ := Freight_Price_List_API.Get_Active_Freight_List_No(shipment_rec_.contract,
                                                                       shipment_rec_.ship_via_code,
                                                                       freight_map_,
                                                                       shipment_rec_.forward_agent_id,
                                                                       use_price_incl_tax_);
   END IF;
   freight_map_id_ := freight_map_;
   zone_id_        := zone_;
   price_list_no_  := price_list_;
END Fetch_Freight_Info___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     shipment_freight_tab%ROWTYPE,
   newrec_     IN OUT shipment_freight_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   recal_freight_charges_         VARCHAR2(5);  
   calculate_shipment_charges_    VARCHAR2(5);
   ship_via_changed_              VARCHAR2(5);
   update_currency_               VARCHAR2(5):= Fnd_Boolean_API.DB_FALSE;
   update_fix_del_freight_charge_ VARCHAR2(5):= Fnd_Boolean_API.DB_FALSE;
BEGIN  
   recal_freight_charges_  := Client_SYS.Get_Item_Value('RECAL_FREIGHT_CHARGES', attr_);
   calculate_shipment_charges_  := Client_SYS.Get_Item_Value('CALCULATE_SHIPMENT_CHARGES', attr_);
   ship_via_changed_ := Client_SYS.Get_Item_Value('SHIP_VIA_CHANGED', attr_);
   
   IF ((ship_via_changed_ = Fnd_Boolean_API.DB_TRUE) OR (recal_freight_charges_ = Fnd_Boolean_API.DB_TRUE)) THEN
      Fetch_Freight_Info___(newrec_.freight_map_id,
                            newrec_.zone_id,
                            newrec_.price_list_no,
                            newrec_.shipment_id,                            
                            'TRUE',                           
                            newrec_.use_price_incl_tax); 
   END IF;                         
                            
   IF newrec_.currency_code != oldrec_.currency_code THEN
      update_currency_ := Fnd_Boolean_API.DB_TRUE;            
   END IF;
   -- Check if fix_deliv_freight should be validated.
   IF newrec_.apply_fix_deliv_freight != oldrec_.apply_fix_deliv_freight OR newrec_.fix_deliv_freight != oldrec_.fix_deliv_freight THEN
      update_fix_del_freight_charge_ := Fnd_Boolean_API.DB_TRUE;           
   END IF;  
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (recal_freight_charges_    = Fnd_Boolean_API.DB_TRUE OR
      update_currency_                 = Fnd_Boolean_API.DB_TRUE OR
      update_fix_del_freight_charge_   = Fnd_Boolean_API.DB_TRUE OR
      calculate_shipment_charges_      = Fnd_Boolean_API.DB_TRUE ) THEN
      IF(Shipment_API.Source_Ref_Type_Exist(newrec_.shipment_id, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE) THEN
         Shipment_Freight_Charge_API.Process_Freight_On_Ship_Update(newrec_.shipment_id, 
                                                                    recal_freight_charges_,
                                                                    update_currency_, 
                                                                    update_fix_del_freight_charge_, 
                                                                    calculate_shipment_charges_);                     
      END IF; 
   END IF;
END Update___;


PROCEDURE Create_Default___ (
   shipment_id_         IN NUMBER,
   contract_            IN VARCHAR2,   
   use_price_incl_tax_  IN VARCHAR2) 
IS
   attr_                    VARCHAR2(8000);
   supply_country_db_       VARCHAR2(2);   
   indrec_                  Indicator_Rec;
   newrec_                  SHIPMENT_FREIGHT_TAB%ROWTYPE;
   objid_                   SHIPMENT_FREIGHT.objid%TYPE;
   objversion_              SHIPMENT_FREIGHT.objversion%TYPE;
BEGIN
   supply_country_db_     := Company_Site_API.Get_Country_Db(contract_);  
   
   Client_SYS.Add_To_Attr('SHIPMENT_ID',           shipment_id_,           attr_);
   Client_SYS.Add_To_Attr('SUPPLY_COUNTRY_DB',     supply_country_db_,     attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', use_price_incl_tax_,    attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   
END Create_Default___;


PROCEDURE Create_Freight_Info___ (
   shipment_id_        IN NUMBER,
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   from_shipment_id_   IN NUMBER,
   use_price_incl_tax_ IN VARCHAR2,
   ship_via_code_      IN VARCHAR2,
   contract_           IN VARCHAR2,
   forward_agent_id_   IN VARCHAR2 ) 
IS
   freight_map_id_            VARCHAR2(15);
   zone_id_                   VARCHAR2(15);
   attr_                      VARCHAR2(32000);
   customer_order_line_rec_   Customer_Order_Line_API.Public_Rec;
   shipment_freight_rec_      SHIPMENT_FREIGHT_TAB%ROWTYPE;
   price_list_no_             VARCHAR2(10); 
   indrec_                    Indicator_Rec;
   newrec_                    SHIPMENT_FREIGHT_TAB%ROWTYPE;
   objid_                     SHIPMENT_FREIGHT.objid%TYPE;
   objversion_                SHIPMENT_FREIGHT.objversion%TYPE;
BEGIN  
   IF (from_shipment_id_ IS NULL) THEN
      customer_order_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      freight_map_id_          := customer_order_line_rec_.freight_map_id;
      zone_id_                 := customer_order_line_rec_.zone_id;
      price_list_no_           := Freight_Price_List_API.Get_Active_Freight_List_No(contract_,
                                                                                    ship_via_code_, 
                                                                                    customer_order_line_rec_.freight_map_id, 
                                                                                    forward_agent_id_,
                                                                                    use_price_incl_tax_);
   ELSE
      shipment_freight_rec_    := Get_Object_By_Keys___(from_shipment_id_);
      freight_map_id_          := shipment_freight_rec_.freight_map_id;
      zone_id_                 := shipment_freight_rec_.zone_id;
      price_list_no_           := shipment_freight_rec_.price_list_no;
   END IF;   
   Client_SYS.Add_To_Attr('SHIPMENT_ID',           shipment_id_,        attr_);
   Client_SYS.Add_To_Attr('FREIGHT_MAP_ID',        freight_map_id_,     attr_);
   Client_SYS.Add_To_Attr('ZONE_ID',               zone_id_,            attr_);   
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', use_price_incl_tax_, attr_);
   Client_SYS.Add_To_Attr('PRICE_LIST_NO',         price_list_no_,      attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   
END Create_Freight_Info___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public interface for creating a new shipment freight record.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   new_attr_   VARCHAR2(2000);
   newrec_     shipment_freight_tab%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Info;
   -- Retrieve the default attribute values
   Prepare_Insert___(new_attr_);

   -- Replace the default attribute values with the ones passed in the in parameter string
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;

   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);

   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;   
END New;

-- Modify
--   Public interface for modification of Shipment Freight attributes.
--   The attributes to be modified should be passed in an attribute string.
PROCEDURE Modify (
   info_        OUT    VARCHAR2,
   attr_        IN OUT VARCHAR2,
   shipment_id_ IN     VARCHAR2 )
IS
   oldrec_   shipment_freight_tab%ROWTYPE;
   newrec_   shipment_freight_tab%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(shipment_id_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   info_ := Client_SYS.Get_All_Info;
END Modify;

-- Remove_Freight_Info
--   The purpose of this method is to set freight related values to NULL.
--   Also note that mandatory fields set to have a value.
PROCEDURE Remove_Freight_Info (
   shipment_id_   IN NUMBER)
IS
   oldrec_     shipment_freight_tab%ROWTYPE;
   newrec_     shipment_freight_tab%ROWTYPE;
   
BEGIN
   IF (Check_Exist___(shipment_id_)) THEN
      oldrec_ := Get_Object_By_Keys___(shipment_id_);   
      newrec_ := oldrec_;   
      newrec_.fix_deliv_freight := NULL;
      newrec_.apply_fix_deliv_freight := Fnd_Boolean_API.DB_FALSE;
      IF (Shipment_API.Get_Shipment_Category_Db(newrec_.shipment_id) != 'NORMAL') THEN  
         newrec_.currency_code := NULL;
      END IF;
      newrec_.freight_map_id := NULL;
      newrec_.zone_id := NULL;
      newrec_.price_list_no := NULL;
      newrec_.freight_chg_invoiced := Fnd_Boolean_API.DB_FALSE;  
      Modify___(newrec_);   
   END IF;
END Remove_Freight_Info;

PROCEDURE Val_Apply_Fix_Deliv_Freight (
   shipment_id_        IN NUMBER,
   delivery_terms_     IN VARCHAR2)
IS 
   freight_rec_    Public_Rec;
BEGIN
   freight_rec_ := Get(shipment_id_);  
   IF ((freight_rec_.apply_fix_deliv_freight = 'TRUE') AND
      (delivery_terms_ IS NULL OR Order_Delivery_Term_API.Get_Calculate_Freight_Charge(delivery_terms_) = 'FALSE')) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOTUPDFIXDELFRE: In order to apply fixed delivery freight, there should be a delivery term where Calculate Freight Charge check box is selected.');
   END IF; 
END Val_Apply_Fix_Deliv_Freight;

PROCEDURE Post_Create_Auto_Ship (
   shipment_id_        IN NUMBER,
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   from_shipment_id_   IN NUMBER,
   receiver_id_        IN VARCHAR2,
   use_price_incl_tax_ IN VARCHAR2,
   ship_via_code_      IN VARCHAR2,
   contract_           IN VARCHAR2,
   forward_agent_id_   IN VARCHAR2 ) 
IS
BEGIN
   IF (Site_Discom_Info_API.get_shipment_freight_charge_db(contract_) = Fnd_Boolean_API.DB_TRUE) THEN
      Create_Freight_Info___ (shipment_id_        ,
                              order_no_           ,
                              line_no_            ,
                              rel_no_             ,
                              line_item_no_       ,
                              from_shipment_id_   ,
                              use_price_incl_tax_ ,
                              ship_via_code_      ,
                              contract_           ,
                              forward_agent_id_   ); 
   ELSE
      Create_Default___(shipment_id_, contract_, use_price_incl_tax_);
   END IF;

END Post_Create_Auto_Ship;

PROCEDURE Post_Create_Manual_Ship (
   shipment_id_   IN NUMBER,
   contract_      IN VARCHAR2,
   receiver_id_   IN VARCHAR2 ) 
IS
   use_price_incl_tax_db_   VARCHAR2(20);
BEGIN
   use_price_incl_tax_db_ := Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(receiver_id_, Site_API.Get_Company(contract_));
   Create_Default___(shipment_id_, contract_, use_price_incl_tax_db_);
END Post_Create_Manual_Ship;


PROCEDURE Update_Freight_Info (
   shipment_id_        IN NUMBER,
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER ) 
IS
   freight_map_id_            VARCHAR2(15);
   zone_id_                   VARCHAR2(15);
   attr_                      VARCHAR2(32000);
   customer_order_line_rec_   Customer_Order_Line_API.Public_Rec;
   oldrec_                    SHIPMENT_FREIGHT_TAB%ROWTYPE;
   price_list_no_             VARCHAR2(10); 
   indrec_                    Indicator_Rec;
   newrec_                    SHIPMENT_FREIGHT_TAB%ROWTYPE;
   objid_                     SHIPMENT_FREIGHT.objid%TYPE;
   objversion_                SHIPMENT_FREIGHT.objversion%TYPE;
   shipment_rec_              Shipment_API.Public_Rec;
BEGIN
   IF Check_Exist___(shipment_id_) THEN 
      Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
      oldrec_       := Lock_By_Id___(objid_, objversion_);
      shipment_rec_ := Shipment_API.Get(shipment_id_);
      IF ((oldrec_.freight_map_id IS NULL) AND 
         (Site_Discom_Info_API.get_shipment_freight_charge_db(shipment_rec_.contract) = Fnd_Boolean_API.DB_TRUE)) THEN
         
         customer_order_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_); 
         freight_map_id_          := customer_order_line_rec_.freight_map_id;
         zone_id_                 := customer_order_line_rec_.zone_id;
         price_list_no_           := Freight_Price_List_API.Get_Active_Freight_List_No(shipment_rec_.contract,
                                                                                       shipment_rec_.ship_via_code, 
                                                                                       customer_order_line_rec_.freight_map_id, 
                                                                                       shipment_rec_.forward_agent_id,
                                                                                       oldrec_.use_price_incl_tax);
         Client_SYS.Add_To_Attr('FREIGHT_MAP_ID',        freight_map_id_,     attr_);
         Client_SYS.Add_To_Attr('ZONE_ID',               zone_id_,            attr_);   
         Client_SYS.Add_To_Attr('PRICE_LIST_NO',         price_list_no_,      attr_);                                                                              

         newrec_ := oldrec_;
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_);
      END IF;  
   END IF;   
END Update_Freight_Info;
