-----------------------------------------------------------------------------
--
--  Logical unit: DispatchAdviceUtility
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220630  AsZelk  SCDEV-11970, Modified Create_Line() method to assign qty_shipped_ to shipped_qty_ for No Parts.
--  220620  Salelk  SCDEV-7837, Modified Send_Dispatch_Advice to create Dispatch_Advice_Rec for Automatic Receipt flow.
--  220505  Aabalk  SCZ-18346, Modified Create_Line so that shipped_qty_ is not incorrectly set to NULL before calculating dispatch source quantity.
--  220124  RoJalk  SC21R2-2756, Modified Create_Line to include activity seq in ITS message.
--  220122  RoJalk  SC21R2-2756, Modified Create_Line calls in Create_Handling_Unit___ to consider activity seq for shipment order.
--  220120  RoJalk  SC21R2-2756, Modified Create_Line calls from Create_Handling_Unit___, Create_Handling_Unit_Line___ to pass 0 for activity seq.
--  211206  RoJalk  SC21R2-2756, Modified Create_Line and calling places to include activity seq for Shipment Order.
--  211201  Diablk  SC21R2-6181, Modified Send_Dispatch_Advice to give error if shipment source ref type is 'Purchase Receipt Return'.
--  210708  DhAplk  SC21R2-1791, Modified Send Dispatch Advice related methods by adding null checks for collections.
--  210329  PamPlk  SC21R2-780, Modified the method Create_Header_Info___() by sending the sender_type as SUPPLIER for customer orders.
--  210302  MaEelk  SC2020r1-12727, Replaced Delivery_Note_API.Get_State with Delivery_Note_API.Get_Objstate 
--  210302          in Send_Dispatch_Advice_Head_Data___ and Create_Address_Info___.
--  210216  ChBnlk  SC2020R1-12547, Modified Create_Address_Info___() in order to set the dis_adv_rec_.forward_agent_id always
--  210216          according to the value fetched for the forward_agent_id_.
--  210122  ChBnlk  SC2020R1-12027, Restructured the SendDespatchAdvice INET_TRANS message related implementation to be more generic without depending on any entity.
--  201207  ChBnlk  SC2020R1-11729, Added media_code_ as a parameter to Create_Header_Info___ and passed it to Create_Address_Info___.
--  201201  ShVese  SC2020R1-11245, Modified Create_Line () to handle shipped qty (N02) for Shipment Order.
--  201201  ShVese  SC2020R1-11596, Modified Create_Line () to use source_ref_type_ instead of shipment_line_rec_.source_ref_type in comparisons.
--  201120  WaSalk  SC2020R1-10817, Modified Create_Address_Info___() to update alt_delnote_no_ when gelr functionalities enable.
--  201019  ChBnlk  SC2020R1-10738, Replace conditional compilation check for ITS with method Dictionary_SYS.Component_Is_Active('ITS').
--  201015  WaSalk  SC2020R1-10603, Modified Send_Dispatch_Advice() to change the Alt_delnote_no in dispatch advise massege if italy localization applicable.
--  201005  ChBnlk   SC2020R1-9656, Added error message to show when ITS is not installed.
--  200929  ChBnlk   SC2020R1-817, Modified  Send_Order_Conf_Inet_Trans___ to get json_clobs directly from generated methods.
--  200918  ChBnlk   SC2020R1-9656, Added component check ITS to execute INET_TRANS message passing related codes only when 
--  200918           ITS is istalled.
--  200914  PamPlk  SC2020R1-9733, Modified the method Create_Handling_Unit___ in order to support when one_ship_line_connected_ is FALSE.
--  200908  ChBnlk  SC2020R1-818, Added new method Create_Handling_Unit_Line___() to have the common handling unit line creation code related to all media codes.
--  200902  PamPlk  SC2020R1-9396, Modified the method Create_Struct_Info___ in Send_Dispatch_Advice by adding the missing parameter, media_code_.
--  200824  ChBnlk  SC2020R1-9418, Modified Create_Line() to set dis_adv_line_rec_.input_unit_meas from input_unit_meas_ when media code is INET_TRANS.
--  200818  ChBnlk  SC2020R1-818, Restructured the Send_Dispatch_Advice to facilitated ITS media code seperately and removed dispatch advice structure related methods.  
--  200804  RasDlk  SC2020R1-8981, Renamed the method Create_Line_From_Dis_Adv_Struct as Create_Line_From_Dis_Adv_Stct since the procedure name is longer than the allowed maximum of 30 characters.
--  200304  BudKlk  Bug 148995(SCZ-5793), Modified the Create_Address_Info___ to resize the variable consignee_ref_.
--  200713  ChBnlk  SC2020R1-818,  Reimplemented the SendDispatchAdvice ITS message with the support of entity based modelling.
--  200428  WaSalk  SC2020R1-6765, Modified Generate_Alt_Delnote__() condition to check delivery note state when sending the dispatch advise in Italian localization applicable.
--  200423  PamPlk  SC2020R1-6600, Modified the method Create_Address_Info___ in order to fetch the Sender_Id.
--  200422  PamPlk  SC2020R1-6670, Modified Create_Line() by adding NVL to customer_part_conv_factor and cust_part_invert_conv_fact in the calculation of N03.
--  200415  PamPlk  SC2020R1-2174, Modified the method, 'Create_Line' in order to pass the shipped_qty_.
--  200406  PamPlk  SC2020R1-2177, Modified the method Create_Header_Info___ in order to add the Sender Type to the header level.
--  200326  WaSalk  GESPRING20-3912, Added method call Generate_Alt_Delnote__() to apply if alt_delnote_no_chronologic localization added.
--  200316  Hahalk  Bug 152733(SCZ-9311), Modified Create_Line() by increasing the length of location_no_ field into 35.
--  200313  ErFelk  Bug 152812(SCZ-9422), Modified Create_Handling_Unit___() by removing the condition Prioritize_Reservations___();
--  200303  ErFelk  Bug 152627(SCZ-9205), Modified Create_Line() by adding NVL to customer_part_conv_factor and cust_part_invert_conv_fact in the calculation of N03.
--  191226  ThKrLk  Bug 151370(SCZ-8123), Modified Create_Line() to add D01 field, when there is a connected shipment in line.
--  191115  MeAblk  SCSPRING20-934, Increased the length of receiver_id upto 50 characters.
--  190924  RasDlk  Bug 149813(SCZ-6679), Modified Create_Handling_Unit___() to avoid duplication of serial parts in incoming dispatch advice.
--  190901  ErFelk  Bug 149269(SCZ-5459), Modified Create_Line() by using customer_part_conv_factor and cust_part_invert_conv_fact to calculate shipped_qty_ of N03.
--  190628  DiKuLk  Bug 148950(SCZ-5633), Modified Create_Top_Level_Hu___() and Create_Handling_Unit___() to handle shipment lines connected to multiple handling units.
--  190514  DiKuLk  Bug 147858(SCZ-4348), Modified Prioritize_Reservations___(), Create_Struct_Info___(), Create_Ship_Line___(), Create_Handling_Unit___() 
--  190509          and Added Create_Inventory_Line___() to handle identified parts with handling units and unidentified parts with handling units correctly.
--  181102  ErFelk  Bug 145071, Modified Create_Line() by replacing order_line_rec_.part_no with inventory_part_no_ to avoid errors when ORDER is not installed.
--  181024  ErFelk  Bug 143644, Modified Create_Line() so that N02 is not send in the message if companies are different and delivered part is not the same as ordered part.
--  180719  DiKuLk  Bug 142977, Modified Send_Dispatch_Advice() to add emailId, phoneNo, faxNo and Company AssociationNo to 'DESADV' message.
--  180109  RuLiLk   Bug 139646, Modified method Create_Disadv_Line___, Sent Shipped quantity inventory quantity only in intra company transactions
--  180108           to avoid errors in quantity due to different inventory conversion factors between companies.
--  171019  RoJalk  STRSC-12396, Added the method Prioritize_Reservations___.  
--  170515  TiRalk  LIM-11429, Modified Send_Dispatch_Advice to get the deliver_to_customer when creating dispatch advice.
--  170507  RoJalk  LIM-11457, Modified Create_Handling_Unit___ so the cursors will include both shipment id and handling unit id.
--  170507  RoJalk  Bug 132014, Modified Create_Disadv_Struct_Info___() to call Create_Disadv_Line___() only if there are reserved quantities sill left to attached in shipments 
--  170507          and all the parts attached to the shipment are serial not tracked in inventory parts.
--  170507  RoJalk  Bug 130169, Modified Create_Disadv_Struct_Info___() so that Create_Disadv_Line___() is called if there are reserved quantities sill left to attached in shipments.
--  170502  TiRalk  LIM-11429, Modified Create_Address_Info___() to fetch the correct receiver_id_ and deliv_address_id_.
--  170428  JeeJlk  Bug 135222, Modified Create_Line to fetch part description into C06 from part level instead of Shimpent line level if there is a sales part cross reference value.
--  170424  RoJalk  LIM-11421, Modified Create_Address_Info___  so the address info is fetched when sending for customer order.
--  170328  NaLrlk  LIM-11285, Modified Create_Address_Info___() to fetch the correct receiver for C05.
--  170223  MaIklk  LIM-9422, Fixed to pass shipment_line_no as parameter when calling ShipmentReservHandlUnit methods.
--  170208  NaSalk  LIM-10572, Modified Create_Line and Create_Handling_Unit___ to use char column to pass handling unit information.
--  170127  MaIklk  LIM-9825, Handled NVL for source ref columns when calling ShipmentReservHandlUnit methods.
--  161205  RoJalk  LIM-9774, Modified Create_Line and moved the order specific logic to Customer_Order_Line_API.Get_Info_For_Desadv.
--  161201  RoJalk  LIM-8323, Added the method Get_Cust_Order_Line_Info___.
--  161128  MaIklk  LIM-9255, Fixed to directly access ShipmentReservHandlUnit since it is moved to SHPMNT.
--  161128  RoJalk  LIM-9712, Modified Create_Line and used Distribution_Order_API.Get_Purchase_Order_Info.
--  161110  RoJalk  LIM-9647, Modified Create_Ship_Line___ and adjusted the conditions.
--  161107  RoJalk  LIM-8391, Replaced Shipment_Handling_Utility_API.Shipment_Structure_Exist with Shipment_API.Shipment_Structure_Exist.
--  160930  RoJalk  LIM-8056, Modified Send_Dispatch_Advice and called Shipment_API.Post_Send_Dispatch_Advice.
--  160908  LaThlk  Bug 131142, Modified Create_Line() method to fetch Purchase Part Number from relevant purchase order line when customer order originate through internal purchase order.
--  160822  RoJalk  LIM-8056, Modified Send_Dispatch_Advice and replaced Customer_Info_Msg_Setup_API.Get_Address with
--  160822          Shipment_Source_Utility_API.Get_Receiver_Msg_Setup_Addr and Customer_Info_Msg_Setup_API.Increase_Sequence_No
--  160822          with  Shipment_Source_Utility_API.Increase_Receiver_Msg_Seq_No.
--  160811  RoJalk  LIM-7965, Modified Create_Line and renamed variables from order ref to source ref.
--  160810  RoJalk  LIM-7965, Modified Create_Handling_Unit___ and included source_ref_type.
--  160810  RoJalk  LIM-8086, Modified Create_Address_Info___ and used generic methods 
--  160810          Shipment_Source_Utility_API.Get_Default_Address/Get_Ean_Location.
--  160729  RoJalk  LIM-7965, Renamed Create_Disadv_Header_Info___ to Create_Header_Info___, Create_Disadv_Address_Info___
--  160729          to Create_Address_Info___, Create_Disadv_Struct_Info___ to Create_Struct_Info___, Create_Disadv_Ship_Line___ 
--  160729          to Create_Ship_Line___, Create_Disadv_Line to  Create_Line. 
--- 160727  RoJalk  LIM-7966, Moved the LU from ORDER to SHPMNT.
--  160726  RoJalk  LIM-7967, Added the method Include_Cust_Ord_Specific___.
--  160726  RoJalk  LIM-7967, Included inventory unit of measure, shipment line no, input unit of measure in LINE segment.
--  160721  RoJalk  LIM-7967, Added dock_code, sub_dock_code, ref_id and location_no.
--  160721  RoJalk  LIM-7962, Modified Create_Disadv_Line to fetch dock_code, sub_dock_code, ref_id, location_no
--  160721          from source when sending the dispatch advice for a shipment.
--  160714  RoJalk  LIM-8101, Added the method Create_Top_Level_Hu___ and renamed Create_Disadv_Ship_Hu___ to
--  160714          Create_Handling_Unit___ to improve the order of message blocks to align with HU structure.
--  160713  RoJalk  LIM-7962, Modified Create_Disadv_Line and used Shipment_Source_Utility_API.Get_Line to fetch generic info.
--  160712  RoJalk  LIM-7956, Replaced the usage of Shipment_Reserv_Handl_Unit_API.Get_Sub_Struct_Eng_Chg_Level, Get_Sub_Struct_Lot_Batch_No
--  160712          Get_Sub_Struct_Serial_No, Get_Sub_Struct_Waiv_Dev_Rej_No with Shipment_Source_Utility_API.Get_Uniq_Struct_Eng_Chg_Level,
--  160712          Get_Uniq_Struct_Lot_Batch_No, Get_Uniq_Struct_Serial_No, .Get_Uniq_Struct_Waiv_Dev_Rej.
--  160711  RoJalk  LIM-7960, Modified Create_Disadv_Ship_Line___ and made the code generic by fetching the info from shipment line.
--  160704  MaRalk  LIM-7671, Modified method Create_Disadv_Address_Info___ 
--  160704          to reflect column renaming in Delivery_Note_API.Public_Rec.
--  160704  RoJalk  LIM-7885, Removed packge unit id, N08 from Create_Disadv_Line. Modified
--  160704          Create_Disadv_Ship_Hu___ and removed the cursors get_sub_struct_ship_line,
--  160704          get_sub_struct_ship_lines, get_sub_struct_attchd_reserv and modified get_handling_units
--  160704          to support the handling unit information as N level structure.
--  160627  Chgulk  STRLOC-249, Added new Address fields.
--  160627  RoJalk  LIM-7824, Added the method Customer_Order_Transfer_API.Create_Disadv_Struct_Info 
--  160627          moving out the code from Create_Disadv_Struct_Info___. Changed the scope of Create_Disadv_Line___ to be public.
--  160627  RoJalk  LIM-7823, Added the method Create_Disadv_Handling_Unit___.
--  160613  RoJalk  LIM-7680, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Shipment_Line_Rec IS RECORD (
   shipment_line_no       NUMBER );

TYPE Shipment_Line_Tab IS TABLE OF Shipment_Line_Rec INDEX BY PLS_INTEGER;
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Include_Cust_Ord_Specific___ (
   shipment_id_   IN NUMBER ) RETURN BOOLEAN
IS
   include_cust_ord_specific_ BOOLEAN:=FALSE;
BEGIN
   IF ((Shipment_API.Source_Ref_Type_Exist(shipment_id_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = 'TRUE')
        OR (shipment_id_ IS NULL)) THEN 
      -- dispatch advice triggered per customer order or shipment including customer order lines   
      include_cust_ord_specific_ := TRUE;  
   END IF;
   RETURN include_cust_ord_specific_;
END Include_Cust_Ord_Specific___;


FUNCTION Prioritize_Reservations___ (
   shipment_id_           IN NUMBER,
   shipment_struct_exist_ IN VARCHAR2) RETURN BOOLEAN
IS
   prioritize_reservations_   BOOLEAN := FALSE;
BEGIN
   IF (shipment_struct_exist_ = 'TRUE') THEN
      IF (Shipment_API.Any_Reciept_Issue_Serial_Part(shipment_id_))  THEN
         prioritize_reservations_ := TRUE;
      ELSE
         prioritize_reservations_ := Shipment_Source_Utility_API.Prioritize_Res_On_Desadv(shipment_id_);
      END IF;
   END IF;
   RETURN prioritize_reservations_;
END Prioritize_Reservations___;


-- Create_Header_Info___
--   Construct the dispatch advice header and address
--   information for Customer Order or Shipment.
PROCEDURE Create_Header_Info___ (
   attr_              OUT    VARCHAR2,
   message_line_      OUT    NUMBER,
   dis_adv_rec_       IN OUT Dispatch_Advice_Rec,
   delnote_no_        IN     VARCHAR2,
   message_id_        IN     NUMBER,
   delivery_rec_      IN     Delivery_Note_API.Public_Rec,
   shipment_rec_      IN     Shipment_API.Public_Rec,
   media_code_        IN     VARCHAR2,
   automatic_receipt_ IN     BOOLEAN)
IS
   shipment_id_         NUMBER;
   contract_            VARCHAR2(5);
   consignment_note_id_ VARCHAR2(50);
   actual_ship_date_    DATE := SYSDATE;
   sender_type_         VARCHAR2(20);
   
BEGIN
   message_line_  := 1;
   shipment_id_   := delivery_rec_.shipment_id;
   IF shipment_id_ IS NOT NULL THEN
      contract_            := shipment_rec_.contract;
      consignment_note_id_ := shipment_rec_.consignment_note_id;
      actual_ship_date_    := shipment_rec_.actual_ship_date;
      IF (Include_Cust_Ord_Specific___(shipment_id_)) THEN          
         $IF Component_Order_SYS.INSTALLED $THEN    
            sender_type_   :=  Sender_Receiver_Type_API.DB_SUPPLIER;
         $ELSE
            NULL;
         $END 
      ELSE
         sender_type_      := shipment_rec_.sender_type;
      END IF;
   ELSE
      $IF Component_Order_SYS.INSTALLED $THEN
         contract_         := Customer_Order_API.Get_Contract(delivery_rec_.order_no);
         sender_type_      :=  Sender_Receiver_Type_API.DB_SUPPLIER;
      $ELSE
         NULL;
      $END
   END IF;
   IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN
      dis_adv_rec_.delnote_no := delnote_no_;
      dis_adv_rec_.shipment_id := shipment_id_;
      dis_adv_rec_.actual_ship_date := actual_ship_date_;
      dis_adv_rec_.consignment_note_id := consignment_note_id_;
      dis_adv_rec_.contract := contract_;
      dis_adv_rec_.sender_type := sender_type_;
   ELSE
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('MESSAGE_ID',   message_id_,            attr_);
      Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_,          attr_);
      Client_SYS.Add_To_Attr('NAME',         'HEADER',               attr_);
      Client_SYS.Add_To_Attr('C00',          delnote_no_,            attr_); -- Delnote No
      Client_SYS.Add_To_Attr('N00',          shipment_id_,           attr_); -- Shipment ID
      Client_SYS.Add_To_Attr('D01',          actual_ship_date_,      attr_); -- Dispatch date/time
      Client_SYS.Add_To_Attr('C03',          consignment_note_id_,   attr_); -- Transport Doc Number/Consignment Note ID
      Client_SYS.Add_To_Attr('C04',          contract_,              attr_); -- Site
      Client_SYS.Add_To_Attr('C97',          sender_type_,           attr_);  
   END IF;
   
   Create_Address_Info___(attr_,
                          dis_adv_rec_,
                          delivery_rec_,
                          shipment_rec_,
                          media_code_,
                          automatic_receipt_);
END Create_Header_Info___;


-- Create_Address_Info___
--   This method constructs the address information for a dispatch advice.
-- If a change is done to either of the EDI or ITS sections of the method please
-- revisit the other section to check if the change is required there.
PROCEDURE Create_Address_Info___ (
   attr_              IN OUT VARCHAR2, 
   dis_adv_rec_       IN OUT Dispatch_Advice_Rec,
   delivery_rec_      IN     Delivery_Note_API.Public_Rec,
   shipment_rec_      IN     Shipment_API.Public_Rec,
   media_code_        IN     VARCHAR2,
   automatic_receipt_ IN     BOOLEAN)
IS
   
   shipment_id_             NUMBER;
   contract_                VARCHAR2(5);
   receiver_id_             VARCHAR2(50);
   ship_addr_no_            VARCHAR2(50);
   consignee_ref_           VARCHAR2(100);
   customer_no_pay_         VARCHAR2(20);
   forward_agent_id_        VARCHAR2(20);
   forwarder_addr_id_       VARCHAR2(50);
   delivery_terms_          VARCHAR2(5);
   delivery_terms_desc_     VARCHAR2(35);
   del_terms_location_      VARCHAR2(2000);
   ship_via_code_           VARCHAR2(3);
   ship_via_desc_           VARCHAR2(35);
   company_addr_id_         COMPANY_ADDRESS_PUB.address_id%TYPE;
   comp_addr_rec_           Company_Address_API.Public_Rec;
   receiver_name_           VARCHAR2(100);
   cust_addr_rec_           Customer_Info_Address_API.Public_Rec;
   ean_doc_addr_            VARCHAR2(2000);
   ean_del_addr_            VARCHAR2(2000);
   ean_pay_addr_            VARCHAR2(2000);
   address_id_              VARCHAR2(50);
   deliv_address_id_        VARCHAR2(50);
   company_                 VARCHAR2(20);
   language_code_           VARCHAR2(2);
   forwaddr_rec_            Forwarder_Info_Address_API.Public_Rec;
   net_total_               NUMBER := 0;
   gross_total_             NUMBER := 0;
   total_volume_            NUMBER := 0;
   comp_dist_rec_           Company_Invent_Info_API.Public_Rec;
   receiver_address1_       VARCHAR2(35);
   receiver_address2_       VARCHAR2(35);
   receiver_address3_       VARCHAR2(100);
   receiver_address4_       VARCHAR2(100);         
   receiver_address5_       VARCHAR2(100);
   receiver_address6_       VARCHAR2(100);        
   receiver_city_           VARCHAR2(35);
   receiver_state_          VARCHAR2(35);
   receiver_zip_code_       VARCHAR2(35);
   receiver_county_         VARCHAR2(35);
   receiver_country_        VARCHAR2(2);
   receiver_country_desc_   VARCHAR2(740);   
   receiver_type_           VARCHAR2(20); 
   company_name_            VARCHAR2(1000);
   sender_                  VARCHAR2(50);
   forwarder_name_          VARCHAR2(100);    
   alt_delnote_no_          VARCHAR2(50);   
   $IF Component_Order_SYS.INSTALLED $THEN  
      cross_ref_rec_        Cust_Addr_Cross_reference_API.Public_Rec;
      order_rec_            Customer_Order_API.Public_Rec; 
   $END
   top_level_hu_count_      NUMBER;
   second_level_hu_count_   NUMBER;
BEGIN
   shipment_id_   := delivery_rec_.shipment_id;
   IF shipment_id_ IS NULL THEN
      $IF Component_Order_SYS.INSTALLED $THEN  
         order_rec_           := Customer_Order_API.Get(delivery_rec_.order_no);
         contract_            := order_rec_.contract;         
         consignee_ref_       := order_rec_.cust_ref; 
         customer_no_pay_     := order_rec_.customer_no_pay;         
         language_code_       := order_rec_.language_code;  
      $END
      receiver_id_         := delivery_rec_.receiver_id;
      ship_addr_no_        := delivery_rec_.receiver_addr_id;
      deliv_address_id_    := delivery_rec_.receiver_addr_id;
      forward_agent_id_    := delivery_rec_.forward_agent_id;
      delivery_terms_      := delivery_rec_.delivery_terms;
      ship_via_code_       := delivery_rec_.ship_via_code;
      del_terms_location_  := delivery_rec_.del_terms_location;
      receiver_type_       := Sender_Receiver_Type_API.DB_CUSTOMER; 
   ELSE
      contract_            := shipment_rec_.contract;
      receiver_id_         := shipment_rec_.receiver_id;
      ship_addr_no_        := shipment_rec_.receiver_addr_id;
      consignee_ref_       := shipment_rec_.receiver_reference;
      language_code_       := shipment_rec_.language_code;      
      forward_agent_id_    := shipment_rec_.forward_agent_id;
      delivery_terms_      := shipment_rec_.delivery_terms;
      ship_via_code_       := shipment_rec_.ship_via_code;
      deliv_address_id_    := shipment_rec_.receiver_addr_id;
      del_terms_location_  := shipment_rec_.del_terms_location; 
      receiver_type_       := shipment_rec_.receiver_type;
      
      IF (Include_Cust_Ord_Specific___(shipment_id_)) THEN          
         $IF Component_Order_SYS.INSTALLED $THEN    
            customer_no_pay_ := Cust_Ord_Customer_API.Get_Customer_No_Pay(receiver_id_);
         $ELSE
            NULL;
         $END 
      END IF;
   END IF;
   delivery_terms_desc_ := Order_Delivery_Term_API.Get_Description(delivery_terms_, language_code_);
   ship_via_desc_       := Mpccom_Ship_Via_API.Get_Description(ship_via_code_, language_code_);
   company_             := Site_API.Get_Company(contract_);
   
   IF shipment_id_ IS NULL  THEN
      company_addr_id_ := Company_Address_Type_API.Get_Company_Address_Id(company_, Address_Type_Code_API.Decode('DELIVERY'), 'TRUE');
      comp_addr_rec_   := Company_Address_API.Get(company_, company_addr_id_);
      company_name_ :=  Company_API.Get_Name(company_);
      
      IF media_code_ = 'INET_TRANS' THEN
         dis_adv_rec_.sender_name := company_name_;
         dis_adv_rec_.sender_address1 :=  comp_addr_rec_.address1;
         dis_adv_rec_.sender_address2 :=  comp_addr_rec_.address2; 
         dis_adv_rec_.sender_address3 :=  comp_addr_rec_.address3; 
         dis_adv_rec_.sender_address4 :=  comp_addr_rec_.address4; 
         dis_adv_rec_.sender_address5 :=  comp_addr_rec_.address5; 
         dis_adv_rec_.sender_address6 :=  comp_addr_rec_.address6; 
         dis_adv_rec_.sender_zip_code :=  comp_addr_rec_.zip_code;
         dis_adv_rec_.sender_city     :=  comp_addr_rec_.city;
         dis_adv_rec_.sender_county   :=  comp_addr_rec_.county;
         dis_adv_rec_.sender_state    :=  comp_addr_rec_.state;
         dis_adv_rec_.sender_country  :=  comp_addr_rec_.country;
         dis_adv_rec_.sender_reference := '';  
      ELSE
         Client_SYS.Add_To_Attr('C06', company_name_,      attr_); -- Consignor address
         Client_SYS.Add_To_Attr('C07', comp_addr_rec_.address1,             attr_);
         Client_SYS.Add_To_Attr('C08', comp_addr_rec_.address2,             attr_);
         Client_SYS.Add_To_Attr('C52', comp_addr_rec_.address3,             attr_);
         Client_SYS.Add_To_Attr('C53', comp_addr_rec_.address4,             attr_);
         Client_SYS.Add_To_Attr('C54', comp_addr_rec_.address5,             attr_);
         Client_SYS.Add_To_Attr('C55', comp_addr_rec_.address6,             attr_);
         Client_SYS.Add_To_Attr('C09', comp_addr_rec_.zip_code,             attr_);
         Client_SYS.Add_To_Attr('C10', comp_addr_rec_.city,                 attr_);
         Client_SYS.Add_To_Attr('C11', comp_addr_rec_.county,               attr_);
         Client_SYS.Add_To_Attr('C12', comp_addr_rec_.state,                attr_);
         Client_SYS.Add_To_Attr('C13', comp_addr_rec_.country,              attr_);
         Client_SYS.Add_To_Attr('C14', '',                                  attr_); -- Sender reference */
      END IF;
   ELSE
      IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN
         dis_adv_rec_.sender_name := shipment_rec_.sender_name;
         dis_adv_rec_.sender_address1 :=  shipment_rec_.sender_address1;
         dis_adv_rec_.sender_address2 :=  shipment_rec_.sender_address2; 
         dis_adv_rec_.sender_address3 :=  shipment_rec_.sender_address3; 
         dis_adv_rec_.sender_address4 :=  shipment_rec_.sender_address4; 
         dis_adv_rec_.sender_address5 :=  shipment_rec_.sender_address5; 
         dis_adv_rec_.sender_address6 :=  shipment_rec_.sender_address6; 
         dis_adv_rec_.sender_zip_code :=  shipment_rec_.sender_zip_code;
         dis_adv_rec_.sender_city     :=  shipment_rec_.sender_city;
         dis_adv_rec_.sender_county   :=  shipment_rec_.sender_county;
         dis_adv_rec_.sender_state    :=  shipment_rec_.sender_state;
         dis_adv_rec_.sender_country  :=  shipment_rec_.sender_country;
         dis_adv_rec_.sender_reference := shipment_rec_.sender_reference;
      ELSE 
         Client_SYS.Add_To_Attr('C06', shipment_rec_.sender_name,          attr_); -- Consignor address
         Client_SYS.Add_To_Attr('C07', shipment_rec_.sender_address1,      attr_);
         Client_SYS.Add_To_Attr('C08', shipment_rec_.sender_address2,      attr_);
         Client_SYS.Add_To_Attr('C52', shipment_rec_.sender_address3,      attr_);
         Client_SYS.Add_To_Attr('C53', shipment_rec_.sender_address4,      attr_);
         Client_SYS.Add_To_Attr('C54', shipment_rec_.sender_address5,      attr_);
         Client_SYS.Add_To_Attr('C55', shipment_rec_.sender_address6,      attr_);
         Client_SYS.Add_To_Attr('C09', shipment_rec_.sender_zip_code,      attr_);
         Client_SYS.Add_To_Attr('C10', shipment_rec_.sender_city,          attr_);
         Client_SYS.Add_To_Attr('C11', shipment_rec_.sender_county,        attr_);
         Client_SYS.Add_To_Attr('C12', shipment_rec_.sender_state,         attr_);
         Client_SYS.Add_To_Attr('C13', shipment_rec_.sender_country,       attr_);
         Client_SYS.Add_To_Attr('C14', shipment_rec_.sender_reference,     attr_); -- Sender reference 
      END IF;
   END IF;
   
   Trace_SYS.Message('Single occurence address...');
   -- Set single occurence address (only used in the small message).
   IF (shipment_id_ IS NULL) THEN 
      IF (delivery_rec_.single_occ_addr_flag = 'Y') THEN
         receiver_name_     := delivery_rec_.receiver_addr_name;
         receiver_address1_ := delivery_rec_.receiver_address1;
         receiver_address2_ := delivery_rec_.receiver_address2;
         receiver_address3_ := delivery_rec_.receiver_address3;
         receiver_address4_ := delivery_rec_.receiver_address4;
         receiver_address5_ := delivery_rec_.receiver_address5;
         receiver_address6_ := delivery_rec_.receiver_address6;
         receiver_zip_code_ := delivery_rec_.receiver_zip_code;
         receiver_city_     := delivery_rec_.receiver_city;
         receiver_state_    := delivery_rec_.receiver_state;
         receiver_county_   := delivery_rec_.receiver_county;
         receiver_country_  := delivery_rec_.receiver_country;
         -- Note: if single Occurance, delivery address is set to null in fetching ean loc details
         deliv_address_id_  := NULL;
      ELSE
         -- Retreive customer address.
         receiver_name_ := Customer_Info_Address_API.Get_Name(receiver_id_, ship_addr_no_);
         cust_addr_rec_ := Customer_Info_Address_API.Get(receiver_id_, ship_addr_no_);
         
         receiver_address1_:= cust_addr_rec_.address1;
         receiver_address2_:= cust_addr_rec_.address2;
         receiver_address3_:= cust_addr_rec_.address3;
         receiver_address4_:= cust_addr_rec_.address4;
         receiver_address5_:= cust_addr_rec_.address5;
         receiver_address6_:= cust_addr_rec_.address6;
         receiver_zip_code_:= cust_addr_rec_.zip_code;
         receiver_city_    := cust_addr_rec_.city;
         receiver_state_   := cust_addr_rec_.state;
         receiver_county_  := cust_addr_rec_.county;
         receiver_country_ := cust_addr_rec_.country;
      END IF;
   ELSE
      IF (shipment_rec_.addr_flag = 'Y') THEN
         receiver_name_     := shipment_rec_.receiver_address_name;
         receiver_address1_ := shipment_rec_.receiver_address1;
         receiver_address2_ := shipment_rec_.receiver_address2;
         receiver_address3_ := shipment_rec_.receiver_address3;
         receiver_address4_ := shipment_rec_.receiver_address4;
         receiver_address5_ := shipment_rec_.receiver_address5;
         receiver_address6_ := shipment_rec_.receiver_address6;
         receiver_zip_code_ := shipment_rec_.receiver_zip_code;
         receiver_city_     := shipment_rec_.receiver_city;
         receiver_state_    := shipment_rec_.receiver_state;
         receiver_county_   := shipment_rec_.receiver_county;
         receiver_country_  := shipment_rec_.receiver_country;
         -- Note: if single Occurance, delivery address is set to null in fetching ean loc details
         deliv_address_id_ := NULL;
      ELSE
         Shipment_Source_Utility_API.Get_Receiver_Addr_Info(receiver_address1_, 
                                                            receiver_address2_,  
                                                            receiver_address3_, 
                                                            receiver_address4_,  
                                                            receiver_address5_, 
                                                            receiver_address6_,  
                                                            receiver_zip_code_, 
                                                            receiver_city_, 
                                                            receiver_state_, 
                                                            receiver_county_, 
                                                            receiver_country_, 
                                                            receiver_country_desc_,
                                                            receiver_name_,
                                                            receiver_id_, 
                                                            ship_addr_no_,   
                                                            receiver_type_);
      END IF;   
   END IF;
   
   IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN
      dis_adv_rec_.receiver_id := receiver_id_;
      dis_adv_rec_.receiver_name := receiver_name_;
      dis_adv_rec_.receiver_address1 := receiver_address1_;
      dis_adv_rec_.receiver_address2 := receiver_address2_;
      dis_adv_rec_.receiver_address3 := receiver_address3_;
      dis_adv_rec_.receiver_address4 := receiver_address4_;
      dis_adv_rec_.receiver_address5 := receiver_address5_;
      dis_adv_rec_.receiver_address6 := receiver_address6_;
      dis_adv_rec_.receiver_zip_code := receiver_zip_code_;
      dis_adv_rec_.receiver_city := receiver_city_;
      dis_adv_rec_.receiver_state := receiver_state_;
      dis_adv_rec_.receiver_county := receiver_county_;
      dis_adv_rec_.receiver_country := receiver_country_;
      dis_adv_rec_.receiver_reference := consignee_ref_;
   ELSE
      Client_SYS.Add_To_Attr('C20', receiver_id_,       attr_);   -- Consignee/Customer ID
      Client_SYS.Add_To_Attr('C21', receiver_name_,     attr_);   -- Consignee address
      Client_SYS.Add_To_Attr('C22', receiver_address1_, attr_);
      Client_SYS.Add_To_Attr('C23', receiver_address2_, attr_);
      Client_SYS.Add_To_Attr('C56', receiver_address3_, attr_);
      Client_SYS.Add_To_Attr('C57', receiver_address4_, attr_);
      Client_SYS.Add_To_Attr('C58', receiver_address5_, attr_);
      Client_SYS.Add_To_Attr('C59', receiver_address6_, attr_);
      Client_SYS.Add_To_Attr('C24', receiver_zip_code_, attr_);
      Client_SYS.Add_To_Attr('C25', receiver_city_,     attr_);
      Client_SYS.Add_To_Attr('C26', receiver_county_,   attr_);
      Client_SYS.Add_To_Attr('C27', receiver_state_,    attr_);
      Client_SYS.Add_To_Attr('C28', receiver_country_,  attr_);
      Client_SYS.Add_To_Attr('C29', consignee_ref_,     attr_);   -- Consignee reference     
   END IF;   
   
   IF (Include_Cust_Ord_Specific___(shipment_id_)) THEN 
      $IF Component_Order_SYS.INSTALLED $THEN 
         sender_ :=  Customer_Order_Transfer_API.Get_Supplier_Id(company_, contract_, receiver_id_, delivery_rec_.delnote_no);
         cross_ref_rec_ := Cust_Addr_Cross_Reference_API.Get(receiver_id_, ship_addr_no_);
         
         IF media_code_ = 'INET_TRANS' THEN
            dis_adv_rec_.sender_id := sender_;
            dis_adv_rec_.cross_reference_info1 := cross_ref_rec_.cross_reference_info_1;
            dis_adv_rec_.cross_reference_info2 := cross_ref_rec_.cross_reference_info_2;
            dis_adv_rec_.cross_reference_info3 := cross_ref_rec_.cross_reference_info_3;
            dis_adv_rec_.cross_reference_info4 := cross_ref_rec_.cross_reference_info_4;
            dis_adv_rec_.cross_reference_info5 := cross_ref_rec_.cross_reference_info_5;
         ELSE
            Client_SYS.Add_To_Attr('C05', sender_, attr_); -- Consignor/Our ID at customer 
            Client_SYS.Add_To_Attr('C74', cross_ref_rec_.cross_reference_info_1, attr_);
            Client_SYS.Add_To_Attr('C75', cross_ref_rec_.cross_reference_info_2, attr_); 
            Client_SYS.Add_To_Attr('C76', cross_ref_rec_.cross_reference_info_3, attr_); 
            Client_SYS.Add_To_Attr('C77', cross_ref_rec_.cross_reference_info_4, attr_); 
            Client_SYS.Add_To_Attr('C78', cross_ref_rec_.cross_reference_info_5, attr_); 
         END IF;
      $ELSE
         NULL;
      $END
   ELSE
      sender_ := Shipment_API.Get_Sender_Id(shipment_id_);
      
      IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN
         dis_adv_rec_.sender_id := sender_;
      ELSE
         Client_SYS.Add_To_Attr('C05', sender_, attr_);
      END IF;      
   END IF;
   
   ean_doc_addr_ := NULL;
   address_id_ := Shipment_Source_Utility_API.Get_Default_Address(receiver_id_, receiver_type_, 'INVOICE');
   IF (address_id_ IS NOT NULL) THEN
      ean_doc_addr_ := Shipment_Source_Utility_API.Get_Ean_Location(receiver_id_, receiver_type_, address_id_);
   END IF;   
   
   ean_del_addr_ := NULL;
   IF (deliv_address_id_ IS NOT NULL) THEN
      ean_del_addr_ := Shipment_Source_Utility_API.Get_Ean_Location(receiver_id_, receiver_type_, deliv_address_id_);
   END IF;
   
   ean_pay_addr_ := NULL;
   IF (customer_no_pay_ IS NOT NULL) THEN
      address_id_ := Shipment_Source_Utility_API.Get_Default_Address(customer_no_pay_, receiver_type_, 'INVOICE');
      IF (address_id_ IS NOT NULL) THEN
         ean_pay_addr_ := Shipment_Source_Utility_API.Get_Ean_Location(customer_no_pay_, receiver_type_, address_id_);
      END IF;
   END IF;
   
   forwarder_addr_id_ := Forwarder_Info_Address_API.Get_Default_Address(forward_agent_id_, Address_Type_Code_API.Decode('DELIVERY'));
   forwaddr_rec_      := Forwarder_Info_Address_API.Get(forward_agent_id_, forwarder_addr_id_);
   forwarder_name_ := Forwarder_Info_API.Get_Name(forward_agent_id_);
   
   -- gelr:alt_delnote_no_chronologic, begin
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(contract_, 'ALT_DELNOTE_NO_CHRONOLOGIC') = Fnd_Boolean_API.DB_TRUE) THEN
      IF ((Delivery_Note_API.Get_Objstate(delivery_rec_.delnote_no) = 'Created') AND Delivery_Note_API.Get_Dispatch_Advice_Sent_Db(delivery_rec_.delnote_no) = 'NOTSENT') THEN
         alt_delnote_no_ := Delivery_Note_API.Get_Alt_Delnote_No(delivery_rec_.delnote_no);
      END IF;
      -- gelr:alt_delnote_no_chronologic, end
   ELSE
      alt_delnote_no_ := delivery_rec_.alt_delnote_no;
   END IF;
   
   
   IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN
      dis_adv_rec_.ean_doc_address := ean_doc_addr_;
      dis_adv_rec_.ean_del_address := ean_del_addr_;
      dis_adv_rec_.ean_payer_address := ean_pay_addr_;         
      dis_adv_rec_.forward_agent_id := forward_agent_id_;         
      dis_adv_rec_.forwarder_name := forwarder_name_;
      dis_adv_rec_.forwarder_address1 := forwaddr_rec_.address1;
      dis_adv_rec_.forwarder_address2 := forwaddr_rec_.address2;
      dis_adv_rec_.forwarder_address3 := forwaddr_rec_.address3;
      dis_adv_rec_.forwarder_address4 := forwaddr_rec_.address4;
      dis_adv_rec_.forwarder_address5 := forwaddr_rec_.address5;
      dis_adv_rec_.forwarder_address6 := forwaddr_rec_.address6;
      dis_adv_rec_.forwarder_zip_code := forwaddr_rec_.zip_code;
      dis_adv_rec_.forwarder_city := forwaddr_rec_.city;
      dis_adv_rec_.forwarder_state := forwaddr_rec_.state;
      dis_adv_rec_.forwarder_county := forwaddr_rec_.county;
      dis_adv_rec_.forwarder_country := forwaddr_rec_.country;         
      dis_adv_rec_.alt_delnote_no   := alt_delnote_no_;     
   ELSE
      Client_SYS.Add_To_Attr('C30', ean_doc_addr_, attr_);                  -- EAN doc address
      Client_SYS.Add_To_Attr('C31', ean_del_addr_, attr_);                  -- EAN del address
      Client_SYS.Add_To_Attr('C32', ean_pay_addr_, attr_);              -- EAN pay address
      Client_SYS.Add_To_Attr('C35', forward_agent_id_,                              attr_); -- Carrier/Forwarder
      Client_SYS.Add_To_Attr('C36', forwarder_name_, attr_); -- Carrier address
      Client_SYS.Add_To_Attr('C37', forwaddr_rec_.address1,                         attr_);
      Client_SYS.Add_To_Attr('C38', forwaddr_rec_.address2,                         attr_);
      Client_SYS.Add_To_Attr('C60', forwaddr_rec_.address3,                         attr_);
      Client_SYS.Add_To_Attr('C61', forwaddr_rec_.address4,                         attr_);
      Client_SYS.Add_To_Attr('C62', forwaddr_rec_.address5,                         attr_);
      Client_SYS.Add_To_Attr('C63', forwaddr_rec_.address6,                         attr_);
      Client_SYS.Add_To_Attr('C39', forwaddr_rec_.zip_code,                         attr_);
      Client_SYS.Add_To_Attr('C40', forwaddr_rec_.city,                             attr_);
      Client_SYS.Add_To_Attr('C41', forwaddr_rec_.county,                           attr_);
      Client_SYS.Add_To_Attr('C42', forwaddr_rec_.state,                            attr_);
      Client_SYS.Add_To_Attr('C43', forwaddr_rec_.country,                          attr_);
      Client_SYS.Add_To_Attr('C45', alt_delnote_no_,                                attr_);
   END IF;
   
   IF shipment_id_ IS NOT NULL THEN   
      comp_dist_rec_ := Company_Invent_Info_API.Get(company_);
      gross_total_   := Shipment_API.Get_Operational_Gross_Weight(shipment_id_, comp_dist_rec_.uom_for_weight,'FALSE'); 
      net_total_     := Handling_Unit_Ship_Util_API.Get_Shipment_Net_Weight(shipment_id_, comp_dist_rec_.uom_for_weight, 'FALSE');
      total_volume_  := Shipment_API.Get_Operational_Volume(shipment_id_, comp_dist_rec_.uom_for_volume);
      top_level_hu_count_ := Handling_Unit_Ship_Util_API.Get_Top_Level_Hu_Count(shipment_id_);
      second_level_hu_count_ := Handling_Unit_Ship_Util_API.Get_Second_Level_Hu_Count(shipment_id_);
      
      IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN
         dis_adv_rec_.dock_code := shipment_rec_.dock_code;
         dis_adv_rec_.sub_dock_code := shipment_rec_.sub_dock_code;
         dis_adv_rec_.ref_id := shipment_rec_.ref_id;
         dis_adv_rec_.location_no := shipment_rec_.location_no;
         dis_adv_rec_.receiver_type := shipment_rec_.receiver_type;
         dis_adv_rec_.airway_bill_no := shipment_rec_.airway_bill_no;
         dis_adv_rec_.pro_no := shipment_rec_.pro_no;            
         dis_adv_rec_.uom_for_weight := comp_dist_rec_.uom_for_weight;
         dis_adv_rec_.uom_for_volume := comp_dist_rec_.uom_for_volume;
         dis_adv_rec_.net_total := net_total_;
         dis_adv_rec_.gross_total := gross_total_;
         dis_adv_rec_.total_volume := total_volume_;
         dis_adv_rec_.top_level_handling_unit_count := top_level_hu_count_;
         dis_adv_rec_.second_level_handling_unit_count := second_level_hu_count_;
      ELSE
         Client_SYS.Add_To_Attr('C15', shipment_rec_.dock_code,       attr_);   
         Client_SYS.Add_To_Attr('C16', shipment_rec_.sub_dock_code,   attr_);   
         Client_SYS.Add_To_Attr('C17', shipment_rec_.ref_id,          attr_);   
         Client_SYS.Add_To_Attr('C18', shipment_rec_.location_no,     attr_);   
         Client_SYS.Add_To_Attr('C19', shipment_rec_.receiver_type,   attr_);
         Client_SYS.Add_To_Attr('C50', shipment_rec_.airway_bill_no,  attr_);  -- Airway Bill No
         Client_SYS.Add_To_Attr('C51', shipment_rec_.pro_no,          attr_);  -- Pro No
         Client_SYS.Add_To_Attr('C88', comp_dist_rec_.uom_for_weight, attr_);  -- UoM for Weight
         Client_SYS.Add_To_Attr('C89', comp_dist_rec_.uom_for_volume, attr_);  -- UoM for Volume
         Client_SYS.Add_To_Attr('N01', top_level_hu_count_,    attr_); -- Total no. pallets/shipment
         Client_SYS.Add_To_Attr('N02', second_level_hu_count_, attr_); -- Total no. packages/shipment
         Client_SYS.Add_To_Attr('N03', net_total_,    attr_); -- Net shipment weight
         Client_SYS.Add_To_Attr('N04', gross_total_,  attr_); -- Gross shipment weight
         Client_SYS.Add_To_Attr('N05', total_volume_, attr_); -- Volume
         
      END IF;
   END IF;
   
   IF NOT(automatic_receipt_) AND media_code_ != 'INET_TRANS' THEN
      Client_SYS.Add_To_Attr('C70', delivery_terms_,      attr_);   -- Delivery terms
      Client_SYS.Add_To_Attr('C71', delivery_terms_desc_, attr_);   -- Delivery terms description
      Client_SYS.Add_To_Attr('C72', ship_via_code_,       attr_);   -- Ship via code
      Client_SYS.Add_To_Attr('C73', ship_via_desc_,       attr_);   -- Ship via description
      Client_SYS.Add_To_Attr('C79', del_terms_location_,  attr_);   -- Del terms location      
      
   ELSE
      dis_adv_rec_.delivery_terms_desc := delivery_terms_desc_;         
      dis_adv_rec_.ship_via_desc := ship_via_desc_; 
      dis_adv_rec_.delivery_terms := delivery_terms_;
      dis_adv_rec_.ship_via_code := ship_via_code_;
      dis_adv_rec_.del_terms_location := del_terms_location_;
   END IF;
   
END Create_Address_Info___;


-- Create_Struct_Info___
--   This method constructs the Customer Order lines' structure information
--   or Shipment handling unit structure information.
-- If a change is done to either of the EDI or ITS sections of the method please
-- revisit the other section to check if the change is required there.
PROCEDURE Create_Struct_Info___ (
   dis_adv_rec_       IN OUT Dispatch_Advice_Rec,
   delnote_no_        IN     VARCHAR2,
   message_id_        IN     NUMBER,
   message_line_      IN     NUMBER,
   customer_no_       IN     VARCHAR2,
   delivery_rec_      IN     Delivery_Note_API.Public_Rec,
   shipment_rec_      IN     Shipment_API.Public_Rec,
   automatic_receipt_ IN     BOOLEAN,
   media_code_        IN     VARCHAR2 DEFAULT NULL )
IS   
   shipment_id_             NUMBER;
   msg_line_                NUMBER;    
   order_no_                VARCHAR2(12);
   forward_agent_id_        VARCHAR2(20);
   ship_via_code_           VARCHAR2(3);
   delivery_terms_          VARCHAR2(5);
   shipment_struct_exist_   VARCHAR2(5);  
   
BEGIN
   shipment_id_   := delivery_rec_.shipment_id;
   msg_line_      := message_line_;
   
   IF shipment_id_ IS NULL THEN
      order_no_            := delivery_rec_.order_no;
      forward_agent_id_    := delivery_rec_.forward_agent_id;
      ship_via_code_       := delivery_rec_.ship_via_code;
      delivery_terms_      := delivery_rec_.delivery_terms;
   ELSE
      shipment_struct_exist_ := Shipment_API.Shipment_Structure_Exist(shipment_id_);
      order_no_              := NULL;
      ship_via_code_         := shipment_rec_.ship_via_code;
      forward_agent_id_      := shipment_rec_.forward_agent_id;
      delivery_terms_        := shipment_rec_.delivery_terms;           
   END IF;
   
   IF shipment_id_ IS NULL THEN 
      $IF Component_Order_SYS.INSTALLED $THEN
         
         Customer_Order_Transfer_API.Create_Disadv_Struct_Info(dis_adv_rec_.dispatch_advice_lines ,
                                                               delnote_no_       ,
                                                               message_id_       ,
                                                               msg_line_         ,
                                                               forward_agent_id_ ,
                                                               delivery_terms_   ,
                                                               ship_via_code_    ,
                                                               customer_no_      ,
                                                               order_no_ ,
                                                               media_code_);
         
         
         
      $ELSE
         NULL;
      $END                                                      
      -- Create Dispatch Advice Lines for shipment lines that are not connected to a handling unit when unattached shipment lines are allowed.
   ELSIF ((Shipment_Line_Handl_Unit_API.Shipment_Exist(shipment_id_) = Fnd_Boolean_API.DB_FALSE) AND (shipment_rec_.shipment_uncon_struct = 'TRUE')) THEN
      Create_Ship_Line___(dis_adv_rec_, message_id_, msg_line_, customer_no_, shipment_id_, media_code_, automatic_receipt_);
   ELSE
      -- handling unit structure exists in inventory for the shipment
      IF (shipment_struct_exist_ = 'TRUE') THEN
         Create_Top_Level_Hu___ (dis_adv_rec_, shipment_id_, message_id_, msg_line_, customer_no_, media_code_, automatic_receipt_); 
      ELSE
         -- Add order lines connected to the shipment - without a package structure.
         Create_Ship_Line___(dis_adv_rec_, message_id_, message_line_, customer_no_, shipment_id_, media_code_, automatic_receipt_);
      END IF;
   END IF;
END Create_Struct_Info___;

-- Create_Ship_Line___
--   Create Dispatch Advice Lines for shipment lines that are not connected to a handling unit
--   when unattached shipment lines are allowed
PROCEDURE Create_Ship_Line___ (
   dis_adv_rec_       IN OUT Dispatch_Advice_Rec,   
   message_id_        IN     NUMBER,
   message_line_      IN     NUMBER,
   customer_no_       IN     VARCHAR2,
   shipment_id_       IN     NUMBER,
   media_code_        IN     VARCHAR2,
   automatic_receipt_ IN     BOOLEAN)
IS
   msg_line_          NUMBER; 
   dis_adv_line_rec_  Dispatch_Advice_Dispatch_Advice_Line_Rec;   
   
   CURSOR get_connected_row IS
      SELECT shipment_id, shipment_line_no, source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type_db,
             qty_shipped, inventory_part_no
        FROM shipment_line_pub
       WHERE shipment_id = shipment_id_
         AND (((source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4) <= 0))
               OR (source_ref_type_db != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER))
      ORDER BY source_ref1, source_ref2, source_ref3, source_ref4;
   
BEGIN
   msg_line_ := message_line_;
   
   FOR connrec_ IN get_connected_row LOOP
      IF (connrec_.inventory_part_no IS NOT NULL) THEN            
         Create_Inventory_Line___(message_line_       => msg_line_, 
                                  dis_adv_line_arr_   => dis_adv_rec_.dispatch_advice_lines,
                                  message_id_         => message_id_,
                                  customer_no_        => customer_no_,
                                  shipment_id_        => shipment_id_,
                                  shipment_line_no_   => connrec_.shipment_line_no,
                                  source_ref_type_db_ => connrec_.source_ref_type_db,
                                  source_ref1_        => connrec_.source_ref1,
                                  source_ref2_        => connrec_.source_ref2,
                                  source_ref3_        => connrec_.source_ref3,
                                  source_ref4_        => connrec_.source_ref4, 
                                  handling_unit_flag_ => 'N',
                                  media_code_         => media_code_,
                                  automatic_receipt_  => automatic_receipt_); 
         
      ELSE
         IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN
            dis_adv_rec_.dispatch_advice_lines.extend();
            Create_Line(dis_adv_line_rec_ => dis_adv_rec_.dispatch_advice_lines(dis_adv_rec_.dispatch_advice_lines.last),                              
                        message_id_       => message_id_,
                        message_line_     => msg_line_,
                        shipment_id_      => shipment_id_,
                        shipment_line_no_ => connrec_.shipment_line_no,
                        source_ref1_      => connrec_.source_ref1,
                        source_ref2_      => connrec_.source_ref2,
                        source_ref3_      => connrec_.source_ref3,
                        source_ref4_      => connrec_.source_ref4,
                        customer_no_      => customer_no_,
                        lot_batch_no_     => '*',
                        serial_no_        => '*',
                        expiration_date_  => NULL,
                        waiv_dev_rej_no_  => NULL,
                        eng_chg_level_    => NULL,
                        qty_shipped_      => connrec_.qty_shipped,
                        handling_unit_id_ => NULL,
                        activity_seq_     => NULL,
                        media_code_       => media_code_,
                        automatic_receipt_ => automatic_receipt_);             
         ELSE
            msg_line_ := msg_line_ + 1;
            Create_Line(dis_adv_line_rec_ => dis_adv_line_rec_,
                        message_id_       => message_id_,
                        message_line_     => msg_line_,
                        shipment_id_      => shipment_id_,
                        shipment_line_no_ => connrec_.shipment_line_no,
                        source_ref1_      => connrec_.source_ref1,
                        source_ref2_      => connrec_.source_ref2,
                        source_ref3_      => connrec_.source_ref3,
                        source_ref4_      => connrec_.source_ref4,
                        customer_no_      => customer_no_,
                        lot_batch_no_     => '*',
                        serial_no_        => '*',
                        expiration_date_  => NULL,
                        waiv_dev_rej_no_  => NULL,
                        eng_chg_level_    => NULL,
                        qty_shipped_      => connrec_.qty_shipped,
                        handling_unit_id_ => NULL,
                        activity_seq_     => NULL,
                        media_code_       => media_code_); 
         END IF;         
      END IF; 
   END LOOP;
   
END Create_Ship_Line___;

-- Create_Handling_Unit___
--   This creates a handling unit segment in the dispatch advice.
-- If a change is done to either of the EDI or ITS sections of the method please
-- revisit the other section to check if the change is required there.
PROCEDURE Create_Handling_Unit___ (
   message_line_      IN OUT NUMBER,
   shipment_line_tab_ IN OUT Shipment_Line_Tab, 
   dis_adv_hu_rec_    IN OUT Dispatch_Advice_Shipment_Handl_Unit_With_History_Rec,   
   dis_adv_rec_       IN OUT Dispatch_Advice_Rec,
   shipment_id_       IN     NUMBER,
   handling_unit_id_  IN     NUMBER,
   message_id_        IN     NUMBER,
   customer_no_       IN     VARCHAR2,
   media_code_        IN     VARCHAR2,
   automatic_receipt_ IN     BOOLEAN)  
IS
   attr_                      VARCHAR2(2000);
   one_ship_line_connected_   BOOLEAN := TRUE;   
   qty_on_handl_unit_         NUMBER;
   lot_batch_no_              VARCHAR2(20);
   eng_chg_level_             VARCHAR2(6);
   serial_no_                 VARCHAR2(50);
   waiv_dev_rej_no_           VARCHAR2(15);
   shipment_line_rec_         Shipment_Line_API.Public_Rec;
   reserv_handl_unit_ext_tab_ Shipment_Reserv_Handl_Unit_API.Reserv_Handl_Unit_Ext_Tab;
   dis_adv_line_rec_          Dispatch_Advice_Dispatch_Advice_Line_Rec;
   
   CURSOR get_ship_line(handling_unit_id_ NUMBER) IS
      SELECT *
        FROM shipment_line_handl_unit_tab
       WHERE shipment_id      = shipment_id_
         AND handling_unit_id = handling_unit_id_;
   
   CURSOR get_handling_unit(handling_unit_id_ NUMBER) IS
      SELECT *
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE handling_unit_id = handling_unit_id_
         AND shipment_id = shipment_id_;
   handling_unit_rec_         get_handling_unit%ROWTYPE;  
   
BEGIN
   
   OPEN get_handling_unit(handling_unit_id_);
   FETCH get_handling_unit INTO handling_unit_rec_;
   CLOSE get_handling_unit; 
   
   IF NOT(automatic_receipt_) AND media_code_ != 'INET_TRANS' THEN   
      message_line_      := message_line_ + 1;
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_,                              attr_);
      Client_SYS.Add_To_Attr('MESSAGE_ID',   message_id_,                                attr_);
      Client_SYS.Add_To_Attr('NAME',         'HANDLING UNIT',                            attr_);
      Client_SYS.Add_To_Attr('C01',          handling_unit_rec_.composition,             attr_); -- Handling unit category   
      Client_SYS.Add_To_Attr('C02',          handling_unit_rec_.handling_unit_type_id,   attr_); -- Handling Unit Type                 
   ELSE      
      dis_adv_hu_rec_.composition := handling_unit_rec_.composition;
      dis_adv_hu_rec_.handling_unit_type_id := handling_unit_rec_.handling_unit_type_id;            
   END IF;
   
   qty_on_handl_unit_       := Shipment_Line_Handl_Unit_API.Get_Sub_Struct_Connected_Qty(shipment_id_, handling_unit_id_);
   one_ship_line_connected_ := Shipment_Line_Handl_Unit_API.Check_One_Ship_Line_Connected(shipment_id_, handling_unit_id_);
   
   IF (one_ship_line_connected_ = TRUE) THEN
      Get_Ship_line_Info_From_Hu___(shipment_line_rec_, shipment_id_, handling_unit_id_);
      
      eng_chg_level_   := Shipment_Reserv_Handl_Unit_API.Get_Uniq_Struct_Eng_Chg_Level(shipment_id_, handling_unit_id_);
      lot_batch_no_    := Shipment_Reserv_Handl_Unit_API.Get_Uniq_Struct_Lot_Batch_No(shipment_id_, handling_unit_id_);     
      serial_no_       := Shipment_Reserv_Handl_Unit_API.Get_Uniq_Struct_Serial_No(shipment_id_, handling_unit_id_);  
      waiv_dev_rej_no_ := Shipment_Reserv_Handl_Unit_API.Get_Uniq_Struct_Waiv_Dev_Rej(shipment_id_, handling_unit_id_);
      
      IF NOT(automatic_receipt_) AND media_code_ != 'INET_TRANS' THEN
         Client_SYS.Add_To_Attr('C03', shipment_line_rec_.source_ref1,     attr_); -- Source Ref1
         Client_SYS.Add_To_Attr('C04', shipment_line_rec_.source_ref2,     attr_); -- Source Ref2
         Client_SYS.Add_To_Attr('C05', shipment_line_rec_.source_ref3,     attr_); -- Source Ref3 
         Client_SYS.Add_To_Attr('C06', shipment_line_rec_.source_ref4,     attr_); -- Source Ref4
         Client_SYS.Add_To_Attr('C07', shipment_line_rec_.source_ref_type, attr_); -- Source Ref Type
         IF (eng_chg_level_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('C15', eng_chg_level_,   attr_); -- Engineering Revision No/Eng Chg Level   
         END IF;
         IF (lot_batch_no_  IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('C16', lot_batch_no_,    attr_); -- Lot Batch No       
         END IF;
         IF (serial_no_  IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('C17', serial_no_,       attr_); -- Serial No              
         END IF;  
         IF (waiv_dev_rej_no_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('C18', waiv_dev_rej_no_, attr_);      
         END IF;
         Client_SYS.Add_To_Attr('N06', (qty_on_handl_unit_/shipment_line_rec_.conv_factor * shipment_line_rec_.inverted_conv_factor), attr_); -- Qty on handling unit in Sales UoM 
         
      ELSE
         dis_adv_hu_rec_.source_ref1 := shipment_line_rec_.source_ref1;
         dis_adv_hu_rec_.source_ref2 := shipment_line_rec_.source_ref2;
         dis_adv_hu_rec_.source_ref3 := shipment_line_rec_.source_ref3;
         dis_adv_hu_rec_.source_ref4 := shipment_line_rec_.source_ref4;
         dis_adv_hu_rec_.source_ref_type := shipment_line_rec_.source_ref_type;             
         dis_adv_hu_rec_.eng_chg_level     := eng_chg_level_;
         dis_adv_hu_rec_.lot_batch_no      := lot_batch_no_;
         dis_adv_hu_rec_.serial_no         := serial_no_;
         dis_adv_hu_rec_.waiv_dev_rej_no   := waiv_dev_rej_no_;
         dis_adv_hu_rec_.eng_chg_level     := eng_chg_level_; 
         dis_adv_hu_rec_.source_qty_on_handling_unit := qty_on_handl_unit_/shipment_line_rec_.conv_factor * shipment_line_rec_.inverted_conv_factor;
      END IF;
   END IF;          
   
   IF NOT(automatic_receipt_) AND media_code_ != 'INET_TRANS' THEN        
      Client_SYS.Add_To_Attr('N02', qty_on_handl_unit_,                            attr_); -- Qty on handling unit     
      Client_SYS.Add_To_Attr('N03', handling_unit_rec_.no_of_children,             attr_); -- Number of connected second level level handling units     
      Client_SYS.Add_To_Attr('N04', handling_unit_rec_.net_weight,                 attr_); -- Net weight
      Client_SYS.Add_To_Attr('N05', handling_unit_rec_.tare_weight,                attr_); -- Tare weight
      Client_SYS.Add_To_Attr('N07', handling_unit_rec_.operative_gross_weight,     attr_); -- Gross weight
      Client_SYS.Add_To_Attr('N08', handling_unit_rec_.operative_volume,           attr_); -- Gross volume
      Client_SYS.Add_To_Attr('C22', handling_unit_rec_.uom_for_weight,             attr_); -- UoM for Weight
      Client_SYS.Add_To_Attr('C23', handling_unit_rec_.uom_for_volume,             attr_); -- UoM for Volume
      Client_SYS.Add_To_Attr('C24', handling_unit_rec_.uom_for_length,             attr_); -- UoM for Length
      Client_SYS.Add_To_Attr('C25', handling_unit_rec_.handling_unit_id,           attr_); -- Label serial number/Handling unit ID
      Client_SYS.Add_To_Attr('C26', handling_unit_rec_.parent_handling_unit_id,    attr_);
      Client_SYS.Add_To_Attr('N09', handling_unit_rec_.width,                      attr_); -- Width
      Client_SYS.Add_To_Attr('N10', handling_unit_rec_.height,                     attr_); -- Height
      Client_SYS.Add_To_Attr('N11', handling_unit_rec_.depth,                      attr_); -- Depth
      Client_SYS.Add_To_Attr('C19', handling_unit_rec_.sscc,                       attr_); -- Sscc   
      Client_SYS.Add_To_Attr('C20', handling_unit_rec_.alt_handling_unit_label_id, attr_); -- Alt Handling Unit Label ID
      
      Connectivity_SYS.Create_Message_Line(attr_);           
      
   ELSE    
      dis_adv_hu_rec_.qty_on_handl_unit := qty_on_handl_unit_;
      dis_adv_hu_rec_.no_of_children := handling_unit_rec_.no_of_children;
      dis_adv_hu_rec_.net_weight := handling_unit_rec_.net_weight;
      dis_adv_hu_rec_.tare_weight := handling_unit_rec_.tare_weight;
      dis_adv_hu_rec_.operative_gross_weight := handling_unit_rec_.operative_gross_weight;
      dis_adv_hu_rec_.operative_volume := handling_unit_rec_.operative_volume;
      dis_adv_hu_rec_.uom_for_weight := handling_unit_rec_.uom_for_weight;
      dis_adv_hu_rec_.uom_for_volume := handling_unit_rec_.uom_for_volume;         
      dis_adv_hu_rec_.uom_for_length := handling_unit_rec_.uom_for_length;
      dis_adv_hu_rec_.handling_unit_id := handling_unit_rec_.handling_unit_id;
      dis_adv_hu_rec_.parent_handling_unit_id := handling_unit_rec_.parent_handling_unit_id;
      dis_adv_hu_rec_.width := handling_unit_rec_.width;
      dis_adv_hu_rec_.height := handling_unit_rec_.height;
      dis_adv_hu_rec_.depth := handling_unit_rec_.depth;
      dis_adv_hu_rec_.sscc := handling_unit_rec_.sscc;
      dis_adv_hu_rec_.alt_handling_unit_label_id := handling_unit_rec_.alt_handling_unit_label_id;
   END IF; 
   
   FOR ship_line_hu_rec_ IN get_ship_line(handling_unit_id_) LOOP
      shipment_line_rec_ :=  Shipment_Line_API.Get(ship_line_hu_rec_.shipment_id, ship_line_hu_rec_.shipment_line_no);
      
      Create_Handling_Unit_Line___(shipment_line_tab_, message_line_, dis_adv_rec_.dispatch_advice_lines, ship_line_hu_rec_.quantity, shipment_line_rec_.source_ref1, shipment_line_rec_.source_ref2, shipment_line_rec_.source_ref3,
                                   shipment_line_rec_.source_ref4, shipment_id_, ship_line_hu_rec_.shipment_line_no, handling_unit_rec_.handling_unit_id,
                                   shipment_line_rec_.Inventory_part_no, shipment_line_rec_.shipment_line_no, message_id_,
                                   customer_no_, shipment_line_rec_.source_ref_type, media_code_, automatic_receipt_);
      
   END LOOP; 
   
   reserv_handl_unit_ext_tab_ := Shipment_Reserv_Handl_Unit_API.Get_Reserv_Hu_Ext_Details(shipment_id_, handling_unit_id_);
   IF(reserv_handl_unit_ext_tab_ IS NOT NULL) THEN
      IF (reserv_handl_unit_ext_tab_.COUNT > 0) THEN
         FOR i IN reserv_handl_unit_ext_tab_.FIRST..reserv_handl_unit_ext_tab_.LAST LOOP
            IF NOT(automatic_receipt_) AND media_code_ != 'INET_TRANS' THEN
               message_line_ := message_line_ + 1;
               Create_Line(dis_adv_line_rec_ => dis_adv_line_rec_,                     
                           message_id_       => message_id_,
                           message_line_     => message_line_,
                           shipment_id_      => shipment_id_,
                           shipment_line_no_ => reserv_handl_unit_ext_tab_(i).shipment_line_no,
                           source_ref1_      => reserv_handl_unit_ext_tab_(i).source_ref1,
                           source_ref2_      => reserv_handl_unit_ext_tab_(i).source_ref2,
                           source_ref3_      => reserv_handl_unit_ext_tab_(i).source_ref3,
                           source_ref4_      => reserv_handl_unit_ext_tab_(i).source_ref4,
                           customer_no_      => customer_no_,
                           lot_batch_no_     => reserv_handl_unit_ext_tab_(i).lot_batch_no,
                           serial_no_        => reserv_handl_unit_ext_tab_(i).serial_no,
                           expiration_date_  => reserv_handl_unit_ext_tab_(i).expiration_date,
                           waiv_dev_rej_no_  => reserv_handl_unit_ext_tab_(i).waiv_dev_rej_no,
                           eng_chg_level_    => reserv_handl_unit_ext_tab_(i).eng_chg_level,
                           qty_shipped_      => reserv_handl_unit_ext_tab_(i).total_inventory_qty,
                           handling_unit_id_ => handling_unit_rec_.handling_unit_id,
                           activity_seq_     => reserv_handl_unit_ext_tab_(i).activity_seq ); 
            ELSE
               dis_adv_rec_.dispatch_advice_lines.extend();
               Create_Line(dis_adv_line_rec_ => dis_adv_rec_.dispatch_advice_lines(dis_adv_rec_.dispatch_advice_lines.last),
                           message_id_       => message_id_,
                           message_line_     => message_line_,
                           shipment_id_      => shipment_id_,
                           shipment_line_no_ => reserv_handl_unit_ext_tab_(i).shipment_line_no,
                           source_ref1_      => reserv_handl_unit_ext_tab_(i).source_ref1,
                           source_ref2_      => reserv_handl_unit_ext_tab_(i).source_ref2,
                           source_ref3_      => reserv_handl_unit_ext_tab_(i).source_ref3,
                           source_ref4_      => reserv_handl_unit_ext_tab_(i).source_ref4,
                           customer_no_      => customer_no_,
                           lot_batch_no_     => reserv_handl_unit_ext_tab_(i).lot_batch_no,
                           serial_no_        => reserv_handl_unit_ext_tab_(i).serial_no,
                           expiration_date_  => reserv_handl_unit_ext_tab_(i).expiration_date,
                           waiv_dev_rej_no_  => reserv_handl_unit_ext_tab_(i).waiv_dev_rej_no,
                           eng_chg_level_    => reserv_handl_unit_ext_tab_(i).eng_chg_level,
                           qty_shipped_      => reserv_handl_unit_ext_tab_(i).total_inventory_qty,
                           handling_unit_id_ => handling_unit_rec_.handling_unit_id,
                           activity_seq_     => reserv_handl_unit_ext_tab_(i).activity_seq,
                           media_code_       => media_code_,
                           automatic_receipt_ => automatic_receipt_); 
            END IF; 
         END LOOP;
      END IF; 
   END IF;
END Create_Handling_Unit___;

PROCEDURE Create_Handling_Unit_Line___(
   shipment_line_tab_ IN OUT Shipment_Line_Tab, 
   message_line_      IN OUT NUMBER, 
   dis_adv_line_arr_  IN OUT Dispatch_Advice_Dispatch_Advice_Line_Arr, 
   ship_line_hu_qty_  IN     NUMBER,
   source_ref1_       IN     VARCHAR2,
   source_ref2_       IN     VARCHAR2,
   source_ref3_       IN     VARCHAR2,
   source_ref4_       IN     VARCHAR2,
   shipment_id_       IN     NUMBER,
   ship_hu_line_no_   IN     NUMBER,
   handling_unit_id_  IN     NUMBER,
   inventory_part_no_ IN     VARCHAR2,
   shipment_line_no_  IN     NUMBER,
   message_id_        IN     NUMBER,
   customer_no_       IN     VARCHAR2,
   source_ref_type_   IN     VARCHAR2,
   media_code_        IN     VARCHAR2,
   automatic_receipt_ IN     BOOLEAN)
IS
   qty_on_handl_unit_ NUMBER;
   found_             VARCHAR2(5) := 'FALSE';
   dis_adv_line_rec_  Dispatch_Advice_Dispatch_Advice_Line_Rec;
   
BEGIN
   qty_on_handl_unit_ :=  ship_line_hu_qty_ - Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(source_ref1_, NVL(source_ref2_,'*'),
                                                                                                   NVL(source_ref3_,'*'), NVL(source_ref4_,'*'),
                                                                                                   shipment_id_, ship_hu_line_no_, handling_unit_id_); 
   IF((inventory_part_no_ IS NOT NULL) AND 
      (Shipment_Reserv_Handl_Unit_API.Handling_Unit_Exist(shipment_id_, shipment_line_no_)= Fnd_Boolean_API.DB_FALSE)) THEN
      IF (shipment_line_tab_ IS NOT NULL)  THEN  
         IF shipment_line_tab_.COUNT > 0  THEN
            FOR record_ IN shipment_line_tab_.FIRST..shipment_line_tab_.LAST LOOP
               IF(shipment_line_tab_(record_).shipment_line_no = shipment_line_no_) THEN
                  found_ := 'TRUE';
                  EXIT;
               END IF;
            END LOOP;
         END IF;
      END IF;   
      IF (found_ = 'FALSE') THEN
         Create_Inventory_Line___(message_line_       => message_line_,
                                  dis_adv_line_arr_   => dis_adv_line_arr_, 
                                  message_id_         => message_id_, 
                                  customer_no_        => customer_no_,
                                  shipment_id_        => shipment_id_,
                                  shipment_line_no_   => shipment_line_no_, 
                                  source_ref_type_db_ => source_ref_type_,
                                  source_ref1_        => source_ref1_,
                                  source_ref2_        => source_ref2_,
                                  source_ref3_        => source_ref3_,
                                  source_ref4_        => source_ref4_, 
                                  handling_unit_flag_ => 'Y',
                                  media_code_         => media_code_,
                                  automatic_receipt_  => automatic_receipt_); 
         shipment_line_tab_(shipment_line_tab_.COUNT +1).shipment_line_no := shipment_line_no_;
      END IF;
      found_ := 'FALSE';
      
   ELSIF (inventory_part_no_ IS NULL) THEN
      IF (qty_on_handl_unit_ > 0) THEN
         IF (automatic_receipt_ OR media_code_ = 'INET_TRANS') THEN
            dis_adv_line_arr_.extend();
            Create_Line(dis_adv_line_rec_  => dis_adv_line_arr_(dis_adv_line_arr_.last),
                        message_id_        => message_id_,
                        message_line_      => message_line_,
                        shipment_id_       => shipment_id_,
                        shipment_line_no_  => shipment_line_no_,
                        source_ref1_       => source_ref1_,
                        source_ref2_       => source_ref2_,
                        source_ref3_       => source_ref3_,
                        source_ref4_       => source_ref4_,
                        customer_no_       => customer_no_,
                        lot_batch_no_      => NULL,
                        serial_no_         => NULL,
                        expiration_date_   => NULL,
                        waiv_dev_rej_no_   => NULL,
                        eng_chg_level_     => NULL,
                        qty_shipped_       => qty_on_handl_unit_,
                        handling_unit_id_  => handling_unit_id_,
                        activity_seq_      => 0,
                        media_code_        => media_code_,
                        automatic_receipt_ => automatic_receipt_); 
            
         ELSE            
            message_line_ := message_line_ + 1;
            Create_Line(dis_adv_line_rec_ => dis_adv_line_rec_,
                        message_id_       => message_id_,
                        message_line_     => message_line_,
                        shipment_id_      => shipment_id_,
                        shipment_line_no_ => shipment_line_no_,
                        source_ref1_      => source_ref1_,
                        source_ref2_      => source_ref2_,
                        source_ref3_      => source_ref3_,
                        source_ref4_      => source_ref4_,
                        customer_no_      => customer_no_,
                        lot_batch_no_     => NULL,
                        serial_no_        => NULL,
                        expiration_date_  => NULL,
                        waiv_dev_rej_no_  => NULL,
                        eng_chg_level_    => NULL,
                        qty_shipped_      => qty_on_handl_unit_,
                        handling_unit_id_ => handling_unit_id_,
                        activity_seq_     => 0,
                        media_code_       => media_code_); 
         END IF; 
      END IF;
      
   END IF;
END Create_Handling_Unit_Line___;

PROCEDURE Get_Ship_line_Info_From_Hu___ (
   shipment_line_rec_    OUT     Shipment_Line_API.Public_Rec,  
   shipment_id_          IN      NUMBER,
   handling_unit_id_     IN      NUMBER )
IS
   ship_line_hu_rec_          SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE;
   
   CURSOR get_sub_struct_ship_line(handling_unit_id_ NUMBER) IS
         SELECT *
           FROM shipment_line_handl_unit_tab
          WHERE shipment_id = shipment_id_ 
            AND handling_unit_id IN (SELECT handling_unit_id
                                       FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
                                    CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
                                          START WITH handling_unit_id = handling_unit_id_);  
   
BEGIN
   OPEN  get_sub_struct_ship_line(handling_unit_id_);
   FETCH get_sub_struct_ship_line INTO ship_line_hu_rec_;
   CLOSE get_sub_struct_ship_line; 
   
   shipment_line_rec_  :=  Shipment_Line_API.Get(ship_line_hu_rec_.shipment_id, ship_line_hu_rec_.shipment_line_no);                       
END Get_Ship_line_Info_From_Hu___;



PROCEDURE Create_Top_Level_Hu___ (
   dis_adv_rec_       IN OUT Dispatch_Advice_Rec,   
   shipment_id_       IN     NUMBER,
   message_id_        IN     NUMBER,
   message_line_      IN     NUMBER,
   customer_no_       IN     VARCHAR2,
   media_code_        IN     VARCHAR2,
   automatic_receipt_ IN     BOOLEAN)  
IS
   msg_line_      NUMBER;
   shipment_line_tab_  Shipment_Line_Tab;
   dis_adv_hu_rec_   Dispatch_Advice_Shipment_Handl_Unit_With_History_Rec;  
   
   CURSOR get_top_level_handling_units IS
      SELECT handling_unit_id 
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_
         AND parent_handling_unit_id IS NULL
       ORDER BY handling_unit_id;
   
   CURSOR get_sub_struct_handling_units(handling_unit_id_ NUMBER) IS
      SELECT handling_unit_id 
        FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
       WHERE shipment_id = shipment_id_           
         AND handling_unit_id IN (SELECT handling_unit_id
                                    FROM SHPMNT_HANDL_UNIT_WITH_HISTORY
                                 CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
                                       START WITH handling_unit_id = handling_unit_id_);          
BEGIN
   IF NOT(automatic_receipt_) AND media_code_ != 'INET_TRANS' THEN
      msg_line_   := message_line_; 
   END IF;   
   -- fetch top level handling units in the structure
   FOR top_level_handling_unit_rec_ IN get_top_level_handling_units LOOP 
      -- travel through the structure below the top most handling unit
      FOR sub_struct_handling_unit_rec_ IN get_sub_struct_handling_units(top_level_handling_unit_rec_.handling_unit_id) LOOP 
         IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN
            dis_adv_rec_.handling_units.extend(); 
            Create_Handling_Unit___(msg_line_, shipment_line_tab_, dis_adv_rec_.handling_units(dis_adv_rec_.handling_units.last), dis_adv_rec_, shipment_id_, sub_struct_handling_unit_rec_.handling_unit_id, message_id_, customer_no_, media_code_, automatic_receipt_);
         ELSE         
            Create_Handling_Unit___(msg_line_, shipment_line_tab_, dis_adv_hu_rec_, dis_adv_rec_, shipment_id_, sub_struct_handling_unit_rec_.handling_unit_id, message_id_, customer_no_, media_code_, automatic_receipt_);
         END IF;
      END LOOP;
   END LOOP;
   
END Create_Top_Level_Hu___;

-- Send_Dispatch_Advice_Head_Data___
-- Returns data related to create dispatch advice header
-- in EDI and ITS flows.
PROCEDURE Send_Dispatch_Advice_Head_Data___ (
   receiver_address_       IN OUT VARCHAR2,
   sender_address_         IN OUT VARCHAR2,
   company_                IN OUT VARCHAR2,
   company_association_no_ IN OUT VARCHAR2,
   customer_email_id_      IN OUT VARCHAR2,
   customer_fax_no_        IN OUT VARCHAR2,
   customer_phone_no_      IN OUT VARCHAR2,
   sequence_no_            IN OUT NUMBER,
   version_no_             IN OUT NUMBER,
   contract_               IN VARCHAR2,
   delnote_no_             IN VARCHAR2,
   order_no_               IN VARCHAR2,
   shipment_id_            IN NUMBER,
   receiver_id_            IN VARCHAR2,
   receiver_type_          IN VARCHAR2,
   media_code_             IN VARCHAR2,
   message_type_           IN VARCHAR2 )    
IS   
   add_id_                 VARCHAR2(50);
BEGIN
   -- gelr:alt_delnote_no_chronologic, begin
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(contract_, 'ALT_DELNOTE_NO_CHRONOLOGIC') = Fnd_Boolean_API.DB_TRUE) THEN
      IF ((Delivery_Note_API.Get_Objstate(delnote_no_) = 'Created') AND Delivery_Note_API.Get_Dispatch_Advice_Sent_Db(delnote_no_) = 'NOTSENT') THEN
         Delivery_Note_API.Generate_Alt_Delnote__(delnote_no_, order_no_, shipment_id_);
      END IF;
   END IF;
   -- gelr:alt_delnote_no_chronologic, end
   company_          := Site_API.Get_Company(contract_);
   receiver_address_ := Shipment_Source_Utility_API.Get_Receiver_Msg_Setup_Addr(receiver_id_,
                                                                                media_code_,
                                                                                message_type_,
                                                                                receiver_type_ );
   IF (receiver_address_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'RECEIVERNOTFOUND: No Reciever address found for media code :P1.', media_code_);
   END IF;
   
   -- Retrieve postal address of company (recipient) from Enterprise
   sender_address_   := Company_Msg_Setup_API.Get_Address(company_,
                                                          media_code_,
                                                          message_type_);
   
   company_association_no_ := Company_Api.Get_Association_No(company_);
   add_id_ := Site_Discom_Info_API.Get_Document_Address_Id(contract_, 'TRUE');
   customer_email_id_ := Comm_Method_API.Get_Value('COMPANY', company_, Comm_Method_Code_API.Decode('E_MAIL'), 1, add_id_, sysdate);
   customer_phone_no_ := Comm_Method_API.Get_Value('COMPANY', company_, Comm_Method_Code_API.Decode('PHONE'), 1, add_id_, sysdate);
   customer_fax_no_   := Comm_Method_API.Get_Value('COMPANY', company_, Comm_Method_Code_API.Decode('FAX'), 1, add_id_, sysdate);  
   
   sequence_no_ := Delivery_Note_API.Get_Desadv_Sequence_No (delnote_no_);
   
   IF (sequence_no_ IS NULL) THEN
      -- This is the first time the dispatch advice is being sent. 
      -- Obtain a new sequence_no and set the version_no to 0.
      sequence_no_ := Shipment_Source_Utility_API.Increase_Receiver_Msg_Seq_No(receiver_id_, media_code_, message_type_, receiver_type_);   
      version_no_ := 0; 
   ELSE
      -- The invoice is being resent
      -- Reuse the existing sequence_no and increment the version.
      version_no_ := Delivery_Note_API.Get_Desadv_Version_No(delnote_no_) + 1; 
   END IF;  
   Delivery_Note_API.Set_Desadv_Sequence_Version(delnote_no_, sequence_no_ , version_no_);
END Send_Dispatch_Advice_Head_Data___;

-- Post_Send_Dispatch_Advice___
-- Contains operations performing after sending dispatch advice
PROCEDURE Post_Send_Dispatch_Advice___ (
   delnote_no_          IN VARCHAR2,
   shipment_id_         IN VARCHAR2,
   order_no_            IN VARCHAR2,
   media_code_          IN VARCHAR2,
   automatic_receipt_   IN BOOLEAN,
   dis_adv_rec_         IN Dispatch_Advice_Rec)
IS
BEGIN
   IF (Delivery_Note_API.Get_Dispatch_Advice_Sent_Db(delnote_no_) = 'NOTSENT') THEN
      -- Set the dispatch advice flag on the delivery note.
      Delivery_Note_API.Set_Dispatch_Advice_Sent(delnote_no_);
      IF shipment_id_ IS NULL THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            -- Post actions to be performed after sending dispatch advice.
            Customer_Order_Transfer_API.Post_Send_Dispatch_Advice(order_no_, media_code_);
         $ELSE
            NULL;
         $END
      ELSE
         -- Post actions to be performed in shipment line level after sending dispatch advice.
         Shipment_API.Post_Send_Dispatch_Advice(shipment_id_, media_code_);   
      END IF;
   END IF;

   IF automatic_receipt_ THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         -- Create Ext_Dispatch_Adv_Struct_Rec for automatic receipt flow.
         Receipt_Info_Transfer_API.Receive_Dis_Adv_Automaticallly(dis_adv_rec_);
      $ELSE
         NULL;
      $END
   END IF;
END Post_Send_Dispatch_Advice___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Send_Dispatch_Advice
--   Generate a dispatch advice (DESADV) EDI/MHS message for the specified order or shipment
-- in the connectivity outbox. Generate an application messge for INET_TRANS flow. 
-- Create Dispatch_Advice_Rec for Automatic Receipt flow.
PROCEDURE Send_Dispatch_Advice (
   delnote_no_        IN VARCHAR2,
   media_code_        IN VARCHAR2,
   automatic_receipt_ IN BOOLEAN DEFAULT FALSE)
IS
   message_type_            VARCHAR2(30);
   shipment_id_             NUMBER;
   delivery_rec_            Delivery_Note_API.Public_Rec;
   attr_                    VARCHAR2(32000);     
   message_id_              NUMBER;
   message_line_            NUMBER;
   receiver_address_        VARCHAR2(2000);
   sender_address_          VARCHAR2(2000);   
   company_                 VARCHAR2(20);   
   shipment_rec_            Shipment_API.Public_Rec;
   $IF Component_Order_SYS.INSTALLED $THEN
      order_rec_            Customer_Order_API.Public_Rec;
   $END
   contract_                VARCHAR2(5);
   order_no_                VARCHAR2(12);
   receiver_id_             VARCHAR2(50);
   receiver_type_           VARCHAR2(20);
   sequence_no_             NUMBER;
   version_no_              NUMBER;
   customer_email_id_       VARCHAR2(200);
   customer_fax_no_         VARCHAR2(200);
   customer_phone_no_       VARCHAR2(200);
   company_association_no_  VARCHAR2(50);  
   -- The structure related to this rec is available in DispatchAdviceUtility.fragment.
   dis_adv_rec_             Dispatch_Advice_Rec; 
   json_obj_                JSON_OBJECT_T;
   json_clob_               CLOB; 
   msg_id_                  NUMBER; 
BEGIN
   IF media_code_ = 'INET_TRANS' AND NOT(Dictionary_SYS.Component_Is_Active('ITS')) THEN
      Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
   END IF;
   
   message_type_     := 'DESADV';
   -- Retreive Delivery note information
   delivery_rec_     := Delivery_Note_API.Get(delnote_no_);
   shipment_id_      := delivery_rec_.shipment_id;
   
   IF shipment_id_ IS NULL THEN
      order_no_       := delivery_rec_.order_no;
      $IF Component_Order_SYS.INSTALLED $THEN
         order_rec_     := Customer_Order_API.Get(order_no_);
         contract_      := order_rec_.contract;         
      $END
      receiver_id_   := delivery_rec_.receiver_id;
      receiver_type_ := Sender_Receiver_Type_API.DB_CUSTOMER;
      IF media_code_ = 'INET_TRANS' THEN
         dis_adv_rec_.contract := contract_;
         dis_adv_rec_.receiver_id := receiver_id_;
         dis_adv_rec_.receiver_type := receiver_type_;            
      END IF;
   ELSE
      IF(Shipment_API.Source_Ref_Type_Exist(shipment_id_, Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) = Fnd_Boolean_API.DB_TRUE) THEN
         Error_SYS.Record_General(lu_name_, 'NOPRR: Dispatch Advice cannot be generated when shipment source ref type is Purchase Receipt Return.');
      END IF; 
      
      shipment_rec_  := Shipment_API.Get(shipment_id_);    
      
      contract_      := shipment_rec_.contract;
      receiver_id_   := shipment_rec_.receiver_id;
      receiver_type_ := shipment_rec_.receiver_type;
      
      IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN          
         dis_adv_rec_.contract := contract_;
         dis_adv_rec_.receiver_id := receiver_id_;
         dis_adv_rec_.receiver_type := receiver_type_;            
      END IF;      
   END IF;
   
   Send_Dispatch_Advice_Head_Data___(receiver_address_, sender_address_, company_, company_association_no_,
                                     customer_email_id_, customer_fax_no_, customer_phone_no_, sequence_no_, version_no_, contract_,
                                     delnote_no_, order_no_, shipment_id_, receiver_id_, receiver_type_, media_code_, message_type_);
   
   IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN
      dis_adv_rec_.receiver_address := receiver_address_;
      dis_adv_rec_.sender_address := sender_address_;         
      dis_adv_rec_.company_association_no := company_association_no_;
      dis_adv_rec_.email_id := customer_email_id_;
      dis_adv_rec_.fax_no := customer_fax_no_;
      dis_adv_rec_.phone_no := customer_phone_no_;
      dis_adv_rec_.sequence_no := sequence_no_;
      dis_adv_rec_.version_no := version_no_;
      
      Create_Header_Info___(attr_,
                            message_line_,
                            dis_adv_rec_,
                            delnote_no_,
                            message_id_,
                            delivery_rec_,
                            shipment_rec_,
                            media_code_,
                            automatic_receipt_);
      
      dis_adv_rec_.dispatch_advice_lines := Dispatch_Advice_Dispatch_Advice_Line_Arr();
      dis_adv_rec_.handling_units := Dispatch_Advice_Shipment_Handl_Unit_With_History_Arr();
      
      Create_Struct_Info___(dis_adv_rec_, delnote_no_, NULL, NULL, dis_adv_rec_.receiver_id, delivery_rec_, shipment_rec_, automatic_receipt_, 'INET_TRANS');
   ELSE
      -- Create OUT_MESSAGE
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CLASS_ID',                 message_type_,    attr_);
      Client_SYS.Add_To_Attr('MEDIA_CODE',               media_code_,      attr_);
      Client_SYS.Add_To_Attr('RECEIVER',                 receiver_address_,attr_);
      Client_SYS.Add_To_Attr('SENDER',                   sender_address_,  attr_);
      Client_SYS.Add_To_Attr('APPLICATION_MESSAGE_ID',   delnote_no_,      attr_);
      Client_SYS.Add_To_Attr('APPLICATION_RECEIVER_ID',  receiver_id_,     attr_);
      
      Connectivity_SYS.Create_Message(message_id_, attr_);
      
      Create_Header_Info___(attr_,
                            message_line_,
                            dis_adv_rec_,
                            delnote_no_,
                            message_id_,
                            delivery_rec_,
                            shipment_rec_,
                            media_code_,
                            automatic_receipt_);
      
      
      Client_SYS.Add_To_Attr('N20', sequence_no_, attr_);
      Client_SYS.Add_To_Attr('N21', version_no_,  attr_);
      Client_SYS.Add_To_Attr('C90', customer_phone_no_, attr_ );
      Client_SYS.Add_To_Attr('C91', customer_fax_no_, attr_ );
      Client_SYS.Add_To_Attr('C94', customer_email_id_, attr_ );
      Client_SYS.Add_To_Attr('C95', company_association_no_, attr_ );
      Client_SYS.Add_To_Attr('C96', Customer_Info_API.Get_Association_No(receiver_id_), attr_);
      
      Connectivity_SYS.Create_Message_Line(attr_);  
      
      Create_Struct_Info___(dis_adv_rec_,
                            delnote_no_,
                            message_id_,
                            message_line_,
                            receiver_id_,
                            delivery_rec_,
                            shipment_rec_,
                            automatic_receipt_,
                            media_code_);
      
      -- 'RELEASE' the message in the Out_Message box
      Connectivity_SYS.Release_Message(message_id_);
   END IF;
   
   -- Generating an application message only for INET_TRANS flow and not required for automatic receipt flow.
   IF NOT(automatic_receipt_) AND media_code_ = 'INET_TRANS' THEN 
         json_obj_ := Dispatch_Advice_Rec_To_Json___(dis_adv_rec_);
         json_clob_ := json_obj_.to_clob;      
         Plsqlap_Server_API.Post_Outbound_Message(json_clob_,
                                                  msg_id_, 
                                                  company_,
                                                  dis_adv_rec_.receiver_address, 
                                                  message_type_ => 'APPLICATION_MESSAGE',
                                                  message_function_ => 'SEND_DISPATCH_ADVICE_INET_TRANS',
                                                  is_json_ => TRUE  );
   END IF ;
   
   Post_Send_Dispatch_Advice___(delnote_no_, shipment_id_, order_no_, media_code_, automatic_receipt_, dis_adv_rec_);
END Send_Dispatch_Advice;


-- Create_Disadv_Line
--   This creates line in the dispatch advice.
-- If a change is done to either of the EDI or ITS sections of the method please
-- revisit the other section to check if the change is required there.
PROCEDURE Create_Line (   
                          dis_adv_line_rec_  IN OUT Dispatch_Advice_Dispatch_Advice_Line_Rec,   
                          message_id_        IN     NUMBER,
                          message_line_      IN     NUMBER,
                          shipment_id_       IN     NUMBER,
                          shipment_line_no_  IN     NUMBER,
                          source_ref1_       IN     VARCHAR2,
                          source_ref2_       IN     VARCHAR2,
                          source_ref3_       IN     VARCHAR2,
                          source_ref4_       IN     VARCHAR2,
                          customer_no_       IN     VARCHAR2,
                          lot_batch_no_      IN     VARCHAR2,
                          serial_no_         IN     VARCHAR2,
                          expiration_date_   IN     DATE,
                          waiv_dev_rej_no_   IN     VARCHAR2,
                          eng_chg_level_     IN     VARCHAR2,
                          qty_shipped_       IN     NUMBER,
                          handling_unit_id_  IN     NUMBER,
                          activity_seq_      IN     NUMBER,
                          media_code_        IN     VARCHAR2 DEFAULT NULL,
                          automatic_receipt_ IN     BOOLEAN  DEFAULT FALSE)
IS
   $IF Component_Order_SYS.INSTALLED $THEN
      order_line_rec_             Customer_Order_Line_API.Public_Rec;
   $END
   shipment_line_rec_             Shipment_Line_API.Public_Rec;
   shipment_rec_                  Shipment_API.Public_Rec;
   attr_                          VARCHAR2(2000);
   shipped_qty_                   NUMBER;
   customer_part_no_              VARCHAR2(45); 
   gtin_no_                       VARCHAR2(14);
   classification_standard_       VARCHAR2(25);
   classification_part_no_        VARCHAR2(25);
   classification_unit_meas_      VARCHAR2(10);
   input_qty_                     NUMBER; 
   conv_factor_                   NUMBER;
   inverted_conv_factor_          NUMBER;
   wanted_delivery_date_          DATE;
   real_ship_date_                DATE;
   dock_code_                     VARCHAR2(35);
   sub_dock_code_                 VARCHAR2(35); 
   ref_id_                        VARCHAR2(35); 
   location_no_                   VARCHAR2(35); 
   catalog_no_                    VARCHAR2(25); 
   catalog_desc_                  VARCHAR2(200);
   inventory_part_no_             VARCHAR2(25);
   contract_                      VARCHAR2(5);
   sales_unit_meas_               VARCHAR2(10);
   input_unit_meas_               VARCHAR2(30);
   public_line_rec_               Shipment_Source_Utility_API.Public_Line_Rec;
   receiver_source_ref1_          VARCHAR2(50);
   receiver_source_ref2_          VARCHAR2(50);
   receiver_source_ref3_          VARCHAR2(50);
   receiver_source_ref4_          VARCHAR2(50);
   receiver_uom_                  VARCHAR2(50);         
   customer_part_desc_            VARCHAR2(200);    
   receiver_source_ref_type_      VARCHAR2(20);
   customer_contract_             VARCHAR2(5); 
   customer_part_conv_factor_     NUMBER;
   cust_part_invert_conv_fact_    NUMBER;
   inventory_uom_                 VARCHAR2(10);
   dispatch_source_qty_           NUMBER;
   source_ref_type_               VARCHAR2(20);
   country_of_origin_             VARCHAR2(50);
BEGIN  
   
   shipped_qty_   := qty_shipped_;   
   IF (shipment_id_ IS NULL) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         order_line_rec_              := Customer_Order_Line_API.Get(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
         classification_standard_     := order_line_rec_.classification_standard;
         classification_part_no_      := order_line_rec_.classification_part_no;
         classification_unit_meas_    := order_line_rec_.classification_unit_meas;
         dock_code_                   := order_line_rec_.dock_code;
         sub_dock_code_               := order_line_rec_.sub_dock_code;
         ref_id_                      := order_line_rec_.ref_id;
         location_no_                 := order_line_rec_.location_no;
         input_qty_                   := order_line_rec_.input_qty; 
         wanted_delivery_date_        := order_line_rec_.wanted_delivery_date;
         input_unit_meas_             := order_line_rec_.input_unit_meas;      
         conv_factor_                 := order_line_rec_.conv_factor;
         inverted_conv_factor_        := order_line_rec_.inverted_conv_factor;
         real_ship_date_              := order_line_rec_.real_ship_date; 
         catalog_no_                  := order_line_rec_.catalog_no;
         catalog_desc_                := order_line_rec_.catalog_desc;
         inventory_part_no_           := order_line_rec_.part_no;
         contract_                    := order_line_rec_.contract;
         sales_unit_meas_             := order_line_rec_.sales_unit_meas;
         customer_part_conv_factor_   := order_line_rec_.customer_part_conv_factor;
         cust_part_invert_conv_fact_  := order_line_rec_.cust_part_invert_conv_fact;
      $ELSE
         NULL;
      $END
   ELSE
      shipment_rec_                := Shipment_API.Get(shipment_id_);
      shipment_line_rec_           := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);
      -- values from shipment line                                                                  
      conv_factor_                 := shipment_line_rec_.conv_factor;
      inverted_conv_factor_        := shipment_line_rec_.inverted_conv_factor;
      catalog_no_                  := shipment_line_rec_.source_part_no;
      catalog_desc_                := shipment_line_rec_.source_part_description;
      inventory_part_no_           := shipment_line_rec_.inventory_part_no;
      sales_unit_meas_             := shipment_line_rec_.source_unit_meas;
      -- values from shipment header
      contract_                    := shipment_rec_.contract;        
      source_ref_type_             := shipment_line_rec_.source_ref_type;      
      
      public_line_rec_             := Shipment_Source_Utility_API.Get_Line(source_ref1_,
                                                                           source_ref2_,
                                                                           source_ref3_,
                                                                           source_ref4_,
                                                                           source_ref_type_);  
      
      -- source specific information
      classification_standard_     := public_line_rec_.classification_standard;
      classification_part_no_      := public_line_rec_.classification_part_no;
      classification_unit_meas_    := public_line_rec_.classification_unit_meas;
      dock_code_                   := public_line_rec_.dock_code;
      sub_dock_code_               := public_line_rec_.sub_dock_code;
      ref_id_                      := public_line_rec_.ref_id;
      location_no_                 := public_line_rec_.location_no;
      input_qty_                   := public_line_rec_.input_qty; 
      wanted_delivery_date_        := public_line_rec_.wanted_delivery_date;
      input_unit_meas_             := public_line_rec_.input_unit_meas;                               
   END IF;
   
   IF ((shipment_id_ IS NULL) OR
       (source_ref_type_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER)) THEN
      $IF Component_Order_SYS.INSTALLED $THEN        
         gtin_no_           := Sales_Part_API.Get_Gtin_No(contract_, catalog_no_, input_unit_meas_);
         IF (shipment_id_ IS NOT NULL) THEN
            order_line_rec_ := Customer_Order_Line_API.Get(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
            customer_part_conv_factor_   := order_line_rec_.customer_part_conv_factor;
            cust_part_invert_conv_fact_  := order_line_rec_.cust_part_invert_conv_fact;
         END IF;
         Customer_Order_Line_API.Get_Info_For_Desadv(receiver_source_ref1_           ,
                                                     receiver_source_ref2_           ,
                                                     receiver_source_ref3_           ,
                                                     receiver_source_ref_type_       ,
                                                     customer_part_no_               ,
                                                     customer_part_desc_             ,
                                                     customer_contract_              ,
                                                     receiver_uom_                   ,
                                                     shipped_qty_                    ,
                                                     order_line_rec_                 ,
                                                     contract_                       ,
                                                     customer_no_                    ,
                                                     inventory_part_no_              ,
                                                     gtin_no_                        ,
                                                     qty_shipped_                    );
         
         IF(customer_part_no_ IS NOT NULL) THEN 
            catalog_desc_   := Sales_Part_API.Get_Catalog_Desc(order_line_rec_.contract, order_line_rec_.catalog_no, Customer_Order_API.Get_Language_Code(source_ref1_));
         END IF;
      $ELSE
         NULL;  
      $END  
   ELSIF (source_ref_type_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN  
         IF (Receipt_Info_Manager_API.Is_Inventory_Part(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_) = 1) THEN
            shipped_qty_ := Inventory_Part_API.Get_Site_Converted_Qty(contract_, inventory_part_no_, qty_shipped_,Shipment_Order_API.Get_Receiver_Contract(source_ref1_), 'REMOVE');
         ELSE
            shipped_qty_ := qty_shipped_;
         END IF;
      $ELSE
         NULL;  
      $END      
   END IF;
   
   inventory_uom_ := Inventory_Part_API.Get_Unit_Meas(contract_, inventory_part_no_);
   dispatch_source_qty_ := ((shipped_qty_/conv_factor_ * inverted_conv_factor_)/NVL(customer_part_conv_factor_,1) * NVL(cust_part_invert_conv_fact_,1));
   country_of_origin_ := Inventory_Part_API.Get_Country_Of_Origin(contract_, inventory_part_no_);
   receiver_uom_ := NVL(receiver_uom_, sales_unit_meas_);  
   
   IF (customer_contract_ IS NOT NULL) THEN     
      IF ((Site_API.Get_Company(customer_contract_) != Site_API.Get_Company(contract_)) AND
          (inventory_part_no_ != customer_part_no_ )) THEN
         shipped_qty_ := NULL;
      END IF;
   END IF;
   
   IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN  
      dis_adv_line_rec_.source_ref1 := source_ref1_;
      dis_adv_line_rec_.source_ref2 := source_ref2_;
      dis_adv_line_rec_.source_ref3 := source_ref3_;
      dis_adv_line_rec_.source_ref4 := source_ref4_; 
      IF shipment_id_ IS NULL THEN
         dis_adv_line_rec_.real_ship_date := real_ship_date_;            
      ELSE
         dis_adv_line_rec_.shipment_line_no  := shipment_line_rec_.shipment_line_no;
         dis_adv_line_rec_.source_ref_type   := shipment_line_rec_.source_ref_type;
         dis_adv_line_rec_.real_ship_date    := shipment_rec_.actual_ship_date;
      END IF;
      dis_adv_line_rec_.source_part_no           := catalog_no_; 
      dis_adv_line_rec_.source_part_description  := catalog_desc_;
      dis_adv_line_rec_.receiver_uom             := receiver_uom_;
      dis_adv_line_rec_.receiver_source_ref1     := receiver_source_ref1_;
      dis_adv_line_rec_.receiver_source_ref2     := receiver_source_ref2_;
      dis_adv_line_rec_.receiver_source_ref3     := receiver_source_ref3_;
      dis_adv_line_rec_.receiver_source_ref_type := receiver_source_ref_type_; 
      dis_adv_line_rec_.customer_part_no         := customer_part_no_;
      dis_adv_line_rec_.customer_part_description  := customer_part_desc_;
      dis_adv_line_rec_.country_of_origin        := country_of_origin_;      
      dis_adv_line_rec_.dock_code                := dock_code_;
      dis_adv_line_rec_.sub_dock_code            := sub_dock_code_;
      dis_adv_line_rec_.ref_id                   := ref_id_;
      dis_adv_line_rec_.location_no              := location_no_; 
      dis_adv_line_rec_.lot_batch_no             := lot_batch_no_;
      dis_adv_line_rec_.serial_no                := serial_no_;
      dis_adv_line_rec_.waiv_dev_rej_no          := waiv_dev_rej_no_;
      dis_adv_line_rec_.eng_chg_level            := eng_chg_level_;
      dis_adv_line_rec_.expiration_date          := expiration_date_;
      dis_adv_line_rec_.wanted_delivery_date     := wanted_delivery_date_;
      dis_adv_line_rec_.qty_shipped              := shipped_qty_;
      dis_adv_line_rec_.shipped_source_qty       := dispatch_source_qty_;
      dis_adv_line_rec_.handling_unit_id         := handling_unit_id_;
      IF (source_ref_type_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
         dis_adv_line_rec_.activity_seq          := activity_seq_;
      END IF;
      dis_adv_line_rec_.classification_standard  := classification_standard_;
      dis_adv_line_rec_.classification_part_no   := classification_part_no_;
      dis_adv_line_rec_.classification_unit_meas := classification_unit_meas_;
      dis_adv_line_rec_.gtin_no                  := gtin_no_;  
      dis_adv_line_rec_.inventory_uom            := inventory_uom_;
      dis_adv_line_rec_.input_unit_meas          := input_unit_meas_;
      dis_adv_line_rec_.input_qty                := input_qty_;
   ELSE      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('MESSAGE_ID',   message_id_,   attr_);
      Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
      Client_SYS.Add_To_Attr('NAME',         'LINE',        attr_);
      Client_SYS.Add_To_Attr('C00',          source_ref1_,  attr_);    -- Source Ref 1
      Client_SYS.Add_To_Attr('C01',          source_ref2_,  attr_);    -- Source Ref 2
      Client_SYS.Add_To_Attr('C02',          source_ref3_,  attr_);    -- Source Ref 3
      Client_SYS.Add_To_Attr('C07',          source_ref4_,  attr_);    -- Source Ref 4
      IF (shipment_id_ IS NULL) THEN
         Client_SYS.Add_To_Attr('D01',       real_ship_date_,                     attr_); 
      ELSE
         Client_SYS.Add_To_Attr('N01',       shipment_line_rec_.shipment_line_no, attr_);  
         Client_SYS.Add_To_Attr('C10',       shipment_line_rec_.source_ref_type,  attr_);
         Client_SYS.Add_To_Attr('D01',       shipment_rec_.actual_ship_date,      attr_);
      END IF;
      
      Client_SYS.Add_To_Attr('C05', catalog_no_,                         attr_); -- Sales Part No
      Client_SYS.Add_To_Attr('C06', catalog_desc_,                        attr_); -- Sales Part Desc
      Client_SYS.Add_To_Attr('C04', receiver_source_ref1_,                attr_); 
      Client_SYS.Add_To_Attr('C12', receiver_source_ref2_,                attr_); 
      Client_SYS.Add_To_Attr('C13', receiver_source_ref3_,                attr_); 
      Client_SYS.Add_To_Attr('C21', receiver_source_ref4_,                attr_); 
      Client_SYS.Add_To_Attr('C20', receiver_source_ref_type_,            attr_);    
      Client_SYS.Add_To_Attr('C08', customer_part_no_,                    attr_); -- Customer Part No
      Client_SYS.Add_To_Attr('C09', customer_part_desc_,                  attr_); -- Customer Part Desc
      Client_SYS.Add_To_Attr('C11', receiver_uom_, attr_); -- Line No0
      
      Client_SYS.Add_To_Attr('C15', country_of_origin_, attr_); -- Line No3
      Client_SYS.Add_To_Attr('C16', dock_code_,                                                              attr_); -- Line No4
      Client_SYS.Add_To_Attr('C17', sub_dock_code_,                                                          attr_); -- Line No5
      Client_SYS.Add_To_Attr('C18', ref_id_,                                                                 attr_); -- Line No6
      Client_SYS.Add_To_Attr('C19', location_no_,                                                            attr_); -- Line No7
      
      IF(lot_batch_no_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('C80', lot_batch_no_,       attr_); -- Lot Batch No
      END IF;
      IF(serial_no_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('C81', serial_no_,          attr_); -- Serial No
      END IF;
      IF(waiv_dev_rej_no_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('C82', waiv_dev_rej_no_,    attr_); -- W/D/R No
      END IF;
      IF(eng_chg_level_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('C83', eng_chg_level_,      attr_); -- EC Level
      END IF;
      
      Client_SYS.Add_To_Attr('D00', wanted_delivery_date_,  attr_); -- Line No1
      IF (expiration_date_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('D02', expiration_date_,    attr_); 
      END IF;
      
      Client_SYS.Add_To_Attr('N02', shipped_qty_,         attr_);  -- Dispatch qty/Real ship qty
      
      Client_SYS.Add_To_Attr('N03', dispatch_source_qty_, attr_);  -- shipped_qty in sales UoM.
      
      IF (handling_unit_id_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('C89', handling_unit_id_, attr_); -- Handling Unit ID
      END IF;
      
      IF (source_ref_type_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
         Client_SYS.Add_To_Attr('N04', activity_seq_, attr_); -- Activity Sequence
      END IF;
      
      Client_SYS.Add_To_Attr('C85', classification_standard_,  attr_);
      Client_SYS.Add_To_Attr('C86', classification_part_no_,   attr_);
      Client_SYS.Add_To_Attr('C87', classification_unit_meas_, attr_);
      Client_SYS.Add_To_Attr('C88', gtin_no_,                  attr_);
      Client_SYS.Add_To_Attr('N09', input_qty_,                attr_);
      Client_SYS.Add_To_Attr('C03', input_unit_meas_,          attr_);
      Client_SYS.Add_To_Attr('C14', inventory_uom_, attr_);
      
      Connectivity_SYS.Create_Message_Line(attr_);
   END IF;
   
END Create_Line;

PROCEDURE Create_Inventory_Line___ (
   message_line_       IN OUT NUMBER, 
   dis_adv_line_arr_   IN OUT Dispatch_Advice_Dispatch_Advice_Line_Arr,  
   message_id_         IN     NUMBER,
   customer_no_        IN     VARCHAR2,
   shipment_id_        IN     NUMBER,
   shipment_line_no_   IN     NUMBER,
   source_ref_type_db_ IN     VARCHAR2,
   source_ref1_        IN     VARCHAR2,
   source_ref2_        IN     VARCHAR2,
   source_ref3_        IN     VARCHAR2,
   source_ref4_        IN     VARCHAR2,
   handling_unit_flag_ IN     VARCHAR2,
   media_code_         IN     VARCHAR2,
   automatic_receipt_  IN     BOOLEAN)
IS
   reservation_tab_   Shipment_Source_Utility_API.Reservation_Tab;
   handling_unit_number_ NUMBER;
   dis_adv_line_rec_   Dispatch_Advice_Dispatch_Advice_Line_Rec;
BEGIN
   reservation_tab_ := Shipment_Source_Utility_API.Get_Reserv_Info_On_Delivered(source_ref1_,source_ref2_,source_ref3_, source_ref4_,
                                                                                source_ref_type_db_, shipment_id_);
   IF (handling_unit_flag_ = 'N') THEN
      handling_unit_number_ := NULL;
   END IF;
   IF (reservation_tab_ IS NOT NULL) THEN
      IF (reservation_tab_.COUNT > 0) THEN        
         FOR i IN reservation_tab_.FIRST..reservation_tab_.LAST LOOP
            IF (handling_unit_flag_ = 'Y') THEN
               handling_unit_number_ := reservation_tab_(i).handling_unit_id;
            END IF; 
            
            IF automatic_receipt_ OR media_code_ = 'INET_TRANS' THEN
               dis_adv_line_arr_.extend();
               Create_Line(dis_adv_line_rec_ => dis_adv_line_arr_(dis_adv_line_arr_.last),                     
                           message_id_       => message_id_,
                           message_line_     => message_line_,
                           shipment_id_      => shipment_id_,
                           shipment_line_no_ => shipment_line_no_,
                           source_ref1_      => source_ref1_,
                           source_ref2_      => source_ref2_,
                           source_ref3_      => source_ref3_,
                           source_ref4_      => source_ref4_,
                           customer_no_      => customer_no_,
                           lot_batch_no_     => reservation_tab_(i).lot_batch_no,
                           serial_no_        => reservation_tab_(i).serial_no,
                           expiration_date_  => reservation_tab_(i).expiration_date,
                           waiv_dev_rej_no_  => reservation_tab_(i).waiv_dev_rej_no,
                           eng_chg_level_    => reservation_tab_(i).eng_chg_level,
                           qty_shipped_      => reservation_tab_(i).qty_shipped,
                           handling_unit_id_ => handling_unit_number_,
                           activity_seq_     => reservation_tab_(i).activity_seq,
                           media_code_       => media_code_,
                           automatic_receipt_ => automatic_receipt_);   
            ELSE
               message_line_ := message_line_ + 1;
               Create_Line(dis_adv_line_rec_ => dis_adv_line_rec_,                     
                           message_id_       => message_id_,
                           message_line_     => message_line_,
                           shipment_id_      => shipment_id_,
                           shipment_line_no_ => shipment_line_no_,
                           source_ref1_      => source_ref1_,
                           source_ref2_      => source_ref2_,
                           source_ref3_      => source_ref3_,
                           source_ref4_      => source_ref4_,
                           customer_no_      => customer_no_,
                           lot_batch_no_     => reservation_tab_(i).lot_batch_no,
                           serial_no_        => reservation_tab_(i).serial_no,
                           expiration_date_  => reservation_tab_(i).expiration_date,
                           waiv_dev_rej_no_  => reservation_tab_(i).waiv_dev_rej_no,
                           eng_chg_level_    => reservation_tab_(i).eng_chg_level,
                           qty_shipped_      => reservation_tab_(i).qty_shipped,
                           handling_unit_id_ => handling_unit_number_,
                           activity_seq_     => reservation_tab_(i).activity_seq,
                           media_code_       => media_code_); 
            END IF;
            
         END LOOP;
      END IF; 
   END IF;
   
END Create_Inventory_Line___;
