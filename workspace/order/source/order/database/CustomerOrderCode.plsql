-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderCode
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120525  JeLise   Made description private.
--  120511  JeLise   Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120511           in Insert___, Update___, Delete___, Insert_Lu_Data_Rec__, Get_Description and in the views. 
--  100517  Ajpelk   Merge rose method documentation
------------------------------Eagle-------------------------------------------
--  060726  ThGulk Added Objid instead of rowid in Procedure Insert__
--  060112  NaWalk Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  050920  NaLrlk Removed unused variables.
--  040220  IsWilk Modified the SUBSTRB to SUBSTR for Unicode Changes.
-----------------  Edge Package Group 3 Unicode Changes-----------------------
--  030926  ThGu   Changed substr to substrb, instr to instrb, length to lengthb.
--  020124  StDa   IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  990414  PaLj   Yoshimua - New Template
--  980527  JOHW   Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  971120  RaKu   Changed to FND200 Templates.
--  970312  RaKu   Changed table name.
--  970219  RaKu   Changed rowversion (10.3 Project).
--  960403  JOED   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN CUSTOMER_ORDER_CODE_TAB%ROWTYPE)
IS
   dummy_      VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM CUSTOMER_ORDER_CODE_TAB
      WHERE order_code = newrec_.order_code;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO CUSTOMER_ORDER_CODE_TAB(
            order_code,
            description,
            rowversion)
         VALUES(
            newrec_.order_code,
            newrec_.description,
            newrec_.rowversion);
   ELSE
     UPDATE CUSTOMER_ORDER_CODE_TAB
        SET description = newrec_.description
      WHERE order_code = newrec_.order_code;
   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('ORDER',
                                                      'CustomerOrderCode',
                                                      newrec_.order_code,
                                                      newrec_.description);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   order_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   
   FUNCTION Base (
      order_code_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      temp_ customer_order_code_tab.description%TYPE;
   BEGIN
      IF (order_code_ IS NULL) THEN
         RETURN NULL;
      END IF;
      temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER', 'CustomerOrderCode',
         order_code_), 1, 35);
      IF (temp_ IS NOT NULL) THEN
         RETURN temp_;
      END IF;
      SELECT description
      INTO   temp_
      FROM   customer_order_code_tab
      WHERE  order_code = order_code_;
      RETURN temp_;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(order_code_, 'Get_Description');
   END Base;

BEGIN
   RETURN Base(order_code_);
END Get_Description;