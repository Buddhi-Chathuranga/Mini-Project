-----------------------------------------------------------------------------
--
--  Logical unit: BatchScheduleChainStep
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  080630  HAAR  Created
-----------------------------------------------------------------------------

layer Core;


-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT BATCH_SCHEDULE_CHAIN_STEP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Modify_Presentation_Object___ (newrec_.schedule_method_id, newrec_.step_no);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     BATCH_SCHEDULE_CHAIN_STEP_TAB%ROWTYPE,
   newrec_     IN OUT BATCH_SCHEDULE_CHAIN_STEP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Modify_Presentation_Object___ (newrec_.schedule_method_id, newrec_.step_no);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN BATCH_SCHEDULE_CHAIN_STEP_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Remove_Parameters__ (remrec_.chain_schedule_method_id, remrec_.step_no,remrec_.schedule_method_id);
END Delete___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Modify_Presentation_Object___ (
   schedule_method_id_   IN NUMBER,
   step_no_              IN NUMBER )
IS
   po_id_          VARCHAR2(200);

   CURSOR get_step IS
      SELECT m.method_name, m.validation_method, m.po_id
      FROM batch_schedule_chain_step_tab s, batch_schedule_method_tab m
      WHERE s.schedule_method_id = schedule_method_id_
      AND   s.step_no = step_no_
      AND   s.chain_schedule_method_id = m.schedule_method_id
      ORDER BY s.step_no;
BEGIN
   IF Installation_SYS.Get_Installation_Mode THEN
      po_id_ := Batch_Schedule_Chain_API.Get_(schedule_method_id_, TRUE).po_id;
   ELSE
      po_id_ := Batch_Schedule_Chain_API.Get(schedule_method_id_).po_id;
   END IF;
   FOR rec IN get_step LOOP
      Pres_Object_Util_API.New_Pres_Object_Dependency (po_id_, rec.po_id, '4', 'Manual');
   END LOOP;
END Modify_Presentation_Object___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


@UncheckedAccess
FUNCTION Count_Batch_Method_Step__ (
   schedule_method_id_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN NULL;
END Count_Batch_Method_Step__;


PROCEDURE Remove_Parameters__ (
   schedule_method_id_ IN NUMBER,
   step_no_            IN NUMBER,
   chain_id_           IN NUMBER)
IS
BEGIN
   DELETE FROM batch_schedule_chain_par_tab
   WHERE  schedule_method_id = schedule_method_id_
   AND    step_no = step_no_
   AND schedule_id IN 
         (SELECT schedule_id 
            FROM batch_schedule_tab 
           WHERE schedule_method_id = chain_id_);
END Remove_Parameters__;


PROCEDURE Register__ (
   schedule_method_id_ IN     NUMBER,
   step_no_            IN     NUMBER,
   info_msg_           IN     VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     BATCH_SCHEDULE_CHAIN_STEP_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.schedule_method_id := schedule_method_id_;
   Client_SYS.Add_To_Attr('BREAK_ON_ERROR_DB', Message_SYS.Find_Attribute(info_msg_, 'BREAK_ON_ERROR_DB', ''), attr_);
   Client_SYS.Add_To_Attr('CHAIN_SCHEDULE_METHOD_ID', Batch_Schedule_Method_API.Get_Schedule_Method_Id(Message_SYS.Find_Attribute(info_msg_, 'METHOD_NAME', '')), attr_);
   --
   -- Check if method already exists in table
   --
   IF schedule_method_id_ IS NOT NULL THEN
      IF Check_Exist___ (schedule_method_id_, step_no_) THEN
         Error_SYS.Appl_General(lu_name_, 'DUPLICATE: The Batch Schedule Method Sequence already exists.');
      ELSE
         Client_SYS.Add_to_Attr('SCHEDULE_METHOD_ID', schedule_method_id_, attr_);
         Client_SYS.Add_to_Attr('STEP_NO', step_no_, attr_);
      END IF;
   END IF;
   --
   New__(info_, objid_, objversion_, attr_, 'DO');
END Register__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
