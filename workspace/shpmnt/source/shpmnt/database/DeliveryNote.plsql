-----------------------------------------------------------------------------
--
--  Logical unit: DeliveryNote
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220517  SaLelk  SCDEV-7911, Modified Check_Update___ by calling Shipment_Source_Utility_API.Validate_Receiver_Id method. 
--  211207  PraWlk  FI21R2-7673, Modified No_Delivery_Note_For_Services___() to consider project deliverables as well for the shipment.
--  210223  Aabalk  SC2020R1-12430, Reverted changes from SCSPRING20-176 modifying New() and Check_Insert___() to store on single occurrence addresses,
--  210126  RoJalk  SC2020R1-11621, Modified Generate_Alt_Delnote_No___, Set_Dispatch_Advice_Sent, Set_Pre_Ship_Delivery_Made, 
--  210126          Set_Dirdel_Sequence_Version, Set_Desadv_Sequence_Version to call Modify___ instead of Unpack methods.
--  201130  PamPlk  GESPRING20-6039, Modified Get_Delnote_No_For_Shipment() by reverting the corrections of SC2020R1-7346.
--  201027  WaSalk  SC2020R1-10871, Modified Validate_Delivery_Info___() by adding two error messages to validate applied date of delivery note as earlier than creation snd ship date. 
--  200709  WaSalk  Bug 153935(SCZ-10210), Modified Get_Shipment_Dis_Adv_Send_Db() by filtering only the SENT dispatch advices.
--  200702  DiJwlk  Bug 154639 (SCZ-10401), Modified Get_Shipment_Net_Summary() by adding UncheckedAccess annotation
--  200617  WaSalk  SC2020R1-7346, Modified Get_Delnote_No_For_Shipment() to select Invalid Delnote_no when gelr functionalities applicable.
--  200518  MalLlk  GESPRING20-4424, Added No_Delivery_Note_For_Services___() and called it inside New() to avoid creating delivery note when
--  200518          company localization parameter 'NO_DELIVERY_NOTE_FOR_SERVICES' is true and if all the lines contain part type 'SERVICE'.
--  200423  WaSalk  GESPRING20-4239, Added Check_Shipment_Delivered() to raise an error massege if shipment not delivered in Italy localizations enable.
--  200331  WaSalk  GESPRING20-3913, Added Generate_Alt_Delnote__() to access  Generate_Alt_Delnote___().
--  200319  WaSalk  GESPRING20-533, Added Generate_Alt_Del_Note_No() and a condition to New() to support Alt_Delnote_No_Chronologic localization.
--  200316  WaSalk  GESPRING20-3910, Modified New() by to call Generate_Alt_Delnote___ only if AltDelNoteNoChronologic localization not enabled.  
--  200207  Dihelk  GESPRING20-1790, Added the Eur-pallet Qut correction to Check_Common___().
--  200120  MeAblk  SCSPRING20-1770, Added NVL() handling for qty_shipdiff in Get_Remaining_Qty().
--  200207  Dihelk  GESPRING20-3671, Added the delevery reason correction to Check_Insert___().
--  200109  WaSalk  GESPRING20-1622, Added Validate____(), Get_Contract() and Modified Insert___(),Check_Insert___(),Check_Update___() according to the localization Modified Date Applied.
--  191122  MeAblk  SCSPRING20-176, Modified the New() and Check_Insert___() methods to make it possible to store the receiver address when non single occurance.
--  191115  MeAblk  SCSPRING20-934, Increased the length of receiver_id upto 50 characters.
--  191015  MeAblk  SCSPRING20-538, Modified method call Shipment_Source_Utility_API.Validate_Receiver_Id() by adding contract_ parameter.
--  190102  RasDlk  SCUXXW4-4749, Added funtion Calculate_Totals() to support totals in ShipmentDeliveryNoteAnalysis Projection.
--  170926  MAHPLK  STRSC-11377, Removed Methods Get_Objstate
--  170126  MaIklk  LIM-10461, Used Shipment_API.Receiver_Address_Exist call instead of Shipment_Source_Utility_API.
--  161107  RoJalk  LIM-8391, Replaced Shipment_Handling_Utility_API.Shipment_Structure_Exist with Shipment_API.Shipment_Structure_Exist.
--  161103  ErFelk  Bug 132046, Modified Modify() by placing the missing Update___() statement.
--  160725  ErFelk  Bug 126329, Modified Get_Shipment_Net_Summary() by placing the calls to get gross_total_ and total_volume_, outside the condition of Shipment_Structure_Exist.
--  160713  RoJalk  LIM-8090, Replaced Shipment_API.Get_Actual_Ship_Date with Shipment_API.Get_Consol_Actual_Ship_Date.
--  160704  MaRalk  LIM-7671, Renamed columns deliver_to_customer_no, originating_co_lang_code, ship_addr_no, 
--  160704          ship_address1-6, ship_city, ship_county, ship_state, ship_zip_code, country_code, addr1 
--  160704          and addr_flag to new names and modified usages. Renamed method parameters of New method.
--  160614  MaIklk  STRSC-2638, Added Get_Remaining_Qty() and Get_Delivered_Qty().
--  160608  MaIklk  LIM-7442, CustomerOrderDelivNote has been renamed to DeliveryNote and moved to SHPMNT.
--  160608          Also made the package as TRUE component.
--  160516  Chgulk  STRLOC-80, Added new Address Fields.
--  160506  Chgulk  STRLOC-369, used the correct package.
--  160307  DipeLK  STRLOC-247,Change Validate_Address() method call to Address_validation_API.Validate_Address
--  160307  MaIklk LIM-4670, Used Get_Partca_Net_Weight() and Get_Config_Weight_Net() in Part_Weight_Volume_Util_API.
--  160211  RoJalk LIM-4730, Modified Get_Shipment_Net_Summary and used shipment_line_pub.  
--  150210  MaIklk LIM-4138, Added Print_Delivery_Note_Allowed().
--  151202  RoJalk LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202         SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit.  
--  151110  MaIklk LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110  RoJalk LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  150819  PrYaLK Bug 121587, Modified Get_Shipment_Net_Summary() by adding cust_part_invert_conv_fact.
--  150723  PrYaLK Bug 123113, Modified Get_Actual_Ship_Date() to fetch the actual_ship_date_.
--  150612  MAHPLK KES-665, Modified Get_Delnote_No_For_Shipment() to filter the delivery note with Invalid state.
--  150526  IsSalk KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  140702  MaEdlk Bug 117072, Removed rounding of gross_total_, net_total_ and total_volume_ OUT parameters of method Get_Net_Summary.
--  140227  MatKse Bug 115429, Added Get_Id_Version_By_Keys and Get_Status.
--  130726  MaEelk Modified Get_Shipment_Net_Summary and replaced package structure codes with handling unit related codes
--  130726  Maeelk Modified Get_Shipment_Net_Summary to replace Sales_Part_API.Get_Weight with Sales_Part_API.Get_Partca_Net_Weight.
--  130417  JeeJlk Added new column ORIGINATING_CO_LANG_CODE.
--  130227  SALIDE EDEL-2020, Removed the join to cust_ord_customer_address in CUSTOMER_ORDER_DELIV_NOTE and CUSTOMER_ORDER_DELIV_NOTE_UIV
--  130227                    and get the name from CUSTORD_ADDRESS which is the name from customer info address.
--  120920  GiSalk Bug 101901, Modified Generate_Alt_Delnote___() to retrieve branch using Invoice_Customer_Order_API.Get_Branch().
--  120615  SBallk Bug 102291, Added alt_delnote_no to the DELIVERY_NOTE_JOIN view to display alter delivery note number to the user.
--  120412  AyAmlk Bug 100608, Increased the column length of delivery_terms to 5 in views CUSTOMER_ORDER_DELIV_NOTE, CUSTOMER_ORDER_DELIV_NOTE_UIV
--  120412         and DELIVERY_NOTE_JOIN.
--  120312  MaMalk Bug 99430, Modified the code to consider inverted_conv_factor where conv_factor has been considered.
--  120126  ChJalk Modified the view comments of addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, ship_addr_no and pre_ship_delivery_made in the base view.
--  111215  MaMalk Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111205  MaMalk Added pragma to Get_Net_Summary and Get_Shipment_Net_Summary.
--  110818  AmPalk Bug 93557, In Unpack_Check_Update___ and Unpack_Check_Insert___ validated country, state, county and city.
--  110712  MaMalk Added the user allowed site filter to CO_DELIV_NOTE_LINE.
--  110711  ChJalk Modified usage of view CUSTOMER_ORDER to CUSTOMER_ORDER_TAB in cursors.
--  110707  MaMalk Added the user allowed site filteration to SHIPMENT_DELIV_NOTE_LINE.
--  110525  ChJalk Modified the method Get_Net_Summary to consider the delivered qty when calculating total_gross_weight_ and total_volume_.
--  110514  NaLrlk Modified the method Get_Net_Summary to fetch the correct volume and weight.
--  110303  PaWelk EANE-3744, Added new view CUSTOMER_ORDER_DELIV_NOTE_UIV.
--  110131  Nekolk  EANE-3744  added where clause to View CUSTOMER_ORDER_DELIV_NOTE,DELIVERY_NOTE_JOIN
--  101025  NiDalk Bug 93730, Increased substr length of addr_1 to 100.
--  100604  MoNilk Replaced ApplicationCountry with IsoCountry to represent correct relationship in overviews.
--  100517  Ajpelk Merge rose method documentation.
--  091222  MaRalk Modified the state machine according to the new template. 
--  090930  MaMalk Removed constant state_separator_. Modified Finite_State_Init___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  100308  NaLrlk Modified the view VIEWJOIN to make null the customer_no in shipment delivery.
--  090522  NWeelk Bug 82382, Modified procedures New and Generate_Alt_Delnote___ to generate an Alt_Delnote_No for the shipment.
--  090609  NaLrlk Added method Get_Actual_Ship_Date and Get_Shipment_Net_Summary.
--  090603  NaLrlk Added method Get_Net_Summary.
--  090521  NaLrlk Added views SHIPMENT_DELIV_NOTE_LINE and CO_DELIV_NOTE_LINE.
--  090515  NaLrlk Added view DELIVERY_NOTE_JOIN.
--  080130  NaLrlk Bug 70005, Added public column del_terms_location and Added parameter del_terms_location_ to method New.
--  071203  PrPrlk Bug 68771, Added new methods Set_Dirdel_Sequence_And_Version and Set_Desadv_Sequence_And_Version that sets the sequence and version when an delivery note and dispatch advice is transferred.
--  071203         Updated the relevent methods to handle the new columns  DIRDEL_SEQUENCE_NO, DIRDEL_VERSION_NO, DESADV_SEQUENCE_NO and DESADV_VERSION_NO.
--  070319  NaLrlk Modified the methods Set_Invalid and Set_Invalid___.
--  070312  NaLrlk Added procedure Set_Invalid.
--  070308  IsAnlk Modified New method to connect orders to pre ship del notes.
--  070306  IsAnlk Modified state machine to include Invalid state and removed the created state. Added method Generate_Alt_Delnote___.
--  070305  AmPalk Added Pre_Ship_Invent_LocNo and Pre_Ship_Delivery_Made.
--  070302  MoMalk Bug 63503, Modified view CUSTOMER_ORDER_DELIV_NOTE, to handle single occurance and non-single occurance separately via a UNION.
--  070227  MaMalk Bug 63401, Made attribute deliver_to_customer_no mandatory in the LU. Modified view comments of base view and added check not null to UCI.
--  070119  NaWilk Removed delivery_terms_desc and Ship_Via_Desc.
--  060817  IsWilk Removed the SUBSTR 35 to addr_1 and ,modified the view comment in &VIEW.
--  060608  MaMalk Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to check the existence of the ship_addr_no when addr_flag is 'N'.
--  060517  MiErlk Enlarge Identity - Changed view comment
--  060420  RoJalk Enlarge Customer - Changed variable definitions.
--  060418  NaLrlk Enlarge Identity - Changed view comments of customer_no and deliver_to_customer_no.
--  ------------------------- 13.4.0 -----------------------------------------
--  060324  SaJjlk Removed condition in method New() for ship_Addr_No.
--  060126  MiKulk Modified the New method to assign the Ship_Addr_No based on the addr_flag.
--  060117  MaHplk Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  051026  PrPrlk Bug 54155, Added new public method Check_Exist().
--  050926  NaLrlk Removed unused variables
--  050117  UsRalk Changed references to Shipment_API.Get_Customer_No to Shipment_API.Get_Deliver_To_Customer_No.
--  041105  KeFelk Added deliver_to_customer_no for retrive data for Delivery notes.
--  040831  KeFelk Removed contact. And deliver_to_customer_no from Get_Preliminary_Delnote_No.
--  040728  WaJalk Added new public attribute contact.
--  040721  KeFelk Modified Get_Preliminary_Delnote_No().
--  040715  KeFelk More Changes regarding deliver_to_customer_no.
--  040714  KeFelk Changes regarding deliver_to_customer_no.
--  040629  WaJalk Added new public attribute deliver_to_customer_no.
--  040219  IsWilk Removed the SUBSTRB from the view and modified the SUBSTRB to SUBSTR for Unicode Changes.
--  040116  SaRalk Bug 41681, Removed DEFAULT NULL condition in parameters delivery_terms_ and
--  040116         delivery_terms_desc_ in procedures Get_Preliminary_Delnote_No and New.
--  ********************* VSHSB Merge End*****************************
--  020503  ARAM  Added public method Is_Delivery_Note_Exist.
--  020506  MaGu  Modified method Insert___ so that correct create_date will be fetched
--                for delivery notes for a shipment
--  020410  Prinlk  Added public method Get_Shipment_Dis_Adv_Send_Db to check whether the dispatch advice has been
--                       send or not.
--  020308  MaGu  Added method Get_Delnote_No_For_Shipment.
--  020306  MaGu  Added new public attribute shipment_id. Also added parameter shipment_id
--                to method New.
--  ********************* VSHSB Merge Start*****************************
--  030731 ChIwlk Performed SP4 Merge.
--  030729 SuAmlk Modified procedure Generate_Alt_Delnote_No to include '-' in alt_delnote_no.
--  030728 SuAmlk Modified type of parameter number_series_ in the procedure Generate_Alt_Delnote_No.
--  030226 ThAjLk Bug 35939, Added two columns Delivery_Terms and Delivery_Terms_Desc to CUSTOMER_ORDER_DELIV_NOTE_TAB
--  030226        and to the main view. Modified the Functions New, Get and Get_Preliminary_Delnote_No.
--  030131 SuAmlk Modified procedure Generate_Alt_Delnote_No to exclude '-' from alt_delnote_no.
--  030129 SuAmlk Added public attribute alt_delnote_no and the procedure Generate_Alt_Delnote_No.
--  020618  AjShlk  Bug 29312, Added attribute county to Update_Ord_Address_Util_API.Get_Order_Address_Line.
--  020322 SaKaLk Call 77116(Foreign Call 28170). Added ship_county to public methods
--                'New' and 'Get_Preliminary_Delnote_No' parameter list.
--  020313 SaKaLk Call 77116(Foreign Call 28170).Added new public column ship_county.
--  020109  GaJalk Bug fix 27084, Added the parameter ship_via_desc_ to the function Get_Preliminary_Delnote_No, and used it in the cursor find_preliminary.
--  001004  MaGu  Added check for addr_flag on address convertion in Unpack_Check_Insert___ and
--                Unpack_Check_Update___.
--  001003  MaGu  Added control value ORDER_ADDRESS_UPDATE to Unpack_Check_Update___ to
--                prevent old address fields from being overwritten when running the order
--                address update application.
--  000921  MaGu  Added new address columns to view CUSTOMER_ORDER_DELIV_NOTE.
--                Added convertion to old address format in Unpack_Check_Insert___
--                and Unpack_Check_Update___. Changed get-methods for new address
--                columns, fetch from view instead. Changed New and Get_Preliminary_Delnote to
--                new address format is handled.
--  000913  FBen  Added UNDEFINE.
--  000913  MaGu  Changed name on new address columns.
--  000908  MaGu  Added address1, address2, zip_code, city and state.
--  ------------------------------ 12.1 -------------------------------------
--  000419  PaLj  Corrected Init_Method Errors
--  000113  JoEd  Bug fix 12854. Removed error message INVOICED_ORDER in
--                Unpack_Check_Update___.
--                This appeared when sending dispatch advice using an Invoiced order.
--  ------------------------------ 12.0 -------------------------------------
--  991020  JoEd  Added column ship_via_desc. Added ship_via_desc to New method.
--  991007  JoEd  Corrected double-byte problems.
--  990921  JoEd  Added nvl check in cursor in Get_Preliminary_Delnote_No.
--  990916  JoEd  Added "Invoiced order" update check.
--  990915  JoEd  Changed view to handle single occurence addresses like
--                e.g. CustomerOrderAddress.
--  990909  JoEd  Added delivery information to view/table.
--                Changed behaviour - split to handle multiple delnotes.
--                Added language code, contract and customer no to view to be
--                able to populate the client.
--  ------------------------------ 11.1 -------------------------------------
--  990421  RaKu  Y.Changed do DB-defaults in Prepare_Insert___.
--  990416  RaKu  Y.Cleanup.
--  990414  PaLj  YOSHIMURA - New Template
--  990414  PaLj  Order_Delnote_Not_Printed removed
--  990118  RaKu  Added defaults in Prepare_Insert___. Modifyed procedure New.
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  990118  RaKu  Added function Get_Dispatch_Advice_Sent_Db.
--                Added procedure Set_Dispatch_Advice_Sent.
--  990115  RaKu  Added attribute dispatch_advice_sent.
--  981204  RaKu  Removed procedure Get_Order_Delivery_Notes.
--                Changed function New to a procedure.
--                Added function Get_Preliminary_Delnote_No.
--  981203  RaKu  Added state-machine and removed obsolete attribute Printed_Flag.
--                Added function Get_Objstate.
--  971120  RaKu  Changed to FND200 Templates.
--  970521  JOED  Rebuild Get_.. methods calling Get_Instance___.
--                Added .._db columns in the view for all IID columns.
--  970312  RaKu  Changed table name.
--  970219  PAZE  Changed rowversion (10.3 project).
--  960416  SVLO  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Calculated_Weight_Volume_Totals_Rec IS RECORD (
   gross_total_weight   NUMBER,
   net_total_weight     NUMBER,
   total_volume         NUMBER);

TYPE Calculated_Weight_Volume_Totals_Arr IS TABLE OF Calculated_Weight_Volume_Totals_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------
--gelr:alt_delnote_no_chronologic, begin
PROCEDURE Generate_Alt_Delnote__ (
   delnote_no_  IN VARCHAR2,
   order_no_    IN VARCHAR2,
   shipment_id_ IN NUMBER )
IS
BEGIN
   Generate_Alt_Delnote___(delnote_no_, order_no_, shipment_id_);
END Generate_Alt_Delnote__;
--gelr:alt_delnote_no_chronologic, end

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Generate_Alt_Delnote_No___
--   Genarates the alternative delivery note number from branch and defined number series.
PROCEDURE Generate_Alt_Delnote_No___ (
   delnote_no_    IN VARCHAR2,
   branch_        IN VARCHAR2,
   number_series_ IN VARCHAR2 )
IS
   alt_delnote_no_ DELIVERY_NOTE_TAB.alt_delnote_no%TYPE;
   newrec_         delivery_note_tab%ROWTYPE;
   objid_          VARCHAR2(2000);
   objversion_     VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, delnote_no_);
   newrec_                := Lock_By_Id___(objid_, objversion_);
   alt_delnote_no_        := (branch_ ||'-'|| number_series_);
   newrec_.alt_delnote_no := alt_delnote_no_;
   Modify___(newrec_, FALSE);
END Generate_Alt_Delnote_No___;


 PROCEDURE Generate_Alt_Delnote___ (
   delnote_no_  IN VARCHAR2,
   order_no_    IN VARCHAR2,
   shipment_id_ IN NUMBER )
IS

   site_date_           DATE;
   contract_            VARCHAR2(5);
   number_series_       VARCHAR2(50);
   company_             VARCHAR2(20);
   branch_              VARCHAR2(20);
   $IF Component_Order_SYS.INSTALLED $THEN
      order_rec_        Customer_Order_API.Public_Rec;
   $END
   shipment_rec_        Shipment_API.Public_Rec;
   receiver_id_         VARCHAR2(50);
   receiver_type_db_    VARCHAR2(20);
BEGIN
   IF (order_no_ IS NOT NULL) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         order_rec_   := Customer_Order_API.Get(order_no_);
         contract_    := order_rec_.contract;    
         receiver_id_ := order_rec_.customer_no;
         receiver_type_db_ := Sender_Receiver_Type_API.DB_CUSTOMER;
      $ELSE
         NULL;
      $END
   ELSIF (shipment_id_ IS NOT NULL) THEN
      shipment_rec_ := Shipment_API.Get(shipment_id_);
      contract_     := shipment_rec_.contract;
      receiver_id_  := shipment_rec_.receiver_id;
      receiver_type_db_ := shipment_rec_.receiver_type;
   END IF;
   company_  := Site_API.Get_Company(contract_);
   branch_   := Shipment_Source_Utility_API.Get_Receiver_Branch(receiver_id_, company_, contract_, receiver_type_db_);
   IF branch_ IS NOT NULL THEN
      site_date_ := Site_API.Get_Site_Date(contract_);
      Deliv_Note_Number_Series_API.Get_Next_Delnote_Number(number_series_, company_, branch_, site_date_);
      IF number_series_ != -1 THEN
         Generate_Alt_Delnote_No___(delnote_no_, branch_, number_series_);
      END IF;
   END IF;
END Generate_Alt_Delnote___;


PROCEDURE Set_Invalid___ (
   rec_  IN OUT DELIVERY_NOTE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Create_Delivery_Note_API.Post_Del_Note_Invalid_Action(rec_.delnote_no, rec_.shipment_id);   
END Set_Invalid___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DISPATCH_ADVICE_SENT_DB', 'NOTSENT', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DELIVERY_NOTE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- gelr:modify_date_applied, begin
   $IF Component_Order_SYS.INSTALLED $THEN
      IF ((Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(Customer_Order_API.Get_Contract(newrec_.order_no),'MODIFY_DATE_APPLIED') = Fnd_boolean_API.DB_TRUE) OR
         (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(Shipment_API.Get_Contract(newrec_.shipment_id),'MODIFY_DATE_APPLIED') = Fnd_boolean_API.DB_TRUE)) THEN 
         IF (newrec_.shipment_id IS NOT NULL) THEN
            -- Fetch site from shipment
            newrec_.transport_date := Site_API.Get_Site_Date(Shipment_API.Get_Contract(newrec_.shipment_id));
            newrec_.del_note_print_date := newrec_.transport_date;
         ELSE
            -- Fetch site from customer order
            newrec_.transport_date := Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(newrec_.order_no));
            newrec_.del_note_print_date := newrec_.transport_date;
         END IF;
      END IF;
   $END   
   -- gelr:modify_date_applied, end   
   -- Retrieve a new delnote_no
   SELECT to_char(mpc_delnote_no.nextval)
     INTO newrec_.delnote_no
     FROM dual;
   Client_SYS.Add_To_Attr('DELNOTE_NO', newrec_.delnote_no, attr_);

   -- Assign values to attributes not editable in client
   IF (newrec_.shipment_id IS NOT NULL) THEN
      -- Fetch site from shipment
      newrec_.create_date := Site_API.Get_Site_Date(Shipment_API.Get_Contract(newrec_.shipment_id));
   ELSE
      -- Fetch site from customer order
      $IF Component_Order_SYS.INSTALLED $THEN
         newrec_.create_date := Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(newrec_.order_no));
      $ELSE
         NULL;
      $END
   END IF;
   Client_SYS.Add_To_Attr('CREATE_DATE', newrec_.create_date, attr_);

   newrec_.alt_delnote_no := newrec_.delnote_no;

   Trace_SYS.Message('Before Insert');
   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT delivery_note_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_              VARCHAR2(30);
   value_             VARCHAR2(4000);   
   receiver_type_db_  VARCHAR2(20);
BEGIN
   -- gelr:warehouse_journal, begin
   $IF Component_Order_SYS.INSTALLED $THEN
      IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(Customer_Order_API.Get_Contract(newrec_.order_no),'WAREHOUSE_JOURNAL') = Fnd_boolean_API.DB_TRUE) THEN  
         newrec_.delivery_reason_id := NVL(newrec_.delivery_reason_id, Customer_Order_API.Get_Delivery_Reason_Id(newrec_.order_no));
      END IF;
   $END   
   -- gelr:warehouse_journal, end   
    
   IF (newrec_.shipment_id IS NOT NULL) THEN
      receiver_type_db_ := Shipment_API.Get_Receiver_Type_DB(newrec_.shipment_id);
   ELSE
      receiver_type_db_ := Sender_Receiver_Type_API.DB_CUSTOMER;
   END IF;
   IF (indrec_.receiver_addr_id = TRUE) THEN
      IF (newrec_.receiver_addr_id IS NOT NULL) THEN
         IF (newrec_.shipment_id IS NOT NULL) THEN
            Shipment_API.Receiver_Address_Exist(newrec_.receiver_id, newrec_.receiver_addr_id, receiver_type_db_);
         ELSE
            IF (newrec_.single_occ_addr_flag = 'N') THEN
               $IF Component_Order_SYS.INSTALLED $THEN
                  Cust_Ord_Customer_Address_API.Exist(newrec_.receiver_id, newrec_.receiver_addr_id);
               $ELSE
                  NULL;
               $END
            END IF;
         END IF;   
      END IF;  
   END IF;  
   super(newrec_, indrec_, attr_);    
   
   Shipment_Source_Utility_API.Validate_Receiver_Id(newrec_.receiver_id, receiver_type_db_, Shipment_API.Get_Contract(newrec_.shipment_id)); 
   
   Address_Setup_API.Validate_Address(newrec_.receiver_country, newrec_.receiver_state, newrec_.receiver_county, newrec_.receiver_city);  
   
   IF (newrec_.single_occ_addr_flag = 'N') THEN    
      newrec_.receiver_addr_name := NULL;
      newrec_.receiver_country   := NULL;
      newrec_.receiver_address1  := NULL;
      newrec_.receiver_address2  := NULL;
      newrec_.receiver_address3  := NULL;
      newrec_.receiver_address4  := NULL;
      newrec_.receiver_address5  := NULL;
      newrec_.receiver_address6  := NULL;
      newrec_.receiver_zip_code  := NULL;
      newrec_.receiver_city      := NULL;
      newrec_.receiver_state     := NULL;
      newrec_.receiver_county    := NULL;
   END IF;  
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     delivery_note_tab%ROWTYPE,
   newrec_ IN OUT delivery_note_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_Delivery_Info___(newrec_, indrec_);
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     delivery_note_tab%ROWTYPE,
   newrec_ IN OUT delivery_note_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                 VARCHAR2(30);
   value_                VARCHAR2(2000);
   shipment_rec_         Shipment_API.Public_Rec;
BEGIN
   shipment_rec_ := Shipment_API.Get(newrec_.shipment_id);
   
   IF (indrec_.receiver_addr_id = TRUE) THEN
     IF (newrec_.receiver_addr_id IS NOT NULL) THEN
        IF (newrec_.shipment_id IS NOT NULL) THEN
           Shipment_API.Receiver_Address_Exist(newrec_.receiver_id, newrec_.receiver_addr_id, shipment_rec_.receiver_type);
        ELSE
           IF (newrec_.single_occ_addr_flag = 'N') THEN
              $IF Component_Order_SYS.INSTALLED $THEN
                 Cust_Ord_Customer_Address_API.Exist(newrec_.receiver_id, newrec_.receiver_addr_id);
              $ELSE
                 NULL;
              $END
           END IF;
        END IF;   
     END IF;  
  END IF;  
  
  IF (indrec_.receiver_id = TRUE) THEN
     IF (newrec_.receiver_id IS NOT NULL) THEN
        IF (newrec_.shipment_id IS NULL) THEN
           $IF Component_Order_SYS.INSTALLED $THEN
              Cust_Ord_Customer_API.Exist(newrec_.receiver_id);
           $ELSE
              NULL;
           $END
        ELSE
           Shipment_Source_Utility_API.Validate_Receiver_Id(newrec_.receiver_id, shipment_rec_.receiver_type, shipment_rec_.contract);
        END IF;     
     END IF;   
  END IF;
  
  super(oldrec_, newrec_, indrec_, attr_);

  Address_Setup_API.Validate_Address(newrec_.receiver_country, newrec_.receiver_state, newrec_.receiver_county, newrec_.receiver_city);
   
  IF (newrec_.single_occ_addr_flag = 'N') THEN     
      newrec_.receiver_addr_name := NULL;
      newrec_.receiver_country   := NULL;
      newrec_.receiver_address1  := NULL;
      newrec_.receiver_address2  := NULL;
      newrec_.receiver_address3  := NULL;
      newrec_.receiver_address4  := NULL;
      newrec_.receiver_address5  := NULL;
      newrec_.receiver_address6  := NULL;
      newrec_.receiver_zip_code  := NULL;
      newrec_.receiver_city      := NULL;
      newrec_.receiver_state     := NULL;
      newrec_.receiver_county    := NULL;
  END IF;
  
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

-- gelr:modify_date_applied, begin
PROCEDURE Validate_Delivery_Info___ (
   newrec_ IN delivery_note_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec)
IS
   state_  VARCHAR2(20);
BEGIN
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(Get_Contract(newrec_.delnote_no),'WAREHOUSE_JOURNAL') = Fnd_boolean_API.DB_TRUE) THEN
      state_ := Get_Objstate(newrec_.delnote_no);
      IF (indrec_.qty_eur_pallets) THEN      
         IF (state_ IN ('Printed', 'Canceled')) THEN         
            Error_SYS.Record_General(lu_name_, 'NOUPDATETRANSDATE: No changes are allowed for :P1 Delivery Notes.', state_);         
         END IF;
      END IF;
   END IF;
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(Get_Contract(newrec_.delnote_no),'MODIFY_DATE_APPLIED') = Fnd_boolean_API.DB_TRUE) THEN
      state_ := Get_Objstate(newrec_.delnote_no);      
      IF (indrec_.transport_date OR indrec_.delivery_reason_id OR indrec_.del_note_print_date) THEN      
         IF (state_ IN ('Printed', 'Canceled')) THEN         
            Error_SYS.Record_General(lu_name_, 'NOUPDATETRANSDATE: No changes are allowed for :P1 Delivery Notes.', state_);         
         END IF;
      END IF;
      IF (newrec_.transport_date IS NOT NULL) THEN
         IF ((TRUNC(newrec_.transport_date) < TRUNC(newrec_.create_date)) OR (TRUNC(newrec_.transport_date) < TRUNC(Delivery_Note_API.Get_Actual_Ship_Date(newrec_.delnote_no))))THEN
            Error_SYS.Record_General(lu_name_, 'EARLIERTRANSDATE: Transport Date cannot be earlier than the delivery note creation date or the actual ship date.');         
         END IF;
      ELSE
         Error_SYS.Record_General(lu_name_, 'TRANSDATENULL: Transport Date must have a value.'); 
      END IF;
      IF (newrec_.del_note_print_date IS NOT NULL) THEN
         IF ((TRUNC(newrec_.del_note_print_date) < TRUNC(newrec_.create_date)) OR (TRUNC(newrec_.del_note_print_date) < TRUNC(Delivery_Note_API.Get_Actual_Ship_Date(newrec_.delnote_no))))THEN
            Error_SYS.Record_General(lu_name_, 'EARLIERPRINTDATE: Delivery Note Print Date cannot be earlier than the delivery note creation date or the actual ship date.');         
         END IF;
      ELSE
         Error_SYS.Record_General(lu_name_, 'PRINTDATENULL: Delivery Note Print Date must have a value.'); 
      END IF;
   END IF;
 END Validate_Delivery_Info___;
-- gelr:modify_date_applied, end

-- gelr:no_delivery_note_for_services, begin
-- No_Delivery_Note_For_Services___
--    Returns ture if, the company localization parameter 'NO_DELIVERY_NOTE_FOR_SERVICES' is true and all the lines contain part type 'SERVICE'.
@UncheckedAccess
FUNCTION No_Delivery_Note_For_Services___ (
   order_no_     IN VARCHAR2,
   shipment_id_  IN NUMBER) RETURN BOOLEAN
IS
   contract_                      VARCHAR2(5);
   all_lines_part_type_service_   VARCHAR2(5) := 'FALSE';
   no_delivery_note_for_services_ VARCHAR2(5);
   
   CURSOR shipment_line IS
      SELECT source_ref_type, source_part_no, inventory_part_no
      FROM   shipment_line_tab
      WHERE  shipment_id = shipment_id_;
      
   $IF Component_Order_SYS.INSTALLED $THEN   
   CURSOR order_line IS
      SELECT catalog_no
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_;
   $END
BEGIN
   IF (order_no_ IS NOT NULL) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         contract_ := Customer_Order_API.Get_Contract(order_no_);
      $ELSE
         NULL;
      $END
   ELSIF (shipment_id_ IS NOT NULL) THEN
      contract_ := Shipment_API.Get_Contract(shipment_id_);
   END IF;   
   no_delivery_note_for_services_ := Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(contract_, 'NO_DELIVERY_NOTE_FOR_SERVICES');
   
   IF (no_delivery_note_for_services_ = Fnd_boolean_API.DB_TRUE) THEN      
      IF (order_no_ IS NOT NULL) THEN         
         $IF Component_Order_SYS.INSTALLED $THEN            
            FOR order_line_rec_ IN order_line LOOP
               all_lines_part_type_service_ := 'TRUE';               
               IF (Sales_Part_API.Get_Non_Inv_Part_Type_DB(contract_, order_line_rec_.catalog_no) = Non_Inventory_Part_Type_API.DB_GOODS) THEN
                  all_lines_part_type_service_ := 'FALSE';
                  EXIT;
               END IF;
            END LOOP;
         $ELSE
            NULL;
         $END
      ELSIF (shipment_id_ IS NOT NULL AND (Shipment_API.Source_Ref_Type_Exist(shipment_id_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE) OR 
                                          (Shipment_API.Source_Ref_Type_Exist(shipment_id_, Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) = Fnd_Boolean_API.DB_TRUE)) THEN
         FOR shipment_line_rec_ IN shipment_line LOOP
            all_lines_part_type_service_ := 'TRUE';               
            IF (Shipment_Source_Utility_API.Is_Goods_Non_Inv_Part_Type(shipment_id_, shipment_line_rec_.source_part_no, shipment_line_rec_.inventory_part_no, shipment_line_rec_.source_ref_type) = 'TRUE') THEN               
               all_lines_part_type_service_ := 'FALSE';
               EXIT;
            END IF;            
         END LOOP;
      END IF;
   END IF;
   
   IF (no_delivery_note_for_services_ = Fnd_boolean_API.DB_TRUE AND all_lines_part_type_service_ = 'TRUE') THEN  
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END No_Delivery_Note_For_Services___;
-- gelr:no_delivery_note_for_services, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Create a new delivery note from another logical unit.
PROCEDURE New (
   delnote_no_               OUT VARCHAR2,
   order_no_                 IN VARCHAR2,
   receiver_addr_id_         IN VARCHAR2,
   single_occ_addr_flag_db_  IN VARCHAR2,
   receiver_addr_name_       IN VARCHAR2,
   receiver_address1_        IN VARCHAR2,
   receiver_address2_        IN VARCHAR2,
   receiver_address3_        IN VARCHAR2,
   receiver_address4_        IN VARCHAR2,
   receiver_address5_        IN VARCHAR2,
   receiver_address6_        IN VARCHAR2,
   receiver_zip_code_        IN VARCHAR2,
   receiver_city_            IN VARCHAR2,
   receiver_state_           IN VARCHAR2,
   receiver_county_          IN VARCHAR2,
   receiver_country_         IN VARCHAR2,
   route_id_                 IN VARCHAR2,
   forward_agent_id_         IN VARCHAR2,
   ship_via_code_            IN VARCHAR2,
   delivery_terms_           IN VARCHAR2,
   shipment_id_              IN NUMBER,
   receiver_id_              IN VARCHAR2,
   pre_ship_invent_loc_no_   IN VARCHAR2,
   del_terms_location_       IN VARCHAR2,
   source_lang_code_         IN VARCHAR2)
IS
   attr_             VARCHAR2(3000);
   newrec_           delivery_note_tab%ROWTYPE;
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   indrec_           Indicator_Rec;
BEGIN 
   -- gelr:no_delivery_note_for_services, begin
   IF (No_Delivery_Note_For_Services___(order_no_, shipment_id_)) THEN      
      -- If the company localization parameter 'NO_DELIVERY_NOTE_FOR_SERVICES' is true and if all the lines 
      -- contain part type 'SERVICE', then delivery note will not be created.
      NULL;
   ELSE
   -- gelr:no_delivery_note_for_services, end
      Prepare_Insert___(attr_);
      Client_SYS.Add_To_Attr('ORDER_NO',                order_no_,                attr_);
      Client_SYS.Add_To_Attr('RECEIVER_ID',             receiver_id_,             attr_);
      Client_SYS.Add_To_Attr('SOURCE_LANG_CODE',        source_lang_code_,        attr_);
      Client_SYS.Add_To_Attr('SINGLE_OCC_ADDR_FLAG_DB', single_occ_addr_flag_db_, attr_);
      Client_SYS.Add_To_Attr('RECEIVER_ADDR_ID',        receiver_addr_id_,        attr_);
   
      IF (single_occ_addr_flag_db_ = 'Y') THEN
         Client_SYS.Add_To_Attr('RECEIVER_ADDR_NAME', receiver_addr_name_, attr_);
         Client_SYS.Add_To_Attr('RECEIVER_ADDRESS1',  receiver_address1_,  attr_);
         Client_SYS.Add_To_Attr('RECEIVER_ADDRESS2',  receiver_address2_,  attr_);
         Client_SYS.Add_To_Attr('RECEIVER_ADDRESS3',  receiver_address3_,  attr_);
         Client_SYS.Add_To_Attr('RECEIVER_ADDRESS4',  receiver_address4_,  attr_);
         Client_SYS.Add_To_Attr('RECEIVER_ADDRESS5',  receiver_address5_,  attr_);
         Client_SYS.Add_To_Attr('RECEIVER_ADDRESS6',  receiver_address6_,  attr_);
         Client_SYS.Add_To_Attr('RECEIVER_ZIP_CODE',  receiver_zip_code_,  attr_);
         Client_SYS.Add_To_Attr('RECEIVER_CITY',      receiver_city_,      attr_);
         Client_SYS.Add_To_Attr('RECEIVER_STATE',     receiver_state_,     attr_);
         Client_SYS.Add_To_Attr('RECEIVER_COUNTY',    receiver_county_,    attr_);
         Client_SYS.Add_To_Attr('RECEIVER_COUNTRY',   receiver_country_,   attr_);
      END IF;
      
      Client_SYS.Add_To_Attr('ROUTE_ID',               route_id_,               attr_);
      Client_SYS.Add_To_Attr('FORWARD_AGENT_ID',       forward_agent_id_,       attr_);
      Client_SYS.Add_To_Attr('SHIP_VIA_CODE',          ship_via_code_,          attr_);
      Client_SYS.Add_To_Attr('DELIVERY_TERMS',         delivery_terms_,         attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_ID',            shipment_id_,            attr_);
      Client_SYS.Add_To_Attr('PRE_SHIP_INVENT_LOC_NO', pre_ship_invent_loc_no_, attr_);
      Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION',     del_terms_location_,     attr_);

      Trace_SYS.Field('attr_', attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);

      delnote_no_ := newrec_.delnote_no;
       -- gelr:alt_delnote_no_chronologic,alt_delnote_no will be generated when printing the delivery note 
      IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(Get_Contract(delnote_no_), 'ALT_DELNOTE_NO_CHRONOLOGIC') = Fnd_Boolean_API.DB_FALSE) THEN
         Generate_Alt_Delnote___(delnote_no_, order_no_, shipment_id_);
      END IF;

      IF (pre_ship_invent_loc_no_ IS NOT NULL) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Deliver_Customer_Order_API.Conn_Order_To_Pre_Del_Note__(delnote_no_, pre_ship_invent_loc_no_);
         $ELSE
            NULL;
         $END
      ELSE
         Create_Delivery_Note_API.Post_Create_Deliv_Note(delnote_no_, shipment_id_);
      END IF;
   END IF;
END New;

-- Set_Printed
--   Changes the status to 'Printed'.
--   Sets the state to Printed.
PROCEDURE Set_Printed (
   delnote_no_ IN VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000) := NULL;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, delnote_no_);
   Print__(info_, objid_, objversion_, attr_, 'DO');
END Set_Printed;


-- Set_Dispatch_Advice_Sent
--   Sets the attribute dispatch_advice_sent to 'Dispatch Advice Sent'.
--   Sets the attribute dispatch_advice_sent to 'Dispatch Advice Sent'.
PROCEDURE Set_Dispatch_Advice_Sent (
   delnote_no_ IN VARCHAR2 )
IS
   oldrec_     delivery_note_tab%ROWTYPE;
   newrec_     delivery_note_tab%ROWTYPE;
BEGIN
   oldrec_ := Lock_By_Keys___(delnote_no_);
   IF (oldrec_.dispatch_advice_sent = 'NOTSENT') THEN
      newrec_                      := oldrec_;
      newrec_.dispatch_advice_sent := Dispatch_Advice_Sent_API.DB_DISPATCH_ADVICE_SENT;   
      Modify___(newrec_);
   END IF;
END Set_Dispatch_Advice_Sent;


-- Get_Delnote_No_For_Shipment
--   Returns the delnote_no connected to the specified shipment_id.
@UncheckedAccess
FUNCTION Get_Delnote_No_For_Shipment (
    shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   delnote_no_  delivery_note_tab.delnote_no%TYPE;
   
   CURSOR find_delnote_no IS
      SELECT delnote_no
        FROM delivery_note_tab
       WHERE shipment_id = shipment_id_
         AND rowstate   != 'Invalid';
           
BEGIN
   OPEN find_delnote_no;
   FETCH find_delnote_no INTO delnote_no_;
   IF (find_delnote_no%NOTFOUND) THEN
      delnote_no_ := NULL;
   END IF;
   
   RETURN delnote_no_;
END Get_Delnote_No_For_Shipment;


PROCEDURE Modify (
   info_       OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   delnote_no_ IN     VARCHAR2 )
IS
   oldrec_     delivery_note_tab%ROWTYPE;
   newrec_     delivery_note_tab%ROWTYPE;
   indrec_     Indicator_Rec;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(delnote_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   info_ := Client_SYS.Get_All_Info;
END Modify;


-- Get_Shipment_Dis_Adv_Send_Db
--   This returns whether the shipment's dispatch advice has been send or
@UncheckedAccess
FUNCTION Get_Shipment_Dis_Adv_Send_Db (
    shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   dispatch_advice_sent_  delivery_note_tab.dispatch_advice_sent%TYPE;
   
   CURSOR dispatch_send IS
      SELECT dispatch_advice_sent
        FROM delivery_note_tab
       WHERE shipment_id = shipment_id_
       AND dispatch_advice_sent = 'SENT';
BEGIN
   OPEN dispatch_send;
   FETCH dispatch_send INTO dispatch_advice_sent_;
   IF (dispatch_send%NOTFOUND) THEN
      dispatch_advice_sent_ := 'NOTSENT';
   END IF;
   CLOSE dispatch_send;
   RETURN dispatch_advice_sent_;
END Get_Shipment_Dis_Adv_Send_Db;


-- Is_Delivery_Note_Exist
--   This will return true if the given delivery note exist.
@UncheckedAccess
FUNCTION Is_Delivery_Note_Exist (
   delnote_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Check_Exist___(delnote_no_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Delivery_Note_Exist;


-- Check_Exist
--   Returns the value obtained by calling the relevant implementation method.
--   Returns the value obtained by calling the relevant implementation
@UncheckedAccess
FUNCTION Check_Exist (
   delnote_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(delnote_no_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE Set_Pre_Ship_Delivery_Made (
   delnote_no_ IN VARCHAR2 )
IS
   newrec_     delivery_note_tab%ROWTYPE;
BEGIN
   newrec_                        := Lock_By_Keys___(delnote_no_);
   newrec_.pre_ship_delivery_made := Fnd_Boolean_API.DB_TRUE;
   Modify___(newrec_);
END Set_Pre_Ship_Delivery_Made;


PROCEDURE Set_Invalid (
   delnote_no_ IN VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000) := NULL;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, delnote_no_);
   Invalidate__(info_, objid_, objversion_, attr_, 'DO');
END Set_Invalid;


PROCEDURE Set_Dirdel_Sequence_Version (
   delnote_no_   IN VARCHAR2,
   sequence_no_  IN NUMBER,
   version_no_   IN NUMBER )
IS
   newrec_     delivery_note_tab%ROWTYPE;
   objid_      delivery_note.objid%TYPE;
   objversion_ delivery_note.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, delnote_no_);
   newrec_                    := Lock_By_Id___(objid_, objversion_);
   newrec_.dirdel_sequence_no := sequence_no_;
   newrec_.dirdel_version_no  := version_no_;
   Modify___(newrec_, FALSE);
END Set_Dirdel_Sequence_Version; 


PROCEDURE Set_Desadv_Sequence_Version (
   delnote_no_   IN VARCHAR2,
   sequence_no_  IN NUMBER,
   version_no_   IN NUMBER )
IS
   newrec_     delivery_note_tab%ROWTYPE;
   objid_      delivery_note.objid%TYPE;
   objversion_ delivery_note.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, delnote_no_);
   newrec_                    := Lock_By_Id___(objid_, objversion_);
   newrec_.desadv_sequence_no := sequence_no_;
   newrec_.desadv_version_no  := version_no_;
   Modify___(newrec_, FALSE);
END Set_Desadv_Sequence_Version;


-- Get_Shipment_Net_Summary
--   This method retreives the net summary information for
--   all connected lines to specified shipment id. 
@UncheckedAccess
PROCEDURE Get_Shipment_Net_Summary (
   gross_total_  OUT NUMBER,
   net_total_    OUT NUMBER,
   total_volume_ OUT NUMBER,
   shipment_id_  IN  NUMBER )
IS
   CURSOR shipment_line IS
      SELECT sol.source_ref1, sol.source_ref2, sol.source_ref3, sol.source_ref4, sol.conv_factor,
             sol.inverted_conv_factor, sol.source_part_no, sol.source_unit_meas, sol.source_ref_type, 
             sol.inventory_part_no, sol.qty_shipped
        FROM shipment_line_tab sol
       WHERE sol.shipment_id = shipment_id_;     
   qty_delivered_          NUMBER;      
   contract_               VARCHAR2(5);
   public_line_rec_        Shipment_Source_Utility_API.Public_Line_Rec;
   company_info_rec_       Company_Invent_Info_API.Public_Rec;
BEGIN                  
   gross_total_            := 0.0;
   net_total_              := 0.0;
   total_volume_           := 0.0;
   contract_               := Shipment_API.Get_Contract(shipment_id_);
   company_info_rec_       := Company_Invent_Info_API.Get(Site_API.Get_Company(contract_));  

   FOR next_row_ IN shipment_line LOOP
      public_line_rec_  := Shipment_Source_Utility_API.Get_Line(next_row_.source_ref1, next_row_.source_ref2, next_row_.source_ref3, next_row_.source_ref4, next_row_.source_ref_type);
      IF(Shipment_Source_Utility_API.Valid_Ship_Deliv_Line(next_row_.source_ref1, next_row_.source_ref2, next_row_.source_ref3, next_row_.source_ref4, next_row_.source_ref_type) = Fnd_Boolean_API.DB_TRUE) THEN         
         qty_delivered_ := next_row_.qty_shipped;
         -- Convert to sales unit of measure
         qty_delivered_ := (qty_delivered_ / next_row_.conv_factor * next_row_.inverted_conv_factor) / NVL(public_line_rec_.receiver_part_conv_factor, 1) * NVL(public_line_rec_.receiver_part_invert_conv_fact, 1);
         -- Update the totals     
         net_total_     := net_total_ + (Part_Weight_Volume_Util_API.Get_Partca_Net_Weight(contract_, next_row_.source_part_no, next_row_.inventory_part_no, next_row_.source_unit_meas, next_row_.conv_factor, next_row_.inverted_conv_factor, company_info_rec_.uom_for_weight) * qty_delivered_);
      END IF;
   END LOOP; 
   gross_total_  := Shipment_API.Get_Operational_Gross_Weight(shipment_id_, company_info_rec_.uom_for_weight, Fnd_Boolean_Api.DB_FALSE);
   total_volume_ := Shipment_API.Get_Operational_Volume(shipment_id_, company_info_rec_.uom_for_volume);
      
   IF (Shipment_API.Shipment_Structure_Exist(shipment_id_) = 'TRUE') THEN
      net_total_ := Shipment_API.Get_Net_Weight (shipment_id_, company_info_rec_.uom_for_weight,Fnd_Boolean_Api.DB_FALSE);   
   END IF;
END Get_Shipment_Net_Summary;


-- Get_Actual_Ship_Date
--   This method retreives the actual ship date
--   for specified delivery note.
@UncheckedAccess
FUNCTION Get_Actual_Ship_Date (
   delnote_no_ IN VARCHAR2 ) RETURN DATE
IS
   order_no_                delivery_note_tab.order_no%TYPE;
   shipment_id_             delivery_note_tab.shipment_id%TYPE;
   pre_ship_invent_loc_no_  delivery_note_tab.pre_ship_invent_loc_no%TYPE;    
   actual_ship_date_        DATE := NULL;
   
   CURSOR get_attr IS
      SELECT order_no, shipment_id, pre_ship_invent_loc_no
        FROM delivery_note_tab
       WHERE delnote_no = delnote_no_;  
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO order_no_, shipment_id_, pre_ship_invent_loc_no_;
   CLOSE get_attr;
   IF (order_no_ IS NOT NULL) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         actual_ship_date_ := Deliver_Customer_Order_API.Get_Actual_Del_Note_Ship_Date(delnote_no_, order_no_, pre_ship_invent_loc_no_);
      $ELSE
         NULL;
      $END
   ELSIF (shipment_id_ IS NOT NULL) THEN
      actual_ship_date_ := Shipment_API.Get_Actual_Ship_Date(shipment_id_);
   END IF;
   RETURN actual_ship_date_;
END Get_Actual_Ship_Date;


PROCEDURE Get_Id_Version_By_Keys (
   objid_      OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   delnote_no_ IN  VARCHAR2 )
IS
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, delnote_no_);
END Get_Id_Version_By_Keys;


@UncheckedAccess
FUNCTION Get_Status (
   delnote_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ delivery_note.state%TYPE;
   CURSOR get_attr IS
      SELECT state
        FROM delivery_note
       WHERE delnote_no = delnote_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Status;


-- Print_Delivery_Note_Allowed__
--   Check if the delivery Note for the shipment can be printed.
@UncheckedAccess
FUNCTION Print_Delivery_Note_Allowed (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   CURSOR get_del_note IS
      SELECT 1
        FROM delivery_note_tab
       WHERE shipment_id = shipment_id_ 
         AND rowstate NOT IN ('Preliminary', 'Printed');      
BEGIN
   OPEN get_del_note;
   FETCH get_del_note INTO allowed_;
   IF (get_del_note%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE get_del_note;
   RETURN allowed_;
END Print_Delivery_Note_Allowed;


PROCEDURE Remove_Order_Deliv_Note (
   order_no_   IN    VARCHAR2)
IS   
BEGIN   
   DELETE
   FROM delivery_note_tab
   WHERE order_no = order_no_;   
END Remove_Order_Deliv_Note;

-- Added this function to access from the base view
@UncheckedAccess
FUNCTION Get_Customer_No (
   order_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      RETURN Customer_Order_API.Get_Customer_No(order_no_);
   $ELSE
      NULL;
   $END
   RETURN NULL;
END Get_Customer_No;


@UncheckedAccess
FUNCTION Get_Remaining_Qty (
   shipment_id_   IN NUMBER,
   line_no_       IN NUMBER) RETURN NUMBER
IS
   rec_              Shipment_Line_API.Public_Rec;
   source_line_rec_  Shipment_Source_Utility_API.Public_Line_Rec;
BEGIN
   rec_             := Shipment_Line_API.Get(shipment_id_, line_no_);
   source_line_rec_ := Shipment_Source_Utility_API.Get_Line(rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, rec_.source_ref4, rec_.source_ref_type);
   IF(source_line_rec_.receiver_qty IS NULL) THEN
      RETURN GREATEST(source_line_rec_.source_qty - ((source_line_rec_.source_qty_shipped - NVL(source_line_rec_.qty_shipdiff, 0))/rec_.conv_factor * rec_.inverted_conv_factor), 0);
   ELSE
      RETURN GREATEST(source_line_rec_.receiver_qty - (((source_line_rec_.source_qty_shipped - NVL(source_line_rec_.qty_shipdiff, 0))/rec_.conv_factor * rec_.inverted_conv_factor)/source_line_rec_.receiver_part_conv_factor * NVL(source_line_rec_.receiver_part_invert_conv_fact, 1)),0);
   END IF;   
END Get_Remaining_Qty;


@UncheckedAccess
FUNCTION Get_Delivered_Qty (
   shipment_id_   IN NUMBER,
   line_no_       IN NUMBER) RETURN NUMBER
IS
   rec_              Shipment_Line_API.Public_Rec;
   source_line_rec_  Shipment_Source_Utility_API.Public_Line_Rec;
BEGIN
   rec_             := Shipment_Line_API.Get(shipment_id_, line_no_);
   source_line_rec_ := Shipment_Source_Utility_API.Get_Line(rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, rec_.source_ref4, rec_.source_ref_type);
   IF(source_line_rec_.receiver_qty IS NULL) THEN
      RETURN (source_line_rec_.source_qty_shipped/rec_.conv_factor * rec_.inverted_conv_factor);
   ELSE
      RETURN (source_line_rec_.source_qty_shipped/rec_.conv_factor * rec_.inverted_conv_factor)/source_line_rec_.receiver_part_conv_factor * NVL(source_line_rec_.receiver_part_invert_conv_fact, 1);
   END IF;    
END Get_Delivered_Qty;


FUNCTION Calculate_Totals (
   shipment_id_   IN  NUMBER) RETURN Calculated_Weight_Volume_Totals_Arr PIPELINED
IS
   rec_     Calculated_Weight_Volume_Totals_Rec;
BEGIN 
  Delivery_Note_API.Get_Shipment_Net_Summary(rec_.gross_total_weight, rec_.net_total_weight, rec_.total_volume, shipment_id_);  
  PIPE ROW (rec_);                                                   
END Calculate_Totals;

-- gelr:tax_book_and_numbering, begin
FUNCTION Get_Create_Date_For_Order_No(
   order_no_ IN VARCHAR2) RETURN DATE
IS
   CURSOR get_ord_del_note_date IS
      SELECT create_date
      FROM   delivery_note_tab
      WHERE  order_no = order_no_;
   
   create_date_      DATE;
BEGIN
   OPEN get_ord_del_note_date;
   FETCH get_ord_del_note_date INTO create_date_;
   
   IF (get_ord_del_note_date%NOTFOUND)THEN
      CLOSE get_ord_del_note_date;
      RETURN NULL;      
   END IF;   
   CLOSE get_ord_del_note_date;
   
   RETURN create_date_;
END Get_Create_Date_For_Order_No;
-- gelr:tax_book_and_numbering, end

-- gelr:modify_date_applied, begin
FUNCTION Get_Contract (
   delnote_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_   VARCHAR2(5);
   
   $IF Component_Order_SYS.INSTALLED $THEN 
      CURSOR get_contract IS
         SELECT contract
         FROM   customer_order_tab co, 
                delivery_note_tab cod
         WHERE  cod.order_no   = co.order_no
         AND    cod.delnote_no = delnote_no_
         UNION ALL
         SELECT contract
         FROM   shipment_tab sh, 
                delivery_note_tab cod
         WHERE  cod.shipment_id = sh.shipment_id
         AND    cod.delnote_no  = delnote_no_;
   $END      
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN 
      OPEN get_contract;
      FETCH get_contract INTO contract_;
      CLOSE get_contract;
   $END   
   RETURN contract_;
END Get_Contract;
-- gelr:modify_date_applied, end

-- gelr:warehouse_journal, begin
@UncheckedAccess
FUNCTION Get_Company (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      RETURN Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));
   $ELSE
      RETURN NULL;
   $END
END Get_Company;
-- gelr:warehouse_journal, end

--gelr:alt_delnote_no_chronologic, begin
FUNCTION Generate_Alt_Del_Note_No(
   delnote_no_      IN VARCHAR2,
   source_ref1_     IN VARCHAR2,
   shipment_id_     IN NUMBER ) RETURN VARCHAR2
IS
   alt_delnote_no_     VARCHAR2(50);
BEGIN
   Generate_Alt_Delnote___(delnote_no_, source_ref1_, shipment_id_);
   alt_delnote_no_ := Get_Alt_Delnote_No(delnote_no_);
   Shipment_Source_Utility_API.Post_Generate_Alt_Delnote_No(delnote_no_, source_ref1_, shipment_id_, alt_delnote_no_); 
   
   RETURN alt_delnote_no_;
END Generate_Alt_Del_Note_No;
--gelr:alt_delnote_no_chronologic, end 

-- gelr:warehouse_journal, begin
PROCEDURE Check_Shipment_Delivered(
   shipment_id_     IN NUMBER, 
   rowstate_        IN VARCHAR2,
   contract_        IN VARCHAR2) 
IS
BEGIN
   IF ((rowstate_ != 'Invalid' AND Shipment_API.Shipment_Delivered(shipment_id_) = 'FALSE') AND
      (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(contract_, 'WAREHOUSE_JOURNAL') = Fnd_Boolean_API.DB_TRUE)) THEN
      Error_SYS.Record_General(lu_name_, 'NOTFULLYDELIVERED: Shipment should be delivered to print shipment delivery note when using Warehouse Journal Report Data localization functionality.');
   END IF;
END Check_Shipment_Delivered;
-- gelr:warehouse_journal, end
