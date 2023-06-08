-----------------------------------------------------------------------------
--
--  Logical unit: AgreementPartDiscount
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210115  RavDlk   SC2020R1-12090, Removed unnecessary packing and unpacking of attrubute string in Modify_Price_Data___, Sync_Discount_Line__ and Copy_All_Discount_Lines__ 
--  180123  CKumlk   STRSC-15930, Modified Check_Insert___ and Check_Update___ by changing Get_State() to Get_Objstate().
--  120910  JeeJlk   Changed Calculate_Discount__ to calculate price_incl_tax_currency value.
--  120907  JeeJlk   Added new column price_incl_tax_currency.
--  110509  NWeelk   Bug 96967, Modified methods Calc_Discount_Upd_Agr_Line__ and Sync_Discount_Line__ by setting NULL to the discount if there are 
--  110509           no discout percentages are defined and moved function Discount_Amount_Exist to AgreementSalesPartDeal, modified method Copy_All_Discount_Lines__
--  110509           by setting value for discount correctly. 
--  110428  NWeelk   Bug 96125, Removed not null checks in method Copy_All_Discount_Lines__ and added not null checks in method Sync_Discount_Line__
--  110428           to set correct values for discount and discount amount.  
--  110418  NWeelk   Bug 96125, Added function Discount_Amount_Exist and removed error message DISCAMOUNTNOPRICE from Unpack_Check_Insert___ 
--  110418           and Unpack_Check_Update___, modified method Sync_Discount_Line__ to update calculation basis upon changing the price base, 
--  110418           modified Calculate_Discount__ to calculate discounts correctly when the deal price is NULL and added error message INVALIDCALCB.
--  110523  MaMalk   Modified Copy_All_Discount_Lines__ to initialize the newrec_ when looping.
--  110520  MaMalk   Modified Calc_Discount_Upd_Agr_Line__ to pass discount as null when no discounts exist.
--  110204  RiLase   Added public interface Calc_Discount_Upd_Agr_Line().
--  080208  KiSalk   Added methods Sync_Discount_Line__ and Copy_All_Discount_Lines__.
--  080101  KiSalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Modify_Price_Data___ (
   agreement_id_            IN VARCHAR2,
   min_quantity_            IN NUMBER,
   valid_from_date_         IN DATE,
   catalog_no_              IN VARCHAR2,
   discount_no_             IN NUMBER,
   calculation_basis_       IN NUMBER,
   price_currency_          IN NUMBER,
   price_incl_tax_currency_ IN NUMBER )
IS
   newrec_               AGREEMENT_PART_DISCOUNT_TAB%ROWTYPE;
BEGIN

   newrec_ := Get_Object_By_Keys___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_, discount_no_);
   newrec_.calculation_basis       := calculation_basis_;
   newrec_.price_currency          := price_currency_;
   newrec_.price_incl_tax_currency := price_incl_tax_currency_;
   Modify___(newrec_);
END Modify_Price_Data___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT AGREEMENT_PART_DISCOUNT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_seq_no (agreement_id_ IN VARCHAR2, min_quantity_ IN NUMBER, valid_from_date_ IN DATE, catalog_no_ IN VARCHAR2) IS
      SELECT nvl(max(discount_no) + 1, 1)
      FROM AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND min_quantity = min_quantity_
      AND valid_from_date = valid_from_date_
      AND   catalog_no = catalog_no_;

BEGIN
   
   OPEN get_seq_no(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date, newrec_.catalog_no);
   FETCH get_seq_no INTO newrec_.discount_no;
   CLOSE get_seq_no;
   
   super(objid_, objversion_, newrec_, attr_);

END Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     agreement_part_discount_tab%ROWTYPE,
   newrec_ IN OUT agreement_part_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   IF ((newrec_.calculation_basis = 0) AND (newrec_.discount_amount != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISC: The total discount given cannot exceed the line price.');
   END IF;

   IF (newrec_.calculation_basis <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDCALCB: Total Discount should not exceed 100%.');
   END IF;
   
   IF (newrec_.discount IS NULL) AND (newrec_.discount_amount IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INSNODISCOUNT: You have to enter a Discount or a Discount Amount.');
   END IF;

   IF (newrec_.discount IS NOT NULL) AND (newrec_.discount_amount IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INSTWODISCOUNT: Both Discount and Discount Amount cannot be used at the same time.');
   END IF;

END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT agreement_part_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   head_state_ VARCHAR2(20);
BEGIN
   super(newrec_, indrec_, attr_);
   
   head_state_ := Customer_Agreement_API.Get_Objstate(newrec_.agreement_id);
   IF (head_state_ ='Closed') THEN
      Error_SYS.Record_General(lu_name_, 'NODISCOUNT: No discounts may be added to a deal per part discount line when the customer agreement is Closed.');
   END IF;   
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     agreement_part_discount_tab%ROWTYPE,
   newrec_ IN OUT agreement_part_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   head_state_ VARCHAR2(20);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   head_state_ := Customer_Agreement_API.Get_Objstate(newrec_.agreement_id);   
   IF (head_state_ ='Closed') THEN
      Error_SYS.Record_General(lu_name_, 'NODISCOUNTMODI: Discounts cannot be modified in deal per part line when the customer agreement is Closed.');
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Calculate_Discount__
--   Calculate line and total discounts, and modifies attributes calculation_basis,
--   price_currency in all lines per particular deal per part.
PROCEDURE Calculate_Discount__ (
   total_discount_  IN OUT NUMBER,
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2 )
IS
   part_deal_rec_           Agreement_Sales_Part_Deal_API.Public_Rec;
   agree_rec_               Customer_Agreement_API.Public_Rec;

   currency_rounding_       NUMBER;
   calculation_basis_       NUMBER;
   price_currency_          NUMBER;
   price_incl_tax_currency_ NUMBER; 
   price_curr_              NUMBER;
   deal_price_              NUMBER;
   deal_price_incl_tax_     NUMBER;
   line_discount_amount_    NUMBER;
   total_discount_amount_   NUMBER;
   no_sum_or_amount_          BOOLEAN := TRUE;
   total_discount_percentage_ NUMBER := 0; 
   tax_cal_basis_             VARCHAR2(10);

   CURSOR get_line IS
      SELECT  discount, discount_amount, discount_no
      FROM AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   catalog_no = catalog_no_
      AND   min_quantity = min_quantity_
      AND   valid_from_date = valid_from_date_
      ORDER BY discount_line_no;
BEGIN
   
   part_deal_rec_  := Agreement_Sales_Part_Deal_API.Get(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   agree_rec_ := Customer_Agreement_API.Get(agreement_id_);   
   currency_rounding_ := NVL(part_deal_rec_.rounding, Currency_Code_API.Get_Currency_Rounding(agree_rec_.company, agree_rec_.currency_code));
   IF (agree_rec_.use_price_incl_tax = 'TRUE') THEN
      deal_price_incl_tax_ := NVL(part_deal_rec_.deal_price_incl_tax, 1);
      price_curr_ := deal_price_incl_tax_;    
   ELSE
      deal_price_ := NVL(part_deal_rec_.deal_price, 1);
      price_curr_ := deal_price_;
   END IF;
   
   calculation_basis_ := price_curr_;

   total_discount_amount_ := 0;

   IF (part_deal_rec_.deal_price IS NULL) THEN
      FOR rec_ IN get_line LOOP
         IF (rec_.discount_amount IS NULL) THEN
            IF (agree_rec_.use_price_incl_tax = 'TRUE') THEN
               --First discount amount should be calculated and then price incl tax (after applying discount)
               --is calculated. Finally price(after applying discount) should be calculated using price incl tax after applying discount.
               line_discount_amount_    := calculation_basis_ * (rec_.discount / 100);            
               price_incl_tax_currency_ := price_curr_ - line_discount_amount_ ; -- price incl tax after applying discount
               tax_cal_basis_           := 'GROSS_BASE';               
            ELSE
               price_currency_          := price_curr_ - (calculation_basis_ * (rec_.discount / 100)); -- price after applying discount
               line_discount_amount_    := price_curr_ - price_currency_;
               tax_cal_basis_           := 'NET_BASE';               
            END IF;
            Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(price_currency_,
                                                                 price_incl_tax_currency_,
                                                                 part_deal_rec_.base_price_site,
                                                                 catalog_no_,
                                                                 tax_cal_basis_,
                                                                 16);
            total_discount_amount_ := total_discount_amount_ + line_discount_amount_;
            
            Modify_Price_Data___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_, rec_.discount_no,
                                 calculation_basis_, price_currency_, price_incl_tax_currency_);
            
            IF (agree_rec_.use_price_incl_tax = 'TRUE') THEN
                calculation_basis_       := price_incl_tax_currency_;
                price_curr_              := price_incl_tax_currency_;
            ELSE
               calculation_basis_       := price_currency_;
               price_curr_              := price_currency_;
            END IF;
            
         ELSE
            -- Set the calculation_basis_ to NULL if the discount_amount is specified.  
            Modify_Price_Data___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_, rec_.discount_no,
                                 NULL, price_currency_, price_incl_tax_currency_);
         END IF;
      END LOOP;
   ELSE
      FOR rec_ IN get_line LOOP
         -- Calculate the price after discount in Agreement currency
         IF (rec_.discount_amount IS NULL) THEN
            IF (agree_rec_.use_price_incl_tax = 'TRUE') THEN
               price_incl_tax_currency_ := price_curr_ - calculation_basis_ * (rec_.discount / 100); 
               tax_cal_basis_           := 'GROSS_BASE';               
            ELSE
               price_currency_          := price_curr_ - (calculation_basis_ * (rec_.discount / 100));
               tax_cal_basis_           := 'NET_BASE';               
            END IF;            
         ELSE
            IF (agree_rec_.use_price_incl_tax = 'TRUE') THEN
               price_incl_tax_currency_ := price_curr_ - rec_.discount_amount;
               tax_cal_basis_           := 'GROSS_BASE';                
            ELSE 
               price_currency_          := price_curr_ - rec_.discount_amount;
               tax_cal_basis_           := 'NET_BASE';                
            END IF;
         END IF;
         Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(price_currency_,
                                                              price_incl_tax_currency_,
                                                              part_deal_rec_.base_price_site,
                                                              catalog_no_,
                                                              tax_cal_basis_,
                                                              16);
         -- Round the discount amount for each discount line, with the number of
         -- decimals specified for the line; if line rounding is null, that of order currency.
         IF (agree_rec_.use_price_incl_tax = 'TRUE') THEN
            IF (rec_.discount_amount IS NULL) THEN
               line_discount_amount_ := calculation_basis_ * (rec_.discount / 100); 
            ELSE
               line_discount_amount_ := rec_.Discount_Amount;
            END IF;
         ELSE
            line_discount_amount_ := price_curr_ - price_currency_;
         END IF;
         
         -- Add up the total discount amount for the deal so far
         total_discount_amount_ := total_discount_amount_ + line_discount_amount_;
   
         -- Update the discount record
         Modify_Price_Data___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_, rec_.discount_no,
                                 calculation_basis_, price_currency_, price_incl_tax_currency_);
   
         IF (no_sum_or_amount_ = TRUE) THEN
            IF (calculation_basis_ != deal_price_ ) OR (calculation_basis_ != deal_price_incl_tax_ ) OR (rec_.discount_amount IS NOT NULL) THEN
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
         IF (agree_rec_.use_price_incl_tax = 'TRUE') THEN
            calculation_basis_ := price_incl_tax_currency_;
            price_curr_        := price_incl_tax_currency_;
         ELSE
            calculation_basis_ := price_currency_;
            price_curr_ := price_currency_;
         END IF;
   
      END LOOP;
   END IF;
   
   IF (agree_rec_.use_price_incl_tax = 'TRUE') THEN
      IF (deal_price_incl_tax_ = 0) THEN
         total_discount_ := 0;
      ELSIF (no_sum_or_amount_ = TRUE) AND
            (total_discount_amount_ =
             (ROUND(deal_price_incl_tax_ * (total_discount_percentage_ / 100), currency_rounding_))) THEN
         -- The sum of all discounts would give the same discount amount as the calculated amount.
         -- Return the sum instead of the calculated value to avoid problems with uneven values
         -- for the calculated percentage on the order line
         total_discount_ := total_discount_percentage_;
      ELSE
         total_discount_ := (total_discount_amount_ / deal_price_incl_tax_) * 100;
      END IF;
   ELSE
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
   END IF;

END Calculate_Discount__;


-- Calc_Discount_Upd_Agr_Line__
--   Calculate total discount, considering Agreement_Part_Discount lines
--   and updates Agreement_Sales_Part_Deal.
PROCEDURE Calc_Discount_Upd_Agr_Line__ (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2 )
IS
   total_discount_      NUMBER;
   discount_type_       AGREEMENT_PART_DISCOUNT_TAB.discount_type%TYPE;
   line_count_          NUMBER;
   part_deal_rec_       Agreement_Sales_Part_Deal_API.Public_Rec;
   disc_                NUMBER;


   CURSOR get_discount_type IS
      SELECT MAX(discount_type)
      FROM   AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_quantity_
      AND   valid_from_date = valid_from_date_
      AND   catalog_no = catalog_no_;
   
   CURSOR get_discount IS
      SELECT count(discount)
      FROM AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id    = agreement_id_
      AND   min_quantity    = min_quantity_
      AND   valid_from_date = valid_from_date_
      AND   catalog_no      = catalog_no_;

BEGIN

   Calculate_Discount__(total_discount_, agreement_id_, min_quantity_, valid_from_date_, catalog_no_);

   
   line_count_ := Agreement_Sales_Part_Deal_API.Get_Disc_Line_Count_Per_Deal__(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   part_deal_rec_  := Agreement_Sales_Part_Deal_API.Get(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);

   IF (line_count_ = 0 ) THEN
      total_discount_ := NULL;
      discount_type_ := '';
      -- or delete Agreement_Sales_Part_Deal record if no deal price available.
   ELSIF (line_count_ = 1 ) THEN
      --Single discount per Agreement_Sales_Part_Deal
      IF (part_deal_rec_.deal_price IS NULL) THEN
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
      --Multiple discounts per Agreement_Sales_Part_Deal
      IF (part_deal_rec_.deal_price IS NULL) THEN
         OPEN  get_discount;
         FETCH get_discount INTO disc_;
         CLOSE get_discount;
         IF (NVL(disc_, 0) = 0) THEN
            total_discount_ := NULL;
         END IF;
      END IF;

      discount_type_ := '';
   END IF;
   Agreement_Sales_Part_Deal_API.Modify_Discount__(agreement_id_, min_quantity_, valid_from_date_, catalog_no_, total_discount_, discount_type_);
END Calc_Discount_Upd_Agr_Line__;


-- Sync_Discount_Line__
--   Makes changes done in Agreement_Sales_Part_Deal those affect discount,
--   available for Agreement_Part_Discount.
PROCEDURE Sync_Discount_Line__ (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2 )
IS
   oldrec_              AGREEMENT_PART_DISCOUNT_TAB%ROWTYPE;
   newrec_              AGREEMENT_PART_DISCOUNT_TAB%ROWTYPE;
   objid_               AGREEMENT_PART_DISCOUNT.objid%TYPE;
   objversion_          AGREEMENT_PART_DISCOUNT.objversion%TYPE;
   discount_no_         AGREEMENT_PART_DISCOUNT_TAB.discount_no%TYPE;
   line_count_          NUMBER;
   part_deal_rec_       Agreement_Sales_Part_Deal_API.Public_Rec;
   temp_                NUMBER;
   recalculate_         BOOLEAN := FALSE;
   discount_type_       AGREEMENT_PART_DISCOUNT_TAB.discount_type%TYPE;
   disc_amount_         AGREEMENT_PART_DISCOUNT_TAB.discount_amount%TYPE;
   disc_                NUMBER;

   CURSOR get_discount_no IS
      SELECT discount_no
      FROM   AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_quantity_
      AND   valid_from_date = valid_from_date_
      AND   catalog_no = catalog_no_;

   CURSOR get_discount_type IS
      SELECT MAX(discount_type)
      FROM   AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_quantity_
      AND   valid_from_date = valid_from_date_
      AND   catalog_no = catalog_no_;
   
   CURSOR get_disc_amount IS
      SELECT discount_amount
      FROM AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id    = agreement_id_
      AND   min_quantity    = min_quantity_
      AND   valid_from_date = valid_from_date_
      AND   catalog_no      = catalog_no_;

   CURSOR get_discount IS
      SELECT count(discount)
      FROM AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id    = agreement_id_
      AND   min_quantity    = min_quantity_
      AND   valid_from_date = valid_from_date_
      AND   catalog_no      = catalog_no_;


BEGIN

   line_count_ := Agreement_Sales_Part_Deal_API.Get_Disc_Line_Count_Per_Deal__(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   part_deal_rec_  := Agreement_Sales_Part_Deal_API.Get(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   IF (line_count_ = 1 ) THEN
      OPEN get_discount_no;
      FETCH get_discount_no INTO discount_no_;
      CLOSE get_discount_no;

      IF (part_deal_rec_.discount_type IS NULL OR part_deal_rec_.net_price = 'TRUE') THEN
      --Remove single discount per Agreement_Sales_Part_Deal
         oldrec_ := Lock_By_Keys___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_, discount_no_);
         Get_Id_Version_By_Keys___ (objid_, objversion_, agreement_id_, min_quantity_, valid_from_date_, catalog_no_, discount_no_);
         Check_Delete___(oldrec_);
         Delete___(objid_, oldrec_);
      ELSE
      --Edit single discount per Agreement_Sales_Part_Deal
         newrec_ := Get_Object_By_Keys___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_, discount_no_);
         newrec_.discount_type := part_deal_rec_.discount_type;
         OPEN  get_disc_amount;
         FETCH get_disc_amount INTO disc_amount_;
         CLOSE get_disc_amount;
         
         IF disc_amount_ IS NOT NULL THEN
            newrec_.discount := '';
            newrec_.discount_amount := disc_amount_;
         ELSE
            newrec_.discount := part_deal_rec_.discount;
            newrec_.discount_amount := '';
         END IF;
         
         Modify___(newrec_);
         recalculate_ := TRUE;
      END IF;
   ELSIF (line_count_ = 0 AND part_deal_rec_.net_price = 'FALSE') THEN
      --New single discount per Agreement_Sales_Part_Deal
      newrec_.agreement_id     := agreement_id_;
      newrec_.min_quantity     := min_quantity_;
      newrec_.valid_from_date  := valid_from_date_;
      newrec_.catalog_no       := catalog_no_;
      newrec_.discount_type    := part_deal_rec_.discount_type;
      newrec_.discount         := part_deal_rec_.discount;
      newrec_.discount_line_no := 1;
      New___(newrec_);
      recalculate_ := TRUE;
   ELSIF (line_count_ > 1 AND part_deal_rec_.net_price = 'TRUE') THEN
      FOR rec_ IN get_discount_no LOOP
      --Remove all discount lines per Agreement_Sales_Part_Deal
         oldrec_ := Lock_By_Keys___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_, rec_.discount_no);
         Get_Id_Version_By_Keys___ (objid_, objversion_, agreement_id_, min_quantity_, valid_from_date_, catalog_no_, rec_.discount_no);
         Check_Delete___(oldrec_);
         Delete___(objid_, oldrec_);
      END LOOP;
   -- Set recalculate_ to TRUE to call method Calculate_Discount__ when there are multiple discount lines. 
   ELSIF (line_count_ > 1 AND part_deal_rec_.net_price = 'FALSE') THEN
      recalculate_ := TRUE;
   END IF;
   IF (recalculate_) THEN
      -- To set calculation basis etc. for the discount/ deal price of Agreement_Sales_Part_Deal
      Calculate_Discount__(temp_, agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
      line_count_ := Agreement_Sales_Part_Deal_API.Get_Disc_Line_Count_Per_Deal__(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
      IF (line_count_ = 0 ) THEN
         temp_ := NULL;
         discount_type_ := '';
      ELSIF (line_count_ = 1 ) THEN
         --Single discount per Agreement_Sales_Part_Deal
         IF (part_deal_rec_.deal_price IS NULL) THEN
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
         --Multiple discounts per Agreement_Sales_Part_Deal
         IF (part_deal_rec_.deal_price IS NULL) THEN
            OPEN  get_discount;
            FETCH get_discount INTO disc_;
            CLOSE get_discount;
            IF (NVL(disc_, 0) = 0) THEN
               temp_ := NULL;
            END IF;
         END IF;
         discount_type_ := '';
      END IF;
      Agreement_Sales_Part_Deal_API.Modify_Discount__(agreement_id_, min_quantity_, valid_from_date_, catalog_no_, temp_, discount_type_); 
   END IF;
END Sync_Discount_Line__;


-- Copy_All_Discount_Lines__
--   Copies all agreement_Part_Discount lines of a particular Agreement_Sales_Part_Deal to a new one.
PROCEDURE Copy_All_Discount_Lines__ (
   from_agreement_id_    IN VARCHAR2,
   from_min_quantity_    IN NUMBER,
   from_valid_from_date_ IN DATE,
   from_catalog_no_      IN VARCHAR2,
   to_agreement_id_      IN VARCHAR2,
   to_min_quantity_      IN NUMBER,
   to_valid_from_date_   IN DATE,
   to_catalog_no_        IN VARCHAR2,
   currency_rate_        IN NUMBER )
IS
   newrec_             AGREEMENT_PART_DISCOUNT_TAB%ROWTYPE;
   temp_currency_rate_ NUMBER;
   part_deal_rec_       Agreement_Sales_Part_Deal_API.Public_Rec;
   discount_type_       AGREEMENT_PART_DISCOUNT_TAB.discount_type%TYPE;
   line_count_          NUMBER;   
   disc_                NUMBER;
   total_discount_      NUMBER;

   CURSOR    source IS
      SELECT *
      FROM AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id = from_agreement_id_
      AND min_quantity = from_min_quantity_
      AND valid_from_date = from_valid_from_date_
      AND catalog_no = from_catalog_no_;
   
   CURSOR get_discount_type IS
      SELECT MAX(discount_type)
      FROM   AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id    = from_agreement_id_
      AND   min_quantity    = from_min_quantity_
      AND   valid_from_date = from_valid_from_date_
      AND   catalog_no      = from_catalog_no_;

   CURSOR get_discount IS
      SELECT count(discount)
      FROM AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id    = from_agreement_id_
      AND   min_quantity    = from_min_quantity_
      AND   valid_from_date = from_valid_from_date_
      AND   catalog_no      = from_catalog_no_;

BEGIN

   temp_currency_rate_ := NVL(currency_rate_, 1);
   -- Copy the lines
   FOR source_rec_ IN source LOOP
      newrec_ := NULL;
      newrec_.agreement_id      := to_agreement_id_;
      newrec_.min_quantity      := to_min_quantity_;
      newrec_.valid_from_date   := to_valid_from_date_;
      newrec_.catalog_no        := to_catalog_no_;
      newrec_.discount_no       := source_rec_.discount_no;
      newrec_.discount          := source_rec_.discount;
      newrec_.discount_amount   := source_rec_.discount_amount * temp_currency_rate_;
      newrec_.discount_line_no  := source_rec_.discount_line_no;
      newrec_.calculation_basis := source_rec_.calculation_basis * temp_currency_rate_;
      newrec_.price_currency    := source_rec_.price_currency * temp_currency_rate_;
      newrec_.discount_type     := source_rec_.discount_type;      
      New___(newrec_);
   END LOOP;

   line_count_ := Agreement_Sales_Part_Deal_API.Get_Disc_Line_Count_Per_Deal__(to_agreement_id_, to_min_quantity_, to_valid_from_date_, to_catalog_no_);
   part_deal_rec_ := Agreement_Sales_Part_Deal_API.Get(to_agreement_id_, to_min_quantity_, to_valid_from_date_, to_catalog_no_);
   total_discount_ := Agreement_Sales_Part_Deal_API.Get_Discount(to_agreement_id_, to_min_quantity_, to_valid_from_date_, to_catalog_no_);
   IF (line_count_ = 0 ) THEN
      total_discount_ := NULL;
      discount_type_ := '';
   ELSIF (line_count_ = 1 ) THEN
      --Single discount per Agreement_Sales_Part_Deal
      IF (part_deal_rec_.deal_price IS NULL) THEN
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
      --Multiple discounts per Agreement_Sales_Part_Deal
      IF (part_deal_rec_.deal_price IS NULL) THEN
         OPEN  get_discount;
         FETCH get_discount INTO disc_;
         CLOSE get_discount;
         IF (NVL(disc_, 0) = 0) THEN
            total_discount_ := NULL;
         END IF;
      END IF;
      discount_type_ := '';
   END IF;
   Agreement_Sales_Part_Deal_API.Modify_Discount__(to_agreement_id_, to_min_quantity_, to_valid_from_date_, to_catalog_no_, total_discount_, discount_type_);

END Copy_All_Discount_Lines__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Calc_Discount_Upd_Agr_Line (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2 )
IS
BEGIN
   Calc_Discount_Upd_Agr_Line__(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
END Calc_Discount_Upd_Agr_Line;


PROCEDURE Update_Discount_Lines (
   agreement_id_    IN VARCHAR2)
IS
   CURSOR get_deal_part_lines IS
      SELECT agreement_id, min_quantity, valid_from_date, catalog_no
      FROM agreement_sales_part_deal_tab
      WHERE agreement_id = agreement_id_;
   
BEGIN
   FOR rec_ IN get_deal_part_lines LOOP
      Calc_Discount_Upd_Agr_Line__(rec_.agreement_id, rec_.min_quantity, rec_.valid_from_date, rec_.catalog_no);
   END LOOP;
   
END Update_Discount_Lines;



