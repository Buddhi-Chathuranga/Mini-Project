-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptRepPickShipHu
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220602  Moinlk   SCDEV-8731,  Modified Execute_Process and set a default value for session_id parameter.
--  210819  RoJalk   SC21R2-2343, Modified Execute_Process and called Temporary_Pick_Reservation_API.Clear_Session.
--  210709  MOINLK   SC21R2-1825, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Validate_Data_Item___ (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2)       
IS
   contract_                          VARCHAR2(5);
   shipment_id_                       NUMBER;
   pick_list_no_                      VARCHAR2(15);         
   shp_handling_unit_id_              NUMBER;
   ship_location_no_                  VARCHAR2(30);
   shp_sscc_                          VARCHAR2(18);
   shp_alt_handling_unit_label_id_    VARCHAR2(25);
   column_name_                       VARCHAR2(30);
   data_item_description_             VARCHAR2(200);
   mandatory_non_process_key_         BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Get_Filter_Keys___(contract_, shipment_id_, pick_list_no_, shp_handling_unit_id_, ship_location_no_, shp_sscc_, 
                         shp_alt_handling_unit_label_id_, capture_session_id_, data_item_id_, data_item_value_);
      data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
      
      IF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHIP_LOCATION_NO')) THEN
         mandatory_non_process_key_ := TRUE;
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, mandatory_non_process_key_);
      END IF;
      
      
      IF(data_item_id_ IN ('SHIP_LOCATION_NO')) THEN
         IF (data_item_value_ IS NOT NULL) THEN
            Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_ => capture_session_id_,
                                                            data_item_id_       => 'LOCATION_NO', -- Use LOCATION_NO to check if location exists at all.
                                                            data_item_value_    => data_item_value_);
            IF (Inventory_Location_API.Get_Location_Type_Db(contract_, data_item_value_) != Inventory_Location_Type_API.DB_SHIPMENT) THEN
               Error_SYS.Record_General(lu_name_,'INVALIDSHIPLOC: Location :P1 is not a shipment location.', data_item_value_);
            END IF;
         END IF;

      ELSE
         IF (data_item_value_ IS NOT NULL) THEN
            IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
               Handling_Unit_API.Exist(data_item_value_);
            END IF;
         END IF;
         
         IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
            column_name_ := 'HANDLING_UNIT_ID';
         ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
            column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
         ELSIF(data_item_id_ = 'SHP_SSCC') THEN
            column_name_ := 'SSCC';
         ELSE
            column_name_ := data_item_id_;
         END IF;

         Pick_Shipment_API.Record_With_Column_Value_Exist(contract_                       => contract_,
                                                          shipment_id_                    => shipment_id_,
                                                          pick_list_no_                   => pick_list_no_,
                                                          shp_handling_unit_id_           => shp_handling_unit_id_,
                                                          shp_sscc_                       => shp_sscc_,
                                                          shp_alt_handling_unit_label_id_ => shp_alt_handling_unit_label_id_,
                                                          column_name_                    => column_name_,
                                                          column_description_             => data_item_description_,
                                                          column_value_                   => data_item_value_);
      END IF;
   $ELSE
      NULL;
   $END                      
END Validate_Data_Item___;

PROCEDURE Get_Filter_Keys___ (
   contract_                       OUT VARCHAR2,
   shipment_id_                    OUT VARCHAR2,
   pick_list_no_                   OUT VARCHAR2,
   shp_handling_unit_id_           OUT VARCHAR2,
   ship_location_no_               OUT VARCHAR2,
   shp_sscc_                       OUT VARCHAR2,
   shp_alt_handling_unit_label_id_ OUT VARCHAR2,
   capture_session_id_             IN  NUMBER,
   data_item_id_                   IN  VARCHAR2,
   data_item_value_                IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_              IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_                 IN  BOOLEAN  DEFAULT TRUE)
IS
   session_rec_     Data_Capture_Common_Util_API.Session_Rec;
   process_package_ VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      contract_        := session_rec_.session_contract;
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      
      -- First try and fetch "predicted" filter keys 
      pick_list_no_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PICK_LIST_NO', session_rec_ , process_package_, use_applicable_);
      shipment_id_                    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      shp_handling_unit_id_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      ship_location_no_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIP_LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      shp_sscc_                       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_SSCC', session_rec_ , process_package_, use_applicable_);
      shp_alt_handling_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      
      -- Add support for alternative handling unit keys
      IF (shp_handling_unit_id_ IS NULL AND shp_sscc_ IS NOT NULL) THEN
         shp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(shp_sscc_);
      END IF;
      IF (shp_handling_unit_id_ IS NULL AND shp_alt_handling_unit_label_id_ IS NOT NULL) THEN
         shp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(shp_alt_handling_unit_label_id_);
      END IF;
      IF (shp_sscc_ IS NULL AND shp_handling_unit_id_ IS NOT NULL) THEN
         shp_sscc_ := Handling_Unit_API.Get_Sscc(shp_handling_unit_id_);
      END IF;
      IF (shp_alt_handling_unit_label_id_ IS NULL AND shp_handling_unit_id_ IS NOT NULL) THEN
         shp_alt_handling_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(shp_handling_unit_id_);
      END IF;
      
      IF (shp_alt_handling_unit_label_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHP_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
            shp_alt_handling_unit_label_id_ := '%';
       END IF;
       
      IF (shp_sscc_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHP_SSCC', data_item_id_)) THEN
            shp_sscc_ := '%';
      END IF;
      
      IF(use_unique_values_) THEN
         IF(shipment_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, pick_list_no_, shp_handling_unit_id_, shp_sscc_, shp_alt_handling_unit_label_id_, 
                                                          'SHIPMENT_ID');
         END IF;
         
         IF(pick_list_no_ IS NULL) THEN
            pick_list_no_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, pick_list_no_, shp_handling_unit_id_, shp_sscc_, shp_alt_handling_unit_label_id_, 
                                                           'PICK_LIST_NO');
         END IF;
         
         IF(shp_handling_unit_id_ IS NULL) THEN
            shp_handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, pick_list_no_, shp_handling_unit_id_, shp_sscc_, shp_alt_handling_unit_label_id_, 
                                                                   'SHP_HANDLING_UNIT_ID');
         END IF;
         
         IF(shp_sscc_ IS NULL OR shp_sscc_ = '%') THEN
            shp_sscc_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, pick_list_no_, shp_handling_unit_id_, shp_sscc_, shp_alt_handling_unit_label_id_, 
                                                       'SHP_SSCC');
         END IF;
         
         IF(shp_alt_handling_unit_label_id_ IS NULL OR shp_alt_handling_unit_label_id_ = '%') THEN
            shp_alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, pick_list_no_, shp_handling_unit_id_, shp_sscc_, shp_alt_handling_unit_label_id_, 
                                                                             'SHP_ALT_HANDLING_UNIT_LABEL_ID');
         END IF;
         
      END IF;
      
   $ELSE
      NULL;
   $END
END Get_Filter_Keys___;

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                       IN VARCHAR2,
   shipment_id_                    IN VARCHAR2,
   pick_list_no_                   IN VARCHAR2,
   shp_handling_unit_id_           IN VARCHAR2,
   shp_sscc_                       IN VARCHAR2,
   shp_alt_handling_unit_label_id_ IN VARCHAR2,
   wanted_data_item_id_            IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_                VARCHAR2(200);
   column_name_                 VARCHAR2(30);
BEGIN

   IF (wanted_data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_ALT_HANDLING_UNIT_LABEL_ID', 'SHP_SSCC')) THEN
      IF (wanted_data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
         column_name_ := 'HANDLING_UNIT_ID';
      ELSIF (wanted_data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
         column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
      ELSIF(wanted_data_item_id_ = 'SHP_SSCC') THEN
         column_name_ := 'SSCC';
      END IF;
   ELSE
      column_name_ := wanted_data_item_id_;
   END IF;  
   
   unique_value_ := Pick_Shipment_API.Get_Column_Value_If_Unique(contract_                       => contract_,
                                                                 shipment_id_                    => shipment_id_,
                                                                 pick_list_no_                   => pick_list_no_,
                                                                 shp_handling_unit_id_           => shp_handling_unit_id_,
                                                                 shp_sscc_                       => shp_sscc_,
                                                                 shp_alt_handling_unit_label_id_ => shp_alt_handling_unit_label_id_,
                                                                 column_name_                    => column_name_);
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;

PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_             IN NUMBER,
   owning_data_item_id_            IN VARCHAR2,
   data_item_detail_id_            IN VARCHAR2,
   shipment_id_                    IN VARCHAR2,
   pick_list_no_                   IN VARCHAR2,
   shp_handling_unit_id_           IN VARCHAR2,
   shp_sscc_                       IN VARCHAR2,
   shp_alt_handling_unit_label_id_ IN VARCHAR2 DEFAULT NULL)
IS
   detail_value_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('SHIPMENT_ID') THEN
            detail_value_ := shipment_id_;
         WHEN ('PICK_LIST_NO') THEN
            detail_value_ := pick_list_no_;
         WHEN ('SHP_HANDLING_UNIT_ID') THEN
            detail_value_ := shp_handling_unit_id_;
         WHEN ('SHP_SSCC') THEN
            IF(shp_sscc_ = 'NULL') THEN
               detail_value_ := NULL;
            ELSE
               detail_value_ := shp_sscc_;
            END IF;
         WHEN ('SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
            IF(shp_alt_handling_unit_label_id_ = 'NULL') THEN
               detail_value_ := NULL;
            ELSE
               detail_value_ := shp_alt_handling_unit_label_id_;
            END IF;
         ELSE
            NULL;
      END CASE;

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Filter_Key_Detail___;

PROCEDURE Add_Unique_Data_Item_Detail___ (
   capture_session_id_          IN NUMBER,
   session_rec_                 IN Data_Capture_Common_Util_API.Session_Rec,
   owning_data_item_id_         IN VARCHAR2,
   owning_data_item_value_      IN VARCHAR2,
   data_item_detail_id_         IN VARCHAR2,
   contract_                    IN VARCHAR2,
   shipment_id_                 IN VARCHAR2,
   pick_list_no_                IN VARCHAR2)  
IS
   detail_value_    VARCHAR2(4000);
   process_package_ VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      -- All non filter key data items, try and fetch their predicted value
      detail_value_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_      => capture_session_id_,
                                                                              current_data_item_id_    => owning_data_item_id_,
                                                                              current_data_item_value_ => owning_data_item_value_,
                                                                              wanted_data_item_id_     => data_item_detail_id_,
                                                                              session_rec_             => session_rec_,
                                                                              process_package_         => process_package_);

      IF (detail_value_ IS NULL AND data_item_detail_id_ IN ('SHIP_LOCATION_NO')) THEN
         detail_value_ := Get_Ship_Location_No___(shipment_id_, contract_, pick_list_no_);
         IF (detail_value_ = 'NULL') THEN
            detail_value_ := NULL;
         END IF;
      END IF;
      
      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;

FUNCTION Get_Ship_Location_No___ (
   shipment_id_  IN NUMBER,
   contract_     IN VARCHAR2,
   pick_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   shipment_rec_                Shipment_API.Public_Rec;
   return_value_                VARCHAR2(200);
   uses_shipment_inventory_     NUMBER;
BEGIN
   IF (nvl(shipment_id_,0) != 0) THEN
      shipment_rec_ := Shipment_API.Get(shipment_id_);
   END IF;

   IF (pick_list_no_ IS NOT NULL) THEN
      uses_shipment_inventory_ := Handle_Ship_Invent_Utility_API.Uses_Shipment_Inventory(pick_list_no_   => pick_list_no_, 
                                                                                         pick_list_type_ => 'CUST_ORDER_PICK_LIST'); 
   END IF;
   IF (uses_shipment_inventory_ = 0) THEN
      return_value_ := 'NULL';
   ELSIF (uses_shipment_inventory_ = 1) THEN   -- use shipment inventory 
      IF (shipment_rec_.ship_inventory_location_no IS NOT NULL) THEN
         -- use ship_inventory_location_no from shipment
         return_value_ := shipment_rec_.ship_inventory_location_no;
      ELSE
         -- if there is only 1 unique shipment location return it
         return_value_ := Inventory_Location_API.Get_Location_No_If_Unique(contract_ => contract_,
                                                                           lov_id_   => 7);
      END IF;
   END IF;

   RETURN return_value_;
END Get_Ship_Location_No___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   message_ VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'PICKOK: The report of picking was saved.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'PICKSOK: :P1 reports of picking were saved.', NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;

@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   IF (Security_SYS.Is_Proj_Action_Available('ReportPickingOfPickListLines', 'ReportPickShipHandlingUnit')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;


PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2)
IS
BEGIN
   IF(data_item_id_ LIKE 'GS1%') THEN
      Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
   ELSE
      Validate_Data_Item___(capture_session_id_, data_item_id_, data_item_value_);
   END IF;
END Validate_Data_Item;

PROCEDURE Create_List_Of_Values(
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_       IN VARCHAR2,
   contract_           IN VARCHAR2)
IS
   dummy_                           VARCHAR2(5);
   shipment_id_                     VARCHAR2(15);
   pick_list_no_                    VARCHAR2(15);         
   shp_handling_unit_id_            NUMBER;
   ship_location_no_                VARCHAR2(30);
   shp_sscc_                        VARCHAR2(18);
   shp_alt_handling_unit_label_id_  VARCHAR2(25);
   column_name_                     VARCHAR2(30);
   lov_type_db_                     VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Get_Filter_Keys___(dummy_, shipment_id_, pick_list_no_, shp_handling_unit_id_, ship_location_no_, shp_sscc_, 
                         shp_alt_handling_unit_label_id_, capture_session_id_, data_item_id_);
      lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);

      IF (data_item_id_ = 'SHIP_LOCATION_NO') THEN
            Inventory_Location_API.Create_Data_Capture_Lov(contract_, capture_session_id_, 4);
      ELSE
         IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
            column_name_ := 'HANDLING_UNIT_ID';
         ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
            column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
         ELSIF(data_item_id_ = 'SHP_SSCC') THEN
            column_name_ := 'SSCC';
         ELSE
            column_name_ := data_item_id_;
         END IF;
         
         Pick_Shipment_API.Create_Data_Capture_Lov(contract_                       => contract_,
                                                   shipment_id_                    => shipment_id_, 
                                                   pick_list_no_                   => pick_list_no_, 
                                                   shp_handling_unit_id_           => shp_handling_unit_id_, 
                                                   shp_sscc_                       => shp_sscc_, 
                                                   shp_alt_handling_unit_label_id_ => shp_alt_handling_unit_label_id_, 
                                                   column_name_                    => column_name_,
                                                   capture_session_id_             => capture_session_id_,
                                                   lov_type_db_                    => lov_type_db_);
      END IF;  

   $ELSE
      NULL;
   $END
END Create_List_Of_Values;

PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY VARCHAR2,
   capture_session_id_ IN     NUMBER,
   contract_           IN     VARCHAR2,
   attr_               IN     VARCHAR2,
   blob_ref_attr_      IN     VARCHAR2)
IS
   ptr_                         NUMBER;
   name_                        VARCHAR2(50);
   value_                       VARCHAR2(4000);
   pick_list_no_                VARCHAR2(15);
   shipment_id_                 NUMBER;
   shp_handling_unit_id_        NUMBER;
   ship_location_no_            VARCHAR2(30);
   message_                     CLOB;
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   clob_out_data_               CLOB;   
   session_id_                  NUMBER := 0;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_            := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      ptr_                    := NULL;
      
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'PICK_LIST_NO') THEN
            pick_list_no_ := value_;
         ELSIF (name_ = 'SHIPMENT_ID') THEN
            shipment_id_ := value_;
         ELSIF(name_ = 'SHIP_LOCATION_NO') THEN
            ship_location_no_ := value_;
         ELSIF(name_ = 'SHP_HANDLING_UNIT_ID') THEN
            shp_handling_unit_id_ := value_;
         END IF;
      END LOOP;
      
      Message_SYS.Add_Attribute(message_, 'HANDLING_UNIT_ID' , shp_handling_unit_id_); 
      Message_SYS.Add_Attribute(message_, 'LAST_LINE' , 'TRUE');
      
      clob_out_data_ := Pick_Shipment_API.Pick_Report_Ship_Handl_Unit__(message_           => message_,
                                                                        ship_location_no_  => ship_location_no_,
                                                                        pick_list_no_      => pick_list_no_,
                                                                        shipment_id_       => shipment_id_);
                                                                  
      session_id_ := Message_SYS.Find_Attribute(clob_out_data_, 'SESSION_ID', session_id_);
      $IF Component_Order_SYS.INSTALLED $THEN
      IF(session_id_ != 0) THEN
         Temporary_Pick_Reservation_API.Clear_Session(session_id_);
      END IF;
      $ELSE
         NULL;   
      $END       
      
   $ELSE
      NULL;
   $END
END Execute_Process;

FUNCTION Get_Automatic_Data_Item_Value(   
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   session_rec_                     Data_Capture_Common_Util_API.Session_Rec;
   automatic_value_                 VARCHAR2(200);
   contract_                        VARCHAR2(5);
   shipment_id_                     VARCHAR2(18);
   pick_list_no_                    VARCHAR2(15);         
   shp_handling_unit_id_            VARCHAR2(18);
   shp_sscc_                        VARCHAR2(18);
   ship_location_no_                VARCHAR2(30);
   shp_alt_handling_unit_label_id_  VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- Try and get value from any previously scanned GS1 barcode if this data item have AI code connected to them. Also reducing the value to lengths we have on the IFS objects
      automatic_value_ := SUBSTR(Data_Capture_Session_API.Get_Item_Value_From_Gs1_Items(capture_session_id_ => capture_session_id_,
                                                                                        capture_process_id_ => session_rec_.capture_process_id,
                                                                                        capture_config_id_  => session_rec_.capture_config_id,
                                                                                        data_item_id_       => data_item_id_), 1, 
                                                                                        NVL(Data_Capt_Proc_Data_Item_API.Get_String_Length(session_rec_.capture_process_id, data_item_id_), 200));
      IF(automatic_value_ IS NULL) THEN
         
         Get_Filter_Keys___(contract_, shipment_id_, pick_list_no_, shp_handling_unit_id_, ship_location_no_, shp_sscc_, 
                            shp_alt_handling_unit_label_id_, capture_session_id_, data_item_id_);
         
         IF(data_item_id_ IN ('SHIPMENT_ID','PICK_LIST_NO', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            automatic_value_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, pick_list_no_, shp_handling_unit_id_, shp_sscc_, shp_alt_handling_unit_label_id_, 
                                                              data_item_id_);
         -- Shipment_Location_No is not part of filter keys                                                     
         ELSE
            IF(shipment_id_ IS NULL OR pick_list_no_ IS NULL AND shp_handling_unit_id_ IS NOT NULL) THEN
               shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, pick_list_no_, shp_handling_unit_id_, shp_sscc_, shp_alt_handling_unit_label_id_, 
                                                             'SHIPMENT_ID');
               
               pick_list_no_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, pick_list_no_, shp_handling_unit_id_, shp_sscc_, shp_alt_handling_unit_label_id_, 
                                                              'PICK_LIST_NO');                                                            
            END IF; 
            automatic_value_ := Get_Ship_Location_No___(shipment_id_, contract_, pick_list_no_);
         END IF;
                
      END IF;
      
      RETURN automatic_value_;
   $ELSE
      NULL;
   $END
END Get_Automatic_Data_Item_Value;

PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_                     Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_            Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                        VARCHAR2(5);
   shipment_id_                     VARCHAR2(18);
   pick_list_no_                    VARCHAR2(15);         
   shp_handling_unit_id_            VARCHAR2(18);
   ship_location_no_                VARCHAR2(18);
   shp_sscc_                        VARCHAR2(18);
   shp_alt_handling_unit_label_id_  VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, shipment_id_, pick_list_no_, shp_handling_unit_id_, ship_location_no_, shp_sscc_, 
                         shp_alt_handling_unit_label_id_, capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);
                         
      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
      
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHIPMENT_ID', 'PICK_LIST_NO', 'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 
                                                                    'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
                                                                    
                  shp_alt_handling_unit_label_id_ := CASE shp_alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE shp_alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  shp_sscc_ :=  CASE shp_sscc_ WHEN '%' THEN NULL ELSE shp_sscc_ END;
                  
                  Add_Filter_Key_Detail___(capture_session_id_             => capture_session_id_,
                                           owning_data_item_id_            => latest_data_item_id_,
                                           data_item_detail_id_            => conf_item_detail_tab_(i).data_item_detail_id,
                                           shipment_id_                    => shipment_id_,
                                           pick_list_no_                   => pick_list_no_,
                                           shp_handling_unit_id_           => shp_handling_unit_id_,
                                           shp_sscc_                       => shp_sscc_,
                                           shp_alt_handling_unit_label_id_ => shp_alt_handling_unit_label_id_);

               ELSE
                  -- Data Items that are not part of the filter keys
                  Add_Unique_Data_Item_Detail___(capture_session_id_          => capture_session_id_,
                                                 session_rec_                 => session_rec_,
                                                 owning_data_item_id_         => latest_data_item_id_,
                                                 owning_data_item_value_      => latest_data_item_value_,
                                                 data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                                 contract_                    => contract_,
                                                 shipment_id_                 => shipment_id_,
                                                 pick_list_no_                => pick_list_no_);
               END IF;
            ELSE
               -- IF Detail items are Feedbacks
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHP_HANDLING_UNIT_TYPE_ID', 'SHP_HANDLING_UNIT_TYPE_DESC', 'SHP_HANDLING_UNIT_TYPE_CATEG_ID',
                                                                    'SHP_HANDLING_UNIT_TYPE_CATEG_DESC', 'SHP_HANDLING_UNIT_TYPE_UOM_VOLUME', 'SHP_HANDLING_UNIT_TYPE_UOM_WEIGHT')) THEN
                  -- Feedback items related to shipment handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                              owning_data_item_id_ => latest_data_item_id_,
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_id_    => shp_handling_unit_id_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN('HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT', 'HANDLING_UNIT_OPERATIVE_VOLUME',
                                                                      'HANDLING_UNIT_WAREHOUSE_ID', 'HANDLING_UNIT_BAY_ID', 'HANDLING_UNIT_TIER_ID',
                                                                      'HANDLING_UNIT_ROW_ID', 'HANDLING_UNIT_BIN_ID', 'HANDLING_UNIT_LOCATION_TYPE',
                                                                      'HANDLING_UNIT_LOCATION_NO_DESC')) THEN
                  
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_  => capture_session_id_,
                                                                             owning_data_item_id_ => latest_data_item_id_,
                                                                             data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_    => shp_handling_unit_id_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHIP_LOCATION_NO_DESC')) THEN
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id, 
                                                                           contract_            => contract_, 
                                                                           location_no_         => ship_location_no_);
               END IF;
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Add_Details_For_Latest_Item;

-------------------- LU  NEW METHODS -------------------------------------
