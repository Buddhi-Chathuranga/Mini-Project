-----------------------------------------------------------------------------
--
--  Logical unit: Requisitioner
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220520  SBalLK  SCDEV-11092, Modified Get_Extension() method by adding parameter to ignore validating requisition existence when use in basic data.
--  210129  RoJalk  SC2020R1-11621, Modified Replace_Person_Id to call New___ instead of Unpack methods.
--  200409  SeJalk  Bug 153248 (SCZ-9748), Modified Prepare_Insert___ to set the corect attribute name.
--  191212  ErRalk  SCSPRING20-1108, Moved code in PurchaseRequisitioner into Requisitioner.
--  160701  IzShlk  STRSC-1973, Removed the overriden exist method, since data validity is introduced.
--  160226  DilMlk  Bug 126583, Modified Get_Extension() to fetch work phone of the requisitioner when there's a distinct 
--  160226          work phone available and to fetch default home phone when there are no work phones defined.
--  160114  Maabse  STRSC-856, Added column SYSTEM_DEFINED
--  121107  SBalLK  Bug 106498, Modified Get_Requisitioner() Get_Extension() method to return values if requisitioner exist.
--  100715  HeWelk  Removed  authorize_id
--  100512  DeKolk  Merge Rose method documentation.
--  100107  Umdolk Refactoring in Communication methods in Enterprise.
--  090330  KaDilk Bug 77435, Modified procedure Get_Default_Requisitioner().
--  090121  KaDilk Bug 77435, Added new column BLOCKED_FOR_USE to the table and view. Modified view PURCHASE_REQUISITIONER_LOV.
--  090121         Modified the relevent procedures.
--  080507  RoJalk Bug 73185, Added Get_Requisitioner_Code.
--  060913  ShKolk Bug 60190, Removed view PURCHASE_REQUISITIONER_LOV1.
--  060814  MarSlk Bug 59399, Modified the view PURCHASE_REQUISITIONER_LOV1 to make the PMRP option unavailable in LOV.
--  060111  IsWilk Modified PROCEDURE Insert___ according to template 2.3
--  050321  JaJalk Added the method Get_Default_Requisitioner to fetch the Requisitioner ID only if the relevant
--  050321         person identity is connected to the logged on fnd user.
--  041005  LaBolk Bug 46813, Added public method Check_Exist.
--  040224  IsAnlk Removed Substrb from view.
--  040113  SuAmlk Bug 40148, Made name of the system requisitioners translatable.
--  040209  IsAnlk Removed General_SYS.Init_Method calls from system generated Implementation methods.
--  031223  SaNalk Added column 'authorize_id' to PURCHASE_REQUISITIONER  View. Modified Unpack_Check_Insert___,
--  031223         Insert___,Unpack_Check_Update___, Update___  to match with design. Modified the Function Get.
--  030929  ThGulk Changed substr to substrb, instr to instrb, length to lengthb.
--  010706  OsAllk Bug fix 22612,UPPERCASE removed in the COMMENT ON COLUMN VIEW_LOV..requisitioner_name.
--  010412 JOHESE Bug fix 21014, Changed PURCHASE_REQUISITIONER_LOV1
--  001215  SrDh  Added the view PURCHASE_REQUISITIONER_LOV1.
--  001017  SrDh  Removed the Authorizer_Id from PURCHASE_REQUISITIONER view and PURCHASE_REQUISITIONER_LOV.
--                Modified the PURCHASE_REQUISITIONER_LOV.
--  000920  OsAm  Added UNDEFINE.
--  000323  IsWi  Added the General_SYS.Init_Method to the PROCEDURES.
--  990616  GaSo  Modified the function Get_Object_By_Id___ in order to correct the template bug .
--  990608  GaSo  Replaced the comment XXXX with Purchase Requisitioner in the
--                FUNCTION Replace_Person_Id .
--  990603  WaKu  Modified the function replace_person.
--  990523  GaSo  Added Replace_Person_Id for ENTKIT .
--  990513  KaWi  Changed lowercase letters into uppercase at the beginning of words in PROMPTs
--  000423  BhRa  Beautify the code.
--  990422  WaKu  Yoshimura - Update to New Template.
--  990216  ErFi  Changed LOV definition
--  990128  OsAm  Changed NO_CHECK to NOCHECK.
--  990121  BhSu  Added NO_CHECK comment to view Purchase_Requisitioner_Lov
--  990120  BhSu  Added reference comment to view Purchase_Requisitioner_Lov
--  990107  ToBe  PurchaseRequisitioner now connected to PersonInfo only requisitioner_code,
--                authorize_id, req_dept and rowversion left as attributes,
--                public functions preserved.
--  990107  ERFI  Changed view comments on authorize_id, requisitioner_code to 20 charcaters
--  971204  GOPE  Correction of  associations attribute
--  971124  JICE  Upgraded to Foundation1 2.0.0
--  970507  PHDE  Added PROCEDURE Get_Control_Type_Value_Desc.
--  970320  JRM   Changed references to table REQUISITION_DETAIL to
--                PURCHASE_REQUISITIONER_TAB
--  970228  VAPH  New template and changed object version
--  961212  SHVE  New template.
--  961108  JOBI  Modified for Developers Workbench/Rational Rose.
--  961016  ASBE  BUG 96-0307 Not possible to remove authorizer.
--  960528  GOPE  Added Get_Deparment and Get_Extension
--  960311  JICE  Renamed from PurRequisitionerList
--  951012  SHR   Base Table to Logical Unit Generator 1.
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
   Client_SYS.Add_To_Attr('SYSTEM_DEFINED_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT requisitioner_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.system_defined IS NULL THEN
      newrec_.system_defined := 'FALSE';
   END IF;
   super(newrec_, indrec_, attr_);   
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     requisitioner_tab%ROWTYPE,
   newrec_ IN OUT requisitioner_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'REQUISITIONER_CODE', newrec_.requisitioner_code);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN requisitioner_tab%ROWTYPE )
IS
   dummy_      VARCHAR2(1);
   CURSOR Exist IS
      SELECT 1
      FROM REQUISITIONER_TAB
      WHERE requisitioner_code = newrec_.requisitioner_code;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO REQUISITIONER_TAB(
            requisitioner_code,
            req_dept,
            rowversion)
         VALUES(
            newrec_.requisitioner_code,
            newrec_.req_dept,
            newrec_.rowversion);

      Basic_Data_Translation_API.Insert_Prog_Translation( 'DISCOM',
                                                       lu_name_,
                                                       newrec_.requisitioner_code||'^'||'REQUISITIONER_NAME',
                                                       Person_Info_API.Get_Name(newrec_.requisitioner_code));
   ELSE
      Basic_Data_Translation_API.Insert_Prog_Translation( 'DISCOM',
                                                       lu_name_,
                                                       newrec_.requisitioner_code||'^'||'REQUISITIONER_NAME',
                                                       Person_Info_API.Get_Name(newrec_.requisitioner_code));
   END IF;
   CLOSE Exist;
END Insert_Lu_Data_Rec__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--   Replaces Mpccom.Mpc4Am.Get_Description which was removed for 10.3.
PROCEDURE Get_Control_Type_Value_Desc (
     desc_    IN OUT VARCHAR2,
     company_ IN VARCHAR2,
     value_   IN VARCHAR2 )
IS
BEGIN
   desc_ := Get_Requisitioner (value_);
END Get_Control_Type_Value_Desc;


-- Get_Extension
--   Returns the extension for this requisitioner.
@UncheckedAccess
FUNCTION Get_Extension (
   requisitioner_code_ IN VARCHAR2,
   ignore_existence_   IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE) RETURN VARCHAR2
IS
   address_id_       VARCHAR2(50) := NULL;
   ret_value_        VARCHAR2(50) := NULL;
   count_            NUMBER := 0;
BEGIN
   IF Check_Exist___(requisitioner_code_) OR ignore_existence_ = Fnd_Boolean_API.DB_TRUE THEN   
      address_id_ := Comm_Method_API.Get_Address_Id_By_Method(requisitioner_code_, 'PHONE', 'PERSON', address_type_ => Address_Type_Code_API.Decode('WORK'));
      
      IF(address_id_ IS NULL) THEN
         Comm_Method_API.Get_Address_Id(address_id_, count_, requisitioner_code_, 'PHONE', 'PERSON', address_type_ => Address_Type_Code_API.Decode('WORK'));
         IF(address_id_ IS NULL AND count_ != 0) THEN 
            address_id_ := Comm_Method_API.Get_Default_Address_Id(requisitioner_code_, 'PHONE', 'PERSON', address_type_ => Address_Type_Code_API.Decode('WORK'));
         END IF;
      END IF;
      
      IF (address_id_ IS NOT NULL) THEN 
         count_ := 1;    
      END IF;
      
      -- when no 'work' type phones are defined the count is zero
      IF (count_ = 0) THEN
         ret_value_ := Comm_Method_API.Get_Default_Value('PERSON', requisitioner_code_, 'PHONE');
      -- when only one 'work' type phone is defined the count is one
      ELSIF (count_ = 1) THEN 
         ret_value_:= Comm_Method_API.Get_Default_Value_Person(requisitioner_code_, 'PHONE', address_id_, Address_Type_Code_API.Decode('WORK'), sysdate);
      -- when more than one 'work' type phones are defined the count is more than one
      ELSE 
         ret_value_ := NULL;
      END IF;
      
      RETURN ret_value_;    
   END IF;
   RETURN NULL;
END Get_Extension;


-- Get_Requisitioner
--   Returns the requisitioner name from PersonInfo in Enterprise.
@UncheckedAccess
FUNCTION Get_Requisitioner (
   requisitioner_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Check_Exist___(requisitioner_code_) THEN
      RETURN Person_Info_API.Get_Name(requisitioner_code_);
   END IF;
   RETURN NULL;
END Get_Requisitioner;


-- Replace_Person_Id
--   Somewhat fake replacement of id's for purchase authorizers, if the
--   new_person_id exists, nothing is done, otherwhise if the old_person_id
--   exists the new_person_id gets created with data from the old. The attributes
--   associated with the id are copied to the new entry in the table.
FUNCTION Replace_Person_Id (
   new_person_id_ IN VARCHAR2,
   old_person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   attr_        VARCHAR2(500);
   newrec_      REQUISITIONER_TAB%ROWTYPE;
   oldrec_      REQUISITIONER_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   IF new_person_id_ = old_person_id_ THEN
      -- no need to change, either neither exists or both do
      RETURN 'TRUE';
   END IF;

   IF check_exist___(new_person_id_) THEN
      -- ok he's already here don't do anything
      RETURN 'FALSE';
   ELSIF (NOT check_exist___(old_person_id_)) THEN
      -- the old guy is nonexisting so the new guy can't really be a Purchase Requisitioner
      RETURN 'TRUE';
   ELSE
      -- get old data to copy
      newrec_ := Get_Object_By_Keys___ (old_person_id_);
      -- add new_person_id
      newrec_.requisitioner_code := new_person_id_;
      New___(newrec_);
      RETURN 'TRUE';
   END IF;
END Replace_Person_Id;


-- Get_Default_Requisitioner
--   Returns the Requisitioner ID only if the relevant person identity
--   is connected to the logged on fnd user, as the default Requisitioner.
--   Otherwise it will returns null.
@UncheckedAccess
FUNCTION Get_Default_Requisitioner (
   fnd_user_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   person_id_  VARCHAR2(20);
   rowstate_   VARCHAR2(20);
BEGIN
   person_id_ := Person_Info_API.Get_Id_For_User(fnd_user_);
   IF (person_id_ IS NOT NULL) THEN
      IF NOT (Check_Exist___(person_id_)) THEN
         person_id_ := NULL;
      ELSE
         rowstate_ := Check_Validity___(person_id_);
         IF (rowstate_ = 'BLOCKED') THEN
            person_id_ := NULL;
         END IF;
      END IF;
   END IF;
   RETURN person_id_;
END Get_Default_Requisitioner;


-- Get_Requisitioner_Code
--   Fetches the requisitioner based on local_source_ref_type.
@UncheckedAccess
FUNCTION Get_Requisitioner_Code (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   requisitioner_code_       VARCHAR2(20);
   requisition_no_           VARCHAR2(20);
   local_source_ref_type_db_ VARCHAR2(100);
BEGIN
   local_source_ref_type_db_ := NVL(source_ref_type_db_, Database_SYS.string_null_);

   IF (local_source_ref_type_db_ IN ('PUR ORDER', 'PUR REQ')) THEN
      IF (local_source_ref_type_db_ = 'PUR ORDER') THEN
         $IF Component_Purch_SYS.INSTALLED $THEN
            requisition_no_ := Purchase_Order_Line_Part_API.Get_Requisition_No(source_ref1_,
                                                                               source_ref2_,
                                                                               source_ref3_);
         $ELSE
            NULL;
         $END                                                                   
      ELSE
         requisition_no_ := source_ref1_;
      END IF;

      $IF Component_Purch_SYS.INSTALLED $THEN
         IF (requisition_no_ IS NOT NULL) THEN
            requisitioner_code_ := Purchase_Requisition_API.Get_Requisitioner_Code( requisition_no_);
         END IF;
      $END
   END IF;

   RETURN (requisitioner_code_);
END Get_Requisitioner_Code;


-- Check_Exist
--   This method checks if the passed in requisitioner exists;
--   returns 'TRUE' if yes, 'FALSE' otherwise.
@UncheckedAccess
FUNCTION Check_Exist (
   requisitioner_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(requisitioner_code_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;