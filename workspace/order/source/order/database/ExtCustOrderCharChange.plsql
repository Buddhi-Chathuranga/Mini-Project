-----------------------------------------------------------------------------
--
--  Logical unit: ExtCustOrderCharChange
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180518  ErFelk  Bug 140610, Added new method Transfer_Line_Change_Chars().
--  100519  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060119  MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  010528  JSAnse  Bug 21463, Added call to General_SYS.Init_Method in Procedure New.
--  001113  JakH    Changed configuration_id to varchar2(50)
--  000719  TFU     Merging from Chameleon
--  000620  BRO     Added public Has_Configuration method
--  000616  DEHA    Added public new method.
--  006009  DEHA    Created.
--  -------------------------- 12.1
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
   newrec_     EXT_CUST_ORDER_CHAR_CHANGE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   newattr_    VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   newattr_ := attr_;
   Unpack___ (newrec_, indrec_, newattr_);
   Check_Insert___(newrec_, indrec_, newattr_);
   Insert___(objid_, objversion_, newrec_, newattr_);
END New;


-- Has_Configuration
--   Return a boolean as a number indicating if a given order line has
--   a configuration. This function is placed in this class for implementation
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
    FROM   EXT_CUST_ORDER_CHAR_CHANGE_TAB
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

PROCEDURE Transfer_Line_Change_Chars (
   configuration_id_         IN OUT NOCOPY VARCHAR2,
   configured_line_price_id_ IN OUT NOCOPY NUMBER,
   message_id_               IN     NUMBER,
   order_no_                 IN     VARCHAR2,
   line_no_                  IN     VARCHAR2,
   rel_no_                   IN     VARCHAR2 )
IS
   dummy_             NUMBER;   
   line_change_exist_ BOOLEAN;
      
   CURSOR exist_change_lines IS
      SELECT 1
      FROM   EXT_CUST_ORDER_CHAR_CHANGE_TAB
      WHERE  message_id = message_id_
      AND    line_no    = line_no_
      AND    release_no = rel_no_;
BEGIN
      
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
      OPEN exist_change_lines;
      FETCH exist_change_lines INTO dummy_;
      line_change_exist_ := exist_change_lines%FOUND;
      CLOSE exist_change_lines;

      IF (line_change_exist_) THEN
         DECLARE
            config_spec_value_id_   NUMBER;
            part_no_                VARCHAR2(25);
            first_loop_             NUMBER;
            attr_                   VARCHAR2(2000);
            exist_configuration_id_ VARCHAR2(50);            
            lu_rec_                 EXT_CUST_ORDER_CHAR_CHANGE_TAB%ROWTYPE;
            effective_date_         DATE;
            spec_revision_no_       NUMBER;
            
            CURSOR transfer_change_chars IS
               SELECT message_line, base_item_no, configuration_id
               FROM   EXT_CUST_ORDER_CHAR_CHANGE_TAB
               WHERE  message_id = message_id_
               AND    line_no    = line_no_
               AND    release_no = rel_no_;
         BEGIN
            configuration_id_ := NULL;
            first_loop_       := 0;
            FOR next_ IN transfer_change_chars LOOP
               
               -- create config. spec./ id only for the first loop
               IF first_loop_ = 0 THEN
                  part_no_ := SUBSTR(next_.base_item_no, 1, 25);

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
               lu_rec_           := Get_Object_By_Keys___(message_id_, next_.message_line);
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
                           NULL,
                           NULL,
                           TRUE );
               -- create the pricing for this characteristic
               Client_SYS.Clear_Attr(attr_);
               Config_Char_Price_API.New(configured_line_price_id_, part_no_, configuration_id_,
                                         spec_revision_no_, lu_rec_.characteristic_id, config_spec_value_id_,
                                         attr_ );
            END LOOP;
            
            IF (configuration_id_ IS NOT NULL) THEN
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
      END IF;
   $ELSE
      NULL;
   $END
         
END Transfer_Line_Change_Chars;   

