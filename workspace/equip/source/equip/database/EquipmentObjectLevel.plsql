-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjectLevel
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970527  ERJA    Created
--  970603  ERJA    Added function Check_Level_Seq and procedure Validate_Column___
--  970606  ERJA    Added procedure Enumerate_Object_Level
--  970618  TOWI    Modified test on equal level_seq in Validate_Column__.
--  970623  CAJO    Added function Get_Obj_Level.
--  970814  ERJA    Changed obj_level to lowercase.
--  971025  STSU    Added methods Check_Exist and Create_Obj_Level.
--  971030  ERJA    Changed view to exclude level unknown and undefined.
--  971030  STSU    Added view2 and view3 and functions.
--                  Get_System_Object_Level and Get_System_Level_Sequence.
--  980225  CLCA    Changed flags for level_seq in view 1-3 into LOV.
--  980319  ADBR    Added Get_Min_Level function.
--  980331  CLCA    Made level_seq>99 possible and created error message for level_seq 98&99.
--  980421  CAJO    Added check that individual_aware may not be changed from Yes to No.
--  981230  ANCE    Checked and updated 'Uppercase/Unformatted' (SKY.0206).
--  990512  MAET    Call Id 10512. Validate_Column___: Check for individualallowed from Yes
--                  to No is removed.
--  990617  ERJA    Removed unused DEFINE statement.
--  991222  ANCE    Changed template due to performance improvement.
--  000112  PJONSE  Call Id: 30178. Added parenthieses round (level_seq < 98 OR level_seq > 99) and
--                  (level_seq > 97 AND level_seq < 100) in affected cursors.
--  000125  ADBR    Changed to VIEW in Get_Level_Seq.
--  000307  PJONSE  Call Id: 33286. Added PROCEDURE Check_Modified_Level_Seq__.
--  040423  UDSULK  Unicode Modification-substr removal-4.
--  061205  ChAmlk  Added Get_Create_Pm and Get_Create_Wo.
--  071115  SHAFLK  Bug 69322 Modified view comments of VIEW2 and VIEW3
--  -----------------------------Project Eagle-------------------------------
--  090923  SaFalk  IID - ME310: Remove unused views [EQUIPMENT_OBJ_LEVEL_SYSTEM]
--  091019  LoPrlk  EAME-182: Remove unused internal variables in EQUIP.
--  091029  NIFRSE  Bug 86801 Added the attribute individual_aware_db to VIEW1 
--  121205  SamGLK  Bug 107156, Modified Unpack_Ckeck_Update___().
--  131212  CLHASE  PBSA-1813, Refactored and splitted.
--  140813  HASTSE  Replaced dynamic code and cleanup
--  ---------------------------- APPS 10 -------------------------------------
--  170831 sawalk STRSA-1048, Data Validity changes, Overridden method Raise_Record_Access_Blocked___ is added.
--  171009 HASTSE  STRSA-30890, fix of validation
--  181004 SHAFLK  Bug 144372, Modified Ckeck_Update___().
-----------------------------------------------------------------------------


layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT equipment_object_level_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.create_pm := NVL(newrec_.create_pm, 'FALSE');
   newrec_.create_wo := NVL(newrec_.create_wo, 'FALSE');
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     equipment_object_level_tab%ROWTYPE,
   newrec_ IN OUT equipment_object_level_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   pm_exist_        VARCHAR2(5) := 'FALSE';
   wo_exist_        VARCHAR2(5) := 'FALSE';
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   $IF Component_Pm_SYS.INSTALLED $THEN
      pm_exist_ := Pm_Action_Util_API.Exist_Pm_For_Object_Level(newrec_.obj_level);
   $ELSE
      NULL;
   $END
   $IF Component_Wo_SYS.INSTALLED $THEN
      wo_exist_ := Work_Order_Utility_API.Exist_Wo_For_Object_Level(newrec_.obj_level);
   $ELSE
      NULL;
   $END
   IF (pm_exist_ = 'TRUE' OR wo_exist_ = 'TRUE') THEN
      Error_SYS.Appl_General(lu_name_, 'PMORWOEXIST: The object level :P1 cannot be updated as PM actions or work orders/work tasks/task steps have already been created for objects with this object level.', newrec_.obj_level);
   END IF;
   Check_Modified_Level_Seq__(newrec_.level_seq, oldrec_.level_seq);
END Check_Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     equipment_object_level_tab%ROWTYPE,
   newrec_ IN OUT equipment_object_level_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   -- Check Level Seq
   IF Validate_SYS.Is_Changed(oldrec_.level_seq, newrec_.level_seq) THEN
      IF (newrec_.level_seq = 98 OR newrec_.level_seq = 99) THEN
         Error_SYS.Appl_General(lu_name_, 'SEQSYSGEN: Level Sequence 98 and 99 are system generated and may not be used.');
      END IF;
      IF Check_Level_Seq__(newrec_.level_seq) THEN
         Error_SYS.Appl_General(lu_name_, 'CHKLEVSEQ: Level sequence :P1 already exist.', newrec_.level_seq);
      END IF;
   END IF;
END Check_Common___;


@Override
PROCEDURE Raise_Record_Access_Blocked___ (
    obj_level_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Access_Blocked(lu_name_, 'ACCESSBLOCKED: Object Level :P1 is blocked for use.', obj_level_);
   super(obj_level_);
END Raise_Record_Access_Blocked___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Check_Level_Seq__ (
   level_seq_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_LEVEL_TAB
      WHERE  (level_seq < 98 OR level_seq > 99)
      AND    level_seq = level_seq_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Level_Seq__;


PROCEDURE Check_Modified_Level_Seq__ (
   level_seq_new_ IN NUMBER,
   level_seq_old_ IN NUMBER )
IS
   temp_prev_        NUMBER;
   temp_next_        NUMBER;
   level_previous_   NUMBER;
   level_next_       NUMBER;

   CURSOR get_previous IS
      SELECT level_seq
      FROM EQUIPMENT_OBJECT_LEVEL_TAB
      WHERE (level_seq < 98 OR level_seq > 99)
         AND level_seq < level_seq_old_
      ORDER BY level_seq desc;

   CURSOR get_next IS
      SELECT level_seq
      FROM EQUIPMENT_OBJECT_LEVEL_TAB
      WHERE (level_seq < 98 OR level_seq > 99)
         AND level_seq > level_seq_old_
      ORDER BY level_seq asc;

BEGIN
   temp_prev_:= 0;
   temp_next_:= 0;
   level_previous_:= 0;
   level_next_:= 0;

   OPEN get_previous;
   FETCH get_previous INTO temp_prev_;
      IF (get_previous%NOTFOUND) THEN
         level_previous_:= level_seq_new_ - 1;
      ELSE
         level_previous_:= temp_prev_;
     END IF;
   CLOSE get_previous;

   OPEN get_next;
   FETCH get_next INTO temp_next_;
      IF (get_next%NOTFOUND) THEN
         level_next_:= level_seq_new_ + 1;
       ELSE
         level_next_:= temp_next_;
      END IF;
   CLOSE get_next;

   IF (level_seq_new_ < level_previous_) OR (level_seq_new_ > level_next_) THEN
      Error_SYS.Appl_General(lu_name_, 'CHKMODLEVSEQPREV: New level :P1 must be between :P2 and :P3!', level_seq_new_, temp_prev_, temp_next_);
   END IF;
END Check_Modified_Level_Seq__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Enumerate_Object_Level (
   client_values_ OUT VARCHAR2 )
IS
   list_ VARCHAR2(2000);
   CURSOR get_all_levels IS
      SELECT obj_level
      FROM EQUIPMENT_OBJECT_LEVEL_TAB
      WHERE (level_seq < 98 OR level_seq > 99);
BEGIN
   FOR test IN get_all_levels LOOP
      list_ := list_ || test.obj_level || chr(31);
   END LOOP;
   client_values_ := list_;
END Enumerate_Object_Level;


@UncheckedAccess
FUNCTION Get_Obj_Level (
   level_seq_ IN NUMBER ) RETURN VARCHAR2
IS
   obj_level_  VARCHAR2(30);
   CURSOR get_object_level IS
      SELECT obj_level
      FROM EQUIPMENT_OBJECT_LEVEL_TAB
      WHERE (level_seq < 98 OR level_seq > 99)
      AND level_seq = level_seq_;
BEGIN
   OPEN get_object_level;
   FETCH get_object_level INTO obj_level_;
   CLOSE get_object_level;
   RETURN obj_level_;
END Get_Obj_Level;


@UncheckedAccess
FUNCTION Check_Exist (
   obj_level_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_LEVEL_TAB
      WHERE  (level_seq < 98 OR level_seq > 99)
      AND    obj_level = obj_level_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_control;
   RETURN 'FALSE';
END Check_Exist;


PROCEDURE Create_Obj_Level (
   obj_level_        IN VARCHAR2,
   level_seq_        IN VARCHAR2,
   individual_aware_ IN VARCHAR2 )
IS
   newrec_      EQUIPMENT_OBJECT_LEVEL_TAB%ROWTYPE;
BEGIN
   newrec_.obj_level        := obj_level_;
   newrec_.level_seq        := level_seq_;
   newrec_.individual_aware := Individual_Aware_API.Encode(individual_aware_);
   New___(newrec_);
END Create_Obj_Level;


@UncheckedAccess
FUNCTION Get_System_Object_Level (
   level_seq_ IN NUMBER ) RETURN VARCHAR2
IS
   obj_level_ VARCHAR2(30);
   CURSOR get_object_level_sys IS
      SELECT obj_level
      FROM EQUIPMENT_OBJECT_LEVEL_TAB
      WHERE (level_seq > 97 AND level_seq < 100)
      AND level_seq = level_seq_;
BEGIN
   OPEN get_object_level_sys;
   FETCH get_object_level_sys INTO obj_level_;
   CLOSE get_object_level_sys;
   RETURN obj_level_;
END Get_System_Object_Level;


@UncheckedAccess
FUNCTION Get_System_Level_Sequence (
   obj_level_ IN VARCHAR2 ) RETURN NUMBER
IS
   level_seq_ NUMBER;
   CURSOR get_level_seq_sys IS
      SELECT level_seq
      FROM EQUIPMENT_OBJECT_LEVEL_TAB
      WHERE (level_seq > 97 AND level_seq < 100)
      AND obj_level = obj_level_;
BEGIN
   OPEN get_level_seq_sys;
   FETCH get_level_seq_sys INTO level_seq_;
   CLOSE get_level_seq_sys;
   RETURN level_seq_;
END Get_System_Level_Sequence;


@UncheckedAccess
FUNCTION Get_Min_Level RETURN VARCHAR2
IS
   temp_ EQUIPMENT_OBJECT_LEVEL_TAB.obj_level%TYPE;
   CURSOR get_attr IS
      SELECT obj_level
      FROM EQUIPMENT_OBJECT_LEVEL_TAB
      WHERE (level_seq < 98 OR level_seq > 99)
      AND   level_seq = ( SELECT min(level_seq)
                             FROM EQUIPMENT_OBJECT_LEVEL_TAB
                             WHERE (level_seq < 98 OR level_seq > 99) );
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Min_Level;


@Override
@UncheckedAccess
FUNCTION Get_Level_Seq (
   obj_level_ IN VARCHAR2 ) RETURN NUMBER
IS
   level_seq_ EQUIPMENT_OBJECT_LEVEL_TAB.level_seq%TYPE;
BEGIN
   level_seq_ := super(obj_level_);
   IF (level_seq_ < 98 OR level_seq_ > 99) THEN
      RETURN level_seq_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Level_Seq;




