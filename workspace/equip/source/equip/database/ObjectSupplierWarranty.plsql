-----------------------------------------------------------------------------
--
--  Logical unit: ObjectSupplierWarranty
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000114  JIJO    Created
--  000301  BGADSE  FUNCTION Has_Warranty: SELECT is changet because it did not
--                  consider valid_until could be NULL.
--  000614  MILOSE  Changed calls to non-dependent modules to be dynamic.
--  001018  GOPE    Added IID 6423 Warranty Handling 2.2.
--  001122  MAGN    IID 6423 added view OBJ_SUPP_WARRANTY_TYPE and "L" FLAG to some
--                  columns in view OBJECT_SUPPLIER_WARRANTY.
--  001129  MIBO    IID 6423 added "L" FLAG to some columns in view OBJ_SUPP_WARRANTY_TYPE.
--  001218  JOHGSE  Call 57691 Sup_Warranty_API.Exist due to backwards combability problems.
--  001219  JOHGSE  Is_Warranty_Valid is commented due to backwardscompability problems,
--                  its not used anyware in the application and will be removed next released
--                  if we dont implement it!
--  010103  JOHGSE  Made view OBJ_SUPP_WARRANTY_TYPE dynamic due to backwardcompability problem
--  010116  JOHGSE  Rescue warranty: Adding Valid_From to view
--  010227  SHAMLK  Added the field note to the view OBJ_SUPP_WARRANTY_TYPE.
--  010320  johgse  Bug Id: 20715 Added valid_until to the Base-functions
--  010424  johgse  Bug Id 21529  Added Valid until, valid to in OBJ_SUPP_WARRANTY_TYPE VIEW
--  010426  UDSULK  Added the General_SYS.Init_Method to Get_Valid_Date,Get_Next_Row,New,
--                  Add_Customer_Order_Warranty and Add_Work_Order_Warranty. 
--  010426  johgse  moved the field note in Obj_Supp_Warranty_Type, it cant be among the keys!
--  ************************************* AD 2002-3 BASELINE ********************************************
--  020604  CHAMLK  Modified the length of the MCH_CODE from 40 to 100
--  --------------------------------AD 2002-3 Beta (Merge of IceAge)------------------------------------- 
--  020826  JEWILK  Bug 31962, Added Procedure Modify_Supplier_Warranty_State.
--                  Modified function Has_Warranty to return true only when there are valid warranties.
--  --------------------------------(Merge of Take Off)------------------------------------- 
--  030915  NEKOLK  Merge of Take Off Bug 37885( Changed the duplicated field 'valid_from' to 'valid_until'.)
--  030926  PRIKLK  Bug 39140, Modified method Add_Customer_Order_Warranty.
--  031018  LABOLK  Converted VARCHAR to VARCHAR2.
--  031022  CHCRLK  Modified function Has_Warranty [Call ID 108998].
--  110204  DIMALK  Unicode Support: Changes Done with 'SUBSTRB'.
--  230304  DIMALK  Unicode Support. Converted all the 'dbms_sql' codes to Native Dynamic SQL statements, inside the package body.
--  061204  Japalk  Removed Dynamic calls to MPCCOM.
--  201204  Namelk  Removed Checks for SUP_WARRANTY_API Installed. 
------------------------------------------------------------------------------------------------------------
--  030907  ILSOLK  Modified Unpack_Check_Insert__() & Unpack_Check_Update__()(Call ID 148049)
--  081231  SHAFLK  Bug 79435,Modified Modify_Supplier_Warranty_State.
--  080714  SHAFLK  Bug 83824, Modified Has_Warranty().
--  100706  SHAFLK  Bug 89844,Modified Modify_Supplier_Warranty_State.
--  100816  MAWILK  Bug 90474, Merged. Added Is_Warranty_Valid() and modified Has_Warranty().
--  101021  NIFRSE  Bug 93384, Updated view column prompts to 'Object Site'.
-------------------------------------------------------------------------
--  110825  ILSOLK  Bug 98626,Added new param valid_to_  into Add_Work_Order_Warranty() method.
--  091106  SaFalk  IID - ME310: Removed bug comment tags.
--  110815  PRIKLK  SADEAGLE-1739, Added user_allowed_site filter to view OBJ_SUPP_WARRANTY_TYPE. Replaced OBJ_SUPP_WARRANTY_TYPE view usages with the table.
--  110824  PRIKLK  SADEAGLE-1739, Added new view OBJECT_SUPPLIER_WARRANTY_UIV to be used in client only.
--  110907  NEKOLK  EASTTWO-11821,Modified view comment for OBJECT_SUPPLIER_WARRANTY_UIV.
--  120123  SHAFLK  Bug 100850, Modified view OBJ_SUPP_WARRANTY_TYPE.
--  120419  ILSOLK  Bug 102067, Modified Has_Warranty(),Is_Warranty_Valid(). 
--  120427  ILSOLK  Bug 102067, Removed Modify_Supplier_Warranty_State() for code cleanup
--  131202  CLHASE  PBSA-1826, Refactored and splitted.
--  140304  HERALK  PBSA-3597, Merged LCS Patch - 113673.
--  160108  NIFRSE  STRSA-925, removed Plsql statements in an SQL select (Is_Warranty_Valid)
---------------------------Task Management-----------------------------------
--  160318  INROLK  TASK-166, Created new Method Is_Valid_Warranty_Exist.
-----------------------------------------------------------------------------
--  180823  ISHHLK  Created new Function Supplier_Warranty_Is_Check.
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
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
   Client_SYS.Add_To_Attr('WARRANTY_SYMPTOM_STATUS', Warranty_Symptom_Status_API.Decode('1'), attr_);
   Client_SYS.Add_To_Attr('WARRANTY_SOURCE', Warranty_Source_API.Decode('Manual'), attr_);
   Client_SYS.Add_To_Attr('VALID_FOR_CUSTOMER', Gen_Yes_No_API.Decode('N'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT OBJECT_SUPPLIER_WARRANTY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Get_Next_Row(newrec_.row_no, newrec_.equipment_object_seq);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     OBJECT_SUPPLIER_WARRANTY_TAB%ROWTYPE,
   newrec_     IN OUT OBJECT_SUPPLIER_WARRANTY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.updated := SYSDATE;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('UPDATED', newrec_.updated, attr_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT object_supplier_warranty_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.warranty_symptom_status := nvl(newrec_.warranty_symptom_status, '1');
   newrec_.warranty_source := nvl(newrec_.warranty_source, 'Manual');
   newrec_.valid_for_customer := nvl(newrec_.valid_for_customer, 'N');
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     object_supplier_warranty_tab%ROWTYPE,
   newrec_ IN OUT object_supplier_warranty_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.valid_from IS NOT NULL ) AND (newrec_.valid_until IS NOT NULL) THEN
      IF (newrec_.valid_from > newrec_.valid_until) THEN
         Error_SYS.Appl_General(lu_name_, 'CANNOTEARLIER: Valid To Date is earlier than Valid From Date');
      END IF;
   END IF;
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Valid_Date (
   period_ IN VARCHAR2,
   valid_from_ IN DATE ) RETURN DATE
IS
   valid_until_         DATE;
   quantity_            NUMBER;
   period_type_         VARCHAR2(20);
   period_unit_qty_rec_ PERIOD_UNIT_QTY_API.Public_Rec;
BEGIN
   period_unit_qty_rec_ := Period_Unit_Qty_API.Get(period_);
   period_type_         := Period_Interval_Unit_API.Decode(period_unit_qty_rec_.period_interval_unit);
   quantity_            := period_unit_qty_rec_.quantity;
   --"Week"
   IF PERIOD_INTERVAL_UNIT_API.ENCODE(period_type_) = 1 THEN
      valid_until_ := valid_from_ + (7 * quantity_);
   --"Month"
   ELSIF PERIOD_INTERVAL_UNIT_API.ENCODE(period_type_) = 2 THEN
      valid_until_ := ADD_MONTHS(valid_from_,quantity_);
   --"Year"
   ELSIF PERIOD_INTERVAL_UNIT_API.ENCODE(period_type_) = 3 THEN
      quantity_ := quantity_ * 12;
      valid_until_ := ADD_MONTHS(valid_from_,quantity_);
   END IF;
   RETURN valid_until_;
END Get_Valid_Date;


PROCEDURE Get_Next_Row (
   row_no_               IN OUT NUMBER,
   equipment_object_seq_  IN     NUMBER)
IS
BEGIN
   SELECT nvl(max(row_no),0) + 1
      INTO   row_no_
      FROM   OBJECT_SUPPLIER_WARRANTY_TAB
      WHERE  equipment_object_seq = equipment_object_seq_;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE;
   WHEN OTHERS THEN
      NULL;
END Get_Next_Row;


@UncheckedAccess
FUNCTION Has_Warranty (
   equipment_object_seq_  IN NUMBER,
   temp_date_            IN DATE ) RETURN VARCHAR2
IS
   CURSOR mch IS
      SELECT valid_from, valid_until 
      FROM   OBJECT_SUPPLIER_WARRANTY_TAB
      WHERE  equipment_object_seq     = equipment_object_seq_
      AND    warranty_symptom_status = '1' ;
BEGIN
   FOR rec_ IN mch LOOP
      IF rec_.valid_from IS NOT NULL AND rec_.valid_until IS NOT NULL THEN
         IF trunc(temp_date_) >=  trunc(rec_.valid_from) AND trunc(temp_date_) <=  trunc(rec_.valid_until) THEN
            RETURN 'TRUE';
         END IF;
      ELSIF rec_.valid_from IS NOT NULL AND rec_.valid_until IS NULL THEN
         IF  trunc(temp_date_) >=  trunc(rec_.valid_from)  THEN
            RETURN 'TRUE';
         END IF;
      ELSIF rec_.valid_from IS NULL AND rec_.valid_until IS NOT NULL THEN
         IF  trunc(temp_date_) <=  trunc(rec_.valid_until)  THEN
            RETURN 'TRUE';
         END IF;
      ELSIF rec_.valid_from IS NULL AND rec_.valid_until IS NULL THEN
         RETURN 'TRUE';
      END IF;
   END LOOP;
   RETURN 'FALSE';
END Has_Warranty;

@UncheckedAccess
FUNCTION Has_Warranty (
   contract_  IN VARCHAR2,
   mch_code_  IN VARCHAR2,
   temp_date_ IN DATE ) RETURN VARCHAR2
IS
BEGIN
   RETURN Has_Warranty(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), temp_date_);
END Has_Warranty;

@UncheckedAccess
FUNCTION Supplier_Warranty_Is_Check (
   equipment_object_seq_  IN NUMBER,
   valid_until_          IN DATE,
   warranty_id_          IN VARCHAR2) RETURN VARCHAR2 
IS
   output_ VARCHAR2(20);
   last_output_ VARCHAR2(20);
   site_date_ DATE;
BEGIN
   site_date_ := Maintenance_Site_Utility_API.Get_Site_Date(Equipment_Object_API.Get_Contract(equipment_object_seq_));
   IF(valid_until_  IS NOT NULL)THEN 
      IF(valid_until_ >= site_date_) THEN 
         output_ := 'TRUE';
      ELSE
         output_ := 'FALSE';
      END IF;
   ELSE 
      output_ := 'TRUE';
   END IF; 
   IF(warranty_id_ IS NOT NULL AND output_ = 'TRUE')THEN 
      last_output_ := 'TRUE';
   ELSE 
      last_output_ := 'FALSE';
   END IF;
   RETURN last_output_;
END Supplier_Warranty_Is_Check;

@UncheckedAccess
FUNCTION Supplier_Warranty_Is_Check (
   contract_      IN VARCHAR2,
   mch_code_      IN VARCHAR2,
   valid_until_   IN DATE,
   warranty_id_    IN VARCHAR2) RETURN VARCHAR2 
IS
BEGIN
   RETURN Supplier_Warranty_Is_Check(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), valid_until_, warranty_id_);
END Supplier_Warranty_Is_Check;

PROCEDURE New (
   attr_ IN OUT VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   New__ (info_, objid_ , objversion_ ,attr_, 'DO');
END New;


PROCEDURE Add_Customer_Order_Warranty (
   equipment_object_seq_       IN NUMBER,
   warranty_action_           IN VARCHAR2,
   supplier_no_               IN VARCHAR2,
   order_no_                  IN VARCHAR2,
   line_no_                   IN VARCHAR2,
   release_no_                IN VARCHAR2,
   warranty_id_               IN NUMBER,
   valid_for_customer_        IN VARCHAR2,
   valid_from_                IN DATE,
   warranty_symptom_status_   IN VARCHAR2,
   err_symptom_               IN VARCHAR2,
   valid_to_                  IN DATE )
IS
   attr_    VARCHAR2(32000);
BEGIN
   Client_SYS.Add_To_Attr('EQUIPMENT_OBJECT_SEQ', equipment_object_seq_,                        attr_);
   Client_SYS.Add_To_Attr('VENDOR_NO',           supplier_no_,                                attr_);
   Client_SYS.Add_To_Attr('SOURCE_ID',           order_no_||' '||line_no_||' '||release_no_,  attr_);
   Client_SYS.Add_To_Attr('WARRANTY_SOURCE',     Warranty_Source_API.Decode('CustomerOrder'), attr_);
   IF warranty_action_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('WARRANTY_ACTION',          warranty_action_,          attr_);
   END IF;
   IF warranty_id_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('WARRANTY_ID',              warranty_id_,              attr_);
   END IF;  
   IF valid_for_customer_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('VALID_FOR_CUSTOMER',       valid_for_customer_,       attr_);
   END IF;
   IF valid_from_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('VALID_FROM',               valid_from_,               attr_);
   END IF;
   IF warranty_symptom_status_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('WARRANTY_SYMPTOM_STATUS',  warranty_symptom_status_,  attr_);
   END IF;
   IF err_symptom_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('ERR_SYMPTOM',              err_symptom_,              attr_);
   END IF;
   IF valid_to_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('VALID_UNTIL',              valid_to_,                 attr_);
   END IF;
   New(attr_);
END Add_Customer_Order_Warranty;


PROCEDURE Add_Work_Order_Warranty (
   equipment_object_seq_      IN NUMBER,
   warranty_action_          IN VARCHAR2,
   supplier_no_              IN VARCHAR2,
   order_no_                 IN VARCHAR2,
   warranty_id_              IN NUMBER,
   valid_for_customer_       IN VARCHAR2,
   valid_from_               IN DATE,
   warranty_symptom_status_  IN VARCHAR2,
   err_symptom_              IN VARCHAR2,
   valid_to_                 IN DATE DEFAULT NULL )
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Add_To_Attr('EQUIPMENT_OBJECT_SEQ', equipment_object_seq_, attr_);
   Client_SYS.Add_To_Attr('VENDOR_NO',           supplier_no_,         attr_);
   Client_SYS.Add_To_Attr('SOURCE_ID',           order_no_,            attr_);
   Client_SYS.Add_To_Attr('WARRANTY_SOURCE',     Warranty_Source_API.Decode('WorkOrder'), attr_);
   IF warranty_action_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('WARRANTY_ACTION',  warranty_action_,     attr_);
   END IF;
   IF warranty_id_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('WARRANTY_ID',      warranty_id_,         attr_);
   END IF;
   IF valid_for_customer_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('VALID_FOR_CUSTOMER', valid_for_customer_,attr_);
   END IF;
   IF valid_from_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('VALID_FROM',        valid_from_,         attr_);
   END IF;
   IF warranty_symptom_status_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('WARRANTY_SYMPTOM_STATUS', warranty_symptom_status_, attr_);
   END IF;
   IF err_symptom_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('ERR_SYMPTOM',       err_symptom_,        attr_);
   END IF;
   IF valid_to_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('VALID_UNTIL',        valid_to_,          attr_);
   END IF;
   New(attr_);
END Add_Work_Order_Warranty;

PROCEDURE Add_Customer_Order_Warranty (
   contract_                  IN VARCHAR2,
   mch_code_                  IN VARCHAR2,
   warranty_action_           IN VARCHAR2,
   supplier_no_               IN VARCHAR2,
   order_no_                  IN VARCHAR2,
   line_no_                   IN VARCHAR2,
   release_no_                IN VARCHAR2,
   warranty_id_               IN NUMBER,
   valid_for_customer_        IN VARCHAR2,
   valid_from_                IN DATE,
   warranty_symptom_status_   IN VARCHAR2,
   err_symptom_               IN VARCHAR2,
   valid_to_                  IN DATE )
IS
BEGIN
   Add_Customer_Order_Warranty(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), warranty_action_, supplier_no_, order_no_, line_no_, release_no_, warranty_id_, valid_for_customer_, valid_from_, warranty_symptom_status_, err_symptom_, valid_to_);
END Add_Customer_Order_Warranty;


PROCEDURE Add_Work_Order_Warranty (
   contract_                 IN VARCHAR2,
   mch_code_                 IN VARCHAR2,
   warranty_action_          IN VARCHAR2,
   supplier_no_              IN VARCHAR2,
   order_no_                 IN VARCHAR2,
   warranty_id_              IN NUMBER,
   valid_for_customer_       IN VARCHAR2,
   valid_from_               IN DATE,
   warranty_symptom_status_  IN VARCHAR2,
   err_symptom_              IN VARCHAR2,
   valid_to_                 IN DATE DEFAULT NULL )
IS
BEGIN
   Add_Work_Order_Warranty(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), warranty_action_, supplier_no_, order_no_, warranty_id_, valid_for_customer_, valid_from_, warranty_symptom_status_, err_symptom_, valid_to_);
END Add_Work_Order_Warranty;


@UncheckedAccess
FUNCTION Is_Warranty_Valid (
   equipment_object_seq_ IN NUMBER,
   report_date_         IN DATE,
   row_no_              IN VARCHAR2,
   warranty_id_         IN VARCHAR2,
   warranty_type_id_    IN VARCHAR2 ) RETURN NUMBER
IS
   date_ok_             BOOLEAN := FALSE;
   valid_from_          obj_supp_warranty_type.valid_from%TYPE;
   valid_until_         obj_supp_warranty_type.valid_until%TYPE;
   part_no_             equipment_object.part_no%TYPE;
   serial_no_           equipment_object.serial_no%TYPE;
   condition_id_        object_supplier_warranty_tab.warranty_id%TYPE;

   CURSOR get_date_info IS
      SELECT osw.valid_from as valid_from,
             osw.valid_until as valid_until,
             swc.condition_id as condition_id
      FROM object_supplier_warranty_tab osw, sup_warranty_type_pub swt, sup_warranty_condition_pub swc
      WHERE osw.warranty_id = swt.warranty_id
      AND swt.warranty_id = swc.warranty_id
      AND swt.warranty_type_id = swc.warranty_type_id
      AND osw.warranty_symptom_status != 2
      AND osw.equipment_object_seq = equipment_object_seq_
      AND osw.row_no = row_no_
      AND swt.warranty_id = warranty_id_
      AND swt.warranty_type_id = warranty_type_id_;
 BEGIN
   part_no_   := Equipment_Serial_API.Get_Part_No  (equipment_object_seq_);
   serial_no_ := Equipment_Object_API.Get_Serial_No(equipment_object_seq_);
	   -- time check
   OPEN get_date_info;
   FETCH get_date_info INTO valid_from_, valid_until_, condition_id_;
   CLOSE get_date_info;
   IF (valid_from_ IS NULL) THEN
      valid_from_ := Serial_Warranty_Dates_API.Get_Valid_From(part_no_, serial_no_, warranty_id_ ,warranty_type_id_ ,condition_id_);
   END IF;
   IF (valid_until_ IS NULL) THEN
      valid_until_ := Serial_Warranty_Dates_API.Get_Valid_To(part_no_, serial_no_, warranty_id_ ,warranty_type_id_ ,condition_id_);
   END IF;

   IF (valid_from_ IS NOT NULL AND valid_until_ IS NOT NULL) THEN
      IF trunc(report_date_) >= valid_from_ AND trunc(report_date_) <= valid_until_ THEN
         date_ok_ := TRUE;
      END IF;
   END IF;

   IF (valid_from_ IS NULL AND valid_until_ IS NULL) THEN
      date_ok_ := TRUE;
   END IF;
    
   IF valid_from_ IS NULL THEN
      IF trunc(report_date_) <= valid_until_ THEN
         date_ok_ := TRUE;
      END IF;
   END IF;
   
   IF valid_until_ IS NULL THEN
      IF trunc(report_date_) >= valid_from_ THEN
         date_ok_ := TRUE;
      END IF;
   END IF;
   IF date_ok_ THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Warranty_Valid;

@UncheckedAccess
FUNCTION Is_Warranty_Valid (
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   report_date_      IN DATE,
   row_no_           IN VARCHAR2,
   warranty_id_      IN VARCHAR2,
   warranty_type_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Is_Warranty_Valid(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), report_date_, row_no_, warranty_id_, warranty_type_id_);
END Is_Warranty_Valid;

-- Check for a matching Warranty for the given parameters.
FUNCTION Is_Valid_Warranty_Exist (
   equipment_object_seq_ IN NUMBER,
   report_date_         IN DATE,
   row_no_              IN VARCHAR2,
   warranty_id_         IN VARCHAR2,
   warranty_type_id_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   part_no_          equipment_object.part_no%TYPE;
   serial_no_        equipment_object.serial_no%TYPE;

   CURSOR get_date_info IS
      SELECT osw.valid_from as valid_from,
             osw.valid_until as valid_until,
             swc.condition_id as condition_id
      FROM object_supplier_warranty_tab osw, sup_warranty_type_pub swt, sup_warranty_condition_pub swc
      WHERE osw.warranty_id = swt.warranty_id
      AND swt.warranty_id = swc.warranty_id
      AND swt.warranty_type_id = swc.warranty_type_id
      AND osw.warranty_symptom_status != 2
      AND osw.equipment_object_seq = equipment_object_seq_
      AND osw.row_no = row_no_
      AND swt.warranty_id = warranty_id_
      AND swt.warranty_type_id = warranty_type_id_;
 BEGIN
   part_no_   := Equipment_Serial_API.Get_Part_No  (equipment_object_seq_);
   serial_no_ := Equipment_Object_API.Get_Serial_No(equipment_object_seq_);
	   -- time check
   FOR rec_ IN get_date_info LOOP
   IF (rec_.valid_from IS NULL) THEN
      rec_.valid_from := Serial_Warranty_Dates_API.Get_Valid_From(part_no_, serial_no_, warranty_id_ ,warranty_type_id_ ,rec_.condition_id);
   END IF;
   IF (rec_.valid_until IS NULL) THEN
      rec_.valid_until := Serial_Warranty_Dates_API.Get_Valid_To(part_no_, serial_no_, warranty_id_ ,warranty_type_id_ ,rec_.condition_id);
   END IF;
  
   IF (rec_.valid_from IS NOT NULL AND rec_.valid_until IS NOT NULL) THEN
      IF trunc(report_date_) >= rec_.valid_from AND trunc(report_date_) <= rec_.valid_until THEN
         RETURN 'TRUE';
      END IF;
   END IF;

   IF (rec_.valid_from IS NULL AND rec_.valid_until IS NULL) THEN
      RETURN 'TRUE';
   END IF;
    
   IF rec_.valid_from IS NULL THEN
      IF trunc(report_date_) <= rec_.valid_until THEN
         RETURN 'TRUE';
      END IF;
   END IF;
   
   IF rec_.valid_until IS NULL THEN
      IF trunc(report_date_) >= rec_.valid_from THEN
         RETURN 'TRUE';
      END IF;
   END IF;
   END LOOP;
   RETURN 'FALSE';
END Is_Valid_Warranty_Exist;

FUNCTION Is_Valid_Warranty_Exist (
   mch_code_            IN VARCHAR2,
   contract_            IN VARCHAR2,
   report_date_         IN DATE,
   row_no_              IN VARCHAR2,
   warranty_id_         IN VARCHAR2,
   warranty_type_id_    IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Is_Valid_Warranty_Exist(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), report_date_, row_no_, warranty_id_, warranty_type_id_);
END Is_Valid_Warranty_Exist;

FUNCTION Is_Warranty_Exist (
   equipment_object_seq_ IN NUMBER,
   warranty_id_         IN NUMBER ) RETURN BOOLEAN
IS
   dummy_  NUMBER;
   CURSOR check_warranty IS
       SELECT 1
       FROM object_supplier_warranty_tab
       WHERE equipment_object_seq = equipment_object_seq_
       AND warranty_id  = warranty_id_;
BEGIN
   OPEN check_warranty;
   FETCH check_warranty INTO dummy_;
   IF (check_warranty%FOUND) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
   CLOSE check_warranty;
END Is_Warranty_Exist;

FUNCTION Is_Warranty_Exist (
   contract_    IN VARCHAR2,
   mch_code_    IN VARCHAR2,
   warranty_id_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Is_Warranty_Exist(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), warranty_id_);
END Is_Warranty_Exist;

@UncheckedAccess
PROCEDURE Exist (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER )
IS
BEGIN
   Exist(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Exist;


@UncheckedAccess
FUNCTION Exists (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Exists;

@UncheckedAccess
FUNCTION Get_Warranty_Symptom_Status (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Warranty_Symptom_Status(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Warranty_Symptom_Status;

@UncheckedAccess
FUNCTION Get_Warranty_Symptom_Status_Db (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN object_supplier_warranty_tab.warranty_symptom_status%TYPE
IS
BEGIN
   RETURN Get_Warranty_Symptom_Status_Db(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Warranty_Symptom_Status_Db;

@UncheckedAccess
FUNCTION Get_Err_Symptom (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Err_Symptom(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Err_Symptom;

@UncheckedAccess
FUNCTION Get_Period (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Period(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Period;

@UncheckedAccess
FUNCTION Get_Vendor_No (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Vendor_No(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Vendor_No;

@UncheckedAccess
FUNCTION Get_Warranty_Id (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Warranty_Id(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Warranty_Id;

@UncheckedAccess
FUNCTION Get_Warranty_Source (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Warranty_Source(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Warranty_Source;

@UncheckedAccess
FUNCTION Get_Warranty_Source_Db (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN object_supplier_warranty_tab.warranty_source%TYPE
IS
BEGIN
   RETURN Get_Warranty_Source_Db(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Warranty_Source_Db;

@UncheckedAccess
FUNCTION Get_Warranty_Action (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Warranty_Action(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Warranty_Action;

@UncheckedAccess
FUNCTION Get_Valid_For_Customer (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Valid_For_Customer(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Valid_For_Customer;

@UncheckedAccess
FUNCTION Get_Valid_For_Customer_Db (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN object_supplier_warranty_tab.valid_for_customer%TYPE
IS
BEGIN
   RETURN Get_Valid_For_Customer_Db(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Valid_For_Customer_Db;

@UncheckedAccess
FUNCTION Get (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN Public_Rec
IS
BEGIN
   RETURN Get(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get;

@UncheckedAccess
FUNCTION Get_Objkey (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Objkey(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Get_Objkey;

@UncheckedAccess
FUNCTION Check_Exist___ (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   row_no_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), row_no_);
END Check_Exist___;