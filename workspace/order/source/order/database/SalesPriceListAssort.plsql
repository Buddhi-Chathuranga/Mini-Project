-----------------------------------------------------------------------------
--
--  Logical unit: SalesPriceListAssort
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210209  ErRalk  Bug 157558(SCZ-13423), Modified Copy__ method to allow copy sales price assortment list.
--  210112  MaEelk  SC2020R1-12036, Modified New_Line and replaced Unpack___, Check_Insert___, Insert___ with New___.
--  210112          Modified Modify_Sales_Price and Round_Sales_Price. Replaced Unpack___, Check_Update___, Update___ with Modify___. 
--  181015  MaEelk  SCUXXW4-9452, Added method Round_Sales_Price in order to support validations done in rounding.
--  161027  ChFolk  STRSC-4311, Added new parameters raise_msg_ and include_period_ to method Copy__ and modified the method to handle  coping according to the flag include_period_.
--  160831  ChFolk  STRSC-3834, Added new parameter valid_to_date into Modify_Sales_Price. Added new method Modify_Valid_To_Date.
--  160805  ChFolk  STRSC-3730, Added new parameter valid_to_date into New_Line and Modified method Copy__ to consider valid_to_date when coping sales price list lines.
--  160803  ChFolk  STRSC-3583, Added new method Check_Period_Overlapped___ and overrride Check_Common___ to add validations for valid_to_date.
--  160803          Modified Insert___ and Update___ to give information message when header valid to date is exceeded by line valid From date and To date.
--  140508  MaRalk  Modified Check_Insert___ and Check_Update___ to restrict adding sales price list assortments
--  140508          with a discount percentage when discount type is not defined.
--  120113  ChFolk  Added alias to the SALES_PRICE_LIST_ASSORT view and use it for the sub query as to get correct filteration.
--  111102  ChJalk  Added user allowed company and user allowed site filters to the view SALES_PRICE_ASSORT_JOIN.
--  111101  ChJalk  Added user allowed company and user allowed site filters to the view SALES_PRICE_LIST_ASSORT.
--  110208  RiLase  Added CASCADE to sales price list reference in view.
--  101210  ShKolk  Renamed company to owning_company.
--  101103  RaKalk  Restricted modifications of price list by unauthorised users.
--  090923 KiSalk  Added Remove.
--  090821 MaJalk  Added company to view ASSORTJOIN.
--  090806 KiSalk  Added Modify_Sales_Price.
--  090619 KiSalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   price_list_no_ SALES_PRICE_LIST_ASSORT_TAB.price_list_no%TYPE;
BEGIN

   price_list_no_ := Client_SYS.Get_Item_Value('PRICE_LIST_NO',attr_ );

   super(attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', Site_API.Get_Site_Date(User_Default_API.Get_Contract), attr_);
   IF (price_list_no_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ROUNDING', Sales_Price_List_API.Get_Rounding(price_list_no_), attr_);
   END IF;
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SALES_PRICE_LIST_ASSORT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.last_updated := TRUNC(SYSDATE);
   IF (newrec_.valid_from_date > Sales_Price_List_API.Get_Valid_To_Date(newrec_.price_list_no)) THEN
      Client_SYS.Add_Info(lu_name_, 'WARN_FOR_VALID_FROM: Price list :P1 will not be valid for Valid From date :P2.', newrec_.price_list_no, newrec_.valid_from_date);
   END IF;
   IF (newrec_.valid_to_date > Sales_Price_List_API.Get_Valid_To_Date(newrec_.price_list_no)) THEN
      Client_SYS.Add_Info(lu_name_, 'WARN_FOR_VALID_TO: Price list :P1 will not be valid for Valid To date :P2.', newrec_.price_list_no, newrec_.valid_to_date);
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('LAST_UPDATED', newrec_.last_updated, attr_);

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SALES_PRICE_LIST_ASSORT_TAB%ROWTYPE,
   newrec_     IN OUT SALES_PRICE_LIST_ASSORT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.last_updated := TRUNC(SYSDATE);
   IF (newrec_.valid_from_date > Sales_Price_List_API.Get_Valid_To_Date(newrec_.price_list_no)) THEN
      Client_SYS.Add_Info(lu_name_, 'WARN_FOR_VALID_FROM: Price list :P1 will not be valid for Valid From date :P2.', newrec_.price_list_no, newrec_.valid_from_date);
   END IF;
   IF (newrec_.valid_to_date > Sales_Price_List_API.Get_Valid_To_Date(newrec_.price_list_no)) THEN
      Client_SYS.Add_Info(lu_name_, 'WARN_FOR_VALID_TO: Price list :P1 will not be valid for Valid To date :P2.', newrec_.price_list_no, newrec_.valid_to_date);
   END IF;
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr('LAST_UPDATED', newrec_.last_updated, attr_);

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SALES_PRICE_LIST_ASSORT_TAB%ROWTYPE )
IS
BEGIN
   Sales_Price_List_API.Check_Editable(remrec_.price_list_no);

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_price_list_assort_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   IF (Assortment_Node_API.Get_Part_No(newrec_.assortment_id, newrec_.assortment_node_id) IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'PARTNODEERROR: Entered node is a part node in the assortment structure. Part nodes are not allowed in assortment node based sales price list lines.');
   END IF;
   IF (newrec_.min_quantity < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGATIVE_MIN_QTY: Min Qty can not be negative');
   END IF;

   IF (newrec_.sales_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGATIVE_SALES_QTY: Sales Price can not be negative');
   END IF;
   
   IF (newrec_.discount_type IS NULL AND newrec_.discount IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DISCTYPE_NULL: Discount percentage cannot be entered without a corresponding discount type.');
   END IF;

   Sales_Price_List_API.Check_Editable(newrec_.price_list_no);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_price_list_assort_tab%ROWTYPE,
   newrec_ IN OUT sales_price_list_assort_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.min_quantity < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGATIVE_MIN_QTY: Min Qty can not be negative');
   END IF;

   IF (newrec_.sales_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGATIVE_SALES_QTY: Sales Price can not be negative');
   END IF;
   
   IF (newrec_.discount_type IS NULL AND newrec_.discount IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DISCTYPE_NULL: Discount percentage cannot be entered without a corresponding discount type.');
   END IF;

   Sales_Price_List_API.Check_Editable(newrec_.price_list_no);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     sales_price_list_assort_tab%ROWTYPE,
   newrec_ IN OUT sales_price_list_assort_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (TRUNC(newrec_.valid_from_date) > TRUNC(newrec_.valid_to_date)) THEN
      Error_SYS.Record_General(lu_name_, 'EARLY_TO_DATE: Valid To date has to be equal to or later than Valid From date.');
   END IF;
   IF (indrec_.valid_to_date AND newrec_.valid_to_date IS NOT NULL) THEN
      IF (Check_Period_Overlapped___(newrec_.price_list_no,
                                     newrec_.min_quantity,
                                     newrec_.valid_from_date,
                                     newrec_.assortment_id,
                                     newrec_.assortment_node_id,
                                     newrec_.price_unit_meas,
                                     newrec_.valid_to_date) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'PERIOD_OVRLAPPED: Timeframe is overlapping with other Valid From and Valid To timeframe for same Min Qty.');
      END IF;
   END IF;   
END Check_Common___;

FUNCTION Check_Period_Overlapped___(
   price_list_no_       IN  VARCHAR2,
   min_quantity_        IN  NUMBER,
   valid_from_date_     IN  DATE,
   assortment_id_       IN  VARCHAR2,
   assortment_node_id_  IN  VARCHAR2,
   price_unit_meas_     IN  VARCHAR2,
   valid_to_date_       IN  DATE ) RETURN VARCHAR2
IS
   period_overlapped_  VARCHAR2(5) := 'FALSE';
   dummy_              NUMBER;
   
   CURSOR find_overlap IS
      SELECT 1
      FROM SALES_PRICE_LIST_ASSORT_TAB
      WHERE price_list_no = price_list_no_      
      AND min_quantity = min_quantity_
      AND assortment_id = assortment_id_
      AND assortment_node_id = assortment_node_id_
      AND price_unit_meas = price_unit_meas_ 
      AND valid_to_date IS NOT NULL
      AND ((TRUNC(valid_from_date_) BETWEEN TRUNC(valid_from_date) AND TRUNC(valid_to_date)) OR
           (TRUNC(valid_to_date_) BETWEEN TRUNC(valid_from_date) AND TRUNC(valid_to_date)) OR
           (TRUNC(valid_to_date_) IS NOT NULL AND (TRUNC(valid_from_date) BETWEEN TRUNC(valid_from_date_) AND TRUNC(valid_to_date_))) OR
           (TRUNC(valid_to_date_) IS NOT NULL AND (TRUNC(valid_to_date) BETWEEN TRUNC(valid_from_date_) AND TRUNC(valid_to_date_))))
      AND valid_from_date != valid_from_date_;
BEGIN
   OPEN find_overlap;
   FETCH find_overlap INTO dummy_;
   IF (find_overlap%FOUND) THEN
      period_overlapped_ := 'TRUE';
   END IF;   
   CLOSE find_overlap;
   
   RETURN period_overlapped_;
END Check_Period_Overlapped___;   
   
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy__
--   Copies records from a price list to another that are valid on the specified date.
--   Returns number of records copied.
PROCEDURE Copy__ (
   copied_items_       OUT NUMBER,
   raise_msg_          IN OUT VARCHAR2,
   price_list_no_      IN  VARCHAR2,
   valid_from_date_    IN  DATE,
   currency_rate_      IN  NUMBER,
   rounding_           IN  NUMBER,
   to_price_list_no_   IN  VARCHAR2,
   to_valid_from_date_ IN  DATE,
   include_period_     IN  VARCHAR2 )
IS
   ignore_header_rounding_  BOOLEAN;
   new_valid_from_date_     DATE;
   to_rounding_             NUMBER;
   counter_                 NUMBER := 0;
   from_list_rec_           Sales_Price_List_API.Public_Rec;
   to_list_rec_             Sales_Price_List_API.Public_Rec;
   different_assortment     EXCEPTION;
   new_valid_to_date_       DATE;
   exist_rec_valid_to_date_ DATE;
   next_valid_from_date_    DATE;
   
   CURSOR find_all_assort_based_records IS
      SELECT min_quantity, valid_from_date, assortment_id, assortment_node_id, price_unit_meas, rounding,
             discount_type, discount, sales_price * currency_rate_ sales_price, valid_to_date
      FROM   sales_price_list_assort_tab
      WHERE  price_list_no = price_list_no_;

   CURSOR get_time_frame_records IS
      SELECT min_quantity, valid_from_date, assortment_id, assortment_node_id, price_unit_meas, rounding,
             discount_type, discount, sales_price * currency_rate_ sales_price, valid_to_date
      FROM   sales_price_list_assort_tab
      WHERE  price_list_no = price_list_no_
      AND    valid_to_date IS NOT NULL
      AND    valid_from_date <= TRUNC(valid_from_date_)
      AND    valid_to_date >= TRUNC(valid_from_date_);
      
   CURSOR get_non_time_frame_records IS
      SELECT min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date, rounding,
             discount_type, discount, sales_price * currency_rate_ sales_price
      FROM   sales_price_list_assort_tab
      WHERE  price_list_no = price_list_no_
      AND   (min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date) IN
             (SELECT min_quantity, assortment_id, assortment_node_id, price_unit_meas, MAX(valid_from_date)
              FROM  sales_price_list_assort_tab 
              WHERE  price_list_no = price_list_no_
              AND    valid_from_date <= TRUNC(valid_from_date_)
              AND    valid_to_date IS NULL
              GROUP BY min_quantity, assortment_id, assortment_node_id, price_unit_meas);
              
   CURSOR check_exist_inserted_rec(new_price_list_no_ VARCHAR2, min_quantity_ IN NUMBER, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, price_unit_meas_ IN VARCHAR2, from_date_ IN DATE) IS
      SELECT valid_to_date
      FROM   sales_price_list_assort_tab
      WHERE  price_list_no = new_price_list_no_
      AND    min_quantity = min_quantity_
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_
      AND    price_unit_meas = price_unit_meas_
      AND    valid_from_date = from_date_;
         
   -- Suppose we have given a valid from date as 15-06-2009 when copying and there are three records with vaid_from_dates
   -- 13-06-2009,14-06-2009 and 16-06-2009, This cursor will select 14-06-2009 as the date that we should consider when copying records
   CURSOR get_next_records IS
         SELECT min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date, rounding,
                discount_type, discount, sales_price * currency_rate_ sales_price, valid_to_date
         FROM  sales_price_list_assort_tab
         WHERE  price_list_no = price_list_no_
         AND    NVL(valid_to_date, TRUNC(valid_from_date_)) >= TRUNC(valid_from_date_)
         AND   (min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date) IN
             (SELECT min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date
              FROM  sales_price_list_assort_tab
              WHERE (min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date) IN
                    (SELECT min_quantity, assortment_id, assortment_node_id, price_unit_meas, MAX(valid_from_date) valid_from_date
                     FROM   sales_price_list_assort_tab
                     WHERE  price_list_no = price_list_no_
                     AND    valid_from_date <= TRUNC(valid_from_date_)
                     AND    valid_to_date IS NULL
                     GROUP BY min_quantity, assortment_id, assortment_node_id, price_unit_meas)
                     UNION ALL
                     (SELECT min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date
                      FROM   sales_price_list_assort_tab
                      WHERE  price_list_no = price_list_no_
                      AND    valid_from_date > TRUNC(valid_from_date_)))
         ORDER BY min_quantity, assortment_id, assortment_node_id, price_unit_meas, valid_from_date;
   
   CURSOR find_null_valid_to_date_recs IS
      SELECT min_quantity, valid_from_date, assortment_id, assortment_node_id, price_unit_meas, rounding,
             discount_type, discount, sales_price * currency_rate_ sales_price
      FROM   sales_price_list_assort_tab
      WHERE  price_list_no = price_list_no_
      AND    valid_to_date IS NULL
      AND   (assortment_id, assortment_node_id, min_quantity, price_unit_meas, valid_from_date) IN
          (SELECT assortment_id, assortment_node_id, min_quantity, price_unit_meas, valid_from_date
           FROM  sales_price_list_assort_tab
           WHERE (assortment_id, assortment_node_id, min_quantity, price_unit_meas, valid_from_date) IN
                 (SELECT assortment_id, assortment_node_id, min_quantity, price_unit_meas, MAX(valid_from_date) valid_from_date
                  FROM   sales_price_list_assort_tab
                  WHERE  price_list_no = price_list_no_
                  AND    valid_from_date <= TRUNC(valid_from_date_)
                  AND    valid_to_date IS NULL
                  GROUP BY assortment_id, assortment_node_id, min_quantity, price_unit_meas)
                  UNION ALL
                  (SELECT assortment_id, assortment_node_id, min_quantity, price_unit_meas, valid_from_date
                   FROM   sales_price_list_assort_tab
                   WHERE  price_list_no = price_list_no_
                   AND    valid_from_date > TRUNC(valid_from_date_)
                   AND    valid_to_date IS NULL))
      ORDER BY assortment_id, assortment_node_id, min_quantity, price_unit_meas, valid_from_date;
 
BEGIN
   
   from_list_rec_ := Sales_Price_List_API.Get(price_list_no_);
   to_list_rec_ := Sales_Price_List_API.Get(to_price_list_no_);

   IF (from_list_rec_.assortment_id IS NULL 
       OR to_list_rec_.assortment_id IS NULL 
       OR NVL(to_list_rec_.assortment_id, '') != to_list_rec_.assortment_id) THEN
      -- No need to procede on copying assortment node based lines. So, skip this procedure.
      RAISE different_assortment;
   END IF;

   ignore_header_rounding_ := (to_list_rec_.currency_code = to_list_rec_.currency_code);
   to_rounding_ := rounding_;

   IF (valid_from_date_ IS NULL) THEN
      -- Copy all rows on price list.
      FOR rec_ IN find_all_assort_based_records LOOP
         IF (include_period_ = 'TRUE' OR ((include_period_ = 'FALSE') AND rec_.valid_to_date IS NULL)) THEN
            IF (ignore_header_rounding_) THEN
               to_rounding_ := rec_.rounding;
            END IF;
            IF (Check_Record_Exist(to_price_list_no_ ,
                                   rec_.min_quantity,
                                   rec_.valid_from_date,
                                   rec_.assortment_id,
                                   rec_.assortment_node_id,
                                   rec_.price_unit_meas) = 0) THEN
               New_Line(to_price_list_no_,
                        rec_.min_quantity,
                        rec_.valid_from_date,
                        rec_.assortment_id,
                        rec_.assortment_node_id,
                        rec_.price_unit_meas,
                        to_rounding_,
                        rec_.sales_price,
                        rec_.discount,
                        rec_.discount_type,
                        rec_.valid_to_date);
               counter_ := counter_ + 1;
            END IF;
         END IF;
      END LOOP;
   ELSE
      -- Copy only rows that are valid from the specified date "valid_from_date_".
      -- IF a to_valid_from_date_ is given we will use that date as the valid_from_date of the new records
      -- IF not depending on the valid_from_date of the old records and the given valid_from_date when copying, fetch the dates for the new records
      IF (include_period_ = 'TRUE') THEN
         IF (to_valid_from_date_ IS NOT NULL) THEN
            -- only one record will be created for one catalog, min_quantity and min_duration
            new_valid_from_date_ := to_valid_from_date_;
            FOR rec_ IN get_time_frame_records LOOP
               IF (ignore_header_rounding_) THEN
                  to_rounding_ := rec_.rounding;
               END IF;
               new_valid_to_date_ := rec_.valid_to_date;
               IF (new_valid_from_date_ > rec_.valid_to_date) THEN
                  new_valid_to_date_ := NULL;
                  IF (raise_msg_ IS NULL) THEN
                     raise_msg_ := 'TRUE';
                  END IF;   
               END IF;
               IF (Check_Record_Exist(to_price_list_no_ ,
                                      rec_.min_quantity,
                                      new_valid_from_date_,
                                      rec_.assortment_id,
                                      rec_.assortment_node_id,
                                      rec_.price_unit_meas) = 0) THEN
                  New_Line(to_price_list_no_,
                           rec_.min_quantity,
                           new_valid_from_date_,
                           rec_.assortment_id,
                           rec_.assortment_node_id,
                           rec_.price_unit_meas,
                           to_rounding_,
                           rec_.sales_price,
                           rec_.discount,
                           rec_.discount_type,
                           new_valid_to_date_);
                  counter_ := counter_ + 1;
               END IF;
            END LOOP;
            FOR rec_ IN get_non_time_frame_records LOOP
               new_valid_from_date_ := to_valid_from_date_;
               -- if there exists a valid timeframe record, the new record is created. Need to create a new record only otherwise.
               OPEN check_exist_inserted_rec(to_price_list_no_, rec_.min_quantity, rec_.assortment_id, rec_.assortment_node_id, rec_.price_unit_meas, new_valid_from_date_);
               FETCH check_exist_inserted_rec INTO exist_rec_valid_to_date_;
               CLOSE check_exist_inserted_rec;
               IF (exist_rec_valid_to_date_ IS NULL) THEN
                  IF (ignore_header_rounding_) THEN
                     to_rounding_ := rec_.rounding;
                  END IF;
                  IF (Check_Record_Exist(to_price_list_no_ ,
                                      rec_.min_quantity,
                                      new_valid_from_date_,
                                      rec_.assortment_id,
                                      rec_.assortment_node_id,
                                      rec_.price_unit_meas) = 0) THEN
                     New_Line(to_price_list_no_,
                              rec_.min_quantity,
                              new_valid_from_date_,
                              rec_.assortment_id,
                              rec_.assortment_node_id,
                              rec_.price_unit_meas,
                              to_rounding_,
                              rec_.sales_price,
                              rec_.discount,
                              rec_.discount_type,
                              NULL);
                     counter_ := counter_ + 1;
                  END IF;
               END IF;   
            END LOOP;   
         ELSE
            -- include_period = TRUE
            -- to_valid_from_date_ IS NULL
            FOR rec_ IN get_time_frame_records LOOP
               new_valid_from_date_ := valid_from_date_;
               IF (ignore_header_rounding_) THEN
                  to_rounding_ := rec_.rounding;
               END IF;
               IF (Check_Record_Exist(to_price_list_no_ ,
                                      rec_.min_quantity,
                                      new_valid_from_date_,
                                      rec_.assortment_id,
                                      rec_.assortment_node_id,
                                      rec_.price_unit_meas) = 0) THEN
                  New_Line(to_price_list_no_,
                           rec_.min_quantity,
                           new_valid_from_date_,
                           rec_.assortment_id,
                           rec_.assortment_node_id,
                           rec_.price_unit_meas,
                           to_rounding_,
                           rec_.sales_price,
                           rec_.discount,
                           rec_.discount_type,
                           rec_.valid_to_date);
                  counter_ := counter_ + 1;
               END IF;
            END LOOP;
            FOR rec_ IN get_next_records LOOP
               IF (ignore_header_rounding_) THEN
                  to_rounding_ := rec_.rounding;
               END IF;
               IF (rec_.valid_from_date <= valid_from_date_) THEN
                  new_valid_from_date_ := valid_from_date_;
                  OPEN check_exist_inserted_rec(to_price_list_no_, rec_.min_quantity, rec_.assortment_id, rec_.assortment_node_id, rec_.price_unit_meas, rec_.valid_from_date);
                  FETCH check_exist_inserted_rec INTO exist_rec_valid_to_date_;
                  CLOSE check_exist_inserted_rec;
                  IF (exist_rec_valid_to_date_ IS NULL) THEN   
                     IF (Check_Record_Exist(to_price_list_no_ ,
                                           rec_.min_quantity,
                                           new_valid_from_date_,
                                           rec_.assortment_id,
                                           rec_.assortment_node_id,
                                           rec_.price_unit_meas) = 0) THEN
                        New_Line(to_price_list_no_,
                                 rec_.min_quantity,
                                 new_valid_from_date_,
                                 rec_.assortment_id,
                                 rec_.assortment_node_id,
                                 rec_.price_unit_meas,
                                 to_rounding_,
                                 rec_.sales_price,
                                 rec_.discount,
                                 rec_.discount_type,
                                 rec_.valid_to_date);
                        counter_ := counter_ + 1;
                     END IF;
                  ELSE
                     next_valid_from_date_ := exist_rec_valid_to_date_ + 1;
                     IF (Check_Record_Exist(to_price_list_no_ ,
                                           rec_.min_quantity,
                                           new_valid_from_date_,
                                           rec_.assortment_id,
                                           rec_.assortment_node_id,
                                           rec_.price_unit_meas) = 0) THEN
                        New_Line(to_price_list_no_,
                                 rec_.min_quantity,
                                 next_valid_from_date_,
                                 rec_.assortment_id,
                                 rec_.assortment_node_id,
                                 rec_.price_unit_meas,
                                 to_rounding_,
                                 rec_.sales_price,
                                 rec_.discount,
                                 rec_.discount_type,
                                 NULL);
                        counter_ := counter_ + 1;
                     END IF;
                  END IF;
               ELSE
                  IF (Check_Record_Exist(to_price_list_no_ ,
                                         rec_.min_quantity,
                                         rec_.valid_from_date,
                                         rec_.assortment_id,
                                         rec_.assortment_node_id,
                                         rec_.price_unit_meas) = 0) THEN
                     New_Line(to_price_list_no_,
                              rec_.min_quantity,
                              rec_.valid_from_date,
                              rec_.assortment_id,
                              rec_.assortment_node_id,
                              rec_.price_unit_meas,
                              to_rounding_,
                              rec_.sales_price,
                              rec_.discount,
                              rec_.discount_type,
                              rec_.valid_to_date);
                     counter_ := counter_ + 1;
                  END IF;
               END IF;
            END LOOP;
         END IF;
      ELSE
         -- valid_from_date IS NOT NULL
         -- include_period_ = 'FALSE'
         IF (to_valid_from_date_ IS NULL) THEN
            -- must copy all lines after the given valid_from_date_
            FOR rec_ IN find_null_valid_to_date_recs LOOP
               IF (valid_from_date_ > rec_.valid_from_date) THEN
                  new_valid_from_date_ := valid_from_date_;
               ELSE
                  new_valid_from_date_ := rec_.valid_from_date;
               END IF;

               IF (ignore_header_rounding_) THEN
                  to_rounding_ := rec_.rounding;
               END IF;
               IF (Check_Record_Exist(to_price_list_no_ ,
                                      rec_.min_quantity,
                                      new_valid_from_date_,
                                      rec_.assortment_id,
                                      rec_.assortment_node_id,
                                      rec_.price_unit_meas) = 0) THEN
                  New_Line(to_price_list_no_,
                           rec_.min_quantity,
                           new_valid_from_date_,
                           rec_.assortment_id,
                           rec_.assortment_node_id,
                           rec_.price_unit_meas,
                           to_rounding_,
                           rec_.sales_price,
                           rec_.discount,
                           rec_.discount_type,
                           NULL);
                  counter_ := counter_ + 1;
               END IF;
            END LOOP;
         ELSE 
            -- valid_from_date IS NOT NULL
            -- include_period_ = 'FALSE'
            -- to_valid_from_date IS NOT NULL
            FOR rec_ IN get_non_time_frame_records LOOP
               new_valid_from_date_ := to_valid_from_date_;
               IF (ignore_header_rounding_) THEN
                  to_rounding_ := rec_.rounding;
               END IF;
               IF (Check_Record_Exist(to_price_list_no_ ,
                                      rec_.min_quantity,
                                      rec_.valid_from_date,
                                      rec_.assortment_id,
                                      rec_.assortment_node_id,
                                      rec_.price_unit_meas) = 0) THEN
                  New_Line(to_price_list_no_,
                           rec_.min_quantity,
                           new_valid_from_date_,
                           rec_.assortment_id,
                           rec_.assortment_node_id,
                           rec_.price_unit_meas,
                           to_rounding_,
                           rec_.sales_price,
                           rec_.discount,
                           rec_.discount_type,
                           NULL);
                  counter_ := counter_ + 1;
               END IF;               
            END LOOP;
         END IF;
      END IF;
   END IF;
   copied_items_ := counter_;

EXCEPTION
   WHEN different_assortment THEN
      copied_items_ := counter_;
END Copy__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New_Line
--   Add a new record in sales_price_list_assort_tab.
PROCEDURE New_Line (
   price_list_no_      IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_date_    IN DATE,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   price_unit_meas_    IN VARCHAR2,
   rounding_           IN NUMBER,
   sales_price_        IN NUMBER,
   discount_           IN NUMBER,
   discount_type_      IN VARCHAR2,
   valid_to_date_      IN DATE )
IS
   newrec_     SALES_PRICE_LIST_ASSORT_TAB%ROWTYPE;
BEGIN

   newrec_.price_list_no := price_list_no_;
   newrec_.min_quantity := min_quantity_;
   newrec_.valid_from_date := valid_from_date_;
   newrec_.assortment_id := assortment_id_;
   newrec_.assortment_node_id := assortment_node_id_;
   newrec_.price_unit_meas := price_unit_meas_;
   newrec_.rounding := rounding_;
   newrec_.sales_price := sales_price_; 
   newrec_.discount := discount_;
   newrec_.discount_type := discount_type_;
   newrec_.valid_to_date := valid_to_date_;
   
   New___(newrec_);

END New_Line;


-- Check_Record_Exist
--   Returns 1 if Record Exists and 0 otherwise.
@UncheckedAccess
FUNCTION Check_Record_Exist (
   price_list_no_      IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_date_    IN DATE,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   price_unit_meas_    IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(price_list_no_, min_quantity_, valid_from_date_, assortment_id_, assortment_node_id_, price_unit_meas_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Record_Exist;


-- Modify_Sales_Price
--   Modifies the sales_price.
PROCEDURE Modify_Sales_Price (
   price_list_no_      IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_date_    IN DATE,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   price_unit_meas_    IN VARCHAR2,
   sales_price_        IN NUMBER,
   valid_to_date_      IN DATE )
IS
   newrec_     SALES_PRICE_LIST_ASSORT_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(price_list_no_, min_quantity_, valid_from_date_, assortment_id_, assortment_node_id_, price_unit_meas_);
   newrec_.sales_price := sales_price_;
   newrec_.valid_to_date := valid_to_date_;
   Modify___(newrec_);
END Modify_Sales_Price;

-- This method modifies valid_to_date
PROCEDURE Modify_Valid_To_Date (
   price_list_no_      IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_date_    IN DATE,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   price_unit_meas_    IN VARCHAR2,
   valid_to_date_      IN DATE )
IS   
   newrec_     SALES_PRICE_LIST_ASSORT_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(price_list_no_, min_quantity_, valid_from_date_, assortment_id_, assortment_node_id_, price_unit_meas_);
   newrec_.valid_to_date := valid_to_date_;
   Modify___(newrec_);
END Modify_Valid_To_Date;   

-- Remove
--   A public interface for Remove__.
PROCEDURE Remove (
   price_list_no_      IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_date_    IN DATE,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   price_unit_meas_    IN VARCHAR2 )
IS
   remrec_     SALES_PRICE_LIST_ASSORT_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, price_list_no_, min_quantity_, valid_from_date_, assortment_id_, assortment_node_id_, price_unit_meas_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;

PROCEDURE Round_Sales_Price (
   price_list_no_      IN VARCHAR2,
   rounding_           IN NUMBER )   
IS
   CURSOR get_sales_price_list_assort IS
      SELECT price_list_no, min_quantity, valid_from_date, assortment_id, assortment_node_id, price_unit_meas, sales_price
      FROM sales_price_list_assort_tab
      WHERE price_list_no = price_list_no_;
      
   newrec_     SALES_PRICE_LIST_ASSORT_TAB%ROWTYPE;  
BEGIN
   IF (price_list_no_ IS NOT NULL) THEN
      FOR rec_ IN  get_sales_price_list_assort LOOP
         newrec_ := Get_Object_By_Keys___(rec_.price_list_no, rec_.min_quantity, rec_.valid_from_date, rec_.assortment_id, rec_.assortment_node_id, rec_.price_unit_meas);
         newrec_.sales_price := ROUND(rec_.sales_price, NVL(rounding_, 20));
         newrec_.rounding := rounding_;
         Modify___(newrec_);                            
      END LOOP;
   END IF;
END Round_Sales_Price;

