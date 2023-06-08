-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220525  SEBSA-SUPULI   SA_TRA_1_09_10-1- MPL: Override Check_Common___, new function C_Get_Rolls_Count
--  220401  SEBSA-SUPULI   SA_TRA_1.04.03-Selection_of_sub_lots-1;Override Update,Added new methods.
--  220401  SEBSA-SUPULI   SA_TRA_1.04.03-Selection_of_sub_lots-1;Created
-----------------------------------------------------------------------------

layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Start)
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_order_line_tab%ROWTYPE,
   newrec_ IN OUT customer_order_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   -- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Start)
   $IF (Component_Partca_SYS.INSTALLED) $THEN
   c_theo_length_per_roll_    part_catalog_tab.c_theoretical_length%TYPE := 0;
   c_theo_width_per_roll_     part_catalog_tab.c_width%TYPE := 0;
   $END 
   -- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Finish)
BEGIN

   super(oldrec_, newrec_, indrec_, attr_);
   -- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Start)
   $IF (Component_Partca_SYS.INSTALLED) $THEN
   c_theo_length_per_roll_ := Part_Catalog_API.Get_C_Theoretical_Length(newrec_.catalog_no);
   c_theo_width_per_roll_  := Part_Catalog_API.Get_C_Width(newrec_.catalog_no);
   -- change sales qty if rolls sales qty is modified 
   IF (newrec_.c_rolls_sales_qty IS NOT NULL) AND (indrec_.c_rolls_sales_qty) AND (Validate_SYS.Is_Changed(oldrec_.c_rolls_sales_qty, newrec_.c_rolls_sales_qty)) 
                         AND Part_Catalog_API.Get_C_Mpl_Part_Db(newrec_.part_no) = 'TRUE'THEN                       
      IF c_theo_width_per_roll_ > 0 AND c_theo_length_per_roll_ > 0 THEN 
         newrec_.buy_qty_due := newrec_.c_rolls_sales_qty * c_theo_length_per_roll_ * c_theo_width_per_roll_;
      ELSE
         Error_SYS.Record_General(lu_name_, 'CROLLSSALESQTY: Width or Length values are missing in Mater Part to calculate Sales Qty');
      END IF;
   END IF;
   $END
   IF (newrec_.buy_qty_due IS NOT NULL) AND (indrec_.buy_qty_due) AND (Validate_SYS.Is_Changed(oldrec_.buy_qty_due, newrec_.buy_qty_due)) AND newrec_.c_rolls_sales_qty IS NOT NULL THEN
      newrec_.c_rolls_sales_qty := NULL;
   END IF;
   -- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Finish)
END Check_Common___;
-- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Finish)




--(+) 220401  SEBSA-SUPULI   SA_TRA_1.04.03-1 (Start)
@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOMER_ORDER_LINE_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOMER_ORDER_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   --(+) 220401  SEBSA-SUPULI   SA_TRA_1.04.03-1 (Start)  
   IF (oldrec_.qty_assigned != newrec_.qty_assigned OR oldrec_.desired_qty != newrec_.desired_qty)THEN 
      
      IF (newrec_.c_free_over_del_enabled = Fnd_Boolean_API.DB_TRUE)THEN
         IF (newrec_.qty_assigned > newrec_.desired_qty)THEN
         
            IF ( C_Check_Order_Line_Disc(newrec_.order_no,newrec_.line_no,newrec_.rel_no,newrec_.line_item_no)) THEN
               --if discount line already created - modify 
               --modify
              C_Modify_Discount_Line(newrec_.order_no,newrec_.line_no,newrec_.rel_no,newrec_.line_item_no,newrec_.qty_assigned ,newrec_.desired_qty);
               
            ELSE
               --if no discount line created yet --create
               C_Create_New_Discount_Line(newrec_.order_no,newrec_.line_no,newrec_.rel_no,newrec_.line_item_no,newrec_.qty_assigned ,newrec_.desired_qty);
            END IF;
         
         ELSIF (newrec_.qty_assigned <= newrec_.desired_qty)THEN 
            --delete discount line
            C_Remove_Discount_Line(newrec_.order_no,newrec_.line_no,newrec_.rel_no,newrec_.line_item_no);
            
         END IF;
         
      END IF;
   END IF;
   --(+) 220401  SEBSA-SUPULI   SA_TRA_1.04.03-1 (Finish)
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

END Update___;


@Override
PROCEDURE Do_Set_Qty_Picked___ (
   rec_  IN OUT CUSTOMER_ORDER_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
  -- Error_SYS.record_general('suwclk','test'||rec_.order_no||rec_.line_no||rec_.rel_no||rec_.line_item_no||rec_.rowstate||rec_.contract||rec_.part_no);
   IF C_Check_Reservation(rec_.order_no,rec_.line_no,rec_.rel_no,rec_.line_item_no,rec_.rowstate,rec_.contract,rec_.part_no)THEN 
       Error_SYS.Record_General(lu_name_, 'CRESERROR: Reservation of half a lot is not allowed for this product. Please review Manual Reservations for Customer Order Line.');
   END IF;
   super(rec_, attr_);

END Do_Set_Qty_Picked___;


@Override
PROCEDURE Do_Set_Qty_Shipped___ (
   rec_  IN OUT CUSTOMER_ORDER_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   IF C_Check_Reservation(rec_.order_no,rec_.line_no,rec_.rel_no,rec_.line_item_no,rec_.rowstate,rec_.contract,rec_.part_no)THEN 
      Error_SYS.Record_General(lu_name_, 'CRESERROR: Reservation of half a lot is not allowed for this product. Please review Manual Reservations for Customer Order Line.');
   END IF;
   super(rec_, attr_);
   --Add post-processing code here
END Do_Set_Qty_Shipped___;

--(+) 220401  SEBSA-SUPULI   SA_TRA_1.04.03-1 (Finish)

--(+) 220401  SEBSA-SUPULI   SA_TRA_1.04.03-1 (Start)
-- Check Order Line Discount Exists
FUNCTION C_Check_Order_Line_Disc(
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER)RETURN BOOLEAN
IS
   dummy_  VARCHAR2(1);
   $IF Component_Discom_SYS.INSTALLED $THEN
   free_del_discount_tpe_  Site_Discom_Info_Tab.C_Free_Del_Disc_Type%TYPE;
   $END
   CURSOR check_discount_lines IS
      SELECT 1
      FROM Cust_Order_Line_Discount_Tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND discount_type = free_del_discount_tpe_;
      
BEGIN
 $IF Component_Discom_SYS.INSTALLED $THEN
 free_del_discount_tpe_  := Site_Discom_Info_API.Get_C_Free_Del_Disc_Type(Customer_Order_API.Get_Contract(order_no_));
 $END
 --one line contains only one discount line for free over delivery
 OPEN  check_discount_lines;
 FETCH check_discount_lines INTO dummy_;
 CLOSE check_discount_lines;
 
   IF dummy_ IS NULL THEN
      RETURN FALSE;
   ELSE
      RETURN TRUE;
   END IF;
   
    
END C_Check_Order_Line_Disc;

PROCEDURE C_Create_New_Discount_Line(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   reserved_qty_ IN NUMBER,
   desired_qty_  IN  NUMBER
   )
IS
   $IF Component_Discom_SYS.INSTALLED $THEN
   free_del_discount_tpe_  Site_Discom_Info_Tab.C_Free_Del_Disc_Type%TYPE;
   $END
   disc_line_no_ NUMBER;
   discount_ NUMBER;
   
   CURSOR get_discount_line_no IS
   SELECT NVL(MAX(DISCOUNT_LINE_NO),0)
   FROM CUST_ORDER_LINE_DISCOUNT
   WHERE ORDER_NO = order_no_ AND
         LINE_NO = line_no_ AND
         REL_NO = rel_no_ AND
         LINE_ITEM_NO = line_item_no_; 
BEGIN
   
   OPEN get_discount_line_no;
   FETCH get_discount_line_no INTO disc_line_no_;
   CLOSE get_discount_line_no;
   $IF Component_Discom_SYS.INSTALLED $THEN   
   free_del_discount_tpe_  := Site_Discom_Info_API.Get_C_Free_Del_Disc_Type(Customer_Order_API.Get_Contract(order_no_));
   
   discount_ := ((reserved_qty_- desired_qty_)/reserved_qty_)*100 ;
   IF free_del_discount_tpe_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'CFREEDELDISCTYPE: An Over Delivery Discount Type should be defined in the site before enabling Free Over Delivery.');
   END IF;
   $END
   Cust_Order_Line_Discount_API.New(order_no_, line_no_, rel_no_, line_item_no_, free_del_discount_tpe_, discount_, 'MANUAL', 'NOT PARTIAL SUM', disc_line_no_ + 1, '', '', '', '', '', '');
   Customer_Order_Line_API.Modify_Discount__(order_no_, line_no_, rel_no_, line_item_no_, discount_, 'TRUE');
END C_Create_New_Discount_Line;


-- Get Free Over Delivery Dicount Line
PROCEDURE C_Get_Order_Line_Disc___(
   objid_        OUT VARCHAR2,
   objversion_   OUT VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER)
IS
   $IF Component_Discom_SYS.INSTALLED $THEN
   free_del_discount_tpe_  Site_Discom_Info_Tab.C_Free_Del_Disc_Type%TYPE;
   $END
   CURSOR check_discount_lines IS
      SELECT objid, objversion
      FROM Cust_Order_Line_Discount
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND discount_type = free_del_discount_tpe_;
      
BEGIN
 $IF Component_Discom_SYS.INSTALLED $THEN
 free_del_discount_tpe_  := Site_Discom_Info_API.Get_C_Free_Del_Disc_Type(Customer_Order_API.Get_Contract(order_no_));
 $END
 --one line contains only one discount line for free over delivery
 OPEN  check_discount_lines;
 FETCH check_discount_lines INTO objid_,objversion_;
 CLOSE check_discount_lines;
 
    
END C_Get_Order_Line_Disc___;


PROCEDURE C_Modify_Discount_Line(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   reserved_qty_ IN NUMBER,
   desired_qty_  IN  NUMBER
   )
IS
   attr_         VARCHAR2(2000);
   info_         VARCHAR2(1000);
   objid_        VARCHAR2(20);
   objversion_   VARCHAR2(50);
BEGIN
   C_Get_Order_Line_Disc___(objid_,objversion_,order_no_,line_no_,rel_no_,line_item_no_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', ((reserved_qty_-desired_qty_)/reserved_qty_)*100 , attr_);   
   Cust_Order_Line_Discount_API.Modify__(info_, objid_, objversion_,attr_,'DO');
END C_Modify_Discount_Line;


PROCEDURE C_Remove_Discount_Line(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER
   )
IS
   info_         VARCHAR2(1000);
   objid_        VARCHAR2(20);
   objversion_   VARCHAR2(50);
BEGIN
   C_Get_Order_Line_Disc___(objid_,objversion_,order_no_,line_no_,rel_no_,line_item_no_);
   IF C_Check_Order_Line_Disc(order_no_,line_no_,rel_no_,line_item_no_)THEN 
      Cust_Order_Line_Discount_API.Remove__(info_, objid_, objversion_,'DO');
   END IF;
   
END C_Remove_Discount_Line;

FUNCTION C_Check_Reservation(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   state_        IN VARCHAR2,
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2)RETURN BOOLEAN
IS
   dummy_  VARCHAR2(1);
   
   CURSOR check_reservation_lines IS
      SELECT 1
      FROM single_manual_reservation t
      WHERE source_ref1 = order_no_
      AND source_ref2 = line_no_
      AND source_ref3 = rel_no_
      AND source_ref4 = line_item_no_
      AND source_qty_reserved IS NOT NULL
      AND source_qty_reserved != qty_onhand;

BEGIN

 OPEN  check_reservation_lines;
 FETCH check_reservation_lines INTO dummy_;
 CLOSE check_reservation_lines;

 IF state_ = 'Reserved' AND Inventory_Part_API.Get_C_Complete_Reservation_Db(contract_, part_no_)= Fnd_Boolean_API.DB_TRUE THEN 
   IF dummy_ IS NOT NULL THEN
      RETURN TRUE;
   END IF;
END IF;
   
RETURN FALSE;

END C_Check_Reservation;
--(+) 220401  SEBSA-SUPULI   SA_TRA_1.04.03-1 (Finish)
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Start)
FUNCTION C_Get_Rolls_Count(
   sales_qty_ IN NUMBER,
   part_no_   IN VARCHAR2) RETURN NUMBER
IS
   $IF (Component_Partca_SYS.INSTALLED) $THEN
   c_theo_length_per_roll_ part_catalog_tab.c_theoretical_length%TYPE:=0;
   c_theo_width_per_roll_  part_catalog_tab.c_width%TYPE:=0;
   $END
   no_of_rolls_            NUMBER:= 0 ;
BEGIN
   $IF (Component_Partca_SYS.INSTALLED) $THEN
   IF Part_Catalog_API.Get_C_Mpl_Part_Db(part_no_) = 'TRUE' THEN   
      c_theo_length_per_roll_ := Part_Catalog_API.Get_C_Theoretical_Length(part_no_);
      c_theo_width_per_roll_  := Part_Catalog_API.Get_C_Width(part_no_);
     
      IF sales_qty_ >= 0 AND c_theo_length_per_roll_ > 0 AND c_theo_width_per_roll_ > 0 THEN 
         no_of_rolls_ := (sales_qty_/(c_theo_length_per_roll_ * c_theo_width_per_roll_));
         IF instr(no_of_rolls_,'.') > 0  THEN 
            no_of_rolls_ := TRUNC(no_of_rolls_)+1;
         END IF;
      END IF;
   
   END IF;
   $END 
   RETURN no_of_rolls_;
END C_Get_Rolls_Count;
-- (+) 220525  SEBSA-SUPULI   SA_TRA_1_09_10-1(Finish)

-------------------- LU CUST NEW METHODS -------------------------------------
