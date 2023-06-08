-----------------------------------------------------------------------------
--
--  Logical unit: MpccomTransactionCode
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200813  Asawlk  SC2020R1-9087, Modified Insert_Or_Update___ to use Check_Update___ and Update___, instead of Modify___.
--  200601  LEPESE  SC2021R1-291, Added private method Update__. Moved implementation from private Insert_Or_Update__ to
--  200601          implementation method Insert_Or_Update___. Rewrote implementation using New___ and Modify___.
--  200117  SBalLK  Bug 151864(SCZ-8504), Added Get_Suppl_Mtrl_Dir_Del_Trans method.
--  170615  DAYJLK  STRSC-9028, Added type Transaction_Code_Tab to replace types Suppl_Mtrl_Issue_Trans_Tab and Curr_Rate_Calc_Trans_Tab.
--  170508  ChFolk  STRSC-7108, Defined new table type Suppl_Mtrl_Issue_Trans_Tab and added new method Get_Suppl_Mtrl_Issue_Trans
--  170508          to use in Inventory_Transaction_Hist_API. 
--  130510  Asawlk  EBALL-37, Added new attribute qty_at_customer_direction.
--  130508  Asawlk  EBALL-37, Replaced the references towards Transit_Qty_Direction_API with Stock_Quantity_Direction_API.
--  121119  NaLrlk  Added new public attributes company_rent_asset_allowed and supplier_rented_allowed.
--  121119          Modified Check_Part_Ownership_Db to include ownership validations for Supplier Rented and Fixed Asset.
--  120309  GayDLK  Bug 101434, Modified 'INVENTORY_TRANSACTION_CODE_LOV' and 'INVENT_TRANSACTION_CODE_LOV' by 
--  120309          removing 'UPPERCASE' from the column comments for 'Transaction Description'.   
--  120202  ChJalk  Moved 'COLUMN=Transaction_Source' to the column TRANSACTION from TRANSACTION_CODE.
--  120106  LEPESE  Added method Is_Vendor_Consignment. 
--  110519  LEPESE  Corrected method Get_Order_Type to return client value from Order_Type_API.
--  101018  LaRelk  BP-2366, Added Invalidate_Cache___,Update_Cache___ and modified public Get method and other get methods. 
--  101014  LaRelk  BP-2366, Added new attribute RECEIPT_ISSUE_TRACKING to the view MPCCOM_TRANSACTION_CODE. 
--  101014          Modified methods Get, Insert___, Unpack_Check_Insert___, Update___, Unpack_Check_Update___,   
--  101014          Insert_Or_Update__, Check_Update_From_Client___, and added method Get_Receipt_Issue_Tracking. 
--  100702  MalLlk  Modified Check_Part_Ownership_Db to add validation based on company_owned_allowed.
--  100615  MalLlk  Added new public attribute company_owned_allowed.
--  100429  Ajpelk  Merge rose method documentation
--  100420  MaEelk  Added Get_Vendor_Consignment_Trans to fetch the corresponding consignment transaction
--  100420          of a given transaction code. If it does not have a corresponding consignment traansaction,
--  100420          it will return the original value.
--  100416  MaEelk  Added Check_Part_Ownership_Db to make ownership validations against the transaction code
--  -------------------------- 14.0.0----------------------------------------
--  070423  RaKalk  Made transaction column a derived private attribute. Removed it from public view and public rec
--  070423          Removed Check_Valid_Transaction_Code, Check_Trans_Shop_Order_Issue, 
--  070423          Transaction_Has_Unique_Code and Get_Any_Transaction_Code functions
--  070423          Modified Unpack_Check_Insert___, Unpack_Check_Update___, Insert_Or_Update__
--  070423          Insert___, Update___, Get, New__, and Modify__ methods
--  070420  RaKalk  Modified the Get_Transaction function public Get method and the views to fetch the
--  070420          transaction value from MpccomSystemEvent LU
--  070326  RaKalk  Modified Insert_Or_Update__ method to create the System event if it does not exist
--                  This change will be rolled back once the ins files are restructured.
--  070321  RaKalk  Added MpccomSystemEvent as the parent LU, Modified the main  view,
--  070321          unpack_check_insert___ method and Get_Description method
--  060713  MiErlk  Changed the procedure Insert_Or_Update__ to handle transaction_source
--                  And Created INVENT_TRANSACTION_CODE_LOV
--  060712  SARALK  Added attribute transaction_source and changed necessary code.
--  060113  LEPESE  Made attribute source_application public.
--  051031  LEPESE  Changed parameter rec_ in method Insert_Or_Update__ to IN OUT.
--  051031          Assign null to the record just before ending the method.
--  050919  NaLrlk  Removed unused variables.
--  050505  KaDilk  Bug 50422, Added functions Transaction_Has_Unique_Code and
--  050505          Get_Any_Transaction_Code.
--  041026  HaPulk  Moved methods Insert_Lu_Translation from Insert___ to New__ and
--  041026          Modify_Translation from Update___ to Modify__.
--  041018  HaPulk  Added new method Check_Update_From_Client___.
--  040929  HaPulk  Renamed Insert_Lu_Data_Rec__ as Insert_Or_Update__ and changed the logic.
--  **************  Touchdown Merge Begin  *********************
--  040223  JoAnSe  Added new attribute trans_based_reval_group.
--  040208  LEPESE  Corrected error in method Insert_Lu_Data_Rec__.
--  040205  LEPESE  Made association with PartTracing public.
--  040120  JoAnSe  Added new attribute transit_qty_direction.
--  **************  Touchdown Merge End    *********************
--  040303  SaNalk  Removed SUBSTRB.
--  040225  SaNalk  Removed SUBSTRB.
--  ----------------------------- 13.3.0 --------------------------------------
--  030930  ThGulk Changed substr to substrb, instr to instrb, length to lengthb.
--  030603  GEBOSE  Changed method Insert_Lu_Data_Rec__ so that it takes care of
--  030603          the two new columns in table MPCCOM_TRANSACTION_CODE_TAB:
--  030521          Customer_Owned_Stock and Supplier_Loaned_Stock.
--  030521  GEBOSE  Added four get-methods: Get_Customer_Owned_Stock,
--  030521          Get_Customer_Owned_Stock_Db, Get_Supplier_Loaned_Stock and
--  030521          Get_Supplier_Loaned_Stock_Db
--  030521  GEBOSE  Added two new columns to the table MPCCOM_TRANSACTION_CODE_TAB:
--  030521          Customer_Owned_Stock and Supplier_Loaned_Stock. Also added
--  030521          these columns to the view MPCCOM_TRANSACTION_CODE
--  ---------------- TAKE OFF II --------------------------------------------
--  020121  DaMase  IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  010209  ANLASE  Bug fix 19177. Added attributes Notc and Intrastat_Direction.
--  001103  LEPE    Added public mandatory attribute cost_source.
--  001010  JOKE    Added method Get_Consignment_Stock_Db.
--  001002  JOKE    Added method Get_Actual_Cost_Receipt_Db for performance.
--  000928  JOKE    Added attribute Actual_Cost_Receipt.
--  000925  JOHESE  Added undefines.
--  000418  NISOSE  Added General_SYS.Init_Method in Get_Invent_Stat_Direction_Db.
--  990827  SHVE    Added column Part_tracing and converted source_application to an iid value.
--  990527  ROOD    Changed INVENTORY_TRANSACTION_CODE_LOV.
--  990423  DAZA    General performance improvements.
--  990413  JOHW    Upgraded to performance optimized template.
--  990228  JOKE    Added Corresponding_transaction along with two new methods
--                  Get_Original_Transaction_Code and Get_Corresponding_Transaction.
--  990214  JOKE    Removed obsolete attribute: Inventory_Value_Direction.
--  990209  ROOD    Added attributes Inventory_Stat_Direction, Inventory_Value_Direction.
--                  Added Get_Invent_Stat_Direction_Db and Get_Invent_Value_Direction_Db.
--                  Removed attribute Inv_Hist_Flag and the function Check_Inv_Hist_Flag.
--  990203  JOKE    Added attribute Consignment_Stock and the public get function.
--  971121  TOOS    Upgrade to F1 2.0
--  971106  JOMC    Bug 1502 Created a new Inventory_Transaction_Code_LOV
--  970408  LEPE    Added funtcion Check_Trans_Shop_Order_Issue.
--  970313  MAGN    Changed tablename from transaction_codes to mpccom_transaction_code_tab.
--  970226  MAGN    Uses column rowversion as objversion(timestamp).
--  970116  MAOR    Changed end-statement in function Check_Inv_Hist_Flag.
--  970115  MAOR    Added function Check_Inv_Hist_Flag.
--  970110  GOPE    corrected transaction = transaction_ in Check_Valid_Transaction_Code
--  961219  JOKE    Changed Order_Type to use OrderType IID.
--  961214  JOKE    Modified with new workbench default templates.
--  961113  JOBE    Modified for compatibility with workbench.
--  960826  MAOR    Changed where-statement transaction_code = transaction_code_
--                  to be transaction_code like transaction_code_ in function
--                  Get_transaction.
--  960821  MAOR    Added function Get_Inv_Hist_Flag.
--  960524  SHVE    Added methods Get_Transaction and Get_Transaction_Info.
--  960523  JOHNI   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Transaction_Code_Tab  IS TABLE OF mpccom_transaction_code_tab.transaction_code%TYPE INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Update_From_Client___
--   This method is used to check whether update is done from client window.
PROCEDURE Check_Update_From_Client___ (
   oldrec_ IN MPCCOM_TRANSACTION_CODE_TAB%ROWTYPE,
   newrec_ IN MPCCOM_TRANSACTION_CODE_TAB%ROWTYPE )
IS
BEGIN
   IF oldrec_.order_type <> newrec_.order_type THEN
      Error_SYS.Item_Update(lu_name_, 'ORDER_TYPE');
   ELSIF oldrec_.source_application <> newrec_.source_application THEN
      Error_SYS.Item_Update(lu_name_, 'SOURCE_APPLICATION');
   ELSIF oldrec_.consignment_stock <> newrec_.consignment_stock THEN
      Error_SYS.Item_Update(lu_name_, 'CONSIGNMENT_STOCK');
   ELSIF oldrec_.inventory_stat_direction <> newrec_.inventory_stat_direction THEN
      Error_SYS.Item_Update(lu_name_, 'INVENTORY_STAT_DIRECTION');
   ELSIF oldrec_.part_tracing <> newrec_.part_tracing THEN
      Error_SYS.Item_Update(lu_name_, 'PART_TRACING');
   ELSIF oldrec_.actual_cost_receipt <> newrec_.actual_cost_receipt THEN
      Error_SYS.Item_Update(lu_name_, 'ACTUAL_COST_RECEIPT');
   ELSIF oldrec_.cost_source <> newrec_.cost_source THEN
      Error_SYS.Item_Update(lu_name_, 'COST_SOURCE');
   ELSIF oldrec_.notc <> newrec_.notc THEN
      Error_SYS.Item_Update(lu_name_, 'NOTC');
   ELSIF oldrec_.intrastat_direction <> newrec_.intrastat_direction THEN
      Error_SYS.Item_Update(lu_name_, 'INTRASTAT_DIRECTION');
   ELSIF oldrec_.customer_owned_stock <> newrec_.customer_owned_stock THEN
      Error_SYS.Item_Update(lu_name_, 'CUSTOMER_OWNED_STOCK');
   ELSIF oldrec_.supplier_loaned_stock <> newrec_.supplier_loaned_stock THEN
      Error_SYS.Item_Update(lu_name_, 'SUPPLIER_LOANED_STOCK');
   ELSIF oldrec_.transit_qty_direction <> newrec_.transit_qty_direction THEN
      Error_SYS.Item_Update(lu_name_, 'TRANSIT_QTY_DIRECTION');
   ELSIF oldrec_.trans_based_reval_group <> newrec_.trans_based_reval_group THEN
      Error_SYS.Item_Update(lu_name_, 'TRANS_BASED_REVAL_GROUP');
   ELSIF oldrec_.company_owned_allowed <> newrec_.company_owned_allowed THEN
      Error_SYS.Item_Update(lu_name_, 'COMPANY_OWNED_ALLOWED');
   ELSIF oldrec_.receipt_issue_tracking <> newrec_.receipt_issue_tracking THEN
      Error_SYS.Item_Update(lu_name_, 'RECEIPT_ISSUE_TRACKING');
   ELSIF oldrec_.company_rent_asset_allowed <> newrec_.company_rent_asset_allowed THEN
      Error_SYS.Item_Update(lu_name_, 'COMPANY_RENT_ASSET_ALLOWED');
   ELSIF oldrec_.supplier_rented_allowed <> newrec_.supplier_rented_allowed THEN
      Error_SYS.Item_Update(lu_name_, 'SUPPLIER_RENTED_ALLOWED');
   END IF;
END Check_Update_From_Client___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT mpccom_transaction_code_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
  
BEGIN
   IF(Client_SYS.Item_Exist('TRANSACTION', attr_)) THEN
      Error_SYS.Item_Insert(lu_name_, 'TRANSACTION');
   END IF;
   super(newrec_, indrec_, attr_);   
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     mpccom_transaction_code_tab%ROWTYPE,
   newrec_ IN OUT mpccom_transaction_code_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2,
   check_update_from_client_ IN BOOLEAN DEFAULT TRUE )
IS  
BEGIN
   IF(Client_SYS.Item_Exist('TRANSACTION', attr_)) THEN
      Error_SYS.Item_Update(lu_name_, 'TRANSACTION');
   END IF;  
   super(oldrec_, newrec_, indrec_, attr_);
   IF(check_update_from_client_) THEN
      Check_Update_From_Client___(oldrec_, newrec_);
   END IF;
END Check_Update___;


-- Insert_Or_Update__
--   Handles component translations
PROCEDURE Insert_Or_Update___ (
   newrec_ IN OUT MPCCOM_TRANSACTION_CODE_TAB%ROWTYPE,
   insert_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_    MPCCOM_TRANSACTION_CODE_TAB%ROWTYPE;
   empty_rec_ MPCCOM_TRANSACTION_CODE_TAB%ROWTYPE;   
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);   
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   
   CURSOR get_record IS
      SELECT *
      FROM MPCCOM_TRANSACTION_CODE_TAB
      WHERE transaction_code = newrec_.transaction_code
      FOR UPDATE;
BEGIN
   OPEN get_record;
   FETCH get_record INTO oldrec_;
   IF (get_record%FOUND) THEN
      newrec_.rowversion := oldrec_.rowversion;
      newrec_.rowkey     := oldrec_.rowkey;
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_, FALSE);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   ELSE
      IF (insert_) THEN
         New___(newrec_);
      END IF;
   END IF;
   CLOSE get_record;
   newrec_ := empty_rec_;
END Insert_Or_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Or_Update__ (
   rec_ IN OUT MPCCOM_TRANSACTION_CODE_TAB%ROWTYPE )
IS
BEGIN
   Insert_Or_Update___(rec_);
END Insert_Or_Update__;


PROCEDURE Update__ (
   rec_ IN OUT MPCCOM_TRANSACTION_CODE_TAB%ROWTYPE )
IS
BEGIN
   Insert_Or_Update___(rec_, insert_ => FALSE);
END Update__;   

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Invent_Stat_Direction_Db
--   Fetches database value of Inventory Stat Direction
FUNCTION Get_Invent_Stat_Direction_Db (
   transaction_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(transaction_code_);
   RETURN micro_cache_value_.inventory_stat_direction;
END Get_Invent_Stat_Direction_Db;


-- Get_Original_Transaction_Code
--   Fetches the transaction Code that has the in parameter as
@UncheckedAccess
FUNCTION Get_Original_Transaction_Code (
   corresponding_transaction_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ MPCCOM_TRANSACTION_CODE_TAB.transaction_code%TYPE;
   CURSOR get_attr IS
      SELECT transaction_code
      FROM MPCCOM_TRANSACTION_CODE_TAB
      WHERE corresponding_transaction = corresponding_transaction_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Original_Transaction_Code;


@UncheckedAccess
FUNCTION Get_Transaction (
   transaction_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Mpccom_System_Event_API.Get_Description(transaction_code_);
END Get_Transaction;


PROCEDURE Check_Part_Ownership_Db (
   transaction_code_  IN VARCHAR2,
   part_ownership_db_ IN VARCHAR2)
IS
   db_company_owned_             CONSTANT VARCHAR2(20) := Part_Ownership_API.DB_COMPANY_OWNED;
   db_consignment_               CONSTANT VARCHAR2(20) := Part_Ownership_API.DB_CONSIGNMENT;
   db_supplier_loaned_           CONSTANT VARCHAR2(20) := Part_Ownership_API.DB_SUPPLIER_LOANED;
   db_customer_owned_            CONSTANT VARCHAR2(20) := Part_Ownership_API.DB_CUSTOMER_OWNED;
   db_supplier_owned_            CONSTANT VARCHAR2(20) := Part_Ownership_API.DB_SUPPLIER_OWNED;
   db_supplier_rented_           CONSTANT VARCHAR2(20) := Part_Ownership_API.DB_SUPPLIER_RENTED;
   db_company_rental_asset_      CONSTANT VARCHAR2(20) := Part_Ownership_API.DB_COMPANY_RENTAL_ASSET;
   rec_                          MPCCOM_TRANSACTION_CODE_TAB%ROWTYPE;
   corresponding_rec_            MPCCOM_TRANSACTION_CODE_TAB%ROWTYPE;
   trans_error_                  EXCEPTION;

BEGIN

   rec_ := Get_Object_By_Keys___(transaction_code_);

   IF (part_ownership_db_ = db_company_owned_) THEN
      IF (rec_.consignment_stock = Consignment_Stock_Trans_API.DB_VENDOR_CONSIGNMENT_STOCK) THEN
         RAISE trans_error_;
      END IF;
      IF (rec_.company_owned_allowed = Fnd_Boolean_API.DB_FALSE) THEN
         RAISE trans_error_;
      END IF;
   ELSIF (part_ownership_db_ = db_consignment_) THEN
      IF (rec_.consignment_stock != Consignment_Stock_Trans_API.DB_VENDOR_CONSIGNMENT_STOCK) THEN
         IF (rec_.corresponding_transaction IS NULL) THEN
            RAISE trans_error_;
         END IF;
         corresponding_rec_ := Get_Object_By_Keys___(rec_.corresponding_transaction);
         IF (corresponding_rec_.consignment_stock != Consignment_Stock_Trans_API.DB_VENDOR_CONSIGNMENT_STOCK) THEN
            RAISE trans_error_;
         END IF;
      END IF;
   ELSIF (part_ownership_db_ = db_customer_owned_) THEN
      IF (rec_.consignment_stock != Consignment_Stock_Trans_API.DB_NOT_CONSIGNMENT_STOCK) THEN
         RAISE trans_error_;
      END IF;
      IF (rec_.customer_owned_stock = Customer_Owned_Stock_API.DB_CUS_OWNED_STOCK_NOT_ALLOWED) THEN
         RAISE trans_error_;
      END IF;
   ELSIF (part_ownership_db_ = db_supplier_loaned_) THEN
      IF (rec_.consignment_stock != Consignment_Stock_Trans_API.DB_NOT_CONSIGNMENT_STOCK) THEN
         RAISE trans_error_;
      END IF;
      IF (rec_.supplier_loaned_stock = Supplier_Loaned_Stock_API.DB_SUPP_LOAN_STOCK_NOT_ALLOWED) THEN
         RAISE trans_error_;
      END IF;
   ELSIF (part_ownership_db_ = db_supplier_owned_) THEN
      IF (rec_.consignment_stock != Consignment_Stock_Trans_API.DB_NOT_CONSIGNMENT_STOCK) THEN
         RAISE trans_error_;
      END IF;
   ELSIF (part_ownership_db_ = db_company_rental_asset_) THEN
      IF (rec_.consignment_stock != Consignment_Stock_Trans_API.DB_NOT_CONSIGNMENT_STOCK) THEN
         RAISE trans_error_;
      END IF;
      IF (rec_.company_rent_asset_allowed = Fnd_Boolean_API.DB_FALSE) THEN
         RAISE trans_error_;
      END IF;
   ELSIF (part_ownership_db_ = db_supplier_rented_) THEN
      IF (rec_.consignment_stock != Consignment_Stock_Trans_API.DB_NOT_CONSIGNMENT_STOCK) THEN
         RAISE trans_error_;
      END IF;
      IF (rec_.supplier_rented_allowed = Fnd_Boolean_API.DB_FALSE) THEN
         RAISE trans_error_;
      END IF;
   ELSE
      RAISE trans_error_;
   END IF;
EXCEPTION
   WHEN trans_error_ THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDTRANS: You are not allowed to perform this transaction :P1 on :P2 Stock.',transaction_code_, Part_Ownership_API.Decode(part_ownership_db_));
END Check_Part_Ownership_Db;


@UncheckedAccess
FUNCTION Get_Vendor_Consignment_Trans (
   transaction_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   trans_rec_                MPCCOM_TRANSACTION_CODE_TAB%ROWTYPE;
   vendor_consignment_trans_ MPCCOM_TRANSACTION_CODE_TAB.transaction_code%TYPE;
BEGIN
   trans_rec_ := Get_Object_By_Keys___(transaction_code_);

   IF (trans_rec_.corresponding_transaction IS NULL) THEN
      -- This transaction code does NOT have a corresponding
      -- vendor consignment transaction code...
      IF (trans_rec_.consignment_stock = 'VENDOR CONSIGNMENT') THEN
         -- ... but it was in itself a vendor consignment transaction so
         -- the method will return the same transaction code back again
         vendor_consignment_trans_ := transaction_code_;
      END IF;
   ELSE
      -- This transaction code does have a corresponding
      -- vendor consignment transaction code
      vendor_consignment_trans_ := trans_rec_.corresponding_transaction;
   END IF;

   RETURN (vendor_consignment_trans_);
END Get_Vendor_Consignment_Trans;


@UncheckedAccess
FUNCTION Is_Vendor_Consignment (
   transaction_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   rec_                   MPCCOM_TRANSACTION_CODE_TAB%ROWTYPE;
   is_vendor_consignment_ BOOLEAN := FALSE;
BEGIN
   rec_ := Get_Object_By_Keys___(transaction_code_);

   IF (rec_.consignment_stock = Consignment_Stock_Trans_API.DB_VENDOR_CONSIGNMENT_STOCK) THEN
      is_vendor_consignment_ := TRUE;
   END IF;

   RETURN (is_vendor_consignment_);
END Is_Vendor_Consignment;


FUNCTION Get_Suppl_Mtrl_Issue_Trans  RETURN Transaction_Code_Tab
IS
   suppl_mtrl_issue_trans_tab_   Transaction_Code_Tab;
BEGIN
   suppl_mtrl_issue_trans_tab_(0) := 'PURSHIP';
   suppl_mtrl_issue_trans_tab_(1) := 'CO-PURSHIP';
   suppl_mtrl_issue_trans_tab_(2) := 'PURBKFL';
   suppl_mtrl_issue_trans_tab_(3) := 'CO-PURBKFL';
   suppl_mtrl_issue_trans_tab_(4) := 'UN-PURSHIP';
   suppl_mtrl_issue_trans_tab_(5) := 'CO-UNPSHIP';
   suppl_mtrl_issue_trans_tab_(6) := 'UN-PURBKFL';
   suppl_mtrl_issue_trans_tab_(7) := 'CO-UNPBKFL';
   
   RETURN suppl_mtrl_issue_trans_tab_;
END Get_Suppl_Mtrl_Issue_Trans;

FUNCTION Get_Cur_Rate_Calc_Trans_By_Src  RETURN Transaction_Code_Tab
IS
   curr_rate_calc_trans_tab_   Transaction_Code_Tab;
BEGIN
   curr_rate_calc_trans_tab_(0) := 'ARRIVAL';
   curr_rate_calc_trans_tab_(1) := 'ARR-REPAIR';
   curr_rate_calc_trans_tab_(2) := 'XO-ARRIVAL';
   curr_rate_calc_trans_tab_(3) := 'COSUPCONSM';
   curr_rate_calc_trans_tab_(4) := 'CO-CONSUM';
   curr_rate_calc_trans_tab_(5) := 'BALRECSP';
   
   RETURN curr_rate_calc_trans_tab_;
END Get_Cur_Rate_Calc_Trans_By_Src;

FUNCTION Get_Suppl_Mtrl_Dir_Del_Trans RETURN Transaction_Code_Tab
IS
   suppl_mtrl_dir_del_trans_tab_   Transaction_Code_Tab;
BEGIN
   suppl_mtrl_dir_del_trans_tab_(0) := 'PURDIR';
   suppl_mtrl_dir_del_trans_tab_(1) := 'INTPURDIR';
   
   RETURN suppl_mtrl_dir_del_trans_tab_;
END Get_Suppl_Mtrl_Dir_Del_Trans;
