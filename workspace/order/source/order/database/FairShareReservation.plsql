-----------------------------------------------------------------------------
--
--  Logical unit: FairShareReservation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210630  JOWISE   MF21R2-2040, Truncate time indication for Planned Due Date field when comparing with a date field
--  150126  MaIklk STRSC-387, Fixed to remove function calls in get_lines_pr3 cursor (Reserve_Fair_Share___()).
--  151019  Chfose LIM-3893, Removed pallet location types in call to Inventory_Part_In_Stock_API.Get_Inventory_Quantity.
--  140731  MeAblk Removed activity_seq_ parameter from the method call Shortage_Demand_API.Calculate_Order_Shortage_Qty.
--  120920  RoJalk Allow connecting a customer order line to several shipment lines - modified the method call 
--  120920         Reserve_Customer_Order_API.Reserve_Order_Line__ and passed the shipment_id_.
--  120314  DaZase Removed last TRUE parameter in Init_Method call inside Process_Fair_Share_Orders__
--  111014  NaLrlk Modified the method Reserve_Fair_Share___ to handle the proportional reservation properly. 
--  091214  AmPalk Bug 86815, Modify the Reserve_Fair_Share___ to use  Get_Objstate and the db_value of the status 
--  091214         for Partially Delivered filter in its' get_lines_pr1 cursor. 
--  090119  NaLrlk Modified the methods Reserve_Fair_Share___ and Process_Fair_Share_Orders__ 
--  090119         to handle the shortages for fair share lines.
--  081023  MiKulk Modified the method Reserve_Fair_Share___ to get the correct
--  081023         base_qty_for_prop_scaling_.
--  080508  MiKulk Modified the sequence name to Fair_Share_Reservation_Seq
--  080103  MiKulk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Reserve_Fair_Share___ (
   sequence_no_  IN NUMBER,
   part_no_      IN VARCHAR2,
   qty_avail_    IN NUMBER,
   qty_required_ IN NUMBER,
   run_date_     IN DATE )
IS
   priority_           NUMBER := 0;
   qty_reserved_       NUMBER;
   qty_remaining_      NUMBER;
   qty_needed_         NUMBER;
   qty_for_pr_         NUMBER;
   qty_to_res_         NUMBER;
   total_needed_qty_   NUMBER;
   total_res_qty_      NUMBER;
   inv_uom_            INVENTORY_PART_TAB.unit_meas%TYPE;
   unit_type_db_       VARCHAR2(10); 
   base_qty_for_prop_scaling_ NUMBER;

   -- Get qty to reserve of Partially delivered Customer Orders
   CURSOR get_lines_pr1 IS
      SELECT order_no, line_no, rel_no, line_item_no,
             (revised_qty_due - qty_assigned - qty_shipped - qty_to_ship - qty_on_order) qty_rest
        FROM customer_order_line_tab
       WHERE part_no = part_no_
         AND (revised_qty_due - qty_assigned - qty_shipped - qty_to_ship - qty_on_order) > 0
         AND order_no IN (SELECT order_no
                            FROM FAIR_SHARE_RESERVATION_TAB
                           WHERE sequence_no = sequence_no_
                             AND Customer_Order_API.Get_Objstate(order_no) = 'PartiallyDelivered')
         AND rowstate NOT IN ('Cancelled', 'Delivered', 'Invoiced')
         AND trunc(planned_due_date) <= trunc(run_date_)
    ORDER BY planned_ship_date, order_no;

   -- Get qty to reserve with earlier planned due dates
   CURSOR get_lines_pr2 IS
      SELECT order_no, line_no, rel_no, line_item_no,
             (revised_qty_due - qty_assigned - qty_shipped - qty_to_ship - qty_on_order) qty_rest
        FROM customer_order_line_tab
       WHERE part_no = part_no_
         AND rowstate != 'Cancelled'
         AND (revised_qty_due - qty_assigned - qty_shipped - qty_to_ship - qty_on_order) > 0
         AND trunc(planned_due_date) < trunc(sysdate)
         AND order_no IN (SELECT order_no
                            FROM FAIR_SHARE_RESERVATION_TAB
                           WHERE sequence_no = sequence_no_)
         AND trunc(planned_due_date) <= trunc(run_date_)
    ORDER BY planned_ship_date, order_no;

   -- Get the highest priorities in the unreserved Customer orders
   CURSOR get_lines_pr3 IS
      SELECT co.priority,
             SUM(col.revised_qty_due - col.qty_assigned - col.qty_shipped - col.qty_to_ship - col.qty_on_order) tot_qty
        FROM customer_order_line_tab col, customer_order_tab co
       WHERE col.order_no = co.order_no
         AND col.part_no = part_no_
         AND col.rowstate != 'Cancelled'
         AND (col.revised_qty_due - col.qty_assigned - col.qty_shipped - col.qty_to_ship - col.qty_on_order) > 0
         AND col.order_no IN (SELECT order_no
                            FROM FAIR_SHARE_RESERVATION_TAB
                           WHERE sequence_no = sequence_no_)
         AND trunc(col.planned_due_date) >= trunc(sysdate) 
         AND trunc(col.planned_due_date) <= trunc(run_date_)
    GROUP BY co.priority
    ORDER BY co.priority;

   -- get the qty reserve for a given priority
   CURSOR get_lines(priority_ IN NUMBER) IS
      SELECT order_no, line_no, rel_no, line_item_no,
             (revised_qty_due - qty_assigned - qty_shipped - qty_to_ship - qty_on_order) qty_rest
        FROM customer_order_line_tab
       WHERE part_no = part_no_
         AND rowstate != 'Cancelled'
         AND (revised_qty_due - qty_assigned - qty_shipped - qty_to_ship - qty_on_order) > 0
         AND order_no IN (SELECT order_no
                            FROM FAIR_SHARE_RESERVATION_TAB
                           WHERE sequence_no = sequence_no_)
         AND trunc(planned_due_date) >= trunc(sysdate)
         AND trunc(planned_due_date) <= trunc(run_date_)
         AND Customer_Order_API.Get_Priority(order_no) = priority_;

   -- Get the total qty needed to be reserved propotionally
   CURSOR total_needed IS
      SELECT SUM (revised_qty_due - qty_assigned - qty_shipped - qty_to_ship - qty_on_order) total_needed_qty
        FROM customer_order_line_tab
       WHERE part_no = part_no_
         AND (revised_qty_due - qty_assigned - qty_shipped - qty_to_ship - qty_on_order) > 0
         AND rowstate != 'Cancelled'
         AND order_no IN (SELECT order_no
                            FROM FAIR_SHARE_RESERVATION_TAB
                           WHERE sequence_no = sequence_no_)
         AND trunc(planned_due_date) <= trunc(run_date_)
    ORDER BY planned_ship_date, order_no;

   -- Get the balance CO lines which didn't include in any of the above 3 priorities 
   CURSOR get_lines_left IS
      SELECT order_no, line_no, rel_no, line_item_no,
             (revised_qty_due - qty_assigned - qty_shipped - qty_to_ship - qty_on_order) qty_rest
        FROM customer_order_line_tab
       WHERE part_no = part_no_
         AND (revised_qty_due - qty_assigned - qty_shipped - qty_to_ship - qty_on_order) > 0
         AND rowstate != 'Cancelled'
         AND order_no IN (SELECT order_no
                            FROM FAIR_SHARE_RESERVATION_TAB
                           WHERE sequence_no = sequence_no_)
         AND trunc(planned_due_date) <= trunc(run_date_)
    ORDER BY planned_ship_date, order_no;

   TYPE Bal_Order_Lines_Tab IS TABLE OF get_lines_left%ROWTYPE
   INDEX BY PLS_INTEGER;
   bal_order_lines_   Bal_Order_Lines_Tab;
BEGIN
   qty_remaining_ := qty_avail_; -- Available quantity in inventory that can be reserved
   qty_needed_    := qty_required_; -- Total quantity that need to be reserved for fair share orders

   --First priority for the partially delivered orders
   FOR pr1_rec_ IN get_lines_pr1 LOOP
      IF (qty_remaining_ > 0) THEN
         IF (qty_remaining_ < pr1_rec_.qty_rest) THEN
            -- Last parameter is set to FALSE becuase we do NOT want to set shortages at this point
            Reserve_Customer_Order_API.Reserve_Order_Line__(qty_reserved_       => qty_reserved_, 
                                                            order_no_           => pr1_rec_.order_no, 
                                                            line_no_            => pr1_rec_.line_no, 
                                                            rel_no_             => pr1_rec_.rel_no, 
                                                            line_item_no_       => pr1_rec_.line_item_no, 
                                                            qty_to_be_reserved_ => qty_remaining_,
                                                            shipment_id_        => 0,  
                                                            set_shortage_       => FALSE);
            EXIT;
         ELSE
            -- Last parameter is set to FALSE becuase we do NOT want to set shortages at this point
            Reserve_Customer_Order_API.Reserve_Order_Line__(qty_reserved_       => qty_reserved_, 
                                                            order_no_           => pr1_rec_.order_no, 
                                                            line_no_            => pr1_rec_.line_no, 
                                                            rel_no_             => pr1_rec_.rel_no, 
                                                            line_item_no_       => pr1_rec_.line_item_no, 
                                                            qty_to_be_reserved_ => pr1_rec_.qty_rest, 
                                                            shipment_id_        => 0,
                                                            set_shortage_       => FALSE );
         END IF;
         qty_remaining_ := NVL((qty_remaining_ - qty_reserved_),0);
         qty_needed_    := NVL((qty_needed_ - qty_reserved_),0);
      ELSE
         EXIT;
      END IF;
   END LOOP;

   -- second priority for the passed planned due dates
   IF (qty_remaining_ > 0) THEN
      FOR pr2_rec_ IN get_lines_pr2 LOOP
         IF (qty_remaining_ > 0) THEN
            IF (qty_remaining_ < pr2_rec_.qty_rest) THEN
               -- Last parameter is set to FALSE becuase we do NOT want to set shortages at this point
               Reserve_Customer_Order_API.Reserve_Order_Line__(qty_reserved_       => qty_reserved_, 
                                                               order_no_           => pr2_rec_.order_no, 
                                                               line_no_            => pr2_rec_.line_no, 
                                                               rel_no_             => pr2_rec_.rel_no, 
                                                               line_item_no_       => pr2_rec_.line_item_no, 
                                                               qty_to_be_reserved_ => qty_remaining_, 
                                                               shipment_id_        => 0,
                                                               set_shortage_       => FALSE );
               EXIT;
            ELSE
               -- Last parameter is set to FALSE becuase we do NOT want to set shortages at this point
               Reserve_Customer_Order_API.Reserve_Order_Line__(qty_reserved_       => qty_reserved_, 
                                                               order_no_           => pr2_rec_.order_no, 
                                                               line_no_            => pr2_rec_.line_no, 
                                                               rel_no_             => pr2_rec_.rel_no, 
                                                               line_item_no_       => pr2_rec_.line_item_no, 
                                                               qty_to_be_reserved_ => pr2_rec_.qty_rest,
                                                               shipment_id_        => 0,
                                                               set_shortage_       => FALSE );
            END IF;
            qty_remaining_ := NVL((qty_remaining_ - qty_reserved_),0);
            qty_needed_    := NVL((qty_needed_ - qty_reserved_),0);
         ELSE
            EXIT;
         END IF;
      END LOOP;
   END IF;

   -- Third priority goes to the priority defined in the customer order header
   IF (qty_remaining_ > 0) THEN
      FOR pr3_rec_ IN get_lines_pr3 LOOP
         IF (priority_ != pr3_rec_.priority) THEN
            priority_ := pr3_rec_.priority;
            qty_for_pr_ := pr3_rec_.tot_qty;
            IF (qty_remaining_ > qty_for_pr_) THEN
               FOR line_rec_ IN get_lines(priority_) LOOP
                  -- Last parameter is set to FALSE becuase we do NOT want to set shortages at this point
                  Reserve_Customer_Order_API.Reserve_Order_Line__(qty_reserved_       => qty_reserved_, 
                                                                  order_no_           => line_rec_.order_no, 
                                                                  line_no_            => line_rec_.line_no, 
                                                                  rel_no_             => line_rec_.rel_no, 
                                                                  line_item_no_       => line_rec_.line_item_no, 
                                                                  qty_to_be_reserved_ => line_rec_.qty_rest,
                                                                  shipment_id_        => 0,
                                                                  set_shortage_       => FALSE );
               END LOOP;
               qty_remaining_ := NVL((qty_remaining_ - qty_for_pr_),0);
            ELSE 
               base_qty_for_prop_scaling_ := qty_remaining_;
               -- Need to use propotional scaling
               FOR line_rec_ IN get_lines(priority_) LOOP
                  inv_uom_       := Inventory_Part_API.Get_Unit_Meas(Customer_Order_API.Get_Contract(line_rec_.order_no), part_no_);
                  unit_type_db_  := Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(inv_uom_));
                  IF (unit_type_db_ = 'DISCRETE') THEN
                     qty_to_res_ := ROUND((base_qty_for_prop_scaling_/qty_for_pr_)*line_rec_.qty_rest, 0);
                  ELSE
                     qty_to_res_ := ROUND((base_qty_for_prop_scaling_/qty_for_pr_)*line_rec_.qty_rest, 4);
                  END IF;
                  -- Last parameter is set to FALSE becuase we do NOT want to set shortages at this point
                  Reserve_Customer_Order_API.Reserve_Order_Line__(qty_reserved_       => qty_reserved_, 
                                                                  order_no_           => line_rec_.order_no, 
                                                                  line_no_            => line_rec_.line_no, 
                                                                  rel_no_             => line_rec_.rel_no, 
                                                                  line_item_no_       => line_rec_.line_item_no, 
                                                                  qty_to_be_reserved_ => qty_to_res_, 
                                                                  shipment_id_        => 0,
                                                                  set_shortage_       => FALSE );
                  qty_remaining_ := NVL((qty_remaining_ - qty_to_res_),0); 
               END LOOP;
            END IF;
         END IF;
      END LOOP;
   END IF;

   -- Still if we have some more to reserve ..i.e Priority undefined COs, or may be due to rounding factor
   -- reserve the remaining lines according to proportional scaling
   IF (qty_remaining_ > 0) THEN
      OPEN total_needed;
      FETCH total_needed INTO total_needed_qty_;
      CLOSE total_needed;

      OPEN get_lines_left;
      FETCH get_lines_left BULK COLLECT INTO bal_order_lines_;
      CLOSE get_lines_left;

      IF (bal_order_lines_.count > 0) THEN
         FOR i IN bal_order_lines_.FIRST .. bal_order_lines_.LAST LOOP
            inv_uom_       := Inventory_Part_API.Get_Unit_Meas(Customer_Order_API.Get_Contract(bal_order_lines_(i).order_no), part_no_);
            unit_type_db_  := Iso_Unit_Type_API.Encode(Iso_Unit_API.Get_Unit_Type(inv_uom_));
            IF (i != bal_order_lines_.LAST) THEN
               IF (unit_type_db_ = 'DISCRETE') THEN
                  qty_to_res_ := ROUND((qty_remaining_/total_needed_qty_)*bal_order_lines_(i).qty_rest, 0);
               ELSE
                  qty_to_res_ := ROUND((qty_remaining_/total_needed_qty_)*bal_order_lines_(i).qty_rest, 4);
               END IF;
               total_res_qty_ := NVL(total_res_qty_, 0) + qty_to_res_;
            ELSE
               qty_to_res_ := qty_remaining_ - NVL(total_res_qty_, 0);
            END IF;
            -- Last parameter is set to FALSE becuase we do NOT want to set shortages at this point
            Reserve_Customer_Order_API.Reserve_Order_Line__(qty_reserved_       => qty_reserved_,
                                                            order_no_           => bal_order_lines_(i).order_no,
                                                            line_no_            => bal_order_lines_(i).line_no,
                                                            rel_no_             => bal_order_lines_(i).rel_no,
                                                            line_item_no_       => bal_order_lines_(i).line_item_no,
                                                            qty_to_be_reserved_ => qty_to_res_,
                                                            shipment_id_        => 0,
                                                            set_shortage_       => FALSE );
         END LOOP;
      END IF;
   END IF;
END Reserve_Fair_Share___;   


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Process_Fair_Share_Orders__ (
   sequence_no_ IN NUMBER)
IS 
   result_           VARCHAR2(20);
   test_date_        DATE;
   dummy_date_       DATE;
   qty_possible_     NUMBER;
   qty_to_reserve_   NUMBER;
   owning_vendor_no_ VARCHAR2(10);
   part_ownership2_  VARCHAR2(200) := NULL;
   inv_part_rec_     Inventory_Part_API.Public_Rec;

   rest_to_reserve_  NUMBER := 0;
   qty_reserved_     NUMBER;
   qty_available_    NUMBER;

   CURSOR get_fair_share_orders IS
      SELECT order_no, run_date
        FROM FAIR_SHARE_RESERVATION_TAB
       WHERE sequence_no = sequence_no_;

   CURSOR get_lines(order_no_ IN VARCHAR2, run_date_ IN DATE) IS
      SELECT line_no, rel_no,line_item_no, contract, part_no, configuration_id, supply_code,
             (revised_qty_due - qty_assigned - qty_shipped) qty_rest, part_ownership,
             owning_customer_no, picking_leadtime, condition_code, ROWID objid
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_item_no >= 0
      AND    (revised_qty_due - qty_assigned - qty_shipped) > 0
      AND    rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND    supply_code IN ('IO', 'SO', 'PT', 'IPT','PS')
      AND    trunc(planned_due_date) <= trunc(run_date_) 
      ORDER BY trunc(planned_due_date), date_entered;

   CURSOR get_qty (part_no_ IN VARCHAR2) IS
      SELECT SUM(l.revised_qty_due - l.qty_assigned - l.qty_shipped) total_qty
      FROM   fair_share_reservation_tab r, customer_order_line_tab l
      WHERE  r.order_no = l.order_no
      AND    r.sequence_no = sequence_no_
      AND    l.part_no = part_no_
      AND    l.line_item_no >= 0
      AND    l.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered');

   TYPE line_list_tab IS TABLE OF VARCHAR2(4) INDEX BY BINARY_INTEGER;
   TYPE rel_list_tab  IS TABLE OF VARCHAR2(4) INDEX BY BINARY_INTEGER;
   TYPE item_list_tab IS TABLE OF NUMBER      INDEX BY BINARY_INTEGER;

   line_list_        line_list_tab;
   rel_list_         rel_list_tab;
   item_list_        item_list_tab;
   linerec_          Customer_Order_Line_API.Public_Rec;
   n_                NUMBER;
   max_              NUMBER;
   qty_short_        NUMBER;

BEGIN


   -- Retrieve all lines which would generate a backorder
   FOR fair_share_rec_ IN get_fair_share_orders LOOP
      test_date_  := trunc(Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(fair_share_rec_.order_no)));
      n_ := 0;
      FOR line_rec_ IN get_lines(fair_share_rec_.order_no, fair_share_rec_.run_date) LOOP
         IF (line_rec_.supply_code = 'IO') THEN
            -- Inventory Order
            inv_part_rec_ := Inventory_Part_API.Get(line_rec_.contract, line_rec_.part_no);
            IF ((inv_part_rec_.onhand_analysis_flag = 'Y') AND (inv_part_rec_.co_reserve_onh_analys_flag = 'Y')) THEN

               IF line_rec_.part_ownership = Part_Ownership_API.DB_SUPPLIER_LOANED THEN
                  owning_vendor_no_ := Customer_Order_Line_API.Get_Owner_For_Part_Ownership(fair_share_rec_.order_no,line_rec_.line_no,line_rec_.rel_no,line_rec_.line_item_no,line_rec_.part_ownership);
               END IF;
               Inventory_Part_In_Stock_API.Make_Onhand_Analysis(result_, qty_possible_, dummy_date_,
                                                                test_date_, test_date_, line_rec_.contract,
                                                                line_rec_.part_no, line_rec_.configuration_id,
                                                                'TRUE', 'FALSE', null, null, line_rec_.objid,
                                                                line_rec_.qty_rest, line_rec_.picking_leadtime, line_rec_.part_ownership,
                                                                owning_vendor_no_, line_rec_.owning_customer_no);

               IF (result_ != 'SUCCESS') THEN
                  Customer_Order_Shortage_API.New(fair_share_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no, 'PLANPICK01');
               ELSE
                  -- Create a shortage record event if analysis was a success. Will be removed if all lines are OK.
                  Customer_Order_Shortage_API.New(fair_share_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no, 'PLANPICK02');
               END IF;
            ELSE
               OPEN  get_qty (line_rec_.part_no);
               FETCH get_qty INTO rest_to_reserve_;
               IF get_qty%NOTFOUND THEN
                  rest_to_reserve_ := 0;
               END IF;
               CLOSE get_qty;
               IF (line_rec_.part_ownership = Part_Ownership_API.DB_COMPANY_OWNED) THEN
                  part_ownership2_ := Part_Ownership_API.DB_CONSIGNMENT;
               END IF;

               qty_available_ := Inventory_Part_In_Stock_API.Get_Inventory_Quantity(contract_               => line_rec_.contract,
                                                                                    part_no_                => line_rec_.part_no,
                                                                                    configuration_id_       => line_rec_.configuration_id,
                                                                                    qty_type_               => 'AVAILABLE',
                                                                                    ownership_type1_db_     => line_rec_.part_ownership,
                                                                                    ownership_type2_db_     => part_ownership2_,
                                                                                    owning_customer_no_     => line_rec_.owning_customer_no,
                                                                                    owning_vendor_no_       => owning_vendor_no_,
                                                                                    location_type1_db_      => 'PICKING',
                                                                                    location_type2_db_      => 'SHIPMENT',
                                                                                    include_standard_       => 'TRUE',
                                                                                    include_project_        => 'TRUE',
                                                                                    automat_reserv_ctrl_db_ => 'AUTO RESERVATION',
                                                                                    condition_code_         => line_rec_.condition_code);
               qty_to_reserve_ := (qty_available_- rest_to_reserve_);
               IF (qty_to_reserve_ < 0 ) THEN
                  Reserve_Fair_Share___(sequence_no_, line_rec_.part_no, qty_available_, rest_to_reserve_, fair_share_rec_.run_date);
                  -- Stored the fair share reserved lines for shortage handling later.
                  n_ := n_ + 1;
                  line_list_(n_)  := line_rec_.line_no;
                  rel_list_(n_)   := line_rec_.rel_no;
                  item_list_(n_)  := line_rec_.line_item_no;
               ELSE
                  Reserve_Customer_Order_API.Reserve_Order_Line__(qty_reserved_       => qty_reserved_,
                                                                  order_no_           => fair_share_rec_.order_no, 
                                                                  line_no_            => line_rec_.line_no, 
                                                                  rel_no_             => line_rec_.rel_no,
                                                                  line_item_no_       => line_rec_.line_item_no,
                                                                  qty_to_be_reserved_ => line_rec_.qty_rest,
                                                                  shipment_id_        => 0 );
               END IF;
            END IF;
         ELSE
            -- supply_code is Shop Order or Purch Order Transit
            IF (line_rec_.qty_rest > 0) THEN
               Customer_Order_Shortage_API.New(fair_share_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no, 'PLANPICK01');
            ELSE
            -- Create a shortage record even if parts are available. Will be removed if all lines are OK.
               Customer_Order_Shortage_API.New(fair_share_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no, 'PLANPICK02');
            END IF;
         END IF;
      END LOOP;
      -- Make shortage for the fair share order lines.
      max_ := n_;
      IF (max_ > 0) THEN
         FOR n_ IN 1..max_ LOOP
            linerec_ := Customer_Order_Line_API.Get(fair_share_rec_.order_no, line_list_(n_), rel_list_(n_), item_list_(n_));
            Customer_Order_Shortage_API.New(fair_share_rec_.order_no, line_list_(n_), rel_list_(n_), item_list_(n_), 'PLANPICK03');

            -- Calculate the qty short for Inventory shortage demand.
            qty_short_ := NVL(Shortage_Demand_API.Calculate_Order_Shortage_Qty(linerec_.contract,
                                                                               linerec_.part_no,
                                                                               linerec_.revised_qty_due,
                                                                               linerec_.qty_assigned,
                                                                               (linerec_.qty_shipped + linerec_.qty_on_order)), 0);
            Customer_Order_Line_API.Set_Qty_Short(fair_share_rec_.order_no, line_list_(n_), rel_list_(n_), item_list_(n_), qty_short_);
         END LOOP;
      END IF;
   END LOOP;
END Process_Fair_Share_Orders__;


@UncheckedAccess
FUNCTION Get_Next_Sequence_No__ RETURN NUMBER
IS
   sequence_no_     NUMBER;

   CURSOR get_next_sequence_no IS
      SELECT Fair_Share_Reservation_Seq.nextval
      FROM dual;
BEGIN
   OPEN get_next_sequence_no;
   FETCH get_next_sequence_no INTO sequence_no_;
   CLOSE get_next_sequence_no;
   RETURN(sequence_no_);
END Get_Next_Sequence_No__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   sequence_no_ IN NUMBER,
   order_no_ IN VARCHAR2,
   run_date_ IN DATE )
IS
   attr_ VARCHAR2(2000);
   newrec_                    FAIR_SHARE_RESERVATION_TAB%ROWTYPE;
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   indrec_                    Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('SEQUENCE_NO',  sequence_no_, attr_);
   Client_SYS.Add_To_Attr('ORDER_NO',     order_no_,    attr_);
   Client_SYS.Add_To_Attr('RUN_DATE',     run_date_,    attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___( objid_, objversion_, newrec_, attr_ ); 
END New;



