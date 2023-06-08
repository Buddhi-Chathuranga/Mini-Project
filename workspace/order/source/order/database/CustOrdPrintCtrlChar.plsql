-----------------------------------------------------------------------------
--
--  Logical unit: CustOrdPrintCtrlChar
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131107  MaMalk Modified cust_ord_print_config_db and PRINT_MEDIA_ITEMS declaration types in view comments.
--  120127  ChJalk Modified the view comments of the column CUST_ORD_PRINT_CONFIG in the base view.
--  091126  SuJalk Bug 87358, Merged Mosaic changes to core.
--  060112  IsWilk Modified the PROCEDURE Insert__ according to template 2.3.
--  040224  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
--  -------------------------------- 13.3.0 ----------------------------------
--  001719  TFU   Merging from Chameleon
--  000627  ThIs  Added field cust_ord_print_config
--  --------------------------------- 12.10 ---------------------------------
--  990409  JakH  New template.
--  971125  RaKu  Changed to FND200 Templates.
--  970312  NABE  Changed Table Name MPC_PRINT_CHAR_CONTROL to
--                CUST_ORD_PRINT_CTRL_CHAR_TAB
--  970219  JOED  Changed objversion.
--  960618  SVLO  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CUST_ORD_PRINT_CONFIG', Cust_Ord_Print_Config_API.Decode('DONOTPRINT'), attr_);
END Prepare_Insert___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy_Printout_Char
--   Copies PRINT_CHAR_CODE and DOCUMENT_CODE as a default when creating
--   new print_control_code (called from Cust_Ord_Print_Control_API package).
PROCEDURE Copy_Printout_Char (
   print_control_code_ IN VARCHAR2 )
IS
   newrec_      CUST_ORD_PRINT_CTRL_CHAR_TAB%ROWTYPE;
   attr_        VARCHAR2(2000);
   attr2_       VARCHAR2(2000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   ptr_         NUMBER := NULL;
   name_        VARCHAR2(30);
   value_       VARCHAR2(2000);
   make_insert_ BOOLEAN := FALSE;
BEGIN
   newrec_.print_control_code := print_control_code_;
   Cust_Ord_Print_Control_API.Exist(print_control_code_);
   Cust_Ord_Print_Character_API.Get_Default(attr_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'PRINT_CHAR_CODE') THEN
         newrec_.print_char_code := value_;
      ELSIF (name_ = 'DOCUMENT_CODE') THEN
         newrec_.document_code := value_;
      ELSIF (name_ = 'CUST_ORD_PRINT_CONFIG') THEN
         newrec_.cust_ord_print_config := value_;
         make_insert_ := TRUE;
      ELSIF (name_ = 'PRINT_MEDIA_ITEMS') THEN
         newrec_.print_media_items := value_;
      END IF;
      IF make_insert_ THEN
         Cust_Ord_Print_Character_API.Exist(newrec_.document_code, newrec_.print_char_code);
         Insert___(objid_, objversion_, newrec_, attr2_);
         make_insert_ := FALSE;
      END IF;
   END LOOP;
END Copy_Printout_Char;


-- Get_Print_Char_Code
--   Get print char code for a print control code.
@UncheckedAccess
FUNCTION Get_Print_Char_Code (
   print_control_code_ IN VARCHAR2,
   document_code_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   print_char_code_  CUST_ORD_PRINT_CTRL_CHAR_TAB.print_char_code%TYPE;
   CURSOR get_char_code IS
      SELECT print_char_code
      FROM CUST_ORD_PRINT_CTRL_CHAR_TAB
      WHERE print_control_code = print_control_code_
      AND   document_code = document_code_;
BEGIN
   OPEN get_char_code;
   FETCH get_char_code INTO print_char_code_;
   IF get_char_code%NOTFOUND THEN
      print_char_code_ := NULL;
   END IF;
   CLOSE get_char_code;
   RETURN print_char_code_;
END Get_Print_Char_Code;



