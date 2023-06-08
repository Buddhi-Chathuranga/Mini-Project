-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjectParam
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950802  SLKO  Created.
--  950824  STOL  Moved creation of view from script into package.
--                Added comments on view.
--  950828  STOL  Added Decode/Encode function calls in view and in procedures
--                Unpack_Check_Insert___  and Unpack_Check_Update___ for
--                column PM_CRITERIA.
--  950831  STOL  Added setting of fields REG_DATE and TEST_POINT_ID in
--                procedure Prepare_Insert___.
--  950831  NILA  Added EXIT at end of file and modified procedure Exist not
--                to validate NULL values.
--  950907  STOL  Moved Encode-statements from Unpack_Check_Insert___ and
--                Unpack_Check_Update___ to procedures Insert___ and
--                Update___.
--  950920  STOL  Removed setting of field REG_DATE in Prepare_Insert___.
--                Added procedure Get_Unit.
--  951021  OYME  Recreated using Base Table to Logical Unit Generator UH-Special
--  951026  OYME  Removed upprecase on IID Pm_Criteria. Removed exist-test on
--                combination of mch_code + test_point_id.
--  951116  ADBR  Overloaded Get_Unit.
--  960104  ADBR  Added default value on PM_CRITERIA.
--  960228  STOL  Added procedure Copy_, Has_Parameter.
--  960321  JOMO  Added procedure Validate_Comb.
--  960521  JOSC  Removed SYS4 dependencies and added call to Init_Method.
--  960612  MINI  Changed mch_code to P and parameter_code to K in viewcomments.
--  960927  CAJO  Generated from Rose-model using Developer's Workbench.
--  961001  TOWI  Moved procedure EnumerateMchCode from PmActionCriteria
--  961006  TOWI  Generated from Rose-model using Developer's Workbench 1.2.2.
--  961111  ADBR  Removed Enumerate_Mch_Code.
--  961204  ADBR  Added _LOV view and some code.
--  961219  ADBR  Merged with new templates.
--  970211  ADBR  Moved validation of test point.
--  970402  TOWI  Adjusted to new templates in Foundation 1.2.2c.
--  970919  CAJO  Converted to F1 2.0. Changed table name to equipment_object_param_tab.
--  971016  ERJA  Changed ref=unit to iso_unit and unit_api to maintenance_unit_api.
--  971120  ERJA  Added Contract
--  971209  TOWI  Ref 2323: Removed last_value and reg_date from Copy.
--  971210  ERJA  Removed fetch of contract in prepare_insert__
--  980215  ERJA  Changed order on mch_code and contract in view and Corrected ref on mch_code
--  980421  MNYS  Support Id: 364. Changed order of parameters in key_ in procedures
--                Check_Delete___ and Delete___.
--  980825  ADBR  Bug ID 5442: Changed VIEW..contract to VIEW_LOV..contract in VIEW_LOV comments.
--  990112  MIBO  SKY.0208 AND SKY.0209 Changed SYSDATE to Site_API.Get_Site_Date(newrec_.contract)
--                and Removed all calls to Get_Instance___ in Get-statements.
--  990118  MIBO  SKY.0209 Changed Site_API.Get_Site_Date(contract) to
--                Maintenance_Site_Utility_API.Get_Site_Date(contract).
--  981230  ANCE  Checked and updated 'Uppercase/Unformatted' (SKY.0206).
--  990308  MAET  Call 10190- EQUIPMENT_OBJECT_PARAM_LOV/WHERE: "pm_criteria_db = 1" was modified
--                            to "pm_criteria_db = 'Y' ".
--  990326  MIBO  Bug ID 7710: Removed references from VIEW_LOV and added CASCADE option in VIEW.
--  000120 PJONSE Changed template due to performance improvement.
--  000131 PJONSE Call Id: 31051 PROCEDURE Copy. Changed 'PM_CRITERIA' to 'PM_CRITERIA_DB' because of call for New__.
--  001011 PJONSE Added functions Get_Reg_Date and Get_Last_Value.
--  011129 SOJOSE Bug ID 26470.  Changed View ref. from Iso_Unit to IsoUnit.
--  020207  ANCE  Bug Id: 26013 Changed function Has_Parameter to return VARCHAR2 datatype.
--  ************************************* AD 2002-3 BASELINE ********************************************
--  020604 CHAMLK Modified the length of the MCH_CODE from 40 to 100 in views EQUIPMENT_OBJECT_PARAM
--                and EQUIPMENT_OBJECT_PARAM_LOV
--  040128 YAWILK Removed the view comment CASCADE. Added the methods Check_Remove__, Do_Remove__.
--  110204 DIMALK Unicode Support: Changes Done with 'SUBSTRB'.
--  ------------------------------ Edge - SP1 Merge -------------------------------------
--  040202 JAPELK BUG ID:41814 Added a default null param to Update_Mch_Parameter__
--  040324 JAPALK Merge with SP1
--  081016 arnilk Bug Id 77768.Replace the Utility_SYS.Get_user methode into Fnd_Session_API.Get_Fnd_User methode
--  -------------------------Project Eagle-----------------------------------
--  091019 LoPrlk EAME-182: Remove unused internal variables in EQUIP.
--  091106 SaFalk IID - ME310: Removed bug comment tags.
--  100610 Umdolk EANE-2348: Correcting reference attributes in mch_code and changed key to parent key in test_point_id.
--  100908 CHODLK Bug 92854, Added new column parameter_description to EQUIPMENT_OBJECT_PARAM. 
--  101021 NIFRSE  Bug 93384, Updated view column prompts to 'Object Site'.
--  110815 PRIKLK SADEAGLE-1739, Added user_allowed_site filter to views EQUIPMENT_OBJECT_PARAM_LOV and EQUIPMENT_OBJECT_PARAM. 
--  110815        Replaced EQUIPMENT_OBJECT_PARAM view usages with the table.
--  120125 NuKuLK SSA-2333, Modified view comments in EQUIPMENT_OBJECT_PARAM.
--  -------------------------Project Black Pearl---------------------------------------------------------------
--  130608 MADGLK BLACK-65 , Removed MAINTENANCE_OBJECT_API method calls
--  131217 HASTSE PBSA-3302, Fixed wildcard in model and duplicated exist checks
-- ----------------------------Apps 9 --------------------------------------------------------------------------
--  140228 BHKALK PBSA-4984, Added validation to unit_code in Check_Update___.
--  140303 HASTSE PBSA-5582, Fixed annotation problem, removed unneeded override of method Get_Meter_Flip_Value.
--  140321 BHKALK PBSA-4984, Modified the validation for unit_code in Check_Update___ to avoid repetition of  warning message.
--  140331 BHKALK PBSA-4984, Modified the validation for unit_code in Check_Update___.
--  140813 HASTSE Replaced dynamic code and cleanup
--  141002 HASTSE PRSA-2516, Refactured Measurment handling
--  141015 HASTSE PRSA-2512, Cleanup
--  141120 SHAFLK PRSA-5481, Modified Copy().
--  141205 PRIKLK PRSA-5814, Override methods Insert and Update and added RCMINT method calls.
--  141212 HASTSE PRSA-5117, Fixed recalculation on changed Start calculation on Parameter
--  150212 KrRaLK PRSA-5780, Override method Check_Insert___().
--  150216 SamGLK PRSA-7322, Modified  Check_Insert___().
--  160830 Nuwklk STRSA-7667,Modified  Check_Insert___.
--  160930 Nuwklk STRSA-12963,Modified  Insert___
--  200514 CLEKLK Bug 152496, Modifying the column size of TEST_POINT_ID.
--  220111 KrRaLK AM21R2-2950, Equipment object is given a sequence number as the primary key
--                (while keeping the old Object ID and Site as a unique constraint). 
--                Inlined the rdf to handle new design.  
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Delete___ (
   objid_  IN     VARCHAR2,
   remrec_ IN     equipment_object_param_tab%ROWTYPE )
IS      
BEGIN
   super(objid_, remrec_);
   IF (remrec_.test_point_id = '*') THEN
      IF (Has_Parameter(remrec_.test_pnt_seq) = 'FALSE') THEN
         Equipment_Object_Test_Pnt_API.Remove_Default_Test_Point__(remrec_.test_pnt_seq);
      END IF;
   END IF;
END Delete___;

@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ equipment_object_param_tab%ROWTYPE )
IS
BEGIN   
   Error_SYS.Record_Exist(lu_name_, 'EQUIPOBJPARAMEXIST: The Equipment Object Parameter ":P1" already exists.', rec_.parameter_code);
   super(rec_);
END Raise_Record_Exist___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr( 'PM_CRITERIA', Pm_Criteria_API.Decode(Pm_Criteria_API.DB_YES), attr_ );   
   Client_SYS.Add_To_Attr( 'PM_CRITERIA_DB', Pm_Criteria_API.DB_YES, attr_ ); 
   Client_SYS.Add_To_Attr('BLOCKED_FOR_USE_DB', 'FALSE', attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT NOCOPY equipment_object_param_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   IF (newrec_.blocked_for_use IS NULL) THEN
      newrec_.blocked_for_use := 'FALSE';
   END IF;
   IF( Equipment_Object_Test_Pnt_Api.Exist_Seq(newrec_.test_pnt_seq) = 'FALSE')THEN
       newrec_.test_pnt_seq := 1;
       newrec_.test_point_id := '*';
      IF newrec_.resource_seq > 0 THEN
         newrec_.lu_name := 'ToolEquipment';
      ELSE
         newrec_.lu_name := 'EquipmentObject';
      END IF;
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     equipment_object_param_tab%ROWTYPE,
   newrec_ IN OUT equipment_object_param_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.lu_name = 'EquipmentObject') THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq));
   END IF;
   
END Check_Common___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     equipment_object_param_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY equipment_object_param_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   sales_base_unit_meas_ VARCHAR2(10);
   warning_         BOOLEAN := FALSE;
   error_           BOOLEAN := FALSE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   $IF Component_Metinv_SYS.INSTALLED $THEN
    IF (newrec_.unit_code != oldrec_.unit_code) THEN
      FOR rec_ IN Metering_Object_Line_API.Get_Met_Inv_Details(newrec_.equipment_object_seq, newrec_.test_point_id, oldrec_.parameter_code) LOOP
         sales_base_unit_meas_ := Iso_Unit_api.Get_Base_Unit(Sales_Part_API.Get_Sales_Unit_Meas(rec_.catalog_contract,rec_.catalog_no));         
         IF ( sales_base_unit_meas_ = Iso_Unit_api.Get_Base_Unit(oldrec_.unit_code) ) THEN
            IF (rec_.valid_until < sysdate ) THEN
                warning_ := TRUE;
            ELSE 
               error_ := TRUE;
            END IF;
         END IF;         
      END LOOP;
      IF warning_ THEN
         Client_SYS.Add_Warning(lu_name_, 'METINVUOMDIF: Metering invoicing is defined for this parameter and the unit conversion factor used to convert meter UoM to sales part UoM is not available.');
      END IF;
      IF error_ THEN
         Error_SYS.Appl_General(lu_name_, 'METINVUOMDERR: One or more valid metering invoices defined for this parameter and the unit conversion factor used to convert meter UoM to sales part UoM is not available.');
      END IF;
    END IF;
   $END
END Check_Update___;


 @Override
 PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT EQUIPMENT_OBJECT_PARAM_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
 IS
    test_pnt_attr_   VARCHAR2(32000);
 
    CURSOR get_rec(test_pnt_seq_ IN NUMBER) IS 
        SELECT equipment_object_seq, lu_name, resource_seq, test_point_id
        FROM equipment_object_test_pnt_tab
        WHERE test_pnt_seq = test_pnt_seq_;
 
    CURSOR get_equip_obj (equipment_object_seq_ IN NUMBER) IS 
        SELECT test_pnt_seq
        FROM equipment_object_test_pnt_tab
        WHERE equipment_object_seq = equipment_object_seq_
        AND   test_point_id = '*'
        AND   lu_name = 'EquipmentObject';
        
     CURSOR get_tooleq (resource_seq_ IN NUMBER) IS
        SELECT test_pnt_seq
        FROM equipment_object_test_pnt_tab
        WHERE resource_seq = resource_seq_
        AND   test_point_id = '*'
        AND   lu_name = 'ToolEquipment';
    
    mch_code_              VARCHAR2(100);
    contract_              VARCHAR2(5);
    lu_name_               VARCHAR2(30);
    resource_seq_          NUMBER;
    equipment_object_seq_  NUMBER;
    test_point_id_         EQUIPMENT_OBJECT_PARAM_TAB.test_point_id%TYPE;
    test_pnt_seq_          NUMBER;
    
 BEGIN
   IF(newrec_.test_pnt_seq = 1) THEN 
      IF (newrec_.lu_name = 'EquipmentObject') THEN
         OPEN get_equip_obj(newrec_.equipment_object_seq);
         FETCH get_equip_obj INTO test_pnt_seq_;
         IF (get_equip_obj%NOTFOUND) THEN            
            Client_SYS.Add_To_Attr('TEST_POINT_ID',      newrec_.test_point_id,      test_pnt_attr_);
            Client_SYS.Add_To_Attr('DESCRIPTION',        'Default Testpoint',        test_pnt_attr_);
            Client_SYS.Add_To_Attr('EQUIPMENT_OBJECT_SEQ',           newrec_.equipment_object_seq,           test_pnt_attr_);            
            Client_SYS.Add_To_Attr('LU_NAME',            newrec_.lu_name,            test_pnt_attr_);                             
            Insert_Testpoint___(test_pnt_attr_);
            newrec_.test_pnt_seq := Client_SYS.Get_Item_Value('TEST_PNT_SEQ', test_pnt_attr_);
         ELSE
            newrec_.test_pnt_seq := test_pnt_seq_;
         END IF;
         CLOSE get_equip_obj;
      END IF;
   
      IF (newrec_.lu_name = 'ToolEquipment') THEN
         OPEN get_tooleq(newrec_.resource_seq);
         FETCH get_tooleq INTO test_pnt_seq_;
         IF (get_tooleq%NOTFOUND) THEN
            Client_SYS.Add_To_Attr('TEST_POINT_ID',      newrec_.test_point_id,      test_pnt_attr_);
            Client_SYS.Add_To_Attr('DESCRIPTION',        'Default Testpoint',        test_pnt_attr_);
            Client_SYS.Add_To_Attr('MCH_CODE', Resource_Util_API.Get_Resource_Id(newrec_.resource_seq), test_pnt_attr_); 
            Client_SYS.Add_To_Attr('LU_NAME',            newrec_.lu_name,            test_pnt_attr_);       
            Client_SYS.Add_To_Attr('RESOURCE_SEQ',       newrec_.resource_seq,       test_pnt_attr_);              
            Insert_Testpoint___(test_pnt_attr_);
            newrec_.test_pnt_seq := Client_SYS.Get_Item_Value('TEST_PNT_SEQ', test_pnt_attr_);
         ELSE 
            newrec_.test_pnt_seq := test_pnt_seq_;
         END IF;
         CLOSE get_tooleq;
      END IF;
   
   END IF; 
   
   OPEN get_rec(newrec_.test_pnt_seq);
   FETCH get_rec INTO equipment_object_seq_, lu_name_, resource_seq_, test_point_id_;
   CLOSE get_rec;  
   IF resource_seq_ IS NOT NULL THEN 
      mch_code_ := Resource_Util_API.Get_Resource_Id(resource_seq_);
   END IF;
   newrec_.equipment_object_seq := equipment_object_seq_;
   newrec_.lu_name := lu_name_;
   newrec_.resource_seq := resource_seq_;
   newrec_.test_point_id := test_point_id_;
   
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr( 'TEST_PNT_SEQ', newrec_.test_pnt_seq, attr_);
   Client_SYS.Add_To_Attr( 'TEST_POINT_ID', newrec_.test_point_id, attr_);
   $IF Component_Rcmint_SYS.INSTALLED $THEN
      Rcm_Bizapi_Util_API.Param_Back_Job(newrec_.parameter_code, newrec_.unit_code);
   $ELSE
      NULL;
   $END
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
   END Insert___;
   
@Override  
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     equipment_object_param_tab%ROWTYPE,
   newrec_     IN OUT equipment_object_param_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   indrec_     Indicator_rec;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   $IF Component_Pm_SYS.INSTALLED $THEN
      IF ( ( newrec_.cal_start_date IS NOT NULL AND oldrec_.cal_start_date IS NULL ) OR 
           ( newrec_.cal_start_date IS NULL AND oldrec_.cal_start_date IS NOT NULL ) OR 
           ( newrec_.cal_start_date != oldrec_.cal_start_date ) )THEN
         PM_ACTION_CRITERIA_API.Update_From_Parameter ( newrec_.test_pnt_seq, newrec_.parameter_code );
      END IF;
   $END

   $IF Component_Rcmint_SYS.INSTALLED $THEN
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      IF ((indrec_.parameter_code = TRUE) OR (indrec_.unit_code = TRUE)) THEN
         Rcm_Bizapi_Util_API.Param_Back_Job(newrec_.parameter_code, newrec_.unit_code);
      END IF;
   $ELSE
      NULL;
   $END
END Update___;
         
PROCEDURE Insert_Testpoint___(
   attr_ IN OUT VARCHAR2)
IS
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(80);
   objversion_   VARCHAR2(2000);
BEGIN
   Equipment_Object_Test_Pnt_API.New__(info_, objid_, objversion_, attr_, 'DO');
END Insert_Testpoint___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Update_Mch_Parameter__ (
   test_pnt_seq_ IN NUMBER,
   parameter_code_ IN VARCHAR2,
   value_          IN NUMBER,
   date_           IN DATE DEFAULT NULL)
IS  
   newrec_  equipment_object_param_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(test_pnt_seq_, parameter_code_);
   newrec_.last_value := value_;
   newrec_.reg_date   := date_;
   Modify___(newrec_);
END Update_Mch_Parameter__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Unit (
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2,
   test_point_id_  IN VARCHAR2,
   parameter_code_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Unit(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), test_point_id_, parameter_code_);
END Get_Unit;

@UncheckedAccess
FUNCTION Get_Unit (
   equipment_object_seq_ IN NUMBER,
   test_point_id_        IN VARCHAR2,
   parameter_code_       IN VARCHAR2) RETURN VARCHAR2
IS
   temp_    EQUIPMENT_OBJECT_PARAM_TAB.unit_code%TYPE;
   
   CURSOR get_attr IS
   SELECT obj_param.unit_code
   FROM EQUIPMENT_OBJECT_PARAM_TAB obj_param, equipment_object_Tab equ_obj
    WHERE equ_obj.equipment_object_seq = equipment_object_seq_
    AND obj_param.equipment_object_seq = equ_obj.equipment_object_seq
    AND obj_param.test_point_id = test_point_id_
    AND obj_param.parameter_code = parameter_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Unit;

@UncheckedAccess
FUNCTION Get_Unit (
   test_pnt_seq_ IN NUMBER,
   parameter_code_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_OBJECT_PARAM_TAB.unit_code%TYPE;
CURSOR get_attr IS
   SELECT unit_code
   FROM EQUIPMENT_OBJECT_PARAM_TAB
   WHERE test_pnt_seq = test_pnt_seq_
   AND parameter_code = parameter_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Unit;   


PROCEDURE Copy (
   source_contract_ IN VARCHAR2,
   source_object_ IN VARCHAR2,
   destination_contract_ IN VARCHAR2,
   destination_object_ IN VARCHAR2,
   pm_no_                IN NUMBER DEFAULT NULL,
   pm_revision_          IN VARCHAR2 DEFAULT NULL)
IS
   attr_        VARCHAR2(32000);
   dummy_       NUMBER;
   newrec_      equipment_object_param_tab%ROWTYPE;
   
    equ_seq_    equipment_object_tab.equipment_object_seq%TYPE;
      CURSOR get_equ_seq(contract_ IN VARCHAR2, mch_code_ IN VARCHAR2) IS
      SELECT equipment_object_seq
      FROM   equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = contract_
      AND    equ_obj.mch_code = mch_code_;
   
   CURSOR source(test_point_id_ IN VARCHAR2, parameter_code_ IN VARCHAR2) IS
      SELECT obj_param.*
      FROM   EQUIPMENT_OBJECT_PARAM_TAB obj_param, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = source_contract_
      AND    equ_obj.mch_code = source_object_
      AND obj_param.equipment_object_seq = equ_obj.equipment_object_seq
      AND    obj_param.test_point_id = test_point_id_
      AND    obj_param.parameter_code = parameter_code_;
      
   CURSOR destination_exist(test_point_id_ IN VARCHAR2, parameter_code_ IN VARCHAR2) IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_PARAM_TAB obj_param, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = destination_contract_
      AND    equ_obj.mch_code = destination_object_
      AND obj_param.equipment_object_seq = equ_obj.equipment_object_seq
      AND    test_point_id =  test_point_id_
      AND    parameter_code = parameter_code_;
   
   $IF Component_Pm_SYS.INSTALLED $THEN
      CURSOR get_copy IS
         SELECT test_point_id, parameter_code 
         FROM   Pm_Action_Criteria_TAB
         WHERE  pm_no = pm_no_
         AND    pm_revision = pm_revision_;
   $END
   
   CURSOR equip_source IS
      SELECT obj_param.*
      FROM   EQUIPMENT_OBJECT_PARAM_TAB obj_param, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = source_contract_
      AND    equ_obj.mch_code = source_object_
      AND obj_param.equipment_object_seq = equ_obj.equipment_object_seq;
      
   CURSOR get_test_pnt_seq(test_point_id_  IN VARCHAR2) IS
        SELECT obj_param.test_pnt_seq
        FROM EQUIPMENT_OBJECT_TEST_PNT_TAB obj_param, equipment_object_Tab equ_obj
      WHERE  equ_obj.contract = destination_contract_
      AND    equ_obj.mch_code = destination_object_
      AND obj_param.equipment_object_seq = equ_obj.equipment_object_seq
        AND    obj_param.test_point_id = test_point_id_
        AND    obj_param.lu_name  = 'EquipmentObject';

   test_pnt_seq_   NUMBER;
BEGIN
   IF pm_no_ IS NULL THEN
      FOR instance IN equip_source LOOP
         OPEN destination_exist(instance.test_point_id, instance.parameter_code);
         FETCH destination_exist INTO dummy_;
         IF destination_exist%FOUND THEN
            CLOSE destination_exist;
         ELSE
            CLOSE destination_exist;
            OPEN get_test_pnt_seq(instance.test_point_id);
            FETCH get_test_pnt_seq INTO test_pnt_seq_;
            CLOSE get_test_pnt_seq;
            newrec_ := NULL;
            newrec_.equipment_object_seq := Equipment_Object_API.Get_Equipment_Object_Seq(destination_contract_, destination_object_);
            newrec_.test_point_id   := instance.test_point_id;
            newrec_.test_pnt_seq    := test_pnt_seq_;
            newrec_.parameter_code  := instance.parameter_code;
            newrec_.unit_code       := instance.unit_code;
            newrec_.pm_criteria     := instance.pm_criteria;
            newrec_.lu_name         := instance.lu_name;
            newrec_.blocked_for_use := instance.blocked_for_use;
            New___(newrec_);
         END IF;
      END LOOP; 
   ELSE   
       $IF Component_Pm_SYS.INSTALLED $THEN
            FOR copy_pm_para IN get_copy LOOP
               FOR instance IN source(copy_pm_para.test_point_id, copy_pm_para.parameter_code) LOOP
                  OPEN destination_exist(instance.test_point_id, instance.parameter_code);
                  FETCH destination_exist INTO dummy_;
                  IF destination_exist%FOUND THEN
                     CLOSE destination_exist;
                  ELSE
                     CLOSE destination_exist;
                     Client_SYS.Clear_Attr(attr_);
                     OPEN get_test_pnt_seq(instance.test_point_id);
                     FETCH get_test_pnt_seq INTO test_pnt_seq_;
                     CLOSE get_test_pnt_seq;
                     newrec_ := NULL;
                     newrec_.equipment_object_seq := Equipment_Object_API.Get_Equipment_Object_Seq(destination_contract_, destination_object_);
                     newrec_.test_point_id   := instance.test_point_id;
                     newrec_.test_pnt_seq    := test_pnt_seq_;
                     newrec_.parameter_code  := instance.parameter_code;
                     newrec_.unit_code       := instance.unit_code;
                     newrec_.pm_criteria     := instance.pm_criteria;
                     newrec_.lu_name         := instance.lu_name;
                     newrec_.blocked_for_use := instance.blocked_for_use;
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
FUNCTION Has_Parameter (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_object IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_PARAM
      WHERE  contract = contract_
      AND    mch_code = mch_code_;
BEGIN
   OPEN exist_object;
   FETCH exist_object INTO dummy_;
   IF exist_object%FOUND THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
   CLOSE exist_object;
END Has_Parameter;

@UncheckedAccess
FUNCTION Has_Parameter (
   test_pnt_seq_ NUMBER ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_object IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_PARAM_TAB
      WHERE  test_pnt_seq = test_pnt_seq_;
BEGIN
   OPEN exist_object;
   FETCH exist_object INTO dummy_;
   IF exist_object%FOUND THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
   CLOSE exist_object;
END Has_Parameter;

FUNCTION Has_Flip_Value (
   test_pnt_seq_   NUMBER,
   parameter_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_object IS
      SELECT 1
      FROM   EQUIPMENT_OBJECT_PARAM_TAB
      WHERE  test_pnt_seq = test_pnt_seq_
       AND   parameter_code = parameter_code_
       AND   meter_flip_value IS NOT NULL;
BEGIN
   OPEN exist_object;
   FETCH exist_object INTO dummy_;
   IF exist_object%FOUND THEN
      CLOSE exist_object;
      RETURN('TRUE');
   ELSE
      CLOSE exist_object;
      RETURN('FALSE');
   END IF;   
END Has_Flip_Value;

PROCEDURE Update_Flip_Value (
   test_pnt_seq_   NUMBER,
   parameter_code_ IN VARCHAR2,
   value_          IN NUMBER)
IS  
   newrec_  equipment_object_param_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(test_pnt_seq_, parameter_code_);   
   newrec_.meter_flip_value := value_;
   Modify___(newrec_);
END Update_Flip_Value;

FUNCTION Get_Pm_Criteria_Db(
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   test_point_id_ IN VARCHAR2,
   parameter_code_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_  EQUIPMENT_OBJECT_PARAM_TAB.pm_criteria%TYPE;
   CURSOR get_attr IS
   SELECT pm_criteria
   FROM EQUIPMENT_OBJECT_PARAM_TAB
   WHERE contract = contract_
   AND mch_code = mch_code_
   AND test_point_id = test_point_id_
   AND parameter_code = parameter_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Pm_Criteria_Db;

FUNCTION Get_Reg_Date(
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   test_point_id_ IN VARCHAR2,
   parameter_code_ IN VARCHAR2) RETURN DATE 
IS
   temp_  EQUIPMENT_OBJECT_PARAM_TAB.reg_date%TYPE;
   CURSOR get_attr IS
   SELECT reg_date
   FROM EQUIPMENT_OBJECT_PARAM_TAB
   WHERE contract = contract_
   AND mch_code = mch_code_
   AND test_point_id = test_point_id_
   AND parameter_code = parameter_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Reg_Date;

FUNCTION Get_Pm_Criteria(
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   test_point_id_ IN VARCHAR2,
   parameter_code_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_  EQUIPMENT_OBJECT_PARAM_TAB.pm_criteria%TYPE;
   CURSOR get_attr IS
   SELECT pm_criteria
   FROM EQUIPMENT_OBJECT_PARAM_TAB
   WHERE contract = contract_
   AND mch_code = mch_code_
   AND test_point_id = test_point_id_
   AND parameter_code = parameter_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN Pm_Criteria_API.Decode(temp_);
END Get_Pm_Criteria;

FUNCTION Get_Last_Value(
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   test_point_id_ IN VARCHAR2,
   parameter_code_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Last_Value(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), test_point_id_, parameter_code_);
END Get_Last_Value;


FUNCTION Get_Last_Value(
   equipment_object_seq_ IN NUMBER,
   test_point_id_        IN VARCHAR2,
   parameter_code_       IN VARCHAR2) RETURN VARCHAR2
IS
   temp_  EQUIPMENT_OBJECT_PARAM_TAB.last_value%TYPE;
   CURSOR get_attr IS
   SELECT last_value
   FROM EQUIPMENT_OBJECT_PARAM_TAB
   WHERE equipment_object_seq = equipment_object_seq_
   AND test_point_id = test_point_id_
   AND parameter_code = parameter_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Last_Value;

@UncheckedAccess
PROCEDURE Exist (
   equipment_object_seq_ IN NUMBER,
   test_point_id_        IN VARCHAR2,
   parameter_code_       IN VARCHAR2 )
IS
   temp_  NUMBER;
   exist_ VARCHAR2(5);
   
   CURSOR check_exist IS
   SELECT 1
   FROM EQUIPMENT_OBJECT_PARAM_TAB
   WHERE equipment_object_seq = equipment_object_seq_
   AND test_point_id = test_point_id_
   AND parameter_code = parameter_code_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO temp_;
   IF (check_exist%FOUND) THEN
      exist_ := 'TRUE';
   END IF;
   CLOSE check_exist;   
END Exist;

@UncheckedAccess
PROCEDURE Exist (
   contract_       IN VARCHAR2,
   mch_code_       IN VARCHAR2,
   test_point_id_  IN VARCHAR2,
   parameter_code_ IN VARCHAR2 )
IS
BEGIN
   Exist(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), test_point_id_, parameter_code_);
END Exist;

PROCEDURE Insert_Parameter(
   attr_ IN OUT VARCHAR2)
IS
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(80);
   objversion_   VARCHAR2(2000);
BEGIN
   New__(info_, objid_, objversion_, attr_, 'DO');
END Insert_Parameter;


PROCEDURE Set_Meter_Flip_Value (
   test_pnt_seq_     IN NUMBER,
   parameter_code_   IN VARCHAR2,
   meter_plif_value_ IN NUMBER )
IS
   newrec_         equipment_object_param_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___ (test_pnt_seq_, parameter_code_);
   newrec_.meter_flip_value := meter_plif_value_;
   Modify___(newrec_);
END Set_Meter_Flip_Value;
   
   

