-----------------------------------------------------------------------------
--
--  Logical unit: CustOrdInvoStat
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120308  MeAblk Bug 100782, Added price_source_id and price_source columns into the view and accordingly  modified the respective methods.
--  110822  KiSalk Bug 98529, Increased the length of catalog_desc to 2000 in view comments.
--  110131  Nekolk  EANE-3744  added where clause to View CUST_ORD_INVO_STAT.
--  100106  NWeelk Bug 88012, Handles new columns condition_code and condition_code_description in methods Insert___, Update___, Unpack_Check_Insert___ and Unpack_Check_Update___.
--  090930  MaMalk Modified Modify_Invoice_Statistics to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  090713  MaMalk Bug 83680, Modified Unpack_Check_Update___ to add the INVOICE_NO and SERIES_ID to the attribute string.   
--  090511  ChJalk Bug 81683, Modified Modify_Invoice_Statistics and Remove_Invoice_Statistics to update or remove statistics only if there is a record for that invoice line in statistics.
--  090507  ChJalk Bug 81683, Modified Modify_Invoice_Statistics and Remove_Invoice_Statistics to fetch the statistics no into a variable.
--  090504  ChJalk Bug 81683, Added Methods Modify_Statistic___, Remove_Statistic___, Modify_Invoice_Statistics and Remove_Invoice_Statistics.   
--  080703  AmPalk Merged APP75 SP2.
--  ----------------- APP75 SP2 End ------------------------------------------
--  080304  ChJalk Bug 70742, Handles new columns invoice_no and series_id in methods Insert___, Update___, Unpack_Check_Insert___ and Unpack_Check_Update___.
--  ----------------- APP75 SP2 Start ----------------------------------------
--  080609  AmPalk Added rebate_amt_base, sales_part_rebate_group, rebate_assortment_id and rebate_assort_node_id.
--  060601  MiErlk Enlarge Identity - Changed view comments Description.
--  060410  IsWilk Enlarge Identity - Changed view comments.
--  ------------------------- 13.4.0 -----------------------------------------
--  060206  CsAmlk Changed Payer No and Payer Name to Invoice Customer ID and Invoice Customer Name.
--  050427  MiKulk Bug 50006, Creation_date was added to the view cust_ord_invo_stat.
--  050427         The methods Insert___, Unpack_Check_Insert___, Update___ and
--  050427         Unpack_Check_Update___ were modified by adding the creation_date.
--  040526  GaJalk Bug 44613, Removed the mandatory flag from the branch attribute. Removed the Error_SYS.Check_Not_Null statement from Unpack_check_insert_ and Unpack_check_update_.
--  030227  SuAmlk Code Review.
--  030121  PrJalk Added column branch
--  021231  PrJalk Merged SP3 Changes
--  021204  GaSolk Added additional_discount and additional_curr_discount to the LU.
--  021122  NaWilk Bug 34284, Added columns payer_no, payer_name, customer_price_group, customer_price_grp_desc tothe view CUST_ORD_INVO_STAT.
--  020703  WaJalk Bug 31013, Added columns payer_no, payer_name, customer_price_group, customer_price_grp_desc.
--  990609  JakH   Renamed column prompts.
--  990510  JakH   Renamed column prompts.
--  990406  JakH   New templates.
--  990204  JoEd   Run through Design.
--  990125  KaSu   Removed the mandatory option for part_desc, line_no, rel_no,
--                 and line_item_no from the view comments.
--  981029  KaSu   Renamed the prompt contract as Site.
--                 Renamed the prompts with name Catalog as name with Sales Part.
--  981023  Reza   General_SYS.Init_Method() was included in the necessary Procedure
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Modify_Statistic___
--   This modifies the given invoice statistic record.
PROCEDURE Modify_Statistic___ (
   attr_         IN OUT VARCHAR2,
   statistic_no_ IN     NUMBER )
IS
   oldrec_     CUST_ORD_INVO_STAT_TAB%ROWTYPE;
   newrec_     CUST_ORD_INVO_STAT_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_   Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(statistic_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Statistic___;


-- Remove_Statistic___
--   This removes the given invoice statistic record.
PROCEDURE Remove_Statistic___ (
   statistic_no_ IN NUMBER )
IS
   remrec_     CUST_ORD_INVO_STAT_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(statistic_no_);
   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_, objversion_, statistic_no_);
   Delete___(objid_, remrec_);
END Remove_Statistic___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_ord_invo_stat_tab%ROWTYPE,
   newrec_ IN OUT cust_ord_invo_stat_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Client_SYS.Add_To_Attr('INVOICE_DATE', newrec_.invoice_date, attr_);
   Client_SYS.Add_To_Attr('INVOICE_NO', newrec_.invoice_no, attr_);
   Client_SYS.Add_To_Attr('SERIES_ID', newrec_.series_id, attr_);

END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Modify_Invoice_Statistics
--   This modifies the invoice statistic records. If item_id is NULL it updates all the statistic records for a
--   given company and invoice_id. If the item_id has a value then it updates the statistic record that is relevant
--   to the given company, invoice_id and item_id combination.
PROCEDURE Modify_Invoice_Statistics (
   attr_        IN OUT VARCHAR2,
   company_     IN     VARCHAR2, 
   invoice_id_  IN     NUMBER,
   item_id_     IN     NUMBER DEFAULT NULL)
IS 
   stat_no_      NUMBER;

   CURSOR get_all_stat_recs IS
      SELECT statistic_no 
      FROM CUST_ORD_INVO_STAT_TAB
      WHERE company = company_
      AND   invoice_id = invoice_id_;

   CURSOR get_all_stat_recs_for_item IS
      SELECT statistic_no 
      FROM CUST_ORD_INVO_STAT_TAB
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;

BEGIN
   IF (item_id_ IS NULL) THEN
      FOR stat_rec_ IN get_all_stat_recs LOOP
         Modify_Statistic___(attr_, stat_rec_.statistic_no);
      END LOOP;
   ELSE
      OPEN get_all_stat_recs_for_item;
      FETCH get_all_stat_recs_for_item INTO stat_no_;
      CLOSE get_all_stat_recs_for_item;
      IF (stat_no_ IS NOT NULL) THEN
         Modify_Statistic___(attr_, stat_no_);
      END IF;
   END IF;
END Modify_Invoice_Statistics;


-- Remove_Invoice_Statistics
--   This removes the invoice statistic records. If item_id is NULL it removes all the statistic records for a
--   given company and invoice_id. If the item_id has a value then it updates the statistic record that is relevant
--   to the given company, invoice_id and item_id combination.
PROCEDURE Remove_Invoice_Statistics (
   company_     IN VARCHAR2, 
   invoice_id_  IN NUMBER,
   item_id_     IN NUMBER DEFAULT NULL)
IS 
   stat_no_      NUMBER;

   CURSOR get_all_stat_recs IS
      SELECT statistic_no 
      FROM CUST_ORD_INVO_STAT_TAB
      WHERE company = company_
      AND   invoice_id = invoice_id_;

   CURSOR get_all_stat_recs_for_item IS
      SELECT statistic_no 
      FROM CUST_ORD_INVO_STAT_TAB
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;

BEGIN
   IF (item_id_ IS NULL) THEN
      FOR stat_rec_ IN get_all_stat_recs LOOP
         Remove_Statistic___(stat_rec_.statistic_no);
      END LOOP;
   ELSE
      OPEN get_all_stat_recs_for_item;
      FETCH get_all_stat_recs_for_item INTO stat_no_;
      CLOSE get_all_stat_recs_for_item;
      IF (stat_no_ IS NOT NULL) THEN
         Remove_Statistic___(stat_no_);
      END IF;
   END IF;
END Remove_Invoice_Statistics;



