-----------------------------------------------------------------------------
--
--  Logical unit: CustOrderEvent
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120525  JeLise   Made description private.
--  120511  JeLise   Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120511           in Insert___, Update___, Delete___, Insert_Lu_Data_Rec__, Get_Description and in the view. 
--  100519  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  050921  NaLrlk Removed unused variables.
--  040224  IsWilk Modified the SUBSTRB to SUBSTR from the view for Unicode Changes.
----------------------------------------13.3.0--------------------------------
--  030926  ThGu   Changed substr to substrb, instr to instrb, length to lengthb.
--  020124  StDa   IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  990407  JakH   New template.
--  980527  JOHW   Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  971124  RaKu   Changed to FND200 Templates.
--  970618  RaKu   Changed shortname from event.apy to ordev.apy.
--  970312  RaKu   Changed tablename.
--  970219  PAZE   Changed rowversion (10.3 project).
--  960213  JOED   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_        IN CUST_ORDER_EVENT_TAB%ROWTYPE)
IS
   dummy_      VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM CUST_ORDER_EVENT_TAB
      WHERE event = newrec_.event;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO CUST_ORDER_EVENT_TAB(
            event,
            output_code,
            description,
            rowversion)
         VALUES(
            newrec_.event,
            newrec_.output_code,
            newrec_.description,
            newrec_.rowversion);
   ELSE
      UPDATE CUST_ORDER_EVENT_TAB
         SET description = newrec_.description
       WHERE event = newrec_.event;
   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('ORDER',
                                                      'CustOrderEvent',
                                                      newrec_.event,
                                                      newrec_.description);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   event_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ cust_order_event_tab.description%TYPE;
BEGIN
   IF (event_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      event_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   cust_order_event_tab
   WHERE  event = event_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(event_, 'Get_Description');
END Get_Description;


