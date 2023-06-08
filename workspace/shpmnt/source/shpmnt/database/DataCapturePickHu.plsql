-----------------------------------------------------------------------------
--
--  Logical unit: DataCapturePickHu
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: PICK_HU
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220614  DaZase  SCDEV-611 and SCDEV-10496, Added support for Pick By Choice and not allowing PBC for Supplier Returns.
--  200728  BudKLK  SC2020R1-1103, Created. NOTE : I have only commented the Pick_Hu_By_Choice_And_Pack___() method and all the methods related to that which I think we need test more aroudn the LOOP funtionality.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_all_values_ CONSTANT VARCHAR2(1) := '%';
number_all_values_ CONSTANT NUMBER := -1;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   capture_session_id_          IN NUMBER,
   contract_                    IN VARCHAR2,
   pick_list_no_                IN VARCHAR2,
   aggregated_line_id_          IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   res_handling_unit_id_        IN NUMBER,   
   res_sscc_                    IN VARCHAR2,
   res_alt_handl_unit_label_id_ IN VARCHAR2,
   source_ref_type_db_          IN VARCHAR2,
   wanted_data_item_id_         IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_           VARCHAR2(200);
   column_name_            VARCHAR2(30);
   pick_by_choice_option_  VARCHAR2(20);
   dummy_                  BOOLEAN;
BEGIN
   pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_);
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (wanted_data_item_id_ = 'RES_HANDLING_UNIT_ID') THEN        
         column_name_ := 'HANDLING_UNIT_ID';
      ELSIF (wanted_data_item_id_ = 'RES_SSCC') THEN
         column_name_ := 'SSCC';
      ELSIF (wanted_data_item_id_ = 'RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
         column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
      ELSIF (wanted_data_item_id_ = 'SOURCE_REF_TYPE') THEN
         column_name_ := 'SOURCE_REF_TYPE_DB';
      ELSE
         column_name_ := wanted_data_item_id_;
      END IF;
      
      IF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED OR
          source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN 
         unique_value_ := Pick_Shipment_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                       pick_list_no_               => pick_list_no_,
                                                                       aggregated_line_id_         => aggregated_line_id_,
                                                                       location_no_                => location_no_,
                                                                       handling_unit_id_           => res_handling_unit_id_,
                                                                       sscc_                       => res_sscc_,
                                                                       alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                       source_ref_type_db_         => source_ref_type_db_,
                                                                       column_name_                => column_name_,
                                                                       sql_where_expression_       => NULL);

      ELSIF wanted_data_item_id_ IN ('RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID', 'LOCATION_NO') THEN 
         unique_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_        => dummy_, 
                                                                       handling_unit_id_             => res_handling_unit_id_,
                                                                       sscc_                         => res_sscc_,
                                                                       alt_handling_unit_label_id_   => res_alt_handl_unit_label_id_, 
                                                                       column_name_                  => column_name_,
                                                                       sql_where_expression_         => Get_Pick_By_Choice_Whr_Expr___(capture_session_id_, 
                                                                                                                                       pick_list_no_, 
                                                                                                                                       location_no_, 
                                                                                                                                       res_handling_unit_id_, 
                                                                                                                                       res_sscc_, 
                                                                                                                                       aggregated_line_id_,
                                                                                                                                       source_ref_type_db_,
                                                                                                                                       column_name_)); 
      ELSE
         unique_value_ := Pick_Shipment_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                       pick_list_no_               => pick_list_no_,
                                                                       aggregated_line_id_         => aggregated_line_id_,
                                                                       location_no_                => NULL,
                                                                       handling_unit_id_           => NULL,
                                                                       sscc_                       => string_all_values_,
                                                                       alt_handling_unit_label_id_ => string_all_values_,
                                                                       source_ref_type_db_         => NULL,
                                                                       column_name_                => column_name_,
                                                                       sql_where_expression_       => NULL);
      END IF;

   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


PROCEDURE Get_Filter_Keys___ (
   contract_                    OUT VARCHAR2,
   pick_list_no_                OUT VARCHAR2,
   aggregated_line_id_          OUT VARCHAR2,
   location_no_                 OUT VARCHAR2,
   res_handling_unit_id_        OUT NUMBER,   
   res_sscc_                    OUT VARCHAR2,
   res_alt_handl_unit_label_id_ OUT VARCHAR2,
   shp_handling_unit_id_        OUT NUMBER,
   shp_sscc_                    OUT VARCHAR2,
   shp_alt_handl_unit_label_id_ OUT VARCHAR2,
   source_ref_type_db_          OUT VARCHAR2,
   capture_session_id_          IN  NUMBER,
   data_item_id_                IN  VARCHAR2,
   data_item_value_             IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_           IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_              IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
   process_package_        VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      contract_        := session_rec_.session_contract;
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      -- First try and fetch "predicted" filter keys 
      pick_list_no_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PICK_LIST_NO', session_rec_ , process_package_, use_applicable_);
      aggregated_line_id_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'AGGREGATED_LINE_ID', session_rec_ , process_package_, use_applicable_);
      shp_handling_unit_id_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      shp_sscc_                    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_SSCC', session_rec_ , process_package_, use_applicable_);
      shp_alt_handl_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      location_no_                 := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      res_handling_unit_id_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RES_HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      res_sscc_                    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RES_SSCC', session_rec_ , process_package_, use_applicable_);
      res_alt_handl_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RES_ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      source_ref_type_db_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SOURCE_REF_TYPE', session_rec_ , process_package_, use_applicable_);

      -- Add support for alternative handling unit keys
      IF (shp_handling_unit_id_ IS NULL AND shp_sscc_ IS NOT NULL) THEN
         shp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(shp_sscc_);
      END IF;
      IF (shp_handling_unit_id_ IS NULL AND shp_alt_handl_unit_label_id_ IS NOT NULL) THEN
         shp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(shp_alt_handl_unit_label_id_);
      END IF;
      IF (shp_sscc_ IS NULL AND shp_handling_unit_id_ IS NOT NULL) THEN
         shp_sscc_ := Handling_Unit_API.Get_Sscc(shp_handling_unit_id_);
      END IF;
      IF (shp_alt_handl_unit_label_id_ IS NULL AND shp_handling_unit_id_ IS NOT NULL) THEN
         shp_alt_handl_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(shp_handling_unit_id_);
      END IF;
      IF (res_handling_unit_id_ IS NULL AND res_sscc_ IS NOT NULL) THEN
         res_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(res_sscc_);
      END IF;
      IF (res_handling_unit_id_ IS NULL AND res_alt_handl_unit_label_id_ IS NOT NULL) THEN
         res_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(res_alt_handl_unit_label_id_);
      END IF;
      IF (res_sscc_ IS NULL AND res_handling_unit_id_ IS NOT NULL) THEN
         res_sscc_ := Handling_Unit_API.Get_Sscc(res_handling_unit_id_);
      END IF;
      IF (res_alt_handl_unit_label_id_ IS NULL AND res_handling_unit_id_ IS NOT NULL) THEN
         res_alt_handl_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(res_handling_unit_id_);
      END IF;

      -- if sscc_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all sscc in the table
      IF (res_sscc_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RES_SSCC', data_item_id_)) THEN
         res_sscc_ := string_all_values_;
      END IF;
      -- if alt_handling_unit_label_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all alternative handling unit label ids in the table
      IF (res_alt_handl_unit_label_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RES_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         res_alt_handl_unit_label_id_ := string_all_values_;
      END IF;

      IF (source_ref_type_db_ IS NULL AND pick_list_no_ IS NOT NULL) THEN
         source_ref_type_db_ := Data_Capture_Shpmnt_Util_API.Get_Unique_Source_Ref_Type_Db(Inventory_Pick_List_API.Get_Shipment_Id(pick_list_no_)); 
      END IF;
         
      IF use_unique_values_ THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (pick_list_no_ IS NULL) THEN
            pick_list_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, aggregated_line_id_, location_no_,
                                                           res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, source_ref_type_db_, 'PICK_LIST_NO');
         END IF;
         IF (aggregated_line_id_ IS NULL) THEN
            aggregated_line_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, aggregated_line_id_, location_no_,
                                                                 res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, source_ref_type_db_, 'AGGREGATED_LINE_ID');
         END IF;
         IF (location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, aggregated_line_id_, location_no_,
                                                          res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, source_ref_type_db_, 'LOCATION_NO');
         END IF;
         IF (res_handling_unit_id_ IS NULL) THEN
            res_handling_unit_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, aggregated_line_id_, location_no_,
                                                                   res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, source_ref_type_db_, 'RES_HANDLING_UNIT_ID');
         END IF;
         
         IF (source_ref_type_db_ IS NULL) THEN
            source_ref_type_db_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, aggregated_line_id_, location_no_,
                                                                 res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, source_ref_type_db_, 'SOURCE_REF_TYPE');
         END IF;

      END IF;
   $ELSE
      NULL;                       
   $END
END Get_Filter_Keys___;


PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_          IN NUMBER,
   owning_data_item_id_         IN VARCHAR2,
   data_item_detail_id_         IN VARCHAR2,
   pick_list_no_                IN VARCHAR2,
   aggregated_line_id_          IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   res_handling_unit_id_        IN NUMBER,
   res_sscc_                    IN VARCHAR2,
   res_alt_handl_unit_label_id_ IN VARCHAR2,
   shp_handling_unit_id_        IN NUMBER,
   shp_sscc_                    IN VARCHAR2,
   shp_alt_handl_unit_label_id_ IN VARCHAR2,
   source_ref_type_db_          IN varchar2)
IS
   detail_value_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('PICK_LIST_NO') THEN
            detail_value_ := pick_list_no_;
         WHEN ('AGGREGATED_LINE_ID') THEN
            detail_value_ := aggregated_line_id_;
         WHEN ('LOCATION_NO') THEN
            detail_value_ := location_no_;
         WHEN ('RES_HANDLING_UNIT_ID') THEN
            detail_value_ := res_handling_unit_id_;
         WHEN ('RES_SSCC') THEN
            detail_value_ := res_sscc_;
         WHEN ('RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
            detail_value_ := res_alt_handl_unit_label_id_;
         WHEN ('SHP_HANDLING_UNIT_ID') THEN
            detail_value_ := shp_handling_unit_id_;
         WHEN ('SHP_SSCC') THEN
            detail_value_ := shp_sscc_;
         WHEN ('SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
            detail_value_ := shp_alt_handl_unit_label_id_;
         WHEN ('SOURCE_REF_TYPE') THEN
            detail_value_ := source_ref_type_db_;
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
   pick_list_no_                IN VARCHAR2,
   res_handling_unit_id_        IN NUMBER )  
IS
   detail_value_    VARCHAR2(4000);
   process_package_ VARCHAR2(30);
   shipment_id_     NUMBER;
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

      -- Non filter key data items and/or feedback items that could be fetched by unique handling by calling Get_Unique_Data_Item_Value___
      
      IF (detail_value_ IS NULL AND data_item_detail_id_ IN ('SHIP_LOCATION_NO') AND res_handling_unit_id_ IS NOT NULL) THEN
         shipment_id_ := Pick_Shipment_API.Get_Shipment_Id_Hu(res_handling_unit_id_, contract_, null, pick_list_no_);
         detail_value_ := Get_Ship_Location_No___(shipment_id_, contract_);
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


PROCEDURE Get_Handling_Unit_Filters___(
   shp_handling_unit_id_        IN OUT NUMBER,
   shp_sscc_                    IN OUT VARCHAR2,
   shp_alt_handl_unit_label_id_ IN OUT VARCHAR2,
   shipment_id_                 IN OUT NUMBER,
   sql_where_expression_        IN OUT VARCHAR2,
   pick_list_no_                IN     VARCHAR2,
   res_handling_unit_id_        IN     NUMBER,
   capture_session_id_          IN     NUMBER,
   data_item_id_                IN     VARCHAR2 )
IS
   session_rec_  Data_Capture_Common_Util_API.Session_Rec;
   contract_     VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      contract_    := Data_Capture_Session_API.Get_Session_Contract(capture_session_id_);

      IF (pick_list_no_ IS NOT NULL AND res_handling_unit_id_ IS NOT NULL) THEN
         shipment_id_ := Pick_Shipment_API.Get_Shipment_Id_Hu(res_handling_unit_id_, contract_, null, pick_list_no_); -- find unique shipment for this hu and its childs
         IF (shipment_id_ IS NOT NULL AND shipment_id_ != 0) THEN
            sql_where_expression_ := ' AND handling_unit_id NOT IN (' || res_handling_unit_id_ || ') AND shipment_id = '|| shipment_id_ || ' ';
         END IF;  -- if no unique shipment found or is 0 we will not use shipment hu items (this is handled outside this method)
      ELSE
         -- To filter out shipments/handling units where the shipment are already fully pick reported, we only do this when shipment_id_ have not been identified yet.
         sql_where_expression_ := ' AND Shipment_API.Not_Pick_Reported_Line_Exist(shipment_id) = 1 ';
         shipment_id_ := number_all_values_;
      END IF;

      IF (shp_handling_unit_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHP_HANDLING_UNIT_ID', data_item_id_)) THEN
         shp_handling_unit_id_ := number_all_values_;
      END IF;
      IF (shp_sscc_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHP_SSCC', data_item_id_)) THEN
         shp_sscc_ := string_all_values_;
      END IF;
      IF (shp_alt_handl_unit_label_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHP_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         shp_alt_handl_unit_label_id_ := string_all_values_;
      END IF;
   $END
   
   sql_where_expression_ := sql_where_expression_ || ' AND shipment_id IS NOT NULL
                                                       AND Shipment_API.Get_Objstate(shipment_id)          = ''Preliminary'' 
                                                       AND Shipment_API.Connected_Lines_Exist(shipment_id) = 1
                                                       AND Shipment_API.Get_Contract(shipment_id) = ''' || contract_ || ''' ';
   
END Get_Handling_Unit_Filters___;


FUNCTION Skip_Handling_Unit___(
   capture_session_id_          IN NUMBER,
   data_item_id_                IN VARCHAR2,
   shp_handling_unit_id_        IN NUMBER,
   shp_sscc_                    IN VARCHAR2,
   shp_alt_handl_unit_label_id_ IN VARCHAR2) RETURN BOOLEAN
IS
   skip_handling_unit_ BOOLEAN := FALSE;
   session_rec_        Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      skip_handling_unit_ := ((Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_a_ => 'SHP_HANDLING_UNIT_ID', data_item_id_b_ => data_item_id_) AND shp_handling_unit_id_ IS NULL) OR
                              (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_a_ => 'SHP_SSCC', data_item_id_b_ => data_item_id_) AND shp_sscc_ IS NULL) OR
                              (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_a_ => 'SHP_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_b_ => data_item_id_) AND shp_alt_handl_unit_label_id_ IS NULL ));
   $END
   RETURN skip_handling_unit_;
END Skip_Handling_Unit___;


FUNCTION Get_Ship_Location_No___ (
   shipment_id_  IN NUMBER,
   contract_     IN VARCHAR2) RETURN VARCHAR2
IS
   shipment_rec_                Shipment_API.Public_Rec;
   return_value_                VARCHAR2(200);
BEGIN
   IF (nvl(shipment_id_,0) != 0) THEN
      shipment_rec_ := Shipment_API.Get(shipment_id_);
   END IF;
   
   IF (shipment_rec_.ship_inventory_location_no IS NOT NULL) THEN
      -- use ship_inventory_location_no from shipment
      return_value_ := shipment_rec_.ship_inventory_location_no;
   ELSE
      -- if there is only 1 unique shipment location return it
      return_value_ := Inventory_Location_API.Get_Location_No_If_Unique(contract_ => contract_,
                                                                        lov_id_   => 7);
   END IF;

   RETURN return_value_;
END Get_Ship_Location_No___;


PROCEDURE Validate_Ship_Data_Items___ (
   contract_                    IN VARCHAR2,
   shp_handling_unit_id_        IN NUMBER,
   ship_location_no_            IN VARCHAR2 )
IS
   shp_handl_unit_location_no_  VARCHAR2(35);
   shp_handl_unit_contract_     VARCHAR2(5);
BEGIN 

   IF (ship_location_no_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_,'SHIPLOCNOVALUE: Shipment Location No must have value since Use Shipment Inventory is set on the Pick List.');
   END IF;

   IF (ship_location_no_ IS NOT NULL AND shp_handling_unit_id_ IS NOT NULL) THEN 
      shp_handl_unit_location_no_ := Handling_Unit_API.Get_Location_No(shp_handling_unit_id_);
      shp_handl_unit_contract_    := Handling_Unit_API.Get_Contract(shp_handling_unit_id_);
      IF ((ship_location_no_ IS NOT NULL AND shp_handl_unit_location_no_ IS NOT NULL AND ship_location_no_ != shp_handl_unit_location_no_) OR
          (shp_handl_unit_contract_ IS NOT NULL AND contract_ != shp_handl_unit_contract_)) THEN
          Raise_Shipment_Handling_Error___(shp_handling_unit_id_, shp_handl_unit_location_no_);
      END IF;
   END IF;

END Validate_Ship_Data_Items___;


PROCEDURE Update_Aggregated_Line_Attr___(
   process_message_        IN OUT CLOB,
   pick_list_no_           IN VARCHAR2,
   aggregated_line_id_     IN REPORT_PICK_HANDLING_UNIT.objid%TYPE,
   ship_location_no_       IN VARCHAR2,
   aggr_handling_unit_id_  IN NUMBER )
IS
   local_message_          CLOB;
BEGIN
   local_message_    := Message_SYS.Find_Clob_Attribute(process_message_, 'AGGREGATED_LINE', '');
   IF local_message_ IS NULL THEN 
      local_message_ := Message_SYS.Construct_Clob_Message('AGGREGATED_LINE');
   END IF;
   Message_SYS.Set_Attribute(local_message_, 'PICK_LIST_NO', pick_list_no_);
   Message_SYS.Set_Attribute(local_message_, 'AGGREGATED_LINE_ID', aggregated_line_id_);
   Message_SYS.Set_Attribute(local_message_, 'SHIP_LOCATION_NO', ship_location_no_);
   Message_SYS.Set_Attribute(local_message_, 'AGGR_HANDLING_UNIT_ID', aggr_handling_unit_id_);
   Message_SYS.Set_Clob_Attribute(process_message_, 'AGGREGATED_LINE', local_message_);
   
END Update_Aggregated_Line_Attr___;


PROCEDURE Get_Aggregated_Line_Attr___(
   process_message_        IN OUT CLOB,
   pick_list_no_           IN OUT VARCHAR2,
   aggregated_line_id_     IN OUT REPORT_PICK_HANDLING_UNIT.objid%TYPE,
   ship_location_no_       IN OUT VARCHAR2,
   aggr_handling_unit_id_  IN OUT NUMBER )
IS
   local_message_         CLOB;
BEGIN
   local_message_ := Message_SYS.Find_Clob_Attribute(process_message_, 'AGGREGATED_LINE', '');
   IF local_message_ IS NOT NULL THEN 
      pick_list_no_           := Message_SYS.Find_Attribute(local_message_, 'PICK_LIST_NO', '');
      aggregated_line_id_     := Message_SYS.Find_Attribute(local_message_, 'AGGREGATED_LINE_ID', '');
      ship_location_no_       := Message_SYS.Find_Attribute(local_message_, 'SHIP_LOCATION_NO', '');
      aggr_handling_unit_id_  := Message_SYS.Find_Attribute(local_message_, 'AGGR_HANDLING_UNIT_ID', -1);
   END IF;
END Get_Aggregated_Line_Attr___;


PROCEDURE Reset_Res_Handl_Unit_Ids___(
   process_message_        IN OUT CLOB )
IS
   local_message_          CLOB;
BEGIN
   local_message_ := Message_SYS.Construct_Clob_Message('RES_HANDLING_UNIT_IDS');
   Message_SYS.Set_Clob_Attribute(process_message_, 'RES_HANDLING_UNIT_IDS', local_message_);
END Reset_Res_Handl_Unit_Ids___;


PROCEDURE Update_Res_Handl_Unit_Ids___(
   process_message_        IN OUT CLOB,
   res_handling_unit_id_   IN     NUMBER )
IS
   local_message_          CLOB;
BEGIN
   IF (res_handling_unit_id_ IS NOT NULL) THEN
      local_message_    := Message_SYS.Find_Clob_Attribute(process_message_, 'RES_HANDLING_UNIT_IDS', '');

      IF local_message_ IS NULL THEN 
         -- We need to have a seperate sub message for handling units so we construct a local_message_ and add or update it in process_message_
         local_message_ := Message_SYS.Construct_Clob_Message('RES_HANDLING_UNIT_IDS');
      END IF;
      -- It is important here to use Add_Attribute for RES_HANDLING_UNIT_ID since we dont want to reset the previouse data rather 
      -- we want to add new data to the list of RES_HANDLING_UNIT_IDS
      -- Since we use same clob to send to method pick by choice and there the attribute name is 'HANDLING_UNIT_ID' it is very inmportant to use same attribute name here name here
      Message_SYS.Add_Attribute(local_message_, 'HANDLING_UNIT_ID', res_handling_unit_id_);
      Message_SYS.Set_Clob_Attribute(process_message_, 'RES_HANDLING_UNIT_IDS', local_message_);
   END IF;
END Update_Res_Handl_Unit_Ids___;


FUNCTION Get_Res_Handling_Unit_Ids___(
   process_message_ IN OUT CLOB ) RETURN CLOB
IS
   local_message_      CLOB;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      local_message_    := Message_SYS.Find_Clob_Attribute(process_message_, 'RES_HANDLING_UNIT_IDS', '');
   END IF;
   RETURN local_message_;
END Get_Res_Handling_Unit_Ids___;


FUNCTION Get_Res_Handl_Unit_Id_Tab___(
   process_message_ IN OUT CLOB ) RETURN Handling_Unit_API.Handling_Unit_Id_Tab
IS
   local_message_      CLOB;
   count_              NUMBER;
   name_arr_           Message_SYS.name_table_clob;
   value_arr_          Message_SYS.line_table_clob;
   handl_unit_id_tab_  Handling_Unit_API.Handling_Unit_Id_Tab;
   rec_counter_        NUMBER := 0;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      local_message_    := Message_SYS.Find_Clob_Attribute(process_message_, 'RES_HANDLING_UNIT_IDS', '');
      Message_SYS.Get_Clob_Attributes(local_message_, count_, name_arr_, value_arr_);  
      FOR n_ IN 1..count_ LOOP
         IF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
            handl_unit_id_tab_(rec_counter_).handling_unit_id := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
            rec_counter_ := rec_counter_ + 1;
         END IF;
      END LOOP;
   END IF;
   
   RETURN handl_unit_id_tab_;
END Get_Res_Handl_Unit_Id_Tab___;


PROCEDURE Reset_Shp_Handl_Unit_Ids___(
   process_message_        IN OUT CLOB )
IS
   local_message_          CLOB;
BEGIN
   local_message_ := Message_SYS.Construct_Clob_Message('SHP_HANDLING_UNIT_IDS');
   Message_SYS.Set_Clob_Attribute(process_message_, 'SHP_HANDLING_UNIT_IDS', local_message_);
END Reset_Shp_Handl_Unit_Ids___;


PROCEDURE Update_Shp_Handl_Unit_Ids___(
   process_message_        IN OUT CLOB,
   shp_handling_unit_id_   IN     NUMBER )
IS
   local_message_          CLOB;
BEGIN
   IF (shp_handling_unit_id_ IS NOT NULL) THEN
      local_message_    := Message_SYS.Find_Clob_Attribute(process_message_, 'SHP_HANDLING_UNIT_IDS', '');

      IF local_message_ IS NULL THEN 
         -- We need to have a seperate sub message for handling units so we construct a local_message_ and add or update it in process_message_
         local_message_ := Message_SYS.Construct_Clob_Message('SHP_HANDLING_UNIT_IDS');
      END IF;
      -- It is important here to use Add_Attribute for SHP_HANDLING_UNIT_ID since we dont want to reset the previouse data rather 
      -- we want to add new data to the list of SHP_HANDLING_UNIT_IDS
      Message_SYS.Add_Attribute(local_message_, 'SHP_HANDLING_UNIT_ID', shp_handling_unit_id_);
      Message_SYS.Set_Clob_Attribute(process_message_, 'SHP_HANDLING_UNIT_IDS', local_message_);
   END IF;
END Update_Shp_Handl_Unit_Ids___;


FUNCTION Get_Shp_Handling_Unit_Ids___(
   process_message_ IN OUT CLOB ) RETURN CLOB
IS
   local_message_      CLOB;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      local_message_    := Message_SYS.Find_Clob_Attribute(process_message_, 'SHP_HANDLING_UNIT_IDS', '');
   END IF;
   
   RETURN local_message_;
END Get_Shp_Handling_Unit_Ids___;


FUNCTION Get_Shp_Handl_Unit_Id_Tab___(
   process_message_ IN OUT CLOB ) RETURN Handling_Unit_API.Handling_Unit_Id_Tab
IS
   local_message_      CLOB;
   count_              NUMBER;
   name_arr_           Message_SYS.name_table_clob;
   value_arr_          Message_SYS.line_table_clob;
   handl_unit_id_tab_  Handling_Unit_API.Handling_Unit_Id_Tab;
   rec_counter_        NUMBER := 0;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      local_message_    := Message_SYS.Find_Clob_Attribute(process_message_, 'SHP_HANDLING_UNIT_IDS', '');
      Message_SYS.Get_Clob_Attributes(local_message_, count_, name_arr_, value_arr_);  
      FOR n_ IN 1..count_ LOOP
         IF (name_arr_(n_) = 'SHP_HANDLING_UNIT_ID') THEN
            handl_unit_id_tab_(rec_counter_).handling_unit_id := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
            rec_counter_ := rec_counter_ + 1;
         END IF;
      END LOOP;
   END IF;
   
   RETURN handl_unit_id_tab_;
END Get_Shp_Handl_Unit_Id_Tab___;


PROCEDURE Update_Inventory_Event_Id___(
   process_message_    IN OUT CLOB,
   inventory_event_id_ IN     NUMBER )
IS
BEGIN
   -- We dont need to construct message (Message_SYS.Construct_Message) here since we already did it in Pre_Process_Action
   IF (inventory_event_id_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(process_message_, 'INVENTORY_EVENT_ID', inventory_event_id_);
   END IF;
END Update_Inventory_Event_Id___;


FUNCTION Get_Inventory_Event_Id___(
   process_message_ IN OUT CLOB ) RETURN NUMBER
IS
   inventory_event_id_ NUMBER;
   number_null_        NUMBER;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      inventory_event_id_ := Message_SYS.Find_Attribute(process_message_, 'INVENTORY_EVENT_ID', number_null_);
   END IF;
   
   IF (inventory_event_id_ IS NULL) THEN 
      inventory_event_id_ := Inventory_Event_Manager_API.Get_Next_Inventory_Event_Id;
      -- We dont need to construct message (Message_SYS.Construct_Message) here since we already did it in Pre_Process_Action
      Update_inventory_event_Id___(process_message_, inventory_event_id_);
   END IF;
   
   RETURN inventory_event_id_;
END Get_Inventory_Event_Id___;


PROCEDURE Set_Loop_Exist___(
   process_message_    IN OUT CLOB,
   loop_exist_         IN VARCHAR2 )
IS
BEGIN
   IF (loop_exist_ IS NOT NULL) THEN
      -- We dont need to construct message (Message_SYS.Construct_Message) here since we already did it in Pre_Process_Action
      Message_SYS.Set_Attribute(process_message_, 'LOOP_EXIST', loop_exist_);
   END IF;
END Set_Loop_Exist___;


FUNCTION Get_Loop_Exist___(
   process_message_ IN OUT CLOB ) RETURN VARCHAR2
IS
   loop_exist_ VARCHAR2(5);
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      loop_exist_ := Message_SYS.Find_Attribute(process_message_, 'LOOP_EXIST', '');
   END IF;
   
   RETURN loop_exist_;
END Get_Loop_Exist___;


PROCEDURE Pack_To_Shipment_Handl_Unit___ (
   res_handling_unit_id_   IN NUMBER,
   shp_handling_unit_id_   IN NUMBER,
   capture_session_id_     IN NUMBER )
IS
   session_rec_             Data_Capture_Common_Util_API.Session_Rec;
   max_weight_volume_error_ VARCHAR2(5);
BEGIN  
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- If shipment id of both res_handling_unit_id_ and shp_handling_unit_id_ are the same, then we can change parent otherwise 
      -- the reservations are seperated from res_handling_unit_id_ and it is not possible to pack them (The reservation already are packed based on pre-pack)
      IF (Handling_Unit_API.Get_Shipment_Id(res_handling_unit_id_) = Handling_Unit_API.Get_Shipment_Id(shp_handling_unit_id_)) THEN
         -- Packing reserv hu into shipment hu
         Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_        => res_handling_unit_id_, 
                                                          parent_handling_unit_id_ => shp_handling_unit_id_);

         session_rec_             := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         max_weight_volume_error_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'MAX_WEIGHT_VOLUME_ERROR');
         IF(max_weight_volume_error_ = Fnd_Boolean_API.DB_TRUE) THEN
            Handling_Unit_API.Check_Max_Capacity_Exceeded(handling_unit_id_ => shp_handling_unit_id_);
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Pack_To_Shipment_Handl_Unit___;


PROCEDURE Pick_Hu_By_Choice_And_Pack___ (
   process_message_              IN OUT CLOB,
   contract_                     IN VARCHAR2,
   aggregated_handling_unit_id_  IN NUMBER,
   res_handling_unit_id_         IN NUMBER,
   aggregated_line_id_           IN REPORT_PICK_HANDLING_UNIT.objid%TYPE,   
   pick_list_no_                 IN VARCHAR2,
   ship_location_no_             IN VARCHAR2,
   shp_handling_unit_id_         IN NUMBER, 
   loop_exist_                   IN BOOLEAN,
   trigger_shipment_flow_        IN VARCHAR2 DEFAULT 'TRUE',
   capture_session_id_           IN NUMBER)
IS
   prev_aggregated_line_id_      REPORT_PICK_HANDLING_UNIT.objid%TYPE;
   prev_pick_list_no_            VARCHAR2(15);
   prev_ship_location_no_        VARCHAR2(35);
   prev_aggr_handling_unit_id_   NUMBER;
   pick_clob_attr_               CLOB; 
   header_message_               CLOB;
   res_handl_unit_id_tab_        Handling_Unit_API.Handling_Unit_Id_Tab;
   shp_handl_unit_id_tab_        Handling_Unit_API.Handling_Unit_Id_Tab;
   source_ref_type_db_           VARCHAR2(200);
BEGIN
   header_message_    := Message_SYS.Find_Clob_Attribute(process_message_, 'AGGREGATED_LINE', '');
   IF loop_exist_ THEN 
      IF header_message_ IS NULL THEN 
         Update_Aggregated_Line_Attr___(process_message_, pick_list_no_, aggregated_line_id_, ship_location_no_, aggregated_handling_unit_id_);
      ELSE   
         Get_Aggregated_Line_Attr___(process_message_, prev_pick_list_no_, prev_aggregated_line_id_, prev_ship_location_no_, prev_aggr_handling_unit_id_);
         -- If res_handling_unit_id_ is null it means we are on last round and the method called from post action, so we dont want to do checking here 
         -- instead we want to execute pick by choice method.  
         IF prev_pick_list_no_ = pick_list_no_ AND prev_aggregated_line_id_ = aggregated_line_id_ AND res_handling_unit_id_ IS NOT NULL THEN 
            IF prev_ship_location_no_ != ship_location_no_ THEN 
               Error_SYS.Record_General(lu_name_,'SHIPLOCATIONISDIFF: Only one shipment location number can be used when pick by choice is enabled and you pick several handling units replacing the reserved handling unit using the loop functionality.');
            END IF ;
         ELSE 
            -- get source_ref_type_db, NOTE that this will only work as long as Shipment only have 1 source type, if that changes in the future we need a new solution here
            -- like either send in source_ref_type_db as parameter (but from Post_Process_Action it might be tricky since pick list no is NULL) or include it into 
            -- process_message_ instead
            source_ref_type_db_ := Data_Capture_Shpmnt_Util_API.Get_Unique_Source_Ref_Type_Db(Inventory_Pick_List_API.Get_Shipment_Id(prev_pick_list_no_)); 
            -- Build Pick_Hu_By_Choice clob message
            pick_clob_attr_ := Get_Res_Handling_Unit_Ids___(process_message_);
            Inventory_Picking_Manager_API.Pick_Hu_By_Choice(message_                => pick_clob_attr_,
                                                            contract_               => contract_,
                                                            handling_unit_id_       => prev_aggr_handling_unit_id_,
                                                            pick_list_no_           => prev_pick_list_no_,
                                                            ship_location_no_       => prev_ship_location_no_,
                                                            source_ref_type_db_     => source_ref_type_db_,
                                                            trigger_shipment_flow_  => trigger_shipment_flow_);

            shp_handl_unit_id_tab_ := Get_Shp_Handl_Unit_Id_Tab___(process_message_);
            IF shp_handl_unit_id_tab_.Count > 0 THEN 
               -- Pack to shipment
               res_handl_unit_id_tab_ := Get_Res_Handl_Unit_Id_Tab___(process_message_);
               -- Since we save the Shp_Handling_Unit_Id for each res_handling_unit_id we use same loop counter for both
               FOR i IN shp_handl_unit_id_tab_.FIRST..shp_handl_unit_id_tab_.LAST LOOP
                  -- Packing into shipment hu, If shipment id of both res_handling_unit_id_ and shp_handling_unit_id_ are the same, then we can change parent atherwise 
                  -- the reservations are seperated from res_handling_unit_id_ and it is not possible to pack them (The reservation already are packed based on pre-pack)
                  IF shp_handl_unit_id_tab_(i).handling_unit_id IS NOT NULL THEN
                     Pack_To_Shipment_Handl_Unit___(res_handl_unit_id_tab_(i).handling_unit_id, 
                                                    shp_handl_unit_id_tab_(i).handling_unit_id,
                                                    capture_session_id_ );
                  END IF;
               END LOOP;
            END IF;

            Update_Aggregated_Line_Attr___(process_message_, pick_list_no_, aggregated_line_id_, ship_location_no_, aggregated_handling_unit_id_);
            -- Following methods call resets the sub-message "RES_HANDLING_UNIT_IDS" and "SHP_HANDLING_UNIT_IDS" for new aggregated_line_id_
            Reset_Res_Handl_Unit_Ids___(process_message_);
            Reset_Shp_Handl_Unit_Ids___(process_message_);
         END IF;
      END IF;
      -- Add new res_handling_unit_id to the process_message_
      Update_Res_Handl_Unit_Ids___(process_message_, res_handling_unit_id_);
      -- Add new shp_handling_unit_id to the process_message_ no matter if it is inside the loop along with res_handling_unit_id or outside the res_handling_unit_id loop.
      Update_Shp_Handl_Unit_Ids___(process_message_, shp_handling_unit_id_);
   ELSE
      -- get source_ref_type_db, NOTE that this will only work as long as Shipment only have 1 source type, if that changes in the future we need a new solution here
      -- like either send in source_ref_type_db as parameter (but from Post_Process_Action it might be tricky since pick list no is NULL) or include it into 
      -- process_message_ instead (which might be tricky for below call since we are not working with the process_message_ in this section since there is no loop)
      source_ref_type_db_ := Data_Capture_Shpmnt_Util_API.Get_Unique_Source_Ref_Type_Db(Inventory_Pick_List_API.Get_Shipment_Id(pick_list_no_)); 
      pick_clob_attr_ := Message_SYS.Construct_Clob_Message('INPUT_DATA');
      Message_SYS.Add_Attribute(pick_clob_attr_, 'HANDLING_UNIT_ID' , res_handling_unit_id_); 
      Inventory_Picking_Manager_API.Pick_Hu_By_Choice(message_                => pick_clob_attr_,
                                                      contract_               => contract_,
                                                      handling_unit_id_       => aggregated_handling_unit_id_,
                                                      pick_list_no_           => pick_list_no_,
                                                      ship_location_no_       => ship_location_no_,
                                                      source_ref_type_db_     => source_ref_type_db_,
                                                      trigger_shipment_flow_  => trigger_shipment_flow_);
      -- Pack to shipment, If shipment id of both res_handling_unit_id_ and shp_handling_unit_id_ are the same, then we can change parent atherwise 
      -- the reservations are seperated from res_handling_unit_id_ and it is not possible to pack them (The reservation already are packed based on pre-pack)
      IF shp_handling_unit_id_ IS NOT NULL THEN
         Pack_To_Shipment_Handl_Unit___(res_handling_unit_id_, 
                                        shp_handling_unit_id_,
                                        capture_session_id_ );
      END IF;
   END IF;
END Pick_Hu_By_Choice_And_Pack___;


FUNCTION Get_Pick_By_Choice_Whr_Expr___ ( 
   capture_session_id_        IN NUMBER,
   pick_list_no_              IN VARCHAR2,
   location_no_               IN VARCHAR2,
   handling_unit_id_          IN number,
   sscc_                      IN VARCHAR2,
   aggregated_line_id_        IN VARCHAR2,
   source_ref_type_db_        IN VARCHAR2,
   column_name_               IN VARCHAR2,
   lov_expresion_             IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   reserve_rec_         Handl_Unit_Stock_Snapshot_API.Public_Rec;
   --source_ref_type_db_  VARCHAR2(20) := '1';
   return_value_        VARCHAR2(2000);
   pbc_allowed_params_  VARCHAR2(1000);
   part_no_expr_        VARCHAR2(1000);
   lov_row_limitation_  NUMBER;
   res_part_no_         VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      
      -- If site setting for pick by choice is not allowed for reserved or pick listed stock record we will call method Pick_By_Choice_Allowed
      -- with pick list line keys to include currect pick list line(s) to the list of value or validate them. Pick_Hu_By_Choice_Allowed when site
      -- setting option is allowed or not printed pick list will always return true for current pick list line so no need to send pick list line info.
      IF aggregated_line_id_ IS NOT NULL THEN 
         reserve_rec_ := Handl_Unit_Stock_Snapshot_API.Get_Object_By_Id(aggregated_line_id_);
      END IF;

      pbc_allowed_params_ := '''' || pick_list_no_ || ''',
                              ''' || source_ref_type_db_ || ''', ';
                              
      IF reserve_rec_.handling_unit_id IS NULL THEN 
         pbc_allowed_params_ := pbc_allowed_params_ || ' NULL, ';
      ELSE
         pbc_allowed_params_ := pbc_allowed_params_ ||  reserve_rec_.handling_unit_id  || ', ';
      END IF;

      IF reserve_rec_.handling_unit_id IS NOT NULL THEN
         res_part_no_ := Handling_Unit_API.Get_Part_No(reserve_rec_.handling_unit_id);
         IF res_part_no_ != '...' THEN
            part_no_expr_ := ' AND  Handling_Unit_API.Get_Part_No(HANDLING_UNIT_ID) != ''...''';
            part_no_expr_ := part_no_expr_ || ' AND  Handling_Unit_API.Get_Part_No(HANDLING_UNIT_ID) = ''' || Handling_Unit_API.Get_Part_No(reserve_rec_.handling_unit_id) || '''';
         ELSE    
            part_no_expr_ := part_no_expr_ || ' AND  HANDLING_UNIT_ID = ' || reserve_rec_.handling_unit_id;
         END IF;
      ELSE
         part_no_expr_ := ' AND  Handling_Unit_API.Get_Part_No(HANDLING_UNIT_ID) != ''...''';
      END IF;

      return_value_ := ' AND  contract = ''' || session_rec_.session_contract || '''
                         AND  location_type = ''PICKING''' ||
                         part_no_expr_;
                          
      IF column_name_ NOT IN ('LOCATION_NO') THEN 
         IF location_no_ IS NOT NULL THEN 
            return_value_ := return_value_ || ' AND  location_no = ''' || location_no_ || '''';
         END IF;
         -- To prevent unnecessary check for lov we add following expression only when neither of handling_unit_id nor sscc is already entered.
         -- Also to prevent unnecessary call for Pick_HU_By_Choice_Allowed method, we call the method only if has_stock_reservation be true.
         IF (lov_expresion_ AND handling_unit_id_ IS NULL AND nvl(sscc_,string_all_values_)  = string_all_values_) OR NOT lov_expresion_  THEN 
            -- If pbc_allowed_params_ is not null, Pick_HU_By_Choice_Allowed will return true for current/all pick list line(s) in the current pick list
            -- so they will be included in lov even when pick by choice is not allowed for reserve/pick listed stock 
            return_value_ := return_value_ ||  ' AND  ((has_stock_reservation = ''FALSE'') 
                             OR Inventory_Picking_Manager_API.Pick_HU_By_Choice_Allowed( ' || pbc_allowed_params_ || ' CONTRACT, HANDLING_UNIT_ID) = ''TRUE'')';
            IF lov_expresion_ THEN 
               -- This condition is added to prevent performance issues on list of value for handling unit, sscc and alt handling unit. 
               -- Pick_HU_By_Choice_Allowed is a heavy method tries to check every stock attached to handling units comes from handling_unit_tab in the Inv_Part_Stock_Reservation to validate it.
               lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
               IF (session_rec_.lov_search_statement IS NULL) THEN
                  return_value_ := return_value_ || ' AND (ROWNUM  <= ''' || lov_row_limitation_ || ''' )';
               END IF;
            END IF;
         END IF;
      END IF; 
   $END
   RETURN return_value_;
END Get_Pick_By_Choice_Whr_Expr___;



FUNCTION Clob_Attribute_Exist___ (
  message_        IN OUT CLOB,
  name_           IN     VARCHAR2,
  value_          IN     VARCHAR2 ) RETURN BOOLEAN
IS
  count_           NUMBER;
  name_arr_        Message_SYS.name_table_clob;
  value_arr_       Message_SYS.line_table_clob;
  return_value_    BOOLEAN DEFAULT FALSE;
BEGIN
   IF message_ IS NOT NULL THEN 
      Message_SYS.Get_Clob_Attributes(message_, count_, name_arr_, value_arr_);
      IF (count_ > 0) THEN
         FOR n_ IN 1..count_ LOOP
            IF ((name_arr_(n_) = name_) AND (value_arr_(n_) = value_)) THEN
                 return_value_ := TRUE;
                  Exit; 
            END IF;
         END LOOP;
      END IF;
   END IF;
   return return_value_;
END Clob_Attribute_Exist___;

PROCEDURE Update_Shipment_Ids___ (
   process_message_      IN OUT CLOB,
   shipment_id_          IN VARCHAR2 )
IS
   local_message_ CLOB;
   add_to_list_   BOOLEAN DEFAULT FALSE;
BEGIN
   local_message_    := Get_Shipment_Id_Message___(process_message_);
   IF local_message_ IS NULL THEN
      -- We need to have a separate sub message for SHIPMENTS so we construct a local_message_ and add or update it in process_message_
      local_message_ := Message_SYS.Construct_Clob_Message('SHIPMENTS');
      add_to_list_ := TRUE;
   ELSE
      IF (NOT Clob_Attribute_Exist___(local_message_, 'SHIPMENT_ID', shipment_id_)) THEN
         add_to_list_ := TRUE;         
      END IF;         
   END IF;
   
   IF (add_to_list_) THEN
      Message_SYS.Add_Attribute(local_message_, 'SHIPMENT_ID', shipment_id_);
      Message_SYS.Set_Clob_Attribute(process_message_, 'SHIPMENTS', local_message_);
   END IF;
END Update_Shipment_Ids___;

FUNCTION Get_Shipment_Id_Message___(
   process_message_ IN OUT CLOB ) RETURN CLOB
IS
   local_message_   CLOB;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      local_message_    := Message_SYS.Find_Clob_Attribute(process_message_, 'SHIPMENTS', '');
   END IF;
   RETURN local_message_;
END Get_Shipment_Id_Message___;


PROCEDURE Raise_Shipment_Handling_Error___(
   shp_handling_unit_id_ NUMBER,
   shp_handl_unit_location_no_ VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTSAMELOCATION: Shipment Handling Unit :P1 is already on Shipment Location :P2.', shp_handling_unit_id_, shp_handl_unit_location_no_);
END Raise_Shipment_Handling_Error___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   contract_                    VARCHAR2(5);
   pick_list_no_                VARCHAR2(15);
   aggregated_line_id_          REPORT_PICK_HANDLING_UNIT.objid%TYPE;
   location_no_                 VARCHAR2(35);
   data_item_description_       VARCHAR2(200);
   shp_handling_unit_id_        NUMBER;
   shp_sscc_                    VARCHAR2(18);
   shp_alt_handl_unit_label_id_ VARCHAR2(25);
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   source_ref_type_db_          VARCHAR2(200);
   hu_sql_where_expression_     VARCHAR2(2000);
   dummy_                       BOOLEAN;
   column_name_                 VARCHAR2(30);
   shipment_id_                 NUMBER;
   local_shp_handling_unit_id_  NUMBER;
   local_shp_sscc_              VARCHAR2(18);
   local_alt_hu_label_id_       VARCHAR2(25);
   aggr_res_handling_unit_id_   NUMBER;
   action_                      VARCHAR2(30);
   ship_location_no_            VARCHAR2(35);
   shp_handl_unit_location_no_  VARCHAR2(35);
   shp_handl_unit_contract_     VARCHAR2(5);
   pick_by_choice_option_       VARCHAR2(20);
   reserve_rec_                 Handl_Unit_Stock_Snapshot_API.Public_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ = 'ACTION') THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, mandatory_non_process_key_ => TRUE);
         Pick_Handl_Unit_Action_API.Exist_Db(data_item_value_); 
         session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         IF (data_item_value_ IN (Pick_Handl_Unit_Action_API.DB_PICK_SUB_LEVEL, Pick_Handl_Unit_Action_API.DB_PICK_PARTS) AND 
             Data_Capt_Conf_Data_Item_API.Loop_Exist(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
            Error_SYS.Record_General(lu_name_,'ACTIONANDLOOPNOTALLOWED: This action is not supported together with loop functionality.');
         END IF;
         IF (data_item_value_ = Pick_Handl_Unit_Action_API.DB_PICK_SUB_LEVEL) THEN
            Get_Filter_Keys___(contract_, pick_list_no_, aggregated_line_id_, location_no_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_,
                               shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, source_ref_type_db_, capture_session_id_, data_item_id_, data_item_value_);
            -- Check if the current handling unit is bottom in the structure and have part connected then Pick Sub Level is not allowed
            IF (res_handling_unit_id_ IS NOT NULL AND NOT Handling_Unit_API.Has_Children(res_handling_unit_id_) AND 
               pick_list_no_ IS NOT NULL AND Pick_Shipment_API.Handl_Unit_Exist_On_Pick_List(pick_list_no_,res_handling_unit_id_)) THEN
               Error_SYS.Record_General(lu_name_,'BOTTOMPARTPICKSUBNOTALLOWED: Pick Sub Level is not allowed when you are in bottom of the handling unit structure then you should use Pick Parts instead.');
            END IF;
         END IF;
      ELSE
         Get_Filter_Keys___(contract_, pick_list_no_, aggregated_line_id_, location_no_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_,
                            shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, source_ref_type_db_, capture_session_id_, data_item_id_, data_item_value_);
         pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_);

         -- When pick by choice is enabled, the handling unit id that the user enter might be different from the already reserved one.
         -- The handling unit reserved on the line have to be fetched with aggregated_line_id_ 
         aggr_res_handling_unit_id_ := res_handling_unit_id_;
         IF (pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED OR aggr_res_handling_unit_id_ IS NULL) THEN 
            IF (aggregated_line_id_ IS NOT NULL) THEN
               reserve_rec_ := Handl_Unit_Stock_Snapshot_API.Get_Object_By_Id(aggregated_line_id_);
            END IF;
            aggr_res_handling_unit_id_ := reserve_rec_.handling_unit_id;
         END IF;

         IF (data_item_id_ IN ('PICK_LIST_NO', 'AGGREGATED_LINE_ID', 'LOCATION_NO', 'SOURCE_REF_TYPE')) THEN
            IF (data_item_id_ = 'SOURCE_REF_TYPE') THEN
               column_name_  := 'SOURCE_REF_TYPE_DB';
            ELSE
               column_name_  := data_item_id_;
            END IF;
            data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);


            IF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED OR
                source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN 
               Pick_Shipment_API.Record_With_Column_Value_Exist(contract_                   => contract_,
                                                                pick_list_no_               => pick_list_no_,
                                                                aggregated_line_id_         => aggregated_line_id_,
                                                                location_no_                => location_no_,
                                                                handling_unit_id_           => res_handling_unit_id_,
                                                                sscc_                       => res_sscc_,
                                                                alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                source_ref_type_db_         => source_ref_type_db_,
                                                                column_name_                => column_name_,
                                                                column_value_               => data_item_value_,
                                                                column_description_         => data_item_description_,
                                                                sql_where_expression_       => NULL);

            ELSIF (data_item_id_ = 'LOCATION_NO') THEN
               Handling_Unit_API.Record_With_Column_Value_Exist(record_exists_              => dummy_, 
                                                                handling_unit_id_           => res_handling_unit_id_,
                                                                sscc_                       => res_sscc_,
                                                                alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                column_name_                => column_name_, 
                                                                column_value_               => data_item_value_,
                                                                column_description_         => data_item_description_,
                                                                sql_where_expression_       => Get_Pick_By_Choice_Whr_Expr___(capture_session_id_, 
                                                                                                                              pick_list_no_, 
                                                                                                                              location_no_, 
                                                                                                                              res_handling_unit_id_, 
                                                                                                                              res_sscc_, 
                                                                                                                              aggregated_line_id_, 
                                                                                                                              source_ref_type_db_,
                                                                                                                              column_name_));
            ELSE                                                              
               Pick_Shipment_API.Record_With_Column_Value_Exist(contract_                   => contract_,
                                                                pick_list_no_               => pick_list_no_,
                                                                aggregated_line_id_         => aggregated_line_id_,
                                                                location_no_                => NULL,
                                                                handling_unit_id_           => NULL,
                                                                sscc_                       => string_all_values_,
                                                                alt_handling_unit_label_id_ => string_all_values_,
                                                                source_ref_type_db_         => NULL,
                                                                column_name_                => column_name_,
                                                                column_value_               => data_item_value_,
                                                                column_description_         => data_item_description_,
                                                                sql_where_expression_       => NULL);
            END IF;                                                 
                                                             
--*********------ We might be able to remove some of these checks SHIP_LOCATION_NO after some testing        
         ELSIF (data_item_id_ IN ('SHIP_LOCATION_NO')) THEN 
            action_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'ACTION', data_item_id_);
            IF (action_ = Pick_Handl_Unit_Action_API.DB_PICK) THEN -- no need to do checks if action is not PICK
               IF (data_item_value_ IS NOT NULL) THEN
                  Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_ => capture_session_id_,
                                                                  data_item_id_       => 'LOCATION_NO', -- Use LOCATION_NO to check if location exists at all.
                                                                  data_item_value_    => data_item_value_);
                  IF (Inventory_Location_API.Get_Location_Type_Db(contract_, data_item_value_) != Inventory_Location_Type_API.DB_SHIPMENT) THEN
                     Error_SYS.Record_General(lu_name_,'INVALIDSHIPLOC: Location :P1 is not a shipment location.', data_item_value_);
                  END IF;
               END IF;
            
               IF (data_item_value_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_,'SHIPINVUSED: :P1 is mandatory when shipment inventory is used.', Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_));
               END IF;
            END IF;
            
            IF (data_item_value_ IS NOT NULL AND shp_handling_unit_id_ IS NOT NULL) THEN 
               shp_handl_unit_location_no_ := Handling_Unit_API.Get_Location_No(shp_handling_unit_id_);
               shp_handl_unit_contract_    := Handling_Unit_API.Get_Contract(shp_handling_unit_id_);
               IF ((data_item_value_ IS NOT NULL AND shp_handl_unit_location_no_ IS NOT NULL AND data_item_value_ != shp_handl_unit_location_no_) OR
                   (shp_handl_unit_contract_ IS NOT NULL AND contract_ != shp_handl_unit_contract_)) THEN
                   Raise_Shipment_Handling_Error___(shp_handling_unit_id_, shp_handl_unit_location_no_);
               END IF;
            END IF;
         ELSIF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            IF (data_item_value_ IS NOT NULL) THEN
               IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
                  Handling_Unit_API.Exist(data_item_value_);
               END IF;
               local_shp_handling_unit_id_ := shp_handling_unit_id_;
               local_shp_sscc_             := shp_sscc_;
               local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
               Get_Handling_Unit_Filters___(shp_handling_unit_id_        => local_shp_handling_unit_id_,
                                            shp_sscc_                    => local_shp_sscc_,
                                            shp_alt_handl_unit_label_id_ => local_alt_hu_label_id_,
                                            shipment_id_                 => shipment_id_,
                                            sql_where_expression_        => hu_sql_where_expression_,
                                            pick_list_no_                => pick_list_no_,
                                            res_handling_unit_id_        => aggr_res_handling_unit_id_,
                                            capture_session_id_          => capture_session_id_,
                                            data_item_id_                => data_item_id_);

               IF ((shipment_id_ IS NULL OR shipment_id_ = 0) AND pick_list_no_ IS NOT NULL AND aggr_res_handling_unit_id_ IS NOT NULL) THEN
                  Error_SYS.Record_General(lu_name_,'NOSHIPHU: :P1 cannot be used here since no unique shipment exist for current handling unit structure.', 
                                           Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_));
               END IF;
               
               IF ((shipment_id_ IS NOT NULL OR shipment_id_ != 0) AND aggr_res_handling_unit_id_ IS NOT NULL) THEN
                  IF Shipment_Reserv_Handl_Unit_API.Has_Qty_Attached_To_Shipment(aggr_res_handling_unit_id_, shipment_id_) = Fnd_Boolean_API.DB_TRUE THEN 
                     Error_SYS.Record_General(lu_name_,'PREATTACHEDEXIST: :P1 must be empty since handling unit :P2 has quantity pre attached to shipment.', 
                                              Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_), aggr_res_handling_unit_id_);
                  END IF;
               END IF;
               ship_location_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                      data_item_id_a_     => 'SHIP_LOCATION_NO',
                                                                                      data_item_id_b_     => data_item_id_);

               IF (ship_location_no_ IS NOT NULL AND shp_handling_unit_id_ IS NOT NULL) THEN 
                  shp_handl_unit_location_no_ := Handling_Unit_API.Get_Location_No(shp_handling_unit_id_);
                  shp_handl_unit_contract_    := Handling_Unit_API.Get_Contract(shp_handling_unit_id_);
                  IF ((ship_location_no_ IS NOT NULL AND shp_handl_unit_location_no_ IS NOT NULL AND ship_location_no_ != shp_handl_unit_location_no_) OR
                      (shp_handl_unit_contract_ IS NOT NULL AND contract_ != shp_handl_unit_contract_)) THEN
                      Raise_Shipment_Handling_Error___(shp_handling_unit_id_, shp_handl_unit_location_no_);
                  END IF;
               END IF;
               
               IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
                  column_name_ := 'HANDLING_UNIT_ID';
               ELSIF (data_item_id_ = 'SHP_SSCC') THEN
                  column_name_ := 'SSCC';
               ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
                  column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
               ELSE
                  column_name_ := data_item_id_;
               END IF;

               data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
               Handling_Unit_API.Record_With_Column_Value_Exist(record_exists_              => dummy_,
                                                                handling_unit_id_           => shp_handling_unit_id_,
                                                                shipment_id_                => shipment_id_,  
                                                                sscc_                       => local_shp_sscc_,
                                                                alt_handling_unit_label_id_ => local_alt_hu_label_id_,
                                                                column_name_                => column_name_,
                                                                column_value_               => data_item_value_,
                                                                column_description_         => data_item_description_,
                                                                source_ref1_                => NULL,
                                                                source_ref2_                => NULL,
                                                                source_ref3_                => NULL,
                                                                source_ref_type_db_         => NULL,
                                                                sql_where_expression_       => hu_sql_where_expression_);
            END IF;
         ELSIF (data_item_id_ IN ('RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            IF (data_item_id_ = 'RES_HANDLING_UNIT_ID' AND data_item_value_ != 0 AND data_item_value_ IS NOT NULL) THEN
               Handling_Unit_API.Exist(data_item_value_);
            END IF;
            IF (data_item_id_ = 'RES_HANDLING_UNIT_ID') THEN
               column_name_ := 'HANDLING_UNIT_ID';
            ELSIF (data_item_id_ = 'RES_SSCC') THEN
               column_name_ := 'SSCC';
            ELSIF (data_item_id_ = 'RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
               column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);           
            IF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED OR
                source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN 
               Pick_Shipment_API.Record_With_Column_Value_Exist(contract_                   => contract_,
                                                                      pick_list_no_               => pick_list_no_,
                                                                      aggregated_line_id_         => aggregated_line_id_,
                                                                      location_no_                => location_no_,
                                                                      handling_unit_id_           => res_handling_unit_id_,
                                                                      sscc_                       => res_sscc_,
                                                                      alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                      source_ref_type_db_         => source_ref_type_db_,
                                                                      column_name_                => column_name_,
                                                                      column_value_               => data_item_value_,
                                                                      column_description_         => data_item_description_,
                                                                      sql_where_expression_       => NULL);
            ELSE
               IF (data_item_id_ = 'RES_HANDLING_UNIT_ID' AND data_item_value_ != aggr_res_handling_unit_id_) THEN
                  IF (Inv_Part_Stock_Reservation_API.Get_Pick_By_Choice_Blocked_Db(aggr_res_handling_unit_id_) = Fnd_Boolean_API.DB_TRUE) THEN
                     Error_SYS.Record_General(lu_name_, 'PICKBYCHOICEBLOCKED: Not allowed to pick another stock record than the one already reserved. The pick list line is blocked for pick by choice.');
                  END IF;
               END IF;
               
               Handling_Unit_API.Record_With_Column_Value_Exist(record_exists_              => dummy_, 
                                                                handling_unit_id_           => res_handling_unit_id_,
                                                                sscc_                       => res_sscc_,
                                                                alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                column_name_                => column_name_, 
                                                                column_value_               => data_item_value_,
                                                                column_description_         => data_item_description_,
                                                                sql_where_expression_       => Get_Pick_By_Choice_Whr_Expr___(capture_session_id_, 
                                                                                                                              pick_list_no_, 
                                                                                                                              location_no_, 
                                                                                                                              res_handling_unit_id_, 
                                                                                                                              res_sscc_, 
                                                                                                                              aggregated_line_id_, 
                                                                                                                              source_ref_type_db_,
                                                                                                                              column_name_));
            END IF;
         ELSIF(data_item_id_ LIKE 'GS1%') THEN
            Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
         END IF;
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
   dummy_                       VARCHAR2(5);
   pick_list_no_                VARCHAR2(15);
   aggregated_line_id_          REPORT_PICK_HANDLING_UNIT.objid%TYPE;
   location_no_                 VARCHAR2(35);
   shp_handling_unit_id_        NUMBER;
   shp_sscc_                    VARCHAR2(18);
   shp_alt_handl_unit_label_id_ VARCHAR2(25);
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   hu_sql_where_expression_     VARCHAR2(2000);
   column_name_                 VARCHAR2(30);
   shipment_id_                 NUMBER;
   local_shp_handling_unit_id_  NUMBER;
   local_shp_sscc_              VARCHAR2(18);
   local_alt_hu_label_id_       VARCHAR2(25);
   aggr_res_handling_unit_id_   NUMBER;
   source_ref_type_db_          VARCHAR2(200);
   lov_type_db_                 VARCHAR2(20);
   pick_list_sql_where_expr_    VARCHAR2(2000);
   pick_by_choice_option_       VARCHAR2(20);
   reserve_rec_                 Handl_Unit_Stock_Snapshot_API.Public_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_);
      IF (data_item_id_ = 'SHIP_LOCATION_NO') THEN
         Inventory_Location_API.Create_Data_Capture_Lov(contract_, capture_session_id_, 4);
      ELSIF (data_item_id_ IN ('ACTION')) THEN
         Pick_Handl_Unit_Action_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSE
         Get_Filter_Keys___(dummy_, pick_list_no_, aggregated_line_id_, location_no_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_,
                            shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_,source_ref_type_db_ ,capture_session_id_, data_item_id_);

         lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);

         -- When pick by choice is enabled, the handling that user enter might be differnet from the already reserved one.
         -- The handling unit reserved on the line have to be fetched with aggregated_line_id_ 
         aggr_res_handling_unit_id_ := res_handling_unit_id_;
         IF pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED  THEN 
            IF aggregated_line_id_ IS NOT NULL THEN
               reserve_rec_ := Handl_Unit_Stock_Snapshot_API.Get_Object_By_Id(aggregated_line_id_);
            END IF;
            aggr_res_handling_unit_id_ := reserve_rec_.handling_unit_id;
         END IF;


         IF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            local_shp_handling_unit_id_ := shp_handling_unit_id_;
            local_shp_sscc_             := shp_sscc_;
            local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
            Get_Handling_Unit_Filters___(shp_handling_unit_id_        => local_shp_handling_unit_id_,
                                         shp_sscc_                    => local_shp_sscc_,
                                         shp_alt_handl_unit_label_id_ => local_alt_hu_label_id_,
                                         shipment_id_                 => shipment_id_,
                                         sql_where_expression_        => hu_sql_where_expression_,
                                         pick_list_no_                => pick_list_no_,
                                         res_handling_unit_id_        => aggr_res_handling_unit_id_,
                                         capture_session_id_          => capture_session_id_,
                                         data_item_id_                => data_item_id_);
            IF (shipment_id_ IS NOT NULL AND shipment_id_ != 0) THEN   -- Only create hu ship lov if we have a unique shipment that is not 0 or we dont know yet 
               -- if there is a shipment connected (since we dont have scanned pick_list_no_ or res_handling_unit_id_ yet)
               IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
                  column_name_ := 'HANDLING_UNIT_ID';
               ELSIF (data_item_id_ = 'SHP_SSCC') THEN
                  column_name_ := 'SSCC';
               ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
                  column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
               ELSE
                  column_name_ := data_item_id_;
               END IF;
               Handling_Unit_API.Create_Data_Capture_Lov(handling_unit_id_           => shp_handling_unit_id_,
                                                         shipment_id_                => shipment_id_,  
                                                         sscc_                       => local_shp_sscc_,
                                                         alt_handling_unit_label_id_ => local_alt_hu_label_id_,
                                                         capture_session_id_         => capture_session_id_,
                                                         column_name_                => column_name_,
                                                         source_ref1_                => NULL,
                                                         source_ref2_                => NULL,
                                                         source_ref3_                => NULL,
                                                         source_ref_type_db_         => NULL,
                                                         lov_type_db_                => lov_type_db_,
                                                         sql_where_expression_       => hu_sql_where_expression_);
            ELSE
               NULL;  -- No LOV will be created if no unique shipment can be found or if its 0 for this pick_list_no_/res_handling_unit_id_ kombo, they should not use shipment hu then
            END IF;

         ELSIF (data_item_id_ = 'PICK_LIST_NO' AND aggregated_line_id_ IS NULL AND location_no_ IS NULL AND res_handling_unit_id_ IS NULL AND shp_handling_unit_id_ IS NULL) THEN   
            -- We need to filter out pick lists where no handling units are left to pick
            pick_list_sql_where_expr_ := ' AND EXISTS (SELECT 1 from Report_Pick_Handling_Unit
                                                       WHERE contract = prpl.contract
                                                       AND pick_list_no = prpl.pick_list_no
                                                       AND handling_unit_id IS NOT NULL  
                                                       AND process_control IS NULL -- filter out pick_parts and pick_sub_level lines
                                                       AND Pick_Shipment_API.Is_Fully_Picked(pick_list_no, handling_unit_id, location_no) = ''FALSE'') ';
            Pick_Shipment_API.Create_Data_Capture_Lov(contract_             => contract_, 
                                                      capture_session_id_   => capture_session_id_,
                                                      lov_type_db_          => lov_type_db_,
                                                      sql_where_expression_ => pick_list_sql_where_expr_);
         ELSE
            IF (data_item_id_ = 'RES_HANDLING_UNIT_ID') THEN
               column_name_ := 'HANDLING_UNIT_ID';
            ELSIF (data_item_id_ = 'RES_SSCC') THEN
               column_name_ := 'SSCC';
            ELSIF (data_item_id_ = 'RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
               column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            -- If shipment handling unit have been identified early in the process we can use that to filter whick pick lists/lines should be possible to choose depending on shipment
--            IF  (shp_handling_unit_id_ IS NOT NULL and pick_list_no_ IS NULL AND aggregated_line_id_ IS NULL AND location_no_ IS NULL AND res_handling_unit_id_ IS NULL) THEN
--               shipment_id_ := Handling_Unit_API.Get_Shipment_Id(shp_handling_unit_id_);
--               -------------------Should talk and ask-----------------
--               IF (shipment_id_ IS NOT NULL) THEN
--                  pick_list_sql_where_expr_ := ' AND ' || shipment_id_ || ' IN (SELECT TO_NUMBER(xt.column_value) FROM XMLTABLE(REPLACE(RTRIM(NVL(Customer_Order_Pick_List_API.Get_Shipments_Consolidated(pick_list_no),''0''), ''^''), ''^'', '','')) xt) ';
--                  -- NOTE: this xmltable solution is borrowed from CreatePickList.plsql and CustOrdConsolPickList.rdf
--               END IF;
--            END IF;

            IF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED OR
                source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN 
               Pick_Shipment_API.Create_Data_Capture_Lov(contract_                   => contract_, 
                                                         pick_list_no_               => pick_list_no_,
                                                         aggregated_line_id_         => aggregated_line_id_,
                                                         location_no_                => location_no_,
                                                         handling_unit_id_           => res_handling_unit_id_,
                                                         sscc_                       => res_sscc_,
                                                         alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_, 
                                                         source_ref_type_db_         => source_ref_type_db_,
                                                         capture_session_id_         => capture_session_id_,
                                                         column_name_                => column_name_,
                                                         lov_type_db_                => lov_type_db_,
                                                         sql_where_expression_       => pick_list_sql_where_expr_);

            ELSIF (data_item_id_ IN ('LOCATION_NO', 'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID')) THEN 
               Handling_Unit_API.Create_Data_Capture_Lov(handling_unit_id_             => res_handling_unit_id_, 
                                                         sscc_                         => res_sscc_,
                                                         alt_handling_unit_label_id_   => res_alt_handl_unit_label_id_, 
                                                         capture_session_id_           => capture_session_id_, 
                                                         column_name_                  => column_name_,
                                                         lov_type_db_                  => lov_type_db_,     
                                                         sql_where_expression_         => Get_Pick_By_Choice_Whr_Expr___(capture_session_id_, 
                                                                                                                         pick_list_no_, 
                                                                                                                         location_no_, 
                                                                                                                         res_handling_unit_id_,
                                                                                                                         res_sscc_, 
                                                                                                                         aggregated_line_id_, 
                                                                                                                         source_ref_type_db_,
                                                                                                                         column_name_, 
                                                                                                                         TRUE)); 

            ELSE 
               Pick_Shipment_API.Create_Data_Capture_Lov(contract_                   => contract_, 
                                                         pick_list_no_               => pick_list_no_,
                                                         aggregated_line_id_         => aggregated_line_id_,
                                                         location_no_                => NULL,
                                                         handling_unit_id_           => NULL,
                                                         sscc_                       => string_all_values_,
                                                         alt_handling_unit_label_id_ => string_all_values_, 
                                                         source_ref_type_db_         => NULL,
                                                         capture_session_id_         => capture_session_id_,
                                                         column_name_                => column_name_,
                                                         lov_type_db_                => lov_type_db_,
                                                         sql_where_expression_       => pick_list_sql_where_expr_);
            END IF;            
         END IF;
      END IF;
   $ELSE
      NULL;       
   $END
END Create_List_Of_Values;


FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_                    VARCHAR2(5);
   pick_list_no_                VARCHAR2(15);
   aggregated_line_id_          REPORT_PICK_HANDLING_UNIT.objid%TYPE;
   location_no_                 VARCHAR2(35);
   shp_handling_unit_id_        NUMBER;
   shp_sscc_                    VARCHAR2(18);
   shp_alt_handl_unit_label_id_ VARCHAR2(25);
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   source_ref_type_db_          VARCHAR2(200);
   automatic_value_             VARCHAR2(200);
   warehouse_task_id_           NUMBER;
   hu_sql_where_expression_     VARCHAR2(2000);
   aggr_res_handling_unit_id_   NUMBER;
   dummy_                       BOOLEAN;
   column_name_                 VARCHAR2(30);
   shipment_id_                 NUMBER;
   local_shp_handling_unit_id_  NUMBER;
   local_shp_sscc_              VARCHAR2(18);
   local_alt_hu_label_id_       VARCHAR2(25);
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   reserve_rec_                 Handl_Unit_Stock_Snapshot_API.Public_Rec;
   pick_by_choice_option_       VARCHAR2(20);

BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN 
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- Try and get value from any previously scanned GS1 barcode if this data item have AI code connected to them. Also reducing the value to lengths we have on the IFS objects
      automatic_value_ := SUBSTR(Data_Capture_Session_API.Get_Item_Value_From_Gs1_Items(capture_session_id_ => capture_session_id_,
                                                                                        capture_process_id_ => session_rec_.capture_process_id,
                                                                                        capture_config_id_  => session_rec_.capture_config_id,
                                                                                        data_item_id_       => data_item_id_), 1, 
                                 NVL(Data_Capt_Proc_Data_Item_API.Get_String_Length(session_rec_.capture_process_id, data_item_id_), 200));

      IF (automatic_value_ IS NULL) THEN

         Get_Filter_Keys___(contract_, pick_list_no_, aggregated_line_id_, location_no_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_,
                            shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, source_ref_type_db_, capture_session_id_, data_item_id_);
   
         pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_);
         -- When pick by choice is enabled, the handling unit that user enter might be differnet from the already reserved one.
         -- The handling unit reserved on the line have to be fetched with aggregated_line_id_ 
         aggr_res_handling_unit_id_ := res_handling_unit_id_;
         IF pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED  THEN 
            IF aggregated_line_id_ IS NOT NULL THEN
               reserve_rec_ := Handl_Unit_Stock_Snapshot_API.Get_Object_By_Id(aggregated_line_id_);
            END IF;
            aggr_res_handling_unit_id_ := reserve_rec_.handling_unit_id;
         END IF;

         IF (data_item_id_ = 'PICK_LIST_NO') THEN
            warehouse_task_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                    data_item_id_a_     => 'WAREHOUSE_TASK_ID',
                                                                                    data_item_id_b_     => data_item_id_);
            IF (warehouse_task_id_ IS NOT NULL) THEN
               automatic_value_ := Warehouse_Task_API.Get_Source_Ref1(warehouse_task_id_);
            ELSE
               automatic_value_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, aggregated_line_id_, location_no_,
                                                                 res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, source_ref_type_db_, data_item_id_);
            END IF;
         ELSIF (data_item_id_ IN ('AGGREGATED_LINE_ID', 'LOCATION_NO', 'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID', 'SOURCE_REF_TYPE')) THEN
   
            automatic_value_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, aggregated_line_id_, location_no_,
                                                              res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, source_ref_type_db_, data_item_id_);
   
         ELSIF data_item_id_ = 'SHIP_LOCATION_NO' THEN
            -- Try and find unique order_no/shipment_id for HU structure for use in finding automatic ship location
            shipment_id_ := Pick_Shipment_API.Get_Shipment_Id(pick_list_no_, Pick_Shipment_API.Get_Pick_List_Type(pick_list_no_));
            automatic_value_ := Get_Ship_Location_No___(shipment_id_, contract_);
            
         ELSIF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            local_shp_handling_unit_id_ := shp_handling_unit_id_;
            local_shp_sscc_             := shp_sscc_;
            local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
            Get_Handling_Unit_Filters___(shp_handling_unit_id_        => local_shp_handling_unit_id_,
                                         shp_sscc_                    => local_shp_sscc_,
                                         shp_alt_handl_unit_label_id_ => local_alt_hu_label_id_,
                                         shipment_id_                 => shipment_id_,
                                         sql_where_expression_        => hu_sql_where_expression_,
                                         pick_list_no_                => pick_list_no_,
                                         res_handling_unit_id_        => aggr_res_handling_unit_id_,
                                         capture_session_id_          => capture_session_id_,
                                         data_item_id_                => data_item_id_);
            IF (Skip_Handling_Unit___(capture_session_id_, data_item_id_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_)) THEN
               automatic_value_ := 'NULL';
            ELSIF ((shipment_id_ IS NULL OR shipment_id_ = 0) AND pick_list_no_ IS NOT NULL AND res_handling_unit_id_ IS NOT NULL) THEN
               automatic_value_ := 'NULL';  -- no unique shipment or its 0 found for current reserve handling unit so to point in fetching shipment handling unit
            ELSE
               IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
                  column_name_ := 'HANDLING_UNIT_ID';
               ELSIF (data_item_id_ = 'SHP_SSCC') THEN
                  column_name_ := 'SSCC';
               ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
                  column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
               ELSE
                  column_name_ := data_item_id_;
               END IF;
               automatic_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                handling_unit_id_           => shp_handling_unit_id_,
                                                                                shipment_id_                => shipment_id_,
                                                                                sscc_                       => local_shp_sscc_,
                                                                                alt_handling_unit_label_id_ => local_alt_hu_label_id_,
                                                                                column_name_                => column_name_,
                                                                                source_ref1_                => NULL,
                                                                                source_ref2_                => NULL,
                                                                                source_ref3_                => NULL,
                                                                                source_ref_type_db_         => NULL,
                                                                                sql_where_expression_       => NULL );--hu_sql_where_expression_);
            END IF;
         END IF;

      END IF;
      RETURN automatic_value_;
   $ELSE
      RETURN NULL;
   $END
END Get_Automatic_Data_Item_Value;



PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_          Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                      VARCHAR2(5);
   pick_list_no_                  VARCHAR2(15);
   aggregated_line_id_            REPORT_PICK_HANDLING_UNIT.objid%TYPE;
   location_no_                   VARCHAR2(35);
   shp_handling_unit_id_          NUMBER;
   shp_sscc_                      VARCHAR2(18);
   shp_alt_handl_unit_label_id_   VARCHAR2(25);
   res_handling_unit_id_          NUMBER;
   res_sscc_                      VARCHAR2(18);
   res_alt_handl_unit_label_id_   VARCHAR2(25);
   part_no_                       VARCHAR2(25);
   condition_code_                VARCHAR2(10);
   activity_seq_                  NUMBER;
   source_ref_type_db_            VARCHAR2(200);
   last_line_on_pick_list_        VARCHAR2(5) := Gen_Yes_No_API.DB_NO;
   no_unique_value_found_         BOOLEAN; 
   mixed_item_value_              VARCHAR2(25) := Language_SYS.Translate_Constant(lu_name_,'MIXEDITEM: Mixed');
   action_                        VARCHAR2(30);
   local_res_handling_unit_id_    NUMBER;
   ship_location_no_              VARCHAR2(35);
   shipment_id_                   NUMBER;
   pick_by_choice_allowed_        BOOLEAN;
   reserve_rec_                   Handl_Unit_Stock_Snapshot_API.Public_Rec;
   pick_by_choice_details_        VARCHAR2(5);
   use_unique_values_             BOOLEAN := TRUE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      pick_by_choice_allowed_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(session_rec_.session_contract) != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED;
      pick_by_choice_details_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PICK_BY_CHOICE_DETAILS');
      IF (pick_by_choice_allowed_ AND pick_by_choice_details_ = Fnd_Boolean_API.DB_TRUE) THEN
         -- Turning off use unique values for performance reasons.
         use_unique_values_ := FALSE;
      END IF;

      Get_Filter_Keys___(contract_, pick_list_no_, aggregated_line_id_, location_no_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_,
                         shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, source_ref_type_db_, capture_session_id_, 
                         latest_data_item_id_, latest_data_item_value_, use_unique_values_);

      IF pick_by_choice_allowed_ AND aggregated_line_id_ IS NOT NULL THEN
         reserve_rec_ := Handl_Unit_Stock_Snapshot_API.Get_Object_By_Id(aggregated_line_id_);
      END IF;
      IF (pick_by_choice_allowed_ AND source_ref_type_db_ IS NOT NULL AND source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) OR
         (pick_by_choice_allowed_ AND reserve_rec_.source_ref_type IS NOT NULL AND reserve_rec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
         pick_by_choice_allowed_ := FALSE; -- Turn off PBC when its supplier returns
         IF (pick_by_choice_details_ = Fnd_Boolean_API.DB_TRUE) THEN
            use_unique_values_ := TRUE;
            -- We are forced to re-fetch all filter items with use_unique_values_ on since this will be handled as not PBC enabled
            -- Its not ideal but since we couldn't find out the source type until after the first filter key call this is the best we can do
            Get_Filter_Keys___(contract_, pick_list_no_, aggregated_line_id_, location_no_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_,
                               shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, source_ref_type_db_, capture_session_id_, 
                               latest_data_item_id_, latest_data_item_value_, use_unique_values_);
         END IF;
      END IF;


      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
   
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
   
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('PICK_LIST_NO', 'AGGREGATED_LINE_ID', 'LOCATION_NO',  
                                                                    'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID',
                                                                    'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID', 'SOURCE_REF_TYPE')) THEN 

                  IF pick_by_choice_allowed_ AND aggregated_line_id_ IS NOT NULL THEN 
                     -- Data Items that are part of the filter keys
                     Add_Filter_Key_Detail___(capture_session_id_          => capture_session_id_,
                                              owning_data_item_id_         => latest_data_item_id_,
                                              data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                              pick_list_no_                => pick_list_no_,
                                              aggregated_line_id_          => aggregated_line_id_,
                                              location_no_                 => nvl(location_no_, reserve_rec_.location_no),
                                              res_handling_unit_id_        => nvl(res_handling_unit_id_, reserve_rec_.handling_unit_id),
                                              res_sscc_                    => nvl(NULLIF(res_sscc_, string_all_values_), Handling_Unit_API.Get_Sscc(reserve_rec_.handling_unit_id)),
                                              res_alt_handl_unit_label_id_ => nvl(NULLIF(res_alt_handl_unit_label_id_, string_all_values_), Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(reserve_rec_.handling_unit_id)),
                                              shp_handling_unit_id_        => shp_handling_unit_id_,
                                              shp_sscc_                    => shp_sscc_,
                                              shp_alt_handl_unit_label_id_ => shp_alt_handl_unit_label_id_,
                                              source_ref_type_db_          => nvl(source_ref_type_db_, reserve_rec_.source_ref_type));
                  ELSE
                     -- Data Items that are part of the filter keys
                     Add_Filter_Key_Detail___(capture_session_id_          => capture_session_id_,
                                              owning_data_item_id_         => latest_data_item_id_,
                                              data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                              pick_list_no_                => pick_list_no_,
                                              aggregated_line_id_          => aggregated_line_id_,
                                              location_no_                 => location_no_,
                                              res_handling_unit_id_        => res_handling_unit_id_,
                                              res_sscc_                    => NULLIF(res_sscc_, string_all_values_),
                                              res_alt_handl_unit_label_id_ => NULLIF(res_alt_handl_unit_label_id_, string_all_values_),
                                              shp_handling_unit_id_        => shp_handling_unit_id_,
                                              shp_sscc_                    => shp_sscc_,
                                              shp_alt_handl_unit_label_id_ => shp_alt_handl_unit_label_id_,
                                              source_ref_type_db_          => source_ref_type_db_);

                  END IF;
                  
               ELSE
                  IF pick_by_choice_allowed_ AND aggregated_line_id_ IS NOT NULL THEN 
                     local_res_handling_unit_id_ := reserve_rec_.handling_unit_id;
                  ELSE
                     local_res_handling_unit_id_ := res_handling_unit_id_;
                  END IF;
                  -- Data Items that are not part of the filter keys
                  Add_Unique_Data_Item_Detail___(capture_session_id_          => capture_session_id_,
                                              session_rec_                 => session_rec_,
                                              owning_data_item_id_         => latest_data_item_id_,
                                              owning_data_item_value_      => latest_data_item_value_,
                                              data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                              contract_                    => contract_,
                                              pick_list_no_                => pick_list_no_,
                                              res_handling_unit_id_        => local_res_handling_unit_id_);
               END IF;
            ELSE  -- FEEDBACK ITEMS AS DETAILS

               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('RES_TOP_PARENT_HANDLING_UNIT_TYPE_ID', 'RES_TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                                    'RES_HANDLING_UNIT_TYPE_CATEG_ID', 'RES_HANDLING_UNIT_TYPE_CATEG_DESC',
                                                                    'RES_HANDLING_UNIT_TYPE_ID', 'RES_HANDLING_UNIT_TYPE_DESC')) THEN

                  -- Feedback items related to handling unit type
                  IF pick_by_choice_allowed_ AND aggregated_line_id_ IS NOT NULL AND res_handling_unit_id_ IS NULL THEN 
                     Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                                 owning_data_item_id_ => latest_data_item_id_,
                                                                                 data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                                 handling_unit_id_    => reserve_rec_.handling_unit_id);
                  ELSE
                     Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                                 owning_data_item_id_ => latest_data_item_id_,
                                                                                 data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                                 handling_unit_id_    => res_handling_unit_id_);
                  END IF;
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('RES_HANDLING_UNIT_WAREHOUSE_ID', 'RES_HANDLING_UNIT_BAY_ID', 'RES_HANDLING_UNIT_TIER_ID', 
                                                                       'RES_HANDLING_UNIT_ROW_ID', 'RES_HANDLING_UNIT_BIN_ID', 'RES_HANDLING_UNIT_LOCATION_TYPE', 
                                                                       'RES_HANDLING_UNIT_LOCATION_NO_DESC', 'RES_HANDLING_UNIT_COMPOSITION', 'RES_HANDLING_UNIT_STRUCTURE_LEVEL',
                                                                       'RES_TOP_PARENT_HANDLING_UNIT_ID', 'RES_TOP_PARENT_SSCC', 'RES_TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                                       'RES_LEVEL_2_HANDLING_UNIT_ID', 'RES_LEVEL_2_SSCC', 'RES_LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                                       'RES_HANDLING_UNIT_DEPTH', 'RES_HANDLING_UNIT_HEIGHT', 'RES_HANDLING_UNIT_NET_WEIGHT',
                                                                       'RES_HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT', 'RES_HANDLING_UNIT_OPERATIVE_VOLUME',
                                                                       'RES_HANDLING_UNIT_TARE_WEIGHT', 'RES_HANDLING_UNIT_UOM_LENGTH', 'RES_HANDLING_UNIT_UOM_WEIGHT',
                                                                       'RES_HANDLING_UNIT_UOM_VOLUME', 'RES_HANDLING_UNIT_WIDTH')) THEN
                  -- Feedback items related to handling unit
                  IF pick_by_choice_allowed_ AND aggregated_line_id_ IS NOT NULL AND res_handling_unit_id_ IS NULL THEN 
                     Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                                owning_data_item_id_  => latest_data_item_id_,
                                                                                data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                                handling_unit_id_     => reserve_rec_.handling_unit_id);
                  ELSE
                     Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                                owning_data_item_id_  => latest_data_item_id_,
                                                                                data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                                handling_unit_id_     => res_handling_unit_id_);
                  END IF;

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHP_HANDLING_UNIT_TYPE_ID', 'SHP_HANDLING_UNIT_TYPE_DESC', 'SHP_HANDLING_UNIT_TYPE_CATEG_ID',
                                                                       'SHP_HANDLING_UNIT_TYPE_CATEG_DESC', 'SHP_HANDLING_UNIT_TYPE_VOLUME', 'SHP_HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                                       'SHP_HANDLING_UNIT_TYPE_TARE_WEIGHT', 'SHP_HANDLING_UNIT_TYPE_UOM_WEIGHT', 'SHP_HANDLING_UNIT_TYPE_UOM_LENGTH',
                                                                       'SHP_HANDLING_UNIT_TYPE_ADD_VOLUME', 'SHP_HANDLING_UNIT_TYPE_MAX_VOL_CAP', 'SHP_HANDLING_UNIT_TYPE_MAX_WGT_CAP', 
                                                                       'SHP_HANDLING_UNIT_TYPE_STACKABLE', 'SHP_HANDLING_UNIT_TYPE_GEN_SSCC', 'SHP_HANDLING_UNIT_TYPE_PRINT_LBL', 
                                                                       'SHP_HANDLING_UNIT_TYPE_NO_OF_LBLS', 'SHP_PARENT_HANDLING_UNIT_DESC')) THEN
                  -- Feedback items related to shipment handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                              owning_data_item_id_ => latest_data_item_id_,
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_id_    => shp_handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHP_HANDLING_UNIT_WIDTH', 'SHP_HANDLING_UNIT_HEIGHT', 'SHP_HANDLING_UNIT_DEPTH', 'SHP_HANDLING_UNIT_UOM_LENGTH', 
                                                                       'SHP_PARENT_HANDLING_UNIT_ID', 'SHP_HANDLING_UNIT_MANUAL_GROSS_WEIGHT', 'SHP_HANDLING_UNIT_MANUAL_VOLUME')) THEN
                  -- Feedback items related to shipment handling unit
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                             owning_data_item_id_  => latest_data_item_id_,
                                                                             data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_     => shp_handling_unit_id_);

               -- ELSIFs below are all summarized/group details for the current handling unit and its structure, so they might not have a unique value if they are different
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('ACTIVITY_SEQ', 'AVAILABILITY_CONTROL_ID', 'AVAILABILITY_CONTROL_DESCRIPTION',
                                                                       'CONDITION_CODE', 'CONFIGURATION_ID', 'ENG_CHG_LEVEL', 'LOT_BATCH_NO',
                                                                       'OWNERSHIP', 'OWNER', 'OWNER_NAME', 'PART_NO', 'SERIAL_NO', 'WAIV_DEV_REJ_NO')) THEN

                  -- TODO: add UNIT_MEAS functionality in Data_Capture_Invent_Util_API.Add_Detail_For_Hand_Unit_Stock        

                  IF pick_by_choice_allowed_ AND aggregated_line_id_ IS NOT NULL AND res_handling_unit_id_ IS NULL THEN 
                     Data_Capture_Invent_Util_API.Add_Detail_For_Hand_Unit_Stock(capture_session_id_   => capture_session_id_,
                                                                                 owning_data_item_id_  => latest_data_item_id_,
                                                                                 data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                                 contract_             => contract_,
                                                                                 location_no_          => reserve_rec_.location_no,
                                                                                 handling_unit_id_     => reserve_rec_.handling_unit_id);
                  ELSE
                     Data_Capture_Invent_Util_API.Add_Detail_For_Hand_Unit_Stock(capture_session_id_   => capture_session_id_,
                                                                                 owning_data_item_id_  => latest_data_item_id_,
                                                                                 data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                                 contract_             => contract_,
                                                                                 location_no_          => location_no_,
                                                                                 handling_unit_id_     => res_handling_unit_id_);
                  END IF;                                                                       

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('CONDITION_CODE_DESCRIPTION')) THEN
                  IF pick_by_choice_allowed_ AND aggregated_line_id_ IS NOT NULL AND res_handling_unit_id_ IS NULL THEN 
                     condition_code_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_,
                                                                                         reserve_rec_.handling_unit_id,
                                                                                         'CONDITION_CODE');
                  ELSE
                     condition_code_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_,
                                                                                      res_handling_unit_id_,
                                                                                      'CONDITION_CODE');
                  END IF;
                  IF (no_unique_value_found_ = FALSE AND condition_code_ IS NULL) THEN
                     Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                       data_item_id_        => latest_data_item_id_,
                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                       data_item_value_     => mixed_item_value_);
                  ELSE 
                     Data_Capture_Invent_Util_API.Add_Condition_Code_Desc(capture_session_id_, latest_data_item_id_, conf_item_detail_tab_(i).data_item_detail_id, condition_code_);
                  END IF ; 

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION')) THEN                     
                  IF pick_by_choice_allowed_ AND aggregated_line_id_ IS NOT NULL AND res_handling_unit_id_ IS NULL THEN 
                     part_no_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_,
                                                                                  reserve_rec_.handling_unit_id,
                                                                                  'PART_NO');
                  ELSE
                     part_no_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_,
                                                                                  res_handling_unit_id_,
                                                                                  'PART_NO');
                  END IF;
                  IF (no_unique_value_found_ = FALSE AND part_no_ IS NULL) THEN
                     
                     Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                       data_item_id_        => latest_data_item_id_,
                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                       data_item_value_     => mixed_item_value_);
                  ELSE 
                     Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_   => capture_session_id_,
                                                                          owning_data_item_id_  => latest_data_item_id_,
                                                                          data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                          contract_             => contract_,
                                                                          part_no_              => part_no_);
                  END IF ; 

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PROJECT_ID', 'PROJECT_NAME', 'SUB_PROJECT_ID', 'SUB_PROJECT_DESCRIPTION', 
                                                                       'ACTIVITY_ID', 'ACTIVITY_DESCRIPTION', 'PROGRAM_ID', 'PROGRAM_DESCRIPTION')) THEN

                  IF pick_by_choice_allowed_ AND aggregated_line_id_ IS NOT NULL AND res_handling_unit_id_ IS NULL THEN 
                     activity_seq_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_,
                                                                                       reserve_rec_.handling_unit_id,
                                                                                       'ACTIVITY_SEQ');
                  ELSE
                     activity_seq_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_,
                                                                                       res_handling_unit_id_,
                                                                                       'ACTIVITY_SEQ');
                  END IF;
                  IF (no_unique_value_found_ = FALSE AND activity_seq_ IS NULL) THEN
                     Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                       data_item_id_        => latest_data_item_id_,
                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                       data_item_value_     => mixed_item_value_);
                  ELSE 
                     Data_Capture_Invent_Util_API.Add_Details_For_Activity_Seq(capture_session_id_   => capture_session_id_,
                                                                               owning_data_item_id_  => latest_data_item_id_,
                                                                               data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                               activity_seq_         => activity_seq_);
                  END IF ; 

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHIP_LOCATION_NO_DESC')) THEN
                  ship_location_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_      => capture_session_id_,
                                                                                              current_data_item_id_    => latest_data_item_id_,
                                                                                              current_data_item_value_ => latest_data_item_value_,
                                                                                              wanted_data_item_id_     => 'SHIP_LOCATION_NO');
                  shipment_id_ := Pick_Shipment_API.Get_Shipment_Id(pick_list_no_, Pick_Shipment_API.Get_Pick_List_Type(pick_list_no_));            
                  Data_Capture_Shpmnt_Util_API.Add_Details_For_Ship_Location(capture_session_id_   => capture_session_id_,
                                                                             owning_data_item_id_  => latest_data_item_id_,
                                                                             data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             contract_             => contract_,
                                                                             shipment_id_          => shipment_id_,
                                                                             ship_location_no_     => ship_location_no_); 

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'LAST_LINE_ON_PICK_LIST') THEN 
                  action_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'ACTION', latest_data_item_id_);
                  IF (Pick_Shipment_API.Lines_Left_To_Pick(pick_list_no_) = 1 AND 
                      (action_ IN (Pick_Handl_Unit_Action_API.DB_PICK_SUB_LEVEL,
                                   Pick_Handl_Unit_Action_API.DB_PICK_PARTS))) THEN
                     last_line_on_pick_list_ := Gen_Yes_No_API.DB_NO; -- These actions means that we are not finished yet so this is not the last line on pick list
                  ELSIF (action_ IN (Pick_Handl_Unit_Action_API.DB_PICK,
                                     Pick_Handl_Unit_Action_API.DB_UNRESERVE_PICK_LIST_LINES)) THEN 
                     IF ((Handling_Unit_API.Get_Root_Handling_Unit_Id(res_handling_unit_id_) = res_handling_unit_id_)  AND 
                         res_handling_unit_id_ IS NOT NULL) THEN    -- Checking handling unit structure if current hu is root
                        IF (Pick_Shipment_API.Last_Hndl_Unit_Structure_On_PL(pick_list_no_, res_handling_unit_id_)) THEN
                           last_line_on_pick_list_ := Gen_Yes_No_API.DB_YES; -- This hu is root hu and all remaing lines belongs to this structure
                        ELSE
                           last_line_on_pick_list_ := Gen_Yes_No_API.DB_NO; -- Part lines still exist not connected to hu or all remaining hu's dont belong to this structure
                        END IF;
                     ELSIF (Pick_Shipment_API.Lines_Left_To_Pick(pick_list_no_) = 1 ) THEN
                        last_line_on_pick_list_ := Gen_Yes_No_API.DB_YES;
                     ELSE
                        last_line_on_pick_list_ := Gen_Yes_No_API.DB_NO;
                     END IF;
                  ELSE
                     last_line_on_pick_list_ := Gen_Yes_No_API.DB_NO;
                  END IF;
                  Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                    data_item_id_        => latest_data_item_id_,
                                                    data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                    data_item_value_     => last_line_on_pick_list_);

               END IF;
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Add_Details_For_Latest_Item;


PROCEDURE Pre_Process_Action(
   process_message_     IN OUT CLOB,
   capture_session_id_  IN     NUMBER,
   contract_            IN     VARCHAR2 )
IS
   pick_by_choice_allowed_      BOOLEAN;
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   hu_loop_start_item_id_       VARCHAR2(50);
   end_loop_item_id_            VARCHAR2(50);
   loop_over_hu_exist_          VARCHAR2(5) := 'FALSE';
BEGIN
   pick_by_choice_allowed_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_) != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED;
   -- NOTE here in pre process method we have no idea what the source will be so we cannot stop this section of 
   -- process message to be created, but this should probably still work even if the source is supplier return
   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      IF pick_by_choice_allowed_ AND Data_Capt_Conf_Data_Item_API.Loop_Exist(session_rec_.capture_process_id, session_rec_.capture_config_id) THEN 
         end_loop_item_id_ := Data_Capt_Conf_Data_Item_API.Get_Loop_End_Item_Id(session_rec_.capture_process_id, session_rec_.capture_config_id);
         hu_loop_start_item_id_ := Data_Capt_Conf_Data_Item_API.Get_Current_Loop_Start_Item_Id(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RES_HANDLING_UNIT_ID');  
         IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'AGGREGATED_LINE_ID',  hu_loop_start_item_id_) OR  
             Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, end_loop_item_id_, 'AGGREGATED_LINE_ID')) THEN
            loop_over_hu_exist_ := 'TRUE';
         END IF;
      END IF;   
   $END
   
   process_message_ := Message_SYS.Construct('PROCESS_MESSAGE');
   Set_Loop_Exist___(process_message_, loop_over_hu_exist_);
   
END Pre_Process_Action;


PROCEDURE Post_Process_Action(
   process_message_     IN OUT CLOB,
   capture_session_id_  IN     NUMBER,
   contract_            IN     VARCHAR2 )
IS
   loop_exist_          BOOLEAN;
   inventory_event_id_  NUMBER;
BEGIN
   IF process_message_ IS NOT NULL THEN 
      loop_exist_ := Get_Loop_Exist___(process_message_) = 'TRUE';
      -- TODO this is a big problem since this flag was set already in pre process before we could validate the source
      -- so we need some way of removing that flag or change its value so we can get the value in Get_Loop_Exist___ at least
      -- other ways the site flag + internal loop will still make us call the PBC logic here
      -- We might be able to remove or change value from execute method, there we know the source and site pbc flag, should
      -- work is we just use Set_Loop_Exist___ and send in 'FALSE', it should modify the flag correctly i think, should be easy
      -- test/trace to see what happens
      IF loop_exist_ THEN 
         Pick_Hu_By_Choice_And_Pack___(process_message_              => process_message_, 
                                       contract_                     => contract_, 
                                       aggregated_handling_unit_id_  => NULL, 
                                       res_handling_unit_id_         => NULL, 
                                       aggregated_line_id_           => NULL, 
                                       pick_list_no_                 => NULL, 
                                       ship_location_no_             => NULL, 
                                       shp_handling_unit_id_         => NULL, 
                                       loop_exist_                   => loop_exist_, 
                                       capture_session_id_           => capture_session_id_ );
      END IF;
      
      IF (process_message_ IS NOT NULL) THEN
         Shipment_Flow_API.Start_Shipment_Flow(Get_Shipment_Id_Message___(process_message_), 40);
      END IF;

      inventory_event_id_ := Get_Inventory_Event_Id___(process_message_);
      Inventory_Event_Manager_API.Finish(inventory_event_id_);

      Client_SYS.Clear_Attr(process_message_);
   END IF;
END Post_Process_Action;


PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY CLOB,
   capture_session_id_ IN     NUMBER,
   contract_           IN     VARCHAR2,
   attr_               IN     VARCHAR2,
   blob_ref_attr_      IN     VARCHAR2 )
IS
   pick_clob_                   CLOB;
   out_clob_                    CLOB;
   --session_id_                  NUMBER;
   ptr_                         NUMBER;
   name_                        VARCHAR2(50);
   value_                       VARCHAR2(32000);
   pick_list_no_                VARCHAR2(15);
   unreserve_                   VARCHAR2(5) := 'FALSE';
   shipment_id_                 NUMBER;
   ship_location_no_            VARCHAR2(35);
   shp_handling_unit_id_        NUMBER;
   res_handling_unit_id_        NUMBER;
   aggregated_line_id_          REPORT_PICK_HANDLING_UNIT.objid%TYPE;
   source_ref_type_db_          VARCHAR2(200);
   inventory_event_id_          NUMBER;
   action_                      VARCHAR2(30);
   reserve_rec_                 Handl_Unit_Stock_Snapshot_API.Public_Rec;
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   loop_over_hu_exist_          BOOLEAN := FALSE;
   pick_list_type_              VARCHAR2(20);
   pick_by_choice_allowed_      BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   NULL;
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'PICK_LIST_NO') THEN
            pick_list_no_ := value_;
         ELSIF (name_ = 'AGGREGATED_LINE_ID') THEN
            aggregated_line_id_ := value_;
         ELSIF (name_ = 'SHIP_LOCATION_NO') THEN
            ship_location_no_ := value_;
         ELSIF (name_ = 'SHP_HANDLING_UNIT_ID') THEN
            shp_handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'RES_HANDLING_UNIT_ID') THEN
            res_handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'ACTION') THEN
            action_ := value_;
         ELSIF (name_ = 'SOURCE_REF_TYPE') THEN
            source_ref_type_db_ := source_ref_type_db_;
         END IF;
      END LOOP; 

      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);

      pick_by_choice_allowed_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_) != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED;
      loop_over_hu_exist_     := (Get_Loop_Exist___(process_message_) = 'TRUE');
      IF (pick_by_choice_allowed_ AND loop_over_hu_exist_ AND source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
         -- Turn off loop over hu exist flag since its PBC connected and current source dont allow for PBC, 
         -- it was set in Pre_Process_Action when we didnt know the source yet
         Set_Loop_Exist___(process_message_, loop_exist_ => 'FALSE' );
         -- TODO: trace this out to see that we are able to turn this off in supplier return with pbc site and internal loop scenario
         -- if we for some reason get more that one flag, we could use Remove_Attribute instead of Set_Attribute i would guess
      END IF;
      IF (pick_by_choice_allowed_ AND source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
         -- Turn off PBC if its supplier return since that is not allowed for PBC
         pick_by_choice_allowed_ := FALSE;
      END IF;
      inventory_event_id_     := Get_Inventory_Event_Id___(process_message_);
      Inventory_Event_Manager_API.Set_Session_Id(inventory_event_id_);
      reserve_rec_            := Handl_Unit_Stock_Snapshot_API.Get_Object_By_Id(aggregated_line_id_);
      pick_list_type_         := Pick_Shipment_API.Get_Pick_List_Type(pick_list_no_);

      IF (pick_by_choice_allowed_ AND  
          (reserve_rec_.handling_unit_id != res_handling_unit_id_ OR loop_over_hu_exist_) AND 
          action_ != Pick_Handl_Unit_Action_API.DB_PICK) THEN 
         Error_SYS.Record_General(lu_name_,'ACTIONISNOTALLOWD: The '':P1'' action cannot be performed when pick by choice is enabled and you try to pick another handling unit than '':P2.''', 
                                  Pick_Handl_Unit_Action_API.Decode(action_),
                                  reserve_rec_.handling_unit_id);
      END IF;
      
      shipment_id_ := Pick_Shipment_API.Get_Shipment_Id_Hu(reserve_rec_.handling_unit_id, contract_, ship_location_no_, pick_list_no_);
      IF ((shipment_id_ IS NULL OR shipment_id_ = 0) AND shp_handling_unit_id_ IS NOT NULL) THEN
         -- Extra check outside Validate_Data_Item to catch cases if ship hu comes before pick list no and reserve handling unit in the configuration, since in those cases we havent been able to identify if a unique shipment exist yet.
         Error_SYS.Record_General(lu_name_,'NOSHIPHU2: :P1 cannot be used here since no unique shipment exist for current handling unit structure :P2', 
                                  Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), 'SHP_HANDLING_UNIT_ID'),
                                  reserve_rec_.handling_unit_id);
      END IF;

      IF (action_ = Pick_Handl_Unit_Action_API.DB_PICK) THEN -- no need to do checks if action is not PICK
         -- Doing some extra checks on ship_location_no
         Validate_Ship_Data_Items___(contract_, shp_handling_unit_id_, ship_location_no_);
      END IF;

      IF (action_ = Pick_Handl_Unit_Action_API.DB_PICK OR action_ = Pick_Handl_Unit_Action_API.DB_UNRESERVE_PICK_LIST_LINES) THEN
         IF (action_ = Pick_Handl_Unit_Action_API.DB_UNRESERVE_PICK_LIST_LINES) THEN
            unreserve_ := 'TRUE';
         END IF;

         IF pick_by_choice_allowed_ AND (reserve_rec_.handling_unit_id != res_handling_unit_id_ OR loop_over_hu_exist_) THEN 
            Pick_Hu_By_Choice_And_Pack___(process_message_              => process_message_, 
                                          contract_                     => contract_, 
                                          aggregated_handling_unit_id_  => reserve_rec_.handling_unit_id, 
                                          res_handling_unit_id_         => res_handling_unit_id_, 
                                          aggregated_line_id_           => aggregated_line_id_, 
                                          pick_list_no_                 => pick_list_no_, 
                                          ship_location_no_             => ship_location_no_, 
                                          shp_handling_unit_id_         => shp_handling_unit_id_,
                                          loop_exist_                   => loop_over_hu_exist_,
                                          trigger_shipment_flow_        => 'FALSE',
                                          capture_session_id_           => capture_session_id_ );
         ELSE 
            pick_clob_ := Message_SYS.Construct('');
            Message_SYS.Add_Attribute(pick_clob_, 'HANDLING_UNIT_ID', res_handling_unit_id_);
            Message_SYS.Add_Attribute(pick_clob_, 'LAST_LINE', 'TRUE');

            IF (pick_list_type_ = 'INVENTORY_PICK_LIST') THEN 
               out_clob_ :=  Inventory_Part_Reservation_API.Pick_Aggregated_Reservations__(message_         => pick_clob_,
                                                                                          pick_list_no_     => pick_list_no_, 
                                                                                          ship_location_no_ => ship_location_no_,
                                                                                          unreserve_        => unreserve_);           
            END IF;

            -- Packing reserv hu into shipment hu, only do packing if action was PICK
            IF (shp_handling_unit_id_ IS NOT NULL AND action_ = Pick_Handl_Unit_Action_API.DB_PICK) THEN
               Pack_To_Shipment_Handl_Unit___(res_handling_unit_id_, shp_handling_unit_id_, capture_session_id_);               
            END IF;
         END IF;

      ELSIF (action_ = Pick_Handl_Unit_Action_API.DB_PICK_SUB_LEVEL) THEN
         Handl_Unit_Stock_Snapshot_API.Modify_Process_Control(objid_           => aggregated_line_id_,
                                                              process_control_ => 'PICK_SUB_LEVEL');
      ELSIF (action_ = Pick_Handl_Unit_Action_API.DB_PICK_PARTS) THEN
         Handl_Unit_Stock_Snapshot_API.Modify_Process_Control(objid_           => aggregated_line_id_,
                                                              process_control_ => 'PICK_PARTS',
                                                              modify_children_ => TRUE);
      END IF;

      IF (shipment_id_ != 0) THEN
         Update_Shipment_Ids___(process_message_, shipment_id_);
      END IF;

   $ELSE
      NULL;
   $END
   
END Execute_Process;


@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN CLOB ) RETURN VARCHAR2
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
   process_available_ := Fnd_Boolean_API.DB_TRUE;
   IF (Security_SYS.Is_Proj_Action_Available('ReportPickingOfPickListLines', 'PickSelected') OR
       Security_SYS.Is_Proj_Action_Available('ReportPickingOfPickListLines', 'UnreserveSelected')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;


--@UncheckedAccess
--FUNCTION Subseq_Session_Start_Allowed (
--   capture_session_id_            IN NUMBER, 
--   subsequent_capture_process_id_ IN VARCHAR2 ) RETURN BOOLEAN
--IS
--   subseq_session_start_allowed_ BOOLEAN := TRUE;
--BEGIN
--   $IF Component_Wadaco_SYS.INSTALLED $THEN
--      -- This control is only made if next process is Start Warehouse Task
--      IF (subsequent_capture_process_id_ = 'START_WAREHOUSE_TASK') THEN
--         -- We are only allowed to jump to Start Warehouse Task process if WAREHOUSE_TASK_ID have a value, if it don't have value we return FALSE
--         IF (Data_Capture_Session_Line_API.Get_Latest_Data_Item_Value(capture_session_id_, 'WAREHOUSE_TASK_ID') IS NULL) THEN
--            subseq_session_start_allowed_ := FALSE;
--         END IF;
--      END IF;
--   $END
--   RETURN subseq_session_start_allowed_;
--END Subseq_Session_Start_Allowed;


PROCEDURE Set_Media_Id_For_Data_Item  (
   capture_session_id_ IN NUMBER,
   line_no_            IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
BEGIN
   Data_Capture_Invent_Util_API.Set_Media_Id_For_Data_Item (capture_session_id_, line_no_, data_item_id_, data_item_value_);
END Set_Media_Id_For_Data_Item ;


FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2) RETURN BOOLEAN
IS
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   process_package_             VARCHAR2(30);
   pick_list_no_                VARCHAR2(15);
   aggr_res_handling_unit_id_   NUMBER;
   unique_shipment_id_          NUMBER;
   action_                      VARCHAR2(30);
   fixed_value_is_applicable_   BOOLEAN := FALSE;
   pick_by_choice_option_       VARCHAR2(20);
   source_ref_type_db_          VARCHAR2(200);
   aggregated_line_id_          REPORT_PICK_HANDLING_UNIT.objid%TYPE;
   reserve_rec_                 Handl_Unit_Stock_Snapshot_API.Public_Rec;
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(session_rec_.session_contract);

      IF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID', 'SHIP_LOCATION_NO')) THEN            
         action_        := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'ACTION', data_item_id_);
         pick_list_no_  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PICK_LIST_NO', session_rec_ , process_package_, use_applicable_ => FALSE);
         source_ref_type_db_  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'SOURCE_REF_TYPE', session_rec_ , process_package_, use_applicable_ => FALSE);

         IF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED OR
            source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN 
            aggr_res_handling_unit_id_ :=  Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'RES_HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_ => FALSE);
         ELSE 
            -- When pick by choice is enabled the res_handling_unit_id might be different from originally reserved handling_unit_id on aggregated pick list line
            -- We need to fetch original reserved handling_unit_id on pick list line to evaluate if fixed value is applicable for shipment handling unit and location. 
            aggregated_line_id_   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'AGGREGATED_LINE_ID', session_rec_ , process_package_, use_applicable_ => FALSE);
            IF aggregated_line_id_ IS NOT NULL THEN
               reserve_rec_ := Handl_Unit_Stock_Snapshot_API.Get_Object_By_Id(aggregated_line_id_);
            END IF;
            aggr_res_handling_unit_id_ := reserve_rec_.handling_unit_id;
         END IF;

         aggr_res_handling_unit_id_ :=  Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'RES_HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_ => FALSE);
         unique_shipment_id_ := Pick_Shipment_API.Get_Shipment_Id_Hu(aggr_res_handling_unit_id_, null, null, pick_list_no_); -- Get unique shipment_id for this hu structure

         IF (action_ IN (Pick_Handl_Unit_Action_API.DB_UNRESERVE_PICK_LIST_LINES, 
                         Pick_Handl_Unit_Action_API.DB_PICK_SUB_LEVEL, 
                         Pick_Handl_Unit_Action_API.DB_PICK_PARTS)) THEN
            fixed_value_is_applicable_ := TRUE;  -- shipment hu and ship loc not necessary when using these 3 actions
         ELSIF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID') AND
               (unique_shipment_id_ IS NULL OR unique_shipment_id_ = 0) AND pick_list_no_ IS NOT NULL AND aggr_res_handling_unit_id_ IS NOT NULL) THEN
            fixed_value_is_applicable_ := TRUE;  -- no unique shipment id or its 0 for this reserve hu structure so no shipment hu should be used
         ELSIF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID') AND 
               (unique_shipment_id_ IS NOT NULL AND unique_shipment_id_ != 0)) THEN
            IF (NOT Fnd_Boolean_API.Is_True_DB(Handling_Unit_Ship_Util_API.Shipment_Has_Hu_Connected(unique_shipment_id_))) THEN
               -- There isn't any handling units defined on the shipment
               fixed_value_is_applicable_ := TRUE;
            ELSIF aggr_res_handling_unit_id_ IS NOT NULL AND Fnd_Boolean_API.Is_True_DB(Shipment_Reserv_Handl_Unit_API.Has_Qty_Attached_To_Shipment(aggr_res_handling_unit_id_, unique_shipment_id_)) THEN 
               -- There is already pre attached reservation on shipment handling unit id
               fixed_value_is_applicable_ := TRUE;
            END IF;
         END IF;
      END IF;
   $END
   RETURN fixed_value_is_applicable_;
END Fixed_Value_Is_Applicable;


PROCEDURE Validate_Configuration (
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER ) 
IS
   conf_detail_tab_         Data_Capture_Common_Util_API.Config_Item_Tab;
   invalid_configuration_   BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Find all data item that have feedback item LAST_LINE_ON_PICK_LIST as a detail item
      conf_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_ALL_Collection(capture_process_id_, capture_config_id_, NULL, 'LAST_LINE_ON_PICK_LIST');
      IF (conf_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_detail_tab_.FIRST..conf_detail_tab_.LAST  LOOP
            -- If any item that have LAST_LINE_ON_PICK_LIST as detail comes before ACTION data items configuration is invalid, 
            -- because we need to know the action to evaluate and set LAST_LINE_ON_PICK_LIST correctly. 
            IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_, 
                                                           capture_config_id_  => capture_config_id_, 
                                                           data_item_id_a_     => conf_detail_tab_(i).data_item_id, 
                                                           data_item_id_b_     => 'ACTION')) THEN
               invalid_configuration_ := TRUE;
               EXIT;
            END IF;
         END LOOP;
      END IF;
      IF invalid_configuration_ THEN
         Error_SYS.Record_General(lu_name_,'LASTLINEUSEDBEFOREACTION: The Feedback item :P1 should only be used on or after the data item :P2 in the Configuration.',
                                  Data_Capt_Proc_Feedba_Item_API.Get_Description(capture_process_id_, 'LAST_LINE_ON_PICK_LIST'),
                                  Data_Capt_Proc_Data_Item_API.Get_Description(capture_process_id_, 'ACTION'));
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Configuration;

