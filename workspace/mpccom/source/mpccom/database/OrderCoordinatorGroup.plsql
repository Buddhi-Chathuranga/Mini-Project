-----------------------------------------------------------------------------
--
--  Logical unit: OrderCoordinatorGroup
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170126  LaThlk Bug 131981, Modified Increase_Cust_Order_No() and Incr_Cust_Order_No_Autonomous() by adding new out parameter order_no_. 
--  170126         Modified Reset_Order_No___() in order to check whether gaps are allowed in number sequences or not before resetting the number.
--  170126  SWiclk Bug 132938, Overridden Prepare_Insert___() in order to assign FALSE as default value for ALLOW_LAPSES_IN_NUMBERS_DB.        
--  130708  SWiclk Bug 107700, Annotated COMMIT with "Transaction_Statement_Approved".
--  130606  RuLiLk Bug 107700, Added Incr_Cust_Order_No_Autonomous, Incr_Quotation_No_Autonomous, Incr_Purch_Order_No_Autonomous, 
--  130606         Incr_Dist_Order_No_Autonomous, Reset_Cust_Order_No_Autonomous, Reset_Quotation_No_Autonomous, Reset_Purch_Ord_No_Autonomous,
--  130606         Reset_Dist_Order_No_Autonomous and Reset_Order_No___(). Renamed Increase_Order_No and Get_Order_No as Increase_Cust_Order_No and
--  130606         Get_Cust_Order_No. Used autonomous transaction in order to update the order_coordinator_group_tab and release the lock immediately.           
--  120525  JeLise   Made description private.
--  120507  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120507           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  110523  ToFjNo BB09: Added Check_Service_Quotation_No___ and the use of it.
--  110510  ToFjNo BB09: Modified tests in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  110504  ToFjNo BB09: Added new public attribute service_quotation_no. Added method Increase_Service_Quotation_No.
--  120129  ToFjNo Merged BB09.
--  100429  Ajpelk Merge rose method documentation
--  ----------------------------Eagle------------------------------------------
--  070906  MiKulk Modified the Prepare_Insert___ not to enter default values for the allocation_order_prefix, allocation_order_no.
--  -------------------------------- BLACKBIRD ------------------------------
--  070815  RaKalk Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to validate
--  070815         distribution allocation prefix and distribution allocation number.
--  070126  MoMalk Added public attributes allocation_order_prefix, allocation_order_no, added method Increase_Allocation_Order_No
--  040430  KiSalk Added attributes purch_order_prefix, purch_order_no, dist_order_prefix, dist_order_no to Public_Rec
--  040430         and their respective get methods. Also added methods Increase_Dist_Order_No Increase_Purch_Order_No,
--  040430         Increase_Dist_Order_No and modified Unpack_Check_Insert___ and Unpack_Check_Update___.
--  000925  JOHESE  Added undefines.
--  000504  GBO   Added quotation_no and Increase_Quotation_No
--  000718  TFU   Merging from Chameleon
--  ------------------------------- 12.10 -----------------------------------
--
--  000418  NISOSE  Added General_SYS.Init_Method in Get_Control_Type_Value_Desc.
--  990422  JOHW  General performance improvements.
--  990415  JOHW  Upgraded to performance optimized template.
--  971121  TOOS  Upgrade to F1 2.0
--  970508  FRMA  Added Get_Control_Type_Value_Desc.
--  970313  CHAN  Changed table name: authorize_group is replaced by
--                order_coordinator_group_tab
--  970221  JOKE  Uses column rowversion as objversion (timestamp).
--  961214  JOKE  Modified with new workbench default templates.
--  961111  JOBE  Modified for compatibility with workbench.
--  960517  AnAr  Added purpose comment to file.
--  960410  SHVE  Added procedure Increase_Order_No from the old track.
--  960306  SHVE  Changed LU Name GenAuthorizeGroup.
--  960222  LEPE  Bug 96-0029. Removed REF-flag to GenAuthorize for column
--                Authorize_group.
--  951012  SHR   Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Service_Quotation_No___
--   This method will validate the service_quotation_no.
PROCEDURE Check_Service_Quotation_No___ (
   service_quotation_no_ IN NUMBER )
IS
BEGIN
   IF service_quotation_no_ != ROUND(service_quotation_no_,0) THEN
      Error_SYS.Record_General(lu_name_, 'SQNNODEC: Service Quotation No must be a numerical value without decimals.');
   END IF;
   IF service_quotation_no_ < 0 THEN
      Error_SYS.Record_General(lu_name_, 'SQNMUSTBEPOS: Service Quotation No must be a positive value.');
   END IF;
   IF LENGTH(service_quotation_no_) > 11 THEN
     Error_SYS.Record_General(lu_name_, 'LONGSERQUOTATIONNO: Service Quotation No cannot exceed 11 digits.');
   END IF;
END Check_Service_Quotation_No___;


-- Reset_Order_No___
--   Reset order numbers appropriately.
PROCEDURE Reset_Order_No___ (
   authorize_group_ IN VARCHAR2,
   attribute_name_  IN VARCHAR2,
   order_no_        IN VARCHAR2 )
IS
   attr_             VARCHAR2(2000);
   current_order_no_ NUMBER; 
   oldrec_           ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   newrec_           ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   objid_            ORDER_COORDINATOR_GROUP.objid%TYPE;
   objversion_       ORDER_COORDINATOR_GROUP.objversion%TYPE;
   indrec_           Indicator_Rec;
BEGIN

   IF (Get_Allow_Lapses_In_Numbers_Db(authorize_group_) = Fnd_Boolean_API.DB_FALSE) THEN      
      oldrec_ := Lock_By_Keys___(authorize_group_);

      current_order_no_ := CASE attribute_name_
                              WHEN 'PURCH_ORDER_NO' THEN oldrec_.purch_order_no
                              WHEN 'ORDER_NO'       THEN oldrec_.order_no
                              WHEN 'DIST_ORDER_NO'  THEN oldrec_.dist_order_no
                              WHEN 'QUOTATION_NO'   THEN oldrec_.quotation_no
                           END;

      IF (order_no_ < current_order_no_) THEN 
         Client_SYS.Add_To_Attr(attribute_name_, order_no_ ,attr_);
         newrec_ := oldrec_;
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By Keys
      END IF;
   END IF;
END Reset_Order_No___;     


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT order_coordinator_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF LENGTH(newrec_.order_no) > 11 THEN
     Error_SYS.Record_General(lu_name_, 'LONGORDERNO: Customer Order No cannot exceed 11 characters');
   END IF;

   IF LENGTH(newrec_.quotation_no) > 11 THEN
     Error_SYS.Record_General(lu_name_, 'LONGQUOTATIONNO: Sales Quotation No cannot exceed 11 characters');
   END IF;

   IF LENGTH(newrec_.purch_order_no) > 11 THEN
     Error_SYS.Record_General(lu_name_, 'LONGPURCHORDERNO: Purchase Order No cannot exceed 11 characters');
   END IF;

   IF LENGTH(newrec_.dist_order_no) > 10 THEN
     Error_SYS.Record_General(lu_name_, 'LONGDISTORDERNO: Distribution Order No cannot exceed 10 characters');
   END IF;

   IF (newrec_.purch_order_no IS NULL)AND (newrec_.purch_order_prefix IS NOT NULL) THEN
     Error_SYS.Record_General(lu_name_, 'PURORDNOEMPTY: The field [Purchase Order Number] must have a value when Purchase Order Prefix is entered.');
   ELSIF (newrec_.purch_order_no IS NOT NULL)AND (newrec_.purch_order_prefix IS NULL) THEN
     Error_SYS.Record_General(lu_name_, 'PURORDPREEMPTY: The field [Purchase Order Prefix] must have a value when Purchase Order Number is entered.');
   END IF;

   IF (newrec_.dist_order_no IS NULL)AND (newrec_.dist_order_prefix IS NOT NULL) THEN
     Error_SYS.Record_General(lu_name_, 'DISTORDNOEMPTY: The field [Distribution Order Number] must have a value when Distribution Order Prefix is entered.');
   ELSIF (newrec_.dist_order_no IS NOT NULL)AND (newrec_.dist_order_prefix IS NULL) THEN
     Error_SYS.Record_General(lu_name_, 'DISTORDPREEMPTY: The field [Distribution Order Prefix] must have a value when Distribution Order Number is entered.');
   END IF;

   IF (newrec_.allocation_order_no IS NULL) AND (newrec_.allocation_order_prefix IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ALLOCORDNOEMPTY: The field [Distribution Allocation Number] must have a value when Distribution Allocation Prefix is entered.');
   ELSIF (newrec_.allocation_order_no IS NOT NULL) AND (newrec_.allocation_order_prefix IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ALLOCORDPRIFIXEMPTY: The field [Distribution Allocation Prefix] must have a value when Distribution Allocation Number is entered.');
   END IF;

   Check_Service_Quotation_No___(newrec_.service_quotation_no);
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     order_coordinator_group_tab%ROWTYPE,
   newrec_ IN OUT order_coordinator_group_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF LENGTH(newrec_.order_no) > 11 THEN
     Error_SYS.Record_General(lu_name_, 'LONGORDERNO: Customer Order No cannot exceed 11 characters');
   END IF;

   IF LENGTH(newrec_.quotation_no) > 11 THEN
     Error_SYS.Record_General(lu_name_, 'LONGQUOTATIONNO: Sales Quotation No cannot exceed 11 characters');
   END IF;

   IF LENGTH(newrec_.purch_order_no) > 11 THEN
     Error_SYS.Record_General(lu_name_, 'LONGPURCHORDERNO: Purchase Order No cannot exceed 11 characters');
   END IF;

   IF LENGTH(newrec_.dist_order_no) > 10 THEN
     Error_SYS.Record_General(lu_name_, 'LONGDISTORDERNO: Distribution Order No cannot exceed 10 characters');
   END IF;

   IF (newrec_.purch_order_no IS NULL)AND (newrec_.purch_order_prefix IS NOT NULL) THEN
     Error_SYS.Record_General(lu_name_, 'PURORDNOEMPTY: The field [Purchase Order Number] must have a value when Purchase Order Prefix is entered.');
   ELSIF (newrec_.purch_order_no IS NOT NULL)AND (newrec_.purch_order_prefix IS NULL) THEN
     Error_SYS.Record_General(lu_name_, 'PURORDPREEMPTY: The field [Purchase Order Prefix] must have a value when Purchase Order Number is entered.');
   END IF;

   IF (newrec_.dist_order_no IS NULL)AND (newrec_.dist_order_prefix IS NOT NULL) THEN
     Error_SYS.Record_General(lu_name_, 'DISTORDNOEMPTY: The field [Distribution Order Number] must have a value when Distribution Order Prefix is entered.');
   ELSIF (newrec_.dist_order_no IS NOT NULL)AND (newrec_.dist_order_prefix IS NULL) THEN
     Error_SYS.Record_General(lu_name_, 'DISTORDPREEMPTY: The field [Distribution Order Prefix] must have a value when Distribution Order Number is entered.');
   END IF;

   IF (newrec_.allocation_order_no IS NULL) AND (newrec_.allocation_order_prefix IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ALLOCORDNOEMPTY: The field [Distribution Allocation Number] must have a value when Distribution Allocation Prefix is entered.');
   ELSIF (newrec_.allocation_order_no IS NOT NULL) AND (newrec_.allocation_order_prefix IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ALLOCORDPRIFIXEMPTY: The field [Distribution Allocation Prefix] must have a value when Distribution Allocation Number is entered.');
   END IF;

   Check_Service_Quotation_No___(newrec_.service_quotation_no);
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);   
   Client_SYS.Add_To_Attr('ALLOW_LAPSES_IN_NUMBERS_DB', Fnd_Boolean_API.DB_FALSE, attr_);   
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Cust_Order_No (
   authorize_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ ORDER_COORDINATOR_GROUP_TAB.order_no%TYPE;
   CURSOR get_attr IS
      SELECT order_no
      FROM ORDER_COORDINATOR_GROUP_TAB
      WHERE authorize_group = authorize_group_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Cust_Order_No;


-- Get_Control_Type_Value_Desc
--   Procedure to get description for accounting rules.
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;

@UncheckedAccess
FUNCTION Get_Description (
   authorize_group_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ order_coordinator_group_tab.description%TYPE;
BEGIN
   IF (authorize_group_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('MPCCOM', 'OrderCoordinatorGroup',
              authorize_group), description), 1, 35)
      INTO  temp_
      FROM  order_coordinator_group_tab
      WHERE authorize_group = authorize_group_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(authorize_group_, 'Get_Description');
END Get_Description;


-- Increase_Cust_Order_No
--   Adds 1 to order number.
PROCEDURE Increase_Cust_Order_No (
   order_no_        OUT VARCHAR2,
   authorize_group_ IN  VARCHAR2 )
IS
   oldrec_ ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   attr_   VARCHAR2(32000);
   newrec_ ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   objid_  ORDER_COORDINATOR_GROUP.objid%TYPE;
   objversion_ ORDER_COORDINATOR_GROUP.objversion%TYPE;
   indrec_   Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   oldrec_ := Lock_By_Keys___(authorize_group_);
   Client_SYS.Add_To_Attr('ORDER_NO',to_char(to_number(oldrec_.order_no) + 1), attr_);

   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.
   order_no_ := authorize_group_ || newrec_.order_no;
--   UPDATE order_coordinator_group_tab
--   SET order_no = to_char(to_number(order_no)+1)
--   WHERE authorize_group = authorize_group_;

END Increase_Cust_Order_No;


-- Increase_Quotation_No
--   Adds 1 to quotation number.
PROCEDURE Increase_Quotation_No (
   quotation_no_    OUT VARCHAR2,
   authorize_group_ IN  VARCHAR2 )
IS
   oldrec_     ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);
   newrec_     ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   objid_      ORDER_COORDINATOR_GROUP.objid%TYPE;
   objversion_ ORDER_COORDINATOR_GROUP.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);

   oldrec_ := Lock_By_Keys___(authorize_group_);
   Client_SYS.Add_To_Attr('QUOTATION_NO', TO_CHAR( TO_NUMBER(oldrec_.quotation_no) + 1), attr_);

   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.
   quotation_no_ := authorize_group_ || newrec_.quotation_no;
   
END Increase_Quotation_No;


-- Increase_Purch_Order_No
--   Adds 1 to purchase order number.
PROCEDURE Increase_Purch_Order_No (
   purch_order_no_  OUT VARCHAR2,
   authorize_group_ IN  VARCHAR2 )
IS
   oldrec_     ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);
   newrec_     ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   objid_      ORDER_COORDINATOR_GROUP.objid%TYPE;
   objversion_ ORDER_COORDINATOR_GROUP.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);

   oldrec_ := Lock_By_Keys___(authorize_group_);
   Client_SYS.Add_To_Attr('PURCH_ORDER_NO', oldrec_.purch_order_no + 1, attr_);

   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.
   purch_order_no_ := Get_Purch_Order_Prefix(authorize_group_) || newrec_.purch_order_no;
END Increase_Purch_Order_No;


-- Increase_Dist_Order_No
--   Adds 1 to distribution order number.
PROCEDURE Increase_Dist_Order_No (
   dist_order_no_   OUT VARCHAR2,
   authorize_group_ IN  VARCHAR2 )
IS
   oldrec_     ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);
   newrec_     ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   objid_      ORDER_COORDINATOR_GROUP.objid%TYPE;
   objversion_ ORDER_COORDINATOR_GROUP.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);

   oldrec_ := Lock_By_Keys___(authorize_group_);
   Client_SYS.Add_To_Attr('DIST_ORDER_NO', oldrec_.dist_order_no + 1, attr_);

   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.
   dist_order_no_ := authorize_group_ || Get_Dist_Order_Prefix(authorize_group_) || newrec_.dist_order_no;   
END Increase_Dist_Order_No;


-- Increase_Allocation_Order_No
--   Adds 1 to allocation order number.
PROCEDURE Increase_Allocation_Order_No (
   authorize_group_ IN VARCHAR2 )
IS
   oldrec_     ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);
   newrec_     ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   objid_      ORDER_COORDINATOR_GROUP.objid%TYPE;
   objversion_ ORDER_COORDINATOR_GROUP.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);

   oldrec_ := Lock_By_Keys___(authorize_group_);
   Client_SYS.Add_To_Attr('ALLOCATION_ORDER_NO', oldrec_.allocation_order_no + 1, attr_);

   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.
END Increase_Allocation_Order_No;


PROCEDURE Increase_Service_Quotation_No (
   authorize_group_ IN VARCHAR2 )
IS
   oldrec_     ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);
   newrec_     ORDER_COORDINATOR_GROUP_TAB%ROWTYPE;
   objid_      ORDER_COORDINATOR_GROUP.objid%TYPE;
   objversion_ ORDER_COORDINATOR_GROUP.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);

   oldrec_ := Lock_By_Keys___(authorize_group_);
   Client_SYS.Add_To_Attr('SERVICE_QUOTATION_NO', oldrec_.service_quotation_no + 1, attr_);

   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.

END Increase_Service_Quotation_No;


-- Incr_Cust_Order_No_Autonomous
--   Increase the customer order number using autonomous transaction.
PROCEDURE Incr_Cust_Order_No_Autonomous (
   order_no_        OUT VARCHAR2,
   authorize_group_ IN VARCHAR2 )
IS
   PRAGMA  AUTONOMOUS_TRANSACTION;
BEGIN
   Increase_Cust_Order_No(order_no_, authorize_group_);
   @ApproveTransactionStatement(2013-07-08,swiclk)
   COMMIT;
END Incr_Cust_Order_No_Autonomous;


-- Incr_Quotation_No_Autonomous
--   Increase the sales quotation order number using autonomous transaction.
PROCEDURE Incr_Quotation_No_Autonomous (
   quotation_no_    OUT VARCHAR2,
   authorize_group_ IN  VARCHAR2 )
IS
   PRAGMA  AUTONOMOUS_TRANSACTION;
BEGIN
   Increase_Quotation_No(quotation_no_, authorize_group_);
   @ApproveTransactionStatement(2013-07-08,swiclk)
   COMMIT;
END Incr_Quotation_No_Autonomous;


-- Incr_Purch_Order_No_Autonomous
--   Increase the purchase order number using autonomous transaction.
PROCEDURE Incr_Purch_Order_No_Autonomous (
   purch_order_no_  OUT VARCHAR2,
   authorize_group_ IN  VARCHAR2 )
IS
   PRAGMA  AUTONOMOUS_TRANSACTION;
BEGIN
   Increase_Purch_Order_No(purch_order_no_, authorize_group_);
   @ApproveTransactionStatement(2013-07-08,swiclk)
   COMMIT;
END Incr_Purch_Order_No_Autonomous;


-- Incr_Dist_Order_No_Autonomous
--   Increase the distribution order number using autonomous transaction.
PROCEDURE Incr_Dist_Order_No_Autonomous (
   dist_order_no_   OUT VARCHAR2,
   authorize_group_ IN  VARCHAR2 )
IS
   PRAGMA  AUTONOMOUS_TRANSACTION;
BEGIN
   Increase_Dist_Order_No(dist_order_no_, authorize_group_);
   @ApproveTransactionStatement(2013-07-08,swiclk)
   COMMIT;
END Incr_Dist_Order_No_Autonomous;


-- Reset_Cust_Order_No_Autonomous
--   Reset customer order number using autonomous transaction.
PROCEDURE Reset_Cust_Order_No_Autonomous (
   authorize_group_ IN VARCHAR2,
   cust_order_no_   IN VARCHAR2 )
IS
   PRAGMA  AUTONOMOUS_TRANSACTION;
BEGIN

   Reset_Order_No___(authorize_group_, 'ORDER_NO', cust_order_no_);
   @ApproveTransactionStatement(2013-07-08,swiclk)
   COMMIT;
END Reset_Cust_Order_No_Autonomous;


-- Reset_Quotation_No_Autonomous
--   Reset quotation order number using autonomous transaction.
PROCEDURE Reset_Quotation_No_Autonomous (
   authorize_group_ IN VARCHAR2,
   quotation_no_    IN VARCHAR2 )
IS
   PRAGMA  AUTONOMOUS_TRANSACTION;
BEGIN

   Reset_Order_No___(authorize_group_, 'QUOTATION_NO', quotation_no_);
   @ApproveTransactionStatement(2013-07-08,swiclk)
   COMMIT;
END Reset_Quotation_No_Autonomous;


-- Reset_Purch_Ord_No_Autonomous
--   Reset purchase order number using autonomous transaction.
PROCEDURE Reset_Purch_Ord_No_Autonomous (
   authorize_group_ IN VARCHAR2,
   purch_order_no_  IN VARCHAR2 )
IS
   PRAGMA  AUTONOMOUS_TRANSACTION;
BEGIN

   Reset_Order_No___(authorize_group_, 'PURCH_ORDER_NO', purch_order_no_);
   @ApproveTransactionStatement(2013-07-08,swiclk)
   COMMIT;
END Reset_Purch_Ord_No_Autonomous;


-- Reset_Dist_Order_No_Autonomous
--   Reset distribution order number using autonomous transaction.
PROCEDURE Reset_Dist_Order_No_Autonomous (
   authorize_group_ IN VARCHAR2,
   dist_order_no_   IN VARCHAR2 )
IS
   PRAGMA  AUTONOMOUS_TRANSACTION;
BEGIN

   Reset_Order_No___(authorize_group_, 'DIST_ORDER_NO', dist_order_no_);
   @ApproveTransactionStatement(2013-07-08,swiclk)
   COMMIT;
END Reset_Dist_Order_No_Autonomous;



