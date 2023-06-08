-----------------------------------------------------------------------------
--
--  Logical unit: CustomerConsignmentStock
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200713  JaThlk  Bug 151033(SCZ-7893), Added new parameter addr_no_ to the method Decrease_Consignment_Stock_Qty and passed it to the method call 
--  200713          Inventory_Part_At_Customer_API.Decrease_Our_Qty_At_Customer.
--  190930  SURBLK  Added Raise_Qty_Less_Zero_Error___ to handle error messages and avoid code duplication.
--  181021  BudKlk  Bug 144009, Modified the method Decrease_Consignment_Stock_Qty() to update the cost of Customer_Order_Delivery_TAB from the transaction cost value in order to calculate invoice sales statistics correctly.
--  171208  KHVESE  STRSC-14829, Added parameter validate_hu_struct_position_ to interface of method Increase_Consignment_Stock_Qty and modified method accordingly.
--  171031  KHVESE  STRSC-9352, Modified method Check_Insert___ and Check_Update___ to remove validation for Invent_Part_Cost_Level.
--  171029  KHVESE  STRSC-9352, Modified method Prepare_Insert___ to set ALLOW_AGGREGATED_REPORTING_DB.
--  171004  KHVESE  STRSC-9352, Modified method Get_Consignment_Stock_Qty and added more parameters (inv part stock keys) to methods Increase_Consignment_Stock_Qty, Decrease_Consignment_Stock_Qty.
--  170823  niedlk  SCUXX-558, Added B2B_USER_ENABLE_OPERATIONS to the attr string in Prepare_Insert___.
--  170314  MeAblk  Bug 134044, Modified Decrease_Consignment_Stock_Qty() to create the outstandingsales record after creating the inventory transaction.
--  150812  MAHPLK  KES-1081, Added new parameter deliv_no_ to Increase_Consignment_Stock_Qty() and Decrease_Consignment_Stock_Qty().
--  150529  JeLise  LIM-2983, Added dummy_number_ instead of 0 for handling_unit_id in Increase_Consignment_Stock_Qty and
--  150529          in Decrease_Consignment_Stock_Qty.
--  130624  UdGnlk  EBALL-94, Modified Decrease_Consignment_Stock_Qty() hence a parameter add to Decrease_Our_Qty_At_Customer(). 
--  130610  AwWelk  EBALL-98, Modified Decrease_Consignment_Stock_Qty() method according to the added parameters for 
--  130610          Decrease_Our_Qty_At_Customer().
--  130426  Asawlk  EBALL-37, Added more parameters to Increase_Consignment_Stock_Qty() and Decrease_Consignment_Stock_Qty()
--  130426          to gain better encapsulation.
--  130408  Asawlk  EBALL-37, Moved attribute consignment_stock_qty to InventoryPartAtCustomer LU. Also removed 
--  130408          Get_Sum_Consignment_Stock_Qty(), Is_Invent_Part_In_Consignment() and Modify_Consignment_Stock_Qty().
--  130408          Added methods Increase_Consignment_Stock_Qty() and Decrease_Consignment_Stock_Qty().
--  130128  CPriLK  Modified the where condition of exist_control of Is_Invent_Part_In_Consignment and calculate_sum Of Get_Sum_Consignment_Stock_Qty.
--  120126  ChJalk  Modified the view comments of consignment_stock in the base view.
--  110131  Nekolk  EANE-3744  added where clause to View CUSTOMER_CONSIGNMENT_STOCK.
--  100514  Ajpelk  Merge rose merthod documentation
--  --------------------------Eagle------------------------------------------
--  060516  MiErlk  Enlarge Identity - Changed view comment
--  060418  SaRalk  Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  060131  LaBolk  Bug 55778, Modified Check_Delete___ to raise an error and stop the deletion
--  060131          if there are consignment enabled CO lines which are yet to be delivered.
--  060220  IsAnlk  Added function Get_Consignment_Stock_Db.  
--  060131  LaBolk  Bug 55778, Modified Check_Delete___ to raise an error and stop the deletion
--  060131          if there are consignment enabled CO lines which are yet to be delivered.
--  060110  CsAmlk  Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  050125  ErFelk  Bug 49004, Modified Unpack_Check_Insert___ to raise an error message if the customer is an Internal one
--  050125          which belongs to the same company as the site.
--  040218  IsWilk  Removed the SUBSTRB from the views for Unicode Changes.
--  -----------------EDGE Package Group 3 Unicode Changes--------------------------------------
--  030729  JaJalk  Performed SP4 Merge.
--  030618  DAYJLK  Replaced calls to Procedure Inventory_Part_API.Get_Weighted_Average_Level_Db
--  030618          with Get_Invent_Part_Cost_Level_Db belonging to the same package in Unpack_Check_Insert___ and
--  030618          Unpack_Check_Update___. Modified error messages NOCONSFORCONDI and NOCONSFORCONDU.
--  020827  LEPESE  Added public method Is_Invent_Part_In_Consignment.
--                  Removed method Get_For_CC. Inserted validation in unpack_check_update___.
--  020805  ANLASE  Added method Get_for_CC for to enable check in invpart.apy.
--                  Added check for weighted_average_level in Unpack_Check_Insert___.
--  ******************************** Takeoff ( Baseline)******************************
--  020506  MAJO    Bug 37048, Improved performance in Get_Sum_Consignment_Stock_Qty.
--  001219  JoEd    Added check on configured parts - they are not allowed.
--  ---------------------- 13.0 ---------------------------------------------
--  991007  JoEd  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  ---------------------- 11.1 ---------------------------------------------
--  990520  JakH  CID 17584 Checked to avoid negative order quantities.
--  990416  RaKu  Y.Cleanup.
--  990412  PaLj  YOSHIMURA - New Template
--  981214  RaKu  Added function Get_Sum_Consignment_Stock_Qty.
--  981126  RaKu  Modifyed check for catalog_type in Unpack_Check_Insert___.
--  980915  RaKu  Added check so packages can not be used together with consignment stock.
--  980910  RaKu  Added procedure Modify_Consignment_Stock_Qty.
--  980907  RaKu  Created
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
   Client_SYS.Add_To_Attr('CONSIGNMENT_STOCK_DB', 'CONSIGNMENT STOCK', attr_);
   Client_SYS.Add_To_Attr('B2B_USER_ENABLE_OPERATIONS_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('ALLOW_AGGREGATED_REPORTING_DB', Fnd_Boolean_API.DB_FALSE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUSTOMER_CONSIGNMENT_STOCK_TAB%ROWTYPE )
IS
BEGIN
   IF (Get_Consignment_Stock_Qty(remrec_.contract, remrec_.catalog_no, remrec_.customer_no, remrec_.addr_no) > 0) THEN
      Error_SYS.Record_General(lu_name_, 'CONSIGNQTYNOTZERO: Can not delete record when Consignment Stock Qty > 0.');
   ELSE
      IF (Customer_Order_API.Consignment_Lines_Exist(remrec_.contract, remrec_.customer_no, remrec_.addr_no, remrec_.catalog_no)) THEN
         Error_SYS.Record_General(lu_name_, 'CO_LINES_EXIST: Can not delete record when there are existing Customer Orders which are Customer Consignment Stock enabled.');
      END IF;
   END IF;

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_consignment_stock_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   sprec_            Sales_Part_API.Public_Rec;
   acquisition_site_ VARCHAR2(5);
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF (indrec_.order_qty AND (newrec_.order_qty < 0)) THEN
      Raise_Qty_Less_Zero_Error___;
   END IF;
         
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   sprec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);
   IF (sprec_.catalog_type != 'INV') THEN
      Error_SYS.Record_General(lu_name_, 'ONLY_INV_ON_CONSIGN: Consignment stock can only be used together with inventory parts.');
   END IF;

   -- configured parts are not allowed
   IF (Part_Catalog_API.Get_Configurable_Db(nvl(sprec_.part_no, newrec_.catalog_no)) = 'CONFIGURED') THEN
      Error_SYS.Record_General(lu_name_, 'NO_CONS_FOR_CONFIG: Consignment stock can not be used for configured parts.');
   END IF;

--   -- parts using condition code and valuation method weighted average are not allowed
--   -- since qty at customer cannot be traced at revaluation.
--   IF (Inventory_Part_API.Get_Invent_Part_Cost_Level_Db(newrec_.contract, sprec_.part_no) != 'COST PER PART') THEN
--      Error_SYS.Record_General(lu_name_, 'NOCONSFORCONDI: Customer consignment stock is only allowed for inventory parts with part cost level Cost Per Part.');
--   END IF;

   acquisition_site_ := Cust_Ord_Customer_API.Get_Acquisition_Site(newrec_.customer_no);

   IF (Cust_Ord_Customer_Category_API.Encode(Cust_Ord_Customer_API.Get_Category (newrec_.customer_no)) = 'I') THEN
      IF (Site_API.Get_Company(newrec_.contract) = Site_API.Get_Company(acquisition_site_)) THEN
         Error_SYS.Record_General(lu_name_,'NO_CONS_FOR_IN_CUST: Consignment Stock cannot be used for Internal Customers belonging to the same Company.');
      END IF;
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_consignment_stock_tab%ROWTYPE,
   newrec_ IN OUT customer_consignment_stock_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   sprec_ Sales_Part_API.Public_Rec;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
  IF (indrec_.order_qty AND (newrec_.order_qty < 0)) THEN
     Raise_Qty_Less_Zero_Error___;
  END IF;
   
--   IF (newrec_.consignment_stock != oldrec_.consignment_stock) THEN
--      sprec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);
--      IF (Inventory_Part_API.Get_Invent_Part_Cost_Level_Db(newrec_.contract, sprec_.part_no) != 'COST PER PART') THEN
--         Error_SYS.Record_General(lu_name_, 'NOCONSFORCONDU: Customer consignment stock can be activated only for inventory parts with part cost level Cost Per Part.');
--      END IF;
--   END IF;
END Check_Update___;

   PROCEDURE Raise_Qty_Less_Zero_Error___
   IS
   BEGIN
      Error_SYS.Record_General(lu_name_, 'ORDER_QTY_LESS_ZERO: Order quantity must not be less than zero!');
   END Raise_Qty_Less_Zero_Error___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Consignment_Stock_Qty (
   contract_    IN VARCHAR2,
   catalog_no_  IN VARCHAR2,
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 ) RETURN NUMBER
IS
   qty_in_consignment_      NUMBER;
   dummy_number_            NUMBER;
BEGIN
   Inventory_Part_At_Customer_API.Get_Our_Total_Qty_At_Customer(dummy_number_,
                                                                qty_in_consignment_,
                                                                dummy_number_,
                                                                contract_,
                                                                Sales_Part_API.Get_Part_No(contract_, catalog_no_),
                                                                customer_no_,
                                                                addr_no_ );
   RETURN NVL(qty_in_consignment_,0);
END Get_Consignment_Stock_Qty;


PROCEDURE Increase_Consignment_Stock_Qty (
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   eng_chg_level_                IN VARCHAR2,
   waiv_dev_rej_no_              IN VARCHAR2,
   activity_seq_                 IN NUMBER,
   handling_unit_id_             IN NUMBER,
   expiration_date_              IN DATE,
   transaction_id_               IN NUMBER,
   transaction_code_             IN VARCHAR2,
   project_id_                   IN VARCHAR2,
   order_no_                     IN VARCHAR2,
   release_no_                   IN VARCHAR2,
   sequence_no_                  IN VARCHAR2,
   line_item_no_                 IN NUMBER,
   deliv_no_                     IN VARCHAR2,
   quantity_                     IN NUMBER,
   catch_quantity_               IN NUMBER,
   validate_hu_struct_position_  IN BOOLEAN DEFAULT TRUE )
IS
   oldrec_                  CUSTOMER_CONSIGNMENT_STOCK_TAB%ROWTYPE;
   customer_order_line_rec_ Customer_Order_Line_API.Public_Rec;
BEGIN
   customer_order_line_rec_ := Customer_Order_Line_API.Get(order_no_, release_no_, sequence_no_, line_item_no_);

   -- This call was placed to make sure the CustomerConsignmentStock record is in place.
   oldrec_ := Lock_By_Keys___(contract_, customer_order_line_rec_.catalog_no, customer_order_line_rec_.customer_no, customer_order_line_rec_.ship_addr_no);
   
   Inventory_Part_At_Customer_API.Increase_Our_Qty_At_Customer(contract_                     => contract_, 
                                                               part_no_                      => part_no_,
                                                               configuration_id_             => configuration_id_,
                                                               lot_batch_no_                 => lot_batch_no_,
                                                               serial_no_                    => serial_no_,
                                                               eng_chg_level_                => eng_chg_level_,
                                                               waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                                               activity_seq_                 => activity_seq_,
                                                               handling_unit_id_             => handling_unit_id_,
                                                               customer_no_                  => customer_order_line_rec_.customer_no,
                                                               addr_no_                      => customer_order_line_rec_.ship_addr_no,
                                                               expiration_date_              => expiration_date_,
                                                               process_type_db_              => Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT,   
                                                               transaction_id_               => transaction_id_,
                                                               transaction_code_             => transaction_code_,
                                                               project_id_                   => project_id_,
                                                               source_ref1_                  => order_no_,
                                                               source_ref2_                  => release_no_,
                                                               source_ref3_                  => sequence_no_,
                                                               source_ref4_                  => line_item_no_,
                                                               source_ref5_                  => deliv_no_,
                                                               quantity_                     => quantity_,
                                                               catch_quantity_               => catch_quantity_,
                                                               validate_hu_struct_position_  => validate_hu_struct_position_);
END Increase_Consignment_Stock_Qty;


PROCEDURE Decrease_Consignment_Stock_Qty (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   activity_seq_          IN NUMBER,
   handling_unit_id_      IN NUMBER,
   expiration_date_       IN DATE,
   transaction_code_      IN VARCHAR2,
   project_id_            IN VARCHAR2,
   order_no_              IN VARCHAR2,
   release_no_            IN VARCHAR2,
   sequence_no_           IN VARCHAR2,
   line_item_no_          IN NUMBER,
   deliv_no_              IN VARCHAR2,
   quantity_              IN NUMBER,
   catch_quantity_        IN NUMBER,
   addr_no_               IN VARCHAR2 DEFAULT NULL)
IS
   oldrec_                  CUSTOMER_CONSIGNMENT_STOCK_TAB%ROWTYPE;
   dummy_number_            NUMBER;
   customer_order_line_rec_ Customer_Order_Line_API.Public_Rec;
   cost_                    NUMBER;
BEGIN
   customer_order_line_rec_ := Customer_Order_Line_API.Get(order_no_, release_no_, sequence_no_, line_item_no_);
   
   -- This call was placed to make sure the CustomerConsignmentStock record is in place.
   oldrec_ := Lock_By_Keys___(contract_, customer_order_line_rec_.catalog_no, customer_order_line_rec_.customer_no, customer_order_line_rec_.ship_addr_no);
   
   Inventory_Part_At_Customer_API.Decrease_Our_Qty_At_Customer(transaction_id_   => dummy_number_,
                                                               contract_         => contract_, 
                                                               part_no_          => part_no_,
                                                               configuration_id_ => configuration_id_,
                                                               lot_batch_no_     => lot_batch_no_,
                                                               serial_no_        => serial_no_,
                                                               eng_chg_level_    => eng_chg_level_,
                                                               waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                               activity_seq_     => activity_seq_,
                                                               handling_unit_id_ => handling_unit_id_,
                                                               customer_no_      => customer_order_line_rec_.customer_no,
                                                               addr_no_          => NVL(addr_no_, customer_order_line_rec_.ship_addr_no),
                                                               expiration_date_  => expiration_date_,
                                                               process_type_db_  => Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT,   
                                                               transaction_code_ => transaction_code_,
                                                               project_id_       => project_id_,
                                                               source_ref1_      => order_no_,
                                                               source_ref2_      => release_no_,
                                                               source_ref3_      => sequence_no_,
                                                               source_ref4_      => line_item_no_,
															                  source_ref5_      => deliv_no_,	
                                                               quantity_         => quantity_,
                                                               catch_quantity_   => catch_quantity_,
                                                               scrap_cause_      => NULL,
                                                               scrap_note_       => NULL);
                                                             
   cost_:= Inventory_Transaction_Hist_API.Get_Cost(dummy_number_);
   Customer_Order_Delivery_API.Modify_Cost(deliv_no_, cost_);
   Deliver_Customer_Order_API.Create_Outstanding_Sales(deliv_no_, 'CO-CONSUME', order_no_, line_item_no_, (quantity_ / customer_order_line_rec_.conv_factor * customer_order_line_rec_.inverted_conv_factor), quantity_, cost_);
END Decrease_Consignment_Stock_Qty;


-- Get_Sum_Consignment_Stock_Qty
--   Returns the summed consignment stock quantity for specified contract
--   and part_no. Used by Inventory.
@UncheckedAccess
FUNCTION Get_Sum_Consignment_Stock_Qty (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   sum_consignment_stock_qty_ NUMBER;

   CURSOR calculate_sum IS
      SELECT SUM(ipac.quantity)
      FROM   inventory_part_at_customer_tab ipac, sales_part_tab sp
      WHERE  ipac.part_no   = sp.part_no
      AND    ipac.contract  = sp.contract
      AND    sp.part_no     = part_no_
      AND    sp.contract    = contract_
      AND    ipac.process_type = Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT
      AND    sp.sales_type IN ('SALES', 'SALES RENTAL');
BEGIN
   OPEN  calculate_sum;
   FETCH calculate_sum INTO sum_consignment_stock_qty_;
   CLOSE calculate_sum;
   RETURN sum_consignment_stock_qty_;
END Get_Sum_Consignment_Stock_Qty;


@UncheckedAccess
FUNCTION Is_Invent_Part_In_Consignment (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
        FROM inventory_part_at_customer_tab ipac, sales_part_pub sp
       WHERE ipac.quantity > 0
         AND ipac.part_no   = sp.part_no
         AND ipac.contract  = sp.contract
         AND sp.contract    = contract_
         AND sp.part_no     = part_no_
         AND ipac.process_type  = Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT
         AND sp.sales_type_db IN ('SALES', 'SALES RENTAL');
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN('TRUE');
   END IF;
   CLOSE exist_control;
   RETURN('FALSE');
END Is_Invent_Part_In_Consignment;



