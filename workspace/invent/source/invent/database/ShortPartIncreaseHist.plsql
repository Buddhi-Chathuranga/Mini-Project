-----------------------------------------------------------------------------
--
--  Logical unit: ShortPartIncreaseHist
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  060118  SuJalk Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  ---------------------------------------- 13.3.0 ---------------------------
--  000925  JOHESE  Added undefines.
--  000418  NISOSE  Added General_SYS.Init_Method in New.
--  990421  JOHW    General performance improvements.
--  990412  JOHW    Upgraded to performance optimized template.
--  981125  FRDI    Full precision for UOM, change comments in tab.
--  971202  GOPE    Upgrade to fnd 2.0
--  970723  NAVE    OrderType, OrderNo, LineNo, RelNo are not Mandatory. Removed
--                  not null checks in UCI and UCU.
--  970710  NAVE    Added sequence for shortage_increase_id. Added public procedure
--                  New (to be called from InventoryPartLocation.
--  970709  NAVE    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT short_part_increase_hist_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT (indrec_.shortage_increase_id) THEN
      SELECT shortage_increase_id.nextval
         INTO   newrec_.shortage_increase_id
         FROM   dual;
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   order_type_ IN VARCHAR2,
   order_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   release_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_increased_ IN NUMBER,
   transaction_date_ IN DATE )
IS
   newrec_  SHORT_PART_INCREASE_HIST_TAB%ROWTYPE;
   dummy_   VARCHAR2(20);
   attr_    VARCHAR2(2000);
   indrec_  Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('ORDER_TYPE',order_type_ , attr_);
   Client_SYS.Add_To_Attr('ORDER_NO',order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO',line_no_, attr_);
   Client_SYS.Add_To_Attr('RELEASE_NO',release_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO',line_item_no_, attr_);
   Client_SYS.Add_To_Attr('QTY_INCREASED',qty_increased_, attr_);
   Client_SYS.Add_To_Attr('TRANSACTION_DATE',transaction_date_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(dummy_, dummy_, newrec_, attr_);
END New;



