-----------------------------------------------------------------------------
--
--  Logical unit: RotablePoolFaManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210505  THPELK   FI21R2-1006, Modified Get_Fa_Pool_Insert_Trans_Id___() to use Public_Declarations_API.PARTCA_Serial_No_Tab. 
--  170303  DilMlk   Bug 133558, Modified method call Refresh_Prepostings by setting TRUE for replace_pre_posting_ parameter to replace 
--  170303           pre postings with project pre postings if it has value.
--  150709  SBalLK   Bug 123249, Modified Get_Fa_Pool_Insert_Trans_Id___() method to fetch insert transaction id from 'ADDFAPOOL' or 'IMPFAPOOL' pools
--  150512  IsSalk   KES-421, Passed new parameter to Inventory_Transaction_Hist_API.New().
--  150709           and if not found, then fetched from the 'REPFAPOOL' pool where serial number exist in the parameters.
--  150413  JeLise  Added handling_unit_id_ in calls to Inventory_Part_In_Stock_API.
--  121121  PraWlk   Bug 106889, Modified Get_Fa_Pool_Insert_Trans_Id___() to retrive the transaction id of of any other serial 
--  121121           connected to the same FA object when no transaction id is available for the specified serial.
--  100505  KRPELK   Merge Rose Method Documentation.
--  100420  MaRalk   Replaced reference-by-name notation instead of the in-line comments to method call
--  100420           Inventory_Transaction_Hist_API.New within Connect_Individual, Deplete, 
--  100420           Remove_Individual and Replenish methods.
--  091222  KAYOLK   Modified the method Connect_Individual() to have the correct case sensitive for the method calls.
------------------------------------------- 14.0.0 ----------------------------------------------
--  071108  NuVelk   Bug 68572, Modified Get_Fa_Pool_Insert_Trans_Id___ to correctly
--                   retrieve transaction_id when transaction_code is 'REPFAPOOL'.
--  060314  JoAnSe   Corrected retrieval of org_trans_cost_ in Deplete
--  051005  JoAnSe   Corrected Error_SYS call in Get_Fa_Pool_Insert_Trans_Id___
--  051004  JoAnSe   Corrected calls to Error_SYS
--  050928  JoAnSe   Merged DMC Changes below
--  **************   DMC End  *******************************************************************
--  050825  JoAnSe   Cleanup of parameters to Calc_Remaining_Inv_Value___
--  050704  JoAnSe   Implemented support for cost details in Deplete() also added new
--                   implementation methods Calc_Remaining_Inv_Value___ and
--                   Get_Fa_Pool_Insert_Trans_Id___
--  **************   DMC Begin  *******************************************************************
--  040921  RaKalk   Added another parameter(Catch_Quantity) to call to Inventory_Transaction_Hist_API.New.
--  040610  DiVelk   Modified Refresh_Prepostings.
--  040518  DaZaSe   Project Inventory: Added zero/null-parameters to call Inventory_Transaction_Hist_API.New, 
--                   change these parameters to real Activity_Seq and Project_Id values if this functionality uses Project Inventory.
--  040513  DiVelk   Modified function call in Refresh_Prepostings.
--  040507  DaZaSe   Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods, 
--                   the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
------------------------------------ 13.3.0 ----------------------------------
--  031030  AnLaSe   Call Id 99818, replaced call to Pre_Accounting_API.New() with call to 
--                   Pre_Accounting_API.Set_Pre_Accounting in method Refresh_Prepostings.
--  031014  PrJalk   Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  030707  JOHESE   Added check on inventory value in Connect_Individual
--  030702  JOHESE   Added Procedure Refresh_Prepostings
--  030627  AnLaSe   Added code for preposting M151 in ConnectIndividual.
--  030624  MaGulk   Removed valuation method & cost level validations from Connect_Individual, Replenish
--  030619  GEBOSE   Added procedures Remove_Individual and Replenish
--  030619  JOHESE   Modified procedure Deplete
--  030613  JOHESE   Modified procedure Connect_Individual
--  030523  MaGulk   Modified Connect_Individual for costing method validation
--  030520  MaGulk   Added Deplete
--  030520  MaGulk   Added Connect_Individual with basic validations
--  030516  MaGulk   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Fa_Pool_Insert_Trans_Id___
--   Retrive the transaction id of the transaction used when the specified
--   serial object was inserted into the specified FA Rotable Pool.
FUNCTION Get_Fa_Pool_Insert_Trans_Id___ (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   serial_no_    IN VARCHAR2,
   fa_object_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_trans_id_       NUMBER := -9999;
   repfapool_trans_id_   NUMBER;
   addfapool_trans_id_   NUMBER;
   impfapool_trans_id_   NUMBER;
   insert_pool_trans_id_ NUMBER;
   serial_no_tab_        Public_Declarations_API.PARTCA_Serial_No_Tab;
   rotable_part_pool_id_ VARCHAR2(20);
   company_              VARCHAR2(20);
BEGIN
   IF serial_no_ IS NOT NULL THEN
      addfapool_trans_id_ :=
        Inventory_Transaction_Hist_API.Get_Last_Serial_Trans_Of_Type(contract_,
                                                                     part_no_,
                                                                     serial_no_,
                                                                     fa_object_id_,
                                                                     NULL,
                                                                     NULL,
                                                                     NULL,
                                                                     'FIXED ASSET OBJECT',
                                                                     'ADDFAPOOL');
     
      impfapool_trans_id_ :=
        Inventory_Transaction_Hist_API.Get_Last_Serial_Trans_Of_Type(contract_,
                                                                     part_no_,
                                                                     serial_no_,
                                                                     fa_object_id_,
                                                                     NULL,
                                                                     NULL,
                                                                     NULL,
                                                                     'FIXED ASSET OBJECT',
                                                                     'IMPFAPOOL');
     
      insert_pool_trans_id_ := GREATEST( NVL(addfapool_trans_id_, dummy_trans_id_), NVL(impfapool_trans_id_, dummy_trans_id_));
      IF insert_pool_trans_id_ = dummy_trans_id_ THEN
         repfapool_trans_id_ :=
            Inventory_Transaction_Hist_API.Get_Last_Serial_Trans_Of_Type(contract_,
                                                                         part_no_,
                                                                         serial_no_,
                                                                         fa_object_id_,
                                                                         NULL,
                                                                         NULL,
                                                                         NULL,
                                                                         'FIXED ASSET OBJECT',
                                                                         'REPFAPOOL');
         insert_pool_trans_id_ := NVL(repfapool_trans_id_, dummy_trans_id_);
      END IF;
   END IF;
   
   IF NVL(insert_pool_trans_id_, dummy_trans_id_) = dummy_trans_id_ THEN
      company_              := Site_API.Get_Company(contract_);
      $IF (Component_Fixass_SYS.INSTALLED) $THEN 
          rotable_part_pool_id_ := Rotable_Pool_Fa_Object_API.Get_Rotable_Part_Pool_Id(company_, fa_object_id_); 
          serial_no_tab_        := Rotable_Pool_Fa_Object_API.Get_Serials_In_Pool(rotable_part_pool_id_); 
      $END

      IF (serial_no_tab_.COUNT = 0) THEN
         serial_no_tab_(1).serial_no := serial_no_;
      ELSE
         serial_no_tab_(serial_no_tab_.first - 1).serial_no := serial_no_;
      END IF;

      serial_no_tab_(serial_no_tab_.LAST + 1).serial_no := NULL;

      FOR i IN serial_no_tab_.FIRST..serial_no_tab_.LAST LOOP
        addfapool_trans_id_ :=
           Inventory_Transaction_Hist_API.Get_Last_Serial_Trans_Of_Type(contract_,
                                                                        part_no_,
                                                                        serial_no_tab_(i).serial_no,
                                                                        fa_object_id_,
                                                                        NULL,
                                                                        NULL,
                                                                        NULL,
                                                                        'FIXED ASSET OBJECT',
                                                                        'ADDFAPOOL');

        impfapool_trans_id_ :=
           Inventory_Transaction_Hist_API.Get_Last_Serial_Trans_Of_Type(contract_,
                                                                        part_no_,
                                                                        serial_no_tab_(i).serial_no,
                                                                        fa_object_id_,
                                                                        NULL,
                                                                        NULL,
                                                                        NULL,
                                                                        'FIXED ASSET OBJECT',
                                                                        'IMPFAPOOL');

        repfapool_trans_id_ :=
           Inventory_Transaction_Hist_API.Get_Last_Serial_Trans_Of_Type(contract_,
                                                                        part_no_,
                                                                        serial_no_tab_(i).serial_no,
                                                                        fa_object_id_,
                                                                        NULL,
                                                                        NULL,
                                                                        NULL,
                                                                        'FIXED ASSET OBJECT',
                                                                        'REPFAPOOL');

        -- Check which transaction was used when the object was inserted into the FA pool
        -- If all three transactions exist it should be the last transaction
        insert_pool_trans_id_ := GREATEST( NVL(addfapool_trans_id_, dummy_trans_id_),
                                           NVL(impfapool_trans_id_, dummy_trans_id_),
                                           NVL(repfapool_trans_id_, dummy_trans_id_));

      EXIT WHEN insert_pool_trans_id_ != dummy_trans_id_;
      END LOOP;
   END IF;
                                   
   IF (insert_pool_trans_id_ = dummy_trans_id_) THEN
      Error_SYS.Record_General(lu_name_, 'FA_TRANS_NOT_FOUND: Could not find transaction used when object was inserted into FA Rotable Pool');
   END IF;
   RETURN insert_pool_trans_id_;
END Get_Fa_Pool_Insert_Trans_Id___;


-- Calc_Remaining_Inv_Value___
--   Create and return a table of cost details with the remaining FA value
--   distributed on the cost details according to the distribution in the
--   table sent in
FUNCTION Calc_Remaining_Inv_Value___ (
   org_cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   org_trans_cost_      IN NUMBER,
   remaining_fa_value_  IN NUMBER) RETURN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab
IS
   new_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN
   FOR i_ IN org_cost_detail_tab_.FIRST .. org_cost_detail_tab_.LAST LOOP
      new_cost_detail_tab_(i_) := org_cost_detail_tab_(i_);

      IF (org_trans_cost_ != 0) THEN
         new_cost_detail_tab_(i_).unit_cost := (remaining_fa_value_/org_trans_cost_) *
                                                org_cost_detail_tab_(i_).unit_cost;
      END IF;
   END LOOP;

   RETURN new_cost_detail_tab_;
END Calc_Remaining_Inv_Value___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Connect_Individual
--   This method is used to connect an inventory part to a FA Object in
--   a FA Rotable Pool.
PROCEDURE Connect_Individual (
   company_              IN VARCHAR2,
   fa_object_id_         IN VARCHAR2,
   rotable_part_pool_id_ IN VARCHAR2,
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   location_no_          IN VARCHAR2,
   lot_batch_no_         IN VARCHAR2,
   serial_no_            IN VARCHAR2,
   eng_chg_level_        IN VARCHAR2,
   waiv_dev_rej_no_      IN VARCHAR2,
   handling_unit_id_     IN NUMBER,
   pre_accounting_id_    IN NUMBER,
   fa_status_            IN VARCHAR2,
   code_a_               IN VARCHAR2,
   code_b_               IN VARCHAR2,
   code_c_               IN VARCHAR2,
   code_d_               IN VARCHAR2,
   code_e_               IN VARCHAR2,
   code_f_               IN VARCHAR2,
   code_g_               IN VARCHAR2,
   code_h_               IN VARCHAR2,
   code_i_               IN VARCHAR2,
   code_j_               IN VARCHAR2 )
IS
   pac_                 VARCHAR2(50);
   transaction_id_      NUMBER;
   accounting_id_       NUMBER;
   transaction_value_   NUMBER;
   pre_posting_type_    VARCHAR2(50);
   transaction_code_    VARCHAR2(50);

   is_code_a_  NUMBER;
   is_code_b_  NUMBER;
   is_code_c_  NUMBER;
   is_code_d_  NUMBER;
   is_code_e_  NUMBER;
   is_code_f_  NUMBER;
   is_code_g_  NUMBER;
   is_code_h_  NUMBER;
   is_code_i_  NUMBER;
   is_code_j_  NUMBER;

   codepart_a_ VARCHAR2(10);
   codepart_b_ VARCHAR2(10);
   codepart_c_ VARCHAR2(10);
   codepart_d_ VARCHAR2(10);
   codepart_e_ VARCHAR2(10);
   codepart_f_ VARCHAR2(10);
   codepart_g_ VARCHAR2(10);
   codepart_h_ VARCHAR2(10);
   codepart_i_ VARCHAR2(10);
   codepart_j_ VARCHAR2(10);

   pre_posting_exist_ BOOLEAN := FALSE;
BEGIN
   -- Check that inventory value is greater then zero
   IF Inventory_Part_Unit_Cost_Api.Get_Inventory_Value_By_Method(
      contract_, part_no_, configuration_id_, lot_batch_no_, serial_no_) <= 0 THEN
      Error_SYS.Record_General(lu_name_, 'ZEROVALUE: The inventory value of the individual must be greater then zero.');
   END IF;

   -- Assign different transactions and posting types depending on the FA status
   -- Import does not work with pre posting
   IF fa_status_ = 'INVESTMENT' THEN
      transaction_code_ := 'ADDFAPOOL';
      pre_posting_type_ := 'M151';
   ELSIF fa_status_ = 'IMPORTALLOWED' THEN
      transaction_code_ := 'IMPFAPOOL';
   END IF;

   -- read Part Availability Control from pool
   pac_ := Rotable_Part_Pool_API.Get_Availability_Control_Id(rotable_part_pool_id_);

   -- modify InventoryPartInStock to add serial to the pool
   Inventory_Part_In_Stock_API.Modify_Rotable_Part_Pool_Id(contract_                     => contract_,
                                                           part_no_                      => part_no_,
                                                           configuration_id_             => configuration_id_,
                                                           location_no_                  => location_no_,
                                                           lot_batch_no_                 => lot_batch_no_,
                                                           serial_no_                    => serial_no_,
                                                           eng_chg_level_                => eng_chg_level_,
                                                           waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                                           activity_seq_                 => 0,
                                                           handling_unit_id_             => handling_unit_id_,
                                                           rotable_part_pool_id_         => rotable_part_pool_id_,
                                                           part_availability_control_id_ => pac_);

   IF fa_status_ = 'INVESTMENT' THEN
      Pre_Accounting_API.Get_Allowed_Codeparts(is_code_a_,
                                               is_code_b_,
                                               is_code_c_,
                                               is_code_d_,
                                               is_code_e_,
                                               is_code_f_,
                                               is_code_g_,
                                               is_code_h_,
                                               is_code_i_,
                                               is_code_j_,
                                               pre_posting_type_,
                                               NULL,
                                               company_);

      IF ((is_code_a_ = 1) AND
          (code_a_ IS NOT NULL)) THEN
         codepart_a_ := code_a_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_b_ = 1) AND
          (code_b_ IS NOT NULL)) THEN
         codepart_b_ := code_b_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_c_ = 1) AND
          (code_c_ IS NOT NULL)) THEN
         codepart_c_ := code_c_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_d_ = 1) AND
          (code_d_ IS NOT NULL)) THEN
         codepart_d_ := code_d_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_e_ = 1) AND
          (code_e_ IS NOT NULL)) THEN
         codepart_e_ := code_e_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_f_ = 1) AND
          (code_f_ IS NOT NULL)) THEN
         codepart_f_ := code_f_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_g_ = 1) AND
          (code_g_ IS NOT NULL)) THEN
         codepart_g_ := code_g_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_h_ = 1) AND
          (code_h_ IS NOT NULL)) THEN
         codepart_h_ := code_h_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_i_ = 1) AND
          (code_i_ IS NOT NULL)) THEN
         codepart_i_ := code_i_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_j_ = 1) AND
          (code_j_ IS NOT NULL)) THEN
         codepart_j_ := code_j_;
         pre_posting_exist_ := TRUE;
      END IF;

      -- Save preaccounting for M151
      IF (pre_posting_exist_) THEN
         Pre_Accounting_API.New(pre_accounting_id_,
                                codepart_a_,
                                codepart_b_,
                                codepart_c_,
                                codepart_d_,
                                codepart_e_,
                                codepart_f_,
                                codepart_g_,
                                codepart_h_,
                                codepart_i_,
                                codepart_j_,
                                company_,
                                pre_posting_type_,
                                contract_);
      END IF;
   END IF;

   -- Create new inventory transaction
   Inventory_Transaction_Hist_API.New(transaction_id_       => transaction_id_,
                                      accounting_id_        => accounting_id_,
                                      value_                => transaction_value_,
                                      transaction_code_     => transaction_code_,
                                      contract_             => contract_,
                                      part_no_              => part_no_,
                                      configuration_id_     => configuration_id_,
                                      location_no_          => location_no_,
                                      lot_batch_no_         => lot_batch_no_,
                                      serial_no_            => serial_no_,
                                      waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                      eng_chg_level_        => eng_chg_level_,
                                      activity_seq_         => 0,
                                      handling_unit_id_     => handling_unit_id_,
                                      project_id_           => NULL,
                                      source_ref1_          => fa_object_id_,
                                      source_ref2_          => NULL,
                                      source_ref3_          => company_,
                                      source_ref4_          => NULL,
                                      source_ref5_          => NULL,
                                      reject_code_          => NULL,
                                      price_                => Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(contract_,
                                                                                                                          part_no_,
                                                                                                                          configuration_id_,
                                                                                                                          lot_batch_no_,
                                                                                                                          serial_no_),
                                      quantity_             => 1,
                                      qty_reversed_         => 0,
                                      catch_quantity_       => NULL,
                                      source_               => NULL,
                                      source_ref_type_      => Order_Type_API.Decode('FIXED ASSET OBJECT'),
                                      owning_vendor_no_     => NULL);

   -- Do transaction booking
   Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_,
                                                         company_,
                                                         'N',
                                                         NULL );
END Connect_Individual;


-- Deplete
--   This method is used to deplete a FA Rotable Pool. This means that a
--   FA Object gets scrapped and the corresponding individual is removed
--   from the FA Rotable Pool to inventory with inventory value matching
--   Net BookValue of the FA Object.
PROCEDURE Deplete (
   company_                 IN VARCHAR2,
   fa_object_id_            IN VARCHAR2,
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   location_no_             IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   eng_chg_level_           IN VARCHAR2,
   waiv_dev_rej_no_         IN VARCHAR2,
   handling_unit_id_        IN NUMBER,
   remaining_fa_value_      IN NUMBER,
   pre_accounting_id_scrap_ IN NUMBER,
   wanted_pac_              IN VARCHAR2,
   code_a_                  IN VARCHAR2,
   code_b_                  IN VARCHAR2,
   code_c_                  IN VARCHAR2,
   code_d_                  IN VARCHAR2,
   code_e_                  IN VARCHAR2,
   code_f_                  IN VARCHAR2,
   code_g_                  IN VARCHAR2,
   code_h_                  IN VARCHAR2,
   code_i_                  IN VARCHAR2,
   code_j_                  IN VARCHAR2 )
IS
   transaction_id_       NUMBER;
   accounting_id_        NUMBER;
   transaction_value_    NUMBER;
   insert_pool_trans_id_ NUMBER;
   org_cost_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   new_cost_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   org_trans_cost_       NUMBER;
BEGIN
   -- Find the transaction that inserted the serial into the rotable pool
   insert_pool_trans_id_ := Get_Fa_Pool_Insert_Trans_Id___(contract_,
                                                           part_no_,
                                                           serial_no_,
                                                           fa_object_id_);

   -- Retrieve the cost details for the insert transaction
   org_cost_detail_tab_ := Inventory_Transaction_Hist_API.Get_Transaction_Cost_Details(insert_pool_trans_id_);
   org_trans_cost_      := Inventory_Transaction_Hist_API.Get_Cost(insert_pool_trans_id_);

   -- Calculate the remaining inventory value for the serial part based on the
   -- cost distribution on the insert transaction
   new_cost_detail_tab_ := Calc_Remaining_Inv_Value___(org_cost_detail_tab_,
                                                       org_trans_cost_,
                                                       remaining_fa_value_);

   Pre_Accounting_API.Insert_Pre_Accounting(pre_accounting_id_scrap_,
                                            code_a_,
                                            code_b_,
                                            code_c_,
                                            code_d_,
                                            code_e_,
                                            code_f_,
                                            code_g_,
                                            code_h_,
                                            code_i_,
                                            code_j_);

   Inventory_Part_Unit_Cost_API.Modify_Serial_Cost(contract_,
                                                   part_no_,
                                                   configuration_id_,
                                                   lot_batch_no_,
                                                   serial_no_,
                                                   new_cost_detail_tab_);

   -- Modify InventoryPartInStock to remove serial from the pool
   Inventory_Part_In_Stock_API.Modify_Rotable_Part_Pool_Id(contract_                     => contract_,
                                                           part_no_                      => part_no_,
                                                           configuration_id_             => configuration_id_,
                                                           location_no_                  => location_no_,
                                                           lot_batch_no_                 => lot_batch_no_,
                                                           serial_no_                    => serial_no_,
                                                           eng_chg_level_                => eng_chg_level_,
                                                           waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                                           activity_seq_                 => 0,
                                                           handling_unit_id_             => handling_unit_id_,
                                                           rotable_part_pool_id_         => NULL,
                                                           part_availability_control_id_ => wanted_pac_);

   -- Create new inventory transaction
   Inventory_Transaction_Hist_API.New(transaction_id_       => transaction_id_,
                                      accounting_id_        => accounting_id_,
                                      value_                => transaction_value_,
                                      transaction_code_     => 'SCRAPPOOL',
                                      contract_             => contract_,
                                      part_no_              => part_no_,
                                      configuration_id_     => configuration_id_,
                                      location_no_          => location_no_,
                                      lot_batch_no_         => lot_batch_no_,
                                      serial_no_            => serial_no_,
                                      waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                      eng_chg_level_        => eng_chg_level_,
                                      activity_seq_         => 0,
                                      handling_unit_id_     => handling_unit_id_,
                                      project_id_           => NULL,
                                      source_ref1_          => fa_object_id_,
                                      source_ref2_          => NULL,
                                      source_ref3_          => company_,
                                      source_ref4_          => NULL,
                                      source_ref5_          => NULL,
                                      reject_code_          => NULL,
                                      price_                => 0,                                                        
                                      quantity_             => 1,
                                      qty_reversed_         => 0,
                                      catch_quantity_       => NULL,
                                      source_               => NULL,
                                      source_ref_type_      => Order_Type_API.Decode('FIXED ASSET OBJECT'),
                                      owning_vendor_no_     => NULL );

   -- Do transaction booking
   Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_,
                                                         company_,
                                                         'N',
                                                         NULL );
END Deplete;


-- Remove_Individual
--   This method is used to disconnect an inventory part from FA Object in a
--   FA Rotable Pool and remove that part from FA Rotable Pool with the intention
--   that the removed individual should be replaced by another individual.
PROCEDURE Remove_Individual (
   company_          IN VARCHAR2,
   fa_object_id_     IN VARCHAR2,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   handling_unit_id_ IN NUMBER,
   wanted_pac_       IN VARCHAR2 )
IS
   transaction_id_      NUMBER;
   accounting_id_       NUMBER;
   value_               NUMBER;
   transaction_code_    VARCHAR2(50);
   new_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN
   -- Pass in an empty table as new_cost_detail_tab_,  this should create a default cost detail with 0 value.
   Inventory_Part_Unit_Cost_API.Modify_Serial_Cost(contract_,
                                                   part_no_,
                                                   configuration_id_,
                                                   lot_batch_no_,
                                                   serial_no_,
                                                   new_cost_detail_tab_);

   -- Remove individual from the FA pool
   Inventory_Part_In_Stock_API.Modify_Rotable_Part_Pool_Id(contract_                     => contract_,
                                                           part_no_                      => part_no_,
                                                           configuration_id_             => configuration_id_,
                                                           location_no_                  => location_no_,
                                                           lot_batch_no_                 => lot_batch_no_,
                                                           serial_no_                    => serial_no_,
                                                           eng_chg_level_                => eng_chg_level_,
                                                           waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                                           activity_seq_                 => 0,
                                                           handling_unit_id_             => handling_unit_id_,
                                                           rotable_part_pool_id_         => NULL,
                                                           part_availability_control_id_ => wanted_pac_);

   -- Create inventory transaction
   transaction_code_ := 'REMFAPOOL'; -- transaction code for remove
   
   Inventory_Transaction_Hist_API.New(transaction_id_       => transaction_id_,
                                      accounting_id_        => accounting_id_,
                                      value_                => value_,
                                      transaction_code_     => transaction_code_,
                                      contract_             => contract_,
                                      part_no_              => part_no_,
                                      configuration_id_     => configuration_id_,
                                      location_no_          => location_no_,
                                      lot_batch_no_         => lot_batch_no_,
                                      serial_no_            => serial_no_,
                                      waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                      eng_chg_level_        => eng_chg_level_,
                                      activity_seq_         => 0,
                                      handling_unit_id_     => handling_unit_id_,
                                      project_id_           => NULL,
                                      source_ref1_          => fa_object_id_,
                                      source_ref2_          => NULL,
                                      source_ref3_          => company_,
                                      source_ref4_          => NULL,
                                      source_ref5_          => NULL,
                                      reject_code_          => NULL,
                                      price_                => 0,                                                        
                                      quantity_             => 1,  -- for serials
                                      qty_reversed_         => 0,
                                      catch_quantity_       => NULL,
                                      source_               => NULL,
                                      source_ref_type_      => Order_Type_API.Decode ('FIXED ASSET OBJECT')
                                      );
   -- Do transaction booking
   Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_,
                                                         company_,
                                                         'N',
                                                         NULL );
END Remove_Individual;


-- Replenish
--   This method is used to connect an inventory part to FA Object in a FA
--   Rotable Pool in order to replenish that FA Rotable Pool.
PROCEDURE Replenish (
   company_              IN VARCHAR2,
   fa_object_id_         IN VARCHAR2,
   rotable_part_pool_id_ IN VARCHAR2,
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   location_no_          IN VARCHAR2,
   lot_batch_no_         IN VARCHAR2,
   serial_no_            IN VARCHAR2,
   eng_chg_level_        IN VARCHAR2,
   waiv_dev_rej_no_      IN VARCHAR2,
   handling_unit_id_     IN NUMBER )
IS
   pac_              VARCHAR2(50);
   transaction_id_   NUMBER;
   accounting_id_    NUMBER;
   value_            NUMBER;
   transaction_code_ VARCHAR2(50);
BEGIN
   -- check inventory value (must be zero for replenish)
   IF Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method
                  (contract_, part_no_, configuration_id_, lot_batch_no_, serial_no_ ) != 0 THEN
      Error_SYS.Record_General(lu_name_, 'COSTBYMETHODNOTZERO: Serial part cost should be zero when replenishing FA Rotable Pool');
   END IF;

   -- read Part Availability Control from pool
   pac_ := Rotable_Part_Pool_API.Get_Availability_Control_Id(rotable_part_pool_id_);

   -- modify serial part to replenish the fa-pool
   Inventory_Part_In_Stock_API.Modify_Rotable_Part_Pool_Id(contract_                     => contract_,
                                                           part_no_                      => part_no_,
                                                           configuration_id_             => configuration_id_,
                                                           location_no_                  => location_no_,
                                                           lot_batch_no_                 => lot_batch_no_,
                                                           serial_no_                    => serial_no_,
                                                           eng_chg_level_                => eng_chg_level_,
                                                           waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                                           activity_seq_                 => 0,
                                                           handling_unit_id_             => handling_unit_id_,
                                                           rotable_part_pool_id_         => rotable_part_pool_id_,
                                                           part_availability_control_id_ => pac_);

   -- Create inventory transaction
   transaction_code_ := 'REPFAPOOL'; -- transaction code for replenish

   Inventory_Transaction_Hist_API.New(transaction_id_       => transaction_id_,
                                      accounting_id_        => accounting_id_,
                                      value_                => value_,
                                      transaction_code_     => transaction_code_,
                                      contract_             => contract_,
                                      part_no_              => part_no_,
                                      configuration_id_     => configuration_id_,
                                      location_no_          => location_no_,
                                      lot_batch_no_         => lot_batch_no_,
                                      serial_no_            => serial_no_,
                                      waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                      eng_chg_level_        => eng_chg_level_,
                                      activity_seq_         => 0,
                                      handling_unit_id_     => handling_unit_id_,
                                      project_id_           => NULL,
                                      source_ref1_          => fa_object_id_,
                                      source_ref2_          => NULL,
                                      source_ref3_          => company_,
                                      source_ref4_          => NULL,
                                      source_ref5_          => NULL,
                                      reject_code_          => NULL,
                                      price_                => 0,                                                        
                                      quantity_             => 1, -- for serials
                                      qty_reversed_         => 0,
                                      catch_quantity_       => NULL,
                                      source_               => NULL,
                                      source_ref_type_      => Order_Type_API.Decode ('FIXED ASSET OBJECT')
                                      );
   -- Do transaction booking
   Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_,
                                                         company_,
                                                         'N',
                                                         NULL );
END Replenish;


PROCEDURE Refresh_Prepostings (
   company_           IN VARCHAR2,
   fa_object_id_      IN VARCHAR2,
   contract_          IN VARCHAR2,
   fa_status_         IN VARCHAR2,
   pre_accounting_id_ IN NUMBER,
   code_a_            IN VARCHAR2,
   code_b_            IN VARCHAR2,
   code_c_            IN VARCHAR2,
   code_d_            IN VARCHAR2,
   code_e_            IN VARCHAR2,
   code_f_            IN VARCHAR2,
   code_g_            IN VARCHAR2,
   code_h_            IN VARCHAR2,
   code_i_            IN VARCHAR2,
   code_j_            IN VARCHAR2 )
IS
   is_code_a_  NUMBER;
   is_code_b_  NUMBER;
   is_code_c_  NUMBER;
   is_code_d_  NUMBER;
   is_code_e_  NUMBER;
   is_code_f_  NUMBER;
   is_code_g_  NUMBER;
   is_code_h_  NUMBER;
   is_code_i_  NUMBER;
   is_code_j_  NUMBER;

   codepart_a_ VARCHAR2(10);
   codepart_b_ VARCHAR2(10);
   codepart_c_ VARCHAR2(10);
   codepart_d_ VARCHAR2(10);
   codepart_e_ VARCHAR2(10);
   codepart_f_ VARCHAR2(10);
   codepart_g_ VARCHAR2(10);
   codepart_h_ VARCHAR2(10);
   codepart_i_ VARCHAR2(10);
   codepart_j_ VARCHAR2(10);

   pre_posting_type_    VARCHAR2(50);
   pre_posting_exist_   BOOLEAN := FALSE;
BEGIN
   IF fa_status_ = 'INVESTMENT' THEN
      pre_posting_type_ := 'M151';

      Pre_Accounting_API.Get_Allowed_Codeparts(is_code_a_,
                                               is_code_b_,
                                               is_code_c_,
                                               is_code_d_,
                                               is_code_e_,
                                               is_code_f_,
                                               is_code_g_,
                                               is_code_h_,
                                               is_code_i_,
                                               is_code_j_,
                                               pre_posting_type_,
                                               NULL,
                                               company_);

      IF ((is_code_a_ = 1) AND
          (code_a_ IS NOT NULL)) THEN
         codepart_a_ := code_a_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_b_ = 1) AND
          (code_b_ IS NOT NULL)) THEN
         codepart_b_ := code_b_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_c_ = 1) AND
          (code_c_ IS NOT NULL)) THEN
         codepart_c_ := code_c_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_d_ = 1) AND
          (code_d_ IS NOT NULL)) THEN
         codepart_d_ := code_d_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_e_ = 1) AND
          (code_e_ IS NOT NULL)) THEN
         codepart_e_ := code_e_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_f_ = 1) AND
          (code_f_ IS NOT NULL)) THEN
         codepart_f_ := code_f_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_g_ = 1) AND
          (code_g_ IS NOT NULL)) THEN
         codepart_g_ := code_g_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_h_ = 1) AND
          (code_h_ IS NOT NULL)) THEN
         codepart_h_ := code_h_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_i_ = 1) AND
          (code_i_ IS NOT NULL)) THEN
         codepart_i_ := code_i_;
         pre_posting_exist_ := TRUE;
      END IF;
      IF ((is_code_j_ = 1) AND
          (code_j_ IS NOT NULL)) THEN
         codepart_j_ := code_j_;
         pre_posting_exist_ := TRUE;
      END IF;

      -- Save preaccounting for M151
      IF (pre_posting_exist_) THEN
         Pre_Accounting_API.Set_Pre_Posting(pre_accounting_id_,
                                            contract_,
                                            pre_posting_type_,
                                            codepart_a_,
                                            codepart_b_,
                                            codepart_c_,
                                            codepart_d_,
                                            codepart_e_,
                                            codepart_f_,
                                            codepart_g_,
                                            codepart_h_,
                                            codepart_i_,
                                            codepart_j_,
                                            NULL,
                                            'TRUE',
                                            'FALSE');
      END IF;
   END IF;
END Refresh_Prepostings;



