-----------------------------------------------------------------------------
--
--  Logical unit: SalesPriceListSendLog
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131028  MaMalk Increased the Customer_No length to VARCHAR2(20). 
--  111020  ChJalk Modified usage of view CUSTOMER_AGREEMENT to CUSTOMER_AGREEMENT_TAB in cursors.
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040226  IsWilk Modified the SUBSTRB to SUBSTR for Unicode Changes.
--  ---------------------------13.3.0-----------------------------------------
--  030926  ThGu   Changed substr to substrb, instr to instrb, length to lengthb.
--  000913  FBen  Added UNDEFINED.
--  000523  JoEd  Added view ORDER_PRICAT_SEND_LOG to use in PRICAT send log
--                overview form.
--  000105  JoEd  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Is_Price_List_Sent
--   Returns whether or not a price list has been sent to a specific
@UncheckedAccess
FUNCTION Is_Price_List_Sent (
   price_list_no_ IN VARCHAR2,
   customer_no_   IN VARCHAR2 ) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM SALES_PRICE_LIST_SEND_LOG_TAB
      WHERE price_list_no = price_list_no_
      AND   customer_no = customer_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF exist_control%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Is_Price_List_Sent;


-- New
--   Creates a new log record
PROCEDURE New (
   price_list_no_ IN VARCHAR2,
   customer_no_   IN VARCHAR2,
   message_id_    IN NUMBER,
   send_date_     IN DATE )
IS
   attr_        VARCHAR2(2000);   
   newrec_      SALES_PRICE_LIST_SEND_LOG_TAB%ROWTYPE;
   objid_       SALES_PRICE_LIST_SEND_LOG.objid%TYPE;
   objversion_  SALES_PRICE_LIST_SEND_LOG.objversion%TYPE;  
   indrec_      Indicator_Rec;   
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Set_Item_Value('PRICE_LIST_NO', price_list_no_, attr_);
   Client_SYS.Set_Item_Value('CUSTOMER_NO', customer_no_, attr_);
   Client_SYS.Set_Item_Value('MESSAGE_ID', message_id_, attr_);
   Client_SYS.Set_Item_Value('SEND_DATE', send_date_, attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;



