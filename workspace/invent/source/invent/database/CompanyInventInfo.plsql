-----------------------------------------------------------------------------
--
--  Logical unit: CompanyInventInfo
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210511  JiThlk  SCZ-14214, Change API for Activate_Ipr() and Modify_Ipr_Active___() to Site_Ipr_Info_API.
--  210115  SBalLK  Issue SC2020R1-11830, Modified New() method by removing attr_ functionality to optimize the performance.
--  200826  SBalLK  Added Create_Next_Intrastat_File_No() and modified Prepare_Insert___(), Check_Insert___() method to enable italy intrastat functionality.
--  200102  WaSalk  Added AUTO_UPDATE_DATE_APPLIED Defualt value for Prepare_Insert___(). 
--  191218  JoAnSe  MFSPRING20-700, Added validation in Check_Common___ for ownrshp_trans_reason_mtr. 
--  170524  AwWelk  STRSC-8620, Modified Prepare_Insert___() and Check_Insert___() to consider IPR_ACTIVE flag. Added Modify_IPR_Active_On_Sites___(),
--  170524          Activate_Ipr_On_All_Sites() and Deactivate_Ipr_On_All_Sites.
--  141211  AwWelk  GEN-239, Moved the logic in Check_Intro_Duration_Days___(), Check_Decline_Inactive_Days___(), Check_Expired_Inactive_Days___(), Check_Decl_To_Mature_Issues___()
--  141211          and Check_Expir_To_Intro_Issues___() to Check_Positive_Integer___().
--  141201  AwWelk  GEN-239, Modified Check_Lifecycle_Offset___() by validating decline inactivity days to be lower than expired inactivity days. Renamed Check_Decl_To_Mature_Count___(),
--  141201          Check_Exp_To_Intro_Count___() to Check_Decl_To_Mature_Issues___() and Check_Expir_To_Intro_Issues___() respectively. Removed Check_Lifecycle_Move_Counts___() and 
--  141201          moved possible validations to Check_Common___().
--  141105  AwWelk  GEN-184, Made Modifications for renaming the field EXPIRED_TO_MATURE_ISSUES to EXPIRED_TO_INTRO_ISSUES.
--  141028  AwWelk  GEN-157, Added validations and logic to handle decline_to_mature_count, expired_to_mature_count.
--  140424  DipeLK  PBFI-6775 ,Added create company tool support from the developer studio
--  131105  UdGnlk  PBSC-204, Modified base view comments to align with model file errors. 
--  130730  MaRalk  TIBE-830, Removed global LU constant inst_CompanyInvplaInfo_ and modified Insert___ 
--  130730          using conditional compilation instead.
--  130515  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  120615  MaEelk  Moved Raise_Uom_Changed_Warning___ and Check_Ownership_Transfer_Point___ from Company_Distribution_Info_API.
--  120613  MaEelk  Moved Compare_Uoms from Company_Distribution_Info_API
--  120607  MaEelk  Added OWNERSHIP_TRANSFER_POINT, KEEP_ENG_REV_SITE_MOVE, STOCK_CTRL_TYPES_BLOCKED,
--  120607          UOM_FOR_VOLUME, UOM_FOR_WEIGHT, UOM_FOR_LENGTH, UOM_FOR_TEMPERATURE and UOM_FOR_DENSITY to CompanyInventInfo
--  110811   PraWlk  Modified views COMPANY_INVENT_INFO and COMPANY_INVENT_INFO_CPT by removing new column 
--  110811          immediate_replenishment. Removed Get_Immediate_Replenishment() and Get_Immediate_Replenishment_db()  
--  110811          and modified methods Unpack_Check_Insert___(), Insert___(), Unpack_Check_Update___(), Update___(), 
--  111004          Import___(), Export___(), and Copy___().
--  110811   PraWlk  Modified views COMPANY_INVENT_INFO and COMPANY_INVENT_INFO_CPT by adding new column 
--  110811          immediate_replenishment. Added Get_Immediate_Replenishment() and Get_Immediate_Replenishment_db() and 
--  110811          modified methods Unpack_Check_Insert___(), Insert___(), Unpack_Check_Update___() and Update___() accordingly. 
--  110811          Modified methods Import___(), Export___(), and Copy___() to support crate company and company templates.
--  100811  PraWlk  Bug 91276, Added new view COMPANY_INVENT_INFO_CPT and added new methods Import___()
--  100811          Export___(), Copy___(), Make_Company() and modified Unpack_Check_Insert___() to support 
--  100811          for the Creation of Company and Company Templates.   
--  100311  HaPulk  Bug 84970, Added assert_safe tag for ExecuteImmediate
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core

-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

number_null_            CONSTANT NUMBER := -99999;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Ordering_Cost___ (
   ordering_cost_ IN NUMBER )
IS
BEGIN
   IF ordering_cost_ < 0 THEN
      Error_SYS.Record_General(lu_name_,'ORDERINGCOST: Ordering cost cannot have a negative value.');
   END IF;
END Check_Ordering_Cost___;


PROCEDURE Check_Inv_Interest_Rate___ (
   inventory_interest_rate_ IN NUMBER )
IS
BEGIN
   IF inventory_interest_rate_ < 0 THEN
      Error_SYS.Record_General(lu_name_,'INVINTERESTRATE: Inventory interest rate cannot have a negative value.');
   END IF;
END Check_Inv_Interest_Rate___;

PROCEDURE Check_Lifecycle_Offset___(
   introduction_duration_days_ IN NUMBER,
   decline_inactivity_days_    IN NUMBER,
   expired_inactivity_days_    IN NUMBER)
IS
BEGIN
     IF introduction_duration_days_ IS NOT NULL THEN 
        Check_Positive_Integer___(introduction_duration_days_, Language_SYS.Translate_Constant(lu_name_,'INTRODURDAYS: Introduction Duration Days '));
     END IF;
     
     IF decline_inactivity_days_ IS NOT NULL THEN 
        Check_Positive_Integer___(decline_inactivity_days_   , Language_SYS.Translate_Constant(lu_name_,'DECLINACDAYS: Decline Inactivity Days '   ));
     END IF;
     
     IF expired_inactivity_days_ IS NOT NULL THEN 
        Check_Positive_Integer___(expired_inactivity_days_   , Language_SYS.Translate_Constant(lu_name_,'EXPIINACDAYS: Expire Inactivity Days '    ));
     END IF;
  
     IF (decline_inactivity_days_ >= expired_inactivity_days_) THEN
        Error_SYS.Record_General(lu_name_,'DECLINELOWERTOEXPIRY: Decline Inactivity Days must be less than Expired Inactivity Days.');
     END IF;
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
   oldrec_ IN     company_invent_info_tab%ROWTYPE,
   newrec_ IN OUT company_invent_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
   
   IF (Validate_SYS.Is_Changed(oldrec_.introduction_duration_days, newrec_.introduction_duration_days) OR
       Validate_SYS.Is_Changed(oldrec_.decline_inactivity_days, newrec_.decline_inactivity_days) OR
       Validate_SYS.Is_Changed(oldrec_.expired_inactivity_days, newrec_.expired_inactivity_days)) THEN

      Check_Lifecycle_Offset___(newrec_.introduction_duration_days,
                                newrec_.decline_inactivity_days,
                                newrec_.expired_inactivity_days);
   END IF;
         
   IF (Validate_SYS.Is_Changed(oldrec_.decline_to_mature_issues, newrec_.decline_to_mature_issues)) THEN
      Check_Positive_Integer___(newrec_.decline_to_mature_issues   , Language_SYS.Translate_Constant(lu_name_,'DECLTOMATUREISSUE: Max Number of Issues for Decline '    ));
   END IF;
   IF (Validate_SYS.Is_Changed(oldrec_.expired_to_intro_issues, newrec_.expired_to_intro_issues)) THEN
      Check_Positive_Integer___(newrec_.expired_to_intro_issues   , Language_SYS.Translate_Constant(lu_name_,'EXPTOINTROISSUE: Max Number of Issues for Expired '    ));
   END IF;
   
   $IF Component_Pmrp_SYS.INSTALLED $THEN 
      IF (Validate_SYS.Is_Changed(oldrec_.ownrshp_trans_reason_mand, newrec_.ownrshp_trans_reason_mand) OR
          Validate_SYS.Is_Changed(oldrec_.ownrshp_trans_reason_mtr, newrec_.ownrshp_trans_reason_mtr)) THEN
         IF (newrec_.ownrshp_trans_reason_mand = Fnd_Boolean_API.DB_TRUE AND newrec_.ownrshp_trans_reason_mtr IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'OWNTRANSFMTR: System Default on Generated MTR must be specified when Part Ownership Transfer Reason is mandatory');
         END IF;
      END IF;
   $END
         
END Check_Common___;
   
@Override
PROCEDURE Copy_Assign___ (
   newrec_      IN OUT company_invent_info_tab%ROWTYPE,
   crecomp_rec_ IN     Enterp_Comp_Connect_V170_API.Crecomp_Lu_Public_Rec,
   oldrec_      IN     company_invent_info_tab%ROWTYPE )
IS
BEGIN
   super(newrec_, crecomp_rec_, oldrec_);
   newrec_.ownership_transfer_point := 'RECEIPT INTO ARRIVAL';
END Copy_Assign___;


-- Check_Ownership_Trans_Point___
--   Validates the Ownership Transfer Point of a Company
PROCEDURE Check_Ownership_Trans_Point___ (
   company_                     IN VARCHAR2,
   ownership_transfer_point_db_ IN VARCHAR2,
   check_update_                IN BOOLEAN )
IS
   transfer_done_ VARCHAR2(10);
BEGIN

   IF (ownership_transfer_point_db_ = 'RECEIPT INTO INVENTORY') THEN
      Site_Invent_Info_API.Check_Ownership_Transfer_Point(company_,
                                                         ownership_transfer_point_db_);

      Inventory_Part_API.Check_Ownership_Transfer_Point( company_,
                                                         ownership_transfer_point_db_);
   END IF;

   IF (check_update_) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN 
          transfer_done_ := Receipt_Info_API.Check_Ownership_Transfer_Done(company_);
      $ELSE
         NULL;
      $END
      IF transfer_done_ = 'FALSE' THEN
         Error_SYS.Record_General(lu_name_, 'TRANSFERNOTALLOWED: Change of Ownership Transfer Point is only allowed if all purchase receipts within company :P1 '||
                                 'are in status Received or Cancelled.',company_);

      END IF;
   END IF;
END Check_Ownership_Trans_Point___;


PROCEDURE Raise_Uom_Changed_Warning___ (
   old_uom_    IN VARCHAR2,
   new_uom_    IN VARCHAR2 )
IS
BEGIN

   Client_SYS.Add_Warning(lu_name_, 'WARNUOMCHANGED: When changing company UoM from :P1 to :P2 you need to consider earlier entered values in the old UoM as they will not be automatically converted. This includes values for storage requirement and freight.', old_uom_, new_uom_);
END Raise_Uom_Changed_Warning___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   company_          company_invent_info_tab.company%TYPE;
   
BEGIN
   company_ := Client_SYS.Get_Item_Value('COMPANY', attr_);
   
   super(attr_);
   Client_SYS.Add_To_Attr('SERVICE_LEVEL_RATE', 50, attr_);
   Client_SYS.Add_To_Attr('ORDERING_COST', 0, attr_);
   Client_SYS.Add_To_Attr('INVENTORY_INTEREST_RATE', 0, attr_);
   Client_SYS.Add_To_Attr('INTRODUCTION_DURATION_DAYS', 30, attr_);
   Client_SYS.Add_To_Attr('DECLINE_INACTIVITY_DAYS', 365, attr_);
   Client_SYS.Add_To_Attr('EXPIRED_INACTIVITY_DAYS', 730, attr_);
   Client_SYS.Add_To_Attr('DECLINE_TO_MATURE_ISSUES', 1, attr_);
   Client_SYS.Add_To_Attr('EXPIRED_TO_INTRO_ISSUES', 1, attr_);
   Client_SYS.Add_To_Attr('POST_PRICE_DIFF_AT_ARRIVAL_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('USE_TRANSIT_BALANCE_POSTING_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CHECK_PREACC_AT_PR_RELEASE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('KEEP_ENG_REV_SITE_MOVE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('STOCK_CTRL_TYPES_BLOCKED_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('IPR_ACTIVE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('OWNRSHP_TRANS_REASON_MAND_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   -- gelr:modify_date_applied, begin
   Client_SYS.Add_To_Attr('AUTO_UPDATE_DATE_APPLIED_DB', 'NO_UPDATE', attr_);
   -- gelr:modify_date_applied, end
   IF (Company_API.Get_Template_Company(company_) IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('UOM_FOR_VOLUME', Company_Invent_Info_API.Get_Uom_For_Volume(Company_API.Get_Template_Company(company_)), attr_);
      Client_SYS.Add_To_Attr('UOM_FOR_WEIGHT', Company_Invent_Info_API.Get_Uom_For_Weight(Company_API.Get_Template_Company(company_)), attr_);
      Client_SYS.Add_To_Attr('UOM_FOR_LENGTH', Company_Invent_Info_API.Get_Uom_For_Length(Company_API.Get_Template_Company(company_)), attr_);
      Client_SYS.Add_To_Attr('UOM_FOR_TEMPERATURE', Company_Invent_Info_API.Get_Uom_For_Temperature(Company_API.Get_Template_Company(company_)), attr_);
      Client_SYS.Add_To_Attr('UOM_FOR_DENSITY', Company_Invent_Info_API.Get_Uom_For_Density(Company_API.Get_Template_Company(company_)), attr_);
   ELSIF (Company_API.Get_From_Company(company_) IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('UOM_FOR_VOLUME', Company_Invent_Info_API.Get_Uom_For_Volume(Company_API.Get_From_Company(company_)), attr_);
      Client_SYS.Add_To_Attr('UOM_FOR_WEIGHT', Company_Invent_Info_API.Get_Uom_For_Weight(Company_API.Get_From_Company(company_)), attr_);
      Client_SYS.Add_To_Attr('UOM_FOR_LENGTH', Company_Invent_Info_API.Get_Uom_For_Length(Company_API.Get_From_Company(company_)), attr_);
      Client_SYS.Add_To_Attr('UOM_FOR_TEMPERATURE', Company_Invent_Info_API.Get_Uom_For_Temperature(Company_API.Get_From_Company(company_)), attr_);
      Client_SYS.Add_To_Attr('UOM_FOR_DENSITY', Company_Invent_Info_API.Get_Uom_For_Density(Company_API.Get_From_Company(company_)), attr_);
   END IF;   
   -- gelr:italy_intrastat, start
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'ITALY_INTRASTAT') = Fnd_Boolean_API.DB_TRUE) THEN
      Client_SYS.Add_To_Attr('NEXT_IT_INTRASTAT_FILE_NO', 1, attr_);
   END IF;
   -- gelr:italy_intrastat, end
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT company_invent_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS   
BEGIN
   super(objid_, objversion_, newrec_, attr_);

   $IF Component_Invpla_SYS.INSTALLED $THEN
      Company_Invpla_Info_API.New(newrec_.company); 
   $END
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT company_invent_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT(indrec_.service_level_rate) THEN
      newrec_.service_level_rate      := 50;
   END IF;
   
   IF NOT(indrec_.ordering_cost) THEN
      newrec_.ordering_cost           := 0;
   END IF;
  
   IF NOT(indrec_.inventory_interest_rate) THEN 
      newrec_.inventory_interest_rate := 0;
   END IF;
   
   IF NOT(indrec_.ownership_transfer_point) THEN 
      newrec_.ownership_transfer_point := 'RECEIPT INTO ARRIVAL';
   END IF;
   
   IF NOT(indrec_.keep_eng_rev_site_move) THEN 
      newrec_.keep_eng_rev_site_move := 'FALSE';
   END IF;
   
   IF NOT(indrec_.stock_ctrl_types_blocked) THEN 
      newrec_.stock_ctrl_types_blocked := 'FALSE';
   END IF;
   
   IF (newrec_.introduction_duration_days IS NULL) THEN
      newrec_.introduction_duration_days  := 30;   
   END IF;
   
   IF (newrec_.decline_inactivity_days IS NULL) THEN
      newrec_.decline_inactivity_days  := 365;   
   END IF;
   
   IF (newrec_.expired_inactivity_days IS NULL) THEN
      newrec_.expired_inactivity_days  := 730;   
   END IF;
   
   IF (newrec_.decline_to_mature_issues IS NULL) THEN
      newrec_.decline_to_mature_issues  := 1;   
   END IF;
   
   IF (newrec_.expired_to_intro_issues IS NULL) THEN
      newrec_.expired_to_intro_issues  := 1;   
   END IF;
         
   IF (newrec_.post_price_diff_at_arrival IS NULL) THEN
      newrec_.post_price_diff_at_arrival  := 'FALSE';   
   END IF;
   
   IF (newrec_.use_transit_balance_posting IS NULL) THEN
      newrec_.use_transit_balance_posting  := 'FALSE';   
   END IF;
   
   IF (newrec_.ipr_active IS NULL) THEN
      newrec_.ipr_active  := Fnd_Boolean_API.DB_FALSE;   
   END IF;

   IF (newrec_.ownrshp_trans_reason_mand IS NULL) THEN
      newrec_.ownrshp_trans_reason_mand  := Fnd_Boolean_API.DB_FALSE;   
   END IF;
   -- gelr:italy_intrastat, start
   IF (newrec_.next_it_intrastat_file_no IS NULL AND Company_Localization_Info_API.Get_Parameter_Value_Db(newrec_.company, 'ITALY_INTRASTAT') = Fnd_Boolean_API.DB_TRUE) THEN
      newrec_.next_it_intrastat_file_no := 1;
   END IF;
   -- gelr:italy_intrastat, end
   super(newrec_, indrec_, attr_);
   Check_Hierarchy_Attributes(newrec_.service_level_rate,
                              newrec_.ordering_cost,
                              newrec_.inventory_interest_rate);  

   IF (Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.uom_for_volume)) != 'VOLUME') THEN
       Error_SYS.Record_General(lu_name_, 'UOMNOTVOLTYPE: Field unit of measure for volume requires a unit of measure of type volume.');
   END IF;

   IF (Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.uom_for_weight)) != 'WEIGHT') THEN
       Error_SYS.Record_General(lu_name_, 'UOMNOTWEIGTYPE: Field unit of measure for weight requires a unit of measure of type weight.');
   END IF;

   IF (Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.uom_for_length)) != 'LENGTH') THEN
       Error_SYS.Record_General(lu_name_, 'UOMNOTLENGTYPE: Field unit of measure for length requires a unit of measure of type length.');
   END IF;

   IF (Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.uom_for_temperature)) != 'TEMPERAT') THEN
       Error_SYS.Record_General(lu_name_, 'UOMNOTTEMPTYPE: Field unit of measure for temperature requires a unit of measure of type temperature.');
   END IF;

   IF (Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.uom_for_density)) != 'DENSITY') THEN
       Error_SYS.Record_General(lu_name_, 'UOMNOTDENSITYTYPE: Field unit of measure for density requires a unit of measure of type density.');
   END IF;

   Check_Ownership_Trans_Point___(newrec_.company, newrec_.ownership_transfer_point, FALSE);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     company_invent_info_tab%ROWTYPE,
   newrec_ IN OUT company_invent_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_   VARCHAR2(30);
   value_  VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
 
   Check_Hierarchy_Attributes(newrec_.service_level_rate,
                              newrec_.ordering_cost,
                              newrec_.inventory_interest_rate,
                              oldrec_.service_level_rate,
                              oldrec_.ordering_cost,
                              oldrec_.inventory_interest_rate);
        
   IF (newrec_.uom_for_volume != oldrec_.uom_for_volume) THEN
      IF (Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.uom_for_volume)) != 'VOLUME') THEN
         Error_SYS.Record_General(lu_name_, 'UOMNOTVOLTYPE: Field unit of measure for volume requires a unit of measure of type volume.');
      END IF;
      Raise_Uom_Changed_Warning___(oldrec_.uom_for_volume, newrec_.uom_for_volume);
   END IF;

   IF (newrec_.uom_for_weight != oldrec_.uom_for_weight) THEN
      IF (Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.uom_for_weight)) != 'WEIGHT') THEN
         Error_SYS.Record_General(lu_name_, 'UOMNOTWEIGTYPE: Field unit of measure for weight requires a unit of measure of type weight.');
      END IF;
      Raise_Uom_Changed_Warning___(oldrec_.uom_for_weight, newrec_.uom_for_weight);
   END IF;

   IF (newrec_.uom_for_length != oldrec_.uom_for_length) THEN
      IF (Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.uom_for_length)) != 'LENGTH') THEN
         Error_SYS.Record_General(lu_name_, 'UOMNOTLENGTYPE: Field unit of measure for length requires a unit of measure of type length.');
      END IF;
      Raise_Uom_Changed_Warning___(oldrec_.uom_for_length, newrec_.uom_for_length);
   END IF;

   IF (newrec_.uom_for_temperature != oldrec_.uom_for_temperature) THEN
      IF (Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.uom_for_temperature)) != 'TEMPERAT') THEN
         Error_SYS.Record_General(lu_name_, 'UOMNOTTEMPTYPE: Field unit of measure for temperature requires a unit of measure of type temperature.');
      END IF;
      Raise_Uom_Changed_Warning___(oldrec_.uom_for_temperature, newrec_.uom_for_temperature);
   END IF;

   IF (newrec_.uom_for_density != oldrec_.uom_for_density) THEN
      IF (Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(newrec_.uom_for_density)) != 'DENSITY') THEN
         Error_SYS.Record_General(lu_name_, 'UOMNOTDENSITYTYPE: Field unit of measure for density requires a unit of measure of type density.');
      END IF;
      Raise_Uom_Changed_Warning___(oldrec_.uom_for_density, newrec_.uom_for_density);
   END IF;

   IF (newrec_.ownership_transfer_point != oldrec_.ownership_transfer_point) THEN
      Check_Ownership_Trans_Point___(newrec_.company, newrec_.ownership_transfer_point, TRUE);
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

  
PROCEDURE Modify_IPR_Active_On_Sites___(
   modify_count_    OUT VARCHAR2,
   company_         IN  VARCHAR2,
   ipr_active_db_   IN  VARCHAR2)
IS 
   $IF Component_Invpla_SYS.INSTALLED $THEN  
      CURSOR get_sites IS 
         SELECT a.contract
           FROM site_public a
           WHERE a.company = company_
           AND EXISTS (SELECT 1
                        FROM site_ipr_info_pub b
                        WHERE a.contract = b.contract 
                        AND   b.ipr_active != ipr_active_db_);
   $END
BEGIN 
   modify_count_ := 0;

   $IF Component_Invpla_SYS.INSTALLED $THEN  
      FOR rec_ IN get_sites LOOP
         IF ipr_active_db_ = Fnd_Boolean_API.DB_TRUE THEN
            Site_Ipr_Info_API.Activate_Ipr(rec_.contract);
         ELSE
            Site_Ipr_Info_API.Deactivate_Ipr(rec_.contract);   
         END IF;
         modify_count_ := modify_count_ + 1;
      END LOOP;
   $END
END Modify_IPR_Active_On_Sites___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE Activate_Ipr_On_All_Sites(
   info_       OUT VARCHAR2,
   company_    IN  VARCHAR2)
IS 
   count_ NUMBER := 0;
BEGIN 
   $IF Component_Invpla_SYS.INSTALLED $THEN    
      Modify_IPR_Active_On_Sites___(count_, company_, Fnd_Boolean_API.DB_TRUE);
   $END
   
   Client_SYS.Clear_Info();
   Client_SYS.Add_Info(lu_name_, 'IPRACTIVATEDCOUNT: IPR has been activated on :P1 sites', count_);
   info_ := Client_SYS.Get_All_Info();
END Activate_Ipr_On_All_Sites;

PROCEDURE Deactivate_Ipr_On_All_Sites(
   info_       OUT VARCHAR2,
   company_    IN  VARCHAR2)
IS 
   count_ NUMBER := 0;
BEGIN 
   $IF Component_Invpla_SYS.INSTALLED $THEN 
      Modify_IPR_Active_On_Sites___(count_, company_, Fnd_Boolean_API.DB_FALSE);
   $END
   
   Client_SYS.Clear_Info();
   Client_SYS.Add_Info(lu_name_, 'IPRDEACTIVATEDCOUNT: IPR has been deactivated on :P1 sites', count_);
   info_ := Client_SYS.Get_All_Info();
END Deactivate_Ipr_On_All_Sites;

@UncheckedAccess
PROCEDURE Get_Post_Price_Diff_At_Arr_Db (
   post_price_diff_att_arr_ OUT VARCHAR2,
   company_                 IN  VARCHAR2 )
IS
   temp_ company_invent_info_tab.post_price_diff_at_arrival%TYPE;
   CURSOR get_attr IS
   SELECT post_price_diff_at_arrival
      FROM  company_invent_info_tab
      WHERE company = company_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   post_price_diff_att_arr_ := temp_;
END Get_Post_Price_Diff_At_Arr_Db;


@UncheckedAccess
FUNCTION Get_Use_Trans_Bal_Posting (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ company_invent_info_tab.use_transit_balance_posting%TYPE;
   CURSOR get_attr IS
      SELECT use_transit_balance_posting
      FROM company_invent_info_tab
      WHERE company = company_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN Fnd_Boolean_API.Decode(temp_);
END Get_Use_Trans_Bal_Posting;


@UncheckedAccess
FUNCTION Get_Use_Trans_Bal_Posting_Db (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ company_invent_info_tab.use_transit_balance_posting%TYPE;
   CURSOR get_attr IS
      SELECT use_transit_balance_posting
      FROM company_invent_info_tab
      WHERE company = company_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Use_Trans_Bal_Posting_Db; 


PROCEDURE New (
   company_ IN VARCHAR2 )
IS
   newrec_     company_invent_info_tab%ROWTYPE;
BEGIN
   IF NOT Check_Exist___ (company_) THEN
      newrec_.company := company_;
      New___(newrec_);
   END IF;
END New;


@UncheckedAccess
FUNCTION Attribute_Check_Needed (
   new_attribute_value_ IN NUMBER,
   old_attribute_value_ IN NUMBER ) RETURN BOOLEAN
IS
   attribute_check_needed_ BOOLEAN := FALSE;
BEGIN
   IF (new_attribute_value_ IS NOT NULL) THEN
      IF ((old_attribute_value_ IS NULL) OR
          (new_attribute_value_ != old_attribute_value_)) THEN
         attribute_check_needed_ := TRUE;
      END IF;
   END IF;

   RETURN (attribute_check_needed_);
END Attribute_Check_Needed;


PROCEDURE Check_Hierarchy_Attributes (
   new_service_level_rate_      IN NUMBER,
   new_ordering_cost_           IN NUMBER,
   new_inventory_interest_rate_ IN NUMBER,
   old_service_level_rate_      IN NUMBER DEFAULT NULL,
   old_ordering_cost_           IN NUMBER DEFAULT NULL,
   old_inventory_interest_rate_ IN NUMBER DEFAULT NULL )
IS
BEGIN
   IF (Attribute_Check_Needed(new_service_level_rate_, old_service_level_rate_)) THEN
      Service_Rate_API.Exist(new_service_level_rate_);
   END IF;

   IF (Attribute_Check_Needed(new_ordering_cost_, old_ordering_cost_)) THEN
      Check_Ordering_Cost___(new_ordering_cost_);
   END IF;

   IF (Attribute_Check_Needed(new_inventory_interest_rate_, old_inventory_interest_rate_)) THEN
      Check_Inv_Interest_Rate___(new_inventory_interest_rate_);
   END IF;

END Check_Hierarchy_Attributes;


-- Get_Ownership_Transfer_Pnt_Db
--   Returns the Db value of the Ownership Transfer Point for a Company
--   This method is used by the copy warehouse structures dialogues in the warehouse navigator
@UncheckedAccess
PROCEDURE Get_Ownership_Transfer_Pnt_Db (
   ownership_transfer_pnt_ OUT VARCHAR2,
   company_ IN VARCHAR2 )
IS
   temp_ company_invent_info_tab.ownership_transfer_point%TYPE;
   CURSOR get_attr IS
   SELECT ownership_transfer_point
      FROM  company_invent_info_tab
      WHERE company = company_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   ownership_transfer_pnt_ := temp_;
END Get_Ownership_Transfer_Pnt_Db;


@UncheckedAccess
FUNCTION Stock_Ctrl_Types_Blocked (
   company_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_ company_invent_info_tab.stock_ctrl_types_blocked%TYPE;
   CURSOR get_attr IS
      SELECT stock_ctrl_types_blocked
      FROM company_invent_info_tab
      WHERE company = company_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF (temp_ = 'TRUE') THEN
      RETURN TRUE;
   END IF;
      RETURN FALSE;
END Stock_Ctrl_Types_Blocked;

PROCEDURE Compare_Uoms (
 info_                  OUT VARCHAR2,
 same_length_uoms_      OUT BOOLEAN,
 same_weight_uoms_      OUT BOOLEAN,
 same_temperature_uoms_ OUT BOOLEAN,
 company1_              IN VARCHAR2, 
 company2_              IN VARCHAR2 )
IS
   temp_same_length_uoms_       BOOLEAN := TRUE;
   temp_same_weight_uoms_       BOOLEAN := TRUE;
   temp_same_temperature_uoms_  BOOLEAN := TRUE;
   company1_rec_                Public_Rec;
   company2_rec_                Public_Rec;
BEGIN

   company1_rec_ := Company_Invent_Info_API.Get(company1_);
   company2_rec_ := Company_Invent_Info_API.Get(company2_);
   
   IF (company1_ != company2_) THEN
      IF (company1_rec_.uom_for_length != company2_rec_.uom_for_length) THEN
         temp_same_length_uoms_ := FALSE;
         Client_SYS.Add_Info(lu_name_, 'NOCOPYLENGTH: There will not be a copy made of values for width, height or depth between the sites as there are different UoM used on company :P1 and company :P2.', company1_, company2_);
      END IF;

      IF (company1_rec_.uom_for_weight != company2_rec_.uom_for_weight) THEN
         temp_same_weight_uoms_ := FALSE;   
         Client_SYS.Add_Info(lu_name_, 'NOCOPYWEIGHT: There will not be a copy made of values for carrying capacity between the sites as there are different UoM used on company :P1 and company :P2.', company1_, company2_);
      END IF;

      IF (company1_rec_.uom_for_temperature != company2_rec_.uom_for_temperature) THEN
         temp_same_temperature_uoms_ := FALSE;   
         Client_SYS.Add_Info(lu_name_, 'NOCOPYTEMP: There will not be a copy made of values for temperature between the sites as there are different UoM used on company :P1 and company :P2.', company1_, company2_);
      END IF;
   END IF;
   same_length_uoms_ := temp_same_length_uoms_;
   same_weight_uoms_ := temp_same_weight_uoms_;
   same_temperature_uoms_ := temp_same_temperature_uoms_;
   info_ := Client_SYS.Get_All_Info;

END Compare_Uoms;

-- gelr:italy_intrastat, start
PROCEDURE Create_Next_Intrastat_File_No(
   current_file_no_  OUT NUMBER,
   company_          IN  VARCHAR2 )
IS
   newrec_        company_invent_info_tab%ROWTYPE;
BEGIN   
   newrec_ := Lock_By_Keys___(company_);
   current_file_no_ := NVL(newrec_.next_it_intrastat_file_no, 1);
   
   newrec_.next_it_intrastat_file_no := current_file_no_ + 1;
   Modify___(newrec_);
END Create_Next_Intrastat_File_No;
-- gelr:italy_intrastat, end

