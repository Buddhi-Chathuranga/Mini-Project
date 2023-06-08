-----------------------------------------------------------------------------
--
--  Logical unit: SupplierInfo
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150811  RasDlk  Bug 120366, Replaced the SUPPLIER_INFO_VAT view from the table in the Validate_One_Time_Supplier__ procedure.
--  981123  Camk    Created
--  981202  Camk    Check on Association No added.
--  990125  Camk    Our_Id removed.
--  990416  Maruse  New template
--  990811  Lisv    Rewrighted the procedure Copy_Details___. Added company as parameter.
--                  Now check in a table which procedures to run when copying a supplier.
--  990820  BmEk    Removed Error_SYS.Check_Not_Null in Unpack_Check_Insert___ for supplier_id.
--                  Added a control in Insert___ instead, to check if supplier_id is null. This
--                  because it should be possible to fetch an automatic generated supplier_id
--                  from LU PartyIdentitySeries. Also added the procedure Get_Identity___.
--  991011  Camk    Copy_Existing_Supplier method without company added for
--                  backward compatibility.
--  991109  BmEk    Call #27527. Renamed Copy_Existing_Supplier to Copy_Existing_Supplier_Inv.
--  000120  Mnisse  New field, Suppliers_Own_Id
--  000128  Mnisse  Check on capital letters for ID, bug #30596.
--  000221  Camk    New public method Get_Supplier_By_Own_Id added.
--  000306  Camk    Bug# 14896 Corrected.
--  000525  LiSv    Removed call to Check_If_Null___ (this is an old solution).
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  001003  Camk    Call #49359 Corrected. Fetch automatic supplier_id when copy customer.
--  010308  JeGu    Bug #20475, New functions: Get_Default_Language_Code, Get_Country_Code
--  010504  Inkase  Bug #20229, Added check if entered country or language is 2 characters,
--                  then save it, else encode it. Also set uppercase on country.
--  021121  hecolk  IID ITFI135N. Added Calls to VALIDATION_PER_COMPANY_API.Validate_Association_Number in Unpack_Check_Insert___ and Unpack_Check_Update___
--  021121          Comments are added to top following Programing Standards.
--  030407  NiKaLK  Added View Multi_Supplier_Info
--  030411  NiKaLK  Removed view Multi_Supplier_Info
--  030918  SaAblk  New section at the bottom of the package to create procedure Create_Supplier_Info_All
--  030918  SaAblk  Moved Create_Supplier_Info_All into the package.
--  040226  Thsrlk  FIPR404A2 - Introduced Micro cash to improve performance.
--  040804  LOKrLK  B116242 - Modified Update_Cache___
--  040804  Jeguse  IID FIJP335. Added column Identifier_Reference and functions for this column.
--  041004  SAAHLK  LCS Patch Merge, Bug 37877.
--  041110  AnGiSe  B119544 - Added parameters in copy_existing_supplier_inv.
--  050304  ShSaLk  Added a view comment to the view supplier_information_all.
--  050411  Prdilk  LCS Patch Merge-Bug 48971, Modified get_copying_info cursor with ORDER BY
--  050919  Hecolk  LCS Merge - Bug 52720, Added FUNCTION Get_Next_Identity and Removed PROCEDURE Get_Identity___
--  060306  Gadalk  B133575 Changes in SUPPLIER_INFO view, Restriction added for coporate_form (Form Of Business)
--  060320  Hapulk  Removed method Create_Supplier_Info_All.
--  060824  Csenlk  LCS Merge 57393,Corrected.Modified Insert___ to increase the next value in Identity Series by one
--  070709  Shsalk  B146478 Corrected accoding to a request from SDMAN module.
--  070829  Chodlk  Added VIEW comments TO default_language_db column.
--  071207  Sacalk  Bug 67508, Added method Get_Identity_From_Asso_No
--  090512  Kanslk  Bug 82240, Modified 'Update__()' and introduced constant 'inst_docman_'.
--  090518  Mohrlk  Bug 81269, Modified Copy_Details___ and introduced constant 'inst_copy_supplier_'. 
--  091204  Kanslk  Reverse-Engineering, removed country_db from reference of corporate_form
--  100113  Umdolk  Refactoring in Communication methods in Enterprise.
--  100701  Kanslk  EANE-2558, modified view SUPPLIER_INFO by adding country_db to the view comments.
--  100716  Paralk  EANE-2930, Corrected in Copy_Details___()
--  110120  RUFELK  RAVEN-1493, Removed use of Validation_Per_Company_API.
--  110131  MUSHLK  BP-4040, Added code for the newly added column Picture_Id.
--  130614  DipeLK  TIBE-726, Removed global variables which are used to check exsistance of DOCMAN,PURCH.
--  130118  SALIDE  EDEL-1996, Added one_time and modified Copy_Existing_Supplier() and Copy_Details___()
--  131024  Isuklk  PBFI-1205 Refactoring in SupplierInfo.entity
--  140725  Hecolk  PRFI-41, Moved code that generates Supplier Id from Check_Insert___ to Insert___ 
--  141115  Chhulk  PRFI-3496, Merged bug 119562. Modified Copy_Details___()
--  150427  SudJlk  ORA-108, Modified Check_Delete___ to manually validate existence of Business Activity for the supplier.
--  150528  RoJalk  ORA-498, Modified Insert___ and assigned a value for rowtype. 
--  150602  RoJalk  ORA-499, Replaced Supplier_Info_API.Get_Party with Supplier_Info_General_API.Get_Party.
--  150608  RoJalk  ORA-501, Modified Check_Delete___, Check_Update___, Update___, Insert___, Prepare_Insert___, Check_Common___ and  
--                  moved the common logic for Supplier_Info_API and Supplier_Info_Prospect_APIto Supplier_Info_General_API 
--  150610  RoJalk  ORA-501, Moved the method Validate_One_Time_Supplier__ from Supplier_Info_API to Supplier_Info_General_API.
--  150611  RoJalk  ORA-501, Called  Supplier_Info_General_API.Set_Default_Value_Rec from Check_Common___. Kept Validate_One_Time_Supplier__
--                  in Supplier_Info_API since the functionality is only applicable to suppliers.
--  150616  RoJalk  ORA-758, Modified Check_Insert___ and assigned a defualt value for newrec_.supplier_category if null. 
--  150617  RoJalk  ORA-656, Included the New___ method within New public interface. Moved Copy_Existing_Supplier_Inv and Copy_Details___
--                  to Supplier_Info_General_API since it is common to both suppliers and prospects.
--  150619  RoJalk  ORA-755, Added code to override the standard error message in Raise_Record_Not_Exist___.
--  150717  RoJalk  ORA-1033, Modified Check_Delete___, Delete___ to handle validations and cascade 
--  150717          deletion connected to SupplierInfoGeneral.
--  150804  MaIklk  BLU-1135, Added Fetch_Supplier_By_Name().
--  150811  RoJalk  ORA-1179, Added method Create_Supplier__.
--  150811  RoJalk  ORA-1179, Called Supplier_Info_General_API.Validate_Create_Supplier from Check_Insert___.
--  150821  RoJalk  ORA-1214, Called Supplier_Info_General_API.Pre_Delete_Actions from Delete___.
--  150825  MaIklk  AFT-1961, Added Get_Last_Modified().
--  150826  RoJalk  AFT-1660, Called Validate_Check_Insert with common validations from Check_Insert___.
--  151007  PRatlk  STRFI-21, Removed method Get_Supplier_From_Asso_No.
--  161201  Waudlk  STRFI-1944, Added method Get_Id_From_Association_No, it will be used when external payments for supplier is done.
--  191003  NiDalk  SCXTEND-724, Added Rm_Dup_Insert___, Rm_Dup_Delete___ and Rm_Dup_Update___ to update rm_dup_search_tab and 
--  191003          rm_dup_search_comm_method_tab with Supplier related information. Called them from Insert___, Delete___ and Update___.
--  191025  NipKlk  SCXTEND-921, Added default null parameters country_ and default_language_ to method New() and added them to attr_.
--  200327  JanWse  SCXTEND-1815, Added Pack_Table as a public version of Pack_Table___
--  200327          and modified Rm_Dup_Update___ to include all values for SupplierInfoContact
--  200824  Hairlk  SCTA-8074, Removed Supplier_Info_API.Create_Supplier__ since its not used anymore.
--  210325  kugnlk  FI21R2-451, Get rid of string manipulations in db - Modified methods New and Modify
--  210721  NaLrlk  PR21R2-401, Added Modify_Supplier() to update a supplier record.
--  210817  NaLrlk  PR21R2-589, Removed NOCOPY from IN OUT parameters in Modify_Supplier().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE string_suppliers IS TABLE OF VARCHAR2(20)
INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   supplier_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, 'RECNOTEX: Supplier :P1 is not of category Supplier.', supplier_id_);
   super(supplier_id_);
END Raise_Record_Not_Exist___;


@Override
PROCEDURE Update_Cache___ (
   supplier_id_ IN VARCHAR2 )
IS  
BEGIN
   IF (micro_cache_value_.name IS NULL) THEN
      Invalidate_Cache___;
   END IF;
   super(supplier_id_);
END Update_Cache___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     supplier_info_tab%ROWTYPE,
   newrec_ IN OUT supplier_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN 
   Supplier_Info_General_API.Validate_Common(oldrec_, newrec_);
   Supplier_Info_General_API.Set_Default_Value_Rec(newrec_);
   $IF NOT Component_Payled_SYS.INSTALLED $THEN
      IF (newrec_.one_time = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'ONETIMENTALLWDPAYS: The One-Time check box for supplier :P1 cannot be set because the component PAYLED is not active.', newrec_.supplier_id);
      END IF;
   $END
   IF (newrec_.one_time = 'TRUE' AND newrec_.b2b_supplier = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'ONETIMEB2BSUPP: A One-Time supplier cannot be a B2B supplier.');
   END IF;
   IF (oldrec_.one_time != newrec_.one_time) THEN
      Validate_One_Time_Supplier__(newrec_.supplier_id);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Supplier_Info_General_API.Add_Default_Values(attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT supplier_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Supplier_Info_General_API.Pre_Insert_Actions(newrec_, attr_);
   newrec_.rowtype := lu_name_;
   super(objid_, objversion_, newrec_, attr_);
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Insert___(newrec_);
   $END
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     supplier_info_tab%ROWTYPE,
   newrec_     IN OUT supplier_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Supplier_Info_General_API.Post_Update_Actions(objid_, oldrec_, newrec_);
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Update___(newrec_);
   $END
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT supplier_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS     
BEGIN
   Supplier_Info_General_API.Validate_Create_Supplier;
   IF (newrec_.supplier_category IS NULL) THEN
      newrec_.supplier_category := 'SUPPLIER';
   END IF; 
   Supplier_Info_General_API.Validate_Check_Insert(newrec_);
   super(newrec_, indrec_, attr_);      
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     supplier_info_tab%ROWTYPE,
   newrec_ IN OUT supplier_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS      
BEGIN     
   IF (oldrec_.supplier_category != newrec_.supplier_category) THEN
      Error_SYS.Record_General(lu_name_, 'SUPCATCHGNOTALLOW: It is not possible to change the category of the supplier from :P1 to :P2.', Supplier_Info_Category_API.Decode(oldrec_.supplier_category), Supplier_Info_Category_API.Decode(newrec_.supplier_category));
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   Supplier_Info_General_API.Validate_Update(newrec_);
   IF (oldrec_.b2b_supplier = 'TRUE' AND newrec_.b2b_supplier = 'FALSE' AND B2b_User_Util_API.Supplier_Users_Exists(newrec_.supplier_id)) THEN
      Error_SYS.Record_General(lu_name_, 'B2BCUUSERXIST: There are Users connected to Supplier :P1. B2B Supplier must not be unchecked.', newrec_.supplier_id);
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN supplier_info_tab%ROWTYPE)
IS
BEGIN
   Supplier_Info_General_API.Validate_Delete(remrec_);
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN supplier_info_tab%ROWTYPE )
IS
BEGIN
   Supplier_Info_General_API.Pre_Delete_Actions(remrec_);
   super(objid_, remrec_);
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Delete___(remrec_);
   $END
END Delete___;


PROCEDURE Rm_Dup_Insert___ (
   rec_  IN supplier_info_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Insert(lu_name_, attr_);
   $ELSE
      NULL;
   $END
END Rm_Dup_Insert___;


PROCEDURE Rm_Dup_Update___ (
   rec_  IN supplier_info_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Update(lu_name_, attr_);
      -- Update contact information
      FOR contact_rec_ IN (SELECT * FROM supplier_info_contact_tab WHERE supplier_id = rec_.supplier_id) LOOP
         attr_ := Supplier_Info_Contact_API.Pack_Table(contact_rec_);
         Rm_Dup_Util_API.Search_Table_Update('SupplierInfoContact', attr_);
      END LOOP;
   $ELSE 
      NULL;
   $END
END Rm_Dup_Update___;


PROCEDURE Rm_Dup_Delete___ (
   rec_  IN supplier_info_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Delete(lu_name_, attr_);
   $ELSE 
      NULL;
   $END
END Rm_Dup_Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Validate_One_Time_Supplier__ (
   supplier_id_ IN VARCHAR2 )
IS
   one_time_not_allowed EXCEPTION;
   temp_                VARCHAR2(1000);
   error_info_          VARCHAR2(100);
   $IF Component_Invoic_SYS.INSTALLED $THEN
      CURSOR is_exist_inv IS
         SELECT 1
         FROM   invoice 
         WHERE  identity = supplier_id_
         AND    party_type_db = 'SUPPLIER';
   $END
   $IF Component_Payled_SYS.INSTALLED $THEN
      CURSOR is_exist_ledg IS
         SELECT 1
         FROM   ledger_item 
         WHERE  identity = supplier_id_
         AND    party_type_db = 'SUPPLIER';
      CURSOR is_exist_pay IS
         SELECT other_payee_identity || DECODE(netting_allowed, 'FALSE', NULL, netting_allowed)
         FROM   identity_pay_info 
         WHERE  identity = supplier_id_
         AND    party_type_db = 'SUPPLIER';
   $END
   $IF Component_Purch_SYS.INSTALLED $THEN
      CURSOR is_exist_pur IS
         SELECT 1
         FROM   supplier_ent
         WHERE  supplier_id = supplier_id_;
      CURSOR is_exist_pur_addr IS
         SELECT 1
         FROM   supplier_address_ent
         WHERE  supplier_id = supplier_id_;
   $END
BEGIN
   $IF Component_Invoic_SYS.INSTALLED $THEN
      -- normal invoice
      OPEN  is_exist_inv;
      FETCH is_exist_inv INTO temp_;
      IF (is_exist_inv%FOUND) THEN
         error_info_ := Language_SYS.Translate_Constant(lu_name_, 'ONEERRINV: Invoice');
         RAISE one_time_not_allowed;
      END IF;
      CLOSE is_exist_inv;
   $ELSE
      NULL;   
   $END
   $IF Component_Payled_SYS.INSTALLED $THEN
      -- on account ledger
      OPEN  is_exist_ledg;
      FETCH is_exist_ledg INTO temp_;
      IF (is_exist_ledg%FOUND) THEN
         error_info_ := Language_SYS.Translate_Constant(lu_name_, 'ONEERRLEDG: Ledger Item');
         RAISE one_time_not_allowed;
      END IF;
      CLOSE is_exist_ledg;
      -- other payee info
      temp_ := NULL;
      OPEN  is_exist_pay;
      FETCH is_exist_pay INTO temp_;
      CLOSE is_exist_pay;
      IF (temp_ IS NOT NULL) THEN
         error_info_ := Language_SYS.Translate_Constant(lu_name_, 'ONEERRPAY: Payment');
         RAISE one_time_not_allowed;
      END IF;
   $ELSE
      NULL;   
   $END
   $IF Component_Purch_SYS.INSTALLED $THEN
      OPEN  is_exist_pur;
      FETCH is_exist_pur INTO temp_;
      IF (is_exist_pur%FOUND) THEN
         error_info_ := Language_SYS.Translate_Constant(lu_name_, 'ONEERRPRCH: Purchasing');
         RAISE one_time_not_allowed;
      END IF;
      CLOSE is_exist_pur;
      OPEN  is_exist_pur_addr;
      FETCH is_exist_pur_addr INTO temp_;
      IF (is_exist_pur_addr%FOUND) THEN
         error_info_ := Language_SYS.Translate_Constant(lu_name_, 'ONEERRPRCHADDR: Purchase Address Info');
         RAISE one_time_not_allowed;
      END IF;
      CLOSE is_exist_pur_addr;
   $ELSE
      NULL;   
   $END
EXCEPTION
   WHEN one_time_not_allowed THEN
      Error_SYS.Record_General(lu_name_, 'ONETIMENTALLWDSUP: The One-Time check box for supplier :P1 cannot be modified due to the existing information in :P2.', supplier_id_, error_info_);
END Validate_One_Time_Supplier__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Id_From_Reference (
   identifier_reference_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   supplier_id_   supplier_info_tab.supplier_id%TYPE;
   CURSOR get_id IS
      SELECT supplier_id
      FROM   supplier_info_tab
      WHERE  identifier_reference = identifier_reference_;
BEGIN
   OPEN  get_id;
   FETCH get_id INTO supplier_id_;
   IF (get_id%NOTFOUND) THEN
      supplier_id_ := NULL;
   END IF;
   CLOSE get_id;
   RETURN supplier_id_;
END Get_Id_From_Reference;


@UncheckedAccess
FUNCTION Get_Doc_Object_Description (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_description_    VARCHAR2(122);
   CURSOR get_obj_description IS
      SELECT supplier_id||'-'||name description
      FROM   supplier_info_tab
      WHERE  supplier_id = supplier_id_;
BEGIN
   OPEN get_obj_description;
   FETCH get_obj_description INTO obj_description_;
   IF (get_obj_description%NOTFOUND) THEN
      CLOSE get_obj_description;
      RETURN Language_SYS.Translate_Constant(lu_name_, 'NODOCDESC: No description available');
   END IF;
   CLOSE get_obj_description;
   RETURN obj_description_;
END Get_Doc_Object_Description;


@UncheckedAccess
FUNCTION Check_Exist (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(supplier_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE New (
   supplier_id_      IN VARCHAR2,
   name_             IN VARCHAR2,
   association_no_   IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       supplier_info_tab%ROWTYPE;
BEGIN
   newrec_.creation_date             := trunc(SYSDATE);
   newrec_.party_type                := Party_Type_API.DB_SUPPLIER;
   newrec_.default_domain            := 'TRUE';
   newrec_.identifier_ref_validation := 'NONE';
   newrec_.one_time                  := Fnd_Boolean_API.DB_FALSE;
   newrec_.b2b_supplier              := Fnd_Boolean_API.DB_FALSE;
   newrec_.supplier_id               := supplier_id_;
   newrec_.name                      := name_;
   newrec_.association_no            := association_no_;
   newrec_.country                   := Iso_Country_API.Encode(country_);
   newrec_.default_language          := Iso_Language_API.Encode(default_language_);
   New___(newrec_);
END New;


PROCEDURE Modify (
   supplier_id_      IN VARCHAR2,
   name_             IN VARCHAR2 DEFAULT NULL,
   association_no_   IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       supplier_info_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(supplier_id_);
   newrec_.name               := name_;
   newrec_.association_no     := association_no_;
   newrec_.country            := Iso_Country_API.Encode(country_);
   newrec_.default_language   := Iso_Language_API.Encode(default_language_);
   Modify___(newrec_);
END Modify;


PROCEDURE Remove (
   supplier_id_ IN VARCHAR2 )
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
   remrec_      supplier_info_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, supplier_id_);
   remrec_ := Lock_By_Keys___(supplier_id_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


PROCEDURE New (
   newrec_ IN OUT supplier_info_tab%ROWTYPE )
IS      
BEGIN      
   New___(newrec_); 
END New;   


@UncheckedAccess
FUNCTION Get_Supplier_By_Own_Id (
   suppliers_own_id_ IN VARCHAR2 ) RETURN string_suppliers
IS
   supplier_array_ string_suppliers;
   index_no_ NUMBER := 0;
   CURSOR get_supplier IS
      SELECT supplier_id
      FROM   supplier_info_tab
      WHERE  suppliers_own_id = suppliers_own_id_;
BEGIN
   FOR i IN get_supplier LOOP
      supplier_array_(index_no_) := i.supplier_id;
      index_no_ := index_no_ + 1;
   END LOOP;
   RETURN supplier_array_;
END Get_Supplier_By_Own_Id;


-- This will be used to fetch the supplier using the name
-- in CCTI integration.
FUNCTION Fetch_Supplier_By_Name (
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   supplier_id_ supplier_info_tab.supplier_id%TYPE;   
   CURSOR get_supp IS
      SELECT supplier_id 
      FROM   supplier_info_tab
      WHERE  name = name_;  
BEGIN
   OPEN get_supp;
   FETCH get_supp INTO supplier_id_;
   CLOSE get_supp;
   RETURN supplier_id_;
END Fetch_Supplier_By_Name;


-- This will be used to fetch the rowversion
-- in CCTI integration.
@UncheckedAccess
FUNCTION Get_Last_Modified (
   supplier_id_ IN VARCHAR2 ) RETURN DATE
IS
   last_modified_    DATE;
   CURSOR get_last_modified IS
      SELECT rowversion
      FROM   supplier_info_tab
      WHERE  supplier_id = supplier_id_;
BEGIN
   OPEN get_last_modified;
   FETCH get_last_modified INTO last_modified_;
   CLOSE get_last_modified;   
   RETURN last_modified_; 
END Get_Last_Modified;


@UncheckedAccess
FUNCTION Get_Id_From_Association_No (
   association_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   supplier_id_   supplier_info_tab.supplier_id%TYPE;
   CURSOR get_id IS
      SELECT supplier_id
      FROM   supplier_info_tab
      WHERE  association_no = association_no_;
BEGIN
   OPEN  get_id;
   FETCH get_id INTO supplier_id_;
   IF (get_id%NOTFOUND) THEN
      supplier_id_ := NULL;
   END IF;
   CLOSE get_id;
   RETURN supplier_id_;
END Get_Id_From_Association_No;


@UncheckedAccess
FUNCTION Is_B2b_Supplier (
   supplier_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   is_b2b_ supplier_info_tab.b2b_supplier%TYPE;
   CURSOR get_b2b(id_ IN VARCHAR2) IS
      SELECT b2b_supplier
      FROM   supplier_info_tab
      WHERE  supplier_id = id_;    
BEGIN
   OPEN get_b2b(supplier_id_);
   FETCH get_b2b INTO is_b2b_;
   CLOSE get_b2b;
   RETURN NVL(is_b2b_,'FALSE') = 'TRUE';
END Is_B2b_Supplier;


-- This functions is used when pumping data for duplication check
FUNCTION Pack_Table (
   rec_  IN supplier_info_tab%ROWTYPE ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      RETURN Pack_Table___(rec_);
   $ELSE
      RETURN NULL;
   $END
END Pack_Table;


-- Modify_Supplier
--   Public interface to modify a record by sending changed values in an attr_.
@IgnoreUnitTest DMLOperation
PROCEDURE Modify_Supplier (
   attr_        IN OUT VARCHAR2,
   supplier_id_ IN     VARCHAR2 )
IS
   indrec_     Indicator_Rec;
   newrec_     supplier_info_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(supplier_id_);
   Unpack___(newrec_, indrec_, attr_);
   Modify___(newrec_);
END Modify_Supplier;