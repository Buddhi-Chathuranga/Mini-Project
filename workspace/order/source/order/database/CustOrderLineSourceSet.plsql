-----------------------------------------------------------------------------
--
--  Logical unit: CustOrderLineSourceSet
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120827  MAHPLK  Added attribute shipment_type.
--  120720  MaMalk  Added attribute Route ID to store the route used for date calculations when creating sourcing alternatives.
--  120718  MAHPLK  Added attribute picking_leadtime.
--  130704  MaRalk  TIBE-965, Removed global LU constant inst_Supplier_ and modified Unpack_Check_Insert___ 
--  130704          and Unpack_Check_Update___ accordingly.
--  100519  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  070530  ChBalk  Bug 64640, Removed General_SYS.Init_Method from function Exist_Any_Source_Set.
--  --------------------------- 13.4.0 ----------------------------------------
--  060125  JaJalk  Added Assert safe annotation.
--  060110  CsAmlk  Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  040219  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  -----------------EDGE Package Group 3 Unicode Changes-----------------------
--  031008  PrJalk  Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  030911  JoAnSe  Added new public attributes supplier_ship_via_transit, 
--                  delivery_leadtime and default_addr_flag.
--  030820  GaSolk  Performed CR Merge(CR Only).
--  030520  DaZa    Added method Exist_Any_Source_Set.
--  030515  DaZa    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORDER_LINE_SOURCE_SET_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS

   CURSOR get_next_row_no(order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2, line_item_no_ NUMBER) IS
   SELECT nvl(max(row_no + 1), 1)
   FROM   CUST_ORDER_LINE_SOURCE_SET_TAB
   WHERE  order_no = order_no_
   AND    line_no = line_no_
   AND    rel_no = rel_no_
   AND    line_item_no = line_item_no_;

BEGIN
    -- set row no
   IF (newrec_.row_no IS NULL) THEN
      OPEN  get_next_row_no(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      FETCH get_next_row_no INTO newrec_.row_no;
      CLOSE get_next_row_no;
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- New_Alternative__
--   Creates a new source set alternative
PROCEDURE New_Alternative__ (
   attr_ IN VARCHAR2 )
IS
   newrec_     CUST_ORDER_LINE_SOURCE_SET_TAB%ROWTYPE;
   new_attr_   VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   new_attr_ := attr_;
   Unpack___(newrec_, indrec_, new_attr_); 
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);
END New_Alternative__;


-- Modify_Alternative__
--   Modifies a specific source set alternative
PROCEDURE Modify_Alternative__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   row_no_       IN NUMBER,
   attr_         IN VARCHAR2 )
IS
   oldrec_     CUST_ORDER_LINE_SOURCE_SET_TAB%ROWTYPE;
   newrec_     CUST_ORDER_LINE_SOURCE_SET_TAB%ROWTYPE;
   new_attr_   VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   new_attr_ := attr_;
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, row_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, new_attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, new_attr_);
   Update___(objid_, oldrec_, newrec_, new_attr_, objversion_);
END Modify_Alternative__;


-- Delete__
--   Deletes all source sets alternatives for a specific customer order line
PROCEDURE Delete__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   remrec_     CUST_ORDER_LINE_SOURCE_SET_TAB%ROWTYPE;
   CURSOR get_alternatives IS
      SELECT rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion
      FROM  CUST_ORDER_LINE_SOURCE_SET_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   FOR altrec_ IN get_alternatives LOOP
      remrec_ := Lock_By_Id___(altrec_.objid, altrec_.objversion);
      Check_Delete___(remrec_);
      Delete___(altrec_.objid, remrec_);
   END LOOP;
END Delete__;


-- Delete_Alternative__
--   Delete a specific source set alternative
PROCEDURE Delete_Alternative__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   row_no_       IN NUMBER )
IS
   remrec_     CUST_ORDER_LINE_SOURCE_SET_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, row_no_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Delete_Alternative__;


-- Set_Selected__
--   Sets the selected flag
PROCEDURE Set_Selected__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   row_no_       IN NUMBER,
   selected_     IN VARCHAR2 )
IS
   oldrec_     CUST_ORDER_LINE_SOURCE_SET_TAB%ROWTYPE;
   newrec_     CUST_ORDER_LINE_SOURCE_SET_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, row_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SELECTED', selected_, attr_);
   Unpack___(newrec_, indrec_, attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Selected__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Exist_Any_Source_Set
--   Checks if any source set alternatives exist for a specific customer order line.
@UncheckedAccess
FUNCTION Exist_Any_Source_Set (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM  CUST_ORDER_LINE_SOURCE_SET_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Exist_Any_Source_Set;



