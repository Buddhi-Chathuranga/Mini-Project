-----------------------------------------------------------------------------
--
--  Logical unit: SalesPartCrossReference
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180215  AyAmlk  STRSC-16329, Added Get_Latest_Customer_Part_No so that the latest modified customer part no can be fetched.
--  150819  PrYaLK  Bug 121587, Modified Check_Insert___() and Check_Update___() by adding inverted_conv_factor.
--  140312  ShVese  Removed the method Get_Min_Durab_Days_Co_Deliv. The method will be generated since it is a public attribute.
--  131029  MaMalk  Made receiving_advice_type_db length to VARCHAR2(30).
--  130708  MaIklk  Remvoved global constants inst_CustSchedAgreementPart_ and inst_PurchaseOrder_.
--  130607  IsSalk  Bug 110353, Removed Constant inst_CustSchedAgreementPart_. Added method Check_Cust_Sched_Agr_Part___() and modified method Check_Delete___
--  130603          to move the handling of removing of sales part cross reference record to IFSEE client.
--  130104  CPriLK Added the sales_type for Sales_Part_API.Exis()
--  120201  MaRalk  Added NOCHECK for SALES_PART_CROSS_REF_CUST_LOV-CUSTOMER_NO view comment to pass the PLSQL test for verifying 
--  120201          REF column comment having /NOCHECK option for other views.
--  110506  MaRalk  Removed method Check_Customer_Part_Exist since the correction was reversed.
--  110429  NaLrlk  Added LOV view SALES_PART_CROSS_REF_CUST_LOV.
--  110210  ShKolk  Added method Check_Customer_Part_Exist.
--  110131  Nekolk  EANE-3744  added where clause to View SALES_PART_CROSS_REFERENCE
--  090827  ShKolk  Modified Synch_Min_Durab_Days_Co_Del___().to update min_durab_days_co_deliv if the new value is not equal to the existing value.
--  090825  ShKolk  Modified Synch_Min_Durab_Days_Co_Del___().
--  090824  ShKolk  Added new function Get_Min_Durab_Days_For_Catalog and modified Modify__, New__, Unpack_Check_Insert___/Update___.
--  090824          Added new column min_durab_days_co_deliv and procedure Synch_Min_Durab_Days_Co_Del___.
--  100514  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  100118  SudJlk  Bug 88099, Modified method Check_Delete___ to prompt an error when trying to delete a cross reference of a part connected to an agreement.
--  091130  Castse  Bug 87188, Modified method Validate_Receiving_Advice___ by removing the variable receiving_advice_type_  
--  091130          and directly using the method call Receiving_Advice_Type_API.Decode in the error message.
--  060601  MiErlk  Enlarge Identity - Changed view comments - Description.
--  060412  RoJalk  Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 ----------------------------------------------
--  060124  JaJalk  Added Assert safe annotation.
--  060118  JaJalk  Added the returning clause in Insert___ according to the new F1 template.
--  050809  Nalrlk  Added the implementation method Validate_Receiving_Advice___ and call this method from unpack_check_insert___/update___.
--  050722  NaLrlk  B125944 Modified the condition in unpack_insert__/update__ for info message when use_customer_default.
--  050715  NaLrlk  Added RECEIVING_ADVICE_TYPE to prepare_insert___.
--  050628  NaLrlk  Added the new Column Receiving_Advice_Type and public function Get_Receiving_Advice_Type_Db.
--  050522  RaKalk  Modified Check_Delete___ to check whether there is a record for customer part no and site
--  050522         in LU CUSSCH/CustSchedAgreementSupp
--  050427  IsAnlk Added Check_Exist public method.
--  041209  PrPrlk Bug 47703, Modified PROCEDURE Unpack_Check_Insert___ to make the necessary validation.
--  040817  DhWilk Inserted General_SYS.Init_Method to Get_Self_Billing_Db
--  040226  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
--  040210  Samnlk  Bug 39270, Modified PROCEDURE Unpack_Check_Insert___.
--  ------------------------------ 13.3.0-------------------------------------
--  ********************* VSHSB Merge End *****************************+*
--  020305  GeKa  Changed Self_Billing_API to Self_Billing_Type_API.
--  020305  GeKa  Added new column Self_Billing.
--  ********************* VSHSB Merge Start *****************************
--  030731  ChIwlk  Performed SP4 Merge.
--  030211  ChJalk  Bug 35437, Modified the message in Check_Delete___.
--  030128  ChJalk  Bug 35437, Modified method Check_Delete___.
--  021216  Asawlk  Merged bug fixes in 2002-3 SP3
--  021031  IsWilk  Bug 33865, Modified the columns customer_unit_meas, conv_factor as mandatory in the VIEW
--  021031          Modified the PROCEDURE's Unpack_Check_Insert___,Unpack_Check_Update___.
--  001013  JoEd  Added method Get_Customer_Part_No.
--  ---------------------- 12.1 ---------------------------------------------
--  991007  JoEd  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  ---------------------- 11.1 ---------------------------------------------
--  990205  JakH  CID 8100: Added check on conversion factors <= 0.
--                SID 6408: Corrected, its supposed to be only a warning when
--                          the same sales part is given a new cross reference
--                          for the same customer.
--  981119  JoEd  SID 7047: Added check on user allowed site on insert.
--  981118  JoEd  SID 6408: Added unique check on sales part when inserting new record.
--  980209  ToOs  Bug fixes
--  971218  ToOs  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate_Receiving_Advice___
--   Validate the receiving advice type on sales part cross reference with
--   customer's setting.
PROCEDURE Validate_Receiving_Advice___ (
   customer_no_              IN VARCHAR2,
   receiving_advice_type_db_ IN VARCHAR2 )
IS
   cust_ord_cust_rec_  Cust_Ord_Customer_API.Public_Rec;
BEGIN
   cust_ord_cust_rec_     := Cust_Ord_Customer_API.Get(customer_no_);

   IF (cust_ord_cust_rec_.confirm_deliveries = 'FALSE' AND receiving_advice_type_db_ NOT IN ('DO_NOT_USE','USE_CUSTOMER_DEFAULT')) THEN
      Client_SYS.Add_Info(lu_name_, 'MISSINGCUSTDELIVCONF: Customer :P1 is not set up to use Delivery Confirmation.', customer_no_);
   END IF;
   IF (cust_ord_cust_rec_.receiving_advice_type = 'DO_NOT_USE' AND receiving_advice_type_db_ NOT IN ('DO_NOT_USE','USE_CUSTOMER_DEFAULT')) OR
      (cust_ord_cust_rec_.receiving_advice_type = 'ARRIVED_GOODS' AND receiving_advice_type_db_ = 'APPROVED_GOODS') OR
      (cust_ord_cust_rec_.receiving_advice_type = 'APPROVED_GOODS' AND receiving_advice_type_db_ = 'ARRIVED_GOODS') THEN
      Error_SYS.Record_General(lu_name_,'INVALIDRECADVTYPE: It is not allowed the receiving advice type :P1 for the customer :P2.', Receiving_Advice_Type_API.Decode(receiving_advice_type_db_), customer_no_ );
   END IF;
END Validate_Receiving_Advice___;


-- Synch_Min_Durab_Days_Co_Del___
--   synchronizes min_durab_days_co_deliv with the value of the new value.
--   All min_durab_days_co_deliv for a specific customer_no, contract and
--   catalog_no should be equal.
PROCEDURE Synch_Min_Durab_Days_Co_Del___ (
   customer_no_                 IN VARCHAR2,
   contract_                    IN VARCHAR2,
   catalog_no_                  IN VARCHAR2,
   new_min_durab_days_co_deliv_ IN NUMBER,
   old_min_durab_days_co_deliv_ IN NUMBER )
IS
   operation_           VARCHAR2(10) := 'MODIFY';
   count_               NUMBER;
   new_min_durab_days_  NUMBER;

   CURSOR get_min_durab_days(customer_no_ IN VARCHAR2,
                             contract_    IN VARCHAR2,
                             catalog_no_  IN VARCHAR2) IS
      SELECT min_durab_days_co_deliv
      FROM SALES_PART_CROSS_REFERENCE_TAB
      WHERE customer_no = customer_no_
      AND   contract = contract_
      AND   catalog_no = catalog_no_;
BEGIN

   new_min_durab_days_ := new_min_durab_days_co_deliv_;

   IF new_min_durab_days_ IS NULL AND old_min_durab_days_co_deliv_ IS NULL THEN
      operation_ := 'NEW';
      OPEN get_min_durab_days(customer_no_, contract_, catalog_no_);
      FETCH get_min_durab_days INTO new_min_durab_days_;
      CLOSE get_min_durab_days;
   END IF;

   UPDATE SALES_PART_CROSS_REFERENCE_TAB
      SET min_durab_days_co_deliv = new_min_durab_days_
      WHERE customer_no = customer_no_
      AND   contract = contract_
      AND   catalog_no = catalog_no_
      AND   NVL(min_durab_days_co_deliv,-999) != NVL(new_min_durab_days_,-999)
      RETURNING COUNT(*) INTO count_;

   IF count_ > 0 THEN
      IF operation_ = 'NEW' THEN
         Client_SYS.Add_Info(lu_name_, 'MINDURABSYNCHD: Minimum remaining days at CO delivery common to exiting Sales Part, Customer and site combination will be copied for this Customers Part No.');
      ELSE
         Client_SYS.Add_Info(lu_name_, 'MINDURABCHANGED: Minimum remaining days at CO delivery will be changed for all customer''s part numbers with same Sales part, Customer and site combination.');
      END IF;
   END IF;   
END Synch_Min_Durab_Days_Co_Del___;


-- Check_Cust_Sched_Agr_Part___
--   Check for the Customer Schedule Agreement Part Info Connected to the Customer's Part No
--   and raise a error or a warning message according to the status.
PROCEDURE Check_Cust_Sched_Agr_Part___ (
   customer_no_       IN  VARCHAR2,
   customer_part_no_  IN  VARCHAR2,
   contract_          IN  VARCHAR2 )
IS
   agreement_id_        VARCHAR2(20);
   active_agreement_id_ VARCHAR2(20);
BEGIN
   $IF Component_Cussch_SYS.INSTALLED $THEN
      agreement_id_ := Cust_Sched_Agreement_Part_API.Agreement_Part_Exist(customer_no_,customer_part_no_,contract_);
      IF (agreement_id_ IS NOT NULL) THEN
         active_agreement_id_ := Cust_Sched_Agreement_Part_API.Get_Active_Agreement_Part_Id(customer_no_, customer_part_no_, contract_);
         IF(active_agreement_id_ IS NOT NULL) THEN
            Error_Sys.Record_General(lu_name_, 'DELETE_NOT_ALLOWED: The customer part number :P1 is used in customer schedule agreement part :P2 on site :P3, and is in Active status. The sales part cross reference may not be deleted.',
                                     customer_part_no_, active_agreement_id_, contract_); 
         ELSE
            Client_SYS.Add_Warning(lu_name_, 'CUSTSCHEDAGREXIST: The customer part number :P1 is used in customer schedule agreement part :P2 on site :P3, and is in a status other than Active.',
                                   customer_part_no_, agreement_id_, contract_);
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Check_Cust_Sched_Agr_Part___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', User_Default_API.Get_Contract, attr_);
   Client_SYS.Add_To_Attr('SELF_BILLING_DB', 'NOT SELF BILLING', attr_);
   Client_SYS.Add_To_Attr('SELF_BILLING', Self_Billing_Type_API.Decode('NOT SELF BILLING'), attr_);
   Client_SYS.Add_To_Attr('RECEIVING_ADVICE_TYPE',Receiving_Advice_Type_API.Decode('USE_CUSTOMER_DEFAULT') , attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SALES_PART_CROSS_REFERENCE_TAB%ROWTYPE )
IS
BEGIN
   Check_Cust_Sched_Agr_Part___(remrec_.customer_no, remrec_.customer_part_no, remrec_.contract);
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_part_cross_reference_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(4000);
   exist_                   NUMBER;
   inv_part_                NUMBER;
   catalog_type_            VARCHAR2(4);
   cust_ord_cust_rec_       Cust_Ord_Customer_API.Public_Rec;
   inv_part_no_             VARCHAR2(25);

   CURSOR exist_catalog(customer_no_ IN VARCHAR2,
                        contract_    IN VARCHAR2,
                        catalog_no_  IN VARCHAR2) IS
      SELECT 1
      FROM  SALES_PART_CROSS_REFERENCE_TAB
      WHERE customer_no = customer_no_
      AND   contract = contract_
      AND   catalog_no = catalog_no_;

BEGIN
   Sales_Part_API.Exist(newrec_.contract, newrec_.catalog_no, Sales_Type_API.DB_SALES_AND_RENTAL);
   
   super(newrec_, indrec_, attr_);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   OPEN exist_catalog(newrec_.customer_no, newrec_.contract, newrec_.catalog_no);
   FETCH exist_catalog INTO exist_;
   IF (exist_catalog%FOUND) THEN
      Client_SYS.Add_Warning(lu_name_, 'DUPCROSSREFERENCE: There is already one record associating part no :P1 to customer :P2.', newrec_.catalog_no, newrec_.customer_no);
   END IF;
   CLOSE exist_catalog;

   IF ((newrec_.customer_unit_meas IS NOT NULL) AND (newrec_.conv_factor IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'CONV_FACTOR: Conversion factor must be set if the part has a unit.');
   END IF;

   IF (newrec_.conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'CONV_VAL_ERR: Conversion factor must be greater than 0.');
   END IF;
   
   IF (newrec_.inverted_conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVERTCONVFACTERR: Inverted Conversion factor must be greater than 0.');
   END IF;

   -- Both the conversion factor and the inverted conversion factor cannot have a value which is not equal to one at the same time.
   IF (newrec_.conv_factor != 1) THEN
      newrec_.inverted_conv_factor := 1;
   END IF;

   IF ((newrec_.min_durab_days_co_deliv < 0) OR
       (newrec_.min_durab_days_co_deliv != ROUND(newrec_.min_durab_days_co_deliv))) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDCODURABLELE: The minimum remaining durability days for the customer order delivery must be a positive integer value.');
   END IF;

   cust_ord_cust_rec_ := Cust_Ord_Customer_API.Get(newrec_.customer_no);   
   Validate_Receiving_Advice___(newrec_.customer_no, newrec_.receiving_advice_type);
   
   -- Inventory Part ID connected to the Sales Part Number can't be different from the Customer Part No.
   IF (cust_ord_cust_rec_.category = 'I') THEN
      IF (Site_API.Get_Company(newrec_.contract) = Site_API.Get_Company(cust_ord_cust_rec_.acquisition_site))THEN
         inv_part_no_ := Sales_Part_API.Get_Part_No(newrec_.contract, newrec_.catalog_no);
         IF (inv_part_no_ != newrec_.customer_part_no) THEN
            Error_SYS.Record_General(lu_name_, 'INVALID_PARTNAME: Inventory Part :P1 connected to Sales Part :P2 is not the same as Customer Part No, which is not allowed in the internal order flow.', inv_part_no_, newrec_.catalog_no);
         END IF;
      END IF;
   END IF;

   $IF (Component_Purch_SYS.INSTALLED) $THEN
      exist_    := Purchase_Part_API.Check_Exist(cust_ord_cust_rec_.acquisition_site, newrec_.customer_part_no);
      inv_part_ := Purchase_Part_API.Is_Inventory_Part(cust_ord_cust_rec_.acquisition_site, newrec_.customer_part_no);         
   $END
   
   IF (exist_ = 1) THEN
      IF (Site_API.Get_Company(newrec_.contract) = Site_API.Get_Company(cust_ord_cust_rec_.acquisition_site))THEN
         catalog_type_ := Sales_Part_API.Get_Catalog_Type_Db(newrec_.contract, newrec_.catalog_no);
         IF (((inv_part_= 1) AND (catalog_type_ = 'NON')) OR ((inv_part_= 0) AND (catalog_type_ = 'INV'))) THEN
            Error_SYS.Record_General(lu_name_, 'PART_MIXED: A mix of Inventory and Non Inventory Parts are not allowed for Inter site Transaction between two sites connected to the same company.');
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_part_cross_reference_tab%ROWTYPE,
   newrec_ IN OUT sales_part_cross_reference_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   Sales_Part_API.Exist(newrec_.contract, newrec_.catalog_no, Sales_Type_API.DB_SALES_AND_RENTAL);
   
   super(oldrec_, newrec_, indrec_, attr_);

   IF ((newrec_.customer_unit_meas IS NOT NULL) AND (newrec_.conv_factor IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'CONV_FACTOR: Conversion factor must be set if the part has a unit.');
   END IF;

   IF (newrec_.conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'CONV_VAL_ERR: Conversion factor must be greater than 0.');
   END IF;
   
   IF (newrec_.inverted_conv_factor <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVERTCONVFACTERR: Inverted Conversion factor must be greater than 0.');
   END IF;

   -- Both the conversion factor and the inverted conversion factor cannot have a value which is not equal to one at the same time
   IF (newrec_.conv_factor != 1) THEN
      newrec_.inverted_conv_factor := 1;
   END IF;

   IF ((newrec_.min_durab_days_co_deliv < 0) OR
       (newrec_.min_durab_days_co_deliv != ROUND(newrec_.min_durab_days_co_deliv))) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDCODURABLELE: The minimum remaining durability days for the customer order delivery must be a positive integer value.');
   END IF;

   Validate_Receiving_Advice___(newrec_.customer_no, newrec_.receiving_advice_type);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


PROCEDURE Check_Customer_No_Ref___ (
   newrec_ IN OUT sales_part_cross_reference_tab%ROWTYPE )
IS
   customer_category_ CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   IF (newrec_.customer_no IS NOT NULL) THEN
      customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
      IF customer_category_ = Customer_Category_API.DB_CUSTOMER THEN
         Cust_Ord_Customer_API.Exist(newrec_.customer_no);         
      ELSIF (customer_category_ = Customer_Category_API.DB_END_CUSTOMER) THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'NOTEXIST: Customer :P1 is not of category :P2 or :P3.', newrec_.customer_no, Customer_Category_API.Decode(Customer_Category_API.DB_CUSTOMER), Customer_Category_API.Decode(Customer_Category_API.DB_PROSPECT));  
      ELSE   
         Customer_Info_API.Exist(newrec_.customer_no, customer_category_);
      END IF;
   END IF;
END Check_Customer_No_Ref___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_     SALES_PART_CROSS_REFERENCE_TAB%ROWTYPE;
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      Synch_Min_Durab_Days_Co_Del___(newrec_.customer_no, newrec_.contract, newrec_.catalog_no, newrec_.min_durab_days_co_deliv, NULL);
      info_ := info_ || Client_SYS.Get_All_Info;
   END IF;
END New__;


@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_ SALES_PART_CROSS_REFERENCE_TAB%ROWTYPE;
   newrec_ SALES_PART_CROSS_REFERENCE_TAB%ROWTYPE;
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      IF (NVL(oldrec_.min_durab_days_co_deliv,-999) != NVL(newrec_.min_durab_days_co_deliv,-999)) THEN
         Synch_Min_Durab_Days_Co_Del___(newrec_.customer_no, newrec_.contract, newrec_.catalog_no, newrec_.min_durab_days_co_deliv, oldrec_.min_durab_days_co_deliv);
      END IF;
   END IF; 
   info_ := info_ || Client_SYS.Get_All_Info;
END Modify__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Customer_Part_No
--   Returns the first customer part for the customer and catalog number.
--   If no cross referenced part is defined for the customer, NULL is returned.
@UncheckedAccess
FUNCTION Get_Customer_Part_No (
   customer_no_ IN VARCHAR2,
   contract_    IN VARCHAR2,
   catalog_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ SALES_PART_CROSS_REFERENCE_TAB.customer_part_no%TYPE;

   CURSOR get_attr IS
      SELECT customer_part_no
      FROM SALES_PART_CROSS_REFERENCE_TAB
      WHERE customer_no = customer_no_
      AND contract = contract_
      AND catalog_no = catalog_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Customer_Part_No;


-- Check_Exist
--   Check whether the record exist or not
@UncheckedAccess
FUNCTION Check_Exist (
   customer_no_      IN VARCHAR2,
   contract_         IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   catalog_no_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_    NUMBER;
   dummy_   VARCHAR2(5) := 'FALSE';

   CURSOR getrec IS
      SELECT 1
        FROM SALES_PART_CROSS_REFERENCE_TAB
       WHERE customer_no      = customer_no_
         AND contract         = contract_
         AND customer_part_no = customer_part_no_
         AND catalog_no       = catalog_no_;

BEGIN

   OPEN getrec;
   FETCH getrec INTO temp_;
   IF (getrec%FOUND) THEN
      dummy_ := 'TRUE';
   ELSE
      dummy_ := 'FALSE';
   END IF;
   CLOSE getrec;
   RETURN dummy_;
END Check_Exist;

-- Get_Min_Durab_Days_For_Catalog
--   Returns min_durab_days_co_deliv for specific customer_no, contract and
@UncheckedAccess
FUNCTION Get_Min_Durab_Days_For_Catalog (
   customer_no_  IN VARCHAR2,
   contract_     IN VARCHAR2,
   catalog_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ SALES_PART_CROSS_REFERENCE_TAB.min_durab_days_co_deliv%TYPE;
   CURSOR get_attr IS
      SELECT min_durab_days_co_deliv
      FROM SALES_PART_CROSS_REFERENCE_TAB
      WHERE customer_no = customer_no_
      AND   contract = contract_
      AND   catalog_no = catalog_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Min_Durab_Days_For_Catalog;

-- Get_Latest_Customer_Part_No
--   Returns the latest modified customer part for the customer, contract and catalog number.
--   If no cross referenced part is defined for the customer, NULL is returned.
@UncheckedAccess
FUNCTION Get_Latest_Customer_Part_No (
   customer_no_ IN VARCHAR2,
   contract_    IN VARCHAR2,
   catalog_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ sales_part_cross_reference_tab.customer_part_no%TYPE;

   CURSOR get_attr IS
      SELECT customer_part_no
      FROM   sales_part_cross_reference_tab
      WHERE  customer_no = customer_no_
      AND    contract = contract_
      AND    catalog_no = catalog_no_
      ORDER BY rowversion DESC;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Latest_Customer_Part_No;
