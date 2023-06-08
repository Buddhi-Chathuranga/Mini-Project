-----------------------------------------------------------------------------
--
--  Logical unit: CustOrdPrintCharacter
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
--  091126  SuJalk Bug 87358, Merged Mosaic changes to APP75 Core track.
--  060112  IsWilk Modified the PROCEDURE Insert__ according to template 2.3.
--  051021  SaNalk Removed LOV property from cust_ord_print_config in VIEW.
--  050922  NaLrlk Removed unused variables.
--  040224  IsWilk Modified the SUBSTRB to SUBSTR for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes----------------------
--  030926  ThGu   Changed substr to substrb, instr to instrb, length to lengthb.
--  020124  StDa   IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  000823  JakH   Added column cust_ord_print_config.
--  ---------------------------------- 12.1.0 -------------------------------
--  990409  JakH   New template.
--  980527  JOHW   Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  971125  TOOS   Upgrade to F1 2.0
--  970312  NABE   Changed Table Names to correspond to View Name with a _TAB
--  970219  JOED   Changed objversion
--  960618  SVLO   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_        IN CUST_ORD_PRINT_CHARACTER_TAB%ROWTYPE)
IS
   dummy_      VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM CUST_ORD_PRINT_CHARACTER_TAB
      WHERE document_code = newrec_.document_code
        AND print_char_code = newrec_.print_char_code;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO CUST_ORD_PRINT_CHARACTER_TAB(
            document_code,
            print_char_code,
            description,
            cust_ord_print_config,
            print_media_items,
            rowversion)
         VALUES(
            newrec_.document_code,
            newrec_.print_char_code,
            newrec_.description,
            newrec_.cust_ord_print_config,
            newrec_.print_media_items,
            newrec_.rowversion);
   ELSE
      UPDATE CUST_ORD_PRINT_CHARACTER_TAB
         SET description = newrec_.description
       WHERE document_code = newrec_.document_code
         AND print_char_code = newrec_.print_char_code;

   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('ORDER',
                                                      'CustOrdPrintCharacter',
                                                      newrec_.document_code||'^'||newrec_.print_char_code,
                                                      newrec_.description);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Default
--   Pack in an attribute string defaults (could be several rows). Then
--   this string would be unpacked in Cust_Ord_Print_Ctrl_Char package
--   and written as a default while creating new print_control_code.
PROCEDURE Get_Default (
   attrib_ IN OUT VARCHAR2 )
IS
   attr_  VARCHAR2(2000);
   CURSOR get_min IS
      SELECT print_char_code, document_code, cust_ord_print_config, print_media_items
      FROM CUST_ORD_PRINT_CHARACTER_TAB pc1
      WHERE print_char_code || document_code IN (
      SELECT MIN(print_char_code || document_code)
      FROM CUST_ORD_PRINT_CHARACTER_TAB pc2
      WHERE pc1.document_code = pc2.document_code );
BEGIN
   Client_SYS.Clear_Attr(attr_);
   FOR rec_ IN get_min LOOP
      Client_SYS.Add_To_Attr('PRINT_CHAR_CODE', rec_.print_char_code, attr_);
      Client_SYS.Add_To_Attr('DOCUMENT_CODE', rec_.document_code, attr_);
      Client_SYS.Add_To_Attr('PRINT_MEDIA_ITEMS', rec_.print_media_items, attr_);
      Client_SYS.Add_To_Attr('CUST_ORD_PRINT_CONFIG', rec_.cust_ord_print_config, attr_);
   END LOOP;
   attrib_ := attr_;
END Get_Default;


@UncheckedAccess
FUNCTION Get_Description (
   document_code_   IN VARCHAR2,
   print_char_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUST_ORD_PRINT_CHARACTER_TAB.description%TYPE;
   CURSOR get_attr IS
      SELECT description
      FROM  CUST_ORD_PRINT_CHARACTER_TAB
      WHERE document_code = document_code_
      AND   print_char_code = print_char_code_;
BEGIN
   temp_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER',
                                                                         'CustOrdPrintCharacter',
                                                                         document_code_||'^'||print_char_code_), 1, 35);
   
   IF (temp_ IS NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Description;
