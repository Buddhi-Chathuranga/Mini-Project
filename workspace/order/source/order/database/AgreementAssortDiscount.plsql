-----------------------------------------------------------------------------
--
--  Logical unit: AgreementAssortDiscount
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210115  RavDlk   SC2020R1-12090, Removed unnecessary packing and unpacking of attrubute string in Modify_Price_Data___, Sync_Discount_Line__ and Copy_All_Discount_Lines__ 
--  180123  CKumlk   STRSC-15930, Modified Check_Common___ by changing Get_State() to Get_Objstate().
--  180103  SBalLK   Bug 139564, Modified Copy_All_Discount_Lines__() method to set total_discount_ amount to NULL when only there is no records for in the discount table.
--  110509  NWeelk   Bug 96967, Modified methods Calc_Discount_Upd_Agr_Line__ and Sync_Discount_Line__ by setting NULL to the discount if there are no 
--  110509           discout percentages are defined and moved function Discount_Amount_Exist to AgreementAssortmentDeal, modified method Copy_All_Discount_Lines__
--  110509           to set value for discount correctly. 
--  110428  NWeelk   Bug 96125, Removed not null checks in method Copy_All_Discount_Lines__ and added not null checks in method Sync_Discount_Line__
--  110428           to set correct values for discount and discount amount.
--  110418  NWeelk   Bug 96125, Added function Discount_Amount_Exist, removed error message DISCAMOUNTNOPRICE from Unpack_Check_Insert___ 
--  110418           and Unpack_Check_Update___, modified method Sync_Discount_Line__ to update calculation basis upon changing the price base, 
--  110418           modified Calculate_Discount__ to calculate discounts correctly when the deal price is NULL and added error message INVALIDCALCB.
--  110524  MaMalk   Modified Calc_Discount_Upd_Agr_Line__ to pass the discount as null when no discount lines exist.
--  080130  KiSalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Modify_Price_Data___ (
   agreement_id_      IN VARCHAR2,
   min_quantity_      IN NUMBER,
   valid_from_         IN DATE,
   price_unit_meas_    IN VARCHAR2,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   discount_no_        IN NUMBER,
   calculation_basis_  IN NUMBER,
   price_currency_     IN NUMBER )
IS
   newrec_               AGREEMENT_ASSORT_DISCOUNT_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_, discount_no_);
   newrec_.calculation_basis := calculation_basis_;
   newrec_.price_currency    := price_currency_;
   Modify___(newrec_);
END Modify_Price_Data___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT AGREEMENT_ASSORT_DISCOUNT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_seq_no (agreement_id_ IN VARCHAR2, assortment_id_   IN VARCHAR2, assortment_node_id_ IN VARCHAR2, min_quantity_ IN NUMBER, valid_from_ IN DATE, price_unit_meas_ IN VARCHAR2) IS
      SELECT nvl(max(discount_no) + 1, 1)
      FROM AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND assortment_id = assortment_id_
      AND assortment_node_id = assortment_node_id_
      AND min_quantity = min_quantity_
      AND valid_from = valid_from_      
      AND price_unit_meas = price_unit_meas_;

BEGIN
   OPEN get_seq_no(newrec_.agreement_id, newrec_.assortment_id, newrec_.assortment_node_id, newrec_.min_quantity, newrec_.valid_from, newrec_.price_unit_meas);
   FETCH get_seq_no INTO newrec_.discount_no;
   CLOSE get_seq_no;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     agreement_assort_discount_tab%ROWTYPE,
   newrec_ IN OUT agreement_assort_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   head_state_ VARCHAR2(20);
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   head_state_ := Customer_Agreement_API.Get_Objstate(newrec_.agreement_id);
   IF ((newrec_.calculation_basis = 0) AND (newrec_.discount_amount != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISC: The total discount given cannot exceed the line price.');
   END IF;

   IF (newrec_.calculation_basis <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDCALCB: Total Discount should not exceed 100%.');
   END IF; 

   IF (head_state_ ='Closed') THEN
      Error_SYS.Record_General(lu_name_, 'NODISCOUNT: No discounts may be added to a deal per assortment discount line when the customer agreement is Closed.');
   END IF;

   IF (newrec_.discount IS NULL) AND (newrec_.discount_amount IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INSNODISCOUNT: You have to enter a Discount or a Discount Amount.');
   END IF;

   IF (newrec_.discount IS NOT NULL) AND (newrec_.discount_amount IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INSTWODISCOUNT: Both Discount and Discount Amount cannot be used at the same time.');
   END IF;
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Calculate_Discount__
--   Calculate line and total discounts, and modifies attributes calculation_basis,
--   price_currency in all lines per particular deal per assortment.
PROCEDURE Calculate_Discount__ (
   total_discount_     IN OUT NUMBER,
   agreement_id_       IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_         IN DATE,
   price_unit_meas_    IN VARCHAR2,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 )
IS
   assort_deal_rec_       Agreement_Assortment_Deal_API.Public_Rec;
   agree_rec_             Customer_Agreement_API.Public_Rec;

   currency_rounding_     NUMBER;
   calculation_basis_     NUMBER;
   price_currency_        NUMBER;
   price_curr_            NUMBER;
   deal_price_            NUMBER;
   line_discount_amount_  NUMBER;
   total_discount_amount_ NUMBER;

   no_sum_or_amount_          BOOLEAN := TRUE;
   total_discount_percentage_ NUMBER := 0;

   CURSOR get_line IS
      SELECT  discount, discount_amount, discount_no
      FROM AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_quantity_
      AND   valid_from = valid_from_
      AND   price_unit_meas = price_unit_meas_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_
      ORDER BY discount_line_no;
BEGIN
   
   assort_deal_rec_  := Agreement_Assortment_Deal_API.Get(agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_);
   agree_rec_ := Customer_Agreement_API.Get(agreement_id_);
   
   currency_rounding_ := NVL(assort_deal_rec_.rounding, Currency_Code_API.Get_Currency_Rounding(agree_rec_.company, agree_rec_.currency_code));
   deal_price_ := NVL(assort_deal_rec_.deal_price, 1);
   price_curr_ := deal_price_;
   calculation_basis_ := price_curr_;

   total_discount_amount_ := 0;

   IF (assort_deal_rec_.deal_price IS NULL) THEN
      FOR rec_ IN get_line LOOP
         IF (rec_.discount_amount IS NULL) THEN
            price_currency_ := price_curr_ - (calculation_basis_ * (rec_.discount / 100));
            
            line_discount_amount_  := price_curr_ - price_currency_;
            
            total_discount_amount_ := total_discount_amount_ + line_discount_amount_;
            
            Modify_Price_Data___(agreement_id_, min_quantity_, valid_from_, price_unit_meas_, assortment_id_,
                                  assortment_node_id_, rec_.discount_no, calculation_basis_, price_currency_);
            
            calculation_basis_ := price_currency_;
            price_curr_ := price_currency_;
            
         ELSE
            -- Set the calculation_basis_ to NULL if the discount_amount is specified.  
            Modify_Price_Data___(agreement_id_, min_quantity_, valid_from_, price_unit_meas_, assortment_id_,
                                  assortment_node_id_, rec_.discount_no, NULL, price_currency_);
         END IF;
      END LOOP;
   ELSE
      FOR rec_ IN get_line LOOP
         -- Calculate the price after discount in Agreement currency
         IF (rec_.discount_amount IS NULL) THEN
            price_currency_ := price_curr_ - (calculation_basis_ * (rec_.discount / 100));
         ELSE
            price_currency_ := price_curr_ - rec_.discount_amount;
         END IF;

         -- Round the discount amount for each discount line, with the number of
         -- decimals specified for the line; if line rounding is null, that of order currency.
         line_discount_amount_ := price_curr_ - price_currency_;

         -- Add up the total discount amount for the deal so far
         total_discount_amount_ := total_discount_amount_ + line_discount_amount_;

         -- Update the discount record
         Modify_Price_Data___(agreement_id_, min_quantity_, valid_from_, price_unit_meas_, assortment_id_,
                                  assortment_node_id_, rec_.discount_no, calculation_basis_, price_currency_);
      
         IF (no_sum_or_amount_ = TRUE) THEN
            IF (calculation_basis_ != deal_price_ ) OR (rec_.discount_amount IS NOT NULL) THEN
               -- A discount amout has been specified or a partial sum has been specified for
               -- a previous line.
               -- In both cases it will not be possible to store the sum of the discount percentages
               -- for the discount records as the discount on the order line as this would cause
               -- errors when posting the invoice.
               no_sum_or_amount_ := FALSE;
            END IF;
            -- Sum up the discount percentages so far
            total_discount_percentage_ := total_discount_percentage_ + rec_.discount;
         END IF;

         -- Use the price after discount as new calculation basis, since create_partial_sum will be 'PARTIAL SUM' 
         -- for the CO and SQ lines created with these lines
         calculation_basis_ := price_currency_;
         price_curr_ := price_currency_;

      END LOOP;
   END IF;

   IF (deal_price_ = 0) THEN
      total_discount_ := 0;
   ELSIF (no_sum_or_amount_ = TRUE) AND
         (total_discount_amount_ =
          (ROUND(deal_price_ * (total_discount_percentage_ / 100), currency_rounding_))) THEN
      -- The sum of all discounts would give the same discount amount as the calculated amount.
      -- Return the sum instead of the calculated value to avoid problems with uneven values
      -- for the calculated percentage on the order line
      total_discount_ := total_discount_percentage_;
   ELSE
      total_discount_ := (total_discount_amount_ / deal_price_) * 100;
   END IF;

END Calculate_Discount__;


-- Calc_Discount_Upd_Agr_Line__
--   Calculate total discount, considering Agreement_Assort_Discount lines
--   and updates Agreement_Assortment_Deal.
PROCEDURE Calc_Discount_Upd_Agr_Line__ (
   agreement_id_       IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_         IN DATE,
   price_unit_meas_    IN VARCHAR2,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 )
IS
   total_discount_      NUMBER;
   discount_type_       AGREEMENT_ASSORT_DISCOUNT_TAB.discount_type%TYPE;
   line_count_          NUMBER;
   assort_deal_rec_     Agreement_Assortment_Deal_API.Public_Rec;
   disc_                NUMBER;


   CURSOR get_discount_type IS
      SELECT MAX(discount_type)
      FROM   AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_quantity_
      AND   valid_from = valid_from_
      AND   price_unit_meas = price_unit_meas_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_;
   
   CURSOR get_discount IS
      SELECT count(discount)
      FROM AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id       = agreement_id_
      AND   min_quantity       = min_quantity_
      AND   valid_from         = valid_from_
      AND   price_unit_meas    = price_unit_meas_
      AND   assortment_id      = assortment_id_
      AND   assortment_node_id = assortment_node_id_;

BEGIN

   Calculate_Discount__(total_discount_, agreement_id_, min_quantity_, valid_from_, price_unit_meas_, assortment_id_, assortment_node_id_);

   
   line_count_ := Agreement_Assortment_Deal_API.Get_Disc_Line_Count_Per_Deal__(agreement_id_, min_quantity_, valid_from_, price_unit_meas_, assortment_id_, assortment_node_id_);
   assort_deal_rec_  := Agreement_Assortment_Deal_API.Get(agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_);

   IF (line_count_ = 0 ) THEN
      total_discount_ := null;
      discount_type_ := '';
      -- or delete Agreement_Assortment_Deal record if no deal price available.
   ELSIF (line_count_ = 1 ) THEN
      --Single discount per Agreement_Assortment_Deal
      IF (assort_deal_rec_.deal_price IS NULL) THEN
         OPEN  get_discount;
         FETCH get_discount INTO disc_;
         CLOSE get_discount;
         IF (NVL(disc_, 0) = 0) THEN
            total_discount_ := NULL;
         END IF;
      END IF;

      OPEN get_discount_type;
      FETCH get_discount_type INTO discount_type_;
      CLOSE get_discount_type;
   ELSE
      --Multiple discounts per Agreement_Assortment_Deal
      IF (assort_deal_rec_.deal_price IS NULL) THEN
         OPEN  get_discount;
         FETCH get_discount INTO disc_;
         CLOSE get_discount;
         IF (NVL(disc_, 0) = 0) THEN
            total_discount_ := NULL;
         END IF;
      END IF;

      discount_type_ := '';
   END IF;
   Agreement_Assortment_Deal_API.Modify_Discount__(agreement_id_, min_quantity_, valid_from_, price_unit_meas_, assortment_id_, assortment_node_id_, total_discount_, discount_type_);
END Calc_Discount_Upd_Agr_Line__;


-- Sync_Discount_Line__
--   Makes changes done in Agreement_Assortment_Deal those affect discount,
--   available for Agreement_Assort_Discount.
PROCEDURE Sync_Discount_Line__ (
   agreement_id_       IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_         IN DATE,
   price_unit_meas_    IN VARCHAR2,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 )
IS
   oldrec_              AGREEMENT_ASSORT_DISCOUNT_TAB%ROWTYPE;
   newrec_              AGREEMENT_ASSORT_DISCOUNT_TAB%ROWTYPE;
   objid_               AGREEMENT_ASSORT_DISCOUNT.objid%TYPE;
   objversion_          AGREEMENT_ASSORT_DISCOUNT.objversion%TYPE;
   discount_no_         AGREEMENT_ASSORT_DISCOUNT_TAB.discount_no%TYPE;
   line_count_          NUMBER;
   assort_deal_rec_     Agreement_Assortment_Deal_API.Public_Rec;
   temp_                NUMBER;
   recalculate_         BOOLEAN := FALSE;
   discount_type_       AGREEMENT_ASSORT_DISCOUNT_TAB.discount_type%TYPE;
   disc_amount_         AGREEMENT_ASSORT_DISCOUNT_TAB.discount_amount%TYPE;
   disc_                NUMBER;

   CURSOR get_discount_no IS
      SELECT discount_no
      FROM   AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_quantity_
      AND   valid_from = valid_from_
      AND   price_unit_meas = price_unit_meas_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_;

   CURSOR get_discount_type IS
      SELECT MAX(discount_type)
      FROM   AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_quantity_
      AND   valid_from = valid_from_
      AND   price_unit_meas = price_unit_meas_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_;
   
   CURSOR get_disc_amount IS
      SELECT discount_amount
      FROM AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id       = agreement_id_
      AND   min_quantity       = min_quantity_
      AND   valid_from         = valid_from_
      AND   price_unit_meas    = price_unit_meas_
      AND   assortment_id      = assortment_id_
      AND   assortment_node_id = assortment_node_id_;

   CURSOR get_discount IS
      SELECT count(discount)
      FROM AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id       = agreement_id_
      AND   min_quantity       = min_quantity_
      AND   valid_from         = valid_from_
      AND   price_unit_meas    = price_unit_meas_
      AND   assortment_id      = assortment_id_
      AND   assortment_node_id = assortment_node_id_;

BEGIN

   line_count_ := Agreement_Assortment_Deal_API.Get_Disc_Line_Count_Per_Deal__(agreement_id_, min_quantity_, valid_from_, price_unit_meas_, assortment_id_, assortment_node_id_);
   assort_deal_rec_  := Agreement_Assortment_Deal_API.Get(agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_);

   IF (line_count_ = 1 ) THEN
      OPEN get_discount_no;
      FETCH get_discount_no INTO discount_no_;
      CLOSE get_discount_no;

      IF (assort_deal_rec_.discount_type IS NULL OR assort_deal_rec_.net_price = 'TRUE') THEN
      --Remove single discount per Agreement_Assortment_Deal
         oldrec_ := Lock_By_Keys___(agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_, discount_no_);
         Get_Id_Version_By_Keys___ (objid_, objversion_, agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_, discount_no_);
         Check_Delete___(oldrec_);
         Delete___(objid_, oldrec_);
      ELSE
      --Edit single discount per Agreement_Assortment_Deal
         newrec_ := Get_Object_By_Keys___(agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_, discount_no_);
         newrec_.discount_type := assort_deal_rec_.discount_type;
         
         OPEN  get_disc_amount;
         FETCH get_disc_amount INTO disc_amount_;
         CLOSE get_disc_amount;
         
         IF disc_amount_ IS NOT NULL THEN
            newrec_.discount := '';
            newrec_.discount_amount := disc_amount_;
         ELSE
            newrec_.discount := assort_deal_rec_.discount;
            newrec_.discount_amount := '';
         END IF;
         Modify___(newrec_);
         recalculate_ := TRUE;
      END IF;
   ELSIF (line_count_ = 0  AND assort_deal_rec_.net_price = 'FALSE') THEN
      --New single discount per Agreement_Assortment_Deal
      newrec_.agreement_id       := agreement_id_;
      newrec_.min_quantity       := min_quantity_;
      newrec_.valid_from         := valid_from_;
      newrec_.price_unit_meas    := price_unit_meas_;
      newrec_.assortment_id      := assortment_id_;
      newrec_.assortment_node_id := assortment_node_id_;
      newrec_.discount_type      := assort_deal_rec_.discount_type;
      newrec_.discount           := assort_deal_rec_.discount;
      newrec_.discount_line_no   := 1;
      New___(newrec_);
      recalculate_ := TRUE;
   ELSIF (line_count_ > 1 AND assort_deal_rec_.net_price = 'TRUE') THEN
      FOR rec_ IN get_discount_no LOOP
      --Remove all discount lines per Agreement_Assortment_Deal
         oldrec_ := Lock_By_Keys___(agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_, rec_.discount_no);
         Get_Id_Version_By_Keys___ (objid_, objversion_, agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_, rec_.discount_no);
         Check_Delete___(oldrec_);
         Delete___(objid_, oldrec_);
      END LOOP;
   ELSIF (line_count_ > 1 AND assort_deal_rec_.net_price = 'FALSE') THEN
      recalculate_ := TRUE; 
   END IF;

   IF (recalculate_) THEN
      -- To set calculation basis etc. for the discount/ deal price of Agreement_Assortment_Deal
      Calculate_Discount__(temp_, agreement_id_, min_quantity_, valid_from_, price_unit_meas_, assortment_id_, assortment_node_id_);
      line_count_ := Agreement_Assortment_Deal_API.Get_Disc_Line_Count_Per_Deal__(agreement_id_, min_quantity_, valid_from_, price_unit_meas_, assortment_id_, assortment_node_id_);
      IF (line_count_ = 0 ) THEN
         temp_ := NULL;
         discount_type_ := '';
      ELSIF (line_count_ = 1 ) THEN
         --Single discount per Agreement_Assortment_Deal
         IF (assort_deal_rec_.deal_price IS NULL) THEN
            OPEN  get_discount;
            FETCH get_discount INTO disc_;
            CLOSE get_discount;
            IF (NVL(disc_, 0) = 0) THEN
               temp_ := NULL;
            END IF;
         END IF;

         OPEN get_discount_type;
         FETCH get_discount_type INTO discount_type_;
         CLOSE get_discount_type;
      ELSE
         --Multiple discounts per Agreement_Assortment_Deal
         IF (assort_deal_rec_.deal_price IS NULL) THEN
            OPEN  get_discount;
            FETCH get_discount INTO disc_;
            CLOSE get_discount;
            IF (NVL(disc_, 0) = 0) THEN
               temp_ := NULL;
            END IF;
         END IF;

         discount_type_ := '';
      END IF;
      Agreement_Assortment_Deal_API.Modify_Discount__(agreement_id_, min_quantity_, valid_from_, price_unit_meas_, assortment_id_, assortment_node_id_, temp_, discount_type_);
   END IF;

END Sync_Discount_Line__;


-- Copy_All_Discount_Lines__
--   Copies all Agreement_Assort_Discount lines Connected to a particular Agreement_Assortment_Deal, to a new one.
PROCEDURE Copy_All_Discount_Lines__ (
   from_agreement_id_       IN VARCHAR2,
   from_min_quantity_       IN NUMBER,
   from_valid_from_         IN DATE,
   from_price_unit_meas_    IN VARCHAR2,
   from_assortment_id_      IN VARCHAR2,
   from_assortment_node_id_ IN VARCHAR2,
   to_agreement_id_         IN VARCHAR2,
   to_min_quantity_         IN NUMBER,
   to_valid_from_           IN DATE,
   to_price_unit_meas_      IN VARCHAR2,
   to_assortment_id_        IN VARCHAR2,
   to_assortment_node_id_   IN VARCHAR2,
   currency_rate_           IN NUMBER )
IS
   newrec_             AGREEMENT_ASSORT_DISCOUNT_TAB%ROWTYPE;
   temp_currency_rate_ NUMBER;
   assort_deal_rec_    Agreement_Assortment_Deal_API.Public_Rec;
   discount_type_      AGREEMENT_ASSORT_DISCOUNT_TAB.discount_type%TYPE;
   line_count_         NUMBER;   
   disc_               NUMBER;
   total_discount_     NUMBER;

   CURSOR    source IS
      SELECT *
      FROM AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id = from_agreement_id_
      AND min_quantity = from_min_quantity_
      AND valid_from = from_valid_from_
      AND price_unit_meas = from_price_unit_meas_
      AND assortment_id = from_assortment_id_
      AND assortment_node_id = from_assortment_node_id_;

   CURSOR get_discount_type IS
      SELECT MAX(discount_type)
      FROM   AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id       = from_agreement_id_
      AND   min_quantity       = from_min_quantity_
      AND   valid_from         = from_valid_from_
      AND   price_unit_meas    = from_price_unit_meas_
      AND   assortment_id      = from_assortment_id_
      AND   assortment_node_id = from_assortment_node_id_;

   CURSOR get_discount IS
      SELECT COUNT(discount)
      FROM AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id       = from_agreement_id_
      AND   min_quantity       = from_min_quantity_
      AND   valid_from         = from_valid_from_
      AND   price_unit_meas    = from_price_unit_meas_
      AND   assortment_id      = from_assortment_id_
      AND   assortment_node_id = from_assortment_node_id_;

BEGIN

   temp_currency_rate_ := NVL(currency_rate_, 1);
   -- Copy the lines
   FOR source_rec_ IN source LOOP
      newrec_.agreement_id       := to_agreement_id_;
      newrec_.min_quantity       := to_min_quantity_;
      newrec_.valid_from         := to_valid_from_;
      newrec_.price_unit_meas    := to_price_unit_meas_;
      newrec_.assortment_id      := to_assortment_id_;
      newrec_.assortment_node_id := to_assortment_node_id_;
      newrec_.discount_no        := source_rec_.discount_no;
      newrec_.discount           := source_rec_.discount;
      newrec_.discount_amount    := source_rec_.discount_amount * temp_currency_rate_;
      newrec_.discount_line_no   := source_rec_.discount_line_no;
      newrec_.calculation_basis  := source_rec_.calculation_basis * temp_currency_rate_;
      newrec_.price_currency     := source_rec_.price_currency * temp_currency_rate_;
      newrec_.discount_type      := source_rec_.discount_type;
      New___(newrec_);      
   END LOOP;
   
   line_count_ := Agreement_Assortment_Deal_API.Get_Disc_Line_Count_Per_Deal__(to_agreement_id_, to_min_quantity_, to_valid_from_, to_price_unit_meas_, to_assortment_id_, to_assortment_node_id_);
   assort_deal_rec_ := Agreement_Assortment_Deal_API.Get(to_agreement_id_, to_assortment_id_, to_assortment_node_id_, to_min_quantity_, to_valid_from_, to_price_unit_meas_);
   total_discount_ := Agreement_Assortment_Deal_API.Get_Discount(to_agreement_id_, to_assortment_id_, to_assortment_node_id_, to_min_quantity_, to_valid_from_, to_price_unit_meas_); 
   IF (line_count_ = 0 ) THEN
      total_discount_ := NULL;
      discount_type_ := '';
   ELSIF (line_count_ = 1 ) THEN
      --Single discount per Agreement_Assortment_Deal
      IF (assort_deal_rec_.deal_price IS NULL) THEN
         OPEN  get_discount;
         FETCH get_discount INTO disc_;
         CLOSE get_discount;
         IF (NVL(disc_, 0) = 0) THEN
            total_discount_ := NULL;
         END IF;
      END IF;
      OPEN get_discount_type;
      FETCH get_discount_type INTO discount_type_;
      CLOSE get_discount_type;
   ELSE
      --Multiple discounts per Agreement_Assortment_Deal
      IF (assort_deal_rec_.deal_price IS NULL) THEN
         OPEN  get_discount;
         FETCH get_discount INTO disc_;
         CLOSE get_discount;
         IF (NVL(disc_, 0) = 0) THEN
            total_discount_ := NULL;
         END IF;
      END IF;
      discount_type_ := '';
   END IF;
   Agreement_Assortment_Deal_API.Modify_Discount__(to_agreement_id_, to_min_quantity_, to_valid_from_, to_price_unit_meas_, to_assortment_id_, to_assortment_node_id_, total_discount_, discount_type_);

END Copy_All_Discount_Lines__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


