-----------------------------------------------------------------------------
--
--  Logical unit: CustHierarchyStruct
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180118  SeJalk  SCUXXW4-9062, Added Get_Top_Cust to get the root customer id for a hierachy.
--  190117  ChBnlk  Bug 145677(SCZ-2164), Modified Get_Level_No() by removing the initialization of customer_level_ in order to return NULL
--  190117          when there's no record in the customer hierarchy.
--  190117          when there's no record in the customer hierarchy.
--  170814  JeeJlk  Bug 136908, Modified Get_Level_No to improve the performance.
--  170405  AmPalk  STRMF-10698, Added Customer_No_Tab and Get_Customers_In_Level.
--  140310  ShVese  Removed Override annotation from the Check_Customer_Parent_Ref___.
--  100513  Ajpelk  Merge rose method documentation
------------------------------Eagle--------------------------------------------
--  080505  KiSalk   Added check exist condition to Customer_Hierarchy_Level_API.New call and added language translation in New__.
--  080424  JeLise   Made additional changes in Get_Level_No.
--  080422  JeLise   Rewrote Get_Level_No.
--  080313  MaHplk  Merged APP75 SP1
--  --------------------------APP75 SP1 merge - End ---------------------------------------------
--  080202  MaRalk  Bug 68752, Added view CUSTOMER_PARENTS.
--  --------------------------APP75 SP1 merge - Start ---------------------------------------------
--  080227  JeLise   Fixed red code in IFS/Design.
--  080121  JeLise   Added call to Customer_Hierarchy_Level_API.New in New__.
--  080121           Added two new methods Get_Level_No and Get_Cust_Level_Name.
--  ************************* Nice Price *************************
--  060418  MaJalk  Enlarge Identity - Changed view comments customer_parent.
--  --------------------------------- 13.4.0 ----------------------------------
--  060117  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  040114  LoPrlk  Rmove public cursors, Cursor get_parent_customer was replaced by function Get_Parent_Cust.
--  ---------------------------------13.3.0------------------------------------
--  001023  MaGu    Modified cursor get_parent_customer.
--  001011  MaGu    Added public cursor get_parent_customer.
--  001003  JoEd    Added method Get_Hierarchy_Id.
--  000920  JoEd    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Customer_No_Tab IS TABLE OF CUST_HIERARCHY_STRUCT_TAB.customer_no%TYPE
  INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Exist_Customer___
--   Returns whether or not a specific customer's already connected to a
PROCEDURE Exist_Customer___ (
   customer_no_ IN VARCHAR2 )
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM CUST_HIERARCHY_STRUCT_TAB
      WHERE customer_no = customer_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF (found_ = 1) THEN
      Error_SYS.Record_General(lu_name_, 'CUSTOMER_EXIST: Customer :P1 is already connected to a hierarchy.', customer_no_);
   END IF;
END Exist_Customer___;


-- Exist_Top_Customer___
--   Checks if a root customer is already added to a hierarchy..
PROCEDURE Exist_Top_Customer___ (
   hierarchy_id_ IN VARCHAR2 )
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM CUST_HIERARCHY_STRUCT_TAB
      WHERE hierarchy_id = hierarchy_id_
      AND customer_parent = '*';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF (found_ = 1) THEN
      Error_SYS.Record_General(lu_name_, 'ROOT_CUSTOMER_EXIST: A root customer is already added to hierarchy :P1.', hierarchy_id_);
   END IF;
END Exist_Top_Customer___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CUST_HIERARCHY_STRUCT_TAB%ROWTYPE )
IS
   CURSOR get_children(hierarchy_id_ IN VARCHAR2, customer_parent_ IN VARCHAR2) IS
      SELECT rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion
      FROM CUST_HIERARCHY_STRUCT_TAB
      WHERE hierarchy_id = hierarchy_id_
      AND customer_parent = customer_parent_;

   childrec_  CUST_HIERARCHY_STRUCT_TAB%ROWTYPE;
BEGIN
   super(objid_, remrec_);

   -- remove all branches ("children") to this customer
   FOR rec_ IN get_children(remrec_.hierarchy_id, remrec_.customer_no) LOOP
      childrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      Trace_SYS.Message('Removing child ' || childrec_.customer_no);
      Check_Delete___(childrec_);
      Delete___(rec_.objid, childrec_);
   END LOOP;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_hierarchy_struct_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(newrec_, indrec_, attr_);

   Exist_Customer___(newrec_.customer_no);
   IF (newrec_.customer_parent = '*') THEN
      Exist_Top_Customer___(newrec_.hierarchy_id);
   END IF;
END Check_Insert___;

PROCEDURE Check_Customer_Parent_Ref___ (
   newrec_ IN OUT NOCOPY cust_hierarchy_struct_tab%ROWTYPE )
IS
   
BEGIN   
   -- Parent ROOT_CUSTOMER defines top level.
   IF (nvl(newrec_.customer_parent, ' ') != '*') THEN
      Cust_Ord_Customer_API.Exist(newrec_.customer_parent);
   END IF;
END Check_Customer_Parent_Ref___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_ CUST_HIERARCHY_STRUCT_TAB%ROWTYPE;
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      newrec_ := Get_Object_By_Id___(objid_);
      IF (newrec_.customer_parent = '*' AND Customer_Hierarchy_Level_API.Check_Exist(newrec_.hierarchy_id, 1) = 0) THEN
         Customer_Hierarchy_Level_API.New(newrec_.hierarchy_id, 1, Language_SYS.Translate_Constant(lu_name_, 'ROOT_LEVEL: Root Level'));
      END IF;
      info_ := info_ || Client_SYS.Get_All_Info;
   END IF;
END New__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Remove_Customer
--   Removes the customer plus it's children from the hierarchy.
PROCEDURE Remove_Customer (
   hierarchy_id_ IN VARCHAR2,
   customer_no_  IN VARCHAR2 )
IS
   CURSOR get_customer IS
      SELECT rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion
      FROM CUST_HIERARCHY_STRUCT_TAB
      WHERE customer_no = customer_no_
      AND hierarchy_id = hierarchy_id_;

   rec_     get_customer%ROWTYPE;
   found_   BOOLEAN;
   remrec_  CUST_HIERARCHY_STRUCT_TAB%ROWTYPE;
BEGIN
   Trace_SYS.Field('customer_no_', customer_no_);
   OPEN get_customer;
   FETCH get_customer INTO rec_;
   found_ := get_customer%FOUND;
   CLOSE get_customer;

   IF found_ THEN
      remrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      Trace_SYS.Field('Found customer', remrec_.customer_no);
      Check_Delete___(remrec_);
      Delete___(rec_.objid, remrec_);
   ELSE
      Trace_SYS.Message('Customer ''' || customer_no_ || ''' not found');
   END IF;
END Remove_Customer;


-- Modify_Customer_Parent
--   Used in client when moving around a customer using drag and drop in the
--   tree list. Customer_Parent is part of the key. It's not standard behaviour
--   to update the key, but here it's better to modify than removing the
--   record and insert it again right after that.
PROCEDURE Modify_Customer_Parent (
   hierarchy_id_    IN VARCHAR2,
   customer_no_     IN VARCHAR2,
   customer_parent_ IN VARCHAR2 )
IS
   CURSOR get_customer IS
      SELECT rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion
      FROM CUST_HIERARCHY_STRUCT_TAB
      WHERE customer_no = customer_no_
      AND hierarchy_id = hierarchy_id_;

   rec_     get_customer%ROWTYPE;
   found_   BOOLEAN;
   oldrec_  CUST_HIERARCHY_STRUCT_TAB%ROWTYPE;
   newrec_  CUST_HIERARCHY_STRUCT_TAB%ROWTYPE;
   attr_    VARCHAR2(2000);
   indrec_  Indicator_Rec;
BEGIN
   Trace_SYS.Field('customer_no_', customer_no_);
   OPEN get_customer;
   FETCH get_customer INTO rec_;
   found_ := get_customer%FOUND;
   CLOSE get_customer;

   IF found_ THEN
      oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      Trace_SYS.Field('Found customer', oldrec_.customer_no);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_PARENT', customer_parent_, attr_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);          
      -- if updating using keys, it doesn't work...
      Update___(rec_.objid, oldrec_, newrec_, attr_, rec_.objversion);
   ELSE
      Trace_SYS.Message('Customer ''' || customer_no_ || ''' not found');
   END IF;
END Modify_Customer_Parent;


-- Get_Hierarchy_Id
--   Returns the hierarchy_id for a specific customer.
--   A customer can only belong to one hierarchy.
@UncheckedAccess
FUNCTION Get_Hierarchy_Id (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_  CUST_HIERARCHY_STRUCT_TAB.hierarchy_id%TYPE;
   CURSOR get_attr IS
      SELECT hierarchy_id
      FROM CUST_HIERARCHY_STRUCT_TAB
      WHERE customer_no = customer_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Hierarchy_Id;


-- Get_Parent_Cust
--   Returns the parent customer for a given object.
--   Added in the process of removing the public cursor GetParentCustomer
@UncheckedAccess
FUNCTION Get_Parent_Cust (
   hierarchy_id_ IN VARCHAR2,
   customer_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;

   CURSOR get_parent IS
      SELECT customer_parent
      FROM   CUST_HIERARCHY_STRUCT_TAB
      WHERE  hierarchy_id = hierarchy_id_
      AND    customer_no = customer_no_;

BEGIN
   OPEN  get_parent;
   FETCH get_parent INTO temp_;
   CLOSE get_parent;

   IF temp_ != '*' THEN
      RETURN temp_;
   END IF;

   RETURN NULL;
END Get_Parent_Cust;

-- Get_Top_Cust
--   Returns the root customer for a given hirachy.
@UncheckedAccess
FUNCTION Get_Top_Cust (
   hierarchy_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;

   CURSOR get_parent IS
      SELECT customer_no
      FROM   CUST_HIERARCHY_STRUCT_TAB
      WHERE  hierarchy_id = hierarchy_id_
      AND    customer_parent = '*';

BEGIN
   OPEN  get_parent;
   FETCH get_parent INTO temp_;
   CLOSE get_parent;
   RETURN temp_;

END Get_Top_Cust;


@UncheckedAccess
FUNCTION Get_Level_No (
   hierarchy_id_ IN VARCHAR2,
   customer_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   customer_level_   NUMBER;

   CURSOR get_parent (hierarchy_id_ IN VARCHAR2, customer_no_ IN VARCHAR2) IS 
      SELECT level as customer_level 
       FROM   CUST_HIERARCHY_STRUCT_TAB
       WHERE customer_no = customer_no_ AND hierarchy_id = hierarchy_id_
       START WITH customer_parent='*'
       CONNECT BY customer_parent= PRIOR customer_no;

BEGIN
   -- Cannot use Get_Parent_Cust since '*' is necessary to get back when no customer_parent exists in the hierarchy
   OPEN get_parent(hierarchy_id_, customer_no_);
   FETCH get_parent INTO customer_level_;
   CLOSE get_parent;

   RETURN customer_level_;
END Get_Level_No;


@UncheckedAccess
FUNCTION Get_Cust_Level_Name (
   hierarchy_id_  IN VARCHAR2,
   customer_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   customer_level_   NUMBER;

BEGIN
   customer_level_ := Get_Level_No(hierarchy_id_, customer_no_);

   RETURN Customer_Hierarchy_Level_API.Get_Name(hierarchy_id_,customer_level_);
END Get_Cust_Level_Name;


FUNCTION Get_Customers_In_Level (
   hierarchy_id_        IN VARCHAR2,
   customer_level_      IN NUMBER) RETURN Customer_No_Tab
IS 
   CURSOR get_all_in_level IS 
      SELECT customer_no
      FROM CUST_HIERARCHY_STRUCT_TAB
      WHERE  hierarchy_id = hierarchy_id_
      AND NVL(Get_Level_No(hierarchy_id, customer_no), -1) = customer_level_;
   customer_no_tab_  Customer_No_Tab;
 BEGIN
   OPEN get_all_in_level;
   FETCH get_all_in_level BULK COLLECT INTO customer_no_tab_;
   CLOSE get_all_in_level;
   RETURN customer_no_tab_;
END Get_Customers_In_Level;

