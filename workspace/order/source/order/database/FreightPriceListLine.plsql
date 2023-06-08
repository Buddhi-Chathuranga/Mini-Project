-----------------------------------------------------------------------------
--
--  Logical unit: FreightPriceListLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130121  RavDlk   SC2020R1-12047,Removed unnecessary packing and unpacking of attrubute string in Copy_Charge_Line___ and Modify_Sales_Price
--  111116  ChJalk   Modified the view FREIGHT_PRICE_LIST_LINE to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111025  ChJalk   Modified the view FREIGHT_PRICE_LIST_LINE to use the user allowed company filter.
--  110323  NiBalk   EANE-4853, Removed user allowed site filter from where clause of view FREIGHT_PRICE_LIST_LINE_COMP.
--  110303  ChJalk   Added user allowed site filter to the view VIEW1.
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  091005  KiSalk   Added forwarder_id_attr_ to Update_Freight_Prices___, Update_Freight_Prices_Batch__ and Update_Freight_Prices__.
--    090806   MaJalk   Bug 80825, In Get_Valid_Charge_Line, rearranged and renamed parameters and added new zone_definition_id_.
--    081103   MaJalk   Added methods Duplicate_Freight_List_Chg___, Update_Freight_Prices___,
--    081103           Start_Update_Freight_Prices__, Update_Freight_Prices__,
--    081103           Update_Freight_Prices_Batch__, Modify_Sales_Price, New.
--    081008   MaJalk   Added methods Copy_All_Charges__ and Copy_Charge_Line___.
--    080924   MaJalk   Added view VIEW1. This view has set to tbwOverviewFreightPriceListLine.
--    080924           To add the RMB change company, there should be a column in client table
--    080924           which has a COMPANY as column name in F1 property.
--  080919  MaHplk   Modified view comment on 'Zone Definition ID' to 'Freight Map ID'.
--  080911  AmPalk   Added Get_Valid_Charge_Line.
--  080912  MaHplk   Modified view comments of zone_definition_id and zone_id.
--  080825  RoJalk   Added the method Remove.
--  080815  RoJalk   Cretaed
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Update_Freight_Prices___
--   Update freight prices for given price list and ship via.
PROCEDURE Update_Freight_Prices___ (
   number_of_updates_      OUT NUMBER,
   valid_from_date_        IN  DATE,
   percentage_offset_      IN  NUMBER,
   amount_offset_          IN  NUMBER,
   price_list_attr_        IN  VARCHAR2,
   ship_via_attr_          IN  VARCHAR2,
   forwarder_id_attr_      IN  VARCHAR2 )
IS
   counter_ NUMBER := 0;

   CURSOR find_records_for_update IS
      SELECT pl.price_list_no, pl.freight_map_id, pll.min_qty, pll.zone_id, MAX(pll.valid_from) valid_from
      FROM   freight_price_list_base_tab pl, freight_price_list_line_tab pll
      WHERE  pl.price_list_no = pll.price_list_no
      AND    Report_SYS.Parse_Parameter(pl.price_list_no, price_list_attr_) = 'TRUE'
      AND    Report_SYS.Parse_Parameter(ship_via_code, ship_via_attr_) = 'TRUE'
      AND    Report_SYS.Parse_Parameter(forwarder_id, forwarder_id_attr_) = 'TRUE'
      AND    valid_from <= valid_from_date_
      GROUP BY pl.price_list_no, pl.freight_map_id, pll.min_qty, pll.zone_id;

   CURSOR find_records_not_yet_valid IS
      SELECT pl.price_list_no, min_qty, pll.valid_from, pl.freight_map_id, pll.zone_id
      FROM   freight_price_list_base_tab pl, freight_price_list_line_tab pll
      WHERE  pl.price_list_no = pll.price_list_no
      AND    Report_SYS.Parse_Parameter(pl.price_list_no, price_list_attr_) = 'TRUE'
      AND    Report_SYS.Parse_Parameter(ship_via_code, ship_via_attr_) = 'TRUE'
      AND    Report_SYS.Parse_Parameter(forwarder_id, forwarder_id_attr_) = 'TRUE';


BEGIN

   FOR next_ IN find_records_for_update LOOP
      Duplicate_Freight_List_Chg___(next_.price_list_no, next_.min_qty, next_.valid_from, next_.freight_map_id,
                                    next_.zone_id, valid_from_date_, percentage_offset_, amount_offset_);
      counter_ := counter_ + 1;
   END LOOP;

   -- Check if there are any records that do not have a valid period yet. In that case, duplicate them also.
   FOR next_ IN find_records_not_yet_valid LOOP
      IF (next_.valid_from > valid_from_date_) THEN
         Duplicate_Freight_List_Chg___(next_.price_list_no, next_.min_qty, next_.valid_from, next_.freight_map_id,
                                       next_.zone_id, next_.valid_from, percentage_offset_, amount_offset_);
         counter_ := counter_ + 1;
      END IF;
   END LOOP;

   number_of_updates_ := counter_;
END Update_Freight_Prices___;


-- Duplicate_Freight_List_Chg___
--   Create new freight list lines or update existing ones.
PROCEDURE Duplicate_Freight_List_Chg___ (
    price_list_no_       IN VARCHAR2,
    min_quantity_        IN NUMBER,
    valid_from_date_     IN DATE,
    freight_map_id_      IN VARCHAR2,
    zone_id_             IN VARCHAR2,
    new_valid_from_date_ IN DATE,
    percentage_offset_   IN NUMBER,
    amount_offset_       IN NUMBER )
IS
   sales_price_          NUMBER;

   CURSOR get_price_list_line_info IS
      SELECT sales_price
      FROM   freight_price_list_line_tab
      WHERE  price_list_no = price_list_no_
      AND    min_qty = min_quantity_
      AND    valid_from = valid_from_date_
      AND    freight_map_id = freight_map_id_
      AND    zone_id = zone_id_;
BEGIN

   -- Fetch record to duplicate.
   OPEN  get_price_list_line_info;
   FETCH get_price_list_line_info INTO sales_price_;
   IF (get_price_list_line_info%NOTFOUND) THEN
      CLOSE get_price_list_line_info;
      Trace_SYS.Message('No record found');
   ELSE
      CLOSE get_price_list_line_info;

      -- Calculate new sales price.
      sales_price_ := (sales_price_ * (1 + percentage_offset_ / 100)) + amount_offset_;

      IF (new_valid_from_date_ = valid_from_date_) THEN
         -- Record already exist. Modify sales price.
         Modify_Sales_Price(price_list_no_, min_quantity_, valid_from_date_, freight_map_id_, zone_id_, sales_price_);
      ELSE
         -- Duplicate record with new valid_from_date.
         New(price_list_no_, min_quantity_, new_valid_from_date_, freight_map_id_, zone_id_, sales_price_);
      END IF;
   END IF;
END Duplicate_Freight_List_Chg___;


-- Copy_Charge_Line___
--   Creates a new Charge record.
PROCEDURE Copy_Charge_Line___ (
   source_rec_   IN FREIGHT_PRICE_LIST_LINE_TAB%ROWTYPE )
IS
   newrec_       FREIGHT_PRICE_LIST_LINE_TAB%ROWTYPE;
BEGIN

   -- Copy the line
   newrec_.price_list_no := source_rec_.price_list_no;
   newrec_.min_qty := source_rec_.min_qty;
   newrec_.valid_from := source_rec_.valid_from;
   newrec_.freight_map_id := source_rec_.freight_map_id;
   newrec_.zone_id := source_rec_.zone_id;
   newrec_.sales_price := source_rec_.sales_price;
   New___(newrec_);
END Copy_Charge_Line___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('VALID_FROM', SYSDATE, attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Update_Freight_Prices_Batch__
--   update freight prices with percentage or amount offset for given price list
--   and ship via as a backgroung job.
PROCEDURE Update_Freight_Prices_Batch__ (
   valid_from_date_     IN DATE,
   percentage_offset_   IN NUMBER,
   amount_offset_       IN NUMBER,
   price_list_attr_     IN VARCHAR2,
   ship_via_attr_       IN VARCHAR2,
   forwarder_id_attr_   IN VARCHAR2 )
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE',      valid_from_date_,      attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET',   percentage_offset_,   attr_);
   Client_SYS.Add_To_Attr('AMOUNT_OFFSET',      amount_offset_,      attr_);
   Client_SYS.Add_To_Attr('PRICE_LIST_ATTR',      price_list_attr_,      attr_);
   Client_SYS.Add_To_Attr('SHIP_VIA_ATTR',      ship_via_attr_,      attr_);
   Client_SYS.Add_To_Attr('FORWARDER_ID_ATTR',  forwarder_id_attr_,      attr_);

   Transaction_SYS.Deferred_Call('Freight_Price_List_Line_API.Start_Update_Freight_Prices__', attr_,
   Language_SYS.Translate_Constant(lu_name_, 'UPDATE_FPRICES: Update Freight Price Lists'));
END Update_Freight_Prices_Batch__;


PROCEDURE Update_Freight_Prices__ (
   number_of_updates_      OUT NUMBER,
   valid_from_date_        IN  DATE,
   percentage_offset_      IN  NUMBER,
   amount_offset_          IN  NUMBER,
   price_list_attr_        IN  VARCHAR2,
   ship_via_attr_          IN  VARCHAR2,
   forwarder_id_attr_      IN  VARCHAR2 )
IS
BEGIN
   Update_Freight_prices___(number_of_updates_, valid_from_date_, percentage_offset_, amount_offset_,
                           price_list_attr_, ship_via_attr_, forwarder_id_attr_);
END Update_Freight_Prices__;


-- Copy_All_Charges__
--   Copies all charge records from one freight price list to another.
PROCEDURE Copy_All_Charges__ (
   price_list_no_       IN VARCHAR2,
   to_price_list_no_    IN VARCHAR2,
   valid_from_date_     IN DATE,
   to_valid_from_date_  IN DATE )
IS
   CURSOR get_min_date_zone IS
      SELECT MAX(valid_from) valid_date, freight_map_id, zone_id, min_qty
      FROM   freight_price_list_line_tab
      WHERE  price_list_no = price_list_no_
      AND    valid_from <= valid_from_date_
      GROUP BY freight_map_id, zone_id, min_qty;

   CURSOR  get_source (freight_map_id_ IN VARCHAR2, zone_id_ IN VARCHAR2, min_qty_ IN NUMBER, valid_date_ IN DATE) IS
      SELECT *
      FROM   freight_price_list_line_tab
      WHERE  price_list_no = price_list_no_
      AND    zone_id = zone_id_
      AND    freight_map_id = freight_map_id_
      AND    min_qty = min_qty_
      AND    valid_from = valid_date_;

   CURSOR  get_source_all IS
      SELECT *
      FROM   freight_price_list_line_tab
      WHERE  price_list_no = price_list_no_;
BEGIN

   IF (to_valid_from_date_ IS NULL) THEN
      IF (valid_from_date_ IS NULL) THEN
         --Copy all lines with original valid from date
         FOR source_rec_ IN get_source_all LOOP
            source_rec_.price_list_no := to_price_list_no_;
            Copy_Charge_Line___ (source_rec_);
         END LOOP;
      ELSE
         --Copy valid lines as at valid_from_date_ with original valid from date
         FOR date_rec_ IN get_min_date_zone LOOP
            FOR source_rec_ IN get_source(date_rec_.freight_map_id, date_rec_.zone_id, date_rec_.min_qty, date_rec_.valid_date) LOOP
               source_rec_.price_list_no := to_price_list_no_;
               Copy_Charge_Line___ (source_rec_);
            END LOOP;
         END LOOP;
      END IF;
   ELSE
      --Copy valid lines as at valid_from_date_ with valid from date to_valid_from_date_
      FOR date_rec_ IN get_min_date_zone LOOP
         FOR source_rec_ IN get_source(date_rec_.freight_map_id, date_rec_.zone_id, date_rec_.min_qty, date_rec_.valid_date) LOOP
            source_rec_.price_list_no := to_price_list_no_;
            source_rec_.valid_from := to_valid_from_date_;
            Copy_Charge_Line___ (source_rec_);
         END LOOP;
      END LOOP;
   END IF;
END Copy_All_Charges__;


-- Start_Update_Freight_Prices__
--   update freight prices for given price list and ship via.
PROCEDURE Start_Update_Freight_Prices__ (
   attr_ IN VARCHAR2 )
IS
   number_of_updates_      NUMBER;
   valid_from_date_        DATE;
   percentage_offset_      NUMBER;
   amount_offset_          NUMBER;
   price_list_attr_        VARCHAR2(4000);
   ship_via_attr_          VARCHAR2(4000);
   forwarder_id_attr_      VARCHAR2(4000);
   info_                   VARCHAR2(2000);
BEGIN

   valid_from_date_        := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_FROM_DATE', attr_));
   percentage_offset_      := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('PERCENTAGE_OFFSET', attr_));
   amount_offset_          := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('AMOUNT_OFFSET', attr_));
   price_list_attr_        := Client_SYS.Get_Item_Value('PRICE_LIST_ATTR', attr_);
   ship_via_attr_          := Client_SYS.Get_Item_Value('SHIP_VIA_ATTR', attr_);
   forwarder_id_attr_      := Client_SYS.Get_Item_Value('FORWARDER_ID_ATTR', attr_);

   Update_Freight_prices___(number_of_updates_, valid_from_date_, percentage_offset_, amount_offset_,
                            price_list_attr_, ship_via_attr_, forwarder_id_attr_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (number_of_updates_ > 0) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NUMBER_OF_UPDATE: Sales price updated in :P1 record(s).', NULL, TO_CHAR(number_of_updates_));
      ELSE
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NO_UPDATES: No records were updated.');
      END IF;
      Transaction_SYS.Set_Progress_Info(info_);
   END IF;
END Start_Update_Freight_Prices__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Remove
--   Public interface provided to remove a record.
PROCEDURE Remove (
   price_list_no_      IN VARCHAR2,
   min_qty_            IN NUMBER,
   valid_from_         IN DATE,
   freight_map_id_     IN VARCHAR2,
   zone_id_            IN VARCHAR2 )
IS
   remrec_     FREIGHT_PRICE_LIST_LINE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, price_list_no_, min_qty_, valid_from_, freight_map_id_, zone_id_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


-- Get_Valid_Charge_Line
--   Returns the valid charge line for the parameters passed in
--   Check the 'min_qty <= NVL(order_weight_, order_volume_)' condition.  It is assumed that the price list freight base has been decided prior calling this method
@UncheckedAccess
FUNCTION Get_Valid_Charge_Line (
   price_list_no_      IN VARCHAR2,
   min_qty_weight_     IN NUMBER,
   min_qty_volume_     IN NUMBER,
   order_date_         IN DATE,
   freight_map_id_     IN VARCHAR2,
   zone_id_            IN VARCHAR2 ) RETURN NUMBER
IS
   min_quantity_              NUMBER := NULL;
   sales_price_               NUMBER := NULL;
   valid_from_date_           DATE   := NULL;

   CURSOR find_charge_line IS
      SELECT min_qty, MAX(valid_from)
      FROM   FREIGHT_PRICE_LIST_LINE_TAB
      WHERE  price_list_no = price_list_no_
      AND    zone_id = zone_id_
      AND    freight_map_id = freight_map_id_
      AND    trunc(valid_from) <= trunc(order_date_)
      AND    min_qty = (SELECT MAX(min_qty)
                             FROM   FREIGHT_PRICE_LIST_LINE_TAB
                             WHERE  price_list_no = price_list_no_
                             AND    zone_id = zone_id_
                             AND    freight_map_id = freight_map_id_
                             AND    min_qty <= NVL(min_qty_weight_, min_qty_volume_)
                             AND    trunc(valid_from) <= trunc(order_date_))
      GROUP BY min_qty;
   
   CURSOR fetch_price IS
      SELECT sales_price
      FROM   FREIGHT_PRICE_LIST_LINE_TAB
      WHERE  price_list_no = price_list_no_
      AND    zone_id = zone_id_
      AND    freight_map_id = freight_map_id_
      AND    trunc(valid_from) = trunc(valid_from_date_)
      AND    min_qty = min_quantity_;
BEGIN
   OPEN  find_charge_line;
   FETCH find_charge_line INTO min_quantity_, valid_from_date_;
   CLOSE find_charge_line;
   
   IF (min_quantity_ IS NOT NULL AND valid_from_date_ IS NOT NULL) THEN
      OPEN fetch_price;
      FETCH fetch_price INTO sales_price_;
      CLOSE fetch_price;
   END IF;
   
   RETURN sales_price_;
END Get_Valid_Charge_Line;


-- New
--   Creates a new record.
PROCEDURE New (
   price_list_no_       IN VARCHAR2,
   min_quantity_        IN NUMBER,
   valid_from_date_     IN DATE,
   freight_map_id_      IN VARCHAR2,
   zone_id_             IN VARCHAR2,
   sales_price_         IN NUMBER )
IS
   newrec_     FREIGHT_PRICE_LIST_LINE_TAB%ROWTYPE;
BEGIN
   newrec_.price_list_no := price_list_no_;
   newrec_.min_qty := min_quantity_;
   newrec_.valid_from := valid_from_date_;
   newrec_.freight_map_id := freight_map_id_;
   newrec_.zone_id := zone_id_;
   newrec_.sales_price := sales_price_;
   New___(newrec_);
END New;


-- Modify_Sales_Price
--   Modifies the sales_price.
PROCEDURE Modify_Sales_Price (
   price_list_no_       IN VARCHAR2,
   min_quantity_        IN NUMBER,
   valid_from_date_     IN DATE,
   freight_map_id_      IN VARCHAR2,
   zone_id_             IN VARCHAR2,
   sales_price_         IN NUMBER )
IS
   newrec_     FREIGHT_PRICE_LIST_LINE_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(price_list_no_, min_quantity_, valid_from_date_, freight_map_id_, zone_id_);
   newrec_.sales_price := sales_price_;
   Modify___(newrec_);
END Modify_Sales_Price;



