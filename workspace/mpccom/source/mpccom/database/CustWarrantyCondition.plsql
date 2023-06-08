-----------------------------------------------------------------------------
--
--  Logical unit: CustWarrantyCondition
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210108  DiJwlk   SC2020R1-11841, Modified Add_Conditions(), Copy_From_Template(), Copy_From_Sup_Warranty() 
--  210108           by removing string manipulations to optimize performance.
--  151106  HimRlk   Bug 123910, Modified Copy() by adding error_when_no_source_ and error_when_existing_copy_ parameters.
--  140519  SURBLK   Set rowkey value as NULL in copy().
--  120213  HaPulk   Changed dynamic code to PARTCA (SerialWarrantyDates) as static
--  100520  MoNilk   Modified key flag to P in CUST_WARRANTY_CONDITION.condition_id.
--  100429  Ajpelk   Merge rose method documentation.
--  100120  MaMalk   Added global lu constants to replace the calls to Transaction_SYS.Logical_Unit_Is_Installed
--  100120           in the business logic.
--  091005  ChFolk   Removed unused variables.
--  ------------------------------ 14.0.0 -----------------------------------
--  060123  JaJalk   Added Assert safe annotation.
--  060111  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060111           and added UNDEFINE according to the new template.
--  --------------------------------- 13.3.0 --------------------------------
--  040202  GeKalk   Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  030911  MiKulk   Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  001124  PaLj     Changed method Check_Delete___
--  001122  PaLj     Added checks for min and max values.
--  001102  PaLj     Added method Add_Conditions
--  001025  JoEd     Added method Copy_From_Template.
--  001025  PaLj     Added method Copy_From_Sup_Warranty
--  001017  JoEd     Added method Copy.
--  001010  PaLj     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUST_WARRANTY_CONDITION_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   Serial_Warranty_Dates_API.Check_Condition__(remrec_.warranty_id, remrec_.warranty_type_id , remrec_.condition_id);   
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_warranty_condition_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   time_unit_db_ VARCHAR2(20) := NULL;
BEGIN
   super(newrec_, indrec_, attr_);
      -- Check of min and max values
   time_unit_db_ := Warranty_Condition_API.Get_Time_Unit_Db(newrec_.condition_id);

   IF ( (newrec_.min_value IS NOT NULL) AND (time_unit_db_ IS NOT NULL) AND ( TRUNC(newrec_.min_value) != newrec_.min_value) ) THEN
         Error_SYS.Record_General(lu_name_, 'MINTIMDEC: You cannot have decimals as Min Value when using a Time Unit!');
   END IF;

   IF ( (newrec_.max_value IS NOT NULL) AND (time_unit_db_ IS NOT NULL) AND ( TRUNC(newrec_.max_value) != newrec_.max_value) ) THEN
         Error_SYS.Record_General(lu_name_, 'MAXTIMDEC: You cannot have decimals as Max Value when using a Time Unit!');
   END IF;

   IF ( (newrec_.min_value IS NOT NULL) AND (newrec_.max_value IS NOT NULL) ) THEN
      IF (newrec_.min_value > newrec_.max_value) THEN
         Error_SYS.Record_General(lu_name_, 'MINTOBIG: The Min Value cannot be greater than the Max Value!');
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_warranty_condition_tab%ROWTYPE,
   newrec_ IN OUT cust_warranty_condition_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   time_unit_db_ VARCHAR2(20) := NULL;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   -- Check of min and max values
   time_unit_db_ := Warranty_Condition_API.Get_Time_Unit_Db(newrec_.condition_id);

   IF ( (newrec_.min_value IS NOT NULL) AND (time_unit_db_ IS NOT NULL) AND ( TRUNC(newrec_.min_value) != newrec_.min_value) ) THEN
         Error_SYS.Record_General(lu_name_, 'MINTIMDEC: You cannot have decimals as Min Value when using a Time Unit!');
   END IF;

   IF ( (newrec_.max_value IS NOT NULL) AND (time_unit_db_ IS NOT NULL) AND ( TRUNC(newrec_.max_value) != newrec_.max_value) ) THEN
         Error_SYS.Record_General(lu_name_, 'MAXTIMDEC: You cannot have decimals as Max Value when using a Time Unit!');
   END IF;

   IF ( (newrec_.min_value IS NOT NULL) AND (newrec_.max_value IS NOT NULL) ) THEN
      IF (newrec_.min_value > newrec_.max_value) THEN
         Error_SYS.Record_General(lu_name_, 'MINTOBIG: The Min Value cannot be greater than the Max Value!');
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   Creates a new warranty condition and copies  conditions from the
--   old warranty.
PROCEDURE Copy (
   old_warranty_id_          IN NUMBER,
   new_warranty_id_          IN NUMBER,
   error_when_no_source_     IN VARCHAR2 DEFAULT 'FALSE',
   error_when_existing_copy_ IN VARCHAR2 DEFAULT 'TRUE'  )
IS
   CURSOR get_record IS
      SELECT rowid objid
      FROM CUST_WARRANTY_CONDITION_TAB
      WHERE warranty_id = old_warranty_id_;

   newrec_     CUST_WARRANTY_CONDITION_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   oldrec_found_ BOOLEAN := FALSE;
BEGIN
   FOR rec_ IN get_record LOOP
      oldrec_found_ := TRUE;
      newrec_ := Get_Object_By_Id___(rec_.objid);
      newrec_.rowkey := NULL;
      Client_SYS.Clear_Attr(attr_);
      newrec_.warranty_id := new_warranty_id_;
      IF (NOT Check_Exist___(new_warranty_id_, newrec_.warranty_type_id, newrec_.condition_id)) THEN
         Insert___(objid_, objversion_, newrec_, attr_);
      ELSE
         IF (error_when_existing_copy_ = 'TRUE') THEN
            Error_SYS.Record_Exist(lu_name_, 'CUSWARCONEXIST: Customer warranty condition :P1 already exists for the warranty type :P2 in warranty :P3.', newrec_.condition_id, newrec_.warranty_type_id, newrec_.warranty_id);
         END IF;
      END IF;
   END LOOP;
   IF (NOT oldrec_found_ AND error_when_no_source_ = 'TRUE') THEN
      Error_SYS.Record_Not_Exist(lu_name_, 'CUSWARCNOTEXIST: Customer warranty condition does not exist.');
   END IF;
END Copy;


-- Copy_From_Sup_Warranty
--   Copy a Supplier warranty to a customer warranty with warranty conditions.
PROCEDURE Copy_From_Sup_Warranty (
   sup_warranty_id_ IN NUMBER,
   cust_warranty_id_ IN NUMBER )
IS
   CURSOR get_record IS
      SELECT warranty_type_id, condition_id, min_value, max_value
      FROM SUP_WARRANTY_CONDITION_PUB
      WHERE warranty_id = sup_warranty_id_;

   newrec_     CUST_WARRANTY_CONDITION_TAB%ROWTYPE;
BEGIN
   FOR suprec_ IN get_record LOOP
      newrec_.warranty_id      := cust_warranty_id_;
      newrec_.warranty_type_id := suprec_.warranty_type_id;
      newrec_.condition_id     := suprec_.condition_id;
      newrec_.min_value        := suprec_.min_value;
      newrec_.max_value        := suprec_.max_value;
      New___(newrec_);
   END LOOP;
END Copy_From_Sup_Warranty;


-- Copy_From_Template
--   Copy warranty conditions from the template.
PROCEDURE Copy_From_Template (
   warranty_id_ IN NUMBER,
   template_id_ IN VARCHAR2 )
IS
   CURSOR get_template IS
      SELECT condition_id, min_value, max_value
      FROM CUST_WARRANTY_TEMP_COND_TAB
      WHERE template_id = template_id_;
   newrec_     CUST_WARRANTY_CONDITION_TAB%ROWTYPE;
BEGIN
   FOR rec_ IN get_template LOOP
      newrec_.warranty_id      := warranty_id_;
      newrec_.warranty_type_id := template_id_;
      newrec_.condition_id     := rec_.condition_id;
      newrec_.min_value        := rec_.min_value;
      newrec_.max_value        := rec_.max_value;
      New___(newrec_);
   END LOOP;
END Copy_From_Template;


-- Add_Conditions
--   Add conditions from one warranty to another warranty.
PROCEDURE Add_Conditions (
   to_warranty_id_        IN NUMBER,
   from_warranty_id_      IN NUMBER,
   from_warranty_type_id_ IN VARCHAR2 )
IS
   CURSOR get_condition_info IS
   SELECT warranty_type_id, condition_id, min_value, max_value
   FROM CUST_WARRANTY_CONDITION_TAB
   WHERE warranty_id = from_warranty_id_
   AND warranty_type_id = from_warranty_type_id_;

   newrec_     CUST_WARRANTY_CONDITION_TAB%ROWTYPE;
BEGIN
   FOR rec_ IN get_condition_info LOOP
      newrec_.warranty_id      := to_warranty_id_;
      newrec_.warranty_type_id := from_warranty_type_id_;
      newrec_.condition_id     := rec_.condition_id;
      newrec_.min_value        := rec_.min_value;
      newrec_.max_value        := rec_.max_value;
      New___(newrec_);
   END LOOP;
END Add_Conditions;



