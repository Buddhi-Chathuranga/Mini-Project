-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjectTestPnt
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950802  SLKO  Created.
--  950831  NILA  Added EXIT at end of file and modified procedure Exist not
--                to validate NULL values.
--  951021  OYME  Recreated using Base Table to Logical Unit Generator UH-Special
--  960228  STOL  Added proc. Copy_ and Has_Test_Point.
--  960315  STOL  Added proc./functions Get_Description and Get_Location.
--  960522  JOSC  Removed SYS4 dependencies and added call to Init_Method.
--  961003  JOBI  Added procedure Enumerate_Test_Point.
--  961006  TOWI  Generated from Rose-model using Developer's Workbench 1.2.2.
--  961107  ADBR  Changed place in view.
--  961212  ADBR  Ref 73: Changed Exist to accept '*'.
--  970402  TOWI  Adjusted to new templates in Foundation 1.2.2c.
--  970919  CAJO  Converted to F1 2.0. Changed table name to equipment_object_test_pnt_tab.
--  971120  ERJA  Added Contract
--  971210  ERJA  Corrected call to Equipment_Object_API.Exist
--  980215  ERJA  Changed order on mch_code and contract in view
--  980303  ERJA  Added PROCEDURE Remove_Obj_Test_Pnt.
--  980420  MNYS  Support Id: 440. Changed order of parameters in key_ in procedures
--                Check_Delete___ and Delete___.
--  990113  MIBO  SKY.0208 AND SKY.0209 Removed all calls to Get_Instance___
--                in Get-statements.
--  990409  MIBO  Template changes due to performance improvement.
--  010426  CHAT  Added the General_SYS.Init_Method to PROCEDURE Remove_Obj_Test_Pnt.
--  011011  UDSULK Added lov attribute of contract and mch code to view comments.
--  020207  ANCE  Bug Id: 26013 Changed function Has_Test_Point to return VARCHAR2 datatype. 
--  ************************************* AD 2002-3 BASELINE ********************************************
--  020604  CHAMLK Modified the length of the MCH_CODE in view EQUIPMENT_OBJECT_TEST_PNT
--  080408  LIAMLK Bug 69438, Removed General_SYS.Init_Method from Has_Test_Point.
--  081016  arnilk Bug Id 77768.Replace the Utility_SYS.Get_user methode into Fnd_Session_API.Get_Fnd_User methode
--  -------------------------Project Eagle-----------------------------------
--  091106  SaFalk IID - ME310: Removed bug comment tags.
--  110129  NEKOLK EANE-3710 added User_Allowed_Site_API.Authorized filter to View EQUIPMENT_OBJECT_TEST_PNT
--  131124  PRIKLK PBSA-1818: Hooks: refactored and split code
--  140303  HASTSE PBSA-5582, Fixed annotation problem.
--  140804  HASTSE PRSA-2088, fixed unused declarations
--  140813  HASTSE Replaced dynamic code and cleanup
--  141120  SHAFLK PRSA-5481, Modified Copy().
--  150207  SamGLK PRSA-7322, Method: Exist_Seq() is added.
--  160413  NIFRSE TASK-269, Method Get_Testpnt_Seq(), Remove Record Not Exist check.
--  160426  DMalLK STRSA-4154, Modified Get_Testpnt_Seq() to get seq of null contracts.
--  160804  Nuwklk STRPJ-15744, Added Resource Related methods.
--  170220  chanlk STRSA-12924, Handle tool Eq in Equipment measurement.
--  200514  CLEKLK Bug 152496, Modifying the column size of TEST_POINT_ID.
--  200527  KrRaLK Bug 153822, Added Get_Risk_Reference_Object_Desc().
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Generate_Seq_No___ RETURN NUMBER 
IS
   temp_ NUMBER;
   CURSOR get_next_sequence_no IS
      SELECT TEST_PNT_SEQ.nextval
      FROM   dual;
BEGIN
   OPEN get_next_sequence_no;
   FETCH get_next_sequence_no INTO temp_;
   CLOSE get_next_sequence_no;
   RETURN temp_;
END Generate_Seq_No___;

PROCEDURE Check_Parameter_Exists__ (
   test_pnt_seq_   IN NUMBER,
   test_point_id_  IN VARCHAR2)
IS
   dummy_  NUMBER;
   CURSOR get_rec IS
     SELECT 1
     FROM EQUIPMENT_OBJECT_PARAM_TAB
     WHERE test_pnt_seq = test_pnt_seq_;
BEGIN 
   OPEN get_rec;
   FETCH get_rec INTO dummy_;
   IF get_rec%FOUND THEN 
      CLOSE get_rec;
      Error_SYS.Appl_General(lu_name_, 'PARAMETEREXISTS: The Test Point ":P1" has one or more Parameters connected and cannot be removed.', test_point_id_);
   END IF;    
   CLOSE get_rec;
END Check_Parameter_Exists__;



@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT equipment_object_test_pnt_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS

   CURSOR get_equip_rec(equipment_object_seq_ IN NUMBER, test_point_id_ IN VARCHAR2) IS
      SELECT 1 FROM equipment_object_test_pnt_tab
      WHERE equipment_object_seq = equipment_object_seq_
      AND   test_point_id = test_point_id_;
      
   CURSOR get_tool_rec(resource_seq_ IN NUMBER, test_point_id_ IN VARCHAR2) IS
      SELECT 1 FROM equipment_object_test_pnt_tab
      WHERE resource_seq = resource_seq_
      AND   test_point_id = test_point_id_;

   temp_ NUMBER;
   
BEGIN
   -- if ToolEquipmentSeq is inserted thru mch_code
   --IF (newrec_.lu_name = 'ToolEquipment') THEN
   --   IF (newrec_.mch_code IS NOT NULL AND newrec_.tool_equipment_seq IS NULL) THEN
   --      newrec_.tool_equipment_seq := newrec_.mch_code;
   --      indrec_.tool_equipment_seq := TRUE;
   --   END IF;
   --   indrec_.mch_code := FALSE;
   --END IF;
   
   super(newrec_, indrec_, attr_);
   
   IF (newrec_.lu_name = 'EquipmentObject') THEN
      Error_SYS.Check_Not_Null(lu_name_, 'EQUIPMENT_OBJECT_SEQ', newrec_.equipment_object_seq);
      Validate_SYS.Item_Insert(lu_name_, 'RESOURCE_SEQ', indrec_.resource_seq);

      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq));
      OPEN get_equip_rec(newrec_.equipment_object_seq, newrec_.test_point_id);
      FETCH get_equip_rec INTO temp_;
      IF(get_equip_rec%FOUND)THEN 
         Error_SYS.Record_General(lu_name_, 'TESTPNTEXIST: Test Point already exists');
      END IF;
      CLOSE get_equip_rec;
   END IF;

   IF (newrec_.lu_name = 'Resource') THEN
      Error_SYS.Check_Not_Null(lu_name_, 'RESOURCE_SEQ', newrec_.contract);
      Validate_SYS.Item_Insert(lu_name_, 'EQUIPMENT_OBJECT_SEQ', indrec_.equipment_object_seq);
      
      OPEN get_tool_rec(newrec_.resource_seq, newrec_.test_point_id);
      FETCH get_tool_rec INTO temp_;
      IF(get_tool_rec%FOUND)THEN 
         Error_SYS.Record_General(lu_name_, 'TESTPNTEXIST: Test Point already exists');
      END IF;
      CLOSE get_tool_rec;
   END IF;

 END Check_Insert___;
   
 @Override
 PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT EQUIPMENT_OBJECT_TEST_PNT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.test_pnt_seq := Generate_Seq_No___();  
--   IF newrec_.resource_seq IS NOT NULL THEN
--      newrec_.mch_code := Resource_Util_API.Get_Resource_Id(newrec_.resource_seq);
--   END IF;

   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr( 'TEST_PNT_SEQ', newrec_.test_pnt_seq, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   test_pnt_seq_ IN NUMBER )
IS
   test_point_id_ EQUIPMENT_OBJECT_TEST_PNT_TAB.test_point_id%TYPE;
   CURSOR getrec IS
      SELECT test_point_id
      FROM   EQUIPMENT_OBJECT_TEST_PNT_TAB
      WHERE  test_pnt_seq = test_pnt_seq_
      UNION 
      SELECT '*'
      FROM dual
      WHERE test_pnt_seq_ = 1;
BEGIN
   OPEN getrec;
   FETCH getrec INTO test_point_id_;
   IF test_point_id_ IS NULL OR test_point_id_ != '*' THEN
    super(test_pnt_seq_);
   END IF;
END Raise_Record_Not_Exist___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN equipment_object_test_pnt_tab%ROWTYPE )
 IS
 BEGIN
   Check_Parameter_Exists__(remrec_.test_pnt_seq, remrec_.test_point_id);
   super(remrec_);
 END Check_Delete___;
 
 
PROCEDURE Check_Mch_Code_Ref___ (
   rec_ IN equipment_object_test_pnt_tab%ROWTYPE )
IS
BEGIN
   IF ( rec_.lu_name = 'EquipmentObject' ) THEN
      Equipment_Object_Api.Exist(rec_.equipment_object_seq);
   END IF;
END Check_Mch_Code_Ref___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Remove_Default_Test_Point__ (
   testpnt_seq_ IN NUMBER)
IS
   default_test_point_rec_ equipment_object_test_pnt_tab%ROWTYPE;
BEGIN
   default_test_point_rec_ := Get_Object_By_Keys___(testpnt_seq_);
   Remove___(default_test_point_rec_);
END Remove_Default_Test_Point__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Copy (
   source_contract_      IN VARCHAR2,
   source_object_        IN VARCHAR2,
   destination_contract_ IN VARCHAR2,
   destination_object_   IN VARCHAR2,
   pm_no_                IN NUMBER DEFAULT NULL,
   pm_revision_          IN VARCHAR2 DEFAULT NULL)
IS
   dummy_       NUMBER;
   newrec_      equipment_object_test_pnt_tab%ROWTYPE;
   equ_seq_     equipment_object_tab.equipment_object_seq%TYPE;
   
   CURSOR get_equ_seq(contract_ IN VARCHAR2, mch_code_ IN VARCHAR2) IS
      SELECT equipment_object_seq
      FROM   equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_;
   CURSOR source(test_point_id_ IN VARCHAR2) IS
      SELECT obj_test_pnt.*
      FROM   EQUIPMENT_OBJECT_TEST_PNT_TAB obj_test_pnt, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = source_contract_
      AND    equ_obj.mch_code = source_object_
      AND equ_obj.equipment_object_seq = obj_test_pnt.equipment_object_seq
      AND    obj_test_pnt.test_point_id = test_point_id_;
      
   CURSOR destination_exist(test_point_id_ IN VARCHAR2) IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_TEST_PNT_TAB obj_test_pnt, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = destination_contract_
      AND    equ_obj.mch_code = destination_object_
      AND equ_obj.equipment_object_seq = obj_test_pnt.equipment_object_seq
      AND    obj_test_pnt.test_point_id = test_point_id_;
      
   $IF Component_Pm_SYS.INSTALLED $THEN
      CURSOR get_copy IS
         SELECT test_point_id
         FROM   Pm_Action_Criteria_TAB
         WHERE  pm_no = pm_no_
         AND    pm_revision = pm_revision_;
   $END

   CURSOR equip_source IS
      SELECT obj_test_pnt.*
      FROM   EQUIPMENT_OBJECT_TEST_PNT_TAB obj_test_pnt, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = source_contract_
      AND    equ_obj.mch_code = source_object_
      AND equ_obj.equipment_object_seq = obj_test_pnt.equipment_object_seq;
BEGIN
   IF pm_no_ IS NULL THEN
      FOR instance IN equip_source LOOP
         OPEN destination_exist(instance.test_point_id);
         FETCH destination_exist INTO dummy_;
         IF destination_exist%FOUND THEN
            CLOSE destination_exist;
         ELSE
            CLOSE destination_exist;
            newrec_ := NULL;
            OPEN get_equ_seq(destination_contract_, destination_object_);
            FETCH get_equ_seq INTO equ_seq_;
            CLOSE get_equ_seq;
            newrec_.equipment_object_seq  := equ_seq_;
            newrec_.test_point_id         := instance.test_point_id;
            newrec_.descr                 := instance.descr;
            newrec_.location              := instance.location;
            newrec_.lu_name               := instance.lu_name;
            New___(newrec_); 
         END IF;
     END LOOP;   
   ELSE   
       $IF Component_Pm_SYS.INSTALLED $THEN
         FOR copy_pm_pnt IN get_copy LOOP
            FOR instance IN source(copy_pm_pnt.test_point_id) LOOP
               OPEN destination_exist(instance.test_point_id);
               FETCH destination_exist INTO dummy_;
               IF destination_exist%FOUND THEN
                  CLOSE destination_exist;
               ELSE
                  CLOSE destination_exist;
                  newrec_ := NULL;
            OPEN get_equ_seq(destination_contract_, destination_object_);
            FETCH get_equ_seq INTO equ_seq_;
            CLOSE get_equ_seq;
                  newrec_.equipment_object_seq  := equ_seq_;
                  newrec_.test_point_id         := instance.test_point_id;
                  newrec_.descr                 := instance.descr;
                  newrec_.location              := instance.location;
                  newrec_.lu_name               := instance.lu_name;
                  New___(newrec_); 
               END IF;             
            END LOOP;
         END LOOP;
       $ELSE
         NULL;
       $END  
   END IF;    
END Copy;


@UncheckedAccess
FUNCTION Has_Test_Point (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_object IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_TEST_PNT_TAB obj_test_pnt, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND equ_obj.equipment_object_seq = obj_test_pnt.equipment_object_seq;
BEGIN
   OPEN exist_object;
   FETCH exist_object INTO dummy_;
   IF exist_object%FOUND THEN
      CLOSE exist_object;
      RETURN('TRUE');
   ELSE 
      RETURN ('FALSE');
   END IF;
END Has_Test_Point;


@UncheckedAccess
FUNCTION Check_Exist (
   test_pnt_seq_ IN NUMBER  ) RETURN VARCHAR2
IS

BEGIN
   IF (NOT Check_Exist___(test_pnt_seq_)) THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Check_Exist;


PROCEDURE Enumerate_Test_Point (
   client_values_ OUT VARCHAR2,
   contract_      IN  VARCHAR2,
   mch_code_      IN  VARCHAR2 )
IS
   list_ VARCHAR2(2000);
   CURSOR get_testpoints IS
      SELECT test_point_id
      FROM EQUIPMENT_OBJECT_TEST_PNT_TAB obj_test_pnt, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND equ_obj.equipment_object_seq = obj_test_pnt.equipment_object_seq;
BEGIN
   FOR test IN get_testpoints LOOP
      list_ := list_ || test.test_point_id || chr(31);
   END LOOP;
   client_values_ := list_;
END Enumerate_Test_Point;

PROCEDURE Remove_Obj_Test_Pnt (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2)
IS
   info_ VARCHAR2(200);
   objid_       VARCHAR2(20);
   objversion_  VARCHAR2(2000);
   CURSOR getrec IS
      SELECT obj_test_pnt.*
      FROM   EQUIPMENT_OBJECT_TEST_PNT_TAB obj_test_pnt, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND equ_obj.equipment_object_seq = obj_test_pnt.equipment_object_seq;
BEGIN
   FOR lurec_ IN getrec LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, lurec_.test_pnt_seq);
      Remove__( info_, objid_, objversion_, 'DO');
   END LOOP;
END Remove_Obj_Test_Pnt; 

   
FUNCTION Get_Testpnt_Seq(
   resource_seq_   IN NUMBER,
   test_point_id_  IN VARCHAR2) RETURN NUMBER    
IS
   testpnt_seq_ NUMBER;
   CURSOR get_attr IS
   SELECT test_pnt_seq
      FROM 	 equipment_object_test_pnt_tab
      WHERE  resource_seq=resource_seq_
      AND    test_point_id = test_point_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO testpnt_seq_;
   CLOSE get_attr;
   
   RETURN testpnt_seq_;
END Get_Testpnt_Seq;

FUNCTION Get_Testpnt_Seq(
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   test_point_id_ IN VARCHAR2) RETURN NUMBER 
   
IS
   testpnt_seq_ NUMBER;
   CURSOR get_attr IS
   SELECT test_pnt_seq
      FROM EQUIPMENT_OBJECT_TEST_PNT_TAB obj_test_pnt, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND equ_obj.equipment_object_seq = obj_test_pnt.equipment_object_seq
      AND obj_test_pnt.test_point_id = test_point_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO testpnt_seq_;
   CLOSE get_attr;
   
   RETURN testpnt_seq_;
END Get_Testpnt_Seq;
   
FUNCTION Get_Description(
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   test_point_id_ IN VARCHAR2) RETURN VARCHAR2 
IS
   temp_  EQUIPMENT_OBJECT_TEST_PNT_TAB.descr%TYPE;
   CURSOR get_attr IS
   SELECT descr
   FROM EQUIPMENT_OBJECT_TEST_PNT_TAB obj_test_pnt, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND equ_obj.equipment_object_seq = obj_test_pnt.equipment_object_seq
   AND obj_test_pnt.test_point_id = test_point_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Description;


FUNCTION Get_Location(
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   test_point_id_ IN VARCHAR2) RETURN VARCHAR2 
IS
   temp_  EQUIPMENT_OBJECT_TEST_PNT_TAB.location%TYPE;
   CURSOR get_attr IS
   SELECT location
   FROM EQUIPMENT_OBJECT_TEST_PNT_TAB obj_test_pnt, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND equ_obj.equipment_object_seq = obj_test_pnt.equipment_object_seq
   AND obj_test_pnt.test_point_id = test_point_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Location; 

FUNCTION Exist_Seq(
   test_pnt_seq_ NUMBER) RETURN VARCHAR2 
IS
   CURSOR get_rec IS
   SELECT 1
   FROM EQUIPMENT_OBJECT_TEST_PNT_TAB
   WHERE test_pnt_seq = test_pnt_seq_;

   temp_  NUMBER;
BEGIN
   OPEN get_rec;
   FETCH get_rec INTO temp_;
   IF(get_rec%NOTFOUND)THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
   CLOSE get_rec;
END Exist_Seq;

@UncheckedAccess
PROCEDURE Exist(
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   test_point_id_ IN VARCHAR2) 
IS
   temp_  NUMBER;
   seq_no_ NUMBER;
   CURSOR get_attr IS
   SELECT 1
   FROM EQUIPMENT_OBJECT_TEST_PNT_TAB obj_test_pnt, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND equ_obj.equipment_object_seq = obj_test_pnt.equipment_object_seq
   AND obj_test_pnt.test_point_id = test_point_id_;
BEGIN   
   seq_no_ := Get_Testpnt_Seq(contract_, mch_code_, test_point_id_);
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF (NOT get_attr%FOUND) THEN     
       Raise_Record_Not_Exist___(seq_no_);
   END IF; 
   CLOSE get_attr;
END Exist;

@UncheckedAccess
PROCEDURE Exist(
   resource_seq_ IN NUMBER,
   test_point_id_ IN VARCHAR2) 
IS
   temp_  NUMBER;
   seq_no_ NUMBER;
   CURSOR get_attr IS
   SELECT 1
   FROM equipment_object_test_pnt_tab
   WHERE resource_seq  = resource_seq_
   AND   test_point_id = test_point_id_;
BEGIN   
   seq_no_ := Get_Testpnt_Seq(resource_seq_,test_point_id_);
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF (NOT get_attr%FOUND) THEN     
       Raise_Record_Not_Exist___(seq_no_);
   END IF; 
   CLOSE get_attr;
END Exist;

PROCEDURE Insert_Testpoint(
   attr_ IN OUT VARCHAR2)
IS
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(80);
   objversion_   VARCHAR2(2000);
BEGIN
   New__(info_, objid_, objversion_, attr_, 'DO');
END Insert_Testpoint;

FUNCTION Has_TestPointId (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   testpoint_id_   IN VARCHAR2) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_object IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_TEST_PNT_TAB obj_test_pnt, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_
      AND equ_obj.equipment_object_seq = obj_test_pnt.equipment_object_seq
   AND obj_test_pnt.test_point_id = testpoint_id_;
BEGIN
   OPEN exist_object;
   FETCH exist_object INTO dummy_;
   IF exist_object%FOUND THEN
      CLOSE exist_object;
      RETURN('TRUE');
   ELSE 
      CLOSE exist_object;
      RETURN ('FALSE');
   END IF;
END Has_TestPointId;

FUNCTION Get_Risk_Reference_Object_Desc(
   lu_name_                IN VARCHAR2,
   key_ref_                IN VARCHAR2) RETURN VARCHAR2
IS
   equip_test_pnt_record_ Equipment_Object_Test_Pnt_API.Public_Rec;
   lu_key_value_          VARCHAR2(100);
   test_pnt_seq_          NUMBER;
   desc_                  VARCHAR2(200) := NULL;
BEGIN
   IF (lu_name_ = 'EquipmentObjectTestPnt') THEN
      lu_key_value_         := Object_Connection_SYS.Convert_To_Key_Value(lu_name_, key_ref_);
      test_pnt_seq_         := to_number(SUBSTR(lu_key_value_, 0, INSTR(lu_key_value_, '^') -1));
      equip_test_pnt_record_ := Equipment_Object_Test_Pnt_API.Get(test_pnt_seq_);
      
      desc_ := Language_SYS.Translate_Constant(lu_name_, 'RISKREFOBJECTDESC: Object Site: :P1, Object ID: :P2, Test Point ID: :P3,  ', NULL,
      Equipment_Object_API.Get_Contract(equip_test_pnt_record_.equipment_object_seq), Equipment_Object_API.Get_Mch_Code(equip_test_pnt_record_.equipment_object_seq), equip_test_pnt_record_.test_point_id);
   END IF;
   
   RETURN desc_;
END Get_Risk_Reference_Object_Desc;





  

