-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptDelivConfirmCo
--  Component:    ORDER
--
--  Purpose: Utility LU for handling Customer Order Delivery Confirmation for DataCaptureProcess
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: DELIVERY_CONFIRMATION
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200917  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Entity_Act_Available in Is_Process_Available to support new projection security concept.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171019  DaZase  STRSC-13009, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171019          of anything found later in that method. Changed size to 4000 on detail_value_ in Add_Unique_Data_Item_Detail___.
--  170503  DaZase  STRSC-7646, Added contract_ to Get_Filter_Keys___, changed validations a bit since both delnote_no and shipment_id can be NULL, 
--  170503          change execution so added signature to a NULL delnote will not cause problems. Cleaned up this process and its unique methods a bit.
--  160608  MaIklk  LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  150216  Chfose  PRSC-5454, Modified Create_List_Of_Values to use new parameter contract_ in call to Deliv_Confirm_Cust_Order_API.Create_Data_Capture_Lov.
--  141022  DaZase  PRSC-3318, Rewrote how filter keys are handled in process. Changes in Get_Filter_Keys___ and Add_Details_For_Latest_Item. 
--  141022          Added methods Get_Unique_Data_Item_Value___ and Add_Filter_Key_Detail___. Removed Pack_Filter_Keys___.
--  140908  RiLase  Removed empty methods since the wadaco framework now can handle when methods doesn't exist.
--  140908  ShVese  Removed cursor get_line from Execute_Process.
--  140827  DaZase  PRSC-1655, Added Validate_Config_Data_Item.
--  140815  Dazase  PRSC-1611, Removed Apply_Additional_Line_Content since it is now obsolete and Get_Automatic_Data_Item_Value can be used instead. 
--  140812  DaZase  PRSC-1611, Renamed Add_Lines_For_Latest_Data_Item to Add_Details_For_Latest_Item.
--  140811  DaZase  PRSC-1611, Changed calls Deliv_Confirm_Cust_Order_API.Check_Valid_Value to Deliv_Confirm_Cust_Order_API.Record_With_Column_Value_Exist.
--  140620  SWiclk  PRSC-1861, Bug 117179, Modified Get_Process_Execution_Message() and Execute_Process() by adding parameter process_message_
--  140620          and parameters process_message_ and blob_ref_attr_ respectively.
--  140521  RoJalk  Added missing conditional compilation for WADACO.
--  140220  MatKse  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_             IN VARCHAR2,
   order_no_             IN VARCHAR2,
   delnote_no_           IN VARCHAR2,
   shipment_id_          IN NUMBER,
   wanted_data_item_id_  IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_          VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      unique_value_ := Deliv_Confirm_Cust_Order_API.Get_Column_Value_If_Unique(contract_    => contract_,
                                                                               order_no_    => order_no_, 
                                                                               delnote_no_  => delnote_no_, 
                                                                               shipment_id_ => shipment_id_, 
                                                                               column_name_ => wanted_data_item_id_);
   $END
   IF (unique_value_ = 'NULL') THEN   -- string 'NULL' is only for automatic handling framework, here it should be NULL
      unique_value_ := NULL;
   END IF;

   RETURN unique_value_;
END Get_Unique_Data_Item_Value___; 


PROCEDURE Get_Filter_Keys___ (
   contract_           OUT VARCHAR2,
   order_no_           OUT VARCHAR2,
   delnote_no_         OUT VARCHAR2,
   shipment_id_        OUT NUMBER,
   signature_          OUT VARCHAR2,   -- not used for filtering in unique handling 
   capture_session_id_ IN  NUMBER,
   data_item_id_       IN  VARCHAR2,
   data_item_value_    IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_  IN  BOOLEAN  DEFAULT FALSE )
IS
   session_rec_           Data_Capture_Common_Util_API.Session_Rec;
   process_package_       VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      contract_        := session_rec_.session_contract;

      -- First try and fetch "predicted" filter keys 
      order_no_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ORDER_NO', session_rec_ , process_package_); 
      delnote_no_  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'DELNOTE_NO', session_rec_ , process_package_);
      shipment_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_ID', session_rec_ , process_package_);
      signature_   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SIGNATURE', session_rec_ , process_package_);

      -- if delnote_no_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all delnotes and non-delnotes in the table
      IF (delnote_no_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DELNOTE_NO', data_item_id_)) THEN
         delnote_no_ := '%';
      END IF;

      -- if shipment_id_ comes after current data item, we exchange the parameter with -1 since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all shipments and non-shipments in the table
      IF (shipment_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_)) THEN
         shipment_id_ := -1;
      END IF;

      IF use_unique_values_ THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (order_no_ IS NULL) THEN
            order_no_ := Get_Unique_Data_Item_Value___(contract_, order_no_, delnote_no_, shipment_id_, 'ORDER_NO');
         END IF;
         IF (delnote_no_ IS NULL) THEN
            delnote_no_ := Get_Unique_Data_Item_Value___(contract_, order_no_, delnote_no_, shipment_id_, 'DELNOTE_NO');
         END IF;
         IF (shipment_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, order_no_, delnote_no_, shipment_id_, 'SHIPMENT_ID');
         END IF;
      END IF;

   $ELSE
      NULL;
   $END
END Get_Filter_Keys___;


PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_   IN NUMBER,
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   order_no_             IN VARCHAR2,
   delnote_no_           IN VARCHAR2,
   shipment_id_          IN NUMBER,
   signature_            IN VARCHAR2 )  
IS
   detail_value_             VARCHAR2(4000);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN

      CASE (data_item_detail_id_)
         WHEN ('ORDER_NO') THEN
            detail_value_ := order_no_;
         WHEN ('DELNOTE_NO') THEN
            detail_value_ := delnote_no_;
         WHEN ('SHIPMENT_ID') THEN
            detail_value_ := shipment_id_;
         WHEN ('SIGNATURE') THEN
            detail_value_ := signature_;
         ELSE
            NULL;
      END CASE;

      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);

   $ELSE
      NULL;
   $END
END Add_Filter_Key_Detail___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   order_no_        VARCHAR2(12);
   delnote_no_      VARCHAR2(15);
   shipment_id_     NUMBER;
   signature_dummy_ VARCHAR2(2000);
   contract_        VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      
      Get_Filter_Keys___(contract_           => contract_,
                         order_no_           => order_no_, 
                         delnote_no_         => delnote_no_, 
                         shipment_id_        => shipment_id_, 
                         signature_          => signature_dummy_, 
                         capture_session_id_ => capture_session_id_, 
                         data_item_id_       => data_item_id_, 
                         data_item_value_    => data_item_value_);
      IF data_item_id_ IN ('ORDER_NO', 'DELNOTE_NO', 'SHIPMENT_ID') THEN
         Deliv_Confirm_Cust_Order_API.Record_With_Column_Value_Exist(contract_     => contract_,
                                                                     order_no_     => order_no_, 
                                                                     delnote_no_   => delnote_no_, 
                                                                     shipment_id_  => shipment_id_, 
                                                                     column_name_  => data_item_id_,
                                                                     column_value_ => data_item_value_);
      END IF;                                                  
      IF (data_item_id_ = 'ORDER_NO') THEN
         Customer_Order_API.Exist(data_item_value_);
         IF NOT (Deliv_Confirm_Cust_Order_API.Deliv_Confirm_Allowed(data_item_value_) = 1) THEN
            Error_SYS.Record_General(lu_name_, 'DELIVERYCONFIRMNOTALLOWED: Delivery Confirmation is not allowed for Order No :P1', data_item_value_);
         END IF;
      ELSIF (data_item_id_ = 'DELNOTE_NO' AND data_item_value_ IS NOT NULL) THEN
         Delivery_Note_API.Exist(data_item_value_);
      ELSIF (data_item_id_ = 'SHIPMENT_ID' AND data_item_value_ IS NOT NULL) THEN
         Shipment_API.Exist(data_item_value_);
      ELSIF(data_item_id_ LIKE 'GS1%') THEN
            Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Data_Item;


PROCEDURE Create_List_Of_Values (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_       IN VARCHAR2,
   contract_           IN VARCHAR2 )
IS
   delnote_no_           VARCHAR2(15);
   order_no_             VARCHAR2(12);
   shipment_id_          NUMBER;
   lov_type_db_          VARCHAR2(20);
   signature_dummy_      VARCHAR2(2000);
   dummy_contract_       VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('ORDER_NO', 'DELNOTE_NO', 'SHIPMENT_ID')) THEN
         lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
         Get_Filter_Keys___(dummy_contract_, order_no_, delnote_no_, shipment_id_, signature_dummy_, capture_session_id_, data_item_id_);
         Deliv_Confirm_Cust_Order_API.Create_Data_Capture_Lov(contract_           => contract_,
                                                              order_no_           => order_no_,
                                                              delnote_no_         => delnote_no_,
                                                              shipment_id_        => shipment_id_,
                                                              capture_session_id_ => capture_session_id_,
                                                              column_name_        => data_item_id_,
                                                              lov_type_db_        => lov_type_db_);

      END IF;
   $ELSE
      NULL;
   $END
END Create_List_Of_Values;


@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   message_ VARCHAR2(200);
BEGIN
   IF (no_of_records_handled_ = 1) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'DELIVCONFIRMATIONOK: The delivery confirmation has been saved.');
   ELSIF (no_of_records_handled_ > 1) THEN 
      message_ := Language_SYS.Translate_Constant(lu_name_, 'DELIVCONFIRMATIONSOK: :P1 delivery confirmations were saved.', NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   automatic_value_ VARCHAR2(200) := NULL;
   order_no_        VARCHAR2(12);
   delnote_no_      VARCHAR2(15);
   shipment_id_     NUMBER;
   signature_dummy_ VARCHAR2(2000);
   contract_        VARCHAR2(5);
   session_rec_     Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- Try and get value from any previously scanned GS1 barcode if this data item have AI code connected to them. Also reducing the value to lengths we have on the IFS objects
      automatic_value_ := SUBSTR(Data_Capture_Session_API.Get_Item_Value_From_Gs1_Items(capture_session_id_ => capture_session_id_,
                                                                                        capture_process_id_ => session_rec_.capture_process_id,
                                                                                        capture_config_id_  => session_rec_.capture_config_id,
                                                                                        data_item_id_       => data_item_id_), 1, 
                                 NVL(Data_Capt_Proc_Data_Item_API.Get_String_Length(session_rec_.capture_process_id, data_item_id_), 200));

      IF (automatic_value_ IS NULL) THEN
         IF (data_item_id_ IN ('ORDER_NO', 'DELNOTE_NO', 'SHIPMENT_ID')) THEN
            Get_Filter_Keys___(contract_, order_no_, delnote_no_, shipment_id_, signature_dummy_, capture_session_id_, data_item_id_);
            automatic_value_ := Deliv_Confirm_Cust_Order_API.Get_Column_Value_If_Unique(contract_    => contract_,
                                                                                        order_no_    => order_no_, 
                                                                                        delnote_no_  => delnote_no_, 
                                                                                        shipment_id_ => shipment_id_, 
                                                                                        column_name_ => data_item_id_);
      
         END IF;
      END IF;
   $END
   RETURN automatic_value_;
END Get_Automatic_Data_Item_Value;


PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
    session_rec_          Data_Capture_Common_Util_API.Session_Rec;
    conf_item_detail_tab_ Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
    delnote_no_           VARCHAR2(15);
    order_no_             VARCHAR2(12);
    shipment_id_          NUMBER;
    signature_            VARCHAR2(2000);
    contract_             VARCHAR2(5);
 BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      
      -- Get any keys that have been saved before in this session (using the filter keys collection only here)
      Get_Filter_Keys___(contract_,
                         order_no_, 
                         delnote_no_, 
                         shipment_id_, 
                         signature_,
                         capture_session_id_, 
                         latest_data_item_id_, 
                         latest_data_item_value_,
                         use_unique_values_ => TRUE);
      
      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
      
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            -- DATA ITEMS AS DETAILS
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN 
               -- Data Items that are part of the filter keys
               Add_Filter_Key_Detail___(capture_session_id_  => capture_session_id_,
                                        owning_data_item_id_ => latest_data_item_id_,
                                        data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                        order_no_            => order_no_,
                                        delnote_no_          => delnote_no_,
                                        shipment_id_         => shipment_id_,
                                        signature_           => signature_);

            ELSE  -- FEEDBACK ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('CUSTOMER_NO','CUSTOMER_NAME', 'WANTED_DELIVERY_DATE', 'ORDER_NO', 'ORDER_TYPE',
                                                                    'ORDER_TYPE_DESCRIPTION', 'ORDER_STATUS', 'ORDER_COORDINATOR', 'ORDER_PRIORITY',
                                                                    'ORDER_REFERENCE', 'ORDER_REFERENCE_NAME', 'ORDER_DELIVERY_TERMS', 'ORDER_SHIP_VIA_CODE',
                                                                    'BILL_ADDR_NO', 'BILL_ADDR_NAME', 'SHIP_ADDR_NO', 'SHIP_ADDR_NAME')) THEN
                  Data_Capture_Order_Util_API.Add_Details_For_Order_No(capture_session_id_   => capture_session_id_,
                                                                       owning_data_item_id_  => latest_data_item_id_,
                                                                       data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       order_no_             => order_no_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('DEL_NOTE_STATUS', 'DEL_NOTE_ACTUAL_SHIP_DATE', 'DEL_NOTE_CREATE_DATE',
                                                                       'DEL_NOTE_FORWARDER_ID', 'DEL_NOTE_DELIVERY_TERMS', 'DEL_NOTE_SHIP_VIA_CODE')) THEN
                  Data_Capture_Shpmnt_Util_API.Add_Details_For_Del_Note_No(capture_session_id_   => capture_session_id_,
                                                                           owning_data_item_id_  => latest_data_item_id_,
                                                                           data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           delnote_no_           => delnote_no_);
               END IF;
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Add_Details_For_Latest_Item;


PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY VARCHAR2,
   capture_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   attr_               IN VARCHAR2,
   blob_ref_attr_      IN VARCHAR2 )
IS
   blob_data_item_value_ VARCHAR2(2000);
   delnote_no_           VARCHAR2(15);
   order_no_             VARCHAR2(12);
   session_           Data_Capture_Common_Util_API.Session_Rec;
   lu_objid_             VARCHAR2(2000);
   dummy_                VARCHAR2(2000);
  
BEGIN
   blob_data_item_value_ := Client_SYS.Get_Item_Value('SIGNATURE',  attr_);
   delnote_no_           := Client_SYS.Get_Item_Value('DELNOTE_NO', attr_);
   order_no_             := Client_SYS.Get_Item_Value('ORDER_NO',   attr_);

   -- Perform delivery confirmation   
   Deliv_Confirm_Cust_Order_API.Confirm_Delivery_Note(order_no_, delnote_no_);
   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      IF delnote_no_ IS NOT NULL THEN
         IF (Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_ => session_.capture_process_id, 
                                                           capture_config_id_  => session_.capture_config_id, 
                                                           process_detail_id_  => 'CONNECT_MEDIA_LU_CUSTOMER_ORDER_DELIV_NOTE') = Fnd_Boolean_API.DB_TRUE) THEN
            -- Save Signature
            Delivery_Note_API.Get_Id_Version_By_Keys(lu_objid_, dummy_, delnote_no_);
            Data_Capt_Sess_Line_Blob_API.Save_To_Media_Library(blob_data_item_value_      => blob_data_item_value_, 
                                                               lu_                        => 'DeliveryNote', 
                                                               lu_objid_                  => lu_objid_, 
                                                               name_                      => 'Signature', 
                                                               description_               => 'Signature for Delivery Note: ' || delnote_no_,
                                                               set_media_item_to_private_ => TRUE);
         END IF;
      END IF;
      IF (Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_ => session_.capture_process_id, 
                                                        capture_config_id_  => session_.capture_config_id, 
                                                        process_detail_id_  => 'CONNECT_MEDIA_LU_CUSTOMER_ORDER') = Fnd_Boolean_API.DB_TRUE) THEN
         -- Save Signature 
         Customer_Order_API.Get_Id_Version_By_Keys(lu_objid_, dummy_, order_no_);
         Data_Capt_Sess_Line_Blob_API.Save_To_Media_Library(blob_data_item_value_      => blob_data_item_value_, 
                                                            lu_                        => 'CustomerOrder', 
                                                            lu_objid_                  => lu_objid_,
                                                            name_                      => 'Signature',
                                                            description_               => 'Signature for CO delivery Note:' || delnote_no_,
                                                            set_media_item_to_private_ => TRUE);
      END IF; 
   $END
END Execute_Process;

@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Deliv_Confirm_Cust_Order_API.Confirm_Delivery_Note is granted thru following projection/entity action
   IF (Security_SYS.Is_Proj_Entity_Act_Available('DeliveryConfirmationOfCustomerOrdersHandling', 'DelivConfirmCustOrder', 'DeliveryConfirmation')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;