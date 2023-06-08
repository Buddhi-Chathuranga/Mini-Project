-----------------------------------------------------------------------------
--
--  Logical unit: CustOrderTemplateLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140311  ShVese Removed Override annotation from the method Check_Catalog_No_Ref___.
--  140116  NaSalk Added new column rental.
--  121016  MeAblk Bug 105702, Added standard_qty2 into the view CUST_ORDER_TEMPLATE in order to use it in dlgCustomerOrderTemplate.tblCustOrderTemplateLine.
--  110131  Nekolk EANE-3744  added where clause to View CUST_ORDER_TEMPLATE_LINE,CUST_ORDER_TEMPLATE,ORDER_QUOTATION_TEMPLATE.
--  081126  MaMalk Bug 78270, Modified views CUST_ORDER_TEMPLATE and ORDER_QUOTATION_TEMPLATE to include cutomer_part_no.    
--  080730  RoJalk Bug 74912, Added condition_code to CUST_ORDER_TEMPLATE and ORDER_QUOTATION_TEMPLATE.
--  060605  SaRalk Enlarge Part Description - Changed variable definitions.
--  060601  MiErlk Enlarge Identity - Changed view comments Description.
--  --------------------------------- 13.4.0 --------------------------------
--  060110  CsAmlk Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  050922  SaMelk Removed unused variables.
--  050906  NaLrlk Modified substrb to SUBSTR in views CUST_ORDER_TEMPLATE and ORDER_QUOTATION_TEMPLATE.
--  050615  ToBe   Bug 51090, Added catalog_desc to the views CUST_ORDER_TEMPLATE
--                 and ORDER_QUOTATION_TEMPLATE.
--  050120  ToBe   Bug 49049, Added line_no and rel_no to the views CUST_ORDER_TEMPLATE
--                 and ORDER_QUOTATION_TEMPLATE.
--  040219  IsWilk Modified the SUBSTRB to SUBSTR for Unicode Changes.
--  -------------- Edge Package Group 3 Unicode Changes-----------------------
--  000914  JoEd   Changed the TEMPLATE and TEMPLATE2 views to use tables
--                 instead of views.
--  000913  FBen   Added UNDEFINE.
--  000719  TFU    Merging from Chameleon
--  000605  GBO    Added view ORDER_QUOTATION_TEMPLATE
--  --------------------------- 12.1 ----------------------------------------
--  991026  PaLj  CID 24332. Added objstate to view CUST_ORDER_TEMPLATE
--  991007  JoEd  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  991007  JoEd  Call Id 21210: Corrected double-byte problems.
--  --------------------------- 11.1 ----------------------------------------
--  990528  JoEd  Call id 18681: Rebuild TEMPLATE view to not handle components.
--  990527  JoEd  Call id 18629: Standard qty may not be negative.
--  990511  RaKu  Changed VIEW to TABLE in Insert___.
--  990407  JakH  New template.
--  981127  JoEd  Call id 5307: Changed key data type from number to string(12).
--  981109  JoEd  Changed view Cust_Order_Template.
--                Added cascade delete on template id - when removing template header
--                the lines are removed as well.
--  980923  JoEd  Added default value on LINE_NO.
--                Removed Get_Item_Value call on CONTRACT during update.
--  980915  JoEd  Create
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
   Client_SYS.Add_To_Attr('CONTRACT', User_Default_API.Get_Contract, attr_);
   Client_SYS.Add_To_Attr('RENTAL_DB', Fnd_Boolean_API.DB_FALSE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORDER_TEMPLATE_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
  CURSOR get_max IS
     SELECT nvl(max(line_no), 0) + 1
     FROM CUST_ORDER_TEMPLATE_LINE_TAB
     WHERE template_id = newrec_.template_id;
BEGIN
   OPEN get_max;
   FETCH get_max INTO newrec_.line_no;
   CLOSE get_max;

   Error_SYS.Check_Not_Null(lu_name_, 'LINE_NO', newrec_.line_no);
   Client_SYS.Add_To_Attr('LINE_NO', newrec_.line_no, attr_);

   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     cust_order_template_line_tab%ROWTYPE,
   newrec_ IN OUT cust_order_template_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.standard_qty < 0) THEN
      Error_SYS.Record_General(lu_name_, 'QTY_LESS_THAN_ZERO: Quantity must not be less than zero!');
   END IF;
END Check_Common___;

PROCEDURE Check_Catalog_No_Ref___ (
   newrec_ IN OUT cust_order_template_line_tab%ROWTYPE )
IS
   usage_   VARCHAR2(20);
BEGIN
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      usage_ := Sales_Type_API.DB_RENTAL_ONLY;
   ELSE
      usage_ := Sales_Type_API.DB_SALES_ONLY;
   END IF; 
   Sales_Part_API.Exist(newrec_.contract, newrec_.catalog_no, usage_);
END Check_Catalog_No_Ref___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


