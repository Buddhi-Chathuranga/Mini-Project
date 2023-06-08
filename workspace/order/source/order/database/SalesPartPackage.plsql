-----------------------------------------------------------------------------
--
--  Logical unit: SalesPartPackage
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140603  MaEdlk  Bug 117072, Removed rounding of variable package_weight_ in method Get_Package_Weight.
--  111130  JeLise  Added check on newrec_.qty_per_assembly = 0 in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  110131  Nekolk  EANE-3744  added where clause to View SALES_PART_PACKAGE
--  100514  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090709  IrRalk  Bug 82835, Modified Get_Package_Weight to round weight to 4 decimals.
--  071227  ChJalk  Bug 69400, Added Function Exist_Inactive_Components.
--  071217  MaRalk  Bug 68703, Added new public method Check_Exist.
--  070913  ChBalk  Bug 67061, Unpack_Check_Insert___ was modified, a validation introduced to 
--  070913          block insertion of pkg parts as component parts to a pkg part.
--  060112  IsWilk  Modified the PROCEDURE Insert__ according to template 2.3.
--  051222  JoEd    Removed check on SalesPart "configurator" flag.
--  011218  Prinlk Added the method Get_Package_Weight to obtain weight of the 
--                 package part
--  ********************* VSHSB Merge *****************************
--  040114  LoPrlk  Rmove public cursors, Cursor get_package_ingridients was removed.
--  -----------------EDGE Package Group 2------------------------------------
--  020820  JoAnSe  Bug 19110 Added check for configured package component in
--  020820          Unpack_Check_Insert___.  
--  000913  FBen    Added UNDEFINED.
--  991007  JoEd    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990928  JoEd    Added check on package header's configuration column.
--                  Added method Exist_Components.
--  ----------------------- 11.1 --------------------------------------------
--  990419  RaKu    Y.Cleanup.
--  981208  JoEd    Changed comment for qty_per_assembly.
--  971125  RaKu    Changed to FND200 Templates.
--  970312  RaKu    Changed table name.
--  970219  RaKu    Changed rowversion (10.3 Project).
--  960219  SVLO    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SALES_PART_PACKAGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Retrieve the next available line_item_no
   Sales_Part_API.Get_Next_Line_Item_No(newrec_.line_item_no, newrec_.contract, newrec_.parent_part);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_part_package_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (indrec_.contract = FALSE) THEN
      newrec_.contract := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   END IF;

   super(newrec_, indrec_, attr_);
   
   Sales_Part_API.Check_If_Valid_Component(newrec_.contract, newrec_.catalog_no);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   
   IF (newrec_.qty_per_assembly < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOT_ALLOWED: Negative numbers are not allowed');
   ELSIF (newrec_.qty_per_assembly = 0) THEN
      Error_SYS.Record_General(lu_name_, 'ZEROQTY: The Qty/Assembly must be greater than zero');
   END IF;

   IF (Sales_Part_API.Get_Configurable_Db(newrec_.contract, newrec_.catalog_no) = 'CONFIGURED') THEN
      Error_SYS.Record_General(lu_name_, 'NO_CONF_COMP: Configured parts may not be entered as package components!');
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_part_package_tab%ROWTYPE,
   newrec_ IN OUT sales_part_package_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.qty_per_assembly < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOT_ALLOWED: Negative numbers are not allowed');
   ELSIF (newrec_.qty_per_assembly = 0) THEN
      Error_SYS.Record_General(lu_name_, 'ZEROQTY: The Qty/Assembly must be greater than zero');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Exist_Components (
   contract_    IN VARCHAR2,
   parent_part_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM SALES_PART_PACKAGE_TAB
      WHERE parent_part = parent_part_
      AND   contract = contract_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Exist_Components;


-- Exist_Inactive_Components
--   Checks if there are inactive component parts for a given package part and
--   returns 1 if there are. Else returns 0.
@UncheckedAccess
FUNCTION Exist_Inactive_Components (
   contract_    IN VARCHAR2,
   parent_part_ IN VARCHAR2 ) RETURN NUMBER
IS
   exist_ NUMBER := 0;

   CURSOR inactive_components IS
      SELECT 1
      FROM sales_part_tab
      WHERE activeind = 'N'
      AND   contract = contract_
      AND   (catalog_no IN (SELECT catalog_no
                            FROM sales_part_package_tab
                            WHERE parent_part = parent_part_
                            AND   contract = contract_)
            OR
             catalog_no IN (SELECT replacement_part_no
                            FROM sales_part_tab
                            WHERE contract = contract_
                            AND replacement_part_no IS NOT NULL
                            AND date_of_replacement <= Site_API.Get_Site_Date(contract_)
                            AND catalog_no IN (SELECT catalog_no
                                               FROM sales_part_package_tab
                                               WHERE parent_part = parent_part_
                                               AND   contract = contract_)));
   

BEGIN
   OPEN inactive_components;
   FETCH inactive_components INTO exist_;
   CLOSE inactive_components;
   IF (exist_ IS NULL) THEN
      exist_ := 0;
   END IF;
   RETURN exist_;
END Exist_Inactive_Components;


-- Get_Package_Weight
--   Returns the total weight of the package based on the corresponding
--   Inventory Part's weights.
@UncheckedAccess
FUNCTION Get_Package_Weight (
   contract_    IN VARCHAR2,
   parent_part_ IN VARCHAR2 ) RETURN NUMBER
IS
   package_weight_ NUMBER;
   CURSOR pack_weight IS 
      SELECT SUM(Inventory_Part_API.Get_Weight_Net(contract, catalog_no) * qty_per_assembly)
      FROM SALES_PART_PACKAGE_TAB 
      WHERE contract = contract_ 
      AND   parent_part = parent_part_;
BEGIN
   OPEN pack_weight;
   FETCH pack_weight INTO package_weight_;
   IF(pack_weight%NOTFOUND) THEN
      CLOSE pack_weight;
      RETURN NULL;      
   ELSE
      CLOSE pack_weight;
      RETURN package_weight_;
   END IF;
END Get_Package_Weight;


-- Check_Exist
--   Returns TRUE if there exists a record match with the given contract,
--   Parent Part and Component Part.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_        IN VARCHAR2,
   parent_part_     IN VARCHAR2,
   component_part_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, parent_part_, component_part_);
END Check_Exist;



