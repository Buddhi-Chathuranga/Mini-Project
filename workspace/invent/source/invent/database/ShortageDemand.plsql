-----------------------------------------------------------------------------
--
--  Logical unit: ShortageDemand
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191002  SURBLK   Added Add_Qty_Reserved_Info___ to handle error messages and avoid code duplication.
--  160816  JoAnSe   STRMF-13895, Removed obsoleted parameter in call to Shop_Material_Alloc_API.Reserve_Line in Reserve_Shortage_Part
--  160225  MaEelk   STRSC-524, Calling shortage demand views  were made dynamic inside the business logic.
--  140731  MeAblk   Removed parameter activity_seq_ from the method Calculate_Order_Shortage_Qty and removed some not relavent code lines.
--  140617  AyAmlk   Bug 117440, Modified Calculate_Order_Shortage_Qty() by removing qty_avail_ deduction so that 
--  140617           the shortage is calculated correctly.
--  130802  ChJalk   TIBE-905, Removed the global variable inst_CustomerOrder_.
--  111028  NISMLK   SMA-285, Increased eng_chg_level_ length to CHAR(6) in Reserve_Shortage_Part method.
--  110812  PraWlk   Bug 96784, Modified Get_Shortage_Qty() by adding new parameter activity_seq_. 
--  110317  Umdolk  Added SHORTAGE_DEMAND_UIV.
--  ----------------------- Blackbird Merge End -----------------------------
--  110214  Nuwklk   Merge Blackbird Code
--  100610  SuThlk   BB08: Added view MAINT_ORDER_MATR_SHORTAGE.
--  ----------------------- Blackbird Merge Start ----------------------------- 
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to VIEW_PART.
--  100819  Asawlk   Bug 91487, Added new method Clear_Shortage__() which will clear inventory part shortages 
--  100819           for customer orders, work orders, material requisitions and shop orders.
--  100505  KRPELK   Merge Rose Method Documentation.
--  100106  MaEelk   Replaced the obsolete method call Shop_Material_Alloc_Int_API.Reserve_Line 
--  100106           with Shop_Material_Alloc_API.Reserve_Line in Reserve_Shortage_Part.
--  091203  KiSalk  Changed backorder option value 'NO PARTIAL DELIVERIES' to 'NO PARTIAL DELIVERIES ALLOWED'.
--  091203  KiSalk   Changed backorder option value 'NO PARTIAL DELIVERIES' to 'NO PARTIAL DELIVERIES ALLOWED'.
--  090930  ChFolk   Removed unused globle variable inst_Project_.
--  -------------------------------- 14.0.0 ---------------------------------
--  080703  Prawlk   Bug 73198, Bug 73198, Used CHR(31) as the separating character for the keys used for objid in 
--  080703           SHORTAGE_DEMAND_BY_PART view.
--  080303  NiBalk   Bug 72023, Restructured Shortage_Exists, to have a single return and to close the cursors.
--  070912  MaJalk   Added activity_seq_ as a parameter and modified Calculate_Order_Shortage_Qty.
--  070511  NiDalk   Modified Calculate_Order_Shortage_Qty.
--  061117  NaLrlk   Changes allow_backorders to backorder_option in Check_Backorder.
--  061109  MiErlk   Bug 59639, Added an info parameter and information messages to Reserve_Shortage_Part  
--  060830           when not possible to reserve full quantity for Material Requisition and Work Order. 
--  060720  RoJalk   Centralized Part Desc - Use Inventory_Part_API.Get_Description.
--  060601  RoJalk   Enlarge Part Description - Changed view comments.
--  060524  JOHESE   Added columns project_id, activity_seq and project_sourced to views SHORTAGE_DEMAND and SHORTAGE_DEMAND_BY_PART and
--                   function Get_Shortage_Qty
--  --------------------------------- 13.4.0 --------------------------------
--  060124  NiDalk   Added Assert safe annotation.
--  050921  NiDalk   Removed unused variables.
--  050905  NuFilk   Changed substrb to substr in SHORTAGE_DEMAND_BY_PART view.
--  050627  NaLrlk   Bug 125308, Added the acitivty_seq and project_id as parameters in the call Work_Order_Part_API.Make_Reservation_Detail.
--  050627  KanGlk   Bug 50900, Modified INV_PART_TAB to TAB_INV_PART.
--  050519  KaDilk   Bug 50900, Modified the views SHORTAGE_DEMAND_INV_PART and SHORTAGE_DEMAND to improve the performance.
--  041105  KaDilk   Bug 45027, Added columns part_ownership,condition code,owning_customer_no and
--  041105           owning_vendor_no to views SHORTAGE_DEMAND and SHORTAGE_DEMAND_BY_PART.
--  041105           Added function Get_Shortage_Qty.
--  040920  JOHESE   Modified call to Inventory_Part_In_Stock_API.Get_Avail_Plan_Qty_Loc_Type
--  040129  NaWalk   Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  031015  KiSalk   Applied LCS Bug 39552, In Calculate_Order_Shortage_Qty, shortage flag check
--  031015            made by Inventory_Part_APIGet_Shortage_Flag_Db.
--  031014  PrJalk   Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  030730  MaEelk   Performed SP4 Merge.
--  030623  MaGulk   Modified Calculate_Order_Shortage_Qty, replaced calls to Inventory_Part_In_Stock_API.Get_Plannable_Qty_Onhand and
--  030623           Inventory_Part_In_Stock_API.Get_Plannable_Qty_Reserved with Inventory_Part_In_Stock_API.Get_Avail_Plan_Qty_Loc_Type
--  030203  ANJPLK   Bug 34734, Added Procedure Check_Backorder and Modified function
--                   Calculate_Order_Shortage_Qty. Added Global LU constant
--                   inst_CustomerOrder_.
--  030122  AGZIPL   Added condition in Reserve_Shortage_Part procedure
--  001219  JOHESE   Removed check in Reserve_Shortage_Part and changed the call to
--                   Reserve_Customer_Order_API.Reserve_Line_From_Shortage
--  001211  PaLj     Added view SHORTAGE_DEMAND_INV_PART and function Shortage.
--                   Create a objid through concatinating with 'a' (garantees unique objid).
--  000925  JOHESE   Added undefines.
--  000831  JOHESE   Changed INVENTORY_PART_LOCATION_API calls to INVETORY_PART_IN_STOCK_API
--  990910  ANHO     Added General_SYS.Init_Method in Reserve_Shortage_Part.
--  990528  SHVE     Added a parameter to Make_line_Reservations so as not to perform
--                   availibility check for material requisitions.
--  990420  JOHW     General performance improvements.
--  990412  JOHW     Upgraded to performance optimized template.
--  980121  FRDI     Clean up conection to Purchase requisition, exeption.
--  980120  FRDI     Clean up conection to Purchase requisition. +Clean up comment
--  980112  JOHO     Restructuring of shop order
--  971202  GOPE     Upgrade to fnd 2.0
--  970731  PHDE     Used Gen_Yes_No_Allowed_API.Get_Db_Value(0) condition in
--                   Calculate_Order_Shortage_Qty.
--  970728  JOMU     Added check to  Reserve_Shortage_Part requiring that qty_to_reserve
--                   be NOT NULL.
--  970724  NAVE     Changes to Reserve_Shortage_Part: call WO_Order_Line_API.
--                   Make_Reservation_Detail instead of Make_Issue_Detail. Needed
--                   Get_Client_Value to evaluate order_type_ being passed in.
--  970723  JOMU     Added Calculate_Order_Shortage_Qty method.
--  970721  JOMU     Added dynamic calls to reservation methods in Reserve_Shortage_Part.
--  970707  NAVE     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Add_Qty_Reserved_Info___(
   qty_reserved_ NUMBER )
   IS
   BEGIN
      Client_SYS.Add_Info(lu_name_, 'MRRESERVEDQTY: Only :P1 could be reserved.', qty_reserved_);
   END Add_Qty_Reserved_Info___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Clear_Shortage__ (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   release_no_     IN VARCHAR2,
   line_item_no_   IN NUMBER,
   order_type_     IN VARCHAR2,
   order_class_    IN VARCHAR2 )
IS
   stmt_           VARCHAR2(2000); 
   order_type_db_  VARCHAR2(20);
BEGIN

   order_type_db_ := Order_Supply_Demand_Type_API.Encode(order_type_);
   IF (order_type_db_='0') THEN
      stmt_ := 'BEGIN 
                   Shop_Material_Alloc_API.Modify_Qty_Short(:order_no,
                                                            :line_no,
                                                            :release_no,
                                                            :line_item_no,
                                                            0);
                END;';
                          
      @ApproveDynamicStatement(2010-08-19,Asawlk)
      EXECUTE IMMEDIATE stmt_
         USING IN order_no_,
               IN line_no_,
               IN release_no_,
               IN line_item_no_;
   
   ELSIF (order_type_db_='1') THEN
      stmt_ := 'BEGIN
                   Customer_Order_Line_API.Set_Qty_Short(:order_no,
                                                         :line_no,
                                                         :release_no,
                                                         :line_item_no,
                                                         0);
                END;';
      @ApproveDynamicStatement(2010-08-19,Asawlk)
      EXECUTE IMMEDIATE stmt_
         USING IN order_no_,
               IN line_no_,
               IN release_no_,
               IN line_item_no_;
   
   ELSIF (order_type_db_='3') THEN
      Material_Requis_Line_API.Modify_Qty_Short(order_class_,
                                                order_no_,
                                                line_no_,
                                                release_no_,
                                                line_item_no_,
                                                0);
   ELSIF (order_type_db_='6') THEN
      stmt_ := 'BEGIN
                   Maint_Material_Req_Line_API.Set_Qty_Short(:wo_no,
                                                             :line_item_no,
                                                             0);
                END;';
      @ApproveDynamicStatement(2010-08-19,Asawlk)
      EXECUTE IMMEDIATE stmt_
         USING IN TO_NUMBER(order_no_),
               IN line_item_no_;

   ELSE
      Error_SYS.Record_General(lu_name_,'ORDER_TYPE_NOT_SUPPORTED: Order type :P1 is not supported in this operation.', order_type_);
   END IF;
END Clear_Shortage__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Shortage_Qty
--   Return the total shortage quantity for a specific inventory contract/part
--   This method will be used to get the shortage quantity for a demand based on
--   part no, contract,condition code,part ownership,owning customer and owning vendor.
@UncheckedAccess
FUNCTION Get_Shortage_Qty (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   activity_seq_  IN NUMBER DEFAULT NULL) RETURN NUMBER
IS
   total_shortage_ NUMBER :=0 ;
   CURSOR get_total_shortage IS
      SELECT SUM(qty_short)
      FROM SHORTAGE_DEMAND
      WHERE CONTRACT      = contract_
        AND PART_NO       = part_no_
        AND (ACTIVITY_SEQ = activity_seq_ OR activity_seq_ IS NULL);
BEGIN
   OPEN get_total_shortage;
   FETCH get_total_shortage INTO total_shortage_;
   CLOSE get_total_shortage;
   RETURN(total_shortage_);
END Get_Shortage_Qty;



-- Get_Shortage_Qty
--   Return the total shortage quantity for a specific inventory contract/part
--   This method will be used to get the shortage quantity for a demand based on
--   part no, contract,condition code,part ownership,owning customer and owning vendor.
@UncheckedAccess
FUNCTION Get_Shortage_Qty (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   condition_code_     IN VARCHAR2,
   part_ownership_     IN VARCHAR2,
   owning_customer_no_ IN VARCHAR2,
   owning_vendor_no_   IN VARCHAR2,
   project_id_         IN VARCHAR2,
   activity_seq_       IN NUMBER) RETURN NUMBER
IS
   qty_shortage_ NUMBER :=0;
   char_null_    VARCHAR2(12) := 'VARCHAR2NULL';

   CURSOR get_shortage_qty IS
      SELECT SUM (qty_short)
      FROM   SHORTAGE_DEMAND
      WHERE  contract        = contract_
      AND    part_no         = part_no_
      AND    part_ownership  = part_ownership_
      AND    NVL(condition_code,     char_null_) = NVL(condition_code_,     char_null_)
      AND    NVL(owning_customer_no, char_null_) = NVL(owning_customer_no_, char_null_)
      AND    NVL(owning_vendor_no,   char_null_) = NVL(owning_vendor_no_,   char_null_)
      AND    NVL(project_id,         char_null_) = NVL(project_id_,         char_null_)
      AND    (activity_seq = activity_seq_ OR activity_seq_ IS NULL);
BEGIN
   OPEN  get_shortage_qty;
   FETCH get_shortage_qty INTO qty_shortage_;
   CLOSE get_shortage_qty;
   RETURN (qty_shortage_);
END Get_Shortage_Qty;



@UncheckedAccess
FUNCTION Shortage_Exists (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_shortage_ NUMBER;
   temp_           NUMBER := 0;
   CURSOR getshort IS
      SELECT count(*)
      FROM   SHORTAGE_DEMAND
      WHERE  PART_NO  = part_no_
      AND    CONTRACT = contract_;

BEGIN
   IF part_no_ IS NOT NULL THEN
      OPEN getshort;
      FETCH getshort INTO found_shortage_;
      IF (getshort%FOUND) THEN
         temp_ := found_shortage_;
      END IF;
      CLOSE getshort;
   END IF;
   RETURN temp_;
END Shortage_Exists;



-- Reserve_Shortage_Part
--   A public reservation method for dynamic calls to all other order types.
--   This method will call public reservation methods in MaterialRequisitionLine,
--   ShopMaterialAlloc, CustomerOrderLine and WorkOrderLine
PROCEDURE Reserve_Shortage_Part (
   info_ OUT VARCHAR2,
   order_type_     IN VARCHAR2,
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   release_no_     IN VARCHAR2,
   line_item_no_   IN NUMBER,
   order_class_    IN VARCHAR2,
   qty_to_reserve_ IN NUMBER )
IS
   stmt_              VARCHAR2(2000);
   dummy_return_qty_  NUMBER;
   qty_reserved_      NUMBER;
   date_to_reserve_   CHAR(1);
   do_analys_         CHAR(1);
   print_picklist_    CHAR(1);
   location_no_       CHAR(1);
   lot_batch_no_      CHAR(1);
   serial_no_         CHAR(1);
   eng_chg_level_     CHAR(6);
   waiv_dev_rej_no_   CHAR(1);
   activity_seq_      NUMBER;
   handling_unit_id_  NUMBER;
   project_id_        VARCHAR2(10);

BEGIN

   IF qty_to_reserve_ IS NULL THEN
      Error_Sys.Record_General('ShortageDemand','NOQTY: Must specify a quantity to reserve.');
   END IF;
   IF qty_to_reserve_ < 0 THEN
      Error_Sys.Record_General('ShortageDemand','NEGQTY: Quantity to reserve cannot be negative.');
   ELSIF qty_to_reserve_ = 0 THEN
      RETURN;
   END IF;

    --Shop Material Alloc
   IF order_type_ = Order_Supply_Demand_Type_API.Decode('0') THEN
      stmt_ := 'BEGIN Shop_Material_Alloc_API.Reserve_Line(
                 :order_no
               , :line_no
               , :release_no
               , :line_item_no
               , :date_to_reserve
               , :do_analys
               , :print_picklist
               , :qty_to_reserve); END;';

      @ApproveDynamicStatement(2006-01-24,nidalk)
      EXECUTE IMMEDIATE stmt_
                  USING IN order_no_,
                        IN line_no_,
                        IN release_no_,
                        IN line_item_no_,
                        IN date_to_reserve_,
                        IN do_analys_,
                        IN print_picklist_,
                        IN qty_to_reserve_;

   ELSIF order_type_ = Order_Supply_Demand_Type_API.Decode('1') THEN /* Customer Order Line */

      stmt_ := 'BEGIN Reserve_Customer_Order_API.Reserve_Line_From_Shortage(
                  :order_no,
                  :line_no,
                  :release_no,
                  :line_item_no,
                  :qty_to_reserve); END;';

      @ApproveDynamicStatement(2006-01-24,nidalk)
      EXECUTE IMMEDIATE stmt_
                  USING IN order_no_,
                        IN line_no_,
                        IN release_no_,
                        IN line_item_no_,
                        IN qty_to_reserve_ ;


   ELSIF order_type_ = Order_Supply_Demand_Type_API.Decode('3') THEN /* Material Requisition Line */
      Material_Requis_Line_API.Make_Line_Reservations(
        dummy_return_qty_
      , order_class_
      , order_no_
      , line_no_
      , release_no_
      , line_item_no_
      , qty_to_reserve_
      ,'N' );

      IF (dummy_return_qty_ > 0) THEN
         qty_reserved_ := qty_to_reserve_ - dummy_return_qty_;
         Add_Qty_Reserved_Info___(qty_reserved_);
      END IF;


   ELSIF order_type_ = Order_Supply_Demand_Type_API.Decode('6') THEN /* Work Order Line */
             
      $IF Component_Wo_SYS.INSTALLED $THEN
         project_id_   := Active_Work_Order_API.Get_Project_No (order_no_);
         activity_seq_ := Active_Work_Order_API.Get_Activity_Seq (order_no_);
         Maint_Material_Req_Line_API.Make_Reservation_Invent(dummy_return_qty_,
                                                             to_number(order_no_),
                                                             line_item_no_,
                                                             location_no_,
                                                             lot_batch_no_,
                                                             serial_no_,
                                                             eng_chg_level_,
                                                             waiv_dev_rej_no_,
                                                             activity_seq_,
                                                             handling_unit_id_,
                                                             project_id_,
                                                             qty_to_reserve_);  
      $END 


      IF (dummy_return_qty_ > 0) THEN
         qty_reserved_ := qty_to_reserve_ - dummy_return_qty_;
         Add_Qty_Reserved_Info___(qty_reserved_);
      END IF;
   ELSE
      NULL; /* All other order supply type values fall through */
   END IF;

   info_ := Client_SYS.Get_All_Info;

END Reserve_Shortage_Part;


-- Calculate_Order_Shortage_Qty
--   To be run after reservations have been made for an order line. Pass in
--   the original qty required, current qty reserved and current qty issued
--   (or any other deductions from the requirement.  Returns the QtyShort
--   calculated based upon these numbers. If shortage functionality is not
--   implemented for the system or part, returns 0.  Method evaluates the
--   quantities and onhand availability for the part/contract.
@UncheckedAccess
FUNCTION Calculate_Order_Shortage_Qty (
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   qty_required_  IN NUMBER,
   qty_reserved_  IN NUMBER,
   qty_issued_    IN NUMBER ) RETURN NUMBER
IS
BEGIN
   IF ((MPCCOM_System_Parameter_API.Get_parameter_value1('SHORTAGE_HANDLING') = 'Y')
       AND (Inventory_Part_API.Get_Shortage_Flag_Db(contract_,part_no_) = 'Y')) THEN
         RETURN greatest(qty_required_ - qty_reserved_ - qty_issued_, 0);
   ELSE
      RETURN 0;
   END IF;
END Calculate_Order_Shortage_Qty;



-- Shortage
--   Returns 1 if there is any shortage for a specific inventory part ELSE return 0
@UncheckedAccess
FUNCTION Shortage (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   shortage_ NUMBER;
   temp_           NUMBER := 0;
   
   CURSOR getshortage IS
      SELECT 1
      FROM   SHORTAGE_DEMAND
      WHERE  PART_NO  = part_no_
      AND    CONTRACT = contract_;
BEGIN
   IF part_no_ IS NOT NULL THEN
      OPEN getshortage;
      FETCH getshortage INTO shortage_;
      IF (getshortage%FOUND) THEN
         temp_ := shortage_;
      END IF;
      CLOSE getshortage;
   END IF;
   RETURN temp_;
END Shortage;



-- Check_Backorder
--   To be used from the client to check whether other order is back order
--   allowed and if not allowed then will display a warning.
PROCEDURE Check_Backorder (
   info_       IN OUT VARCHAR2,
   order_no_   IN     VARCHAR2,
   order_type_ IN     VARCHAR2,
   qty_short_  IN     NUMBER,
   qty_assign_ IN     NUMBER )
IS   
   backorder_option_  VARCHAR2(40);
BEGIN

IF Order_Supply_Demand_Type_API.Encode(order_type_)='1' THEN
   $IF Component_Order_SYS.INSTALLED $THEN   
       backorder_option_ :=Customer_Order_API.Get_Backorder_Option_Db(order_no_);   
   $END

   IF (backorder_option_= 'NO PARTIAL DELIVERIES ALLOWED') AND (qty_short_ > qty_assign_) THEN
       Client_SYS.Add_Info(lu_name_,'BACORDNALLOW: Partial Deliveries not allowed for order :P1 . Partial reservation not allowed.', order_no_ );
   END IF;
END IF;
info_ := Client_SYS.Get_All_Info;
END Check_Backorder;



