-----------------------------------------------------------------------------
--
--  Logical unit: CreateDeliveryNote
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201130  PamPlk  GESPRING20-6039, Modified the condition to proceed if gelr functionality applicable by allowing creating new delivery note in Create_Shipment_Deliv_Note().
--  200617  WaSalk  SC2020R1-7346, Modified condition to not to  proceed if gelr functionality applicable, avoiding creating new delivery note in Create_Shipment_Deliv_Note().
--  170505  MaIklk  STRSC-7956, Removed SHIP_RECEIVER_ADDR from join in Create_Shipment_Delivery_Note and used shipment table to fetch data.
--  161018  MaRalk  LIM-9153, Modified Create_Shipment_Deliv_Note by renaming some of the variables with the prefix 'receiver'.
--  161018          Modified cursor get_shipment_data_ to reflect column renaming of the view SHIP_RECEIVER_ADDR.
--  161012  MaIklk  LIM-8866, Used Ship_Receiver_Addr instead of customer_info_Address_public in Create_Shipment_Deliv_Note().
--  160815  MaIklk  LIM-8136, Used header source ref type instead of receiver type for Shipment_Source_Utility_API.Post_Del_Note_Invalid_Action/Post_Create_Deliv_Note.
--  160704  MaRalk  LIM-7671, Modified method Create_Shipment_Deliv_Note by removing the parameter originating_co_lang_code_
--  160630          which having no value assigned and instead used the value fetching from the cursor get_shipment_data_.
--  160608  MaIklk  LIM-7442, CreateOrderDeliveryNote has been renamed to CreateDeliveryNote and moved to SHPMNT.
--  160608          Also made the package as TRUE component.
--  160516 Chgulk  STRLOC-80, Added New Address fields.
--  160426 RoJalk  LIM-6631, Modified Connect_Order_To_Deliv_Note - get_shipment_line to include NVL handling. 
--  160223 RoJalk  LIM-4188, Modified Connect_Order_To_Deliv_Note method and used SHIPMENT_LINE_PUB instead of SHIPMENT_LINE_TAB.
--  160212 MaRalk  LIM-4188, Modified method Create_Shipment_Deliv_Note by replacing the usage of Shipmnet_Tab with Shipment_Pub.
--  160202 MaRalk  LIM-6114, Modified method Create_Shipment_Deliv_Note in order to reflect the 
--  160202         column name change ship_addr_no as receiver_addr_id in shipment_tab.
--  160126 RoJalk  LIM-5387, Modified get_shipment_line to include source_ref_type. 
--  151202 RoJalk  LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202         SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit.  
--  151110 MaIklk  LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110 RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151109 MaEelk  LIM-4453, Removed pallet_id_ from Customer_Order_Reservation_API calls
--  150612 MHAPLK  KES-665, Modified Disconn_Reserve_From_Delnote__() to set the delivery note no as NULL for shipment connected order lines. 
--  150612         Modified Create_Shipment_Deliv_Note() to create new delivery note if the existing delivery note is in Invalid state.
--  150526 IsSalk  KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150504 JeLise  LIM-1893, Added handling_unit_id_ in LU calls where applicable.
--  130704 ChJalk  TIBE-958, Modified Set_Receipt_Ref_On_Receipt___ to use conditional compilation.
--  130417 JeeJlk  Modified Create_Ord_Pre_Ship_Del_Note__ and Create_Shipment_Deliv_Note to pass originating_co_lang_code to Customer_Order_Deliv_Note_API.New.
--  130227 SALIDE  EDEL-2020, Replaced the use of company_name2 with the name from customer_info_address (ENTERP).
--  130103 GiSalk  Bug 107491, Modified Create_Pre_Ship_Del_Notes__() by adding ORDER BY statement to the cursor get_pre_ship_data.
--  121203 SBalLK  Bug 106195, Modified Create_Shipment_Deliv_Note() to create delivery note with correct address flag for sending ean_location_delivery_address with Dispatch Advice Message.
--  121031 RoJalk  Allow connecting a customer order line to several shipment lines - modified the parameter list to the method 
--  121031         calls Customer_Order_Reservation_API.Modify_Delnote_No and passed shipment id.
--  120608 SBallk  Bug 102291, Modified Connect_Line_To_Deliv_Note___, Connect_Reserve_To_Del_Note___, Conn_Order_To_Pre_Del_Note__ and Disconn_Reserve_From_Delnote__ to fetch branch specific delivery note number.
--  120412 AyAmlk  Bug 100608, Increased the length of delivery_terms_ in Create_Shipment_Deliv_Note().
--  110629 AmPalk  Bug 94949, Added Set_Receipt_Ref_On_Receipt___. Modified Connect_Order_To_Deliv_Note to call methods from Distribution Order LU to update PO receipt with the delivery note. 
--  110127 NeKolk  EANE-3744  added where clause to the View CREATE_PRE_SHIP_DELIVERY_NOTE .
--  100505 MaMalk  Bug 90002, Modified Create_Ord_Pre_Ship_Del_Note__ and Conn_Order_To_Pre_Del_Note__ to create the pre-ship delnote per location. 
--  100513 Ajpelk  Merge rose method documentation
--  090603 DaGulk  Bug 83173, Reuse constant DELNOCREATEDHEAD instead of DELNOCREATED.
--  090527 SuJalk  Bug 83173, Modified the error constant to DELNOCREATED to avoid duplicating the error constant for different messages in method Connect_Line_To_Deliv_Note___.
--  080618 DaZase  Bug 71443, Modified the CURSOR get_line in method Connect_Order_To_Deliv_Note by adding new condition for checking deliver_to_customer_no.
--  080207 NaLrlk  Bug 70005, Modified the Where condition in cursor select stmt in methods Conn_Order_To_Pre_Del_Note__ and  Connect_Order_To_Deliv_Note.
--  080130 NaLrlk  Bug 70005, Added parameter del_terms_location in server calls Customer_Order_Deliv_Note_API.New() in the
--  080130         methods Create_Ord_Pre_Ship_Del_Note__  and Create_Shipment_Deliv_Note
--  070806 MaJalk  Modified Disconn_Reserve_From_Delnote__ to create CO history notes when invalidating Pre-Ship delivery note.
--  070312 NaLrlk  Added methods Disconn_Reserve_From_Delnote__, Invalidate_Pre_Ship_Delnote and Find_Pre_Ship_Delivery_Note.
--  070308 NaLrlk  Added the method parameter with attr_ Create_Pre_Ship_Del_Notes__
--  070307 AmPalk  Added Create_Pre_Ship_Del_Notes__, Create_Ord_Pre_Ship_Del_Note__, Conn_Order_To_Pre_Del_Note__ and Connect_Reserve_To_Del_Note___.
--  070307         Removed Create_Prelimin_Deliv_Note.
--  070306 AmPalk  Added CREATE_PRE_SHIP_DELIVERY_NOTE.
--  070306 IsAnlk  Removed method call to Customer_Order_Deliv_Note_API.Get_Preliminary_Delnote_No.
--  070122 NaWilk  Removed parameters Del_terms_desc and Ship_via_desc from Create_Prelimin_Deliv_Note, Customer_Order_Deliv_Note_API.New
--  070122         and Customer_Order_Deliv_Note_API.Get_Preliminary_Delnote_No.
--  070119 NaWilk  Removed usage of Ship_Via_Desc and Delivery_terms_desc from where clause of cursor get_line.
--  060928 IsWilk  Removed the SUBSTR of addr_1_ when calling Customer_Order_Deliv_Note_API.New in PROCEDURE Create_Shipment_Deliv_Note.
--  060725 ChJalk  Modified call Mpccom_Ship_Via_Desc_API.Get_Description to Mpccom_Ship_Via_API.Get_Description
--  060725         and Order_Delivery_Term_Desc_API.Get_Description to Order_Delivery_Term_API.Get_Description.
--  060516 SaRalk  Enlarge Address - Changed variable definitions.
--  060509 SaRalk  Enlarge Forwarder - Changed variable definitions.
--  060419 NaLrlk  Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 -----------------------------------------
--  060216 MaRalk  Bug 55958, Modified Procedure Connect_Order_To_Deliv_Note.
--  050718 KanGlk    Modified Create_Shipment_Deliv_Note; SubString - 100 varchar2 length addr_1_ to 35, which fetched from CUST_ORD_CUSTOMER_ADDRESS_TAB.
--  050216 IsAnlk    Modified SHIPMENT_CONNECTED as VARCHAR2 and changed the code accordingly.
--  050118 UsRalk  Renamed CustomerNo attribute on Shipment LU to DeliverToCustomerNo.
--  040831 KeFelk  Removed contact from Create_Prelimin_Deliv_Note & Create_Shipment_Deliv_Note.
--  040728 WaJalk  Added new parameter contact_ to method Create_Prelimin_Deliv_Note.
--  040721 KeFelk  Modified Create_Shipment_Deliv_Note().
--  040629 WaJalk  Added new parameter deliver_to_customer_no_ in methods Connect_Order_To_Deliv_Note
--  040629         and Create_Prelimin_Deliv_Note.
--  040331  ChJalk Bug 43762, Modified the FUNCTION Delivery_Note_To_Be_Created__.
--  040329  JoEd   Changed parameter order in call to Customer_Order_Deliv_Note_API.New in
--                 Create_Shipment_Deliv_Note.
--  040116  SaRalk Bug 41681, Removed DEFAULT NULL condition in parameters delivery_terms_ and
--  040116         delivery_terms_desc_ in procedure Create_Prelimin_Deliv_Note.
--  ********************* VSHSB Merge End*****************************
--  020308  MaGu  Added method Create_Shipment_Deliv_Note. Modified method Connect_Order_To_Deliv_Note.
--                Added cursor get_shipment_line to connect all shipment order lines
--                to a delivery note that is connected to a shipment.
--  020204  MaGu  Modified cursor get_lines in method Connect_Order_To_Deliv_Note so that
--                order lines connected to a shipment will not be added on the delivery note.
--  ********************* VSHSB Merge Start*****************************
--  030909 ErSolk Bug 38541, Modified procedure Connect_Order_To_Deliv_Note.
--  030804 ChFolk Performed SP4 Merge. (SP4Only)
--  030320 SaRalk Bug 35939, Modified Procedure Connect_Order_To_Deliv_Note.
--  030227 ThAjLk Bug 35939, Modified the Procedures Connect_Order_To_Deliv_Note and Connect_Order_To_Deliv_Note.
--  020322 SaKaLk Call 77116(Foreign Call 28170). Added county to calling methods in Customer_Order_Deliv_Note_API
--                'New' and 'Get_Preliminary_Delnote_No' parameter list. Also added it to Create_Prelimin_Deliv_Note.
--  020109  GaJalk Bug fix 27084, In the procedure Connect_Order_To_Deliv_Note, in the cursor get_line compared ShipViaDesc between order line and delivery note.
--                 Modified the procedure Create_Prelimin_Deliv_Note.
--  001221  JoAn  Changed comparision for address info in Connect_Order_To_Deliv_Note
--                to use new address format.
--  000922  MaGu  Changed to new address format in Create_Prelimin_Deliv_Note.
--  000913  FBen  Added UNDEFINE.
--  ---------------------- 12.1 ---------------------------------------------
--  000419  PaLj  Corrected Init_Method Errors
--  000124  JoEd  Bug fix 13497. Performance problems in Connect_Order_To_Deliv_Note.
--                Changed cursor to use EXISTS instead of IN (SELECT ...)
--  ---------------------- 11.2 ---------------------------------------------
--  991020  JoEd  Added ship_via_desc to Create_Prelimin_Deliv_Note.
--  990921  JoEd  Added nvl check in cursor in Connect_Order_To_Deliv_Note.
--  990914  JoEd  Added new parameters to Create_Prelimin_Deliv_Note.
--  990913  JoEd  Changed Connect_Order_To_Deliv_Note to handle multiple
--                delivery notes.
--  ---------------------- 11.1 ---------------------------------------------
--  990409  JakH  Use of tables instead of views.
--  990114  RaKu  Moved procedure Barcode_Id_Already_Used to LU PackageVerification.
--  990108  RaKu  Added procedure Barcode_Id_Already_Used.
--  981204  RaKu  Changed New_Delivery_Note__ to Connect_Order_To_Deliv_Note.
--                Added procedure Create_Prelimin_Deliv_Note.
--  980330  JoAn  SID 2859 Changed Connect_Order_To_Deliv_Note___ so that lines
--                with supply code Purchase order direct are connected, this will
--                make it possible to include theese lines when sending a
--                dispatch advise message.
--  971120  RaKu  Changed to FND200 Templates.
--  970924  JoAn  Removed quotes in text passed to Translate_Constant due
--                to translation problems
--  970515  JOED  Fixed Translate_Constant calls with extra parameters.
--  970417  JOED  Removed objstate from Customer_Order_History_API.New
--                and Customer_Order_Line_Hist_API.New.
--  970416  JOED  Changed call to Customer_Order_History_API.
--                Changed call to Customer_Order_Line_Hist_API.
--  961212  JoAn  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_       CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Post_Create_Deliv_Note (
   delnote_no_    IN VARCHAR2,
   shipment_id_   IN NUMBER)
IS 
BEGIN    
   IF (shipment_id_ IS NULL) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Deliver_Customer_Order_API.Connect_Order_To_Deliv_Note(delnote_no_);
      $ELSE
         NULL;
      $END
   ELSE
      Shipment_Source_Utility_API.Post_Create_Deliv_Note(delnote_no_, Shipment_API.Get_Source_Ref_Type_Db(shipment_id_));
   END IF;   
END Post_Create_Deliv_Note;


PROCEDURE Post_Del_Note_Invalid_Action (
   delnote_no_    IN VARCHAR2,
   shipment_id_   IN NUMBER)
IS     
BEGIN        
   IF (shipment_id_ IS NULL) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Reservation_API.Disconn_Reserve_From_Delnote(delnote_no_);
      $ELSE
         NULL;
      $END  
   ELSE
      -- Same order method will be called through shipment source utility for order connected shipment.
      Shipment_Source_Utility_API.Post_Del_Note_Invalid_Action(delnote_no_, Shipment_API.Get_Source_Ref_Type_Db(shipment_id_));
   END IF;   
END Post_Del_Note_Invalid_Action;

                        
-- Create_Shipment_Deliv_Note
--   Checks if a delivery note already exists for
--   specified shipment_id. If not, the procedure creates one.
--   It returns the ID of the delivery note found or the one
--   that just has been created
PROCEDURE Create_Shipment_Deliv_Note (
   delnote_no_  OUT VARCHAR2,
   shipment_id_ IN  NUMBER )
IS
   delnote_                   VARCHAR2(15);
   order_dummy_               VARCHAR2(12);
   receiver_addr_id_          shipment_tab.receiver_addr_id%TYPE;
   single_occ_addr_flag_db_   VARCHAR2(1);
   receiver_addr_name_        VARCHAR2(100);
   receiver_address1_         VARCHAR2(35);
   receiver_address2_         VARCHAR2(35);
   receiver_address3_         VARCHAR2(100);
   receiver_address4_         VARCHAR2(100);
   receiver_address5_         VARCHAR2(100);
   receiver_address6_         VARCHAR2(100);
   receiver_zip_code_         VARCHAR2(35);
   receiver_city_             VARCHAR2(35);
   receiver_county_           VARCHAR2(35);
   receiver_state_            VARCHAR2(35);
   receiver_country_          VARCHAR2(2);
   route_id_                  VARCHAR2(12):= NULL;
   forward_agent_id_          shipment_tab.forward_agent_id%TYPE;
   ship_via_code_             VARCHAR2(3);
   language_code_             VARCHAR2(2);
   delivery_terms_            VARCHAR2(5);
   del_terms_location_        VARCHAR2(100);
   receiver_id_               shipment_tab.receiver_id%TYPE;   
   delnote_state_             VARCHAR2(20);  
   -- gelr:alt_delnote_no_chronologic, begin
   contract_                  VARCHAR2(5);
   -- gelr:alt_delnote_no_chronologic, end
   
   CURSOR get_shipment_data_ IS
      SELECT s.receiver_addr_id, s.forward_agent_id, s.ship_via_code, s.language_code, s.addr_flag, 
             s.receiver_address1, s.receiver_address2, s.receiver_address3, s.receiver_address4, s.receiver_address5, s.receiver_address6, 
             s.receiver_zip_code, s.receiver_city, s.receiver_county, s.receiver_state, s.receiver_country, 
             s.receiver_address_name, s.delivery_terms, s.receiver_id, s.del_terms_location
        FROM shipment_tab s
       WHERE shipment_id      = shipment_id_;
BEGIN
   -- Check if there is already one delivery note created for this shipment
   delnote_ := Delivery_Note_API.Get_Delnote_No_For_Shipment(shipment_id_);
   delnote_state_ := Delivery_Note_API.Get_Objstate(delnote_);
   contract_ := Shipment_API.Get_Contract(shipment_id_);
   IF ((delnote_ IS NULL) OR (delnote_ IS NOT NULL AND delnote_state_ = 'Invalid'))THEN
      OPEN get_shipment_data_;
      FETCH get_shipment_data_ INTO receiver_addr_id_, forward_agent_id_, ship_via_code_, language_code_, single_occ_addr_flag_db_, 
                                    receiver_address1_, receiver_address2_,receiver_address3_,receiver_address4_, receiver_address5_, receiver_address6_, 
                                    receiver_zip_code_, receiver_city_, receiver_county_, receiver_state_, receiver_country_, receiver_addr_name_,
                                    delivery_terms_, receiver_id_, del_terms_location_;      
      CLOSE get_shipment_data_;           
      -- Create a delivery note. 
      Delivery_Note_API.New(delnote_, order_dummy_, receiver_addr_id_, NVL( single_occ_addr_flag_db_, 'Y'), receiver_addr_name_, 
                            receiver_address1_, receiver_address2_, receiver_address3_, receiver_address4_, receiver_address5_, receiver_address6_,
                            receiver_zip_code_, receiver_city_, receiver_state_, receiver_county_, receiver_country_, 
                            route_id_, forward_agent_id_, ship_via_code_, delivery_terms_, shipment_id_, receiver_id_,
                            pre_ship_invent_loc_no_ => NULL, 
                            del_terms_location_ => del_terms_location_,
                            source_lang_code_ => language_code_);            
   END IF;
   -- Return delivery note number for the bypassed criteria
   delnote_no_ := delnote_;
END Create_Shipment_Deliv_Note;



