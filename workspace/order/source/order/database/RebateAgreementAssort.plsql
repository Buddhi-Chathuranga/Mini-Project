-----------------------------------------------------------------------------
--
--  Logical unit: RebateAgreementAssort
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210126  RavDlk   SC2020R1-12324, Removed unnecessary packing and unpacking of attrubute string in Copy_Rebate_Assortment_Line___
--  170512  AmPalk   STRMF-11637, Valid_To_Date introduced in to Rebate Agreement deals level.
--  170424  ThImlk   STRMF-10971, Modified Copy_Rebate_Assortment_Line___() to correctly set periodic_rebate_amount and rebate_cost_amount values when copying rebate agreements. 
--  161222  ThImlk   STRMF-8328, Modified Copy_Rebate_Assortment_Line___() to pass periodic_rebate_amount and rebate_cost_amount values.
--  131029  MaMalk   Removed the length part of Rebate_Cost and Rebate_Rate in the view comments.
--  120124  ChJalk   Modified the view comments of the base view for the column VALID_FROM.
--  110915  MaMalk   Modified Check_Before_Ins_And_Upd___ to allow 0 and 100 for rabate cost and rate.
--  110819  NWeelk   Bug 97235, Added from_valid_from_ as a parameter to the method Copy_Rebate_Assortment_Line___ and passed it to Copy_Assortment_Final__. 
--  110419  JeLise   Modified method Unpack_Check_Insert___ by introducing an error message to raise if 
--  110419           the valid from date entered is not within the range and modified method Copy_All_Rebate_Assortments__ 
--  110419           to select and copy records having correct valid from dates.
--  091108  AmPalk   Bug 85942, Made valid_from a key field. Restricted the line deletion when the header is active. 
--  091110  RiLase   Added Check_Before_Ins_And_Upd___.
--  091002  DaZase   Added length on view comment for rebate_type.
--  081208  KiSalk   Added method Check_Active_Deal_Per_Assort.
--  081001  JeLise   Changed rebate_rate and rebate_cost to mandatory.
--  080918  JeLise   Added attribute structure_level.
--  080528  JeLise   Added methods Copy_All_Rebate_Assortments__ and Copy_Rebate_Assortment_Line___.
--  080519  JeLise   Added methods Check_Exist and Has_Valid_Deal.
--  080515  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Copy_Rebate_Assortment_Line___ (
   source_rec_        IN REBATE_AGREEMENT_ASSORT_TAB%ROWTYPE,
   from_agreement_id_ IN VARCHAR2,
   currency_rate_     IN NUMBER,
   from_valid_from_   IN DATE )
IS
   newrec_     REBATE_AGREEMENT_ASSORT_TAB%ROWTYPE;
   to_periodic_rebate_amount_ REBATE_AGREEMENT_ASSORT_TAB.periodic_rebate_amount%TYPE;
   to_rebate_cost_amount_     REBATE_AGREEMENT_ASSORT_TAB.rebate_cost_amount%TYPE;
BEGIN

   -- Copy the line   
   IF (Rebate_Agreement_API.Get_Rebate_Criteria_Db(from_agreement_id_) = Rebate_Criteria_API.DB_PERCENTAGE )THEN
      to_periodic_rebate_amount_    := source_rec_.periodic_rebate_amount;
      to_rebate_cost_amount_        := source_rec_.rebate_cost_amount;
   ELSE
      to_periodic_rebate_amount_    := (source_rec_.periodic_rebate_amount * currency_rate_);
      to_rebate_cost_amount_        := (source_rec_.rebate_cost_amount * currency_rate_);
   END IF;
   
   newrec_.agreement_id           := source_rec_.agreement_id;
   newrec_.rebate_type            := source_rec_.rebate_type;
   newrec_.assortment_id          := source_rec_.assortment_id;
   newrec_.assortment_node_id     := source_rec_.assortment_node_id;
   newrec_.hierarchy_id           := source_rec_.hierarchy_id;
   newrec_.customer_level         := source_rec_.customer_level;
   newrec_.rebate_rate            := source_rec_.rebate_rate;
   newrec_.rebate_cost            := source_rec_.rebate_cost;
   newrec_.periodic_rebate_amount := to_periodic_rebate_amount_;
   newrec_.rebate_cost_amount     := to_rebate_cost_amount_;
   newrec_.valid_from             := source_rec_.valid_from;
   newrec_.structure_level        := source_rec_.structure_level;
   newrec_.valid_to_date          := source_rec_.valid_to_date;
   New___(newrec_);
   Rebate_Agr_Assort_Final_API.Copy_Assortment_Final__(from_agreement_id_, source_rec_.agreement_id,
                                                       source_rec_.rebate_type, source_rec_.assortment_id,
                                                       source_rec_.assortment_node_id, source_rec_.hierarchy_id,
                                                       source_rec_.customer_level, currency_rate_, 
                                                       source_rec_.valid_from, from_valid_from_);
END Copy_Rebate_Assortment_Line___;


PROCEDURE Check_Before_Ins_And_Upd___ (
   newrec_ IN REBATE_AGREEMENT_ASSORT_TAB%ROWTYPE)
IS
BEGIN

   IF (newrec_.rebate_rate > 100 OR newrec_.rebate_rate < 0) THEN
      Error_SYS.Record_General(lu_name_, 'REBATERATEVALIDATION: The rebate rate must be between 0 and 100.');
   END IF;

   IF (newrec_.rebate_cost > 100 OR newrec_.rebate_cost < 0) THEN
      Error_SYS.Record_General(lu_name_, 'REBATECOSTVALIDATION: The rebate cost must be between 0 and 100.');
   END IF;
   
   IF (newrec_.valid_to_date IS NOT NULL) THEN
      IF (TRUNC(newrec_.valid_to_date) < TRUNC(Rebate_Agreement_Api.Get_Valid_From(newrec_.agreement_id))) OR
         (TRUNC(newrec_.valid_to_date) < newrec_.valid_from) OR
         (TRUNC(newrec_.valid_to_date) > TRUNC(NVL(Rebate_Agreement_Api.Get_Valid_To(newrec_.agreement_id), Database_SYS.Last_Calendar_Date_))) THEN
         Error_SYS.Record_General(lu_name_, 'REBAGREENOTVALIDTO: Valid to date entered is not valid within the valid period of the rebate agreement.');
      END IF;
   END IF;
END Check_Before_Ins_And_Upd___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN REBATE_AGREEMENT_ASSORT_TAB%ROWTYPE )
IS
BEGIN
   IF (Rebate_Agreement_API.Get_Rowstate(remrec_.agreement_id) = 'Active') THEN
      Error_SYS.Record_General(lu_name_, 'REBLINECANNOTDEL: Cannot delete the lines when the rebate agreement is active.');
   END IF;
   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     rebate_agreement_assort_tab%ROWTYPE,
   newrec_ IN OUT rebate_agreement_assort_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);   
   Check_Before_Ins_And_Upd___(newrec_);
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT rebate_agreement_assort_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   temp_    NUMBER := NULL;
   CURSOR get_existing IS
      SELECT 1
      FROM rebate_agreement_assort_tab
      WHERE agreement_id = newrec_.agreement_id 
      AND rebate_type = newrec_.rebate_type
      AND assortment_id = newrec_.assortment_id
      AND assortment_node_id = newrec_.assortment_node_id
      AND hierarchy_id = newrec_.hierarchy_id
      AND customer_level = newrec_.customer_level
      AND valid_to_date IS NOT NULL 
      AND TRUNC(newrec_.valid_from ) BETWEEN TRUNC(valid_from) AND TRUNC(valid_to_date);
BEGIN
   super(newrec_, indrec_, attr_);
   IF (TRUNC(newrec_.valid_from) < TRUNC(Rebate_Agreement_Api.Get_Valid_From(newrec_.agreement_id))) OR
      (TRUNC(newrec_.valid_from) > TRUNC(NVL(Rebate_Agreement_Api.Get_Valid_To(newrec_.agreement_id), newrec_.valid_from))) THEN
      Error_SYS.Record_General(lu_name_, 'REBAGREENOTVALID: Valid from date entered is not valid within the valid period of the rebate agreement.');
   END IF;
   OPEN get_existing;
   FETCH get_existing INTO temp_;
      IF (get_existing%FOUND) THEN
         CLOSE get_existing;
         Error_SYS.Record_General(lu_name_, 'VALIDFROMOVERLAP: Valid from date entered is overlapping with another explicitly defined valid period.');
      END IF;
   CLOSE get_existing;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_All_Rebate_Assortments__
--   Copies all Deal per Assortment records from one agreement to another.
PROCEDURE Copy_All_Rebate_Assortments__ (
   from_agreement_id_ IN VARCHAR2,
   to_agreement_id_   IN VARCHAR2,
   valid_from_date_   IN DATE,
   to_valid_from_     IN DATE,
   currency_rate_     IN NUMBER )
IS
   CURSOR  get_source_all IS
      SELECT *
      FROM REBATE_AGREEMENT_ASSORT_TAB
      WHERE agreement_id = from_agreement_id_;

   CURSOR get_min_date_rec IS
      SELECT MAX(valid_from) valid_date, rebate_type, assortment_id, assortment_node_id, hierarchy_id, customer_level
      FROM   REBATE_AGREEMENT_ASSORT_TAB
      WHERE  agreement_id = from_agreement_id_
      AND    valid_from  <= valid_from_date_
      GROUP BY rebate_type, assortment_id, assortment_node_id, hierarchy_id, customer_level;

   CURSOR  get_source (valid_date_ IN DATE, rebate_type_ IN VARCHAR2, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, hierarchy_id_ IN VARCHAR2, customer_level_ IN NUMBER) IS
      SELECT *
      FROM REBATE_AGREEMENT_ASSORT_TAB
      WHERE agreement_id       = from_agreement_id_
      AND   valid_from         = valid_date_
      AND   rebate_type        = rebate_type_
      AND   assortment_id      = assortment_id_
      AND   assortment_node_id = assortment_node_id_
      AND   hierarchy_id       = hierarchy_id_
      AND   customer_level     = customer_level_;
   
BEGIN

   IF (to_valid_from_ IS NULL) THEN
      IF (valid_from_date_ IS NULL) THEN
         -- Copy all lines with original valid from date
         FOR source_rec_ IN get_source_all LOOP
            source_rec_.agreement_id := to_agreement_id_;
            Copy_Rebate_Assortment_Line___(source_rec_, from_agreement_id_, currency_rate_, source_rec_.valid_from);
         END LOOP;
      ELSE
         -- Copy valid lines as at valid_from_date_
         FOR date_rec_ IN get_min_date_rec LOOP
            FOR source_rec_ IN get_source(date_rec_.valid_date, date_rec_.rebate_type, date_rec_.assortment_id, date_rec_.assortment_node_id, date_rec_.hierarchy_id, date_rec_.customer_level) LOOP
               source_rec_.agreement_id := to_agreement_id_;
               Copy_Rebate_Assortment_Line___(source_rec_, from_agreement_id_, currency_rate_, date_rec_.valid_date);
            END LOOP;
         END LOOP;
      END IF;
   ELSE
      -- Copy valid lines as at valid_from_date_ with valid from date to_valid_from_
      FOR date_rec_ IN get_min_date_rec LOOP
         FOR source_rec_ IN get_source(date_rec_.valid_date, date_rec_.rebate_type, date_rec_.assortment_id, date_rec_.assortment_node_id, date_rec_.hierarchy_id, date_rec_.customer_level) LOOP
            source_rec_.agreement_id := to_agreement_id_;
            source_rec_.valid_from   := to_valid_from_;
            Copy_Rebate_Assortment_Line___(source_rec_, from_agreement_id_, currency_rate_, date_rec_.valid_date);
         END LOOP;
      END LOOP;
   END IF;
END Copy_All_Rebate_Assortments__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   agreement_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR agreement_lines_exist IS
      SELECT 1
      FROM REBATE_AGREEMENT_ASSORT_TAB
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


@UncheckedAccess
FUNCTION Has_Valid_Deal (
   agreement_id_       IN VARCHAR2,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_ NUMBER;
   -- Check if valid line exists on the agreement
   CURSOR rebate_assortment_exist IS
      SELECT 1
      FROM REBATE_AGREEMENT_ASSORT_TAB
      WHERE agreement_id = agreement_id_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_
      AND   valid_from <= trunc(SYSDATE);
BEGIN
   OPEN rebate_assortment_exist;
   FETCH rebate_assortment_exist INTO temp_;
   IF (rebate_assortment_exist%NOTFOUND) THEN
      CLOSE rebate_assortment_exist;
      RETURN FALSE;
   ELSE
      CLOSE rebate_assortment_exist;
      RETURN TRUE;
   END IF;
END Has_Valid_Deal;


-- Check_Active_Deal_Per_Assort
--   This will return 1 if the assortment_id is connected to an active deal per rebate agreement; 0 otherwise.
@UncheckedAccess
FUNCTION Check_Active_Deal_Per_Assort (
   assortment_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_records IS
      SELECT count(*)
      FROM   REBATE_AGREEMENT_ASSORT_TAB raa, rebate_agreement_tab ra
      WHERE  ra.rowstate      = 'Active'
      AND    ra.agreement_id  = raa.agreement_id
      AND    ra.assortment_id = assortment_id_;
BEGIN
   OPEN exist_records;
   FETCH exist_records INTO dummy_;
   CLOSE exist_records;
   IF (dummy_ > 0) THEN
      dummy_ := 1;
   END IF;

   RETURN dummy_;
END Check_Active_Deal_Per_Assort;



