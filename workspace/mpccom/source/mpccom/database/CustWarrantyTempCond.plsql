-----------------------------------------------------------------------------
--
--  Logical unit: CustWarrantyTempCond
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100519  MoNilk   Modified key flag to P in CUST_WARRANTY_TEMP_COND.condition_id.
--  --------------------------------- 14.0.0 --------------------------------
--  090710  HiWilk   Bug 84235, Modified MINMAXNEG error message in Validate_Min_Max_Values___ method. 
--  090703  HiWilk   Bug 84235, Introduced Validate_Min_Max_Values___ method to validate Min Value and Max Value 
--  090703           in Unpack_Check_Update___ and Unpack_Check_Insert___. Added minus value check for Min Value and Max Value.
--  060111  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060111           and added UNDEFINE according to the new template.
--  --------------------------------- 13.3.0 --------------------------------
--  001122  PaLj     Added checks for min and max values.
--  001010  PaLj     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Min_Max_Values___(
   rec_ IN CUST_WARRANTY_TEMP_COND_TAB%ROWTYPE )
IS
   time_unit_db_ VARCHAR2(20) := NULL;
BEGIN
   
   IF ((rec_.min_value < 0) OR (rec_.max_value < 0)) THEN
      Error_SYS.Record_General(lu_name_, 'MINMAXNEG: The minimum and/or maximum value cannot have negative value(s).');
   END IF;    
   
   IF ( (rec_.min_value IS NOT NULL) AND (rec_.max_value IS NOT NULL) ) THEN
      IF (rec_.min_value > rec_.max_value) THEN
         Error_SYS.Record_General(lu_name_, 'MINTOBIG: The Min Value cannot be greater than the Max Value!');
      END IF;
   END IF;   
   
   time_unit_db_ := Warranty_Condition_API.Get_Time_Unit_Db(rec_.condition_id);

   IF ( (rec_.min_value IS NOT NULL) AND (time_unit_db_ IS NOT NULL) AND ( TRUNC(rec_.min_value) != rec_.min_value) ) THEN
         Error_SYS.Record_General(lu_name_, 'MINTIMDEC: You cannot have decimals as Min Value when using a Time Unit!');
   END IF;

   IF ( (rec_.max_value IS NOT NULL) AND (time_unit_db_ IS NOT NULL) AND ( TRUNC(rec_.max_value) != rec_.max_value) ) THEN
         Error_SYS.Record_General(lu_name_, 'MAXTIMDEC: You cannot have decimals as Max Value when using a Time Unit!');
   END IF;
   
END Validate_Min_Max_Values___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_warranty_temp_cond_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   
   Validate_Min_Max_Values___(newrec_);
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_warranty_temp_cond_tab%ROWTYPE,
   newrec_ IN OUT cust_warranty_temp_cond_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   Validate_Min_Max_Values___(newrec_);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


