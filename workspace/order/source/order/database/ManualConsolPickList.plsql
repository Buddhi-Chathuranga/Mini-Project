-----------------------------------------------------------------------------
--
--  Logical unit: ManualConsolPickList
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191016  KiSalk  Bug 150541(SCZ-7450), In Finite_State_Add_To_Attr___, set the proper value instead of null variable for OBJSTATE of attr_.
--  151104  JeLise  LIM-4392, Removed checks on 'CUSTOMER ORDER PALLET PICK LIST' in Validate_Worker___ and Check_Insert___.
--  130813  MAHPLK  Increase the length of ORDER_NO, ROUTE_ID, PART_NO, SHIP_VIA_CODE, FORWARD_AGENT_ID, CUSTOMER_NO and LOCATION_GROUP.
--  121206  MAHPLK  Added private attribute storage_zone.
--  130312  IsSalk  Bug 108470, Modified Finite_State_Machine___() in order to change the status if there exists at least one connected line .
--  120320  MaRalk  Modified methods Unpack_Check_Insert___, Validate_Worker___ to validate warehouse worker groups task type.
--  120314  DaZase  Removed last TRUE parameter in Init_Method call inside Set_Created.
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  110202  Nekolk  EANE-3744  added where clause to View MANUAL_CONSOL_PICK_LIST.
--  091012  KiSalk Added Validate_Worker___.
--  090930  DaZase Added length on view comment for tier_no.
--  090127  KiSalk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Lines_Exist___ (
   rec_ IN MANUAL_CONSOL_PICK_LIST_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM customer_order_reservation_tab
      WHERE preliminary_pick_list_no = rec_.preliminary_pick_list_no;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN TRUE;
   END IF;
   CLOSE exist_control;
   RETURN FALSE;
END Lines_Exist___;


PROCEDURE Validate_Worker___ (
   newrec_ IN MANUAL_CONSOL_PICK_LIST_TAB%ROWTYPE )
IS
   order_pick_allowed_       BOOLEAN;
   order_pick_allowed_group_ BOOLEAN;
BEGIN
   Warehouse_Worker_API.Validate_Worker(newrec_.contract, newrec_.worker_id);
   order_pick_allowed_       := Warehouse_Worker_Task_Type_API.Is_Active_Worker(newrec_.contract, newrec_.worker_id, 'CUSTOMER ORDER PICK LIST');
   order_pick_allowed_group_ := Warehouse_Worker_Grp_Task_API.Is_Active_Worker_Group(newrec_.contract, newrec_.worker_group, 'CUSTOMER ORDER PICK LIST');
   
   IF NOT (order_pick_allowed_) THEN
      Error_SYS.Record_General('ManualConsolPickList','NOTASKTYPE: The Worker is not allowed to perform this Warehouse Task, see Warehouse Worker Task Type.');         
   END IF;

   IF NOT (order_pick_allowed_group_) THEN
      Error_SYS.Record_General('ManualConsolPickList','NOWAREHOUSEGRPTASK: The Worker Group is not allowed to perform this Warehouse Task, see Warehouse Worker Groups Task Type.');
   END IF;
END Validate_Worker___;


@Override
PROCEDURE Finite_State_Add_To_Attr___ (
   rec_  IN     MANUAL_CONSOL_PICK_LIST_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(rec_, attr_);
   Client_SYS.Add_To_Attr('OBJSTATE', rec_.rowstate, attr_);
END Finite_State_Add_To_Attr___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_         MANUAL_CONSOL_PICK_LIST_TAB.contract%TYPE;
BEGIN
   super(attr_);
   contract_ := USER_ALLOWED_SITE_API.Get_Default_Site;
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('WAREHOUSE', '%', attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', '%', attr_);
   Client_SYS.Add_To_Attr('PART_NO', '%', attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', '%', attr_);
   Client_SYS.Add_To_Attr('LOCATION_GROUP', '%', attr_);
   Client_SYS.Add_To_Attr('BAY_NO', '%', attr_);
   Client_SYS.Add_To_Attr('ROW_NO', '%', attr_);
   Client_SYS.Add_To_Attr('TIER_NO', '%', attr_);
   Client_SYS.Add_To_Attr('STORAGE_ZONE', '%', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT MANUAL_CONSOL_PICK_LIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   exist_    BOOLEAN := TRUE;
BEGIN
   IF (newrec_.preliminary_pick_list_no IS NULL) THEN
      WHILE (exist_) LOOP
         SELECT manual_consol_pick_list_seq.nextval
            INTO   newrec_.preliminary_pick_list_no
            FROM   DUAL;
         -- Check for the existing Mnual Consolidated Pick Lists
         exist_ := (Check_Exist___(newrec_.preliminary_pick_list_no));
      END LOOP;
   END IF;
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   Error_SYS.Check_Not_Null(lu_name_, 'PRELIMINARY_PICK_LIST_NO', newrec_.preliminary_pick_list_no);
   Client_SYS.Add_To_Attr('PRELIMINARY_PICK_LIST_NO', newrec_.preliminary_pick_list_no, attr_);
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT manual_consol_pick_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   order_pick_allowed_       BOOLEAN;
   order_pick_allowed_group_ BOOLEAN;
BEGIN
   super(newrec_, indrec_, attr_);
   order_pick_allowed_       := Warehouse_Worker_Task_Type_API.Is_Active_Worker(newrec_.contract, newrec_.worker_id, 'CUSTOMER ORDER PICK LIST');   
   order_pick_allowed_group_ := Warehouse_Worker_Grp_Task_API.Is_Active_Worker_Group(newrec_.contract, newrec_.worker_group, 'CUSTOMER ORDER PICK LIST');
   IF (newrec_.contract IS NOT NULL) THEN
      IF (newrec_.worker_id IS NOT NULL) THEN
         Warehouse_Worker_API.Validate_Worker(newrec_.contract, newrec_.worker_id);                   
         IF NOT (order_pick_allowed_) THEN
            Error_SYS.Record_General('ManualConsolPickList','NOTASKTYPE: The Worker is not allowed to perform this Warehouse Task, see Warehouse Worker Task Type.');         
         END IF;
      END IF;  
      
      IF (newrec_.worker_group IS NOT NULL) THEN
         IF NOT (order_pick_allowed_group_) THEN
            Error_SYS.Record_General('ManualConsolPickList','NOWAREHOUSEGRPTASK: The Worker Group is not allowed to perform this Warehouse Task, see Warehouse Worker Groups Task Type.');
         END IF;         
      END  IF;         
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     manual_consol_pick_list_tab%ROWTYPE,
   newrec_ IN OUT manual_consol_pick_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);   
   IF (newrec_.worker_id IS NOT NULL AND newrec_.contract IS NOT NULL) THEN      
      Validate_Worker___(newrec_);
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Print_Pick_Lists__
--   Print the pick lists for the manual consolidated pick list.
--   There may be several pick lists per manual consolidated pick list.
--   Returns 'TRUE if all pick lists printed; 'FALSE' otherwise.
PROCEDURE Print_Pick_Lists__ (
   preliminary_pick_list_no_ IN NUMBER )
IS
   pick_list_attr_ VARCHAR2(32000);
   CURSOR get_pick_list IS
      SELECT DISTINCT pick_list_no
      FROM   customer_order_reservation_tab
      WHERE  preliminary_pick_list_no = preliminary_pick_list_no_;
BEGIN

   -- Fetch the list of pick list no's connected to a manual consolidated pick list
   FOR rec_ IN get_pick_list LOOP
      Client_SYS.Add_To_Attr('PICK_LIST_NO', rec_.pick_list_no, pick_list_attr_);
   END LOOP;
   -- Print all the pick lists
   Customer_Order_Flow_API.Start_Print_Consol_Pl__(pick_list_attr_);
END Print_Pick_Lists__;


@UncheckedAccess
FUNCTION Pick_Lists_Printed__ (
   preliminary_pick_list_no_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   customer_order_reservation_tab cor, customer_order_pick_list_tab pl
      WHERE  pl.printed_flag = 'Y'
        AND  cor.pick_list_no = pl.pick_list_no
        AND  cor.preliminary_pick_list_no = preliminary_pick_list_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN('TRUE');
   END IF;
   CLOSE exist_control;
   RETURN('FALSE');
END Pick_Lists_Printed__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Lines_Exist
--   Returns 1 if connected lines exist; 0 otherwise.
@UncheckedAccess
FUNCTION Lines_Exist (
   preliminary_pick_list_no_ IN NUMBER ) RETURN NUMBER
IS
   lu_rec_ MANUAL_CONSOL_PICK_LIST_TAB%ROWTYPE;
BEGIN
   lu_rec_.preliminary_pick_list_no := preliminary_pick_list_no_;
   IF Lines_Exist___(lu_rec_) THEN 
      RETURN(1);
   ELSE
      RETURN(0);
   END IF;
END Lines_Exist;


-- Set_Created
--   A public interface for Create_Pick_List__ method.
PROCEDURE Set_Created (
   preliminary_pick_list_no_ IN NUMBER )
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, preliminary_pick_list_no_);   
   Create_Pick_List__(info_, objid_, objversion_, attr_, 'DO');

END Set_Created;

