-----------------------------------------------------------------------------
--
--  Logical unit: ScrappingCause
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  170505  KhVese  STRSC-7900, Modified method Create_Data_Capture_Lov() to only fetch Active causes.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  141217  TAORSE  Added Enumerate_Db method
--  140728  BudKlk  Bug 117726, Added a new method Create_Data_Capture_Lov() in order to enable lov for the Scrapping cause.
--  120525  JeLise  Made description private.
--  120507  JeLise  Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120507          in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507          was added. Get_Reject_Message and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  101101  KAYOLK  Refactored the code for removing the TERMINAL_CODE column from the SCRAPPING_CAUSE_TAB table.
--  100430  Ajpelk  Merge rose method documentation
--  ----------------------- 14.0.0 -------------------------------------------
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  -----------------------------Version 13.3.0--------------------------------
--  000925  JOHESE  Added undefines.
--  000418  NISOSE  Added General_SYS.Init_Method in Get_Control_Type_Value_Desc,
--                  Modify_Reject_Message, New_Reject_Reason and Remove_Reject_Reason.
--  990824  FRDI    Bug Fix 8674: Created overloading method for Get_By_Terminal_Code.
--  990426  DAZA    General performance improvements.
--  990412  FRDI    Upgraded to performance optimized template.
--  981211  JOHW    Removed call to OpQuantityCode.
--  981205  JOHW    Added attribute TerminalCode and Exist_Check_Terminal_Code
--                  and Get_By_Terminal_Code
--  980417  FRDI    Adding description to batch prcesses.
--  971121  TOOS    Upgrade to F1 2.0
--  970805  DAAN    Added condition for New___, Modify___ and Remove___.
--  970509  PEKR    Added transfer of new scrapcodes to TIME.
--  970509  ANHO    Added code to Modify_Reject_Message, New_Reject_Reason and
--                  Remove_Reject_Reason.
--  970508  FRMA    Added Get_Control_Type_Value_Desc.
--  970428  PEKR    Added Modify_Reject_Message, New_Reject_Reason and
--                  Remove_Reject_Reason.
--  970313  MAGN    Changed tablename reject_list to scrapping_cause_tab.
--  970226  MAGN    Uses column rowversion as objversion(timestamp).
--  961215  JOKE    Modified with new workbench default templates and
--                  removed get_reject_message procedure.
--  960311  SHVE    Changed LU Name PurRejectList.
--  951108  SHVE    Created a procedure for the function Get_Reject_Message
--  951012  SHR     Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

separator_  CONSTANT VARCHAR2(1)  := Client_SYS.field_separator_;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Reject_Message
--   Fetches the RejectMessage attribute for a record.
@UncheckedAccess
FUNCTION Get_Reject_Message (
   reject_reason_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ scrapping_cause_tab.reject_message%TYPE;
BEGIN
   IF (reject_reason_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      reject_reason_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT reject_message
      INTO  temp_
      FROM  scrapping_cause_tab
      WHERE reject_reason = reject_reason_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(reject_reason_, 'Get_Reject_Message');
END Get_Reject_Message;

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
   description_ := Get_Reject_Message(value_);
END Get_Control_Type_Value_Desc;


-- Enumerate
--   Returns a list of reject reasons.
@UncheckedAccess
PROCEDURE Enumerate (
   lu_conn_list_ OUT VARCHAR2 )
IS
   list_ VARCHAR2(2000);
   CURSOR getlu IS
      SELECT reject_reason
      FROM   SCRAPPING_CAUSE_TAB;
BEGIN
   FOR met IN getlu LOOP
      list_ := list_||met.reject_reason||separator_;
   END LOOP;
   lu_conn_list_ := list_;
END Enumerate;

--Enumerate_Db
@UncheckedAccess
PROCEDURE Enumerate_Db (
   lu_conn_list_ OUT VARCHAR2)
IS
   list_ VARCHAR2(2000);
   CURSOR getlu IS
      SELECT reject_reason
      FROM   SCRAPPING_CAUSE_TAB;   
BEGIN
   FOR met IN getlu LOOP
      list_ := list_ || met.reject_reason|| separator_;
   END LOOP;
   lu_conn_list_ := list_;
END Enumerate_Db;

-- Exist_Check
--   Used for check if an instance of the object exists.
PROCEDURE Exist_Check (
  ret_           OUT VARCHAR2,
  reject_reason_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(reject_reason_)) THEN
      ret_ :='FALSE';
      Error_SYS.Record_Not_Exist(lu_name_);
   ELSE
      ret_ :='TRUE';
   END IF;

END Exist_Check;


-- New_Reject_Reason
--   Creating new reject reasons from public.
PROCEDURE New_Reject_Reason (
   reject_reason_ IN VARCHAR2,
   reject_message_ IN VARCHAR2 )
IS
   attr_           VARCHAR2(2000);
   newrec_         SCRAPPING_CAUSE_TAB%ROWTYPE;
   objid_          ROWID;
   objversion_     VARCHAR2(2000);
   indrec_         Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('REJECT_REASON', reject_reason_, attr_);
   Client_SYS.Add_To_Attr('REJECT_MESSAGE', reject_message_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New_Reject_Reason;


-- Modify_Reject_Message
--   Modifying reject_message for a reject_reason.
PROCEDURE Modify_Reject_Message (
   reject_reason_  IN VARCHAR2,
   reject_message_ IN VARCHAR2 )
IS
   attr_           VARCHAR2(2000);
   newrec_         SCRAPPING_CAUSE_TAB%ROWTYPE;
   oldrec_         SCRAPPING_CAUSE_TAB%ROWTYPE;
   objid_          ROWID;
   objversion_     VARCHAR2(2000);
   indrec_         Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(reject_reason_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('REJECT_REASON', reject_reason_, attr_);
   Client_SYS.Add_To_Attr('REJECT_MESSAGE', reject_message_, attr_);
   newrec_ := oldrec_;   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Reject_Message;


-- Remove_Reject_Reason
--   Deleting a reject_reason.
PROCEDURE Remove_Reject_Reason (
   reject_reason_ IN VARCHAR2 )
IS
   remrec_         SCRAPPING_CAUSE_TAB%ROWTYPE;
   objid_          ROWID;
   objversion_     VARCHAR2(2000);
BEGIN
   remrec_ := Get_Object_By_Keys___(reject_reason_);
   Get_Id_Version_By_Keys___(objid_,objversion_,reject_reason_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_Reject_Reason;


-- This method is used by DataCaptScrapHandlUnit, DataCaptScrapInvPart, DataCapProcessHuShip and DataCapProcessPartShip
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   capture_session_id_ IN NUMBER)
IS
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;

   CURSOR get_scrap_causes IS
      SELECT reject_reason, reject_message
      FROM   SCRAPPING_CAUSE_TAB
      WHERE  rowstate = 'Active'
      ORDER BY Utility_SYS.String_To_Number(reject_reason) ASC, reject_reason ASC;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      FOR lov_rec_ IN get_scrap_causes LOOP         
         Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                          capture_session_id_    => capture_session_id_,
                                          lov_item_value_        => lov_rec_.reject_reason,
                                          lov_item_description_  => Get_Reject_Message(lov_rec_.reject_reason),
                                          lov_row_limitation_    => lov_row_limitation_,    
                                          session_rec_           => session_rec_);
         EXIT WHEN exit_lov_;
      END LOOP;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


