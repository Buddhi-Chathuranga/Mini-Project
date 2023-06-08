-----------------------------------------------------------------------------
--
--  Logical unit: AgreementSalesPartHist
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210108  RavDlk SC2020R1-11982, Modified Modify_When_Reported by removing unused variables
--  210108  RavDlk SC2020R1-11982, Modified New and Modify_When_Reported by removing unnecessary packing and unpacking of attrubute string
--  120123  ChJalk Modified the view comments of the columns retrospective_report_date, retrospective_amount and retrospective_qty.
--  100512  Ajpelk Merge rose method documentation
-- ----------------------------Eagle------------------------------------------
--  070223  MoMalk Bug 58176, Made changes to the code to use 
--  080107  KiSalk Removed contract and added min_quantity and valid_from_date
-- --------------------------- Nice Price Start ------------------------------
--  070223  MoMalk Bug 58176, Made changes to the code to use
--  070223         Fnd_Session_API.Get_Fnd_User instead of oracle method user.
--  050520  SaJjlk Added column PROVISIONAL_PRICE and modified method New.
--  040524  SaRalk Bug 44357, Added a new column Printed_By. Changed procedures Unpack_Check_Insert___, Insert___, Unpack_Check_Update___
--  040524         Update___ and Modify_When_Reported.
--  990419  JoAn  Changed the reference to AgreementSalesPartDeal to cascade
--  990407  PaLj  New Yoshimura Templates
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  981029  CAST  Created.
--  981217  CAST  Adjusted method Modify_When_Reported
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Next_Change_No___
--   Returns next ChangeNo for AgreementId, Contract and CatalogNo.
FUNCTION Get_Next_Change_No___ (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2 ) RETURN NUMBER
IS
   change_no_  NUMBER;
   CURSOR get_next IS
      SELECT MAX(change_no) + 1
      FROM   AGREEMENT_SALES_PART_HIST_TAB
      WHERE  agreement_id = agreement_id_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    catalog_no = catalog_no_;
BEGIN
   OPEN get_next;
   FETCH get_next INTO change_no_;
   CLOSE get_next;
   change_no_ := NVL(change_no_, 0);
   RETURN change_no_;
END Get_Next_Change_No___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public method for creation of a new history record
PROCEDURE New (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2,
   deal_price_      IN NUMBER,
   old_deal_price_  IN NUMBER )
IS
   change_no_           AGREEMENT_SALES_PART_HIST_TAB.change_no%TYPE;
   provisional_price_   AGREEMENT_SALES_PART_HIST_TAB.provisional_price%TYPE;
   attr_                VARCHAR2(32000) := NULL;
   newrec_              AGREEMENT_SALES_PART_HIST_TAB%ROWTYPE;
BEGIN
   change_no_           := Get_Next_Change_No___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   provisional_price_   := Agreement_Sales_Part_Deal_API.Get_Provisional_Price_Db(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   
   Client_SYS.Clear_Attr(attr_);
   newrec_.min_quantity         := min_quantity_;
   newrec_.valid_from_date      := valid_from_date_;
   newrec_.catalog_no           := catalog_no_;
   newrec_.agreement_id         := agreement_id_;
   newrec_.change_no            := change_no_;
   newrec_.deal_price           := deal_price_;
   newrec_.old_deal_price       := old_deal_price_;
   newrec_.change_date          := SYSDATE;
   newrec_.user_code            := Fnd_Session_API.Get_Fnd_User;
   newrec_.provisional_price    := provisional_price_;   
   New___(newrec_);  
END New;


-- Modify_When_Reported
--   Modify RetrospectiveReportDate, RetrospectiveQty and RetrospectiveAmount
--   for a history record
PROCEDURE Modify_When_Reported (
   agreement_id_              IN VARCHAR2,
   min_quantity_              IN NUMBER,
   valid_from_date_           IN DATE,
   catalog_no_                IN VARCHAR2,
   change_no_                 IN NUMBER,
   retrospective_report_date_ IN DATE,
   retrospective_qty_         IN NUMBER,
   retrospective_amount_      IN NUMBER )
IS
   newrec_      AGREEMENT_SALES_PART_HIST_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_, change_no_);
   newrec_.retrospective_report_date := retrospective_report_date_;
   newrec_.retrospective_qty         := retrospective_qty_;
   newrec_.retrospective_amount      := retrospective_amount_;
   newrec_.printed_by                := Fnd_Session_API.Get_Fnd_User;
   Modify___(newrec_);
END Modify_When_Reported;



