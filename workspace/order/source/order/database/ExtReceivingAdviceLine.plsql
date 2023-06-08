-----------------------------------------------------------------------------
--
--  Logical unit: ExtReceivingAdviceLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190930  DaZase  SCSPRING20-143, Added Raise_Manual_Matching_Error___ to solve MessageDefinitionValidation issue.
--  180126  RoJalk  STRSC-15962, Modified Matching_Line___ and added missing NVL when calculating sales_qty_conf_apprd_.
--  150819  PrYaLK  Bug 121587, Modified procedure Matching_Line___ to fetch both customer_part_conv_factor and cust_part_invert_conv_fact by calling
--  150819          Customer_Order_Line_API.Get() instead of calling both Customer_Order_Line_API.Get_Customer_Part_Conv_Factor and
--  150819          Customer_Order_Line_API.Get_Cust_Part_Invert_Conv_Fact.
--  141210  JeLise  PRSC-399, Added line_item_no in where-statement in both cursors in Get_Match_Line_For_Delnote___.
--  130710  MaIklk  TIBE-993, Moved deliv_unconfirm_cos_tab_ global variable to relevant function and modified the function to use CLOB. 
--  120313  MoIflk  Bug 99430, Modified procedure Matching_Line___ to include inverted_conv_factor.
--  120130  NaLrlk  Replaced the method call Part_Catalog_API.Get_Active_Gtin_Part_No with Part_Gtin_API.Part_Gtin_API.Get_Part_Via_Identified_Gtin.
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  100520  KRPELK  Merge Rose Method Documentation.
--  101008  MaRalk  Modified the state machine according to the new developer studio template - 2.5.
--  090930  MaMalk  Removed constant state_separator_. Modified Finite_State_Init___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  090817  MaJalk  Bug 83121, Changed the data type of the gtin no to String.
--  080604  AmPalk  Removed ean_no.
--  080509  KiSalk  Added Validate_Customer_Part_No___ and GTIN validations.
--  080505  KiSalk  Added attribute gtin_no and modified New.
--  --------------------------- Nice Price Start -----------------------------
--  080102  MaMalk  Bug 65955, Modified the method Matching_Line___ to consider customer_part_conv_factor when doing
--  080102          calculations and comparisons.
--  060420  RoJalk  Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 ------------------------------------------
--  060224  KeFelk  Modifications to Get_Match_Line_For_Po_Ref___ inorder to deal when only PO no is exist.
--  051111  UsRalk  Modified matching related cursors.
--  051027  UsRalk  Removed method Get_Valid_Rec_Advice_Type___.
--  051027  UsRalk  Modified matching logic to use customer_part_no instead of catalog_no.
--  050926  KeFelk  Modifications to Packed_Deliv_Unconfirm_Cos__.
--  050921  KeFelk  Added Check_Manual_Match__.
--  050914  KeFelk  Added Matched_User and related logic to the LU.
--  050907  KeFelk  Added Set_Qty_Confirmed_Arrived instead of Modify_Qty_Confirmed_Arrived in matching process.
--  050830  KeFelk  Changes to Matching_Line___, Automatic Matching of differences.
--  050826  KeFelk  Removed Auto_Matching_Enable method. Move the logic to CustomerOrderTransfer LU.
--  050811  KeFelk  Changes to Get_Match_Line_For_Po_Ref___.
--  050805  KeFelk  Added Get_Error_Message and Clear_Line_Error_Message__.
--  050727  KeFelk  Added more methods for manual matching.
--  050720  KeFelk  Modifications to Get_Match_Line_For_%%% methods and added Auto_Matching_Enabled___.
--  050715  KeFelk  Changed the matching logic by introducing Contract to it.
--  050706  KeFelk  Added new methods and added more logic to the existing methods.
--  050627  KeFelk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------




-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE deliv_unconfirm_cos_rec IS RECORD(
   row_no                 NUMBER,
   deliv_no               NUMBER,
   order_no               VARCHAR2(12),
   line_no                VARCHAR2(4),
   rel_no                 VARCHAR2(4),
   line_item_no           NUMBER,
   qty_confirmed_arrived  NUMBER,
   qty_to_invoice         NUMBER );

TYPE deliv_unconfirm_cos_table IS TABLE OF deliv_unconfirm_cos_rec INDEX BY BINARY_INTEGER;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Manual_Matching_Error___ (
   customer_part_no_ IN VARCHAR2,
   po_reference_     IN VARCHAR2 )
IS
BEGIN   
   Error_SYS.Record_General(lu_name_, 'TWODLFORDELNOTE: More than one unconfirmed customer order delivery lines were found for the customer part :P1 and delivery note no :P2. Manual matching must be performed.', customer_part_no_, po_reference_);
END Raise_Manual_Matching_Error___;

-- Get_Match_Line_For_Delnote___
--   This method is Used to find the unconfirmed customer order delivery line
--   for the  given customer and contract, when delivery note number is used
--   as mathing option.
PROCEDURE Get_Match_Line_For_Delnote___ (
   match_rec_    OUT Deliv_Unconfirm_Cust_Order%ROWTYPE,
   message_id_   IN  NUMBER,
   message_line_ IN  NUMBER,
   customer_no_  IN  VARCHAR2,
   contract_     IN  VARCHAR2 )
IS
   count_    NUMBER := 0;
   rec_      EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   head_rec_ Ext_Receiving_Advice_API.Public_Rec;

   CURSOR c_unconf_coline_for_delnote IS
      SELECT count(*)
      FROM deliv_unconfirm_cust_order
      WHERE customer_no = customer_no_
      AND   (contract   = contract_       OR contract_       IS NULL)
      AND   (catalog_no = rec_.catalog_no OR rec_.catalog_no IS NULL)
      AND   ((customer_part_no = rec_.customer_part_no) OR ((customer_part_no IS NULL) AND (catalog_no = rec_.catalog_no)))
      AND   delnote_no  = rec_.receipt_reference
      AND   line_item_no <= 0
      AND   DECODE(head_rec_.receiving_advice_type, 'ARRIVED_GOODS', NVL(qty_confirmed_arrived,0), 0) = 0;

   CURSOR get_unconf_coline_for_delnote IS
      SELECT *
      FROM deliv_unconfirm_cust_order
      WHERE customer_no = customer_no_
      AND   (contract   = contract_       OR contract_       IS NULL)
      AND   (catalog_no = rec_.catalog_no OR rec_.catalog_no IS NULL)
      AND   ((customer_part_no = rec_.customer_part_no) OR ((customer_part_no IS NULL) AND (catalog_no = rec_.catalog_no)))
      AND   delnote_no  = rec_.receipt_reference
      AND   line_item_no <= 0
      AND   DECODE(head_rec_.receiving_advice_type, 'ARRIVED_GOODS', NVL(qty_confirmed_arrived,0), 0) = 0;
BEGIN
   rec_      := Get_Object_By_Keys___(message_id_, message_line_);
   head_rec_ := Ext_Receiving_Advice_API.Get(message_id_);

   OPEN c_unconf_coline_for_delnote;
   FETCH c_unconf_coline_for_delnote INTO count_;
   CLOSE c_unconf_coline_for_delnote;

   IF count_ = 0 THEN
      Error_SYS.Record_General(lu_name_, 'NODLFORDELNOTE: Could not find any unconfirmed customer order delivery line for the customer part :P1 and delivery note no :P2.', rec_.customer_part_no, rec_.receipt_reference);
   ELSIF count_ > 1 THEN
      Raise_Manual_Matching_Error___(rec_.customer_part_no, rec_.receipt_reference);
   ELSE
      OPEN get_unconf_coline_for_delnote;
      FETCH get_unconf_coline_for_delnote INTO match_rec_;
      CLOSE get_unconf_coline_for_delnote;
   END IF;
END Get_Match_Line_For_Delnote___;


-- Get_Match_Line_For_Po_Ref___
--   This method is Used to find the unconfirmrd customer order delivery
--   line for the given customer and contarct, when customers PO reference
--   is used as mathing option.
PROCEDURE Get_Match_Line_For_Po_Ref___ (
   match_rec_    OUT Deliv_Unconfirm_Cust_Order%ROWTYPE,
   message_id_   IN  NUMBER,
   message_line_ IN  NUMBER,
   customer_no_  IN  VARCHAR2,
   contract_     IN  VARCHAR2 )
IS
   count_         NUMBER:=0;
   po_only_count_ NUMBER:=0;
   po_reference_  VARCHAR2(200);
   rec_           EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   head_rec_      Ext_Receiving_Advice_API.Public_Rec;

   CURSOR c_unconf_coline_for_poref IS
      SELECT count(*)
      FROM deliv_unconfirm_cust_order
      WHERE customer_no = customer_no_
      AND   (contract   = contract_       OR contract_       IS NULL)
      AND   (catalog_no = rec_.catalog_no OR rec_.catalog_no IS NULL)
      AND   ((customer_part_no = rec_.customer_part_no) OR ((customer_part_no IS NULL) AND (catalog_no = rec_.catalog_no)))
      AND   customer_po_no      = rec_.customer_po_no
      AND   customer_po_line_no = rec_.customer_po_line_no
      AND   customer_po_rel_no  = rec_.customer_po_release_no
      AND   DECODE(head_rec_.receiving_advice_type, 'ARRIVED_GOODS', NVL(qty_confirmed_arrived,0), 0) = 0;

   CURSOR c_unconf_coline_for_only_po IS
      SELECT count(*)
      FROM  deliv_unconfirm_cust_order
      WHERE customer_no = customer_no_
      AND   (contract   = contract_       OR contract_       IS NULL)
      AND   (catalog_no = rec_.catalog_no OR rec_.catalog_no IS NULL)
      AND   ((customer_part_no = rec_.customer_part_no) OR ((customer_part_no IS NULL) AND (catalog_no = rec_.catalog_no)))
      AND   customer_po_no     = rec_.customer_po_no
      AND   customer_po_line_no IS NULL AND rec_.customer_po_line_no IS NULL
      AND   customer_po_rel_no  IS NULL AND rec_.customer_po_release_no IS NULL
      AND   DECODE(head_rec_.receiving_advice_type, 'ARRIVED_GOODS', NVL(qty_confirmed_arrived,0), 0) = 0;

   CURSOR get_unconf_coline_for_poref IS
      SELECT *
      FROM  deliv_unconfirm_cust_order
      WHERE customer_no = customer_no_
      AND   (contract   = contract_       OR contract_       IS NULL)
      AND   (catalog_no = rec_.catalog_no OR rec_.catalog_no IS NULL)
      AND   ((customer_part_no = rec_.customer_part_no) OR ((customer_part_no IS NULL) AND (catalog_no = rec_.catalog_no)))
      AND   customer_po_no      = rec_.customer_po_no
      AND   customer_po_line_no = rec_.customer_po_line_no
      AND   customer_po_rel_no  = rec_.customer_po_release_no
      AND   DECODE(head_rec_.receiving_advice_type, 'ARRIVED_GOODS', NVL(qty_confirmed_arrived,0), 0) = 0;

   CURSOR get_unconf_coline_for_only_po IS
      SELECT *
      FROM  deliv_unconfirm_cust_order
      WHERE customer_no = customer_no_
      AND   (contract   = contract_       OR contract_       IS NULL)
      AND   (catalog_no = rec_.catalog_no OR rec_.catalog_no IS NULL)
      AND   ((customer_part_no = rec_.customer_part_no) OR ((customer_part_no IS NULL) AND (catalog_no = rec_.catalog_no)))
      AND   customer_po_no     = rec_.customer_po_no
      AND   customer_po_line_no IS NULL AND rec_.customer_po_line_no IS NULL
      AND   customer_po_rel_no  IS NULL AND rec_.customer_po_release_no IS NULL
      AND   DECODE(head_rec_.receiving_advice_type, 'ARRIVED_GOODS', NVL(qty_confirmed_arrived,0), 0) = 0;
BEGIN

   rec_      := Get_Object_By_Keys___(message_id_, message_line_);
   head_rec_ := Ext_Receiving_Advice_API.Get(message_id_);

   OPEN  c_unconf_coline_for_poref;
   FETCH c_unconf_coline_for_poref INTO count_;
   CLOSE c_unconf_coline_for_poref;

   OPEN  c_unconf_coline_for_only_po;
   FETCH c_unconf_coline_for_only_po INTO po_only_count_;
   CLOSE c_unconf_coline_for_only_po;

   po_reference_ := rec_.customer_po_no || ' ' || rec_.customer_po_line_no || ' ' || rec_.customer_po_release_no ;

   IF count_ = 0 THEN
      IF po_only_count_ = 0 THEN
         Error_SYS.Record_General(lu_name_, 'NODLFORPOREF: Could not find any unconfirmed customer order delivery line for the customer part :P1 and customer PO reference :P2.', rec_.customer_part_no, po_reference_);
      ELSIF po_only_count_ > 1 THEN
         Raise_Manual_Matching_Error___(rec_.customer_part_no, po_reference_);
      ELSE
         OPEN  get_unconf_coline_for_only_po;
         FETCH get_unconf_coline_for_only_po INTO match_rec_;
         CLOSE get_unconf_coline_for_only_po;
      END IF;
   ELSIF count_ > 1 THEN
      Raise_Manual_Matching_Error___(rec_.customer_part_no, po_reference_);
   ELSE
      OPEN  get_unconf_coline_for_poref;
      FETCH get_unconf_coline_for_poref INTO match_rec_;
      CLOSE get_unconf_coline_for_poref;
   END IF;
END Get_Match_Line_For_Po_Ref___;


-- Get_Match_Line_For_Ref_Id___
--   This method is Used to find the unconfirmrd customer order delivery
--   line for the given  given customer and contarct, when customers
--   refereance id is used as mathing option.
PROCEDURE Get_Match_Line_For_Ref_Id___ (
   match_rec_    OUT Deliv_Unconfirm_Cust_Order%ROWTYPE,
   message_id_   IN  NUMBER,
   message_line_ IN  NUMBER,
   customer_no_  IN  VARCHAR2,
   contract_     IN  VARCHAR2 )
IS
   count_    NUMBER:=0;
   rec_      EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   head_rec_ Ext_Receiving_Advice_API.Public_Rec;

   CURSOR c_unconf_coline_for_refid IS
      SELECT count(*)
      FROM  deliv_unconfirm_cust_order
      WHERE customer_no = customer_no_
      AND   (contract   = contract_       OR contract_       IS NULL)
      AND   (catalog_no = rec_.catalog_no OR rec_.catalog_no IS NULL)
      AND   ((customer_part_no = rec_.customer_part_no) OR ((customer_part_no IS NULL) AND (catalog_no = rec_.catalog_no)))
      AND   ref_id      = rec_.customer_ref_id
      AND   DECODE(head_rec_.receiving_advice_type, 'ARRIVED_GOODS', NVL(qty_confirmed_arrived,0), 0) = 0;

   CURSOR get_unconf_coline_for_refid IS
      SELECT *
      FROM  deliv_unconfirm_cust_order
      WHERE customer_no = customer_no_
      AND   (contract   = contract_       OR contract_       IS NULL)
      AND   (catalog_no = rec_.catalog_no OR rec_.catalog_no IS NULL)
      AND   ((customer_part_no = rec_.customer_part_no) OR ((customer_part_no IS NULL) AND (catalog_no = rec_.catalog_no)))
      AND   ref_id      = rec_.customer_ref_id
      AND   DECODE(head_rec_.receiving_advice_type, 'ARRIVED_GOODS', NVL(qty_confirmed_arrived,0), 0) = 0;
BEGIN
   rec_      := Get_Object_By_Keys___(message_id_, message_line_);
   head_rec_ := Ext_Receiving_Advice_API.Get(message_id_);

   OPEN  c_unconf_coline_for_refid;
   FETCH c_unconf_coline_for_refid INTO count_;
   CLOSE c_unconf_coline_for_refid;

   IF count_ = 0 THEN
      Error_SYS.Record_General(lu_name_, 'NODLFORREFID: Could not find any unconfirmed customer order delivery line for the customer part :P1 and reference id :P2.', rec_.customer_part_no, rec_.customer_ref_id);
   ELSIF count_ > 1 THEN
      Error_SYS.Record_General(lu_name_, 'TWODLFORREFID: More than one unconfirmed customer order delivery lines were found for the customer part :P1 and reference id :P2. Manual matching must be performed.', rec_.customer_part_no, rec_.customer_ref_id);
   ELSE
      OPEN  get_unconf_coline_for_refid;
      FETCH get_unconf_coline_for_refid INTO match_rec_;
      CLOSE get_unconf_coline_for_refid;
   END IF;
END Get_Match_Line_For_Ref_Id___;


-- Matching_Line___
--   This method is Used to to perform the mathing process for a given
--   receiving advice line.
PROCEDURE Matching_Line___ (
   message_id_               IN NUMBER,
   message_line_             IN NUMBER,
   match_rec_                IN Deliv_Unconfirm_Cust_Order%ROWTYPE,
   receiving_advice_type_db_ IN VARCHAR2,
   rec_adv_auto_match_diff_  IN VARCHAR2)
IS
   head_rec_             Ext_Receiving_Advice_API.Public_Rec;
   sales_qty_shipped_    NUMBER;
   rec_                  EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   sales_qty_conf_arrvd_ NUMBER;
   sales_qty_conf_apprd_ NUMBER;
   customer_rec_         Customer_Order_Line_API.Public_Rec;
BEGIN
   head_rec_ := Ext_Receiving_Advice_API.Get(message_id_);
   rec_      := Get_Object_By_Keys___(message_id_, message_line_);

   IF (receiving_advice_type_db_ != 'ARRIVED_AND_APPROVED_GOODS') AND (receiving_advice_type_db_ != head_rec_.receiving_advice_type ) THEN
      Error_SYS.Record_General(lu_name_, 'ADVTYPENOMATCH: Receiving Advice type is not matched.');
   END IF;

   customer_rec_ := Customer_Order_Line_API.Get(match_rec_.order_no,
                                                match_rec_.line_no,
                                                match_rec_.rel_no,
                                                match_rec_.line_item_no);

   sales_qty_shipped_ := match_rec_.qty_shipped / match_rec_.conv_factor * match_rec_.inverted_conv_factor;

   IF head_rec_.receiving_advice_type = 'ARRIVED_GOODS' THEN
      sales_qty_conf_arrvd_ := (rec_.qty_confirmed_arrived * NVL(customer_rec_.customer_part_conv_factor, 1))/NVL(customer_rec_.cust_part_invert_conv_fact, 1);
      IF receiving_advice_type_db_ = 'ARRIVED_GOODS' THEN
         IF (sales_qty_conf_arrvd_ = sales_qty_shipped_) OR
             (sales_qty_conf_arrvd_ != sales_qty_shipped_ AND rec_adv_auto_match_diff_ = 'TRUE') THEN
            Deliv_Confirm_Cust_Order_API.Confirm_Delivery(match_rec_.order_no,
                                                          match_rec_.line_no,
                                                          match_rec_.rel_no,
                                                          match_rec_.line_item_no,
                                                          match_rec_.deliv_no,
                                                          sales_qty_conf_arrvd_);
            Set_To_Matched__(message_id_, message_line_);
            Customer_Order_Delivery_API.Modify_Qty_Confirmed_Arrived(match_rec_.deliv_no,
                                                                     sales_qty_conf_arrvd_);
         ELSE
            Set_To_Qty_Difference__(message_id_, message_line_);
         END IF;
      ELSE
         IF (sales_qty_conf_arrvd_ = sales_qty_shipped_) OR
             (sales_qty_conf_arrvd_ != sales_qty_shipped_ AND rec_adv_auto_match_diff_ = 'TRUE') THEN
            Set_To_Matched__(message_id_, message_line_);
            Customer_Order_Delivery_API.Set_Qty_Confirmed_Arrived(match_rec_.deliv_no,
                                                                  sales_qty_conf_arrvd_);
         ELSE
            Set_To_Qty_Difference__(message_id_, message_line_);
         END IF;
      END IF;
   ELSE
      sales_qty_conf_apprd_ := (rec_.qty_confirmed_approved * NVL(customer_rec_.customer_part_conv_factor, 1))/NVL(customer_rec_.cust_part_invert_conv_fact, 1);

      IF (sales_qty_conf_apprd_ = sales_qty_shipped_) OR
          (sales_qty_conf_apprd_ != sales_qty_shipped_ AND rec_adv_auto_match_diff_ = 'TRUE') THEN
         Deliv_Confirm_Cust_Order_API.Confirm_Delivery(match_rec_.order_no,
                                                       match_rec_.line_no,
                                                       match_rec_.rel_no,
                                                       match_rec_.line_item_no,
                                                       match_rec_.deliv_no,
                                                       sales_qty_conf_apprd_);
         Set_To_Matched__(message_id_, message_line_);
         Customer_Order_Delivery_API.Set_Qty_Confirmed_Arrived(match_rec_.deliv_no,
                                                               sales_qty_conf_apprd_);
      ELSE
         Set_To_Qty_Difference__(message_id_, message_line_);
      END IF;
   END IF;
END Matching_Line___;


PROCEDURE Match_Deliv_Unconfirm_Cos___ (
   deliv_unconfirm_cos_tab_ IN deliv_unconfirm_cos_table,
   message_id_              IN NUMBER,
   message_line_            IN NUMBER )
IS
   attr_          VARCHAR2(32000);
   info_          VARCHAR2(2000);
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   error_message_ VARCHAR2(2000);
   transfer_tab_  deliv_unconfirm_cos_table;
   head_rec_      Ext_Receiving_Advice_API.Public_Rec;
   col_rec_       Customer_Order_Line_API.Public_Rec;
   tabale_row_    NUMBER;
BEGIN
   head_rec_     := Ext_Receiving_Advice_API.Get(message_id_);
   transfer_tab_ := deliv_unconfirm_cos_tab_;
   tabale_row_   := transfer_tab_.LAST;
   Clear_Line_Error_Message__(message_id_, message_line_);

   FOR i IN transfer_tab_.FIRST..transfer_tab_.LAST LOOP
      col_rec_ := Customer_Order_Line_API.Get(transfer_tab_(i).order_no,
                                              transfer_tab_(i).line_no,
                                              transfer_tab_(i).rel_no,
                                              transfer_tab_(i).line_item_no);

      IF (col_rec_.receiving_advice_type != 'ARRIVED_AND_APPROVED_GOODS') AND (col_rec_.receiving_advice_type != head_rec_.receiving_advice_type ) THEN
         Error_SYS.Record_General(lu_name_, 'ADVTYPENOMATCH: Receiving Advice type is not matched.');
      END IF;

      IF head_rec_.receiving_advice_type = 'ARRIVED_GOODS' THEN
         IF col_rec_.receiving_advice_type = 'ARRIVED_GOODS' THEN
            Deliv_Confirm_Cust_Order_API.Confirm_Delivery(transfer_tab_(i).order_no,
                                                          transfer_tab_(i).line_no,
                                                          transfer_tab_(i).rel_no,
                                                          transfer_tab_(i).line_item_no,
                                                          transfer_tab_(i).deliv_no,
                                                          transfer_tab_(i).qty_confirmed_arrived);
            IF (i = tabale_row_) THEN
               Set_To_Matched__(message_id_, message_line_);
            END IF;
            Customer_Order_Delivery_API.Set_Qty_Confirmed_Arrived(transfer_tab_(i).deliv_no,
                                                                  transfer_tab_(i).qty_confirmed_arrived);
            Customer_Order_Delivery_API.Modify_Qty_To_Invoice(transfer_tab_(i).deliv_no,
                                                              transfer_tab_(i).qty_confirmed_arrived);
         ELSE
            IF (i = tabale_row_) THEN
               Set_To_Matched__(message_id_, message_line_);
            END IF;
            Customer_Order_Delivery_API.Set_Qty_Confirmed_Arrived(transfer_tab_(i).deliv_no,
                                                                  transfer_tab_(i).qty_confirmed_arrived);
         END IF;
      ELSE
         Deliv_Confirm_Cust_Order_API.Confirm_Delivery(transfer_tab_(i).order_no,
                                                          transfer_tab_(i).line_no,
                                                          transfer_tab_(i).rel_no,
                                                          transfer_tab_(i).line_item_no,
                                                          transfer_tab_(i).deliv_no,
                                                          transfer_tab_(i).qty_to_invoice);
         IF (i = tabale_row_) THEN
            Set_To_Matched__(message_id_, message_line_);
         END IF;
         Customer_Order_Delivery_API.Set_Qty_Confirmed_Arrived(transfer_tab_(i).deliv_no,
                                                               transfer_tab_(i).qty_confirmed_arrived);
         Customer_Order_Delivery_API.Modify_Qty_To_Invoice(transfer_tab_(i).deliv_no,
                                                           transfer_tab_(i).qty_to_invoice);
      END IF;
   END LOOP;
EXCEPTION
   WHEN others THEN
      error_message_ := SQLERRM;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
      Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
      Line_Manual_Matching_Error__(info_, objid_, objversion_, attr_, 'DO');
END Match_Deliv_Unconfirm_Cos___;


PROCEDURE Fill_Deliv_Unconfirm_Cos___ (
   deliv_unconfirm_cos_tab_ IN OUT deliv_unconfirm_cos_table,
   transfer_rec_            IN     deliv_unconfirm_cos_rec )
IS
   index_ NUMBER;
BEGIN
   index_                                                 := deliv_unconfirm_cos_tab_.COUNT;
   index_                                                 := index_+ 1;
   deliv_unconfirm_cos_tab_(index_).row_no                := transfer_rec_.row_no;
   deliv_unconfirm_cos_tab_(index_).deliv_no              := transfer_rec_.deliv_no;
   deliv_unconfirm_cos_tab_(index_).order_no              := transfer_rec_.order_no;
   deliv_unconfirm_cos_tab_(index_).line_no               := transfer_rec_.line_no;
   deliv_unconfirm_cos_tab_(index_).rel_no                := transfer_rec_.rel_no;
   deliv_unconfirm_cos_tab_(index_).line_item_no          := transfer_rec_.line_item_no;
   deliv_unconfirm_cos_tab_(index_).qty_confirmed_arrived := transfer_rec_.qty_confirmed_arrived;
   deliv_unconfirm_cos_tab_(index_).qty_to_invoice        := transfer_rec_.qty_to_invoice;
END Fill_Deliv_Unconfirm_Cos___;


PROCEDURE Validate_Customer_Part_No___ (
   rec_ IN EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE )
IS
   customer_part_no_ EXT_RECEIVING_ADVICE_LINE_TAB.customer_part_no%TYPE;
BEGIN
   IF (rec_.customer_part_no IS NULL) THEN
      IF (rec_.gtin_no IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOCUSTOMERPARTNO: Customer part number is missing in the message line.');
      END IF;
      customer_part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(rec_.gtin_no);
      IF (customer_part_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'GTINERROR: GTIN No :P1 in the message line is inactive or not registered.', rec_.gtin_no);
      END IF;
   ELSIF (rec_.gtin_no IS NOT NULL) THEN
      IF (rec_.customer_part_no != NVL(Part_Gtin_API.Get_Part_Via_Identified_Gtin(rec_.gtin_no), rec_.customer_part_no)) THEN
         Error_SYS.Record_General(lu_name_, 'GTINMISMATCHR: GTIN No of customer part number :1 is different from :p2.', rec_.customer_part_no, rec_.gtin_no);
      END IF;
   END IF;
END Validate_Customer_Part_No___;


PROCEDURE Do_Refresh_Header___ (
   rec_  IN OUT EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Ext_Receiving_Advice_API.Refresh__(rec_.message_id);
END Do_Refresh_Header___;


PROCEDURE Do_Match___ (
   rec_  IN OUT EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   customer_no_              EXT_RECEIVING_ADVICE_TAB.customer_no%TYPE;
   info_                     VARCHAR2(2000);
   objid_                    VARCHAR2(2000);
   objversion_               VARCHAR2(2000);
   error_message_            VARCHAR2(2000);
   match_rec_                deliv_unconfirm_cust_order%ROWTYPE;
   coc_rec_                  Cust_Ord_Customer_API.Public_Rec;
   head_rec_                 Ext_Receiving_Advice_API.Public_Rec;
   receiving_advice_type_db_ VARCHAR2(30);
BEGIN
   @ApproveTransactionStatement(2013-12-09,mablse)
   SAVEPOINT Line_Match;

   Validate_Customer_Part_No___(rec_);

   head_rec_    := Ext_Receiving_Advice_API.Get(rec_.message_id);
   customer_no_ := Ext_Receiving_Advice_API.Get_Valid_Customer_No__(rec_.message_id);
   coc_rec_     := Cust_Ord_Customer_API.Get(customer_no_);

   CASE coc_rec_.rec_adv_matching_option
      WHEN 'DELIVERY NOTE' THEN
         IF (rec_.receipt_reference IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NODELNO: Delivery note number is missing in the message line.');
         END IF;
         Get_Match_Line_For_Delnote___(match_rec_,
                                       rec_.message_id,
                                       rec_.message_line,
                                       customer_no_,
                                       head_rec_.contract);
      WHEN 'CUSTOMERS PO REFERENCE' THEN
         IF (rec_.customer_po_no IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOPOREF: Customers po reference is missing in the received message line.');
         END IF;
         Get_Match_Line_For_Po_Ref___(match_rec_,
                                      rec_.message_id,
                                      rec_.message_line,
                                      customer_no_,
                                      head_rec_.contract);
      WHEN 'REFERENCE ID' THEN
         IF (rec_.customer_ref_id IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOREFID: Reference id is missing in the received message line.');
         END IF;
         Get_Match_Line_For_Ref_Id___(match_rec_,
                                      rec_.message_id,
                                      rec_.message_line,
                                      customer_no_,
                                      head_rec_.contract);
   END CASE;

   receiving_advice_type_db_ := Customer_Order_Line_API.Get_Receiving_Advice_Type_Db(match_rec_.order_no, match_rec_.line_no, match_rec_.rel_no, match_rec_.line_item_no);

   Matching_Line___(rec_.message_id,
                    rec_.message_line,
                    match_rec_,
                    receiving_advice_type_db_,
                    coc_rec_.rec_adv_auto_match_diff);
EXCEPTION
   WHEN others THEN
      error_message_ := SQLERRM;
      @ApproveTransactionStatement(2013-12-09,mablse)
      ROLLBACK TO Line_Match;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id, rec_.message_line);
      Line_Matching_Error__(info_, objid_, objversion_, attr_, 'DO');
END Do_Match___;


PROCEDURE Do_Line_Matching_Error___ (
   rec_  IN OUT EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_        EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   newrec_        EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   error_message_ VARCHAR2(2000);
   indrec_        Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(rec_.message_id, rec_.message_line);
   newrec_ := oldrec_;
   error_message_ := Client_SYS.Get_Item_Value('ERROR_MESSAGE',attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Client_SYS.Add_To_Attr('ERROR_MESSAGE',error_message_,attr_);
END Do_Line_Matching_Error___;


PROCEDURE Do_Update___ (
   rec_  IN OUT EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_       EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   newrec_       EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   fnd_user_     VARCHAR2(30);
   indrec_       Indicator_Rec;
BEGIN
   oldrec_   := Lock_By_Keys___(rec_.message_id, rec_.message_line);
   newrec_   := oldrec_;
   fnd_user_ := Fnd_Session_API.Get_Fnd_User;

   Client_SYS.Add_To_Attr('MATCHED_USER', fnd_user_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Client_SYS.Add_To_Attr('MATCHED_USER', fnd_user_, attr_);
END Do_Update___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE,
   newrec_     IN OUT EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   info_  VARCHAR2(2000);
   rowid_ VARCHAR2(2000);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (newrec_.error_message IS NULL AND newrec_.matched_user IS NULL) THEN
      Get_Id_Version_By_Keys___(rowid_, objversion_, newrec_.message_id, newrec_.message_line);
      Change__(info_, rowid_, objversion_, attr_, 'DO');
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT ext_receiving_advice_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   IF (newrec_.customer_part_no IS NULL AND newrec_.gtin_no IS NOT NULL) THEN
      newrec_.customer_part_no := Part_Gtin_API.Get_Part_Via_Identified_Gtin(newrec_.gtin_no);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     ext_receiving_advice_line_tab%ROWTYPE,
   newrec_ IN OUT ext_receiving_advice_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT(indrec_.error_message) THEN  
      newrec_.error_message := NULL;
   END IF;
   IF NOT(indrec_.matched_user) THEN 
      newrec_.matched_user  := NULL;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.customer_part_no IS NULL AND newrec_.gtin_no IS NOT NULL) THEN
      newrec_.customer_part_no := Part_Gtin_API.Get_Part_Via_Identified_Gtin(newrec_.gtin_no);
   END IF;
   IF newrec_.rowstate IN ('Matched', 'Cancelled') AND newrec_.matched_user IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'NOTALLOWUPDATELINE: Changes are not allowed when message line is in :P1 state.', newrec_.rowstate);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Set_To_Matched__
--   Changes the state to 'Matched'
PROCEDURE Set_To_Matched__ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   Client_SYS.Clear_Attr(attr_);
   Match_Line__(info_, objid_, objversion_, attr_, 'DO');
END Set_To_Matched__;


-- Set_To_Matching_In_Progress__
--   Changes the state to 'MatchingInProgress'
PROCEDURE Set_To_Matching_In_Progress__ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   Client_SYS.Clear_Attr(attr_);
   Match__(info_, objid_, objversion_, attr_, 'DO');
END Set_To_Matching_In_Progress__;


-- Set_To_Qty_Difference__
--   Changes the state to 'QtyDifference'
PROCEDURE Set_To_Qty_Difference__ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   Client_SYS.Clear_Attr(attr_);
   Qty_Difference_Line__(info_, objid_, objversion_, attr_, 'DO');
END Set_To_Qty_Difference__;


-- Set_To_Cancelled__
--   Changes the state to 'Cancelled'
PROCEDURE Set_To_Cancelled__ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   Client_SYS.Clear_Attr(attr_);
   Cancel__(info_, objid_, objversion_, attr_, 'DO');
END Set_To_Cancelled__;


-- Validate_Before_Manual_Match__
--   Use to validates the customer no and receiving advic type when
--   performing the manual matching.
PROCEDURE Validate_Before_Manual_Match__ (
   customer_no_   OUT VARCHAR2,
   error_message_ OUT VARCHAR2,
   message_id_    IN  NUMBER,
   message_line_  IN  NUMBER )
IS
   rec_           EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   head_rec_      Ext_Receiving_Advice_API.Public_Rec;
   attr_          VARCHAR2(32000);
   info_          VARCHAR2(2000);
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   header_error_  BOOLEAN:=TRUE;
   err_message_   VARCHAR2(2000);
BEGIN
   rec_      := Get_Object_By_Keys___(message_id_, message_line_);
   head_rec_ := Ext_Receiving_Advice_API.Get(message_id_);

   customer_no_  := head_rec_.customer_no;
   Ext_Receiving_Advice_API.Validate_Message__(customer_no_, head_rec_.internal_customer_site);
   header_error_ := FALSE;

   Validate_Customer_Part_No___(rec_);

   error_message_ := 'VALIDATE_OK';
EXCEPTION
   WHEN others THEN
      err_message_ := SQLERRM;
      Client_SYS.Clear_Attr(attr_);

      IF (header_error_) THEN
         Ext_Receiving_Advice_API.Set_To_Stopped__(message_id_, err_message_);
      ELSE
         Client_SYS.Add_To_Attr('ERROR_MESSAGE', err_message_, attr_);
         Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
         Line_Manual_Matching_Error__(info_, objid_, objversion_, attr_, 'DO');
      END IF;
END Validate_Before_Manual_Match__;


PROCEDURE Packed_Deliv_Unconfirm_Cos__ (
   message_id_   IN OUT VARCHAR2,
   message_line_ IN     VARCHAR2 ,
   message_      IN     CLOB )
IS
   count_                     NUMBER;
   index_                     NUMBER;
   name_arr_                  Message_SYS.name_table;
   value_arr_                 Message_SYS.line_table;
   transfer_rec_              deliv_unconfirm_cos_rec;
   msg_id_                    NUMBER;
   msg_line_                  NUMBER;
   deliv_unconfirm_cos_tab_   deliv_unconfirm_cos_table;     
BEGIN
   msg_id_   := Client_SYS.Attr_Value_To_Number(message_id_);
   msg_line_ := Client_SYS.Attr_Value_To_Number(message_line_);    
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);    
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'PACK_START') THEN        
         transfer_rec_.row_no := 1;
      ELSIF (name_arr_(n_) = 'DELIV_NO') THEN
         index_ := deliv_unconfirm_cos_tab_.COUNT;
         IF (index_ > 0) THEN
            transfer_rec_.row_no := deliv_unconfirm_cos_tab_(index_).row_no +1;
         END IF;
         transfer_rec_.deliv_no := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'ORDER_NO') THEN
         transfer_rec_.order_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LINE_NO') THEN
         transfer_rec_.line_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'REL_NO') THEN
         transfer_rec_.rel_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LINE_ITEM_NO') THEN
         transfer_rec_.line_item_no := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'QTY_CONFIRMED_ARRIVED') THEN
         transfer_rec_.qty_confirmed_arrived := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'QTY_TO_INVOICE') THEN
         transfer_rec_.qty_to_invoice := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         Fill_Deliv_Unconfirm_Cos___(deliv_unconfirm_cos_tab_, transfer_rec_);
      ELSIF (name_arr_(n_) = 'PACK_COMPLETE') THEN
         Match_Deliv_Unconfirm_Cos___(deliv_unconfirm_cos_tab_, msg_id_, msg_line_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;     
EXCEPTION
   WHEN OTHERS THEN      
      RAISE;
END Packed_Deliv_Unconfirm_Cos__;


-- Clear_Line_Error_Message__
--   Used to clear the error message during the matching process.
PROCEDURE Clear_Line_Error_Message__ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   oldrec_      EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   newrec_      EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   attr_        VARCHAR2(32000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   IF Get_Error_Message(message_id_, message_line_) IS NOT NULL THEN
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', '', attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
END Clear_Line_Error_Message__;


-- Check_Manual_Match__
--   Used to check the match check box in the manual matching dialog.
@UncheckedAccess
FUNCTION Check_Manual_Match__ (
   message_id_             IN NUMBER,
   message_line_           IN NUMBER,
   receipt_reference_      IN VARCHAR2,
   customer_po_no_         IN VARCHAR2,
   customer_po_line_no_    IN VARCHAR2,
   customer_po_release_no_ IN VARCHAR2,
   customer_ref_id_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   coc_rec_     Cust_Ord_Customer_API.Public_Rec;
   rec_         EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   customer_no_ EXT_RECEIVING_ADVICE_TAB.customer_no%TYPE;
   match_       VARCHAR2(5):='FALSE';
BEGIN
   rec_ := Get_Object_By_Keys___(message_id_, message_line_);

   IF rec_.rowstate = 'QtyDifference' THEN
      customer_no_ := Ext_Receiving_Advice_API.Get_Valid_Customer_No__(message_id_);
      coc_rec_     := Cust_Ord_Customer_API.Get(customer_no_);

      CASE coc_rec_.rec_adv_matching_option
         WHEN 'DELIVERY NOTE' THEN
            IF receipt_reference_ = rec_.receipt_reference THEN
               match_ := 'TRUE';
            END IF;
         WHEN 'CUSTOMERS PO REFERENCE' THEN
            IF (customer_po_no_ = rec_.customer_po_no AND
                customer_po_line_no_ = rec_.customer_po_line_no AND
                customer_po_release_no_ = rec_.customer_po_release_no) THEN
               match_ := 'TRUE';
            END IF;
         WHEN 'REFERENCE ID' THEN
            IF customer_ref_id_ = rec_.customer_ref_id THEN
               match_ := 'TRUE';
            END IF;
      END CASE;
   END IF;
   RETURN match_;
END Check_Manual_Match__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public New function which accepts a record of the LU to create a new record.
PROCEDURE New (
   rec_ IN EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE )
IS
   newrec_     EXT_RECEIVING_ADVICE_LINE_TAB%ROWTYPE;
   newattr_    VARCHAR2(32000);
   indrec_     INDICATOR_REC := Get_Indicator_rec___(rec_); 
   objid_      EXT_RECEIVING_ADVICE_LINE.objid%TYPE;
   objversion_ EXT_RECEIVING_ADVICE_LINE.objversion%TYPE;
BEGIN
   newrec_ := rec_;
   Check_Insert___(newrec_, indrec_, newattr_);
   Insert___(objid_, objversion_, newrec_, newattr_);
END New;


