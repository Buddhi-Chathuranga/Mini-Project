-----------------------------------------------------------------------------
--
--  Logical unit: CompanyOrderInfo
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200306  ApWilk  Bug 150228 (SCZ-7172), Modified Prepare_Insert___() to avoid the Error Encountered when Adding new Data on the Company/Distribution/Order Tab.
--  200306  ApWilk  Bug 148585 (SCZ-5249), Added the function Get_Company_Ivc_Param().
--  191101  ShPrlk  Bug 150792(SCZ-7681), Modified Prepare_Insert___() to avoid the Error for 'Apply Tax' Encountered 
--  191101          when Adding new Data on the Company/Distribution/Order Tab.
--  191028  ApWilk  Bug 150193(SCZ-7179), Modified Prepare_Insert___() to avoid the Error Encountered when Adding new Data on the Company/Distribution/Order Tab.
--  190917  ShPrlk  Bug 150002(SCZ-6959), Removed changes done by 148226 as check box is handled through templates. 
--  190612  ShPrlk  Bug 148226(SCZ-4503), Modified Check_Insert___ to have apply_tax check box checked if company template is not 'STD-JP'.
--  160519  SWeelk  Bug 127689, Modified Import_Assign___() to stop overriding newrec_.intersite_profitability value
--  160422  SURBLK  Removed Check_Common___
--  150807  Wahelk  BLU-954, Modified Prepare_Insert___ and Check_Insert___ to add default values for OVERWRITE_ORD_REL_DATA_DB and TRANS_ORD_ADDR_INFO_TEMP_DB
--  140521  RoJalk  Removed conditional compilation for Tax_Regime_API calls since INVOIC is static.
--  140429  RoJalk  Removed Get_Delay_Cogs_To_Dc_Db, Get_Base_For_Adv_Inv_Db becuse Get_Base_For_Adv_Invoice_Db, 
--  140429          Get_Delay_Cogs_To_Deliv_Con_Db methods are generated after hooks changes.
--  140424  DipeLK  PBFI-6785 ,Added create company tool support from the developer studio
--  130703  MaIklk  TIBE-954, Removed inst_TaxRegime_, inst_CompanyInvoiceInfo_ and inst_PurchaseOrderLine_ global constants
--                  And used conditional compilation.
--  130701  SudJlk  Bug 107700, Removed attribute order_no_on_incoming_co and all logic related to it.
--  130109  AyAmlk  Bug 103043, Added a new attribute allow_with_deliv_conf to control if Delivery Confirmation
--  130109          should be possible to use for Advance/Prepayment Invoices.
--  120614  MaEelk  Added Get_Base_For_Adv_Inv_Db that would return the database value of Base_For_Adv_Inv.
--  120517  MAHPLK  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Import_Assign___ (
   newrec_      IN OUT company_order_info_tab%ROWTYPE,
   crecomp_rec_ IN     Enterp_Comp_Connect_V170_API.Crecomp_Lu_Public_Rec,
   pub_rec_     IN     Create_Company_Template_Pub%ROWTYPE )
IS
BEGIN
   super(newrec_, crecomp_rec_, pub_rec_);
   IF (newrec_.intersite_profitability IS NULL) THEN
      newrec_.intersite_profitability := 'FALSE';
   END IF;
END Import_Assign___;


@Override
PROCEDURE Copy_Assign___ (
   newrec_      IN OUT company_order_info_tab%ROWTYPE,
   crecomp_rec_ IN     Enterp_Comp_Connect_V170_API.Crecomp_Lu_Public_Rec,
   oldrec_      IN     company_order_info_tab%ROWTYPE )
IS
BEGIN
   super(newrec_, crecomp_rec_, oldrec_);
   newrec_.intersite_profitability := 'FALSE';
END Copy_Assign___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('INTERSITE_PROFITABILITY_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('DELAY_COGS_TO_DELIV_CONF_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ALLOW_WITH_DELIV_CONF_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('OVERWRITE_ORD_REL_DATA_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('TRANS_ORD_ADDR_INFO_TEMP_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('EXC_SVC_DELNOTE_PRINT_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('INCLUDE_TAX_FOR_INTERIM_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('APPLY_TAX_DB', 'TRUE',attr_);
   Client_SYS.Add_To_Attr('IVC_UNCONCT_CHG_SEPERATLY_DB', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     COMPANY_ORDER_INFO_TAB%ROWTYPE,
   newrec_     IN OUT COMPANY_ORDER_INFO_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   --This check should only be made when enable intersite_profitability, can only be done in update.
   IF (newrec_.intersite_profitability = 'TRUE') THEN
      IF (oldrec_.intersite_profitability != newrec_.intersite_profitability) THEN
         $IF (NOT Component_Purch_SYS.INSTALLED) $THEN
             Error_SYS.Record_General(lu_name_, 'PURCHNOTINST: Purch must be installed to use inter-site profitability.');         
         $ELSE
            NULL;
         $END
      END IF;
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT company_order_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS 
BEGIN
   IF (NOT indrec_.intersite_profitability) THEN   
      newrec_.intersite_profitability := 'FALSE';
   END IF;
   IF (NOT indrec_.delay_cogs_to_deliv_conf) THEN   
      newrec_.delay_cogs_to_deliv_conf := 'FALSE';
   END IF;
   IF (NOT indrec_.allow_with_deliv_conf) THEN      
      newrec_.allow_with_deliv_conf := 'FALSE'; 
   END IF;
   IF NOT(indrec_.overwrite_ord_rel_data) THEN
      newrec_.overwrite_ord_rel_data := 'FALSE';
   END IF;
   IF NOT (indrec_.trans_ord_addr_info_temp) THEN
      newrec_.trans_ord_addr_info_temp := 'FALSE';
   END IF;
   
   super(newrec_, indrec_, attr_);
   
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS 
FUNCTION Get_Company_Ivc_Param RETURN VARCHAR2
IS
 company_  VARCHAR2(20) := Site_API.Get_Company(User_Allowed_Site_API.Get_Default_Site);
 dummy_    VARCHAR2(10);
BEGIN
   IF(Get_Ivc_Unconct_Chg_Seperat_Db(company_) = 'TRUE')THEN
     dummy_ := 'TRUE';
   ELSE
     dummy_ := 'FALSE';
   END IF;
   RETURN dummy_;
END Get_Company_Ivc_Param;



