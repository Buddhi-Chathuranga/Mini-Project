-----------------------------------------------------------------------------
--
--  Logical unit: CustOrdPrintControl
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130812  MaIklk   TIBE-929, Removed inst_CustOrdPrintCtrlChar_ global variable and used conditional compilation instead.
--  120525  JeLise   Made description private.
--  120508  JeLise   Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120508           in Insert___, Update___, Delete___, Insert_Lu_Data_Rec__, Get_Description and in the views.
--  100429  Ajpelk   Merge rose method documentation
------------------------------Eagle------------------------------------------
--  060126  JaJalk Added Assert safe annotation.
--  050919  NaLrlk Removed unused variables.
--  050330  SaMelk Modified the Error_SYS message NOCUSTORDPRINTCTRLCHAR.
--  050316  SaMelk Put Dynamic calls to methods in CustOrdPrintCtrlChar LU.
--  050201  SaMelk Moved the file from ORDER Module to MPCCOM Module
--  040224  IsWilk Modified the SUBSTRB to SUBSTR for Unicode Changes.
--  ------------------------13.3.0-------------------------------------------
--  030926  ThGu  Changed substr to substrb, instr to instrb, length to lengthb.
--  020124  StDa  IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  990409  JakH  New template.
--  980527  JOHW  Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  971125  TOOS  Upgrade to F1 2.0
--  970312  NABE  Changed Table name from MPC_PRINT_CONTROL to
--                CUST_ORD_PRINT_CONTROL_TAB
--  970219  JOED  Changed objversion.
--  960219  JOED  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORD_PRINT_CONTROL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS  
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   
   $IF (Component_Order_SYS.INSTALLED) $THEN
      Cust_Ord_Print_Ctrl_Char_API.Copy_Printout_Char(newrec_.print_control_code); 
   $ELSE
      Error_SYS.Record_General('CustOrdPrintControl','NOCUSTORDPRINTCTRLCHAR: Customer order print characteristic is not installed.');
   $END
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN CUST_ORD_PRINT_CONTROL_TAB%ROWTYPE )
IS
   dummy_      VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM CUST_ORD_PRINT_CONTROL_TAB
      WHERE print_control_code = newrec_.print_control_code;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO CUST_ORD_PRINT_CONTROL_TAB(
            print_control_code,
            description,
            rowversion)
         VALUES(
            newrec_.print_control_code,
            newrec_.description,
            newrec_.rowversion);
   ELSE
      UPDATE CUST_ORD_PRINT_CONTROL_TAB
         SET description = newrec_.description
       WHERE print_control_code = newrec_.print_control_code;
   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('MPCCOM',
                                                      'CustOrdPrintControl',
                                                      newrec_.print_control_code,
                                                      newrec_.description);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   print_control_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ cust_ord_print_control_tab.description%TYPE;
BEGIN
   IF (print_control_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      print_control_code_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  cust_ord_print_control_tab
      WHERE print_control_code = print_control_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(print_control_code_, 'Get_Description');
END Get_Description;



