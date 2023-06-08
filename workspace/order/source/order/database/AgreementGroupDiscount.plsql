-----------------------------------------------------------------------------
--
--  Logical unit: AgreementGroupDiscount
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210115  RavDlk   SC2020R1-12090, Removed unnecessary packing and unpacking of attrubute string in Modify_Calculation_Basis___, Sync_Discount_Line__ and Copy_All_Discount_Lines__ 
--  180123  CKumlk   STRSC-15930, Modified Check_Insert___ and Check_Update___ by changing Get_State() to Get_Objstate().
--  110524  MaMalk   Modified Calc_Discount_Upd_Agr_Line__ to pass the discount as null when no discount lines exist.
--  080222  KiSalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Modify_Calculation_Basis___ (
   agreement_id_      IN VARCHAR2,
   min_quantity_      IN NUMBER,
   valid_from_date_   IN DATE,
   catalog_group_     IN VARCHAR2,
   discount_no_       IN NUMBER,
   calculation_basis_ IN NUMBER )
IS
   newrec_               AGREEMENT_GROUP_DISCOUNT_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(agreement_id_, catalog_group_, valid_from_date_, min_quantity_, discount_no_);
   newrec_.calculation_basis := calculation_basis_;
   Modify___(newrec_);
END Modify_Calculation_Basis___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT AGREEMENT_GROUP_DISCOUNT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_seq_no (agreement_id_ IN VARCHAR2, min_quantity_ IN NUMBER, valid_from_date_ IN DATE, catalog_group_ IN VARCHAR2) IS
      SELECT nvl(max(discount_no) + 1, 1)
      FROM AGREEMENT_GROUP_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND min_quantity = min_quantity_
      AND valid_from_date = valid_from_date_
      AND   catalog_group = catalog_group_;

BEGIN
      
   OPEN get_seq_no(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date, newrec_.catalog_group);
   FETCH get_seq_no INTO newrec_.discount_no;
   CLOSE get_seq_no;
   
   super(objid_, objversion_, newrec_, attr_);

END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT agreement_group_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   head_state_ VARCHAR2(20);
BEGIN
   super(newrec_, indrec_, attr_);

   head_state_ := Customer_Agreement_API.Get_Objstate(newrec_.agreement_id);

   IF (head_state_ ='Closed') THEN
      Error_SYS.Record_General(lu_name_, 'NODISCOUNT: No discounts may be added to a deal sales group discount line when the customer agreement is Closed.');
   END IF;

END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     agreement_group_discount_tab%ROWTYPE,
   newrec_ IN OUT agreement_group_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   head_state_ VARCHAR2(20);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   head_state_ := Customer_Agreement_API.Get_Objstate(newrec_.agreement_id);

   IF (newrec_.calculation_basis = 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISC: The total discount given cannot exceed the line price.');
   END IF;

   IF (head_state_ ='Closed') THEN
      Error_SYS.Record_General(lu_name_, 'NODISCOUNTMODI: Discounts cannot be modified in deal per sales group line when the customer agreement is Closed.');
   END IF;

END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Calculate_Discount__
--   Calculate line and total discounts, and modifies attribute calculation_basis
--   in all lines per particular deal per part.
PROCEDURE Calculate_Discount__ (
   total_discount_  IN OUT NUMBER,
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_group_   IN VARCHAR2 )
IS
   calculation_basis_     NUMBER;


   CURSOR get_line IS
      SELECT  discount, discount_no
      FROM AGREEMENT_GROUP_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   catalog_group = catalog_group_
      AND   min_quantity = min_quantity_
      AND   valid_from_date = valid_from_date_
      ORDER BY discount_line_no;
BEGIN

   calculation_basis_ := 1;
   total_discount_ := 0;

   FOR rec_ IN get_line LOOP
      -- Add up the total discount for the deal so far
      total_discount_ := total_discount_ + (calculation_basis_ * rec_.discount);

      -- Update the discount record
      Modify_Calculation_Basis___(agreement_id_, min_quantity_, valid_from_date_, catalog_group_, rec_.discount_no, calculation_basis_);

      -- New calculation basis for next line, since create_partial_sum will be 'PARTIAL SUM'
      -- for the CO and SQ lines created with these lines
      calculation_basis_ := calculation_basis_ * (1 - rec_.discount / 100);

   END LOOP;

END Calculate_Discount__;


-- Calc_Discount_Upd_Agr_Line__
--   Calculate total discount, considering AGREEMENT_GROUP_DISCOUNT lines
--   and updates Agreement_Sales_Group_Deal.
PROCEDURE Calc_Discount_Upd_Agr_Line__ (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_group_   IN VARCHAR2 )
IS
   total_discount_      NUMBER;
   discount_type_       AGREEMENT_GROUP_DISCOUNT_TAB.discount_type%TYPE;
   line_count_          NUMBER;

   CURSOR get_discount_type IS
      SELECT MAX(discount_type)
      FROM   AGREEMENT_GROUP_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_quantity_
      AND   valid_from_date = valid_from_date_
      AND   catalog_group = catalog_group_;
BEGIN

   Calculate_Discount__(total_discount_, agreement_id_, min_quantity_, valid_from_date_, catalog_group_);


   line_count_ := Agreement_Sales_Group_Deal_API.Get_Disc_Line_Count_Per_Deal__(agreement_id_, catalog_group_, valid_from_date_, min_quantity_);
   IF (line_count_ = 0 ) THEN
      total_discount_ := NULL;
      discount_type_ := '';
      -- or delete Agreement_Sales_Group_Deal record if no deal price available.
   ELSIF (line_count_ = 1 ) THEN
      --Single discount per Agreement_Sales_Group_Deal
      OPEN get_discount_type;
      FETCH get_discount_type INTO discount_type_;
      CLOSE get_discount_type;
   ELSE
      --Multiple discounts per Agreement_Sales_Group_Deal
      discount_type_ := '';
   END IF;
   Agreement_Sales_Group_Deal_API.Modify_Discount__(agreement_id_, catalog_group_, valid_from_date_, min_quantity_, total_discount_, discount_type_);
END Calc_Discount_Upd_Agr_Line__;


-- Sync_Discount_Line__
--   Makes changes done in Agreement_Sales_Group_Deal those affect discount,
--   available for AGREEMENT_GROUP_DISCOUNT.
PROCEDURE Sync_Discount_Line__ (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_group_   IN VARCHAR2 )
IS
   oldrec_              AGREEMENT_GROUP_DISCOUNT_TAB%ROWTYPE;
   newrec_              AGREEMENT_GROUP_DISCOUNT_TAB%ROWTYPE;
   objid_               AGREEMENT_GROUP_DISCOUNT.objid%TYPE;
   objversion_          AGREEMENT_GROUP_DISCOUNT.objversion%TYPE;
   discount_no_         AGREEMENT_GROUP_DISCOUNT_TAB.discount_no%TYPE;
   line_count_          NUMBER;
   group_deal_rec_       Agreement_Sales_Group_Deal_API.Public_Rec;
   temp_                NUMBER;
   recalculate_         BOOLEAN := FALSE;

   CURSOR get_discount_no IS
      SELECT MAX(discount_no)
      FROM   AGREEMENT_GROUP_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_quantity_
      AND   valid_from_date = valid_from_date_
      AND   catalog_group = catalog_group_;
BEGIN

   line_count_ := Agreement_Sales_Group_Deal_API.Get_Disc_Line_Count_Per_Deal__(agreement_id_, catalog_group_, valid_from_date_, min_quantity_);
   IF (line_count_ = 1 ) THEN
      OPEN get_discount_no;
      FETCH get_discount_no INTO discount_no_;
      CLOSE get_discount_no;

      group_deal_rec_  := Agreement_Sales_Group_Deal_API.Get(agreement_id_, catalog_group_, valid_from_date_, min_quantity_);
      IF (group_deal_rec_.discount_type IS NULL) THEN
      --Remove single discount per Agreement_Sales_Group_Deal
         oldrec_ := Lock_By_Keys___(agreement_id_, catalog_group_, valid_from_date_, min_quantity_, discount_no_);
         Get_Id_Version_By_Keys___ (objid_, objversion_, agreement_id_, catalog_group_, valid_from_date_, min_quantity_, discount_no_);
         Check_Delete___(oldrec_);
         Delete___(objid_, oldrec_);
      ELSE
      --Edit single discount per Agreement_Sales_Group_Deal
         newrec_ := Get_Object_By_Keys___(agreement_id_, catalog_group_, valid_from_date_, min_quantity_, discount_no_);
         newrec_.discount_type := group_deal_rec_.discount_type;
         newrec_.discount := group_deal_rec_.discount;
         Modify___(newrec_);
         recalculate_ := TRUE;
      END IF;
   ELSIF (line_count_ = 0 ) THEN
      --New single discount per Agreement_Sales_Group_Deal
      group_deal_rec_  := Agreement_Sales_Group_Deal_API.Get(agreement_id_, catalog_group_, valid_from_date_, min_quantity_ );
      newrec_.agreement_id     := agreement_id_;
      newrec_.min_quantity     := min_quantity_;
      newrec_.valid_from_date  := valid_from_date_;
      newrec_.catalog_group    := catalog_group_;
      newrec_.discount_type    := group_deal_rec_.discount_type;
      newrec_.discount         := group_deal_rec_.discount;
      newrec_.discount_line_no := 1;
      New___(newrec_);
      recalculate_ := TRUE;
   END IF;
   IF (recalculate_) THEN
      -- To set calculation basis etc. for the discount/ deal price of Agreement_Sales_Group_Deal
      Calculate_Discount__(temp_, agreement_id_, min_quantity_, valid_from_date_, catalog_group_);
   END IF;
END Sync_Discount_Line__;


-- Copy_All_Discount_Lines__
--   Copies all AGREEMENT_GROUP_DISCOUNT lines of a particular Agreement_Sales_Group_Deal to a new one.
PROCEDURE Copy_All_Discount_Lines__ (
   from_agreement_id_    IN VARCHAR2,
   from_min_quantity_    IN NUMBER,
   from_valid_from_date_ IN DATE,
   from_catalog_group_   IN VARCHAR2,
   to_agreement_id_      IN VARCHAR2,
   to_min_quantity_      IN NUMBER,
   to_valid_from_date_   IN DATE,
   to_catalog_group_     IN VARCHAR2 )
IS
   newrec_             AGREEMENT_GROUP_DISCOUNT_TAB%ROWTYPE;
   CURSOR    source IS
      SELECT *
      FROM AGREEMENT_GROUP_DISCOUNT_TAB
      WHERE agreement_id = from_agreement_id_
      AND min_quantity = from_min_quantity_
      AND valid_from_date = from_valid_from_date_
      AND catalog_group = from_catalog_group_;
BEGIN

   -- Copy the lines
   FOR source_rec_ IN source LOOP
      newrec_.agreement_id      := to_agreement_id_;
      newrec_.min_quantity      := to_min_quantity_;
      newrec_.valid_from_date   := to_valid_from_date_;
      newrec_.catalog_group     := to_catalog_group_;
      newrec_.discount_no       := source_rec_.discount_no;
      newrec_.discount          := source_rec_.discount;
      newrec_.discount_line_no  := source_rec_.discount_line_no;
      newrec_.calculation_basis := source_rec_.calculation_basis;
      newrec_.discount_type     := source_rec_.discount_type;
      New___(newrec_);
   END LOOP;
END Copy_All_Discount_Lines__;

FUNCTION Check_Multiple_Discount_Lines (
   agreement_id_      IN VARCHAR2,
   min_quantity_      IN NUMBER,
   valid_from_date_   IN DATE,
   catalog_group_     IN VARCHAR2 ) RETURN VARCHAR2
IS  
   dummy_ NUMBER;
   CURSOR check_record IS
      SELECT COUNT(discount_no)
      FROM AGREEMENT_GROUP_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND min_quantity = min_quantity_
      AND valid_from_date = valid_from_date_
      AND catalog_group = catalog_group_;
BEGIN
   OPEN check_record;
   FETCH check_record INTO dummy_;
   CLOSE check_record;
   
   IF dummy_ > 1 THEN
      RETURN 'FALSE';
   END IF;
   RETURN 'TRUE';   
END Check_Multiple_Discount_Lines;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


