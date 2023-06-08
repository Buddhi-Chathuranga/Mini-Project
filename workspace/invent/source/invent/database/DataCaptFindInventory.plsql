-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptFindInventory
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: FIND_INVENTORY
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210715  BwItlK  Bug 159850 (SCZ-15196), Modified Create_List_Of_Values() method passing a new variable sql_where_expression to filter out parts with quantity 0.
--  210108  NiAslk  SC2020R1-11746,Modified Is_Process_Available method to add the valid projection name.
--  201221  NiAslk  SC2020R1-11746,Modified Is_Process_Available method to make the process visible in the menu.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  180131  DaZase  STRSC-16633, Added setting of lov_type_db_ in Create_List_Of_Values.
--  171019  SWiclk  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Get_Filter_Keys___ (
   contract_                   OUT VARCHAR2,
   part_no_                    OUT VARCHAR2,
   location_no_                OUT VARCHAR2,   
   gtin_no_                    OUT VARCHAR2,
   capture_session_id_         IN  NUMBER,
   data_item_id_               IN  VARCHAR2,
   data_item_value_            IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_          IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_             IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_           Data_Capture_Common_Util_API.Session_Rec;
   process_package_       VARCHAR2(30);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      contract_        := session_rec_.session_contract;

      -- First try and fetch "predicted" filter keys 
      part_no_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_, use_applicable_);
      location_no_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      gtin_no_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'GTIN', session_rec_ , process_package_, use_applicable_);
            
      IF (gtin_no_ IS NULL AND Data_Capture_Invent_Util_API.Gtin_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
         gtin_no_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_);
      END IF;
      
      IF ((part_no_ IS NULL) AND (gtin_no_ IS NOT NULL)) THEN
         part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(gtin_no_); 
      END IF;
         
      IF use_unique_values_ THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (part_no_ IS NULL) THEN
            part_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_,'PART_NO');
         END IF;         
         IF (location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, 'LOCATION_NO');
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
   part_no_              IN VARCHAR2,
   location_no_          IN VARCHAR2,
   gtin_no_              IN VARCHAR2)  
IS
   detail_value_             VARCHAR2(4000);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      CASE (data_item_detail_id_)
         WHEN ('PART_NO') THEN
            detail_value_ := part_no_;
         WHEN ('LOCATION_NO') THEN
            detail_value_ := location_no_;
         WHEN ('GTIN_NO') THEN
            detail_value_ := gtin_no_;
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

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   wanted_data_item_id_        IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_          VARCHAR2(200);
   dummy_                 BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF (wanted_data_item_id_ IN ('PART_NO', 'LOCATION_NO')) THEN
         unique_value_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                 contract_                   => contract_,
                                                                                 part_no_                    => part_no_,
                                                                                 configuration_id_           => NULL,
                                                                                 location_no_                => location_no_,
                                                                                 lot_batch_no_               => NULL,
                                                                                 serial_no_                  => NULL,
                                                                                 eng_chg_level_              => NULL,
                                                                                 waiv_dev_rej_no_            => NULL,
                                                                                 activity_seq_               => NULL,
                                                                                 handling_unit_id_           => NULL,
                                                                                 alt_handling_unit_label_id_ => NULL,
                                                                                 column_name_                => wanted_data_item_id_);
      END IF;
      IF (unique_value_ = 'NULL') THEN
         unique_value_ := NULL;
      END IF;
   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___; 

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_List_Of_Values (
   capture_session_id_  IN NUMBER,
   capture_process_id_  IN VARCHAR2,
   capture_config_id_   IN NUMBER,
   data_item_id_        IN VARCHAR2,
   contract_            IN VARCHAR2 )
IS
   lov_type_db_    VARCHAR2(20);
   part_no_        VARCHAR2(25);
   location_no_    VARCHAR2(35);   
   gtin_no_        VARCHAR2(14);
   dummy_contract_ VARCHAR2(5);
   -- Added sql_where_expression to filter out parts where qty is greather than 0
   sql_where_expression_ VARCHAR2(50) := ' AND qty_onhand > 0';
   
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Get_Filter_Keys___(dummy_contract_, part_no_, location_no_, gtin_no_, capture_session_id_, data_item_id_);
      IF (data_item_id_ IN ('PART_NO', 'LOCATION_NO')) THEN
         lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
         Inventory_Part_In_Stock_API.Create_Data_Capture_Lov(contract_                   => contract_,
                                                             part_no_                    => part_no_,
                                                             configuration_id_           => NULL,
                                                             location_no_                => location_no_,
                                                             lot_batch_no_               => NULL,
                                                             serial_no_                  => NULL,
                                                             eng_chg_level_              => NULL,
                                                             waiv_dev_rej_no_            => NULL,
                                                             activity_seq_               => NULL,
                                                             handling_unit_id_           => NULL,
                                                             alt_handling_unit_label_id_ => NULL,
                                                             capture_session_id_         => capture_session_id_,
                                                             column_name_                => data_item_id_,
                                                             lov_type_db_                => lov_type_db_,
                                                             sql_where_expression_       => sql_where_expression_);
      END IF;
   $ELSE
      NULL;
   $END  

END Create_List_Of_Values;

PROCEDURE Validate_Data_Item (
   capture_session_id_  IN NUMBER,
   data_item_id_        IN VARCHAR2, 
   data_item_value_     IN VARCHAR2 )       
IS
   part_no_                      VARCHAR2(25);
   contract_                     VARCHAR2(5);
   location_no_                  VARCHAR2(35);
   gtin_no_                      VARCHAR2(14);   
   data_item_description_        VARCHAR2(200);
   
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN      
      Get_Filter_Keys___(contract_, part_no_, location_no_, gtin_no_, capture_session_id_, data_item_id_, data_item_value_);                                             
      data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);

      IF(data_item_id_ LIKE 'GS1%') THEN
         Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      ELSIF (data_item_value_ IS NOT NULL) THEN        
         IF (data_item_id_ IN ('PART_NO')) THEN
            Inventory_Part_API.Exist(contract_, part_no_);         
         ELSIF (data_item_id_ IN ('LOCATION_NO')) THEN
            Inventory_Location_API.Exist(contract_, location_no_);         
         ELSIF (data_item_id_ IN ('GTIN_NO')) THEN
            Part_Gtin_API.Exist(part_no_, gtin_no_);         
         END IF;      
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Data_Item;

@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   IF (Security_SYS.Is_Projection_Available('InventoryPartInStockHandling')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;

PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY VARCHAR2,
   capture_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   attr_               IN VARCHAR2,
   blob_ref_attr_      IN VARCHAR2 )
IS
  
BEGIN
  NULL;
END Execute_Process;

@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   message_               VARCHAR2(200);
BEGIN
   message_ :=  Language_SYS.Translate_Constant(lu_name_, 'FINDINVENTORY: Find inventory completed.');
   RETURN message_;
END Get_Process_Execution_Message;

@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS   
   part_no_          VARCHAR2(25);
   gtin_no_          VARCHAR2(14);
   contract_         VARCHAR2(5);
   location_no_      VARCHAR2(35);   
   automatic_value_  VARCHAR2(200);
   dummy_            BOOLEAN;
   session_rec_      Data_Capture_Common_Util_API.Session_Rec;   
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN  
      session_rec_  := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_); 
      -- Try and get value from any previously scanned GS1 barcode if this data item have AI code connected to them. Also reducing the value to lengths we have on the IFS objects 
      automatic_value_ := SUBSTR(Data_Capture_Session_API.Get_Item_Value_From_Gs1_Items(capture_session_id_ => capture_session_id_, 
                                                                                        capture_process_id_ => session_rec_.capture_process_id, 
                                                                                        capture_config_id_  => session_rec_.capture_config_id, 
                                                                                        data_item_id_       => data_item_id_), 1,  
                                     NVL(Data_Capt_Proc_Data_Item_API.Get_String_Length(session_rec_.capture_process_id, data_item_id_), 200)); 

      IF (automatic_value_ IS NULL) THEN
         Get_Filter_Keys___(contract_, part_no_, location_no_, gtin_no_, capture_session_id_, data_item_id_);
         IF (data_item_id_ IN ('PART_NO', 'LOCATION_NO')) THEN    
               automatic_value_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                          contract_                   => contract_,
                                                                                          part_no_                    => part_no_,
                                                                                          configuration_id_           => NULL,
                                                                                          location_no_                => location_no_,
                                                                                          lot_batch_no_               => NULL,
                                                                                          serial_no_                  => NULL,
                                                                                          eng_chg_level_              => NULL,
                                                                                          waiv_dev_rej_no_            => NULL,
                                                                                          activity_seq_               => NULL,
                                                                                          handling_unit_id_           => NULL,
                                                                                          alt_handling_unit_label_id_ => NULL,      
                                                                                          column_name_                => data_item_id_);
         ELSIF (data_item_id_= 'GTIN') THEN        
            automatic_value_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_);  
            IF (part_no_ IS NOT NULL AND automatic_value_ IS NULL) THEN            
               automatic_value_ := 'NULL';                     
            END IF;
         END IF;
      END IF;
      RETURN automatic_value_;
   $ELSE
      RETURN NULL;
   $END

END Get_Automatic_Data_Item_Value;

@UncheckedAccess
PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_      IN NUMBER,
   latest_data_item_id_     IN VARCHAR2,
   latest_data_item_value_  IN VARCHAR2 )
IS
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   contract_                     VARCHAR2(5);
   part_no_                      VARCHAR2(25);
   location_no_                  VARCHAR2(35);   
   gtin_no_                      VARCHAR2(14);
   gs1_                          VARCHAR2(4000);
   conf_item_detail_tab_         Data_Capture_Common_Util_API.Config_Item_Detail_Tab;   
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- fetch all necessary keys for all possible detail items below
      session_rec_          := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, part_no_, location_no_, gtin_no_, capture_session_id_, latest_data_item_id_, latest_data_item_value_);

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
      
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         Data_Capture_Invent_Util_API.Add_Details_For_Find_Inventory(capture_session_id_   => capture_session_id_,
                                                                     owning_data_item_id_  => latest_data_item_id_,
                                                                     data_item_detail_tab_ => conf_item_detail_tab_,
                                                                     contract_             => contract_,
                                                                     part_no_              => part_no_,                                                                             
                                                                     location_no_          => location_no_,
                                                                     gtin_no_              => gtin_no_,
                                                                     gs1_                  => gs1_);
      END IF;
   $ELSE
       NULL; 
   $END
END Add_Details_For_Latest_Item;

-------------------- LU  NEW METHODS -------------------------------------
