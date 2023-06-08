-----------------------------------------------------------------------------
--
--  Logical unit: AssetClass
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160502  JeLise  STRSC-2131, Changed Insert_Lu_Data_Rec__ to call New___ and Modify___ to avoid installation errors.
--  141211  AwWelk  GEN-239, Moved the logic in Check_Intro_Duration_Days___(), Check_Decline_Inactive_Days___(), Check_Expired_Inactive_Days___(), Check_Decl_To_Mature_Issues___(),
--  141211          Check_Expir_To_Intro_Issues___() and Check_Class_Periods___() to Check_Positive_Integer___().
--  141201  AwWelk  GEN-239, Modified Check_Lifecycle_Offset___() by validating decline inactivity days to be lower than expired inactivity days. Renamed Check_Decl_To_Mature_Count___(),
--  141201          Check_Exp_To_Intro_Count___() to Check_Decl_To_Mature_Issues___() and Check_Expir_To_Intro_Issues___() respectively. Removed Check_Lifecycle_Move_Counts___() and 
--  141201          moved possible validations to Check_Common___().
--  141105  AwWelk  GEN-184, Made Modifications for renaming the field EXPIRED_TO_MATURE_ISSUES to EXPIRED_TO_INTRO_ISSUES.
--  141028  AwWelk  GEN-157, Added validations and logic to handle decline_to_mature_count, expired_to_mature_count.
--  141022  AwWelk  GEN-42, Added UPPER_LIMIT_VERYSLOW_MOVER field and modified the validations in Check_Upper_Limits___().
--  131101  UdGnlk  PBSC-188, Modified base view column comments to align with the model errors. 
--  120525  JeLise  Made description private.
--  120504  Matkse  Replaced calls to obsolete Module_Translate_Attr_Util_API with Basic_Data_Translation_API.Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120504          Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120504          was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100212  Asawlk  Bug 88330, Modified Update___() to place the call to Invalidate_Cache___ right after the UPDATE clause.
--  100106  PraWlk  Bug 88129, Modified  Insert_Lu_Data_Rec__() by adding seasonal_demand_pattern to the INSERT block.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  051213  GeKalk  Added co_reserve_onh_analys_flag to Insert_Lu_Data_Rec__.
--  051109  GeKalk  Reverse the previous correction and added co_reserve_onh_analys_flag.
--  051103  GeKalk  Modified Prepare_Insert___ to change the value of ONHAND_ANALYSIS_FLAG.
--  051026  DaZase  Added capability checks in unpack methods.
--  050913  SaMelk  Modified the 'Prepare_Insert___' method.
--  050621  DaZase  Added automatic_capability_check.
--  040226  GeKalk  Removed substrb from views for UNICODE modifications and changed
--  040226          substrb to substr where it is necessary to keep.
--  040203  ErSolk  Bug 40017, Modified procedure Check_Delete___.
--  031001  ThGulk  Changed substr to substrb, instr to instrb, length to lengthb.
--  020124  DaMase  IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  000925  JOHESE  Added undefines.
--  000414  NISOSE  Added General_SYS.Init_Method in Get_Control_Type_Value_Desc.
--  990419  ANHO    General performance improvements.
--  990409  ANHO    Upgraded to performance optimized template.
--  990322  FRDI    Changed promt form Oe Alloc Assign Flag to Physical Reservation Flag
--  990308  FRDI    Removed attributes Fixed_Asset_Flag, Expense_Flag.
--  981015  SHVE    Removed attributes serial_flag,lot_batch_flag,serial_rule.
--  980811  ANHO    Removed attribute maint_flag and function Get_Maint_Flag.
--  980609  GOPE    Added Serial Rule
--  980526  JOHW    Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  980220  GOPE    Added ForecastConsumptionFlag
--  971126  GOPE    Upgrade to fnd 2.0
--  971106  GOPE    Added checks around shortage flag
--  970709  NAVE    Incorporated Asset_Class.Shortage_Flag.
--  970617  GOPE    Changed default for part tracking to NO from ALLOWED
--  970508  FRMA    Added Get_Control_Type_Value_Desc.
--  970312  CHAN    Changed table name asset_class_tab instead of asset_class_codes
--  970219  JOKE    Uses column rowversion as objversion (timestamp).
--  961212  LEPE    Modified for new template standard.
--  961101  MAOR    Added rtrim, rpad around objversion.
--  961028  MAOR    Changed reference_name on iid:n on view-comments.
--  961025  MAOR    Modified file to Rational Rose Model-standard.
--  960917  JICE    Changed oe_alloc_assign_flag to use IID CustOrdReservationType
--                  instead of GenYesNo.
--  960307  JICE    Renamed from InvAssetClassCodes
--  951011  SHR     Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

number_null_            CONSTANT NUMBER := -99999;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Upper_Limits___(
   upper_limit_veryslow_mover_  IN NUMBER,
   upper_limit_slow_mover_      IN NUMBER,
   upper_limit_medium_mover_    IN NUMBER)
IS
BEGIN
   -- Validate the limits.
   IF (upper_limit_veryslow_mover_ != ROUND(upper_limit_veryslow_mover_) OR
       upper_limit_slow_mover_     != ROUND(upper_limit_slow_mover_) OR
       upper_limit_medium_mover_   != ROUND(upper_limit_medium_mover_) OR
       upper_limit_veryslow_mover_ < 0 OR upper_limit_slow_mover_ < 0 OR upper_limit_medium_mover_ < 0) THEN
      Error_SYS.Record_General(lu_name_,'ERRORFREQLIMITSINTEGER: Upper frequency limits must be integers greater than or equal to 0');
   END IF;
   -- Check if only one limit has a value
   IF (((upper_limit_veryslow_mover_ IS NOT NULL) OR (upper_limit_slow_mover_ IS NOT NULL) OR (upper_limit_medium_mover_ IS NOT NULL)) AND
       ((upper_limit_veryslow_mover_ IS     NULL) OR (upper_limit_slow_mover_ IS     NULL) OR (upper_limit_medium_mover_ IS     NULL))) THEN
       Error_SYS.Record_General(lu_name_,'ERRORFREQLIMITSBOTH: If one upper frequency limit has a value then the other two needs to have a value too.');
   END IF;
   -- Check that slow movers limit is not equal or greater than medium movers limit
   IF (upper_limit_veryslow_mover_ >= upper_limit_slow_mover_) THEN 
      Error_SYS.Record_General(lu_name_,'ERRORFREQLIMITSVSLOWMOVER: Upper Frequency Limit - Slow Movers must be larger than Upper Frequency Limit - Very Slow Movers.');
   ELSIF(upper_limit_slow_mover_ >= upper_limit_medium_mover_) THEN
      Error_SYS.Record_General(lu_name_,'ERRORFREQLIMITS: Upper Frequency Limit - Medium Movers must be larger than Upper Frequency Limit - Slow Movers.');
   END IF;
END Check_Upper_Limits___;
   
PROCEDURE Check_Lifecycle_Offset___(
   introduction_duration_days_ IN NUMBER,
   decline_inactivity_days_    IN NUMBER,
   expired_inactivity_days_    IN NUMBER)
IS
   exit_procedure_ EXCEPTION;
BEGIN
   IF ((introduction_duration_days_ IS NULL) AND
       (decline_inactivity_days_    IS NULL) AND
       (expired_inactivity_days_    IS NULL)) THEN
      RAISE exit_procedure_;
   END IF;

   IF ((introduction_duration_days_ IS NOT NULL) AND
       (decline_inactivity_days_    IS NOT NULL) AND
       (expired_inactivity_days_    IS NOT NULL)) THEN

      Check_Positive_Integer___(introduction_duration_days_, Language_SYS.Translate_Constant(lu_name_,'INTRODURDAYS: Introduction Duration Days '));
      Check_Positive_Integer___(decline_inactivity_days_   , Language_SYS.Translate_Constant(lu_name_,'DECLINACDAYS: Decline Inactivity Days '   ));
      Check_Positive_Integer___(expired_inactivity_days_   , Language_SYS.Translate_Constant(lu_name_,'EXPIINACDAYS: Expire Inactivity Days '    ));
    
      IF (decline_inactivity_days_ >= expired_inactivity_days_) THEN
         Error_SYS.Record_General(lu_name_,'DECLINELOWERTOEXPIRY: Decline Inactivity Days must be less than Expired Inactivity Days.');
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_,'ALLMUSTHAVEVALUE: When defining lifecycle stages, Introduction Stage Duration, Decline Inactivity Days and Expired Inactivity Days all must have a value.');
   END IF;

EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Check_Lifecycle_Offset___;

PROCEDURE Check_Positive_Integer___ (
   number_ IN NUMBER,
   name_   IN VARCHAR2 )
IS
BEGIN
   IF number_ <= 0 OR (number_ != ROUND(number_)) THEN
      Error_SYS.Record_General(lu_name_,'NUMBERPOSINT: :P1 must be an integer greater than 0.', name_);
   END IF;
END Check_Positive_Integer___;


@Override 
PROCEDURE Check_Common___ (
   oldrec_ IN     asset_class_tab%ROWTYPE,
   newrec_ IN OUT asset_class_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here

   IF (Validate_SYS.Is_Changed(oldrec_.decline_to_mature_issues, newrec_.decline_to_mature_issues)) THEN
      Check_Positive_Integer___(newrec_.decline_to_mature_issues   , Language_SYS.Translate_Constant(lu_name_,'DECLTOMATUREISSUE: Max Number of Issues for Decline '    ));
   END IF;
   IF (Validate_SYS.Is_Changed(oldrec_.expired_to_intro_issues, newrec_.expired_to_intro_issues)) THEN
      Check_Positive_Integer___(newrec_.expired_to_intro_issues   , Language_SYS.Translate_Constant(lu_name_,'EXPTOINTROISSUE: Max Number of Issues for Expired '    ));
   END IF;
END Check_Common___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('SHORTAGE_FLAG', Inventory_Part_Shortage_API.Decode('N'), attr_);
   Client_SYS.Add_To_Attr('ONHAND_ANALYSIS_FLAG', Inventory_Part_Onh_Analys_API.Decode('Y'), attr_);
   Client_SYS.Add_To_Attr('OE_ALLOC_ASSIGN_FLAG', Cust_Ord_Reservation_Type_API.Decode('N'), attr_);
   Client_SYS.Add_To_Attr('FORECAST_CONSUMPTION_FLAG', Inv_Part_Forecast_Consum_API.Decode('NOFORECAST'), attr_);
   Client_SYS.Add_To_Attr('AUTOMATIC_CAPABILITY_CHECK', Capability_Check_Allocate_API.Decode('NO AUTOMATIC CAPABILITY CHECK'), attr_);
   Client_SYS.Add_To_Attr('CO_RESERVE_ONH_ANALYS_FLAG', Inventory_Part_Onh_Analys_API.Decode('N'), attr_);
   Client_SYS.Add_To_Attr('SEASONAL_DEMAND_PATTERN', Fnd_Boolean_API.Decode('FALSE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN ASSET_CLASS_TAB%ROWTYPE )
IS
   asset_class_ VARCHAR2(240);
BEGIN
   super(remrec_);

   asset_class_ := Mpccom_Defaults_API.Get_Char_Value('*','PART_DESCRIPTION','ASSET_CLASS');
   IF (asset_class_ = remrec_.asset_class) THEN
      Error_Sys.Record_General(lu_name_, 'DEFVALUE: Asset class is used as the default asset class. ( System Data for Inventory and Distribution \ Defaults )');
   END IF;
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT asset_class_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT(indrec_.shortage_flag) THEN
      newrec_.shortage_flag := 'N';
   END IF;
   
   IF NOT(indrec_.seasonal_demand_pattern) THEN
      newrec_.seasonal_demand_pattern := 'FALSE';
   END IF;

   super(newrec_, indrec_, attr_);

   IF Mpccom_System_Parameter_API.Get_Parameter_Value1('SHORTAGE_HANDLING') = 'N' AND newrec_.shortage_flag = 'Y' THEN
         Error_SYS.Record_General('AssetClass', 'SHORTFLAG: It is not allowed to change to :P1 when shortage handling is set to :P2', Inventory_Part_Shortage_API.Decode(newrec_.shortage_flag),Gen_Yes_No_API.Decode('N'));
   END IF;

   IF newrec_.forecast_consumption_flag = 'FORECAST' AND newrec_.onhand_analysis_flag= 'Y' THEN
        Error_SYS.Record_General(lu_name_,'ERRORFORECASTCONSUM: :P1 is not allowed when :P2 is selected.',
        Inv_Part_Forecast_Consum_API.Decode(newrec_.forecast_consumption_flag), Inventory_Part_Onh_Analys_API.Decode(newrec_.onhand_analysis_flag));
   END IF;

   IF (newrec_.forecast_consumption_flag = 'FORECAST' OR newrec_.onhand_analysis_flag= 'Y') AND
      newrec_.automatic_capability_check != 'NO AUTOMATIC CAPABILITY CHECK' THEN
      Error_SYS.Record_General(lu_name_,'ERRORAUTOCC: You are not allowed to combine an automatic Capability Check with either availability check or online consumption.');
   END IF;

   Check_Upper_Limits___(newrec_.upper_limit_veryslow_mover, newrec_.upper_limit_slow_mover, newrec_.upper_limit_medium_mover);

   Check_Lifecycle_Offset___(newrec_.introduction_duration_days, newrec_.decline_inactivity_days, newrec_.expired_inactivity_days);

   IF (newrec_.classification_periods IS NOT NULL) THEN
      Check_Positive_Integer___(newrec_.classification_periods   , Language_SYS.Translate_Constant(lu_name_,'PERPOSINT: The desired number of classification periods '    ));
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     asset_class_tab%ROWTYPE,
   newrec_ IN OUT asset_class_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                          VARCHAR2(30);
   value_                         VARCHAR2(4000);
   old_forecast_consumption_flag_ ASSET_CLASS_TAB.forecast_consumption_flag%TYPE;
   old_onhand_analysis_flag_      ASSET_CLASS_TAB.onhand_analysis_flag%TYPE;
BEGIN
   old_forecast_consumption_flag_ := newrec_.forecast_consumption_flag;
   old_onhand_analysis_flag_ := newrec_.onhand_analysis_flag;

   super(oldrec_, newrec_, indrec_, attr_);

   IF Mpccom_System_Parameter_API.Get_Parameter_Value1('SHORTAGE_HANDLING') = 'N' AND newrec_.shortage_flag = 'Y' THEN
         Error_SYS.Record_General('AssetClass', 'SHORTFLAG: It is not allowed to change to :P1 when shortage handling is set to :P2', Inventory_Part_Shortage_API.Decode(newrec_.shortage_flag),Gen_Yes_No_API.Decode('N'));
   END IF;
   
   IF Validate_SYS.Is_Changed(oldrec_.forecast_consumption_flag, newrec_.forecast_consumption_flag) OR
      Validate_SYS.Is_Changed(oldrec_.onhand_analysis_flag, newrec_.onhand_analysis_flag) THEN
      IF newrec_.forecast_consumption_flag = 'FORECAST' AND newrec_.onhand_analysis_flag= 'Y' THEN
           Error_SYS.Record_General(lu_name_,'ERRORFORECASTCONSUM: :P1 is not allowed when :P2 is selected.',
           Inv_Part_Forecast_Consum_API.Decode(newrec_.forecast_consumption_flag), Inventory_Part_Onh_Analys_API.Decode(newrec_.onhand_analysis_flag));
      END IF;
   END IF;

   IF (newrec_.forecast_consumption_flag = 'FORECAST' OR newrec_.onhand_analysis_flag= 'Y') AND
      newrec_.automatic_capability_check != 'NO AUTOMATIC CAPABILITY CHECK' THEN
      Error_SYS.Record_General(lu_name_,'ERRORAUTOCC: You are not allowed to combine an automatic Capability Check with either availability check or online consumption.');
   END IF;

   IF (Validate_SYS.Is_Changed(oldrec_.upper_limit_veryslow_mover, newrec_.upper_limit_veryslow_mover) OR 
       Validate_SYS.Is_Changed(oldrec_.upper_limit_slow_mover, newrec_.upper_limit_slow_mover) OR
       Validate_SYS.Is_Changed(oldrec_.upper_limit_medium_mover, newrec_.upper_limit_medium_mover)) THEN

      Check_Upper_Limits___(newrec_.upper_limit_veryslow_mover, newrec_.upper_limit_slow_mover, newrec_.upper_limit_medium_mover);
   END IF;

   IF (Validate_SYS.Is_Changed(oldrec_.introduction_duration_days, newrec_.introduction_duration_days) OR
       Validate_SYS.Is_Changed(oldrec_.decline_inactivity_days, newrec_.decline_inactivity_days) OR
       Validate_SYS.Is_Changed(oldrec_.expired_inactivity_days, newrec_.expired_inactivity_days)) THEN

      Check_Lifecycle_Offset___(newrec_.introduction_duration_days,
                                newrec_.decline_inactivity_days,
                                newrec_.expired_inactivity_days);
   END IF;
   
   IF (Validate_SYS.Is_Changed(oldrec_.classification_periods, newrec_.classification_periods)) THEN
      Check_Positive_Integer___(newrec_.classification_periods   , Language_SYS.Translate_Constant(lu_name_,'PERPOSINT: The desired number of classification periods '    ));
   END IF;


EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN ASSET_CLASS_TAB%ROWTYPE)
IS
   dummy_ VARCHAR2(1);
   rec_   asset_class_tab%ROWTYPE;
   
   CURSOR Exist IS
      SELECT 'X'
      FROM ASSET_CLASS_TAB
      WHERE asset_class = newrec_.asset_class;

   CURSOR get_rec IS
      SELECT rowstate, rowkey
      FROM ASSET_CLASS_TAB
      WHERE asset_class = newrec_.asset_class;
BEGIN
   rec_ := newrec_;

   OPEN get_rec;
   FETCH get_rec INTO rec_.rowstate, rec_.rowkey;
   CLOSE get_rec;
   
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      New___(rec_);
   ELSE
      Modify___(rec_);
   END IF;
   CLOSE Exist;
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   asset_class_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ asset_class_tab.description%TYPE;
BEGIN
   IF (asset_class_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      asset_class_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  asset_class_tab
      WHERE asset_class = asset_class_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(asset_class_, 'Get_Description');
END Get_Description;



PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;



