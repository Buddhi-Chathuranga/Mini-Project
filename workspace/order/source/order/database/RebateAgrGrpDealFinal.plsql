-----------------------------------------------------------------------------
--
--  Logical unit: RebateAgrGrpDealFinal
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170424  ThImlk   STRMF-10971, Modified Copy_Group_Deal_Final__() to set min_value and percentage values correctly, when copying rebate agreements.
--  131113  RoJalk   Hooks implementation - refactor files.
--  110819  NWeelk   Bug 97235, Added parameter from_valid_from_ to the method Copy_Group_Deal_Final__ and used it 
--  110819           to compare valid_from of the cursor to insert final settlement lines correctly.
--  110427  JeLise   Changed the comparison of valid_from in get_source_all in Copy_Group_Deal_Final__,
--  110427           and changed so the new lines will be created with the new valid_from_. 
--  091109  AmPalk   Bug 85942, The parent LU got the valid_from key. Hence valid_from became a key of this LU.
--  091109           Restricted the line deletion when the header is active. Modified Get_Final_Rebate to consider 
--  091109           valid period 1st and then the min qty when fetching the final rate.
--  091002  DaZase   Added length on view comments for rebate_type/sales_part_rebate_group. Changed so keys columns are not updatable.
--  080513  JeLise   Added method Check_Final_Rows_Exist.
--  080418  MaJalk   Added method Copy_Group_Deal_Final__.
--  080410  JeLise   Added Get_Final_Rebate.
--  080407  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN REBATE_AGR_GRP_DEAL_FINAL_TAB%ROWTYPE )
IS
BEGIN
   IF (Rebate_Agreement_API.Get_Rowstate(remrec_.agreement_id) = 'Active') THEN
      Error_SYS.Record_General(lu_name_, 'REBLINECANNOTDEL: Cannot delete the lines when the rebate agreement is active.');
   END IF;
   super(remrec_);
END Check_Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_Group_Deal_Final__
--   Copy an existing record details  to a new record.
PROCEDURE Copy_Group_Deal_Final__ (
   from_agreement_id_       IN VARCHAR2,
   to_agreement_id_         IN VARCHAR2,
   rebate_type_             IN VARCHAR2,
   sales_part_rebate_group_ IN VARCHAR2,
   hierarchy_id_            IN VARCHAR2,
   customer_level_          IN NUMBER,
   currency_rate_           IN NUMBER,
   valid_from_              IN DATE,
   from_valid_from_         IN DATE )
IS
   CURSOR  get_source_all IS
      SELECT *
      FROM REBATE_AGR_GRP_DEAL_FINAL_TAB
      WHERE agreement_id            = from_agreement_id_
      AND   rebate_type             = rebate_type_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_
      AND   valid_from              = from_valid_from_;

   attr_          VARCHAR2(32000);
   newrec_        REBATE_AGR_GRP_DEAL_FINAL_TAB%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   to_min_value_  REBATE_AGR_GRP_DEAL_FINAL_TAB.min_value%TYPE;
   to_percentage_ REBATE_AGR_GRP_DEAL_FINAL_TAB.percentage%TYPE;
   indrec_        Indicator_Rec;
BEGIN

   FOR source_rec_ IN get_source_all LOOP
      -- Copy the line
      Prepare_Insert___(attr_);
      
      IF (Rebate_Agreement_API.Get_Rebate_Criteria_Db(from_agreement_id_) = Rebate_Criteria_API.DB_PERCENTAGE )THEN
         to_min_value_  := (source_rec_.min_value * currency_rate_);
         to_percentage_ := source_rec_.percentage;
      ELSE
         to_min_value_ := source_rec_.min_value;
         to_percentage_ := (source_rec_.percentage * currency_rate_);
      END IF;
      
      Client_SYS.Add_To_Attr('AGREEMENT_ID', to_agreement_id_, attr_);
      Client_SYS.Add_To_Attr('REBATE_TYPE', source_rec_.rebate_type, attr_);
      Client_SYS.Add_To_Attr('SALES_PART_REBATE_GROUP', source_rec_.sales_part_rebate_group, attr_);
      Client_SYS.Add_To_Attr('HIERARCHY_ID', source_rec_.hierarchy_id, attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_LEVEL', source_rec_.customer_level, attr_);
      Client_SYS.Add_To_Attr('MIN_VALUE', to_min_value_ , attr_);
      Client_SYS.Add_To_Attr('VALID_FROM', valid_from_ , attr_);
      Client_SYS.Add_To_Attr('PERCENTAGE', to_percentage_, attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Copy_Group_Deal_Final__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Final_Rebate (
   agreement_id_            IN VARCHAR2,
   rebate_type_             IN VARCHAR2,
   sales_part_rebate_group_ IN VARCHAR2,
   hierarchy_id_            IN VARCHAR2,
   customer_level_          IN NUMBER,
   min_value_               IN NUMBER,
   period_end_date_         IN DATE ) RETURN NUMBER
IS
   percentage_          REBATE_AGR_GRP_DEAL_FINAL_TAB.percentage%TYPE;
   latest_valid_from_   DATE;
   latest_valid_parent_ DATE;
   max_min_value_       NUMBER;
   
   CURSOR get_latest_parent IS
      SELECT MAX(valid_from)
      FROM rebate_agreement_grp_deal_tab
      WHERE agreement_id            = agreement_id_
      AND   rebate_type             = rebate_type_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_
      AND   valid_from             <= TRUNC(period_end_date_);
   
   CURSOR get_latest_line IS
      SELECT MAX(valid_from)
      FROM REBATE_AGR_GRP_DEAL_FINAL_TAB
      WHERE agreement_id            = agreement_id_
      AND   rebate_type             = rebate_type_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_
      AND   valid_from             <= TRUNC(period_end_date_);

   CURSOR get_final_rebate IS
      SELECT MAX(min_value)
      FROM REBATE_AGR_GRP_DEAL_FINAL_TAB
      WHERE agreement_id            = agreement_id_
      AND   rebate_type             = rebate_type_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_
      AND   min_value              <= min_value_
      AND   valid_from              = TRUNC(latest_valid_from_);

   CURSOR get_final_pecentage IS
      SELECT percentage
      FROM REBATE_AGR_GRP_DEAL_FINAL_TAB
      WHERE agreement_id            = agreement_id_
      AND   rebate_type             = rebate_type_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_
      AND   min_value               = max_min_value_
      AND   valid_from              = TRUNC(latest_valid_from_);
BEGIN
   OPEN get_latest_parent;
   FETCH get_latest_parent INTO latest_valid_parent_;
   CLOSE get_latest_parent;

   OPEN get_latest_line;
   FETCH get_latest_line INTO latest_valid_from_;
   CLOSE get_latest_line;
   -- Once latest deal line selected, check the min value range. 
   -- IF a % not defined for that valid from date return 0.
   IF (latest_valid_parent_ IS NOT NULL) AND (latest_valid_from_ IS NOT NULL) AND (latest_valid_parent_ = latest_valid_from_) THEN
      OPEN get_final_rebate;
      FETCH get_final_rebate INTO max_min_value_;
      CLOSE get_final_rebate;
      IF (max_min_value_ IS NOT NULL) THEN
         OPEN get_final_pecentage;
         FETCH get_final_pecentage INTO percentage_;
         CLOSE get_final_pecentage;
      END IF;
   END IF;
   RETURN NVL(percentage_, 0);
END Get_Final_Rebate;


@UncheckedAccess
FUNCTION Check_Final_Rows_Exist (
   agreement_id_            IN VARCHAR2,
   rebate_type_             IN VARCHAR2,
   sales_part_rebate_group_ IN VARCHAR2,
   hierarchy_id_            IN VARCHAR2,
   customer_level_          IN NUMBER,
   valid_from_              IN DATE ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM REBATE_AGR_GRP_DEAL_FINAL_TAB
      WHERE agreement_id            = agreement_id_
      AND   rebate_type             = rebate_type_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_
      AND   valid_from              = valid_from_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';
END Check_Final_Rows_Exist;



