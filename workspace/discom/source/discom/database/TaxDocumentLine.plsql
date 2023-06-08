-----------------------------------------------------------------------------
--
--  Logical unit: TaxDocumentLine
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220817  MaEelk  SCDEV-13090, Added Get_Inventory_Valuation_Met_Db to get the Inventory Valuation Method of the part connected to the Tax Document Line.
--  220729  MaEelk  SCDEV-12972, Added Tax Code to Tax Document Line
--  220726  MaEelk  SCDEV-12898, Modified Calculate_Amounts_And_Taxes and made a check against Inventory Sales Part Shipment Lines.
--  220725  MalLlk  SCDEV-12482, Added method Get_Inventory_Transaction_Date().
--  220724  MaEelk  SCDEV-12851, Replaced the usage of shipment_line_tab.source_part_no with shipment_line_tab.inventory_part_no, Used Inventory Part Description instead of Source Part Description,
--  220719  MaEelk  SCDEV-12653, Supported Non Deductible Tax in incoming Tax Document.
--  220713  MaEelk  SCDEV-11672, Added Calculate_Amounts_And_Taxes to fetch taxes either from Tax Calculation Structure or Brazil Avalara Tax Fetching logic.
--  220713          Calculated Total non-deductible percentage to the Tax Document Line. Added validation logic for Tax  Parameters when calculating amounts and Taxes.
--  220610  MaEelk  SCDEV-6571, Added Get_External_Tax_Info to fetch Avalara Brazil Tax Information.
--  220412  NiRalk  SCDEV-8136, Updated Create_Tax_Document_Line___ with adding Transfer_Tax_lines method.
--  220404  ApWilk  SCDEV-8105, Modified Get_Tax_Documnt_Line_Info___,Tax_Document_Line_Rec and Create_Tax_Document_Line___ to fix minor issues found when testing.
--  220401  ApWilk  SCDEV-8668, Modified Get_Part_Cost_By_Source_Ref___() to increase the variable length of receiver_contract and sender_contract.
--  220329  ApWilk  SCDEV-8105, Modified Tax_Document_Line_Rec, Create_Tax_Document_Line___, and added Create_Inbound_Tax_Doc_Line to handle creation logic for the Inbound Tax Document.
--  220329  HasTlk  SCDEV-8221, Added IgnoreUnitTest annotation to Modify_Tax_Info method.
--  220323  ApWilk  SCDEV-8668, Modified Get_Part_Cost_By_Source_Ref___() to adjust the logic to be supported with transactions between same sites and different sites.
--  220303  Hastlk  SCDEV-7872, Added new method Modify_Tax_Info to update the Tax amounts in Tax Document Line.
--  220201  ApWilk  SC21R2-7304, Modified Get_Part_Cost_By_Source_Ref___() to find the inventory transaction cost based on the part cost level.
--  220127  ApWilk  SC21R2-7290, Modified Get_Part_Cost_By_Source_Ref___() to be supported with the transaction code 'SHIPODWHS-' when fetching the inventory part transaction cost.
--  220118  ApWilk  SC21R2-5566, Added IgnoreUnitTest annotation to the methods Check_Tax_Calc_Struct_Ref___, Get_Next_Tax_Document_Line_No___, Create_Tax_Document_Line___,
--  220118          Get_Shipment_Line_Info___, Get_Part_Cost_By_Source_Ref___, Update___, Create_Outbound_Tax_Doc_Line, Get_Tax_Document_Line_Info, Get_Quantity and Get_Amounts.     
--  220118  MaEelk  SC21R2-5576, Added IgnoreUnitTest annotation to Create_Tax_Document_Line___
--  220117  NiRalk  SC21R2-7056, Added new procedure Get_Amounts().
--  220112  ApWilk  SC21R2-6311, Removed TaxAmount, GrossAmount, TaxAmountAccCurr and TaxAmountParallelCurr from method Create_Tax_Document_Line___().
--  220104  MalLlk  SC21R2-5593, Override Update___ to add tax lines when changing tax calc structure id.
--  220104          Renamed the method Create_Tax_Line___ to Create_Tax_Document_Line___.
--  211217  ApWilk  SC21R2-6794, Modified Create_Tax_Line___() to support brazilian specific attributes.
--  211214  ApWilk  SC21R2-6311, Added new method Get_Part_Cost_By_Source_Ref___(), modified Tax_Document_Line_Rec and Create_Tax_Line___() to retrieve the part price and calculate the net amount.
--  211210  ApWilk  SC21R2-5562, Added the function Get_Tax_Document_Line_Info(), Get_Shipment_Line_Info___() and relevant record types.
--  211208  MaEelk  SC21R2-6474, Modified Tax_Document_Line_Rec and Get_Next_Tax_Document_Line_No___ to support the creation of
--                  Tax Document Lines
--  211119  ApWilk  SC21R2-5562, Added logic to create the Outound Tax Document Line originated from a Shipment Order.
-----------------------------------------------------------------------------

layer Core;
-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Tax_Document_Line_Rec IS RECORD (
   source_ref1                tax_document_line_tab.source_ref1%TYPE,
   source_ref2                tax_document_line_tab.source_ref2%TYPE,
   source_ref3                tax_document_line_tab.source_ref3%TYPE,
   source_ref4                tax_document_line_tab.source_ref4%TYPE, 
   part_no                    VARCHAR2(25),
   part_description           tax_document_line_tab.part_description%TYPE,
   original_source_ref1       VARCHAR2(50),
   original_source_ref2       VARCHAR2(50),
   original_source_ref3       VARCHAR2(50),
   original_source_ref4       VARCHAR2(50),   
   qty_shipped                NUMBER,
   original_source_ref_type   VARCHAR2(20),
   price                      tax_document_line_tab.price%TYPE,
   acquisition_origin         tax_document_line_tab.acquisition_origin%TYPE,
   acquisition_reason_id      tax_document_line_tab.acquisition_reason_id%TYPE,
   statistical_code           tax_document_line_tab.statistical_code%TYPE,
   business_operation         tax_document_line_tab.business_operation%TYPE,
   net_amount                 tax_document_line_tab.net_amount%TYPE,
   tax_code                   tax_document_line_tab.tax_code%TYPE,
   tax_calc_structure_id      tax_document_line_tab.tax_calc_structure_id%TYPE, 
   tax_amount                 tax_document_line_tab.tax_amount%TYPE, 
   gross_amount               tax_document_line_tab.gross_amount%TYPE, 
   tax_amount_acc_curr        tax_document_line_tab.tax_amount_acc_curr%TYPE, 
   tax_amount_parallel_curr   tax_document_line_tab.tax_amount_parallel_curr%TYPE,
   tax_document_line_text     tax_document_line_tab.tax_document_line_text%TYPE,
   non_ded_tax_percentage     tax_document_line_tab.non_ded_tax_percentage%TYPE
   );

TYPE Tax_Doc_Line_Tab IS TABLE OF Tax_Document_Line_Rec
         INDEX BY BINARY_INTEGER;
         
TYPE Tax_Document_Line_Info_Rec IS RECORD (
   part_no                    VARCHAR2(25),
   qty                        NUMBER,
   unit_meas                  VARCHAR2(10)
);
   
TYPE Tax_Document_Line_Info_Arr IS TABLE OF Tax_Document_Line_Info_Rec; 
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@IgnoreUnitTest TrivialFunction
PROCEDURE Check_Tax_Calc_Struct_Ref___ (
   newrec_ IN OUT tax_document_line_tab%ROWTYPE )
IS
BEGIN
   Tax_Calc_Structure_API.Validate_Tax_Structure_State(newrec_.company, newrec_.tax_calc_structure_id);
END Check_Tax_Calc_Struct_Ref___;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Next_Tax_Document_Line_No___ (
   company_           IN VARCHAR2,
   tax_document_no_   IN NUMBER ) RETURN NUMBER
IS
   CURSOR max_tax_line_no IS
      SELECT MAX(line_no)
      FROM   tax_document_line_tab
      WHERE  company = company_
      AND    tax_document_no = tax_document_no_;
      
   max_tax_line_no_ NUMBER;
BEGIN
   OPEN  max_tax_line_no;
   FETCH max_tax_line_no INTO max_tax_line_no_;
   CLOSE max_tax_line_no;
   
   RETURN NVL(max_tax_line_no_, 0) + 1;
   
END Get_Next_Tax_Document_Line_No___;

@IgnoreUnitTest NoOutParams
PROCEDURE Create_Tax_Document_Line___ (
   company_                IN VARCHAR2,
   tax_document_no_        IN NUMBER,
   source_ref1_            IN VARCHAR2,
   tax_document_line_tab_  IN Tax_Doc_Line_Tab,
   originating_tax_doc_no_ IN NUMBER)
IS
   newrec_              tax_document_line_tab%ROWTYPE;
   tax_doc_rec_         Tax_Document_API.Public_Rec;
   contract_            VARCHAR2(5);
   inv_part_rec_        Inventory_Part_API.Public_Rec;
   direction_           tax_document_tab.direction%TYPE;
BEGIN
   tax_doc_rec_         := Tax_Document_API.Get(company_, tax_document_no_);
   contract_            := tax_doc_rec_.contract;
   direction_           := tax_doc_rec_.direction;
   IF(tax_document_line_tab_.COUNT > 0) THEN
      FOR i IN tax_document_line_tab_.FIRST..tax_document_line_tab_.LAST LOOP 
         newrec_.company                     := company_;
         newrec_.tax_document_no             := tax_document_no_;
         newrec_.line_no                     := Get_Next_Tax_Document_Line_No___(company_, tax_document_no_ );
         newrec_.source_ref1                 := source_ref1_;
         newrec_.source_ref2                 := tax_document_line_tab_(i).source_ref2;
         newrec_.source_ref3                 := tax_document_line_tab_(i).source_ref3;
         newrec_.source_ref4                 := tax_document_line_tab_(i).source_ref4;
         IF(direction_ = Tax_Document_Direction_API.DB_OUTBOUND) THEN
            newrec_.price                       := 0;  
            newrec_.part_description            := Inventory_Part_API.Get_Description(contract_, tax_document_line_tab_(i).part_no);
            inv_part_rec_                       := Inventory_Part_API.Get(contract_, tax_document_line_tab_(i).part_no);                                                                        
            newrec_.acquisition_origin          := inv_part_rec_.acquisition_origin;
            newrec_.acquisition_reason_id       := inv_part_rec_.acquisition_reason_id;
            newrec_.statistical_code            := inv_part_rec_.statistical_code;
            newrec_.net_amount                  := newrec_.price * tax_document_line_tab_(i).qty_shipped;
         ELSIF(direction_ = Tax_Document_Direction_API.DB_INBOUND) THEN
            newrec_.price                       := tax_document_line_tab_(i).price; 
            newrec_.part_description            := tax_document_line_tab_(i).part_description;
            newrec_.acquisition_origin          := tax_document_line_tab_(i).acquisition_origin;
            newrec_.acquisition_reason_id       := tax_document_line_tab_(i).acquisition_reason_id;
            newrec_.statistical_code            := tax_document_line_tab_(i).statistical_code;
            newrec_.business_operation          := tax_document_line_tab_(i).business_operation;
            newrec_.net_amount                  := tax_document_line_tab_(i).net_amount;
            newrec_.tax_code                    := tax_document_line_tab_(i).tax_code;
            newrec_.tax_calc_structure_id       := tax_document_line_tab_(i).tax_calc_structure_id;       
            newrec_.tax_amount                  := tax_document_line_tab_(i).tax_amount;                  
            newrec_.gross_amount                := tax_document_line_tab_(i).gross_amount;                
            newrec_.tax_amount_acc_curr         := tax_document_line_tab_(i).tax_amount_acc_curr;         
            newrec_.tax_amount_parallel_curr    := tax_document_line_tab_(i).tax_amount_parallel_curr;
            newrec_.tax_document_line_text      := tax_document_line_tab_(i).tax_document_line_text;
            newrec_.non_ded_tax_percentage      := tax_document_line_tab_(i).non_ded_tax_percentage;
         END IF;         
         New___(newrec_);
         IF (direction_ = Tax_Document_Direction_API.DB_INBOUND) THEN
            Tax_Handling_Discom_Util_API.Transfer_Tax_lines(company_, 
                                                           Tax_Source_API.DB_TAX_DOCUMENT_LINE,
                                                           originating_tax_doc_no_,
                                                           newrec_.line_no,
                                                           '*',
                                                           '*',
                                                           '*',
                                                           newrec_.tax_document_no);
         END IF;
      END LOOP;   
   ELSE
      Error_SYS.Record_General(lu_name_, 'TAXLINENOTCREATED: Tax Document Line is not Created');
   END IF;   
END Create_Tax_Document_Line___;

@IgnoreUnitTest TrivialFunction
@DynamicComponentDependency SHPMNT
PROCEDURE Get_Shipment_Line_Info___ (
   part_no_    OUT VARCHAR2,
   qty_        OUT VARCHAR2,
   unit_meas_  OUT VARCHAR2,
   order_ref1_ IN  VARCHAR2,
   order_ref2_ IN  VARCHAR2)
IS  
   shipment_rec_      Shipment_Line_API.Public_Rec;  
BEGIN
   shipment_rec_     := Shipment_Line_API.Get(order_ref1_, order_ref2_);
   part_no_          := shipment_rec_.inventory_part_no;
   qty_              := shipment_rec_.qty_shipped;
   unit_meas_        := shipment_rec_.source_unit_meas;   
END Get_Shipment_Line_Info___; 

@IgnoreUnitTest TrivialFunction
@UncheckedAccess
FUNCTION Get_Part_Cost_By_Source_Ref___ (
   company_             IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   transaction_code_    IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2) RETURN NUMBER
IS
   part_cost_                  NUMBER;
   rounding_                   NUMBER; 
BEGIN
   rounding_               := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
      
   part_cost_ := Inventory_Transaction_Hist_API.Get_Weighted_Average_Part_Cost(source_ref_type_db_, 
                                                                                 source_ref1_, 
                                                                                 source_ref2_, 
                                                                                 source_ref3_, 
                                                                                 source_ref4_, 
                                                                                 source_ref5_, 
                                                                                 transaction_code_, 
                                                                                 contract_, 
                                                                                 part_no_);     
   RETURN NVL(ROUND(part_cost_, rounding_),0); 
END  Get_Part_Cost_By_Source_Ref___;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Tax_Documnt_Line_Info___ (
   company_          IN  tax_document_tab.company%TYPE,
   tax_document_no_  IN  tax_document_tab.tax_document_no%TYPE ) RETURN Tax_Doc_Line_Tab
IS
   tax_document_line_tab_  Tax_Doc_Line_Tab;
   i_                      INTEGER := 0;
   CURSOR get_line_info IS
      SELECT part_description, source_ref2, source_ref3, source_ref4, price, acquisition_origin, acquisition_reason_id, statistical_code, business_operation, net_amount,
      tax_code, tax_calc_structure_id, tax_amount, gross_amount, tax_amount_acc_curr, tax_amount_parallel_curr, tax_document_line_text, non_ded_tax_percentage
      FROM tax_document_line_tab
      WHERE company = company_
      AND tax_document_no = tax_document_no_;
BEGIN
   FOR rec_ IN get_line_info LOOP
      i_ := i_ + 1;
      tax_document_line_tab_(i_).source_ref2                 := rec_.source_ref2;
      tax_document_line_tab_(i_).source_ref3                 := rec_.source_ref3;
      tax_document_line_tab_(i_).source_ref4                 := rec_.source_ref4;
      tax_document_line_tab_(i_).part_description            := rec_.part_description;
      tax_document_line_tab_(i_).price                       := rec_.price;
      tax_document_line_tab_(i_).acquisition_origin          := rec_.acquisition_origin;
      tax_document_line_tab_(i_).acquisition_reason_id       := rec_.acquisition_reason_id;
      tax_document_line_tab_(i_).statistical_code            := rec_.statistical_code;
      tax_document_line_tab_(i_).business_operation          := rec_.business_operation;
      tax_document_line_tab_(i_).net_amount                  := rec_.net_amount;
      tax_document_line_tab_(i_).tax_code                    := rec_.tax_code;
      tax_document_line_tab_(i_).tax_calc_structure_id       := rec_.tax_calc_structure_id;      
      tax_document_line_tab_(i_).tax_amount                  := rec_.tax_amount;
      tax_document_line_tab_(i_).gross_amount                := rec_.gross_amount;
      tax_document_line_tab_(i_).tax_amount_acc_curr         := rec_.tax_amount_acc_curr;
      tax_document_line_tab_(i_).tax_amount_parallel_curr    := rec_.tax_amount_parallel_curr;
      tax_document_line_tab_(i_).tax_document_line_text      := rec_.tax_document_line_text;
      tax_document_line_tab_(i_).non_ded_tax_percentage      := rec_.non_ded_tax_percentage;
   END LOOP;
   RETURN tax_document_line_tab_;
END Get_Tax_Documnt_Line_Info___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Validate_Tax_Parameters___ (
   line_rec_   IN tax_document_line_tab%ROWTYPE )   
IS
   external_tax_calc_method_    VARCHAR2(50);
   business_transaction_id_     VARCHAR2(20);
BEGIN
   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(line_rec_.company); 

   IF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      IF ((line_rec_.tax_calc_structure_id IS NULL) AND (line_rec_.tax_code IS NULL)) THEN
         Error_SYS.Record_General(lu_name_, 'TAXCALCSTRUCTMISSING: Tax Calculation Structure/Tax Code is missing in one or more Outgoing Tax Document Lines.');   
      END IF;
   ELSIF (external_tax_calc_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
      business_transaction_id_ := Tax_Document_API.Get_Business_Transaction_Id(line_rec_.company, line_rec_.tax_document_no);
      IF (business_transaction_id_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'BUSINESTRANIDMISSING: Business Transaction ID is missing in the Outgoing Tax Document.'); 
      END IF;
      IF ((line_rec_.statistical_code IS NULL) OR (line_rec_.acquisition_origin IS NULL) OR (line_rec_.acquisition_reason_id IS NULL)) THEN
         Error_SYS.Record_General(lu_name_, 'BRPARTATTRIBMISSING: Goods/Service Statistical Code or Acquisition Origin or Acquisition Reason ID is missing in one or more Outgoing Tax Document Lines.');  
      END IF;
   END IF;
END Validate_Tax_Parameters___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@IgnoreUnitTest NoOutParams
PROCEDURE Create_Outbound_Tax_Doc_Line (
   company_                IN VARCHAR2,
   tax_document_no_        IN NUMBER,
   source_ref1_            IN VARCHAR2,
   tax_document_line_tab_  IN Tax_Doc_Line_Tab )
IS   
BEGIN
   Create_Tax_Document_Line___ (company_,
                                tax_document_no_,
                                source_ref1_,
                                tax_document_line_tab_,
                                NULL);
END Create_Outbound_Tax_Doc_Line;

@IgnoreUnitTest NoOutParams
PROCEDURE Create_Inbound_Tax_Doc_Line (
   company_                IN VARCHAR2,
   tax_document_no_        IN NUMBER,
   source_ref1_            IN VARCHAR2,
   originating_tax_doc_no_ IN NUMBER )
IS
   tax_document_line_tab_   Tax_Doc_Line_Tab;   
BEGIN
   tax_document_line_tab_   := Get_Tax_Documnt_Line_Info___(company_, originating_tax_doc_no_);
   Create_Tax_Document_Line___ (company_,
                                tax_document_no_,
                                source_ref1_,
                                tax_document_line_tab_,
                                originating_tax_doc_no_);
   
END Create_Inbound_Tax_Doc_Line;

@IgnoreUnitTest PipelinedFunction
@UncheckedAccess
FUNCTION Get_Tax_Document_Line_Info (
   company_             IN VARCHAR2,
   tax_document_no_     IN NUMBER,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2) RETURN Tax_Document_Line_Info_Arr PIPELINED
IS 
   rec_                 Tax_Document_Line_Info_Rec;
   source_ref_type_     tax_document_tab.source_ref_type%TYPE;
BEGIN
   source_ref_type_  := Tax_Document_API.Get_Source_Ref_Type_Db(company_, tax_document_no_);
   IF(source_ref_type_ IN ('SHIPMENT'))THEN
      $IF Component_Shpmnt_SYS.INSTALLED $THEN  
         Get_Shipment_Line_Info___(rec_.part_no, rec_.qty, rec_.unit_meas, source_ref1_, source_ref2_); 
      $ELSE
         NULL;
      $END     
   END IF;   
   PIPE ROW (rec_);
END Get_Tax_Document_Line_Info;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Quantity (
   company_           IN VARCHAR2,
   tax_document_no_   IN NUMBER,
   line_no_           IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_qty IS
      SELECT qty
      FROM   TAX_DOCUMENT_LINE_INFO
      WHERE  company = company_
      AND    tax_document_no = tax_document_no_
      AND    line_no = line_no_;
      
   quantity_ NUMBER;
BEGIN
   OPEN get_qty;
   FETCH get_qty INTO quantity_;
   CLOSE get_qty;
   
   RETURN quantity_;  
END Get_Quantity;

@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Amounts (
   net_amount_            OUT NUMBER,
   tax_amount_            OUT NUMBER,
   gross_amount_          OUT NUMBER,
   company_               IN  VARCHAR2,
   tax_document_no_       IN  NUMBER)
IS
   CURSOR get_amounts IS
      SELECT SUM(net_amount), SUM(tax_amount), SUM(gross_amount)
      FROM  tax_document_line_tab
      WHERE company = company_
      AND tax_document_no = tax_document_no_;
BEGIN
   OPEN get_amounts;
   FETCH get_amounts INTO net_amount_, tax_amount_, gross_amount_;
   CLOSE get_amounts;
END Get_Amounts;

--Modify_Tax_Info
--Update the Tax amounts in Tax Document Line, by fetching data from Source Tax Item.
@IgnoreUnitTest DMLOperation
PROCEDURE Modify_Tax_Info (
   company_          IN VARCHAR2,
   tax_document_no_  IN NUMBER,
   line_no_          IN NUMBER )
IS
   newrec_                       TAX_DOCUMENT_LINE_TAB%ROWTYPE;
   dummy_                        NUMBER;
   line_non_ded_tax_curr_amount_ NUMBER;

BEGIN
   newrec_                             := Get_Object_By_Keys___(company_, tax_document_no_, line_no_);
   Source_Tax_Item_API.Get_Line_Tax_Code_Info ( dummy_, 
                                                dummy_, 
                                                newrec_.tax_amount, 
                                                newrec_.tax_amount_acc_curr, 
                                                newrec_.tax_amount_parallel_curr, 
                                                line_non_ded_tax_curr_amount_, 
                                                dummy_, 
                                                dummy_, 
                                                company_, 
                                                Tax_Source_API.DB_TAX_DOCUMENT_LINE,
                                                tax_document_no_, 
                                                line_no_, 
                                                '*', 
                                                '*', 
                                                '*');
   newrec_.gross_amount                := newrec_.tax_amount + newrec_.net_amount ;                                             
   newrec_.non_ded_tax_percentage      := (line_non_ded_tax_curr_amount_/newrec_.net_amount)*100;
   Modify___(newrec_);  
END Modify_Tax_Info;


@IgnoreUnitTest TrivialFunction
@UncheckedAccess
PROCEDURE Get_External_Tax_Info (
   quantity_                    OUT NUMBER,
   avalara_brazil_specific_rec_ OUT Tax_Handling_Discom_Util_API.Avalara_Brazil_Specific_Rec,
   company_                     IN  VARCHAR2,
   tax_document_no_             IN  NUMBER,
   line_no_                     IN NUMBER)
IS
   CURSOR get_tax_document_line_info IS
   SELECT tax_document_no, line_no, part_no, part_description, qty, unit_meas, price, acquisition_reason_id, statistical_code, acquisition_origin
   FROM   TAX_DOCUMENT_LINE_INFO
   WHERE  company = company_
   AND    tax_document_no = tax_document_no_
   AND    line_no = line_no_;  
   
   header_rec_    Tax_Document_API.Public_Rec;
   line_info_rec_  get_tax_document_line_info%ROWTYPE;
   
BEGIN
   header_rec_ := Tax_Document_API.Get(company_, tax_document_no_);  

   OPEN get_tax_document_line_info;
   FETCH get_tax_document_line_info INTO line_info_rec_;
   CLOSE get_tax_document_line_info;

   quantity_ := line_info_rec_.qty;

   IF Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_) = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL THEN
      avalara_brazil_specific_rec_.source_ref1               := line_info_rec_.tax_document_no;
      avalara_brazil_specific_rec_.source_ref2               := line_info_rec_.line_no;
      avalara_brazil_specific_rec_.ship_addr_no              := header_rec_.receiver_addr_id;
      avalara_brazil_specific_rec_.doc_addr_no               := header_rec_.document_addr_id;
      avalara_brazil_specific_rec_.document_code             := line_info_rec_.tax_document_no;
      avalara_brazil_specific_rec_.part_no                   := line_info_rec_.part_no;
      avalara_brazil_specific_rec_.part_description          := line_info_rec_.part_description;
      avalara_brazil_specific_rec_.price                     := line_info_rec_.price;
      avalara_brazil_specific_rec_.external_use_type         := Acquisition_Reason_API.Get_External_Use_Type_Db(company_, line_info_rec_.acquisition_reason_id);
      avalara_brazil_specific_rec_.business_transaction_id   := Business_Transaction_Id_API.Get_External_Tax_System_Ref(company_, header_rec_.business_transaction_id);
      avalara_brazil_specific_rec_.statistical_code          := line_info_rec_.statistical_code;
      avalara_brazil_specific_rec_.cest_code                 := Part_Br_Spec_Attrib_API.Get_Cest_Code(line_info_rec_.part_no);
      avalara_brazil_specific_rec_.unit_meas                 := line_info_rec_.unit_meas;
      avalara_brazil_specific_rec_.acquisition_origin        := line_info_rec_.acquisition_origin;
      avalara_brazil_specific_rec_.product_type_classif      := Part_Br_Spec_Attrib_API.Get_Product_Type_Classif_Db(line_info_rec_.part_no);
   END IF;
END Get_External_Tax_Info;

--------------------------------------------------------------------------------------------------------------------
-- Calculate_Amounts_And_Taxes
-- This method is called when delivering a shipment created from a shipment order to move parts between two sites.
-- If the Create Tax Document is enable in the company, it is mandatory to create a Tax Document from the Shipment.
-- When the Shipment is delivered, before creating the INTORDTR transaction, this method will be called and calculate amount and taxes in the Tax Document Line.
-- If there are non deductible taxes connected to the Tax Document Line, The Total Non Deductible Tax Percentage wilbe calculated and sent back
-- so that this Non Deductible Tax Amount  can be abosobed into INTORDTR Transaction.
--------------------------------------------------------------------------------------------------------------------
PROCEDURE  Calculate_Amounts_And_Taxes (
   non_ded_tax_percentage_    OUT NUMBER,
   transaction_code_          IN  VARCHAR2,
   quantity_                  IN  NUMBER,
   source_ref1_               IN  VARCHAR2,
   source_ref2_               IN  VARCHAR2,
   source_ref3_               IN  VARCHAR2,
   source_ref4_               IN  VARCHAR2,
   source_ref5_               IN  VARCHAR2,
   source_ref_type_db_        IN  VARCHAR2,
   recalculate_               IN  BOOLEAN DEFAULT FALSE)
IS
   shipment_line_no_ NUMBER; 
   
   CURSOR get_line_keys_and_non_ded_tax IS
      SELECT tdl.company, tdl.tax_document_no, tdl.line_no, tdl.non_ded_tax_percentage
      FROM   tax_document_line_tab tdl, tax_document_tab td
      WHERE  tdl.source_ref1 = source_ref5_
      AND    tdl.source_ref2 = shipment_line_no_
      AND    tdl.company = td.company
      AND    tdl.tax_document_no = td.tax_document_no
      AND    td.rowstate = 'Preliminary';
      
   company_                   tax_document_line_tab.company%TYPE;
   tax_document_no_           tax_document_line_tab.tax_document_no%TYPE;
   line_no_                   tax_document_line_tab.line_no%TYPE;
   newrec_                    tax_document_line_tab%ROWTYPE;
   dummy_num_                 NUMBER;
   dummy_var_                 VARCHAR2(20);
   non_ded_tax_curr_amount_   NUMBER;

   
BEGIN
   IF(source_ref_type_db_ IN ('SHIPMENT_ORDER')) THEN 
      $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
         shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source (source_ref5_,
                                                                              source_ref1_,
                                                                              source_ref2_,
                                                                              source_ref3_,
                                                                              source_ref4_,
                                                                              source_ref_type_db_);
 
                                                                             
         IF (shipment_line_no_ IS NOT NULL) THEN
            OPEN get_line_keys_and_non_ded_tax;
            FETCH get_line_keys_and_non_ded_tax INTO company_, tax_document_no_, line_no_, non_ded_tax_percentage_;
            CLOSE get_line_keys_and_non_ded_tax; 
            IF (tax_document_no_ IS NOT NULL) THEN
               IF ((non_ded_tax_percentage_ IS NULL) OR recalculate_) THEN
                  newrec_ := Get_Object_By_Keys___(company_, tax_document_no_, line_no_);
                  Validate_Tax_Parameters___(newrec_);

                  newrec_.price := Get_Part_Cost_By_Source_Ref___(newrec_.company,
                                                                  source_ref_type_db_, 
                                                                  source_ref1_, 
                                                                  source_ref2_, 
                                                                  source_ref3_, 
                                                                  source_ref4_, 
                                                                  source_ref5_, 
                                                                  transaction_code_, 
                                                                  Tax_Document_API.Get_Contract(newrec_.company, newrec_.tax_document_no), 
                                                                  Shipment_Line_API.Get_Inventory_Part_No(source_ref5_, shipment_line_no_));     
                  newrec_.net_amount   := newrec_.price * quantity_;

                  -- Create Tax Lines for the Tax Document Line
                  Tax_Handling_Discom_Util_API.Add_Transaction_Tax_Info(newrec_.company, 
                                                                        newrec_.tax_code,
                                                                        newrec_.tax_calc_structure_id, 
                                                                        newrec_.tax_document_no, 
                                                                        newrec_.line_no, 
                                                                        newrec_.price,
                                                                        quantity_,
                                                                        newrec_.net_amount,                                                                      
                                                                        SYSDATE);

                  Source_Tax_Item_API.Get_Line_Tax_Code_Info ( dummy_var_, 
                                                               dummy_var_, 
                                                               newrec_.tax_amount, 
                                                               newrec_.tax_amount_acc_curr, 
                                                               newrec_.tax_amount_parallel_curr, 
                                                               non_ded_tax_curr_amount_, 
                                                               dummy_num_, 
                                                               dummy_num_, 
                                                               newrec_.company, 
                                                               Tax_Source_API.DB_TAX_DOCUMENT_LINE,
                                                               newrec_.tax_document_no, 
                                                               newrec_.line_no, 
                                                               '*', 
                                                               '*', 
                                                               '*');   
                  newrec_.gross_amount             := newrec_.tax_amount + newrec_.net_amount ;
                  IF (newrec_.net_amount > 0) THEN
                     newrec_.non_ded_tax_percentage   := (non_ded_tax_curr_amount_/newrec_.net_amount)*100;
                     non_ded_tax_percentage_          := newrec_.non_ded_tax_percentage;
                  ELSE
                     newrec_.non_ded_tax_percentage   := 0;
                     non_ded_tax_percentage_          := newrec_.non_ded_tax_percentage;

                  END IF;
                  Modify___(newrec_);
               END IF;
            ELSE
               IF (Shipment_Line_API.Get_Inventory_Part_No(source_ref5_, shipment_line_no_) IS NOT NULL) THEN
                  company_ := Site_API.Get_Company(Shipment_API.Get_Contract(source_ref5_));
                  IF (Company_Tax_Discom_Info_API.Get_Create_Tax_Document(company_) = 'TRUE') THEN
                     Error_SYS.Record_General(lu_name_, 'NOTAXDOC: Outgoing Tax Document should be created prior to delivery');   
                  END IF;
               END IF;
               non_ded_tax_percentage_ := 0;               
            END IF;
         END IF;        
      $ELSE
         non_ded_tax_percentage_ := 0;
      $END  
   END IF;
END Calculate_Amounts_And_Taxes;

-- Get_Inventory_Transaction_Date
--    This function retruns the Delivery Date used for Tax Ledger item.
--    For outgoing tax document, shipment delivery transaction date is retruned.
--    For incoming tax document, arrival transaction date is retruned.
@IgnoreUnitTest TrivialFunction
@UncheckedAccess
FUNCTION Get_Inventory_Transaction_Date(
   company_          IN VARCHAR2,
   tax_document_no_  IN NUMBER,
   line_no_          IN NUMBER) RETURN DATE
IS
   tax_document_rec_        Tax_Document_API.Public_Rec;
   $IF Component_Shpmnt_SYS.INSTALLED $THEN
      shipment_line_rec_    Shipment_Line_API.Public_Rec;
   $END   
   shipment_order_id_       VARCHAR2(50);
   shipment_order_line_no_  VARCHAR2(50);
   receipt_no_              VARCHAR2(50);
   shipment_id_             VARCHAR2(50);
   transaction_code_        VARCHAR2(10);
   source_ref2_             VARCHAR2(50);
   earliest_transaction_id_ NUMBER;
   transaction_date_        DATE;      
   
   CURSOR get_source_ref2 IS
      SELECT source_ref2
      FROM   tax_document_line_tab
      WHERE  company         = company_
      AND    tax_document_no = tax_document_no_
      AND    line_no         = line_no_;
BEGIN
   $IF Component_Shpmnt_SYS.INSTALLED $THEN   
      tax_document_rec_ := Tax_Document_API.Get(company_, tax_document_no_);
      IF (tax_document_rec_.source_ref_type = Tax_Doc_Source_Ref_Type_API.DB_SHIPMENT) THEN
         OPEN   get_source_ref2;
         FETCH  get_source_ref2 INTO source_ref2_;
         CLOSE  get_source_ref2;

         shipment_line_rec_      := Shipment_Line_API.Get(TO_NUMBER(tax_document_rec_.source_ref1), TO_NUMBER(source_ref2_));
         shipment_order_id_      := shipment_line_rec_.source_ref1; 
         shipment_order_line_no_ := shipment_line_rec_.source_ref2;

         IF (tax_document_rec_.direction = Tax_Document_Direction_API.DB_OUTBOUND) THEN
            transaction_code_ := 'SHIPODSIT+';
            $IF Component_Rceipt_SYS.INSTALLED $THEN
               receipt_no_    := TO_CHAR(Receipt_Return_API.Get_Receipt_No(source_ref1_           => shipment_order_id_, 
                                                                           source_ref2_           => shipment_order_line_no_, 
                                                                           source_ref3_           => shipment_line_rec_.source_ref3, 
                                                                           source_ref4_           => NULL, 
                                                                           shipment_conn_line_no_ => TO_NUMBER(shipment_line_rec_.source_ref4)));
            $END   
            -- For receipt transactions, shipment_id is not saved in inventory_transaction_hist_tab in source_ref5 column. 
            -- This has still not being implemented and once it is in place, it is needed to simply pass tax_document_rec_.source_ref1.
            shipment_id_      := NULL;
         ELSE
            transaction_code_ := 'SHIPODSIT-';
            receipt_no_       := NULL;
            shipment_id_      := tax_document_rec_.source_ref1;
         END IF;
         earliest_transaction_id_ := Inventory_Transaction_Hist_API.Get_Earliest_Transaction_Id(source_ref1_        => shipment_order_id_,
                                                                                                source_ref2_        => shipment_order_line_no_,
                                                                                                source_ref3_        => receipt_no_,
                                                                                                source_ref4_        => NULL,
                                                                                                source_ref5_        => shipment_id_,
                                                                                                source_ref_type_db_ => Order_Type_API.DB_SHIPMENT_ORDER,
                                                                                                transaction_code_   => transaction_code_);
         transaction_date_ := Inventory_Transaction_Hist_API.Get_Date_Applied(earliest_transaction_id_);
      END IF;
   $END
   RETURN transaction_date_;
END Get_Inventory_Transaction_Date;

FUNCTION Get_Inventory_Valuation_Met_Db (
   company_          IN VARCHAR2,
   tax_document_no_  IN NUMBER,
   line_no_          IN NUMBER ) RETURN VARCHAR2
IS
   tax_document_rec_               Tax_Document_API.Public_Rec;
   tax_document_line_rec_          tax_document_line_tab%ROWTYPE;
   part_no_                        VARCHAR2(25);
   inventory_valuation_method_db_  VARCHAR2(50);
BEGIN
   tax_document_rec_  := Tax_Document_API.Get(company_, tax_document_no_);
   IF(tax_document_rec_.source_ref_type IN ('SHIPMENT'))THEN
      tax_document_line_rec_ := Get_Object_By_Keys___(company_, tax_document_no_, line_no_);
      
      $IF Component_Shpmnt_SYS.INSTALLED $THEN  
         part_no_ := Shipment_Line_API.Get_Inventory_Part_No(tax_document_line_rec_.source_ref1, tax_document_line_rec_.source_ref2); 
         inventory_valuation_method_db_ := Inventory_Part_API.Get_Inventory_Valuation_Met_Db(tax_document_rec_.contract, part_no_);
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPMENT');
      $END     
   END IF;   
   RETURN inventory_valuation_method_db_;   
END Get_Inventory_Valuation_Met_Db;
