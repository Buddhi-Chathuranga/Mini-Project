-----------------------------------------------------------------------------
--
--  Logical unit: AddressPresentation
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-- 000224   Mnisse  Created
-- 000302   Mnisse  It should always be only one default value.
-- 000804   Camk    Bug #15677 Corrected. General_SYS.Init_Method added
-- 001023   Camk    County added
-- 020104   ROOD    IID 10094: Replaced the "array-representation" with a one
--                  string layout representation. Added edit layout. Rewrote
--                  old methods to maintain backward compatibility.
-- 020107   ROOD    IID 10094: Removed unnecessary default handling in method Get.
--                  Added validation/update to always have one default country.
-- 020109   ROOD    IID 10094: Replaced default_country with default_display_layout
--                  and default_edit_layout.
-- 020110   ROOD    IID 10094: Modifed order between fields in Format_Address.
-- 020208   THSRLK  IID 10990. Add New Procedure Get_All_Layouts
-- 020212   RaKu    Call 76481. Added proc Check_Defaults__ and moved
--                  the call from Insert___/Modify___ to New/Modify.
-- 020227   ROOD    IID 10094: Modified implementation in Format_Address to cover the
--                  case when no layouts at all exists in the table.
-- 040624   Jeguse  Bug 45629, Added function Format_To_Line and modified function Format_Address
-- 041011   Thsrlk  LCS Merge (46159)
-- 050425   Hecolk  LCS Merge - 49941, Removed 'General_SYS.Init_Method' in Get_All_Layouts because pragma is set.
-- 060502   Sacalk  Bug 56972, Update party type address when the address presentation is changed
-- 060531   SHDILK  Bug ID 56549, Modified Layout_To_Array___
-- 061010   DiAmlk  LCS Merge 59885.Added a new parameter to Format_Address.
-- 070627   Kagalk  LCS Merge 65835, Rolled back 59885.
-- 070627   Kagalk  LCS Merge 65828, Fixed to handle blank lines in the address presentation.
-- 110809   Umdolk  FIDEAGLE-352, Merged Bug 94883, Modified Format_Address()
-- 110810   Shhelk  FIDEAGLE-351, Merged bug 96490, Modified Format_Address()
-- 130219   Chgulk  Bug 107726, Modified in Format_To_Line().
-- 131011   Isuklk  CAHOOK-2672 Refactoring in AddressPresentation.entity
-- 140328   Dihelk  PBFI-4378,Added Get_Validate_Address() method
-- 141215   Chhulk  PRFI-4045, Merged bug 120147.
-- 151222   Chiblk  STRFI-890, Rewrite sub methods to implmentation methods
-- 160427   Chgulk  STRLOC-56, changed the code to support additional address fields.
-- 160624   Dihelk  STRLOC-394, Added the new method Get_Address_Fields_Extended to facilitate new address.
-- 200826   Hecolk  FISPRING20-146, Changes related to Aurena implementation of Address Presentation.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Public_Rec_Address IS RECORD
   (address1_row    NUMBER,
    address1_order  NUMBER,
    address2_row    NUMBER,
    address2_order  NUMBER,
    address3_row    NUMBER,
    address3_order  NUMBER,
    address4_row    NUMBER,
    address4_order  NUMBER,
    address5_row    NUMBER,
    address5_order  NUMBER,
    address6_row    NUMBER,
    address6_order  NUMBER,
    zip_code_row    NUMBER,
    zip_code_order  NUMBER,
    city_row        NUMBER,
    city_order      NUMBER,
    state_row       NUMBER,
    state_order     NUMBER,
    default_country VARCHAR2(5),
    county_row      NUMBER,
    county_order    NUMBER);

TYPE Address_Rec_Type IS RECORD
   (address1       VARCHAR2(1025),
    address2       VARCHAR2(1025),
    address3       VARCHAR2(1025),
    address4       VARCHAR2(1025),
    address5       VARCHAR2(1025),
    address6       VARCHAR2(1025),
    address7       VARCHAR2(1025),
    address8       VARCHAR2(1025),
    address9       VARCHAR2(1025),
    address10      VARCHAR2(1025));

lfcr_                   CONSTANT VARCHAR2(2)    := CHR(13)||CHR(10);
ampersand_              CONSTANT VARCHAR2(1)    := CHR(38);
default_display_layout_ CONSTANT VARCHAR2(1000) := ampersand_ || 'ADDRESS1' || lfcr_ || ampersand_ || 'ADDRESS2' || lfcr_ || 
                                                   ampersand_ || 'ZIP_CODE - ' || ampersand_ || 'CITY' || lfcr_ || 
                                                   ampersand_ || 'STATE' || lfcr_ || ampersand_ || 'COUNTY' || lfcr_ || 
                                                   ampersand_ || 'COUNTRY_CODE - ' || ampersand_ || 'COUNTRY';

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Parse_Row___ (
   array_  IN OUT Public_Rec_Address,
   row_no_ IN     NUMBER,
   row_    IN     VARCHAR2 )
IS
   address1_  VARCHAR2(10) := ampersand_ || 'ADDRESS1%';
   address2_  VARCHAR2(10) := ampersand_ || 'ADDRESS2%';
   address3_  VARCHAR2(10) := ampersand_ || 'ADDRESS3%';
   address4_  VARCHAR2(10) := ampersand_ || 'ADDRESS4%';
   address5_  VARCHAR2(10) := ampersand_ || 'ADDRESS5%';
   address6_  VARCHAR2(10) := ampersand_ || 'ADDRESS6%';
   zip_code_  VARCHAR2(10) := ampersand_ || 'ZIP_CODE%';
   city_      VARCHAR2(6)  := ampersand_ || 'CITY%';
   county_    VARCHAR2(8)  := ampersand_ || 'COUNTY%';
   state_     VARCHAR2(7)  := ampersand_ || 'STATE%';
   len_       NUMBER       := LENGTH(row_);
   pos_       NUMBER       := INSTR(row_, ampersand_);
   next_      NUMBER;
   order_     NUMBER       := 1;
   part_      VARCHAR2(1000);
BEGIN
   WHILE pos_ < len_ LOOP
      -- Search next occurance of ampersand
      next_ := INSTR(row_, ampersand_, pos_ + 1);
      IF (next_ = 0) THEN
         -- No more occurances
         next_ := len_;
         -- Extract the last part
         part_ := SUBSTR(row_, pos_);
      ELSE
         -- Extract the part
         part_ := SUBSTR(row_, pos_, next_ - pos_);
      END IF;
      -- Move position to next occurance
      pos_ := next_;
      -- Compare the parts and write to array
      -- address1
      IF (part_ LIKE address1_) THEN
         array_.address1_row   := row_no_;
         array_.address1_order := order_;
      -- address2
      ELSIF (part_ LIKE address2_) THEN
         array_.address2_row   := row_no_;
         array_.address2_order := order_;
      -- address3
      ELSIF (part_ LIKE address3_) THEN
         array_.address3_row   := row_no_;
         array_.address3_order := order_;
      -- address4
      ELSIF (part_ LIKE address4_) THEN
         array_.address4_row   := row_no_;
         array_.address4_order := order_;
      -- address5
      ELSIF (part_ LIKE address5_) THEN
         array_.address5_row   := row_no_;
         array_.address5_order := order_;
      -- address6
      ELSIF (part_ LIKE address6_) THEN
         array_.address6_row   := row_no_;
         array_.address6_order := order_;   
      -- zip_code
      ELSIF (part_ LIKE zip_code_) THEN
         array_.zip_code_row   := row_no_;
         array_.zip_code_order := order_;
      -- city
      ELSIF (part_ LIKE city_) THEN
         array_.city_row   := row_no_;
         array_.city_order := order_;
      -- county
      ELSIF (part_ LIKE county_) THEN
         array_.county_row   := row_no_;
         array_.county_order := order_;
      -- state
      ELSIF (part_ LIKE state_) THEN
         array_.state_row   := row_no_;
         array_.state_order := order_;
      END IF;
      order_ := order_ + 1;
   END LOOP;
END Parse_Row___;   


-- Layout_To_Array___
--   Converts from current one string layout representation
--   to previous array representation
FUNCTION Layout_To_Array___ (
   layout_ IN VARCHAR2 ) RETURN Public_Rec_Address
IS
   old_rec_         Public_Rec_Address;
   carriage_return_ VARCHAR2(2) := CHR(13)||CHR(10);
   layout_row_      VARCHAR2(2000);
   layout_len_      NUMBER      := LENGTH(layout_);
   layout_pos_      NUMBER      := 0;
   layout_next_     NUMBER;
   layout_row_no_   NUMBER      := 1;   
BEGIN
   WHILE layout_pos_ < layout_len_ LOOP
      -- Search next occurance of carriage return
      layout_next_ := INSTR(layout_, carriage_return_, layout_pos_ + 1);
      IF (layout_next_ = 0) THEN
         -- No more occurances
         layout_next_ := layout_len_;
         -- Extract the last template row
         layout_row_ := SUBSTR(layout_, layout_pos_ + 1);
      ELSE
         -- Extract the template row without the carriage return
         layout_row_ := SUBSTR(layout_, layout_pos_ + 1, layout_next_ - layout_pos_);
      END IF;
      -- Move position to next occurance
      layout_pos_ := layout_next_;
      -- Parse the extracted row
      Parse_Row___(old_rec_, layout_row_no_, layout_row_);
      layout_row_no_ := layout_row_no_ + 1;
   END LOOP;
   RETURN old_rec_;
END Layout_To_Array___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     address_presentation_tab%ROWTYPE,
   newrec_ IN OUT address_presentation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);   
   --Note - IF the maximum no of Rows in address is 6. Therefore maximum no of separaters that can have is 5.
   --       Here we try to check wether separator exists in the sixth occurance of the address layout.
   --       IF it exists for the sith time that means there are more than 6 address rows.
   IF (INSTR(newrec_.display_layout,lfcr_,1,newrec_.user_defined_row_count) != 0) THEN
      Error_SYS.Appl_General(lu_name_, 'MAXLINES: Number of rows in Display Layout should be less than or equal to user defined row count.');
   END IF;
   IF (indrec_.user_defined_row_count) AND (newrec_.user_defined_row_count > newrec_.max_row_count) THEN
      Error_SYS.Appl_General(lu_name_, 'ERRORMAXROWCOUNT: Maximum number of rows allowed for user defined row count should be less than or equal to :P1.', newrec_.max_row_count);
   ELSIF (indrec_.user_defined_row_count) AND (newrec_.user_defined_row_count > 6) THEN
      Client_SYS.Add_Warning(lu_name_, 'WARNMAXROWCOUNT: In the standard IFS layouts a maximum of 6 address rows are visible. If you want to use more than 6 address rows it is recommended to adjust the existing layouts.');
   END IF;   
END Check_Common___;

 
@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DISPLAY_LAYOUT', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('DEFAULT_EDIT_LAYOUT', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('MAX_ROW_COUNT', 10, attr_);
   Client_SYS.Add_To_Attr('DISPLAY_LAYOUT', default_display_layout_, attr_);
   Client_SYS.Add_To_Attr('EDIT_LAYOUT', Init_Edit_Layout_String___, attr_);
END Prepare_Insert___;


FUNCTION Init_Edit_Layout_String___ RETURN VARCHAR2
IS
   edit_layout_   VARCHAR2(2000);
BEGIN
   edit_layout_ := Message_SYS.Construct('');
   Message_SYS.Add_Attribute(edit_layout_, 'R1', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'R2', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'R3', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'R4', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'R5', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'R6', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'R8', 0);
   Message_SYS.Add_Attribute(edit_layout_, 'R9', 0);
   Message_SYS.Add_Attribute(edit_layout_, 'R10', 0);
   Message_SYS.Add_Attribute(edit_layout_, 'R11', 0);
   Message_SYS.Add_Attribute(edit_layout_, 'C1', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'C2', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'C3', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'C4', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'C5', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'C6', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'C8', 0);
   Message_SYS.Add_Attribute(edit_layout_, 'C9', 0);
   Message_SYS.Add_Attribute(edit_layout_, 'C10', 0);
   Message_SYS.Add_Attribute(edit_layout_, 'C11', 0);
   Message_SYS.Add_Attribute(edit_layout_, 'W1', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'W2', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'W3', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'W4', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'W5', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'W6', 1);
   Message_SYS.Add_Attribute(edit_layout_, 'W8', 0);
   Message_SYS.Add_Attribute(edit_layout_, 'W9', 0);
   Message_SYS.Add_Attribute(edit_layout_, 'W10', 0);
   Message_SYS.Add_Attribute(edit_layout_, 'W11', 0);
   RETURN edit_layout_;
END Init_Edit_Layout_String___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT address_presentation_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   desc_   VARCHAR2(2000);
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   desc_ := Language_SYS.Translate_Constant(lu_name_, 'SYNCADDR: Synchronizing address presentation.');
   Transaction_SYS.Deferred_Call('Address_Presentation_API.Sync_Address', newrec_.country_code, desc_);   
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     address_presentation_tab%ROWTYPE,
   newrec_     IN OUT address_presentation_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   desc_   VARCHAR2(2000);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (oldrec_.display_layout != newrec_.display_layout) THEN
      desc_ := Language_SYS.Translate_Constant(lu_name_, 'SYNCADDR: Synchronizing address presentation.');
      Transaction_SYS.Deferred_Call('Address_Presentation_API.Sync_Address', newrec_.country_code, desc_);              
   END IF;
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT address_presentation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (Client_SYS.Item_Exist('COUNTRY', attr_)) THEN
      Error_SYS.Item_Insert(lu_name_, 'COUNTRY');
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     address_presentation_tab%ROWTYPE,
   newrec_ IN OUT address_presentation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (Client_SYS.Item_Exist('COUNTRY', attr_)) THEN
      Error_SYS.Item_Update(lu_name_, 'COUNTRY');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
 
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Check_Defaults_
IS
   count_ NUMBER;
   CURSOR rec_exist IS
      SELECT 1
      FROM   address_presentation_tab;
   CURSOR find_default_display IS
      SELECT COUNT(*)
      FROM   address_presentation_tab
      WHERE default_display_layout = 'TRUE';
   CURSOR find_default_edit IS
      SELECT COUNT(*)
      FROM   address_presentation_tab
      WHERE  default_edit_layout = 'TRUE';
BEGIN
   OPEN  rec_exist;
   FETCH rec_exist INTO count_;
   IF (rec_exist%FOUND) THEN
      CLOSE rec_exist;
      OPEN  find_default_display;
      FETCH find_default_display INTO count_;
      CLOSE find_default_display;
      IF (count_ = 0) THEN
          Error_SYS.Appl_General(lu_name_, 'NODEFDISPLAY: A "Display Layout" must be set as default.');
      ELSIF count_ > 1 THEN
          Error_SYS.Appl_General(lu_name_, 'TOOMANYDEFDISPLAY: Only one "Display Layout" can be set as default.');
      END IF;
      OPEN  find_default_edit;
      FETCH find_default_edit INTO count_;
      CLOSE find_default_edit;
      IF (count_ = 0) THEN
          Error_SYS.Appl_General(lu_name_, 'NODEFEDITLAY: A "Edit Layout" must be set as default.');
      ELSIF count_ > 1 THEN
          Error_SYS.Appl_General(lu_name_, 'TOOMANYDEFEDITLAY: Only one "Edit Layout" can be set as default.');
      END IF;
   ELSE
      CLOSE rec_exist;
   END IF;
END Check_Defaults_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Address_Fields (
   address1_        IN VARCHAR2,
   address2_        IN VARCHAR2,
   address3_        IN VARCHAR2,
   address4_        IN VARCHAR2,
   address5_        IN VARCHAR2,
   address6_        IN VARCHAR2,
   address7_        IN VARCHAR2 DEFAULT NULL,
   address8_        IN VARCHAR2 DEFAULT NULL,
   address9_        IN VARCHAR2 DEFAULT NULL,
   address10_       IN VARCHAR2 DEFAULT NULL,
   field_separator_ IN VARCHAR2 DEFAULT ' ' ) RETURN VARCHAR2
IS
   address_         VARCHAR2(2000);
BEGIN
   IF (address1_ IS NOT NULL) THEN
      address_ := address1_;
   END IF;
   IF (address2_ IS NOT NULL) THEN
      IF (address_ IS NULL) THEN
          address_ := address2_;
      ELSE
         address_ := address_||field_separator_||address2_;
      END IF;
   END IF;
   IF (address3_ IS NOT NULL) THEN
      IF (address_ IS NULL) THEN
          address_ := address3_;
      ELSE
         address_ := address_||field_separator_||address3_;
      END IF;
   END IF;
   IF (address4_ IS NOT NULL) THEN
      IF (address_ IS NULL) THEN
          address_ := address4_;
      ELSE
         address_ := address_||field_separator_||address4_;
      END IF;
   END IF;
   IF (address5_ IS NOT NULL) THEN
      IF (address_ IS NULL) THEN
          address_ := address5_;
      ELSE
         address_ := address_||field_separator_||address5_;
      END IF;
   END IF;
   IF (address6_ IS NOT NULL) THEN
      IF (address_ IS NULL) THEN
          address_ := address6_;
      ELSE
         address_ := address_||field_separator_||address6_;
      END IF;
   END IF;
   IF (address7_ IS NOT NULL) THEN
      IF (address_ IS NULL) THEN
          address_ := address7_;
      ELSE
         address_ := address_||field_separator_||address7_;
      END IF;
   END IF;
   IF (address8_ IS NOT NULL) THEN
      IF (address_ IS NULL) THEN
          address_ := address8_;
      ELSE
         address_ := address_||field_separator_||address8_;
      END IF;
   END IF;
   IF (address9_ IS NOT NULL) THEN
      IF (address_ IS NULL) THEN
          address_ := address9_;
      ELSE
         address_ := address_||field_separator_||address9_;
      END IF;
   END IF;
   IF (address10_ IS NOT NULL) THEN
      IF (address_ IS NULL) THEN
          address_ := address10_;
      ELSE
         address_ := address_||field_separator_||address10_;
      END IF;
   END IF;
   RETURN address_; 
END Get_Address_Fields;


@UncheckedAccess
FUNCTION Format_Address (
   country_code_     IN VARCHAR2,
   address1_         IN VARCHAR2 DEFAULT NULL,
   address2_         IN VARCHAR2 DEFAULT NULL,
   address3_         IN VARCHAR2 DEFAULT NULL,
   address4_         IN VARCHAR2 DEFAULT NULL,
   address5_         IN VARCHAR2 DEFAULT NULL,
   address6_         IN VARCHAR2 DEFAULT NULL,
   city_             IN VARCHAR2 DEFAULT NULL,
   county_           IN VARCHAR2 DEFAULT NULL,
   state_            IN VARCHAR2 DEFAULT NULL,
   zip_code_         IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   order_language_   IN VARCHAR2 DEFAULT NULL,
   keep_blank_field_ IN BOOLEAN  DEFAULT FALSE ) RETURN VARCHAR2
IS
   address_         VARCHAR2(2000) := Get_Display_Layout(country_code_);
   blank_field_     CONSTANT VARCHAR2(13):= '<BLANK_FIELD>';
BEGIN
   IF (address_ IS NULL) THEN
      -- No records in table at all, default to "native" display layout to avoid losing the address information
      address_ := ampersand_ || 'ADDRESS1'|| CHR(13) || CHR(10);
      address_ := address_ || ampersand_ || 'ADDRESS2'|| CHR(13) || CHR(10);
      address_ := address_ || ampersand_ || 'ADDRESS3'|| CHR(13) || CHR(10);
      address_ := address_ || ampersand_ || 'ADDRESS4'|| CHR(13) || CHR(10);
      address_ := address_ || ampersand_ || 'ADDRESS5'|| CHR(13) || CHR(10);
      address_ := address_ || ampersand_ || 'ADDRESS6'|| CHR(13) || CHR(10);
      address_ := address_ || ampersand_ || 'ZIP_CODE'|| CHR(13) || CHR(10);
      address_ := address_ || ampersand_ || 'CITY'|| CHR(13) || CHR(10);
      address_ := address_ || ampersand_ || 'STATE'|| CHR(13) || CHR(10);
      address_ := address_ || ampersand_ || 'COUNTY'|| CHR(13) || CHR(10);
      address_ := address_ || ampersand_ || 'COUNTRY_CODE - '|| ampersand_ || 'COUNTRY';
   END IF;
   -- Print a dummy field <BLANK_FIELD> for fields left blank in the address presentation.
   -- These dummy fields will be replaced by blank lines once the real addresses are filled (below).
   WHILE (INSTR(address_,Address_Presentation_API.lfcr_||Address_Presentation_API.lfcr_) != 0) LOOP
      address_ := REPLACE(address_,
                          Address_Presentation_API.lfcr_ || Address_Presentation_API.lfcr_,
                          Address_Presentation_API.lfcr_ || blank_field_ || Address_Presentation_API.lfcr_);
   END LOOP;
   -- Substitute the variables with the input address data.
   address_ := REPLACE(address_, ampersand_ || 'ADDRESS1', address1_);
   address_ := REPLACE(address_, ampersand_ || 'ADDRESS2', address2_);
   address_ := REPLACE(address_, ampersand_ || 'ADDRESS3', address3_);
   address_ := REPLACE(address_, ampersand_ || 'ADDRESS4', address4_);
   address_ := REPLACE(address_, ampersand_ || 'ADDRESS5', address5_);
   address_ := REPLACE(address_, ampersand_ || 'ADDRESS6', address6_);
   address_ := REPLACE(address_, ampersand_ || 'CITY', city_);
   address_ := REPLACE(address_, ampersand_ || 'COUNTY', county_);
   address_ := REPLACE(address_, ampersand_ || 'STATE', state_);
   address_ := REPLACE(address_, ampersand_ || 'ZIP_CODE', zip_code_);
   -- New fields in the current format. Does not have an eqvivalent in the previous format
   -- The order between these two is vital here. Country code has to be substituted first!
   --address_ := REPLACE(address_, ampersand_ || 'COUNTRY_CODE', Iso_Country_API.Encode(country_));
   --address_ := REPLACE(address_, ampersand_ || 'COUNTRY', country_);
   IF (INSTR(address_,ampersand_ ||'COUNTRY_CODE') != 0) THEN
      address_ := REPLACE(address_, ampersand_ || 'COUNTRY_CODE', NVL(country_code_,Iso_Country_API.Encode(country_)));
   END IF;
   IF (INSTR(address_,ampersand_ ||'COUNTRY') != 0) THEN
      IF (order_language_ IS NOT NULL) THEN
         address_ := REPLACE(address_, ampersand_ || 'COUNTRY', NVL(country_,Iso_Country_API.Get_Description(country_code_, order_language_)));
      ELSE
      address_ := REPLACE(address_, ampersand_ || 'COUNTRY', NVL(country_,Iso_Country_API.Decode (country_code_)));
      END IF;
   END IF;
   -- Remove all empty address fields (Blanks that are introduced after substituting the address fields)
   WHILE (INSTR(address_,Address_Presentation_API.lfcr_ || Address_Presentation_API.lfcr_) != 0) LOOP
      address_ := REPLACE(address_,
                          Address_Presentation_API.lfcr_ || Address_Presentation_API.lfcr_,
                          Address_Presentation_API.lfcr_);
   END LOOP;
   -- checked for keep_blank_field_
   -- NOTE: keep_blank_field_ should be passed FALSE in order to remove the blank lines. by passing TRUE would result in getting
   -- an address with '<BLANK_FIELD>' for the relevent line. This could be used to distinguish a blank line purposely set with a
   -- blank line created due to the NULL value.
   -- Replace all fields tagged by a blank_field_ with a a blank line
   IF NOT (keep_blank_field_) THEN
      WHILE (INSTR(address_, Address_Presentation_API.lfcr_ || blank_field_ || Address_Presentation_API.lfcr_) != 0) LOOP
         address_ := REPLACE(address_,
                             Address_Presentation_API.lfcr_ || blank_field_ || Address_Presentation_API.lfcr_,
                             Address_Presentation_API.lfcr_ || Address_Presentation_API.lfcr_);
      END LOOP;
   END IF;
   RETURN address_;
END Format_Address;


@UncheckedAccess
FUNCTION Format_To_Line (
   address_in_    IN VARCHAR2 ) RETURN Address_Rec_Type
IS
   address_rec_      Address_Rec_Type;
   address_          VARCHAR2(2000);
   instr_            NUMBER;
BEGIN
   address_ := address_in_;
   instr_ := INSTR(address_,lfcr_);
   IF (NVL(instr_,0) > 0) THEN
      address_rec_.address1 := TRIM(SUBSTR(address_,1,instr_-1));
      address_              := SUBSTR(address_,instr_+2);
   ELSIF (address_ IS NOT NULL) THEN
      address_rec_.address1 := TRIM(address_);
      address_              := NULL;
   END IF;
   instr_ := INSTR(address_,lfcr_);
   IF (NVL(instr_,0) > 0) THEN
      address_rec_.address2 := TRIM(SUBSTR(address_,1,instr_-1));
      address_              := SUBSTR(address_,instr_+2);
   ELSIF (address_ IS NOT NULL) THEN
      address_rec_.address2 := TRIM(address_);
      address_  := NULL;
   END IF;
   instr_ := INSTR(address_,lfcr_);
   IF (NVL(instr_,0) > 0) THEN
      address_rec_.address3 := TRIM(SUBSTR(address_,1,instr_-1));
      address_              := SUBSTR(address_,instr_+2);
   ELSIF (address_ IS NOT NULL) THEN
      address_rec_.address3 := TRIM(address_);
      address_              := NULL;
   END IF;
   instr_ := INSTR(address_,lfcr_);
   IF (NVL(instr_,0) > 0) THEN
      address_rec_.address4 := TRIM(SUBSTR(address_,1,instr_-1));
      address_              := SUBSTR(address_,instr_+2);
   ELSIF (address_ IS NOT NULL) THEN
      address_rec_.address4 := TRIM(address_);
      address_              := NULL;
   END IF;
   instr_ := INSTR(address_,lfcr_);
   IF (NVL(instr_,0) > 0) THEN
      address_rec_.address5 := TRIM(SUBSTR(address_,1,instr_-1));
      address_              := SUBSTR(address_,instr_+2);
   ELSIF (address_ IS NOT NULL) THEN
      address_rec_.address5 := TRIM(address_);
      address_              := NULL;
   END IF;
   instr_ := INSTR(address_,lfcr_);
   IF (NVL(instr_,0) > 0) THEN
      address_rec_.address6 := TRIM(SUBSTR(address_,1,instr_-1));
      address_              := SUBSTR(address_,instr_+2);
   ELSIF (address_ IS NOT NULL) THEN
      address_rec_.address6 := TRIM(address_);
      address_              := NULL;
   END IF;
   instr_ := INSTR(address_,lfcr_);
   IF (NVL(instr_,0) > 0) THEN
      address_rec_.address7 := TRIM(SUBSTR(address_,1,instr_-1));
      address_              := SUBSTR(address_,instr_+2);
   ELSIF (address_ IS NOT NULL) THEN
      address_rec_.address7 := TRIM(address_);
      address_              := NULL;
   END IF;
   instr_ := INSTR(address_,lfcr_);
   IF (NVL(instr_,0) > 0) THEN
      address_rec_.address8 := TRIM(SUBSTR(address_,1,instr_-1));
      address_              := SUBSTR(address_,instr_+2);
   ELSIF (address_ IS NOT NULL) THEN
      address_rec_.address8 := TRIM(address_);
      address_              := NULL;
   END IF;
   instr_ := INSTR(address_,lfcr_);
   IF (NVL(instr_,0) > 0) THEN
      address_rec_.address9 := TRIM(SUBSTR(address_,1,instr_-1));
      address_              := SUBSTR(address_,instr_+2);
   ELSIF (address_ IS NOT NULL) THEN
      address_rec_.address9 := TRIM(address_);
      address_              := NULL;
   END IF;
   instr_ := INSTR(address_,lfcr_);
   IF (NVL(instr_,0) > 0) THEN
      address_rec_.address10 := TRIM(SUBSTR(address_,1,instr_-1));
      address_               := SUBSTR(address_,instr_+2);
   ELSIF (address_ IS NOT NULL) THEN
      address_rec_.address10 := TRIM(address_);
      address_               := NULL;
   END IF;
   RETURN address_rec_;
END Format_To_Line;


@Override
@UncheckedAccess
FUNCTION Get_Display_Layout (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ address_presentation_tab.display_layout%TYPE;
   CURSOR get_default_display IS
      SELECT display_layout
      FROM   address_presentation_tab
      WHERE  default_display_layout = 'TRUE';
BEGIN
   temp_ := super(country_code_);
   IF (temp_ IS NULL) THEN
      OPEN get_default_display;
      FETCH get_default_display INTO temp_;
      CLOSE get_default_display;   
   END IF;
   RETURN temp_;
END Get_Display_Layout;


@Override
@UncheckedAccess
FUNCTION Get_Edit_Layout (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ address_presentation_tab.edit_layout%TYPE;
   CURSOR get_default_edit IS
      SELECT edit_layout
      FROM   address_presentation_tab
      WHERE  default_edit_layout = 'TRUE';
BEGIN
   temp_ := super(country_code_);
   IF (temp_ IS NULL) THEN
      OPEN get_default_edit;
      FETCH get_default_edit INTO temp_;
      CLOSE get_default_edit;   
   END IF;
   RETURN temp_;
END Get_Edit_Layout;


@UncheckedAccess
FUNCTION Get_Address_Record (
   country_code_ IN VARCHAR2 ) RETURN Public_Rec_Address
IS
   temp_    Public_Rec_Address;
   layout_  VARCHAR2(2000);
BEGIN
   -- Get the current representation and transform it into the previous one
   layout_ := Get_Display_Layout(country_code_);
   temp_ := Layout_To_Array___(layout_);
   RETURN temp_;
END Get_Address_Record;


PROCEDURE Sync_Address (
   country_code_   IN VARCHAR2 )
IS
BEGIN
  Company_Address_API.Sync_Addr(country_code_);
  Customer_Info_Address_API.Sync_Addr(country_code_);  
  Customs_Info_Address_API.Sync_Addr(country_code_);   
  Forwarder_Info_Address_API.Sync_Addr(country_code_); 
  Manufacturer_Info_Address_API.Sync_Addr(country_code_);
  Owner_Info_Address_API.Sync_Addr(country_code_);       
  Person_Info_Address_API.Sync_Addr(country_code_);      
  Supplier_Info_Address_API.Sync_Addr(country_code_);
END Sync_Address;
