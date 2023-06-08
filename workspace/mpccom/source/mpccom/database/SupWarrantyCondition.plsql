-----------------------------------------------------------------------------
--
--  Logical unit: SupWarrantyCondition
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120213  HaPulk  Changed dynamic code to PARTCA (SerialWarrantyDates) as static
--  100520  MoNilk  Modified key flag to P in SUP_WARRANTY_CONDITION.condition_id.
--  100430  Ajpelk  Merge rose method documentation.
--  100120  MaMalk  Added global lu constants to replace the calls to Transaction_SYS.Logical_Unit_Is_Installed
--  100120          in the business logic.
--  ------------------------ 14.0.0 -----------------------------------------
--  060714  ChBalk  Removed obsolete public cursor Get_Sup_Warranty_Condition implementation.
--  ------------------------ 13.4.0 -----------------------------------------
--  060123  JaJalk  Added Assert safe annotation.
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040202  GeKalk  Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  ------------------------Version 13.3.0-----------------------------------
--  030206   vias    WP610 Warranties, Added public cursor Get_Sup_Warranty_Condition.
--  001124  PaLj    Changed method Check_Delete___
--  001122  PaLj    Added checks for min and max values.
--  001026  JoEd    Added method Copy_From_Template.
--  001023  PaLj    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SUP_WARRANTY_CONDITION_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   Serial_Warranty_Dates_API.Check_Condition__(remrec_.warranty_id, remrec_.warranty_type_id, remrec_.condition_id);   
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sup_warranty_condition_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
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
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sup_warranty_condition_tab%ROWTYPE,
   newrec_ IN OUT sup_warranty_condition_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
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
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   Creates a new warranty condition and copies  conditions from the
--   old warranty.
PROCEDURE Copy (
   old_warranty_id_ IN NUMBER,
   new_warranty_id_ IN NUMBER )
IS
   CURSOR get_record IS
      SELECT rowid objid
      FROM SUP_WARRANTY_CONDITION_TAB
      WHERE warranty_id = old_warranty_id_;

   newrec_     SUP_WARRANTY_CONDITION_TAB%ROWTYPE;
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
--   Copy warranty conditions from the template.
PROCEDURE Copy_From_Template (
   warranty_id_ IN NUMBER,
   template_id_ IN VARCHAR2 )
IS
   CURSOR get_template IS
      SELECT condition_id, min_value, max_value
      FROM SUP_WARRANTY_TEMP_COND_TAB
      WHERE template_id = template_id_;
   newrec_     SUP_WARRANTY_CONDITION_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   FOR rec_ IN get_template LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('WARRANTY_ID', warranty_id_, attr_);
      Client_SYS.Add_To_Attr('WARRANTY_TYPE_ID', template_id_, attr_);
      Client_SYS.Add_To_Attr('CONDITION_ID', rec_.condition_id, attr_);
      Client_SYS.Add_To_Attr('MIN_VALUE', rec_.min_value, attr_);
      Client_SYS.Add_To_Attr('MAX_VALUE', rec_.max_value, attr_);      
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP; 
END Copy_From_Template;



