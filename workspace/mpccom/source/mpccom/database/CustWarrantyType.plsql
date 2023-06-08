-----------------------------------------------------------------------------
--
--  Logical unit: CustWarrantyType
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201222  BudKlk  SC2020R1-11924, Corrected the errors in this file.
--  201222  BudKlk  SC2020R1-11841, Removed Client_SYS.Add_To_Attr and made assignments directly to record where it is possible.
--  190115  SWiclk  SCUXXW4-7645, Added Warranty_Types_Exist().
--  151106  HimRlk  Bug 123910, Modified Copy() by adding error_when_no_source_ and error_when_existing_copy_ parameters.
--  140519  SURBLK  Set rowkey value as NULL in copy().
--  120213  HaPulk  Changed dynamic code to PARTCA (SerialWarrantyDates) as static
--  100429  Ajpelk  Merge rose method documentation
--  100120  MaMalk  Added global lu constants to replace the calls to Transaction_SYS.Logical_Unit_Is_Installed
--  100120          in the business logic.
--  ------------------------------- 14.0.0 ----------------------------------
--  060123  JaJalk  Added Assert safe annotation.
--  060111  SeNslk  Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060111          and added UNDEFINE according to the new template.
--  050919  NaLrlk  Removed unused variables.
--  040428  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  040223  SaNalk  Removed SUBSTRB.
--  040202  GeKalk  Remove the length parameter of bind varaibles for IN parameters for UNICODE modifications.
--  -------------------------------- 13.3.0 ----------------------------------
--  031010  DAYJLK  Call Id 105588, Modified Warranty_Dates_Per_Type to fetch the appropriate min_value_ and max_value_.
--  030911  MiKulk  Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  021104  PrTilk  Bug 33939, changed the attr_ length to 32000 in the PROCEDURE Copy_From_Template.
--  020604  ChFolk  Modified the length of serial_no from 20 to 50 in Warranty_Dates_Per_Type.
--  ****************** AV 2002-3 Baseline ***********************************
--  010525  JSAnse  Bug 21463, Removed 'TRUE' as last parameter in the General_SYS.Init_Method call in Warranty_Dates_Per_Type.
--  001124  PaLj    Changed Unpack_Check_Insert___
--  001124  PaLj    Changed Method Merge
--  001120  PaLj    Added methods Warranty_Dates_At_Delivery, Warranty_Dates_At_Arrival and Warranty_Dates_Per_Type
--  000120  PaLj    Rebuild: now having dynamic calls to Part Catalog LU:s
--  001113  PaLj    Added WARRANTY_CONDITION_RULE to prepare_insert___
--  001102  PaLj    Added methods Merge, Add_Type and changed Delete___ and Remove__
--  001031  JoEd    Added method Warranty_Exist___ and use of that in Delete___.
--  001025  PaLj    added method Copy_From_Sup_Warranty
--  001017  JoEd    Added method Copy.
--  001010  PaLj    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Warranty_Exist___
--   Return FALSE if there are no more warranty types on the current ID.
FUNCTION Warranty_Exist___ (
   warranty_id_ IN NUMBER ) RETURN BOOLEAN
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM CUST_WARRANTY_TYPE_TAB
      WHERE warranty_id = warranty_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN (found_ = 1);
END Warranty_Exist___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('MATERIAL_COST_TYPE_DB', 'NOT MATERIAL', attr_);
   Client_SYS.Add_To_Attr('EXPENSES_COST_TYPE_DB', 'NOT EXPENSES', attr_);
   Client_SYS.Add_To_Attr('FIXED_PRICE_COST_TYPE_DB', 'NOT FIXED PRICE', attr_);
   Client_SYS.Add_To_Attr('PERSONNEL_COST_TYPE_DB', 'NOT PERSONNEL', attr_);
   Client_SYS.Add_To_Attr('EXTERNAL_COST_TYPE_DB', 'NOT EXTERNAL', attr_);
   Client_SYS.Add_To_Attr('WARRANTY_CONDITION_RULE', Warranty_Condition_Rule_API.Decode('INCLUSIVE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_warranty_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF newrec_.warranty_condition_rule IS NULL THEN
      newrec_.warranty_condition_rule := 'INCLUSIVE';
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ CUST_WARRANTY_TYPE_TAB%ROWTYPE;
BEGIN
   remrec_ := Get_Object_By_Id___(objid_);
   super(info_, objid_, objversion_, action_);
   IF (action_ = 'DO') THEN
      -- if no more warranty types, remove warranty header
      IF NOT Warranty_Exist___(remrec_.warranty_id) THEN
         Cust_Warranty_API.Remove(remrec_.warranty_id);
      END IF;
   END IF;
   info_ := info_ || Client_SYS.Get_All_Info;
END Remove__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   Creates a new warranty type and copies all warranty types from
--   the old warranty.
PROCEDURE Copy (
   old_warranty_id_          IN NUMBER,
   new_warranty_id_          IN NUMBER,
   error_when_no_source_     IN VARCHAR2 DEFAULT 'FALSE',
   error_when_existing_copy_ IN VARCHAR2 DEFAULT 'TRUE' )
IS
   CURSOR get_record IS
      SELECT rowid objid
      FROM CUST_WARRANTY_TYPE_TAB
      WHERE warranty_id = old_warranty_id_;

   newrec_     CUST_WARRANTY_TYPE_TAB%ROWTYPE;
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
      IF (NOT Check_Exist___(new_warranty_id_, newrec_.warranty_type_id)) THEN
         Insert___(objid_, objversion_, newrec_, attr_);
      ELSE
         IF (error_when_existing_copy_ = 'TRUE') THEN
            Error_SYS.Record_Exist(lu_name_, 'CUSWARTEXIST: Customer warranty type :P1 already exists for the warranty :P2.', newrec_.warranty_type_id, new_warranty_id_);
         END IF;
      END IF;
   END LOOP;
   IF (NOT oldrec_found_ AND error_when_no_source_ = 'TRUE') THEN
      Error_SYS.Record_Not_Exist(lu_name_, 'CUSWARTNOTEXIST: Customer warranty type does not exist.');
   END IF;
END Copy;


-- Copy_From_Sup_Warranty
--   Copy a Supplier warranty type to a customer warranty type.
PROCEDURE Copy_From_Sup_Warranty (
   sup_warranty_id_  IN NUMBER,
   cust_warranty_id_ IN NUMBER )
IS
   CURSOR get_record IS
      SELECT warranty_id, warranty_type_id, warranty_description, note_text,
             expenses_cost_type_db, external_cost_type_db, fixed_price_cost_type_db,
             material_cost_type_db, personnel_cost_type_db, warranty_condition_rule_db
      FROM SUP_WARRANTY_TYPE_PUB
      WHERE warranty_id = sup_warranty_id_;
   newrec_     CUST_WARRANTY_TYPE_TAB%ROWTYPE;
   tmp_        VARCHAR2(15);

BEGIN
   FOR suprec_ IN get_record LOOP
      newrec_.warranty_id := cust_warranty_id_;
      newrec_.warranty_type_id := suprec_.warranty_type_id;
      newrec_.warranty_description := suprec_.warranty_description;
      newrec_.note_text := suprec_.note_text;

      -- INVERT the five cost type flags

      IF suprec_.expenses_cost_type_db = 'EXPENSES' THEN
         tmp_ := 'NOT EXPENSES';
      ELSIF suprec_.expenses_cost_type_db = 'NOT EXPENSES' THEN
         tmp_ := 'EXPENSES';
      ELSE
         tmp_ := NULL; 
      END IF;
      newrec_.expenses_cost_type := tmp_;

       IF suprec_.external_cost_type_db = 'EXTERNAL' THEN
         tmp_ := 'NOT EXTERNAL';
      ELSIF suprec_.external_cost_type_db = 'NOT EXTERNAL' THEN
         tmp_ := 'EXTERNAL';
      ELSE
         tmp_ := NULL;
      END IF;
      newrec_.external_cost_type := tmp_;
       IF suprec_.fixed_price_cost_type_db = 'FIXED PRICE' THEN
         tmp_ := 'NOT FIXED PRICE';
      ELSIF suprec_.fixed_price_cost_type_db = 'NOT FIXED PRICE' THEN
         tmp_ := 'FIXED PRICE';
      ELSE
         tmp_ := NULL;
      END IF;
      newrec_.fixed_price_cost_type := tmp_;

      IF suprec_.material_cost_type_db = 'MATERIAL' THEN
         tmp_ := 'NOT MATERIAL';
      ELSIF suprec_.material_cost_type_db = 'NOT MATERIAL' THEN
         tmp_ := 'MATERIAL';
      ELSE
         tmp_ := NULL;
      END IF;
      newrec_.material_cost_type := tmp_;

      IF suprec_.personnel_cost_type_db = 'PERSONNEL' THEN
         tmp_ := 'NOT PERSONNEL';
      ELSIF suprec_.personnel_cost_type_db = 'NOT PERSONNEL' THEN
         tmp_ := 'PERSONNEL';
      ELSE
         tmp_ := NULL;
      END IF;
      newrec_.personnel_cost_type := tmp_;
      
      newrec_.warranty_condition_rule := suprec_.warranty_condition_rule_db;

      New___(newrec_);
   END LOOP;
END Copy_From_Sup_Warranty;


-- Copy_From_Template
--   Copies warranty types from the template.
PROCEDURE Copy_From_Template (
   warranty_id_ IN NUMBER,
   template_id_ IN VARCHAR2 )
IS
   CURSOR get_template IS
      SELECT warranty_description, note_text, material_cost_type,
             expenses_cost_type, fixed_price_cost_type, personnel_cost_type,
             external_cost_type, warranty_condition_rule
      FROM CUST_WARRANTY_TYPE_TEMP_TAB
      WHERE template_id = template_id_;
   newrec_     CUST_WARRANTY_TYPE_TAB%ROWTYPE;
   
BEGIN
   FOR rec_ IN get_template LOOP
      
      newrec_.warranty_id := warranty_id_;
      newrec_.warranty_type_id := template_id_;
      newrec_.warranty_description := rec_.warranty_description;
      newrec_.note_text := rec_.note_text;
      newrec_.material_cost_type := rec_.material_cost_type;
      newrec_.expenses_cost_type := rec_.expenses_cost_type;
      newrec_.fixed_price_cost_type := rec_.fixed_price_cost_type;
      newrec_.personnel_cost_type := rec_.personnel_cost_type;
      newrec_.external_cost_type := rec_.external_cost_type;
      newrec_.warranty_condition_rule := rec_.warranty_condition_rule;

      New___(newrec_);
   END LOOP;
   Cust_Warranty_Condition_API.Copy_From_Template(warranty_id_, template_id_);
   Warranty_Lang_Desc_API.Copy_From_Template(warranty_id_, template_id_);
END Copy_From_Template;


-- Merge
--   This will merge one warranty to anther and delete the first one from
--   the table.
PROCEDURE Merge (
   from_warranty_id_ IN     NUMBER,
   to_warranty_id_   IN     NUMBER )
IS
   CURSOR from_types IS
   SELECT warranty_type_id
   FROM CUST_WARRANTY_TYPE_TAB
   WHERE warranty_id = from_warranty_id_;

   CURSOR to_types IS
   SELECT warranty_type_id
   FROM CUST_WARRANTY_TYPE_TAB
   WHERE warranty_id = to_warranty_id_;

   type_collision_ BOOLEAN;
   remrec_    CUST_WARRANTY_TYPE_TAB%ROWTYPE;

   objid_      CUST_WARRANTY_TYPE.objid%TYPE;
   objversion_ CUST_WARRANTY_TYPE.objversion%TYPE;   
BEGIN
   FOR from_rec_ IN from_types LOOP
      type_collision_ := FALSE;
      FOR to_rec_ IN to_types LOOP
         IF (from_rec_.warranty_type_id = to_rec_.warranty_type_id) THEN
            type_collision_ := TRUE;
         END IF;
      END LOOP;
      IF type_collision_ THEN
         -- Delete already calulated warranty dates on the removed type
         Serial_Warranty_Dates_API.Remove_Type(to_warranty_id_, from_rec_.warranty_type_id);         
         -- remove the type from the to_warranty_id with its conditions and lang_desc
         Get_Id_Version_By_Keys___(objid_, objversion_, to_warranty_id_, from_rec_.warranty_type_id);
         remrec_ := Lock_By_Id___(objid_, objversion_);
         Check_Delete___(remrec_);
         --Does cascade delete of the conditions and langdescs
         Delete___(objid_, remrec_);

      END IF;
      -- insert the type and its conditions and lang_desc to the to_warranty_id from from_warranty_id
      Cust_Warranty_Type_API.Add_Type(to_warranty_id_, from_warranty_id_, from_rec_.warranty_type_id);
      Warranty_Lang_Desc_API.Add_Descs(to_warranty_id_, from_warranty_id_, from_rec_.warranty_type_id);
      Cust_Warranty_Condition_API.Add_Conditions(to_warranty_id_, from_warranty_id_, from_rec_.warranty_type_id);
   END LOOP;
END Merge;


-- Add_Type
--   This will add customer warranty types from one warranty to another.
PROCEDURE Add_Type (
   to_warranty_id_        IN NUMBER,
   from_warranty_id_      IN NUMBER,
   from_warranty_type_id_ IN VARCHAR2 )
IS
   newrec_     CUST_WARRANTY_TYPE_TAB%ROWTYPE;
   
   CURSOR get_type_info IS
   SELECT *
   FROM CUST_WARRANTY_TYPE_TAB
   WHERE warranty_id = from_warranty_id_
   AND warranty_type_id = from_warranty_type_id_;   

BEGIN
   FOR rec_ IN get_type_info LOOP

      newrec_.warranty_id := to_warranty_id_;
      newrec_.warranty_type_id := from_warranty_type_id_;
      newrec_.warranty_description := rec_.warranty_description;
      newrec_.note_text := rec_.note_text;
      newrec_.material_cost_type := rec_.material_cost_type;
      newrec_.expenses_cost_type := rec_.expenses_cost_type;
      newrec_.fixed_price_cost_type := rec_.fixed_price_cost_type;
      newrec_.personnel_cost_type := rec_.personnel_cost_type;
      newrec_.external_cost_type := rec_.external_cost_type;
      newrec_.warranty_condition_rule := rec_.warranty_condition_rule;
      
      New___(newrec_);
   END LOOP;
END Add_Type;


-- Warranty_Dates_At_Arrival
--   This will calculate warranty dates at arrival.
PROCEDURE Warranty_Dates_At_Arrival (
   part_no_           IN VARCHAR2,
   serial_no_         IN VARCHAR2,
   cust_warranty_id_  IN NUMBER,
   sup_warranty_id_   IN NUMBER,
   arrival_date_      IN DATE DEFAULT SYSDATE )
IS
   CURSOR connection_type IS
      SELECT warranty_type_id
      FROM SUP_WARRANTY_TYPE_PUB
      WHERE warranty_id = sup_warranty_id_
      AND customer_order_connection_db = 'NOT CALCULATE';

BEGIN
   FOR rec_ IN connection_type LOOP
      Warranty_Dates_Per_Type(part_no_, serial_no_, cust_warranty_id_, rec_.warranty_type_id, arrival_date_);
   END LOOP;
END Warranty_Dates_At_Arrival;


-- Warranty_Dates_At_Delivery
--   This will calculate warranty dates at delivery.
PROCEDURE Warranty_Dates_At_Delivery (
   part_no_           IN VARCHAR2,
   serial_no_         IN VARCHAR2,
   cust_warranty_id_  IN NUMBER,
   delivery_date_      IN DATE DEFAULT SYSDATE )
IS
   CURSOR connection_type IS
      SELECT warranty_type_id
      FROM CUST_WARRANTY_TYPE_TAB
      WHERE warranty_id = cust_warranty_id_;
BEGIN
   FOR rec_ IN connection_type LOOP
      Warranty_Dates_Per_Type(part_no_, serial_no_, cust_warranty_id_, rec_.warranty_type_id, delivery_date_);
   END LOOP;
END Warranty_Dates_At_Delivery;


-- Warranty_Dates_Per_Type
--   This will calculate warranty dates per warranty type.
PROCEDURE Warranty_Dates_Per_Type (
  part_no_ IN VARCHAR2,
  serial_no_ IN VARCHAR2,
  warranty_id_ IN NUMBER,
  warranty_type_id_ IN VARCHAR2,
  start_date_ IN DATE DEFAULT SYSDATE)
IS
   time_unit_ VARCHAR2(5);   
   min_value_ NUMBER;
   max_value_ NUMBER;
   CURSOR get_cust_conditions IS
      SELECT warranty_type_id, condition_id, min_value, max_value
      FROM CUST_WARRANTY_CONDITION_PUB
      WHERE warranty_id = warranty_id_
      AND warranty_type_id = warranty_type_id_;
BEGIN
   FOR rec_ IN get_cust_conditions LOOP
      time_unit_ := Warranty_Condition_API.Get_Time_Unit_Db(rec_.condition_id);
      IF (time_unit_ IS NOT NULL) THEN
         min_value_ := rec_.min_value;
         max_value_ := rec_.max_value;
         IF (min_value_ IS NULL) THEN
            -- Fetch from Customer Warranty Type Template
            min_value_ := Cust_Warranty_Temp_Cond_API.Get_Min_Value(warranty_type_id_ ,
                                                                    rec_.condition_id);
            IF (min_value_ IS NOT NULL) THEN
               max_value_ := Cust_Warranty_Temp_Cond_API.Get_Max_Value(warranty_type_id_ ,
                                                                       rec_.condition_id);
            END IF;
         END IF;

         Serial_Warranty_Dates_API.Calculate_Dates(part_no_, serial_no_, warranty_id_, warranty_type_id_,
                                                   rec_.condition_id, time_unit_, min_value_, max_value_, start_date_, 
                                                   Time_Unit_API.Get_Db_Value(0), Time_Unit_API.Get_Db_Value(1), Time_Unit_API.Get_Db_Value(2));         
      END IF;
   END LOOP;
END Warranty_Dates_Per_Type;

FUNCTION Warranty_Types_Exist (
   warranty_id_ IN NUMBER ) RETURN BOOLEAN
IS   
BEGIN  
   RETURN Warranty_Exist___(warranty_id_);
END Warranty_Types_Exist;



