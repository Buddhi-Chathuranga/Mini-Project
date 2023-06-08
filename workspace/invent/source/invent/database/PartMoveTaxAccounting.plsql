-----------------------------------------------------------------------------
--
--  Logical unit: PartMoveTaxAccounting
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220124  MaEelk  SC21R2-4998, Added Ignore Unit Testing Annotation to Create_Voucher_Header___, Create_Voucher_Rows___ and Create_Vouchers 
--  220120  NiRalk  SC21R2-7265, Updated account_err_desc_ in Complete_Check_Accounting___ method.
--  220112  NiRalk  SC21R2-7056, Added Accounting_Have_Errors method to get error details for Tax Document Posting Analysis page
--  220110  MaEelk  SC21R2-6501, Added Create_Vouchers with a new signature to support creating vouchers for a given source reference
--  220110          Added Voucher_Created to check if vouchers have been created for a given source.
--  220110          Modified Create_Postings to support the Source Ref Type. Modified Create_Voucher_Header___ and Create_Voucher_Rows___.
--  220107  MalLlk  SC21R2-6671, Modified Create_Voucher_Rows___ to set currency rate and tax base values to negative
--  220107          where tax direction is Tax Disbursed, when creating voucher row.
--  220205  MaEelk  SC21R2-6993, Modified Do_Str_Event_Acc___ and Create_Vouchers to support the Posting cretion and Voucher creation from Tax Document Lines. 
--  220105  MaEelk  SC21R2-6993, Modified Do_Str_Event_Acc___ and Create_Vouchers to support the Posting cretion and Voucher creation from Tax Document Lines.
--  220103  ApWilk  SC21R2-6896, Modified method Create_Voucher_Rows___() to support the new key changes when assigning the values 
--  220103          for reference_number and reference_serie of voucher row.
--  211220  MaEelk  SC21R2-6775, Kay Changed as SOURCE_REF1, SOURCE_REF1, SOURCE_REF_TYPE, TAX_ITEM_ID and SEQ
--  211215  Asawlk  SC21R2-6258, Added method Reverse_Postings. 
--  211201  NiRalk  SC21R2-6175, Added Source_Ref_Information function and source_reference_rec record type.
--  211102  MaEelk  SC21R2-5668, Added tax_code to control_type_key_rec_.tax_code_ in Do_Str_Event_Acc___ 
--  211102          in order to support the Control Type AC7 having Accunt values specified in Posting Control Detail.
--  211022  MalLlk  SC21R2-5222, Modified Create_Postings, to call Tax_Handling_Invent_Util_API.Calculate_Calctax_Tax_Amounts
--  211022          to get, tax amounts for CALCTAX tax codes when receiving.
--  210929  MalLlk  SC21R2-2806, Modified Create_Voucher_Rows___ to pass tax base amounts, 
--  210929          reference_row_no and tax_direction when creating a voucher row.
--  210915  MaEelk  SC21R2-2751, Added logic to create vouchers in Multiple Tax Registrations.
--  210914  MaEelk  SC21R2-2750, Added logic to create postings in Multiple Tax Registration
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE source_reference_rec  IS RECORD (
      originating_source_ref1            VARCHAR2(50),
      originating_source_ref2            VARCHAR2(50),
      originating_source_ref3            VARCHAR2(50),
      originating_source_ref4            VARCHAR2(50),
      originating_source_ref5            VARCHAR2(50),
      originating_source_ref_type VARCHAR2(50));

TYPE source_reference_arr IS TABLE OF source_reference_rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Next_Seq___ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   tax_item_id_        IN NUMBER ) RETURN NUMBER
IS
   CURSOR max_seq_no IS
      SELECT MAX(seq)
      FROM   part_move_tax_accounting_tab
      WHERE  source_ref1 = source_ref1_
      AND    source_ref2 = source_ref2_
      AND    source_ref_type = source_ref_type_db_
      AND    tax_item_id = tax_item_id_;
      
   max_seq_no_ NUMBER;
   
BEGIN
   OPEN max_seq_no;
   FETCH max_seq_no INTO max_seq_no_;
   CLOSE max_seq_no;
   
   RETURN NVL(max_seq_no_, 0) + 1;   
END Get_Next_Seq___;


-- Complete_Check_Accounting___
--   Checks the code string and returns an error message if it went wrong.
@IgnoreUnitTest TrivialFunction
PROCEDURE Complete_Check_Accounting___ (
   account_err_desc_ OUT    VARCHAR2,
   codestr_rec_      IN OUT Accounting_Codestr_API.CodestrRec,
   company_          IN     VARCHAR2,
   user_group_       IN     VARCHAR2,
   posting_type_     IN     VARCHAR2,
   date_applied_     IN     DATE )
IS
   accounting_error  EXCEPTION;
   pragma            exception_init(accounting_error, -20105);
BEGIN

   Accounting_Codestr_API.Complete_Codestring( codestr_rec_, company_,
                                               posting_type_, date_applied_);
   codestr_rec_.text := 'DUMMY';
   Accounting_Codestr_API.Validate_Codestring( codestr_rec_, company_,
                                               date_applied_, user_group_);

   account_err_desc_ := NULL;
EXCEPTION
   WHEN accounting_error THEN
      account_err_desc_ := SUBSTR(sqlerrm, INSTR(sqlerrm,':', 1, 2)+2,2000);
      
END Complete_Check_Accounting___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Raise_Part_Move_Posting_Err___ (
   posting_event_    IN VARCHAR2,
   account_err_desc_ IN VARCHAR2)
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'ACCERROR: Posting cannot be created for the Business Event :P1. :P2', posting_event_, account_err_desc_);
END Raise_Part_Move_Posting_Err___;   


PROCEDURE Do_Str_Event_Acc___ ( 
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   tax_item_id_                IN NUMBER,                          
   company_                    IN VARCHAR2,
   contract_                   IN VARCHAR2,
   tax_code_                   IN VARCHAR2,
   posting_event_              IN VARCHAR2,
   accounting_year_            IN NUMBER,
   accounting_period_          IN NUMBER,
   value_                      IN NUMBER,
   curr_amount_                IN NUMBER,
   parallel_amount_            IN NUMBER,
   user_group_                 IN VARCHAR2,
   userid_                     IN VARCHAR2,   
   date_applied_               IN DATE ) 
IS
   CURSOR get_str_event_acc IS
      SELECT str_code, debit_credit_db, project_accounting_flag_db
      FROM ACC_EVENT_POSTING_TYPE_PUB
      WHERE  event_code = posting_event_;
      
   control_type_key_rec_        Mpccom_Accounting_API.Control_Type_Key;
   newrec_                      part_move_tax_accounting_tab%ROWTYPE;
   account_err_desc_            VARCHAR2(2000);
   account_err_status_          VARCHAR2(2);
   codestr_rec_                 Accounting_Codestr_API.CodestrRec;
      
BEGIN
   newrec_.source_ref1 := source_ref1_;
   newrec_.source_ref2 := source_ref2_;
   newrec_.source_ref_type := source_ref_type_db_;
   newrec_.tax_item_Id := tax_item_id_;
   newrec_.company := company_;
   newrec_.contract := contract_;
   newrec_.tax_code := tax_code_;
   newrec_.accounting_year := accounting_year_;
   newrec_.accounting_period := accounting_period_;
   newrec_.currency_code := Company_Finance_API.Get_Currency_Code(company_);
   newrec_.value := value_;
   newrec_.curr_amount := curr_amount_;
   newrec_.parallel_amount := parallel_amount_;
   newrec_.userid := userid_;                                                                          
   newrec_.date_applied := date_applied_;
   control_type_key_rec_.tax_code_ := tax_code_;

   FOR eventrec_ IN get_str_event_acc LOOP
      Mpccom_Accounting_API.Get_Code_String(account_err_desc_,
                                            account_err_status_,
                                            codestr_rec_,
                                            control_type_key_rec_,
                                            company_,
                                            eventrec_.str_code,
                                            date_applied_);
      IF (account_err_desc_ IS NOT NULL) THEN
         IF (source_ref_type_db_ = Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST) THEN
            Raise_Part_Move_Posting_Err___ (posting_event_, account_err_desc_);
         ELSE
            newrec_.error_desc := account_err_desc_;
         END IF;
      END IF;
      
      account_err_desc_ := NULL;
      Complete_Check_Accounting___ (account_err_desc_,
                                    codestr_rec_,
                                    company_,
                                    user_group_,
                                    eventrec_.str_code,
                                    date_applied_);
      IF (account_err_desc_ IS NOT NULL) THEN
         IF (source_ref_type_db_ = Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST) THEN
            Raise_Part_Move_Posting_Err___ (posting_event_, account_err_desc_);
         ELSE
            newrec_.error_desc := account_err_desc_;
         END IF;
      END IF;

      newrec_.seq := Get_Next_Seq___(newrec_.source_ref1,
                                     newrec_.source_ref2,
                                     newrec_.source_ref_type,
                                     newrec_.tax_item_Id);                                     
      newrec_.str_code := eventrec_.str_code;
      newrec_.event_code := posting_event_;
      newrec_.account_no := NVL(codestr_rec_.code_a, '*');
      newrec_.codeno_b := codestr_rec_.code_b;
      newrec_.codeno_c := codestr_rec_.code_c;
      newrec_.codeno_d := codestr_rec_.code_d;
      newrec_.codeno_e := codestr_rec_.code_e;
      newrec_.codeno_f := codestr_rec_.code_f;
      newrec_.codeno_g := codestr_rec_.code_g;
      newrec_.codeno_h := codestr_rec_.code_h;
      newrec_.codeno_i := codestr_rec_.code_i;
      newrec_.codeno_j := codestr_rec_.code_j;
      newrec_.debit_credit := eventrec_.debit_credit_db;

      -- Create the posting
      New___(newrec_);         
   END LOOP;
END Do_Str_Event_Acc___;      

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Voucher_Header___ (
   voucher_no_        OUT    NUMBER,
   voucher_id_        OUT    VARCHAR2,
   voucher_type_      OUT    VARCHAR2,
   transfer_id_       IN     VARCHAR2,
   company_           IN     VARCHAR2,
   voucher_date_      IN     DATE,
   function_group_    IN     VARCHAR2,
   user_group_        IN     VARCHAR2)
IS
   dummy_                  VARCHAR2(30) := user_group_;
   accounting_year_        NUMBER;
   accounting_period_      NUMBER;
   
BEGIN
   voucher_no_             := 0;
   voucher_id_             := to_char(NULL);

   User_Group_Period_API.Get_Period(accounting_year_,
                                    accounting_period_,
                                    company_,
                                    user_group_,
                                    voucher_date_);

   Voucher_Type_User_Group_API.Get_Default_Voucher_Type(voucher_type_,
                                                        company_,
                                                        user_group_,
                                                        accounting_year_,
                                                        function_group_);

   Voucher_API.New_Voucher(voucher_type_        => voucher_type_,
                           voucher_no_          => voucher_no_,
                           voucher_id_          => voucher_id_,
                           accounting_year_     => accounting_year_,
                           accounting_period_   => accounting_period_,
                           company_             => company_,
                           transfer_id_         => transfer_id_,
                           voucher_date_        => voucher_date_,
                           voucher_group_       => function_group_,
                           user_group_          => dummy_,
                           correction_          => 'N');
END Create_Voucher_Header___;

@IgnoreUnitTest DynamicStatement
PROCEDURE Create_Voucher_Rows___ (
   source_ref1_          IN VARCHAR2,
   source_ref2_          IN VARCHAR2,
   source_ref_type_db_   IN VARCHAR2,
   tax_item_id_          IN NUMBER,                          
   company_              IN  VARCHAR2,
   voucher_type_         IN  VARCHAR2,
   voucher_no_           IN  NUMBER,
   transfer_id_          IN  VARCHAR2,
   voucher_id_           IN  VARCHAR2,
   date_applied_         IN  DATE)
IS
   part_move_tax_accounting_rec_   PART_MOVE_TAX_ACCOUNTING_TAB%ROWTYPE;
   voucher_row_rec_  Voucher_API.VoucherRowRecType;
   tax_item_rec_     Source_Tax_Item_Invent_API.Public_Rec;
   quantity_         NUMBER;  
   currency_rate_    NUMBER;

   CURSOR get_part_move_tax_accountings  IS
      SELECT *
      FROM   part_move_tax_accounting_tab
      WHERE  source_ref1 = source_ref1_
      AND    source_ref2 = source_ref2_
      AND    source_ref_type = source_ref_type_db_
      AND    tax_item_Id = tax_item_Id_
      AND    voucher_no IS NULL
      AND    date_applied = date_applied_
      FOR UPDATE;

   TYPE Part_Move_Tax_Acc_Tab IS TABLE OF PART_MOVE_TAX_ACCOUNTING_TAB%ROWTYPE
     INDEX BY PLS_INTEGER;

   part_move_tax_accounting_tab_ Part_Move_Tax_Acc_Tab;

BEGIN
   IF (source_ref_type_db_ = Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST) THEN
      quantity_         := Inventory_Transaction_Hist_API.Get_Sum_Qty_Part_Move_Tax_Id(source_ref1_);
   ELSIF (source_ref_type_db_ = Tax_Source_API.DB_TAX_DOCUMENT_LINE) THEN
      $IF Component_Discom_SYS.INSTALLED $THEN
         quantity_         := Tax_Document_Line_API.Get_Quantity(company_,
                                                                 source_ref1_, 
                                                                 source_ref2_);
      $ELSE
         Error_SYS.Component_Not_Exist('DISCOM');
      $END
   END IF;
   
   OPEN get_part_move_tax_accountings;
   FETCH get_part_move_tax_accountings BULK COLLECT INTO part_move_tax_accounting_tab_;
   CLOSE get_part_move_tax_accountings;  

   IF (part_move_tax_accounting_tab_.COUNT > 0) THEN
      tax_item_rec_ := Source_Tax_Item_Invent_API.Get(company_            => company_,
                                                      source_ref_type_db_ => source_ref_type_db_,      
                                                      source_ref1_        => source_ref1_,
                                                      source_ref2_        => source_ref2_,
                                                      source_ref3_        => '*',
                                                      source_ref4_        => '*',
                                                      source_ref5_        => '*',
                                                      tax_item_id_        => tax_item_id_);
                                                      
      -- Note: Here it is considered accounting currency as the transaction currency, since they are same.
      currency_rate_ := Currency_Rate_API.Get_Currency_Rate(company_, 
                                                            part_move_tax_accounting_tab_(1).currency_code, 
                                                            Currency_Type_API.Get_Default_Type(company_), 
                                                            date_applied_);                                                
                                                     
      FOR i IN part_move_tax_accounting_tab_.FIRST..part_move_tax_accounting_tab_.LAST LOOP
         part_move_tax_accounting_rec_ := part_move_tax_accounting_tab_(i); 
         
         voucher_row_rec_.company                 := company_;
         voucher_row_rec_.voucher_type            := voucher_type_;
         voucher_row_rec_.accounting_year         := part_move_tax_accounting_rec_.accounting_year;
         voucher_row_rec_.accounting_year         := part_move_tax_accounting_rec_.accounting_period;
         voucher_row_rec_.voucher_no              := voucher_no_;
         voucher_row_rec_.row_no                  := to_number(NULL);
         voucher_row_rec_.Codestring_Rec.code_a   := part_move_tax_accounting_rec_.account_no;
         voucher_row_rec_.Codestring_Rec.code_b   := part_move_tax_accounting_rec_.codeno_b;
         voucher_row_rec_.Codestring_Rec.code_c   := part_move_tax_accounting_rec_.codeno_c;
         voucher_row_rec_.Codestring_Rec.code_d   := part_move_tax_accounting_rec_.codeno_d;
         voucher_row_rec_.Codestring_Rec.code_e   := part_move_tax_accounting_rec_.codeno_e;
         voucher_row_rec_.Codestring_Rec.code_f   := part_move_tax_accounting_rec_.codeno_f;
         voucher_row_rec_.Codestring_Rec.code_g   := part_move_tax_accounting_rec_.codeno_g;
         voucher_row_rec_.Codestring_Rec.code_h   := part_move_tax_accounting_rec_.codeno_h;
         voucher_row_rec_.Codestring_Rec.code_i   := part_move_tax_accounting_rec_.codeno_i;
         voucher_row_rec_.Codestring_Rec.code_j   := part_move_tax_accounting_rec_.codeno_j;

         IF part_move_tax_accounting_rec_.debit_credit = 'D' THEN
            voucher_row_rec_.currency_debet_amount        := part_move_tax_accounting_rec_.curr_amount;
            voucher_row_rec_.currency_credit_amount       := to_number(NULL);
            voucher_row_rec_.debet_amount                 := part_move_tax_accounting_rec_.value;
            voucher_row_rec_.credit_amount                := to_number(NULL);
            voucher_row_rec_.currency_amount              := part_move_tax_accounting_rec_.curr_amount;
            voucher_row_rec_.third_currency_debit_amount  := part_move_tax_accounting_rec_.parallel_amount;
            voucher_row_rec_.third_currency_credit_amount := to_number(NULL);
         ELSE
            voucher_row_rec_.currency_debet_amount        := to_number(NULL);
            voucher_row_rec_.currency_credit_amount       := part_move_tax_accounting_rec_.curr_amount;
            voucher_row_rec_.debet_amount                 := to_number(NULL);
            voucher_row_rec_.credit_amount                := part_move_tax_accounting_rec_.value;
            voucher_row_rec_.currency_amount              := (-1) * part_move_tax_accounting_rec_.curr_amount;
            voucher_row_rec_.third_currency_debit_amount  := to_number(NULL);
            voucher_row_rec_.third_currency_credit_amount := part_move_tax_accounting_rec_.parallel_amount;
         END IF;

         voucher_row_rec_.amount                       := to_number(NULL);
         voucher_row_rec_.third_currency_amount        := to_number(NULL);
         voucher_row_rec_.currency_code                := part_move_tax_accounting_rec_.currency_code;
         voucher_row_rec_.currency_rate                := currency_rate_;
         voucher_row_rec_.quantity                     := quantity_;
         voucher_row_rec_.process_code                 := to_char(NULL);
         voucher_row_rec_.optional_code                := part_move_tax_accounting_rec_.tax_code;         
         voucher_row_rec_.reference_number             := part_move_tax_accounting_rec_.source_ref1;
         voucher_row_rec_.reference_serie              := part_move_tax_accounting_rec_.source_ref_type;
         voucher_row_rec_.trans_code                   := part_move_tax_accounting_rec_.str_code;
         voucher_row_rec_.update_error                 := to_char(NULL);
         voucher_row_rec_.transfer_id                  := transfer_id_;
         voucher_row_rec_.corrected                    := 'N';
         $IF (Component_Discom_SYS.INSTALLED) $THEN
            IF(part_move_tax_accounting_rec_.source_ref_type = Tax_Source_API.DB_TAX_DOCUMENT_LINE)THEN
               voucher_row_rec_.text := Tax_Document_API.Get_Direction_Db(company_, part_move_tax_accounting_rec_.source_ref1);
            END IF;
         $END 
         
         IF (part_move_tax_accounting_rec_.str_code IN ('M299', 'M300', 'M301')) THEN
            voucher_row_rec_.tax_direction              := Tax_Direction_API.DB_TAX_RECEIVED;
            voucher_row_rec_.tax_base_amount            := tax_item_rec_.tax_base_dom_amount;
            voucher_row_rec_.currency_tax_base_amount   := tax_item_rec_.tax_base_curr_amount;
            voucher_row_rec_.parallel_curr_tax_base_amt := tax_item_rec_.tax_base_parallel_amount;
         ELSIF (part_move_tax_accounting_rec_.str_code IN ('M297', 'M298', 'M302')) THEN
            voucher_row_rec_.tax_direction              := Tax_Direction_API.DB_TAX_DISBURSED;
            voucher_row_rec_.tax_base_amount            := (-1) * ABS(tax_item_rec_.tax_base_dom_amount);
            voucher_row_rec_.currency_tax_base_amount   := (-1) * ABS(tax_item_rec_.tax_base_curr_amount);
            voucher_row_rec_.parallel_curr_tax_base_amt := (-1) * ABS(tax_item_rec_.tax_base_parallel_amount);
         END IF;
         
         Voucher_Api.Add_Voucher_Row(voucher_row_rec_,
                                     transfer_id_,
                                     voucher_id_,
                                     FALSE);
         part_move_tax_accounting_rec_.voucher_no      := voucher_no_;
         part_move_tax_accounting_rec_.voucher_type    := voucher_type_;
         part_move_tax_accounting_rec_.voucher_date    := date_applied_;
         Modify___(part_move_tax_accounting_rec_);
         
      END LOOP;
   END IF; 
END Create_Voucher_Rows___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Postings (
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   company_                    IN VARCHAR2,
   tax_direction_db_           IN VARCHAR2,
   contract_                   IN VARCHAR2,
   date_applied_               IN DATE ) 
IS
   posting_event_               VARCHAR2(20);
   receiver_                    BOOLEAN := FALSE;
   fee_type_db_                 VARCHAR2(10);   
   user_group_                  VARCHAR2(50);
   accounting_year_             NUMBER;
   accounting_period_           NUMBER;
   tax_dom_amount_              NUMBER;
   tax_curr_amount_             NUMBER;
   tax_parallel_amount_         NUMBER;
   tax_percentage_              NUMBER;
   userid_                      VARCHAR2(30);
   exit_procedure               EXCEPTION;

   CURSOR get_tax_information IS
      SELECT tax_item_id, tax_code, tax_curr_amount, tax_dom_amount, tax_parallel_amount, tax_base_curr_amount
      FROM   SOURCE_TAX_ITEM_PUB
      WHERE  company = company_
      AND    source_ref1 = source_ref1_
      AND    source_ref2 = source_ref2_
      AND    source_ref_type_db = source_ref_type_db_;
      
   BEGIN
   IF (source_ref_type_db_ IN (Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST,
                               Tax_Source_API.DB_TAX_DOCUMENT_LINE)) THEN 
      IF (tax_direction_db_ = Part_Move_Tax_Direction_API.DB_SENDER) THEN
         posting_event_ := 'ICBS-TAX';
      ELSIF (tax_direction_db_ = Part_Move_Tax_Direction_API.DB_RECEIVER) THEN
         receiver_ := TRUE;
      ELSE
         RAISE exit_procedure;
      END IF;
   END IF;         
      
   userid_ := Fnd_Session_API.Get_Fnd_User;
   user_group_ := User_Group_Member_Finance_API.Get_User_Group(company_,
                                                               userid_);
   User_Group_Period_API.Get_Period(accounting_year_,
                                    accounting_period_,
                                    company_,
                                    user_group_,
                                    date_applied_);
   
   FOR tax_information_rec_ IN get_tax_information LOOP
      tax_dom_amount_      := tax_information_rec_.tax_dom_amount;
      tax_curr_amount_     := tax_information_rec_.tax_curr_amount;
      tax_parallel_amount_ := tax_information_rec_.tax_parallel_amount;
   
      IF (receiver_)  THEN
         fee_type_db_ := Statutory_Fee_API.Get_Fee_Type_Db(company_, tax_information_rec_.tax_code);
         IF (fee_type_db_ = Fee_Type_API.DB_TAX) THEN
            posting_event_ := 'ICBR-TAX';
         ELSIF (fee_type_db_ = Fee_Type_API.DB_CALCULATED_TAX) THEN
            posting_event_ := 'ICBRC-TAX';
            -- When receiving, it's required to calculate and post tax amounts, considering 'Calculated Tax' tax rates as well.
            tax_percentage_ := Statutory_Fee_API.Get_Tax_Percentage(company_, tax_information_rec_.tax_code);
            IF (tax_percentage_ != 0) THEN
               Tax_Handling_Invent_Util_API.Calculate_Calctax_Tax_Amounts(tax_curr_amount_,
                                                                          tax_dom_amount_,                                                                        
                                                                          tax_parallel_amount_,
                                                                          tax_information_rec_.tax_base_curr_amount,
                                                                          company_,
                                                                          tax_information_rec_.tax_code,
                                                                          tax_percentage_,
                                                                          date_applied_);
            END IF;                                                           
         ELSE
            EXIT;
         END IF;                 
      END IF;
      
      Do_Str_Event_Acc___(company_                    => company_,
                          source_ref1_                => source_ref1_,
                          source_ref2_                => source_ref2_,
                          source_ref_type_db_         => source_ref_type_db_,
                          tax_item_Id_                => tax_information_rec_.tax_item_Id,                          
                          contract_                   => contract_,
                          tax_code_                   => tax_information_rec_.tax_code,
                          posting_event_              => posting_event_,
                          accounting_year_            => accounting_year_,
                          accounting_period_          => accounting_period_,
                          value_                      => tax_dom_amount_,
                          curr_amount_                => tax_curr_amount_,
                          parallel_amount_            => tax_parallel_amount_,
                          user_group_                 => user_group_,
                          userid_                     => userid_,   
                          date_applied_               => date_applied_ );
   END LOOP;
EXCEPTION
   WHEN exit_procedure THEN
      NULL;      
END Create_Postings;

@IgnoreUnitTest NoOutParams
PROCEDURE Create_Vouchers (
   company_            IN VARCHAR2,
   from_date_          IN DATE,
   to_date_            IN DATE,
   source_ref_type_db_ IN VARCHAR2)
IS
    transfer_id_           VARCHAR2(20);
    previous_date_applied_ DATE;
    voucher_type_          VARCHAR2(30);
    voucher_no_            NUMBER;
    voucher_id_            VARCHAR2(300);
    user_group_            VARCHAR2(50);
    voucher_needs_closing_ BOOLEAN;
    transfer_initiated_    BOOLEAN;
    function_group_        VARCHAR2(10);
    first_calendar_date_   DATE  := Database_SYS.first_calendar_date_;


   CURSOR get_part_move_accountings (company_ IN VARCHAR2, from_date_ IN DATE, to_date_  IN DATE, source_ref_type_db_ IN VARCHAR2) IS
      SELECT DISTINCT date_applied, source_ref1, source_ref2, source_ref_type, tax_item_id
      FROM   part_move_tax_accounting_tab pmt1
      WHERE  pmt1.date_applied   >= from_date_ 
      AND    pmt1.date_applied   <= to_date_
      AND    pmt1.company         = company_
      AND    pmt1.source_ref_type = source_ref_type_db_
      AND    pmt1.voucher_no IS NULL
      AND    NOT EXISTS (SELECT 1 FROM part_move_tax_accounting_tab pmt2
                         WHERE pmt2.source_ref1 = pmt1.source_ref1
                         AND   pmt2.source_ref2 = pmt1.source_ref2
                         AND   pmt2.source_ref_type = pmt1.source_ref_type
                         AND   pmt2.tax_item_id = pmt1.tax_item_id
                         AND   pmt2.error_desc IS NOT NULL)
      ORDER BY date_applied, source_ref1, source_ref2, source_ref_type, tax_item_id;

   TYPE Part_Move_Tax_Acc_Tab_Type IS TABLE OF get_part_move_accountings %ROWTYPE
     INDEX BY PLS_INTEGER;

   part_move_tax_accnt_tab_ Part_Move_Tax_Acc_Tab_Type;
BEGIN

   transfer_initiated_    := FALSE;
   voucher_id_            := '';
   voucher_needs_closing_ := FALSE;
   previous_date_applied_ := first_calendar_date_;

   user_group_            := User_Group_Member_Finance_API.Get_User_Group(company_,
                                                           Fnd_Session_API.Get_Fnd_User);

   function_group_ := 'LT';

   OPEN get_part_move_accountings (company_, from_date_, to_date_, source_ref_type_db_);
   FETCH get_part_move_accountings BULK COLLECT INTO part_move_tax_accnt_tab_;
   CLOSE get_part_move_accountings;

   IF part_move_tax_accnt_tab_.COUNT > 0 THEN
      FOR i_ IN part_move_tax_accnt_tab_.FIRST .. part_move_tax_accnt_tab_.LAST LOOP
         IF NOT (transfer_initiated_) THEN
            Voucher_API.Transfer_Init(transfer_id_, company_);
            transfer_initiated_ := TRUE;
         END IF;

         IF (part_move_tax_accnt_tab_(i_).date_applied != previous_date_applied_) THEN
            previous_date_applied_ := part_move_tax_accnt_tab_(i_).date_applied;
            
            IF (voucher_needs_closing_) THEN
               Voucher_API.Voucher_End(voucher_id_,TRUE);
            END IF;
            
            Create_Voucher_Header___ ( voucher_no_,
                                       voucher_id_,
                                       voucher_type_,
                                       transfer_id_,
                                       company_,
                                       part_move_tax_accnt_tab_(i_).date_applied,
                                       function_group_,
                                       user_group_);
            voucher_needs_closing_ := TRUE;
         END IF;

         Create_Voucher_Rows___ (part_move_tax_accnt_tab_(i_).source_ref1,
                                 part_move_tax_accnt_tab_(i_).source_ref2,
                                 part_move_tax_accnt_tab_(i_).source_ref_type,
                                 part_move_tax_accnt_tab_(i_).tax_item_id,
                                 company_,
                                 voucher_type_,
                                 voucher_no_,
                                 transfer_id_,
                                 voucher_id_,
                                 part_move_tax_accnt_tab_(i_).date_applied);
      END LOOP;

      IF ((transfer_initiated_) AND (voucher_needs_closing_)) THEN
         Voucher_Api.Voucher_End(voucher_id_, TRUE);
      END IF;
   END IF; 
END Create_Vouchers;

@IgnoreUnitTest PipelinedFunction
@UncheckedAccess
FUNCTION Source_Ref_Information(source_ref1_ IN NUMBER) RETURN source_reference_arr PIPELINED
IS 
   rec_                 source_reference_rec;
   transaction_code_    VARCHAR2(10);
BEGIN
   Inventory_Transaction_Hist_API.Get_Src_Ref_By_Part_Mov_Tax_Id (
      rec_.originating_source_ref1,
      rec_.originating_source_ref2,
      rec_.originating_source_ref3,
      rec_.originating_source_ref4,
      rec_.originating_source_ref5,
      rec_.originating_source_ref_type,
      transaction_code_,
      source_ref1_);
   PIPE ROW (rec_);
END Source_Ref_Information;

PROCEDURE Reverse_Postings (
   company_                   IN    VARCHAR2,
   source_ref1_               IN    VARCHAR2,
   source_ref2_               IN    VARCHAR2,
   tax_item_id_               IN    NUMBER,
   old_source_ref1_           IN    VARCHAR2,
   old_source_ref2_           IN    VARCHAR2,   
   old_tax_item_id_           IN    NUMBER,
   old_source_ref_type_db_    IN    VARCHAR2,
   qty_                       IN    NUMBER,
   old_qty_                   IN    NUMBER )
IS
   CURSOR get_postings IS
      SELECT seq, str_code, event_code, contract, tax_code,
             account_no, codeno_b, codeno_c, codeno_d, codeno_e, codeno_f, codeno_g, 
             codeno_h, codeno_i, codeno_j, accounting_year, accounting_period, voucher_no,
             voucher_type, voucher_date, debit_credit, value*(qty_/old_qty_)  value, currency_code, 
             curr_amount*(qty_/old_qty_) curr_amount, parallel_amount*(qty_/old_qty_) parallel_amount,
             date_applied, userid
        FROM part_move_tax_accounting_tab t
       WHERE t.source_ref1 = old_source_ref1_
         AND t.source_ref2 = old_source_ref2_
         AND t.source_ref_type = old_source_ref_type_db_
         AND t.tax_item_id     = old_tax_item_id_;
       
   comp_fin_rec_           Company_Finance_API.Public_Rec;
   value_                  NUMBER;
   curr_amount_            NUMBER;
   parallel_amount_        NUMBER;   
   debit_credit_           VARCHAR2(1);
   newrec_                 part_move_tax_accounting_tab%ROWTYPE;
   
BEGIN
   comp_fin_rec_ := Company_Finance_API.Get(company_);
 
   newrec_.source_ref1 := NVL(source_ref1_, old_source_ref1_);
   newrec_.source_ref2 := NVL(source_ref2_, old_source_ref2_);
   newrec_.source_ref_type := old_source_ref_type_db_;
   newrec_.tax_item_id     := tax_item_id_;
   
   newrec_.company := company_;
   
   FOR posting_rec_ IN get_postings LOOP      
      -- If correction type = 'REVERSE' we do not want to have negative values on the postings
      -- If a negative value would be found for a posting being reversed then create the reversal as a 'CORRECTION' 
      IF (comp_fin_rec_.correction_type = 'REVERSE') THEN
         -- Reverse postings should be created by swapping the debit credit flag on the postings
         curr_amount_     := posting_rec_.curr_amount;
         value_           := posting_rec_.value;
         parallel_amount_ := posting_rec_.parallel_amount; 
         IF (posting_rec_.debit_credit = 'C') THEN
            debit_credit_ := 'D';
         ELSE
            debit_credit_ := 'C';
         END IF;
      ELSE
         -- Reverse postings should be created by changing sign on the amount
         curr_amount_     := posting_rec_.curr_amount * (-1);
         parallel_amount_ := posting_rec_.parallel_amount * (-1); 
         debit_credit_    := posting_rec_.debit_credit;
         value_           := posting_rec_.value * (-1);
      END IF;
      newrec_.seq := Get_Next_Seq___(newrec_.source_ref1,
                                     newrec_.source_ref2,
                                     newrec_.source_ref_type,
                                     newrec_.tax_item_Id);
      newrec_.contract           := posting_rec_.contract;
      newrec_.tax_code           := posting_rec_.tax_code;
      newrec_.accounting_year    := posting_rec_.accounting_year;
      newrec_.accounting_period  := posting_rec_.accounting_period;
      newrec_.currency_code      := comp_fin_rec_.currency_code;
      newrec_.value              := value_;
      newrec_.curr_amount        := curr_amount_;
      newrec_.parallel_amount    := parallel_amount_;
      newrec_.userid             := posting_rec_.userid;                                                                          
      newrec_.date_applied       := posting_rec_.date_applied;        
      newrec_.str_code           := posting_rec_.str_code;
      newrec_.event_code         := posting_rec_.event_code;
      newrec_.account_no         := posting_rec_.account_no;
      newrec_.codeno_b           := posting_rec_.codeno_b;
      newrec_.codeno_c           := posting_rec_.codeno_c;
      newrec_.codeno_d           := posting_rec_.codeno_d;
      newrec_.codeno_e           := posting_rec_.codeno_e;
      newrec_.codeno_f           := posting_rec_.codeno_f;
      newrec_.codeno_g           := posting_rec_.codeno_g;
      newrec_.codeno_h           := posting_rec_.codeno_h;
      newrec_.codeno_i           := posting_rec_.codeno_i;
      newrec_.codeno_j           := posting_rec_.codeno_j;
      newrec_.debit_credit       := debit_credit_;

      New___(newrec_);      
   END LOOP;   
END Reverse_Postings;    

FUNCTION Voucher_Created ( 
   source_ref1_               IN    VARCHAR2,
   source_ref_type_db_        IN    VARCHAR2) RETURN BOOLEAN
IS   
   CURSOR fetch_voucher IS
      SELECT 1 FROM part_move_tax_accounting_tab
      WHERE source_ref1 = source_ref1_
      AND   source_ref_type = source_ref_type_db_
      AND   voucher_no IS NOT NULL;
      
   dummy_       NUMBER;
   result_      BOOLEAN;
BEGIN
   OPEN  fetch_voucher;
   FETCH fetch_voucher INTO dummy_;
   IF (fetch_voucher%FOUND) THEN
      result_ := TRUE;
   ELSE
      result_ := FALSE;
   END IF;
   CLOSE fetch_voucher;
   RETURN result_;
END Voucher_Created;

@IgnoreUnitTest NoOutParams
PROCEDURE Create_Vouchers (
   company_                   IN    VARCHAR2,
   source_ref1_               IN    VARCHAR2,
   source_ref_type_db_        IN    VARCHAR2 )
IS
    transfer_id_            VARCHAR2(20);
    voucher_type_           VARCHAR2(30);          
    voucher_no_             NUMBER;
    voucher_id_             VARCHAR2(300) := '';
    user_group_             VARCHAR2(30);
    transfer_initiated_     BOOLEAN := FALSE;
    voucher_header_created_ BOOLEAN := FALSE;
    voucher_needs_closing_  BOOLEAN := FALSE;    
    function_group_         VARCHAR2(10);

   CURSOR get_part_move_accountings (company_ IN VARCHAR2, source_ref1_ IN VARCHAR2, source_ref_type_db_  IN VARCHAR2) IS
      SELECT DISTINCT date_applied, source_ref1, source_ref2, source_ref_type, tax_item_id
      FROM   part_move_tax_accounting_tab pmt1
      WHERE  pmt1.company       = company_
      AND    pmt1.source_ref1   = source_ref1_
      AND    pmt1.source_ref_type   = source_ref_type_db_
      AND    pmt1.voucher_no IS NULL
      AND    NOT EXISTS (SELECT 1 FROM part_move_tax_accounting_tab pmt2
                         WHERE pmt2.source_ref1 = pmt1.source_ref1
                         AND   pmt2.source_ref_type = pmt1.source_ref_type
                         AND   pmt2.error_desc IS NOT NULL)
      ORDER BY date_applied, source_ref1, source_ref2, source_ref_type, tax_item_id;

   TYPE Part_Move_Tax_Acc_Tab_Type IS TABLE OF get_part_move_accountings %ROWTYPE
     INDEX BY PLS_INTEGER;

   part_move_tax_accnt_tab_ Part_Move_Tax_Acc_Tab_Type;
BEGIN

   user_group_            := User_Group_Member_Finance_API.Get_User_Group(company_,
                                                           Fnd_Session_API.Get_Fnd_User);

   function_group_ := 'LT';

   OPEN get_part_move_accountings (company_, source_ref1_, source_ref_type_db_);
   FETCH get_part_move_accountings BULK COLLECT INTO part_move_tax_accnt_tab_;
   CLOSE get_part_move_accountings;
   
   IF part_move_tax_accnt_tab_.COUNT > 0 THEN  
      IF NOT (transfer_initiated_) THEN
         Voucher_API.Transfer_Init(transfer_id_, company_);
         transfer_initiated_ := TRUE;
      END IF;
      
      FOR i_ IN part_move_tax_accnt_tab_.FIRST .. part_move_tax_accnt_tab_.LAST LOOP

         IF NOT(voucher_header_created_) THEN
            Create_Voucher_Header___ ( voucher_no_,
                                       voucher_id_,
                                       voucher_type_,
                                       transfer_id_,
                                       company_,
                                       part_move_tax_accnt_tab_(i_).date_applied,
                                       function_group_,
                                       user_group_);
            voucher_header_created_ := TRUE;
            voucher_needs_closing_ := TRUE;
         END IF;
         
         Create_Voucher_Rows___ (part_move_tax_accnt_tab_(i_).source_ref1,
                                 part_move_tax_accnt_tab_(i_).source_ref2,
                                 part_move_tax_accnt_tab_(i_).source_ref_type,
                                 part_move_tax_accnt_tab_(i_).tax_item_id,
                                 company_,
                                 voucher_type_,
                                 voucher_no_,
                                 transfer_id_,
                                 voucher_id_,
                                 part_move_tax_accnt_tab_(i_).date_applied);
      END LOOP;

      IF ((transfer_initiated_) AND (voucher_needs_closing_)) THEN
         Voucher_Api.Voucher_End(voucher_id_, TRUE);
      END IF;
   END IF; 
END Create_Vouchers;

FUNCTION Accounting_Have_Errors (
   source_ref1_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR fetch_errors IS 
      SELECT 1 
      FROM   part_move_tax_accounting_tab t 
      WHERE  t.source_ref1     = source_ref1_  
      AND    t.source_ref_type = source_ref_type_db_ 
      AND    error_desc IS NOT NULL;
   dummy_    NUMBER;
   result_   VARCHAR2(5);
BEGIN
   OPEN  fetch_errors;
   FETCH fetch_errors INTO dummy_;
   IF (fetch_errors%FOUND) THEN
      result_ := 'TRUE';
   ELSE
      result_ := 'FALSE';
   END IF;
   CLOSE fetch_errors;
   RETURN result_; 
END Accounting_Have_Errors;
