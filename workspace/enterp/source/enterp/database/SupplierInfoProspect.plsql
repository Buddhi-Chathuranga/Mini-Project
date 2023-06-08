-----------------------------------------------------------------------------
--
--  Logical unit: SupplierInfoProspect
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150528  RoJalk  ORA-499, Created.
--  150608  RoJalk  ORA-501, Added the overrides for the methods Check_Common___, Prepare_Insert___,  
--  150608          Insert___, Update___,  Check_Insert___, Check_Update___ and  Check_Delete___. 
--  150611  RoJalk  ORA-501, Called  Supplier_Info_General_API.Set_Default_Value_Rec from Check_Common___.  
--                  Included a validation in Check_Common___ to prevent one time suppliers. 
--  150616  RoJalk  Modified Check_Insert___ and assigned a defualt value for newrec_.supplier_category if null.
--  150617  RoJalk  ORA-656, Included the New___ method within New public interface.
--  150619  RoJalk  ORA-755, Added code to override the standard error message in Raise_Record_Not_Exist___.
--  150702  RoJalk  ORA-778, Added the method Change_Supplier_Category.
--  150717  RoJalk  ORA-1033, Modified Check_Delete___, Delete___ to handle validations and cascade 
--  150717          deletion connected to SupplierInfoGeneral.
--  150811  RoJalk  ORA-1179, Called Supplier_Info_General_API.Validate_Create_Supplier from Check_Update___ .
--  150814  RoJalk  ORA-1197, Added New() with method with parameters supplier_id, name and association_no.
--  150819  RoJalk  ORA-1196, Added the parameter country_ to New.
--  150820  RoJalk  ORA-1242, Modified New method and changed the supplier_id_ to return a value.
--  150821  RoJalk  ORA-1214, Called Supplier_Info_General_API.Pre_Delete_Actions from Delete___.
--  150826  RoJalk  AFT-1660, Called Validate_Check_Insert with common validations from Check_Insert___.
--  180207  MaAuse  STRSC-15652, Modifed New by adding parameter default_language_.
--  191113  NiDalk  SCXTEND-724, Added Rm_Dup_Insert___, Rm_Dup_Delete___ and Rm_Dup_Update___ to update rm_dup_search_tab and 
--  191113          rm_dup_search_comm_method_tab with Supplier related information. Called them from Insert___, Delete___ and Update___.
--  210325  kugnlk  FI21R2-451, Get rid of string manipulations in db - Modified New and Change_Supplier_Category__ method.
--  210728  LaDelk  PR21R2-529, Modified Check_Common___ and Check_Update___ to enable B2B for prospects.
--  210806  NaLrlk  PR21R2-589, Added Modify() to update a supplier record.
--  210817  NaLrlk  PR21R2-589, Removed NOCOPY from IN OUT parameters in Modify().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   supplier_id_ IN     VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, 'RECNOTEXIST: Supplier :P1 is not of category Prospect.', supplier_id_);
   super(supplier_id_);
END Raise_Record_Not_Exist___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     supplier_info_tab%ROWTYPE,
   newrec_ IN OUT supplier_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN  
   Supplier_Info_General_API.Validate_Common(oldrec_, newrec_);
   IF (newrec_.one_time = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'ONETIMESUPCATEG: The One-Time check box cannot be set for a supplier with category :P1.', Supplier_Info_Category_API.Decode(Supplier_Info_Category_API.DB_PROSPECT));
   END IF; 
   Supplier_Info_General_API.Set_Default_Value_Rec(newrec_);
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
   IF (newrec_.supplier_category IS NULL) THEN
      newrec_.supplier_category := 'PROSPECT';
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
   IF ((oldrec_.supplier_category != newrec_.supplier_category) AND (newrec_.supplier_category = Supplier_Info_Category_API.DB_SUPPLIER)) THEN
      Supplier_Info_General_API.Validate_Create_Supplier;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   Supplier_Info_General_API.Validate_Update(newrec_);
   IF (oldrec_.b2b_supplier = 'TRUE' AND newrec_.b2b_supplier = 'FALSE' AND B2b_User_Util_API.Supplier_Users_Exists(newrec_.supplier_id)) THEN
      Error_SYS.Record_General(lu_name_, 'B2BSUUSERXIST: There are Users connected to Supplier :P1. B2B Supplier must not be unchecked.', newrec_.supplier_id);
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN supplier_info_tab%ROWTYPE)
IS
BEGIN
   Supplier_Info_General_API.Validate_Delete(remrec_);
   $IF Component_Purch_SYS.INSTALLED $THEN
      Inquiry_Supplier_API.Check_Inquiry_Supplier(remrec_.supplier_id);
   $END   
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN     VARCHAR2,
   remrec_ IN     supplier_info_tab%ROWTYPE )
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
      Rm_Dup_Util_API.Search_Table_Insert('SupplierInfo', attr_);
   $ELSE
      NULL;
   $END
END Rm_Dup_Insert___;


PROCEDURE Rm_Dup_Update___ (
   rec_  IN supplier_info_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
   CURSOR get_contact_info IS
       SELECT person_id, guid
       FROM   supplier_info_contact
       WHERE  supplier_id = rec_.supplier_id;
BEGIN
   $IF Component_Rmpanl_SYS.INSTALLED AND Component_Srm_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Update('SupplierInfo', attr_);
      -- Update contact information
      FOR contact_rec_ IN get_contact_info LOOP
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('SUPPLIER_ID', rec_.supplier_id, attr_);
         Client_SYS.Add_To_Attr('PERSON_ID', contact_rec_.person_id, attr_);
         Client_SYS.Add_To_Attr('GUID', contact_rec_.guid, attr_);
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
      Rm_Dup_Util_API.Search_Table_Delete('SupplierInfo', attr_);
   $ELSE 
      NULL;
   $END
END Rm_Dup_Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Change_Supplier_Category__ (
   supplier_id_      IN VARCHAR2,
   supplier_name_    IN VARCHAR2, 
   association_no_   IN VARCHAR2,
   template_rec_     IN supplier_info_tab%ROWTYPE )
IS
   attr_              VARCHAR2(8000);
   template_attr_     VARCHAR2(8000);
   oldrec_            supplier_info_tab%ROWTYPE;
   newrec_            supplier_info_tab%ROWTYPE;
   template_rec_in_   supplier_info_tab%ROWTYPE;
   objid_             supplier_info_prospect.objid%TYPE;
   objversion_        supplier_info_prospect.objversion%TYPE;
   indrec_            Indicator_Rec;
   ptr_               NUMBER;
   value_             VARCHAR2(2000);
   name_              VARCHAR2(30);
BEGIN
   IF (template_rec_.supplier_id IS NULL) THEN
      newrec_ := Get_Object_By_Keys___(supplier_id_);
      newrec_.name              := name_;
      newrec_.association_no    := association_no_;
      newrec_.supplier_category := Supplier_Info_Category_API.DB_SUPPLIER;
      Modify___(newrec_);
   ELSE
      template_rec_in_               := template_rec_;
      template_rec_in_.supplier_id   := NULL;
      template_rec_in_.creation_date := NULL;
      template_attr_                 := Pack___(template_rec_in_);
      oldrec_ := Lock_By_Keys___(supplier_id_);
      Get_Id_Version_By_Keys___(objid_, objversion_, supplier_id_);             
      newrec_ := oldrec_;
      attr_   := Pack___(newrec_);
      attr_ := Client_SYS.Remove_Attr('SUPPLIER_ID',    attr_);
      attr_ := Client_SYS.Remove_Attr('CREATION_DATE',  attr_);
      Client_SYS.Set_Item_Value('NAME',                 supplier_name_,                          attr_);
      Client_SYS.Set_Item_Value('ASSOCIATION_NO',       association_no_,                         attr_);
      Client_SYS.Set_Item_Value('SUPPLIER_CATEGORY_DB', Supplier_Info_Category_API.DB_SUPPLIER,  attr_);
      --Replace the template attribute values with the ones with original rec values.
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (value_ IS NOT NULL) THEN
            Client_SYS.Set_Item_Value(name_, value_, template_attr_);
         END IF;
      END LOOP;
      Unpack___(newrec_, indrec_, template_attr_);
      Check_Update___(oldrec_, newrec_, indrec_, template_attr_);
      Update___(objid_, oldrec_, newrec_, template_attr_, objversion_);
   END IF;   
END Change_Supplier_Category__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   newrec_ IN OUT supplier_info_tab%ROWTYPE )
IS      
BEGIN      
   New___(newrec_); 
END New; 


PROCEDURE New (
   supplier_id_      IN OUT VARCHAR2,
   name_             IN     VARCHAR2,
   association_no_   IN     VARCHAR2,
   country_          IN     VARCHAR2,
   default_language_ IN     VARCHAR2 )
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
   supplier_id_ := newrec_.supplier_id;
END New;


-- Modify
--   Public interface to modify a record by sending changed values in an attr_.
@IgnoreUnitTest DMLOperation
PROCEDURE Modify (
   attr_        IN OUT VARCHAR2,
   supplier_id_ IN     VARCHAR2 )
IS
   indrec_     Indicator_Rec;
   newrec_     supplier_info_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(supplier_id_);
   Unpack___(newrec_, indrec_, attr_);
   Modify___(newrec_);
END Modify;
