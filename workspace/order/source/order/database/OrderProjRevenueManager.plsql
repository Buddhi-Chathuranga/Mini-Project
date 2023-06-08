-----------------------------------------------------------------------------
--
--  Logical unit: OrderProjRevenueManager
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220125  KiSalk Bug 162116(PJZ-10252), Passed parameter refresh_proj_revenue_ to Customer_Order_Inv_Item_API.Create_Postings__ as TRUE in Get_Planned_Revenue_Elements.
--  180802  WaSalk Bug 141843, Modified Simulate_Invoice___() by adding a parametter to Customer_Order_Inv_Head_API.Create_Invoice_Head().
--  171220  ChBnlk Bug 139282, Modified Simulate_Invoice___() by adding a check to the cursor get_qty_to_invoice to allow negative quantities 
--  171220         when the supply code is 'SEO'.
--  160212  KiSalk Bug 122942, Modified where clause of cursor get_qty_to_invoice in Simulate_Invoice___ to consider invoiced blocked Co lines in planned revenue calculation.
--  141107  NaSalk Modified parameter list of Get_Planned_Revenue_Elements.
--  141017  NaSalk Modified Get_Planned_Revenue_Elements to support intra company rental planned revenue reporting.
--  140925  JeeJlk Modified Simulate_Invoice___ in order to pass all the parameters correctly in all the method calls to Customer_Order_Inv_Head_API.Create_Invoice_Head.
--  140925  Vwloza Updated cursor get_qty_to_invoice in Simulate_Invoice___ to exclude replacement COs.
--  140317  NaSalk Modified Simulate_Invoice___ to consider chargeable days for rental lines.
--  130712  ErFelk Bug 111147, Added ignore return annotation in methods Get_Prel_Revenue_Elements() and Get_Planned_Revenue_Elements().
--  120321  RoJalk Added the parameter refresh_old_data to the methods Get_Planned_Revenue_Elements, Simulate_Invoice___
--  120321         to allow cost refresh for Invoiced Customer Order lines .
--  120312  RoJalk Added the method call Customer_Order_API.Calculate_Order_Discount__  to Get_Planned_Revenue_Elements.  
--  120217  RoJalk Modified Get_Prel_Revenue_Elements, Get_Planned_Revenue_Elements and added exception handling.
--  101129  THTHLK HIGHPK-3348, Modified Fill_Proj_Revenue_Element_Tmp, corrected General_SYS.Init_Method function name parameter.
--  100714  ChFolk Modified Get_Planned_Revenue_Elements to remove method call for bonus calculation as bonus functionality is obsoleted.
--  091103  RoJalk Added method Get_Base_Revenue_Amount___ and used it from Generate_Revenue_Element to convert the invoice amount in 
--  091103         base currency for planned and preliminary revenue.Added parameter item_id_ to Generate_Revenue_Element.
--  091028  KaEllk Passed parameter revenue_simulation_ to Create_Postings__. 
--  091007  RoJalk Modified Clear_Temporary_Table to be a implementation method and called from
--  091007         Get_Prel_Revenue_Elements and Get_Planned_Revenue_Elements.  
--  090929  RoJalk Replaced the method call Invoice_Customer_Order_API.Create_Invoice_Line__ with
--  090929         Invoice_Customer_Order_API.Create_Invoice_Item__ in Simulate_Invoice___.
--  090928  RoJalk Changed the parameter list to the method call Customer_Order_Inv_Item_API.Create_Postings__.
--  090918  RoJalk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Project_Revenue_Element_Rec IS RECORD (
      project_revenue_element   VARCHAR2(100),
      amount                    NUMBER );
TYPE Project_Revenue_Element_Tab IS TABLE OF Project_Revenue_Element_Rec
   INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Fill_Temporary_Table___
--   Fills temporary table project_revenue_element_tmp with data recevied from
--   PLSQL tables of type Project_Revenue_Element_Tab.
PROCEDURE Fill_Temporary_Table___ (
   project_revenue_element_tab_  IN Project_Revenue_Element_Tab )
IS
   record_   project_revenue_element_tmp%ROWTYPE;
BEGIN

   IF (project_revenue_element_tab_.COUNT > 0) THEN

      FOR i IN project_revenue_element_tab_.FIRST..project_revenue_element_tab_.LAST LOOP

         IF (NVL(project_revenue_element_tab_(i).amount, 0) != 0) THEN

            record_.project_revenue_element := project_revenue_element_tab_(i).project_revenue_element;
            record_.amount                  := NVL(project_revenue_element_tab_(i).amount, 0);
                
            INSERT INTO project_revenue_element_tmp
               (project_revenue_element,
                amount)
            VALUES
               (record_.project_revenue_element,
                NVL(record_.amount, 0));

         END IF;

      END LOOP;

   END IF;
END Fill_Temporary_Table___;


-- Get_Prj_Revenue_Element_Tab___
--   Fills PLSQL table project_revenue_element_tab_ with the data selected from
--   temporary table project_revenue_element_tmp.
FUNCTION Get_Prj_Revenue_Element_Tab___ RETURN Project_Revenue_Element_Tab
IS
   project_revenue_element_tab_   Project_Revenue_Element_Tab;

   CURSOR get_proj_revenue_elements IS
      SELECT project_revenue_element,
      SUM (amount) amount
      FROM project_revenue_element_tmp
      GROUP BY project_revenue_element;
BEGIN

   OPEN  get_proj_revenue_elements;
   FETCH get_proj_revenue_elements BULK COLLECT INTO project_revenue_element_tab_;
   CLOSE get_proj_revenue_elements;
   
   RETURN project_revenue_element_tab_;

END Get_Prj_Revenue_Element_Tab___;


-- Simulate_Invoice___
--   Simulate the invoice header and lines for the given order reference.
PROCEDURE Simulate_Invoice___ (
   invoice_id_       OUT NUMBER,
   company_          OUT VARCHAR2, 
   order_no_         IN  VARCHAR2,
   line_no_          IN  VARCHAR2,
   rel_no_           IN  VARCHAR2,
   line_item_no_     IN  NUMBER,
   refresh_old_data_ IN  VARCHAR2  )
IS
   cust_po_no_          VARCHAR2(50);
   item_id_             NUMBER;
   qty_invoiced_        NUMBER;
   
   CURSOR head_data IS
      SELECT order_no, customer_no, currency_code, authorize_code, date_entered,
             bill_addr_no, customer_no_pay, customer_no_pay_addr_no,
             internal_po_no, NVL(internal_ref, cust_ref) cust_ref, delivery_terms, del_terms_location,
             forward_agent_id, pay_term_id, ship_via_code,
             ship_addr_no, NVL(internal_po_label_note, label_note) label_note, note_id,
             contract, wanted_delivery_date, customer_po_no, currency_rate_type, language_code, 
             use_price_incl_tax, rowstate
      FROM   customer_order_tab
      WHERE  order_no = order_no_;
   
   invoice_component_   head_data%ROWTYPE;
   
   -- if using cost refresh functionality from project include Invoiced CO lines
   -- Replacement customer orders are excluded.
   CURSOR get_qty_to_invoice IS
      SELECT buy_qty_due, rental
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    ((buy_qty_due > 0) OR (supply_code = 'SEO' AND buy_qty_due < 0))
      AND    (((refresh_old_data_ = 'FALSE') AND rowstate NOT IN ('Invoiced', 'Cancelled')) 
             OR ((refresh_old_data_ = 'TRUE') AND (rowstate != 'Cancelled')))
      AND    demand_code != Order_Supply_Type_API.DB_REPLACEMENT_CUSTOMER_ORDER;

   CURSOR get_charge_to_invoice IS
      SELECT coc.contract, coc.sequence_no, coc.line_no, coc.rel_no, coc.line_item_no,
             coc.charge_type, coc.charged_qty
      FROM   customer_order_charge_tab coc
      WHERE  coc.line_no IS NULL     -- not connected to an order_line
      AND    coc.collect = 'INVOICE' -- only invoice charges, no collect charges
      AND    coc.order_no = order_no_
   UNION
      SELECT coc.contract, coc.sequence_no, coc.line_no, coc.rel_no, coc.line_item_no,
             coc.charge_type, coc.charged_qty
      FROM   customer_order_charge_tab coc,
             customer_order_inv_item coii
      WHERE  coii.invoice_id = invoice_id_
      AND    coc.collect = 'INVOICE'             -- only invoice charges, no collect charges
      AND    coc.line_item_no = coii.line_item_no
      AND    coc.rel_no  = coii.release_no
      AND    coc.line_no = coii.line_no
      AND    coc.order_no = coii.order_no
      AND    coc.order_no = order_no_;

BEGIN
   
   OPEN head_data;
   FETCH head_data INTO invoice_component_;
   IF head_data%NOTFOUND THEN
      CLOSE head_data;
      Error_SYS.Record_General(lu_name_, 'NO_INV_HEAD_DATA: Could not find order data when creating invoice.');
   ELSE
      CLOSE head_data;
      
      company_ := Site_API.Get_Company(invoice_component_.contract);
      -- create invoice header
      Customer_Order_Inv_Head_API.Create_Invoice_Head(
         invoice_id_,
         company_,
         invoice_component_.order_no,
         invoice_component_.customer_no,
         invoice_component_.customer_no_pay,
         Order_Coordinator_API.Get_Name(invoice_component_.authorize_code),
         invoice_component_.date_entered,
         invoice_component_.cust_ref,
         Mpccom_Ship_Via_API.Get_Description(invoice_component_.ship_via_code, invoice_component_.language_code),
         invoice_component_.forward_agent_id,
         invoice_component_.label_note,
         Order_Delivery_Term_API.Get_Description(invoice_component_.delivery_terms, invoice_component_.language_code),
         invoice_component_.del_terms_location,
         invoice_component_.pay_term_id,
         invoice_component_.currency_code,
         invoice_component_.ship_addr_no,
         invoice_component_.customer_no_pay_addr_no,
         invoice_component_.bill_addr_no,
         invoice_component_.wanted_delivery_date,
         'CUSTORDDEB',
         NULL, -- number_reference
         NULL, -- series_reference
         invoice_component_.contract,
         NULL, -- js_invoice_state
         invoice_component_.currency_rate_type,
         'FALSE', --collect
         NULL, --rma_no_
         NULL, --shipment_id_
         NULL, --adv_invoice_
         NULL, --adv_pay_base_date_
         NULL, --sb_reference_no_
         'FALSE', --use_ref_inv_curr_rate_
         NULL, --ledger_item_id_
         NULL, --ledger_item_series_id_
         NULL, --ledger_item_version_id_
         NULL, --aggregation_no_
         'FALSE', --final_settlement_
         NULL, --project_id_
         NULL, --tax_id_number_
         NULL, --tax_id_type_
         NULL, --branch_
         NULL, --supply_country_db_
         NULL, --invoice_date_
         invoice_component_.use_price_incl_tax, --use_price_incl_tax_db_
         NULL, --wht_amount_base_
         NULL, --curr_rate_new_
         NULL, --tax_curr_rate_new_
         NULL, --Correction_reason_id_
         NULL, --correction_reason_
        'TRUE') ;--is_simulated_ 
         

         IF (invoice_component_.internal_po_no IS NOT NULL ) THEN
            cust_po_no_ := invoice_component_.internal_po_no;
         ELSE
            cust_po_no_ := invoice_component_.customer_po_no;
         END IF;

         FOR qty_to_invoice_rec_ IN get_qty_to_invoice LOOP
            -- create invoice part lines
            IF (qty_to_invoice_rec_.rental = Fnd_Boolean_API.DB_FALSE) THEN 
               qty_invoiced_ := qty_to_invoice_rec_.buy_qty_due;
            ELSE
               qty_invoiced_ := qty_to_invoice_rec_.buy_qty_due * Customer_Order_Line_API.Get_Rental_Chargeable_Days(order_no_, 
                                                                                                                     line_no_, 
                                                                                                                     rel_no_,      
                                                                                                                     line_item_no_);
            END IF;
            
            Invoice_Customer_Order_API.Create_Invoice_Item__(
               item_id_,
               invoice_id_,
               order_no_,
               line_no_,
               rel_no_,
               line_item_no_,
               qty_invoiced_,
               cust_po_no_,
               NULL,
               NULL,
               TRUE,
               TRUE );

         END LOOP;
        
         FOR charge_rec_ IN get_charge_to_invoice LOOP
            -- create invoice charge lines.
            Invoice_Customer_Order_API.Create_Invoice_Charge_Line(
               order_no_,
               charge_rec_.line_no,
               charge_rec_.rel_no,
               charge_rec_.line_item_no,
               invoice_id_,
               cust_po_no_,
               charge_rec_.sequence_no,
               charge_rec_.charged_qty,
               TRUE);
         END LOOP;

   END IF;
   
END Simulate_Invoice___;


-- Clear_Temporary_Table___
--   delete all the records from the temporary table project_revenue_element_tmp
PROCEDURE Clear_Temporary_Table___
IS
BEGIN
   DELETE FROM project_revenue_element_tmp;
END Clear_Temporary_Table___;


-- Get_Base_Revenue_Amount___
--   Returns revenue_amount_ in base currency.
FUNCTION Get_Base_Revenue_Amount___ (
   company_          IN VARCHAR2,
   invoice_id_       IN NUMBER,
   item_id_          IN NUMBER,
   revenue_amount_   IN NUMBER ) RETURN NUMBER
IS
   currency_code_                 VARCHAR2(3);
   rounding_                      NUMBER;
   order_rec_                     Customer_Order_API.Public_Rec;
   order_line_rec_                Customer_Order_Line_API.Public_Rec;
   customer_order_inv_item_rec_   Customer_Order_Inv_Item_API.Public_Rec;
   base_revenue_amount_           NUMBER:=0;
   curr_rate_                     NUMBER:=0;
BEGIN
   customer_order_inv_item_rec_ := Customer_Order_Inv_Item_API.Get(company_, invoice_id_, item_id_); 
   order_rec_                   := Customer_Order_API.Get(customer_order_inv_item_rec_.order_no);
   currency_code_               := Company_Finance_API.Get_Currency_Code(company_);
   rounding_                    := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   
   Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_revenue_amount_, curr_rate_, order_rec_.customer_no, customer_order_inv_item_rec_.contract, 
                                                         order_rec_.currency_code, revenue_amount_, order_rec_.currency_rate_type);

   base_revenue_amount_ := ROUND(base_revenue_amount_, rounding_);

   RETURN base_revenue_amount_;
   
END Get_Base_Revenue_Amount___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Fill_Proj_Revenue_Element_Tmp
--   Fills the temporary table project_revenue_element_tmp from the PLSQL table
--   of type Project_Revenue_Element_Tab
PROCEDURE Fill_Proj_Revenue_Element_Tmp (
   project_revenue_element_tab_  IN Project_Revenue_Element_Tab )
IS
BEGIN

   Clear_Temporary_Table___;
   Fill_Temporary_Table___(project_revenue_element_tab_ );
   
END Fill_Proj_Revenue_Element_Tmp;


-- Generate_Revenue_Element
--   Fetch the revenue element mapped for the code part, reverse the accounting
--   value and fill the temporary table project_revenue_element_tmp.
PROCEDURE Generate_Revenue_Element (
   invoice_id_       IN   NUMBER,
   codestr_rec_      IN   Accounting_Codestr_API.CodestrRec,
   account_value_    IN   NUMBER,
   company_          IN   VARCHAR2,
   posting_type_     IN   VARCHAR2,
   item_id_          IN   NUMBER )
IS
   project_revenue_element_tab_   Project_Revenue_Element_Tab;
   index_                         NUMBER:=1;
   base_revenue_amount_           NUMBER:=0;
BEGIN
   -- Get the invoice amount in base currency
   base_revenue_amount_                                         := Get_Base_Revenue_Amount___ (company_, invoice_id_, item_id_, account_value_);
   -- reverse the sign for revenue
   project_revenue_element_tab_(index_).amount                  := base_revenue_amount_ * - 1;

   -- get the revenue element
   project_revenue_element_tab_(index_).project_revenue_element := Cost_Element_To_Account_API.Get_Project_Follow_Up_Element(
                                                                     company_,
                                                                     codestr_rec_,
                                                                     Customer_Order_Inv_Head_API.Get_Invoice_Date(company_, invoice_id_),
                                                                     'TRUE',
                                                                     posting_type_,
                                                                     default_element_type_ => 'BOTH');
   -- fill temp table with retrieved revenue element and revenue value
   Fill_Temporary_Table___(project_revenue_element_tab_);

END Generate_Revenue_Element;


-- Get_Prel_Revenue_Elements
--   Generates the preliminary revenue by a posting simulation and return in a
--   PLSQL structure of type Project_Revenue_Element_Tab.
FUNCTION Get_Prel_Revenue_Elements (
   invoice_id_       IN   NUMBER,
   company_          IN   VARCHAR2,
   item_id_          IN   NUMBER ) RETURN Project_Revenue_Element_Tab
IS
   project_revenue_element_tab_   Project_Revenue_Element_Tab;
   
BEGIN

   Clear_Temporary_Table___;

   BEGIN
      @ApproveTransactionStatement(2013-11-28,MeAblk)
      SAVEPOINT before_create_postings;

      -- simulate the posting creation and insert the revenue elements and revenue values in to the temp table
      Customer_Order_Inv_Item_API.Create_Postings__(company_, invoice_id_, item_id_, TRUE);
   
      -- retrieve the values from the temp table.
      project_revenue_element_tab_ := Get_Prj_Revenue_Element_Tab___();

      @ApproveTransactionStatement(2013-11-28,MeAblk)
      ROLLBACK TO SAVEPOINT before_create_postings;

   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-28,MeAblk)
         ROLLBACK TO SAVEPOINT before_create_postings;
         RAISE;
   END;

   RETURN project_revenue_element_tab_;

END Get_Prel_Revenue_Elements;


-- Get_Planned_Revenue_Elements
--   Generates the planned revenue by a invoice and posting simulation and return
--   in a PLSQL structure of type Project_Revenue_Element_Tab.
FUNCTION Get_Planned_Revenue_Elements (
   cust_order_line_rec_ IN customer_order_line_tab%ROWTYPE,
   refresh_old_data_    IN VARCHAR2 ) RETURN Project_Revenue_Element_Tab
IS
   project_revenue_element_tab_   Project_Revenue_Element_Tab;
   invoice_id_                    NUMBER;
   company_                       VARCHAR2(20);
   intra_co_rental_               BOOLEAN := FALSE;
      
   CURSOR get_invoice_item_id IS
      SELECT item_id
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company  = company_
      AND invoice_id = invoice_id_;
BEGIN
   Clear_Temporary_Table___;
   company_ := Site_API.Get_Company(Customer_Order_API.Get_Contract(cust_order_line_rec_.order_no));
   -- For inter site intra company rental flow, revenue elements are based on rental transactions and mpccom accounting postings.                                            
   IF (cust_order_line_rec_.rental = Fnd_Boolean_API.DB_TRUE AND 
       NVL(cust_order_line_rec_.demand_code, Database_SYS.string_null_) = Order_Supply_Type_API.DB_INT_PURCH_TRANS) THEN 
      IF Site_API.Get_Company(cust_order_line_rec_.contract) =  Site_API.Get_Company(Cust_Ord_Customer_API.Get_Acquisition_Site(cust_order_line_rec_.customer_no)) THEN 
         intra_co_rental_ := TRUE;
      END IF;   
   END IF;   
   BEGIN
      @ApproveTransactionStatement(2013-11-28,MeAblk)
      SAVEPOINT before_create_invoice_postings;

      Customer_Order_API.Calculate_Order_Discount__(cust_order_line_rec_.order_no, 
                                                    cust_order_line_rec_.line_no, 
                                                    cust_order_line_rec_.rel_no, 
                                                    cust_order_line_rec_.line_item_no); 
      IF (NOT intra_co_rental_) THEN 
         -- create the invoice header, part lines and charge lines
         Simulate_Invoice___(invoice_id_, 
                             company_, 
                             cust_order_line_rec_.order_no, 
                             cust_order_line_rec_.line_no, 
                             cust_order_line_rec_.rel_no, 
                             cust_order_line_rec_.line_item_no, 
                             refresh_old_data_);

         FOR invoice_item_id_rec_ IN get_invoice_item_id LOOP

            -- simulate the posting creation and insert the revenue elements and revenue values in to the temp table
            Customer_Order_Inv_Item_API.Create_Postings__(company_, invoice_id_, invoice_item_id_rec_.item_id, TRUE, TRUE);

         END LOOP;
      ELSE
         $IF Component_Rental_SYS.INSTALLED $THEN 
            Rental_Transaction_Manager_API.Simulate_Co_Intra_Comp_Trans(cust_order_line_rec_.order_no, 
                                                                        cust_order_line_rec_.line_no, 
                                                                        cust_order_line_rec_.rel_no, 
                                                                        cust_order_line_rec_.line_item_no);
         $ELSE
            NULL;
         $END
      END IF;  
      -- retrieve the values from the temp table.
      project_revenue_element_tab_ := Get_Prj_Revenue_Element_Tab___();

      @ApproveTransactionStatement(2013-11-28,MeAblk)
      ROLLBACK TO SAVEPOINT before_create_invoice_postings;
   
   EXCEPTION
      WHEN OTHERS THEN
         @ApproveTransactionStatement(2013-11-28,MeAblk)
         ROLLBACK TO SAVEPOINT before_create_invoice_postings;
         RAISE;
   END;

   RETURN project_revenue_element_tab_;

END Get_Planned_Revenue_Elements;



