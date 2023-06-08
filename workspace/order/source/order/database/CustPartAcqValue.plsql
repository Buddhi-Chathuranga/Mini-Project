-----------------------------------------------------------------------------
--
--  Logical unit: CustPartAcqValue
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210118  MaEelk SC2020R1-12154, Modified Modify_Cust_Part_Acq_Value__ and replaced the calls to Unpack___, Check_Update___ and Update___ with Modify___.
--  210119         Modified New_Cust_Part_Acq_Value and replaced the calls to Unpack___, Check_Insert___ and Insert___ with New___.
--  140325  MeAblk Modified method Modify_Cust_Part_Acq_Value__ in order to correclty assign the value for CUST_PART_ACQ_VALUE_SOURCE_DB in Creating new CUST_PART_ACQ_VALUE_HIST record.
--  131118  RoJalk Hooks implementation - Modified the scope of acquisition_value, currency_code to be private.Removed the refernce for serial_no and lot_batch_no. 
--  110531  ShVese Moved the check for acquisition level from Modify_Cust_Part_Acq_Value__ to Set_Cust_Repair_Part_Acq_Value. 
--  110530  ShVese Handled setting of serial no to * for Receipt and Issue serial tracked parts in Set_Cust_Repair_Part_Acq_Value and New_Cust_Part_Acq_Value.
--  110512  ShVese Restructured Set_Cust_Repair_Part_Acq_Value and added logic to convert the acq value from supplier to base currency. 
--  110512         Also made sure that no conversion will take place if acq value is 0 or if supplier and customer currency is the same.
--  110427  THIMLK Restructured the method, Modify_Cust_Part_Acq_Value__() by adding the parameter,'contract_'and removing the DEFAULT NULL 
--  110427         clause from the parameter,'note_text_'.
--  110321  THIMLK Added new methods, Set_Cust_Repair_Part_Acq_Value(), Get_Acq_Val_For_Acq_Val_Level() and added new parameters 'convert_acq_value_' 
--  110321         and 'note_text_' in Modify_Cust_Part_Acq_Value__(), to handle Acquisition Value for Customer Owned Repair Parts.
--  110128  SHVESE Replaced the check for serial tracking and lot tracking with comparision to constants in 
--  110128         Is_Level_Exist___.
--  100519  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060410  IsWilk Enlarge Identity - Changed view comments of customer_no.      
--  ----------------------------- 13.4.0 -------------------------------------
--  060110  CsAmlk Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  050929  UsRalk Replaced calls to Currency_Rate_API with calls to Invoice_Library_API.
--  050922  SaMelk Removed unused variables.
--  040219  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
--  ----------------------------- 13.3.0 --------------------------------------
--  031030  KiSalk Call 109559 New parameter 'contract_' added and modified New_Cust_Part_Acq_Value to recalculate
--  031030         acq. value when the parameter contract_ is passed in, and modified Transfer_Cust_Part_Acq_Value accordingly.
--  031027  KiSalk Call 109360: Re-implemented methods Get_Acquisition_Value and Get_Currency_Code.
--  031027         Also '%' in Is_Level_Exist___ changed to '*'.
--  031027  KiSalk Call 109315: Changed the position of calling 'Cust_Part_Acq_Value_API.Get_Acquisition_Value'
--  031027        in Transfer_Cust_Part_Acq_Value.
--  031023  ChIwlk Modified comments of columns serial_no and lot_batch_no in view CUST_PART_ACQ_VALUE.
--  031021  KiSalk Call 108846: Modified Transfer_Cust_Part_Acq_Value to do less
--  031021          when cust. part acq. val. levels are 'NO_ACQ'.
--  030930  KiSalk Call 104375: In New_Cust_Part_Acq_Value and Transfer_Cust_Part_Acq_Value, removed codes
--  030930         that set lot batch no. to '*' when cust. part acquisition value evel= 'SERIAL_LEVEL_ACQ'.
--  030922  KiSalk Call 103744: Rounding of acq_value_ in Transfer_Cust_Part_Acq_Value removed.
--  030903  KiSalk GEDI206NK Owner Codes- Added Procedure Transfer_Cust_Part_Acq_Value.
--  030717  KiSalk Modified New_Cust_Part_Acq_Value to set serial no & lot batch no
--  030717          depending on customer part acq. value level.
--  030709  KiSalk Made Acquisition_Value public and added function 'Check_Exist'.
--  030502  SaNalk Modified the error message in procedure Unpack_Check_Update___.
--  030430  SaNalk Modified the error message in procedures Unpack_Check_Insert___ & Unpack_Check_Update___.
--  030429  SaNalk Added FUNCTION Is_Level_Exist___.Called this function in PROCEDURE New_Cust_Part_Acq_Value.
--  030425  SaNalk Added a check for negative Acqusition Values in procedures Unpack_Check_Update___ & Unpack_Check_Insert___.
--  030424  SaNalk Modified the properties of columns in VIEW.Added a check for '*' values in
--                 serial_no and lot_batch_no in PROCEDURE Unpack_Check_Insert___.
--  030423  SaNalk Modified the description comments of new methods.
--  030422  SaNalk Added Procedures New_Cust_Part_Acq_Value & Modify_Cust_Part_Acq_Value__.
--  030421  SaNalk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_false_                       CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;

db_lot_tracking_                CONSTANT VARCHAR2(12) := Part_Lot_Tracking_API.db_lot_tracking;

db_not_lot_tracking_            CONSTANT VARCHAR2(16) := Part_Lot_Tracking_API.db_not_lot_tracking;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Is_Level_Exist___ (
   customer_no_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   lot_track_code_db_    VARCHAR2(30);
   cust_acq_level_db_    VARCHAR2(20);
   dummy_                NUMBER;
   temp_serial_no_       VARCHAR2(50):= serial_no_;
   temp_lot_no_          VARCHAR2(20):= lot_batch_no_;
   part_cat_rec_         Part_Catalog_API.Public_Rec;


   CURSOR get_acq_level(temp_serial_no_ IN VARCHAR2, temp_lot_no_ IN VARCHAR2) IS
      SELECT 1
      FROM CUST_PART_ACQ_VALUE_TAB
      WHERE customer_no = customer_no_
      AND part_no = part_no_
      AND serial_no = temp_serial_no_
      AND lot_batch_no = temp_lot_no_ ;

BEGIN

   cust_acq_level_db_ := Cust_Part_Acq_Val_Level_API.Encode(Cust_Ord_Customer_API.Get_Cust_Part_Acq_Val_Level(customer_no_));
   part_cat_rec_ := Part_Catalog_API.Get(part_no_);
   
   lot_track_code_db_ := part_cat_rec_.lot_tracking_code;
    
   IF (cust_acq_level_db_ = 'PART_LEVEL_ACQ')THEN
      temp_serial_no_ := '*';
      temp_lot_no_ := '*';
   ELSIF (cust_acq_level_db_ = 'SERIAL_LEVEL_ACQ') THEN 
      IF (part_cat_rec_.receipt_issue_serial_track = db_false_) THEN
         temp_serial_no_ := '*';
      ELSIF (lot_track_code_db_ = db_not_lot_tracking_) THEN
         temp_lot_no_ := '*';
      END IF;
   ELSIF (cust_acq_level_db_ = 'LOT/BATCH_LEVEL_ACQ')  THEN
      IF (lot_track_code_db_ = db_not_lot_tracking_) THEN
         temp_lot_no_ := '*';
         temp_serial_no_ := '*';
      ELSIF ( lot_track_code_db_ = db_lot_tracking_) THEN
         temp_serial_no_ := '*';
      END IF;
   END IF;

   OPEN get_acq_level(temp_serial_no_,temp_lot_no_);
   FETCH get_acq_level INTO dummy_ ;
   IF (get_acq_level%FOUND) THEN
      CLOSE get_acq_level;
      RETURN(TRUE);
   END IF;
   CLOSE get_acq_level;
   RETURN(FALSE);

END Is_Level_Exist___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_part_acq_value_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF( newrec_.serial_no <> '*' ) THEN
      Part_Serial_Catalog_API.Exist(newrec_.part_no, newrec_.serial_no);
   END IF;
   
   IF( newrec_.lot_batch_no <> '*' ) THEN
      Lot_Batch_Master_API.Exist(newrec_.part_no, newrec_.lot_batch_no);
   END IF;
   
   -- Note: Check that Acqusition Value is not negative
   IF (newrec_.acquisition_value < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGACQVALUE: Acquisition Value should be equal or greater than to 0.');
   END IF;

END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_part_acq_value_tab%ROWTYPE,
   newrec_ IN OUT cust_part_acq_value_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   -- Note: Check that Acqusition Value is not negative
   IF (newrec_.acquisition_value < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGACQVALUE: Acquisition Value should be equal or greater than to 0.');
   END IF;

END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Modify_Cust_Part_Acq_Value__ (
   attr_                IN OUT VARCHAR2,
   customer_no_         IN VARCHAR2,
   part_no_             IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   contract_            IN VARCHAR2,
   note_text_           IN VARCHAR2,
   convert_acq_value_   IN VARCHAR2 )

IS
   newrec_              CUST_PART_ACQ_VALUE_TAB%ROWTYPE;
   cust_ord_cust_rec_   Cust_Ord_Customer_API.Public_Rec;
   currency_code_       VARCHAR2(3);
   acq_value_           NUMBER;
   new_lot_batch_no_    VARCHAR2(20) := lot_batch_no_;
   new_serial_no_       VARCHAR2(50) := serial_no_;  
   company_             SITE_TAB.company%TYPE;
   curr_type_           VARCHAR2(10);
   curr_conv_factor_    NUMBER;
   currency_rate_       NUMBER;
   site_date_           DATE;
BEGIN
   cust_ord_cust_rec_ := Cust_Ord_Customer_API.Get (customer_no_);
   newrec_ := Get_Object_By_Keys___(customer_no_,part_no_,new_serial_no_,new_lot_batch_no_);
   IF (convert_acq_value_ = 'TRUE') AND (contract_ IS NOT NULL) THEN
      acq_value_     := Client_SYS.Get_Item_Value('ACQUISITION_VALUE', attr_);

      currency_code_ := cust_ord_cust_rec_.currency_code;
      company_       := Site_API.Get_Company(contract_);
      site_date_     := Site_API.Get_Site_Date(contract_);

      Invoice_Library_API.Get_Currency_Rate_Defaults(
         currency_type_ => curr_type_,
         conv_factor_   => curr_conv_factor_,
         currency_rate_ => currency_rate_,
         company_       => company_,
         currency_code_ => currency_code_,
         date_          => site_date_,
         related_to_    => 'CUSTOMER',
         identity_      => customer_no_ );
      currency_rate_ := currency_rate_ / curr_conv_factor_;
      -- Acquisition value in customer currency
      acq_value_     := acq_value_/currency_rate_;

      newrec_.acquisition_value := acq_value_;
      newrec_.currency_code := currency_code_;
      newrec_.cust_part_acq_value_source := 'ESTIMATE';
   ELSE
      newrec_.acquisition_value := Client_SYS.Get_Item_Value('ACQUISITION_VALUE', attr_);

      IF (Client_SYS.Item_Exist('CURRENCY_CODE', attr_)) THEN
         newrec_.currency_code := Client_SYS.Get_Item_Value('CURRENCY_CODE', attr_);
      END IF;
      IF (Client_SYS.Item_Exist('CUST_PART_ACQ_VALUE_SOURCE_DB', attr_)) THEN 
         newrec_.cust_part_acq_value_source := Client_SYS.Get_Item_Value('CUST_PART_ACQ_VALUE_SOURCE_DB', attr_);   
      END IF;
   END IF;

   Modify___(newrec_);

   --Note: Create new CUST_PART_ACQ_VALUE_HIST record
   Cust_Part_Acq_Value_Hist_API.New_Cust_Part_Acq_Value_Hist__(customer_no_, part_no_, new_serial_no_, new_lot_batch_no_, 
                                                               newrec_.acquisition_value, newrec_.currency_code, newrec_.cust_part_acq_value_source, note_text_);

END Modify_Cust_Part_Acq_Value__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Acquisition_Value (
   customer_no_  IN VARCHAR2,
   part_no_      IN VARCHAR2,
   serial_no_    IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ CUST_PART_ACQ_VALUE_TAB.acquisition_value%TYPE;
   CURSOR get_attr(temp_serial_no_ IN VARCHAR2, temp_lot_batch_no_ IN VARCHAR2) IS
      SELECT acquisition_value
      FROM CUST_PART_ACQ_VALUE_TAB
      WHERE customer_no = customer_no_
      AND   part_no = part_no_
      AND   serial_no LIKE temp_serial_no_
      AND   lot_batch_no LIKE temp_lot_batch_no_ ;

   cust_ord_cust_rec_        Cust_Ord_Customer_API.Public_Rec;
BEGIN

   cust_ord_cust_rec_ := Cust_Ord_Customer_API.Get (customer_no_);
   IF cust_ord_cust_rec_.cust_part_acq_val_level !='NO_ACQ' THEN
      OPEN get_attr(serial_no_ , lot_batch_no_);
      FETCH get_attr INTO temp_;
      IF get_attr%NOTFOUND THEN
         CLOSE get_attr;
         OPEN get_attr('%' , lot_batch_no_);
         FETCH get_attr INTO temp_;
         IF get_attr%NOTFOUND THEN
            CLOSE get_attr;
            OPEN get_attr('%' , '%');
            FETCH get_attr INTO temp_;
         END IF;
      END IF;
      CLOSE get_attr;
   END IF;

   RETURN temp_;
END Get_Acquisition_Value;


@UncheckedAccess
FUNCTION Get_Currency_Code (
   customer_no_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUST_PART_ACQ_VALUE_TAB.currency_code%TYPE;
   CURSOR get_attr(temp_serial_no_ IN VARCHAR2, temp_lot_batch_no_ IN VARCHAR2) IS
      SELECT currency_code
      FROM CUST_PART_ACQ_VALUE_TAB
      WHERE customer_no = customer_no_
      AND   part_no = part_no_
      AND   serial_no LIKE temp_serial_no_
      AND   lot_batch_no LIKE temp_lot_batch_no_;
   cust_ord_cust_rec_        Cust_Ord_Customer_API.Public_Rec;

BEGIN
   cust_ord_cust_rec_ := Cust_Ord_Customer_API.Get (customer_no_);
   IF cust_ord_cust_rec_.cust_part_acq_val_level !='NO_ACQ' THEN
      OPEN get_attr(serial_no_ , lot_batch_no_);
      FETCH get_attr INTO temp_;
      IF get_attr%NOTFOUND THEN
         CLOSE get_attr;
         OPEN get_attr('%' , lot_batch_no_);
         FETCH get_attr INTO temp_;
         IF get_attr%NOTFOUND THEN
            CLOSE get_attr;
            OPEN get_attr('%' , '%');
            FETCH get_attr INTO temp_;
         END IF;
      END IF;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Currency_Code;


PROCEDURE New_Cust_Part_Acq_Value (
   customer_no_         IN VARCHAR2,
   part_no_             IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   acq_value_base_curr_ IN NUMBER,
   contract_            IN VARCHAR2 )
IS
   currency_code_          VARCHAR2(3);
   new_lot_batch_no_       VARCHAR2(20) := lot_batch_no_;
   new_serial_no_          VARCHAR2(50) := serial_no_;
   newrec_                 CUST_PART_ACQ_VALUE_TAB%ROWTYPE;
   cust_ord_cust_rec_      Cust_Ord_Customer_API.Public_Rec;
   acq_value_              NUMBER;
   company_                SITE_TAB.company%TYPE;
   curr_type_              VARCHAR2(10);
   curr_conv_factor_       NUMBER;
   currency_rate_          NUMBER;
   site_date_              DATE;
BEGIN
   cust_ord_cust_rec_ := Cust_Ord_Customer_API.Get (customer_no_);

   IF cust_ord_cust_rec_.cust_part_acq_val_level <> 'NO_ACQ' THEN
      --If part. acq. val. level is 'SERIAL_LEVEL_ACQ' and part is Lot Batch handled, record as in 'LOT/BATCH_LEVEL_ACQ' case.
      IF cust_ord_cust_rec_.cust_part_acq_val_level= 'PART_LEVEL_ACQ' THEN
         new_serial_no_:='*';
         new_lot_batch_no_:='*';
      ELSIF  cust_ord_cust_rec_.cust_part_acq_val_level= 'LOT/BATCH_LEVEL_ACQ' THEN
         new_serial_no_:='*';
      END IF;
      
      -- For receipt and issue serial tracked parts the serial no should always be * since it is not serial tracked in inventory
      IF Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(part_no_) THEN
         new_serial_no_:='*';
      END IF;
      
      IF NOT(Is_Level_Exist___(customer_no_, part_no_, new_serial_no_, new_lot_batch_no_)) THEN
         currency_code_ := cust_ord_cust_rec_.currency_code;
         IF (contract_ IS NOT NULL) THEN
            company_       := Site_API.Get_Company(contract_);
            site_date_     := Site_API.Get_Site_Date(contract_);
            Invoice_Library_API.Get_Currency_Rate_Defaults(
              currency_type_ => curr_type_,
              conv_factor_   => curr_conv_factor_,
              currency_rate_ => currency_rate_,
              company_       => company_,
              currency_code_ => currency_code_,
              date_          => site_date_,
              related_to_    => 'CUSTOMER',
              identity_      => customer_no_ );
              currency_rate_ := currency_rate_ / curr_conv_factor_;
              -- Acquisition value in customer currency
              acq_value_ := acq_value_base_curr_/currency_rate_;
         ELSE
            acq_value_ := acq_value_base_curr_;
         END IF;
         
         -- Note: Create new CUST_PART_ACQ_VALUE record
         newrec_.customer_no := customer_no_;
         newrec_.part_no := part_no_;
         newrec_.serial_no := new_serial_no_;
         newrec_.lot_batch_no := new_lot_batch_no_;
         newrec_.acquisition_value := acq_value_;
         newrec_.currency_code := currency_code_;
         newrec_.cust_part_acq_value_source := 'ESTIMATE';
         New___(newrec_);
         
         --Note: Create new CUST_PART_ACQ_VALUE_HIST record
         Cust_Part_Acq_Value_Hist_API.New_Cust_Part_Acq_Value_Hist__(customer_no_, part_no_, new_serial_no_, new_lot_batch_no_,
                                                                     acq_value_, currency_code_, 'ESTIMATE', NULL);
      END IF;
   END IF;
END New_Cust_Part_Acq_Value;


PROCEDURE Set_Cust_Repair_Part_Acq_Value (
   info_                OUT VARCHAR2,
   customer_no_         IN VARCHAR2,
   part_no_             IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   contract_            IN VARCHAR2,
   condition_code_      IN VARCHAR2 )
IS
   attr_                      VARCHAR2(2000);
   cust_ord_cust_rec_         Cust_Ord_Customer_API.Public_Rec;
   acq_value_                 NUMBER;
   condition_code_usage_      PART_CATALOG_TAB.condition_code_usage%TYPE;
   condition_code_price_      NUMBER;
   inv_condition_code_price_  NUMBER;
   pur_part_price_            NUMBER;   
   vendor_no_                 VARCHAR2(20);
   convert_acq_value_to_base_ VARCHAR2(10) := 'TRUE';
   convert_acq_value_         VARCHAR2(10) := 'TRUE';
   company_                   SITE_TAB.company%TYPE;
   curr_type_                 VARCHAR2(10);
   curr_conv_factor_          NUMBER;
   currency_rate_             NUMBER;
   supp_curr_code_            VARCHAR2(3);
   site_date_                 DATE;
   new_lot_batch_no_          VARCHAR2(20) := lot_batch_no_;
   new_serial_no_             VARCHAR2(50) := serial_no_;
   $IF Component_Purch_SYS.INSTALLED $THEN
      part_supl_rec_          Purchase_Part_Supplier_API.Public_Rec;
   $END   
BEGIN
   cust_ord_cust_rec_    := Cust_Ord_Customer_API.Get (customer_no_);

   IF cust_ord_cust_rec_.cust_part_acq_val_level <> 'NO_ACQ' THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         vendor_no_ := Supplier_API.Get_Cust_Vendor_No(customer_no_);   
         part_supl_rec_:= Purchase_Part_Supplier_API.Get( contract_, part_no_, vendor_no_);  
         pur_part_price_ :=  part_supl_rec_.list_price;
         supp_curr_code_ :=  part_supl_rec_.currency_code;
      $END
      
      IF (cust_ord_cust_rec_.currency_code = supp_curr_code_) THEN
         convert_acq_value_ := 'FALSE';
         convert_acq_value_to_base_ := 'FALSE';
      END IF;

      condition_code_usage_ := Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_);
      IF ( cust_ord_cust_rec_.cust_part_acq_val_level IN ('SERIAL_LEVEL_ACQ','LOT/BATCH_LEVEL_ACQ') AND condition_code_usage_ = 'ALLOW_COND_CODE') THEN

         inv_condition_code_price_ := Inv_Part_Config_Condition_API.Get_Estimated_Cost( condition_code_, contract_, part_no_, '*');
         $IF Component_Purch_SYS.INSTALLED $THEN 
            condition_code_price_ := Condition_Code_Pur_Price_API.Get_Price( condition_code_, vendor_no_, contract_, part_no_);
         $END
         IF ( condition_code_price_ > 0) THEN
            acq_value_ := condition_code_price_;
         ELSIF ( inv_condition_code_price_ > 0) THEN
            Client_SYS.Add_Info(lu_name_,'NO_COND_VAL: Although Customer :P1 is set up to store acquisition values, there is no value set on the supplier for purchase part record for this part at condition code :P2. The value set up on the inventory part will be used.',
                                customer_no_, condition_code_); 
            acq_value_ := inv_condition_code_price_;
            convert_acq_value_to_base_ := 'FALSE';
            convert_acq_value_ := 'TRUE';
         ELSE
            Client_SYS.Add_Info(lu_name_,'NO_ESTIMATE_COST_VAL: Customer :P1 is set up to store acquisition values. No value is set on the supplier for purchase part record for this part at condition code :P2, nor is there a value set up on the inventory part. The Acquisition Value will be set to zero.',
                                customer_no_, condition_code_); 
            acq_value_ := 0;
         END IF;
      END IF;

      IF ((cust_ord_cust_rec_.cust_part_acq_val_level IN ('SERIAL_LEVEL_ACQ','LOT/BATCH_LEVEL_ACQ') AND condition_code_usage_ = 'NOT_ALLOW_COND_CODE') OR cust_ord_cust_rec_.cust_part_acq_val_level = 'PART_LEVEL_ACQ') THEN

         IF ( pur_part_price_ > 0 ) THEN
            acq_value_ := pur_part_price_;
         ELSE
            Client_SYS.Add_Info(lu_name_,'NO_COND_VALUE: Although Customer :P1 is set up to store acquisition values, there is no value set on the supplier for purchase part record for this part, the Acquisition Value will be set to zero.',
                                customer_no_); 
            acq_value_ := 0;
         END IF;
      END IF;

      IF (acq_value_ = 0) THEN
         convert_acq_value_ := 'FALSE';
         convert_acq_value_to_base_ := 'FALSE';
      END IF;
   
      IF (convert_acq_value_to_base_ = 'TRUE') THEN
         -- the acquisition value needs to be converted from the supplier's currency to base currency first before it is converted later on from base to the customer's currency
         company_       := Site_API.Get_Company(contract_);
         --base_curr_code_ := Company_Finance_API.Get_Currency_Code(company_);
         site_date_     := Site_API.Get_Site_Date(contract_);

         Invoice_Library_API.Get_Currency_Rate_Defaults(
            currency_type_ => curr_type_,
            conv_factor_   => curr_conv_factor_,
            currency_rate_ => currency_rate_,
            company_       => company_,
            currency_code_ => supp_curr_code_,
            date_          => site_date_,
            related_to_    => 'SUPPLIER',
            identity_      => vendor_no_ );

         currency_rate_ := currency_rate_ / curr_conv_factor_;

         -- Acquisition value in base currency
         acq_value_     := acq_value_ * currency_rate_;
         
      END IF;

      -- For receipt and issue serial tracked parts the serial no should always be * since it is not serial tracked in inventory     
      IF (NOT(Is_Level_Exist___(customer_no_, part_no_, serial_no_, lot_batch_no_)) OR
         ((Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(part_no_)) AND NOT(Is_Level_Exist___(customer_no_, part_no_, '*', lot_batch_no_)))) THEN  
         IF (convert_acq_value_ = 'TRUE') THEN
            New_Cust_Part_Acq_Value(customer_no_, part_no_, serial_no_, lot_batch_no_, acq_value_, contract_);
         ELSE
            -- the acquistion value is already in the customer's currency so no need to convert it
            New_Cust_Part_Acq_Value(customer_no_, part_no_, serial_no_, lot_batch_no_, acq_value_, NULL);
         END IF;
      ELSE
         -- Update with new acquisition value.
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ACQUISITION_VALUE', acq_value_, attr_);

         --If part. acq. val. level is 'SERIAL_LEVEL_ACQ' and part is Lot Batch handled, record as in 'LOT/BATCH_LEVEL_ACQ' case.
         IF cust_ord_cust_rec_.cust_part_acq_val_level= 'PART_LEVEL_ACQ' THEN
            new_serial_no_:='*';
            new_lot_batch_no_:='*';
         ELSIF  cust_ord_cust_rec_.cust_part_acq_val_level= 'LOT/BATCH_LEVEL_ACQ' THEN
            new_serial_no_:='*';
         END IF;
         
         Modify_Cust_Part_Acq_Value__ ( attr_, customer_no_, part_no_, new_serial_no_, new_lot_batch_no_, contract_, NULL, convert_acq_value_); 
      END IF;
   END IF;
   info_ := info_ || Client_SYS.Get_All_Info;
END Set_Cust_Repair_Part_Acq_Value;


@UncheckedAccess
FUNCTION Get_Acq_Val_For_Acq_Val_Level (
   customer_no_  IN VARCHAR2,
   part_no_      IN VARCHAR2,
   serial_no_    IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   acq_value_            CUST_PART_ACQ_VALUE_TAB.acquisition_value%TYPE;
   cust_acq_level_db_    VARCHAR2(20);
   new_lot_batch_no_     VARCHAR2(20) := lot_batch_no_;
   new_serial_no_        VARCHAR2(50) := serial_no_;
BEGIN
   cust_acq_level_db_ := Cust_Part_Acq_Val_Level_API.Encode(Cust_Ord_Customer_API.Get_Cust_Part_Acq_Val_Level(customer_no_));
   IF cust_acq_level_db_= 'PART_LEVEL_ACQ' THEN
      new_serial_no_:='*';
      new_lot_batch_no_:='*';
   ELSIF cust_acq_level_db_= 'LOT/BATCH_LEVEL_ACQ' THEN
      new_serial_no_:='*';
   END IF;

   acq_value_ := Get_Acquisition_Value(customer_no_,
                                       part_no_,
                                       new_serial_no_,
                                       new_lot_batch_no_);
   RETURN acq_value_;

END Get_Acq_Val_For_Acq_Val_Level;


-- Check_Exist
--   Check if a specified instance exists.
--   Return TRUE if the instance exists, FALSE otherwise.
@UncheckedAccess
FUNCTION Check_Exist (
   customer_no_  IN VARCHAR2,
   part_no_      IN VARCHAR2,
   serial_no_    IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Check_Exist___(customer_no_, part_no_, serial_no_, lot_batch_no_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE Transfer_Cust_Part_Acq_Value (
   customer_no_          IN VARCHAR2,
   part_no_              IN VARCHAR2,
   serial_no_            IN VARCHAR2,
   lot_batch_no_         IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   contract_             IN VARCHAR2,
   from_owning_customer_ IN VARCHAR2 )
IS
   acq_value_                NUMBER;
   invent_value_             NUMBER;
   company_                  SITE_TAB.company%TYPE;
   curr_conv_factor_         NUMBER;
   curr_type_                VARCHAR2(10);
   from_currency_rate_       NUMBER;
   site_date_                DATE;
   to_cust_ord_cust_rec_     Cust_Ord_Customer_API.Public_Rec;
   from_cust_ord_cust_rec_   Cust_Ord_Customer_API.Public_Rec;
   temp_serial_no_           VARCHAR2(50);
   temp_lot_batch_no_        VARCHAR2(20);
   from_record_exists_       BOOLEAN;
BEGIN


   to_cust_ord_cust_rec_ := Cust_Ord_Customer_API.Get (customer_no_);

   IF to_cust_ord_cust_rec_.cust_part_acq_val_level !='NO_ACQ' THEN

      temp_serial_no_ := serial_no_;
      temp_lot_batch_no_ := lot_batch_no_;
      company_ := Site_API.Get_Company(contract_);
      site_date_ := Site_API.Get_Site_Date(contract_);
      from_cust_ord_cust_rec_ := Cust_Ord_Customer_API.Get (from_owning_customer_);

      --Get Acquisition Value of 'from customer' depending on part. acq. val. level of 'to customer'
      --If part. acq. val. level is 'SERIAL_LEVEL_ACQ' and part is Lot Batch handled, record should be as in 'LOT/BATCH_LEVEL_ACQ' case:
      IF to_cust_ord_cust_rec_.cust_part_acq_val_level ='PART_LEVEL_ACQ' THEN
         temp_lot_batch_no_ := '*';
         temp_serial_no_ := '*';
      ELSIF to_cust_ord_cust_rec_.cust_part_acq_val_level ='LOT/BATCH_LEVEL_ACQ' THEN
         temp_serial_no_ := '*';
      END IF;
      from_record_exists_ := Check_Exist___(from_owning_customer_, part_no_, temp_serial_no_, temp_lot_batch_no_)
                              AND from_cust_ord_cust_rec_.cust_part_acq_val_level !='NO_ACQ';
      IF from_record_exists_ THEN
         -- Calculate "from customer's" currency rate
         Invoice_Library_API.Get_Currency_Rate_Defaults(
            currency_type_ => curr_type_,
            conv_factor_   => curr_conv_factor_,
            currency_rate_ => from_currency_rate_,
            company_       => company_,
            currency_code_ => from_cust_ord_cust_rec_.currency_code,
            date_          => site_date_,
            related_to_    => 'CUSTOMER',
            identity_      => from_owning_customer_);
         from_currency_rate_ := from_currency_rate_ / curr_conv_factor_;

         -- "from customer's" part acquisition value in "from customer's" currency
         acq_value_ := Get_Acquisition_Value(from_owning_customer_,
                                             part_no_,
                                             temp_serial_no_,
                                             temp_lot_batch_no_);

         -- "from customer's" part acquisition value in base currency
         acq_value_ := acq_value_ * from_currency_rate_;
      ELSE
         invent_value_:=Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(contract_,
                                                                                   part_no_,
                                                                                   configuration_id_,
                                                                                   lot_batch_no_,
                                                                                   serial_no_);
         -- Inventory value in base currency
         acq_value_ := invent_value_;
      END IF;

      -- New Customer Part Acquisition Value
      --(checks and validations are done at New_Cust_Part_Acq_Value)
      New_Cust_Part_Acq_Value(customer_no_,
                              part_no_,
                              serial_no_,
                              lot_batch_no_,
                              acq_value_,
                              contract_);
   END IF;

END Transfer_Cust_Part_Acq_Value;



