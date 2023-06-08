-----------------------------------------------------------------------------
--
--  Logical unit: SupWarrantyType
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190401  SaGelk  SCUXXW4-18316, Changed Warranty_Exist___ implementation method to a public method.
--  120213  HaPulk  Changed dynamic code to PARTCA (SerialWarrantyDates) as static
--  100430  Ajpelk  Merge rose method documentation
--  100120  MaMalk  Added global lu constants to replace the calls to Transaction_SYS.Logical_Unit_Is_Installed
--  100120          in the business logic.
--  -------------------------------- 14.0.0 ---------------------------------
--  060123  JaJalk  Added Assert safe annotation.
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040428  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  040225  SaNalk  Removed SUBSTRB.
--  040202  GeKalk  Remove the length parameter of bind varaibles for IN parameters for UNICODE modifications.
--  -------------------------------- 13.3.0 ----------------------------------
--  031010  DAYJLK  Call Id 105588, Modified Warranty_Dates_Per_Type to fetch the appropriate min_value_ and max_value_.
--  021104  PrTilk  Bug 33939, changed the attr_ length to 32000 in the PROCEDURE Copy_From_Template.
--  020604  ChFolk  Modified procedure, Warranty_Dates_Per_Type: extended the length of serial_no from 20 to 50.
--  ****************** AV 2002-3 Baseline ***********************************
--  001124  PaLj  Changed Unpack_Check_Insert___
--  001120  PaLj  Added methods Warranty_Dates_At_Delivery, Warranty_Dates_At_Arrival and Warranty_Dates_Per_Type
--  000120  PaLj  Rebuild: now having dynamic calls to Part Catalog LU:s
--  001113  PaLj  Added WARRANTY_CONDITION_RULE to prepare_insert___
--  001031  JoEd  Added method Warranty_Exist___ and use of that in Delete___.
--  001024  JoEd  Added attribute warranty_condition_rule.
--  001023  PaLj  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_ORDER_CONNECTION_DB', 'NOT CALCULATE', attr_);
   Client_SYS.Add_To_Attr('CONVERT_TO_CUST_ORD_DB', 'NOT CONVERT', attr_);
   Client_SYS.Add_To_Attr('MATERIAL_COST_TYPE_DB', 'MATERIAL', attr_);
   Client_SYS.Add_To_Attr('EXPENSES_COST_TYPE_DB', 'EXPENSES', attr_);
   Client_SYS.Add_To_Attr('FIXED_PRICE_COST_TYPE_DB', 'FIXED PRICE', attr_);
   Client_SYS.Add_To_Attr('PERSONNEL_COST_TYPE_DB', 'PERSONNEL', attr_);
   Client_SYS.Add_To_Attr('EXTERNAL_COST_TYPE_DB', 'EXTERNAL', attr_);
   Client_SYS.Add_To_Attr('WARRANTY_CONDITION_RULE', Warranty_Condition_Rule_API.Decode('INCLUSIVE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN SUP_WARRANTY_TYPE_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);

   -- if no more warranty types, remove warranty header
   IF NOT Warranty_Exist(remrec_.warranty_id) THEN
      Sup_Warranty_API.Remove(remrec_.warranty_id);
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sup_warranty_type_tab%ROWTYPE,
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

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   Creates a new warranty type and copies all warranty types from
--   the old warranty.
PROCEDURE Copy (
   old_warranty_id_ IN NUMBER,
   new_warranty_id_ IN NUMBER )
IS
   CURSOR get_record IS
      SELECT rowid objid
      FROM SUP_WARRANTY_TYPE_TAB
      WHERE warranty_id = old_warranty_id_;

   newrec_     SUP_WARRANTY_TYPE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
BEGIN
   FOR rec_ IN get_record LOOP
      newrec_ := Get_Object_By_Id___(rec_.objid);
      Client_SYS.Clear_Attr(attr_);
      newrec_.warranty_id := new_warranty_id_;
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Copy;


-- Copy_From_Template
--   Copies warranty types from the template.
PROCEDURE Copy_From_Template (
   warranty_id_ IN NUMBER,
   template_id_ IN VARCHAR2 )
IS
   CURSOR get_template IS
      SELECT warranty_description, note_text, material_cost_type,
             expenses_cost_type, fixed_price_cost_type, personnel_cost_type,
             external_cost_type, warranty_condition_rule, customer_order_connection,
             convert_to_cust_ord
      FROM SUP_WARRANTY_TYPE_TEMP_TAB
      WHERE template_id = template_id_;
   newrec_     SUP_WARRANTY_TYPE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_Rec;
BEGIN
   FOR rec_ IN get_template LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('WARRANTY_ID', warranty_id_, attr_);
      Client_SYS.Add_To_Attr('WARRANTY_TYPE_ID', template_id_, attr_);
      Client_SYS.Add_To_Attr('WARRANTY_DESCRIPTION', rec_.warranty_description, attr_);
      Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
      Client_SYS.Add_To_Attr('MATERIAL_COST_TYPE_DB', rec_.material_cost_type, attr_);
      Client_SYS.Add_To_Attr('EXPENSES_COST_TYPE_DB', rec_.expenses_cost_type, attr_);
      Client_SYS.Add_To_Attr('FIXED_PRICE_COST_TYPE_DB', rec_.fixed_price_cost_type, attr_);
      Client_SYS.Add_To_Attr('PERSONNEL_COST_TYPE_DB', rec_.personnel_cost_type, attr_);
      Client_SYS.Add_To_Attr('EXTERNAL_COST_TYPE_DB', rec_.external_cost_type, attr_);
      Client_SYS.Add_To_Attr('WARRANTY_CONDITION_RULE_DB', rec_.warranty_condition_rule, attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_ORDER_CONNECTION_DB', rec_.customer_order_connection, attr_);
      Client_SYS.Add_To_Attr('CONVERT_TO_CUST_ORD_DB', rec_.convert_to_cust_ord, attr_);
      
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
   Sup_Warranty_Condition_API.Copy_From_Template(warranty_id_, template_id_);
END Copy_From_Template;


-- Convert_To_Cust_Warranty
--   This will convert a supplier warranty to a customer warranty.
PROCEDURE Convert_To_Cust_Warranty (
   sup_warranty_id_  IN     NUMBER,
   cust_warranty_id_ IN OUT NUMBER )
IS
   CURSOR any_convert_type IS
      SELECT 1
      FROM SUP_WARRANTY_TYPE_PUB
      WHERE warranty_id = sup_warranty_id_
      AND convert_to_cust_ord_db = 'CONVERT';

   convert_ NUMBER;
BEGIN
   OPEN any_convert_type;
   FETCH any_convert_type INTO convert_;
   CLOSE any_convert_type;
   IF (convert_ = 1) THEN
      -- Copy the sup warranty to a new or a existing cust warranty
      Cust_Warranty_API.Copy_From_Sup_Warranty(cust_warranty_id_, sup_warranty_id_);
   END IF;
END Convert_To_Cust_Warranty;


-- Warranty_Dates_At_Arrival
--   This will calculate warranty dates at arrival.
PROCEDURE Warranty_Dates_At_Arrival (
   part_no_           IN VARCHAR2,
   serial_no_         IN VARCHAR2,
   sup_warranty_id_   IN NUMBER,
   arrival_date_      IN DATE DEFAULT SYSDATE )
IS
   CURSOR connection_type IS
      SELECT warranty_type_id
      FROM SUP_WARRANTY_TYPE_TAB
      WHERE warranty_id = sup_warranty_id_
      AND customer_order_connection = 'NOT CALCULATE';
BEGIN

   FOR rec_ IN connection_type LOOP
      Warranty_Dates_Per_Type(part_no_, serial_no_, sup_warranty_id_, rec_.warranty_type_id, arrival_date_);
   END LOOP;

END Warranty_Dates_At_Arrival;


-- Warranty_Dates_At_Delivery
--   This will calculate warranty dates at delivery.
PROCEDURE Warranty_Dates_At_Delivery (
   part_no_           IN VARCHAR2,
   serial_no_         IN VARCHAR2,
   sup_warranty_id_   IN NUMBER,
   delivery_date_     IN DATE DEFAULT SYSDATE )
IS
   CURSOR get_type IS
      SELECT warranty_type_id
      FROM SUP_WARRANTY_TYPE_TAB
      WHERE warranty_id = sup_warranty_id_;
BEGIN

   FOR rec_ IN get_type LOOP
      Warranty_Dates_Per_Type(part_no_, serial_no_, sup_warranty_id_, rec_.warranty_type_id, delivery_date_);
   END LOOP;

END Warranty_Dates_At_Delivery;


-- Warranty_Dates_Per_Type
--   This will calculate warranty dates at per Warranty Type.
PROCEDURE Warranty_Dates_Per_Type (
  part_no_          IN VARCHAR2,
  serial_no_        IN VARCHAR2,
  sup_warranty_id_  IN NUMBER,
  warranty_type_id_ IN VARCHAR2,
  start_date_       IN DATE DEFAULT SYSDATE)
IS
   time_unit_ VARCHAR2(5);   
   min_value_ NUMBER;
   max_value_ NUMBER;

   CURSOR get_sup_conditions IS
      SELECT warranty_type_id, condition_id, min_value, max_value
      FROM SUP_WARRANTY_CONDITION_PUB
      WHERE warranty_id = sup_warranty_id_
      AND warranty_type_id = warranty_type_id_;

BEGIN

   FOR rec_ IN get_sup_conditions LOOP
      Trace_SYS.Field('part_no_ = ',part_no_);
      Trace_SYS.Field('serial_no_ = ',serial_no_);
      Trace_SYS.Field('sup_warranty_id_ = ',sup_warranty_id_);
      Trace_SYS.Field('warranty_type_id_ = ',warranty_type_id_);
      Trace_SYS.Field('rec_.condition_id = ',rec_.condition_id);
      time_unit_ := Warranty_Condition_API.Get_Time_Unit_Db(rec_.condition_id);
      IF (time_unit_ IS NOT NULL) THEN
         min_value_ := rec_.min_value;
         max_value_ := rec_.max_value;
         IF (min_value_ IS NULL) THEN
            -- Fetch from Supplier Warranty Type Template
            min_value_ := Sup_Warranty_Temp_Cond_API.Get_Min_Value(warranty_type_id_ ,
                                                                   rec_.condition_id);
            IF (min_value_ IS NOT NULL) THEN
               max_value_ := Sup_Warranty_Temp_Cond_API.Get_Max_Value(warranty_type_id_ ,
                                                                      rec_.condition_id);
            END IF;
         END IF;
         
         Serial_Warranty_Dates_API.Calculate_Dates(part_no_, serial_no_, sup_warranty_id_, warranty_type_id_, rec_.condition_id, time_unit_, min_value_, max_value_, start_date_, 
                                                   Time_Unit_API.Get_Db_Value(0), Time_Unit_API.Get_Db_Value(1), Time_Unit_API.Get_Db_Value(2));         
      END IF;
   END LOOP;
END Warranty_Dates_Per_Type;

-- Warranty_Exist
--   Return FALSE if there are no more warranty types on the current ID.
FUNCTION Warranty_Exist (
   warranty_id_ IN NUMBER ) RETURN BOOLEAN
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM SUP_WARRANTY_TYPE_TAB
      WHERE warranty_id = warranty_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN (found_ = 1);
END Warranty_Exist;
