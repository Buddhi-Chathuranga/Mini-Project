-----------------------------------------------------------------------------
--
--  Logical unit: CompanyAddress
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980930  ANHO    Created.
--  981126  Camk    Method Check_If_Null added
--  990412  Maruse  New template
--  990415  Maruse  Minor change in Get_Id_By_Type.
--  990428  Maruse  New template corrections.
--  990907  BmEk    Bug #11396. Added check in Unpack_Check_Insert and Unpack_Check_Update
--                  if valid to date is earlier then valid from date .
--  991124  Camk    Function Get_Company_By_Ean_Location() added.
--  991228  LiSv    Corrected bug #13129, changed substr_b to substr in function
--                  Get_Line.
--  000209  Mnisse  FIN243, new address fields.
--  000118  Camk    Address not mandatory
--  000225  Mnisse  Change of public methods for the new address fields.
--  000227  Mnisse  Address presentation, New_Address, Modify_Address
--  000229  Mnisse  Bug #32920, uppercase for Zip_Code
--  000302  Mnisse  Update also old address field.
--  000303  Mnisse  Public New and Modify shall update new address fields.
--  000410  Camk    Raise a warning to the user that the address format might not
--                  correctly stored.
--  000525  LiSv    Removed call to Check_If_Null___ (this is an old solution).
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  001024  Camk    County added
--  010314  Cand    Bug #18479, Added procedure Cascade_Delete_Comm_Method__
--  020529  JeGu    Bug #30404 Added column address_lov to view company_address
--  020918  ARAMLK  Merged with the 2002-3 AV.
--  030919  PPer    Merge TakeOff
--  030818  KuPeLk  Merged Chain Reaction by adding some changes.Added column Pay_Tax,Added the procedure Get_Address_Data,
--                  Made Pay_Tax false at the creation of the Delivery_Address,changed 'COMPANY_ADDRESS_TAB' TO &TABLE
--                  and  Added dynamic call to method get_address_data.
--  030916  Gepelk  IID ARFI124N. Add procedure Validate_Address
--  040324  RAFA    Merged SP1, lifted bugs 40783, 41095, 42712
--  040628  Jeguse  Bug 45629, Added functions Get_Address_Form, Get_Address_Rec, Get_All_Address_Lines and Get_Address_Line 
--  040920  SAAHLK  LCS Patch Merge, Bug 44319.
--  050105  SAAHLK  LCS Patch Merge, Bug 42347.
--  050303  AjPelk  B120109 En error msg EANEXIST: has renamed.
--  051208  Gawilk  Added method Get_Country_Db for LCS bugs 45867 and 54308
--  060428  Sacalk  Bug 56972, Added function Sync_Addr, Modified New_ and Modify_ methods 
--  060712  Kagalk  FIPL610A - Added columns Street, House_No, Community, District.   
--  060726  CsAmlk  Persian Calendar Modifications.
--  061010  DiAmlk  LCS Merge 59888.Modified the method Get_Address_Form.
--  070627  Kagalk  LCS Merge 65835, Rolled back 59885.
--  070627  Kagalk  LCS Merge 65828, Fixed address presentation in Get_Address_Form.
--  090224  Shdilk  Bug 80642, Modified variable length of 'name' in Get_Address_Form.
--  090430  Chhulk  Bug 79336, Modified Cascade_Delete_Comm_Method__
--  090521  AsHelk  Bug 80221, Adding Transaction Statement Approved Annotation.
--  090922  Nsillk  Issue Id EAFH-121 Removed unnecessary COMMIT statements
--  100622  Samblk  Bug 90960, Modified Validate_Address to support given test case
--  100113  Umdolk  Refactoring in Communication methods in Enterprise.
--  130614  DipeLK  Tibe-726, Removed global variable which used to check exsistance of INVENT componen
--  150220  Dihelk  PRFI-4712, Removed the Concat_Addr_Fields___() and corrected the address handling to tally with customer's and supplier's
--  150610  Waudlk  Bug 121697, Added Check_Exist method.
--  151103  THPELK  STRFI-307 - Removed Reset_Valid_From(),Reset_Valid_To().
--  160106	Chwtlk  STRFI-962, Merge of LCS Bug 126573, Modified Cascade_Delete_Comm_Method__()
--  160307  DipeLK  STRLOC-247,Removed Validate_Address() method.
--  160412  reanpl  STRLOC-53, Added handling of new attributes address3, address4, address5, address6, removed New_Address, Modify_Address
--  160505  ChguLK  STRCLOC-369, Renamed the package name to Address_Setup_API.
--  180509  Nirylk  Bug 141210, Merged App9 correction. Modified Check_Common___().
--  181130  thjilk  Modified Check_Delete___ to validate Address Types
--  191105  Vashlk  Bug 150833, Performance improvement for Vertex.
--  210127  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in methods New, Modify, New_Address, Modify_Address_Info and Modify_Detailed_Address
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE STRING_COMPANY IS TABLE OF VARCHAR2(20)
   INDEX BY BINARY_INTEGER;
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Company_Party___ (
   newrec_ IN OUT company_address_tab%ROWTYPE,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.party IS NULL) THEN
      newrec_.party := Company_API.Get_Party(newrec_.company);
      Client_SYS.Add_To_Attr('PARTY', newrec_.party, attr_);
   END IF;
END Get_Company_Party___;


PROCEDURE Check_Ean_Location___ (
   rec_ IN company_address_tab%ROWTYPE )
IS
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
   CURSOR check_exist IS
      SELECT 1
      FROM   company_address_tab
      WHERE  ean_location = rec_.ean_location
      AND    ROWID||''   <> NVL(objid_,CHR(0));
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, rec_.company, rec_.address_id);
   IF (rec_.ean_location IS NOT NULL) THEN
      FOR a IN check_exist LOOP
         Error_SYS.Record_Exist(lu_name_, 'EANEXIST: This Company''s Own Address ID already exists on another address for this company, or on another company.');
      END LOOP;
   END IF;
END Check_Ean_Location___;


PROCEDURE Split_Address___ (
   country_  IN   VARCHAR2,
   address_  IN   VARCHAR2,
   address1_ OUT  VARCHAR2,
   address2_ OUT  VARCHAR2,
   address3_ OUT  VARCHAR2,
   address4_ OUT  VARCHAR2,
   address5_ OUT  VARCHAR2,
   address6_ OUT  VARCHAR2,
   zip_code_ OUT  VARCHAR2,
   city_     OUT  VARCHAR2,
   county_   OUT  VARCHAR2,
   state_    OUT  VARCHAR2 )
IS
   address_pres_  Address_Presentation_API.Public_Rec_Address;
   lines_         NUMBER := 1;
   line_          VARCHAR2(100);
   addr_          VARCHAR2(2000);
   ptr_           NUMBER;
   cnt_           NUMBER;
   start_         NUMBER;
   end_           NUMBER;
   line_assigned_ BOOLEAN := FALSE;
   make_warning_  BOOLEAN := FALSE;
BEGIN
   -- Get the address presentation definition.
   address_pres_ := Address_Presentation_API.Get_Address_Record(Iso_Country_API.Encode(country_));
   -- Get the values from the address field and assign them to the specified
   -- address fields.
   -- This will not work correctly for fields on the same row due to the impossibility
   -- to know where on the line to split for the different fields. Hence, save the whole
   -- line in one field.
   -- A notification should be supplied to the user.
   -- Get the number of lines for the current address, call is depending on party_type.
   addr_ := address_;
   addr_ := RTRIM(REPLACE(addr_, CHR(13), ''), CHR(10));
   LOOP
      ptr_ := INSTR(addr_, CHR(10));
      IF (ptr_ > 0 AND ptr_ < LENGTH(addr_)) THEN
         lines_ := lines_ + 1;
         addr_ := SUBSTR(addr_, ptr_+1);
      ELSE
         EXIT;
      END IF;
   END LOOP;
   -- Loop through all the address lines
   FOR i IN 1 .. lines_ LOOP
      line_assigned_ := FALSE;
      -- Get the next line
      addr_  := address_;
      addr_  := CHR(10)||RTRIM( REPLACE(addr_, CHR(13), ''),CHR(10))||CHR(10);
      cnt_   := i;
      start_ := NVL(INSTR(addr_, CHR(10), 1, cnt_), 0);
      end_   := NVL(INSTR(addr_, CHR(10), 1, cnt_ + 1), 0);
      line_  := SUBSTR(addr_, start_ + 1, end_ - start_ - 1);
      -- Assign the values.
      IF (address_pres_.address1_row = i) THEN
         address1_ := SUBSTR(line_,1,35);
         line_assigned_ := TRUE;
      END IF;
      IF (address_pres_.address2_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            address2_ := SUBSTR(line_,1,35);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.address3_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            address3_ := SUBSTR(line_,1,100);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.address4_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            address4_ := SUBSTR(line_,1,100);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.address5_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            address5_ := SUBSTR(line_,1,100);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.address6_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            address6_ := SUBSTR(line_,1,100);
            line_assigned_ := TRUE;
         END IF;
      END IF;      
      IF (address_pres_.zip_code_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            zip_code_ := SUBSTR(line_,1,35);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.city_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            city_ := SUBSTR(line_,1,35);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.county_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            county_ := SUBSTR(line_,1,35);
            line_assigned_ := TRUE;
         END IF;
      END IF;
      IF (address_pres_.state_row = i) THEN
         IF (line_assigned_ = TRUE) THEN
            make_warning_ := TRUE;
         ELSE
            state_ := SUBSTR(line_,1,35);
            line_assigned_ := TRUE;
         END IF;
      END IF;
   END LOOP;
   -- IF make_warning flag is TRUE then make a warning to the user
   -- that an address line is not split correctly.
   IF (make_warning_ = TRUE) THEN
      -- How is this done??
      NULL;
   END IF;
END Split_Address___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN   
   super(attr_);
   Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode('COMPANY'), attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('WITHIN_CITY_LIMIT_DB', Fnd_Boolean_API.DB_FALSE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT company_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN   
   Get_Company_Party___(newrec_, attr_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     company_address_tab%ROWTYPE,
   newrec_ IN OUT company_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN      
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY', newrec_.party);
END Check_Update___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     company_address_tab%ROWTYPE,
   newrec_     IN OUT company_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS 
   validation_result_   VARCHAR2(5);
   validation_flag_     VARCHAR2(5);   
   CURSOR get_address_types(company_ IN VARCHAR2, address_id_ IN VARCHAR2) IS
      SELECT t.rowid, t.company, Address_Type_Code_API.Decode(t.address_type_code) AS address_type_code, t.def_address
      FROM   company_address_type_tab t
      WHERE  t.company = company_
      and    t.address_id = address_id_;   
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Logic to remove address default flag on other address IDs if time period overlaps.
   IF (NVL(newrec_.valid_from, Database_Sys.Get_First_Calendar_Date()) != NVL(oldrec_.valid_from, Database_Sys.Get_First_Calendar_Date())) OR 
      (NVL(newrec_.valid_to, Database_Sys.Get_Last_Calendar_Date()) != NVL(oldrec_.valid_to, Database_Sys.Get_Last_Calendar_Date())) THEN 
      FOR c1 IN get_address_types(newrec_.company, newrec_.address_id) LOOP
         Company_Address_Type_API.Check_Def_Address_Exist(validation_result_, 
                                                          validation_flag_, 
                                                          c1.company, 
                                                          c1.def_address, 
                                                          c1.address_type_code, 
                                                          c1.rowid, 
                                                          newrec_.valid_from, 
                                                          newrec_.valid_to);
         IF (c1.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
            Company_Address_Type_API.Check_Def_Addr_Temp(c1.company, 
                                                         c1.address_type_code, 
                                                         c1.def_address,
                                                         c1.rowid, 
                                                         newrec_.valid_from, 
                                                         newrec_.valid_to);
         END IF;
      END LOOP;
   END IF;
END Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     company_address_tab%ROWTYPE,
   newrec_ IN OUT company_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   action_             VARCHAR2(10);
   validation_result_  VARCHAR2(5);
   validation_flag_    VARCHAR2(5);   
   CURSOR get_address_types(company_ IN VARCHAR2, address_id_ IN VARCHAR2) IS
      SELECT t.rowid, t.company, Address_Type_Code_API.Decode(t.address_type_code) AS address_type_code, t.def_address
      FROM   company_address_type_tab t
      WHERE  t.company = company_
      AND    t.address_id = address_id_;      
   $IF Component_Accrul_SYS.INSTALLED $THEN
      postal_addresses_   External_Tax_System_Util_API.postal_address_arr;
      postal_address_     External_Tax_System_Util_API.postal_address_rec;
   $END   
BEGIN
   action_ := Client_SYS.Get_Item_Value('ACTION', attr_);
   IF (Object_Property_API.Get_Value('PartyType', '*', 'UNIQUE_OWN_ADDR') = 'TRUE') THEN
      Check_Ean_Location___(newrec_);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.valid_from > newrec_.valid_to) THEN
      Error_SYS.Appl_General(lu_name_, 'WRONGINTERVAL: Valid From date is later than Valid To date');
   END IF;
   Address_Setup_API.Check_Nullable_Address_Fields(lu_name_, newrec_.address1, newrec_.address2, newrec_.address3, newrec_.address4, newrec_.address5, newrec_.address6);
   Address_Setup_API.Validate_Address(newrec_.country, newrec_.state, newrec_.county, newrec_.city);
   IF (newrec_.state = '*') THEN
      newrec_.state := NULL;
   END IF;
   IF (newrec_.county = '*') THEN
      newrec_.county := NULL;
   END IF;
   IF (newrec_.city = '*') THEN
      newrec_.city := NULL;
   END IF;                      
   Address_Setup_API.Validate_Address_Attributes(lu_name_, 
                                                 newrec_.country, 
                                                 newrec_.address1, 
                                                 newrec_.address2, 
                                                 newrec_.address3, 
                                                 newrec_.address4, 
                                                 newrec_.address5, 
                                                 newrec_.address6, 
                                                 newrec_.zip_code, 
                                                 newrec_.city, 
                                                 newrec_.county, 
                                                 newrec_.state);
   newrec_.address := Address_Presentation_API.Format_Address(newrec_.country, 
                                                              newrec_.address1, 
                                                              newrec_.address2, 
                                                              newrec_.address3, 
                                                              newrec_.address4, 
                                                              newrec_.address5, 
                                                              newrec_.address6, 
                                                              newrec_.city, 
                                                              newrec_.county, 
                                                              newrec_.state, 
                                                              newrec_.zip_code, 
                                                              Iso_Country_API.Decode(newrec_.country)); 
   IF (action_ = 'DO') THEN
      $IF Component_Accrul_SYS.INSTALLED $THEN
         IF (indrec_.address1 OR indrec_.address2 OR indrec_.zip_code OR indrec_.city OR indrec_.state OR indrec_.county OR indrec_.country) THEN            
            postal_addresses_.DELETE;      
            postal_address_            := NULL;
            postal_address_.address_id := newrec_.address_id;
            postal_address_.address1   := newrec_.address1;
            postal_address_.address2   := newrec_.address2;
            postal_address_.zip_code   := newrec_.zip_code;
            postal_address_.city       := newrec_.city;
            postal_address_.state      := newrec_.state;
            postal_address_.county     := newrec_.county;
            postal_address_.country    := newrec_.country;
            postal_addresses_(0)       := postal_address_;            
            External_Tax_System_Util_API.Handle_Address_Information(postal_addresses_, newrec_.company, 'COMPANY_CUSTOMER'); 
            IF (postal_addresses_.EXISTS(0)) THEN
               newrec_.jurisdiction_code := postal_addresses_(0).jurisdiction_code;   
            ELSE
               newrec_.jurisdiction_code := NULL;
            END IF;  
         END IF;                                                                         
      $ELSE
         newrec_.jurisdiction_code := NULL;
      $END 
   ELSE
      newrec_.jurisdiction_code := NULL;   
   END IF;
   IF (newrec_.tax_calc_structure_id IS NOT NULL) THEN                                                            
      Company_Address_Type_API.Exist(newrec_.company, newrec_.address_id, Address_Type_Code_API.Decode('DELIVERY'));
      $IF Component_Invoic_SYS.INSTALLED $THEN
         IF (Delivery_Fee_Code_Company_API.Check_Tax_Codes_Exist(newrec_.company, newrec_.address_id) = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'COMPTAXSTRTAXCODEEXIST: When specifying tax information for company you can either enter structure in Tax Calculation Structure field or one or more tax codes in Tax Code column. Please clear Tax Calculation Structure field or remove Tax Codes.');
         END IF;      
      $END
      $IF Component_Accrul_SYS.INSTALLED $THEN
         Tax_Structure_Item_API.Check_Valid_Tax_Structure(newrec_.company, newrec_.tax_calc_structure_id, SYSDATE); 
      $END      
   END IF;
   Client_Sys.Add_To_Attr('JURISDICTION_CODE', newrec_.jurisdiction_code, attr_);
   -- Check if connected address types still are valid according to modified date periods.
   IF (NVL(newrec_.valid_from, Database_Sys.Get_First_Calendar_Date()) != NVL(oldrec_.valid_from, Database_Sys.Get_First_Calendar_Date())) OR 
      (NVL(newrec_.valid_to, Database_Sys.Get_Last_Calendar_Date()) != NVL(oldrec_.valid_to, Database_Sys.Get_Last_Calendar_Date())) THEN 
      FOR c1 IN get_address_types(newrec_.company, newrec_.address_id) LOOP
         Company_Address_Type_API.Check_Def_Address_Exist(validation_result_, 
                                                          validation_flag_, 
                                                          c1.company, 
                                                          c1.def_address, 
                                                          c1.address_type_code, 
                                                          c1.rowid, 
                                                          newrec_.valid_from, 
                                                          newrec_.valid_to);
         IF (c1.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
            Client_SYS.Add_Warning(lu_name_, 'DEFADDEXIST1: A default address ID already exists for :P1 Address Type for this time period. Do you want to set the current address ID as default instead?', c1.address_type_code);
         END IF;
      END LOOP;
   END IF;
END Check_Common___;


PROCEDURE Check_Tax_Calc_Struct_Ref___ (
   newrec_ IN OUT company_address_tab%ROWTYPE )
IS   
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      Tax_Calc_Structure_API.Validate_Tax_Structure_State(newrec_.company, newrec_.tax_calc_structure_id);
   $ELSE
      NULL;
   $END
END Check_Tax_Calc_Struct_Ref___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN company_address_tab%ROWTYPE )
IS
   addr_type_code_list_     VARCHAR2(2000);
   addr_type_count_         NUMBER;
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   counter_                 NUMBER := 1;
   info_str_                VARCHAR2(2000);
   CURSOR get_address_types (company_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT *
      FROM   company_address_type
      WHERE  company = company_
      AND   address_id = address_id_;
   CURSOR get_def_address_types_count (company_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT COUNT(*)
      FROM   company_address_type
      WHERE  company = company_
      AND    address_id = address_id_
      AND    def_address = 'TRUE';
BEGIN
   OPEN get_def_address_types_count(remrec_.company, remrec_.address_id);
   FETCH get_def_address_types_count INTO addr_type_count_;
   CLOSE get_def_address_types_count;
   FOR rec_ IN get_address_types(remrec_.company, remrec_.address_id) LOOP
      Company_Address_Type_API.Check_Def_Address_Exist(validation_result_, validation_flag_, rec_.company, rec_.def_address, rec_.address_type_code_db, rec_.objid, remrec_.valid_from, remrec_.valid_to);
      IF ((validation_result_ = 'TRUE') AND (rec_.def_address = 'TRUE')) THEN
         IF ((counter_ = 1)  AND (addr_type_count_ > 1)) THEN
            addr_type_code_list_ := CONCAT(rec_.address_type_code, ',');
         ELSIF (counter_ = addr_type_count_) THEN
            addr_type_code_list_ := CONCAT(addr_type_code_list_, CONCAT(rec_.address_type_code, ''));
         ELSE
            addr_type_code_list_ := CONCAT(addr_type_code_list_, CONCAT(rec_.address_type_code, ','));
         END IF;
         counter_ := counter_ + 1;
      END IF;
   END LOOP;
   IF (addr_type_code_list_ IS NOT NULL) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRWITHDEFADDRTYPES: This is the default :P1 Address Type(s) for Company :P2. If removed, there will be no default address for this Address Type(s).', addr_type_code_list_, remrec_.company);
   END IF;
   info_str_ := Client_SYS.Get_All_Info();
   super(remrec_);
   Client_SYS.Clear_Info();
   Client_SYS.Merge_Info(info_str_);     
END Check_Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_To_Attr('ACTION', action_, attr_);
   super(info_, objid_, objversion_, attr_, action_);
END New__;


@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_To_Attr('ACTION', action_, attr_);
   super(info_, objid_, objversion_, attr_, action_);
END Modify__;


@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ company_address_tab%ROWTYPE;
BEGIN
   IF (action_ = 'DO') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Cascade_Delete_Comm_Method__(remrec_.company, remrec_.address_id);      
   END IF;   
   super(info_, objid_, objversion_, action_);
END Remove__;


PROCEDURE Cascade_Delete_Comm_Method__ (
   company_    IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
   CURSOR comm_method_ IS
      SELECT ROWID, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') AS rowversion
      FROM   comm_method_tab
      WHERE  party_type = 'COMPANY'
      AND    identity   = company_
      AND    address_id = address_id_;
BEGIN
   FOR item_ IN comm_method_ LOOP
      Comm_Method_API.Remove__(info_, item_.ROWID, item_.rowversion, 'DO');
   END LOOP;
END Cascade_Delete_Comm_Method__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Line (
   company_    IN VARCHAR2,
   address_id_ IN VARCHAR2,
   line_no_    IN NUMBER DEFAULT 1 ) RETURN VARCHAR2
IS
   country_       company_address.country%TYPE;
   address_pres_  Address_Presentation_API.Public_Rec_Address;
   line_          NUMBER;
   row1_          VARCHAR2(100);
   row2_          VARCHAR2(100);
   row3_          VARCHAR2(100);
   row4_          VARCHAR2(100);
   row5_          VARCHAR2(100);
BEGIN
   country_      := Get_Country(company_, address_id_);
   address_pres_ := Address_Presentation_API.Get_Address_Record(Iso_Country_API.Encode(country_));
   line_         := line_no_;
   -- IF line_no_ = 0 then return the last line.
   --    Set line_no_ to the highest row in the definition
   IF (line_ = 0 ) THEN
      line_ := address_pres_.address1_row;
      IF (address_pres_.address2_row > line_) THEN
         line_ := address_pres_.address2_row;
      END IF;
      IF (address_pres_.address3_row > line_) THEN
         line_ := address_pres_.address3_row;
      END IF;
      IF (address_pres_.address4_row > line_) THEN
         line_ := address_pres_.address4_row;
      END IF;
      IF (address_pres_.address5_row > line_) THEN
         line_ := address_pres_.address5_row;
      END IF;
      IF (address_pres_.address6_row > line_) THEN
         line_ := address_pres_.address6_row;
      END IF;
      IF (address_pres_.zip_code_row > line_) THEN
         line_ := address_pres_.zip_code_row;
      END IF;
      IF (address_pres_.city_row > line_) THEN
         line_ := address_pres_.city_row;
      END IF;
      IF (address_pres_.county_row > line_) THEN
         line_ := address_pres_.county_row;
      END IF;
      IF (address_pres_.state_row > line_) THEN
         line_ := address_pres_.state_row;
      END IF;
   END IF;
   -- Check the different address fields for the correct line number.
   -- Put the value in the right order.
   IF (address_pres_.address1_row = line_) THEN
      IF (address_pres_.address1_order = 1) THEN
         row1_ := Get_Address1(company_, address_id_);
      ELSIF (address_pres_.address1_order = 2) THEN
         row2_ := Get_Address1(company_, address_id_);
      ELSIF (address_pres_.address1_order = 3) THEN
         row3_ := Get_Address1(company_, address_id_);
      ELSIF (address_pres_.address1_order = 4) THEN
         row4_ := Get_Address1(company_, address_id_);
      ELSIF (address_pres_.address1_order = 5) THEN
         row5_ := Get_Address1(company_, address_id_);
      ELSE
         row1_ := Get_Address1(company_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address2_row = line_) THEN
      IF (address_pres_.address2_order = 1) THEN
         row1_ := Get_Address2(company_, address_id_);
      ELSIF (address_pres_.address2_order = 2) THEN
         row2_ := Get_Address2(company_, address_id_);
      ELSIF (address_pres_.address2_order = 3) THEN
         row3_ := Get_Address2(company_, address_id_);
      ELSIF (address_pres_.address2_order = 4) THEN
         row4_ := Get_Address2(company_, address_id_);
      ELSIF (address_pres_.address2_order = 5) THEN
         row5_ := Get_Address2(company_, address_id_);
      ELSE
         row1_ := Get_Address2(company_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address3_row = line_) THEN
      IF (address_pres_.address3_order = 1) THEN
         row1_ := Get_Address3(company_, address_id_);
      ELSIF (address_pres_.address3_order = 2) THEN
         row2_ := Get_Address3(company_, address_id_);
      ELSIF (address_pres_.address3_order = 3) THEN
         row3_ := Get_Address3(company_, address_id_);
      ELSIF (address_pres_.address3_order = 4) THEN
         row4_ := Get_Address3(company_, address_id_);
      ELSIF (address_pres_.address3_order = 5) THEN
         row5_ := Get_Address3(company_, address_id_);
      ELSE
         row1_ := Get_Address3(company_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address4_row = line_) THEN
      IF (address_pres_.address4_order = 1) THEN
         row1_ := Get_Address4(company_, address_id_);
      ELSIF (address_pres_.address4_order = 2) THEN
         row2_ := Get_Address4(company_, address_id_);
      ELSIF (address_pres_.address4_order = 3) THEN
         row3_ := Get_Address4(company_, address_id_);
      ELSIF (address_pres_.address4_order = 4) THEN
         row4_ := Get_Address4(company_, address_id_);
      ELSIF (address_pres_.address4_order = 5) THEN
         row5_ := Get_Address4(company_, address_id_);
      ELSE
         row1_ := Get_Address4(company_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address5_row = line_) THEN
      IF (address_pres_.address5_order = 1) THEN
         row1_ := Get_Address5(company_, address_id_);
      ELSIF (address_pres_.address5_order = 2) THEN
         row2_ := Get_Address5(company_, address_id_);
      ELSIF (address_pres_.address5_order = 3) THEN
         row3_ := Get_Address5(company_, address_id_);
      ELSIF (address_pres_.address5_order = 4) THEN
         row4_ := Get_Address5(company_, address_id_);
      ELSIF (address_pres_.address5_order = 5) THEN
         row5_ := Get_Address5(company_, address_id_);
      ELSE
         row1_ := Get_Address5(company_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.address6_row = line_) THEN
      IF (address_pres_.address6_order = 1) THEN
         row1_ := Get_Address6(company_, address_id_);
      ELSIF (address_pres_.address6_order = 2) THEN
         row2_ := Get_Address6(company_, address_id_);
      ELSIF (address_pres_.address6_order = 3) THEN
         row3_ := Get_Address6(company_, address_id_);
      ELSIF (address_pres_.address6_order = 4) THEN
         row4_ := Get_Address6(company_, address_id_);
      ELSIF (address_pres_.address6_order = 5) THEN
         row5_ := Get_Address6(company_, address_id_);
      ELSE
         row1_ := Get_Address6(company_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.zip_code_row = line_) THEN
      IF (address_pres_.zip_code_order = 1) THEN
         row1_ := Get_Zip_Code(company_, address_id_);
      ELSIF (address_pres_.zip_code_order = 2) THEN
         row2_ := Get_Zip_Code(company_, address_id_);
      ELSIF (address_pres_.zip_code_order = 3) THEN
         row3_ := Get_Zip_Code(company_, address_id_);
      ELSIF (address_pres_.zip_code_order = 4) THEN
         row4_ := Get_Zip_Code(company_, address_id_);
      ELSIF (address_pres_.zip_code_order = 5) THEN
         row5_ := Get_Zip_Code(company_, address_id_);
      ELSE
         row1_ := Get_Zip_Code(company_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.city_row = line_) THEN
      IF (address_pres_.city_order = 1) THEN
         row1_ := Get_City(company_, address_id_);
      ELSIF (address_pres_.city_order = 2) THEN
         row2_ := Get_City(company_, address_id_);
      ELSIF (address_pres_.city_order = 3) THEN
         row3_ := Get_City(company_, address_id_);
      ELSIF (address_pres_.city_order = 4) THEN
         row4_ := Get_City(company_, address_id_);
      ELSIF (address_pres_.city_order = 5) THEN
         row5_ := Get_City(company_, address_id_);
      ELSE
         row1_ := Get_City(company_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.county_row = line_) THEN
      IF (address_pres_.county_order = 1) THEN
         row1_ := Get_County(company_, address_id_);
      ELSIF (address_pres_.county_order = 2) THEN
         row2_ := Get_County(company_, address_id_);
      ELSIF (address_pres_.county_order = 3) THEN
         row3_ := Get_County(company_, address_id_);
      ELSIF (address_pres_.county_order = 4) THEN
         row4_ := Get_County(company_, address_id_);
      ELSIF (address_pres_.county_order = 5) THEN
         row5_ := Get_County(company_, address_id_);
      ELSE
         row1_ := Get_County(company_, address_id_);
      END IF;
   END IF;
   IF (address_pres_.state_row = line_) THEN
      IF (address_pres_.state_order = 1) THEN
         row1_ := Get_State(company_, address_id_);
      ELSIF (address_pres_.state_order = 2) THEN
         row2_ := Get_State(company_, address_id_);
      ELSIF (address_pres_.state_order = 3) THEN
         row3_ := Get_State(company_, address_id_);
      ELSIF (address_pres_.state_order = 4) THEN
         row4_ := Get_State(company_, address_id_);
      ELSIF (address_pres_.state_order = 5) THEN
         row5_ := Get_State(company_, address_id_);
      ELSE
         row1_ := Get_State(company_, address_id_);
      END IF;
   END IF;
   --Concatenate the different parts.
   RETURN RTRIM(LTRIM(row1_ || ' ' || row2_ || ' ' || row3_ || ' ' || row4_ || ' ' || row5_));
END Get_Line;


@UncheckedAccess
FUNCTION Get_Lines_Count (
   company_    IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   country_       company_address.country%TYPE;
   address_pres_  Address_Presentation_API.Public_Rec_Address;
   line_no_       NUMBER;
BEGIN
   country_ := Get_Country(company_, address_id_);
   address_pres_ := Address_Presentation_API.Get_Address_Record(Iso_Country_API.Encode(country_));
   -- Get the highest row value in the definition.
   line_no_ := address_pres_.address1_row;
   IF (address_pres_.address2_row > line_no_) THEN
      line_no_ := address_pres_.address2_row;
   END IF;
   IF (address_pres_.address3_row > line_no_) THEN
      line_no_ := address_pres_.address3_row;
   END IF;
   IF (address_pres_.address4_row > line_no_) THEN
      line_no_ := address_pres_.address4_row;
   END IF;
   IF (address_pres_.address5_row > line_no_) THEN
      line_no_ := address_pres_.address5_row;
   END IF;
   IF (address_pres_.address6_row > line_no_) THEN
      line_no_ := address_pres_.address6_row;
   END IF;
   IF (address_pres_.zip_code_row > line_no_) THEN
      line_no_ := address_pres_.zip_code_row;
   END IF;
   IF (address_pres_.city_row > line_no_) THEN
      line_no_ := address_pres_.city_row;
   END IF;
   IF (address_pres_.county_row > line_no_) THEN
      line_no_ := address_pres_.county_row;
   END IF;
   IF (address_pres_.state_row > line_no_) THEN
      line_no_ := address_pres_.state_row;
   END IF;
   RETURN line_no_;
END Get_Lines_Count;


@UncheckedAccess
FUNCTION Get_Db_Types (
   company_    IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   types_   VARCHAR2(2000) := Client_SYS.text_separator_;
   CURSOR types IS
      SELECT address_type_code
      FROM   company_address_type_tab
      WHERE  company = company_
      AND    address_id = address_id_;
BEGIN
   FOR t IN types LOOP
      types_ := types_ || t.address_type_code || Client_SYS.text_separator_;
   END LOOP;
   RETURN types_;
END Get_Db_Types;


@UncheckedAccess
FUNCTION Get_Id_By_Type (
   company_           IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   curr_date_         IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20);
   addr_id_  VARCHAR2(50);
   CURSOR get_id_by IS
      SELECT a.address_id
      FROM   company_address_tab a, company_address_type_tab t
      WHERE  a.company = company_
      AND    t.company = a.company
      AND    t.address_id = a.address_id
      AND    t.def_address = 'TRUE'
      AND    t.address_type_code = db_value_
      AND    TRUNC(curr_date_) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date()); 
BEGIN
   db_value_ := Address_Type_Code_API.Encode(address_type_code_);
   OPEN get_id_by;
   FETCH get_id_by INTO addr_id_;
   IF (get_id_by%NOTFOUND) THEN
      CLOSE get_id_by;
      RETURN NULL;
   END IF;
   CLOSE get_id_by;
   RETURN addr_id_;
END Get_Id_By_Type;


@UncheckedAccess
FUNCTION Get_Id_By_Ean_Location (
   company_      IN VARCHAR2,
   ean_location_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   address_id_  VARCHAR2(50);
   CURSOR get_id IS
      SELECT address_id
      FROM   company_address_tab
      WHERE  company = company_
      AND    ean_location = ean_location_;
BEGIN
   OPEN get_id;
   FETCH get_id INTO address_id_;
   IF (get_id%NOTFOUND) THEN
      CLOSE get_id;
      RETURN NULL;
   END IF;
   RETURN address_id_;
END Get_Id_By_Ean_Location;


@UncheckedAccess
FUNCTION Is_Valid (
   company_    IN VARCHAR2,
   address_id_ IN VARCHAR2,
   curr_date_  IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   is_valid_    NUMBER;
   CURSOR valid_data IS
      SELECT 1
      FROM   company_address_tab
      WHERE  company = company_
      AND    address_id = address_id_
      AND    TRUNC(curr_date_) BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date()); 
BEGIN
   OPEN valid_data;
   FETCH valid_data INTO is_valid_;
   IF (valid_data%NOTFOUND) THEN
      CLOSE valid_data;
      RETURN 'FALSE';
   ELSE
      CLOSE valid_data;
      RETURN 'TRUE';
   END IF;
END Is_Valid;


PROCEDURE New (
   company_      IN VARCHAR2,
   address_id_   IN VARCHAR2,
   address_      IN VARCHAR2,
   country_      IN VARCHAR2,
   ean_location_ IN VARCHAR2 DEFAULT NULL,
   valid_from_   IN DATE DEFAULT NULL,
   valid_to_     IN DATE DEFAULT NULL )
IS
   newrec_       company_address_tab%ROWTYPE;
   address1_     company_address_tab.address1%TYPE;
   address2_     company_address_tab.address2%TYPE;
   address3_     company_address_tab.address3%TYPE;
   address4_     company_address_tab.address4%TYPE;
   address5_     company_address_tab.address5%TYPE;
   address6_     company_address_tab.address6%TYPE;
   zip_code_     company_address_tab.zip_code%TYPE;
   city_         company_address_tab.city%TYPE;
   county_       company_address_tab.county%TYPE;
   state_        company_address_tab.state%TYPE;
BEGIN
   newrec_.company            := company_;
   newrec_.address_id         := address_id_;
   newrec_.address            := address_;
   newrec_.country            := Iso_Country_API.Encode(country_);
   newrec_.party_type         := 'COMPANY';
   newrec_.default_domain     := 'TRUE';
   newrec_.ean_location       := ean_location_;    
   newrec_.valid_from         := valid_from_;
   newrec_.valid_to           := valid_to_;
   newrec_.within_city_limit  := 'FALSE';
   Split_Address___(country_, address_, address1_, address2_, address3_, address4_, address5_, address6_, zip_code_, city_, county_, state_);
   newrec_.address1  := address1_;
   newrec_.address2  := address2_;
   newrec_.address3  := address3_;
   newrec_.address4  := address4_;
   newrec_.address5  := address5_;
   newrec_.address6  := address6_; 
   newrec_.zip_code  := zip_code_;
   newrec_.city      := city_;
   newrec_.county    := county_;
   newrec_.state     := state_;
   New___(newrec_);
   -- Raise a warning to the user that the address format might not be correctly stored.
   Client_SYS.Add_Info(lu_name_, 'COMPADDR: The address might have been stored with an invalid format. Please check the address :P1 for company :P2', address_id_, company_);
END New;


PROCEDURE Modify (
   company_      IN VARCHAR2,
   address_id_   IN VARCHAR2,
   address_      IN VARCHAR2 DEFAULT NULL,
   country_      IN VARCHAR2 DEFAULT NULL,
   ean_location_ IN VARCHAR2 DEFAULT NULL,
   valid_from_   IN DATE DEFAULT NULL,
   valid_to_     IN DATE DEFAULT NULL )
IS
   oldrec_       company_address_tab%ROWTYPE;
   newrec_       company_address_tab%ROWTYPE;
   address1_     company_address_tab.address1%TYPE;
   address2_     company_address_tab.address2%TYPE;
   address3_     company_address_tab.address3%TYPE;
   address4_     company_address_tab.address4%TYPE;
   address5_     company_address_tab.address5%TYPE;
   address6_     company_address_tab.address6%TYPE;
   zip_code_     company_address_tab.zip_code%TYPE;
   city_         company_address_tab.city%TYPE;
   county_       company_address_tab.city%TYPE;
   state_        company_address_tab.state%TYPE;
   country_temp_ company_address.country%TYPE;
BEGIN
   oldrec_ := Get_Object_By_Keys___(company_, address_id_);
   newrec_ := oldrec_;
   newrec_.address      := address_;
   newrec_.country      := Iso_Country_API.Encode(country_);
   newrec_.ean_location := ean_location_;    
   newrec_.valid_from   := valid_from_;
   newrec_.valid_to     := valid_to_;
   -- The new address fields should only be updated when the address_ is not NULL.
   IF (address_ IS NOT NULL) THEN
      -- IF the country is not supplied then use the country from the old record.
      country_temp_ := NVL(country_, Iso_Country_API.Decode(oldrec_.country));
      Split_Address___(country_temp_, address_, address1_, address2_, address3_, address4_, address5_, address6_, zip_code_, city_, county_, state_);
      newrec_.address1  := address1_;
      newrec_.address2  := address2_;
      newrec_.address3  := address3_;
      newrec_.address4  := address4_;
      newrec_.address5  := address5_;
      newrec_.address6  := address6_; 
      newrec_.zip_code  := zip_code_;
      newrec_.city      := city_;
      newrec_.county    := county_;
      newrec_.state     := state_;
      newrec_.country   := Iso_Country_API.Encode(country_temp_);
   END IF;  
   Modify___(newrec_);
   -- Raise a warning to the user that the address format might not be correctly stored.
   Client_SYS.Add_Info(lu_name_, 'COMPADDR: The address might have been stored with an invalid format. Please check the address :P1 for company :P2', address_id_, company_);
END Modify;


PROCEDURE Remove (
   company_    IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(200);
   remrec_       company_address_tab%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(company_, address_id_);
   Get_Id_Version_By_Keys___(objid_, objversion_, company_, address_id_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


@UncheckedAccess
FUNCTION Get_Default_Address (
   company_           IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   curr_date_         IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   CURSOR get_def_address IS
      SELECT address_id
      FROM   company_address_tab
      WHERE  company = company_
      AND    curr_date_ BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date());
BEGIN
   FOR t IN get_def_address LOOP
      IF (Company_Address_Type_API.Is_Default(company_, t.address_id, address_type_code_) = 'TRUE') THEN
         RETURN t.address_id;
      END IF;
   END LOOP;
   RETURN NULL;
END Get_Default_Address;


@UncheckedAccess
FUNCTION Get_Company_By_Ean_Location (
   ean_location_ IN VARCHAR2 ) RETURN STRING_COMPANY
IS
   company_array_ STRING_COMPANY;
   index_no_ NUMBER := 0;
   CURSOR get_company IS
      SELECT company
      FROM   company_address_tab
      WHERE  ean_location = ean_location_;
BEGIN
   FOR i IN get_company LOOP
      company_array_(index_no_) := i.company;
      index_no_ := index_no_ + 1;
   END LOOP;
   RETURN company_array_;
END Get_Company_By_Ean_Location;


PROCEDURE Get_Address_Data (
   address_    OUT VARCHAR2,
   name_       OUT VARCHAR2,
   fax_        OUT VARCHAR2,
   phone_      OUT VARCHAR2,
   company_    IN  VARCHAR2,
   address_id_ IN  VARCHAR2 )
IS
   CURSOR get_data IS
      SELECT address1||CHR(44)||address2||CHR(44)||zip_code||CHR(44)||city||CHR(44)||state address
      FROM  company_address_tab
      WHERE address_id = address_id_;
BEGIN
   OPEN get_data;
   FETCH get_data INTO address_;
   CLOSE get_data;
   $IF Component_Invent_SYS.INSTALLED $THEN
      name_ := Company_Address_Deliv_Info_API.Get_Address_Name(company_, address_id_);
   $ELSE
      NULL;
   $END
   fax_  := Comm_Method_API.Get_Value('COMPANY', company_, Comm_Method_Code_API.Decode('FAX'), 1, address_id_, SYSDATE);
   phone_:= Comm_Method_API.Get_Value('COMPANY', company_, Comm_Method_Code_API.Decode('PHONE'), 1, address_id_, SYSDATE);
END Get_Address_Data;


FUNCTION Get_Address_Form (
   identity_     IN VARCHAR2,
   address_id_   IN VARCHAR2,
   fetch_name_   IN VARCHAR2 DEFAULT 'FALSE',
   remove_empty_ IN VARCHAR2 DEFAULT 'TRUE',
   separator_    IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   address_         VARCHAR2(2000);
   country_         VARCHAR2(35);
   name_            company_tab.name%TYPE;
   address_record_  Public_Rec;
BEGIN
   address_record_ := Get(identity_, address_id_);
   -- Added parameter print_blanks_
   address_ := Address_Presentation_API.Format_Address(address_record_.country, 
                                                       address_record_.address1, 
                                                       address_record_.address2, 
                                                       address_record_.address3, 
                                                       address_record_.address4, 
                                                       address_record_.address5, 
                                                       address_record_.address6, 
                                                       address_record_.city, 
                                                       address_record_.county, 
                                                       address_record_.state, 
                                                       address_record_.zip_code, 
                                                       country_);
   IF (fetch_name_ = 'TRUE') THEN
      name_    := Company_API.Get_Name(identity_);
      address_ := name_ || Address_Presentation_API.lfcr_ || address_;
   END IF;                            
   IF (separator_ IS NOT NULL) THEN
      address_ := REPLACE(address_,Address_Presentation_API.lfcr_,separator_);                                                        
   END IF;
   RETURN address_;
END Get_Address_Form;


FUNCTION Get_Address_Rec (
   identity_     IN VARCHAR2,
   address_id_   IN VARCHAR2,
   fetch_name_   IN VARCHAR2 DEFAULT 'FALSE',
   remove_empty_ IN VARCHAR2 DEFAULT 'TRUE') RETURN Address_Presentation_API.Address_Rec_Type
IS
   address_rec_     Address_Presentation_API.Address_Rec_Type;
   address_         VARCHAR2(2000);
BEGIN
   address_ := Get_Address_Form(identity_, address_id_, fetch_name_, remove_empty_); 
   address_rec_ := Address_Presentation_API.Format_To_Line(address_);
   RETURN address_rec_;
END Get_Address_Rec;


PROCEDURE Get_All_Address_Lines (
   address_l_    IN OUT VARCHAR2,
   address_2_    IN OUT VARCHAR2,
   address_3_    IN OUT VARCHAR2,
   address_4_    IN OUT VARCHAR2,
   address_5_    IN OUT VARCHAR2,
   address_6_    IN OUT VARCHAR2,
   identity_     IN     VARCHAR2,
   address_id_   IN     VARCHAR2,
   fetch_name_   IN     VARCHAR2 DEFAULT 'FALSE',
   remove_empty_ IN     VARCHAR2 DEFAULT 'TRUE')
IS
   address_rec_        Address_Presentation_API.Address_Rec_Type;
BEGIN
   address_rec_ := Get_Address_Rec(identity_, address_id_, fetch_name_, remove_empty_);
   address_l_   := address_rec_.address1;
   address_2_   := address_rec_.address2;
   address_3_   := address_rec_.address3;
   address_4_   := address_rec_.address4;
   address_5_   := address_rec_.address5;
   address_6_   := address_rec_.address6;
END Get_All_Address_Lines;


PROCEDURE Get_All_Address_Lines (
   address_l_    IN OUT VARCHAR2,
   address_2_    IN OUT VARCHAR2,
   address_3_    IN OUT VARCHAR2,
   address_4_    IN OUT VARCHAR2,
   address_5_    IN OUT VARCHAR2,
   address_6_    IN OUT VARCHAR2,
   address_7_    IN OUT VARCHAR2,
   address_8_    IN OUT VARCHAR2,
   address_9_    IN OUT VARCHAR2,
   address_10_   IN OUT VARCHAR2,
   identity_     IN     VARCHAR2,
   address_id_   IN     VARCHAR2,
   fetch_name_   IN     VARCHAR2 DEFAULT 'FALSE',
   remove_empty_ IN     VARCHAR2 DEFAULT 'TRUE')
IS
   address_rec_        Address_Presentation_API.Address_Rec_Type;
BEGIN
   address_rec_ := Get_Address_Rec(identity_, address_id_, fetch_name_, remove_empty_);
   address_l_   := address_rec_.address1;
   address_2_   := address_rec_.address2;
   address_3_   := address_rec_.address3;
   address_4_   := address_rec_.address4;
   address_5_   := address_rec_.address5;
   address_6_   := address_rec_.address6;
   address_7_   := address_rec_.address7;
   address_8_   := address_rec_.address8;
   address_9_   := address_rec_.address9;
   address_10_  := address_rec_.address10;
END Get_All_Address_Lines;


FUNCTION Get_Address_Line (
   identity_     IN VARCHAR2,
   address_id_   IN VARCHAR2,
   line_no_      IN NUMBER DEFAULT 1,
   remove_empty_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN VARCHAR2
IS
   address_rec_     Address_Presentation_API.Address_Rec_Type;
   address_line_    VARCHAR2(2000);
BEGIN
   address_rec_ := Get_Address_Rec(identity_, address_id_, 'FALSE', remove_empty_);
   address_line_ := CASE line_no_
                       WHEN 1 THEN address_rec_.address1
                       WHEN 2 THEN address_rec_.address2
                       WHEN 3 THEN address_rec_.address3
                       WHEN 4 THEN address_rec_.address4
                       WHEN 5 THEN address_rec_.address5
                       WHEN 6 THEN address_rec_.address6
                       WHEN 7 THEN address_rec_.address7
                       WHEN 8 THEN address_rec_.address8
                       WHEN 9 THEN address_rec_.address9
                       WHEN 10 THEN address_rec_.address10
                    END;
   RETURN address_line_;
END Get_Address_Line;


PROCEDURE Sync_Addr (
   country_code_  IN VARCHAR2)
IS
   address_   company_address_tab.address%TYPE;
   country_   iso_country_tab.description%TYPE;
   CURSOR get_records IS
      SELECT country, 
             address1,
             address2, 
             address3, 
             address4, 
             address5, 
             address6, 
             city, 
             county, 
             state, 
             zip_code,
             address,  
             ROWID objid
      FROM   company_address_tab
      WHERE  country = country_code_
      FOR UPDATE;   
BEGIN
   country_:= Iso_Country_API.Decode(country_code_);
   FOR rec_ IN get_records LOOP
      address_ := Address_Presentation_API.Format_Address(rec_.country, 
                                                          rec_.address1, 
                                                          rec_.address2, 
                                                          rec_.address3, 
                                                          rec_.address4, 
                                                          rec_.address5, 
                                                          rec_.address6, 
                                                          rec_.city,
                                                          rec_.county, 
                                                          rec_.state, 
                                                          rec_.zip_code, 
                                                          country_); 
      IF (address_ != rec_.address) THEN
         UPDATE company_address_tab
            SET address = address_       
          WHERE ROWID = rec_.objid;       
      END IF;                            
   END LOOP;    
END Sync_Addr;


@UncheckedAccess
FUNCTION Check_Exist (
   company_    IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (Check_Exist___(company_, address_id_)) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Check_Exist;


@UncheckedAccess
FUNCTION Tax_Calc_Structure_Used (
   company_                IN VARCHAR2,
   tax_calc_structure_id_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_   NUMBER := 0;
   CURSOR check_exist IS
      SELECT 1
      FROM   company_address_tab
      WHERE  company               = company_
      AND    tax_calc_structure_id = tax_calc_structure_id_;
BEGIN
   OPEN  check_exist;
   FETCH check_exist INTO dummy_;
   IF (check_exist%FOUND) THEN      
      CLOSE check_exist;
      RETURN TRUE;
   ELSE
      CLOSE check_exist;
      RETURN FALSE;
   END IF;
END Tax_Calc_Structure_Used;


-- This method is to be used by Aurena
PROCEDURE New_Address (
   company_           IN VARCHAR2,
   address_id_        IN VARCHAR2,
   own_address_id_    IN VARCHAR2,
   within_city_limit_ IN VARCHAR2, 
   address1_          IN VARCHAR2,
   address2_          IN VARCHAR2,
   address3_          IN VARCHAR2,
   address4_          IN VARCHAR2,
   address5_          IN VARCHAR2,
   address6_          IN VARCHAR2,
   zip_code_          IN VARCHAR2,
   city_              IN VARCHAR2,
   state_             IN VARCHAR2,
   county_            IN VARCHAR2,
   country_           IN VARCHAR2,
   valid_from_        IN DATE,
   valid_to_          IN DATE,
   street_            IN VARCHAR2,
   house_no_          IN VARCHAR2,
   community_         IN VARCHAR2,
   district_          IN VARCHAR2 )
IS
   newrec_       company_address_tab%ROWTYPE;
BEGIN
   newrec_.company      := company_;
   newrec_.address_id   := address_id_;
   newrec_.ean_location := own_address_id_;
   newrec_.within_city_limit  := within_city_limit_;
   newrec_.address1     := address1_;
   newrec_.address2     := address2_;
   newrec_.address3     := address3_;
   newrec_.address4     := address4_;
   newrec_.address5     := address5_;
   newrec_.address6     := address6_; 
   newrec_.zip_code     := zip_code_;
   newrec_.city         := city_;
   newrec_.county       := county_;
   newrec_.state        := state_;
   newrec_.country      := Iso_Country_API.Encode(country_);
   newrec_.party_type   := 'COMPANY';
   newrec_.default_domain  := 'TRUE';
   newrec_.valid_from   := valid_from_;
   newrec_.valid_to     := valid_to_;
   newrec_.street       := street_;
   newrec_.house_no     := house_no_;
   newrec_.community    := community_;
   newrec_.district     := district_;
   New___(newrec_);
END New_Address;


-- This method is to be used by Aurena
PROCEDURE Modify_Address_Info (
   company_           IN VARCHAR2,
   address_id_        IN VARCHAR2,
   own_address_id_    IN VARCHAR2,
   within_city_limit_ IN VARCHAR2,
   address1_          IN VARCHAR2,
   address2_          IN VARCHAR2,
   address3_          IN VARCHAR2,
   address4_          IN VARCHAR2,
   address5_          IN VARCHAR2,
   address6_          IN VARCHAR2,
   zip_code_          IN VARCHAR2,
   city_              IN VARCHAR2,
   state_             IN VARCHAR2,
   county_            IN VARCHAR2,
   country_           IN VARCHAR2,   
   valid_from_        IN DATE,
   valid_to_          IN DATE )
IS
   newrec_       company_address_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(company_, address_id_);
   newrec_.ean_location := own_address_id_;
   newrec_.within_city_limit  := within_city_limit_;
   newrec_.address1     := address1_;
   newrec_.address2     := address2_;
   newrec_.address3     := address3_;
   newrec_.address4     := address4_;
   newrec_.address5     := address5_;
   newrec_.address6     := address6_; 
   newrec_.zip_code     := zip_code_;
   newrec_.city         := city_;
   newrec_.state        := state_;
   newrec_.county       := county_;
   newrec_.country      := Iso_Country_API.Encode(country_);
   newrec_.valid_from   := valid_from_;
   newrec_.valid_to     := valid_to_;
   Modify___(newrec_);
END Modify_Address_Info;


-- This method is to be used by Aurena
PROCEDURE Modify_Detailed_Address (
   company_    IN VARCHAR2,
   address_id_ IN VARCHAR2,
   street_     IN VARCHAR2,
   house_no_   IN VARCHAR2,
   community_  IN VARCHAR2,
   district_   IN VARCHAR2 )
IS
   newrec_       company_address_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(company_, address_id_);
   newrec_.street       := street_;
   newrec_.house_no     := house_no_;
   newrec_.community    := community_;
   newrec_.district     := district_;   
   Modify___(newrec_);
END Modify_Detailed_Address;
