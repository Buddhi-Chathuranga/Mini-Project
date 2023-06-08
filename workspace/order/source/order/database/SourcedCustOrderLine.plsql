-----------------------------------------------------------------------------
--
--  Logical unit: SourcedCustOrderLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190530  JaThlk  SCUXXW4-9522, Added the method Get_Acquisition_Site to support dynamic dependency for
--  190522          the column PartType in Aurena.
--  131031  RoJalk  Modified the lengh of supply_code_db in the base view to align with the model.
--  130708  MaIklk  TIBE-1031, Removed global constant inst_Supplier_ and used conditional compilation instead.
--  120124  MaRalk  Added DATE format to the SOURCED_CUST_ORDER_LINE-SUPPLY_SITE_DUE_DATE, 
--  120124          WANTED_DELIVERY_DATE columns to avoid model errors in the PLSQL implementation test.
--  110131  Nekolk  EANE-3744  added where clause to View SUPPLY_SITE_RESERVE_SOURCE.
--  100513  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060417  RoJalk  Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 -----------------------------------------------
--  060124  JaJalk  Added Assert safe annotation.
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  050920  Removed unused variables from the code.
--  050523  DaZase  Added public Lock_By_Id method.
--  050518  JoEd    Added confirm_deliveries_db and consignment_stock_db to VIEWSOURCE.
--  050304  DaZase  Added planned_due_date and supply_site_due_date handling in Get_Sourced_Line_Source_Id.
--  050303  DaZase  Added planned_due_date and latest_release_date.
--  050216  VeMolk  Bug 49362, Added a check in Unpack_Check_Insert___ in order to restrict sourcing options 
--  050216          for an internal customer order.
--  040226  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  ----------------13.3.0-----------------------------------------------------
--  031015  DaZa    Added nvl checks on cursor in Check_Exist so we also can use this method
--                  when we check if a specific order has any sourced lines.
--  031013  PrJalk  Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  031007  NuFilk  Modified check for supplier to a dynamic check.
--  030909  DaZa    Added purchase_part_no to view SUPPLY_SITE_RESERVE_SOURCE.
--  030909  DaZa    Added a check for sourced reservations in Check_Delete___.
--  030904  Asawlk  Modified view SUPPLY_SITE_RESERVE_SOURCE.
--  030902  JaJalk  Performed CR Merge2(CR Only).
--  030829  NuFilk  Code Review and adding descriptions.
--  030828  JoEd    Added release_planning and objstate columns to SUPPLY_SITE_RESERVE_SOURCE.
--  030828  DaZa    Added condition_code, part_ownership, part_ownership_db, owning_customer_no
--                  to view SUPPLY_SITE_RESERVE_SOURCE.
--  030820  GaSolk  Performed CR Merge(CR Only).
--  030627  CaRase  Added new column supply_site_due_date to view SOURCED_CUST_ORDER_LINE.
--  030627  WaJalk  Added new column supply_site.
--  030612  DaZa    Added method Get_Objid.
--  030611  CaRase  Added view Supply_Site_Reserv_Source
--  030603  NuFilk  Modified cursor in Get_Sourced_Line_Source_Id.
--  030522  NuFilk  Added methods New and Modify.
--  030520  NuFilk  Added methods Get_Total_Sourced_Qty, Get_Next_Source_Id,
--  030520          and Get_Sourced_Line_Source_Id.
--  030519  ChBalk  Removed qty_available and changed name wanted_delivery_date.
--  030516  NuFilk  Added sequence for source_id.
--  030513  NuFilk  Added public method Check_Exist.
--  030512  NuFilk  Created the LU
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SOURCED_CUST_ORDER_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_To_Attr('SOURCE_ID', newrec_.source_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SOURCED_CUST_ORDER_LINE_TAB%ROWTYPE )
IS
BEGIN
   -- Note : Deleting not allowed if Sourced reservations exists
   IF (Sourced_Co_Supply_Site_Res_API.Sourced_Reservation_Exist(remrec_.order_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no, remrec_.source_id) = 1) THEN
      Error_SYS.Record_General(lu_name_, 'SR_EXIST: The order line may not be removed while Sourced Reservations exists, remove reservations first!');
   END IF;

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sourced_cust_order_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   -- When the customer order line originates from an internal purchase order, it is only possible to choose
   -- one sourcing alternative.
   IF ((Customer_Order_API.Get_Internal_Po_No(newrec_.order_no) IS NOT NULL) AND
      (Check_Exist(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) = 1)) THEN
      Error_SYS.Record_General(lu_name_, 'NO_MULTIPLE_SOURCES: It is not allowed to source a customer order line from multiple sourcing alternatives when the customer order originates from an internal purchase order.');   
   END IF;

   newrec_.source_id := Get_Next_Source_Id__(newrec_.order_no, newrec_.line_no, newrec_.rel_no,newrec_.line_item_no);

   super(newrec_, indrec_, attr_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Next_Source_Id__
--   Returns a new source id for all new records created.
FUNCTION Get_Next_Source_Id__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_source_id IS
   SELECT nvl(max(source_id + 1), 1)
   FROM   SOURCED_CUST_ORDER_LINE_TAB
   WHERE  order_no = order_no_
   AND    line_no = line_no_
   AND    rel_no = rel_no_
   AND    line_item_no = line_item_no_;

   source_id_     NUMBER;
BEGIN
   OPEN  get_source_id;
   FETCH get_source_id into source_id_;
   CLOSE get_source_id;
   RETURN source_id_;
END Get_Next_Source_Id__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Check if any line exist for the corresponding order line or order in
--   manual sourcing, Return 1 if so else 0.
@UncheckedAccess
FUNCTION Check_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR order_line_exist IS
      SELECT 1
      FROM   SOURCED_CUST_ORDER_LINE_TAB
      WHERE  order_no     = order_no_
      AND    line_no      = NVL(line_no_, line_no)
      AND    rel_no       = NVL(rel_no_, rel_no)
      AND    line_item_no = NVL(line_item_no_,line_item_no);
   dummy_   NUMBER;
BEGIN
   OPEN order_line_exist;
   FETCH order_line_exist INTO dummy_;
   IF (order_line_exist%FOUND) THEN
      CLOSE order_line_exist;
      RETURN dummy_;
   END IF;
   CLOSE order_line_exist;
   RETURN 0;
END Check_Exist;


-- Get_Total_Sourced_Qty
--   Return the total sourced quantity for the customer order line.
@UncheckedAccess
FUNCTION Get_Total_Sourced_Qty (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR sourced_order_line IS
      SELECT sum(sourced_qty)
      FROM   SOURCED_CUST_ORDER_LINE_TAB
      WHERE  order_no     = order_no_
        AND  line_no      = line_no_
        AND  rel_no       = rel_no_
        AND  line_item_no = line_item_no_;

   dummy_       NUMBER;
BEGIN
   OPEN sourced_order_line;
   FETCH sourced_order_line INTO dummy_;
   IF (sourced_order_line%FOUND) THEN
      CLOSE sourced_order_line;
      RETURN dummy_;
   END IF;
   CLOSE sourced_order_line;
   RETURN NULL;
END Get_Total_Sourced_Qty;


-- Get_Sourced_Line_Source_Id
--   Returns the Source Id for a line with the same sourcing information
--   if one exists.
@UncheckedAccess
FUNCTION Get_Sourced_Line_Source_Id (
   rec_ IN  SOURCED_CUST_ORDER_LINE_TAB%ROWTYPE ) RETURN NUMBER
IS
   CURSOR exist_control IS
     SELECT source_id, supply_code, wanted_delivery_date, vendor_no, ship_via_code, supply_site_due_date, planned_due_date
     FROM   SOURCED_CUST_ORDER_LINE_TAB
     WHERE  order_no = rec_.order_no
       AND  line_no = rec_.line_no
       AND  rel_no = rec_.rel_no
       AND  line_item_no = rec_.line_item_no;

BEGIN
   FOR temp_rec_ IN exist_control LOOP
     IF (rec_.supply_code = temp_rec_.supply_code
         AND  rec_.wanted_delivery_date = temp_rec_.wanted_delivery_date
         AND  nvl(rec_.vendor_no,0) = nvl(temp_rec_.vendor_no,0)
         AND  rec_.ship_via_code = temp_rec_.ship_via_code)
         AND  nvl(to_char(rec_.supply_site_due_date, 'YYMMDD'), 'NULL') = nvl(to_char(temp_rec_.supply_site_due_date, 'YYMMDD'), 'NULL')
         AND  nvl(to_char(rec_.planned_due_date, 'YYMMDD'), 'NULL') = nvl(to_char(temp_rec_.planned_due_date, 'YYMMDD'), 'NULL') THEN

        RETURN temp_rec_.source_id;
     END IF;
   END LOOP;
   RETURN 0;
END Get_Sourced_Line_Source_Id;


-- New
--   Creates a new instance.
PROCEDURE New(
   attr_   IN OUT VARCHAR2,
   action_ IN     VARCHAR2 )
IS
   objid_                   VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   info_                     VARCHAR2(2000);
BEGIN
   New__(info_, objid_, objversion_, attr_, action_);
   info_ := Client_SYS.Get_All_Info;
END New;


-- Modify
--   Public interface to SourceOrderLines to modify instances of this LU.
PROCEDURE Modify (
   attr_         IN OUT VARCHAR2,
   order_no_     IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2,
   line_item_no_ IN     NUMBER,
   source_id_    IN     NUMBER )
IS
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   info_                VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, source_id_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
   info_ := Client_SYS.Get_All_Info;
END Modify;


-- Remove
--   Public interface to SourceOrderLines to remove all the lines that
--   corresponds to the original customer order line. (which would have
--   created new order lines based on sourcing alternatives by now).
PROCEDURE Remove (
   info_         OUT VARCHAR2,
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   rel_no_       IN  VARCHAR2,
   line_item_no_ IN  NUMBER )
IS
   CURSOR order_line_source_lines IS
       SELECT source_id
       FROM   SOURCED_CUST_ORDER_LINE_TAB
       WHERE  order_no = order_no_
       AND    line_no = line_no_
       AND    rel_no  = rel_no_
       AND    line_item_no = line_item_no_;
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
BEGIN
   FOR rec_ IN order_line_source_lines LOOP
      Get_Id_Version_By_Keys___(objid_,objversion_,order_no_,line_no_,rel_no_,line_item_no_,rec_.source_id);
      Remove__(info_,objid_,objversion_,'DO');
      info_ := Client_SYS.Get_All_Info;
   END LOOP;
END Remove;


-- Get_Objid
--   Returns Objid for the sourced line. Used for ATP check when reserving
--   a supply chain reservation.
@UncheckedAccess
FUNCTION Get_Objid (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   source_id_    IN NUMBER ) RETURN VARCHAR2
IS
   temp_  VARCHAR2(2000);
   CURSOR get_attr IS
      SELECT rowid
      FROM   SOURCED_CUST_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    source_id = source_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Objid;


-- Lock_By_Id
--   Public Lock_By_Id method, used by client frmSupplyReserveSource
--   for an overide of method DataSourceExecuteSqlLock
PROCEDURE Lock_By_Id (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 )
IS
   dummy_ SOURCED_CUST_ORDER_LINE_TAB%ROWTYPE;
BEGIN
   dummy_ := Lock_By_Id___(objid_, objversion_);
END Lock_By_Id;


FUNCTION Get_Acquisition_Site (
   vendor_no_ IN VARCHAR2) RETURN VARCHAR2
IS
   acquisition_site_ VARCHAR2(5);
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
	   acquisition_site_ := Supplier_API.Get_Acquisition_Site(vendor_no_);
   $ELSE
      acquisition_site_ := NULL;
   $END
   RETURN acquisition_site_; 
END Get_Acquisition_Site;
