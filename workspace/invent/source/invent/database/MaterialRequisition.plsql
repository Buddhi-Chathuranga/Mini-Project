-----------------------------------------------------------------------------
--
--  Logical unit: MaterialRequisition
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210217  NaLrlk  PR21R2-84, Added internal_destination parameters to New() to be used in new Material Requisition.
--  201130  SBalLK  Bug 156865(SCZ-12504), Modified Status_Change_Allowed() method to enable status changes when material requisition lines not exists.
--  181108  fandse  SCUXXW4-6335, Added Status_Change_Allowed and Print_Pick_List_Allowed, to be used MaterialRequisition client in Aurena.
--  ------------------------------APPS 10------------------------------------
--  161110  ChJalk  Bug 132459, Modified the method Check_Insert___ to raise the Error message NOT_A_WORK_DAY if the due date is not a working date.
--  160905  Dinklk  APPUXX-4360, Modified Check_Insert___ to set created_by_user_id.
--  160621  Dinklk  APPUXX-1764, Added a public method New to save a new record from UXx page.
--  130805  MaRalk  TIBE-897, Removed unused global LU constants inst_PurchaseOrderLine_ and inst_PurchaseReqUtil_.
--  130715  bhkalk  TIBE-2334 Added a parameter to Calendar_Changed() to resolve a scalability issue.
--  ------------------------------APPS 9-------------------------------------
--  130515  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  121010  MaEelk  Bug 103165, Modified Calendar_Changed() to raise an error if the due date is not within current calendar.
--  121006  MaEelk  Bug 101214, Modified Calendar_Changed() method to update the 'Due Date' when distribution calendar changed.
--  120315  ChFolk  Modified Get_Total_Value to replace Purchase_Req_Util_API.Calc_Part_Req_Line_Total with
--  120315          Purchase_Req_Line_Part_API.Get_Line_Total to get the purchase requisition line cost.
--  120215  MeAblk  Bug 100811, Removed some validations from Update___() and placed them in Unpack_Check_Update___().
--  120215          Modified the same block to raise error messages instead of info messages and also handled NULL values.
--  120126  MaEelk  Added DATE/DATE format to DATE_ENTERED and DUE_DATE in view comments.
--  111207  MAHPLK  Removed General_SYS.Init_Method from Get_Total_Value. 
--  111101  Darklk  Bug 99278, Modified the procedure Delete___ to remove the pre-accounting record associate 
--  111101          with the current Material requisition hearder.
--  110225  ChJalk  Moved 'User Allowed Site' Default Where condition from client to base view and added OPEN_MATERIAL_REQUISITION.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  091012  SuSalk  Bug 86127, Modified Get_Total_Value method to consider M51 and M53 based transactions. 
--  090714  DAYJLK  Bug 84607, Replaced parameters order_class_, and order_no_ with objid_ and objversion_ 
--  090714          respectively on procedures Plan__, Release__ and Stop__. Added implementation method
--  090714          Change_Status___.
--  080110  HaPulk  Bug 70293, Added new methods Plan__, Release__ and Stop__ to perform state transition.
--  060523  KanGlk  Instead of MATERIAL_REQUIS_LINE, MATERIAL_REQUIS_LINE_TAB  had been used.
--  -------------------------------- 13.4.0 ----------------------------------
--  060315  IsAnlk  Modified Get_Total_Value to calculate total_value based on Lot Batch.
--  060125  ShOflk  Bug 55559, Modified methods Update___ and Get_Total_Value. Added method
--  060125          Modify_Total_Value__ and a new attribute Total Value to the LU.
--  060124  NiDalk  Added Assert safe annotation.
--  060119  MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  050920  Nidalk  Removed unused variables.
--  050405  ToBeSe  Bug 49880, Added parameter contract, outer site loop and exception handling
--                  for calendar changes in procedure Calendar_Changed.
--  040428  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  040416  SaNalk  Removed the obsolete code for activity object connection in method Delete___.
--  040415  SaNalk  Removed method Respond_Activity_Detail.
--  040414  SaNalk  Removed columns 'PROJECT' and 'ACTIVITY' from view 'MATERIAL_REQUISITION', from methods
--  040414          Unpack_Check_Insert___,Unpack_Check_Update___,Insert___,Update___.
--  040302  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  040202  NaWalk  Removed the fourth variable of DBMS_SQL inside the loop.
--  040126  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  -------------------------------- 13.3.0 ----------------------------------
--  031013  MaEelk  Call ID 104459, Modified cursors in Get_Internal_Destination and Get_Destination_ID.
--  030729  MaGulk  Merged SP4
--  030103  BhRalk  Bug 35086, Modified the Method Unpack_Check_Insert___ to validate
--                  due date with date entered.
--  021018  RoAnse  Bug 33126, Changed STATUS_CODE to STATUS_CODE_DB in call to Client_SYS.Add_To_Attr
--                  in procedure Calendar_Changed.
--  020822  ANLASE  Replaced Inventory_Part_Config_API.Get_Inventory_Value_By_Method with
--                  Inventory_Part_Unit_Cost_API.Get_Invent_Value_By_Condition.
--  ****************************  Take Off Baseline  *********************************
--  010410  DaJoLK  Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and
--                  TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  010315  Makulk  Fixed bug 20129 (i.e. Added PROCEDURE Calendar_Changed ).
--  010104  JOHW    Added validation for update of Internal Destination when
--                  material requisition is in status Closed.
--  000925  JOHESE  Added undefines.
--  000804  PERK    Changed Inventory_Part_API.Get_Inventory_Value_By_Method to
--                  Inventory_Part_Config_API.Get_Inventory_Value_By_Method
--  000718  ANLASE  Added columns internal_destination and destination_id.
--  000523  NISOSE  Made a correction in Get_Total_Value.
--  000515  ANLASE  Removed method Generate_New_Order_No___ and added sequencehandling for
--                  MaterialReqNo in method Insert___
--  000505  ANHO    Replaced call to USER_DEFAULT_API.Get_Contract with USER_ALLOWED_SITE_API.Get_Default_Site.
--  000418  NISOSE  Added General_SYS.Init_Method in Get_Total_Value, Is_Pre_Posting_Mandatory och
--                  Make_Order_Reservations.
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  000329  NISOSE  Added function Get_Total_Value.
--  990920  ROOD    Bug fix 11708, Changed an error message in Unpack_Check_Insert___.
--  990919  ROOD    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990617  LEPE    Added function Is_Pre_Posting_Mandatory.
--  990608  ANHO    Added infomessage in New__ if it is mandatory pre posting.
--  990528  SHVE    Added a parameter to Make_line_Reservations.
--  990506  SHVE    Replaced call to Inventory_Part_Cost_API.Get_Cost_Per_Part with
--                  Inventory_Part_API.Get_Inventory_Value_By_Method.
--  990421  DAZA    General performance improvements.
--  990413  DAZA    Upgraded to performance optimized template.
--  990105  TOBE    Added function Get_Pre_Accounting_Id.
--  990104  TOBE    Added PRE_ACCOUNTING_ID to attr_ in Insert___.
--  981228  FRDI    Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  981215  FRDI    Replaced calls to MPCCOM_SHOP_CALENDAR_API with calls to WORK_TIME_CALENDAR_API.
--  980902  LEPE    Performance enhancement on method Generate_New_Order_No___.
--  980612  JOHW    Added check on status before update of internal customer.
--  980513  LEPE    Correction in Respond_Activity_Detail to return object progress
--                  as fraction instead of percentage. Demand from IFS/Project.
--  980402  JOHO    Added Client_SYS.Add_to_attr for Note_id in insert.
--  980401  LEPE    Changed handling of client and server default values.
--  980306  ANHO    Made an object connection to the Project Module in Delete___.
--  980224  JOHO    HEAT ID 3006.
--  980219  ANHO    Changed defaultvalue on due_date in Prepare_Insert___.
--  971128  GOPE    Upgrade to fnd 2.0
--  971104  LEPE    Further development of the Respond_Activity_Detail method for IFS/Project.
--  970909  LEPE    Added public method RespondActivityDetail for integration towards IFS/Project.
--  970908  GOPE    Added method NEW
--  970710  CHAN    Added a parameter in call to Material_Requis_Line_API.Make_Line_Reservations.
--  970703  RaKu    BUG 97-0073. Changed parameters in call to Material_Requis_Line_API.Check_Status.
--  970617  JOED    Added _db columns in the view.
--  970530  MAGN    Modified public Get-functions that use Get_Instance according to
--                  Foundation 2.0.0, support id 230.
--  970313  CHAN    Changed table name: mpc_intorder_header is replaced by
--                  material_requisition_tab
--  970220  JOKE    Uses column rowversion as objversion (timestamp).
--  970117  ASBE    Due_date is not checked against the shop_calendar. Added
--                  check in Unpack_Check_Insert.
--  961215  AnAr    Changed call to Material_Requis_Line_API.Make_Order_Reservations.
--  961212  AnAr    Made Workbench compatible.
--  961119  AnAr    Removed LOV-View.
--  961031  MAOR    Renamed Internal_Customer_API.Get_Customer_Name to
--                  Internal_Customer_API.Get_Name.
--  960704  AnAr    Added Get_Customer_Id.
--  960703  AnAr    Fixed flags on Note_Text.
--  960607  JOBE    Added functionality to CONTRACT.
--  960430  MAOS    Removed call to dual when fetching note_id and pre_accounting_id.
--  960425  MPC5    Spec 96-0002 LONG-fields is replaced by VARCHAR2(2000).
--  960307  JICE    Renamed from IntorderHeader
--  951030  BJSA    Base Table to Logical Unit Generator 1.0
--  91202   OYME    Added PRE_ACCOUNTING_ID to attr_-string
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
PROCEDURE New(
   newrec_ IN OUT NOCOPY material_requisition_tab%ROWTYPE)
IS
BEGIN
   --UXX Usage Only--
   New___(newrec_); 
END New;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Change_Status___ (
   objid_               IN     VARCHAR2,
   objversion_          IN OUT VARCHAR2,
   status_code_         IN     VARCHAR2 )
IS
   attr_        VARCHAR2(2000);
   newrec_      MATERIAL_REQUISITION_TAB%ROWTYPE;
   oldrec_      MATERIAL_REQUISITION_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'STATUS_CODE', status_code_, attr_ );

   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);

END Change_Status___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   due_date_         DATE;
   contract_         MATERIAL_REQUISITION_TAB.contract%TYPE;
BEGIN
   super(attr_);
   contract_ := USER_ALLOWED_SITE_API.Get_Default_Site;
   due_date_ := Work_Time_Calendar_API.Get_Closest_Work_Day (Site_API.Get_Dist_Calendar_Id (contract_),
                                                             Site_API.Get_Site_Date(contract_));
   Client_SYS.Add_To_Attr('DUE_DATE', due_date_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT MATERIAL_REQUISITION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Generate New Order_No.
   SELECT material_requisition_no.nextval
      INTO newrec_.order_no
      FROM DUAL;
   -- Generate Note_Id And Pre_Accounting_Id.
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   newrec_.pre_accounting_id := Pre_Accounting_API.Get_Next_Pre_Accounting_Id;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', newrec_.order_no, attr_ );
   Client_SYS.Add_To_Attr('NOTE ID', newrec_.note_id, attr_);
   Client_SYS.Add_To_Attr('STATUS_CODE', Material_Requis_Status_API.Decode(newrec_.status_code), attr_);
   Client_SYS.Add_To_Attr('DATE_ENTERED', newrec_.date_entered, attr_);
   Client_SYS.Add_To_Attr('ORDER_CLASS', Material_Requis_Type_API.Decode(newrec_.order_class), attr_);
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_ );
   Client_SYS.Add_To_Attr('PRE_ACCOUNTING_ID', newrec_.pre_accounting_id, attr_ );
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     MATERIAL_REQUISITION_TAB%ROWTYPE,
   newrec_     IN OUT MATERIAL_REQUISITION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   order_class_       MATERIAL_REQUISITION.order_class%TYPE;
   CURSOR get_child_keys IS
      SELECT line_no, release_no, line_item_no
      FROM MATERIAL_REQUIS_LINE_TAB
      WHERE order_class = newrec_.order_class
      AND order_no = newrec_.order_no;
BEGIN
   
   IF newrec_.status_code IN ('9') THEN
      IF (Validate_SYS.Is_Changed(oldrec_.int_customer_no, newrec_.int_customer_no)) THEN
         newrec_.int_customer_no := oldrec_.int_customer_no;
         Client_SYS.Add_To_Attr('INT_CUSTOMER_NO', newrec_.int_customer_no, attr_);
         Client_SYS.Add_Info(lu_name_, 'NOTICSC:  Not allowed to change Internal Customer in status :P1. The Internal Customer will not be changed.', Material_Requis_Status_API.Decode(newrec_.status_code));
      END IF;

      IF (Validate_SYS.Is_Changed(oldrec_.destination_id, newrec_.destination_id)) THEN
         newrec_.destination_id := oldrec_.destination_id;
         newrec_.internal_destination := oldrec_.internal_destination;
         Client_SYS.Add_To_Attr('DESTINATION_ID', newrec_.destination_id, attr_);
         Client_SYS.Add_Info(lu_name_, 'NOTINDESTID:  Not allowed to change Internal Destination ID in status :P1. The Internal Destination ID will not be changed.', Material_Requis_Status_API.Decode(newrec_.status_code));
      END IF;

      IF (Validate_SYS.Is_Changed(oldrec_.internal_destination, newrec_.internal_destination)) AND 
         (newrec_.destination_id        = oldrec_.destination_id)       THEN
         newrec_.internal_destination := oldrec_.internal_destination;
         Client_SYS.Add_To_Attr('INTERNAL_DESTINATION', newrec_.internal_destination, attr_);
         Client_SYS.Add_Info(lu_name_, 'NOTINDEST:  Not allowed to change Internal Destination in status :P1. The Internal Destination will not be changed.', Material_Requis_Status_API.Decode(newrec_.status_code));
      END IF;
   END IF;

   IF (oldrec_.status_code != newrec_.status_code AND newrec_.status_code = '9') THEN
	   newrec_.total_value := Material_Requisition_API.Get_Total_Value(Material_Requis_Type_API.Decode(newrec_.order_class),
                                                                      newrec_.order_no,
                                                                      'FALSE');
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   IF newrec_.status_code NOT IN ('7', '9') THEN
      IF  newrec_.status_code != oldrec_.status_code THEN
         order_class_ := Material_Requis_Type_API.Decode(newrec_.order_class);
         FOR rec_ IN Get_Child_Keys LOOP
            Material_Requis_Line_API.Change_Status(order_class_, newrec_.order_no, rec_.line_no, rec_.release_no, rec_.line_item_no, Material_Requis_Status_API.Decode(newrec_.status_code));
         END LOOP;
      END IF;
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN MATERIAL_REQUISITION_TAB%ROWTYPE )
IS
BEGIN
   Pre_Accounting_API.Remove_Accounting_Id(remrec_.pre_accounting_id);
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT material_requisition_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_             VARCHAR2(30);
   value_            VARCHAR2(4000);
   user_             VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   IF NOT (indrec_.date_entered) THEN
      newrec_.date_entered := Site_API.Get_Site_Date(newrec_.contract);
   END IF;
   
   IF NOT (indrec_.status_code) THEN
      newrec_.status_code  := '4';
   END IF;
   
   IF NOT (indrec_.order_class) THEN
      newrec_.order_class  := 'INT';
   END IF;

   super(newrec_, indrec_, attr_);

   IF ((indrec_.due_date) AND
     (Work_Time_Calendar_API.Is_Working_Day (Site_API.Get_Dist_Calendar_Id (newrec_.contract),
                                              newrec_.due_date)= 0)) THEN
      Error_SYS.Record_General(lu_name_, 'NOT_A_WORK_DAY: :P1 is not a work day in the calendar :P2.', to_char(newrec_.due_date, 'YYYY-MM-DD'), Site_API.Get_Dist_Calendar_Id (newrec_.contract));
   END IF;

   -- Check Contract
   User_Allowed_Site_API.Exist(user_, newrec_.contract);
   -- Check STATUS_CODE
   newrec_.created_by_user_id := user_;

   IF newrec_.status_code NOT IN('1', '3', '4') THEN
      Error_SYS.Record_General('MaterialRequisition', 'WRONG_STATUS_CODE: Wrong status code.');
   END IF;

   -- Check  Due Date
   IF (TRUNC(newrec_.due_date) < TRUNC(newrec_.date_entered) ) THEN
      Error_SYS.Record_General('MaterialRequisition', 'WRONG_DUE_DATE: Due Date is earlier than Date Entered.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     material_requisition_tab%ROWTYPE,
   newrec_ IN OUT material_requisition_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_              VARCHAR2(30);
   value_             VARCHAR2(4000);
   user_              VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- Check Contract
   User_Allowed_Site_API.Exist(user_, newrec_.contract);
   -- Check Status_Code MaterialRequisition
   IF newrec_.status_code NOT IN ('7', '9') THEN
      IF (Validate_SYS.Is_Changed(oldrec_.status_code, newrec_.status_code)) THEN
         IF newrec_.status_code IN ('1', '3', '4') THEN
            -- Check Status_Code on MaterialRequisLine
            IF (Status_Change_Allowed(newrec_.order_class,newrec_.order_no) = Fnd_Boolean_API.DB_FALSE) THEN
               Error_SYS.Record_General('MaterialRequisition', 'NOT_VALID_STATUS: Not valid status change.');
            END IF;
         ELSE
            Error_SYS.Record_General('MaterialRequisition', 'WRONG_STATUS_CODE: Wrong status code.');
         END IF;
      END IF;
   END IF;
   
   IF (Validate_SYS.Is_Changed(oldrec_.int_customer_no, newrec_.int_customer_no)) AND newrec_.status_code IN ('7', '9') THEN
      Error_SYS.Record_General(lu_name_, 'NOTICSC:  Not allowed to change Internal Customer in status :P1. The Internal Customer will not be changed.', Material_Requis_Status_API.Decode(newrec_.status_code));
   END IF;

   IF newrec_.status_code IN ('9') THEN
      IF (Validate_SYS.Is_Changed(oldrec_.destination_id, newrec_.destination_id))  THEN
         Error_SYS.Record_General(lu_name_, 'NOTINDESTID:  Not allowed to change Internal Destination ID in status :P1. The Internal Destination ID will not be changed.', Material_Requis_Status_API.Decode(newrec_.status_code));
      END IF;

      IF (Validate_SYS.Is_Changed(oldrec_.internal_destination, newrec_.internal_destination)) AND
         NOT(Validate_SYS.Is_Changed(oldrec_.destination_id, newrec_.destination_id)) THEN
         Error_SYS.Record_General(lu_name_, 'NOTINDEST:  Not allowed to change Internal Destination in status :P1. The Internal Destination will not be changed.', Material_Requis_Status_API.Decode(newrec_.status_code));
      END IF;
   END IF;
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Modify_Total_Value__
--   Modify the total value to the current value returned by Get_Total_Value
PROCEDURE Modify_Total_Value__ (
   order_class_   IN VARCHAR2,
   order_no_      IN VARCHAR2,
   line_modified_ IN VARCHAR2 )
IS
   attr_        VARCHAR2(2000);
   newrec_      MATERIAL_REQUISITION_TAB%ROWTYPE;
   oldrec_      MATERIAL_REQUISITION_TAB%ROWTYPE;
   objid_       MATERIAL_REQUISITION.objid%TYPE;
   objversion_  MATERIAL_REQUISITION.objversion%TYPE;
   total_value_  NUMBER := 0;
   indrec_      Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(Material_Requis_Type_API.Encode(order_class_), order_no_);
   IF (oldrec_.status_code = '9')  THEN
      total_value_ := Get_Total_Value(order_class_, order_no_, line_modified_);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr( 'TOTAL_VALUE', total_value_, attr_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);      
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Modify_Total_Value__;


-- Plan__
--   This method is used to perform the state transition to Planned.
PROCEDURE Plan__ (
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2 )
IS
   status_code_   VARCHAR2(2000);
BEGIN
   status_code_ := Material_Requis_Status_API.Decode ('1');
   Change_Status___(objid_, objversion_, status_code_);
END Plan__;


-- Release__
--   This method is used to perform the state transition to Released.
PROCEDURE Release__ (
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2 )
IS
   status_code_   VARCHAR2(2000);
BEGIN
   status_code_ := Material_Requis_Status_API.Decode ('4');
   Change_Status___(objid_, objversion_, status_code_);
END Release__;


-- Stop__
--   This method is used to perform the state transition to Stopped.
PROCEDURE Stop__ (
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2 )
IS
   status_code_   VARCHAR2(2000);
BEGIN
   status_code_ := Material_Requis_Status_API.Decode ('3');
   Change_Status___(objid_, objversion_, status_code_);
END Stop__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Change_Status
--   Set the status to the given value
PROCEDURE Change_Status (
   order_class_ IN VARCHAR2,
   order_no_    IN VARCHAR2,
   status_code_ IN VARCHAR2 )
IS
   attr_        VARCHAR2(2000);
   newrec_      MATERIAL_REQUISITION_TAB%ROWTYPE;
   oldrec_      MATERIAL_REQUISITION_TAB%ROWTYPE;
   objid_       MATERIAL_REQUISITION.objid%TYPE;
   objversion_  MATERIAL_REQUISITION.objversion%TYPE;
   indrec_      Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'STATUS_CODE', status_code_, attr_ );
   oldrec_ := Lock_By_Keys___(Material_Requis_Type_API.Encode(order_class_), order_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);         
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Change_Status;


-- Make_Order_Reservations
--   Make reservations for every requisition line on the requisition.
--   Calls MakeLineReservations in LU MaterialRequisLine to make the reservation.
PROCEDURE Make_Order_Reservations (
   order_class_ IN VARCHAR2,
   order_no_    IN VARCHAR2 )
IS
   order_class_db_    MATERIAL_REQUISITION_TAB.order_class%TYPE;
   CURSOR get_line IS
      SELECT line_no, release_no, line_item_no
      FROM MATERIAL_REQUIS_LINE_TAB
      WHERE order_no = order_no_
      AND order_class = order_class_db_;
   qty_left_   NUMBER;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   FOR linerec IN get_line LOOP
      qty_left_ := 0;
      Material_Requis_Line_API.Make_Line_Reservations(
      qty_left_,
      order_class_,
      order_no_,
      linerec.line_no,
      linerec.release_no,
      linerec.line_item_no,
      NULL,
      'Y');
   END LOOP;
END Make_Order_Reservations;


-- New
--   For creating new instances of object MaterialRequisition.
PROCEDURE New (
   order_class_          OUT VARCHAR2,
   order_no_             OUT VARCHAR2,
   site_                 IN  VARCHAR2,
   int_customer_no_      IN  VARCHAR2,
   due_date_             IN  DATE,
   note_text_            IN  VARCHAR2,
   destination_id_       IN  VARCHAR2 DEFAULT NULL,
   internal_destination_ IN  VARCHAR2 DEFAULT NULL )
IS
  attr_       VARCHAR2(32000);
  objid_      ROWID;
  objversion_ VARCHAR2(2000);
  newrec_     MATERIAL_REQUISITION_TAB%ROWTYPE;
  indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DUE_DATE', due_date_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', site_, attr_);
   Client_SYS.Add_To_Attr('INT_CUSTOMER_NO', int_customer_no_, attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', note_text_, attr_);
   Client_SYS.Add_To_Attr('DESTINATION_ID', destination_id_, attr_);
   Client_SYS.Add_To_Attr('INTERNAL_DESTINATION', internal_destination_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);   
   Insert___(objid_, objversion_, newrec_, attr_);
   order_class_ := Material_Requis_Type_API.Decode(newrec_.order_class);
   order_no_    := newrec_.order_no;
END New;


-- Is_Pre_Posting_Mandatory
--   The method calls Accounting Rules to find out if Mandatory Pre Posting
--   is activated on any code part for Material Requisition Headers within
--   a specific company. If mandatory pre posting is activated the method
--   returns the value 1 otherwise it returns 0.
FUNCTION Is_Pre_Posting_Mandatory (
   company_ IN VARCHAR2 ) RETURN NUMBER
IS
   code_a_flag_ NUMBER;
   code_b_flag_ NUMBER;
   code_c_flag_ NUMBER;
   code_d_flag_ NUMBER;
   code_e_flag_ NUMBER;
   code_f_flag_ NUMBER;
   code_g_flag_ NUMBER;
   code_h_flag_ NUMBER;
   code_i_flag_ NUMBER;
   code_j_flag_ NUMBER;
BEGIN
   Accounting_Codestr_API.Execute_Accounting(code_a_flag_,
                                             code_b_flag_,
                                             code_c_flag_,
                                             code_d_flag_,
                                             code_e_flag_,
                                             code_f_flag_,
                                             code_g_flag_,
                                             code_h_flag_,
                                             code_i_flag_,
                                             code_j_flag_,
                                             'MPC4',
                                             company_,
                                             'M109',
                                             'C58');
   IF (code_a_flag_ = 1) OR
      (code_b_flag_ = 1) OR
      (code_c_flag_ = 1) OR
      (code_d_flag_ = 1) OR
      (code_e_flag_ = 1) OR
      (code_f_flag_ = 1) OR
      (code_g_flag_ = 1) OR
      (code_h_flag_ = 1) OR
      (code_i_flag_ = 1) OR
      (code_j_flag_ = 1) THEN
      RETURN(1);
   ELSE
      RETURN(0);
   END IF;
END Is_Pre_Posting_Mandatory;


-- Get_Total_Value
--   Returns the total order value for all lines.
@UncheckedAccess
FUNCTION Get_Total_Value (
   order_class_   IN VARCHAR2,
   order_no_      IN VARCHAR2,
   line_modified_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_value_    NUMBER := 0;
   line_rec_       Material_Requis_Line_API.Public_Rec;
   order_class_db_ MATERIAL_REQUISITION_TAB.order_class%TYPE;
   po_order_no_    VARCHAR2(12);
   po_line_no_     VARCHAR2(4);
   po_rel_no_      VARCHAR2(4);
   purchase_type_  VARCHAR2(200);
   buy_unit_price_ NUMBER;
   line_qty_       NUMBER;
   rec_            MATERIAL_REQUISITION_TAB%ROWTYPE;

   CURSOR get_child_keys IS
      SELECT line_no, release_no, line_item_no, status_code
      FROM MATERIAL_REQUIS_LINE_TAB
      WHERE order_class = order_class_db_
      AND   order_no    = order_no_;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   rec_            := Get_Object_By_Keys___(order_class_db_, order_no_);
   total_value_    := rec_.total_value;
   IF (total_value_ IS NULL) OR (line_modified_ = 'TRUE')  THEN
      total_value_ :=0;

      FOR rec_ IN Get_Child_Keys LOOP
         line_rec_    := Material_Requis_Line_API.Get(order_class_db_, order_no_, rec_.line_no, rec_.release_no, rec_.line_item_no);
         IF (Inventory_Part_API.Check_Exist(line_rec_.contract, line_rec_.part_no)) THEN
            IF (rec_.status_code = '9') THEN

               total_value_ := total_value_ + Inventory_Transaction_Hist_API.Get_Sum_Value_Order_Line (
                                                                               order_type_api.decode('MTRL REQ'),
                                                                               order_no_,
                                                                               rec_.line_no,
                                                                               rec_.release_no,
                                                                               rec_.line_item_no,
                                                                               'M53',
                                                                               NULL,
                                                                               NULL,
                                                                               NULL,
                                                                               NULL,
                                                                               NULL)
                                            + Inventory_Transaction_Hist_API.Get_Sum_Value_Order_Line (
                                                                               order_type_api.decode('MTRL REQ'),
                                                                               order_no_,
                                                                               rec_.line_no,
                                                                               rec_.release_no,
                                                                               rec_.line_item_no,
                                                                               'M51',
                                                                               NULL,
                                                                               NULL,
                                                                               NULL,
                                                                               NULL,
                                                                               NULL);


            ELSE
               total_value_ := total_value_ + ((line_rec_.qty_due - line_rec_.qty_returned) * Inventory_Part_Unit_Cost_API.Get_Invent_Value_By_Condition(line_rec_.contract,
                                                                                                                                                         line_rec_.part_no,
                                                                                                                                                         '*',
                                                                                                                                                         line_rec_.condition_code));
            END IF;
         ELSE
            Material_Requis_Pur_Order_API.Get_Purchase_Link(po_order_no_,
                                                            po_line_no_,
                                                            po_rel_no_,
                                                            purchase_type_,
                                                            order_no_,
                                                            rec_.line_no,
                                                            rec_.release_no,
                                                            rec_.line_item_no,
                                                            order_class_);
            $IF Component_Purch_SYS.INSTALLED $THEN
               IF (purchase_type_ = 'O') THEN
                  line_qty_ := Purchase_Order_Line_API.Get_Buy_Qty_Due(po_order_no_, po_line_no_, po_rel_no_);
                  IF (line_qty_ != 0) THEN
                     buy_unit_price_ := Purchase_Order_Line_API.Get_Line_Total(po_order_no_, po_line_no_, po_rel_no_) / line_qty_;
                  ELSE
                     buy_unit_price_ := 0;
                  END IF;
               ELSE
                  line_qty_ := Purchase_Req_Line_Part_API.Get_Original_Qty(po_order_no_, po_line_no_, po_rel_no_);
                  IF (line_qty_ != 0) THEN
                     buy_unit_price_ := Purchase_Req_Line_Part_API.Get_Line_Total(po_order_no_, po_line_no_, po_rel_no_) /line_qty_;
                  ELSE
                     buy_unit_price_ := 0;
                  END IF;
               END IF;
            $ELSE
               buy_unit_price_ := 0;
            $END
          
            total_value_ := total_value_ + ((line_rec_.qty_due - line_rec_.qty_returned) * buy_unit_price_);
         END IF;
      END LOOP;
   END IF;
   RETURN (total_value_);
END Get_Total_Value;


-- Calendar_Changed
--   Change the due date of material requisitions that use a particular Calendar ID.
PROCEDURE Calendar_Changed (
   error_log_   OUT CLOB,
   calendar_id_ IN  VARCHAR2,
   contract_    IN  VARCHAR2 DEFAULT NULL )
IS
   work_day_        DATE;
   is_working_day_  NUMBER;
   attr_            VARCHAR2(2000);
   objid_           VARCHAR2(100);
   objversion_      VARCHAR2(300);
   info_            VARCHAR2(2000);
   error_msg_       VARCHAR2(2000);
   separator_       VARCHAR2(1) := CLIENT_SYS.text_separator_;

   CURSOR sites IS
        SELECT contract
          FROM site_public
         WHERE contract LIKE nvl(contract_,'%')
           AND   dist_calendar_id = calendar_id_;

   CURSOR get_record (local_contract_ VARCHAR2 ) IS
         SELECT order_class,
                order_no,
                contract,
                int_customer_no,
                status_code,
                date_entered,
                trunc(due_date) due_date
           FROM  MATERIAL_REQUISITION_TAB
          WHERE  contract = local_contract_
            AND  status_code NOT IN ('9');
   
   CURSOR get_child_keys( order_no_ VARCHAR2, order_class_ VARCHAR2) IS 
      SELECT line_no, release_no, line_item_no
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  order_class = order_class_
      AND    order_no    = order_no_;
   
BEGIN
   FOR site_rec IN sites LOOP
      FOR rec IN get_record(site_rec.contract) LOOP
         --Exception handling for calendar changes.
         BEGIN

            work_day_ := rec.due_date;
            is_working_day_ := Work_Time_Calendar_API.Is_Working_Day(calendar_id_,work_day_);

            IF (is_working_day_ = 0) THEN
               FOR line_key_rec IN get_child_keys(rec.order_no, rec.order_class) LOOP
                  IF material_requis_pur_order_api.Connected_To_Purchase_Order (rec.order_no,
                                                                                line_key_rec.line_no,
                                                                                line_key_rec.release_no,
                                                                                line_key_rec.line_item_no,
                                                                                rec.order_class) THEN
                     work_day_ := Work_Time_Calendar_API.Get_Next_Work_Day(calendar_id_, work_day_);
                     is_working_day_ := 1;
                     EXIT;
                  END IF;
               END LOOP;

               IF ( is_working_day_ = 0 ) THEN
                  work_day_ := Work_Time_Calendar_API.Get_Previous_Work_Day(calendar_id_, work_day_);
               END IF;
               
               IF (work_day_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'INVALIDDATE: Due date is not within current calendar.');
               END IF;
               
               objid_ := NULL;
               objversion_ := NULL;
               info_ := NULL;

               Get_Id_Version_By_Keys___ (objid_, objversion_, rec.order_class, rec.order_no);

               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('CONTRACT', rec.contract, attr_);
               Client_SYS.Add_To_Attr('INT_CUSTOMER_NO', rec.int_customer_no, attr_);
               Client_SYS.Add_To_Attr('STATUS_CODE_DB', rec.status_code, attr_);
               Client_SYS.Add_To_Attr('DATE_ENTERED', rec.date_entered, attr_);
               Client_SYS.Add_To_Attr('DUE_DATE', work_day_, attr_);
               Modify__ (info_, objid_, objversion_, attr_, 'DO' );
            END IF;

         EXCEPTION
            WHEN OTHERS THEN

               error_msg_ := Language_SYS.Translate_Constant(lu_name_, 
                                                            'CALCHG: Error while updating Material Requisition. Order No: :P1, ', 
                                                            Language_SYS.Get_Language, 
                                                            rec.order_no);
               error_msg_ := error_msg_ || Language_SYS.Translate_Constant(lu_name_, 
                                                                          'CALCHG2: Due Date: :P1.', 
                                                                          Language_SYS.Get_Language, 
                                                                          rec.due_date);
               
               error_msg_ := error_msg_ || ' ' || SQLERRM;

               --Remove call to Work_Time_Calendar_API , instead write to OUT parameter
               IF error_log_ IS NULL THEN
                  error_log_ := error_msg_ || separator_;
               ELSE
                  error_log_ := error_log_ || error_msg_ || separator_;
               END IF;
         END;
      END LOOP;
   END LOOP;
END Calendar_Changed;


-- Status_Change_Allowed
--   Checks if the status of the lines are ok for a status change in the header into Planned, Released or Stopped.
--   Used to enable commands in Aurena and in Check_Update___.
FUNCTION Status_Change_Allowed (
   order_class_db_ IN VARCHAR2,
   order_no_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_class_       MATERIAL_REQUISITION_TAB.order_class%TYPE;
   result_            VARCHAR2(5) := Fnd_Boolean_API.DB_TRUE;
   CURSOR get_child_keys IS
      SELECT line_no, release_no, line_item_no
      FROM MATERIAL_REQUIS_LINE_TAB
      WHERE order_class = order_class_db_
      AND order_no = order_no_;
BEGIN
   order_class_ := Material_Requis_Type_API.Decode(order_class_db_);
   FOR rec_ IN Get_Child_Keys LOOP
      IF NOT Material_Requis_Line_API.Check_Status(order_class_, order_no_, rec_.line_no, rec_.release_no, rec_.line_item_no ) THEN
         result_ := Fnd_Boolean_API.DB_FALSE;
         RETURN result_;
      END IF;
   END LOOP;
   RETURN result_;
END Status_Change_Allowed;

-- Print_Pick_List_Allowed
--   Checks if it is allowed to print pick list.
FUNCTION Print_Pick_List_Allowed (
   order_class_db_ IN VARCHAR2,
   order_no_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_class_       MATERIAL_REQUISITION_TAB.order_class%TYPE;
   result_            VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   CURSOR get_child_keys IS
      SELECT line_no, release_no, line_item_no, status_code, qty_assigned
      FROM MATERIAL_REQUIS_LINE_TAB
      WHERE order_class = order_class_db_
      AND order_no = order_no_;
BEGIN
   order_class_ := Material_Requis_Type_API.Decode(order_class_db_);
   IF (Get_Status_Code_Db(order_class_,order_no_) IN ('1','3','9')) THEN
      RETURN result_;
   END IF;
   FOR rec_ IN Get_Child_Keys LOOP
      IF (rec_.status_code = '5' OR rec_.qty_assigned > 0) THEN
         result_ := Fnd_Boolean_API.DB_TRUE;
         RETURN result_;
      END IF;
   END LOOP;
   RETURN result_;
END Print_Pick_List_Allowed;
