-----------------------------------------------------------------------------
--
--  Logical unit: PublicDeclarations
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210429  WaSalk  SC21R2-1004, Added PARTCA_Serial_No_Rec and PARTCA_Serial_No_Tab.
--  201123  Cpeilk  SC2020R1-11489, Added PURCH_invoice_postings_rec, PURCH_invoice_postings_table, PURCH_charge_info_rec, PURCH_charge_inv_info_rec
--  201123          PURCH_order_info_rec, PURCH_order_invoice_info_rec, PURCH_exchange_info_rec, PURCH_exchange_inv_info_rec,
--  201123          PURCH_received_po_lines_rec and PURCH_received_po_lines_table to get rid of dependency in the package specification.
--  201119  TRATLK  PJ2020R1-4852, Added types PROJ_Project_Unfinish_Act_Type, PROJ_Project_Unfinish_Work_Type and PROJ_Project_Cost_Element_Type
--  190819  JANSLK  Bug 149564 (PJZ-2515), Added types PROJ_Project_Conn_Cost_Tab and PROJ_Project_Conn_Revenue_Tab.
--  190528  DISKLK  Add public types, usable anywhere, starting with PROJ.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-- MDAHSE, 2019-05-28: This problem might get another solution later, but for now,
-- we will keep these types here in APPSRV.

TYPE PROJ_Project_Conn_Cost_Type IS RECORD
   (control_category              VARCHAR2(100),
    estimated                     NUMBER,
    planned                       NUMBER,
    planned_committed_status      VARCHAR2(20),
    planned_committed             NUMBER,
    committed                     NUMBER,
    used                          NUMBER,
    actual                        NUMBER,
    estimated_hours               NUMBER,
    planned_hours                 NUMBER,
    planned_committed_hours       NUMBER,
    committed_hours               NUMBER,
    actual_hours                  NUMBER,
    progress_cost                 NUMBER,
    progress_hours                NUMBER,
    earned_value_cost             NUMBER,
    earned_value_hours            NUMBER,
    estimated_transaction         NUMBER,
    planned_transaction           NUMBER,
    planned_committed_transaction NUMBER,
    committed_transaction         NUMBER,
    used_transaction              NUMBER,
    actual_transaction            NUMBER,
    transaction_currency_code     VARCHAR2(3),
    account                       VARCHAR2(20),
    code_b                        VARCHAR2(20),
    code_c                        VARCHAR2(20),
    code_d                        VARCHAR2(20),
    code_e                        VARCHAR2(20),
    code_f                        VARCHAR2(20),
    code_g                        VARCHAR2(20),
    code_h                        VARCHAR2(20),
    code_i                        VARCHAR2(20),
    code_j                        VARCHAR2(20));


TYPE PROJ_Project_Conn_Revenue_Type IS RECORD
   (control_category          VARCHAR2(100),
    estimated_revenue         NUMBER,
    planned_revenue           NUMBER,
    preliminary_revenue       NUMBER,
    posted_revenue            NUMBER,
    actual_revenue            NUMBER,
    transaction_currency_code VARCHAR2(3),
    estimated_transaction     NUMBER,
    planned_transaction       NUMBER,
    preliminary_transaction   NUMBER,
    posted_transaction        NUMBER,
    actual_transaction        NUMBER);


TYPE PROJ_Project_Conn_Attr_Type IS RECORD 
   (pre_accounting_id             NUMBER,
    actual_revenue                NUMBER,
    codestring                    VARCHAR2(250),
    object_cost_progress          NUMBER,    
    process_type                  VARCHAR2(100),
    refresh_old_data              VARCHAR2(5),
    object_hours_progress         NUMBER,   
    include_in_ev                 VARCHAR2(10),
    report_earned_value           VARCHAR2(10),
    last_transaction_date         DATE,
    transfer_to_finance           BOOLEAN,
    transfer_to_finance_date      DATE,
    skip_budget_check             VARCHAR2(5),
    last_transaction_date_updated BOOLEAN);


TYPE PROJ_Project_Unfinish_Act_Type IS RECORD
   (activity_seq   NUMBER,
    activity_no    VARCHAR2(100),
    sub_project_id VARCHAR2(100));


-- Columns are identical to Project_Unfinish_Work_TAB columns. Any modification of that table should reflect here as well.
TYPE PROJ_Project_Unfinish_Work_Type IS RECORD
   (connection_sequence NUMBER,
    activity_seq        VARCHAR2(10),
    keyref1             VARCHAR2(25),
    keyref2             VARCHAR2(25),
    keyref3             VARCHAR2(25),
    keyref4             VARCHAR2(25),
    keyref5             VARCHAR2(25),
    keyref6             VARCHAR2(25),
    proj_lu_name        VARCHAR2(20),
    project_id          VARCHAR2(100),
    sub_project_id      VARCHAR2(100),
    description         VARCHAR2(2000),
    date_generated      DATE,
    created_by          VARCHAR2(30),
    rowversion          DATE,
    rowkey              VARCHAR2(50));


TYPE PROJ_Project_Cost_Element_Type IS RECORD (
   project_cost_element    VARCHAR2(100),
   amount                  NUMBER,
   currency_amount         NUMBER,
   hours                   NUMBER);


TYPE PROJ_Project_Conn_Cost_Tab IS TABLE OF PROJ_Project_Conn_Cost_Type
INDEX BY BINARY_INTEGER;

TYPE PROJ_Project_Conn_Revenue_Tab IS TABLE OF PROJ_Project_Conn_Revenue_Type
INDEX BY BINARY_INTEGER;

TYPE PROJ_Project_Unfinish_Act_Tab_Type IS TABLE OF PROJ_Project_Unfinish_Act_Type
INDEX BY BINARY_INTEGER;

-- Used the Project_Unfinish_Work_Type instead of Project_Unfinish_Work_TAB%ROWTYPE since it sometimes give ORA-21700 error.
TYPE PROJ_Project_Unfinish_Work_Tab_Type IS TABLE OF PROJ_Project_Unfinish_Work_Type
INDEX BY BINARY_INTEGER;

TYPE PROJ_Project_Cost_Element_Tab IS TABLE OF PROJ_Project_Cost_Element_Type
INDEX BY PLS_INTEGER;


   
TYPE PURCH_invoice_postings_rec IS RECORD (
   company                       VARCHAR2(20),
   posting_type                  VARCHAR2(10),
   code_a                        VARCHAR2(20),
   code_b                        VARCHAR2(20),
   code_c                        VARCHAR2(20),
   code_d                        VARCHAR2(20),
   code_e                        VARCHAR2(20),
   code_f                        VARCHAR2(20),
   code_g                        VARCHAR2(20),
   code_h                        VARCHAR2(20),
   code_i                        VARCHAR2(20),
   code_j                        VARCHAR2(20),
   activity_seq                  NUMBER,
   debit_acc_curr                NUMBER NOT NULL := 0,
   credit_acc_curr               NUMBER NOT NULL := 0,
   debit_invoice_curr            NUMBER NOT NULL := 0,
   credit_invoice_curr           NUMBER NOT NULL := 0,
   debit_par_curr                NUMBER := NULL,
   credit_par_curr               NUMBER := NULL,
   quantity                      NUMBER,
   process_code                  VARCHAR2(10),
   text                          VARCHAR2(4000),
   qty_per_price_uom             NUMBER,
   parallel_curr_rate            NUMBER,
   parallel_conv_factor          NUMBER,
   matched_net_amount            NUMBER,
   matched_non_deduct_tax_amount NUMBER,
   trans_currency_code           VARCHAR2(3),
   trans_currency_rate           NUMBER,   
   trans_div_factor              NUMBER,
   invoic_currency_rate          NUMBER,   
   invoic_div_factor             NUMBER,
   price_difference              VARCHAR2(5) := 'FALSE',
   vou_comp_trans_curr_rate      NUMBER,
   vou_comp_amounts              VARCHAR2(800),
   spend_db                      VARCHAR2(5) := 'FALSE');

TYPE PURCH_invoice_postings_table IS TABLE OF PURCH_invoice_postings_rec INDEX BY BINARY_INTEGER;

TYPE PURCH_charge_info_rec IS RECORD (
   order_no                      VARCHAR2(12),
   line_no                       VARCHAR2(4),
   release_no                    VARCHAR2(4),
   receipt_no                    NUMBER NOT NULL := 1,
   series_id                     VARCHAR2(20),
   invoice_no                    VARCHAR2(50),
   company                       VARCHAR2(20),
   price_adjustment              BOOLEAN NOT NULL := FALSE,
   quantity                      NUMBER NOT NULL := 0,
   unit_price                    NUMBER NOT NULL := 0,
   unit_price_diff               NUMBER NOT NULL := 0,
   price                         NUMBER NOT NULL := 0,
   invoice_curr_code             VARCHAR2(3),
   invoice_curr_rate             NUMBER NOT NULL := 0,
   curr_conv_factor              NUMBER NOT NULL := 0,
   sequence_no                   NUMBER,
   charge_type                   VARCHAR2(35),
   charge_description            VARCHAR2(35),
   price_unit_meas               VARCHAR2(30),
   fee_code                      VARCHAR2(20),
   unit_charge                   VARCHAR2(20),
   distribute_charge_by          VARCHAR2(20),
   voucher_date                  DATE,
   non_deduct_tax_amt            NUMBER,
   matched_net_amount            NUMBER,
   matched_non_deduct_tax_amount NUMBER,
   base_curr_rate                NUMBER NOT NULL := 0,
   base_conv_factor              NUMBER NOT NULL := 0);
   
TYPE PURCH_charge_inv_info_rec IS RECORD (
   postings                  PURCH_invoice_postings_table,
   charge_info               PURCH_charge_info_rec);
   
TYPE PURCH_order_info_rec IS RECORD (
   order_no                VARCHAR2(12),
   line_no                 VARCHAR2(4),
   release_no              VARCHAR2(4),
   receipt_no              NUMBER NOT NULL := 1,
   series_id               VARCHAR2(20),
   invoice_no              VARCHAR2(50),
   company                 VARCHAR2(20),
   price_adjustment        BOOLEAN NOT NULL := FALSE,
   quantity                NUMBER NOT NULL := 0,
   discount                NUMBER NOT NULL := 0,
   invoice_curr_code       VARCHAR2(3),
   curr_rate               NUMBER NOT NULL := 0,
   curr_conv_factor        NUMBER NOT NULL := 0,
   part_no                 VARCHAR2(25),
   description             VARCHAR2(2000),
   unit_meas               VARCHAR2(30),
   price                   NUMBER NOT NULL := 0,
   price_qty               NUMBER NOT NULL := 0,
   price_unit_meas         VARCHAR2(30),
   unit_price              NUMBER NOT NULL := 0,
   unit_price_diff         NUMBER NOT NULL := 0,
   additional_cost_amount  NUMBER,
   update_purchase_price   VARCHAR2(200),
   fee_code                VARCHAR2(20),
   advice_id               NUMBER,
   voucher_date            DATE,
   non_deduct_tax_amt      NUMBER,
   base_curr_rate          NUMBER NOT NULL := 0,
   base_conv_factor        NUMBER NOT NULL := 0);
   
TYPE PURCH_order_invoice_info_rec IS RECORD (
   postings                  PURCH_invoice_postings_table,
   order_info                PURCH_order_info_rec);
   
TYPE PURCH_exchange_info_rec IS RECORD (
   order_no              VARCHAR2(12),
   line_no               VARCHAR2(4),
   release_no            VARCHAR2(4),
   receipt_no            NUMBER NOT NULL := 1,
   invoice_no            VARCHAR2(50),
   company               VARCHAR2(20),
   price_adjustment      BOOLEAN NOT NULL := FALSE,
   quantity              NUMBER NOT NULL := 0,
   unit_price            NUMBER NOT NULL := 0,
   unit_price_diff       NUMBER NOT NULL := 0,
   price                 NUMBER NOT NULL := 0,
   invoice_curr_code     VARCHAR2(3),
   invoice_curr_rate     NUMBER NOT NULL := 0,
   curr_conv_factor      NUMBER NOT NULL := 0,
   price_unit_meas       VARCHAR2(30),
   series_id             VARCHAR2(20),
   part_no               VARCHAR2(25),
   core_deposit          VARCHAR2(25),
   update_exchange_price VARCHAR2(200),
   base_curr_rate        NUMBER NOT NULL := 0,
   base_conv_factor      NUMBER NOT NULL := 0);
   
TYPE PURCH_exchange_inv_info_rec IS RECORD (
   postings        PURCH_invoice_postings_table,
   exchange_info   PURCH_exchange_info_rec);
   
TYPE PURCH_received_po_lines_rec IS RECORD
   (order_no                  VARCHAR2(12),
    line_no                   VARCHAR2(4),
    release_no                VARCHAR2(4),
    receipt_no                NUMBER,
    sequence_no               NUMBER,
    part_no                   VARCHAR2(35),             
    part_no_desc              VARCHAR2(2000),
    vendor_part_no            VARCHAR2(80),             
    vendor_part_description   VARCHAR2(200),
    requisitioner             VARCHAR2(60),
    qty_in_buy                NUMBER,
    price_conv_factor         NUMBER,
    fbuy_unit_price           NUMBER,                      
    discount                  NUMBER,
    additional_cost_amount    NUMBER,  
    buy_unit_meas             VARCHAR2(10),  
    price_unit_meas           VARCHAR2(10),  
    wo_no                     VARCHAR2(12),
    task_seq                  NUMBER,
    receipt_reference         VARCHAR2(50),
    arrival_date              DATE,
    matching_result           VARCHAR2(2000),
    core_deposit              VARCHAR2(20),
    project_transaction_seq   NUMBER,
    invoicing_advice_id       VARCHAR2(15));    
    
TYPE PARTCA_Serial_No_Rec IS RECORD (
   serial_no      VARCHAR2(50));

TYPE PARTCA_Serial_No_Tab IS TABLE OF PARTCA_Serial_No_Rec INDEX BY PLS_INTEGER;
    
TYPE PURCH_received_po_lines_table IS TABLE OF PURCH_received_po_lines_rec INDEX BY BINARY_INTEGER;


TYPE CSHPLN_Cash_Plan_Parameter_Rec IS RECORD ( 
   cash_plan_id                    VARCHAR2(30),
   snapshot_id                     VARCHAR2(30),
   company                         VARCHAR2(20),
   order_date                      DATE,
   until_date                      DATE,
   source_Id                       VARCHAR2(30),
   sub_source_id                   VARCHAR2(30),
   sub_source_status_info          CSHPLN_Probability_Tab,
   inv_proportions_exists          BOOLEAN,
   cash_plan_function             VARCHAR2(30),
   cash_flow_in_out               VARCHAR2(20),
   counterpart_type               VARCHAR2(20));
   
TYPE CSHPLN_Probability_Rec IS RECORD
(  cash_probability            NUMBER);
   
TYPE CSHPLN_Probability_Tab IS TABLE OF CSHPLN_Probability_Rec INDEX BY VARCHAR2(200);

TYPE CSHPLN_Cash_Plan_Balance_Rec IS RECORD (
   cash_plan_id                    VARCHAR2(30),
   snapshot_id                     VARCHAR2(30),
   row_id                          NUMBER,
   event_date                      DATE,
   source_Id                       VARCHAR2(30),
   company                         VARCHAR2(20),
   sub_source_id                   VARCHAR2(30),
   cash_probability                NUMBER, 
   sub_source_status                VARCHAR2(30),
   currency_amount                 NUMBER,
   currency_amount_with_tax        NUMBER,
   currency_code                   VARCHAR2(3),
   counterpart_id                  VARCHAR2(30),
   counterpart_name                VARCHAR2(100),
   account                         VARCHAR2(20),
   code_B                          VARCHAR2(20),
   code_C                          VARCHAR2(20),
   code_D                          VARCHAR2(20),
   code_E                          VARCHAR2(20),
   code_F                          VARCHAR2(20),
   code_G                          VARCHAR2(20),
   code_H                          VARCHAR2(20),
   code_I                          VARCHAR2(20),
   code_J                          VARCHAR2(20),
   cf_internal_external            VARCHAR2(20),
   project                         VARCHAR2(20),
   contract                        VARCHAR2(15),
   source_ref1                     VARCHAR2(50),
   source_ref2                     VARCHAR2(50),
   source_ref3                     VARCHAR2(50),
   source_ref4                     VARCHAR2(50),
   source_ref5                     VARCHAR2(50),
   reference_text                  VARCHAR2(100),
   comments                        VARCHAR2(2000),
   cash_flow_in_out                VARCHAR2(20),
   cash_plan_function              VARCHAR2(30),
   counterpart_type                VARCHAR2(20));
   
TYPE CSHPLN_Cash_Plan_Balance_Tab IS TABLE OF CSHPLN_Cash_Plan_Balance_Rec INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU  NEW METHODS -------------------------------------
