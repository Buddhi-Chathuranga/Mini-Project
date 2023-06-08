-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptModifyHndlUnit
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: MODIFY_HANDLING_UNIT
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200915  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  200311  DaZase  SCXTEND-3803, Small change in Create_List_Of_Values to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171024  DaZase  STRSC-13024, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171024          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  170217  DaZase  Changes in Get_Sql_Invent_Where_Expr___/Get_Automatic_Data_Item_Value/Get_Unique_Data_Item_Value___ 
--  170217          due to unique Handling_Unit_API methods now uses table instead of extended view for performance reasons, 
--  170217          so a contract/user allowed site check was added since that was on extended view.
--  161102  DaZase  LIM-7326, Added handling of new data items PRINT_SHIPMENT_LABEL, NO_OF_SHIPMENT_LABELS, PRINT_CONTENT_LABEL and NO_OF_CONTENT_LABELS.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160519  UdGnlk  LIM-7475, Modified Execute_Process() method call from Print_Transport_Package_Label() to Handling_Unit_API.Print_Shpmnt_Hand_Unit_Label().
--  160108  DaZase  LIM-4571, Reworked and renamed DataCaptModHandUntShp to DataCaptModifyHndlUnit and moved it from ORDER to INVENT. 
--  160108          The old ORDER DataCaptModHandUntShp is now obsolete and replaced with this file. This process now support Modifying handling units 
--  160108          both in Inventory and in Shipment.
--  151028  Erlise  LIM-3776, Rename ALT_TRANSPORT_LABEL_ID data item to ALT_HANDLING_UNIT_LABEL_ID and 
--  151028          NEW_ALT_TRANSPORT_LABEL_ID to NEW_ALT_HANDLING_UNIT_LABEL_ID.
--  151027  DaZase  LIM-4297, Changed calls to Add_Details_For_Hand_Unit_Type and Add_Details_For_Handling_Unit 
--  151027          so they now call Data_Capture_Invent_Util_API instead of Data_Capture_Order_Util_API.                  
--  151006  MaEelk  LIM-3579, Removed the parameter shipment_id from the call to handling_Unit_API.Create_Sscc and 
--  151006          replaced the usage of Handling_Unit_API.Get_Top_Shipment_Id with Handling_Unit_API.Get_Shipment_Id
--  150826  DaZase  AFT-1922, Added value check on WIDTH', 'HEIGHT', 'DEPTH', 'MANUAL_GROSS_WEIGHT', 'MANUAL_VOLUME in Validate_Data_Item.
--  150825  DaZase  AFT-1964, Removed feedback items MANUAL_GROSS_WEIGHT/MANUAL_VOLUME from Add_Details_For_Latest_Item.
--  150807  DaZase  COB-607, Reworked some of the unique methods so data items that are not using the filter keys 
--  150807          are handled before calling Get_Filter_Keys___, to help performance a bit. 
--  150327  RILASE  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PRIVATE DECLARATIONS -----------------------------------
string_all_values_ CONSTANT VARCHAR2(1) := '%';
number_all_values_ CONSTANT NUMBER := -1;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


FUNCTION Get_Data_Source___ (
   shipment_id_               IN NUMBER,
   parent_consol_shipment_id_ IN NUMBER,
   session_rec_               IN Data_Capture_Common_Util_API.Session_Rec,
   data_item_id_              IN  VARCHAR2 ) RETURN VARCHAR2
IS
   data_source_               VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      $IF Component_Shpmnt_SYS.INSTALLED $THEN

         IF (shipment_id_ IS NOT NULL OR parent_consol_shipment_id_ IS NOT NULL) THEN
            -- If any of the shipment filter keys are not NULL then we are using SHIPMENT
            data_source_ := 'SHIPMENT';

         ELSE -- All shipment filter keys are at the moment NULL
            -- Check shipment if data item is one of the shipment only data items
            IF (data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID')) THEN
               -- If any of the shipment only and not nullable items comes before current item
               IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_)) THEN
                  -- then we know that this is INVENT only since at least one of the shipment only and not nullable items ARE NULL 
                  data_source_ := 'INVENT';
               ELSE  -- None of the shipment only and not nullable items comes before current item
                  -- If any of shipment only and not nullable items will be set as NULL by fixed value handling
                  IF (Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'SHIPMENT_ID')) THEN
                     -- then we know that this is INVENT only since at least one of the shipment only and not nullable items WILL BE NULL
                     data_source_ := 'INVENT';
                  ELSE  -- None of the shipment only and not nullable items will be NULL by fixed value handling
                     IF (data_item_id_ = 'SHIPMENT_ID') THEN
                        -- since shipment_id exist in both data sources and we still dont know which one to use, both are valid
                        data_source_ := 'INVENT_AND_SHIPMENT';  
                     ELSE

                        -- We still don't know if this session will use shipment or not, so both NULL and SHIPMENT is allowed
                        data_source_ := 'NULL_AND_SHIPMENT';
                     END IF;
                  END IF;
               END IF;
            
            ELSE -- data item is one of the items that can be both INVENT and SHIPMENT
               -- If any of the shipment only and not nullable items comes before current item
               IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_)) THEN
                  -- then we know that this is INVENT only since at least one of the shipment only and not nullable items ARE NULL 
                  data_source_ := 'INVENT';
               ELSE  -- None of the shipment only and not nullable items comes before current item
                  -- If any of shipment only and not nullable items will be set as NULL by fixed value handling
                  IF (Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'SHIPMENT_ID')) THEN
                     -- then we know that this is INVENT only since at least one of the shipment only and not nullable items WILL BE NULL
                     data_source_ := 'INVENT';
                  ELSE  -- None of the shipment only and not nullable items will be NULL by fixed value handling
                     -- We still don't know if this session will use shipment or not, so both INVENT and SHIPMENT is allowed
                     data_source_ := 'INVENT_AND_SHIPMENT';
                  END IF;
               END IF;
            END IF;
         END IF;

      $ELSE  -- SHIPMENT not installed
          data_source_ := 'INVENT';
      $END   -- SHIPMENT CC
   $END   -- WADACO CC
    RETURN data_source_;
END Get_Data_Source___;


PROCEDURE Get_Filter_Keys___ (
   contract_                      OUT VARCHAR2,
   shipment_id_                   OUT NUMBER,
   parent_consol_shipment_id_     OUT NUMBER,
   handling_unit_id_              OUT NUMBER,
   sscc_                          OUT VARCHAR2,
   alt_handling_unit_label_id_    OUT VARCHAR2,
   data_source_                   OUT VARCHAR2,
   capture_session_id_            IN  NUMBER,
   data_item_id_                  IN  VARCHAR2,
   data_item_value_               IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_             IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_                IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   process_package_     VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      contract_        := session_rec_.session_contract;
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      -- First try and fetch "predicted" filter keys 
      shipment_id_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      parent_consol_shipment_id_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PARENT_CONSOL_SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      handling_unit_id_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_                          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);

      -- Fetch the data source that should be used
      data_source_ := Get_Data_Source___(shipment_id_, parent_consol_shipment_id_, session_rec_, data_item_id_);

      IF (shipment_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_)) THEN
         shipment_id_ := number_all_values_;
      END IF;

      IF (parent_consol_shipment_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_CONSOL_SHIPMENT_ID', data_item_id_)) THEN
         parent_consol_shipment_id_ := number_all_values_;
      END IF;

      IF (handling_unit_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', data_item_id_)) THEN
         handling_unit_id_ := number_all_values_;
      END IF;      

      IF (sscc_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SSCC', data_item_id_)) THEN
         sscc_ := string_all_values_;
      END IF;

      IF (alt_handling_unit_label_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         alt_handling_unit_label_id_ := string_all_values_;
      END IF;

      IF (use_unique_values_) THEN

         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (shipment_id_ IS NULL OR shipment_id_ = number_all_values_) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, data_source_, 'SHIPMENT_ID');
         END IF;
         IF (parent_consol_shipment_id_ IS NULL OR parent_consol_shipment_id_ = number_all_values_) THEN
            parent_consol_shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, data_source_, 'PARENT_CONSOL_SHIPMENT_ID');
         END IF;
         IF (handling_unit_id_ IS NULL OR handling_unit_id_ = number_all_values_) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, data_source_, 'HANDLING_UNIT_ID');
         END IF;
         IF (sscc_ IS NULL OR sscc_ = string_all_values_) THEN
            sscc_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, data_source_, 'SSCC');
         END IF;
         IF (alt_handling_unit_label_id_ IS NULL OR alt_handling_unit_label_id_ = string_all_values_) THEN
            alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, data_source_, 'ALT_HANDLING_UNIT_LABEL_ID');
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Get_Filter_Keys___;


FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                      IN VARCHAR2,
   shipment_id_                   IN NUMBER,
   handling_unit_id_              IN NUMBER,
   parent_consol_shipment_id_     IN NUMBER,
   sscc_                          IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2,
   data_source_                   IN VARCHAR2,
   wanted_data_item_id_           IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_                 VARCHAR2(200);
   local_handling_unit_id_        NUMBER;
   dummy_                         BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   IF (wanted_data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN

      IF (data_source_ = 'SHIPMENT') THEN
         $IF Component_Shpmnt_SYS.INSTALLED $THEN
            unique_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                     contract_                   => contract_,
                                                                     shipment_id_                => shipment_id_,
                                                                     handling_unit_id_           => handling_unit_id_,
                                                                     parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                     sscc_                       => sscc_,
                                                                     alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                     column_name_                => wanted_data_item_id_,
                                                                     sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___);
         $ELSE
            NULL;
         $END

      ELSIF (data_source_ = 'NULL_AND_SHIPMENT') THEN
         -- Since NULL is always a possibility here, there is no point checking shipment since this method 
         -- should not return 'NULL' so in this method you dont see the difference between NULL and unique value NULL, 
         -- so it will always return NULL even if you find a unique shipment value since the "other" NULL is always 
         -- alternative also. This is the difference between this method and Get_Automatic_Data_Item_Value where we 
         -- actually handle and return 'NULL' for unique NULL values.
         unique_value_ := NULL;


      ELSIF (data_source_ = 'INVENT_AND_SHIPMENT') THEN
        unique_value_ := Get_Unique_Inv_Ship_Value___(contract_, shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, wanted_data_item_id_);

      ELSIF ((data_source_ = 'INVENT') AND (wanted_data_item_id_ NOT IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID'))) THEN
         -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
         local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
         unique_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                       handling_unit_id_           => local_handling_unit_id_,
                                                                       sscc_                       => sscc_,
                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                       column_name_                => wanted_data_item_id_,
                                                                       sql_where_expression_       => Get_Sql_Invent_Where_Expr___);

      END IF;


   ELSIF (wanted_data_item_id_ IN ('WIDTH', 'HEIGHT', 'DEPTH', 'MANUAL_GROSS_WEIGHT', 'MANUAL_VOLUME', 'NO_OF_HANDLING_UNIT_LABELS', 'NO_OF_CONTENT_LABELS', 'NO_OF_SHIPMENT_LABELS')) THEN
      -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
      local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
      unique_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                    handling_unit_id_           => local_handling_unit_id_,
                                                                    sscc_                       => sscc_,
                                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                    column_name_                => wanted_data_item_id_,
                                                                    sql_where_expression_       => ' AND (contract IS NULL OR EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE contract = site)) ');  -- No extra shipment_id IS NULL here since it could be a shipment hu

   END IF;

   IF (unique_value_ = 'NULL') THEN
      unique_value_ := NULL;
   END IF;
   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


FUNCTION Get_Unique_Inv_Ship_Value___ (
   contract_                      IN VARCHAR2,
   shipment_id_                   IN NUMBER,
   parent_consol_shipment_id_     IN NUMBER,
   handling_unit_id_              IN NUMBER,
   sscc_                          IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2,
   column_name_                   IN VARCHAR2 ) RETURN VARCHAR2

IS
   unique_value_                  VARCHAR2(200);
   shipment_unique_value_         VARCHAR2(200);
   invent_unique_value_           VARCHAR2(200);
   shpmnt_no_unique_value_found_  BOOLEAN; 
   invent_no_unique_value_found_  BOOLEAN;
   local_handling_unit_id_        NUMBER;
BEGIN
   IF (column_name_ NOT IN ('PARENT_CONSOL_SHIPMENT_ID')) THEN
      -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
      local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
      invent_unique_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => invent_no_unique_value_found_,
                                                                           handling_unit_id_           => local_handling_unit_id_,
                                                                           sscc_                       => sscc_,
                                                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                           column_name_                => column_name_,
                                                                           sql_where_expression_       => Get_Sql_Invent_Where_Expr___);
   ELSE
      invent_no_unique_value_found_ := TRUE; 
   END IF;

   $IF Component_Shpmnt_SYS.INSTALLED $THEN
      shipment_unique_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_      => shpmnt_no_unique_value_found_,
                                                                        contract_                   => contract_,
                                                                        shipment_id_                => shipment_id_,
                                                                        handling_unit_id_           => handling_unit_id_,
                                                                        parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                        sscc_                       => sscc_,
                                                                        alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                        column_name_                => column_name_,
                                                                        sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___);
   $END

   IF (shipment_unique_value_ = invent_unique_value_) THEN
      unique_value_ := shipment_unique_value_;   -- same unique value so 1 unique value was found
   ELSIF (shipment_unique_value_ IS NOT NULL AND invent_unique_value_ IS NULL AND invent_no_unique_value_found_) THEN
      unique_value_ := shipment_unique_value_;   -- shipment unique value was found but none in invent records, use shipment value
   ELSIF (invent_unique_value_ IS NOT NULL AND shipment_unique_value_ IS NULL AND shpmnt_no_unique_value_found_) THEN
      unique_value_ := invent_unique_value_; -- invent unique value was found but none in shipment, use invent value
   ELSE -- not the same unique values from invent and shipment or one of the data sources got more then 1 value so no combined unique value was found
      unique_value_ := NULL;            
   END IF;

   RETURN unique_value_;
END Get_Unique_Inv_Ship_Value___;


PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_           IN NUMBER,
   owning_data_item_id_          IN VARCHAR2,
   data_item_detail_id_          IN VARCHAR2,
   shipment_id_                  IN NUMBER,
   parent_consol_shipment_id_    IN NUMBER,
   handling_unit_id_             IN NUMBER,
   sscc_                         IN VARCHAR2,
   alt_handling_unit_label_id_   IN VARCHAR2 )  
IS
   detail_value_                 VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('SHIPMENT_ID') THEN
            IF (shipment_id_ != number_all_values_) THEN
               detail_value_ := shipment_id_;
            END IF;
         WHEN ('PARENT_CONSOL_SHIPMENT_ID') THEN
            IF (parent_consol_shipment_id_ != number_all_values_) THEN
               detail_value_ := parent_consol_shipment_id_;
            END IF;
         WHEN ('HANDLING_UNIT_ID') THEN
            IF (handling_unit_id_ != number_all_values_) THEN
               detail_value_ := handling_unit_id_;
            END IF;
         WHEN ('SSCC') THEN
            IF (sscc_ != string_all_values_) THEN
               detail_value_ := sscc_;
            END IF;
         WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
            IF (alt_handling_unit_label_id_ != string_all_values_) THEN
               detail_value_ := alt_handling_unit_label_id_;
            END IF;
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
   
   
PROCEDURE Add_Unique_Data_Item_Detail___ (
   capture_session_id_         IN NUMBER,
   session_rec_                IN Data_Capture_Common_Util_API.Session_Rec,
   owning_data_item_id_        IN VARCHAR2,
   owning_data_item_value_     IN VARCHAR2,
   data_item_detail_id_        IN VARCHAR2,
   contract_                   IN VARCHAR2,
   shipment_id_                IN NUMBER,
   handling_unit_id_           IN NUMBER,
   parent_consol_shipment_id_  IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2 )
IS
   detail_value_          VARCHAR2(4000);
   process_package_       VARCHAR2(30);
   dummy_data_source_     VARCHAR2(30); -- not realy used here
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

      -- Non filter key data items that could be fetched by unique handling
      IF (detail_value_ IS NULL AND data_item_detail_id_ IN ('WIDTH', 'HEIGHT', 'DEPTH', 'MANUAL_GROSS_WEIGHT', 'MANUAL_VOLUME', 'NO_OF_HANDLING_UNIT_LABELS', 'NO_OF_CONTENT_LABELS', 'NO_OF_SHIPMENT_LABELS')) THEN
         detail_value_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, dummy_data_source_, data_item_detail_id_);
      END IF;

      
      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;


FUNCTION Get_Sql_Shpmnt_Where_Expr___ RETURN VARCHAR2
IS
BEGIN
   RETURN ' AND handling_unit_id IS NOT NULL AND state IN (''Preliminary'', ''Completed'') ';
END Get_Sql_Shpmnt_Where_Expr___;


FUNCTION Get_Sql_Invent_Where_Expr___ RETURN VARCHAR2
IS
BEGIN
   RETURN ' AND shipment_id IS NULL AND (contract IS NULL OR EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE contract = site)) ';
END Get_Sql_Invent_Where_Expr___;


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
   handling_unit_id_              NUMBER;
   shipment_id_                   NUMBER;
   parent_consol_shipment_id_     NUMBER;
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   dummy_contract_                VARCHAR2(5);
   dummy_exit_lov_                BOOLEAN;
   data_source_                   VARCHAR2(30);
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   lov_type_db_                   VARCHAR2(20);
   local_handling_unit_id_        NUMBER;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('CREATE_NEW_SSCC', 'PRINT_HANDLING_UNIT_LABEL', 'PRINT_CONTENT_LABEL', 'PRINT_SHIPMENT_LABEL')) THEN
         Gen_Yes_No_API.Create_Data_Capture_Lov(capture_session_id_ => capture_session_id_);
      ELSIF (data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
         Get_Filter_Keys___(dummy_contract_, shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, data_source_, capture_session_id_, data_item_id_);
         session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_);
   
         IF (data_source_ = 'NULL_AND_SHIPMENT') THEN
            -- add first a NULL LOV line
            Data_Capture_Session_Lov_API.New(exit_lov_              => dummy_exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => NULL,
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => Data_Capture_Config_API.Get_Lov_Row_Limitation(capture_process_id_, capture_config_id_),    
                                             session_rec_           => session_rec_);
         END IF;
   
         IF ((data_source_ = 'INVENT') AND (data_item_id_ NOT IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID'))) OR
            (data_source_ = 'INVENT_AND_SHIPMENT') THEN
   
            -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
            local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
            Handling_Unit_API.Create_Data_Capture_Lov(handling_unit_id_           => local_handling_unit_id_,
                                                      sscc_                       => sscc_,
                                                      alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                      capture_session_id_         => capture_session_id_,
                                                      column_name_                => data_item_id_,
                                                      lov_type_db_                => lov_type_db_,
                                                      sql_where_expression_       => Get_Sql_Invent_Where_Expr___);
         END IF;
         
         IF (data_source_ IN ('SHIPMENT', 'NULL_AND_SHIPMENT', 'INVENT_AND_SHIPMENT')) THEN
            $IF Component_Shpmnt_SYS.INSTALLED $THEN
               Shipment_API.Create_Data_Capture_Lov(contract_                   => contract_,
                                                    shipment_id_                => shipment_id_,
                                                    handling_unit_id_           => handling_unit_id_,
                                                    parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                    sscc_                       => sscc_,
                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                    capture_session_id_         => capture_session_id_,
                                                    column_name_                => data_item_id_,
                                                    lov_type_db_                => lov_type_db_,
                                                    sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___);
   
            $ELSE
               NULL;
            $END
         END IF;
   
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
   IF no_of_records_handled_ = 1 THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'MODIFYOK: The handling unit was modified.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'MODIFIESOK: :P1 handling units were modified.', NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY VARCHAR2,
   capture_session_id_ IN     NUMBER,
   contract_           IN     VARCHAR2,
   attr_               IN     VARCHAR2,
   blob_ref_attr_      IN     VARCHAR2 )
IS
   ptr_                          NUMBER;
   name_                         VARCHAR2(50);
   value_                        VARCHAR2(4000);
   handling_unit_id_             NUMBER;
   width_                        NUMBER;
   height_                       NUMBER;
   depth_                        NUMBER;
   manual_gross_weight_          NUMBER;
   manual_volume_                NUMBER;
   no_of_handling_unit_labels_   NUMBER;
   no_of_content_labels_         NUMBER;
   no_of_shipment_labels_        NUMBER;
   create_new_sscc_              BOOLEAN;
   new_sscc_                     VARCHAR2(18);
   new_alt_hand_unit_label_id_   VARCHAR2(25);
   print_handling_unit_label_    BOOLEAN;
   print_content_label_          BOOLEAN;
   print_shipment_label_         BOOLEAN;
   print_handling_unit_label_db_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   print_content_label_db_       VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   print_shipment_label_db_      VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   shipment_id_                  NUMBER;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'CREATE_NEW_SSCC') THEN
         create_new_sscc_ := (value_ = Gen_Yes_No_API.DB_YES);
      ELSIF (name_ = 'NEW_SSCC') THEN
         new_sscc_ := value_;
      ELSIF (name_ = 'NEW_ALT_HANDLING_UNIT_LABEL_ID') THEN
         new_alt_hand_unit_label_id_ := value_;
      ELSIF (name_ = 'PRINT_HANDLING_UNIT_LABEL') THEN
         print_handling_unit_label_ := (value_ = Gen_Yes_No_API.DB_YES);
         print_handling_unit_label_db_ := CASE value_ WHEN Gen_Yes_No_API.DB_YES THEN Fnd_Boolean_API.DB_TRUE ELSE Fnd_Boolean_API.DB_FALSE END;
      ELSIF (name_ = 'PRINT_CONTENT_LABEL') THEN
         print_content_label_ := (value_ = Gen_Yes_No_API.DB_YES);
         print_content_label_db_ := CASE value_ WHEN Gen_Yes_No_API.DB_YES THEN Fnd_Boolean_API.DB_TRUE ELSE Fnd_Boolean_API.DB_FALSE END;
      ELSIF (name_ = 'PRINT_SHIPMENT_LABEL') THEN
         print_shipment_label_ := (value_ = Gen_Yes_No_API.DB_YES);
         print_shipment_label_db_ := CASE value_ WHEN Gen_Yes_No_API.DB_YES THEN Fnd_Boolean_API.DB_TRUE ELSE Fnd_Boolean_API.DB_FALSE END;
      ELSIF (name_ = 'WIDTH') THEN
         width_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'HEIGHT') THEN
         height_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'DEPTH') THEN
         depth_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'MANUAL_GROSS_WEIGHT') THEN
         manual_gross_weight_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'MANUAL_VOLUME') THEN
         manual_volume_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'NO_OF_HANDLING_UNIT_LABELS') THEN
         no_of_handling_unit_labels_ := NVL(Client_SYS.Attr_Value_To_Number(value_), 1);
      ELSIF (name_ = 'NO_OF_CONTENT_LABELS') THEN
         no_of_content_labels_ := NVL(Client_SYS.Attr_Value_To_Number(value_), 1);
      ELSIF (name_ = 'NO_OF_SHIPMENT_LABELS') THEN
         no_of_shipment_labels_ := NVL(Client_SYS.Attr_Value_To_Number(value_), 1);
      ELSIF (name_ = 'SHIPMENT_ID') THEN
         shipment_id_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
   END LOOP;

   Handling_Unit_API.Modify(handling_unit_id_           => handling_unit_id_,
                            sscc_                       => new_sscc_,
                            alt_handling_unit_label_id_ => new_alt_hand_unit_label_id_,
                            width_                      => width_,
                            height_                     => height_,
                            depth_                      => depth_,
                            manual_gross_weight_        => manual_gross_weight_,
                            manual_volume_              => manual_volume_,
                            print_label_db_             => print_handling_unit_label_db_,
                            print_content_label_db_     => print_content_label_db_,
                            print_shipment_label_db_    => print_shipment_label_db_,
                            no_of_handling_unit_labels_ => no_of_handling_unit_labels_,
                            no_of_content_labels_       => no_of_content_labels_,
                            no_of_shipment_labels_      => no_of_shipment_labels_);

   IF (create_new_sscc_) THEN
      Handling_Unit_API.Create_Sscc(handling_unit_id_); 
   END IF;

   IF (print_handling_unit_label_) THEN
      Handling_Unit_API.Print_Handling_Unit_Label(handling_unit_id_           => handling_unit_id_, 
                                                  no_of_handling_unit_labels_ => no_of_handling_unit_labels_);
   END IF;

   IF (print_content_label_) THEN
      Handling_Unit_API.Print_Hand_Unit_Content_Label(handling_unit_id_           => handling_unit_id_, 
                                                      no_of_handling_unit_labels_ => no_of_content_labels_);
   END IF;

   IF (print_shipment_label_ AND shipment_id_ IS NOT NULL) THEN
      Handling_Unit_API.Print_Shpmnt_Hand_Unit_Label(handling_unit_id_           => handling_unit_id_, 
                                                     shipment_id_                => shipment_id_, 
                                                     no_of_handling_unit_labels_ => no_of_shipment_labels_);
   END IF;

END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Handling_Unit_API.Modify is granted thru following projection/action
   IF (Security_SYS.Is_Proj_Action_Available('HandlingUnitHandling', 'ModifyHandingUnitWadaco')) THEN   
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   handling_unit_id_              NUMBER;
   shipment_id_                   NUMBER;
   contract_                      VARCHAR2(5);
   parent_consol_shipment_id_     NUMBER;
   sscc_                          VARCHAR2(18);
   create_new_sscc_               VARCHAR2(1);
   alt_handling_unit_label_id_    VARCHAR2(25);
   automatic_value_               VARCHAR2(200);
   column_name_                   VARCHAR2(50);
   data_source_                   VARCHAR2(30);
   local_handling_unit_id_        NUMBER;
   dummy_                         BOOLEAN;
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_              := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- Try and get value from any previously scanned GS1 barcode if this data item have AI code connected to them. Also reducing the value to lengths we have on the IFS objects
      automatic_value_ := SUBSTR(Data_Capture_Session_API.Get_Item_Value_From_Gs1_Items(capture_session_id_ => capture_session_id_,
                                                                                        capture_process_id_ => session_rec_.capture_process_id,
                                                                                        capture_config_id_  => session_rec_.capture_config_id,
                                                                                        data_item_id_       => data_item_id_), 1, 
                                 NVL(Data_Capt_Proc_Data_Item_API.Get_String_Length(session_rec_.capture_process_id, data_item_id_), 200));

      IF (automatic_value_ IS NULL) THEN

         Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, data_source_, capture_session_id_, data_item_id_);
         IF (data_item_id_ IN ('HANDLING_UNIT_ID', 'SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SSCC', 'NEW_SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'NEW_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            IF (data_item_id_ = 'NEW_SSCC') THEN
               create_new_sscc_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'CREATE_NEW_SSCC', data_item_id_);
               IF (create_new_sscc_ = Gen_Yes_No_API.DB_YES) THEN
                  automatic_value_ := 'NULL';
               END IF;
               column_name_     := 'SSCC';
            ELSIF (data_item_id_ = 'NEW_ALT_HANDLING_UNIT_LABEL_ID') THEN
               column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
            ELSE
               column_name_ := data_item_id_;
            END IF;
   
            IF (automatic_value_ IS NULL) THEN
   
               IF (data_source_ IN ('SHIPMENT', 'NULL_AND_SHIPMENT')) THEN
                  $IF Component_Shpmnt_SYS.INSTALLED $THEN
                     automatic_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                 contract_                   => contract_,
                                                                                 shipment_id_                => shipment_id_,
                                                                                 handling_unit_id_           => handling_unit_id_,
                                                                                 parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                                 sscc_                       => sscc_,
                                                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                 column_name_                => column_name_,
                                                                                 sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___);
   
                     IF (data_source_ = 'NULL_AND_SHIPMENT' AND automatic_value_ != 'NULL') THEN
                        automatic_value_ := NULL;  
                        -- if we dont find a unique value or if we actually find a unique value that isnt NULL, then user have to enter this data item,
                        -- since we will then for this data source type have 2 different unique values since NULL is always possible also.
                     END IF;
                  $ELSE
                     NULL;
                  $END
   
               ELSIF (data_source_ = 'INVENT_AND_SHIPMENT') THEN
                  automatic_value_ := Get_Unique_Inv_Ship_Value___(contract_, shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, column_name_);
   
               ELSIF ((data_source_ = 'INVENT') AND (data_item_id_ NOT IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID'))) THEN
                  -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
                  local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
                  automatic_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                   handling_unit_id_           => local_handling_unit_id_,
                                                                                   sscc_                       => sscc_,
                                                                                   alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                   column_name_                => column_name_,
                                                                                   sql_where_expression_       => Get_Sql_Invent_Where_Expr___);
   
               ELSIF ((data_source_ = 'INVENT') AND (data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID'))) THEN
                  automatic_value_ := 'NULL';
               END IF;
            END IF;
   
         ELSIF (data_item_id_ = 'CREATE_NEW_SSCC') THEN
            IF (sscc_ IS NOT NULL OR NOT Fnd_Boolean_API.Is_True_Db(Handling_Unit_API.Get_Generate_Sscc_No_Db(handling_unit_id_))) THEN
               automatic_value_ := Gen_Yes_No_API.DB_NO;
            ELSIF (Fnd_Boolean_API.Is_True_Db(Handling_Unit_API.Get_Generate_Sscc_No_Db(handling_unit_id_))) THEN
               automatic_value_ := Gen_Yes_No_API.DB_YES;
            END IF;
         ELSIF (data_item_id_ IN ('WIDTH', 'HEIGHT', 'DEPTH', 'MANUAL_GROSS_WEIGHT', 'MANUAL_VOLUME', 'NO_OF_HANDLING_UNIT_LABELS', 'NO_OF_CONTENT_LABELS', 'NO_OF_SHIPMENT_LABELS')) THEN
            -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
            local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
            automatic_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                             handling_unit_id_           => local_handling_unit_id_,
                                                                             sscc_                       => sscc_,
                                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                             column_name_                => data_item_id_,
                                                                             sql_where_expression_       => ' AND (contract IS NULL OR EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE contract = site)) ');  -- No extra shipment_id IS NULL here since it could be a shipment hu
         ELSIF (data_item_id_ IN ('PRINT_HANDLING_UNIT_LABEL')) THEN
            IF (Fnd_Boolean_API.Is_True_Db(Handling_Unit_API.Get_Print_Label_Db(handling_unit_id_))) THEN
               automatic_value_ := Gen_Yes_No_API.DB_YES;
            ELSE
               automatic_value_ := Gen_Yes_No_API.DB_NO;
            END IF;
   
         ELSIF (data_item_id_ IN ('PRINT_CONTENT_LABEL')) THEN
            IF (Fnd_Boolean_API.Is_True_Db(Handling_Unit_API.Get_Print_Content_Label_Db(handling_unit_id_))) THEN
               automatic_value_ := Gen_Yes_No_API.DB_YES;
            ELSE
               automatic_value_ := Gen_Yes_No_API.DB_NO;
            END IF;
         ELSIF (data_item_id_ IN ('PRINT_SHIPMENT_LABEL')) THEN
            IF (Fnd_Boolean_API.Is_True_Db(Handling_Unit_API.Get_Print_Shipment_Label_Db(handling_unit_id_))) THEN
               automatic_value_ := Gen_Yes_No_API.DB_YES;
            ELSE
               automatic_value_ := Gen_Yes_No_API.DB_NO;
            END IF;
         END IF;
      END IF;
   $END
   RETURN automatic_value_;
END Get_Automatic_Data_Item_Value;


PROCEDURE Validate_Data_Item (
   capture_session_id_  IN NUMBER,
   data_item_id_        IN VARCHAR2,
   data_item_value_     IN VARCHAR2 )
IS
   contract_                      VARCHAR2(5);
   handling_unit_id_              NUMBER;
   shipment_id_                   NUMBER;
   parent_consol_shipment_id_     NUMBER;
   data_item_description_         VARCHAR2(200);
   sscc_                          VARCHAR2(18);
   new_sscc_                      VARCHAR2(18);
   create_new_sscc_               VARCHAR2(1);
   alt_handling_unit_label_id_    VARCHAR2(25);
   exists_in_invent_              BOOLEAN;
   exists_in_shipment_            BOOLEAN;
   data_source_                   VARCHAR2(30);
   local_handling_unit_id_        NUMBER;
   dummy_                         BOOLEAN;

BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF (data_item_id_ = 'CREATE_NEW_SSCC') THEN
         Gen_Yes_No_API.Exist_Db(data_item_value_);
         new_sscc_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_      => capture_session_id_,
                                                                             current_data_item_id_    => data_item_id_,
                                                                             current_data_item_value_ => data_item_value_,
                                                                             wanted_data_item_id_     => 'NEW_SSCC');
         IF (new_sscc_ IS NOT NULL AND data_item_value_ = Gen_Yes_No_API.DB_YES) THEN
            Error_SYS.Record_General(lu_name_, 'NOTSPECWHENGEN: A new SSCC cannot be created when :P1 already has been specified manually.', Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), 'NEW_SSCC'));
         END IF;
      ELSIF (data_item_id_ = 'NEW_SSCC') THEN
         create_new_sscc_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_      => capture_session_id_,
                                                                                    current_data_item_id_    => data_item_id_,
                                                                                    current_data_item_value_ => data_item_value_,
                                                                                    wanted_data_item_id_     => 'CREATE_NEW_SSCC');
         IF (create_new_sscc_ = Gen_Yes_No_API.DB_YES AND data_item_value_ IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOTGENSSCCWHENSPEC: A SSCC cannot specified when :P1 is entered for :P2.', Gen_Yes_No_API.Decode(Gen_Yes_No_API.DB_YES), Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), 'CREATE_NEW_SSCC'));
         END IF;
         Sscc_Handling_Util_API.Validate_Sscc_Digits(data_item_value_);
      ELSIF (data_item_id_ IN ('PRINT_HANDLING_UNIT_LABEL', 'PRINT_CONTENT_LABEL', 'PRINT_SHIPMENT_LABEL')) THEN
         Gen_Yes_No_API.Exist_Db(data_item_value_);

      ELSIF(data_item_id_ LIKE 'GS1%') THEN
            Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      ELSIF (data_item_id_ IN ('NO_OF_HANDLING_UNIT_LABELS', 'NO_OF_CONTENT_LABELS', 'NO_OF_SHIPMENT_LABELS')) THEN
         IF (data_item_value_ <= 0 OR (data_item_value_ != ROUND(data_item_value_)) OR data_item_value_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_,'NUMBERPOSINT: :P1 must be an integer greater than 0.', Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_));
         END IF; 
      ELSIF (data_item_id_ IN ('WIDTH', 'HEIGHT', 'DEPTH', 'MANUAL_GROSS_WEIGHT', 'MANUAL_VOLUME')) THEN
         IF (data_item_value_ IS NOT NULL AND data_item_value_ <= 0) THEN  -- NULL values are ok but not zero or negative values
            Error_SYS.Record_General(lu_name_, 'VALUEGREATERTHENZERO: Value must be greater then zero.', NULL);
         END IF;
      ELSE

         Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, data_source_, capture_session_id_,
                            data_item_id_, data_item_value_);
         
         IF (data_item_id_ IN ('HANDLING_UNIT_ID')) THEN
            Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
         END IF;
         
         IF (data_item_id_ IN ('SHIPMENT_ID', 'HANDLING_UNIT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
            data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
            IF (data_item_id_ = 'HANDLING_UNIT_ID') THEN
               Handling_Unit_API.Exist(data_item_value_);
            END IF;


            IF (data_source_ = 'SHIPMENT') OR ((data_source_ = 'NULL_AND_SHIPMENT') AND (data_item_value_ IS NOT NULL)) THEN
               IF (data_source_ = 'SHIPMENT' AND data_item_id_ IN ('SHIPMENT_ID') AND data_item_value_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'SHIPITEMISNULL: :P1 is mandatory in this context and requires a value.', data_item_description_);
               END IF;

               $IF Component_Shpmnt_SYS.INSTALLED $THEN

                  Shipment_API.Record_With_Column_Value_Exist(record_exists_              => dummy_,
                                                              contract_                   => contract_,
                                                              shipment_id_                => shipment_id_,
                                                              handling_unit_id_           => NVL(handling_unit_id_, number_all_values_),
                                                              parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                              sscc_                       => sscc_,
                                                              alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                              column_name_                => data_item_id_,
                                                              column_value_               => data_item_value_,
                                                              column_description_         => data_item_description_,
                                                              sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___);
                  $ELSE
                     NULL;
                  $END           

            ELSIF (data_source_ = 'INVENT_AND_SHIPMENT') THEN

               -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
               local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
               Handling_Unit_API.Record_With_Column_Value_Exist(record_exists_                 => exists_in_invent_,
                                                                handling_unit_id_              => local_handling_unit_id_,
                                                                sscc_                          => sscc_,
                                                                alt_handling_unit_label_id_    => alt_handling_unit_label_id_,
                                                                column_name_                   => data_item_id_,
                                                                column_value_                  => data_item_value_,
                                                                column_description_            => data_item_description_,
                                                                sql_where_expression_          => Get_Sql_Invent_Where_Expr___,
                                                                raise_error_                   => FALSE);
               $IF Component_Shpmnt_SYS.INSTALLED $THEN
                  Shipment_API.Record_With_Column_Value_Exist(record_exists_              => exists_in_shipment_,
                                                              contract_                   => contract_,
                                                              shipment_id_                => shipment_id_,
                                                              handling_unit_id_           => NVL(handling_unit_id_, number_all_values_),
                                                              parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                              sscc_                       => sscc_,
                                                              alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                              column_name_                => data_item_id_,
                                                              column_value_               => data_item_value_,
                                                              column_description_         => data_item_description_,
                                                              sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___,
                                                              raise_error_                => FALSE);
               $END

               IF (NOT exists_in_invent_ AND NOT exists_in_shipment_) THEN
                  Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', data_item_description_, data_item_value_);
               END IF;
            ELSIF ((data_source_ = 'INVENT') AND (data_item_id_ NOT IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID'))) THEN

               -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
               local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
               Handling_Unit_API.Record_With_Column_Value_Exist(record_exists_                 => dummy_,
                                                                handling_unit_id_              => local_handling_unit_id_,
                                                                sscc_                          => sscc_,
                                                                alt_handling_unit_label_id_    => alt_handling_unit_label_id_,
                                                                column_name_                   => data_item_id_,
                                                                column_value_                  => data_item_value_,
                                                                column_description_            => data_item_description_,
                                                                sql_where_expression_          => Get_Sql_Invent_Where_Expr___);
            END IF;

         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Data_Item;
   
   
PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_          Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                      VARCHAR2(5);
   handling_unit_id_              NUMBER;
   shipment_id_                   NUMBER;
   parent_consol_shipment_id_     NUMBER;
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   data_source_                   VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, data_source_, capture_session_id_,
                         latest_data_item_id_, data_item_value_ => latest_data_item_value_, use_unique_values_ => TRUE);

      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
     
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN 

               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN

                  -- FILTER DATA ITEMS AS DETAILS
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                           shipment_id_                => shipment_id_,
                                           parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                           handling_unit_id_           => handling_unit_id_,
                                           sscc_                       => sscc_,
                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_);
               ELSE
                  -- RESIDUAL DATA ITEMS AS DETAILS
                  Add_Unique_Data_Item_Detail___(capture_session_id_         => capture_session_id_,
                                                 session_rec_                => session_rec_,
                                                 owning_data_item_id_        => latest_data_item_id_,
                                                 owning_data_item_value_     => latest_data_item_value_,
                                                 data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                                 contract_                   => contract_,
                                                 shipment_id_                => shipment_id_,
                                                 handling_unit_id_           => handling_unit_id_,
                                                 parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                 sscc_                       => sscc_,
                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_);
               END IF;
            ELSE 

               -- FEEDBACK ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('PARENT_HANDLING_UNIT_ID', 'PARENT_SSCC', 'PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                                    'HANDLING_UNIT_ACCESSORY_EXIST', 'HANDLING_UNIT_COMPOSITION',
                                                                    'HANDLING_UNIT_UOM_LENGTH','HANDLING_UNIT_NET_WEIGHT', 'HANDLING_UNIT_TARE_WEIGHT',
                                                                    'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT', 'HANDLING_UNIT_UOM_WEIGHT',
                                                                    'HANDLING_UNIT_OPERATIVE_VOLUME', 'HANDLING_UNIT_UOM_VOLUME', 
                                                                    'HANDLING_UNIT_GEN_SSCC', 'HANDLING_UNIT_MIX_OF_PART_NO_BLOCKED',
                                                                    'HANDLING_UNIT_MIX_OF_CONDITION_CODE_BLOCKED', 'HANDLING_UNIT_MIX_OF_LOT_BATCH_NUMBERS_BLOCKED',
                                                                    'HANDLING_UNIT_LOCATION_NO', 'HANDLING_UNIT_LOCATION_NO_DESC', 
                                                                    'HANDLING_UNIT_LOCATION_TYPE', 'HANDLING_UNIT_WAREHOUSE_ID', 'HANDLING_UNIT_BAY_ID',
                                                                    'HANDLING_UNIT_TIER_ID', 'HANDLING_UNIT_ROW_ID', 'HANDLING_UNIT_BIN_ID',
                                                                    'TOP_PARENT_HANDLING_UNIT_ID', 'TOP_PARENT_SSCC', 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                                    'HANDLING_UNIT_STRUCTURE_LEVEL', 'LEVEL_2_HANDLING_UNIT_ID', 'LEVEL_2_SSCC', 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID')) THEN

                  -- Feedback items related to handling unit
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                             owning_data_item_id_  => latest_data_item_id_,
                                                                             data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_     => handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PARENT_HANDLING_UNIT_DESC', 'HANDLING_UNIT_TYPE_ID', 'HANDLING_UNIT_TYPE_DESC',
                                                                       'HANDLING_UNIT_TYPE_CATEG_ID', 'HANDLING_UNIT_TYPE_CATEG_DESC', 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                                       'HANDLING_UNIT_TYPE_MAX_VOL_CAP', 'HANDLING_UNIT_TYPE_MAX_WGT_CAP', 'HANDLING_UNIT_TYPE_STACKABLE',
																	   'TOP_PARENT_HANDLING_UNIT_TYPE_ID', 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC')) THEN
                  -- Feedback items related to handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                              owning_data_item_id_ => latest_data_item_id_,
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_id_    => handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('CREATED_DATE', 'RECEIVER_ADDRESS_ID', 'RECEIVER_COUNTRY', 'RECEIVER_REFERENCE',
                                                                       'DELIVERY_TERMS', 'RECEIVER_DESCRIPTION', 'RECEIVER_ID', 'FORWARD_AGENT_ID',
                                                                       'LOAD_SEQUENCE_NO', 'ROUTE_ID', 'SENDER_REFERENCE', 'SHIPMENT_TYPE',
                                                                       'SHIP_DATE', 'SHIP_INVENTORY_LOCATION_NO', 'SHIP_VIA_CODE', 'SHIPMENT_STATUS',
                                                                       'SHIP_VIA_DESC')) THEN

                  $IF Component_Shpmnt_SYS.INSTALLED $THEN
                     -- Feedback items related to shipment
                     Data_Capture_Shpmnt_Util_API.Add_Details_For_Shipment(capture_session_id_        => capture_session_id_,
                                                                           owning_data_item_id_       => latest_data_item_id_,
                                                                           data_item_detail_id_       => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           shipment_id_               => shipment_id_);
                  $ELSE
                     NULL;
                  $END

               END IF;
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Add_Details_For_Latest_Item;   


FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2) RETURN BOOLEAN
IS
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   process_package_               VARCHAR2(30);
   contract_                      VARCHAR2(5);
   handling_unit_id_              NUMBER;
   shipment_id_                   NUMBER;
   parent_consol_shipment_id_     NUMBER;
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   data_source_                   VARCHAR2(30);
   fixed_value_is_applicable_     BOOLEAN := FALSE;
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      handling_unit_id_:= Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_ => FALSE);
      shipment_id_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'SHIPMENT_ID', session_rec_ , process_package_, use_applicable_ => FALSE);

      -- if predicted shipment_id_ or handling_unit_id_ is null then try fetch it with unique handling
      IF (shipment_id_ IS NULL OR handling_unit_id_ IS NULL) THEN
         Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 
                            data_source_, capture_session_id_, data_item_id_, use_applicable_ => FALSE);
         IF (handling_unit_id_ IS NULL OR handling_unit_id_ = number_all_values_) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, data_source_, 'HANDLING_UNIT_ID');
         END IF;   
         IF (shipment_id_ IS NULL OR shipment_id_ = number_all_values_) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, data_source_, 'SHIPMENT_ID');
         END IF;
      END IF;   

      IF data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID') AND 
         ((handling_unit_id_ IS NOT NULL AND shipment_id_ IS NULL AND 
         Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', data_item_id_)) OR 
        (shipment_id_ IS NULL AND 
          (Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'SHIPMENT_ID') OR 
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_)))) THEN
         fixed_value_is_applicable_ := TRUE;
      END IF;   

   $END

   RETURN fixed_value_is_applicable_;

END Fixed_Value_Is_Applicable;


