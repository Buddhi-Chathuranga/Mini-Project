-----------------------------------------------------------------------------
--
--  Logical unit: FreightPriceListBase
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170926  RaVdlk   STRSC-11152,Removed Get_Objstate function, since it is generated from the foundation
--  160601  MAHPLK   FINHR-2018, Removed Validate_Tax_Calc_Basis___.
--  140321  HimRlk   Added new parameter use_price_incl_tax_ to Get_Active_Freight_List_No(). Added new private method Check_Active_Price_List__().
--  140321           Modified Check_Active_Price_List___() to validate value of use_price_incl_tax_.
--  130207  JeeJlk   Added new column USE_PRICE_INCL_TAX.
--  111215  MaMalk   Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111116  ChJalk   Modified the views FREIGHT_PRICE_LIST_BASE, FREIGHT_PRICE_LIST_BASE_ALL, FREIGHT_PRICE_LIST_BASE_SITE and FREIGHT_PRICE_LIST_LOV to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111025  ChJalk   Modified the views FREIGHT_PRICE_LIST_BASE, FREIGHT_PRICE_LIST_BASE_ALL, FREIGHT_PRICE_LIST_BASE_SITE and FREIGHT_PRICE_LIST_LOV to use the user allowed company filter.
--  110323  NiBalk   EANE-4853, Removed user allowed site filter from where clause of view FREIGHT_PRICE_LIST_BASE_ALL.
--  110203  Nekolk   EANE-3744  added where clause to View FREIGHT_PRICE_LIST_BASE_ALL.
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  090220  MaHplk   Added Forwarder ID to LU.
--  090116  ShKolk   Modified Check_Active_Price_List___() to consider supplier_id in the cursor.
--  090116           Added new error message CANNOTACTIVATEPLDIR.
--  090102  ShKolk   Removed attribute min_freight_amount and Get_Min_Freight_Amount().
--  081031  MaJalk   Added view FREIGHT_PRICE_LIST_LOV.
--  081022  MaJalk   Corrected cursor get_active_price_list at Get_Active_Freight_List_No.
--  080926  MaJalk   Removed method Check_Usage___.
--  080924  MaJalk   Added supplier to view VIEW_SITE. 
--  080923  MaJalk   Added view VIEW_SITE.
--  080919  MaJalk   Added methods Check_Active_Price_List___, Check_Usage___, Get_Active_For_Site
--  080919           and modified Finite_State_Machine___.
--  080919  MaHplk   Modified view comment on 'Zone Definition ID' to 'Freight Map ID'.
--  080918  MaJalk   Removed method Get_Active_For_Site.
--  080917  MaJalk   Added attribute min_freight_amount.
--  080915  MaJalk   Added attribute company.
--  080912  AmPalk   Added Get_Active_For_Site and changed Get_Active_Freight_List_No.
--  080912  MaHplk   Modified view comment of zone_definition_id.
--  080829  RoJalk   Removed Connect_All_Sites_In_Company__ and renamed
--  080829           Active_Freight_List_Exists to Get_Active_Freight_List_No.
--  080826  RoJalk   Modified Insert___ and removed the call Post_Insert_Actions__
--  080826           and modified Remove_Invalid_Freight_Lines__.
--  080826  RoJalk   Added Get_Objstate.
--  080826  RoJalk   Added Connect_All_Sites_In_Company__.
--  080825  Rojalk   Added the method Remove_Invalid_Freight_Lines__.
--  080822  RoJalk   Addded Get_Next_Price_List_No__.
--  080822  RoJalk   Modified Finite_State_Machine___.
--  080820  RoJalk   Added the column contract and generated the related code.
--  080815  RoJalk   Changed the scope of Post_Insert_Actions___ to be private.
--  080815  RoJalk   Cretaed
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Active_Price_List___
--   Checks for an active freight price list for a contract and ship via.
PROCEDURE Check_Active_Price_List___ (
   rec_  IN OUT FREIGHT_PRICE_LIST_BASE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   price_list_no_ FREIGHT_PRICE_LIST_BASE_TAB.price_list_no%TYPE;
   CURSOR get_active_price_list (contract_ VARCHAR2)IS
      SELECT price_list_no
      FROM   FREIGHT_PRICE_LIST_BASE_TAB
      WHERE  price_list_no IN (SELECT price_list_no
                               FROM freight_price_list_site_tab
                               WHERE contract = contract_)
        AND  ship_via_code = rec_.ship_via_code
        AND  forwarder_id = rec_.forwarder_id
        AND  use_price_incl_tax = rec_.use_price_incl_tax
        AND  NVL(supplier_id,' ') = NVL(rec_.supplier_id,' ')
        AND  ROWTYPE = rec_.ROWTYPE
        AND  rowstate = 'Active' ;

   CURSOR get_contract IS
      SELECT contract
      FROM   freight_price_list_site_tab
      WHERE  price_list_no = rec_.price_list_no;
BEGIN
   FOR contract_rec_ IN get_contract LOOP
      OPEN  get_active_price_list(contract_rec_.contract);
      FETCH get_active_price_list INTO price_list_no_;
      CLOSE get_active_price_list;

      IF (price_list_no_ IS NOT NULL) THEN
         IF (rec_.supplier_id IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'CANNOTACTIVATEPL: There cannot be two active freight price lists for the same valid site, ship-via code, forwarder and usage of price including tax.');
         ELSE
            Error_SYS.Record_General(lu_name_, 'CANNOTACTIVATEPLDIR: There cannot be two active freight price lists for the same valid site, ship-via code, supplier, forwarder and usage of price including tax.');
         END IF;
         
      END IF;
   END LOOP;
END Check_Active_Price_List___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     freight_price_list_base_tab%ROWTYPE,
   newrec_ IN OUT freight_price_list_base_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF indrec_.use_price_incl_tax = FALSE OR newrec_.use_price_incl_tax IS NULL THEN
      newrec_.use_price_incl_tax := 'FALSE';
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);

END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Active_Price_List__
--   Private method to checks for an active freight price list for a contract and ship via.
 PROCEDURE Check_Active_Price_List__ (
   rec_  IN OUT FREIGHT_PRICE_LIST_BASE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS   
BEGIN
   Check_Active_Price_List___(rec_, attr_);
END Check_Active_Price_List__;  

-- Freight_List_Line_Exists__
--   Returns 1 if a record is found for the given price_list_no in the table
@UncheckedAccess
FUNCTION Freight_List_Line_Exists__ (
   price_list_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_   NUMBER;

   CURSOR get_freight_price_list_line IS
      SELECT 1
      FROM   FREIGHT_PRICE_LIST_LINE_TAB
      WHERE  price_list_no = price_list_no_;

BEGIN
   OPEN  get_freight_price_list_line;
   FETCH get_freight_price_list_line INTO dummy_;
      IF (get_freight_price_list_line%FOUND) THEN
         CLOSE get_freight_price_list_line;
         RETURN 1;
      END IF;
   CLOSE get_freight_price_list_line;
   RETURN 0;
END Freight_List_Line_Exists__;


-- Post_Insert_Actions__
--   Includes the executions needed after a record is inserted to the table.
PROCEDURE Post_Insert_Actions__ (
   attr_   IN OUT VARCHAR2,
   newrec_ IN OUT FREIGHT_PRICE_LIST_BASE_TAB%ROWTYPE )
IS
   target_info_       VARCHAR2(2000);
   target_attr_       VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(target_attr_);
   Client_SYS.Add_To_Attr('PRICE_LIST_NO', newrec_.price_list_no, target_attr_);
   Client_SYS.Add_To_Attr('CONTRACT', newrec_.contract, target_attr_);
   Freight_Price_List_Site_API.New(target_info_, target_attr_);
END Post_Insert_Actions__;


PROCEDURE Init_State__ (
   attr_          IN OUT VARCHAR2,
   price_list_no_ IN     VARCHAR2 )
IS
   rec_   FREIGHT_PRICE_LIST_BASE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(price_list_no_);
   Finite_State_Init___(rec_, attr_);
END Init_State__;


-- Get_Next_Price_List_No__
--   Returns price_list_no from freight_price_list_seq to be used in Freight
--   Price List.
@UncheckedAccess
FUNCTION Get_Next_Price_List_No__ RETURN VARCHAR2
IS
   price_list_no_ FREIGHT_PRICE_LIST_BASE_TAB.price_list_no%TYPE;
BEGIN
   SELECT freight_price_list_seq.nextval INTO price_list_no_ FROM dual;
   RETURN price_list_no_;
END Get_Next_Price_List_No__;


-- Remove_Invalid_Freight_Lines__
--   Remove invaild prices from the Freight Price List.
PROCEDURE Remove_Invalid_Freight_Lines__ (
   removed_items_   OUT NUMBER,
   valid_from_date_ IN  DATE,
   price_list_attr_ IN  VARCHAR2 )
IS
   counter_                 NUMBER := 0;
   ptr_                     NUMBER := NULL;
   name_                    VARCHAR2(30);
   price_list_no_           VARCHAR2(10);
   current_valid_from_date_ DATE;
   min_qty_                 NUMBER;
   freight_map_id_          VARCHAR2(15);
   zone_id_                 VARCHAR2(15);

   CURSOR find_valid_freight_rec IS
      SELECT   min_qty, freight_map_id, zone_id, MAX(valid_from) valid_from
      FROM     Freight_Price_List_Line_Tab
      WHERE    price_list_no = price_list_no_
      AND      valid_from <= valid_from_date_
      GROUP BY min_qty, freight_map_id, zone_id;

   CURSOR find_records_to_remove IS
      SELECT valid_from
      FROM   Freight_Price_List_Line_Tab
      WHERE  price_list_no = price_list_no_
      AND    min_qty = min_qty_
      AND    freight_map_id = freight_map_id_
      AND    zone_id = zone_id_
      AND    valid_from < current_valid_from_date_;
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(price_list_attr_, ptr_, name_, price_list_no_)) LOOP
      -- Remove all freight prices that are invalid.
      FOR rem_ IN find_valid_freight_rec LOOP
         current_valid_from_date_ := rem_.valid_from;
         min_qty_    := rem_.min_qty;
         zone_id_    := rem_.zone_id;
         freight_map_id_ := rem_.freight_map_id;
         current_valid_from_date_ := rem_.valid_from;
         FOR remrec_ IN find_records_to_remove LOOP
            Freight_Price_List_Line_API.Remove(price_list_no_, min_qty_, remrec_.valid_from, freight_map_id_, zone_id_);
            counter_ := counter_ + 1;
         END LOOP;
      END LOOP;
   END LOOP;
   removed_items_ := counter_;
END Remove_Invalid_Freight_Lines__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Active_Freight_List_No
--   Returns valid active price list found for the given contract, freight map id, forwarder id,
--   ship via code_ and/or vendor_no.
@UncheckedAccess
FUNCTION Get_Active_Freight_List_No (
   contract_      IN VARCHAR2,
   ship_via_code_ IN VARCHAR2,
   zone_def_id_   IN VARCHAR2,
   forwarder_id_  IN VARCHAR2,
   use_price_incl_tax_ IN VARCHAR2,
   vendor_no_     IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   temp_ FREIGHT_PRICE_LIST_BASE_TAB.price_list_no%TYPE;

   CURSOR get_active_dir_price_list(temp_forwarder_id_ VARCHAR2) IS
      SELECT t.price_list_no
      FROM   FREIGHT_PRICE_LIST_BASE_TAB t
      WHERE  contract_ IN (SELECT contract FROM Freight_Price_List_Site_Tab fpst WHERE fpst.price_list_no = t.price_list_no )
      AND    t.ship_via_code = ship_via_code_
      AND    t.forwarder_id = temp_forwarder_id_
      AND    t.use_price_incl_tax = use_price_incl_tax_
      AND    t.rowstate = 'Active'
      AND    t.freight_map_id = zone_def_id_
      AND    t.supplier_id LIKE (vendor_no_);

   CURSOR get_active_price_list(temp_forwarder_id_ VARCHAR2) IS
      SELECT t.price_list_no
      FROM   FREIGHT_PRICE_LIST_BASE_TAB t
      WHERE  contract_ IN (SELECT contract FROM Freight_Price_List_Site_Tab fpst WHERE fpst.price_list_no = t.price_list_no )
      AND    t.ship_via_code = ship_via_code_
      AND    t.forwarder_id = temp_forwarder_id_
      AND    t.use_price_incl_tax = use_price_incl_tax_
      AND    t.rowstate = 'Active'
      AND    t.freight_map_id = zone_def_id_
      AND    t.supplier_id IS NULL;
BEGIN
   IF (vendor_no_ IS NULL) THEN
      IF forwarder_id_ IS NOT NULL THEN
         OPEN  get_active_price_list(forwarder_id_);
         FETCH get_active_price_list INTO temp_;
         IF get_active_price_list%FOUND THEN
            CLOSE get_active_price_list;
         ELSE
            CLOSE get_active_price_list;
            OPEN  get_active_price_list('*');
            FETCH get_active_price_list INTO temp_;
            CLOSE get_active_price_list;
         END IF;
      ELSE
         OPEN  get_active_price_list('*');
         FETCH get_active_price_list INTO temp_;
         CLOSE get_active_price_list;
      END IF;
   ELSE
      OPEN  get_active_dir_price_list(forwarder_id_);
      FETCH get_active_dir_price_list INTO temp_;
      IF get_active_dir_price_list%FOUND THEN
         CLOSE get_active_dir_price_list;
      ELSE
         CLOSE get_active_dir_price_list;
         OPEN  get_active_dir_price_list('*');
         FETCH get_active_dir_price_list INTO temp_;
         CLOSE get_active_dir_price_list;
      END IF;
   END IF;

   RETURN temp_;
END Get_Active_Freight_List_No;


-- Get_Active_For_Site
--   Selects active price list no for contract, ship via, forwarder id, use price incl tax and freight list type.
@UncheckedAccess
FUNCTION Get_Active_For_Site (
   price_list_no_ IN VARCHAR2,
   contract_      IN VARCHAR2,
   ship_via_code_ IN VARCHAR2,
   forwarder_id_  IN VARCHAR2,
   use_price_incl_tax_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_ FREIGHT_PRICE_LIST_BASE_TAB.price_list_no%TYPE;
   CURSOR get_active_freight_price_list(temp_forwarder_id_ VARCHAR2) IS
      SELECT fplbt.price_list_no
      FROM   FREIGHT_PRICE_LIST_BASE_TAB fplbt, freight_price_list_site_tab fplst
      WHERE  fplbt.price_list_no = fplst.price_list_no
      AND    fplst.contract = contract_
      AND    fplbt.ship_via_code = ship_via_code_
      AND    fplbt.forwarder_id = temp_forwarder_id_
      AND    fplbt.use_price_incl_tax = use_price_incl_tax_
      AND    rowstate = 'Active' 
      AND    fplbt.ROWTYPE = (SELECT ROWTYPE FROM FREIGHT_PRICE_LIST_BASE_TAB WHERE price_list_no = price_list_no_);

BEGIN
   OPEN  get_active_freight_price_list(forwarder_id_);
   FETCH get_active_freight_price_list INTO temp_;
   IF get_active_freight_price_list%FOUND THEN
      CLOSE get_active_freight_price_list;
   ELSE
      CLOSE get_active_freight_price_list;
      OPEN  get_active_freight_price_list('*');
      FETCH get_active_freight_price_list INTO temp_;
      CLOSE get_active_freight_price_list;
   END IF;
   RETURN temp_;
END Get_Active_For_Site;


