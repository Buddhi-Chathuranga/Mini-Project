-----------------------------------------------------------------------------
--
--  Logical unit: AgreementSalesGroupDeal
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180608  DilMlk  Bug 142322, Modified Check_Update___ to prevent getting an error when user modifies a line to add Notes and then try to save it.
--  180119  CKumlk  STRSC-15930, Modified Check_Delete___ by changing Get_State() to Get_Objstate().
--  170421  IzShlk  STRSC-4713, Introduced Modify_Valid_To_Date() to modify valid_to dates.
--  170420  IzShlk  STRSC-4713, Handled logic in Copy_All_Sales_Group_Deals__() to select both valid_from & valid_to records only if the 
--                               "Include lines with both Valid From and Valid To dates" checkbox is checked.
--  170420  IzShlk  STRSC-4713, Added an additional parameter(raise_msg_) to Copy_All_Sales_Group_Deals__() to raise a warning msg if the new valid_from date is later than the valid_to date.
--  160726  ChFolk  STRSC-3669, Modified get_min_date_part in Copy_All_Sales_Group_Deals__ to fetch correct lines to be copied considering the valid_to_date.
--  160726          If the valid_to_date is defined then it must be priortised.
--  160725  ChFolk  STRSC-3671, Modified Copy_Group_Deal_Line___ to add valid_to_date when lines are copied.
--  160721  ChFolk  STRSC-3574, Modified Find_Agr_Sales_Grp_Deal to change the cursor find_catalog_group_based as there is a requirement to fetch the price from the line 
--  160721          which has a period defined when there are overlappings exists.
--  160720  ChFolk  STRSC-3574, Modified Find_Agr_Sales_Grp_Deal to consider valid_to_date when selecting the sales group deal.
--  160718  ChFolk  STRSC-3571, Added new function Check_Period_Overlapped___ and modified Check_Common___ to use it in validating entered from date and to date.
--  160715  ChFolk  STRSC-3571, Override Check_Common___ to validate valid_to_date.
--  151229  ThEdlk  Bug 125768, Modified Prepare_Insert__() to fetch header value for the valid_from_date when it is greater than the sysdate.
--  150914  MeAblk Bug 124475, Modified Check_Delete___ in order to avoid make any update to the agreement when it is in 'Closed' state.
--  140616  RoJalk  Modified Update___  and added a NVL when checking a value for SERVER_DATA_CHANGE.
--  140226  AyAmlk  Bug 115495, Modified methods which use the server_data_change flag, to specified the value as 2 when changed through
--  140226          Modify_Discount__().
--  111116  ChJalk Modified the view AGREEMENT_SALES_GROUP_DEAL to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111026  ChJalk Modified the view AGREEMENT_SALES_GROUP_DEAL to use the user allowed company filter.
--  110822  NWeelk Bug 93605, Added public method Copy to copy multiple deal per sales group lines.
--  110325  ChJalk EANE-4849, Removed user allowed site filter from the view AGREEMENT_SALES_GRP_DEAL_JOIN.
--  110304  ChJalk EANE-3807, Added user allowed site filter to the view AGREEMENT_SALES_GRP_DEAL_JOIN.
--  091109  DaZase Added checks on valid_from_date in Unpack_Check_Insert___.
--  080407  MaHplk Modified view comments on state column of AGREEMENT_SALES_GRP_DEAL_JOIN.
--  080226  KiSalk Added attribute 'SERVER_DATA_CHANGE' and methods Modify_Discount__, Get_Disc_Line_Count_Per_Deal__ and Copy_Group_Deal_Line___.
--  080221  AmPalk Added Find_Agr_Sales_Grp_Deal.
--  080221  MaHplk Added new view AGREEMENT_SALES_GRP_DEAL_JOIN.
--  080219  AmPalk Added new key fields to the LU. min_quantity and valid_from_date.
--  080126  AmPalk Added Check_Exist_For_Agrmnt.
--  071226  KiSalk Added method Copy_All_Sales_Group_Deals__.
-- ----------------------------- Nice Price Start -----------------------------
--  060110  SuJalk Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
-- ----------------------------------13.3.0-----------------------------------
--  020109  CaSt  Bug fix 26922, Changed discount limits in Unpack_Check_Insert___ and Unpack_Check_Update___
--                to allow negative discount.
--  020102  JICE  Added public view for Sales Configurator export.
--  991012  JOHW  Made Discount Type and Discount mandatory.
--  990907  JOHW  Added checks where Discount_Type is Null and Discount is not.
--  990901  JOHW  Made Discount Public.
--  990831  JOHW  Added Discount Type and Discount.
--  990406  RaKu  Changed to new templates.
--  990209  CAST  Added note_text.
--  980130  MNYS  Changed Discount_Class to be MANDATORY.
--  980114  MNYS  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Agree_Group_Deal_Rec IS RECORD
   (agreement_id AGREEMENT_SALES_GROUP_DEAL_TAB.agreement_id%TYPE,
    catalog_group AGREEMENT_SALES_GROUP_DEAL_TAB.catalog_group%TYPE,
    min_qty AGREEMENT_SALES_GROUP_DEAL_TAB.min_quantity%TYPE,
    valid_from AGREEMENT_SALES_GROUP_DEAL_TAB.valid_from_date%TYPE);

TYPE Agree_Group_Deal_Table IS TABLE OF Agree_Group_Deal_Rec INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Copy_Group_Deal_Line___ (
   source_rec_        IN AGREEMENT_SALES_GROUP_DEAL_TAB%ROWTYPE,
   from_agreement_id_ IN VARCHAR2,
   from_valid_from_   IN DATE,
   copy_notes_        IN NUMBER )
IS
   attr_            VARCHAR2(32000);
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
   newrec_          AGREEMENT_SALES_GROUP_DEAL_TAB%ROWTYPE;
   indrec_          Indicator_Rec;

BEGIN


   -- Copy the line
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 1, attr_);--Not to raise discount_type null error
   Client_SYS.Add_To_Attr('AGREEMENT_ID', source_rec_.agreement_id, attr_);
   Client_SYS.Add_To_Attr('CATALOG_GROUP', source_rec_.catalog_group, attr_);
   Client_SYS.Add_To_Attr('MIN_QUANTITY', source_rec_.min_quantity, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', source_rec_.valid_from_date, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', source_rec_.discount, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_TYPE', source_rec_.discount_type, attr_);
   Client_SYS.Add_To_Attr('VALID_TO_DATE', source_rec_.valid_to_date, attr_);

   IF (copy_notes_ = 1) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', source_rec_.note_text, attr_);
   END IF;

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   -- Copy multiple Discount Lines
   Agreement_Group_Discount_API.Copy_All_Discount_Lines__ (from_agreement_id_,
                                                           source_rec_.min_quantity,
                                                           from_valid_from_,
                                                           source_rec_.catalog_group,
                                                           source_rec_.agreement_id,
                                                           source_rec_.min_quantity,
                                                           source_rec_.valid_from_date,
                                                           source_rec_.catalog_group );

END Copy_Group_Deal_Line___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   agreement_id_   agreement_sales_group_deal_tab.agreement_id%TYPE;
BEGIN
   agreement_id_ := client_sys.Get_Item_Value('AGREEMENT_ID', attr_);
   super(attr_);
   Client_SYS.Add_To_Attr('MIN_QUANTITY', 0, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', GREATEST(TRUNC(Customer_Agreement_API.Get_Valid_From(agreement_id_ )), sysdate), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT AGREEMENT_SALES_GROUP_DEAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   IF NOT(newrec_.discount_type IS NULL OR Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      -- New line is created with discount from client. So, create corresponding discount record
      Agreement_Group_Discount_API.Sync_Discount_Line__(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date, newrec_.catalog_group);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     AGREEMENT_SALES_GROUP_DEAL_TAB%ROWTYPE,
   newrec_     IN OUT AGREEMENT_SALES_GROUP_DEAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (newrec_.discount IS NOT NULL OR oldrec_.discount IS NOT NULL) THEN
      IF (NVL(newrec_.discount_type, Database_SYS.string_null_) != NVL(oldrec_.discount_type,Database_SYS.string_null_)
          OR NVL(newrec_.discount, 0) != NVL(oldrec_.discount, 0)) THEN
         IF (NVL(Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_), 0) != 2) THEN
            -- Create/ Modify / Delete Discount record if not called through Modify_Discount__
            Agreement_Group_Discount_API.Sync_Discount_Line__(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date, newrec_.catalog_group);
         END IF;
      END IF;
   END IF;
END Update___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT agreement_sales_group_deal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF (Customer_Agreement_Api.Get_Assortment_Id(newrec_.agreement_id) IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ASSORTINAGRMHEAD: Deal per sales group records can not enter with a assortment id specified in the agreement header.');
   END IF;
   
   IF (NOT Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      Error_SYS.Check_Not_Null(lu_name_, 'DISCOUNT_TYPE', newrec_.discount_type);
   END IF;

   IF (newrec_.discount < -100) OR (newrec_.discount > 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT3: Discount must be between -100 and 100!');
   END IF;
   
   IF (TRUNC(newrec_.valid_from_date) < TRUNC(Customer_Agreement_Api.Get_Valid_From(newrec_.agreement_id))) OR
      (TRUNC(newrec_.valid_from_date) > TRUNC(NVL(Customer_Agreement_Api.Get_Valid_Until(newrec_.agreement_id), newrec_.valid_from_date))) THEN
      Client_SYS.Add_Info(lu_name_, 'CUSTAGREENOTVALID: Valid from date entered is not valid within the valid period of the customer agreement.');
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     agreement_sales_group_deal_tab%ROWTYPE,
   newrec_ IN OUT agreement_sales_group_deal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   discount_changed_   BOOLEAN := FALSE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   discount_changed_ := discount_changed_ OR Validate_SYS.Is_Changed(oldrec_.discount_type, newrec_.discount_type)   
                        OR Validate_SYS.Is_Changed(oldrec_.discount, newrec_.discount);
   
   IF (NOT Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      IF (NOT ( Get_Disc_Line_Count_Per_Deal__( newrec_.agreement_id, newrec_.catalog_group, newrec_.valid_from_date, newrec_.min_quantity) > 1)) THEN
         Error_SYS.Check_Not_Null(lu_name_, 'DISCOUNT_TYPE', newrec_.discount_type);
      END IF;
   END IF;

   IF (discount_changed_ AND NOT Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      --Discount change is not allowed by client; but allowed as updates resulted from chenges in Agreement_Group_Discount lines.
      IF ( Get_Disc_Line_Count_Per_Deal__( newrec_.agreement_id, newrec_.catalog_group, newrec_.valid_from_date, newrec_.min_quantity) > 1) THEN
         Error_SYS.Record_General(lu_name_, 'MULTIDISCTYPEASSEDIT: Multiple Discount lines exist. Discount / Discount type cannot be modified in deal per Sales Group line.');
      END IF;
   END IF;
   
   IF (newrec_.discount < -100) OR (newrec_.discount > 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT3: Discount must be between -100 and 100!');
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN agreement_sales_group_deal_tab%ROWTYPE )
IS
BEGIN
   IF (Customer_Agreement_API.Get_Objstate(remrec_.agreement_id) = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when agreement is in closed state');
   END IF;
   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     agreement_sales_group_deal_tab%ROWTYPE,
   newrec_ IN OUT agreement_sales_group_deal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 ) 
IS
   header_valid_to_date_  DATE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (TRUNC(newrec_.valid_from_date) > TRUNC(newrec_.valid_to_date)) THEN
      Error_SYS.Record_General(lu_name_, 'EARLY_TO_DATE: Valid To date has to be equal to or later than Valid From date.');
   END IF;
   
   header_valid_to_date_ := Customer_Agreement_API.Get_Valid_Until(newrec_.agreement_id);
   IF (TRUNC(newrec_.valid_to_date) IS NOT NULL AND (TRUNC(newrec_.valid_to_date) > TRUNC(NVL(header_valid_to_date_, Database_SYS.Get_Last_Calendar_Date())))) THEN
      Client_SYS.Add_Info(lu_name_, 'INVALID_TO_DATE: Valid To date has to be equal to or earlier than Customer Agreement To Date.', TRUNC(newrec_.valid_to_date), TRUNC(header_valid_to_date_));
   END IF;
   
   IF (indrec_.valid_to_date AND newrec_.valid_to_date IS NOT NULL) THEN
      IF (Check_Period_Overlapped___(newrec_.agreement_id, newrec_.catalog_group, newrec_.min_quantity, newrec_.valid_from_date, newrec_.valid_to_date) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'PERIOD_OVRLAPPED: Timeframe is overlapping with other Valid From and Valid To timeframe for same Min Qty.');
      END IF;
   END IF;
   
END Check_Common___;

FUNCTION Check_Period_Overlapped___ (
   agreement_id_    IN VARCHAR2,
   catalog_group_   IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,   
   valid_to_date_   IN DATE ) RETURN VARCHAR2
IS
   period_overlapped_  VARCHAR2(5) := 'FALSE';
   dummy_              NUMBER;
   
   CURSOR find_overlap IS
      SELECT 1
      FROM AGREEMENT_SALES_GROUP_DEAL_TAB
      WHERE agreement_id = agreement_id_
      AND catalog_group = catalog_group_
      AND min_quantity = min_quantity_
      AND valid_to_date IS NOT NULL
      AND ((TRUNC(valid_from_date_) BETWEEN TRUNC(valid_from_date) AND TRUNC(valid_to_date)) OR
           (TRUNC(valid_to_date_) BETWEEN TRUNC(valid_from_date) AND TRUNC(valid_to_date)) OR
           (TRUNC(valid_to_date_) IS NOT NULL AND (TRUNC(valid_from_date) BETWEEN TRUNC(valid_from_date_) AND TRUNC(valid_to_date_))) OR
           (TRUNC(valid_to_date_) IS NOT NULL AND (TRUNC(valid_to_date) BETWEEN TRUNC(valid_from_date_) AND TRUNC(valid_to_date_))))
      AND valid_from_date != valid_from_date_;
BEGIN
   OPEN find_overlap;
   FETCH find_overlap INTO dummy_;
   IF (find_overlap%FOUND) THEN
      period_overlapped_ := 'TRUE';
   END IF;
   CLOSE find_overlap;
   
   RETURN period_overlapped_;
END Check_Period_Overlapped___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy_All_Sales_Group_Deals__ (
   raise_msg_         IN OUT VARCHAR2,
   from_agreement_id_ IN VARCHAR2,
   to_agreement_id_   IN VARCHAR2,
   valid_from_date_   IN DATE,
   to_valid_from_     IN DATE,
   copy_notes_        IN NUMBER,
   row_select_state_  IN VARCHAR2 DEFAULT 'Include_All_Dates' )
IS
   from_valid_from_  DATE;
   
   -- This cursor will return the qualified lines by considering both valid_from_date and valid_to_date dates
   CURSOR get_min_date_part_all IS
      SELECT valid_date, catalog_group, min_quantity
      FROM 
         (SELECT MAX(valid_from_date) valid_date, catalog_group, min_quantity
            FROM   AGREEMENT_SALES_GROUP_DEAL_TAB
            WHERE  agreement_id = from_agreement_id_
            AND    valid_to_date IS NOT NULL
            AND    TRUNC(valid_from_date) <= TRUNC(valid_from_date_)
            AND    TRUNC(valid_to_date) >= TRUNC(valid_from_date_)
            GROUP BY catalog_group, min_quantity
         UNION ALL
            SELECT MAX(valid_from_date) valid_date,  catalog_group, min_quantity
               FROM   AGREEMENT_SALES_GROUP_DEAL_TAB
               WHERE  agreement_id = from_agreement_id_
               AND    valid_to_date IS NULL
               AND    TRUNC(valid_from_date) <= TRUNC(valid_from_date_)
               AND    (catalog_group, min_quantity) NOT IN (SELECT catalog_group, min_quantity
                                                            FROM   AGREEMENT_SALES_GROUP_DEAL_TAB
                                                            WHERE  agreement_id = from_agreement_id_
                                                            AND    valid_to_date is not null
                                                            AND    TRUNC(valid_from_date) <= TRUNC(valid_from_date_)
                                                            AND    TRUNC(valid_to_date) >= TRUNC(valid_from_date_))
               GROUP BY catalog_group, min_quantity);  
               
   -- This cursor will return the qualified lines by considering only valid_from_date
   CURSOR get_min_date_part IS
   SELECT valid_date,  catalog_group, min_quantity
   FROM 
      (SELECT MAX(valid_from_date) valid_date,  catalog_group, min_quantity
         FROM   AGREEMENT_SALES_GROUP_DEAL_TAB
         WHERE  agreement_id = from_agreement_id_
         AND    valid_to_date IS NULL
         AND    TRUNC(valid_from_date) <= TRUNC(valid_from_date_)
         GROUP BY catalog_group, min_quantity);
   
   CURSOR  get_source (catalog_group_ IN VARCHAR2, min_quantity_ IN NUMBER, valid_date_ IN DATE) IS
         SELECT *
         FROM AGREEMENT_SALES_GROUP_DEAL_TAB
         WHERE agreement_id = from_agreement_id_
         AND catalog_group = catalog_group_
         AND min_quantity = min_quantity_
         AND valid_from_date = valid_date_;

   CURSOR  get_source_all (row_state_ VARCHAR2) IS
         SELECT *
         FROM AGREEMENT_SALES_GROUP_DEAL_TAB
         WHERE agreement_id = from_agreement_id_
         AND row_state_ = 'Include_From_Dates'
         AND valid_to_date IS NULL
      UNION ALL
         SELECT *
         FROM AGREEMENT_SALES_GROUP_DEAL_TAB
         WHERE agreement_id = from_agreement_id_
         AND row_state_ = 'Include_All_Dates';

BEGIN
   --raise_msg_ := 'FALSE';
   IF (to_valid_from_ IS NULL) THEN
      IF (valid_from_date_ IS NULL) THEN
         --Copy all lines with original valid from date
         FOR source_rec_ IN get_source_all (row_select_state_) LOOP
            source_rec_.agreement_id := to_agreement_id_;
            Copy_Group_Deal_Line___ (source_rec_, from_agreement_id_, source_rec_.valid_from_date, copy_notes_);
         END LOOP;
      ELSE
         IF row_select_state_ =  'Include_All_Dates' THEN
            --Copy valid lines as at valid_from_date_ with original valid from date (Considered both valid from and valid to dates)
            FOR date_rec_ IN get_min_date_part_all LOOP
               FOR source_rec_ IN get_source(date_rec_.catalog_group, date_rec_.min_quantity, date_rec_.valid_date) LOOP
                  source_rec_.agreement_id := to_agreement_id_;
                  Copy_Group_Deal_Line___ (source_rec_, from_agreement_id_, source_rec_.valid_from_date, copy_notes_);
               END LOOP;
            END LOOP;
         ELSE
            --Copy valid lines as at only valid_from_date_ with original valid from date (Considered only valid from date)
            FOR date_rec_ IN get_min_date_part LOOP
               FOR source_rec_ IN get_source(date_rec_.catalog_group, date_rec_.min_quantity, date_rec_.valid_date) LOOP
                  source_rec_.agreement_id := to_agreement_id_;
                  Copy_Group_Deal_Line___ (source_rec_, from_agreement_id_, source_rec_.valid_from_date, copy_notes_);
               END LOOP;
            END LOOP;
         END IF;
      END IF;
   ELSE
      IF row_select_state_ =  'Include_All_Dates' THEN
         --Copy valid lines as at valid_from_date_ with valid from date to_valid_from_
         FOR date_rec_ IN get_min_date_part_all LOOP
            FOR source_rec_ IN get_source(date_rec_.catalog_group, date_rec_.min_quantity, date_rec_.valid_date) LOOP
               -- If to_valid_from_ is later than original valid_to_date, then the new line's valid_to_date should be NULL.
               IF TRUNC(to_valid_from_) > TRUNC(Get_Valid_To_Date(from_agreement_id_, source_rec_.catalog_group, source_rec_.valid_from_date, source_rec_.min_quantity)) THEN
                  raise_msg_ := 'TRUE';
                  source_rec_.valid_to_date := NULL;
               END IF;
               source_rec_.agreement_id := to_agreement_id_;
               from_valid_from_ := source_rec_.valid_from_date;
               source_rec_.valid_from_date := to_valid_from_;
               Copy_Group_Deal_Line___ (source_rec_, from_agreement_id_, date_rec_.valid_date, copy_notes_);
            END LOOP;
         END LOOP;
      ELSE
         --Copy valid lines as at valid_from_date_ with valid from date to_valid_from_date_
         FOR date_rec_ IN get_min_date_part LOOP
            FOR source_rec_ IN get_source(date_rec_.catalog_group, date_rec_.min_quantity, date_rec_.valid_date) LOOP
               source_rec_.agreement_id := to_agreement_id_;
               from_valid_from_ := source_rec_.valid_from_date;
               source_rec_.valid_from_date := to_valid_from_;
               Copy_Group_Deal_Line___ (source_rec_, from_agreement_id_, date_rec_.valid_date, copy_notes_);
            END LOOP;
         END LOOP;
      END IF;
   END IF;
END Copy_All_Sales_Group_Deals__;


@UncheckedAccess
FUNCTION Get_Disc_Line_Count_Per_Deal__ (
   agreement_id_    IN VARCHAR2,
   catalog_group_   IN VARCHAR2,
   valid_from_date_ IN DATE,
   min_quantity_    IN NUMBER ) RETURN NUMBER
IS
   line_count_          NUMBER;
   CURSOR get_total_lines IS
      SELECT count(discount_no)
      FROM   agreement_group_discount_tab
      WHERE     agreement_id = agreement_id_
      AND       min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND      catalog_group = catalog_group_;

BEGIN

   OPEN get_total_lines;
   FETCH get_total_lines INTO line_count_;
   CLOSE get_total_lines;

   RETURN line_count_;

END Get_Disc_Line_Count_Per_Deal__;


PROCEDURE Modify_Discount__ (
   agreement_id_ IN VARCHAR2,
   catalog_group_   IN VARCHAR2,
   valid_from_date_ IN DATE,
   min_quantity_    IN NUMBER,
   discount_        IN NUMBER,
   discount_type_   IN VARCHAR2 )
IS
   attr_            VARCHAR2(2000);
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
   newrec_          AGREEMENT_SALES_GROUP_DEAL_TAB%ROWTYPE;
   oldrec_          AGREEMENT_SALES_GROUP_DEAL_TAB%ROWTYPE;
   indrec_          Indicator_Rec;
BEGIN

   oldrec_ := Lock_By_Keys___(agreement_id_, catalog_group_, valid_from_date_, min_quantity_);
   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_, catalog_group_, valid_from_date_, min_quantity_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_TYPE', discount_type_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
   -- NOTE: Passed 2 to specify the change was done through Modify_Discount__.
   Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 2, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);

END Modify_Discount__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist_For_Agrmnt (
   agreement_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER := 0;
   CURSOR get_attr IS
      SELECT 1
      FROM AGREEMENT_SALES_GROUP_DEAL_TAB
      WHERE agreement_id = agreement_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF (temp_ = 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist_For_Agrmnt;


PROCEDURE Find_Agr_Sales_Grp_Deal (
   discount_        OUT NUMBER,
   discount_type_   OUT VARCHAR2,
   min_quantity_    OUT NUMBER,
   valid_from_date_ OUT DATE,
   catalog_group_    IN VARCHAR2,
   agreement_id_     IN VARCHAR2,
   price_qty_due_    IN NUMBER,
   effectivity_date_ IN DATE DEFAULT NULL )
IS
  discount_type_found_   VARCHAR2(25);
  discount_found_        NUMBER;
  date_                  DATE;
  last_calendar_date_    DATE := Database_Sys.Get_Last_Calendar_Date();
  
   CURSOR find_catalog_group_min_qty IS
      SELECT MAX(min_quantity)
         FROM AGREEMENT_SALES_GROUP_DEAL_TAB
        WHERE agreement_id = agreement_id_
          AND catalog_group = catalog_group_
          AND min_quantity <= price_qty_due_
          AND TRUNC(valid_from_date) <= TRUNC(date_)
          AND TRUNC(NVL(valid_to_date, last_calendar_date_)) >= TRUNC(date_)
          AND discount IS NOT NULL;
      
   CURSOR find_catalog_group_period IS
      SELECT valid_from_date
      FROM   AGREEMENT_SALES_GROUP_DEAL_TAB
      WHERE  agreement_id = agreement_id_
      AND    catalog_group = catalog_group_
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    TRUNC(valid_to_date) >= TRUNC(date_)
      AND    discount IS NOT NULL
      AND    min_quantity = min_quantity_
      AND    valid_to_date IS NOT NULL;
   
   CURSOR get_max_from_date IS
      SELECT MAX(valid_from_date)
      FROM   AGREEMENT_SALES_GROUP_DEAL_TAB
      WHERE  agreement_id = agreement_id_
      AND    catalog_group = catalog_group_
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    discount IS NOT NULL
      AND    min_quantity = min_quantity_
      AND    valid_to_date IS NULL;
      
  CURSOR get_attributes IS
      SELECT discount, discount_type
      FROM   AGREEMENT_SALES_GROUP_DEAL_TAB
      WHERE  agreement_id = agreement_id_
      AND    catalog_group = catalog_group_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    discount IS NOT NULL;
BEGIN
   IF (effectivity_date_ IS NULL)  THEN
       date_ := trunc(Site_API.Get_Site_Date(User_Default_API.Get_Contract));
   ELSE
       date_ := effectivity_date_;
   END IF;

   OPEN  find_catalog_group_min_qty;
   FETCH find_catalog_group_min_qty INTO min_quantity_;
   CLOSE find_catalog_group_min_qty;

   IF (min_quantity_ IS NOT NULL) THEN
      OPEN find_catalog_group_period;
      FETCH find_catalog_group_period INTO valid_from_date_;
      CLOSE find_catalog_group_period;
      IF (valid_from_date_ IS NULL) THEN
         OPEN get_max_from_date;
         FETCH get_max_from_date INTO valid_from_date_;
         CLOSE get_max_from_date;
      END IF;
      IF (valid_from_date_ IS NOT NULL) THEN
         OPEN  get_attributes;
         FETCH get_attributes INTO discount_found_, discount_type_found_;
         CLOSE get_attributes;
      END IF;
   END IF;

   discount_type_ := discount_type_found_;
   discount_ := discount_found_;

END Find_Agr_Sales_Grp_Deal;


-- Copy
--   Copies the selected sales group deal lines.
PROCEDURE Copy (
   to_agreement_id_    IN VARCHAR2,
   attr_               IN VARCHAR2 )
IS
   source_rec_         AGREEMENT_SALES_GROUP_DEAL_TAB%ROWTYPE;
   new_agree_rec_      CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   source_agree_rec_   CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   ptr_                NUMBER;
   name_               VARCHAR2(30);
   value_              VARCHAR2(2000);
   from_agreement_     VARCHAR2(10);
   agr_grp_deal_tab_   Agree_Group_Deal_Table;
   row_count_          NUMBER := 0;
   
   CURSOR  get_source(agreement_id_ IN VARCHAR2, catalog_group_ IN VARCHAR2, min_qty_ IN NUMBER, valid_from_ IN DATE) IS
      SELECT *
      FROM AGREEMENT_SALES_GROUP_DEAL_TAB
      WHERE agreement_id = agreement_id_
      AND   catalog_group = catalog_group_
      AND   min_quantity = min_qty_
      AND   valid_from_date = valid_from_;
   
   CURSOR get_agreement_data(agreement_id_ IN VARCHAR2) IS
      SELECT * 
      FROM CUSTOMER_AGREEMENT_TAB
      WHERE agreement_id = agreement_id_;
   
BEGIN
   
   OPEN get_agreement_data(to_agreement_id_);
   FETCH get_agreement_data INTO new_agree_rec_; 
   CLOSE get_agreement_data;
         
   -- Check if the agreement is of a valid company.
   IF (new_agree_rec_.agreement_id IS NOT NULL) THEN
      Company_Finance_API.Exist(new_agree_rec_.company);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NO_AGREEMENT_EXIST: Customer Agreement :P1 does not exist.', to_agreement_id_);
   END IF;
   
   IF new_agree_rec_.assortment_id IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'ASSORTINCPAGRMHEAD: Deal per sales group records cannot be copied to an agreement that includes an assortment ID specified in the agreement header.');
   END IF;
   
   ptr_ := NULL;
   IF (attr_ IS NOT NULL) THEN
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'AGREEMENT_ID') THEN
            agr_grp_deal_tab_(row_count_).agreement_id := value_;
         ELSIF (name_ = 'CATALOG_GROUP') THEN
            agr_grp_deal_tab_(row_count_).catalog_group := value_;
         ELSIF (name_ = 'MIN_QUANTITY') THEN
            agr_grp_deal_tab_(row_count_).min_qty := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'VALID_FROM') THEN
            agr_grp_deal_tab_(row_count_).valid_from := Client_SYS.Attr_Value_To_Date(value_);
            row_count_ := row_count_ + 1;
         END IF;
      END LOOP; 
   END IF;
   
   IF (agr_grp_deal_tab_.COUNT > 0) THEN
      FOR index_ IN agr_grp_deal_tab_.FIRST..agr_grp_deal_tab_.LAST LOOP   
         OPEN get_source(agr_grp_deal_tab_(index_).agreement_id, agr_grp_deal_tab_(index_).catalog_group, agr_grp_deal_tab_(index_).min_qty, agr_grp_deal_tab_(index_).valid_from);
         FETCH get_source INTO source_rec_; 
         CLOSE get_source;
      
         OPEN get_agreement_data(source_rec_.agreement_id);
         FETCH get_agreement_data INTO source_agree_rec_; 
         CLOSE get_agreement_data;
      
         from_agreement_ := source_rec_.agreement_id;
         source_rec_.agreement_id := to_agreement_id_;
         
         Copy_Group_Deal_Line___(source_rec_, from_agreement_, agr_grp_deal_tab_(index_).valid_from, 1);
      END LOOP;
   END IF;
END Copy;

PROCEDURE Modify_Valid_To_Date (
   agreement_id_      IN VARCHAR2,
   catalog_group_     IN VARCHAR2,
   min_quantity_      IN NUMBER,   
   valid_from_date_   IN DATE,
   valid_to_date_     IN DATE )
IS
   newrec_     AGREEMENT_SALES_GROUP_DEAL_TAB%ROWTYPE;

BEGIN
   newrec_ := Get_Object_By_Keys___(agreement_id_, catalog_group_, valid_from_date_, min_quantity_);
   newrec_.valid_to_date := valid_to_date_;
   Modify___(newrec_);
END Modify_Valid_To_Date;

