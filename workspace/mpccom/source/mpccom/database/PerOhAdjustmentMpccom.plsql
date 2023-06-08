-----------------------------------------------------------------------------
--
--  Logical unit: PerOhAdjustmentMpccom
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200918  Dinklk  MF2020R1-7197, Added new parameter posting_group_id to Start_Manuf_Oh_Adjustment___.
--  200915  Dinklk  MF2020R1-7197, Modified Oh_Adjustment_Rec_To_Attr___ to add posting_group_id to attr.
--  200915          Modified Attr_To_Oh_Adjustment_Rec___ to extract posting_group_id from attr.
--  200915          Added posting_group_id as a parameter to Start_Invent_Oh_Adjustment___
--  130920  MAWILK  BLACK-566, Replaced Component_Pcm_SYS.
--  130809  AwWelk  TIBE-936, Removed global variables.
--  100810  PraWlk  Bug 90982, Added parameter oh_type_ to method Check_Adjustments_Allowed___ and modified it
--  100810          to exclude inventory part statistics check for overhead types Work Order Labor Overhead and
--  100810          Project Labor Overhead. Modified Start_Create_Adjustments__ to pass in value for parameter oh_type_.
--  100429  Ajpelk  Merge rose method documentation
--  091217  JENASE  Replaced calls to obsolete LU OperationHistoryInt.
--  091023  KAYOLK  Added Transaction_Statement_Approved Tag for ROLLBACK statements.
--  091006  ChFolk  Removed unused variables.
------------------------------------ 14.0.0 ---------------------------------
--  061221  RaKalk  Modified Get_Bucket_Type_From_Oh___ and Create_Adjustments_For_Oh__ to add SALES OVERHEAD type
--  060309  JoAnSe  Changes made so that each adjustment will be executed
--  060309          in its own background job.
--  060123  JaJalk  Added Assert safe annotation.
--  051219  DiAmlk  Added Start_Pcm_Oh_Adjustment___ and made a call to it inside the method
--                  Create_Adjustments__.(Relate to spec AMAD124 - Periodic Adjustment)
--  051212  JoAnSe  Added Start_Proj_Oh_Adjustment___ acceld from Create_Adjustments__
--  051123  JoAnSe  Added check in Start_Create_Adjustments__ for percentage < -100%
--  051123  JoAnSe  Made call to Inventory_Value_API.Get_Max_Year_Period dynamic
--  051121  MAJO    Added method Start_Manuf_Oh_Adjustment___.
--  051117  JoAnSe  Activated deferred call in Start_Create_Adjustments__
--  051102  JoAnSe  Added new checks and error handling.
--  051023  JoAnSe  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Adjustments_Allowed___
--   Make sure overhead adjustments are allowed at the specified date
PROCEDURE Check_Adjustments_Allowed___ (
   company_         IN VARCHAR2,
   accounting_year_ IN VARCHAR2,
   adjustment_date_ IN DATE,
   oh_type_         IN VARCHAR2 )
IS
   accounting_period_ NUMBER;

   CURSOR get_sites IS
      SELECT contract
      FROM site_public
      WHERE company = company_;

BEGIN

   -- Check if the accounting period is open at adjustment_date
   accounting_period_ := Accounting_Period_API.Get_Accounting_Period(company_, adjustment_date_);
   IF (Accounting_Period_API.Is_Period_Allowed(company_, accounting_period_, accounting_year_) = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'PERCLOSED: Accounting Period :P1 for Company :P2 and Accounting Year :P3 is not open for new postings',
                               accounting_period_, company_, accounting_year_);
   END IF;

   
   IF oh_type_ NOT IN ('WORK ORDER LABOR OVERHEAD','PROJECT LABOR OVERHEAD') THEN
      FOR next_site_ IN get_sites LOOP
         -- Check when inventory statistics was last executed for any site within the specified company
         Check_Statistics_Period___(next_site_.contract, adjustment_date_);
      END LOOP;
   END IF;

END Check_Adjustments_Allowed___;


-- Create_Adjustments___
--   Execute the process for creating periodic overhead adjustments
--   This method will start one background job for each adjustment
--   that shoudl be processed in the current 'batch'
PROCEDURE Create_Adjustments___ (
   adjustment_run_id_ IN NUMBER )
IS
   oh_adjustments_    Per_Oh_Adjustment_History_API.Oh_Adjustment_Tab;
   description_       VARCHAR2(2000);
   attr_              VARCHAR2(2000);
BEGIN

   -- Retrive the table with all adjustments to be made for this adjustment_run_id_
   oh_adjustments_ := Per_Oh_Adjustment_History_API.Get_Adjustments_To_Execute__(adjustment_run_id_);

   IF (oh_adjustments_.COUNT > 0) THEN
      FOR i IN oh_adjustments_.FIRST..oh_adjustments_.LAST LOOP

         attr_ := Oh_Adjustment_Rec_To_Attr___(oh_adjustments_(i));

         description_ := Language_SYS.Translate_Constant(lu_name_, 'ADJUSTOH: Create Overhead Adjustments for Company: '':P1'', OH Type: '':P2'', Cost Source ID: '':P3''',                                                          
                                                         p1_ => oh_adjustments_(i).company, 
                                                         p2_ => Per_Oh_Adjustment_Oh_Type_API.Decode(oh_adjustments_(i).oh_type),
                                                         p3_ => oh_adjustments_(i).cost_source_id );

         Transaction_SYS.Deferred_Call('PER_OH_ADJUSTMENT_MPCCOM_API.Create_Adjustments_For_Oh__', attr_, description_);
      END LOOP;
   END IF;

END Create_Adjustments___;


-- Start_Invent_Oh_Adjustment___
--   Start the overhead adjustment process for inventory transactions.
PROCEDURE Start_Invent_Oh_Adjustment___ (
   company_                 IN VARCHAR2,
   adjustment_id_           IN NUMBER,
   accounting_year_         IN NUMBER,
   cost_bucket_public_type_ IN VARCHAR2,
   cost_source_id_          IN VARCHAR2,
   posting_group_id_        IN VARCHAR2,
   adjustment_percentage_   IN NUMBER,
   adjustment_date_         IN DATE )
IS
BEGIN
   $IF (Component_Invent_SYS.INSTALLED) $THEN 
      Per_Oh_Adjustment_Invent_API.Create_Per_Oh_Adjustments(company_,
                                                             adjustment_id_,
                                                             accounting_year_,
                                                             cost_bucket_public_type_,
                                                             cost_source_id_,
                                                             posting_group_id_,
                                                             adjustment_percentage_,
                                                             adjustment_date_);
   $ELSE
       Error_SYS.Record_General('PerOhAdjustmentMpccom','NOINVENTPEROH: Periodic Oh Ajustment for Inventory is not installed. :P1 cannot be fetched from inst_PerOhAdjustmentInvent.',
                                  cost_bucket_public_type_);
   $END 
END Start_Invent_Oh_Adjustment___;


-- Start_Manuf_Oh_Adjustment___
--   Start the overhead adjustment process for manufacturing transactions.
PROCEDURE Start_Manuf_Oh_Adjustment___ (
   company_                 IN VARCHAR2,
   adjustment_id_           IN NUMBER,
   accounting_year_         IN NUMBER,
   cost_bucket_public_type_ IN VARCHAR2,
   cost_source_id_          IN VARCHAR2,
   posting_group_id         IN VARCHAR2,
   adjustment_percentage_   IN NUMBER,
   adjustment_date_         IN DATE )
IS
BEGIN

   IF cost_bucket_public_type_ = 'GENERAL' THEN
      $IF (Component_Shpord_SYS.INSTALLED)$THEN 
         Shop_Order_Oh_History_API.Create_Per_Oh_Adjustments(company_,
                                                             adjustment_id_,
                                                             accounting_year_,
                                                             cost_bucket_public_type_,
                                                             cost_source_id_,
                                                             posting_group_id,
                                                             adjustment_percentage_,
                                                             adjustment_date_);
      $ELSE
         Error_SYS.Record_General('PerOhAdjustmentMpccom','NOSOGENOH: Shop Order Overhead is not installed. :P1 cannot be fetched from ShopOrderOhHistory.',
                                  cost_bucket_public_type_);
      $END 
   ELSIF cost_bucket_public_type_ IN ('LABOROH', 'MACH1', 'MACH2', 'SUBCONTRACTING OH') THEN
      $IF (Component_Mfgstd_SYS.INSTALLED)$THEN
         Operation_History_Util_API.Create_Per_Oh_Adjustments(company_,
                                                              adjustment_id_,
                                                              accounting_year_,
                                                              cost_bucket_public_type_,
                                                              cost_source_id_,
                                                              posting_group_id,                                                             
                                                              adjustment_percentage_,
                                                              adjustment_date_);         
      $ELSE 
         Error_SYS.Record_General('PerOhAdjustmentMpccom','NOMFGSTDOH: Manufacturing standards is not installed. :P1 cannot be fetched from OperationHistoryUtil.',
                                  cost_bucket_public_type_);
      $END 
   END IF;   
END Start_Manuf_Oh_Adjustment___;


-- Start_Pcm_Oh_Adjustment___
--   Start the overhead adjustment process for labor transactions...
PROCEDURE Start_Pcm_Oh_Adjustment___ (
   company_                 IN VARCHAR2,
   adjustment_id_           IN NUMBER,
   accounting_year_         IN NUMBER,
   cost_source_id_          IN VARCHAR2,
   adjustment_percentage_   IN NUMBER,
   adjustment_date_         IN DATE )
IS
BEGIN
   $IF (Component_Wo_SYS.INSTALLED)$THEN 
      Jt_Task_Accounting_API.Create_Time_Ovh_Adjustments(company_,
                                                     adjustment_id_,
                                                     accounting_year_,
                                                     cost_source_id_,
                                                     adjustment_percentage_,
                                                     adjustment_date_);
   $ELSE 
      Error_SYS.Record_General('PerOhAdjustmentMpccom','NOPCMPEROH: Periodic Oh Adjustment for labor related costs is not possible to execute.');
   $END 
END Start_Pcm_Oh_Adjustment___;


-- Start_Proj_Oh_Adjustment___
--   Start the overhead adjustment process project related costs
PROCEDURE Start_Proj_Oh_Adjustment___ (
   company_                 IN VARCHAR2,
   adjustment_id_           IN NUMBER,
   accounting_year_         IN NUMBER,
   cost_source_id_          IN VARCHAR2,
   adjustment_percentage_   IN NUMBER,
   adjustment_date_         IN DATE )
IS
BEGIN
   $IF (Component_Prjrep_SYS.INSTALLED)$THEN 
      Project_Trans_Posting_API.Create_Per_Oh_Adjustments(company_,
                                                          adjustment_id_,
                                                          accounting_year_,
                                                          cost_source_id_,
                                                          adjustment_percentage_,
                                                          adjustment_date_);
   $ELSE 
      Error_SYS.Record_General('PerOhAdjustmentMpccom','NOPROJPEROH: Periodic Oh Ajustment for Project related costs is not possible to execute.');
   $END 
END Start_Proj_Oh_Adjustment___;


-- Get_Acc_Year_Last_Date___
--   Return the last date in the specified accounting year.
FUNCTION Get_Acc_Year_Last_Date___ (
   company_         IN VARCHAR2,
   accounting_year_ IN NUMBER ) RETURN DATE
IS
   last_period_ NUMBER;
   last_date_   DATE;
BEGIN
   last_period_ := Accounting_Period_API.Get_Max_Period(company_, accounting_year_);
   last_date_   := Accounting_Period_API.Get_Date_Until(company_, accounting_year_, last_period_);
   RETURN last_date_;
END Get_Acc_Year_Last_Date___;


-- Check_Statistics_Period___
--   Make sure that the inventory statistics period is still open at
--   the date decided for the adjustment postings
PROCEDURE Check_Statistics_Period___ (
   contract_        IN VARCHAR2,
   adjustment_date_ IN DATE )
IS
   latest_stat_year_no_        NUMBER;
   latest_stat_period_no_      NUMBER;
   latest_year_period_no_      NUMBER;
   stat_period_new_            NUMBER;
   stat_year_new_              NUMBER;
   new_year_period_no_         NUMBER;

   stmt_                       VARCHAR2(2000);

BEGIN

   -- Retrieve the last statistics year and period
   stmt_ := 'BEGIN
               Inventory_Value_API.Get_Max_Year_Period(:latest_stat_year_no,
                                                       :latest_stat_period_no,
                                                       :contract);
             END;';
   @ApproveDynamicStatement(2006-01-23,JaJalk)
   EXECUTE IMMEDIATE stmt_
      USING OUT latest_stat_year_no_,
            OUT latest_stat_period_no_,
            IN  contract_;

   latest_year_period_no_ := ((NVL(latest_stat_year_no_,0) * 100) + NVL(latest_stat_period_no_,0));

   -- Check the period for adjustment date
   Statistic_Period_API.Get_Statistic_Period(stat_year_new_,
                                             stat_period_new_,
                                             adjustment_date_);

   new_year_period_no_ := ((NVL(stat_year_new_,0) * 100) + NVL(stat_period_new_,0));

   -- Adjustments cannot be made to a period in the past
   IF (new_year_period_no_ < latest_year_period_no_) THEN
      Error_SYS.Record_General(lu_name_,
                               'ILLEGALPERIOD: Inventory value statistics period for date :P1 on site :P2 has been closed, chose Current Date as date for new postings',
                               adjustment_date_, contract_);
   END IF;

END Check_Statistics_Period___;


-- Get_Bucket_Type_From_Oh___
--   Return the cost bucket public type corresponding to the specified
--   overhead type.
FUNCTION Get_Bucket_Type_From_Oh___ (
   oh_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cost_bucket_public_type_ VARCHAR2(20);
BEGIN

   cost_bucket_public_type_ :=
      CASE oh_type_
         WHEN 'DELIVERY OVERHEAD' THEN 'DELOH'
         WHEN 'MATERIAL OVERHEAD' THEN 'MATOH'
         WHEN 'GENERAL OVERHEAD' THEN 'GENERAL'
         WHEN 'SHOP ORDER LABOR OVERHEAD' THEN 'LABOROH'
         WHEN 'MACHINE OVERHEAD 1' THEN 'MACH1'
         WHEN 'MACHINE OVERHEAD 2' THEN 'MACH2'
         WHEN 'SUB CONTRACT OVERHEAD' THEN 'SUBCONTRACTING OH'
         WHEN 'SALES OVERHEAD' THEN 'SALESOH'
         ELSE NULL
      END;

   RETURN cost_bucket_public_type_;

END Get_Bucket_Type_From_Oh___;


-- Oh_Adjustment_Rec_To_Attr___
--   Converts an oh adjustment record into an attribute string.
FUNCTION Oh_Adjustment_Rec_To_Attr___ (
   oh_adjustment_rec_ IN Per_Oh_Adjustment_History_API.Oh_Adjustment_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(2000);
BEGIN

   Client_SYS.Add_To_Attr('ADJUSTMENT_ID',         oh_adjustment_rec_.adjustment_id, attr_);
   Client_SYS.Add_To_Attr('COMPANY',               oh_adjustment_rec_.company, attr_);
   Client_SYS.Add_To_Attr('ACCOUNTING_YEAR',       oh_adjustment_rec_.accounting_year, attr_);
   Client_SYS.Add_To_Attr('OH_TYPE',               oh_adjustment_rec_.oh_type, attr_);
   Client_SYS.Add_To_Attr('COST_SOURCE_ID',        oh_adjustment_rec_.cost_source_id, attr_);
   Client_SYS.Add_To_Attr('POSTING_GROUP_ID',      oh_adjustment_rec_.posting_group_id, attr_);
   Client_SYS.Add_To_Attr('ADJUSTMENT_PERCENTAGE', oh_adjustment_rec_.adjustment_percentage, attr_);
   Client_SYS.Add_To_Attr('DATING_OF_POSTINGS',    oh_adjustment_rec_.dating_of_postings, attr_);

   RETURN (attr_);

END Oh_Adjustment_Rec_To_Attr___;


FUNCTION Attr_To_Oh_Adjustment_Rec___ (
   attr_ IN VARCHAR2 ) RETURN Per_Oh_Adjustment_History_API.Oh_Adjustment_Rec
IS
   oh_adjustment_rec_ Per_Oh_Adjustment_History_API.Oh_Adjustment_Rec;
BEGIN

   oh_adjustment_rec_.adjustment_id := 
      Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ADJUSTMENT_ID', attr_));
   oh_adjustment_rec_.company :=
      Client_SYS.Get_Item_Value('COMPANY', attr_);
   oh_adjustment_rec_.accounting_year := 
      Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ACCOUNTING_YEAR', attr_));
   oh_adjustment_rec_.oh_type :=
      Client_SYS.Get_Item_Value('OH_TYPE', attr_);
   oh_adjustment_rec_.cost_source_id :=
      Client_SYS.Get_Item_Value('COST_SOURCE_ID', attr_);
   oh_adjustment_rec_.posting_group_id :=
      Client_SYS.Get_Item_Value('POSTING_GROUP_ID', attr_);
   oh_adjustment_rec_.adjustment_percentage :=
      Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ADJUSTMENT_PERCENTAGE', attr_));
   oh_adjustment_rec_.dating_of_postings := 
      Client_SYS.Get_Item_Value('DATING_OF_POSTINGS', attr_);

   RETURN (oh_adjustment_rec_);

END Attr_To_Oh_Adjustment_Rec___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Start_Create_Adjustments__
--   Entry level method used to start the process for periodic overhead
--   adjustments and for the adjustment creation process
--   Picks up all records associated with the specified AdjustmentRunId
--   from PerOhAdjustmentHistory and executes the adjustments one by one.
PROCEDURE Start_Create_Adjustments__ (
   adjustment_run_id_ IN NUMBER )
IS
   oh_adjustments_   Per_Oh_Adjustment_History_API.Oh_Adjustment_Tab;
   adjustment_date_  DATE;
BEGIN

   -- Retrive the table with all adjustments to be made for this adjustment_run_id_
   oh_adjustments_ := Per_Oh_Adjustment_History_API.Get_Adjustments_To_Execute__(adjustment_run_id_);

   IF (oh_adjustments_.COUNT > 0) THEN
      FOR i IN oh_adjustments_.FIRST..oh_adjustments_.LAST LOOP

         IF (oh_adjustments_(i).dating_of_postings = 'CURRENT DATE') THEN
            adjustment_date_ := SYSDATE;
         ELSE
            adjustment_date_ := Get_Acc_Year_Last_Date___(oh_adjustments_(i).company,
                                                          oh_adjustments_(i).accounting_year);
            IF (TRUNC(adjustment_date_) > trunc(SYSDATE)) THEN
               Error_SYS.Record_General(lu_name_, 'WRONGDATETYPE: Last date of accounting year :P1 has not been reached yet, choose :P2 as dating for new postings',
                                        oh_adjustments_(i).accounting_year, Per_Oh_Adjustment_Dating_API.Decode('CURRENT DATE'));
            END IF;

         END IF;
         
         IF (oh_adjustments_(i).adjustment_percentage < -1) THEN
            Error_SYS.Record_General(lu_name_, 'WRONGPERCENTAGE: Adjustment Percentage less than -100% is not allowed');
         END IF;
         
         IF oh_adjustments_(i).cost_source_id IS NOT NULL AND oh_adjustments_(i).posting_group_id IS NOT NULL THEN
            Error_SYS.Record_General(lu_name_, 'COSTPOSTINGNOTNULL: Either Cost Source ID or Posting Group ID can have a value for overhead type :P1',
                                                Per_Oh_Adjustment_Oh_Type_API.Decode(oh_adjustments_(i).oh_type));
         ELSIF oh_adjustments_(i).cost_source_id IS NULL AND oh_adjustments_(i).posting_group_id IS NULL THEN
            Error_SYS.Record_General(lu_name_, 'COSTPOSTINGNULL: Either Cost Source ID or Posting Group ID should have a value for overhead type :P1',
                                                Per_Oh_Adjustment_Oh_Type_API.Decode(oh_adjustments_(i).oh_type));
         END IF;

         -- First check that all adjustments are still possible to make
         Check_Adjustments_Allowed___(oh_adjustments_(i).company,
                                      oh_adjustments_(i).accounting_year,
                                      adjustment_date_,
                                      oh_adjustments_(i).oh_type );

      END LOOP;

      Create_Adjustments___(adjustment_run_id_);
   END IF;

END Start_Create_Adjustments__;


-- Create_Adjustments_For_Oh__
--   Execute the process for creating periodic overhead adjustments for one
PROCEDURE Create_Adjustments_For_Oh__ (
   attr_ IN VARCHAR2 )
IS
   oh_adjustment_rec_ Per_Oh_Adjustment_History_API.Oh_Adjustment_Rec;
   bucket_type_       VARCHAR2(20);
   adjustment_date_   DATE;
   error_message_     VARCHAR2(2000);

BEGIN

   oh_adjustment_rec_ := Attr_To_Oh_Adjustment_Rec___(attr_);

   -- Get the bucket type corresponding to this overhead type
   bucket_type_ := Get_Bucket_Type_From_Oh___(oh_adjustment_rec_.oh_type);

   IF (oh_adjustment_rec_.dating_of_postings = 'CURRENT DATE') THEN
      adjustment_date_ := SYSDATE;
   ELSE
      adjustment_date_ := Get_Acc_Year_Last_Date___(oh_adjustment_rec_.company, 
                                                    oh_adjustment_rec_.accounting_year);
   END IF;

   CASE
      WHEN oh_adjustment_rec_.oh_type IN ('DELIVERY OVERHEAD', 'MATERIAL OVERHEAD', 'SALES OVERHEAD') THEN
         -- Adjust only inventory related costs
         Start_Invent_Oh_Adjustment___(oh_adjustment_rec_.company,
                                       oh_adjustment_rec_.adjustment_id,
                                       oh_adjustment_rec_.accounting_year,
                                       bucket_type_,
                                       oh_adjustment_rec_.cost_source_id,
                                       oh_adjustment_rec_.posting_group_id,
                                       oh_adjustment_rec_.adjustment_percentage,
                                       adjustment_date_);

      WHEN oh_adjustment_rec_.oh_type IN ('GENERAL OVERHEAD', 'SHOP ORDER LABOR OVERHEAD',
                                          'MACHINE OVERHEAD 1', 'MACHINE OVERHEAD 2',
                                          'SUB CONTRACT OVERHEAD' ) THEN
         -- Adjust inventory and manufacturing related costs
         -- Level machine/labor/general oh
         Start_Manuf_Oh_Adjustment___( oh_adjustment_rec_.company,
                        oh_adjustment_rec_.adjustment_id,
                        oh_adjustment_rec_.accounting_year,
                        bucket_type_,
                        oh_adjustment_rec_.cost_source_id,
                        oh_adjustment_rec_.posting_group_id,
                        oh_adjustment_rec_.adjustment_percentage,
                        adjustment_date_);

         -- Accum machine/labor/general oh
         Start_Invent_Oh_Adjustment___(oh_adjustment_rec_.company,
                                       oh_adjustment_rec_.adjustment_id,
                                       oh_adjustment_rec_.accounting_year,
                                       bucket_type_,
                                       oh_adjustment_rec_.cost_source_id,
                                       oh_adjustment_rec_.posting_group_id,
                                       oh_adjustment_rec_.adjustment_percentage,
                                       adjustment_date_);

      WHEN oh_adjustment_rec_.oh_type = 'WORK ORDER LABOR OVERHEAD' THEN
         -- Adjust work order related costs
         Start_Pcm_Oh_Adjustment___(oh_adjustment_rec_.company,
                                    oh_adjustment_rec_.adjustment_id,
                                    oh_adjustment_rec_.accounting_year,
                                    oh_adjustment_rec_.cost_source_id,
                                    oh_adjustment_rec_.adjustment_percentage,
                                    adjustment_date_); 

      WHEN oh_adjustment_rec_.oh_type = 'PROJECT LABOR OVERHEAD' THEN
         -- Adjust Project labor related costs
         Start_Proj_Oh_Adjustment___(oh_adjustment_rec_.company,
                                     oh_adjustment_rec_.adjustment_id,
                                     oh_adjustment_rec_.accounting_year,
                                     oh_adjustment_rec_.cost_source_id,
                                     oh_adjustment_rec_.adjustment_percentage,
                                     adjustment_date_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'ILLOHTYPE: Design time error oh_type :P1 not handled', oh_adjustment_rec_.oh_type);
   END CASE;

   -- Set the status of the history records to executed
   Per_Oh_Adjustment_History_API.Set_Executed(oh_adjustment_rec_.company,
                                              oh_adjustment_rec_.adjustment_id);

EXCEPTION
   WHEN others THEN
      error_message_ := sqlerrm;
      -- Rollback the transaction
      -- Method executed on a background job.
      @ApproveTransactionStatement(2009-10-23,kayolk)
      ROLLBACK;
      -- Logg the error

      -- Set error status on the history records
      Per_Oh_Adjustment_History_API.Set_Error(oh_adjustment_rec_.company, 
                                              oh_adjustment_rec_.adjustment_id, 
                                              error_message_);

      IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
         Transaction_SYS.Set_Status_Info(error_message_);
      END IF;

END Create_Adjustments_For_Oh__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


