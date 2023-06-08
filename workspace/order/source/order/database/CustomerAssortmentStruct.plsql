-----------------------------------------------------------------------------
--
--  Logical unit: CustomerAssortmentStruct
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210528  SWiclk   COM21R2-89, Modified Update___() in order to set Limit Sales for Nodes for the Commerce(B2B) functionality.
--  210528           Modified Delete___() methods in order to delete Customer Assortment Node(s) when deleting assortment.
--  170522  SURBLK   Added Check_Cus_Conn_Other_Assorts() to indicate the particular customer has limited the sales for another assortment.
--  170503  SURBLK   Modified Update___() to fetch default_assortment as TRUE when only a classification standard is defined.
--  170117  SURBLK   Added Check_Limit_Sales_To_Assorts().
--  150813  Wahelk   BLU-1192, Modified Copy_Customer method to add new parameter copy_info_
--  140415  JanWse   PBSC-8348, Set ROWKEY to NULL before inserting in Copy_Customer
--  120316  JeLise   Added new method Copy_Customer.
--  110917  NaLrlk   Modified the method Unpack_Check_Insert___ to validate the connected assortment.
--  081211  KiSalk   Added new method Delete_Assortment_Connections.
--  080328  MaHplk   Added new method Check_Assort_Connected_Cust.
--  080304  KiSalk   Created
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
   Client_SYS.Add_To_Attr('default_assortment_db', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('LIMIT_SALES_TO_ASSORTMENTS_DB', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_ASSORTMENT_STRUCT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN

   IF(newrec_.classification_standard IS NOT NULL) THEN
      IF (Find_Default_Assortment(newrec_.customer_no) IS NULL) THEN
         newrec_.default_assortment := 'TRUE';
      ELSE
         IF (newrec_.default_assortment = 'TRUE') THEN
            UPDATE CUSTOMER_ASSORTMENT_STRUCT_TAB
               SET default_assortment = 'FALSE'
               WHERE customer_no = newrec_.customer_no
                 AND default_assortment = 'TRUE';
         END IF;
      END IF;
   ELSE
      newrec_.default_assortment := 'FALSE';
   END IF;
      
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOMER_ASSORTMENT_STRUCT_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOMER_ASSORTMENT_STRUCT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN

   IF (newrec_.default_assortment = 'TRUE') THEN
      UPDATE CUSTOMER_ASSORTMENT_STRUCT_TAB
         SET default_assortment = 'FALSE'
         WHERE customer_no = newrec_.customer_no
           AND default_assortment = 'TRUE';
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   IF (newrec_.default_assortment = 'FALSE' AND newrec_.classification_standard IS NOT NULL AND  Find_Default_Assortment(newrec_.customer_no) IS NULL) THEN
      -- Reset default_assortment if no row is default at this point. This will be corrected in next call to
      -- Update___, if un-set this one and set another row default in multi row change at client side.
      UPDATE CUSTOMER_ASSORTMENT_STRUCT_TAB
         SET default_assortment = 'TRUE'
         WHERE customer_no = newrec_.customer_no
           AND assortment_id = newrec_.assortment_id;
   END IF;
   
   -- Note: This is for the Storefornt Manager funtoinality in Commerce (B2B).
   IF (Dictionary_SYS.Component_Is_Active('SALBB')) THEN
      IF (oldrec_.limit_sales_to_assortments = 'TRUE' AND newrec_.limit_sales_to_assortments = 'FALSE') THEN
         Customer_Assortment_Node_API.Modify_Limit_Sales_To_Node_All(newrec_.customer_no, newrec_.assortment_id, newrec_.limit_sales_to_assortments);
      END IF;      
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN customer_assortment_struct_tab%ROWTYPE )
IS
BEGIN   
   super(objid_, remrec_);
   -- Note: This is for the Storefornt Manager funtoinality in Commerce (B2B).
   IF (Dictionary_SYS.Component_Is_Active('SALBB')) THEN      
      Customer_Assortment_Node_API.Delete_All_By_Assortment_Id(remrec_.customer_no, remrec_.assortment_id);
   END IF;
END Delete___;

@Override
PROCEDURE Delete___ (
   remrec_ IN customer_assortment_struct_tab%ROWTYPE )
IS
BEGIN   
   super(remrec_);
   -- Note: This is for the Storefornt Manager funtoinality in Commerce (B2B).
   IF (Dictionary_SYS.Component_Is_Active('SALBB')) THEN      
      Customer_Assortment_Node_API.Delete_All_By_Assortment_Id(remrec_.customer_no, remrec_.assortment_id);
   END IF;  
END Delete___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUSTOMER_ASSORTMENT_STRUCT_TAB%ROWTYPE )
IS
   dummy_ NUMBER;
   CURSOR non_defaults_exist_control(customer_no_ VARCHAR2) IS
      SELECT 1
      FROM   CUSTOMER_ASSORTMENT_STRUCT_TAB
      WHERE  default_assortment = 'FALSE'
      AND    customer_no = customer_no_
      AND    classification_standard IS NOT NULL;
BEGIN

   IF (remrec_.default_assortment = 'TRUE') THEN
      OPEN non_defaults_exist_control(remrec_.customer_no);
      FETCH non_defaults_exist_control INTO dummy_;
      IF (non_defaults_exist_control%FOUND) THEN
         CLOSE non_defaults_exist_control;
         Error_SYS.Record_General(lu_name_ , 'DELETEDEFAULTROW: It is not possible to remove the default classification standard when other classification standards exists for the customer.');
      END IF;
      CLOSE non_defaults_exist_control;
   END IF;

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_assortment_struct_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);

   IF ((newrec_.classification_standard IS NOT NULL) AND (Assortment_Structure_API.Get_Assort_For_Classification(newrec_.classification_standard) IS NULL)) THEN
      Error_SYS.Record_General(lu_name_ , 'NOTCONNACTIVEASSORT: The Classification Standard is not connected to an active assortment.');
   END IF;

   IF (Assortment_Structure_API.Get_Objstate(newrec_.assortment_id) != 'Active') THEN
      Error_SYS.Record_General(lu_name_ , 'NOTACTIVEASSORT: Only active assortments can be connected to a customer.');
   END IF;
END Check_Insert___;


@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ IN customer_assortment_struct_tab%ROWTYPE ) 
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'RECORDEXIST: The Customer Assortment already exists.');
   super(rec_);
END Raise_Record_Exist___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Find_Default_Assortment (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ASSORTMENT_STRUCT_TAB.assortment_id%TYPE;
   CURSOR get_attr IS
      SELECT assortment_id
      FROM CUSTOMER_ASSORTMENT_STRUCT_TAB
      WHERE default_assortment= 'TRUE'
      AND customer_no = customer_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Find_Default_Assortment;


@UncheckedAccess
FUNCTION Check_Assort_Connected_Cust (
   assortment_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   return_val_         NUMBER:=1;
   temp_               NUMBER;
   CURSOR cust_connect IS
      SELECT 1
      FROM CUSTOMER_ASSORTMENT_STRUCT_TAB
      WHERE assortment_id = assortment_id_;
BEGIN
   OPEN cust_connect;
   FETCH cust_connect INTO temp_;
   IF (cust_connect%NOTFOUND)THEN
      return_val_ := 0;
   END IF;
   CLOSE cust_connect;
   RETURN return_val_;
END Check_Assort_Connected_Cust;


-- Check_Cus_Conn_Other_Assorts
-- Check whether the customer connected for other 
-- assortments with limited sales.  
FUNCTION Check_Cus_Conn_Other_Assorts (
   customer_no_ IN VARCHAR2,
   assortment_id_ IN VARCHAR2) RETURN NUMBER
IS
   return_val_         NUMBER:=1;
   temp_               NUMBER;
   CURSOR cust_connect IS
      SELECT 1
        FROM CUSTOMER_ASSORTMENT_STRUCT_TAB
       WHERE customer_no = customer_no_
         AND assortment_id != assortment_id_
         AND limit_sales_to_assortments = 'TRUE';
BEGIN
   OPEN cust_connect;
   FETCH cust_connect INTO temp_;
   IF (cust_connect%NOTFOUND)THEN
      return_val_ := 0;
   END IF;
   CLOSE cust_connect;
   RETURN return_val_;
END Check_Cus_Conn_Other_Assorts;


-- Delete_Assortment_Connections
--   Delete all records with assortment_id_
PROCEDURE Delete_Assortment_Connections(
   assortment_id_ IN VARCHAR2 )
IS
   remrec_ CUSTOMER_ASSORTMENT_STRUCT_TAB%ROWTYPE;
   CURSOR get_records IS
      SELECT customer_no, rowid
      FROM CUSTOMER_ASSORTMENT_STRUCT_TAB
      WHERE assortment_id = assortment_id_;
BEGIN


   FOR rec_ IN get_records LOOP
      remrec_ := Lock_By_Keys___(rec_.customer_no, assortment_id_);
      Check_Delete___(remrec_);
      Delete___(rec_.rowid, remrec_);
   END LOOP;

END Delete_Assortment_Connections;


-- Copy_Customer
--   Copy the assortment structure of the customer to a new customer
PROCEDURE Copy_Customer (
   customer_no_ IN VARCHAR2,
   new_id_      IN VARCHAR2,
   copy_info_   IN  Customer_Info_API.Copy_Param_Info)
IS
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   indrec_     Indicator_Rec;

   CURSOR get_charges IS
      SELECT *
      FROM CUSTOMER_ASSORTMENT_STRUCT_TAB
      WHERE customer_no = customer_no_;
BEGIN

   FOR newrec_ IN get_charges LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_NO', new_id_, attr_);
      newrec_.rowkey := NULL;
     
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;

   Client_SYS.Clear_Info;
END Copy_Customer;

PROCEDURE Update_Assortment_Connections(
   assortment_id_             IN VARCHAR2,
   classification_standard_   IN VARCHAR2 )
IS
   oldrec_     CUSTOMER_ASSORTMENT_STRUCT_TAB%ROWTYPE;
   newrec_     CUSTOMER_ASSORTMENT_STRUCT_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   
   CURSOR get_records IS
      SELECT customer_no, rowid
      FROM CUSTOMER_ASSORTMENT_STRUCT_TAB
      WHERE assortment_id = assortment_id_;
BEGIN
   FOR rec_ IN get_records LOOP
      oldrec_ := Lock_By_Keys___(rec_.customer_no, assortment_id_);
      newrec_ := oldrec_;
      newrec_.classification_standard := classification_standard_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END LOOP;
END Update_Assortment_Connections;


@UncheckedAccess
FUNCTION Check_Limit_Sales_To_Assorts (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_val_         VARCHAR2(20):= 'TRUE';
   temp_               NUMBER;
   CURSOR limit_sales IS
      SELECT 1
      FROM   customer_assortment_struct_tab
      WHERE  customer_no = customer_no_ 
	   AND    limit_sales_to_assortments = 'TRUE' ;
BEGIN
   OPEN limit_sales;
   FETCH limit_sales INTO temp_;
   IF (limit_sales%NOTFOUND)THEN
      return_val_ := 'FALSE';
   END IF;
   CLOSE limit_sales;
   RETURN return_val_;
END Check_Limit_Sales_To_Assorts;

