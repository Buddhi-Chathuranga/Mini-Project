-----------------------------------------------------------------------------
--
--  Logical unit: PackSizeChargeListLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  111116  ChJalk   Modified the view PACK_SIZE_CHARGE_LIST_LINE to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111026  ChJalk   Modified the view PACK_SIZE_CHARGE_LIST_LINE to use the user allowed company filter.
--  110526  ShKolk   Added General_SYS for Get_Pack_Size_Chg_Line().
--  100421  ShKolk   Added Validate_Dates___().
--  100405  ShKolk   Added new column fixed_charge.
--  090930  DaZase   Added length on view comment for charge_list_no, made key columns (valid_from_date, input_unit_meas_group_id and unit_code) not updateable.
--  081023  MaJalk   Set VALID_FROM_DATE as SYSDATE at Prepare_Insert___.
--  081006  MaJalk   Changed condition for error message INVALVALUES1 at Unpack_Check_Insert___ and Unpack_Check_Update___.
--  080828  MaJalk   Changed the order of parameters at Get_Pack_Size_Chg_Line.
--  080825  MaJalk   Added validations for charge_percentage at Unpack_Check_Insert___ and Unpack_Check_Update___.
--    080730   MaJalk   Added method Get_Pack_Size_Chg_Line.
--  080630  MaJalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Dates___ (
   rec_   IN PACK_SIZE_CHARGE_LIST_LINE_TAB%ROWTYPE )
IS
   valid_from_  DATE;
   valid_to_    DATE;

   CURSOR get_data IS
      SELECT valid_from, valid_to
      FROM pack_size_charge_list_tab
      WHERE charge_list_no = rec_.charge_list_no;
BEGIN

   OPEN get_data;
   FETCH get_data INTO valid_from_, valid_to_;
   CLOSE get_data;

   IF ( TRUNC(rec_.valid_from_date) < TRUNC(valid_from_) ) OR
      ( TRUNC(rec_.valid_from_date) > TRUNC(NVL(valid_to_, Database_SYS.last_calendar_date_)) ) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDFROMDATE: Pack Size Charge Price List is Not valid for :P1.', to_char(rec_.valid_from_date, 'YYYY-MM-DD'));
   END IF;
END Validate_Dates___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', SYSDATE, attr_ );
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT pack_size_charge_list_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(newrec_, indrec_, attr_);   
   Validate_Dates___(newrec_);
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     pack_size_charge_list_line_tab%ROWTYPE,
   newrec_ IN OUT pack_size_charge_list_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (Input_Unit_Meas_API.Get_Cust_Usage_Allowed(newrec_.input_unit_meas_group_id, newrec_.unit_code) != 1 ) THEN
      Error_SYS.Record_General(lu_name_, 'INVALINPUTUOM: Sales Usage Allowed is not enabled for Input UoM Group :P1 and Input UoM :P2.', newrec_.input_unit_meas_group_id, newrec_.unit_code);
   END IF;

   IF (newrec_.charge_amount IS NOT NULL AND newrec_.charge_percentage IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INVALVALUES1: Either Charge Amount or Charge (%) is allowed.');
   END IF;

   IF (newrec_.charge_amount IS NULL AND newrec_.charge_percentage IS NULL AND newrec_.fixed_charge IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INVALVALUES2: Either the Charge Amount, the Charge (%) or the Fixed Charge should have a value.');
   END IF;

   IF ((newrec_.charge_amount < 0 OR newrec_.charge_percentage  < 0) AND newrec_.charge_cost != 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALVALUES3: Charge Cost must be zero for minus Charge Amounts or minus Charge (%).');
   END IF;

   IF ((newrec_.charge_percentage < -100) OR (newrec_.charge_percentage > 100)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALVALUES4: Discount must be between -100 and 100.');
   END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Pack_Size_Chg_Line
--   Returns charge_amount, charge_percentage, charge_cost and fixed_charge.
PROCEDURE Get_Pack_Size_Chg_Line (
   charge_amount_            OUT NUMBER,
   charge_percentage_        OUT NUMBER,
   charge_cost_              OUT NUMBER,
   fixed_charge_             OUT NUMBER,
   pack_size_charge_list_no_  IN VARCHAR2,
   input_unit_meas_group_id_  IN VARCHAR2,
   input_unit_meas_           IN VARCHAR2,
   price_effectivity_date_    IN DATE )
IS
   CURSOR get_attr IS
      SELECT charge_amount, charge_percentage, charge_cost, fixed_charge
      FROM PACK_SIZE_CHARGE_LIST_LINE_TAB
      WHERE charge_list_no             = pack_size_charge_list_no_
      AND   TRUNC(valid_from_date)    <= TRUNC(price_effectivity_date_)
      AND   unit_code                  = input_unit_meas_
      AND   input_unit_meas_group_id   = input_unit_meas_group_id_
      ORDER BY valid_from_date DESC;
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO charge_amount_, charge_percentage_, charge_cost_, fixed_charge_;
   CLOSE get_attr;
END Get_Pack_Size_Chg_Line;


@UncheckedAccess
FUNCTION Get_Fixed_Charge (
   charge_list_no_           IN VARCHAR2,
   valid_from_date_          IN DATE,
   input_unit_meas_group_id_ IN VARCHAR2,
   unit_code_                IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ PACK_SIZE_CHARGE_LIST_LINE_TAB.fixed_charge%TYPE;
   CURSOR get_attr IS
      SELECT fixed_charge
      FROM PACK_SIZE_CHARGE_LIST_LINE_TAB
      WHERE charge_list_no = charge_list_no_
      AND   TRUNC(valid_from_date) <= TRUNC(valid_from_date_)
      AND   input_unit_meas_group_id = input_unit_meas_group_id_
      AND   unit_code = unit_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Fixed_Charge;



