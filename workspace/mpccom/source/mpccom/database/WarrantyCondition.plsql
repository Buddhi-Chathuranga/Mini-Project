-----------------------------------------------------------------------------
--
--  Logical unit: WarrantyCondition
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120525  JeLise   Made description private.
--  120507  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120507           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. Get_Condition_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100430  Ajpelk   Merge rose method documentation
--  090710  HiWilk   Bug 84235, Introduced Validate_Min_Max_Values___ method to validate Min Value and Max Value 
--  090710           in Unpack_Check_Update___ and Unpack_Check_Insert___. Added minus value check for Min Value and Max Value.
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040225  SaNalk  Removed SUBSTRB.
--  -----------------------Version 13.3.0-------------------------- ---------
--  001122  PaLj  Added checks for min and max values.
--  001121  PaLj  CID 53028. Added LOV-functionality to time_unit and unit_code.
--  001113  PaLj  Made condition_description mandatory
--  001010  PaLj  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

-- Get_Condition_Description
--   Fetches the ConditionDescription attribute for a record.
@UncheckedAccess
FUNCTION Get_Condition_Description (
   condition_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ warranty_condition_tab.condition_description%TYPE;
BEGIN
   IF (condition_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      condition_id_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT condition_description
      INTO  temp_
      FROM  warranty_condition_tab
      WHERE condition_id = condition_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_id_, 'Get_Condition_Description');
END Get_Condition_Description;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Condition_Id___ RETURN NUMBER
IS
   condition_id_   NUMBER;
   CURSOR get_next_condition_id IS
      SELECT condition_id.nextval
      FROM dual;
BEGIN
   OPEN get_next_condition_id;
   FETCH get_next_condition_id INTO condition_id_;
   CLOSE get_next_condition_id;
   RETURN condition_id_;
END Get_Next_Condition_Id___;


PROCEDURE Validate_Min_Max_Values___(
   rec_ IN WARRANTY_CONDITION_TAB%ROWTYPE )
IS
BEGIN
   
   IF ((rec_.min_value < 0) OR (rec_.max_value < 0)) THEN
      Error_SYS.Record_General(lu_name_, 'MINMAXNEG: The minimum and/or maximum value cannot have negative value(s).');
   END IF;    
   
   IF ( (rec_.min_value IS NOT NULL) AND (rec_.time_unit IS NOT NULL) AND ( TRUNC(rec_.min_value) != rec_.min_value) ) THEN
         Error_SYS.Record_General(lu_name_, 'MINTIMDEC: You cannot have decimals as Min Value when using a Time Unit!');
   END IF;

   IF ( (rec_.max_value IS NOT NULL) AND (rec_.time_unit IS NOT NULL) AND ( TRUNC(rec_.max_value) != rec_.max_value) ) THEN
         Error_SYS.Record_General(lu_name_, 'MAXTIMDEC: You cannot have decimals as Max Value when using a Time Unit!');
   END IF;

   IF ( (rec_.min_value IS NOT NULL) AND (rec_.max_value IS NOT NULL) ) THEN
      IF (rec_.min_value > rec_.max_value) THEN
         Error_SYS.Record_General(lu_name_, 'MINTOBIG: The Min Value cannot be greater than the Max Value!');
      END IF;
   END IF;
      
END Validate_Min_Max_Values___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WARRANTY_CONDITION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.condition_id := Get_Next_Condition_Id___;
   Client_SYS.Add_To_Attr('CONDITION_ID', newrec_.condition_id, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warranty_condition_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   -- Check of unit usage
   IF ((newrec_.time_unit IS NOT NULL) AND (newrec_.unit_code IS NOT NULL)) THEN
       Error_SYS.Record_General(lu_name_, 'TWO_UNITS: You cannot have both Time Unit and Other U/M. Please use one of them!');
   END IF;

   IF ((newrec_.time_unit IS NULL) AND (newrec_.unit_code IS NULL)) THEN
       Error_SYS.Record_General(lu_name_, 'NO_UNITS: You must specify Time Unit or Other U/M!');
   END IF;

   Validate_Min_Max_Values___(newrec_);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     warranty_condition_tab%ROWTYPE,
   newrec_ IN OUT warranty_condition_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   -- Check if unit usage
   IF ((newrec_.time_unit IS NOT NULL) AND (newrec_.unit_code IS NOT NULL)) THEN
       Error_SYS.Record_General(lu_name_, 'TWO_UNITS: You cannot have both Time Unit and Other U/M. Please use one of them!');
   END IF;

   IF ((newrec_.time_unit IS NULL) AND (newrec_.unit_code IS NULL)) THEN
       Error_SYS.Record_General(lu_name_, 'NO_UNITS: You must specify Time Unit or Other U/M!');
   END IF;
   
   Validate_Min_Max_Values___(newrec_);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


