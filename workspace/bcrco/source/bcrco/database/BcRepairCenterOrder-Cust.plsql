-----------------------------------------------------------------------------
--
--  Logical unit: BcRepairCenterOrder
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
PROCEDURE Prepare_Insert___ (
   attr_    IN OUT   VARCHAR2 )
IS
   user_id_  VARCHAR2(300);
   currency_ VARCHAR2(3);
   site_     VARCHAR2(5);
BEGIN
   
   
   user_id_ :=    Fnd_Session_API.Get_Fnd_User;
   site_    :=    User_Allowed_Site_API.Get_Default_Site(user_id_);
   currency_:=    Company_Finance_API.Get_Currency_Code(Site_API.Get_Company(site_));
   
   super(attr_);
   
   Client_SYS.Add_To_Attr('DATE_CREATED',    sysdate,       attr_);
   Client_SYS.Add_To_Attr('REPORTED_BY',     user_id_,      attr_);
   Client_SYS.Add_To_Attr('CONTRACT',        site_,         attr_);
   Client_SYS.Add_TO_Attr('CURRENCY',        currency_ ,    attr_); 
END Prepare_Insert___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT bc_repair_center_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   temp_    NUMBER;
BEGIN
   
   IF (newrec_.rco_no IS NULL) THEN
      temp_          :=    Rco_Id_Sequence.NEXTVAL;
      newrec_.rco_no :=  temp_;
   END IF;
   
   super(newrec_, indrec_, attr_);

END Check_Insert___;


--Change order statues to cancel for the given order
PROCEDURE Cancel_Lines___ (
   rec_  IN OUT NOCOPY bc_repair_center_order_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   
BEGIN
   Bc_Repair_Line_API.Cancel_Line__(rec_.rco_no);
END Cancel_Lines___;


--Change all order line statues to cancel for the given order
PROCEDURE Cancel_Order__ (
   rco_no_  IN OUT NOCOPY bc_repair_center_order_tab.rco_no%TYPE )
IS
   CURSOR      get_lines_ IS
      SELECT   * 
      FROM     bc_repair_center_order_tab
      WHERE    rco_no = rco_no_;
BEGIN
   FOR order_ IN get_lines_
      LOOP
         Finite_State_Set___(order_,'Cancelled');
   END LOOP;
END Cancel_Order__;


--Check all lines are compleated
FUNCTION Enable_Create_Order___ (
   rec_  IN     bc_repair_center_order_tab%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR get_compleate_line_cout IS
      SELECT   NVL(COUNT(rco_no),0) 
      FROM     bc_repair_line_tab
      WHERE    (ROWSTATE='RepairCompleted' OR ROWSTATE='Cancelled') AND rco_no = rec_.rco_no;
   
   compleate_count_ NUMBER    := 0;
   line_count_ NUMBER         := 0;
BEGIN
   
   OPEN     get_compleate_line_cout; 
   LOOP 
      FETCH    get_compleate_line_cout  into  compleate_count_; 
   END LOOP; 
   CLOSE    get_compleate_line_cout;
   
   line_count_ :=  Get_Line_Count(rec_);
   
   IF(compleate_count_=line_count_) THEN
      RETURN TRUE;
   END IF;
   
   Error_SYS.Appl_General(lu_name_, 'All Cusoter Order List must be Repair Compleated !');
   
   RETURN FALSE;
END Enable_Create_Order___;


--Change Rco started to sta
PROCEDURE Repair_Center_Order_Start__ (
   rco_  IN OUT NOCOPY bc_repair_center_order_tab%ROWTYPE )
IS 
BEGIN
   Finite_State_Set___(rco_,'Started');
END Repair_Center_Order_Start__;


--Check order has more than zero line
FUNCTION Check_Repair_Line_Count___ (
   rec_  IN     bc_repair_center_order_tab%ROWTYPE ) RETURN BOOLEAN
IS
   count_   NUMBER;
BEGIN
   
   count_ := Get_Line_Count(rec_);
   
   IF(count_ = 0) THEN
      Error_SYS.Appl_General(lu_name_, 'This repair center order does not have any repair lines !');
      RETURN FALSE;
   ELSE
      RETURN TRUE;
   END IF;
END Check_Repair_Line_Count___;


--Check Line cancell or shipped
FUNCTION Check_Lines_Can_Or_Shi___ (
   rec_  IN     bc_repair_center_order_tab%ROWTYPE ) RETURN BOOLEAN
IS
   CURSOR      get_lines_ IS
      SELECT   * 
      FROM     bc_repair_line_tab
      WHERE    rco_no = rec_.rco_no;
   
   line_       bc_repair_line_tab%ROWTYPE;
BEGIN
  OPEN      get_lines_; 
   LOOP 
   FETCH    get_lines_  into  line_; 
      IF(line_.rowstate = 'Cancelled' OR line_.rowstate = 'Shipped') THEN
         RETURN TRUE;
      ELSE
         Error_SYS.Appl_General(lu_name_, 'Repair Center Order Line should be Cancelled or Shipped');
         RETURN FALSE;
      END IF;
   END LOOP; 
   CLOSE    get_lines_;
END Check_Lines_Can_Or_Shi___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
--Updste order no 
PROCEDURE Modify_Record (
   rco_no_      IN    NUMBER,
   order_no_    IN    VARCHAR2  )
IS  
   rec_         bc_repair_center_order_tab%ROWTYPE;
BEGIN
   
   rec_                    := Get_Object_By_Keys___(rco_no_);     
   rec_.customer_order_no  := order_no_;
      
   Modify___(rec_);
END Modify_Record;


--Change the state to compleated for the given repaie center order
PROCEDURE Set_State_Complete_ (
   rco_no_  IN    bc_repair_line_tab.rco_no%TYPE )
IS
   order_rec_     bc_repair_center_order_tab%ROWTYPE;
   
   CURSOR      Get_Repair_Order IS
      SELECT   *
      FROM     bc_repair_center_order_tab
      WHERE    rco_no = rco_no_;
BEGIN
   
   OPEN  Get_Repair_Order;
   FETCH Get_Repair_Order  INTO   order_rec_;
   
   Finite_State_Set___(order_rec_,'Completed');
   
   CLOSE Get_Repair_Order;
END Set_State_Complete_;


--change state to cancel
PROCEDURE Set_Order_State_Cancel_ (
   rco_no_  IN OUT NOCOPY bc_repair_center_order_tab.rco_no%TYPE )
IS
   CURSOR      get_orders_ IS
      SELECT   * 
      FROM     bc_repair_center_order_tab
      WHERE    rco_no = rco_no_;
BEGIN
   FOR order_ IN get_orders_
      LOOP
         Finite_State_Set___(order_,'Cancelled');
   END LOOP;
END Set_Order_State_Cancel_;


--set state to close
PROCEDURE Set_Order_State_Close_ (
   rco_no_  IN bc_repair_center_order_tab.rco_no%TYPE )
IS
   CURSOR      get_orders_ IS
      SELECT   * 
      FROM     bc_repair_center_order_tab
      WHERE    rco_no = rco_no_;
BEGIN
   FOR order_ IN get_orders_
      LOOP
         Finite_State_Set___(order_,'Closed');
   END LOOP;
END Set_Order_State_Close_;


--get line count for the given rco no
FUNCTION Get_Line_Count (
   rec_  IN     bc_repair_center_order_tab%ROWTYPE ) RETURN NUMBER
IS
   CURSOR   count_line   IS
      SELECT   NVL(COUNT(rco_no),0) 
      FROM     bc_repair_line_tab
      WHERE    rco_no = rec_.rco_no;
   line_count_     NUMBER;
BEGIN
	
   OPEN count_line;
   FETCH count_line INTO line_count_; 
   CLOSE count_line;
   
	RETURN line_count_;
END Get_Line_Count;


-------------------- LU CUST NEW METHODS -------------------------------------
--check order id is already used
FUNCTION Check_Order_Id___ (
   rco_no_ IN NUMBER) RETURN BOOLEAN
IS
BEGIN

   IF(Bc_Repair_Center_Order_API.Exists(rco_no_)) THEN
      Error_SYS.Appl_General(lu_name_, ' Order Number is already Exist !');
      RETURN FALSE;
   END IF;
   RETURN TRUE;
END Check_Order_Id___;
--(+)220615 SEBSA-BUDDHI MINIPROJECT(FINSH)