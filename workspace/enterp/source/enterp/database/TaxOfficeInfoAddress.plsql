-----------------------------------------------------------------------------
--
--  Logical unit: TaxOfficeInfoAddress
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030128  Machlk  Created.
--  030916  Gepelk  IID ARFI124N. Add procedure Validate_Address
--  100113  Umdolk  Refactoring in Communication methods in Enterprise.
--  100622  Samblk  Bug 90960, Modified Validate_Address to support given test case
--  110810  Shdilk  FIDEAGLE-1323, Modidied view TAX_OFFICE_INFO_ADDRESS
--  120328  Hiralk  EASTRTM-3059, Merged Bug 101459.
--  121003  Hecolk  Bug 102095, Merged from APP75 - Modified Unpack_Check_Update__
--  141122  AmThlk  Added Get_Default_Address(),Is_Type_Default() to validate default_address_type 
--  150220  Dihelk  PRFI-4712, Corrected the address handling to tally with customer's and supplier's
--  160307  DipeLK  STRLOC-247,Removed Validate_Address() method.
--  160419  reanpl  STRLOC-355, Added handling of new attributes address3, address4, address5, address6, removed New_Address, Modify_Address
--  160505  ChguLK  STRCLOC-369, Renamed the package name to Address_Setup_API.
--  181129  thjilk  Modified Check_Delete___ to validate Address Types
--  181130  thjilk  Added method Modify_Detailed_Address 
--  210325  kugnlk  FI21R2-451, Get rid of string manipulations in db - Modified Modify_Detailed_Address method
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     tax_office_info_address_tab%ROWTYPE,
   newrec_ IN OUT tax_office_info_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   validation_result_   VARCHAR2(5);
   validation_flag_     VARCHAR2(5);   
   CURSOR get_address_types(tax_office_id_ IN VARCHAR2, address_id_ IN VARCHAR2) IS
      SELECT t.rowid, t.tax_office_id, t.tax_office_addr_type_code, t.def_address, Tax_Office_Addr_Type_Code_API.Decode(t.tax_office_addr_type_code) AS address_type_code
      FROM   tax_office_addr_type_tab t
      WHERE  t.tax_office_id = tax_office_id_
      AND    t.address_id = address_id_;      
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
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
   -- Check if connected address types still are valid according to modified date periods.
   IF (NVL(newrec_.valid_from, Database_Sys.Get_First_Calendar_Date()) != NVL(oldrec_.valid_from, Database_Sys.Get_First_Calendar_Date())) OR 
      (NVL(newrec_.valid_to, Database_Sys.Get_Last_Calendar_Date()) != NVL(oldrec_.valid_to, Database_Sys.Get_Last_Calendar_Date())) THEN 
      FOR c1 IN get_address_types(newrec_.tax_office_id, newrec_.address_id) LOOP
         Tax_Office_Addr_Type_API.Check_Def_Address_Exist(validation_result_, 
                                                          validation_flag_, 
                                                          c1.tax_office_id, 
                                                          c1.def_address, 
                                                          c1.tax_office_addr_type_code, 
                                                          c1.rowid, 
                                                          newrec_.valid_from, 
                                                          newrec_.valid_to);
         IF (c1.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
            Client_SYS.Add_Warning(lu_name_, 'DEFADDEXIST1: A default address ID already exists for :P1 Address Type for this time period. Do you want to set the current address ID as default instead?', c1.address_type_code);
         END IF;
      END LOOP;
   END IF;
END Check_Common___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     tax_office_info_address_tab%ROWTYPE,
   newrec_ IN OUT tax_office_info_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   detailed_address_   Enterp_Address_Country_Tab.detailed_address%TYPE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   detailed_address_ := Enterp_Address_Country_API.Get_Detailed_Address(newrec_.country);
   IF (detailed_address_ = 'TRUE') THEN
      IF (NVL(oldrec_.street, 'DUMMY') <> NVL(newrec_.street, 'DUMMY') OR NVL(oldrec_.house_no, 'DUMMY') <> NVL(newrec_.house_no, 'DUMMY')) THEN
         newrec_.address1 := SUBSTR((newrec_.street || ' ' || newrec_.house_no),0,35);
      END IF;
   END IF;
END Check_Update___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     tax_office_info_address_tab%ROWTYPE,
   newrec_     IN OUT tax_office_info_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS 
   validation_result_   VARCHAR2(5);
   validation_flag_     VARCHAR2(5);   
   CURSOR get_address_types(tax_office_id_ IN VARCHAR2, address_id_ IN VARCHAR2) IS
      SELECT t.rowid, t.tax_office_id, t.tax_office_addr_type_code, t.def_address
      FROM   tax_office_addr_type_tab t
      WHERE  t.tax_office_id = tax_office_id_
      AND    t.address_id = address_id_;   
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Logic to remove address default flag on other address IDs if time period overlaps.
   IF (NVL(newrec_.valid_from, Database_Sys.Get_First_Calendar_Date()) != NVL(oldrec_.valid_from, Database_Sys.Get_First_Calendar_Date())) OR 
      (NVL(newrec_.valid_to, Database_Sys.Get_Last_Calendar_Date()) != NVL(oldrec_.valid_to, Database_Sys.Get_Last_Calendar_Date())) THEN 
      FOR c1 IN get_address_types(newrec_.tax_office_id, newrec_.address_id) LOOP
         Tax_Office_Addr_Type_API.Check_Def_Address_Exist(validation_result_, 
                                                          validation_flag_, 
                                                          c1.tax_office_id, 
                                                          c1.def_address, 
                                                          c1.tax_office_addr_type_code, 
                                                          c1.rowid, 
                                                          newrec_.valid_from, 
                                                          newrec_.valid_to);
         IF (c1.def_address = 'TRUE' AND (validation_result_ = 'FALSE')) THEN
            Tax_Office_Addr_Type_API.Check_Def_Addr_Temp(c1.tax_office_id, 
                                                         c1.tax_office_addr_type_code, 
                                                         c1.def_address,
                                                         c1.rowid, 
                                                         newrec_.valid_from, 
                                                         newrec_.valid_to);
         END IF;
      END LOOP;
   END IF;
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN tax_office_info_address_tab%ROWTYPE )
IS
   addr_type_code_list_     VARCHAR2(2000);
   addr_type_count_         NUMBER;
   validation_result_       VARCHAR2(5);
   validation_flag_         VARCHAR2(5);
   counter_                 NUMBER := 1;
   info_str_                VARCHAR2(2000);
   CURSOR get_address_types (tax_office_id_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT *
      FROM   tax_office_addr_type
      WHERE  tax_office_id = tax_office_id_
      AND    address_id = address_id_;
   CURSOR get_def_address_types_count (tax_office_id_ VARCHAR2, address_id_ VARCHAR2) IS
      SELECT COUNT(*)
      FROM   tax_office_addr_type
      WHERE  tax_office_id = tax_office_id_
      AND    address_id = address_id_
      AND    def_address = 'TRUE';
BEGIN
   OPEN get_def_address_types_count(remrec_.tax_office_id, remrec_.address_id);
   FETCH get_def_address_types_count INTO addr_type_count_;
   CLOSE get_def_address_types_count;
   FOR rec_ IN get_address_types(remrec_.tax_office_id, remrec_.address_id) LOOP
      Tax_Office_Addr_Type_API.Check_Def_Address_Exist(validation_result_, validation_flag_, rec_.tax_office_id, rec_.def_address, rec_.tax_office_addr_type_code_db, rec_.objid, remrec_.valid_from, remrec_.valid_to);
      IF ((validation_result_ = 'TRUE') AND (rec_.def_address = 'TRUE')) THEN
         IF ((counter_ = 1)  AND (addr_type_count_ > 1)) THEN
            addr_type_code_list_ := CONCAT(rec_.tax_office_addr_type_code, ', ');
         ELSIF (counter_ = addr_type_count_) THEN
            addr_type_code_list_ := CONCAT(addr_type_code_list_, CONCAT(rec_.tax_office_addr_type_code, ''));
         ELSE
            addr_type_code_list_ := CONCAT(addr_type_code_list_, CONCAT(rec_.tax_office_addr_type_code, ', '));
         END IF;
         counter_ := counter_ + 1;
      END IF;
   END LOOP;
   IF (addr_type_code_list_ IS NOT NULL) THEN
      Client_SYS.Add_Warning(lu_name_, 'REMOVEADDRWITHDEFADDRTYPES: This is the default :P1 Address Type(s) for Tax Office :P2. If removed, there will be no default address for this Address Type(s).', addr_type_code_list_, remrec_.tax_office_id);
   END IF;
   info_str_ := Client_SYS.Get_All_Info();
   super(remrec_);
   Client_SYS.Clear_Info();
   Client_SYS.Merge_Info(info_str_);     
END Check_Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ tax_office_info_address_tab%ROWTYPE;
BEGIN
   IF (action_ = 'DO') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Cascade_Delete_Comm_Method__(remrec_.tax_office_id, remrec_.address_id);
   END IF;
   super(info_, objid_, objversion_, action_); 
END Remove__;


PROCEDURE Cascade_Delete_Comm_Method__ (
   tax_office_id_ IN VARCHAR2,
   address_id_    IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   CURSOR getrec IS
      SELECT objid, objversion
      FROM   tax_info_comm_method
      WHERE  tax_office_id = tax_office_id_
      AND    address_id = address_id_;
BEGIN
   OPEN getrec;
   FETCH getrec INTO objid_, objversion_;
   WHILE getrec%FOUND LOOP
      Comm_Method_API.Remove__(info_, objid_, objversion_, 'DO');
      FETCH getrec INTO objid_, objversion_;
   END LOOP;
   CLOSE getrec;
END Cascade_Delete_Comm_Method__;
                   
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Default_Address (
   tax_office_id_     IN VARCHAR2,
   address_id_        IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   curr_date_         IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
BEGIN
   RETURN NULL;
END Get_Default_Address;


FUNCTION Get_Default_Address (
   tax_office_id_     IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   curr_date_         IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
   CURSOR get_def_address IS
      SELECT address_id
      FROM   tax_office_info_address
      WHERE  tax_office_id = tax_office_id_
      AND    curr_date_ BETWEEN NVL(valid_from, Database_SYS.Get_First_Calendar_Date()) AND NVL(valid_to, Database_SYS.Get_Last_Calendar_Date());
BEGIN
   FOR t IN get_def_address LOOP
      IF (Tax_Office_Addr_Type_API.Is_Default(tax_office_id_, t.address_id, address_type_code_) = 'TRUE') THEN
         RETURN t.address_id;
      END IF;
   END LOOP;
   RETURN NULL;
END Get_Default_Address;


-- This method is to be used by Aurena
PROCEDURE Modify_Detailed_Address (
   tax_office_id_  IN VARCHAR2,
   address_id_     IN VARCHAR2,
   street_         IN VARCHAR2,
   house_no_       IN VARCHAR2,
   community_      IN VARCHAR2,
   district_       IN VARCHAR2 )
IS
   newrec_       tax_office_info_address_tab%ROWTYPE;
   new_address1_ VARCHAR2(2000); 
BEGIN
   new_address1_ := CONCAT(street_, CONCAT(' ', house_no_));
   newrec_ := Get_Object_By_Keys___(tax_office_id_, address_id_);
   newrec_.address1  := new_address1_;
   newrec_.street    := street_;
   newrec_.house_no  := house_no_;
   newrec_.community := community_;
   newrec_.district  := district_;
   Modify___(newrec_);
END Modify_Detailed_Address;

