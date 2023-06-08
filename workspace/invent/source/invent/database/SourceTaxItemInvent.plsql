-----------------------------------------------------------------------------
--
--  Logical unit: SourceTaxItemInvent
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220120  MalLlk  SC21R2-5022, Added IgnoreUnitTest annotation to the methods Check_Insert___, Insert___ and Create_Tax_Items.
--  211220  Kgamlk  FI21R2-7201, Added tax_category1 and tax_category2 to Source Tax Item.
--  210705  MalLlk  SC21R2-1823, Created.
-----------------------------------------------------------------------------

layer Core;

-- ------------------ SOURCE REF column mapping -----------------------------
--
--   source_ref_type => Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST
--   source_ref1 => part_move_tax_id
--   source_ref2 => '*'
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
   IF newrec_.source_ref_type = Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST THEN 
      newrec_.source_ref2 := '*';    
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
                                                     tax_info_table_(i).tax_code,                                              
                                                     tax_calc_structure_id_      => NULL,
                                                     tax_calc_structure_item_id_ => NULL,
                                                     transferred_                => NULL,
                                                     tax_item_id_                => NULL,
                                                     tax_percentage_             => tax_info_table_(i).tax_percentage,
                                                     tax_curr_amount_            => tax_info_table_(i).tax_curr_amount,
                                                     tax_dom_amount_             => tax_info_table_(i).tax_dom_amount,
                                                     tax_para_amount_            => tax_info_table_(i).tax_para_amount,
                                                     non_ded_tax_curr_amount_    => NULL,
                                                     non_ded_tax_dom_amount_     => NULL,
                                                     non_ded_tax_para_amount_    => NULL,
                                                     tax_base_curr_amount_       => tax_info_table_(i).tax_base_curr_amount,
                                                     tax_base_dom_amount_        => tax_info_table_(i).tax_base_dom_amount,
                                                     tax_base_para_amount_       => tax_info_table_(i).tax_base_para_amount,
                                                     tax_limit_curr_amount_      => NULL,
                                                     cst_code_                   => NULL,
                                                     legal_tax_class_            => NULL,
                                                     tax_category1_              => NULL,
                                                     tax_category2_              => NULL);

         New___(newrec_);
      END LOOP;
   END IF;
END Create_Tax_Items;