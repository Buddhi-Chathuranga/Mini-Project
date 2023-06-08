-----------------------------------------------------------------------------
--
--  Logical unit: EquipObjDowntime
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220113  TGUNLK  AM21R2-3586, Created for IFS Cloud - 22R1
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT equip_obj_downtime_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   CURSOR check_overlap_exist (equipment_object_seq_ NUMBER, new_downtime_ TIMESTAMP, new_uptime_ TIMESTAMP)IS
      SELECT downtime_seq
      FROM  equip_obj_downtime_tab
      WHERE equipment_object_seq  = equipment_object_seq_
      AND downtime <= new_uptime_
      AND uptime >= new_downtime_;
   
   CURSOR get_overlap_details (equipment_object_seq_ NUMBER, downtime_seq_ VARCHAR2)IS
      SELECT TO_CHAR(t1.downtime, 'DD-Mon-YYYY HH24:MI:SS'), TO_CHAR(t1.uptime, 'DD-Mon-YYYY HH24:MI:SS'), t2.task_seq 
      FROM  equip_obj_downtime_tab t1, equip_obj_downtime_task_tab t2
      WHERE t1.equipment_object_seq  = equipment_object_seq_
      AND t1.downtime_seq = downtime_seq_
      AND t1.equipment_object_seq  = t2.equipment_object_seq
      AND t1.downtime_seq = t2.downtime_seq
      AND t2.reported_task = 'TRUE';
   
   downtime_seq_              NUMBER;
   task_seq_                  NUMBER;
   object_id_                 VARCHAR2(100);
   old_downtime_char_         VARCHAR2(50);
   old_uptime_char_           VARCHAR2(50);
   old_time_duration_         VARCHAR2(500);
   site_date_                 TIMESTAMP;
   
BEGIN
   
   site_date_ := Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq));
   IF (newrec_.downtime >  site_date_) THEN
      Error_SYS.Appl_General(lu_name_, 'CHECKDOWNTIME: Downtime cannot be in the future.');
   END IF;
   IF (newrec_.uptime >  site_date_) THEN
      Error_SYS.Appl_General(lu_name_, 'CHECKUPTIME: Uptime cannot be in the future.');
   END IF;
   
   IF (newrec_.downtime >=  newrec_.uptime) THEN
      Error_SYS.Appl_General(lu_name_, 'CHECKTIMEGAP: Downtime cannot be later than Uptime.');
   END IF; 
   
   OPEN check_overlap_exist(newrec_.equipment_object_seq, newrec_.downtime, newrec_.uptime);
   FETCH check_overlap_exist INTO downtime_seq_;
   IF (check_overlap_exist%FOUND) THEN
      CLOSE check_overlap_exist;
      OPEN get_overlap_details(newrec_.equipment_object_seq, downtime_seq_);
      FETCH get_overlap_details INTO old_downtime_char_, old_uptime_char_, task_seq_;
      
      object_id_            :=    Equipment_Object_API.Get_Mch_Code(newrec_.equipment_object_seq);
      old_time_duration_    :=    old_downtime_char_ || ' - ' || old_uptime_char_;
      
      Error_SYS.Record_General(lu_name_, 'DOWNTIMEOVERLAPED: For object :P1, Downtime :P2 is already reported from Work Task :P3.', object_id_, old_time_duration_, task_seq_);
      
   END IF;
   CLOSE check_overlap_exist;
   
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT equip_obj_downtime_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.downtime_seq := downtime_seq.NEXTVAL;
   Client_SYS.Add_To_Attr('DOWNTIME_SEQ', newrec_.downtime_seq, attr_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@IgnoreUnitTest NoOutParams
PROCEDURE Report_Equip_Obj_Downtime(
   equipment_object_seq_ IN NUMBER,
   downtime_seq_         IN NUMBER,
   task_seq_             IN NUMBER,
   downtime_             IN TIMESTAMP,
   uptime_               IN TIMESTAMP )
IS
   equip_obj_downtime_rec_         equip_obj_downtime_tab%ROWTYPE;
   equip_obj_downtime_task_rec_    equip_obj_downtime_task_tab%ROWTYPE;
   
BEGIN
   IF downtime_seq_ IS NULL THEN
      equip_obj_downtime_rec_.equipment_object_seq  := equipment_object_seq_;
      equip_obj_downtime_rec_.downtime              := downtime_;
      equip_obj_downtime_rec_.uptime                := uptime_;
      
      New(equip_obj_downtime_rec_);
      
      equip_obj_downtime_task_rec_.downtime_seq     := equip_obj_downtime_rec_.downtime_seq;
      equip_obj_downtime_task_rec_.reported_task    := Fnd_Boolean_API.DB_TRUE;
   ELSE
      equip_obj_downtime_task_rec_.downtime_seq     := downtime_seq_;
      equip_obj_downtime_task_rec_.reported_task    := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   equip_obj_downtime_task_rec_.equipment_object_seq   := equipment_object_seq_;
   equip_obj_downtime_task_rec_.task_seq               := task_seq_;
   
   Equip_Obj_Downtime_Task_API.New(equip_obj_downtime_task_rec_);
   
END Report_Equip_Obj_Downtime;


@IgnoreUnitTest TrivialFunction
PROCEDURE New(
   newrec_ IN OUT equip_obj_downtime_tab%ROWTYPE )
IS
BEGIN
   New___(newrec_);
END New;
