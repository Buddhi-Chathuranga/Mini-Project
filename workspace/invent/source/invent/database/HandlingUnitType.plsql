-----------------------------------------------------------------------------
--
--  Logical unit: HandlingUnitType
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  171024  MaRalk  STRSC-12063, Override method Insert___ in order to handle document text.
--  170508  LEPESE  LIM-11466, Allow zero values for lenght, weight and volume. Gathered all validations in Check_Common___.
--  170209  Maeelk  LIM-STRSC-5375, Added default value of PRINT_CONTENT_LABEL, PRINT_SHIPMENT_LABEL, NO_OF_CONTENT_LABELS and  NO_OF_SHIPMENT_LABELS to Check_Insert___.
--  161019  DaZase  LIM-9273, Added checks for NO_OF_CONTENT_LABELS and NO_OF_SHIPMENT_LABELS in Check_Insert___ and Check_Update___.
--  161012  UdGnlk  LIM-8759, Modified Prepare_Insert___() to add default values PRINT_CONTENT_LABEL_DB, NO_OF_CONTENT_LABELS,
--  161012          PRINT_SHIPMENT_LABEL_DB and NO_OF_SHIPMENT_LABELS.      
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150520  DaZase  COB-437, Removed 100 record description limitation in method Create_Data_Capture_Lov, 
--  150520          this will be replaced with a new configurable LOV record limitation in WADACO framework.
--  150305  RILASE  COB-21, Added Create_Data_Capture_Lov.
--  140219  MAHPLK  Added new attributes generate_sscc_no, print_label and no_of_handling_unit_labels.
--  130823  MaEelk  Made a call to Handling_Unit_API.Calculate_Shipment_Charges if a change is done to tare_weight or volume from Update___
--  130507  MaEelk  Added Get_Additive_Volume_Db. This would return the database value of the additive_volume
--  120815  JeLise  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Unit_Type_Rec IS RECORD (
   handling_unit_type_id HANDLING_UNIT_TYPE_TAB.handling_unit_type_id%TYPE);

TYPE Unit_Type_Tab IS TABLE OF Unit_Type_Rec
INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Weight___ (
   weight_ IN NUMBER )
IS
BEGIN

   IF (NVL(weight_, 0) < 0) THEN
      Error_SYS.Record_General(lu_name_, 'WEIGHT: Weight cannot be negative.');
   END IF;
END Check_Weight___;


PROCEDURE Check_Length___ (
   length_ IN NUMBER )
IS
BEGIN

   IF (NVL(length_, 0) < 0) THEN
      Error_SYS.Record_General(lu_name_, 'LENGTH: Length cannot be negative.');
   END IF;
END Check_Length___;


PROCEDURE Check_Volume___ (
   volume_ IN NUMBER )
IS
BEGIN

   IF (NVL(volume_, 0) < 0) THEN
      Error_SYS.Record_General(lu_name_, 'VOLUME: Volume cannot be negative.');
   END IF;
END Check_Volume___;


PROCEDURE Check_Uom___ (
   width_               IN NUMBER,
   height_              IN NUMBER,
   depth_               IN NUMBER,
   uom_for_length_      IN VARCHAR2,
   weight_              IN NUMBER,
   uom_for_weight_      IN VARCHAR2,
   volume_              IN NUMBER,
   uom_for_volume_      IN VARCHAR2,
   max_weight_capacity_ IN NUMBER,
   max_volume_capacity_ IN NUMBER )
IS
BEGIN
   -- Checks on Width, Height, Depth and UoM for Length
   IF (uom_for_length_ IS NOT NULL) THEN
      IF Iso_Unit_Type_API.Encode(ISO_UNIT_API.Get_Unit_Type(uom_for_length_)) != 'LENGTH' THEN
         Error_SYS.Record_General(lu_name_, 'UOMNOTLENTYPE: Field UoM for Length requires a unit of measure of type Length.');
      END IF;
   END IF;

   IF ((width_ IS NOT NULL) OR (height_ IS NOT NULL) OR (depth_ IS NOT NULL)) THEN
      IF (uom_for_length_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOUOMLENGTH: Field UoM for Length requires a value.');
      END IF;
   END IF;

   IF (uom_for_length_ IS NOT NULL) THEN
      IF (width_ IS NULL) THEN
         IF (height_ IS NULL) THEN
            IF (depth_ IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'NOLENGTHVAL: Any of the fields Width, Height or Depth requires a value if a UoM for Length is entered.');
            END IF;
         END IF;
      END IF;
   END IF;

   -- Checks on Weight and UoM for Weight
   IF ((weight_ IS NOT NULL) OR (max_weight_capacity_ IS NOT NULL)) THEN
      IF (uom_for_weight_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOUOMWEIGHT: Field UoM for Weight requires a value.');
      ELSE
         IF Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(uom_for_weight_)) != 'WEIGHT' THEN
            Error_SYS.Record_General(lu_name_, 'UOMNOTWEIGHTTYPE: Field UoM for Weight requires a unit of measure of type Weight.');
         END IF;
      END IF;
   END IF;

   IF (uom_for_weight_ IS NOT NULL) THEN
      IF (weight_ IS NULL) THEN
         IF (max_weight_capacity_ IS NULL) THEN 
            Error_SYS.Record_General('HandlingUnitType', 'NOWEIGHTVAL: Any of the fields Tare Weight or Max Weight Capacity requires a value if a UoM for Weight is entered.');
         END IF;
      END IF;
   END IF;
   
   -- Checks on Volume and UoM for Volume
   IF ((volume_ IS NOT NULL) OR (max_volume_capacity_ IS NOT NULL)) THEN
      IF (uom_for_volume_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOUOMVOLUME: Field UoM for Volume requires a value.');
      ELSE
         IF Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(uom_for_volume_)) != 'VOLUME' THEN
            Error_SYS.Record_General(lu_name_, 'UOMNOTVOLUMETYPE: Field UoM for Volume requires a unit of measure of type Volume.');
         END IF;
      END IF;
   END IF;

   IF (uom_for_volume_ IS NOT NULL) THEN
      IF (volume_ IS NULL) THEN
         IF (max_volume_capacity_ IS NULL) THEN 
            Error_SYS.Record_General('HandlingUnitType', 'NOVOLUMEVAL: Any of the fields Volume or Max Volume Capacity requires a value if a UoM for Volume is entered.');
         END IF;
      END IF;
   END IF;
END Check_Uom___;


PROCEDURE Check_Currency_Code___ (
   cost_          IN NUMBER,
   currency_code_ IN VARCHAR2 )
IS
BEGIN
   
   IF (cost_ IS NOT NULL AND currency_code_ IS NULL) THEN 
      Error_SYS.Record_General(lu_name_, 'NOCURRENCY: Field Currency Code requires a value.');
   END IF;
   IF (cost_ IS NULL AND currency_code_ IS NOT NULL) THEN 
      Error_SYS.Record_General('HandlingUnitType', 'NOCOST: The field Cost requires a value if a Currency Code is entered.');
   END IF;
END Check_Currency_Code___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ADDITIVE_VOLUME_DB',         Fnd_Boolean_API.db_false,       attr_);
   Client_SYS.Add_To_Attr('STACKABLE_DB',               Fnd_Boolean_API.db_false,       attr_);
   Client_SYS.Add_To_Attr('GENERATE_SSCC_NO_DB',        Fnd_Boolean_API.DB_FALSE,       attr_);
   Client_SYS.Add_To_Attr('PRINT_LABEL_DB',             Fnd_Boolean_API.DB_FALSE,       attr_);
   Client_SYS.Add_To_Attr('NO_OF_HANDLING_UNIT_LABELS', 1,                              attr_);
   Client_SYS.Add_To_Attr('PRINT_CONTENT_LABEL_DB',     Fnd_Boolean_API.DB_FALSE,       attr_);
   Client_SYS.Add_To_Attr('NO_OF_CONTENT_LABELS',       1,                              attr_);
   Client_SYS.Add_To_Attr('PRINT_SHIPMENT_LABEL_DB',    Fnd_Boolean_API.DB_FALSE,       attr_);
   Client_SYS.Add_To_Attr('NO_OF_SHIPMENT_LABELS',      1,                              attr_);
   Client_SYS.Add_To_Attr('USE_HU_RESERVATION_RANKING_DB', Fnd_Boolean_API.DB_FALSE,    attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT handling_unit_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
 IS
 BEGIN
    newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
    Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_ );
    super(objid_, objversion_, newrec_, attr_);    
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___; 
 
      
@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     HANDLING_UNIT_TYPE_TAB%ROWTYPE,
   newrec_     IN OUT HANDLING_UNIT_TYPE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   number_null_    NUMBER := -9999999;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Update Data in Basic Data Translations tab
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT',
                                                            'HandlingUnitType',
                                                            newrec_.handling_unit_type_id,
                                                            NULL,
                                                            newrec_.description,
                                                            oldrec_.description);
   IF (NVL(oldrec_.tare_weight, number_null_) != NVL(newrec_.tare_weight, number_null_)) OR
      (NVL(oldrec_.volume, number_null_) != NVL(newrec_.volume, number_null_)) THEN
      Handling_Unit_Ship_Util_API.Calc_Ship_Charges_By_Hu_Type(newrec_.handling_unit_type_id);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     handling_unit_type_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY handling_unit_type_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (Validate_SYS.Is_Changed(newrec_.width, oldrec_.width)) THEN
      Check_Length___(newrec_.width);
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.height, oldrec_.height)) THEN
      Check_Length___(newrec_.height);
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.depth, oldrec_.depth)) THEN
      Check_Length___(newrec_.depth);
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.tare_weight, oldrec_.tare_weight)) THEN
      Check_Weight___(newrec_.tare_weight);
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.volume, oldrec_.volume)) THEN
      Check_Volume___(newrec_.volume);
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.max_weight_capacity, oldrec_.max_weight_capacity)) THEN
      Check_Weight___(newrec_.max_weight_capacity);
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.max_volume_capacity, oldrec_.max_volume_capacity)) THEN
      Check_Volume___(newrec_.max_volume_capacity);
   END IF;
   
   IF ((Validate_SYS.Is_Changed(newrec_.width              , oldrec_.width              )) OR
       (Validate_SYS.Is_Changed(newrec_.height             , oldrec_.height             )) OR
       (Validate_SYS.Is_Changed(newrec_.depth              , oldrec_.depth              )) OR
       (Validate_SYS.Is_Changed(newrec_.uom_for_length     , oldrec_.uom_for_length     )) OR
       (Validate_SYS.Is_Changed(newrec_.tare_weight        , oldrec_.tare_weight        )) OR
       (Validate_SYS.Is_Changed(newrec_.uom_for_weight     , oldrec_.uom_for_weight     )) OR
       (Validate_SYS.Is_Changed(newrec_.volume             , oldrec_.volume             )) OR
       (Validate_SYS.Is_Changed(newrec_.uom_for_volume     , oldrec_.uom_for_volume     )) OR
       (Validate_SYS.Is_Changed(newrec_.max_weight_capacity, oldrec_.max_weight_capacity)) OR
       (Validate_SYS.Is_Changed(newrec_.max_volume_capacity, oldrec_.max_volume_capacity))) THEN
      Check_Uom___(newrec_.width, 
                   newrec_.height, 
                   newrec_.depth, 
                   newrec_.uom_for_length, 
                   newrec_.tare_weight, 
                   newrec_.uom_for_weight, 
                   newrec_.volume, 
                   newrec_.uom_for_volume,
                   newrec_.max_weight_capacity,
                   newrec_.max_volume_capacity);
   END IF;

   IF ((Validate_SYS.Is_Changed(newrec_.cost          , oldrec_.cost        )) OR 
       (Validate_SYS.Is_Changed(newrec_.currency_code, oldrec_.currency_code))) THEN 
      Check_Currency_Code___(newrec_.cost, newrec_.currency_code);
   END IF;

   IF (Validate_SYS.Is_Changed(newrec_.no_of_handling_unit_labels, oldrec_.no_of_handling_unit_labels) AND (newrec_.no_of_handling_unit_labels < 1)) THEN
      Error_SYS.Record_General(lu_name_, 'NOHULABELFORMAT: No of Handling Unit Labels must be greater than or equal to 1.');   
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.no_of_content_labels, oldrec_.no_of_content_labels) AND (newrec_.no_of_content_labels < 1)) THEN
      Error_SYS.Record_General(lu_name_, 'NOHUCONTENTLABELFORMAT: No of Handling Unit Content Labels must be greater than or equal to 1.');   
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.no_of_shipment_labels, oldrec_.no_of_shipment_labels) AND (newrec_.no_of_shipment_labels < 1)) THEN
      Error_SYS.Record_General(lu_name_, 'NOSHIPMENTHULABELFORMAT: No of Shipment Handling Unit Labels must be greater than or equal to 1.');   
   END IF;
   IF newrec_.transport_task_capacity != ROUND(newrec_.transport_task_capacity) OR SIGN(newrec_.transport_task_capacity) != 1 THEN
      Error_SYS.Record_General(lu_name_, 'TRANSTASKCAPNOTNEGINT: Transport task capacity must be a positive integer.');
   END IF;
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT handling_unit_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT(indrec_.additive_volume)THEN 
     newrec_.additive_volume := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT(indrec_.stackable)THEN 
     newrec_.stackable       := Fnd_Boolean_API.db_false;
   END IF;   
   IF NOT(indrec_.print_content_label) THEN
      newrec_.print_content_label := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   IF NOT(indrec_.no_of_content_labels) THEN
      newrec_.no_of_content_labels := 1;
   END IF;
   
   IF NOT(indrec_.print_shipment_label) THEN
      newrec_.print_shipment_label := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   IF NOT(indrec_.no_of_shipment_labels) THEN
      newrec_.no_of_shipment_labels := 1;
   END IF;
   
   super(newrec_, indrec_, attr_);
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Handl_Unit_Category_Desc (
   handling_unit_type_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   handling_unit_category_id_   HANDLING_UNIT_TYPE_TAB.handling_unit_category_id%TYPE;
   handling_unit_category_desc_ VARCHAR2(200);
BEGIN
   handling_unit_category_id_   := Get_Handling_Unit_Category_Id(handling_unit_type_id_);
   handling_unit_category_desc_ := Handling_Unit_Category_API.Get_Description(handling_unit_category_id_);
   
   RETURN handling_unit_category_desc_;
END Get_Handl_Unit_Category_Desc;

@UncheckedAccess
FUNCTION Get_Description (
   handling_unit_type_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ HANDLING_UNIT_TYPE_TAB.description%TYPE;
   CURSOR get_attr IS
      SELECT description
      FROM   handling_unit_type_tab
      WHERE  handling_unit_type_id = handling_unit_type_id_;
BEGIN
   temp_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT',
                                                                         'HandlingUnitType',
                                                                         handling_unit_type_id_), 1, 200);
   IF (temp_ IS NULL) THEN                                                                              
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Description;


-- This method is used by DataCaptCreateHndlUnit and DataCaptRegstrArrivals
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   capture_session_id_       IN NUMBER,
   column_name_              IN VARCHAR2,
   lov_type_db_              IN VARCHAR2 )
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_       Get_Lov_Values;
   stmt_                 VARCHAR2(2000);
   TYPE Lov_Value_Tab    IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_        Lov_Value_Tab;
   second_column_name_   VARCHAR2(200);
   second_column_value_  VARCHAR2(200);
   lov_item_description_ VARCHAR2(200);
   session_rec_          Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_   NUMBER;
   exit_lov_             BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('HANDLING_UNIT_TYPE', column_name_);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;
      stmt_ := stmt_  || ' FROM HANDLING_UNIT_TYPE
                           ORDER BY ' || column_name_ || ' ASC';
       
     @ApproveDynamicStatement(2015-03-05,RILASE)
     OPEN get_lov_values_ FOR stmt_;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('HANDLING_UNIT_TYPE_ID') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_ID_DESC';
            ELSE
               NULL;
         END CASE;
         
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'HANDLING_UNIT_TYPE_ID_DESC') THEN
                     second_column_value_ := Handling_Unit_Type_API.Get_Description(lov_value_tab_(i));
                  END IF;
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
                  ELSE
                     lov_item_description_ := NULL;
                  END IF;
               END IF;
            END IF;
            
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;