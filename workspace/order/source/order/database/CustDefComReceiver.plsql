-----------------------------------------------------------------------------
--
--  Logical unit: CustDefComReceiver
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170208  MaIklk  STRSC-5319, Moved DML operations from Check_Insert___ and Check_Delete___ to Delete___ and Insert___.
--  150813  Wahelk  BLU-1192, Modified Copy_Customer method to add new parameter copy_info_
--  100513  Ajpelk  Merge rose method documentation
--  091203  DaGulk  Bug 86922, Removed view CUST_DEF_COM_RECEIVER_ENT.  
--  070504  NuVelk  Added new method Check_Comm_Receiver_Exist.
--  070320  AmPalk  Modified Copy_Customer to restrict insert new record if there is one exists already. Else problems arise when coping a customer from the Customer form.
--  060417  SaRalk  Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  060117  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  050922  SaMelk  Removed Unused variables.
--  050802  KiSalk  Bug 51603, In CUST_DEF_COM_RECEIVER's view comments reference 
--  050802          of customer_no to CustOrdCustomer, changed to 'CASCADE'.
--  031008  PrJalk  Bug Fix 106224, Changed incorrect General_Sys.Init_Method calls.
--  020610  DiKuUs  Bug 30139.  Added new method Copy_Customer
--  000710  JakH    Merged from Chameleon
--  000412  ThIs    Added methods New and Remove
--  000407  ThIs    Added VIEW_ENT
--  000406  BRO     Created
--  000406  DEHA    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN cust_def_com_receiver_tab%ROWTYPE )
IS
   salesman_code_ VARCHAR2(20);
BEGIN   
   salesman_code_ := Commission_Receiver_API.Get_Salesman_Code (remrec_.commission_receiver);
   IF (salesman_code_ IS NOT NULL) THEN
      IF (salesman_code_ = Cust_Ord_Customer_API.Get_Salesman_Code(remrec_.customer_no)) THEN
         Cust_Ord_Customer_API.Modify_Commission_Receiver(remrec_.customer_no, Create_Com_Receiver_API.Decode('DONOTCREATE'));
      END IF;
   END IF;
   super(objid_,remrec_);
END Delete___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT cust_def_com_receiver_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS  
   salesman_code_ VARCHAR2(20);
BEGIN   
   salesman_code_ := Commission_Receiver_API.Get_Salesman_Code (newrec_.commission_receiver);
   IF (salesman_code_ IS NOT NULL) THEN
      IF (salesman_code_ = Cust_Ord_Customer_API.Get_Salesman_Code(newrec_.customer_no)) THEN
         Cust_Ord_Customer_API.Modify_Commission_Receiver(newrec_.customer_no, Create_Com_Receiver_API.Decode('CREATE'));
      END IF;
   END IF;
   super(objid_,objversion_,newrec_,attr_);
END Insert___;
 
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new record
PROCEDURE New (
   commission_receiver_ IN VARCHAR2,
   customer_no_         IN VARCHAR2 )
IS
   newrec_        CUST_DEF_COM_RECEIVER_TAB%ROWTYPE;
   attr_          VARCHAR2(2000);
   objid_         VARCHAR2(200);
   objversion_    VARCHAR2(200);
   indrec_        Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('COMMISSION_RECEIVER', commission_receiver_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Remove
--   Deletes a record
PROCEDURE Remove (
   commission_receiver_ IN VARCHAR2,
   customer_no_         IN VARCHAR2 )
IS
   objid_             CUST_DEF_COM_RECEIVER.objid%TYPE;
   objversion_        VARCHAR2(2000);
   remrec_            CUST_DEF_COM_RECEIVER_TAB%ROWTYPE;

BEGIN

   Get_Id_Version_By_Keys___ (
      objid_,
      objversion_,
      commission_receiver_,
      customer_no_ );

   IF objid_ IS NOT NULL THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
END Remove;


-- Copy_Customer
--   Copy default commission receiver data when copying a customer.
PROCEDURE Copy_Customer (
   customer_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2,
   copy_info_   IN  Customer_Info_API.Copy_Param_Info)
IS
   CURSOR get_cust IS 
   SELECT * 
      FROM CUST_DEF_COM_RECEIVER_TAB
      WHERE customer_no = customer_id_;
BEGIN
     FOR newrec_ IN get_cust LOOP
        -- Do not  redundantly insert a record while in the RMB Copy Customer.. process. 
        IF NOT(Check_Exist___(newrec_.commission_receiver,new_id_)) THEN
            New (newrec_.commission_receiver,new_id_);
        END IF;
     END LOOP;
END Copy_Customer;


-- Check_Comm_Receiver_Exist
--   Check if the commission receiver already exists
@UncheckedAccess
FUNCTION Check_Comm_Receiver_Exist (
   commission_receiver_ IN VARCHAR2,
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   found_   BOOLEAN:= FALSE;
BEGIN
   found_ := Check_Exist___(commission_receiver_,customer_no_);
   IF found_ THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Comm_Receiver_Exist;



