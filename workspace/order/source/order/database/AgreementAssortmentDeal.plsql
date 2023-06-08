-----------------------------------------------------------------------------
--
--  Logical unit: AgreementAssortmentDeal
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190104  UdGnlk  Bug 147460(SCZ-3695), Modified Get_Discount_Node() to pass the correct value of assortment node id to the cursors when variable assortment_node_ is null.
--  181019  KiSalk  Bug 144812(SCZ-1443), Corrected a typo error in Get_Deal_Price_Node.
--  180119  CKumlk  STRSC-15930, Modified Check_Insert___, Check_Update___ and Check_Delete___ by changing Get_State() to Get_Objstate().
--  170407  IzShlk  STRSC-4713, Handled logic in Copy_All_Assortment_Deals__() to select both valid_from & valid_to records only if the 
--                               "Include lines with both Valid From and Valid To dates" checkbox is checked.
--  170420  IzShlk  STRSC-4713, Added an additional parameter(raise_msg_) to Copy_All_Assortment_Deals__() to raise a warning msg if the new valid_from date is later than the valid_to date.
--  160922  ChFolk  STRSC-3834, Added new method PROCEDURE Modify_Valid_To_Date which is used to update valid_to_date for a given assortment @AllowTableOrViewAccess TABLE_NAME
--  160922          Added new parameter valid_to_date into Modify_Deal_Price and New.
--  160726  ChFolk  STRSC-3669, Modified get_min_date_part in Copy_All_Assortment_Deals__ to fetch correct lines to be copied considering the valid_to_date.
--  160726          If the valid_to_date is defined then it must be priortised.
--  160721  ChFolk  STRSC-3574, Modified Get_Deal_Price_Node to change the cursor get_price_qty as there is a requirement to fetch the price from the line 
--  160721          which has a period defined when there are overlappings exists. Did the similar modification in Get_Discount_Node.
--  160720  ChFolk  STRSC-3574, Modified Get_Deal_Price_Node, Get_Discount_Node to include valid_to when selecting the assortment line.
--  160718  ChFolk  STRSC-3572, Added new function Check_Period_Overlapped___ and modified Check_Common___ to use it in validating entered from date and to date.
--  160715  ChFolk  STRSC-3572, Modified Check_Common___ to add validations for Valid To Date.
--  151229  ThEdlk  Bug 125768, Modified Prepare_Insert__() to fetch header value for the valid_from_date when it is greater than the sysdate.
--  150914  MeAblk  Bug 124475, Modified Check_Update___, Check_Insert___ and override Check_Delete___ in order to avoid make any update to the agreement when it is in 'Closed' state.
--  140616  RoJalk  Modified Update___  and added a NVL when checking a value for SERVER_DATA_CHANGE.
--  140226  AyAmlk  Bug 115495, Modified methods which use the server_data_change flag, to specified the value as 2 when changed through
--  140226          Modify_Discount__().
--  130703  MaIklk  TIBE-943, Removed last_calendar_date_ global constant because it was not used.
--  111116  ChJalk  Modified the view AGREEMENT_ASSORTMENT_DEAL to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111026  ChJalk  Modified the view AGREEMENT_ASSORTMENT_DEAL to use the user allowed company filter.
--  110822  NWeelk  Bug 93605, Added public method Copy to copy multiple assortment deal lines.
--  110509  NWeelk  Bug 96967, Modified method Get_Discount_Node by removing discount IS NOT NULL check from the cursors, added discount amounts check 
--  110509          to the error messages NODISCANDPRICE, SALES_DISCOUNT_INS, added function Discount_Amount_Exist
--  110509          and modified method Copy_Assortment_Deal_Line___ by setting values for discount correctly, modified method Update___ by adding 
--  110509          discount amounts exist check before calling the method Sync_Discount_Line__. 
--  110526  MiKulk  Modified the public new method by setting the server_data_change attribute to 1.
--  110325  ChJalk  EANE-4849, Removed user allowed site filter from the view AGREEMENT_ASSORT_DEAL_JOIN.
--  110304  ChJalk  EANE-3807, Added user allowed site filter to the view AGREEMENT_ASSORT_DEAL_JOIN.
--  100901  NaLrlk  Bug 91448, Modified the relationships among CustomerAgreement, AssortmentNode and AgreementAssortmentDeal
--  100901          and made Assortment_id and Assortment_node_id primary keys of AgreementAssortmentDeal. 
--  100901  NaLrlk  Bug 88741, Modified procedure Unpack_Check_Insert___ by initializing variable copy_record_ to FALSE. 
--  091109  DaZase  Extended the valid_from check in methods Unpack_Check_Insert___/Unpack_Check_Update___ to also check with Valid_Until date.
--  090816  AmPalk  Bug 82295, Modified Get_Discount_Node, Unpack_Check_Insert___ and Get_Disc_Line_Count_Per_Deal__ 
--  090816          by allowing/handling Price UoM NULL situations only for standalone discount lines.
--  090816          In such instances the '*' acts as valid for all UoMs.
--  080407  MaHplk  Modified view comments on state column of AGREEMENT_ASSORT_DEAL_JOIN.
--  080402  AmPalk  Made last_update to be SYSDATE, when updating, if the value is null.
--  080225  AmPalk  Disabled part node inserts on the tab.
--  080225  MaHplk  Added new view AGREEMENT_ASSORT_DEAL_JOIN.
--  080222  MaHplk  Removed price_incl_tax and Modified net_price to not null.
--  080221  MaJalk  Added methods Modify_Deal_Price and New.
--  080211  AmPalk  Modified cursors used for pick correct quantity range in Get_Deal_Price_Node and Get_Discount_Node, 
--  080211          to consider values in deal price and discount fields too, as appropriate.
--  080208  MaJalk  Added procedure Remove.
--  080208  KiSalk  Added attribute server_data_change, methods Modify_Discount__ and Get_Disc_Line_Count_Per_Deal__.
--  080125  AmPalk  To support multiple discount lines changed check with discount_type to discount in the cursor get_node_in_agreement in method Get_Discount_Node.
--  080124  AmPalk  Added Get_Discount_Node.
--  080103  KiSalk  Added method Copy_All_Assortment_Deals__.
--  080102  AmPalk  Added part step pricing logic to Get_Deal_Price_Node method.
--  071220  AmPalk  Moveded Get_Dealpricenode_Best_Agrm to Customer Agreement and removed part_qty_from Get_Deal_Price_Node.
--  071220          Columns min_quantity, valid_from and price_unit_meas made key.
--  071213  AmPalk  Added Get_Deal_Price_Node and Get_Dealpricenode_Best_Agrm.
--  071212  AmPalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Agree_Assort_Deal_Rec IS RECORD
   (agreement_id AGREEMENT_ASSORTMENT_DEAL_TAB.agreement_id%TYPE,
    min_qty AGREEMENT_ASSORTMENT_DEAL_TAB.min_quantity%TYPE,
    valid_from AGREEMENT_ASSORTMENT_DEAL_TAB.valid_from%TYPE,
    price_unit_meas AGREEMENT_ASSORTMENT_DEAL_TAB.price_unit_meas%TYPE,
    assortment_id AGREEMENT_ASSORTMENT_DEAL_TAB.assortment_id%TYPE,
    assortment_node_id AGREEMENT_ASSORTMENT_DEAL_TAB.assortment_node_id%TYPE);

TYPE Agree_Assort_Deal_Table IS TABLE OF Agree_Assort_Deal_Rec INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Copy_Assortment_Deal_Line___ (
   source_rec_        IN AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE,
   from_agreement_id_ IN VARCHAR2,
   from_valid_from_   IN DATE,
   currency_rate_     IN NUMBER,
   copy_notes_        IN NUMBER )
IS
   attr_            VARCHAR2(32000);
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
   newrec_          AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE;
   indrec_          Indicator_Rec;

BEGIN


   -- Copy the line
   Prepare_Insert___(attr_);
   Client_SYS.Set_Item_Value('PROVISIONAL_PRICE_DB', source_rec_.provisional_price, attr_);
   Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 1, attr_);--Not to raise discount_type null error
   Client_SYS.Add_To_Attr('AGREEMENT_ID', source_rec_.agreement_id, attr_);
   Client_SYS.Add_To_Attr('MIN_QUANTITY', source_rec_.min_quantity, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM', source_rec_.valid_from, attr_);
   Client_SYS.Add_To_Attr('PRICE_UNIT_MEAS', source_rec_.price_unit_meas, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_ID', source_rec_.assortment_id, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_NODE_ID', source_rec_.assortment_node_id, attr_);
   Client_SYS.Add_To_Attr('DEAL_PRICE', source_rec_.deal_price * currency_rate_, attr_);
   IF source_rec_.discount IS NULL THEN
      Client_SYS.Add_To_Attr('DISCOUNT', 0, attr_);
   ELSE
      Client_SYS.Add_To_Attr('DISCOUNT', source_rec_.discount, attr_);
   END IF;
   Client_SYS.Add_To_Attr('ROUNDING', source_rec_.rounding, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_TYPE', source_rec_.discount_type, attr_);
   Client_SYS.Add_To_Attr('NET_PRICE_DB', source_rec_.net_price, attr_);

   IF (copy_notes_ = 1) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', source_rec_.note_text, attr_);
   END IF;
   Client_SYS.Add_To_Attr('LAST_UPDATE', SYSDATE, attr_);
   IF (source_rec_.valid_to IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('VALID_TO', source_rec_.valid_to, attr_);
   END IF;
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   -- Copy multiple Discount Lines
   Agreement_Assort_Discount_API.Copy_All_Discount_Lines__ (from_agreement_id_,
                                                            source_rec_.min_quantity,
                                                            from_valid_from_,
                                                            source_rec_.price_unit_meas,
                                                            source_rec_.assortment_id,
                                                            source_rec_.assortment_node_id,
                                                            source_rec_.agreement_id,
                                                            source_rec_.min_quantity,
                                                            source_rec_.valid_from,
                                                            source_rec_.price_unit_meas,
                                                            source_rec_.assortment_id,
                                                            source_rec_.assortment_node_id,
                                                            currency_rate_ );
END Copy_Assortment_Deal_Line___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   agreement_id_   agreement_assortment_deal_tab.agreement_id%TYPE;
BEGIN
   agreement_id_ := client_sys.Get_Item_Value('AGREEMENT_ID', attr_);
   super(attr_);
   Client_SYS.Add_To_Attr('PROVISIONAL_PRICE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('NET_PRICE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('LAST_UPDATE', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('MIN_QUANTITY', 0, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM', GREATEST(TRUNC(Customer_Agreement_API.Get_Valid_From(agreement_id_ )), sysdate), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   IF NOT(newrec_.discount_type IS NULL OR Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      -- New line is created with discount from client. So, create corresponding discount record
      Agreement_Assort_Discount_API.Sync_Discount_Line__(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from, newrec_.price_unit_meas, newrec_.assortment_id, newrec_.assortment_node_id);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE,
   newrec_     IN OUT AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF ((newrec_.discount IS NOT NULL) OR (oldrec_.discount IS NOT NULL) OR (Discount_Amount_Exist(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from, newrec_.price_unit_meas, newrec_.assortment_id, newrec_.assortment_node_id) = 'TRUE')) THEN
      IF (NVL(newrec_.discount_type, Database_SYS.string_null_) != NVL(oldrec_.discount_type,Database_SYS.string_null_) 
          OR NVL(newrec_.discount, 0) != NVL(oldrec_.discount, 0)
          OR (newrec_.net_price = 'TRUE' AND oldrec_.net_price = 'FALSE')
          OR NVL(newrec_.deal_price, 0) != NVL(oldrec_.deal_price, 0)) THEN
         IF (NVL(Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_), 0) != 2) THEN
            -- Create/ Modify / Delete Discount record if not called through Modify_Discount__
            Agreement_Assort_Discount_API.Sync_Discount_Line__(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from, newrec_.price_unit_meas, newrec_.assortment_id, newrec_.assortment_node_id);
         END IF;
      END IF;
   END IF;
END Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     agreement_assortment_deal_tab%ROWTYPE,
   newrec_ IN OUT agreement_assortment_deal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   disc_amount_exist_     VARCHAR2(5);
   header_valid_to_date_  DATE;
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   disc_amount_exist_ := Discount_Amount_Exist(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from, newrec_.price_unit_meas, newrec_.assortment_id, newrec_.assortment_node_id);
   IF ((newrec_.discount_type IS NOT NULL) AND (newrec_.discount IS NULL) AND (disc_amount_exist_ = 'FALSE')) THEN

      Error_SYS.Record_General(lu_name_, 'SALES_DISCOUNT_INS: You have to specify a discount percentage when using a discount type.');
   END IF;
   IF ((newrec_.discount IS NULL) AND (newrec_.deal_price IS NULL) AND (disc_amount_exist_ = 'FALSE')) THEN
      Error_SYS.Record_General(lu_name_, 'NODISCANDPRICE: Either discount type or deal price must be entered.');
   END IF;
   
   IF (newrec_.deal_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NONE_NEG_PRICE: The price must be greater than 0.');
   END IF;

   IF (newrec_.discount < -100) OR (newrec_.discount > 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT3: Discount must be between -100 and 100!');
   END IF;

   IF (Agreement_Sales_Group_Deal_Api.Check_Exist_For_Agrmnt(newrec_.agreement_id) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'SALGRPASSORTBOTH: Deal per sales group records already exists. Both deal per assortment and deal per sales group can not have records for an agreement.');
   END IF;
   
   IF (TRUNC(newrec_.valid_from) > TRUNC(newrec_.valid_to)) THEN
      Error_SYS.Record_General(lu_name_, 'EARLY_TO_DATE: Valid To date has to be equal to or later than Valid From date.');
   END IF;
   
   header_valid_to_date_ := Customer_Agreement_API.Get_Valid_Until(newrec_.agreement_id);
   IF (indrec_.valid_to AND  (TRUNC(newrec_.valid_to) IS NOT NULL) AND (TRUNC(newrec_.valid_to) > TRUNC(NVL(header_valid_to_date_, Database_SYS.Get_Last_Calendar_Date())))) THEN
      Client_SYS.Add_Info(lu_name_, 'INVALID_TO_DATE: Valid To date has to be equal to or earlier than Customer Agreement To Date.');
   END IF;
   
   IF (indrec_.valid_to AND newrec_.valid_to IS NOT NULL) THEN
      IF (Check_Period_Overlapped___(newrec_.agreement_id, newrec_.assortment_id, newrec_.assortment_node_id, newrec_.min_quantity, newrec_.valid_from, newrec_.price_unit_meas, newrec_.valid_to) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'PERIOD_OVRLAPPED: Timeframe is overlapping with other Valid From and Valid To timeframe for same Min Qty.');
      END IF;
   END IF;
   
END Check_Common___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT agreement_assortment_deal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF (Customer_Agreement_API.Get_Objstate(newrec_.agreement_id) = 'Closed' AND (newrec_.deal_price IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when agreement is in closed state');
   END IF;
      
   IF (newrec_.deal_price IS NULL) AND (newrec_.price_unit_meas IS NULL) THEN
      newrec_.price_unit_meas := '*';
   ELSIF (newrec_.deal_price IS NOT NULL) AND (newrec_.price_unit_meas IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'PRICELINEUOMNULL: Only standalone discount lines allowed without a price unit of measure. Please enter a price unit of measure.');
   END IF;

   IF (TRUNC(newrec_.valid_from) < TRUNC(NVL(Customer_Agreement_Api.Get_Valid_From(newrec_.agreement_id), newrec_.valid_from + 1))) OR
      (TRUNC(newrec_.valid_from) > TRUNC(NVL(Customer_Agreement_Api.Get_Valid_Until(newrec_.agreement_id), newrec_.valid_from))) THEN
      Client_SYS.Add_Info(lu_name_, 'CUSTAGREENOTVALID: Valid from date entered is not valid within the valid period of the customer agreement.');
   END IF;

   IF ((NOT Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) AND newrec_.discount IS NOT NULL AND newrec_.discount_type IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DISCTYPE_NULL: Discount percentage cannot be entered without a corresponding discount type.');
   END IF;

   IF (Assortment_Node_API.Get_Part_No(newrec_.assortment_id, newrec_.assortment_node_id) IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'PARTNODENOTVALID: Entered node is a part node in the assortment structure. Part nodes are not allowed on the deal per assortment tab.');
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     agreement_assortment_deal_tab%ROWTYPE,
   newrec_ IN OUT agreement_assortment_deal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   discount_changed_   BOOLEAN := FALSE;
   disc_line_count_    NUMBER;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (Customer_Agreement_API.Get_Objstate(newrec_.agreement_id) = 'Closed' AND (NOT discount_changed_)) THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when agreement is in closed state');
   END IF;
   
   discount_changed_ := discount_changed_ OR Validate_SYS.Is_Changed(oldrec_.discount_type, newrec_.discount_type)   
                        OR Validate_SYS.Is_Changed(oldrec_.discount, newrec_.discount);
   
   disc_line_count_ := Get_Disc_Line_Count_Per_Deal__(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from, newrec_.price_unit_meas, newrec_.assortment_id, newrec_.assortment_node_id);
   IF (discount_changed_ AND NOT Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      IF NOT (newrec_.net_price = 'TRUE' AND newrec_.discount IS NULL) THEN
         --Discount change is not allowed by client; but allowed as updates resulted from chenges in Agreement_Assort_Discount lines.
         IF ( disc_line_count_ > 1) THEN
            Error_SYS.Record_General(lu_name_, 'MULTIDISCTYPEASSEDIT: Multiple Discount lines exist. Discount / Discount type cannot be modified in deal per Assortment line.');
         END IF;
      END IF;
   END IF;

   IF (newrec_.discount IS NOT NULL AND newrec_.discount_type IS NULL AND NOT Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      IF ( disc_line_count_ < 2) THEN
         Error_SYS.Record_General(lu_name_, 'DISCTYPE_NULL: Discount percentage cannot be entered without a corresponding discount type.');
      END IF;
   END IF;
   
   newrec_.last_update := TRUNC(SYSDATE);
END Check_Update___;


@Override   
PROCEDURE Check_Delete___ (
   remrec_ IN agreement_assortment_deal_tab%ROWTYPE )
IS
BEGIN
   IF (Customer_Agreement_API.Get_Objstate(remrec_.agreement_id) = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when agreement is in closed state');
   END IF;
   super(remrec_);
END Check_Delete___;

FUNCTION Check_Period_Overlapped___ (
   agreement_id_       IN VARCHAR2,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_         IN DATE, 
   price_unit_meas_    IN VARCHAR2, 
   valid_to_           IN DATE ) RETURN VARCHAR2
IS
   period_overlapped_  VARCHAR2(5) := 'FALSE';
   dummy_              NUMBER;
   
   CURSOR find_overlap IS
      SELECT 1
      FROM AGREEMENT_ASSORTMENT_DEAL_TAB
      WHERE agreement_id = agreement_id_
      AND assortment_id = assortment_id_
      AND assortment_node_id = assortment_node_id_
      AND min_quantity = min_quantity_
      AND price_unit_meas = price_unit_meas_
      AND valid_to IS NOT NULL
      AND ((TRUNC(valid_from_) BETWEEN TRUNC(valid_from) AND TRUNC(valid_to)) OR
           (TRUNC(valid_to_) BETWEEN TRUNC(valid_from) AND TRUNC(valid_to)) OR 
           (TRUNC(valid_to_) IS NOT NULL AND (TRUNC(valid_from) BETWEEN TRUNC(valid_from_) AND TRUNC(valid_to_))) OR
           (TRUNC(valid_to_) IS NOT NULL AND (TRUNC(valid_to) BETWEEN TRUNC(valid_from_) AND TRUNC(valid_to_))))
      AND valid_from != valid_from_;
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

PROCEDURE Copy_All_Assortment_Deals__ (
   raise_msg_          IN OUT VARCHAR2,
   from_agreement_id_ IN VARCHAR2,
   to_agreement_id_   IN VARCHAR2,
   currency_rate_     IN NUMBER,
   valid_from_        IN DATE,
   to_valid_from_     IN DATE,
   copy_notes_        IN NUMBER,
   row_select_state_  IN VARCHAR2 DEFAULT 'Include_All_Dates' )
IS
   from_valid_from_  DATE;
   source_rec_       AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE;
   
   -- This cursor will return the qualified lines by considering both valid_from_date and valid_to_date dates
   CURSOR get_min_date_part_all IS
      SELECT valid_date, assortment_id, assortment_node_id, price_unit_meas, min_quantity
      FROM
         (SELECT valid_from valid_date, assortment_id, assortment_node_id, price_unit_meas, min_quantity
          FROM   AGREEMENT_ASSORTMENT_DEAL_TAB
          WHERE  agreement_id = from_agreement_id_
          AND    valid_to IS NOT NULL          
          AND    TRUNC(valid_from) <= TRUNC(valid_from_)
          AND    TRUNC(valid_to) >= TRUNC(valid_from_)
          UNION ALL
          SELECT MAX(valid_from) valid_date, assortment_id, assortment_node_id, price_unit_meas, min_quantity
          FROM   AGREEMENT_ASSORTMENT_DEAL_TAB
          WHERE  agreement_id = from_agreement_id_
          AND    valid_to IS NULL
          AND    TRUNC(valid_from) <= TRUNC(valid_from_)
          AND    (assortment_id, assortment_node_id, price_unit_meas, min_quantity) NOT IN (SELECT assortment_id, assortment_node_id, price_unit_meas, min_quantity
                                                                                            FROM   AGREEMENT_ASSORTMENT_DEAL_TAB
                                                                                            WHERE  agreement_id = from_agreement_id_
                                                                                            AND    valid_to IS NOT NULL
                                                                                            AND    TRUNC(valid_from) <= TRUNC(valid_from_)
                                                                                            AND    TRUNC(valid_to) >= TRUNC(valid_from_))
         GROUP BY assortment_id, assortment_node_id, price_unit_meas, min_quantity);
   
   -- This cursor will return the qualified lines by considering only valid_from_date
   CURSOR get_min_date_part IS
      SELECT valid_date, assortment_id, assortment_node_id, price_unit_meas, min_quantity
      FROM
         (SELECT MAX(valid_from) valid_date, assortment_id, assortment_node_id, price_unit_meas, min_quantity
          FROM   AGREEMENT_ASSORTMENT_DEAL_TAB
          WHERE  agreement_id = from_agreement_id_
          AND    valid_to IS NULL
          AND    TRUNC(valid_from) <= TRUNC(valid_from_)
          GROUP BY assortment_id, assortment_node_id, price_unit_meas, min_quantity);
               
   CURSOR  get_source (assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2, price_unit_meas_ IN VARCHAR2, min_quantity_ IN NUMBER, valid_date_ IN DATE) IS
         SELECT *
         FROM AGREEMENT_ASSORTMENT_DEAL_TAB
         WHERE agreement_id = from_agreement_id_
         AND assortment_id = assortment_id_
         AND assortment_node_id = assortment_node_id_
         AND price_unit_meas = price_unit_meas_
         AND min_quantity = min_quantity_
         AND valid_from = valid_date_;

   CURSOR  get_source_all (row_state_ VARCHAR2) IS
         SELECT *
         FROM AGREEMENT_ASSORTMENT_DEAL_TAB
         WHERE agreement_id = from_agreement_id_
         AND row_state_ = 'Include_From_Dates'
         AND valid_to IS NULL
      UNION ALL
         SELECT *
         FROM AGREEMENT_ASSORTMENT_DEAL_TAB
         WHERE agreement_id = from_agreement_id_
         AND row_state_ = 'Include_All_Dates';

BEGIN
   --raise_msg_ := 'FALSE';
   IF (to_valid_from_ IS NULL) THEN
      IF (valid_from_ IS NULL) THEN
         --Copy all lines with original valid from date
         FOR source_ IN get_source_all (row_select_state_) LOOP
            source_.agreement_id := to_agreement_id_;
            Copy_Assortment_Deal_Line___ (source_, from_agreement_id_, source_.valid_from, currency_rate_, copy_notes_);
         END LOOP;
      ELSE
         IF row_select_state_ =  'Include_All_Dates' THEN
            --Copy valid lines as at valid_from_date_ with original valid from date (Considered both valid from and valid to dates)
            FOR date_rec_ IN get_min_date_part_all LOOP
               OPEN get_source(date_rec_.assortment_id, date_rec_.assortment_node_id, date_rec_.price_unit_meas, date_rec_.min_quantity, date_rec_.valid_date);
               FETCH get_source INTO source_rec_;
               CLOSE get_source;
               source_rec_.agreement_id := to_agreement_id_;
               Copy_Assortment_Deal_Line___ (source_rec_, from_agreement_id_, source_rec_.valid_from, currency_rate_, copy_notes_);
            END LOOP;
         ELSE
            --Copy valid lines as at only valid_from_date_ with original valid from date (Considered only valid from date)
            FOR date_rec_ IN get_min_date_part LOOP
               OPEN get_source(date_rec_.assortment_id, date_rec_.assortment_node_id, date_rec_.price_unit_meas, date_rec_.min_quantity, date_rec_.valid_date);
               FETCH get_source INTO source_rec_;
               CLOSE get_source;
               source_rec_.agreement_id := to_agreement_id_;
               Copy_Assortment_Deal_Line___ (source_rec_, from_agreement_id_, source_rec_.valid_from, currency_rate_, copy_notes_);
            END LOOP;
         END IF;
      END IF;
   ELSE
      IF row_select_state_ =  'Include_All_Dates' THEN
         --Copy valid lines as at valid_from_date_ with valid from date to_valid_from_date_
         FOR date_rec_ IN get_min_date_part_all LOOP
            OPEN get_source(date_rec_.assortment_id, date_rec_.assortment_node_id, date_rec_.price_unit_meas, date_rec_.min_quantity, date_rec_.valid_date);
            FETCH get_source INTO source_rec_;
            CLOSE get_source;
            -- If to_valid_from_date_ is later than original valid_to_date, then the new line's valid_to_date should be NULL.
            IF TRUNC(to_valid_from_) > TRUNC(Get_Valid_To(from_agreement_id_, source_rec_.assortment_id, source_rec_.assortment_node_id, source_rec_.min_quantity, source_rec_.valid_from, source_rec_.price_unit_meas)) THEN
               raise_msg_ := 'TRUE';
               source_rec_.valid_to := NULL;
            END IF;
            source_rec_.agreement_id := to_agreement_id_;
            from_valid_from_ := source_rec_.valid_from;
            source_rec_.valid_from := to_valid_from_;
            Copy_Assortment_Deal_Line___ (source_rec_, from_agreement_id_, date_rec_.valid_date, currency_rate_, copy_notes_);
         END LOOP;
      ELSE
         --Copy valid lines as at valid_from_ with valid from date to_valid_from_
         FOR date_rec_ IN get_min_date_part LOOP
            OPEN get_source(date_rec_.assortment_id, date_rec_.assortment_node_id, date_rec_.price_unit_meas, date_rec_.min_quantity, date_rec_.valid_date);
            FETCH get_source INTO source_rec_;
            CLOSE get_source;
            source_rec_.agreement_id := to_agreement_id_;
            from_valid_from_ := source_rec_.valid_from;
            source_rec_.valid_from := to_valid_from_;
            Copy_Assortment_Deal_Line___ (source_rec_, from_agreement_id_, date_rec_.valid_date, currency_rate_, copy_notes_);
         END LOOP;
      END IF;
      
      
   END IF;
END Copy_All_Assortment_Deals__;


PROCEDURE Modify_Discount__ (
   agreement_id_       IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_         IN DATE,
   price_unit_meas_    IN VARCHAR2,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   discount_           IN NUMBER,
   discount_type_      IN VARCHAR2 )
IS
   attr_            VARCHAR2(2000);
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
   newrec_          AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE;
   oldrec_          AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE;
   indrec_          Indicator_Rec;
BEGIN
   
   oldrec_ := Lock_By_Keys___(agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_);
   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_);
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


@UncheckedAccess
FUNCTION Get_Disc_Line_Count_Per_Deal__ (
   agreement_id_       IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_         IN DATE,
   price_unit_meas_    IN VARCHAR2,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   line_count_          NUMBER;
   -- Hence null price_unit_meas_ means *. 
   CURSOR get_total_lines IS
      SELECT count(discount_no)
      FROM   AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE  agreement_id = agreement_id_
      AND    min_quantity = min_quantity_
      AND    valid_from = valid_from_
      AND    price_unit_meas = NVL(price_unit_meas_, '*')
      AND    assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_;
BEGIN
   OPEN get_total_lines;
   FETCH get_total_lines INTO line_count_;
   CLOSE get_total_lines;
   RETURN line_count_;
END Get_Disc_Line_Count_Per_Deal__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Deal_Price_Node
--   In the assortment structure given, for that part given, returns
--   the closest assortment node which has defined price data in AgreementAssortmentDeal with matching conditions.
PROCEDURE Get_Deal_Price_Node (
   assortment_node_ OUT VARCHAR2,
   min_quantity_    OUT NUMBER,
   valid_from_      OUT DATE,
   assortment_id_   IN  VARCHAR2,
   part_no_         IN  VARCHAR2,
   agreement_id_    IN  VARCHAR2,
   price_uom_       IN  VARCHAR2,
   price_qty_due_   IN  NUMBER,
   price_date_      IN  DATE )
IS
   last_calender_date_ DATE := Database_SYS.Get_Last_Calendar_Date();
   -- For performance reasons take an Active Assortment Structure - Agreement ID in.
   -- Min quantity has not been considered.
   CURSOR get_node_in_agreement IS
          SELECT t.assortment_node_id
          FROM assortment_node_tab t
          WHERE EXISTS (SELECT 1 FROM agreement_assortment_deal_tab dt
                                 WHERE dt.assortment_id = t.assortment_id
                                 AND dt.assortment_node_id = t.assortment_node_id
                                 AND dt.agreement_id = agreement_id_
                                 AND dt.price_unit_meas = price_uom_
                                 AND TRUNC(dt.valid_from) <= TRUNC(NVL(price_date_, SYSDATE))
                                 AND TRUNC(NVL(dt.valid_to, last_calender_date_)) >= TRUNC(NVL(price_date_, SYSDATE))
                                 AND dt.deal_price IS NOT NULL
                        )
          START WITH        t.assortment_id = assortment_id_
                 AND        t.assortment_node_id = part_no_
          CONNECT BY PRIOR  t.assortment_id = t.assortment_id
                 AND PRIOR  t.parent_node = t.assortment_node_id;

   -- Search for the correct quantity range within the valid period.
   CURSOR get_min_qty(assortment_node_id_ IN VARCHAR2) IS
      SELECT MAX(min_quantity)
         FROM   agreement_assortment_deal_tab
         WHERE  assortment_id = assortment_id_
         AND    agreement_id = agreement_id_
         AND    assortment_node_id = assortment_node_id_
         AND    min_quantity <= price_qty_due_
         AND    TRUNC(valid_from) <= TRUNC(NVL(price_date_, SYSDATE))
         AND    TRUNC(NVL(valid_to, last_calender_date_)) >= TRUNC(NVL(price_date_, SYSDATE))
         AND    deal_price IS NOT NULL
         AND    price_unit_meas = price_uom_;
   
   CURSOR get_price_qty_from_period(assortment_node_id_ IN VARCHAR2, min_qty_ NUMBER) IS
      SELECT valid_from
         FROM   agreement_assortment_deal_tab
         WHERE  assortment_id = assortment_id_
         AND    agreement_id = agreement_id_
         AND    assortment_node_id = assortment_node_id_
         AND    min_quantity = min_qty_
         AND    TRUNC(valid_from) <= TRUNC(NVL(price_date_, SYSDATE))
         AND    TRUNC(valid_to) >= TRUNC(NVL(price_date_, SYSDATE))
         AND    deal_price IS NOT NULL
         AND    price_unit_meas = price_uom_
         AND    valid_to IS NOT NULL;
   
   CURSOR get_price_qty_max_from_date(assortment_node_id_ IN VARCHAR2, min_qty_ NUMBER) IS
      SELECT MAX(valid_from)
         FROM   agreement_assortment_deal_tab
         WHERE  assortment_id = assortment_id_
         AND    agreement_id = agreement_id_
         AND    assortment_node_id = assortment_node_id_
         AND    min_quantity = min_qty_
         AND    TRUNC(valid_from) <= TRUNC(NVL(price_date_, SYSDATE))
         AND    deal_price IS NOT NULL
         AND    price_unit_meas = price_uom_
         AND    valid_to IS NULL;
         
   temp_min_qty_       NUMBER;
   temp_date_         DATE;

BEGIN
   FOR rec_ IN get_node_in_agreement LOOP
      OPEN get_min_qty(rec_.assortment_node_id);
      FETCH get_min_qty INTO temp_min_qty_;
      CLOSE get_min_qty;

      IF (temp_min_qty_ IS NOT NULL) THEN
         OPEN get_price_qty_from_period(rec_.assortment_node_id, temp_min_qty_);
         FETCH get_price_qty_from_period INTO temp_date_;
         CLOSE get_price_qty_from_period;
         IF (temp_date_ IS NULL) THEN
            OPEN get_price_qty_max_from_date(rec_.assortment_node_id, temp_min_qty_);
            FETCH get_price_qty_max_from_date INTO temp_date_;
            CLOSE get_price_qty_max_from_date;
         END IF;
         assortment_node_ := rec_.assortment_node_id;
         min_quantity_ := temp_min_qty_;
         valid_from_ := temp_date_;
      END IF;
      EXIT WHEN temp_min_qty_ IS NOT NULL;
   END LOOP;
END Get_Deal_Price_Node;


-- Get_Discount_Node
--   In the assortment structure given, for that part given, returns
--   the closest assortment node which has defined discount data in AgreementAssortmentDeal with matching conditions.
PROCEDURE Get_Discount_Node (
   deal_assort_node_ OUT VARCHAR2,
   min_quantity_     OUT NUMBER,
   valid_from_       OUT DATE,
   deal_price_uom_   OUT VARCHAR2,
   assortment_id_    IN  VARCHAR2,
   assortment_node_  IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   agreement_id_     IN  VARCHAR2,
   price_uom_        IN  VARCHAR2,
   price_qty_due_    IN  NUMBER,
   price_date_       IN  DATE )
IS
   temp_min_qty_     NUMBER;
   temp_date_        DATE;

   -- For performance reasons take an Active Assortment Structure - Agreement ID in.
   -- Min quantity has not been considered.
   -- Since discount with the price is fetched from the price fetching 
   -- logic, here select only the additional discounts (discount with out a price).

   CURSOR get_node_for_given_uom IS
          SELECT t.assortment_node_id
          FROM assortment_node_tab t
          WHERE EXISTS (SELECT 1 
                        FROM   agreement_assortment_deal_tab dt
                        WHERE  dt.assortment_id = t.assortment_id
                        AND    dt.assortment_node_id = t.assortment_node_id
                        AND    dt.agreement_id = agreement_id_
                        AND    dt.price_unit_meas = NVL(price_uom_, '*')
                        AND    TRUNC(dt.valid_from) <= TRUNC(NVL(price_date_, SYSDATE))
                        AND    TRUNC(NVL(dt.valid_to, TO_DATE('9999-12-31', 'YYYY-MM-DD', 'NLS_CALENDAR=GREGORIAN'))) >= TRUNC(NVL(price_date_, SYSDATE))
                        AND    dt.deal_price IS NULL
                        )
          START WITH        t.assortment_id = assortment_id_
                 AND        t.assortment_node_id = part_no_
          CONNECT BY PRIOR  t.assortment_id = t.assortment_id
                 AND PRIOR  t.parent_node = t.assortment_node_id;

   -- Standalone discount may exist that valid for all UoMs.
   CURSOR get_node_for_all_uom IS
          SELECT t.assortment_node_id
          FROM assortment_node_tab t
          WHERE EXISTS (SELECT 1 
                        FROM   agreement_assortment_deal_tab dt
                        WHERE  dt.assortment_id = t.assortment_id
                        AND    dt.assortment_node_id = t.assortment_node_id
                        AND    dt.agreement_id = agreement_id_
                        AND    dt.price_unit_meas = '*'
                        AND    TRUNC(dt.valid_from) <= TRUNC(NVL(price_date_, SYSDATE))
                        AND    TRUNC(NVL(dt.valid_to, TO_DATE('9999-12-31', 'YYYY-MM-DD', 'NLS_CALENDAR=GREGORIAN'))) >= TRUNC(NVL(price_date_, SYSDATE))
                        AND    dt.deal_price IS NULL
                        )
          START WITH        t.assortment_id = assortment_id_
                 AND        t.assortment_node_id = part_no_
          CONNECT BY PRIOR  t.assortment_id = t.assortment_id
                 AND PRIOR  t.parent_node = t.assortment_node_id;


   -- Search for the correct quantity range within the valid period.
   CURSOR get_discount_min_qty(assortment_node_id_ IN VARCHAR2, uom_to_consider_ IN VARCHAR2) IS
      SELECT MAX(min_quantity)
         FROM   agreement_assortment_deal_tab
         WHERE  assortment_id = assortment_id_
         AND    agreement_id = agreement_id_
         AND    assortment_node_id = assortment_node_id_
         AND    min_quantity <= price_qty_due_
         AND    TRUNC(valid_from) <= TRUNC(NVL(price_date_, SYSDATE))
         AND    TRUNC(NVL(valid_to, TO_DATE('9999-12-31', 'YYYY-MM-DD', 'NLS_CALENDAR=GREGORIAN'))) >= TRUNC(NVL(price_date_, SYSDATE))
         AND    deal_price IS NULL
         AND    price_unit_meas = uom_to_consider_;
   
   CURSOR get_discount_period(assortment_node_id_ IN VARCHAR2, uom_to_consider_ IN VARCHAR2, min_qty_ NUMBER) IS
      SELECT valid_from
      FROM   agreement_assortment_deal_tab
      WHERE  assortment_id = assortment_id_
      AND    agreement_id = agreement_id_
      AND    assortment_node_id = assortment_node_id_
      AND    TRUNC(valid_from) <= TRUNC(NVL(price_date_, SYSDATE))
      AND    TRUNC(NVL(valid_to, TO_DATE('9999-12-31', 'YYYY-MM-DD', 'NLS_CALENDAR=GREGORIAN'))) >= TRUNC(NVL(price_date_, SYSDATE))
      AND    deal_price IS NULL
      AND    price_unit_meas = uom_to_consider_
      AND    min_quantity = min_qty_
      AND    valid_to IS NOT NULL;
   
   CURSOR get_discount_from_date(assortment_node_id_ IN VARCHAR2, uom_to_consider_ IN VARCHAR2, min_qty_ NUMBER) IS
      SELECT MAX(valid_from)
      FROM   agreement_assortment_deal_tab
      WHERE  assortment_id = assortment_id_
      AND    agreement_id = agreement_id_
      AND    assortment_node_id = assortment_node_id_
      AND    TRUNC(valid_from) <= TRUNC(NVL(price_date_, SYSDATE))
      AND    TRUNC(NVL(valid_to, TO_DATE('9999-12-31', 'YYYY-MM-DD', 'NLS_CALENDAR=GREGORIAN'))) >= TRUNC(NVL(price_date_, SYSDATE))
      AND    deal_price IS NULL
      AND    price_unit_meas = uom_to_consider_
      AND    min_quantity = min_qty_
      AND    valid_to IS NULL;
         
BEGIN
   -- IF an assortment node id passed in, search limits for the discount quantity range.
   -- Else search for an assortment node, in given assortment structure, that has part_no_ as its' child and a valid agreement_assortment_deal entry exists. 
   IF (assortment_node_ IS NOT NULL) THEN
      -- Search the best line that has this given price uom. 
      OPEN get_discount_min_qty(assortment_node_, price_uom_);
      FETCH get_discount_min_qty INTO temp_min_qty_;
      CLOSE get_discount_min_qty;

      IF (temp_min_qty_ IS NOT NULL) THEN
         OPEN get_discount_period(assortment_node_, price_uom_, temp_min_qty_);
         FETCH get_discount_period INTO temp_date_;
         CLOSE get_discount_period;
         IF (temp_date_ IS NULL) THEN
            OPEN get_discount_from_date(assortment_node_, price_uom_, temp_min_qty_);
            FETCH get_discount_from_date INTO temp_date_;
            CLOSE get_discount_from_date;
         END IF;
         
         deal_assort_node_ := assortment_node_;
         min_quantity_ := temp_min_qty_;
         valid_from_ := temp_date_;
         deal_price_uom_ := price_uom_;
      END IF;
      IF (min_quantity_ IS NULL) THEN
         -- IF given UoM does not have a matching line, search for all UoM lines.
         OPEN get_discount_min_qty(assortment_node_, '*');
         FETCH get_discount_min_qty INTO temp_min_qty_;
         CLOSE get_discount_min_qty;
         IF (temp_min_qty_ IS NOT NULL) THEN
            OPEN get_discount_period(assortment_node_, '*', temp_min_qty_);
            FETCH get_discount_period INTO temp_date_;
            CLOSE get_discount_period;
            IF (temp_date_ IS NULL) THEN
               OPEN get_discount_from_date(assortment_node_, '*', temp_min_qty_);
               FETCH get_discount_from_date INTO temp_date_;
               CLOSE get_discount_from_date;
            END IF;
            deal_assort_node_ := assortment_node_;
            min_quantity_ := temp_min_qty_;
            valid_from_ := temp_date_;
            deal_price_uom_ := '*';
         END IF;
      END IF;
   ELSE
      -- No assortment_node_ given. Search a one and then pick most matching quantity range.
      FOR rec_ IN get_node_for_given_uom LOOP
         -- Search the best line that has this given price uom. 
         OPEN get_discount_min_qty(rec_.assortment_node_id, price_uom_);
         FETCH get_discount_min_qty INTO temp_min_qty_;
         CLOSE get_discount_min_qty;

         IF (temp_min_qty_ IS NOT NULL) THEN
            OPEN get_discount_period(rec_.assortment_node_id, price_uom_, temp_min_qty_);
            FETCH get_discount_period INTO temp_date_;
            CLOSE get_discount_period;
            IF (temp_date_ IS NULL) THEN
               OPEN get_discount_from_date(rec_.assortment_node_id, price_uom_, temp_min_qty_);
               FETCH get_discount_from_date INTO temp_date_;
               CLOSE get_discount_from_date;
            END IF;
            deal_assort_node_ := rec_.assortment_node_id;
            min_quantity_ := temp_min_qty_;
            valid_from_ := temp_date_;
            deal_price_uom_ := price_uom_;
         END IF;
         EXIT WHEN temp_min_qty_ IS NOT NULL;
      END LOOP;
      IF (min_quantity_ IS NULL) THEN
         -- IF given UoM does not have a matching line, search for all UoM lines.
         FOR rec_ IN get_node_for_all_uom LOOP
            OPEN get_discount_min_qty(rec_.assortment_node_id, '*');
            FETCH get_discount_min_qty INTO temp_min_qty_;
            CLOSE get_discount_min_qty;

            IF (temp_min_qty_ IS NOT NULL) THEN
               OPEN get_discount_period(rec_.assortment_node_id, '*', temp_min_qty_);
               FETCH get_discount_period INTO temp_date_;
               CLOSE get_discount_period;
               IF (temp_date_ IS NULL) THEN
                  OPEN get_discount_from_date(rec_.assortment_node_id, '*', temp_min_qty_);
                  FETCH get_discount_from_date INTO temp_date_;
                  CLOSE get_discount_from_date;
               END IF;
               deal_assort_node_ := rec_.assortment_node_id;
               min_quantity_ := temp_min_qty_;
               valid_from_ := temp_date_;
               deal_price_uom_ := '*';
            END IF;
            EXIT WHEN temp_min_qty_ IS NOT NULL;
         END LOOP;
      END IF;
   END IF;
END Get_Discount_Node;


-- Remove
--   Removes specified record.
PROCEDURE Remove (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   agreement_id_       IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_         IN DATE,
   price_unit_meas_    IN VARCHAR2 )
IS
   remrec_     AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_, assortment_id_, assortment_node_id_,
                             min_quantity_, valid_from_, price_unit_meas_ );
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


-- Modify_Deal_Price
--   Update deal price.
PROCEDURE Modify_Deal_Price (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   agreement_id_       IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_         IN DATE,
   price_unit_meas_    IN VARCHAR2,
   deal_price_         IN NUMBER,
   valid_to_date_      IN DATE )
IS
   attr_            VARCHAR2(2000);
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
   newrec_          AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE;
   oldrec_          AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE;
   indrec_          Indicator_Rec;
BEGIN
   
   oldrec_ := Lock_By_Keys___(agreement_id_, assortment_id_, assortment_node_id_, min_quantity_,  valid_from_, price_unit_meas_);
   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_, price_unit_meas_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DEAL_PRICE', deal_price_, attr_);
   Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 1, attr_);
   Client_SYS.Add_To_Attr('VALID_TO', valid_to_date_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);

END Modify_Deal_Price;


-- New
--   Add a new record to deal per assortment line at customer agreement.
--   This method calls only from CustomerAgreement.apy
PROCEDURE New (
   agreement_id_       IN VARCHAR2,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   price_unit_meas_    IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_date_    IN DATE,
   deal_price_         IN NUMBER,
   provisional_price_  IN VARCHAR2,
   discount_type_      IN VARCHAR2,
   discount_           IN NUMBER,
   net_price_          IN VARCHAR2,
   rounding_           IN NUMBER,
   valid_to_date_      IN DATE )
IS
   objid_      AGREEMENT_ASSORTMENT_DEAL.objid%TYPE;
   objversion_ AGREEMENT_ASSORTMENT_DEAL.objversion%TYPE;
   newrec_     AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_ID', agreement_id_, attr_);
   Client_SYS.Add_To_Attr('MIN_QUANTITY', min_quantity_, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM', valid_from_date_, attr_);
   Client_SYS.Add_To_Attr('PRICE_UNIT_MEAS', price_unit_meas_, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_ID', assortment_id_, attr_);
   Client_SYS.Add_To_Attr('ASSORTMENT_NODE_ID', assortment_node_id_, attr_);
   Client_SYS.Add_To_Attr('DEAL_PRICE', deal_price_, attr_);
   Client_SYS.Add_To_Attr('PROVISIONAL_PRICE_DB', provisional_price_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_TYPE', discount_type_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
   Client_SYS.Add_To_Attr('NET_PRICE_DB', net_price_, attr_);
   Client_SYS.Add_To_Attr('ROUNDING', rounding_, attr_);
   Client_SYS.Add_To_Attr('VALID_TO', valid_to_date_, attr_);
   -- server_data_change attribute is set becuase NEW is only called when updaing the
   -- assortment nodes from Update Agreement Assortment Price..
   Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 1, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___( objid_, objversion_, newrec_, attr_ );
END New;


-- Discount_Amount_Exist
--   Returns TRUE if there exist discount lines having discount amount.
@UncheckedAccess
FUNCTION Discount_Amount_Exist (
   agreement_id_        IN VARCHAR2,
   min_quantity_        IN NUMBER,
   valid_from_          IN DATE,
   price_unit_meas_     IN VARCHAR2,
   assortment_id_       IN VARCHAR2,
   assortment_node_id_  IN VARCHAR2) RETURN VARCHAR2
IS
   found_       VARCHAR2(5) := 'FALSE';
   count_       NUMBER;
   
   CURSOR get_disc_amount IS
      SELECT count(agreement_id)
      FROM AGREEMENT_ASSORT_DISCOUNT_TAB
      WHERE agreement_id       = agreement_id_
      AND   min_quantity       = min_quantity_
      AND   valid_from         = valid_from_
      AND   price_unit_meas    = price_unit_meas_
      AND   assortment_id      = assortment_id_
      AND   assortment_node_id = assortment_node_id_
      AND   discount_amount IS NOT NULL;
BEGIN
   OPEN get_disc_amount;
   FETCH get_disc_amount INTO count_;
   CLOSE get_disc_amount;
   
   IF (count_ >= 1) THEN
      found_ := 'TRUE';
   END IF;
   
   RETURN found_;
END Discount_Amount_Exist;


-- Copy
--   Copies the selected assortment deal lines.
PROCEDURE Copy (
   to_agreement_id_    IN VARCHAR2,
   attr_               IN VARCHAR2 )
IS
   source_rec_          AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE;
   new_agree_rec_       CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   source_agree_rec_    CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   ptr_                 NUMBER;
   name_                VARCHAR2(30);
   value_               VARCHAR2(2000);
   from_agreement_      VARCHAR2(10);
   currency_rate_       NUMBER;
   currtype_            VARCHAR2(10);
   conv_factor_         NUMBER;
   rate_                NUMBER;
   agr_assort_deal_tab_ Agree_Assort_Deal_Table;
   row_count_           NUMBER := 0;
   
   CURSOR  get_source(agreement_id_ IN VARCHAR2, min_qty_ IN NUMBER, valid_from_ IN DATE, price_unit_meas_ IN VARCHAR2, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2) IS
      SELECT *
      FROM AGREEMENT_ASSORTMENT_DEAL_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_qty_
      AND   valid_from = valid_from_
      AND   price_unit_meas = price_unit_meas_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_;
   
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
   
   ptr_ := NULL;
   IF (attr_ IS NOT NULL) THEN
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'AGREEMENT_ID') THEN
            agr_assort_deal_tab_(row_count_).agreement_id := value_;
         ELSIF (name_ = 'MIN_QUANTITY') THEN
            agr_assort_deal_tab_(row_count_).min_qty := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'VALID_FROM') THEN
            agr_assort_deal_tab_(row_count_).valid_from := Client_SYS.Attr_Value_To_Date(value_);
         ELSIF (name_ = 'PRICE_UNIT_MEAS') THEN
            agr_assort_deal_tab_(row_count_).price_unit_meas := value_;
         ELSIF (name_ = 'ASSORTMENT_ID') THEN
            agr_assort_deal_tab_(row_count_).assortment_id := value_;
         ELSIF (name_ = 'ASSORTMENT_NODE_ID') THEN
            agr_assort_deal_tab_(row_count_).assortment_node_id := value_;
            row_count_ := row_count_ + 1;
         END IF;
      END LOOP; 
   END IF;
   
   IF (agr_assort_deal_tab_.COUNT > 0) THEN
      FOR index_ IN agr_assort_deal_tab_.FIRST..agr_assort_deal_tab_.LAST LOOP   
         OPEN get_source(agr_assort_deal_tab_(index_).agreement_id, agr_assort_deal_tab_(index_).min_qty, agr_assort_deal_tab_(index_).valid_from, agr_assort_deal_tab_(index_).price_unit_meas, agr_assort_deal_tab_(index_).assortment_id, agr_assort_deal_tab_(index_).assortment_node_id);
         FETCH get_source INTO source_rec_; 
         CLOSE get_source;
      
         OPEN get_agreement_data(source_rec_.agreement_id);
         FETCH get_agreement_data INTO source_agree_rec_; 
         CLOSE get_agreement_data;
      
         IF (NVL(new_agree_rec_.assortment_id, Database_SYS.string_null_) != NVL(source_agree_rec_.assortment_id, Database_SYS.string_null_)) THEN
            Error_SYS.Record_General(lu_name_, 'WRONGASSORT: In order to copy the selected lines, agreement :P1 should include the assortment :P2.', to_agreement_id_, source_agree_rec_.assortment_id);
         END IF; 
         
         IF (source_agree_rec_.currency_code = new_agree_rec_.currency_code) THEN
            currency_rate_ := 1;
         ELSE
            Invoice_Library_API.Get_Currency_Rate_Defaults(currtype_, conv_factor_, rate_, source_agree_rec_.company, source_agree_rec_.currency_code, SYSDATE, 'CUSTOMER', NULL);
            -- Currence rate for Source agreement's currency to base currency
            currency_rate_ := rate_ / conv_factor_;
            Invoice_Library_API.Get_Currency_Rate_Defaults(currtype_, conv_factor_, rate_, source_agree_rec_.company, new_agree_rec_.currency_code, SYSDATE, 'CUSTOMER', NULL);
            -- Currence rate for new agreement's currency from Source agreement's currency
            currency_rate_ := currency_rate_ * conv_factor_ / rate_ ;
         END IF;
      
         from_agreement_ := source_rec_.agreement_id;
         source_rec_.agreement_id := to_agreement_id_;
         
         Copy_Assortment_Deal_Line___(source_rec_, from_agreement_, agr_assort_deal_tab_(index_).valid_from, currency_rate_, 1);
      END LOOP;
   END IF;
END Copy;

-- This method modifies valid_to_date
PROCEDURE Modify_Valid_To_Date (
   agreement_id_       IN VARCHAR2,
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   min_quantity_       IN NUMBER,
   valid_from_date_    IN DATE,
   price_unit_meas_    IN VARCHAR2,
   valid_to_date_      IN DATE )
IS   
   newrec_     AGREEMENT_ASSORTMENT_DEAL_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(agreement_id_, assortment_id_, assortment_node_id_, min_quantity_, valid_from_date_, price_unit_meas_);
   newrec_.valid_to := valid_to_date_;
   Modify___(newrec_);
END Modify_Valid_To_Date;


