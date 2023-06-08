-----------------------------------------------------------------------------
--
--  Logical unit: SourceTaxItemOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220107  Hahalk  Bug 161993 (SC21R2-6910), Override Check_Update___ by adding condition to prevent of checking user athourization when there is an intersite flow.
--  211220  Kgamlk  FI21R2-7201, Added tax_category1 and tax_category2 to Source Tax Item.
--  210706  PraWlk  FI21R2-925, Modified Create_Tax_Items() and Modify_Tax_Items() by adding cst_code and legal_tax_class for the call 
--  210706          to Source_Tax_Item_API.Assign_Param_To_Record().
--  200731  KiSalk  Bug 155034(SCZ-10932), Added Cleanup_Tax_Items to delete taxes without validations in the Cleanup process.
--  200715  NiDalk  SCXTEND-4526, Added Tax_Exist to check tax lines exist for a particular source.
--  200417  Nudilk  Bug 152777, Modified code in Check_Common___.
--  161228  MalLlk  FINHR-5040, Modified New(), Create_Tax_Items(), Modify() and Modify_Tax_Items() to introduce Tax Calculation Structures.
--  160623  SudJlk  STRSC-2598, Replaced Cust_Order_Line_Address_API.Public_Rec with Cust_Order_Line_Address_API.Co_Line_Addr_Rec and 
--  160623          Cust_Order_Line_Address_API.Get() with Cust_Order_Line_Address_API.Get_Co_Line_Addr()
--  160407  DipeLk  FINHR-1686, Added method Get_Total_Ord_Line_Tax_Pct in order to get total tax presentage for order lines .
--  160211  MalLlk  FINHR-625, Removed method Add_All_Tax_Lines. 
--  160211  IsSalk  FINHR-685, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Charge.
--  160202  MaRalk  LIM-6114, Replaced Shipment_API.Get_Ship_Addr_No usages with Shipment_API.Get_Receiver_Addr_Id
--  160202          in Get_Connected_Address_Id___ method.
--  160129  IsSalk  FINHR-647, Redirect method calls to new utility LU TaxHandlingOrderUtil.
--  160119  IsSalk  FINHR-657, Used FndBoolean in taxable attribute in Sales Charge Type.
--  151110  MaIklk  LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151016  MAHPLK  FINHR-140, Created.
-----------------------------------------------------------------------------

layer Core;


-- ------------------ SOURCE REF column matching ---------------------------
--
--   source_ref_type => Tax_Source_API.DB_CUSTOMER_ORDER_LINE
--   source_ref1 => order_no
--   source_ref2 => line_no
--   source_ref3 => rel_no
--   source_ref4 => line_item_no
--   source_ref5 => '*'
--
--   source_ref_type => Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE
--   source_ref1 => order_no
--   source_ref2 => sequence_no
--   source_ref3 => '*'
--   source_ref4 => '*'
--   source_ref5 => '*'
--
--   source_ref_type => Tax_Source_API.DB_ORDER_QUOTATION_LINE
--   source_ref1 => quotation_no
--   source_ref2 => line_no
--   source_ref3 => rel_no
--   source_ref4 => line_item_no
--   source_ref5 => '*'
--
--   source_ref_type => Tax_Source_API.DB_ORDER_QUOTATION_CHARGE
--   source_ref1 => quotation_no
--   source_ref2 => quotation_charge_no
--   source_ref3 => '*'
--   source_ref4 => '*'
--   source_ref5 => '*'
--
--   source_ref_type => Tax_Source_API.DB_RETURN_MATERIAL_LINE
--   source_ref1 => rma_no
--   source_ref2 => rma_line_no
--   source_ref3 => '*'
--   source_ref4 => '*'
--   source_ref5 => '*'
--
--   source_ref_type => Tax_Source_API.DB_RETURN_MATERIAL_CHARGE
--   source_ref1 => rma_no
--   source_ref2 => rma_charge_no
--   source_ref3 => '*'
--   source_ref4 => '*'
--   source_ref5 => '*'
--
--   source_ref_type => Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE
--   source_ref1 => shipment_id
--   source_ref2 => sequence_no
--   source_ref3 => '*'
--   source_ref4 => '*'
--   source_ref5 => '*'
--
-- -------------------------------------------------------------------------

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_            CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;

db_false_           CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     SOURCE_TAX_ITEM_TAB%ROWTYPE,
   newrec_ IN OUT SOURCE_TAX_ITEM_TAB%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   attr1_                     VARCHAR2(3200);
   source_key_rec_            Tax_Handling_Util_API.source_key_rec;
   do_additional_validate_    VARCHAR2(5);
BEGIN   
   do_additional_validate_ := nvl(Client_SYS.Get_Item_Value('DO_ADDITIONAL_VALIDATE', attr_),'FALSE');
   Client_SYS.Clear_Attr(attr1_);
   
   Client_SYS.Set_Item_Value('DO_ADDITIONAL_VALIDATE', do_additional_validate_, attr1_);
   
   source_key_rec_.source_ref_type  := newrec_.source_ref_type;
   source_key_rec_.source_ref1      := newrec_.source_ref1;
   source_key_rec_.source_ref2      := newrec_.source_ref2;
   source_key_rec_.source_ref3      := newrec_.source_ref3;
   source_key_rec_.source_ref4      := newrec_.source_ref4;
   source_key_rec_.source_ref5      := newrec_.source_ref5;
   
   Tax_Handling_Order_Util_API.Validate_Tax_Code(newrec_.company, source_key_rec_, newrec_.tax_code, newrec_.tax_percentage, indrec_.tax_code, indrec_.tax_percentage);
   Tax_Handling_Order_Util_API.Validate_Source_Pkg_Info(source_key_rec_, attr1_);
   super(oldrec_, newrec_, indrec_, attr_);
   
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT source_tax_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   User_Finance_API.Exist_Current_User(newrec_.company);
   IF newrec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_LINE THEN 
      newrec_.source_ref5 := '*';
   ELSIF newrec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE THEN
      newrec_.source_ref3 := '*';
      newrec_.source_ref4 := '*';
      newrec_.source_ref5 := '*';
   ELSIF newrec_.source_ref_type = Tax_Source_API.DB_ORDER_QUOTATION_LINE THEN 
      newrec_.source_ref5 := '*';
   ELSIF newrec_.source_ref_type = Tax_Source_API.DB_ORDER_QUOTATION_CHARGE THEN 
      newrec_.source_ref3 := '*';
      newrec_.source_ref4 := '*';
      newrec_.source_ref5 := '*';
   ELSIF newrec_.source_ref_type = Tax_Source_API.DB_RETURN_MATERIAL_LINE THEN 
      newrec_.source_ref3 := '*';
      newrec_.source_ref4 := '*';
      newrec_.source_ref5 := '*';
   ELSIF newrec_.source_ref_type = Tax_Source_API.DB_RETURN_MATERIAL_CHARGE THEN
      newrec_.source_ref3 := '*';
      newrec_.source_ref4 := '*';
      newrec_.source_ref5 := '*';
   ELSIF newrec_.source_ref_type = Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE THEN 
      newrec_.source_ref3 := '*';
      newrec_.source_ref4 := '*';
      newrec_.source_ref5 := '*';
   END IF;  
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SOURCE_TAX_ITEM_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS   
BEGIN 
   newrec_.tax_item_id := Source_Tax_Item_API.Get_Max_Tax_Item_Id(newrec_.company, 
                                                                  newrec_.source_ref_type, 
                                                                  newrec_.source_ref1, 
                                                                  newrec_.source_ref2, 
                                                                  newrec_.source_ref3, 
                                                                  newrec_.source_ref4,
                                                                  newrec_.source_ref5) + 1;
   super(objid_, objversion_, newrec_, attr_);
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SOURCE_TAX_ITEM_TAB%ROWTYPE )
IS
   attr1_            VARCHAR2(3200);
   source_key_rec_   Tax_Handling_Util_API.source_key_rec;
BEGIN
   User_Finance_API.Exist_Current_User(remrec_.company);
   Client_SYS.Clear_Attr(attr1_);
   Client_SYS.Set_Item_Value('DO_ADDITIONAL_VALIDATE', 'FALSE', attr1_);
   
   source_key_rec_.source_ref_type  := remrec_.source_ref_type;
   source_key_rec_.source_ref1      := remrec_.source_ref1;
   source_key_rec_.source_ref2      := remrec_.source_ref2;
   source_key_rec_.source_ref3      := remrec_.source_ref3;
   source_key_rec_.source_ref4      := remrec_.source_ref4;
   source_key_rec_.source_ref5      := remrec_.source_ref5;
   
   Tax_Handling_Order_Util_API.Validate_Source_Pkg_Info(source_key_rec_, attr1_);
   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     source_tax_item_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY source_tax_item_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   exist_user_flag_   BOOLEAN := FALSE;
BEGIN
   IF oldrec_.source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_LINE THEN
      IF (Customer_Order_Line_Api.Get_Demand_Code_Db(oldrec_.source_ref1,oldrec_.source_ref2,oldrec_.source_ref3,oldrec_.source_ref4) IN ('IPT','IPD'))THEN
         exist_user_flag_ := TRUE;
      END IF;
   END IF;
   
   IF (NOT exist_user_flag_) THEN
      User_Finance_API.Exist_Current_User(oldrec_.company);
   END IF;
   
   super(oldrec_,newrec_,indrec_,attr_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-- Is_Tax_Code_Exist__
--   Check tax code exists for a given customer order. If tax code does
--   not exists, then error message will raise.
FUNCTION Is_Tax_Code_Exist__ (
   company_  IN VARCHAR2,
   order_no_ IN VARCHAR2,
   tax_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
   dummy_         NUMBER;
   flag_          VARCHAR2(5);

   CURSOR check_tax_code_exist IS
      SELECT 1
      FROM PREPAY_TAX_CODE_LOV
      WHERE company = company_
      AND order_no = order_no_
      AND fee_code = tax_code_;
BEGIN
   OPEN check_tax_code_exist;
   FETCH check_tax_code_exist INTO dummy_;
   CLOSE check_tax_code_exist;

   IF (dummy_ = 1) THEN
      flag_ := 'TRUE';
   ELSE
      flag_ := 'FALSE';
   END IF;
   RETURN flag_;
END Is_Tax_Code_Exist__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE New (
   newrec_  IN OUT source_tax_Item_tab%ROWTYPE )
IS
BEGIN   
   New___(newrec_);
END New;


-- gelr:br_external_tax_integration, added cst_code and legal_tax_class
PROCEDURE New (
   company_                    IN VARCHAR2,
   source_ref_type_            IN VARCHAR2,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,   
   source_ref5_                IN VARCHAR2,   
   tax_item_id_                IN VARCHAR2,   
   tax_code_                   IN VARCHAR2,
   tax_calc_structure_id_      IN VARCHAR2,
   tax_calc_structure_item_id_ IN VARCHAR2,
   tax_percentage_             IN NUMBER,
   tax_curr_amount_            IN NUMBER,
   tax_dom_amount_             IN NUMBER,   
   tax_base_curr_amount_       IN NUMBER,
   tax_base_dom_amount_        IN NUMBER,
   cst_code_                   IN VARCHAR2,
   legal_tax_class_            IN VARCHAR2,
   tax_category1_              IN VARCHAR2,
   tax_category2_              IN VARCHAR2 )
IS  
   newrec_  source_tax_Item_tab%ROWTYPE;
BEGIN
   -- gelr:br_external_tax_integration, added cst_code and legal_tax_class
   Source_Tax_Item_API.Assign_Param_To_Record(newrec_, 
                                              company_,
                                              source_ref_type_,
                                              source_ref1_,
                                              source_ref2_,
                                              source_ref3_,
                                              source_ref4_,
                                              source_ref5_,
                                              tax_code_,
                                              tax_calc_structure_id_,
                                              tax_calc_structure_item_id_,
                                              'FALSE',
                                              tax_item_id_,
                                              tax_percentage_,
                                              tax_curr_amount_,
                                              tax_dom_amount_,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,      
                                              tax_base_curr_amount_,
                                              tax_base_dom_amount_,
                                              NULL,
                                              NULL,
                                              cst_code_,
                                              legal_tax_class_,
                                              tax_category1_,
                                              tax_category2_);
   New___(newrec_);   
END New;


PROCEDURE Modify (
   newrec_  IN OUT source_tax_Item_tab%ROWTYPE )
IS
   rec_ source_tax_Item_tab%ROWTYPE;   
BEGIN
   rec_ := Get_Object_By_Keys___(newrec_.company, newrec_.source_ref_type, newrec_.source_ref1, newrec_.source_ref2, newrec_.source_ref3, newrec_.source_ref4, newrec_.source_ref5, newrec_.tax_item_id);  
   rec_.company                    := newrec_.company;
   rec_.source_ref_type            := newrec_.source_ref_type;
   rec_.source_ref1                := newrec_.source_ref1;
   rec_.source_ref2                := newrec_.source_ref2;
   rec_.source_ref3                := newrec_.source_ref3;
   rec_.source_ref4                := newrec_.source_ref4;
   rec_.source_ref5                := newrec_.source_ref5;
   rec_.tax_item_id                := newrec_.tax_item_id;       
   rec_.tax_code                   := newrec_.tax_code;
   rec_.tax_calc_structure_id      := newrec_.tax_calc_structure_id;
   rec_.tax_calc_structure_item_id := newrec_.tax_calc_structure_item_id;
   rec_.tax_percentage             := newrec_.tax_percentage;
   rec_.tax_curr_amount            := newrec_.tax_curr_amount;
   rec_.tax_dom_amount             := newrec_.tax_dom_amount;
   rec_.tax_base_curr_amount       := newrec_.tax_base_curr_amount;
   rec_.tax_base_dom_amount        := newrec_.tax_base_dom_amount;  
   Modify___(rec_);
END Modify;


-------------------- PUBLIC METHODS FOR COMMON LOGIC -----------------------


PROCEDURE Create_Tax_Items (
   tax_info_table_      IN Tax_Handling_Util_API.tax_information_table,
   source_key_rec_      IN Tax_Handling_Util_API.source_key_rec,
   company_             IN VARCHAR2 )
IS
   emptyrec_            SOURCE_TAX_ITEM_TAB%ROWTYPE;
   newrec_              SOURCE_TAX_ITEM_TAB%ROWTYPE;
BEGIN   
   IF (tax_info_table_.COUNT > 0) THEN
      FOR i IN tax_info_table_.FIRST .. tax_info_table_.LAST LOOP
         newrec_ := emptyrec_;
         Source_Tax_Item_API.Assign_Param_To_Record(newrec_, 
                                                    company_,
                                                    source_key_rec_.source_ref_type,
                                                    source_key_rec_.source_ref1,
                                                    source_key_rec_.source_ref2,
                                                    source_key_rec_.source_ref3,
                                                    source_key_rec_.source_ref4,
                                                    source_key_rec_.source_ref5,
                                                    tax_info_table_(i).tax_code,
                                                    tax_calc_structure_id_ => tax_info_table_(i).tax_calc_structure_id,
                                                    tax_calc_structure_item_id_ => tax_info_table_(i).tax_calc_structure_item_id,
                                                    transferred_ => NULL,
                                                    tax_item_id_ => NULL,
                                                    tax_percentage_ => tax_info_table_(i).tax_percentage,
                                                    tax_curr_amount_ => tax_info_table_(i).tax_curr_amount,
                                                    tax_dom_amount_ => tax_info_table_(i).tax_dom_amount,
                                                    tax_para_amount_ => 0,
                                                    non_ded_tax_curr_amount_ => 0,
                                                    non_ded_tax_dom_amount_ => 0,
                                                    non_ded_tax_para_amount_ => 0,
                                                    tax_base_curr_amount_ => tax_info_table_(i).tax_base_curr_amount,
                                                    tax_base_dom_amount_ => tax_info_table_(i).tax_base_dom_amount,
                                                    tax_base_para_amount_ => 0,
                                                    tax_limit_curr_amount_ => NULL,
                                                    -- gelr:br_external_tax_integration, begin
                                                    cst_code_ => tax_info_table_(i).cst_code,
                                                    legal_tax_class_ => tax_info_table_(i).legal_tax_class,
                                                    -- gelr:br_external_tax_integration, end
                                                    tax_category1_ => tax_info_table_(i).tax_category1,
                                                    tax_category2_ => tax_info_table_(i).tax_category2); 
         New___(newrec_);
      END LOOP;
   END IF;
END Create_Tax_Items;


PROCEDURE Modify_Tax_Items (
   tax_info_table_      IN Tax_Handling_Util_API.tax_information_table,
   source_key_rec_      IN Tax_Handling_Util_API.source_key_rec,
   company_             IN VARCHAR2)
IS
   emptyrec_            SOURCE_TAX_ITEM_TAB%ROWTYPE;
   newrec_              SOURCE_TAX_ITEM_TAB%ROWTYPE;
   tax_table_           Source_Tax_Item_API.source_tax_table;
BEGIN
   tax_table_ := Source_Tax_Item_API.Get_Tax_Items(company_, 
                                                   source_key_rec_.source_ref_type, 
                                                   source_key_rec_.source_ref1, 
                                                   NVL(source_key_rec_.source_ref2, '*'), 
                                                   NVL(source_key_rec_.source_ref3, '*'), 
                                                   NVL(source_key_rec_.source_ref4, '*'),
                                                   NVL(source_key_rec_.source_ref5, '*'));
   
   IF (tax_info_table_.COUNT > 0 AND tax_table_.COUNT > 0) THEN
      FOR i IN tax_info_table_.FIRST .. tax_info_table_.LAST LOOP
         newrec_ := emptyrec_;
         Source_Tax_Item_API.Assign_Param_To_Record(newrec_, 
                                                    company_, 
                                                    source_key_rec_.source_ref_type, 
                                                    source_key_rec_.source_ref1, 
                                                    source_key_rec_.source_ref2, 
                                                    source_key_rec_.source_ref3, 
                                                    source_key_rec_.source_ref4, 
                                                    source_key_rec_.source_ref5, 
                                                    tax_info_table_(i).tax_code, 
                                                    tax_calc_structure_id_ => tax_info_table_(i).tax_calc_structure_id,
                                                    tax_calc_structure_item_id_ => tax_info_table_(i).tax_calc_structure_item_id,
                                                    transferred_ => NULL, 
                                                    tax_item_id_ => tax_table_(i).tax_item_id, 
                                                    tax_percentage_ => tax_info_table_(i).tax_percentage, 
                                                    tax_curr_amount_ => tax_info_table_(i).tax_curr_amount, 
                                                    tax_dom_amount_ => tax_info_table_(i).tax_dom_amount, 
                                                    tax_para_amount_ => NULL, 
                                                    non_ded_tax_curr_amount_ => NULL, 
                                                    non_ded_tax_dom_amount_ => NULL, 
                                                    non_ded_tax_para_amount_ => NULL, 
                                                    tax_base_curr_amount_ => tax_info_table_(i).tax_base_curr_amount, 
                                                    tax_base_dom_amount_ => tax_info_table_(i).tax_base_dom_amount, 
                                                    tax_base_para_amount_ => NULL, 
                                                    tax_limit_curr_amount_ => NULL,
                                                    -- gelr:br_external_tax_integration, begin
                                                    cst_code_ => tax_info_table_(i).cst_code,
                                                    legal_tax_class_ => tax_info_table_(i).legal_tax_class,
                                                    -- gelr:br_external_tax_integration, end
                                                    tax_category1_ => tax_info_table_(i).tax_category1,
                                                    tax_category2_ => tax_info_table_(i).tax_category2);

         Modify(newrec_);
      END LOOP;
   END IF;   
END Modify_Tax_Items;


PROCEDURE Remove_Tax_Items (
   company_         IN VARCHAR2,
   source_ref_type_ IN VARCHAR2,
   source_ref1_     IN VARCHAR2,
   source_ref2_     IN VARCHAR2,
   source_ref3_     IN VARCHAR2,
   source_ref4_     IN VARCHAR2,
   source_ref5_     IN VARCHAR2)
IS
   tax_table_       Source_Tax_Item_API.source_tax_table;
   remrec_          source_tax_item_tab%ROWTYPE;
BEGIN
   tax_table_ := Source_Tax_Item_API.Get_Tax_Items(company_, source_ref_type_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref5_);
   FOR i IN 1 .. tax_table_.COUNT LOOP
      Source_Tax_Item_API.Assign_Pubrec_To_Record(remrec_, tax_table_(i));
      Remove___(remrec_);
   END LOOP;
END Remove_Tax_Items;

-- Cleanup_Tax_Items
-- This is called by Cleanup_Customer_Order_API to delete taxes without validations
PROCEDURE Cleanup_Tax_Items (
   company_         IN VARCHAR2,
   source_ref_type_ IN VARCHAR2,
   source_ref1_     IN VARCHAR2,
   source_ref2_     IN VARCHAR2,
   source_ref3_     IN VARCHAR2,
   source_ref4_     IN VARCHAR2,
   source_ref5_     IN VARCHAR2)
IS
   tax_table_       Source_Tax_Item_API.source_tax_table;
   remrec_          source_tax_item_tab%ROWTYPE;
BEGIN
   tax_table_ := Source_Tax_Item_API.Get_Tax_Items(company_, source_ref_type_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref5_);
   FOR i IN 1 .. tax_table_.COUNT LOOP
      Source_Tax_Item_API.Assign_Pubrec_To_Record(remrec_, tax_table_(i));
      Delete___(remrec_);
   END LOOP;
END Cleanup_Tax_Items;

-------------------- PUBLIC METHODS FOR FETCHING TAX RELATED INFO ----------


-- Tax_Lines_Match
--   This method Returns TRUE if two sets if customer order line tax lines match, both tax code and tax percentage.
@UncheckedAccess
FUNCTION Tax_Lines_Match(
   company_          IN VARCHAR2,
   source_ref_type_  IN VARCHAR2,
   source_ref1_      IN VARCHAR2,
   old_source_ref2_  IN VARCHAR2,
   old_source_ref3_  IN VARCHAR2,
   new_source_ref2_  IN VARCHAR2,
   new_source_ref3_  IN VARCHAR2) RETURN BOOLEAN
IS
   CURSOR tax_lines_diff IS
      SELECT * FROM
      (SELECT tax_code, tax_percentage
         FROM source_tax_item_tab
        WHERE company          = company_
          AND source_ref1      = source_ref1_
          AND source_ref2      = old_source_ref2_
          AND source_ref3      = old_source_ref3_
          AND source_ref_type  = source_ref_type_
        MINUS
       SELECT tax_code, tax_percentage
         FROM source_tax_item_tab
        WHERE company          = company_
          AND source_ref1      = source_ref1_
          AND source_ref2      = new_source_ref2_
          AND source_ref3      = new_source_ref3_
          AND source_ref_type  = source_ref_type_)
       UNION ALL
      SELECT * FROM
      (SELECT tax_code, tax_percentage
         FROM source_tax_item_tab
        WHERE company          = company_
          AND source_ref1      = source_ref1_
          AND source_ref2      = new_source_ref2_
          AND source_ref3      = new_source_ref3_
          AND source_ref_type  = source_ref_type_
         MINUS
         SELECT tax_code, tax_percentage
         FROM source_tax_item_tab
        WHERE company          = company_
          AND source_ref1      = source_ref1_
          AND source_ref2      = old_source_ref2_
          AND source_ref3      = old_source_ref3_
          AND source_ref_type  = source_ref_type_);
BEGIN
   FOR tax_lines_diff_rec_ IN tax_lines_diff LOOP
      IF (tax_lines_diff_rec_.tax_code IS NOT NULL) THEN
         RETURN FALSE;
      END IF;
   END LOOP;
   -- IF there was no false value returned, no un-matching lines were found and the method returns true
   RETURN TRUE;
END Tax_Lines_Match;

--------------------------------------------------------
-- Tax_Exist
--   Checks if tax lines exist for a particular source
--------------------------------------------------------
FUNCTION Tax_Exist (
   company_    IN VARCHAR2,
   source_ref_type_  IN VARCHAR2,
   source_ref1_      IN VARCHAR2 ) RETURN BOOLEAN 
IS
   lines_exist_      BOOLEAN := FALSE;
   dummy_            NUMBER;
   
   CURSOR tax_exist IS
      SELECT 1
      FROM source_tax_item_tab
        WHERE company          = company_
          AND source_ref1      = source_ref1_
          AND source_ref_type  = source_ref_type_;
   
BEGIN
   OPEN tax_exist;
   FETCH tax_exist INTO dummy_;
   
   IF tax_exist%FOUND then
      lines_exist_ := TRUE;
   END IF;
   
   RETURN lines_exist_;
END Tax_Exist;
