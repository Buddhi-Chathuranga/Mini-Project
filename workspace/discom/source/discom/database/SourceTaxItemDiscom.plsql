-----------------------------------------------------------------------------
--
--  Logical unit: SourceTaxItemDiscom
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220725  MaEelk  SCDEV-12653, Pass parallel amounts and Tax Limit Curr Amount to Source_Tax_Item_Discom_API.New, so they would be saved in Source Tax Item Tab
--  220719  MaEelk  SCDEV-12653, Modified New and added new parameters to pase non deductible tax amounts when creating the source tax item record
--  220712  MaEelk  SCDEV-11672, Modified Create_Tax_Items to pass non-deductible tax amounts to Source_Tax_Item_API.Assign_Param_To_Record(.
--  220412  NiRalk  SCDEV-8136, Added New method.
--  220201  HasTlk  SC21R2-7281, Modified Create_Tax_Items method by assigning values for cst_code_, legal_tax_class_, tax_category1_ and tax_category2_.
--  220104  MalLlk  SC21R2-5593, Added method Remove_Tax_Items.
--  211220  Kgamlk  FI21R2-7201, Added tax_category1 and tax_category2 to Source Tax Item.
--  211202  MalLlk  SC21R2-5583, Created.
-----------------------------------------------------------------------------

layer Core;

-- ------------------ SOURCE REF column mapping -----------------------------
--
--   source_ref_type => Tax_Source_API.DB_TAX_DOCUMENT_LINE
--   source_ref1 => tax_document_no
--   source_ref2 => line_no
--   source_ref3 => '*'
--   source_ref4 => '*'
--   source_ref5 => '*'
-- --------------------------------------------------------------------------

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT source_tax_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.source_ref_type = Tax_Source_API.DB_TAX_DOCUMENT_LINE THEN
      newrec_.source_ref3 := '*';
      newrec_.source_ref4 := '*';
      newrec_.source_ref5 := '*';
   END IF;  
   super(newrec_, indrec_, attr_);
END Check_Insert___;

@IgnoreUnitTest MethodOverride
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

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Tax_Items (
   tax_info_table_      IN Tax_Handling_Util_API.tax_information_table,
   source_key_rec_      IN Tax_Handling_Util_API.source_key_rec,
   company_             IN VARCHAR2)
IS
   newrec_              source_tax_item_tab%ROWTYPE;
BEGIN
   IF (tax_info_table_.COUNT > 0) THEN
      FOR i IN tax_info_table_.FIRST .. tax_info_table_.LAST LOOP
         Source_Tax_Item_API.Assign_Param_To_Record( newrec_, 
                                                     company_,
                                                     source_key_rec_.source_ref_type,
                                                     source_key_rec_.source_ref1,
                                                     source_key_rec_.source_ref2,
                                                     source_key_rec_.source_ref3,
                                                     source_key_rec_.source_ref4,
                                                     source_key_rec_.source_ref5,
                                                     tax_code_                   => tax_info_table_(i).tax_code,                                              
                                                     tax_calc_structure_id_      => tax_info_table_(i).tax_calc_structure_id,
                                                     tax_calc_structure_item_id_ => tax_info_table_(i).tax_calc_structure_item_id,
                                                     transferred_                => Fnd_Boolean_API.DB_FALSE,
                                                     tax_item_id_                => NULL,
                                                     tax_percentage_             => tax_info_table_(i).tax_percentage,
                                                     tax_curr_amount_            => tax_info_table_(i).tax_curr_amount,
                                                     tax_dom_amount_             => tax_info_table_(i).tax_dom_amount,
                                                     tax_para_amount_            => tax_info_table_(i).tax_para_amount,
                                                     non_ded_tax_curr_amount_    => tax_info_table_(i).non_ded_tax_curr_amount,
                                                     non_ded_tax_dom_amount_     => tax_info_table_(i).non_ded_tax_dom_amount,
                                                     non_ded_tax_para_amount_    => tax_info_table_(i).non_ded_tax_para_amount,
                                                     tax_base_curr_amount_       => tax_info_table_(i).tax_base_curr_amount,
                                                     tax_base_dom_amount_        => tax_info_table_(i).tax_base_dom_amount,
                                                     tax_base_para_amount_       => tax_info_table_(i).tax_base_para_amount,
                                                     tax_limit_curr_amount_      => NULL,
                                                     cst_code_                   => tax_info_table_(i).cst_code,
                                                     legal_tax_class_            => tax_info_table_(i).legal_tax_class,
                                                     tax_category1_              => tax_info_table_(i).tax_category1,
                                                     tax_category2_              => tax_info_table_(i).tax_category2);

         New___(newrec_);
      END LOOP;
   END IF;
END Create_Tax_Items;

@IgnoreUnitTest TrivialFunction
PROCEDURE Remove_Tax_Items (
   source_key_rec_  IN Tax_Handling_Util_API.source_key_rec,
   company_         IN VARCHAR2)
IS
   tax_table_       Source_Tax_Item_API.source_tax_table;
   newrec_          source_tax_item_tab%ROWTYPE;
BEGIN
   tax_table_ := Source_Tax_Item_API.Get_Tax_Items(company_, 
                                                   source_key_rec_.source_ref_type, 
                                                   source_key_rec_.source_ref1, 
                                                   source_key_rec_.source_ref2, 
                                                   source_key_rec_.source_ref3, 
                                                   source_key_rec_.source_ref4, 
                                                   source_key_rec_.source_ref5);
   
   FOR i IN 1 .. tax_table_.COUNT LOOP
      Source_Tax_Item_API.Assign_Pubrec_To_Record(newrec_, tax_table_(i));
      Remove___(newrec_);
   END LOOP;
END Remove_Tax_Items;

@IgnoreUnitTest TrivialFunction
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
   tax_para_amount_            IN NUMBER,
   tax_base_curr_amount_       IN NUMBER,
   tax_base_dom_amount_        IN NUMBER,
   tax_base_para_amount_       IN NUMBER,
   non_ded_tax_curr_amount_    IN NUMBER,
   non_ded_tax_dom_amount_     IN NUMBER,
   non_ded_tax_para_amount_    IN NUMBER,
   tax_limit_curr_amount_      IN NUMBER,
   cst_code_                   IN VARCHAR2,
   legal_tax_class_            IN VARCHAR2,
   tax_category1_              IN VARCHAR2,
   tax_category2_              IN VARCHAR2 )
IS  
   newrec_  source_tax_Item_tab%ROWTYPE;
BEGIN
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
                                              tax_para_amount_          => tax_para_amount_,
                                              non_ded_tax_curr_amount_  => non_ded_tax_curr_amount_,
                                              non_ded_tax_dom_amount_   => non_ded_tax_dom_amount_,
                                              non_ded_tax_para_amount_  => non_ded_tax_para_amount_,      
                                              tax_base_curr_amount_     => tax_base_curr_amount_,
                                              tax_base_dom_amount_      => tax_base_dom_amount_,
                                              tax_base_para_amount_     => tax_base_para_amount_,
                                              tax_limit_curr_amount_    => tax_limit_curr_amount_,
                                              cst_code_                 => cst_code_,
                                              legal_tax_class_          => legal_tax_class_,
                                              tax_category1_            => tax_category1_,
                                              tax_category2_            => tax_category2_);
   New___(newrec_);   
END New;