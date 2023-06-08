-----------------------------------------------------------------------------
--
--  Logical unit: EquipObjDownTimeTask
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220110  TGUNLK  AM21R2-3586, Created for IFS Cloud - 22R1
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT equip_obj_downtime_task_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.created_by      := Fnd_Session_API.Get_Fnd_User();
   newrec_.created_date    := Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq));

   Client_SYS.Add_To_Attr('CREATED_BY', newrec_.created_by, attr_);
   Client_SYS.Add_To_Attr('CREATED_DATE', newrec_.created_date, attr_);
   
   super(objid_, objversion_, newrec_, attr_);

END Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@IgnoreUnitTest TrivialFunction
PROCEDURE New(
  newrec_ IN OUT equip_obj_downtime_task_tab%ROWTYPE )
IS
BEGIN
   New___(newrec_);
END New;


@IgnoreUnitTest TrivialFunction
FUNCTION Is_Task_Downtime_Reported(
   task_seq_   IN NUMBER) RETURN VARCHAR2
IS
   dummy_    NUMBER;
   CURSOR check_record_exist IS
      SELECT 1
      FROM  equip_obj_downtime_task_tab
      WHERE task_seq  = task_seq_;
   
BEGIN
   OPEN check_record_exist;
   FETCH check_record_exist INTO dummy_;
   IF (check_record_exist%NOTFOUND) THEN
      CLOSE check_record_exist;
      RETURN Fnd_Boolean_API.DB_FALSE;
   END IF;
   CLOSE check_record_exist;
   
   RETURN Fnd_Boolean_API.DB_TRUE;
END Is_Task_Downtime_Reported;


FUNCTION Get_Obj_Downtime_Duration(
   task_seq_   IN NUMBER,
   equipment_object_seq_   IN NUMBER) RETURN NUMBER
IS
   downtime_           DATE;
   uptime_             DATE;
   downtime_duration_  NUMBER;
   
   CURSOR get_downtime_seq IS
      SELECT d.downtime, d.uptime 
      FROM  equip_obj_downtime_task_tab t, equip_obj_downtime_tab d
      WHERE d.downtime_seq = t.downtime_seq
      AND d.equipment_object_seq = t.equipment_object_seq
      AND t.task_seq  = task_seq_
      AND t.equipment_object_seq = equipment_object_seq_;
   
BEGIN
   OPEN get_downtime_seq;
   FETCH get_downtime_seq INTO downtime_, uptime_;
   CLOSE get_downtime_seq;
   
   downtime_duration_ := (( uptime_ - downtime_ ) * 24);

   RETURN downtime_duration_;
END Get_Obj_Downtime_Duration;


FUNCTION Get_Wo_Reported_Downtime_Seq(
   wo_no_   IN NUMBER,
   equipment_object_seq_ IN NUMBER) RETURN NUMBER
IS
   downtime_seq_    NUMBER;
   
   $IF Component_Wo_SYS.INSTALLED $THEN
   CURSOR get_reported_downtime_seq_by_wo(wo_no_ NUMBER) IS
      SELECT downtime_seq
      FROM equip_obj_downtime_task_tab
      WHERE equipment_object_seq = equipment_object_seq_
      AND task_seq IN (SELECT task_seq
                      FROM  jt_task_tab
                      WHERE wo_no = wo_no_);
   $END                   
                        
BEGIN
   $IF Component_Wo_SYS.INSTALLED $THEN
      OPEN  get_reported_downtime_seq_by_wo(wo_no_);
      FETCH get_reported_downtime_seq_by_wo INTO downtime_seq_;
      CLOSE get_reported_downtime_seq_by_wo;
      
      RETURN downtime_seq_;
   $ELSE
      RETURN NULL;
   $END

END Get_Wo_Reported_Downtime_Seq;