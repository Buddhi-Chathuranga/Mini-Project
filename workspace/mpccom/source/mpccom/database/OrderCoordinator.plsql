-----------------------------------------------------------------------------
--
--  Logical unit: OrderCoordinator
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160727  IzShlk  STRSC-3682, Activated data valitity in Do_Coordinator_Exist method.
--  160706  SudJlk  STRSC-1959, Removed Blocked_For_Use with the introduction of data validity.
--  150122  MeAblk  EAP-984, Added new method Get_Email.
--  141217  TAORSE  Removed extra Enumerate_Db method
--  141216  NiFrse  PRSA-6059, Added a new Enumerate_Db method.
--  100429  Ajpelk  Merge rose method documentation
--  091005  ChFolk  Removed unused variables.
--  ------------------------------- 14.0.0 ------------------------------------
--  090606  PraWlk  Bug 83548, Modified Unpack_Check_Insert___ by assigning FALSE for blocked_for_use
--  090606          attibute when it is NULL.
--  090522  PraWlk  Bug 83040, Modified procedure Do_Coordinator_Exist to validate Do_Coordinator. 
--  090511  PraWlk  Bug 81853, Modified Exist to use the parameter error_when_blocked_.
--  090220  PraWlk  Bug 77435, Added column blocked_for_use to the ORDER_COORDINATOR view and 
--  090220           modified views ORDER_COORDINATOR_LOV, DO_ORDER_COORDINATOR_LOV and 
--  090220            DAO_DO_COORDINATOR_LOV. Added funtions Get, Get_Blocked_For_Use and 
--  090220          Get_Blocked_For_Use_db. Modified Prepare_Insert___ and Enumerate.
--  070817  AmPalk  Added DAO_DO_COORDINATOR_LOV.
--------------------------------------------------------------------------------
--  060112  SeNslk  Modified the PROCEDURE Insert___ according to the new template.
--  050628  HaPulk  Removed some red codes.
--  040831  DiVelk  Added function Check_Exist().
--  040804  LaBolk  Modified error message in Do_Coordinator_Exist.
--  040513  NaWalk  Added the procedure Do_Coordinator_Exist.
--  040303  SaNalk  Added substr to VIEW_LOV..name
--  040223  SaNalk  Removed SUBSTRB.
--  ----------------------------- 13.3.0 ---------------------------------------
--  010706  OsAllk  Bug Fix 22612,UPPERCASE removed in the COMMENT ON COLUMN VIEW_LOV..name.
--  010212  JSAnse  Modified list_ in the procedure Enumerate to VARCHAR2(32000)
--  000925  JOHESE  Added undefines.
--  000418  NISOSE  Added General_SYS.Init_Method in Get_Control_Type_Value_Desc
--                  and Replace_Person_Id.
--  990607  FRDI    Changep prompt on the authorize_code-Collumn.
--  990602  JakH    Changed Replace_Person_Id for ENTKIT.
--  990512  JakH    Added Replace_Person_Id for ENTKIT.
--  990422  JOHW    General performance improvements.
--  990415  JOHW    Upgraded to performance optimized template.
--  990127  TOBE    Added /NOCHECK on ref to PersonInfo in VIEW_LOV.
--  981229  ErFi    Added Order_Coordinator_Lov
--  981228  ErFi    Modified to validate Order Coordiantor against Person Info in Enterprise.
--                  Removed attributes Name, Phone, Extension. Changed functions to fetch values
--                  Enterprise.
--  971121  TOOS    Upgrade to F1 2.0
--  970929  JOKE    Made view column AuthorizeGroup Mandatory.
--  970527  MAGN    Support Id: 355. Changed view comment for LU PROMPT from co-ordinator
--                  to coordinator.
--  970526  MAGN    Support Id: 122. Changed view comments PROMPT for col.
--                  Authorize_Code to Coordinator Id and Name to Coordinator Name.
--  970508  FRMA    Added Get_Control_Type_Value_Desc.
--  970313  CHAN    Changed table name: authorize is replaced by
--                  order_coordinator_tab
--  970221  JOKE    Uses column rowversion as objversion (timestamp).
--  970124  AnAr    Added Procedure Enumerate.
--  961214  JOKE    Modified with new workbench default templates.
--  961111  JOBE    Modified for compatibility with workbench.
--  960517  AnAr    Added purpose comment to file.
--  960306  SHVE    Changed LU Name GenAuthorize.
--  951012  SHR     Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

separator_ CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--   Procedure to get description for accounting rules.
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Name(value_);
END Get_Control_Type_Value_Desc;


-- returns the db values
@UncheckedAccess
PROCEDURE Enumerate_Db(
   authorize_list_db_ OUT VARCHAR2)
IS
   list_ VARCHAR2(32000);
   CURSOR getlu IS
      SELECT authorize_code
      FROM   ORDER_COORDINATOR_TAB
      WHERE  rowstate = 'Active'
      ORDER BY authorize_code;
BEGIN
   FOR met IN getlu LOOP
      list_ := list_ || met.authorize_code || separator_;
   END LOOP;
   authorize_list_db_ := Domain_SYS.Enumerate_(list_);
END Enumerate_Db;

-- Enumerate
--   Gets a list of all authorize codes.
@UncheckedAccess
PROCEDURE Enumerate (
   authorize_list_ OUT VARCHAR2 )
IS
   list_ VARCHAR2(32000);
   CURSOR getlu IS
      SELECT authorize_code
      FROM   ORDER_COORDINATOR_TAB
      WHERE  rowstate = 'Active';
BEGIN
   FOR met IN getlu LOOP
      list_ := list_ || met.authorize_code || separator_;
   END LOOP;
   authorize_list_ := list_;
END Enumerate;

-- Get_Name
--   Fetches the Order Coordinator Name from the Person Info LU in Enterprise.
@UncheckedAccess
FUNCTION Get_Name (
   authorize_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
  name_  VARCHAR2(100);
BEGIN
   name_ := Person_Info_API.Get_Name(authorize_code_);
   RETURN name_;
END Get_Name;


-- Get_Extension
--   Fetches the Order Coordinator Extension from the
--   Person Info Comm Method LU in Enterprise.
@UncheckedAccess
FUNCTION Get_Extension (
   authorize_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
/*   temp_ ORDER_COORDINATOR.extension%TYPE;
   CURSOR get_attr IS
      SELECT extension
      FROM ORDER_COORDINATOR
      WHERE authorize_code = authorize_code_;
*/
  extension_  VARCHAR2(200);
BEGIN
/*   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
*/
  extension_ := Comm_Method_API.Get_Default_Value('PERSON', authorize_code_, 'PHONE');
  RETURN extension_;
END Get_Extension;


-- Get_Phone
--   Fetches the Order Coordinator Phone from the
--   Person Info Comm Method LU in Enterprise.
@UncheckedAccess
FUNCTION Get_Phone (
   authorize_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
/*   temp_ ORDER_COORDINATOR.phone%TYPE;
   CURSOR get_attr IS
      SELECT phone
      FROM ORDER_COORDINATOR
      WHERE authorize_code = authorize_code_;
*/
  phone_  VARCHAR2(200);
BEGIN
/*   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
*/
  phone_ := Comm_Method_API.Get_Default_Value('PERSON', authorize_code_, 'PHONE');
  RETURN phone_;
END Get_Phone;


@UncheckedAccess
FUNCTION Get_Email (
   authorize_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
  email_  VARCHAR2(200);
BEGIN
  email_ := Comm_Method_API.Get_Default_Value('PERSON', authorize_code_, 'E_MAIL');
  RETURN email_;
END Get_Email;


-- Replace_Person_Id
--   The procedure does not really replace any person data,
--   instead it adds a person-id if it's not already in the
--   list of active  coordinators.
--   The group of the old coordinator is copied to the new guy.
FUNCTION Replace_Person_Id (
   new_person_id_ IN VARCHAR2,
   old_person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   attr_        VARCHAR2(500);
   newrec_      ORDER_COORDINATOR_TAB%ROWTYPE;
   oldrec_      ORDER_COORDINATOR_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   IF new_person_id_ = old_person_id_ THEN
      -- no need to change, either neither exists or both
      RETURN 'TRUE';
   END IF;

   IF check_exist___(new_person_id_) THEN
      -- ok he's already here don't do anything
      RETURN 'FALSE';
   ELSIF (NOT check_exist___(old_person_id_)) THEN
      -- the old guy is nonexisting so the new one is not really a coordinator
       RETURN 'TRUE';
   ELSE
      -- get old data to copy
      oldrec_ := Get_Object_By_Keys___ (old_person_id_);
      -- add new_person_id
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('AUTHORIZE_CODE', new_person_id_ , attr_);
      Client_SYS.Add_To_Attr('AUTHORIZE_GROUP',  oldrec_.authorize_group, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      RETURN 'TRUE';
   END IF;
END Replace_Person_Id;


-- Do_Coordinator_Exist
--   Checks whether the Distribution Order Exists.
PROCEDURE Do_Coordinator_Exist (
   authorize_code_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_do_coordinator IS
      SELECT 1
      FROM   order_coordinator_tab oc, order_coordinator_group_tab og
      WHERE  og.dist_order_prefix IS NOT NULL
      AND    og.authorize_group = oc.authorize_group
      AND    oc.authorize_code = authorize_code_;
BEGIN
   Exist (authorize_code_, TRUE);
   OPEN exist_do_coordinator;
   FETCH exist_do_coordinator INTO dummy_;
   IF (exist_do_coordinator%FOUND) THEN
      CLOSE exist_do_coordinator;
   ELSE
      CLOSE exist_do_coordinator;
      Error_SYS.Record_General(lu_name_, 'DOCONOTEXIST: Coordinator :P1 has no distribution order defaults defined. Please view the list of values for a valid entry.', authorize_code_);
   END IF;
END Do_Coordinator_Exist;


-- Check_Exist
--   Checks whether the coordinator exists.
@UncheckedAccess
FUNCTION Check_Exist (
   authorize_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Check_Exist___(authorize_code_)
   THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;



