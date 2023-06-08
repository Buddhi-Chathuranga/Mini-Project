-----------------------------------------------------------------------------
--
--  Logical unit: RebateAgrSalesPartDeal
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170512  AmPalk  STRMF-11637, Valid_To_Date introduced in to Rebate Agreement deals level.
--  170424  ThImlk  STRMF-10971, Modified Copy_Rebate_Sp_Deal_Line___() to correctly set periodic_rebate_amount and rebate_cost_amount values when copying rebate agreements. 
--  170406  ThImlk  STRMF-10459, Added Validate_Sales_Unit_Meas__() and called it from Check_Insert___() to check invalid sales unit mease, when entering Uom manually.
--  161222  ThImlk  STRMF-8328, Modified Copy_Rebate_Sp_Deal_Line___() to pass periodic_rebate_amount and rebate_cost_amount values.
--  161104  RaKalk  STRMF-7689, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- Copy_Rebate_Sp_Deal_Line___
--   Creates a new Deal per Rebate Group record.
PROCEDURE Copy_Rebate_Sp_Deal_Line___ (
   source_rec_        IN REBATE_AGR_SALES_PART_DEAL_TAB%ROWTYPE,
   from_agreement_id_ IN VARCHAR2,
   currency_rate_     IN NUMBER,
   from_valid_from_   IN DATE )
IS
   attr_                      VARCHAR2(32000);
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   newrec_                    REBATE_AGR_SALES_PART_DEAL_TAB%ROWTYPE;
   indrec_                    Indicator_Rec;
   to_periodic_rebate_amount_ REBATE_AGR_SALES_PART_DEAL_TAB.periodic_rebate_amount%TYPE;
   to_rebate_cost_amount_     REBATE_AGR_SALES_PART_DEAL_TAB.rebate_cost_amount%TYPE;
BEGIN

   -- Copy the line
   Prepare_Insert___(attr_);
   
   IF (Rebate_Agreement_API.Get_Rebate_Criteria_Db(from_agreement_id_) = Rebate_Criteria_API.DB_PERCENTAGE )THEN
      to_periodic_rebate_amount_    := source_rec_.periodic_rebate_amount;
      to_rebate_cost_amount_        := source_rec_.rebate_cost_amount;
   ELSE
      to_periodic_rebate_amount_    := (source_rec_.periodic_rebate_amount * currency_rate_);
      to_rebate_cost_amount_        := (source_rec_.rebate_cost_amount * currency_rate_);
   END IF;
   
   Client_SYS.Add_To_Attr('AGREEMENT_ID',             source_rec_.agreement_id, attr_);
   Client_SYS.Add_To_Attr('REBATE_TYPE',              source_rec_.rebate_type, attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO',               source_rec_.catalog_no, attr_);
   Client_SYS.Add_To_Attr('SALES_UNIT_MEAS',          source_rec_.sales_unit_meas, attr_);   
   Client_SYS.Add_To_Attr('HIERARCHY_ID',             source_rec_.hierarchy_id, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL',           source_rec_.customer_level, attr_);
   Client_SYS.Add_To_Attr('REBATE_RATE',              source_rec_.rebate_rate, attr_);
   Client_SYS.Add_To_Attr('REBATE_COST',              source_rec_.rebate_cost, attr_);
   Client_SYS.Add_To_Attr('PERIODIC_REBATE_AMOUNT',   to_periodic_rebate_amount_, attr_);
   Client_SYS.Add_To_Attr('REBATE_COST_AMOUNT',       to_rebate_cost_amount_, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM',               source_rec_.valid_from, attr_);
   Client_SYS.Add_To_Attr('VALID_TO_DATE',            source_rec_.valid_to_date, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);   
   Insert___(objid_, objversion_, newrec_, attr_);

   Rebate_Agr_Sp_Deal_Final_API.Copy_Sales_Part_Deal_Final__(from_agreement_id_,
                                                             source_rec_.agreement_id,
                                                             source_rec_.rebate_type,
                                                             source_rec_.catalog_no,
                                                             source_rec_.sales_unit_meas,
                                                             source_rec_.hierarchy_id,
                                                             source_rec_.customer_level,
                                                             currency_rate_, 
                                                             source_rec_.valid_from,
                                                             from_valid_from_);
END Copy_Rebate_Sp_Deal_Line___;

-- Validate_Sales_Unit_Meas__
--   Checks if the sales_unit_meas exists on sales_part for the user allowed sites . If not found, print an error message.
PROCEDURE Validate_Sales_Unit_Meas__ (
   catalog_no_ IN VARCHAR2,
   company_    IN VARCHAR2,
   sales_uom_  IN VARCHAR2)
IS
   found_      NUMBER;

   CURSOR get_sales_uom IS
      SELECT 1
      FROM   sales_part_tab sa, site_tab si 
      WHERE  si.company = company_
      AND    sa.catalog_no = catalog_no_
      AND    sa.sales_unit_meas = sales_uom_
      AND    sa.contract = si.contract
      AND EXISTS (SELECT 1 FROM user_allowed_site_pub
                   WHERE si.contract = site);
BEGIN
   OPEN get_sales_uom;
   FETCH get_sales_uom INTO found_;
   IF (get_sales_uom%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE get_sales_uom;
   IF found_ = 0 THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_SALES_UOM: The Sales UoM :P1 does not exist.', sales_uom_ );
   END IF;
END Validate_Sales_Unit_Meas__;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN REBATE_AGR_SALES_PART_DEAL_TAB%ROWTYPE )
IS
BEGIN
   IF (Rebate_Agreement_API.Get_Rowstate(remrec_.agreement_id) = 'Active') THEN
      Error_SYS.Record_General(lu_name_, 'REBLINECANNOTDEL: Cannot delete the lines when the rebate agreement is active.');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     REBATE_AGR_SALES_PART_DEAL_TAB%ROWTYPE,
   newrec_ IN OUT REBATE_AGR_SALES_PART_DEAL_TAB%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.rebate_rate > 100 OR newrec_.rebate_rate < 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDRBTRATE: The rebate rate must be between 0 and 100.');
   END IF;
   IF (newrec_.rebate_cost > 100 OR newrec_.rebate_cost < 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDRBTCOST: The rebate cost must be between 0 and 100.');
   END IF;
   IF (newrec_.valid_to_date IS NOT NULL) THEN
      IF (TRUNC(newrec_.valid_to_date) < TRUNC(Rebate_Agreement_Api.Get_Valid_From(newrec_.agreement_id))) OR
         (TRUNC(newrec_.valid_to_date) < newrec_.valid_from) OR
         (TRUNC(newrec_.valid_to_date) > TRUNC(NVL(Rebate_Agreement_Api.Get_Valid_To(newrec_.agreement_id), Database_SYS.Last_Calendar_Date_))) THEN
         Error_SYS.Record_General(lu_name_, 'REBAGREENOTVALIDTO: Valid to date entered is not valid within the valid period of the rebate agreement.');
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT REBATE_AGR_SALES_PART_DEAL_TAB%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   temp_    NUMBER := NULL;
   CURSOR get_existing IS
      SELECT 1
      FROM rebate_agr_sales_part_deal_tab
      WHERE agreement_id = newrec_.agreement_id 
      AND rebate_type = newrec_.rebate_type
      AND catalog_no = newrec_.catalog_no
      AND sales_unit_meas = newrec_.sales_unit_meas
      AND hierarchy_id = newrec_.hierarchy_id
      AND customer_level = newrec_.customer_level
      AND valid_to_date IS NOT NULL 
      AND TRUNC(newrec_.valid_from ) BETWEEN TRUNC(valid_from) AND TRUNC(valid_to_date);
      
BEGIN
   super(newrec_, indrec_, attr_);   
   IF (newrec_.customer_level < Rebate_Agreement_API.Get_Customer_Level(newrec_.agreement_id)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDLEVEL: The hierarchy level cannot be less than the level in the rebate agreement header.');
   END IF; 

   IF (TRUNC(newrec_.valid_from) < TRUNC(Rebate_Agreement_Api.Get_Valid_From(newrec_.agreement_id))) OR
      (TRUNC(newrec_.valid_from) > TRUNC(NVL(Rebate_Agreement_Api.Get_Valid_To(newrec_.agreement_id), newrec_.valid_from))) THEN
      Error_SYS.Record_General(lu_name_, 'REBAGREENOTVALID: Valid from date entered is not valid within the valid period of the rebate agreement.');
   END IF;
   Validate_Sales_Unit_Meas__(newrec_.catalog_no, Rebate_Agreement_API.Get_Company(newrec_.agreement_id),newrec_.sales_unit_meas);
   
   OPEN get_existing;
   FETCH get_existing INTO temp_;
      IF (get_existing%FOUND) THEN
         CLOSE get_existing;
         Error_SYS.Record_General(lu_name_, 'VALIDFROMOVERLAP: Valid from date entered is overlapping with another explicitly defined valid period.');
      END IF;
   CLOSE get_existing;
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_All_Sales_Part_Deals__
--   Copies all Deal per Rebate Group records from one agreement to another.
PROCEDURE Copy_All_Sales_Part_Deals__ (
   from_agreement_id_ IN VARCHAR2,
   to_agreement_id_   IN VARCHAR2,
   valid_from_date_   IN DATE,
   to_valid_from_     IN DATE,
   currency_rate_     IN NUMBER )
IS
   CURSOR  get_source_all IS
      SELECT *
      FROM REBATE_AGR_SALES_PART_DEAL_TAB
      WHERE agreement_id = from_agreement_id_;

   CURSOR get_min_date_rec IS
      SELECT MAX(valid_from) valid_date,
             rebate_type,
             catalog_no,
             sales_unit_meas,
             hierarchy_id,
             customer_level
      FROM REBATE_AGR_SALES_PART_DEAL_TAB
      WHERE agreement_id = from_agreement_id_
      AND   valid_from  <= valid_from_date_
      GROUP BY rebate_type, catalog_no, sales_unit_meas, hierarchy_id, customer_level;

   CURSOR get_source (valid_date_ IN DATE, rebate_type_ IN VARCHAR2, catalog_no_ IN VARCHAR2, sales_unit_meas_ IN VARCHAR2, hierarchy_id_ IN VARCHAR2, customer_level_ IN NUMBER) IS
      SELECT *
      FROM REBATE_AGR_SALES_PART_DEAL_TAB
      WHERE agreement_id            = from_agreement_id_
      AND   valid_from              = valid_date_
      AND   rebate_type             = rebate_type_
      AND   catalog_no              = catalog_no_
      AND   sales_unit_meas         = sales_unit_meas_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_;
            
BEGIN

   IF (to_valid_from_ IS NULL) THEN
      IF (valid_from_date_ IS NULL) THEN
         -- Copy all lines with original valid from date
         FOR source_rec_ IN get_source_all LOOP
            source_rec_.agreement_id := to_agreement_id_;
            Copy_Rebate_Sp_Deal_Line___(source_rec_, from_agreement_id_, currency_rate_, source_rec_.valid_from);
         END LOOP;
      ELSE
         -- Copy valid lines as at valid_from_date_
         FOR date_rec_ IN get_min_date_rec LOOP
            FOR source_rec_ IN get_source(date_rec_.valid_date, date_rec_.rebate_type, date_rec_.catalog_no, date_rec_.sales_unit_meas , date_rec_.hierarchy_id, date_rec_.customer_level) LOOP
               source_rec_.agreement_id := to_agreement_id_;
               Copy_Rebate_Sp_Deal_Line___(source_rec_, from_agreement_id_, currency_rate_, date_rec_.valid_date);
            END LOOP;
         END LOOP;
      END IF;
   ELSE
      -- Copy valid lines as at valid_from_date_ with valid from date to_valid_from_
      FOR date_rec_ IN get_min_date_rec LOOP
         FOR source_rec_ IN get_source(date_rec_.valid_date, date_rec_.rebate_type, date_rec_.catalog_no, date_rec_.sales_unit_meas, date_rec_.hierarchy_id, date_rec_.customer_level) LOOP
            source_rec_.agreement_id := to_agreement_id_;
            source_rec_.valid_from   := to_valid_from_;
            Copy_Rebate_Sp_Deal_Line___(source_rec_, from_agreement_id_, currency_rate_, date_rec_.valid_date);
         END LOOP;
      END LOOP;
   END IF;
END Copy_All_Sales_Part_Deals__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   agreement_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR agreement_lines_exist IS
      SELECT 1
      FROM REBATE_AGR_SALES_PART_DEAL_TAB
      WHERE agreement_id = agreement_id_;
BEGIN
   OPEN agreement_lines_exist;
   FETCH agreement_lines_exist INTO temp_;
   IF (agreement_lines_exist%NOTFOUND) THEN
      temp_ := 0;
   END IF;
   CLOSE agreement_lines_exist;
   RETURN temp_;
END Check_Exist;


-------------------- LU  NEW METHODS -------------------------------------
