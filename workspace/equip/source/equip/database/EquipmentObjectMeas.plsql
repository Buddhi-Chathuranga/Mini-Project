-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjectMeas
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950802  SLKO  Created.
--  950831  TOWI  Added EXIT at end of file and modified procedure Exist not
--                to validate NULL values.
--  950901  NILA  Corrected procedure Exist due to compilation error.
--  950918  STOL  Moved creation of view from script to package.
--                Added view comments.
--  951021  OYME  Recreated using Base Table to Logical Unit Generator UH-Special
--  951023  OYME  Removed exists-test on test_sequence_id.
--  951029  OYME  Corrected ref= in view-comment on test_point_id.
--  960321  JOMO  Added Validate_Comb___ with exist-control on
--                EquipmentObjectTestPoint.
--  960612  MINI  Changed reference in viewcomment for parameter_code
--  961006  TOWI  Generated from Rose-model using Developer's Workbench 1.2.2.
--  961203  ADBR  Added Dynamic_Call.
--  961204  ADBR  Added Update_Mch_Parameter.
--  961219  ADBR  Merged with new templates.
--  970402  TOWI  Adjusted to new templates in Foundation 1.2.2c.
--  970610  JOSC  Ref 97-0025: Added remark at insert.
--  970919  CAJO  Converted to F1 2.0. Changed table name to equipment_object_meas_tab.
--  970923  ERJA  Changed ms_values_seq to equipment_object_meas_seq
--  971120  ERJA  Added Contract
--  971218  ERJA  Correction in unpack_check_insert.
--  980319  CAJO  Removed contract from prepare_insert. Changed to fnd_user.
--  980422  MNYS  Support Id: 3984. Added contract in Prepare_Insert___.
--                Support Id: 2895. Added check on reg_date in Unpack_Check_Insert___ and
--                Unpack_Check_Update___.
--  990113  MIBO  SKY.0208 AND SKY.0209 Changed SYSDATE to Site_API.Get_Site_Date(contract)
--  990118  MIBO  SKY.0209 Changed Site_API.Get_Site_Date(contract) to
--                Maintenance_Site_Utility_API.Get_Site_Date(contract).
--  99011  MIBO   SKY.0209 Changed Maintenance_Site_Utility_API.Get_Site_Date(User_Default_API.Get_Contract) to
--                Maintenance_Site_Utility_API.Get_Site_Date(NULL).
--  981230  ANCE  Checked and updated 'Uppercase/Unformatted' (SKY.0206).
--  990401  CLCA  Added Procedure New.
--  990409  MIBO  Template changes due to performance improvement.
--  000420 BGADSE Call Id 37990: Prepare_Insert____: Added default CONTRACT.
--  001027 PJONSE Added 'IF (remark_ IS NULL) THEN' in Procedure New.
--  011227 SHAFLK Bug 27083,Removed the 6 position limit on values_seq_ in Prepare_Insert___ and New.
--  ************************************* AD 2002-3 BASELINE ********************************************
--  020604 CHAMLK Modified the length of the MCH_CODE from 40 to 100 in view EQUIPMENT_OBJECT_MEAS
--  ************************************* Merge of Service Pack 3 ***************************************
--  021015 SHAFLK Bug 33525,Modified procedure Delete___.
--  021127 SHAFLK Bug 34501,Modified procedure Delete___.
--  021216 UDSULK Added body of FUNCTION Max_Measured_Value
--  230304 DIMALK Unicode Support. Converted all the 'dbms_sql' codes to Native Dynamic SQL statements, inside the package body.
--  ------------------------------ Edge - SP1 Merge -------------------------------------
--  040324 JAPALK Merge with SP1
--  040922 ARWILK Modified method Unpack_Check_Update___(LCS 46773).
--  040930 SHAFLK Bug 47192,Modified procedure Unpack_Check_Insert___.
--  041007 SHAFLK Bug 47192, Modified added error message in procedure Unpack_Check_Insert___.
--  041104 Chanlk Merged Bug 47192.
--  050627 SHAFLK Bug 51705, Modified procedure Delete___. 
--  050701 NIJALK Merged bug 51705. 
--  080404 Chanlk Bug 72784, Modified methods Delete and Insert
--  090326 SHAFLK Bug 81639, Modified FUNCTION Max_Measured_Value.
--  100508 CHODLK Bug 86377, Modified Prepare_Insert___(),New().  
--  101021 NIFRSE Bug 93384, Updated view column prompts to 'Object Site'.
--  091019 LoPrlk EAME-182: Remove unused internal variables in EQUIP.
--  091106 SaFalk IID - ME310: Removed bug comment tags.
--  110127 NEKOLK EANE-3710 added User_Allowed_Site_API.Authorized filter to View EQUIPMENT_OBJECT_MEAS.
--  110221 SaFalk EANE-4424, Modified Delete___ to use TABLE.
--  130311 MITKLK EIGHTSA-722, Added procedure 'Get_Forcast_Date' for linear regression 
--  -------------------------Project Black Pearl---------------------------------------------------------------
--  130613 MADGLK BLACK-65 , Removed MAINTENANCE_OBJECT_API method calls.
--  ------------------------------------------------------------------------- 
--  131128 ChAmlk Hooks: Created
--  140219 buralk PBSA-4964:Fixed
--  140408 nifrse PBSA-4711, Get_Forscast_date Handled divide by zero problem.
--  140512 NIFRSE PBSA-7111, Update the code using Database constants instead of hardcoded values, except in some cursor definitions.
--  140813 HASTSE Replaced dynamic code and cleanup
--  140817 SAFALK PRSA-2254, removed '&' in one of the comments.
--  140819 SHAFLK  PRSA-2134, Modified Check_Common___().
--  140916 HASTSE PBSA-2511, Refacturing Criteria plan generation, Removed Equipment and ToolEq attributes from PmActionCriteria
--  141002 HASTSE PRSA-2516, Refactured Measurment handling
--  141009 SHAFLK PRSA-4681, Corrected in Calc_Accumulated_Value___.
--  141015 HASTSE PRSA-2512, Cleanup
--  140220 HASTSE PRSA-4863, errors in overdue handling
--  141022 HASTSE PRSA-4964, Forcast calculation problems
--  141111 KrRaLK PRSA-5241, Modified Get_Latest_Measured_Value(), with @UncheckedAccess annotation.
--  141121 HASTSE PRSA-5201, fixed handling if reading set to incorrect
--  170210 UMDILK STRSA-18495, Modified Prepare_Insert___.
--  170707 BHKALK STRSA-27019, Modified Handle_Meter_Change() and Calc_Accumulated_Value___().
--  180108 ARUFLK STRSA-33828, Modified Get_Prev_Rec_Val_By_Date() and Calc_Accumulated_Value___().
--  180510 SHEPLK Bug 141474, Modified New() and Check_Insert___().
--  180724 DMALLK BUG 142790, Modified method to do Maintenace plan regenaration as ONLINE/BATCH.
--  181205 DMALLK BUG 145741, Modified methods to handle incorrect,meter roll over, meter flip in background when necessary and introduced Handle_Pm_Action_Criteria().
--  190104 HILALK NGMWO-3571, Added Get_Meter_Id_For_Latest_Value(), Get_Latest_Rec_Value_All_Types() and Get_Latest_Reg_Date_All_Types().
--  2018-12-25  HMANLK  SAUXXW4-710, Added validation for start and end reading values.
--  2019-06-25  INROLK  SAZM-1565, Added method Get_Last_Comple_Value .
--  200514 CLEKLK Bug 152496, Modifying the column size of TEST_POINT_ID.
--  200715 NEKOLK AMZWOP-771: bug 154820 , Get_Forcast_Date()
--  210130 DEEKLK AM2020R1-7382, Modified Handle_Pm_Action_Criteria().
--  210524 THWCLK AM21R2-1474, Modified Get_Forcast_Date() and remove Get_Forcast_Value(),Get_Prev_Recorded_Value().  
--  220111 KrRaLK AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS   
   remark_      VARCHAR2(70);
   user_        VARCHAR2(30);
   contract_    VARCHAR2(5);
BEGIN
   contract_ := nvl(Equipment_Object_API.Get_Contract(Client_SYS.Get_Item_Value('EQUIPMENT_OBJECT_SEQ', attr_)), User_Default_API.Get_Contract);
   super(attr_);
   
   remark_ := Language_SYS.Translate_Constant(lu_name_, 'CREBY: Created by');
   user_ := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr( 'REMARK',              remark_||' '||user_, attr_ );      
   Client_SYS.Add_To_Attr( 'REG_DATE',            Maintenance_Site_Utility_API.Get_Site_Date(contract_), attr_ );  
   Client_SYS.Add_To_Attr( 'TEST_SEQUENCE_ID',
   Def_Key_Value_API.Get_Db_Value(0), attr_ );
 END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT EQUIPMENT_OBJECT_MEAS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   last_reg_date_ DATE;
   contract_      Equipment_Object_Tab.Contract%TYPE;
   mch_code_      Equipment_Object_Tab.Mch_Code%TYPE;
   
   CURSOR get_rec(test_pnt_seq_ IN NUMBER) IS 
        SELECT equipment_object_seq, test_point_id, resource_seq, contract, mch_code
        FROM equipment_object_test_pnt_tab
        WHERE test_pnt_seq = test_pnt_seq_;

    equipment_object_seq_  equipment_object_meas_tab.test_point_id%TYPE;
    test_point_id_   EQUIPMENT_OBJECT_MEAS_TAB.test_point_id%TYPE;
    resource_seq_   NUMBER;
    values_seq_  NUMBER := NULL;
    execution_method_   VARCHAR2(6);
    parameter_type_db_  VARCHAR2(20);      
BEGIN
   
   SELECT equipment_object_meas_seq.nextval
      INTO values_seq_
      FROM dual;
    
    newrec_.values_seq := values_seq_;
      
   OPEN get_rec(newrec_.test_pnt_seq);
   FETCH get_rec INTO equipment_object_seq_, test_point_id_, resource_seq_,contract_,mch_code_;
   CLOSE get_rec;
   
   newrec_.equipment_object_seq := equipment_object_seq_;
   newrec_.test_point_id := test_point_id_;
   newrec_.resource_seq  := resource_seq_;
   newrec_.contract      := contract_;
   newrec_.mch_code      := mch_code_;
   
   
   
   super(objid_, objversion_, newrec_, attr_);
  
   last_reg_date_ := Equipment_Object_Param_API.Get_Reg_Date(newrec_.test_pnt_seq, newrec_.parameter_code);
   execution_method_ := Object_Property_API.Get_Value('MaintenanceConfiguration', '*', 'PM_CON_PLAN_SYNC');
   parameter_type_db_ := Measurement_Parameter_API.Get_Measurement_Param_Type_Db(newrec_.parameter_code);
     
   IF ((last_reg_date_ IS NULL OR last_reg_date_ < newrec_.reg_date) AND newrec_.measurement_type IN (Measurement_Type_API.DB_RECORDED_READING, Measurement_Type_API.DB_METER_CHANGE_BEFORE)) THEN
     Equipment_Object_Param_API.Update_Mch_Parameter__(newrec_.test_pnt_seq, newrec_.parameter_code, newrec_.measured_value,newrec_.reg_date);
     IF execution_method_ = 'ONLINE' OR parameter_type_db_ != Measurement_Param_Type_Api.DB_ACCUMULATED THEN 
         $IF Component_Pm_SYS.INSTALLED $THEN       
            PM_ACTION_CRITERIA_API.Update_Last_Measured_Value(newrec_.test_pnt_seq, newrec_.parameter_code, newrec_.measured_value);     
         $ELSE
            NULL;
         $END
      END IF;
      --Update Recurring Service Trigger for Accumulated and Limit parameters
         $IF Component_Recsrv_SYS.INSTALLED $THEN       
            Recurring_Service_Trigger_API.Update_Last_Measured_Value(newrec_.test_pnt_seq, newrec_.parameter_code, newrec_.measured_value, newrec_.reg_date);
         $ELSE
            NULL;
         $END
   END IF;
   
   IF execution_method_ = 'ONLINE' OR parameter_type_db_ != Measurement_Param_Type_Api.DB_ACCUMULATED THEN 
      $IF Component_Pm_SYS.INSTALLED $THEN
         IF ( newrec_.measurement_type IN (Measurement_Type_API.DB_RECORDED_READING, Measurement_Type_API.DB_METER_CHANGE_BEFORE)) THEN
            PM_ACTION_CRITERIA_API.Update_From_Measurement ( newrec_.values_seq, newrec_.test_pnt_seq, newrec_.parameter_code, newrec_.measured_value, newrec_.reg_date);
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
   IF execution_method_ = 'BATCH' AND parameter_type_db_ = Measurement_Param_Type_Api.DB_ACCUMULATED THEN 
      $IF Component_Pm_SYS.INSTALLED $THEN
         Handle_Pm_Action_Criteria ( values_seq_ => newrec_.values_seq, 
                                      test_pnt_seq_ => newrec_.test_pnt_seq, 
                                      parameter_code_ => newrec_.parameter_code, 
                                      mch_code_ => Equipment_Object_API.Get_Mch_code(newrec_.equipment_object_seq), 
                                      contract_ => Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq), 
                                      measurement_type_ => newrec_.measurement_type);
      $ELSE
         NULL;
      $END
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN equipment_object_meas_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'NOREMOVE: Registrations can not be removed, instead set it as incorrect.');

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     equipment_object_meas_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY equipment_object_meas_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.reg_date > Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq))) THEN
        Error_SYS.Appl_General(lu_name_, 'WRONGDATE: Registration Date can not be later than the date of today.');
   END IF;
   IF (Meter_Id_Required_API.Encode(Measurement_Parameter_API.Get_Meter_Id_Required(newrec_.parameter_code)) ='M') THEN
     IF (newrec_.meter_id IS NULL ) THEN
            Error_SYS.Appl_General(lu_name_, 'METERIDREQUIRED: This parameter requires a Meter ID - please enter the ID.');
     END IF;
   END IF;
END Check_Common___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT equipment_object_meas_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Calc_Accumulated_Value___ ( newrec_.measured_value, newrec_.measurement_type, newrec_.recorded_value, newrec_.reg_date, newrec_.test_pnt_seq, newrec_.parameter_code );
   Client_SYS.Add_To_Attr('MEASURED_VALUE', newrec_.measured_value, attr_);
   Client_SYS.Add_To_Attr('MEASUREMENT_TYPE_DB', newrec_.measurement_type, attr_);
   
   --indrec_.contract := FALSE;
   super(newrec_, indrec_, attr_);
   
   IF (Is_Reg_Date_Exists(newrec_.test_pnt_seq, newrec_.parameter_code, newrec_.reg_date) = 1 AND newrec_.measurement_type != Measurement_Type_API.DB_METER_ROLL_OVER ) THEN      
      Error_SYS.Appl_General(lu_name_, 'EQUIPDUPLIDATE: A Measurement is already exists on (:P1) for parameter (:P2) and test point (:P3) combination.', TO_CHAR(newrec_.reg_date, 'MM/DD/YYYY HH12:MI:SS AM'), newrec_.parameter_code, newrec_.test_point_id);      
   END IF;
    
END Check_Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     equipment_object_meas_tab%ROWTYPE,
   newrec_     IN OUT equipment_object_meas_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   last_reg_date_        DATE;
   update_pms_           VARCHAR2(5);
   execution_method_     VARCHAR2(6);
   parameter_type_db_    VARCHAR2(20); 
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   last_reg_date_ := Equipment_Object_Param_API.Get_Reg_Date(newrec_.test_pnt_seq, newrec_.parameter_code);
   execution_method_ := Object_Property_API.Get_Value('MaintenanceConfiguration', '*', 'PM_CON_PLAN_SYNC');
   parameter_type_db_ := Measurement_Parameter_API.Get_Measurement_Param_Type_Db(newrec_.parameter_code);
   
   IF ((last_reg_date_ IS NULL OR last_reg_date_ < newrec_.reg_date) AND newrec_.measurement_type = Measurement_Type_API.DB_RECORDED_READING) THEN
      Equipment_Object_Param_API.Update_Mch_Parameter__(newrec_.test_pnt_seq, newrec_.parameter_code, newrec_.measured_value,newrec_.reg_date);
      $IF Component_Pm_SYS.INSTALLED $THEN  
         IF execution_method_ = 'ONLINE' OR parameter_type_db_ != Measurement_Param_Type_Api.DB_ACCUMULATED THEN
            Pm_Action_Criteria_API.Update_Last_Measured_Value(newrec_.test_pnt_seq, newrec_.parameter_code, newrec_.measured_value);  
         END IF;
      $ELSE
         NULL;
      $END
      --Update Recurring Service Trigger for Accumulated and Limit parameters
      $IF Component_Recsrv_SYS.INSTALLED $THEN       
         Recurring_Service_Trigger_API.Update_Last_Measured_Value(newrec_.test_pnt_seq, newrec_.parameter_code, newrec_.measured_value, newrec_.reg_date);
      $ELSE
         NULL;
      $END
   END IF;
   
   $IF Component_Pm_SYS.INSTALLED $THEN
      /* 
         update_pms_ - PM Calendar plan regenerate along with change in record.
      */
      update_pms_ := NVL(Client_SYS.Get_Item_Value('UPDATE_PM', attr_),'TRUE');
         
      IF ( newrec_.measurement_type IN (Measurement_Type_API.DB_RECORDED_READING, Measurement_Type_API.DB_METER_CHANGE_BEFORE)) THEN
         IF execution_method_ = 'ONLINE' OR parameter_type_db_ != Measurement_Param_Type_API.DB_ACCUMULATED AND update_pms_ = 'TRUE' THEN 
            Pm_Action_Criteria_API.Update_From_Measurement( newrec_.values_seq, newrec_.test_pnt_seq, newrec_.parameter_code, newrec_.measured_value, newrec_.reg_date);
         END IF;
      ELSIF ( newrec_.measurement_type = Measurement_Type_API.DB_INCORRECT_READING AND oldrec_.measurement_type != Measurement_Type_API.DB_INCORRECT_READING AND newrec_.measured_value IS NOT NULL) THEN
         Pm_Action_Criteria_API.Update_Incorrect_Measurement ( newrec_.values_seq, newrec_.test_pnt_seq, newrec_.parameter_code, newrec_.measured_value, newrec_.reg_date);
      END IF;
      
      IF execution_method_ = 'BATCH' AND parameter_type_db_ = Measurement_Param_Type_API.DB_ACCUMULATED  AND update_pms_ = 'TRUE' THEN          
         IF ( newrec_.measurement_type IN (Measurement_Type_API.DB_RECORDED_READING, Measurement_Type_API.DB_METER_CHANGE_BEFORE)) THEN
            Handle_Pm_Action_Criteria( values_seq_ => newrec_.values_seq, 
                                       test_pnt_seq_ => newrec_.test_pnt_seq, 
                                       parameter_code_ => newrec_.parameter_code, 
                                       mch_code_ => Equipment_Object_API.Get_Mch_code(newrec_.equipment_object_seq), 
                                       contract_ => Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq),
                                       measurement_type_ => newrec_.measurement_type);
         END IF;         
      END IF;
   $ELSE
      NULL;
   $END

EXCEPTION
   WHEN dup_val_on_index THEN
      Raise_Record_Exist___(newrec_);
END Update___;

PROCEDURE Calc_Accumulated_Value___ (   
   measured_value_   OUT NUMBER,
   measurement_type_ IN OUT VARCHAR2,
   recorded_value_   IN NUMBER,
   reg_date_         IN DATE,
   test_pnt_seq_     IN NUMBER,
   parameter_code_   IN VARCHAR2)
IS
   
   CURSOR row_no_prev_meas_typ_eql_date IS
      SELECT count(*) 
         FROM (SELECT recorded_value, reg_date, measurement_type, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE test_pnt_seq = test_pnt_seq_
                  AND parameter_code = parameter_code_                  
                  AND reg_date = reg_date_
                  AND measurement_type NOT IN ('IncorrectReading','MeterSetup')
                  ORDER BY reg_date DESC);
   
   CURSOR get_prev_meas_typ_lesser_date IS
      SELECT recorded_value, reg_date, measurement_type, MEASURED_VALUE 
         FROM (SELECT recorded_value, reg_date, measurement_type, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE test_pnt_seq = test_pnt_seq_
                  AND parameter_code = parameter_code_                  
                  AND reg_date < reg_date_
                  AND measurement_type NOT IN ('IncorrectReading','MeterSetup')
                  ORDER BY reg_date DESC, values_seq DESC)
         WHERE ROWNUM = 1;
   
   CURSOR get_prev_meas_typ_equal_date IS
      SELECT recorded_value, reg_date, measurement_type, MEASURED_VALUE 
         FROM (SELECT recorded_value, reg_date, measurement_type, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE test_pnt_seq = test_pnt_seq_
                  AND parameter_code = parameter_code_                  
                  AND reg_date = reg_date_
                  AND measurement_type NOT IN ('IncorrectReading','MeterSetup')
                  ORDER BY reg_date DESC)
         WHERE ROWNUM = 1;
   
   CURSOR get_last_correct_record IS
      SELECT recorded_value, reg_date
         FROM (SELECT recorded_value, reg_date, measurement_type, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE test_pnt_seq = test_pnt_seq_
                  AND parameter_code = parameter_code_                  
                  AND measurement_type NOT IN ('IncorrectReading', 'PreliminaryReading', 'MeterSetup')
                  ORDER BY reg_date DESC, MEASURED_VALUE DESC)
         WHERE ROWNUM = 1;   
   
   CURSOR get_higher_value(date_ DATE) IS
      SELECT recorded_value, MEASURED_VALUE, measurement_type, values_seq 
      FROM (SELECT recorded_value, MEASURED_VALUE, measurement_type, values_seq 
                  FROM EQUIPMENT_OBJECT_MEAS_TAB
                     WHERE test_pnt_seq = test_pnt_seq_
                     AND parameter_code = parameter_code_                     
                     AND reg_date > date_
                     AND measurement_type NOT IN ('IncorrectReading', 'PreliminaryReading', 'MeterSetup')
                     ORDER BY reg_date)
            WHERE ROWNUM = 1;
   
   CURSOR get_lower_value IS
      SELECT recorded_value, MEASURED_VALUE, Reg_date 
         FROM (SELECT recorded_value, MEASURED_VALUE, Reg_date 
                  FROM EQUIPMENT_OBJECT_MEAS_TAB
                     WHERE test_pnt_seq = test_pnt_seq_
                     AND parameter_code = parameter_code_                     
                     AND reg_date <= reg_date_
                     AND measurement_type NOT IN ('IncorrectReading', 'PreliminaryReading', 'MeterSetup')
                     ORDER BY reg_date DESC)
                  WHERE ROWNUM = 1;
   
   CURSOR get_next_rec_val IS
      SELECT recorded_value 
         FROM (SELECT recorded_value 
               FROM EQUIPMENT_OBJECT_MEAS_VALID
                  WHERE test_pnt_seq = test_pnt_seq_
                  AND parameter_code = parameter_code_                  
                  AND reg_date > reg_date_                  
                  ORDER BY reg_date ASC)
         WHERE ROWNUM = 1;
         
   CURSOR meter_setup_rec_val IS
      SELECT recorded_value 
      FROM EQUIPMENT_OBJECT_MEAS_TAB
      WHERE test_pnt_seq = test_pnt_seq_
         AND parameter_code = parameter_code_                  
         AND measurement_type = 'MeterSetup';
         
   max_                    NUMBER;
   is_new_record_          NUMBER := 0;
   last_recorded_value_    EQUIPMENT_OBJECT_MEAS_TAB.recorded_value%TYPE;
   last_reg_date_          EQUIPMENT_OBJECT_MEAS_TAB.reg_date%TYPE;
   
   lower_value_            EQUIPMENT_OBJECT_MEAS_TAB.recorded_value%TYPE;
   higher_value_           EQUIPMENT_OBJECT_MEAS_TAB.recorded_value%TYPE;
   lower_measured_value_   EQUIPMENT_OBJECT_MEAS_TAB.measured_value%TYPE;
   higher_measured_value_  EQUIPMENT_OBJECT_MEAS_TAB.measured_value%TYPE;
   lower_date_             EQUIPMENT_OBJECT_MEAS_TAB.reg_date%TYPE;
   dummy_date_             EQUIPMENT_OBJECT_MEAS_TAB.reg_date%TYPE;
   
   prev_recorded_value_    EQUIPMENT_OBJECT_MEAS_TAB.recorded_value%TYPE;
   prev_reg_date_          EQUIPMENT_OBJECT_MEAS_TAB.reg_date%TYPE;
   prev_meas_type_         EQUIPMENT_OBJECT_MEAS_TAB.measurement_type%TYPE;
   prev_measured_value_    EQUIPMENT_OBJECT_MEAS_TAB.measured_value%TYPE;
   
   meter_flip_value_       NUMBER;
   total_value_            EQUIPMENT_OBJECT_MEAS_TAB.measured_value%TYPE;
   
   seq_no_                 EQUIPMENT_OBJECT_MEAS_TAB.values_seq%TYPE;
   next_meas_type_         EQUIPMENT_OBJECT_MEAS_TAB.measurement_type%TYPE;
   new_date_               EQUIPMENT_OBJECT_MEAS_TAB.reg_date%TYPE;
   next_recorded_value_    EQUIPMENT_OBJECT_MEAS_TAB.recorded_value%TYPE;
   
   row_count_              NUMBER;
   temp_meas_type_         EQUIPMENT_OBJECT_MEAS_TAB.measurement_type%TYPE;

   contract_               Equipment_Object_Test_Pnt_Tab.contract%TYPE;
   meter_setup_val_        NUMBER;
BEGIN
   
   IF (reg_date_ IS NULL) THEN
      contract_ := Equipment_Object_Test_Pnt_Api.Get_Contract(test_pnt_seq_);
      IF(contract_ IS NULL) THEN
         dummy_date_:= sysdate;
      ELSE 
          dummy_date_ := Maintenance_Site_Utility_API.Get_Site_Date(contract_);
      END IF;      
   ELSE
      dummy_date_ := reg_date_;
   END IF;
   
   IF (Measurement_Parameter_API.Get_Measurement_Param_Type_Db(parameter_code_) = Measurement_Param_Type_API.DB_ACCUMULATED) THEN       
      max_ := Max_Measured_Value(test_pnt_seq_, parameter_code_);
      meter_flip_value_    := EQUIPMENT_OBJECT_PARAM_API.Get_Meter_Flip_Value(test_pnt_seq_, parameter_code_);

      OPEN  get_last_correct_record;
      FETCH get_last_correct_record INTO last_recorded_value_, last_reg_date_;
      IF (get_last_correct_record %NOTFOUND) THEN
         is_new_record_ := 1;
      END IF;
      CLOSE get_last_correct_record;

      --If there are previous readings and measurement_type_ passed to method is null
      IF (is_new_record_ = 0 AND (measurement_type_ IS NULL OR measurement_type_ = Measurement_Type_API.DB_METER_CHANGE_BEFORE)) THEN 
         
         IF (measurement_type_ = Measurement_Type_API.DB_METER_CHANGE_BEFORE) THEN
            temp_meas_type_   := measurement_type_;
            measurement_type_ := '';
         END IF;
         
         OPEN  row_no_prev_meas_typ_eql_date;
         FETCH row_no_prev_meas_typ_eql_date INTO row_count_;
         CLOSE row_no_prev_meas_typ_eql_date;
         
         IF row_count_ > 1 THEN
            FOR equel_rec_ IN get_prev_meas_typ_equal_date LOOP
               IF (equel_rec_.measurement_type = Measurement_Type_API.DB_METER_ROLL_OVER) OR (equel_rec_.measurement_type = Measurement_Type_API.DB_METER_CHANGE_AFTER) THEN
                  prev_recorded_value_ := equel_rec_.recorded_value;
                  prev_reg_date_       := equel_rec_.reg_date;
                  prev_meas_type_      := equel_rec_.measurement_type;
                  prev_measured_value_ := equel_rec_.MEASURED_VALUE;
               END IF;               
            END LOOP;            
         ELSE
            OPEN  get_prev_meas_typ_lesser_date;
            FETCH get_prev_meas_typ_lesser_date INTO prev_recorded_value_, prev_reg_date_, prev_meas_type_, prev_measured_value_;
            CLOSE get_prev_meas_typ_lesser_date;
               
            OPEN  get_prev_meas_typ_lesser_date;
            FETCH get_prev_meas_typ_lesser_date INTO prev_recorded_value_, prev_reg_date_, prev_meas_type_, prev_measured_value_;
            CLOSE get_prev_meas_typ_lesser_date;
         END IF;
         
         --If previous measurement type is RecordedReading and currect reading is less than the Meter Flip Value. 
         IF (prev_meas_type_ IN (Measurement_Type_API.DB_RECORDED_READING, Measurement_Type_API.DB_METER_CHANGE_AFTER)) AND (recorded_value_ <= NVL(meter_flip_value_, recorded_value_)) THEN  

            IF (dummy_date_ >= last_reg_date_) THEN
               IF (last_recorded_value_ <=  recorded_value_) THEN
                  measured_value_   := (recorded_value_ - last_recorded_value_) + max_;
                  measurement_type_ := Measurement_Type_API.DB_RECORDED_READING;              
               ELSE
                  --Registration Date can not be lesser than the previous Registration Date for Recorded Value   
                  measurement_type_ := Measurement_Type_API.DB_PRELIMINARY_READING;
               END IF;            
            ELSIF (dummy_date_ < last_reg_date_) THEN
               OPEN  get_higher_value(reg_date_);
               FETCH get_higher_value INTO higher_value_, higher_measured_value_, next_meas_type_, seq_no_;   
               CLOSE get_higher_value;

               OPEN  get_lower_value;
               FETCH get_lower_value INTO lower_value_, lower_measured_value_, lower_date_;   
               CLOSE get_lower_value;

               IF recorded_value_ <= higher_value_ AND recorded_value_ >= lower_value_ THEN
                  measured_value_   := (recorded_value_ - lower_value_) + lower_measured_value_;
                  measurement_type_ := Measurement_Type_API.DB_RECORDED_READING;
               ELSE 

                  --If Next measurement type is Meter Roll Over and recorded value is lesser than the next Recorded Reading                  
                  IF (next_meas_type_ = Measurement_Type_API.DB_METER_ROLL_OVER ) THEN
                     OPEN  get_next_rec_val;
                     FETCH get_next_rec_val INTO next_recorded_value_;   
                     CLOSE get_next_rec_val;

                     --IF recorded value is lesser than the next Recorded Reading 
                     IF (next_recorded_value_ > recorded_value_) THEN

                        SELECT reg_date_- interval '1' second
                           INTO new_date_
                        FROM dual;

                        --If new Meter Roll Over date is higher than the previous Recorded Reading
                        IF (lower_date_ < new_date_) THEN

                           --Reduce Meter Roll Over date by 1 second
                           Update_Reading_Date__(seq_no_, new_date_);

                           measured_value_   := (recorded_value_ + higher_measured_value_);
                           measurement_type_ := Measurement_Type_API.DB_RECORDED_READING; 
                        ELSE                                                                                                                                                                 
                           measurement_type_ := Measurement_Type_API.DB_PRELIMINARY_READING;
                        END IF;         
                     ELSE                                                                                                                                                             
                        measurement_type_ := Measurement_Type_API.DB_PRELIMINARY_READING;
                     END IF; 
                  ELSE                                                                                                                                                          
                     measurement_type_ := Measurement_Type_API.DB_PRELIMINARY_READING;                    
                  END IF;                  
               END IF;
            ELSE
               --Recorded Value can not be lesser than the previous Recorded Value.
               measurement_type_ := Measurement_Type_API.DB_PRELIMINARY_READING;
            END IF; 
         ELSIF (prev_meas_type_ = Measurement_Type_API.DB_METER_ROLL_OVER) AND (recorded_value_ <= NVL(meter_flip_value_, recorded_value_)) THEN  
            --First Record after the meter roll over and if currect reading is less than the Meter Flip Value.
            IF (dummy_date_ >= last_reg_date_) THEN
               IF (last_recorded_value_ >  recorded_value_) THEN
                  --measured_value_ := Suggest_Total_Value_After_Flip(parameter_code_, test_pnt_seq_, recorded_value_, reg_date_);
                  measured_value_   := prev_measured_value_ +  recorded_value_;
                  measurement_type_ := Measurement_Type_API.DB_RECORDED_READING;  
                  
               ELSE
                  measurement_type_ := Measurement_Type_API.DB_PRELIMINARY_READING;
               END IF;
            ELSIF (dummy_date_ < last_reg_date_) THEN
               OPEN  get_higher_value(reg_date_);
               FETCH get_higher_value INTO higher_value_, higher_measured_value_, next_meas_type_, seq_no_;   
               CLOSE get_higher_value;
               IF (prev_recorded_value_ > recorded_value_) AND (recorded_value_ <= higher_value_) THEN
                  measured_value_   := prev_measured_value_ + recorded_value_;
                  measurement_type_ := Measurement_Type_API.DB_RECORDED_READING;
               ELSE
                  measurement_type_ := Measurement_Type_API.DB_PRELIMINARY_READING;
               END IF;               
            ELSE
               measurement_type_ := Measurement_Type_API.DB_PRELIMINARY_READING;
            END IF;
         ELSIF (prev_meas_type_ IS NULL) THEN
            OPEN  get_higher_value(reg_date_);
            FETCH get_higher_value INTO higher_value_, higher_measured_value_, next_meas_type_, seq_no_;   
            CLOSE get_higher_value;
            
            IF (recorded_value_ <= higher_value_ AND next_meas_type_ = Measurement_Type_API.DB_RECORDED_READING) THEN
               measured_value_   := recorded_value_;
               measurement_type_ := Measurement_Type_API.DB_RECORDED_READING;
            ELSE
               measurement_type_ := Measurement_Type_API.DB_PRELIMINARY_READING;
            END IF;                          
         ELSE
            measurement_type_ := Measurement_Type_API.DB_PRELIMINARY_READING;
         END IF;        
      ELSIF (measurement_type_ = Measurement_Type_API.DB_METER_ROLL_OVER) THEN        
            --When inserting Meter Roll Over Record
            --recorded_value_ = meter_flip_value_ 
            prev_recorded_value_ := Get_Prev_Rec_Val_By_Date(reg_date_, test_pnt_seq_, parameter_code_);                                 
            total_value_         := Get_Prev_Total_Val_By_Date(reg_date_, test_pnt_seq_, parameter_code_);    
            measured_value_      := (recorded_value_ - prev_recorded_value_) + total_value_;
            measurement_type_    := Measurement_Type_API.DB_METER_ROLL_OVER;
            
      ELSIF (measurement_type_ = Measurement_Type_API.DB_METER_CHANGE_AFTER) THEN 
         total_value_         := Get_Prev_Total_Val_By_Date(reg_date_, test_pnt_seq_, parameter_code_);
         measured_value_      := total_value_;
         measurement_type_    := Measurement_Type_API.DB_METER_CHANGE_AFTER;
         
      ELSIF (measurement_type_ = Measurement_Type_API.DB_METER_SETUP) THEN            
         measurement_type_    := Measurement_Type_API.DB_METER_SETUP;         
         measured_value_      := 0;
      ELSIF (is_new_record_ = 1) AND (recorded_value_ <= NVL(meter_flip_value_, recorded_value_)) THEN
         --For the very first reading
         
         OPEN meter_setup_rec_val;
         FETCH meter_setup_rec_val INTO meter_setup_val_;
         CLOSE meter_setup_rec_val; 
     
         IF (meter_setup_val_ IS NULL) THEN
            meter_setup_val_ := 0;
         END IF;         
         measured_value_ := (recorded_value_ - meter_setup_val_ );
               
         IF ( measurement_type_ IS NULL ) THEN
            measurement_type_ := Measurement_Type_API.DB_RECORDED_READING;
         END IF;         
      ELSE
         measurement_type_ := Measurement_Type_API.DB_PRELIMINARY_READING;
      END IF;                  
   ELSE
      IF (measurement_type_ = Measurement_Type_API.DB_METER_SETUP) THEN
         measurement_type_ := Measurement_Type_API.DB_METER_SETUP;      
         measured_value_      := 0;
      ELSE
         measurement_type_ := Measurement_Type_API.DB_RECORDED_READING;
         measured_value_   := recorded_value_;
      END IF;                           
   END IF;
   
   IF (temp_meas_type_ = Measurement_Type_API.DB_METER_CHANGE_BEFORE AND measurement_type_ = Measurement_Type_API.DB_RECORDED_READING) THEN
      measurement_type_ := temp_meas_type_;
   END IF;

END Calc_Accumulated_Value___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Update_Reading_Date__ (
   seq_values_       IN NUMBER,
   new_date_         IN DATE) 
IS        
   newrec_  equipment_object_meas_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(seq_values_);
   newrec_.reg_date := new_date_;
   Modify___(newrec_);        
END Update_Reading_Date__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Max_Measured_Value (
   test_pnt_seq_   IN NUMBER, 
   parameter_code_ IN  VARCHAR2) RETURN NUMBER
IS
   CURSOR Measured IS
      SELECT MAX(measured_value)
        FROM EQUIPMENT_OBJECT_MEAS_VALID
       WHERE test_pnt_seq = test_pnt_seq_      
         AND parameter_code = parameter_code_;

   max_ NUMBER;
BEGIN
   max_:=0;
   
   OPEN Measured;
   FETCH Measured INTO max_;
   IF Measured%NOTFOUND THEN
      max_:=0;
   END IF;
   CLOSE Measured;

   RETURN max_;
END Max_Measured_Value;


FUNCTION Get_No_Of_Measurements(
   test_pnt_seq_   IN NUMBER,
   parameter_code_ IN  VARCHAR2) RETURN NUMBER
IS
   CURSOR measured IS
      SELECT DISTINCT trunc(reg_date)
      FROM   EQUIPMENT_OBJECT_MEAS_VALID
      WHERE  test_pnt_seq = test_pnt_seq_
      AND parameter_code = parameter_code_;
   temp_ NUMBER;

BEGIN


   temp_:=0;
   FOR rec_ IN measured LOOP
      temp_ := temp_ + 1;
   END LOOP;

   RETURN temp_;
END Get_No_Of_Measurements;
/*
FUNCTION Get_Forcast_Date(
   test_point_id_       IN VARCHAR2,
   parameter_code_      IN VARCHAR2,
   value_               IN NUMBER,
   test_pnt_seq_        IN NUMBER) RETURN DATE
IS
   TYPE  forcast_rec IS RECORD
   (
     test_point_id      VARCHAR2(100),
     parameter_code     VARCHAR2(100),
     date_diff          NUMBER,
     measure            NUMBER,
     rec_date           DATE
   );
   
   TYPE  forcast_rec_tab IS TABLE OF forcast_rec INDEX BY BINARY_INTEGER;

   forcast_record_    forcast_rec_tab;
   regdate_             DATE;
   measure_value_       NUMBER;
   temp_regdate_        DATE;
   temp_measure_value_  NUMBER;
   rec_count_           NUMBER;
   rec_no_              NUMBER := 1;
   val_rec_count_       NUMBER;
   cal_start_date_      DATE := TO_DATE('01.01.0001:00:00:00','DD.MM.YYYY:HH24:MI:SS');
   min_reg_date_        DATE;

   -- regression calculation vaiables 
   eqval_ex_             NUMBER := 0;
   eqval_ey_             NUMBER := 0;
   eqval_exy_            NUMBER := 0;
   eqval_ex2_            NUMBER := 0;
   eqval_slope_          NUMBER := 0;
   eqval_intersept_      NUMBER := 0;

   last_date_diff_       NUMBER := 0;
   last_measured_date_   DATE;
   gen_date_             DATE;
   no_of_recs_           NUMBER := 0;
   slope_               NUMBER;
   intercept_           NUMBER;
   date_diff_           NUMBER;
   min_measurment_     NUMBER;
   --Check value to avoid divide by zero
   first_meas_value_      NUMBER;
   last_meas_value_       NUMBER;
   
   CURSOR get_first_rec (start_date_ DATE)  IS
      SELECT t.reg_date , t.measured_value FROM EQUIPMENT_OBJECT_MEAS_VALID t 
      WHERE 
      t.test_pnt_seq = test_pnt_seq_
      AND t.parameter_code = parameter_code_
      AND trunc((((86400*(t.reg_date - start_date_))/60)/60)/24)>=0
      ORDER BY t.values_seq ASC;
      
   CURSOR get_start_date IS 
      SELECT a.cal_start_date FROM EQUIPMENT_OBJECT_PARAM_TAB a
      WHERE a.test_pnt_seq = test_pnt_seq_ 
      AND a.parameter_code = parameter_code_;
   
    CURSOR get_min_reg_date IS 
      SELECT a.reg_date FROM EQUIPMENT_OBJECT_MEAS_VALID a
      WHERE a.test_pnt_seq = test_pnt_seq_
      AND a.parameter_code = parameter_code_
      AND a.reg_date >= cal_start_date_
      ORDER BY measured_value ASC;
    
    CURSOR get_min_meas IS 
      SELECT min(a.measured_value) FROM EQUIPMENT_OBJECT_MEAS_VALID a
      WHERE a.test_pnt_seq = test_pnt_seq_ 
      AND a.parameter_code = parameter_code_
      AND a.reg_date >= cal_start_date_;
   
BEGIN
   
   OPEN get_start_date;
   FETCH get_start_date INTO cal_start_date_;
   IF (cal_start_date_ IS NULL)THEN 
       cal_start_date_ := TO_DATE('01.01.0001:00:00:00','DD.MM.YYYY:HH24:MI:SS');
   END IF;
   CLOSE get_start_date;
   
   rec_count_ := 0;
   
   OPEN get_first_rec(cal_start_date_);
   LOOP
      FETCH get_first_rec INTO regdate_ , measure_value_;
      EXIT WHEN get_first_rec %NOTFOUND;
      IF (get_first_rec %NOTFOUND) THEN
         rec_count_ := 0;
      ELSE
         IF (rec_count_ = 0)THEN 
            forcast_record_(1).date_diff :=0; 
            forcast_record_(1).measure := measure_value_;
            forcast_record_(1).rec_date := regdate_;
            temp_regdate_ := regdate_;
            temp_measure_value_ := measure_value_;
            --Check value to avoid divide by zero
            first_meas_value_ := measure_value_;
         ELSE  
            rec_no_ := rec_no_+1;
            forcast_record_(rec_no_).date_diff := regdate_ - temp_regdate_;
            forcast_record_(rec_no_).measure := measure_value_;
            forcast_record_(rec_no_).rec_date := regdate_;

            temp_measure_value_ := measure_value_;
    
         END IF;
      END IF;
 
      rec_count_ := rec_count_+ 1;      

      --Check value to avoid divide by zero
      last_meas_value_ := measure_value_;
   END LOOP;
 
   CLOSE get_first_rec;
   
   --If less than 2 value or the date is the same, gen_date is set to null to avoid divide by zero
   IF (rec_no_ < 2 OR (last_meas_value_ - first_meas_value_ = 0)) THEN
      gen_date_ := NULL;
   ELSE 
      
      IF ( rec_no_ > 1 AND rec_no_<5)THEN 
         no_of_recs_ := rec_no_;
         val_rec_count_ :=0;
         
         LOOP 
            val_rec_count_ := val_rec_count_+1;
            -- y = date diff and x = Measure value
             eqval_ex_ := forcast_record_(val_rec_count_).measure + eqval_ex_;            
             eqval_ey_ := forcast_record_(val_rec_count_).date_diff + eqval_ey_;           
             eqval_exy_ := (forcast_record_(val_rec_count_).date_diff* forcast_record_(val_rec_count_).measure) +  eqval_exy_;             
             eqval_ex2_ := (forcast_record_(val_rec_count_).measure*forcast_record_(val_rec_count_).measure) + eqval_ex2_;
            EXIT WHEN val_rec_count_ = rec_no_;
         END LOOP;
      END IF;
      
      IF (rec_no_ >= 5) THEN 
         val_rec_count_ := rec_no_- 5;
         no_of_recs_ := 5;
         LOOP 
            val_rec_count_ := val_rec_count_+1;
             
              -- y = date diff and x = Measure value
                 eqval_ex_ := forcast_record_(val_rec_count_).measure + eqval_ex_;            
                 eqval_ey_ := forcast_record_(val_rec_count_).date_diff + eqval_ey_;           
                 eqval_exy_ := (forcast_record_(val_rec_count_).date_diff* forcast_record_(val_rec_count_).measure) +  eqval_exy_;             
                 eqval_ex2_ := (forcast_record_(val_rec_count_).measure*forcast_record_(val_rec_count_).measure) + eqval_ex2_;
                      
             EXIT WHEN val_rec_count_ = rec_no_;
         END LOOP;
       END IF;
      
       eqval_slope_   := ((no_of_recs_*eqval_exy_) - (eqval_ex_*eqval_ey_))/((no_of_recs_*eqval_ex2_)-(eqval_ex_*eqval_ex_));
       eqval_intersept_ := (eqval_ey_ - (eqval_slope_*eqval_ex_))/no_of_recs_;
       slope_ := eqval_slope_;              
       intercept_ :=  eqval_intersept_ ;
       
       last_date_diff_      := forcast_record_(rec_no_).date_diff;
       last_measured_date_  := forcast_record_(rec_no_).rec_date;
       
        OPEN get_min_meas;
        FETCH get_min_meas INTO min_measurment_;
        CLOSE get_min_meas;

       date_diff_   :=  intercept_ + (slope_* value_) ;

        OPEN get_min_reg_date;
        FETCH get_min_reg_date INTO min_reg_date_;
        CLOSE get_min_reg_date;
          gen_date_ := min_reg_date_ + date_diff_ ;

   END IF;
   RETURN gen_date_;
END Get_Forcast_Date;
*/
FUNCTION Get_Forcast_Date (
   test_point_id_       IN VARCHAR2, -- Unused
   parameter_code_      IN VARCHAR2,
   value_               IN NUMBER,
   test_pnt_seq_        IN NUMBER) RETURN DATE
IS
BEGIN
   RETURN Get_Forcast_Date(test_pnt_seq_, parameter_code_, value_);
END Get_Forcast_Date;

   
FUNCTION Get_Forcast_Date(
   test_pnt_seq_        IN NUMBER,
   parameter_code_      IN VARCHAR2,
   value_               IN NUMBER ) RETURN DATE
IS
   TYPE  forcast_rec IS RECORD
   ( date_diff          NUMBER,
     measure            NUMBER,
     rec_date           DATE );
   
   TYPE  forcast_rec_tab IS TABLE OF forcast_rec INDEX BY BINARY_INTEGER;

   forcast_record_       forcast_rec_tab;
   
   cal_start_date_       DATE;
   temp_regdate_         DATE;
   min_reg_date_         DATE;

   -- regression calculation vaiables 
   eqval_ex_             NUMBER := 0;
   eqval_ey_             NUMBER := 0;
   eqval_exy_            NUMBER := 0;
   eqval_ex2_            NUMBER := 0;

   no_of_recs_           NUMBER;
   slope_                NUMBER;
   intercept_            NUMBER;
   date_diff_            NUMBER;
   --Check value to avoid divide by zero
   first_meas_value_     NUMBER;
   last_meas_value_      NUMBER;
   
   max_no_of_records_    NUMBER := 5;
   
   
   CURSOR get_first_rec (start_date_ DATE)  IS
      SELECT t.reg_date, t.measured_value
        FROM EQUIPMENT_OBJECT_MEAS_TAB t 
       WHERE t.test_pnt_seq   = test_pnt_seq_
         AND t.parameter_code = parameter_code_
         AND t.reg_date       >= start_date_
         AND t.measurement_type IN ('RecordedReading', 'MeterChangeBefore')
      ORDER BY t.reg_date DESC;
            
BEGIN
   
   cal_start_date_ := Equipment_Object_Param_Api.Get_Cal_Start_Date(test_pnt_seq_, parameter_code_);
   IF (cal_start_date_ IS NULL)THEN 
       cal_start_date_ := TO_DATE('01.01.0001:00:00:00','DD.MM.YYYY:HH24:MI:SS');
   END IF;
  
   no_of_recs_    := 0;
   
   -- fetching last 5 records from end
   FOR rec_ IN get_first_rec(cal_start_date_) LOOP
      no_of_recs_                            := no_of_recs_ + 1;
      forcast_record_(no_of_recs_).measure   := rec_.measured_value;
      forcast_record_(no_of_recs_).rec_date  := rec_.reg_date;
   
      IF no_of_recs_ >= max_no_of_records_ THEN
         EXIT;
      END IF;
   END LOOP;
      
   --If less than 2 values 
   IF (no_of_recs_ < 2 ) THEN
      RETURN NULL;
   END IF;
   
   -- calculating date_diff for the records, and geting first and last value   
   FOR i IN REVERSE 1 .. no_of_recs_ LOOP
      IF i = no_of_recs_ THEN
         forcast_record_(i).date_diff := 0;
         first_meas_value_            := forcast_record_(i).measure;
         temp_regdate_                := forcast_record_(i).rec_date;
      ELSE
         forcast_record_(i).date_diff := forcast_record_(i).rec_date - temp_regdate_;
      END IF;
      last_meas_value_                := forcast_record_(i).measure;
   END LOOP;
   
   --If value is the same, gen_date is set to null to avoid divide by zero
   IF (last_meas_value_ - first_meas_value_ = 0) THEN
      RETURN NULL;
   END IF;
   
   FOR i IN REVERSE 1 .. no_of_recs_ LOOP
      eqval_ex_  := forcast_record_(i).measure + eqval_ex_;            
      eqval_ey_  := forcast_record_(i).date_diff + eqval_ey_;           
      eqval_exy_ := (forcast_record_(i).date_diff * forcast_record_(i).measure) +  eqval_exy_;             
      eqval_ex2_ := (forcast_record_(i).measure * forcast_record_(i).measure) + eqval_ex2_;
   END LOOP;
   
   -- begin - exception - end to catch divide by zero if that occurs
   BEGIN
      slope_               := ((no_of_recs_ * eqval_exy_) - (eqval_ex_ * eqval_ey_)) / ((no_of_recs_ * eqval_ex2_) - (eqval_ex_ * eqval_ex_));
      intercept_           := (eqval_ey_ - (slope_ * eqval_ex_)) / no_of_recs_;

      date_diff_           := intercept_ + (slope_ * value_) ;
      min_reg_date_        := forcast_record_(no_of_recs_).rec_date;
      
      RETURN ( min_reg_date_ + date_diff_ );
      
   EXCEPTION
      WHEN OTHERS THEN
         RETURN NULL;
   END;  
   
END Get_Forcast_Date;

PROCEDURE New (
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   test_point_id_    IN VARCHAR2,
   parameter_code_   IN VARCHAR2,
   test_sequence_id_ IN VARCHAR2,
   measured_value_   IN NUMBER,
   reg_date_         IN DATE,
   remark_           IN VARCHAR2,
   test_pnt_seq_     IN NUMBER,
   resource_seq_     IN NUMBER,
   measurement_note_ IN VARCHAR2 DEFAULT NULL,
   meter_id_         IN VARCHAR2 DEFAULT NULL,
   start_reading_    IN NUMBER DEFAULT NULL,
   end_reading_      IN NUMBER DEFAULT NULL,
   new_review_val_   IN NUMBER DEFAULT NULL)
IS   
BEGIN
   New (
      contract_,
      Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_),
      test_point_id_,
      parameter_code_,
      test_sequence_id_,
      measured_value_,
      reg_date_,
      remark_,
      test_pnt_seq_,
      resource_seq_,
      measurement_note_,
      meter_id_,
      start_reading_,
      end_reading_,
      new_review_val_ );
   
END New;

PROCEDURE New( contract_         IN VARCHAR2,
               equipment_object_seq_ IN NUMBER,
               test_point_id_        IN VARCHAR2,
               parameter_code_       IN VARCHAR2,
               test_sequence_id_     IN VARCHAR2,
               measured_value_       IN NUMBER,
               reg_date_             IN DATE,
               remark_               IN VARCHAR2,
               test_pnt_seq_         IN NUMBER,
               resource_seq_         IN NUMBER,
               measurement_note_     IN VARCHAR2 DEFAULT NULL,
               meter_id_             IN VARCHAR2 DEFAULT NULL,
               start_reading_        IN NUMBER DEFAULT NULL,
               end_reading_          IN NUMBER DEFAULT NULL,
               new_review_val_       IN NUMBER DEFAULT NULL )
IS   
   newrec_                 EQUIPMENT_OBJECT_MEAS_TAB%ROWTYPE;
   dummy_                  EQUIPMENT_OBJECT_MEAS_TAB.test_point_id%TYPE;
   dummy_contract_         VARCHAR2(5);
   dummy_date_             DATE;
   remark_temp_            VARCHAR2(200);
   measured_value_temp_    NUMBER;
   user_                   VARCHAR2(30);
   dummy_test_sequence_id_ VARCHAR2(24);
   created_by_             VARCHAR2(100);
   start_text_             VARCHAR2(100);
   end_text_               VARCHAR2(100);
   default_text_           VARCHAR2(100);
   dummy_meter_id_         EQUIPMENT_OBJECT_MEAS_TAB.meter_id%TYPE;
BEGIN
   dummy_ := test_point_id_;
   IF (dummy_ IS NULL) THEN
      dummy_ := '*';
   END IF;
   created_by_:=Language_SYS.Translate_Constant(lu_name_, 'CREBY: Created by');
   start_text_ :=Language_SYS.Translate_Constant(lu_name_, 'STARTREADINGCONSTANT: Start Reading from Metered Invoicing');
   end_text_ :=Language_SYS.Translate_Constant(lu_name_, 'ENDREADINGCONSTANT: End Reading from Metered Invoicing');
   default_text_ :=Language_SYS.Translate_Constant(lu_name_, 'DEFAULTREADINGCONSTANT: Adjustment from Metered Invoicing'); 
  
   IF Fnd_Session_API.Is_Odp_Session THEN
      IF(start_reading_ IS NOT NULL) THEN
         measured_value_temp_   := start_reading_;
         user_                  := Fnd_Session_API.Get_Fnd_User;
         remark_temp_           := created_by_||' '||user_||', '||start_text_;
         newrec_.recorded_value := measured_value_temp_;
         newrec_.remark         := remark_temp_;
      ELSIF(end_reading_ IS NOT NULL) THEN
         measured_value_temp_ := end_reading_;
         user_                  := Fnd_Session_API.Get_Fnd_User;
         remark_temp_           := created_by_||' '||user_||', '||end_text_;
         newrec_.recorded_value := measured_value_temp_;
         newrec_.remark         := remark_temp_;
      ELSIF(new_review_val_ IS NOT NULL) THEN
         measured_value_temp_   := new_review_val_;
         user_                  := Fnd_Session_API.Get_Fnd_User;
         remark_temp_           := created_by_||' '||user_||', '||default_text_;
         newrec_.recorded_value := measured_value_temp_;
         newrec_.remark         := remark_temp_;
      ELSE
         IF (remark_ IS NULL) THEN
            remark_temp_   := Language_SYS.Translate_Constant(lu_name_, 'CREBY: Created by');
            user_          := Fnd_Session_API.Get_Fnd_User;
            newrec_.remark := remark_temp_||' '||user_;
         ELSE
            newrec_.remark := remark_;
         END IF;
         newrec_.recorded_value := measured_value_;
      END IF;
   ELSE 
      IF (remark_ IS NULL) THEN
         remark_temp_   := Language_SYS.Translate_Constant(lu_name_, 'CREBY: Created by');
         user_          := Fnd_Session_API.Get_Fnd_User;
         newrec_.remark := remark_temp_||' '||user_;
      ELSE
         newrec_.remark := remark_;
      END IF;
      newrec_.recorded_value := measured_value_;
      
   END IF;  
   IF (contract_ IS NULL AND resource_seq_ IS NULL) THEN
      dummy_contract_ := User_Default_API.Get_Contract;
   ELSE
      dummy_contract_ := contract_;
   END IF;
 
   IF (reg_date_ IS NULL) THEN
      IF (dummy_contract_ IS NULL) THEN
         dummy_date_ := sysdate;         
      ELSE    
         dummy_date_ := Maintenance_Site_Utility_API.Get_Site_Date(dummy_contract_);
      END IF;      
   ELSE
      dummy_date_ := reg_date_;
   END IF;   
     
   IF (test_sequence_id_ IS NULL) THEN
      dummy_test_sequence_id_ := Def_Key_Value_API.Get_Db_Value(0);
   ELSE
      dummy_test_sequence_id_ := test_sequence_id_;
   END IF;
   --
   newrec_.test_pnt_seq     := test_pnt_seq_;
   newrec_.parameter_code   := parameter_code_;
   newrec_.test_sequence_id := dummy_test_sequence_id_;
   newrec_.measurement_note := measurement_note_;
   newrec_.reg_date         := dummy_date_;  
   newrec_.contract         := dummy_contract_;
   newrec_.mch_code         := Equipment_Object_API.Get_Mch_Code(equipment_object_seq_);
   newrec_.equipment_object_seq := equipment_object_seq_;
   
   dummy_meter_id_ := meter_id_;
   IF ((dummy_meter_id_ IS NULL)) THEN
      dummy_meter_id_ := Get_Prev_Meter_Id_By_Date(dummy_date_, test_pnt_seq_, parameter_code_);
   END IF;
   newrec_.meter_id := dummy_meter_id_;
   
   New___(newrec_);
END New;

FUNCTION Rec_Value_For_Max_Measured (
   test_pnt_seq_   IN NUMBER, 
   parameter_code_ IN  VARCHAR2) RETURN NUMBER
IS
   CURSOR Measured IS
      SELECT measured_value, recorded_value
        FROM EQUIPMENT_OBJECT_MEAS_VALID
       WHERE test_pnt_seq = test_pnt_seq_      
         AND parameter_code = parameter_code_;

   max_           NUMBER;
   rec_value_     NUMBER := NULL;
BEGIN
   max_       := 0;
   FOR rec_ IN Measured LOOP
      IF (rec_.measured_value > max_) THEN
         max_       := rec_.measured_value;
         rec_value_ := rec_.recorded_value;
      END IF;
   END LOOP;
   RETURN rec_value_;
END Rec_Value_For_Max_Measured;


FUNCTION Get_Seq_For_Latest_Measured (
   test_pnt_seq_ IN NUMBER,
   parameter_code_ IN  VARCHAR2) RETURN NUMBER
IS
   CURSOR latest_seq IS
      SELECT max(values_seq)
      FROM   EQUIPMENT_OBJECT_MEAS_TAB
      WHERE  test_pnt_seq = test_pnt_seq_
      AND parameter_code = parameter_code_;

   latest_seq_ equipment_object_meas_tab.values_seq%TYPE;

BEGIN
   OPEN latest_seq;
     FETCH latest_seq INTO latest_seq_;
   CLOSE latest_seq;
   RETURN latest_seq_;
END Get_Seq_For_Latest_Measured;

FUNCTION Get_Seq_For_Latest_Valid (
   test_pnt_seq_ IN NUMBER,
   parameter_code_ IN  VARCHAR2) RETURN NUMBER
IS
   CURSOR latest_seq IS
      SELECT max(values_seq)
        FROM EQUIPMENT_OBJECT_MEAS_TAB
       WHERE test_pnt_seq = test_pnt_seq_
         AND parameter_code = parameter_code_
         AND measurement_type IN ('RecordedReading', 'MeterChangeBefore');

   latest_seq_ equipment_object_meas_tab.values_seq%TYPE;

BEGIN
   OPEN latest_seq;
   FETCH latest_seq INTO latest_seq_;
   CLOSE latest_seq;
   RETURN latest_seq_;
END Get_Seq_For_Latest_Valid;

FUNCTION Get_Prev_Rec_Val_By_Date (
   date_             IN DATE,
   test_pnt_seq_     IN NUMBER,
   parameter_code_   IN VARCHAR2) RETURN NUMBER
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.RECORDED_VALUE%TYPE;
   CURSOR get_attr IS
      SELECT RECORDED_VALUE
      FROM (SELECT RECORDED_VALUE        
            FROM   EQUIPMENT_OBJECT_MEAS_TAB
            WHERE test_pnt_seq = test_pnt_seq_
            AND parameter_code = parameter_code_            
            AND (contract = User_Allowed_Site_API.Authorized(contract) OR contract is null)
            AND measurement_type IN ('RecordedReading', 'MeterChangeBefore','MeterChangeAfter')
            AND reg_date <= date_
            ORDER BY reg_date DESC)
      WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Prev_Rec_Val_By_Date;

FUNCTION Get_Prev_Total_Val_By_Date (
   date_             IN DATE,
   test_pnt_seq_     IN NUMBER,
   parameter_code_   IN VARCHAR2) RETURN NUMBER
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.MEASURED_VALUE%TYPE;
   CURSOR get_attr IS
      SELECT MEASURED_VALUE
      FROM (SELECT MEASURED_VALUE
            FROM   EQUIPMENT_OBJECT_MEAS_VALID
            WHERE test_pnt_seq = test_pnt_seq_
            AND parameter_code = parameter_code_            
            --AND measurement_type = 'RecordedReading'
            AND reg_date <= date_
            ORDER BY reg_date DESC)
      WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Prev_Total_Val_By_Date;

FUNCTION Get_Prev_Rec_Date_By_Date (
   date_             IN DATE,
   test_pnt_seq_ IN NUMBER,
   parameter_code_   IN VARCHAR2) RETURN DATE
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.REG_DATE%TYPE;
   CURSOR get_attr IS
      SELECT REG_DATE
      FROM (SELECT REG_DATE
            FROM   EQUIPMENT_OBJECT_MEAS_VALID
            WHERE test_pnt_seq = test_pnt_seq_             
            AND parameter_code = parameter_code_            
            --AND measurement_type = 'RecordedReading'
            AND reg_date <= date_
            ORDER BY reg_date DESC)
      WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Prev_Rec_Date_By_Date;

FUNCTION Get_Prev_Meter_Id_By_Date (
   date_             IN DATE,
   test_pnt_seq_     IN NUMBER,
   parameter_code_   IN VARCHAR2) RETURN VARCHAR2
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.meter_id%TYPE;
   CURSOR get_attr IS
      SELECT meter_id
      FROM (SELECT meter_id
            FROM   EQUIPMENT_OBJECT_MEAS_TAB
            WHERE test_pnt_seq = test_pnt_seq_
            AND parameter_code = parameter_code_            
            AND measurement_type NOT IN ('IncorrectReading', 'PreliminaryReading')
            AND reg_date < date_
            ORDER BY reg_date DESC)
      WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Prev_Meter_Id_By_Date;

FUNCTION Get_Latest_Recorded_Value (
   test_pnt_seq_ IN NUMBER,
   parameter_code_   IN VARCHAR2) RETURN NUMBER
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.recorded_value%TYPE;
   CURSOR get_attr IS
      SELECT recorded_value
         FROM (SELECT recorded_value, reg_date, measurement_type, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE test_pnt_seq = test_pnt_seq_                  
                  AND parameter_code = parameter_code_                  
                  AND measurement_type NOT IN ('IncorrectReading', 'PreliminaryReading','MeterSetup')
                  ORDER BY reg_date DESC, MEASURED_VALUE DESC)
         WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Latest_Recorded_Value;

FUNCTION Get_Latest_Registered_Date (
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   test_point_id_    IN VARCHAR2,
   parameter_code_   IN VARCHAR2) RETURN EQUIPMENT_OBJECT_MEAS_TAB.reg_date%TYPE
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.reg_date%TYPE;
   CURSOR get_attr IS
      SELECT reg_date
         FROM (SELECT recorded_value, reg_date, measurement_type, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE mch_code= mch_code_
                  AND contract = contract_
                  AND parameter_code = parameter_code_
                  AND test_point_id = test_point_id_
                  AND measurement_type NOT IN ('IncorrectReading', 'PreliminaryReading','MeterSetup')
                  ORDER BY reg_date DESC, MEASURED_VALUE DESC)
         WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Latest_Registered_Date;

FUNCTION Get_Meter_Id_For_Latest_Value (
   test_pnt_seq_ IN NUMBER,
   parameter_code_   IN VARCHAR2) RETURN EQUIPMENT_OBJECT_MEAS_TAB.meter_id%TYPE
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.meter_id%TYPE;
   CURSOR get_attr IS
      SELECT meter_id
         FROM (Select meter_id, reg_date, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE test_pnt_seq = test_pnt_seq_                  
                  AND parameter_code = parameter_code_                  
                  ORDER BY reg_date DESC, MEASURED_VALUE DESC)
         WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Meter_Id_For_Latest_Value;

FUNCTION Get_Latest_Rec_Value_All_Types (
   test_pnt_seq_ IN NUMBER,
   parameter_code_   IN VARCHAR2) RETURN NUMBER
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.recorded_value%TYPE;
   CURSOR get_attr IS
      SELECT recorded_value
         FROM (Select recorded_value, reg_date, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE test_pnt_seq = test_pnt_seq_                  
                  AND parameter_code = parameter_code_                  
                  ORDER BY reg_date DESC, MEASURED_VALUE DESC)
         WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Latest_Rec_Value_All_Types;

FUNCTION Get_Latest_Reg_Date_All_Types (
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   test_point_id_    IN VARCHAR2,
   parameter_code_   IN VARCHAR2) RETURN EQUIPMENT_OBJECT_MEAS_TAB.reg_date%TYPE
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.reg_date%TYPE;
   CURSOR get_attr IS
      SELECT reg_date
         FROM (Select recorded_value, reg_date, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE mch_code= mch_code_
                  AND contract = contract_
                  AND parameter_code = parameter_code_
                  AND test_point_id = test_point_id_
                  ORDER BY reg_date DESC, MEASURED_VALUE DESC)
         WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Latest_Reg_Date_All_Types;

FUNCTION Get_Latest_Meas_Type (
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   test_point_id_    IN VARCHAR2,
   parameter_code_   IN VARCHAR2) RETURN EQUIPMENT_OBJECT_MEAS_TAB.measurement_type%TYPE
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.measurement_type%TYPE;
   CURSOR get_attr IS
      SELECT measurement_type
         FROM (SELECT recorded_value, reg_date, measurement_type, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE mch_code= mch_code_ 
                  AND contract = contract_
                  AND parameter_code = parameter_code_
                  AND test_point_id = test_point_id_
                  AND measurement_type NOT IN ('IncorrectReading','MeterSetup')
                  ORDER BY reg_date DESC, values_seq DESC)
         WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Latest_Meas_Type;

@UncheckedAccess
FUNCTION Get_Latest_Measured_Value (
   test_pnt_seq_ IN NUMBER,
   parameter_code_   IN VARCHAR2) RETURN NUMBER
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.measured_value%TYPE;
   CURSOR get_attr IS
      SELECT measured_value
         FROM (SELECT recorded_value, reg_date, measurement_type, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE test_pnt_seq = test_pnt_seq_                  
                  AND parameter_code = parameter_code_                  
                  AND measurement_type NOT IN ('IncorrectReading', 'PreliminaryReading','MeterSetup')
                  ORDER BY reg_date DESC, MEASURED_VALUE DESC)
         WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Latest_Measured_Value;  

FUNCTION Get_Last_Comple_Value (
   test_pnt_seq_ IN NUMBER,
   parameter_code_   IN VARCHAR2,
   completion_date_       IN DATE) RETURN NUMBER
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.measured_value%TYPE;
   CURSOR get_attr IS
      SELECT measured_value
         FROM (SELECT recorded_value, reg_date, measurement_type, MEASURED_VALUE 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE test_pnt_seq = test_pnt_seq_                  
                  AND parameter_code = parameter_code_                  
                  AND measurement_type NOT IN ('IncorrectReading', 'PreliminaryReading','MeterSetup')
                  AND reg_date <= completion_date_
                  ORDER BY reg_date DESC, MEASURED_VALUE DESC)
         WHERE ROWNUM = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Last_Comple_Value;

FUNCTION Get_Average_Date (
   start_date_           IN DATE,
   end_date_             IN DATE) RETURN EQUIPMENT_OBJECT_MEAS_TAB.reg_date%TYPE
IS
   temp_ EQUIPMENT_OBJECT_MEAS_TAB.reg_date%TYPE;
BEGIN
   SELECT (start_date_ + (end_date_ - start_date_) / 2)
   INTO temp_
   FROM dual;
   RETURN temp_;
END Get_Average_Date;

-- Used from METINV
PROCEDURE Calc_Accumulated_Value (   
                                     measured_value_   OUT    NUMBER,
                                     measurement_type_ IN OUT VARCHAR2,
                                     contract_         IN     VARCHAR2, 
                                     mch_code_         IN     VARCHAR2, 
                                     parameter_code_   IN     VARCHAR2,
                                     test_point_id_    IN     VARCHAR2,   
                                     recorded_value_   IN     NUMBER,
                                     reg_date_         IN     DATE,
                                     test_pnt_seq_     IN     NUMBER)
IS
BEGIN
   Calc_Accumulated_Value___ ( measured_value_, measurement_type_, recorded_value_, reg_date_, test_pnt_seq_, parameter_code_ );
END Calc_Accumulated_Value;

-- Used from METINV
PROCEDURE Calc_Accumulated_Value (   
                                     measured_value_   OUT    NUMBER,
                                     measurement_type_ IN OUT VARCHAR2,
                                     parameter_code_   IN     VARCHAR2,
                                     recorded_value_   IN     NUMBER,
                                     reg_date_         IN     DATE,
                                     test_pnt_seq_     IN     NUMBER)
IS
BEGIN
   Calc_Accumulated_Value___ ( measured_value_, measurement_type_, recorded_value_, reg_date_, test_pnt_seq_, parameter_code_ );
END Calc_Accumulated_Value;

   
FUNCTION Suggest_Total_Value_After_Flip (    
   parameter_code_ IN  VARCHAR2,   
   test_pnt_seq_ IN NUMBER,
   recorded_value_ IN NUMBER,
   reg_date_ IN DATE   ) RETURN NUMBER
IS   
   total_value_         NUMBER;
   suggested_value_     NUMBER;
   prev_recorded_value_ NUMBER;
   meter_flip_value_    NUMBER;
BEGIN
   prev_recorded_value_ := Get_Prev_Rec_Val_By_Date(reg_date_, test_pnt_seq_, parameter_code_);                     
   meter_flip_value_    := EQUIPMENT_OBJECT_PARAM_API.Get_Meter_Flip_Value(test_pnt_seq_, parameter_code_);
   total_value_         := Get_Prev_Total_Val_By_Date(reg_date_, test_pnt_seq_, parameter_code_);    
   suggested_value_      := ((meter_flip_value_ - prev_recorded_value_) + recorded_value_) + total_value_;      
   RETURN suggested_value_;   
END Suggest_Total_Value_After_Flip;    

FUNCTION Prev_Preliminary_Records_Exist (
   test_pnt_seq_ IN NUMBER,
   parameter_code_   IN VARCHAR2,
   invalid_reg_date_ IN DATE) RETURN NUMBER
IS
   
   CURSOR is_prev_record_preliminary IS
      SELECT 1 
         FROM (SELECT recorded_value, reg_date, measurement_type, RANK() OVER (PARTITION BY mch_code, contract, parameter_code, test_point_id  ORDER BY reg_date DESC) AS rnk 
               FROM EQUIPMENT_OBJECT_MEAS_TAB
                  WHERE test_pnt_seq = test_pnt_seq_
                  AND parameter_code = parameter_code_                  
                  AND reg_date < invalid_reg_date_
                  AND measurement_type != 'IncorrectReading')
               WHERE rnk = 1
               AND measurement_type = 'PreliminaryReading';

   dummy_       NUMBER;

BEGIN
   
   OPEN is_prev_record_preliminary;
   FETCH is_prev_record_preliminary INTO dummy_;
   IF (is_prev_record_preliminary%FOUND) THEN
      CLOSE is_prev_record_preliminary;
      RETURN 1;  
   END IF;
   CLOSE is_prev_record_preliminary;
   RETURN 0; 
   
   
END Prev_Preliminary_Records_Exist;

FUNCTION Next_Recorded_Read_Exist (
   test_pnt_seq_ IN NUMBER,
   parameter_code_   IN VARCHAR2,
   reg_date_ IN DATE) RETURN NUMBER
IS   
   CURSOR is_next_recorded_read IS
      SELECT 1
            FROM   EQUIPMENT_OBJECT_MEAS_VALID
            WHERE test_pnt_seq = test_pnt_seq_
            AND parameter_code = parameter_code_            
            --AND measurement_type = 'RecordedReading'
            AND reg_date >= reg_date_
            ORDER BY reg_date ASC;
   dummy_       NUMBER;
BEGIN   
   OPEN is_next_recorded_read;
   FETCH is_next_recorded_read INTO dummy_;
   IF (is_next_recorded_read%FOUND) THEN
      CLOSE is_next_recorded_read;
      RETURN 1;  
   END IF;
   CLOSE is_next_recorded_read;
   RETURN 0; 
END Next_Recorded_Read_Exist;

FUNCTION Next_Flip_Change_Exist (
   test_pnt_seq_ IN NUMBER,
   parameter_code_   IN VARCHAR2,
   reg_date_ IN DATE) RETURN NUMBER
IS   
   CURSOR get_rec IS
      SELECT 1
            FROM   EQUIPMENT_OBJECT_MEAS_TAB
            WHERE test_pnt_seq =test_pnt_seq_
            AND parameter_code = parameter_code_            
            AND measurement_type IN ('MeterRollOver', 'MeterChangeBefore', 'MeterChangeAfter')
            AND reg_date >= reg_date_
            ORDER BY reg_date ASC;
   dummy_       NUMBER;
BEGIN   
   OPEN get_rec;
   FETCH get_rec INTO dummy_;
   IF (get_rec%FOUND) THEN
      CLOSE get_rec;
      RETURN 1;  
   END IF;
   CLOSE get_rec;
   RETURN 0; 
END Next_Flip_Change_Exist;

PROCEDURE Handle_Incorrect_Readings (
   seq_values_ IN NUMBER,
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2,
   test_point_id_ IN VARCHAR2,
   test_sequence_id_ IN VARCHAR2,
   parameter_code_ IN VARCHAR2,
   recorded_value_ IN NUMBER,
   measurement_note_ IN VARCHAR2,
   invalid_reg_date_ IN DATE,
   valid_reg_date_ IN DATE,
   unknown_correct_read_ NUMBER,
   test_pnt_seq_  IN NUMBER) 
IS  
   CURSOR get_preliminary_records IS
      SELECT values_seq, contract, mch_code, test_point_id, parameter_code, recorded_value, reg_date, measurement_type
      FROM EQUIPMENT_OBJECT_MEAS_TAB t
      WHERE test_pnt_seq = test_pnt_seq_
      AND parameter_code = parameter_code_                   
      AND reg_date > invalid_reg_date_
      ORDER by reg_date ASC; 
   
   measurement_type_ VARCHAR2(120);
   total_value_      NUMBER;
   user_             VARCHAR2(30);
   newrec_           EQUIPMENT_OBJECT_MEAS_TAB%ROWTYPE;
   meter_id_         EQUIPMENT_OBJECT_MEAS_TAB.meter_id%TYPE;
   remark_temp_      VARCHAR2(80);   
   incorrect_date_   DATE;
   meas_note_        VARCHAR2(2000);
   loop_count_       NUMBER := 0;
BEGIN
   newrec_ := Get_Object_By_Keys___(seq_values_);
   
   newrec_.measurement_type := Measurement_Type_API.DB_INCORRECT_READING;
   newrec_.measurement_note := measurement_note_;
   
   Modify___(newrec_);
   
   --If correct reading known
   IF (unknown_correct_read_ = 0) THEN
      meter_id_ := Get_Meter_Id(seq_values_);
      remark_temp_ := Language_SYS.Translate_Constant(lu_name_, 'CREBY: Created by');
      user_ := Fnd_Session_API.Get_Fnd_User;
            
      incorrect_date_ := Get_Reg_Date(seq_values_);
       meas_note_ :=Language_SYS.Translate_Constant(lu_name_,'MEASNOTE: Corrected reading for an Incorrect Reading dated ') || TO_CHAR(incorrect_date_, 'mm/dd/yyyy HH:MI:SS AM');
     
      newrec_ := NULL;
      newrec_.parameter_code   := parameter_code_;
      newrec_.recorded_value   := recorded_value_;
      newrec_.test_sequence_id := test_sequence_id_;
      newrec_.reg_date         := valid_reg_date_;
      newrec_.measurement_note := meas_note_;
      newrec_.meter_id         := meter_id_;
      newrec_.remark           := remark_temp_||' '||user_;
      newrec_.test_pnt_seq     := test_pnt_seq_;

      New___(newrec_);
   END IF;

   FOR preli_rec_ IN get_preliminary_records LOOP
      IF (preli_rec_.measurement_type != Measurement_Type_API.DB_PRELIMINARY_READING) THEN 
         EXIT;
      END IF;
      trace_sys.message('arralk preli_rec_.values_seq ' || preli_rec_.values_seq);
      trace_sys.message('arralk preli_rec_.recorded_value ' || preli_rec_.recorded_value);
      trace_sys.message('arralk preli_rec_.reg_date ' || preli_rec_.reg_date);
      trace_sys.message('arralk preli_rec_.measurement_type ' || preli_rec_.measurement_type);
      --Clear measurement type for each loop.
      measurement_type_ := '';
      Calc_Accumulated_Value___ ( total_value_, measurement_type_, preli_rec_.recorded_value, preli_rec_.reg_date, test_pnt_seq_, preli_rec_.parameter_code );

      trace_sys.message('arralk total_value_ ' || total_value_);
      trace_sys.message('arralk measurement_type_ ' || measurement_type_);
      IF (measurement_type_ = Measurement_Type_API.DB_RECORDED_READING) THEN
         newrec_ :=  Get_Object_By_Keys___(preli_rec_.values_seq);
         newrec_.measurement_type := measurement_type_;
         newrec_.measured_value   := total_value_;
         Modify___(newrec_);
         loop_count_ := loop_count_ + 1;
      END IF;

   END LOOP; 
     
END Handle_Incorrect_Readings;


PROCEDURE Handle_Meter_Change (
   seq_values_          IN NUMBER,
   contract_            IN VARCHAR2,
   mch_code_            IN VARCHAR2,
   test_point_id_       IN VARCHAR2,
   test_sequence_id_    IN VARCHAR2,
   parameter_code_      IN VARCHAR2,
   start_reading_       IN NUMBER,
   meter_change_date_   IN DATE,
   selected_reg_date_   IN DATE,
   meter_id_            IN VARCHAR2,
   roll_over_val_       IN NUMBER,
   meas_note_           IN VARCHAR2,
   end_reading_         IN NUMBER,
   unknwon_start_read_  IN NUMBER,
   unknwon_change_date_ IN NUMBER,
   unknwon_end_read_    IN NUMBER,
   test_pnt_seq_        IN NUMBER,
   tooleq_seq_          IN NUMBER,
   setup_or_change_     IN VARCHAR2 DEFAULT NULL) 
IS
   CURSOR get_preliminary_records IS
      SELECT values_seq, contract, mch_code, test_point_id, parameter_code, recorded_value, reg_date, measurement_type
               FROM EQUIPMENT_OBJECT_MEAS_TAB t
                  WHERE test_pnt_seq = test_pnt_seq_
                  AND parameter_code = parameter_code_                   
                  AND reg_date > selected_reg_date_
                  ORDER by reg_date ASC;  
   
   measurement_type_ VARCHAR2(120);
   total_value_      NUMBER;
   user_             VARCHAR2(30);
   newrec_           EQUIPMENT_OBJECT_MEAS_TAB%ROWTYPE;
   remark_temp_      EQUIPMENT_OBJECT_MEAS_TAB.remark%TYPE;  
   loop_count_       NUMBER := 0;
   
   change_before_datetime_ DATE;
   prev_meter_id_          EQUIPMENT_OBJECT_MEAS_TAB.meter_id%TYPE; 
   dummy_test_sequence_id_ VARCHAR2(24);
BEGIN
   
   IF (test_sequence_id_ IS NULL) THEN
         dummy_test_sequence_id_ := Def_Key_Value_API.Get_Db_Value(0);
   ELSE
         dummy_test_sequence_id_ := test_sequence_id_;
   END IF;
   
   user_ := Fnd_Session_API.Get_Fnd_User;
   remark_temp_ := Language_SYS.Translate_Constant(lu_name_, 'CREBY: Created by');      
   remark_temp_ := remark_temp_||' '||user_;
   
   trace_sys.message('arralk setup_or_change_ ' || setup_or_change_); 
   IF( setup_or_change_ = 'MC' OR setup_or_change_ IS NULL) THEN
      SELECT meter_change_date_- interval '1' second 
         INTO change_before_datetime_
      FROM dual;     

      prev_meter_id_ := Get_Prev_Meter_Id_By_Date(selected_reg_date_, test_pnt_seq_, parameter_code_);

      measurement_type_ := '';
      Calc_Accumulated_Value___ ( total_value_, measurement_type_, end_reading_, change_before_datetime_, test_pnt_seq_, parameter_code_ );

      IF (measurement_type_ = Measurement_Type_API.DB_RECORDED_READING) THEN                        

         trace_sys.Message('arralk remark_temp_ ' || remark_temp_);

         IF (unknwon_start_read_ = 1) THEN
            trace_sys.Message('arralk remark_temp_ ' || remark_temp_);
            remark_temp_ := remark_temp_||'. '|| Language_SYS.Translate_Constant(lu_name_,'UNKNWSTARTREAD: Start Reading Unknown');
         END IF;
         IF (unknwon_change_date_ = 1) THEN
            remark_temp_ := remark_temp_||'. '|| Language_SYS.Translate_Constant(lu_name_,'UNKNWMCHGDATE: Meter Change Date Unknown');
         END IF;
         IF (unknwon_end_read_ = 1) THEN
            remark_temp_ := remark_temp_||'. '|| Language_SYS.Translate_Constant(lu_name_,'UNKNWENDREAD: End Reading Unknown');
         END IF;

         newrec_.test_pnt_seq     := test_pnt_seq_;
         newrec_.parameter_code   := parameter_code_;
         newrec_.recorded_value   := end_reading_;
         newrec_.test_sequence_id := dummy_test_sequence_id_;
         newrec_.reg_date         := change_before_datetime_;
         newrec_.meter_id         := prev_meter_id_;
         newrec_.remark           := remark_temp_;
         newrec_.measurement_type := Measurement_Type_API.DB_METER_CHANGE_BEFORE;

         New___(newrec_);

         EQUIPMENT_OBJECT_PARAM_API.Update_Flip_Value(test_pnt_seq_, parameter_code_, roll_over_val_);

         newrec_ := NULL;
         newrec_.test_pnt_seq     := test_pnt_seq_;
         newrec_.parameter_code   := parameter_code_;
         newrec_.recorded_value   := start_reading_;
         newrec_.test_sequence_id := dummy_test_sequence_id_;
         newrec_.reg_date         := meter_change_date_;
         newrec_.measurement_note := meas_note_;
         newrec_.meter_id         := meter_id_;
         newrec_.remark           := remark_temp_;
         newrec_.measurement_type := Measurement_Type_API.DB_METER_CHANGE_AFTER;    

         New___(newrec_);       

         IF (seq_values_ IS NOT NULL) THEN 
            measurement_type_ := '';
            total_value_      := 0;
            Calc_Accumulated_Value___ ( total_value_, measurement_type_, Get_Recorded_Value(seq_values_), selected_reg_date_, test_pnt_seq_, parameter_code_ );

            IF (measurement_type_ = Measurement_Type_API.DB_RECORDED_READING) THEN
               newrec_ := Get_Object_By_Keys___(seq_values_);
               newrec_.measurement_type := measurement_type_;
               newrec_.measured_value   := total_value_;
               newrec_.meter_id         := meter_id_;
               Modify___(newrec_);
               
               loop_count_ := loop_count_ + 1;
            END IF;

            FOR preli_rec_ IN get_preliminary_records LOOP
               --Clear measurement type for each loop.
               measurement_type_ := '';
               total_value_      := 0;
               Calc_Accumulated_Value___ ( total_value_, measurement_type_, preli_rec_.recorded_value, preli_rec_.reg_date, test_pnt_seq_, preli_rec_.parameter_code );
               IF (measurement_type_ = Measurement_Type_API.DB_RECORDED_READING) THEN
                  newrec_ := Get_Object_By_Keys___(preli_rec_.values_seq);
                  newrec_.measurement_type := measurement_type_;
                  newrec_.measured_value   := total_value_;
                  newrec_.meter_id         := meter_id_;
                  Modify___(newrec_);
                  
                  loop_count_ := loop_count_ + 1;
               END IF;
            END LOOP;   
         END IF;

      END IF;

   ELSIF (setup_or_change_ = 'MS') THEN
      trace_sys.message('arralk setup_or_change_ ' || setup_or_change_);   
            
      remark_temp_ := remark_temp_||'. '|| Language_SYS.Translate_Constant(lu_name_,'MTRSETUP: Meter Setup'); 

      newrec_.test_pnt_seq       := test_pnt_seq_;
      newrec_.parameter_code     := parameter_code_;
      newrec_.test_sequence_id   := dummy_test_sequence_id_;
      newrec_.reg_date           := meter_change_date_;
      newrec_.measurement_note   := meas_note_;
      newrec_.meter_id           := meter_id_;
      newrec_.remark             := remark_temp_;
      newrec_.measurement_type   := Measurement_Type_API.DB_METER_SETUP;
      newrec_.recorded_value     := start_reading_;
      
      New___(newrec_);
      
      IF (roll_over_val_ IS NOT NULL) THEN
            EQUIPMENT_OBJECT_PARAM_API.Update_Flip_Value(test_pnt_seq_, parameter_code_, roll_over_val_);
      END IF;      
   END IF;   

END Handle_Meter_Change;

PROCEDURE Mark_Flip_Incorrect (
   seq_values_       IN NUMBER) 
IS        
   newrec_     equipment_object_meas_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(seq_values_);
   newrec_.measurement_type := Measurement_Type_API.DB_INCORRECT_READING;
   newrec_.measured_value   := NULL; 
   Modify___(newrec_);        
END Mark_Flip_Incorrect;

PROCEDURE Mark_Rec_Reading_Incorrect (
   seq_values_       IN NUMBER,
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   test_point_id_    IN VARCHAR2,
   parameter_code_   IN VARCHAR2,
   measurement_note_ IN VARCHAR2,
   reg_date_         IN DATE,
   test_pnt_seq_    IN NUMBER) 
IS
   
   CURSOR get_all_next_records IS
      SELECT *
        FROM equipment_object_meas_tab t
       WHERE test_pnt_seq = test_pnt_seq_
         AND parameter_code = parameter_code_                     
         AND reg_date > reg_date_
         AND measurement_type NOT IN ('IncorrectReading', 'MeterSetup')
      ORDER by reg_date ASC;
   
   measurement_type_        equipment_object_meas_tab.measurement_type%TYPE;
   total_value_             NUMBER;
   max_total_value_         NUMBER;
   latest_registered_date_  equipment_object_meas_tab.reg_date%TYPE;
   latest_values_seq_       NUMBER;
   meas_rec_                equipment_object_meas_tab%ROWTYPE;
   latest_meas_rec_         equipment_object_meas_tab%ROWTYPE;
   execution_method_        VARCHAR2(6);
   parameter_type_db_       VARCHAR2(20);
   objid_                   VARCHAR2(20);
   objversion_              VARCHAR2(100);
   attr_                    VARCHAR2(32000);
   indrec_                  Indicator_rec;
BEGIN
   
   meas_rec_  := Get_Object_By_Keys___(seq_values_);
   meas_rec_.measurement_type := Measurement_Type_API.DB_INCORRECT_READING;
   meas_rec_.measurement_note := measurement_note_;
   meas_rec_.measured_value := NULL;
   Modify___(meas_rec_);
   
         
   latest_values_seq_      := Get_Seq_For_Latest_Valid(test_pnt_seq_, parameter_code_);

   latest_meas_rec_        := Get_Object_By_Keys___(latest_values_seq_);
   latest_registered_date_ := latest_meas_rec_.reg_date;
   max_total_value_        := latest_meas_rec_.measured_value;
          
   IF (Measurement_Parameter_API.Get_Measurement_Param_Type_Db(parameter_code_) = Measurement_Param_Type_API.DB_LIMIT ) THEN
      IF ( Equipment_Object_Param_API.Get_Pm_Criteria_Db(test_pnt_seq_, parameter_code_) =  Pm_Criteria_API.DB_YES) THEN
         Equipment_Object_Param_API.Update_Mch_Parameter__(test_pnt_seq_,parameter_code_, max_total_value_, latest_registered_date_); 
      END IF;      
   ELSIF ( Measurement_Parameter_API.Get_Measurement_Param_Type_Db(parameter_code_) = Measurement_Param_Type_API.DB_ACCUMULATED) THEN       
      Equipment_Object_Param_API.Update_Mch_Parameter__(test_pnt_seq_,parameter_code_, max_total_value_,latest_registered_date_); 
      
      FOR rec_ IN get_all_next_records LOOP
         --Clear measurement type for each loop. Calc_Accumulated_Value___ returns correct value
         measurement_type_ := '';
         total_value_      := 0;
         Calc_Accumulated_Value___ ( total_value_, measurement_type_, rec_.recorded_value, rec_.reg_date, test_pnt_seq_, rec_.parameter_code );
         IF (rec_.measurement_type = Measurement_Type_API.DB_PRELIMINARY_READING AND measurement_type_ = Measurement_Type_API.DB_PRELIMINARY_READING) THEN         
            EXIT;
         ELSIF (rec_.measurement_type = Measurement_Type_API.DB_RECORDED_READING AND measurement_type_ = Measurement_Type_API.DB_RECORDED_READING) THEN
            meas_rec_  := rec_;
            meas_rec_.measured_value   := total_value_;
            indrec_.measured_value := TRUE; 
            Client_SYS.Add_To_Attr('UPDATE_PM', 'FALSE', attr_);
            Check_Update___(rec_, meas_rec_, indrec_, attr_);
            Update___(objid_, rec_, meas_rec_, attr_, objversion_, TRUE);
            
         ELSIF (rec_.measurement_type = Measurement_Type_API.DB_PRELIMINARY_READING AND measurement_type_ = Measurement_Type_API.DB_RECORDED_READING) THEN
            meas_rec_  := rec_;
            meas_rec_.measurement_type := measurement_type_;
            meas_rec_.measured_value   := total_value_;
            indrec_.measurement_type   := TRUE;  
            indrec_.measured_value     := TRUE; 
            Client_SYS.Add_To_Attr('UPDATE_PM', 'FALSE', attr_);
            Check_Update___(rec_, meas_rec_, indrec_, attr_);
            Update___(objid_, rec_, meas_rec_, attr_, objversion_, TRUE);
         END IF;
      END LOOP;   
           
   END IF; 

   $IF Component_Pm_SYS.INSTALLED $THEN
      execution_method_ := Object_Property_API.Get_Value('MaintenanceConfiguration', '*', 'PM_CON_PLAN_SYNC');
      parameter_type_db_ := Measurement_Parameter_API.Get_Measurement_Param_Type_Db(parameter_code_);
    
      IF execution_method_ = 'ONLINE' OR parameter_type_db_ != Measurement_Param_Type_Api.DB_ACCUMULATED THEN 
         PM_ACTION_CRITERIA_API.Update_Last_Measured_Value(test_pnt_seq_, parameter_code_, max_total_value_);
         PM_ACTION_CRITERIA_API.Update_From_Measurement (seq_values_, test_pnt_seq_, parameter_code_, null, reg_date_);  
      END IF;
      ----Update Recurring Service Trigger for Accumulated and Limit parameters
         $IF Component_Recsrv_SYS.INSTALLED $THEN       
            Recurring_Service_Trigger_API.Update_Last_Measured_Value(test_pnt_seq_, parameter_code_, max_total_value_, reg_date_, NULL, NULL, NULL, 'TRUE');
         $ELSE
            NULL;
         $END
      IF execution_method_ = 'BATCH' AND parameter_type_db_ = Measurement_Param_Type_Api.DB_ACCUMULATED THEN 
         Handle_Pm_Action_Criteria( values_seq_ => seq_values_, 
                                    test_pnt_seq_ => test_pnt_seq_, 
                                    parameter_code_ => parameter_code_, 
                                    mch_code_ => meas_rec_.mch_code, 
                                    contract_ => meas_rec_.contract, 
                                    measurement_type_ => meas_rec_.measurement_type, 
                                    exclude_measurement_type_ => 'TRUE');
      END IF; 
   $ELSE
      NULL;
   $END
   
END Mark_Rec_Reading_Incorrect;

PROCEDURE Handle_Meter_Flips (
   seq_values_       IN NUMBER,
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   test_point_id_    IN VARCHAR2,
   test_sequence_id_ IN VARCHAR2,
   parameter_code_   IN VARCHAR2,
   recorded_value_   IN NUMBER,
   reg_date_         IN DATE,
   test_pnt_seq_     IN NUMBER) 
IS
   CURSOR get_preliminary_records IS
      SELECT values_seq, contract, mch_code, test_point_id, parameter_code, recorded_value, reg_date, measurement_type
               FROM EQUIPMENT_OBJECT_MEAS_TAB t
                  WHERE test_pnt_seq = test_pnt_seq_
                  AND parameter_code = parameter_code_                       
                  AND reg_date > reg_date_
                  ORDER by reg_date ASC;  
   
   measurement_type_ VARCHAR2(120);
   user_             VARCHAR2(30);
   newrec_           EQUIPMENT_OBJECT_MEAS_TAB%ROWTYPE;
   meter_id_         EQUIPMENT_OBJECT_MEAS_TAB.meter_id%TYPE;
   remark_temp_      VARCHAR2(80);   
   meter_flip_value_ NUMBER;
   meter_flip_date_  DATE;
   total_value_      NUMBER;
   
   loop_count_       NUMBER := 0;
BEGIN
  
   meter_id_ := Get_Meter_Id(seq_values_);
   remark_temp_ := Language_SYS.Translate_Constant(lu_name_, 'CREBY: Created by');
   user_ := Fnd_Session_API.Get_Fnd_User;
      
   SELECT reg_date_- interval '1' second AS flip 
      INTO meter_flip_date_
   FROM dual;
   
   meter_flip_value_ := EQUIPMENT_OBJECT_PARAM_API.Get_Meter_Flip_Value(test_pnt_seq_,parameter_code_);
   
   newrec_.parameter_code   := parameter_code_;
   newrec_.recorded_value   := meter_flip_value_;
   newrec_.test_sequence_id := test_sequence_id_;
   newrec_.reg_date         := meter_flip_date_;
   newrec_.meter_id         := meter_id_;
   newrec_.measurement_type := Measurement_Type_API.DB_METER_ROLL_OVER;
   newrec_.remark           := remark_temp_||' '||user_;
   newrec_.test_pnt_seq     := test_pnt_seq_;
   
   New___(newrec_);
         
   newrec_ := Get_Object_By_Keys___(seq_values_);
   
   measurement_type_ := '';
   trace_sys.message('arralk reg_date_ ' || TO_CHAR(reg_date_, 'MM/DD/YYYY HH12:MI:SS AM'));
   Calc_Accumulated_Value___ ( total_value_, measurement_type_, recorded_value_, reg_date_, test_pnt_seq_, parameter_code_ );
   trace_sys.message('arralk measurement_type_ ' || measurement_type_);
   
   IF (measurement_type_ = Measurement_Type_API.DB_RECORDED_READING) THEN
      newrec_.measurement_type := Measurement_Type_API.DB_RECORDED_READING;
      newrec_.measured_value   := total_value_;       
      Modify___(newrec_);
      loop_count_ := loop_count_ + 1;
   END IF;   
   
   FOR preli_rec_ IN get_preliminary_records LOOP
      --Clear measurement type for each loop.
      measurement_type_ := '';
      total_value_      := 0;
      Calc_Accumulated_Value___ ( total_value_, measurement_type_, preli_rec_.recorded_value, preli_rec_.reg_date, test_pnt_seq_, preli_rec_.parameter_code );
      IF (measurement_type_ = Measurement_Type_API.DB_RECORDED_READING) THEN
         newrec_ := Get_Object_By_Keys___(preli_rec_.values_seq);
         newrec_.measurement_type  := measurement_type_;
         newrec_.measured_value    := total_value_;       
         Modify___(newrec_);
         loop_count_ := loop_count_ + 1;
      END IF;
   END LOOP;
   
END Handle_Meter_Flips;  

FUNCTION Is_Reg_Date_Exists (
   test_pnt_seq_ IN NUMBER,
   parameter_code_   IN VARCHAR2,
   reg_date_ IN DATE) RETURN NUMBER
IS   
   CURSOR get_date IS
      SELECT 1
            FROM   EQUIPMENT_OBJECT_MEAS_TAB
            WHERE test_pnt_seq =test_pnt_seq_
            AND parameter_code = parameter_code_            
            AND measurement_type IN ('RecordedReading', 'PreliminaryReading', 'MeterRollOver', 'MeterChangeBefore', 'MeterChangeAfter')
            AND reg_date = reg_date_
            ORDER BY reg_date ASC;
   dummy_       NUMBER;
BEGIN   
   OPEN get_date;
   FETCH get_date INTO dummy_;
   IF (get_date%FOUND) THEN
      CLOSE get_date;
      RETURN 1;  
   END IF;
   CLOSE get_date;
   RETURN 0; 
END Is_Reg_Date_Exists;

FUNCTION Is_Readings_Exists (
   test_pnt_seq_  IN NUMBER,
   parameter_code_   IN VARCHAR2) RETURN NUMBER
IS   
   CURSOR get_records IS
      SELECT 1
            FROM   EQUIPMENT_OBJECT_MEAS_TAB
            WHERE test_pnt_seq = test_pnt_seq_
            AND parameter_code = parameter_code_            
            AND measurement_type NOT IN ('MeterSetup', 'IncorrectReading')
            ORDER BY reg_date ASC;
   dummy_       NUMBER;
BEGIN   
   OPEN get_records;
   FETCH get_records INTO dummy_;
   IF (get_records%FOUND) THEN
      CLOSE get_records;
      RETURN 1;  
   END IF;
   CLOSE get_records;
   RETURN 0; 
END Is_Readings_Exists;

FUNCTION Is_Valid_Readings (
   value_seq_  IN NUMBER) RETURN VARCHAR2 
IS   
   CURSOR get_records IS
      SELECT measurement_type
            FROM   EQUIPMENT_OBJECT_MEAS_TAB
            WHERE values_seq = value_seq_;
            
   measurement_type_       VARCHAR2(50);
BEGIN   
   OPEN get_records;
   FETCH get_records INTO measurement_type_;
   CLOSE get_records;
   IF (measurement_type_ = 'IncorrectReading') THEN      
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;   
END Is_Valid_Readings;

PROCEDURE  Handle_Pm_Action_Criteria(values_seq_ IN NUMBER, 
                                     test_pnt_seq_ IN NUMBER, 
                                     parameter_code_ IN VARCHAR2, 
                                     mch_code_ IN VARCHAR2, 
                                     contract_ IN VARCHAR2,
                                     measurement_type_ IN VARCHAR2,
                                     exclude_measurement_type_ IN VARCHAR2 DEFAULT 'FALSE')
IS   
   attrib_             VARCHAR2(32000);  
   description_        VARCHAR2(200);
   msg_                VARCHAR2(32000);
   exec_count_         PLS_INTEGER;
   job_id_tab_         Message_SYS.name_table;
   attrib_tab_         Message_SYS.line_table;
   posted_by_diff_     BOOLEAN := FALSE;
   execute_by_diff_    BOOLEAN := FALSE;
   temp_test_pnt_seq_  NUMBER;
   temp_parameter_code_ VARCHAR2(5);
   exe_index_          NUMBER; 
   results_            Transaction_SYS.Arguments_Table;
BEGIN
 
   $IF Component_Pm_SYS.INSTALLED $THEN
      IF ( (measurement_type_ IN (Measurement_Type_API.DB_RECORDED_READING, Measurement_Type_API.DB_METER_CHANGE_BEFORE) OR exclude_measurement_type_= 'TRUE')
            AND Transaction_SYS.Package_Is_Active('PM_ACTION_CRITERIA_API')) THEN
         Client_SYS.Add_To_Attr('VALUE_SEQ', values_seq_, attrib_);
         Client_SYS.Add_To_Attr('TEST_PNT_SEQ', test_pnt_seq_, attrib_);
         Client_SYS.Add_To_Attr('PARAMETER_CODE', parameter_code_, attrib_);
         Client_SYS.Add_To_Attr('MCH_CODE', mch_code_, attrib_);
         Client_SYS.Add_To_Attr('CONTRACT', contract_, attrib_);
         description_ := Language_SYS.Translate_Constant(lu_name_, 'PM_CRITERIA_UPDATE: Update PM Action Condition and Regenerate Maintenance Plan.');
         
         --check whether there is posted job.
         results_ := Transaction_SYS.Get_Posted_Job_Arguments('PM_ACTION_CRITERIA_API.Refresh_Pm_Criteria', NULL);  
         
         --check if at least one posted job is initiated by this parameters.
         IF (results_ IS NOT NULL  AND results_.COUNT > 0) THEN 
            posted_by_diff_ := TRUE;
            FOR i_ IN results_.FIRST..results_.LAST LOOP
               temp_test_pnt_seq_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('TEST_PNT_SEQ', results_(i_).arguments_string));
               temp_parameter_code_ := Client_SYS.Get_Item_Value('PARAMETER_CODE',results_(i_).arguments_string);
               
               IF temp_test_pnt_seq_ = test_pnt_seq_ AND temp_parameter_code_ = parameter_code_ THEN  
                  --bj has been initiated by same parameters.
                  posted_by_diff_ := FALSE;
               END IF;
            END LOOP;
         END IF;
         
         IF ( results_ IS NULL OR results_.COUNT = 0 OR posted_by_diff_ )THEN 
            Transaction_SYS.Get_Executing_Job_Arguments(msg_,'PM_ACTION_CRITERIA_API.Refresh_Pm_Criteria');
            Message_SYS.Get_Attributes(msg_, exec_count_, job_id_tab_, attrib_tab_);
            
            --check if at least one executing job is initiated by this parameters.
            IF exec_count_ > 0 THEN 
               execute_by_diff_ := TRUE;
               exe_index_ := 0;
               FOR i_ IN 1..exec_count_ LOOP
                  temp_test_pnt_seq_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('TEST_PNT_SEQ',attrib_tab_(i_)));
                  temp_parameter_code_ := Client_SYS.Get_Item_Value('PARAMETER_CODE',attrib_tab_(i_));
                  
                  IF temp_test_pnt_seq_ = test_pnt_seq_ AND temp_parameter_code_ = parameter_code_ THEN 
                     --bj has been initiated by same parameters.
                     exe_index_ := exe_index_ + 1; 
                     execute_by_diff_ := FALSE;
                  END IF;
               END LOOP;
            END IF;

            IF ( (results_ IS NULL OR results_.COUNT = 0 OR posted_by_diff_ ) AND ( exec_count_ = 0 OR execute_by_diff_ OR exe_index_ = 1 )) THEN 
               --Post a background job only if There are no posted bjs/have less than two executing bjs.
               Transaction_SYS.Deferred_Call('PM_ACTION_CRITERIA_API.Refresh_Pm_Criteria',attrib_, description_);
            END IF;
         END IF;
      END IF;
   $ELSE
      NULL;
   $END   
END Handle_Pm_Action_Criteria;
