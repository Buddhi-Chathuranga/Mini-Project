-----------------------------------------------------------------------------
--
--  Logical unit: IntrastatManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220117  ShVese  SC21R2-3145, Modified Start_Intrastat_Process_Priv__ to handle the undo delivery transaction UND-SHPODW. 
--  211208  ShVese  SC21R2-642, Passed in receiver_contract_ to Shipment_Intrastat_API.Find_Intrastat_Data to handle shipment orders.
--  211207  Hahalk  Bug 161186(SC21R2-6469), Modified Find_Intrastat_Data___() to change the notc to 31, 32 for certain transaction codes for Denmark.
--  211115  ShVese  SC21R2-642, Modified Start_Intrastat_Process_Priv__  to include transactions by comparing 
--  211014          against country connected to remote warehouses for shipment orders.
--  210614  Hahalk  Bug 159520(SCZ-15147), Modifed If() condition in Start_Intrastat_Process_Priv__() to prevent from including transaction line into Intrastat line which 
--  210614          having different company country.
--  200928  HaPulk  SC2020R1-10102, Replaced Package_Is_Installed with Package_Is_Active since condition is to check component ACTIVE/INACTIVE instead of installability.
--  200904  RasDlk  SC2020R1-649, Modified Start_Intrastat_Process_Priv__() to handle source_ref_type 'SHIPMENT_ORDER'.
--  200211  ErFelk  Bug 149159(SCZ-5814), Modified Start_Intrastat_Process_Priv__() to handle source_ref_type 'PROJECT_DELIVERABLES'.
--  200902  SBalLK  GESPRING20-537, Modified Get_Transactions___() and Start_Intrastat_Process_Priv__() methods to enable italy intrastat functionality.
--  200211  ErFelk  Bug 149159(SCZ-5814), Modified Start_Intrastat_Process_Priv__() to handle source_ref_type 'PROJECT_DELIVERABLES'. 
--  200121  ApWilk  Bug 151263, Added the method Check_Tax_Registration_Exist___() and modified Start_Intrastat_Process_Priv__() to support include certain direct delivery
--  200121          transactions when collecting intrastat.
--  200106  ErFelk  Bug 145333, Adde methods Get_Valid_Intrastat_Ids___(), Remove_Intrastat_Entries___(), Consolidate_Intrastat__() and Start_Consolidate_Intrastat().
--  181126  Asawlk  Bug 145534(SCZ-2047), Modified Start_Intrastat_Process_Priv__() by replacing Transaction_SYS.Set_Progress_Info() with Transaction_SYS.Log_Progress_Info()
--  181126          as it may lead to a deadlock situation when the task is run in a Schedule Chain.
--  171122  TiRalk  STRSC-14699, Modified Find_Intrastat_Data___ to allow create intrastat lines though the company weight UoM is a base UoM is different than kg.
--  160518  SWeelk  Bug 125317, Modified get_transactions cursor in Start_Intrastat_Process_Priv__ method to select records containing source_ref_type as null
--  150919  Hairlk  AFT-5549, Added readonly access to Get_Report_Name function
--  150906  NaLrlk  AFT-1514, Modified Start_Intrastat_Process_Priv__() to exclude rental transactions.
--  150810  SBalLK  Bug 123739, Modified Start_Intrastat_Process_Priv__() cursors to discard the transaction record which are not belong to the selected
--  150810          company. Modified Get_Eu_Countries___() and Get_Transactions___() method to increate the performance by manupulating data fetchin logic.
--- 150512  MAHPLK  KES-402, Renamed usage of order_no, release_no, sequence_no, line_item_no attributes of InventoryTransactionHist 
--  150512          to source_ref1, source_ref2, source_ref3, source_ref4
--  140305  Nipklk  Bug 115698, Modified method Start_Intrastat_Process_Priv__ to avoid transaction OWNTRANOUT which is not needed for intrastat.
--  131011  IsSalk  Bug 112391, Modified method Start_Intrastat_Process_Priv__ to set Intrastat data for the PO credit invoices.
--  130814  UdGnlk  TIBE-852, Modified Find_Intrastat_Data public method to implementation method as part of remove global variables.
--  130814          Removed global variables eu_country_table and transaction_table, therefore pass through parameters in methods.
--  130814          Moved the type declarations to specification as its been use in CustomerOrderIntrastat and PurchaseIntrastatUtil.       
--  130806  UdGnlk  TIBE-852, Removed global variable g_processinfoflag_ and move to method to pass through parameters. 
--  130806  UdGnlk  TIBE-852, Removed the dynamic code and modify to conditional compilation.
--  130725  IsSalk  Bug 107531, Modified Find_Intrastat_Data by passing unit statistical charge diff when calling Intrastat_Line_API.New_Intrastat_Line()
--  130715  ErFelk  Bug 111147, Added return statement in Check_Site_Country().
--  120410  AyAmlk  Bug 100608, Increased the length of deliv_terms_ in Find_Intrastat_Data().
--  120405  RoJalk  Bug 101284, Modified Find_Intrastat_Data by passing opponent type when calling Intrastat_Line_API.New_Intrastat_Line()
--  120405          to clarify the opponent type when generating intrastat file for country IT.
--  110707  PraWlk  Bug 95295, Modified Find_Intrastat_Data() by Passing NULL for return material reason and return reason when calling 
--  110707          Intrastat_Line_API.New_Intrastat_Line().
--  110704  TiRalk  Bug 97374, Modified Start_Intrastat_Process_Priv__ by changing the method call Find_Intrastat_Non_Inv_Data to 
--  110704          Intrastat_Purch_Trans_Data and included non inventory scrap transactions NSCPCRECOR, NSCPCREDIT when country is GB.
--  110628  TiRalk  Bug 93821, Modified Start_Intrastat_Process by removing logic which checks 
--  110628          Company Intrastat Exempt check only for PO transactions.
--  110628  TiRalk  Bug 93821, Modified Start_Intrastat_Process by adding logic to raise error message for CO and stock transactions correctly. 
--  110628  TiRalk  Bug 93821, Modified Start_Intrastat_Process by removing logic which checks whether a country connected for all sites
--  110628          of applicable company and moved that logic to Start_Intrastat_Process_Priv__ to raise error only for CO and stock transactions.
--  110628          Modified Start_Intrastat_Process_Priv__ by rearranging the code to include PO records to intrastat considerring PO line delivery address.
--  110510  TiRalk  Bug 96057, Modified Find_Intrastat_Data by changing parameter value intrastat alt qty of method call 
--  110510          Intrastat_Line_API.New_Intrastat_Line to pass values correctly.
--  110428  TiRalk  Bug 95518, Modified Start_Intrastat_Process_Priv__ by calling Purchase_Intrastat_Util_API.Find_Intrastat_Non_Inv_Data
--  110428          to include purchase non inventory and no part transactions to intrastat report.
--  101025  PraWlk  Bug 93752, Modified Find_Intrastat_Data() by passing customs_unit_meas_ to parameter intrastat_alt_unit_meas
--  101025          when calling Intrastat_Line_API.New_Intrastat_Line which revorks a part of correction done for 93020. 
--  100930  Asawlk  Bug 93020, Modified Find_Intrastat_Data()  by passing the correct value to parameter intrastat_alt_unit_meas
--  100930          when calling Intrastat_Line_API.New_Intrastat_Line. 
--  100602  LARELK  Replaced Application_Country_API with Iso_Country_API in Start_Intrastat_Process_Priv__,Start_Intrastat_Process. 
--  100511  KRPELK  Merge Rose Method Documentation.
--  090928  ChFolk  Removed unused variables in the package.
--  --------------------------------------------- 14.0.0 ---------------------------------------------
--  100927  PraWlk  Bug 93020, Modified method Find_Intrastat_Data() by adding a call to Inventory_Part_Config_API.
--  100927          Get_Intrastat_Conv_Factor() to fetch the intrastat conv factor value based on configuration id. 
--  090720  HoInlk  Bug 76329, Added function Get_Including_Country to get including country when country code is
--  090720          MC or IM. Modified Start_Intrastat_Process_Priv__ and Find_Intrastat_Data to call this method.
--  090516  SuThlk  Bug 82219, Added dynamic method call to Customer_Order_Intrastat_API.Find_Data_From_Credit_Invoice 
--  090516          in Start_Intrastat_Process_Priv__ to collect NOTC 16 intrastat lines from credit invoices.
--  080730  AmPalk  Replaced inv_part_rec_.weight_net with invpart_weight_net_ to reflect the removal of weight_net field from Inventory Part.
--  070205  RoJalk  Modified Start_Intrastat_Process_Priv__ to include transactions SCPCREDIT,SCPCREDCOR,
--  070205          CO-SCPCRED,CO-SCPCREC when country is GB.  
--  060911  ChBalk  Merged call 53157, Modified Find_Intrastat_Data to pass NULL to new parameter county_.
--  060720  RoJalk  Centralized Part Desc - Use Inventory_Part_API.Get_Description.
--  060713  MaMalk  Modified Start_Intrastat_Process_Priv__ to change the method call made to Find_Intrastat_Data in customer order and purchasing. 
--  060515  IsAnlk  Enlarge Address - Changed variable definitions.
--  -------------------------------------------13.4.0-------------------------------------------------
--  060329  ShVese  B136336-Replaced call to Purchase_Order_Line_Util_API.Get_Po_Demand_Order_Info with 
--                  Customer_Order_Pur_Order_API.Get_Custord_For_Purord to fetch customer order ref.
--  060320  ShVese  B136336-Added call to Purchase_Order_Line_Util_API.Get_Po_Demand_Order_Info to fetch the 
--                  demand order reference in method Start_Intrastat_Process_Priv__.
--  060123  NiDalk  Added Assert safe annotation. 
--  051112  JoAnSe  Replaced use of associated_transaction_id with Invent_Trans_Connect_API.Get_Connected_Transaction_Id.
--  051026  DaYjlk  Bug 53604, Modified methods Start_Intrastat_Process_Priv__ and OrderIntrastathandling call variables to route 
--  051026          the creation of Intrastat lines for transaction codes PURDIR and INTPURDIR. instead of 
--  051026          PurchIntrastathandling which assigns the relevant CO Reference information to make them adhere to the logic that
--  051026          PODIRSH and INTPODIRSH rescpectively, adhere to, so that the same behaviour is produced.
--  051013  LEPESE  Changes in method Start_Intrastat_Process_Priv__. Replaced use of obsolete cost
--  051013          column in inventory_transaction_hist_tab with call to InventoryTransactionCost.
--  050920  NiDalk  Removed unused variables.
--  050616  SaLalk  Bug 51293, Modified Find_Intrastat_Data method to make the country of origin 
--  050616          same as country of dispatch for a German company when intrastat direction is import.
--  050505  ErSolk  Bug 50036, Modified procedure Find_Intrastat_Data to fetch
--  050505          weight from Inventory_Part_Config_API.
--  040701  MaJalk  Bug 45566, truncated the ith.date_applied in CURSOR get_transactions in Method Start_Intrastat_Process_Priv__.
--  040428  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs and removed 
--  040428          the methods Build_Order_Stmt___,Build_Purch_Stmt___,Bind_Order___ ,Bind_Purch___.
--  -------------------------------- 13.3.0 -----------------------------------------------------------
--  030827  NaWalk  Performed the CR Merge.
--  030610  SeKalk  Modified the procedure Check_Site_Country
--  030508  SeKalk  Modified the Procedure Find_Intrastat_Data and the Error Message Id in Set_Status_Info___
--  030508  BhRalk  Modified the Method Start_Intrastat_Process_Priv__ by adding variable site_company_.
--  030506  BhRalk  Modified the Method Start_Intrastat_Process.
--  030506  BhRalk  Modified the Method Start_Intrastat_Process_Priv__.
--  030424  BhRalk  Modified the the cursor get_transaction in Method Start_Intrastat_Process_Priv__.
--  030423  BhRalk  Modified the Method Check_Site_Country to remove use of private views.
--  030326  SeKalk  Replaced Site_Delivery_Address_API and Site_Delivery_Address_Tab with Company_Address_API and Company_Address_Tab
--  ********************* CRMerge *****************************
--  020815  MaGu    Bug 30882. Modified method Find_Intrastat_Data. Changed calculation
--  020815          of intrastat_alt_qty so that net weight is not used.
--  020619  DaZa    Bug 30248, added region_of_origin in method Find_Intrastat_Data.
--  010525  JSAnse  Bug fix 21463, Added call to General_SYS.Init_Method in Check_Site_Country.
--  010522  JSAnse  Bug fix 21592, Removed dbms_output call in function Eu_Country.
--  010411  DaJoLK  Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                  TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  010328  ANLASE  Added SQLERRM in Exception in Start_Intrastat_Process_Priv__.
--  010322  ANLASE  Placed error message last in Start_Intrastat_Process_Priv__.
--  010320  ANLASE  Added call to Intrastat_API.Set_Released in Start_Intrastat_Process_Priv__.
--                  Changed from warning to errormessage in exception in method Start_Intrastat_Process_Priv__.
--  010315  ANLASE  Removed trace.
--  010312  ANLASE  Corrections in Find_Intrasta_Data: get correct opponent_number and opponent_name.
--                  Added call to Set_Status_Info___ when no opposite country is found.
--  010309  ANLASE  Modified cursor and moved Get_Eu_Countries to Start_Intrastat_Process_Priv__.  
--                  Added call to Intrastat_API.Set_Process_Info in method Check_Process_Info.
--                  Added Progress_Info messages and savepoints in Start_Intrastat_Process_Priv__.
--                  Added call to Check_Process_Info.
--  010307  ANLASE  Added method Check_Process_Info, changed transaction_id to datatype NUMBER,
--                  renamed parameters in method Find_Intrastat_Data.
--  010306  ANLASE  Replaced transaction with transaction_code in all calls to Find_Intrastat_Data.
--  010305  ErFi    Added method Get_Report_Name.
--  010305  ANLASE  Added check for delivery terms in Validate_Site__,
--                  added check for intrastat_exempt in Start_Intrastat_Process_Priv__.
--                  Added parameter cost_ to method Find_Intrastat_Data.
--  010302  ANLASE  Added call to Inventory_Transaction_Hist_API.Get_Associated_Transaction_Id
--                  in method Find_Intrastat_Data.
--  010228  ANLASE  Added check for EU-countries, moved call to Get_Eu_Countries to Start_Intrastat_Process.
--  010228  ErFi    Added methods Get_Notc, Get_Transactions___,
--                  Remove_Transaction_Entries___.
--  010227  ErFi    Added methods Eu_Country, Get_Eu_Countries___, New_Eu_Country___,
--                  Remove_Entries___.
--  010226  ANLASE  Modified Start_Intrastat_Process_Priv__.
--                  Changed intrastat_id to datatype number.
--  010222  ANLASE  Added to_invoice_date as parameter in call to Purchase_Intrastat_Util_API.Find_Intrastat_Data.
--  010214  ANLASE  Added PL-tables eu_country_tab_ and transaction_tab_.
--  010213  ANLASE  Modified Start_Intrastat_process.
--  010213  ANLASE  Created. Added undefines
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE eu_country_type IS TABLE OF VARCHAR2(2)
   INDEX BY BINARY_INTEGER;
TYPE mpccom_transaction IS RECORD (
   transaction_code VARCHAR2(10),
   notc             VARCHAR2(2),
   direction        VARCHAR2(20));
TYPE mpccom_transaction_type IS TABLE OF mpccom_transaction
   INDEX BY BINARY_INTEGER;

TYPE Intrastat_Id_Tab_Type IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
-------------------- PRIVATE DECLARATIONS -----------------------------------

separator_   CONSTANT VARCHAR2(1)     := Client_SYS.field_separator_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- Check_Tax_Registration_Exist___
-- Check whether the reporting country has a tax registration in the reporting company
-- when collecting intrastat.
FUNCTION Check_Tax_Registration_Exist___(
  company_               IN VARCHAR2,
  country_code_db_       IN VARCHAR2,
  valid_from_            IN DATE) RETURN BOOLEAN
IS
   temp_ NUMBER;
   $IF Component_Invoic_SYS.INSTALLED $THEN
      CURSOR exist_tax_reg IS
         SELECT 1
         FROM   tax_liability_countries_tab
         WHERE  company = company_
         AND    country_code = country_code_db_
         AND    valid_from_ BETWEEN valid_from AND valid_until;
   $END
BEGIN
   $IF Component_Invoic_SYS.INSTALLED $THEN
      OPEN  exist_tax_reg;
      FETCH exist_tax_reg INTO temp_;
      IF (exist_tax_reg%FOUND) THEN
         CLOSE exist_tax_reg;
         RETURN TRUE;
      END IF;
      CLOSE exist_tax_reg;
      RETURN FALSE;
   $ELSE
      NULL;
   $END
END Check_Tax_Registration_Exist___;

-- Set_Status_Info___
--   Writes information about the current transaction being processed to the
--   log for the background job.
PROCEDURE Set_Status_Info___ (
   transaction_id_ IN NUMBER,
   language_       IN VARCHAR2,
   info_           IN VARCHAR2 DEFAULT NULL )
IS
   transaction_info_   VARCHAR2(2000);
BEGIN
   -- Write information about the current transaction being processed
   -- to the background job log
   transaction_info_ := Language_SYS.Translate_Constant(lu_name_,
                        'TRANS_ERROR1: Error when processing Inventory Transaction Id :P1.',
                                                        language_, TO_CHAR(transaction_id_));
   Transaction_SYS.Set_Status_Info(transaction_info_);
   IF info_ IS NOT NULL THEN
      -- Write additional error information
      Transaction_SYS.Set_Status_Info(info_);
   END IF;
END Set_Status_Info___;


-- Eu_Country___
--   Returns TRUE if the given country is a member of the EU, FALSE otherwise.
--   The check is made against a PL/SQL table created during the execution of
--   the Intrastat process, hence this method will always return FALSE if it
--   is used at any other time.
FUNCTION Eu_Country___ (
   country_code_     IN VARCHAR2,
   eu_country_table_ IN eu_country_type ) RETURN BOOLEAN
IS
BEGIN
   -- Check for emtpy table
   IF eu_country_table_.LAST IS NOT NULL THEN
      FOR counter_ IN eu_country_table_.FIRST..eu_country_table_.LAST LOOP
         IF counter_ > eu_country_table_.COUNT THEN
            RETURN FALSE;
         END IF;
         IF country_code_ = eu_country_table_(counter_) THEN
            RETURN TRUE;
         END IF;
      END LOOP;
   END IF;
   RETURN FALSE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
END Eu_Country___;

-- Get_Valid_Intrastat_Ids___
--    This method will separate the intrastat_ids from the string and will check 
--    whether all ids belongs to the same period and status is Confirmed.
PROCEDURE Get_Valid_Intrastat_Ids___(
   valid_intrastat_id_tab_ IN OUT Intrastat_Id_Tab_Type,
   intrastat_ids_          IN VARCHAR2,
   from_date_              IN DATE,
   to_date_                IN DATE,
   country_code_           IN VARCHAR2 )
IS
   separator_position_  NUMBER;
   valid_intrastat_id_  VARCHAR2(32000);
   intrastat_id_        NUMBER;
   intrastat_id_cnt_    NUMBER := 0;
   remaining_string_    VARCHAR2(32000);
   dummy_               NUMBER;
   invalid_intrastat_id EXCEPTION;
   
   CURSOR check_intrastat_id IS
      SELECT 1
      FROM intrastat_tab       
      WHERE country_code = country_code_
      AND begin_date = from_date_
      AND end_date = to_date_
      AND rowstate = 'Confirmed'
      AND intrastat_id = intrastat_id_;
BEGIN
   -- Remove old entries   
   Remove_Intrastat_Entries___(valid_intrastat_id_tab_);
      
   IF (intrastat_ids_ IS NOT NULL) THEN
      -- Separete the intrastat ids and store them in a table.
      separator_position_ := INSTR(intrastat_ids_, ',');
      intrastat_id_cnt_ := intrastat_id_cnt_ + 1;
      remaining_string_ := intrastat_ids_;
      
      WHILE (separator_position_ != 0) LOOP
         valid_intrastat_id_ := SUBSTR(remaining_string_, 1, separator_position_ - 1);
         valid_intrastat_id_tab_(intrastat_id_cnt_) := TO_NUMBER(valid_intrastat_id_);
         remaining_string_    := SUBSTR(remaining_string_ , separator_position_ + 1);
         intrastat_id_cnt_    := intrastat_id_cnt_ + 1;
         separator_position_  := INSTR(remaining_string_, ',');
      END LOOP;
      
      IF (separator_position_ = 0) THEN
         valid_intrastat_id_tab_(intrastat_id_cnt_)  := TO_NUMBER(remaining_string_);
      END IF;
   END IF;
   
   FOR i_ IN valid_intrastat_id_tab_.FIRST..valid_intrastat_id_tab_.LAST LOOP 
      -- Check the intrastat id whether it satisfies the requirements.
      intrastat_id_ := valid_intrastat_id_tab_(i_);
      
      OPEN check_intrastat_id;
      FETCH check_intrastat_id INTO dummy_;
      IF (check_intrastat_id%NOTFOUND) THEN
         CLOSE check_intrastat_id;
         RAISE invalid_intrastat_id;         
      END IF;         
      CLOSE check_intrastat_id;
   END LOOP;      
EXCEPTION
   WHEN invalid_intrastat_id THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDINTRASTATID: Intrastat ID :P1 does not fulfill the requirements. ', intrastat_id_);
   WHEN OTHERS THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDINTRASTATIDLIST: Intrastat IDs :P1 format is incorrect ', intrastat_ids_);
END Get_Valid_Intrastat_Ids___;

PROCEDURE Remove_Intrastat_Entries___ (
   valid_intrastat_id_tab_ IN OUT Intrastat_Id_Tab_Type)
IS 
   
BEGIN
      valid_intrastat_id_tab_.DELETE;
   
END Remove_Intrastat_Entries___;

-- Remove_Eu_Entries___
--   Clears the PL/SQL table containing the EU countries.
PROCEDURE Remove_Eu_Entries___ (
   eu_country_table_  IN OUT eu_country_type)
IS   
BEGIN
   eu_country_table_.DELETE;
END Remove_Eu_Entries___;


-- Get_Eu_Countries___
--   Retrieves all EU countries from the database and stores them in a PL/SQL table.
PROCEDURE Get_Eu_Countries___ (
   eu_country_table_  IN OUT eu_country_type )
IS
   country_list_ VARCHAR2(32000);
   country_      VARCHAR2(2000);
   country_db_   VARCHAR2(2);
   endpos_       NUMBER := 1;
   current_      NUMBER := 1;
  
BEGIN
   -- Remove old entries   
   Remove_Eu_Entries___(eu_country_table_);
   
   -- Get all countries used in the application
   Iso_Country_API.Enumerate(country_list_);
   WHILE endpos_ <= length(country_list_) LOOP
      endpos_ := instr(country_list_, separator_, endpos_);
      country_ := substr(country_list_, current_, endpos_ - current_);
      country_db_ := Iso_Country_API.Encode(country_);
      IF Iso_Country_API.Get_Eu_Member_Db(country_db_)='Y' THEN
         -- Insert the EU country in the PL/SQL table        
         New_Eu_Country___(country_db_, eu_country_table_);
      END IF;

      endpos_ := endpos_ + 1;
      current_ := endpos_;

   END LOOP;
END Get_Eu_Countries___;


-- New_Eu_Country___
--   Inserts an EU country in the PL/SQL table.
PROCEDURE New_Eu_Country___ (
   country_code_      IN VARCHAR2,
   eu_country_table_  IN OUT eu_country_type )
IS
BEGIN
   eu_country_table_(eu_country_table_.COUNT + 1) := country_code_;
END New_Eu_Country___;


PROCEDURE Find_Intrastat_Data___ (
   process_info_flag_   IN OUT BOOLEAN,
   intrastat_id_        IN NUMBER,
   begin_date_          IN DATE,
   end_date_            IN DATE,
   report_country_      IN VARCHAR2,
   language_            IN VARCHAR2,
   transaction_id_      IN NUMBER,
   transaction_code_    IN VARCHAR2,
   order_type_          IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   order_no_            IN VARCHAR2,
   release_no_          IN VARCHAR2,
   sequence_no_         IN VARCHAR2,
   line_item_no_        IN NUMBER,
   cost_                IN NUMBER,
   inventory_direction_ IN VARCHAR2,
   quantity_            IN NUMBER,
   qty_reversed_        IN NUMBER,
   reject_code_         IN VARCHAR2,
   date_applied_        IN DATE,
   user_                IN VARCHAR2,
   eu_country_table_    IN eu_country_type,
   transaction_table_   IN mpccom_transaction_type )
IS
   opp_trans_rec_       Inventory_Transaction_Hist_API.Public_Rec;
   inv_part_rec_        Inventory_Part_API.Public_Rec;
   opp_site_del_rec_    Company_Address_API.Public_Rec;
   opp_site_rec_        Site_API.Public_Rec;
   opp_trans_           NUMBER;
   opp_company_         VARCHAR2(20);
   opp_company_desc_    VARCHAR2(100);
   mode_of_transp_      VARCHAR2(200);
   deliv_terms_         VARCHAR2(5);
   customs_unit_meas_   VARCHAR2(10);
   notc_                VARCHAR2(100);
   intrastat_direction_ VARCHAR2(100);
   info_                VARCHAR2(2000);
   intrastat_exempt_    VARCHAR2(30);
   weight_unit_code_    VARCHAR2(10);
   country_of_origin_   VARCHAR2(3);
   invpart_weight_net_  NUMBER;
   config_intrastat_conv_factor_ NUMBER;  
BEGIN

   --find opposite/corresponding transaction for site-move
   opp_trans_ := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(transaction_id_, 'INTERSITE TRANSFER');
   opp_trans_rec_ := Inventory_Transaction_Hist_API.Get(opp_trans_);

   --IF opposite delivery address IS NULL, no opposite country can be found and no intrastat line will be created
   opp_site_rec_ := Site_API.Get(opp_trans_rec_.contract);
   opp_site_del_rec_ := Company_Address_API.Get(Site_API.Get_Company(opp_trans_rec_.contract), opp_site_rec_.delivery_address);
   IF opp_site_del_rec_.country IN ('MC', 'IM') THEN
      opp_site_del_rec_.country := Get_Including_Country(opp_site_del_rec_.country);
   END IF;
   IF report_country_ <> opp_site_del_rec_.country AND (opp_site_del_rec_.country IS NOT NULL) THEN
      -- The report country should already be validated as an EU memeber
      -- Only use addresses which are not exempted
         intrastat_exempt_ := NVL(Company_Address_Deliv_Info_API.Get_Intrastat_Exempt_Db(Site_API.Get_Company(opp_trans_rec_.contract), opp_site_rec_.delivery_address), 'INCLUDE');
         IF Eu_Country___(opp_site_del_rec_.country, eu_country_table_) AND intrastat_exempt_ = 'INCLUDE' THEN
         --Validate site for connected transaction
         Validate_Site___(process_info_flag_, mode_of_transp_, deliv_terms_, language_, transaction_id_, opp_trans_rec_.contract, intrastat_id_);
         --Validate the attributes on inventory part
         inv_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);
         Validate_Inventory_Part___ (process_info_flag_, customs_unit_meas_, inv_part_rec_, transaction_id_, language_, contract_, part_no_, intrastat_id_);
         --Get the nature of transaction and direction
         Get_Notc___(notc_, intrastat_direction_, transaction_table_, transaction_code_);       

         IF ((report_country_ = 'DE') AND (inv_part_rec_.country_of_origin = 'DE' OR inv_part_rec_.country_of_origin IS NULL) AND (intrastat_direction_ = 'IMPORT')) THEN
            country_of_origin_ :=  opp_site_del_rec_.country;
         ELSE
            country_of_origin_ :=  inv_part_rec_.country_of_origin;
         END IF;
         
         --Get company for opposite site
         opp_company_ := opp_site_rec_.company;
         opp_company_desc_ := Company_Finance_API.Get_Description(opp_company_);

         -- weight_net field gets removed from Inventory Part and gets added to the part catalog under IID DI011.
         -- invpart_weight_net_ introduced insted inv_part_rec_.weight_net.
         invpart_weight_net_ := Inventory_Part_API.Get_Weight_Net(contract_, part_no_);
         Inventory_Part_Config_API.Get_Net_Weight_And_Unit_Code(invpart_weight_net_, 
                                                                weight_unit_code_,
                                                                contract_,
                                                                part_no_,
                                                                configuration_id_);
         IF (weight_unit_code_ != 'kg') THEN
            -- When having Base UoM other than kg as the Company weight UoM it cannot be define the conversion with kg.
            -- With that data set up it allows to create lines. 
            BEGIN
               invpart_weight_net_ := Iso_Unit_API.Convert_Unit_Quantity(invpart_weight_net_,
                                                                         weight_unit_code_,
                                                                         'kg');
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;                  
         END IF;
         
         config_intrastat_conv_factor_ := Inventory_Part_Config_API.Get_Intrastat_Conv_Factor(contract_,
                                                                                             part_no_,
                                                                                             configuration_id_);
         
         IF (report_country_ = 'DK') THEN            
            IF (notc_ = 31) THEN
               notc_ := 32;
            END IF;
         END IF;
         --Create new intrastatline
         Intrastat_Line_API.New_Intrastat_Line(intrastat_id_,
                                               transaction_id_,
                                               transaction_code_,
                                               order_type_,
                                               contract_,
                                               part_no_,
                                               Inventory_Part_API.Get_Description(contract_, part_no_), --part description
                                               configuration_id_,
                                               lot_batch_no_,
                                               serial_no_,
                                               order_no_,
                                               release_no_,
                                               sequence_no_,
                                               line_item_no_,
                                               inventory_direction_,                                               
                                               quantity_,
                                               qty_reversed_,
                                               inv_part_rec_.unit_meas,
                                               reject_code_,
                                               date_applied_,
                                               user_, -- fnd_user
                                               invpart_weight_net_,
                                               inv_part_rec_.customs_stat_no,
                                               NVL(NVL(config_intrastat_conv_factor_, inv_part_rec_.intrastat_conv_factor),0), -- intrastat_alt_qty
                                               customs_unit_meas_,
                                               notc_,
                                               intrastat_direction_,
                                               country_of_origin_,                                               
                                               'AUTOMATIC', -- Intrastat origin
                                               opp_site_del_rec_.country, -- opposite_country_
                                               opp_company_, -- opponent_number_
                                               opp_company_desc_, -- opponent_name_
                                               cost_, -- order_unit_price
                                               NULL, -- unit_add_cost_amount
                                               NULL, -- unit_charge_amount_
                                               mode_of_transp_,-- mode_of_transport
                                               NULL, -- invoice_serie
                                               NULL, -- invoice_no_,
                                               NULL, -- invoiced unit_price_,
                                               NULL, -- unit_add_cost_amount_inv_
                                               NULL, -- unit_inv_charge_amount_,
                                               deliv_terms_, -- delivery_terms,
                                               'NO TRIANGULATION',
                                               'DELIVERY',
                                               NULL, -- region_port_
                                               inv_part_rec_.region_of_origin,
                                               NULL,
                                               NULL,
                                               NULL,
                                               'COMPANY',
                                               NULL -- unit_stat_charge_diff_
                                               );
         END IF;
   --If no opposite country can be found no intrastat line will be created - add information
   ELSIF opp_site_del_rec_.country IS NULL THEN
         info_ := Language_SYS.Translate_Constant(lu_name_,
            'NO_OPP_COUNTRY: Site :P1 is not connected to a country.',
                                                  language_, opp_trans_rec_.contract);
         Set_Status_Info___(transaction_id_, language_, info_);
         Check_Process_Info(process_info_flag_, intrastat_id_);
   END IF;

EXCEPTION
   WHEN OTHERS THEN
      @ApproveTransactionStatement(2012-01-25,GanNLK)
      ROLLBACK TO before_invent_;
      Set_Status_Info___(transaction_id_, language_, SQLERRM);
      Check_Process_Info(process_info_flag_, intrastat_id_);
END Find_Intrastat_Data___;


-- Get_Transactions___
--   Retrieves the Nature of Transaction Code and Intrastat direction for
--   all appropriate inventory transactions and stores them in a PL/SQL table
--   for faster access.
PROCEDURE Get_Transactions___ (
   transaction_table_        IN OUT mpccom_transaction_type,
   italy_intrastat_enabled_  IN BOOLEAN)
IS
   --             transaction table.
   CURSOR get_transactions IS
      SELECT transaction_code, notc, intrastat_direction_db
      FROM mpccom_transaction_code_pub
      WHERE intrastat_direction_db IN ('EXPORT', 'IMPORT');
      
   -- gelr:italy_intrastat, start
   CURSOR get_italy_trans_exceptions IS
      SELECT transaction_code, notc, intrastat_direction
      FROM  mpccom_trans_code_country_tab
      WHERE included = 'TRUE'
      AND   country_code = 'IT'
      AND   intrastat_direction IN ( Intrastat_Direction_API.DB_EXPORT, Intrastat_Direction_API.DB_IMPORT)
      AND   transaction_code NOT IN ( SELECT transaction_code
                                      FROM TABLE(transaction_table_));
   
   trans_exception_table_ mpccom_transaction_type;
   next_index_            NUMBER;
   -- gelr:italy_intrastat, end
BEGIN
   -- Remove old entries
   Remove_Transaction_Entries___(transaction_table_);
   OPEN get_transactions;
   FETCH get_transactions BULK COLLECT INTO transaction_table_;
   CLOSE get_transactions;
   
   -- gelr:italy_intrastat, start
   IF (italy_intrastat_enabled_) THEN
      OPEN get_italy_trans_exceptions;
      FETCH get_italy_trans_exceptions BULK COLLECT INTO trans_exception_table_;
      CLOSE get_italy_trans_exceptions;
      
      IF(trans_exception_table_.COUNT > 0) THEN
         next_index_ := transaction_table_.COUNT + 1;
         FOR i_ IN trans_exception_table_.FIRST..trans_exception_table_.LAST LOOP
            transaction_table_(next_index_).transaction_code := trans_exception_table_(i_).transaction_code;
            transaction_table_(next_index_).notc             := trans_exception_table_(i_).notc;
            transaction_table_(next_index_).direction        := trans_exception_table_(i_).direction;
            next_index_ := next_index_ + 1;
         END LOOP;
      END IF;
   END IF;
   -- gelr:italy_intrastat, end
END Get_Transactions___;


-- Remove_Transaction_Entries___
--   Clears the PL/SQL table which stores the Nature of Transaction Code
--   and Intrastat Direction.
PROCEDURE Remove_Transaction_Entries___(
   transaction_table_  IN OUT mpccom_transaction_type )
IS
BEGIN
   transaction_table_.DELETE;
END Remove_Transaction_Entries___;


-- Get_Notc___
--   Returns the Nature of Transaction Code (NoTC) and Intrastat direction
--   for a given inventory transaction.
PROCEDURE Get_Notc___ (
   notc_                   OUT VARCHAR2,
   intrastat_direction_db_ OUT VARCHAR2,
   transaction_table_      IN  mpccom_transaction_type,
   transaction_code_       IN  VARCHAR2 )
IS
BEGIN
   -- Loop the PL/SQL table to find the NoTC and intrastat direction
   FOR i_ IN transaction_table_.FIRST..transaction_table_.LAST LOOP
      IF transaction_table_(i_).transaction_code = transaction_code_ THEN
         notc_ := transaction_table_(i_).notc;
         intrastat_direction_db_ := transaction_table_(i_).direction;
         EXIT;
      END IF;
   END LOOP;
EXCEPTION
   WHEN value_error THEN
      -- Something went wrong, the PL/SQL table is probably empty
      -- Return NULL
      Trace_SYS.Message('EXCEPTION! VALUE ERROR');
END Get_Notc___;


-- Validate_Inventory_Part___
--   Checks a number of attributes on the Inventory Part to make sure that
--   they have values.
PROCEDURE Validate_Inventory_Part___ (
   process_info_flag_ IN OUT BOOLEAN,
   customs_unit_meas_ OUT VARCHAR2,
   part_record_       IN  Inventory_Part_API.Public_Rec,
   transaction_id_    IN  NUMBER,
   language_          IN  VARCHAR2,
   contract_          IN  VARCHAR2,
   part_no_           IN  VARCHAR2,
   intrastat_id_      IN  NUMBER )
IS
   info_ VARCHAR2(2000);
BEGIN
   IF part_record_.customs_stat_no IS NULL THEN
      -- This attribute is not mandatory in the application,
      -- but it must be entered in the Intrastat report
      info_ := Language_SYS.Translate_Constant(lu_name_,
         'NO_CUST_STAT: Customs Stat No for Inventory Part :P1 on Site :P2 must be entered.',
                                               language_, part_no_, contract_);
      Set_Status_Info___(transaction_id_, language_, info_);
      Check_Process_Info(process_info_flag_, intrastat_id_);
   END IF;
   customs_unit_meas_ := Customs_Statistics_Number_API.Get_Customs_Unit_Meas(part_record_.customs_stat_no);
END Validate_Inventory_Part___;


-- Validate_Site___
--   Checks a number of attributes on the Site Delivery Address to make
--   sure that they have values.
PROCEDURE Validate_Site___ (
   process_info_flag_ IN OUT BOOLEAN,
   mode_of_transport_ OUT VARCHAR2,
   delivery_terms_    OUT VARCHAR2,
   language_          IN  VARCHAR2,
   transaction_id_    IN  NUMBER,
   contract_          IN  VARCHAR2,
   intrastat_id_      IN  NUMBER )
IS
   info_              VARCHAR2(2000);
   site_rec_          Site_API.Public_Rec;
   
BEGIN
   
   site_rec_  := Site_API.Get(contract_);
   mode_of_transport_ :=  Mpccom_Ship_Via_API.Get_Mode_Of_Transport(Company_Address_Deliv_Info_API.Get_Ship_Via_Code(site_rec_.company, site_rec_.delivery_address));
   IF mode_of_transport_ IS NULL THEN
      -- This attribute is not mandatory in the application,
      -- but it must be entered in the Intrastat report
      info_ := Language_SYS.Translate_Constant(lu_name_,
         'NO_MODE: No Mode of Transport has been selected for the Ship Via Code used on Site :P1.',
                                               language_, contract_);
      Set_Status_Info___(transaction_id_, language_, info_);
      Check_Process_Info(process_info_flag_, intrastat_id_);
   END IF;

   delivery_terms_ := Company_Address_Deliv_Info_API.Get_Delivery_Terms(site_rec_.company, site_rec_.delivery_address);
   IF delivery_terms_ IS NULL THEN
      -- This attribute is not mandatory in the application,
      -- but it must be entered in the Intrastat report
      info_ := Language_SYS.Translate_Constant(lu_name_,
         'NO_DEL_TERMS: No Delivery Terms has been selected for Site :P1.',
                                               language_, contract_);
      Set_Status_Info___(transaction_id_, language_, info_);
      Check_Process_Info(process_info_flag_, intrastat_id_);
   END IF;

END Validate_Site___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Start_Intrastat_Process_Priv__
--   This method will fetch data from inventory transactions for the Intrastat report.
PROCEDURE Start_Intrastat_Process_Priv__ (
   attr_ IN VARCHAR2 )
IS
   company_             VARCHAR2(20);
   country_code_        VARCHAR2(3);
   from_date_           DATE;
   to_date_             DATE;
   to_invoice_date_     DATE;

   intrastat_id_        NUMBER;

   ptr_                 NUMBER := NULL;
   name_                VARCHAR2(30);
   value_               VARCHAR2(2000);

   order_cnt_           NUMBER := 0;
   purchase_cnt_        NUMBER := 0;
   stock_cnt_           NUMBER := 0;
   shipment_cnt_        NUMBER := 0;
   language_            VARCHAR2(4) := Fnd_Session_API.Get_Language;
   part_rec_            Inventory_transaction_hist_tab%ROWTYPE;

   transaction_info_    VARCHAR2(2000);

   site_rec_            Site_API.Public_Rec;
   company_country_     VARCHAR2(35);
   intrastat_exempt_db_ VARCHAR2(20);    

   dummy_               NUMBER;
   po_transactions_     BOOLEAN := FALSE;
   custorder_or_stock_  BOOLEAN := FALSE;
   info_                VARCHAR2(2000);
   po_transactions_only EXCEPTION;
   
   g_processinfoflag_   BOOLEAN;   
   eu_country_table_    eu_country_type;
   transaction_table_   mpccom_transaction_type;
   
   dummy_txt_           VARCHAR2(10) := NULL;
   sender_country_code_ VARCHAR2(3);
   receiver_country_code_ VARCHAR2(3);
   receiver_contract_    VARCHAR2(5);
   
   -- gelr:italy_intrastat, start
   TYPE Transaction_Rec IS RECORD (
      transaction_id    inventory_transaction_hist_tab.transaction_id%TYPE,
      source_ref_type   inventory_transaction_hist_tab.source_ref_type%TYPE,
      contract          inventory_transaction_hist_tab.contract%TYPE,
      transaction_code  inventory_transaction_hist_tab.transaction_code%TYPE,
      source_ref1       inventory_transaction_hist_tab.source_ref1%TYPE);
      
   TYPE Transaction_Tab IS TABLE OF transaction_rec INDEX BY PLS_INTEGER;
   intrastat_transaction_tab_  Transaction_Tab;
   italy_intrastat_enabled_    BOOLEAN := FALSE;
   -- gelr:italy_intrastat, end
   
   --             than the company selected for collecting intrastat data. Removed parameterized dates.
   -- declare cursor for intrastat transactions
   CURSOR get_transactions IS
      SELECT ith.transaction_id, ith.source_ref_type ,ith.contract, ith.transaction_code, ith.source_ref1
      FROM inventory_transaction_hist_tab ith, mpccom_transaction_code_pub m, site_public sp
      WHERE (ith.date_applied BETWEEN from_date_ AND to_date_)
      AND ith.quantity != 0
      AND (ith.source_ref_type != 'RENTAL' OR ith.source_ref_type IS NULL)
      AND m.intrastat_direction_db IS NOT NULL
      AND ith.transaction_code = m.transaction_code
      AND ith.contract = sp.contract
      AND sp.company = company_;

   CURSOR get_italy_transactions IS
      SELECT ith.transaction_id, ith.source_ref_type ,ith.contract, ith.transaction_code, ith.source_ref1
        FROM inventory_transaction_hist_tab ith, mpccom_trans_code_country_tab t, mpccom_transaction_code_pub m, site_public sp
       WHERE ith.transaction_code   = m.transaction_code
         AND t.transaction_code (+) = m.transaction_code
         AND (ith.date_applied BETWEEN from_date_ AND to_date_)
         AND ith.quantity != 0
         AND (ith.source_ref_type != 'RENTAL' OR ith.source_ref_type IS NULL)
         AND (t.included IS NULL OR t.included = 'TRUE')
         AND CASE WHEN t.transaction_code IS NOT NULL THEN t.intrastat_direction ELSE m.intrastat_direction_db END IS NOT NULL
         AND ith.contract     = sp.contract
         AND sp.company       = company_
         AND t.country_code(+)   = country_code_;
   -- gelr:italy_intrastat, end

   -- declare cursor for transaction ID
   CURSOR inv_trans (c_transaction_id_ NUMBER) IS
      SELECT * 
      FROM inventory_transaction_hist_tab
      WHERE transaction_id = c_transaction_id_;

   TYPE Transaction_Id_Tab_Type IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

   customer_order_tab_  Transaction_Id_Tab_Type;
   purchase_order_tab_  Transaction_Id_Tab_Type;
   stock_movement_tab_  Transaction_Id_Tab_Type;
   shipment_tab_        Transaction_Id_Tab_Type;

   --             than the company selected for collecting intrastat data. Removed parameterized dates.
   -- Check the purchase transactions
   CURSOR po_transactions IS
      SELECT 1 
      FROM inventory_transaction_hist_tab ith, mpccom_transaction_code_pub m, site_public sp
      WHERE ((TRUNC(ith.date_applied) >= from_date_) AND (TRUNC(ith.date_applied) <= to_date_))
      AND ith.quantity != 0
      AND m.intrastat_direction_db IS NOT NULL
      AND ith.transaction_code = m.transaction_code
      AND ith.source_ref_type = 'PUR ORDER'
      AND ith.contract = sp.contract
      AND sp.company = company_;
BEGIN
   g_processinfoflag_ := FALSE;
   ------------------------------------------------------------------------------
   -- Fetch inparameters and verify that the correct parameters were passed.   --
   ------------------------------------------------------------------------------

   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'COMPANY') THEN
         company_ := value_;
         Company_Finance_API.Exist(company_);
      ELSIF (name_ = 'COUNTRY_CODE') THEN
         country_code_ := value_;
         Iso_Country_API.Exist(country_code_);
      ELSIF (name_ = 'FROM_DATE') THEN
         from_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TO_DATE') THEN
         to_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TO_INVOICE_DATE') THEN
         to_invoice_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   -- If no purchase transactions exist, error message will be pop up before creating 
   -- intrastat header, since the error message will be valid only for CO and stock transactions
   OPEN po_transactions;
   FETCH po_transactions INTO dummy_;
   IF po_transactions%FOUND THEN
      po_transactions_ := TRUE;
   ELSE
      -- All sites must be connected to a country in order to select accurate CO and stock transactions
      IF (Check_Site_Country(company_) = 'TRUE') THEN
         CLOSE po_transactions;
         Error_SYS.Record_General(lu_name_, 'SITEMISSINGCOUNTRY: All sites for company :P1 are not connected to a country.', company_);
      END IF;
   END IF;
   CLOSE po_transactions;
   
   -- Create Header for Intrastat Report the method returns intrastat_id
   Intrastat_API.New_Intrastat_Header(intrastat_id_, company_, country_code_, from_date_, to_date_, to_invoice_date_);
   -- Commit here to be able to catch waring message.
   @ApproveTransactionStatement(2012-01-25,GanNLK)
   COMMIT;
   
   -- gelr:italy_intrastat, start
   IF ( Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'ITALY_INTRASTAT') = Fnd_Boolean_API.DB_TRUE ) THEN
      italy_intrastat_enabled_ := TRUE;
   END IF;
   -- gelr:italy_intrastat, end
   
   -- Insert all EU countries into the PL/SQL table
   Get_Eu_Countries___(eu_country_table_);

   -- Insert all Notc and Intrastat directions into the PL/SQL table
   -- gelr:italy_intrastat, Added italy intrastat parameter.
   Get_Transactions___(transaction_table_, italy_intrastat_enabled_);

   transaction_info_ := Language_SYS.Translate_Constant(lu_name_, 
                        'GETTRANS: Gathering Inventory Transactions...',
                        language_);
   Transaction_SYS.Log_Progress_Info(transaction_info_);

   IF (italy_intrastat_enabled_) THEN
      -- gelr:italy_intrastat, start
      OPEN get_italy_transactions;
      FETCH get_italy_transactions BULK COLLECT INTO intrastat_transaction_tab_;
      CLOSE get_italy_transactions;
      -- gelr:italy_intrastat, end
   ELSE
      -- Note: Use cursor to get transactions and create pl-tables for order, purch, invent.
      OPEN get_transactions;
      FETCH get_transactions BULK COLLECT INTO intrastat_transaction_tab_;
      CLOSE get_transactions;
   END IF;
   
   IF (intrastat_transaction_tab_.COUNT > 0) THEN
      FOR i_ IN intrastat_transaction_tab_.FIRST..intrastat_transaction_tab_.LAST LOOP
         site_rec_              := Site_API.Get(intrastat_transaction_tab_(i_).contract);
         company_country_       := Company_Address_API.Get_Country_Db(company_,site_rec_.delivery_address);
         
          IF (intrastat_transaction_tab_(i_).source_ref_type = 'SHIPMENT_ORDER' AND
            (intrastat_transaction_tab_(i_).transaction_code IN ('SHIPODWHS+','SHIPODWHS-','UNR-SHPODW','UND-SHPODW'))) THEN     
               $IF (Component_Shipod_SYS.INSTALLED) $THEN
                  Shipment_Order_API.Get_Send_Rece_Contract_Country(dummy_txt_, sender_country_code_,receiver_contract_,receiver_country_code_,intrastat_transaction_tab_(i_).source_ref1);
                  IF (intrastat_transaction_tab_(i_).transaction_code IN ('SHIPODWHS-','UND-SHPODW')) THEN    
                     -- shipment order delivery transaction   
                     company_country_ := sender_country_code_;
                  ELSE
                     --shipment order receipt and cancel receipt transactions
                     company_country_ := receiver_country_code_;
                  END IF;  
               $ELSE
                  NULL;
               $END
         END IF;    

         IF company_country_ IN ('MC', 'IM') THEN
            company_country_ := Get_Including_Country(company_country_);
         END IF;
         IF intrastat_transaction_tab_(i_).source_ref_type = 'PUR ORDER' THEN
            IF intrastat_transaction_tab_(i_).transaction_code IN ('PURDIR','INTPURDIR') THEN
               order_cnt_ := order_cnt_ + 1;
               customer_order_tab_(order_cnt_) := intrastat_transaction_tab_(i_).transaction_id;            
            ELSE
               -- gelr:italy_intrastat, Added Consume from Consignment Stock.
               IF ((NOT ((intrastat_transaction_tab_(i_).transaction_code IN ('SCPCREDIT', 'SCPCREDCOR', 'CO-SCPCRED', 'CO-SCPCREC', 'NSCPCREDIT', 'NSCPCRECOR')) AND (company_country_ != 'GB'))) OR
                   (intrastat_transaction_tab_(i_).transaction_code = 'COSUPCONSM' AND italy_intrastat_enabled_ ))THEN
                  IF (intrastat_transaction_tab_(i_).transaction_code != 'OWNTRANOUT') THEN
                     purchase_cnt_ := purchase_cnt_ + 1;
                     purchase_order_tab_(purchase_cnt_) := intrastat_transaction_tab_(i_).transaction_id;
                  END IF;
               END IF;
            END IF;
         ELSE
            custorder_or_stock_ := TRUE;
            intrastat_exempt_db_   := NVL(Company_Address_Deliv_Info_API.Get_Intrastat_Exempt_Db(company_,site_rec_.delivery_address),'INCLUDE');
            
            IF (intrastat_exempt_db_ ='INCLUDE') THEN                                         
               IF (NVL(company_country_,chr(32)) = NVL(country_code_,chr(32))) THEN
                  -- order types for order: customer order and return material authorization.
                  IF (intrastat_transaction_tab_(i_).source_ref_type IN ('CUST ORDER', 'RMA')) THEN
                     order_cnt_ := order_cnt_ + 1;
                     customer_order_tab_(order_cnt_) := intrastat_transaction_tab_(i_).transaction_id;
                  ELSIF (intrastat_transaction_tab_(i_).source_ref_type IN ('PROJECT_DELIVERABLES','SHIPMENT_ORDER')) THEN
                     shipment_cnt_ := shipment_cnt_ + 1;
                     shipment_tab_(shipment_cnt_) := intrastat_transaction_tab_(i_).transaction_id;
                  ELSE
                     stock_cnt_ := stock_cnt_ + 1;
                     stock_movement_tab_(stock_cnt_) := intrastat_transaction_tab_(i_).transaction_id;
                  END IF; 
               ELSIF ((NVL(company_country_,chr(32)) != NVL(country_code_,chr(32))) AND
                      (Check_Tax_Registration_Exist___(company_, country_code_, to_invoice_date_ ) AND 
                       intrastat_transaction_tab_(i_).transaction_code IN ('PODIRSH')))THEN
                  -- Mainly handle for direct delivery flow when having direct delivery transaction from another EU country.
                  IF (intrastat_transaction_tab_(i_).source_ref_type IN ('CUST ORDER', 'RMA')) THEN
                     order_cnt_ := order_cnt_ + 1;
                     customer_order_tab_(order_cnt_) := intrastat_transaction_tab_(i_).transaction_id;
                  END IF;   
               END IF;
            END IF;
         END IF;
      END LOOP;
   END IF;

   ------------------------------------------------------------------------------
   -- Build statements for dynamic calls to order and purch.
   ------------------------------------------------------------------------------

   --Call PurchIntrastathandling.
   --Do not loop over an empty table.
   $IF (Component_Purch_SYS.INSTALLED) $THEN
   IF  (purchase_cnt_ > 0) THEN
      transaction_info_ := Language_SYS.Translate_Constant(lu_name_,
                           'PROCPURCH: Processing Purchase Transactions...', 
                           language_);
      Transaction_SYS.Log_Progress_Info(transaction_info_);
    
      FOR i_ IN purchase_order_tab_.FIRST..purchase_order_tab_.LAST LOOP                 
         @ApproveTransactionStatement(2012-01-25,GanNLK)
         SAVEPOINT before_purch_;
         
         Purchase_Intrastat_Util_API.Find_Intrastat_Data(intrastat_id_,
                                                         from_date_,
                                                         to_date_,
                                                         to_invoice_date_,
                                                         country_code_,
                                                         language_,
                                                         purchase_order_tab_(i_),
                                                         eu_country_table_,
                                                         transaction_table_ );
                  
         @ApproveTransactionStatement(2012-01-25,GanNLK)
         COMMIT;
      END LOOP;   
   END IF;
   
   transaction_info_ := Language_SYS.Translate_Constant(lu_name_,
                        'PROCNONINVPURCH: Processing Purchase Transactions for non inventory and no parts...', 
                        language_);
   Transaction_SYS.Log_Progress_Info(transaction_info_);
     
   Purchase_Intrastat_Util_API.Intrastat_Purch_Trans_Data(intrastat_id_,
                                                          from_date_,
                                                          to_date_,
                                                          to_invoice_date_,
                                                          company_,
                                                          country_code_,
                                                          language_,
                                                          eu_country_table_,
                                                          transaction_table_ );  
                                                                                                            
   IF (country_code_ = 'GB') THEN
      Purchase_Intrastat_Util_API.Find_Data_From_Credit_Invoice(intrastat_id_,
                                                                from_date_,
                                                                to_date_,
                                                                to_invoice_date_,
                                                                company_,
                                                                country_code_,
                                                                eu_country_table_);      
   END IF;  
   
   -- gelr:italy_intrastat, start
   IF (italy_intrastat_enabled_) THEN
      Purchase_Intrastat_Util_API.Find_Additional_Italy_Data(intrastat_id_,
                                                            from_date_,
                                                            to_date_,
                                                            to_invoice_date_,
                                                            company_,
                                                            country_code_,
                                                            language_,
                                                            eu_country_table_ );
   END IF;
   -- gelr:italy_intrastat, end
   $END
      
   -- If purchase transactions exist, error message will be pop up after creating Intrastat with
   -- PO transactions, since the error message will be valid only for CO and stock transactions
   IF (po_transactions_ AND custorder_or_stock_) THEN
      -- All sites must be connected to a country in order to select accurate CO and stock transactions
      IF (Check_Site_Country(company_) = 'TRUE') THEN
         RAISE po_transactions_only;
      END IF;
   END IF;

   --Call OrderIntrastathandling.
   $IF (Component_Order_SYS.INSTALLED) $THEN
      IF (order_cnt_ > 0) THEN
         transaction_info_ := Language_SYS.Translate_Constant(lu_name_, 
                              'PROCORDER: Processing Customer Order Transactions...',
                              language_);
         Transaction_SYS.Log_Progress_Info(transaction_info_);
         
         FOR i_ IN customer_order_tab_.FIRST..customer_order_tab_.LAST LOOP
            @ApproveTransactionStatement(2012-01-25,GanNLK)
            SAVEPOINT before_order_;              
                     
              Customer_Order_Intrastat_API.Find_Intrastat_Data(intrastat_id_,
                                                               from_date_,
                                                               to_date_,
                                                               to_invoice_date_,
                                                               company_,
                                                               country_code_,
                                                               language_,
                                                               customer_order_tab_(i_),
                                                               eu_country_table_,
                                                               transaction_table_ );
            
            @ApproveTransactionStatement(2012-01-25,GanNLK)
            COMMIT;
         END LOOP;   
      END IF;
      -- only for country UK
      IF (country_code_ = 'GB') THEN
         -- collect the intrastat lines from credit invoices which are havin RMA received
         -- for the given period.      
         Customer_Order_Intrastat_API.Find_Data_From_Credit_Invoice(intrastat_id_,
                                                                    from_date_,
                                                                    to_date_,
                                                                    to_invoice_date_,
                                                                    company_,
                                                                    country_code_,
                                                                    eu_country_table_);         
      END IF;
   $END


   --Call InventIntrastathandling
   IF (stock_cnt_ > 0) THEN
      transaction_info_ := Language_SYS.Translate_Constant(lu_name_, 
                           'PROCINVENT: Processing Inventory Transactions...', 
                           language_);
      Transaction_SYS.Log_Progress_Info(transaction_info_);
      FOR i_ IN stock_movement_tab_.FIRST..stock_movement_tab_.LAST LOOP
         OPEN inv_trans(stock_movement_tab_(i_));
         FETCH inv_trans INTO part_rec_;
         CLOSE inv_trans;
         @ApproveTransactionStatement(2012-01-25,GanNLK)
         SAVEPOINT before_invent_;
         Find_Intrastat_Data___ (g_processinfoflag_,
                                 intrastat_id_,
                                 from_date_,
                                 to_date_,
                                 country_code_,
                                 language_,
                                 part_rec_.transaction_id,
                                 part_rec_.transaction_code,
                                 part_rec_.source_ref_type,
                                 part_rec_.contract,
                                 part_rec_.part_no,
                                 part_rec_.configuration_id,
                                 part_rec_.lot_batch_no,
                                 part_rec_.serial_no,
                                 part_rec_.source_ref1,
                                 part_rec_.source_ref2,
                                 part_rec_.source_ref3,
                                 part_rec_.source_ref4,
                                 Inventory_Transaction_Cost_API.Get_Sum_Unit_Cost(
                                                                            part_rec_.transaction_id),
                                 part_rec_.direction,
                                 part_rec_.quantity,
                                 part_rec_.qty_reversed,
                                 part_rec_.reject_code,
                                 part_rec_.date_applied,
                                 part_rec_.userid,
                                 eu_country_table_,
                                 transaction_table_ );
         @ApproveTransactionStatement(2012-01-25,GanNLK)
         COMMIT;
      END LOOP;
   END IF;
   
   $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
   IF (shipment_cnt_ > 0) THEN
      transaction_info_ := Language_SYS.Translate_Constant(lu_name_, 
                              'PROCSHIPMENT: Processing Shipment Transactions...',
                              language_);
         Transaction_SYS.Log_Progress_Info(transaction_info_);         
         
      FOR i_ IN shipment_tab_.FIRST..shipment_tab_.LAST LOOP
         @ApproveTransactionStatement(2020-02-11,ErFelk)
         SAVEPOINT before_shpmnt_;              
                     
         Shipment_Intrastat_API.Find_Intrastat_Data(intrastat_id_,
                                                    from_date_,
                                                    to_date_,
                                                    to_invoice_date_,
                                                    company_,
                                                    country_code_,
                                                    language_,
                                                    receiver_contract_,
                                                    shipment_tab_(i_),
                                                    eu_country_table_,
                                                    transaction_table_ );
            
            @ApproveTransactionStatement(2020-02-11,ErFelk)
            COMMIT;
      END LOOP;
   END IF;
   $END
   
   -- Clear the PL/SQL tables to free the memory used for this session.
   Remove_Eu_Entries___(eu_country_table_);
   Remove_Transaction_Entries___(transaction_table_);

   -- update status
   Intrastat_API.Set_Released(intrastat_id_);

   -- Intrastat process finished
   transaction_info_ := Language_SYS.Translate_Constant(lu_name_,
                        'FINISHINTRASTAT: Created Intrastat :P1.',
                        language_, TO_CHAR(intrastat_id_));
   Transaction_SYS.Log_Progress_Info(transaction_info_);

EXCEPTION
   WHEN po_transactions_only THEN
      IF intrastat_id_ IS NOT NULL THEN
         info_ := Language_SYS.Translate_Constant(lu_name_,
                                                  'SITEMISSINGCOUNTRY: All sites for company :P1 are not connected to a country.',
                                                  language_,
                                                  company_);
         Transaction_SYS.Set_Status_Info(info_);

         transaction_info_ := Language_SYS.Translate_Constant(lu_name_,
                                                              'FINISHINTRASTAT: Created Intrastat :P1.',
                                                              language_, 
                                                              TO_CHAR(intrastat_id_));
         Transaction_SYS.Log_Progress_Info(transaction_info_);
         Check_Process_Info(g_processinfoflag_, intrastat_id_);
         -- Update status
         Intrastat_API.Set_Released(intrastat_id_);
         @ApproveTransactionStatement(2012-01-25,GanNLK)
         COMMIT;
      END IF;

   WHEN OTHERS THEN
      @ApproveTransactionStatement(2012-01-25,GanNLK)
      ROLLBACK;
      IF intrastat_id_ IS NOT NULL THEN
         Check_Process_Info(g_processinfoflag_, intrastat_id_);
         --update status
         Intrastat_API.Set_Released(intrastat_id_);
         @ApproveTransactionStatement(2012-01-25,GanNLK)
         COMMIT;
      END IF;
      Error_SYS.Record_General(lu_name_, 'TRANS_ERROR: Error when fetching transactions for Intrastat :P1. The job is cancelled. '|| SQLERRM, to_char(intrastat_id_));
END Start_Intrastat_Process_Priv__;
   
PROCEDURE Consolidate_Intrastat__ (
   attr_ IN VARCHAR2 )
IS
   company_                VARCHAR2(20);
   country_code_           VARCHAR2(3);
   from_date_              DATE;
   to_date_                DATE;
   to_invoice_date_        DATE;   
   new_intrastat_id_       NUMBER;
   ptr_                    NUMBER := NULL;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   intrastat_ids_          VARCHAR2(32000);
   transaction_info_       VARCHAR2(2000);
   consolidation_flag_db_  VARCHAR2(5); 
   language_               VARCHAR2(4) := Fnd_Session_API.Get_Language;   
   valid_intrastat_id_tab_ Intrastat_Id_Tab_Type;      
BEGIN
   
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'COMPANY') THEN
         company_ := value_;
         Company_Finance_API.Exist(company_);
      ELSIF (name_ = 'COUNTRY_CODE') THEN
         country_code_ := value_;
         Iso_Country_API.Exist(country_code_);
      ELSIF (name_ = 'FROM_DATE') THEN
         from_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TO_DATE') THEN
         to_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TO_INVOICE_DATE') THEN
         to_invoice_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'CONSOLIDATION_FLAG_DB') THEN
         consolidation_flag_db_ := value_;
      ELSIF (name_ = 'INTRASTAT_IDS') THEN
         intrastat_ids_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
      
   Get_Valid_Intrastat_Ids___(valid_intrastat_id_tab_, intrastat_ids_, from_date_, to_date_, country_code_);
   
   IF (valid_intrastat_id_tab_.COUNT > 0) THEN
      -- Create Header for Intrastat Report the method returns intrastat_id
      Intrastat_API.New_Intrastat_Header(new_intrastat_id_, company_, country_code_, from_date_, to_date_, to_invoice_date_);
      Intrastat_API.Reset_Consolidation_Flag(new_intrastat_id_, consolidation_flag_db_);
      
      FOR i_ IN valid_intrastat_id_tab_.FIRST..valid_intrastat_id_tab_.LAST LOOP 
         Intrastat_Line_API.Consolidate_Intrastat_Lines(valid_intrastat_id_tab_(i_), new_intrastat_id_);
      END LOOP;   
   END IF;
   
   -- Clear the PL/SQL tables to free the memory used for this session.
   Remove_Intrastat_Entries___(valid_intrastat_id_tab_);   

   -- update status
   Intrastat_API.Set_Released(new_intrastat_id_);

   -- Intrastat process finished
   transaction_info_ := Language_SYS.Translate_Constant(lu_name_,
                        'FINISHCONSOLIDATEINTRASTAT: Created Consolidation Intrastat :P1.',
                        language_, TO_CHAR(new_intrastat_id_));
                           
   Transaction_SYS.Log_Progress_Info(transaction_info_);

END Consolidate_Intrastat__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Site_Country
--   Checks if all sites for the selected company are connected to a country.
--   If not, processing data for the Intrastat report can be incomplete.
--   Returns 'TRUE' if any site in the company is not connected to a country.
FUNCTION Check_Site_Country (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- Note: check if site is connected to a delivery adress
   -- Note: check if delivery adress is connected to a country
   -- Note: Returns 'FALSE' if OK, 'TRUE' if any site for the company is not connected to a country.
   
   address_array_  Site_API.SITE_ADDRESS_INFO_TYPE;
   country_        VARCHAR2(200);
   dummy_          NUMBER;

BEGIN
   Site_API.Get_Del_Addr_By_Company(dummy_, address_array_, company_);
   IF (dummy_ != -1 ) THEN
      FOR i IN 0..dummy_ LOOP
         BEGIN
            IF (address_array_(i).delivery_address IS NULL ) THEN
               RETURN 'TRUE';
            ELSE
               country_ := Company_Address_Api.Get_Country(company_,address_array_(i).delivery_address);
               IF (country_ IS NULL) THEN
                  RETURN 'TRUE';
               END IF;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RETURN 'TRUE';
         END;
      END LOOP; 
      RETURN 'FALSE';
   END IF;
   RETURN 'TRUE';
END Check_Site_Country;


-- Start_Intrastat_Process
--   This operation will start the process for fetching data for Intrastat
--   report as a deferred job per chosen country, company and interval.
PROCEDURE Start_Intrastat_Process (
   company_         IN VARCHAR2,
   country_code_    IN VARCHAR2,
   from_date_       IN DATE,
   to_date_         IN DATE,
   to_invoice_date_ IN DATE )
IS
   attr_               VARCHAR2(2000);
   batch_desc_         VARCHAR2(200);
BEGIN

   -- Verify that the correct parameters were passed.
   Company_Finance_API.Exist(company_);
   Iso_Country_API.Exist(country_code_);

   IF (EU_Member_API.Encode(Iso_Country_API.Get_EU_Member(country_code_)) !='Y') THEN
      Error_SYS.Record_General(lu_name_, 'NOEUCOUNTRY: Country for Intrastat report must be a EU-country.');
   END IF;
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('COUNTRY_CODE', country_code_, attr_);
   Client_SYS.Add_To_Attr('FROM_DATE', from_date_, attr_);
   Client_SYS.Add_To_Attr('TO_DATE', to_date_, attr_);
   Client_SYS.Add_To_Attr('TO_INVOICE_DATE', to_invoice_date_, attr_);

   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'STARTINTRASTAT: Start Intrastat Process.');
   Transaction_SYS.Deferred_Call('INTRASTAT_MANAGER_API.Start_Intrastat_Process_Priv__', attr_, batch_desc_);

END Start_Intrastat_Process;

-- Start_Consolidate_Intrastat
--   This operation will start the process for fetching data for Consolidate Intrastat
--   report as a deferred job per chosen country, company and interval.
PROCEDURE Start_Consolidate_Intrastat (
   company_         IN VARCHAR2,
   country_code_    IN VARCHAR2,
   from_date_       IN DATE,
   to_date_         IN DATE,
   to_invoice_date_ IN DATE,
   intrastat_ids_   IN VARCHAR2 )
IS
   attr_               VARCHAR2(2000);
   batch_desc_         VARCHAR2(200);
BEGIN

   -- Verify that the correct parameters were passed.
   Company_Finance_API.Exist(company_);
   Iso_Country_API.Exist(country_code_);

   IF (EU_Member_API.Encode(Iso_Country_API.Get_EU_Member(country_code_)) !='Y') THEN
      Error_SYS.Record_General(lu_name_, 'NOEUCOUNTRY: Country for Intrastat report must be a EU-country.');
   END IF;
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('COUNTRY_CODE', country_code_, attr_);
   Client_SYS.Add_To_Attr('FROM_DATE', from_date_, attr_);
   Client_SYS.Add_To_Attr('TO_DATE', to_date_, attr_);
   Client_SYS.Add_To_Attr('TO_INVOICE_DATE', to_invoice_date_, attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_IDS', intrastat_ids_, attr_);
   Client_SYS.Add_To_Attr('CONSOLIDATION_FLAG_DB', 'TRUE', attr_);

   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'STARTINTRASTATCONSOL: Start Consolidate Intrastat Process.');
   Transaction_SYS.Deferred_Call('INTRASTAT_MANAGER_API.Consolidate_Intrastat__', attr_, batch_desc_);

END Start_Consolidate_Intrastat;


-- Check_Process_Info
--   Checks process info on Intrastat header. Sets process info to incomplete
--   if warning message is created.
PROCEDURE Check_Process_Info (
   process_info_flag_ IN OUT BOOLEAN,
   intrastat_id_      IN NUMBER )
IS
BEGIN
   --check if a warning was created earlier in the job
   IF NOT process_info_flag_ THEN
         process_info_flag_ := TRUE;
         --only make this call if the flag has not been set earlier
         Intrastat_API.Set_Process_Info(intrastat_id_);
   END IF;
END Check_Process_Info;


-- Eu_Country
--   Returns TRUE if the given country is a member of the EU, FALSE otherwise.
--   The check is made against a PL/SQL table created during the execution of
--   the Intrastat process, hence this method will always return FALSE if it
--   is used at any other time.
FUNCTION Eu_Country (
   country_code_     IN VARCHAR2,
   eu_country_table_ IN eu_country_type   ) RETURN BOOLEAN
IS  
BEGIN
   RETURN Eu_Country___(country_code_, eu_country_table_);
END Eu_Country;


-- Get_Notc
--   Returns the Nature of Transaction Code (NoTC) and Intrastat direction
--   for a given inventory transaction.
PROCEDURE Get_Notc (
   notc_                   OUT VARCHAR2,
   intrastat_direction_db_ OUT VARCHAR2,
   transaction_table_      IN  mpccom_transaction_type,
   transaction_code_       IN  VARCHAR2 )
IS  
BEGIN
   Get_Notc___(notc_, intrastat_direction_db_, transaction_table_, transaction_code_);    
END Get_Notc;


-- Get_Report_Name
--   Returns the name of the country specific Intrastat report view (if it is available).
--   Otherwise nothing is returned.
@UncheckedAccess
FUNCTION Get_Report_Name (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   package_name_ VARCHAR2(100);
   view_name_    VARCHAR2(100);
BEGIN
   -- Check for installed country specific report package
   package_name_ := 'INTRASTAT_'||country_code_||'_RPI';
   Trace_SYS.Message('Checking if country specific report package '||UPPER(package_name_)
                     || ' is installed.');
   IF NOT Transaction_SYS.Package_Is_Active(package_name_) THEN
      -- The specifc localized report package was not installed.
      -- This should never happen if the installation was correct.
      -- Return an empty view name.
      view_name_ := NULL;
   ELSE
      view_name_ := 'INTRASTAT_'||country_code_||'_REP';
      Trace_SYS.Message('The package was installed. Returning report view name: '
                        ||view_name_);
   END IF;
   RETURN view_name_;
END Get_Report_Name;


@UncheckedAccess
FUNCTION Get_Including_Country (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   including_country_   VARCHAR2(3);
BEGIN
   including_country_ := country_code_;
   IF country_code_ = 'MC' THEN
      including_country_ := 'FR';
   ELSIF country_code_ = 'IM' THEN
      including_country_ := 'GB';
   END IF;   
   RETURN including_country_;
END Get_Including_Country;




