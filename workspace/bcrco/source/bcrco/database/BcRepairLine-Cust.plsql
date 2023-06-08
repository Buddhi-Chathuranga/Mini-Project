-----------------------------------------------------------------------------
--
--  Logical unit: BcRepairLine
--  Component:    BCRCO
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
-----------------------------------------------------------------------------
--  230501  Buddhi  Initial Mini Project Develop
-----------------------------------------------------------------------------

layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
--(+)220615 SEBSA-BUDDHI MINIPROJECT(START)
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT bc_repair_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS         
   count_         NUMBER   := 0;
   check_part_    BOOLEAN;
   rl_id_         NUMBER;
   note_id_       bc_repair_line_tab.note_id%TYPE;
   temp_          NUMBER;
   line_state_    bc_repair_center_order_tab.rowstate%TYPE;
   
   CURSOR      get_row_state  IS
      SELECT   rowstate
      FROM     bc_repair_center_order_tab
      WHERE    rco_no   =  newrec_.rco_no;
   
   CURSOR      get_lines IS
      SELECT   repair_line_no
      FROM     bc_repair_line_tab
      WHERE    part_number = newrec_.part_number AND serial_no = newrec_.serial_no AND rco_no = newrec_.rco_no
      AND      rowstate NOT IN ('Shipped','Cancelled');
BEGIN
   
   OPEN     get_row_state;
   FETCH    get_row_state INTO line_state_;
   CLOSE    get_row_state;
   
   IF(line_state_ != 'Planned') THEN
      Error_SYS.Appl_General(lu_name_, 'Repair Order is '||line_state_||'. If You want Add Order Line, Order should be Planned. !');
   ELSE 
      
      super(newrec_, indrec_, attr_);
   
      rl_id_                  :=    Get_Repair_Line_Id__(newrec_.rco_no);
      newrec_.repair_line_no  :=   (rl_id_+1);

      temp_                   :=    Note_Id_Sequence.NEXTVAL;
      note_id_                :=    CONCAT('NOTEID-',TO_CHAR(temp_));
      newrec_.note_id         :=    note_id_;

      FOR line_ IN get_lines
      LOOP
         count_ := count_ + 1;
      END LOOP;

      IF (count_ > 0) THEN
            Error_SYS.Appl_General(lu_name_, 'Part Number : '|| newrec_.part_number||' ,Serial Number : '|| newrec_.serial_no || ' is lready Used');
      END IF;

--      check_part_ :=  Check_Part_Is_Used___(newrec_);
--      IF (check_part_   =  FALSE) THEN
--         Error_SYS.Appl_General(lu_name_,'Part Number : '|| newrec_.part_number||' is Already Used !');
--      END IF;
   END IF;
END Check_Insert___;



@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   rcono_         NUMBER;
   site_          bc_repair_line_tab.repair_site%TYPE;
   
BEGIN
   
   rcono_   :=    Client_SYS.Get_Item_Value('RCO_NO',attr_);
   site_    :=    Get_Default_Site__(rcono_);
  
   super(attr_);

   Client_SYS.Add_To_Attr('DATE_ENTERED',             sysdate,                                              attr_);
   Client_SYS.Add_To_Attr('REQUIRED_START',           sysdate,                                              attr_);
   Client_SYS.Add_To_Attr('REPAIR_SITE',              site_,                                                attr_);
   Client_SYS.Add_To_Attr('BILLABLE_OR_WARRANTY',     'Billable',                                           attr_);
   Client_SYS.Add_To_Attr('MANUFACTURER_WARRANTY_DB', Fnd_Boolean_API.Encode('False') ,                     attr_);
   Client_SYS.Add_To_Attr('REPAIR_WARRANTY_DB',       Fnd_Boolean_API.Encode('False') ,                     attr_);
   Client_SYS.Add_To_Attr('CONDITION_CODE',           Condition_Code_API.Get_Default_Condition_Code() ,     attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_         OUT      VARCHAR2,
   objversion_    OUT      VARCHAR2,
   newrec_        IN OUT   bc_repair_line_tab%ROWTYPE,
   attr_          IN OUT   VARCHAR2 )
IS

BEGIN
      
   super(objid_, objversion_, newrec_, attr_);
   
   Bc_Log_Info_API.Create_Log_Info__(newrec_, 'Create New Repair Center Order Line.');
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN       VARCHAR2,
   oldrec_     IN       bc_repair_line_tab%ROWTYPE,
   newrec_     IN OUT   bc_repair_line_tab%ROWTYPE,
   attr_       IN OUT   VARCHAR2,
   objversion_ IN OUT   VARCHAR2,
   by_keys_    IN       BOOLEAN DEFAULT FALSE )
IS

BEGIN
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   Bc_Log_Info_API.Create_Log_Info__(newrec_, 'Update Repair Center Order.');
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN bc_repair_line_tab%ROWTYPE )
IS
BEGIN
   
   Bc_Log_Info_API.Create_Log_Info__(remrec_, 'Delete');
   super(objid_, remrec_);
   
END Delete___;



@Override
PROCEDURE Finite_State_Machine___ (
   rec_   IN OUT bc_repair_line_tab%ROWTYPE,
   event_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS

BEGIN
   
   super(rec_, event_, attr_);
   
   IF(rec_.rowstate != 'New') THEN
      Bc_Log_Info_API.Create_Log_Info__(rec_, CONCAT('Change State to .',rec_.rowstate));
   END IF;
END Finite_State_Machine___;


--start repair center order
PROCEDURE Repair_Order_Start___ (
   rec_     IN OUT NOCOPY bc_repair_line_tab%ROWTYPE,
   attr_    IN OUT NOCOPY VARCHAR2 )
IS
   CURSOR      get_order  IS
      SELECT   * 
      FROM     bc_repair_center_order_tab
      WHERE    rco_no = rec_.rco_no;
   
   rec_order_  bc_repair_center_order_tab%ROWTYPE;
BEGIN
   
   OPEN     get_order;
   FETCH    get_order INTO rec_order_;
   CLOSE    get_order;
   
   Bc_Repair_Center_Order_API.Repair_Center_Order_Start__(rec_order_);
END Repair_Order_Start___;

--return truue, If all lene are not in repair compleate and cancelled
PROCEDURE Compleate_Rco___ (
   rec_     IN OUT NOCOPY bc_repair_line_tab%ROWTYPE,
   attr_    IN OUT NOCOPY VARCHAR2 )
IS
   CURSOR      get_lines IS
      SELECT   repair_line_no, rowstate
      FROM     bc_repair_line_tab
      WHERE    rco_no = rec_.rco_no;
   
   is_complete_   VARCHAR2(5)        := 'TRUE';
BEGIN

   FOR line_ IN get_lines
      LOOP
      IF ((line_.rowstate != 'RepairCompleted' AND line_.rowstate != 'Cancelled') AND line_.repair_line_no != rec_.repair_line_no) THEN
         is_complete_ := 'FALSE';
      END IF;
   END LOOP;
      
   IF (is_complete_ = 'TRUE') THEN
      Bc_Repair_Center_Order_API.Set_State_Complete_(rec_.rco_no);
   END IF;
END Compleate_Rco___;


--check rco cancel
PROCEDURE Check_Rco_Cancel___ (
   rec_     IN OUT NOCOPY   bc_repair_line_tab%ROWTYPE,
   attr_    IN OUT NOCOPY   VARCHAR2 )
IS
   CURSOR      get_lines IS
      SELECT   repair_line_no, rowstate
      FROM     bc_repair_line_tab
      WHERE    rco_no = rec_.rco_no;
      
   CURSOR      get_line_for_cancel IS
      SELECT   repair_line_no, rowstate
      FROM     bc_repair_line_tab
      WHERE    rco_no = rec_.rco_no;
   
   is_complete_   VARCHAR2(5)        := 'TRUE';
   cancel_        VARCHAR2(5)        := 'FALSE';
BEGIN
   FOR line_ IN get_lines
   LOOP
      IF (line_.rowstate != 'Cancelled' AND line_.repair_line_no != rec_.repair_line_no) THEN
         cancel_ := 'TRUE';
      END IF;
   END LOOP;
   
   IF (cancel_ = 'FALSE' ) THEN
      Bc_Repair_Center_Order_API.Set_Order_State_Cancel_(rec_.rco_no);
   END IF;
   
   FOR line_ IN get_line_for_cancel
      LOOP
      IF ((line_.rowstate != 'RepairCompleted' AND line_.rowstate != 'Cancelled') AND line_.repair_line_no != rec_.repair_line_no) THEN
         is_complete_ := 'FALSE';
      END IF;
   END LOOP;
      
   IF (is_complete_ = 'TRUE') THEN
      Bc_Repair_Center_Order_API.Set_State_Complete_(rec_.rco_no);
   END IF;
END Check_Rco_Cancel___;


--check rco is released or started
FUNCTION Check_Order_Released___ (
   rec_  IN     bc_repair_line_tab%ROWTYPE ) RETURN BOOLEAN
IS
   state_   bc_repair_center_order.state%TYPE;
BEGIN

   state_   :=    Bc_Repair_Center_Order_API.Get_State(rec_.rco_no);
   
   IF( state_ = 'Released' OR state_ = 'Started' ) THEN
      IF(rec_.quantity = rec_.quantity_received) THEN
         RETURN TRUE;
      ELSE
         Error_SYS.Appl_General(lu_name_, 'The quantity should be equal quantity received!');
      END IF;
   END IF;
   Error_SYS.Appl_General(lu_name_, 'Please Release The '|| rec_.rco_no || ' Order !');
   RETURN FALSE;
END Check_Order_Released___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
--Returning the maximum number of repair line ID per given repair center order
FUNCTION Get_Repair_Line_Id__ (
   repair_center_order_     IN     bc_repair_line_tab.rco_no%TYPE)   RETURN   NUMBER
IS 
   CURSOR      get_max_count IS
      SELECT   NVL(MAX(t.REPAIR_LINE_NO),0) 
      FROM     bc_repair_line_tab t
      WHERE    t.rco_no  =  repair_center_order_;
      
   max_   NUMBER :=  0;
BEGIN
   
   OPEN get_max_count;
   FETCH get_max_count INTO max_;
   CLOSE get_max_count;
      
	RETURN   max_;  
END Get_Repair_Line_Id__;


--Returning the site of repair line ID per given repair center order
FUNCTION Get_Default_Site__ (
   repair_center_order_     IN    bc_repair_center_order_tab.rco_no%TYPE) RETURN bc_repair_line_tab.REPAIR_SITE%TYPE
IS
   
   CURSOR   get_site IS
      SELECT   CONTRACT 
      FROM     bc_repair_center_order_tab t
      WHERE    t.rco_no = repair_center_order_;
   
   site_    bc_repair_line_tab.repair_site%TYPE;
BEGIN
   
   OPEN  get_site;
   FETCH get_site INTO site_;
   CLOSE get_site;

	RETURN   site_;
END Get_Default_Site__;


--Cancel State
PROCEDURE Cancel_Line__ (
   rco_no_  IN OUT NOCOPY bc_repair_center_order_tab.rco_no%TYPE )
IS
   CURSOR      get_lines IS
      SELECT   * 
      FROM     bc_repair_line_tab
      WHERE    rco_no = rco_no_;
BEGIN
   FOR line_ IN get_lines
      LOOP
         Finite_State_Set___(line_,'Cancelled');
   END LOOP;
END Cancel_Line__;


--change state TO shipped
PROCEDURE Change_To_Shipped__ (
   rco_no_  bc_repair_center_order.rco_no%TYPE)
IS
   CURSOR      get_lines IS
      SELECT   * 
      FROM     bc_repair_line_tab
      WHERE    rco_no = rco_no_;
      
BEGIN
   FOR line_ IN get_lines
      LOOP
         Finite_State_Set___(line_,'Shipped');
      END LOOP;
      
   Bc_Repair_Center_Order_API.Set_Order_State_Close_(rco_no_);
END Change_To_Shipped__;


--create customer order
PROCEDURE Re_Order_Id___ (
   rec_ IN bc_repair_line_tab%ROWTYPE)
IS
   CURSOR      get_lines IS
      SELECT   * 
      FROM     bc_repair_line_tab
      WHERE    rec_.rco_no = rco_no;
      
   line_ bc_repair_line_tab%ROWTYPE;
   count_ NUMBER :=   0;
   info_           VARCHAR2(2000);
   objversion_     VARCHAR2(2000);
   attr_           VARCHAR2(2000);
BEGIN
   
   OPEN get_lines; 
   LOOP 
   FETCH get_lines into line_; 
      EXIT WHEN get_lines%notfound;
      count_   :=  count_   +  1;
      Client_SYS.Add_To_Attr('REPAIR_LINE_NO',     count_,       attr_);
      Modify__(info_, line_.rowkey, objversion_, attr_, 'DO');
   END LOOP; 
   CLOSE get_lines; 
END Re_Order_Id___;


--check part is already used
FUNCTION Check_Part_Is_Used___ (
   rec_  IN  bc_repair_line_tab%ROWTYPE) RETURN BOOLEAN
IS
   CURSOR      get_count IS
      SELECT   NVL(COUNT(*),0) 
      FROM     bc_repair_line_tab
      WHERE    rec_.part_number = part_number AND rowstate != 'Cancelled';
      
   count_   NUMBER;
BEGIN
   
	OPEN  get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   
   IF (count_ = 0 )   THEN
      RETURN   TRUE;
   END IF;
   
   RETURN FALSE;
END Check_Part_Is_Used___;

--(+)220615 SEBSA-BUDDHI MINIPROJECT(FINSH)
 