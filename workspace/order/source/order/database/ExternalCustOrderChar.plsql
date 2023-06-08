-----------------------------------------------------------------------------
--
--  Logical unit: ExternalCustOrderChar
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210329  ThKrlk  Bug 158501(SCZ-14129), Modified Transfer_Line_Chars() to handle non inventory sales part.
--  210306  ChBnlk  Bug 157923(SCZ-13949), Modified Transfer_Line_Chars() to ensure that the part number referred is correct by fetching
--  210306          it from the corresponding customer order line to avoid problems when the order originates from an external message.
--  160725  ChBnlk  Bug 129894, Modified Transfer_Line_Chars() by passing values to the parameter package_content 
--  160725          instead of passing FALSE.
--  140226  ChBnlk  Bug 113704, Modified Transfer_Line_Chars() by removing parameters configuration_id_ and attr_ from method call 
--  140226          Configured_Line_Price_API.Copy_Pricing__().
--  130705  UdGnlk  TIBE-994, Removed global variable and modify to conditional compilation. 
--  120621  Chahlk  MOSXP-740, Added new parameter to the Config_Spec_Value_API.New()
--  120308  SudJlk  Bug 101400, Modified Transfer_Line_Chars to call Config_Spec_Value_API.New with value TRUE for validate_value
--  120308          so that the relevant validations will take place before inserting the config spec values.
--  100519  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060125  JaJalk  Added Assert safe annotation.
--  060119  MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  040212  JICE    Bug 39570, client values changed to db values in call to
--                  Config_Spec_Value_API.New.
--  040129  GeKalk  Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  020510  CaStse  Bug fix 28385, Modified Transfer_Line_Chars.
--  020404  CaStse  Bug fix 28385, Removed all corrections for bug fix 28385.
--  020318  CaStse  Bug fix 28385, Added check if order is sent via EDI or not to Transfer_Line_Chars.
--  010528  JSAnse  Bug fix 21463, Added call to General_SYS.Init_Method in procedures new and Get_Object_By_Keys.
--  010413  JaBa    Bug Fix 20598,Added new global lu constant inst_ConfigSpecValue_.
--  001205  JoAn    CID 56719 Corrected dynamic SQL in Transfer_Line_Chars
--  001113  JakH    Changed Configuration_Id to varchar2(50)
--  001113  JakH    Blocked configuration creation for non-configured-parts.
--  001006  JakH    Removed use of config_spec_usage and modified use of
--                  config_char_price, adding the price line by line.
--  000719  TFU     Merging from Chameleon
--  000707  DEHA    Extended Transfer_Line_Chars (interface, ....)
--                  to create config char price lines, added public method
--                  Get_Object_By_Keys.
--  000620  DEHA    Added pubic method Transfer_Line_Chars.
--  000619  BRO     Added public Has_Configuration method
--  000616  DEHA    Added public new method.
--  006009  DEHA    Created.
--  --------------------------- 12.1
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public new method.
PROCEDURE New (
   attr_ IN VARCHAR2 )
IS
   newrec_     EXTERNAL_CUST_ORDER_CHAR_TAB%ROWTYPE;
   newattr_    VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   newattr_ := attr_;
   Unpack___(newrec_, indrec_, newattr_);
   Check_Insert___(newrec_, indrec_, newattr_);
   Insert___(objid_, objversion_, newrec_, newattr_);
END New;


-- Has_Configuration
--   Return a boolean as a number indicating if a given order line has a
--   configuration. This function is placed in this class for implementation
--   purposes (the best would have been to place it in the ExternalCustOrderLine
--   class, but dynamic calls in a function used in a view are not possible)
@UncheckedAccess
FUNCTION Has_Configuration (
   message_id_ IN NUMBER,
   line_no_    IN VARCHAR2,
   rel_no_     IN VARCHAR2 ) RETURN NUMBER
IS
   return_  NUMBER;

   CURSOR check_config IS
      SELECT 1
      FROM   EXTERNAL_CUST_ORDER_CHAR_TAB
      WHERE  message_id = message_id_
      AND    line_no = line_no_
      AND    release_no = rel_no_;
BEGIN
   OPEN check_config;
   FETCH check_config INTO return_;
   IF check_config%NOTFOUND THEN
      return_ := 0;
   END IF;
   CLOSE check_config;

   RETURN return_;
END Has_Configuration;


-- Get_Object_By_Keys
--   Public interface to the corresponding implementation method.
FUNCTION Get_Object_By_Keys (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER ) RETURN EXTERNAL_CUST_ORDER_CHAR_TAB%ROWTYPE
IS
BEGIN
   RETURN Get_Object_By_Keys___ (message_id_, message_line_);
END Get_Object_By_Keys;


-- Transfer_Line_Chars
--   Transfers all external order line characteristics/ configurations for
--   this line to the customer order (line).
PROCEDURE Transfer_Line_Chars (
   configuration_id_         IN OUT VARCHAR2,
   configured_line_price_id_ IN OUT NUMBER,
   message_id_               IN     NUMBER,
   order_no_                 IN     VARCHAR2,
   line_no_                  IN     VARCHAR2,
   rel_no_                   IN     VARCHAR2 )
IS
   CURSOR exist_control IS
      SELECT 1
      FROM   EXTERNAL_CUST_ORDER_CHAR_TAB
      WHERE  message_id = message_id_
      AND    line_no    = line_no_
      AND    release_no = rel_no_;
   
   dummy_      NUMBER;
   line_exist_ BOOLEAN;
-- line_item_no on incoming site is always zero since we only purchase components an not packages.
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   line_exist_ := exist_control%FOUND;
   CLOSE exist_control;

   IF line_exist_ THEN
      $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
          DECLARE
             config_spec_value_id_   NUMBER;
             part_no_                VARCHAR2(200);
             first_loop_             NUMBER;
             attr_                   VARCHAR2(2000);
             exist_configuration_id_ VARCHAR2(50);
             lu_rec_                 EXTERNAL_CUST_ORDER_CHAR_TAB%ROWTYPE;
             effective_date_         DATE;
             spec_revision_no_       NUMBER;
             CURSOR transfer_chars IS
                SELECT message_line, base_item_no, configuration_id
                FROM   EXTERNAL_CUST_ORDER_CHAR_TAB
                WHERE  message_id = message_id_
                AND    line_no    = line_no_
                AND    release_no = rel_no_;
          BEGIN
            configuration_id_ := NULL;
            
            -- Fetch the part no from the newly created customer order line that the char row belongs to This is to avoid problems if sales part and inventory part does not have the same id.
            -- The value of the base_item_no attribute on the external_cust_order_char record is not used.
            part_no_ := NVL(Customer_Order_Line_API.Get_Part_No(order_no_, line_no_, rel_no_, 0),
                            Customer_Order_Line_API.Get_Catalog_No(order_no_, line_no_, rel_no_, 0));
            
            first_loop_ := 0;
            FOR next_ IN transfer_chars LOOP
               -- create config. spec./ id only for the first loop
               IF first_loop_ = 0 THEN                 
                  -- Fetch the date based on used config spec revision
                  effective_date_ := TRUNC(Config_Part_Spec_Rev_API.Get_Phase_In_Date(part_no_,
                                           Configuration_Spec_API.Get_Spec_Revision_No(part_no_, next_.configuration_id)));
                  
                  --If no configuration_id is sent in, the message comes via EDI and SYSDATE should be used.
                  IF (effective_date_ IS NULL) THEN
                     effective_date_ := SYSDATE;
                  END IF;
                  Configuration_Spec_API.Create_Configuration_Spec(configuration_id_, part_no_, effective_date_);
                  first_loop_ := 1;
               END IF;

               -- create config spec. values for the given config. id
               lu_rec_           := External_Cust_Order_Char_API.Get_Object_By_Keys(message_id_, next_.message_line);
               spec_revision_no_ := Configuration_Spec_API.Get_Spec_Revision_No(part_no_, configuration_id_);                
               Config_Spec_Value_API.New(
                           config_spec_value_id_, configuration_id_,
                           SUBSTR(lu_rec_.characteristic_id, 1, 24),
                           part_no_,
                           spec_revision_no_,
                           lu_rec_.characteristic_value,
                           lu_rec_.characteristic_data_type,
                           lu_rec_.characteristic_value_type,
                           lu_rec_.qty_of_option,
	                        lu_rec_.package_content,
                           NULL,
                           TRUE );
               -- create the pricing for this characteristic
               Client_SYS.Clear_Attr(attr_);
               Config_Char_Price_API.New(configured_line_price_id_, part_no_, configuration_id_,
                                         spec_revision_no_, lu_rec_.characteristic_id, config_spec_value_id_,
                                         attr_ );
            END LOOP;
            IF configuration_id_ IS NOT NULL THEN
               -- check if config. id already exists (if use the existing)
               Client_SYS.Clear_Attr(attr_);
               Configuration_Spec_API.Complete(exist_configuration_id_,part_no_,configuration_id_);
               IF exist_configuration_id_ IS NOT NULL THEN
                  IF exist_configuration_id_ != configuration_id_ THEN
                     Configured_Line_Price_API.Copy_Pricing__(configured_line_price_id_,
                                                              exist_configuration_id_);
                     Configured_Line_Price_API.Remove_Pricing(configured_line_price_id_, configuration_id_);
                     configuration_id_ := exist_configuration_id_;
                  END IF;
               END IF;
            END IF;
         END;
      $ELSE
         NULL;
      $END 
   END IF; 
END Transfer_Line_Chars;



