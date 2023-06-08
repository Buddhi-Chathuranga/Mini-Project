-----------------------------------------------------------------------------
--
--  Logical unit: SupplierInfoGeneral
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150528  RoJalk  ORA-499, Created.
--  150604  RoJalk  ORA-500, Added methods Validate_Delete, Add_Default_Values, Validate_Update, Validate_Common,
--  150604          Post_Update_Actions to be used from both Supplier_Info_Prospect_API and Supplier_Info_API.
--  150608  RoJalk  ORA-501, Added the methods Pre_Insert_Actions, Get_Supplier_Category, Get_Next_Identity and Get_Next_Party___.
--  150608          Called Add_Default_Values from Prepare_Insert___. 
--  150610  RoJalk  ORA-501, Moved the method Validate_One_Time_Supplier__ from Supplier_Info_API to Supplier_Info_General_API.
--  150611  RoJalk  ORA-501, Added the method Set_Default_Value_Rec including common value assignments for supplier_Info_Prospect_API
--                  and Supplier_Info_API. Moved Validate_One_Time_Supplier__ to Supplier_Info_API. 
--  150617  RoJalk  ORA-656, Included the New___ method within New public interface. Included Copy_Existing_Supplier_Inv and Copy_Details___
--                  since it is common to both suppliers and prospects. Added methods Raise_Record_Removed___, Lock_By_Keys___.
--  150703  RoJalk  ORA-783, Added the method Change_Supplier_Category.
--  150708  RoJalk  ORA-672, Modified Copy_Details___ and added parameters copy_for_category_ and copy_convert_option_.
--  150709  RoJalk  ORA-736, Added methods Get_Creation_Date and Get_Country.
--  150713  SudJlk  ORA-657, Added method Get_Picture_Id.
--  150727  RoJalk  ORA-663, Added the method Get_Default_Language_Db.
--  150804  RoJalk  ORA-663, Added the method Get and public record declaration.
--  150811  RoJalk  ORA-1179, Added the method Validate_Create_Supplier.
--  150821  RoJalk  ORA-1214, Added the method Pre_Delete_Actions and modified Validate_Delete to include Check_Restricted_Delete call.
--  150825  RoJalk  AFT-1656, Modified Copy_Details___ and added the parameter copy_convert_option_ to INVOIC method call.
--  150826  RoJalk  AFT-1662, Declared Copy_Param_Info and used in Copy_Details___ method.
--  150826  RoJalk  AFT-1660, Added the method Validate_Check_Insert.
--  150917  RoJalk  AFT-5456, Modified the code in Get_Supplier_Category_Db and fetched the value using a select statement rather than method redirection.
--  160912  Chwilk  STRFI-3456, Bug 131149 - Changed return type of function Get_Creation_Date to date.
--  161004  reanpl  FINHR-3451, Added ACCRUL handling in Copy_Details___
--  180207  MaAuse  STRSC-15652, Modifed Copy_Existing_Supplier_Inv by adding parameter default_language_.
--  180703  Nudilk  Bug 142813, Added method Get_Country_Db.
--  200824  Hairlk  SCTA-8074, Replaced Security_SYS.Is_Method_Available with projection specific Is_Proj_Action_Available.
--  210728  LaDelk  PR21R2-529, Added method Get_B2b_Supplier_Db.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Public_Rec IS RECORD
  (supplier_id                    supplier_info_tab.supplier_id%TYPE,
   "rowid"                        ROWID,
   rowversion                     supplier_info_tab.rowversion%TYPE,
   rowkey                         supplier_info_tab.rowkey%TYPE,
   rowtype                        supplier_info_tab.supplier_category%TYPE,
   name                           supplier_info_tab.name%TYPE,
   creation_date                  supplier_info_tab.creation_date%TYPE,
   association_no                 supplier_info_tab.association_no%TYPE,
   party                          supplier_info_tab.party%TYPE,
   default_language               supplier_info_tab.default_language%TYPE,
   country                        supplier_info_tab.country%TYPE,
   party_type                     supplier_info_tab.party_type%TYPE,
   suppliers_own_id               supplier_info_tab.suppliers_own_id%TYPE,
   corporate_form                 supplier_info_tab.corporate_form%TYPE,
   identifier_reference           supplier_info_tab.identifier_reference%TYPE,
   picture_id                     supplier_info_tab.picture_id%TYPE,
   one_time                       supplier_info_tab.one_time%TYPE,
   supplier_category              supplier_info_tab.supplier_category%TYPE,
   b2b_supplier                   supplier_info_tab.b2b_supplier%TYPE);
   
TYPE Copy_Param_Info IS RECORD (
   copy_convert_option    VARCHAR2(14),
   overwrite_purch_data   VARCHAR2(20) );

-------------------- PRIVATE DECLARATIONS -----------------------------------
 
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Object_By_Keys___ (
   supplier_id_ IN VARCHAR2 ) RETURN supplier_info_tab%ROWTYPE
IS
   lu_rec_ supplier_info_tab%ROWTYPE;
   CURSOR getrec IS
      SELECT *
      FROM   supplier_info_tab
      WHERE  supplier_id = supplier_id_;
BEGIN
   OPEN getrec;
   FETCH getrec INTO lu_rec_;
   CLOSE getrec;
   RETURN(lu_rec_);
END Get_Object_By_Keys___;


FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN supplier_info_tab%ROWTYPE
IS
   lu_rec_ supplier_info_tab%ROWTYPE;
   CURSOR getrec IS
      SELECT *
      FROM   supplier_info_tab
      WHERE  ROWID = objid_;
BEGIN
   OPEN getrec;
   FETCH getrec INTO lu_rec_;
   IF (getrec%NOTFOUND) THEN
      Error_SYS.Record_Removed(lu_name_);
   END IF;
   CLOSE getrec;
   RETURN(lu_rec_);
END Get_Object_By_Id___;


FUNCTION Lock_By_Keys___ (
   supplier_id_ IN VARCHAR2 ) RETURN supplier_info_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        supplier_info_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  supplier_info_tab
         WHERE supplier_id = supplier_id_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(supplier_id_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(supplier_id_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;  


PROCEDURE Raise_Too_Many_Rows___ (
   supplier_id_ IN VARCHAR2,
   method_name_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Too_Many_Rows(Supplier_Info_General_API.lu_name_, NULL, method_name_);
END Raise_Too_Many_Rows___;


PROCEDURE Raise_Record_Not_Exist___ (
   supplier_id_ IN VARCHAR2 )
IS 
BEGIN
   Error_SYS.Record_Not_Exist(Supplier_Info_General_API.lu_name_);
END Raise_Record_Not_Exist___;   


PROCEDURE Raise_Record_Removed___ (
   supplier_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Removed(Supplier_Info_General_API.lu_name_);
END Raise_Record_Removed___;

   
FUNCTION Check_Exist___ (
   supplier_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1
      INTO  dummy_
      FROM  supplier_info_tab
      WHERE supplier_id = supplier_id_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(supplier_id_, 'Check_Exist___');
END Check_Exist___;


PROCEDURE Get_Next_Party___ (
   newrec_ IN OUT supplier_info_tab%ROWTYPE )
IS
BEGIN
   Party_Id_API.Get_Next_Party('DEFAULT', newrec_.party);   
END Get_Next_Party___;


PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN      
   Add_Default_Values(attr_);
END Prepare_Insert___;


PROCEDURE Copy_Details___ (
   supplier_id_           IN VARCHAR2,
   new_id_                IN VARCHAR2,
   company_               IN VARCHAR2,
   copy_for_category_     IN VARCHAR2,
   copy_convert_option_   IN VARCHAR2,
   overwrite_purch_data_  IN VARCHAR2 )
IS
   pkg_method_name_   VARCHAR2(200);
   module_            VARCHAR2(6);
   stmt_              VARCHAR2(2000);
   copy_info_         Copy_Param_Info;
   CURSOR get_copying_info IS
      SELECT pkg_and_method_name, module
      FROM   copying_info_tab
      WHERE  party_type = 'SUPPLIER'
      AND    INSTR(copy_for_category, copy_for_category_) != 0
      AND    INSTR(copy_convert_option, copy_convert_option_) != 0   
      ORDER BY exec_order;
BEGIN
   copy_info_.copy_convert_option  := copy_convert_option_;
   copy_info_.overwrite_purch_data := overwrite_purch_data_;
   OPEN get_copying_info;
   WHILE (TRUE) LOOP
      FETCH get_copying_info INTO pkg_method_name_, module_;
      EXIT WHEN get_copying_info%NOTFOUND;
      Assert_SYS.Assert_Is_Package_Method(pkg_method_name_);
      IF (module_ = 'ACCRUL') THEN
         IF (Dictionary_SYS.Component_Is_Active('ACCRUL')) THEN
            stmt_ := 'BEGIN '||pkg_method_name_||'(:supplier_id_, :new_id_, :company_); END;';
            @ApproveDynamicStatement(2016-09-04,reanpl)
            EXECUTE IMMEDIATE stmt_ USING supplier_id_, new_id_, company_;
         END IF;                                          
      ELSIF (module_ = 'INVOIC') THEN
         IF (Dictionary_SYS.Component_Is_Active('INVOIC')) THEN
            IF (pkg_method_name_ = 'Supplier_Document_Tax_Info_API.Copy_Supplier') THEN
               $IF Component_Invoic_SYS.INSTALLED $THEN
                  Supplier_Document_Tax_Info_API.Copy_Supplier(supplier_id_, new_id_, company_);
               $ELSE
                  NULL;
               $END
            ELSE            
               stmt_ := 'BEGIN '||pkg_method_name_||'(:supplier_id_, :new_id_, :company_, :copy_info_); END;';
               @ApproveDynamicStatement(2015-08-24,rojalk)
               EXECUTE IMMEDIATE stmt_ USING supplier_id_, new_id_, company_, copy_info_;
            END IF;   
         END IF;                                          
      ELSIF (module_ = 'PAYLED') THEN
         IF (Dictionary_SYS.Component_Is_Active('PAYLED')) THEN
            stmt_ := 'BEGIN '||pkg_method_name_||'(:supplier_id_, :new_id_, :company_); END;';
            @ApproveDynamicStatement(2005-11-10,ovjose)
            EXECUTE IMMEDIATE stmt_ USING supplier_id_, new_id_, company_;
         END IF;                                          
      ELSIF (module_ = 'PURCH') THEN
         IF (Dictionary_SYS.Component_Is_Active('PURCH')) THEN
            IF (pkg_method_name_ = 'Supplier_API.Copy_Supplier') THEN
               $IF Component_Purch_SYS.INSTALLED $THEN
                  Supplier_API.Copy_Supplier(supplier_id_, new_id_, copy_info_);
               $ELSE
                  NULL;
               $END   
            ELSE 
               stmt_ := 'BEGIN '||pkg_method_name_||'(:supplier_id_, :new_id_); END;';
               @ApproveDynamicStatement(2014-03-07,chhulk)
               EXECUTE IMMEDIATE stmt_ USING supplier_id_, new_id_; 
            END IF;
         END IF;
      ELSIF (module_ = 'ENTERP' AND pkg_method_name_ = 'Comm_Method_API.Copy_Identity_Info') THEN
         IF (Get_One_Time_Db(supplier_id_) = 'FALSE') THEN
            Comm_Method_API.Copy_Identity_Info('SUPPLIER', supplier_id_, new_id_);
         END IF;
      ELSE
         stmt_ := 'BEGIN '||pkg_method_name_||'(:supplier_id_, :new_id_); END;';
         @ApproveDynamicStatement(2005-11-10,ovjose)
         EXECUTE IMMEDIATE stmt_ USING supplier_id_, new_id_;
      END IF;
   END LOOP;
   CLOSE get_copying_info;
END Copy_Details___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   supplier_category_db_   VARCHAR2(20);
BEGIN
   IF (action_ = 'PREPARE') THEN
      Prepare_Insert___(attr_);
   ELSIF (action_ = 'CHECK') THEN
      supplier_category_db_ := Client_SYS.Get_Item_Value('SUPPLIER_CATEGORY_DB', attr_);
      IF (supplier_category_db_ IS NULL) THEN
         supplier_category_db_ := Supplier_Info_Category_API.Encode(Client_SYS.Get_Item_Value('SUPPLIER_CATEGORY', attr_));
      END IF;  
      IF (supplier_category_db_ = 'SUPPLIER') THEN
         Supplier_Info_API.New__(info_, objid_, objversion_, attr_, action_);
      ELSIF (supplier_category_db_ = 'PROSPECT') THEN
         Supplier_Info_Prospect_API.New__(info_, objid_, objversion_, attr_, action_);
      ELSE
         Error_SYS.Check_Not_Null(lu_name_, 'SUPPLIER_CATEGORY', supplier_category_db_);
      END IF;
   ELSIF (action_ = 'DO') THEN
      supplier_category_db_ := Client_SYS.Get_Item_Value('SUPPLIER_CATEGORY_DB', attr_);
      IF (supplier_category_db_ IS NULL) THEN
         supplier_category_db_ := Supplier_Info_Category_API.Encode(Client_SYS.Get_Item_Value('SUPPLIER_CATEGORY', attr_));
      END IF;  
      IF (supplier_category_db_ = 'SUPPLIER') THEN
         Supplier_Info_API.New__(info_, objid_, objversion_, attr_, action_);
      ELSIF (supplier_category_db_ = 'PROSPECT') THEN
         Supplier_Info_Prospect_API.New__(info_, objid_, objversion_, attr_, action_);
      ELSE
         Error_SYS.Check_Not_Null(lu_name_, 'SUPPLIER_CATEGORY', supplier_category_db_);
      END IF;
   END IF;
END New__;


PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_ supplier_info_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Id___(objid_);
   IF (newrec_.supplier_category = 'SUPPLIER') THEN
      Supplier_Info_API.Modify__(info_, objid_, objversion_, attr_, action_);
   ELSIF (newrec_.supplier_category = 'PROSPECT') THEN
      Supplier_Info_Prospect_API.Modify__(info_, objid_, objversion_, attr_, action_);
   END IF;
END Modify__;


PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ supplier_info_tab%ROWTYPE;
BEGIN
   remrec_ := Get_Object_By_Id___(objid_);
   IF (remrec_.supplier_category = 'SUPPLIER') THEN
      Supplier_Info_API.Remove__(info_, objid_, objversion_, action_);
   ELSIF (remrec_.supplier_category = 'PROSPECT') THEN
      Supplier_Info_Prospect_API.Remove__(info_, objid_, objversion_, action_);
   END IF;
END Remove__;


PROCEDURE Change_Supplier_Category__ (
   supplier_id_          IN VARCHAR2,
   supplier_name_        IN VARCHAR2,
   association_no_       IN VARCHAR2,
   template_supp_id_     IN VARCHAR2,
   template_company_     IN VARCHAR2,
   overwrite_purch_data_ IN VARCHAR2)
IS   
   template_rec_   supplier_info_tab%ROWTYPE;
   CURSOR get_template_attr IS
      SELECT *
      FROM   supplier_info_tab
      WHERE  supplier_id = template_supp_id_;
BEGIN   
   IF (template_supp_id_ IS NOT NULL) THEN
      $IF Component_Accrul_SYS.INSTALLED $THEN
         Company_Finance_API.Exist(template_company_);
      $END
      Supplier_Info_API.Exist(template_supp_id_);
      OPEN get_template_attr;
      FETCH get_template_attr INTO template_rec_;     
      IF (get_template_attr%FOUND) THEN    
         Supplier_Info_Prospect_API.Change_Supplier_Category__(supplier_id_, supplier_name_, association_no_, template_rec_);
         Copy_Details___(template_rec_.supplier_id, supplier_id_, template_company_, 'SUPPLIER', 'CONVERT', overwrite_purch_data_);
      END IF;
      CLOSE get_template_attr;
   ELSE
      Supplier_Info_Prospect_API.Change_Supplier_Category__(supplier_id_, supplier_name_, association_no_, template_rec_);
   END IF;  
END Change_Supplier_Category__;


-- This method is to be used by Aurena
PROCEDURE Write_Supplier_Logo__ (
   objversion_      IN VARCHAR2,
   objid_           IN VARCHAR2,
   supplier_logo##  IN BLOB )
IS  
   rec_            supplier_info_tab%ROWTYPE;
   picture_id_     supplier_info_general.picture_id%TYPE;
   pic_objversion_ binary_object_data_block.objversion%TYPE;
   pic_objid_      binary_object_data_block.objid%TYPE;
   supplier_id_    supplier_info_general.supplier_id%TYPE;
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(2000);
   nobjversion_    VARCHAR2(2000) := objversion_;
BEGIN
   rec_         := Get_Object_By_Id___(objid_);  
   supplier_id_ := rec_.supplier_id;
   picture_id_  := Supplier_Info_General_API.Get_Picture_Id(supplier_id_);
   IF (supplier_logo## IS NOT NULL) THEN
      Binary_Object_API.Create_Or_Replace(picture_id_, supplier_id_ , '' , '' , 'FALSE' , 0 , 'PICTURE' , '' );
      Binary_Object_Data_Block_API.New__(pic_objversion_, pic_objid_, picture_id_, NULL);
      Binary_Object_Data_Block_API.Write_Data__(pic_objversion_, pic_objid_, supplier_logo##);   
   ELSE
      Binary_Object_API.Do_Delete(picture_id_);
      picture_id_ := NULL;
   END IF;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PICTURE_ID', picture_id_, attr_);
   Supplier_Info_General_API.Modify__(info_, objid_, nobjversion_, attr_, 'DO');
END Write_Supplier_Logo__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
 
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Next_Identity RETURN NUMBER
IS
   next_id_             NUMBER;
   party_type_db_       supplier_info_tab.party_type%TYPE := 'SUPPLIER';
   update_next_value_   BOOLEAN := FALSE;
BEGIN
   Party_Identity_Series_API.Get_Next_Value(next_id_, party_type_db_);  
   WHILE Check_Exist___(next_id_) LOOP
      next_id_ := next_id_ + 1;
      update_next_value_ := TRUE;
   END LOOP;
   IF (update_next_value_) THEN
      Party_Identity_Series_API.Update_Next_Value(next_id_, party_type_db_);
   END IF;
   RETURN next_id_;
END Get_Next_Identity;


@UncheckedAccess
FUNCTION Get_One_Time_Db (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_   supplier_info_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(supplier_id_);
   IF (rec_.supplier_category = 'SUPPLIER') THEN
      RETURN Supplier_Info_API.Get_One_Time_Db(supplier_id_);
   ELSIF (rec_.supplier_category = 'PROSPECT') THEN
      RETURN Supplier_Info_Prospect_API.Get_One_Time_Db(supplier_id_);
   ELSE
      RETURN NULL;   
   END IF;
END Get_One_Time_Db;


@UncheckedAccess
FUNCTION Get_B2b_Supplier_Db (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_   supplier_info_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(supplier_id_);
   IF (rec_.supplier_category = 'SUPPLIER') THEN
      RETURN Supplier_Info_API.Get_B2b_Supplier_Db(supplier_id_);
   ELSIF (rec_.supplier_category = 'PROSPECT') THEN
      RETURN Supplier_Info_Prospect_API.Get_B2b_Supplier_Db(supplier_id_);
   ELSE
      RETURN NULL;   
   END IF;
END Get_B2b_Supplier_Db;


@ObjectConnectionMethod
@UncheckedAccess
FUNCTION Get_Name (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_   supplier_info_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(supplier_id_);
   IF (rec_.supplier_category = 'SUPPLIER') THEN
      RETURN Supplier_Info_API.Get_Name(supplier_id_);
   ELSIF (rec_.supplier_category = 'PROSPECT') THEN
      RETURN Supplier_Info_Prospect_API.Get_Name(supplier_id_);
   ELSE
      RETURN NULL;   
   END IF;
END Get_Name;   


@UncheckedAccess
FUNCTION Get_Party (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_   supplier_info_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(supplier_id_);
   IF (rec_.supplier_category = 'SUPPLIER') THEN
      RETURN Supplier_Info_API.Get_Party(supplier_id_);
   ELSIF (rec_.supplier_category = 'PROSPECT') THEN
      RETURN Supplier_Info_Prospect_API.Get_Party(supplier_id_);
   ELSE
      RETURN NULL;   
   END IF;
END Get_Party;  


@UncheckedAccess
FUNCTION Get_Supplier_Category_Db (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ supplier_info_tab.supplier_category%TYPE;
BEGIN
   IF (supplier_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT supplier_category
      INTO  temp_
      FROM  supplier_info_tab
      WHERE supplier_id = supplier_id_;
   RETURN temp_;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(supplier_id_, 'Get_Supplier_Category_Db');
END Get_Supplier_Category_Db; 


@UncheckedAccess
FUNCTION Get_Supplier_Category (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ supplier_info_tab.supplier_category%TYPE;
BEGIN
   IF (supplier_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT supplier_category
      INTO  temp_
      FROM  supplier_info_tab
      WHERE supplier_id = supplier_id_;
   RETURN Supplier_Info_Category_API.Decode(temp_);
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(supplier_id_, 'Get_Supplier_Category');
END Get_Supplier_Category; 


@UncheckedAccess
FUNCTION Get_Creation_Date (
   supplier_id_ IN VARCHAR2 ) RETURN DATE
IS
   rec_   supplier_info_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(supplier_id_);
   IF (rec_.supplier_category = 'SUPPLIER') THEN
      RETURN Supplier_Info_API.Get_Creation_Date(supplier_id_);
   ELSIF (rec_.supplier_category = 'PROSPECT') THEN
      RETURN Supplier_Info_Prospect_API.Get_Creation_Date(supplier_id_);
   ELSE
      RETURN NULL;   
   END IF;
END Get_Creation_Date;


@UncheckedAccess
FUNCTION Get_Country (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_   supplier_info_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(supplier_id_);
   IF (rec_.supplier_category = 'SUPPLIER') THEN
      RETURN Supplier_Info_API.Get_Country(supplier_id_);
   ELSIF (rec_.supplier_category = 'PROSPECT') THEN
      RETURN Supplier_Info_Prospect_API.Get_Country(supplier_id_);
   ELSE
      RETURN NULL;   
   END IF;
END Get_Country; 


@UncheckedAccess
FUNCTION Get_Country_Db (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_   supplier_info_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(supplier_id_);
   IF (rec_.supplier_category = 'SUPPLIER') THEN
      RETURN Supplier_Info_API.Get_Country_Db(supplier_id_);
   ELSIF (rec_.supplier_category = 'PROSPECT') THEN
      RETURN Supplier_Info_Prospect_API.Get_Country_Db(supplier_id_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Country_Db;


@UncheckedAccess
FUNCTION Get_Default_Language_Db (
   supplier_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_   supplier_info_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(supplier_id_);
   IF (rec_.supplier_category = 'SUPPLIER') THEN
      RETURN Supplier_Info_API.Get_Default_Language_Db(supplier_id_);
   ELSIF (rec_.supplier_category = 'PROSPECT') THEN
      RETURN Supplier_Info_Prospect_API.Get_Default_Language_Db(supplier_id_);
   ELSE
      RETURN NULL;   
   END IF;
END Get_Default_Language_Db; 


@UncheckedAccess
PROCEDURE Exist (
   supplier_id_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(supplier_id_)) THEN
      Raise_Record_Not_Exist___(supplier_id_);
   END IF;
END Exist;


PROCEDURE Validate_Delete (
   rec_ IN supplier_info_tab%ROWTYPE)
IS
   key_   VARCHAR2(2000);
BEGIN
   key_ := rec_.supplier_id||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
   $IF Component_Srm_SYS.INSTALLED $THEN
      Business_Activity_API.Check_Business_Activity(rec_.supplier_id, rec_.party_type);
   $END
END Validate_Delete;


PROCEDURE Validate_Check_Insert (
   newrec_ IN supplier_info_tab%ROWTYPE)
IS
BEGIN
   IF (newrec_.supplier_id IS NOT NULL) THEN      
      IF (UPPER(newrec_.supplier_id) != newrec_.supplier_id) THEN
         Error_SYS.Record_General(lu_name_, 'CAPCHECK: Only capital letters are allowed in the ID.');
      END IF;
   END IF;  
END Validate_Check_Insert;


PROCEDURE Pre_Delete_Actions (
   rec_ IN supplier_info_tab%ROWTYPE)
IS
   key_   VARCHAR2(2000);
BEGIN
   key_ := rec_.supplier_id||'^';
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
END Pre_Delete_Actions; 


PROCEDURE Add_Default_Values(
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_To_Attr('CREATION_DATE',             TRUNC(SYSDATE),                               attr_);
   Client_SYS.Add_To_Attr('PARTY_TYPE',                Party_Type_API.Decode('SUPPLIER'),            attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN',            'TRUE',                                       attr_);
   Client_SYS.Add_To_Attr('IDENTIFIER_REF_VALIDATION', Identifier_Ref_Validation_API.Decode('NONE'), attr_);
   Client_SYS.Add_To_Attr('ONE_TIME_DB',               Fnd_Boolean_API.DB_FALSE,                     attr_);
   Client_SYS.Add_To_Attr('B2B_SUPPLIER_DB',           Fnd_Boolean_API.DB_FALSE,                     attr_);
END Add_Default_Values;


PROCEDURE Set_Default_Value_Rec (   
   newrec_ IN OUT supplier_info_tab%ROWTYPE )
IS
BEGIN  
   IF (newrec_.identifier_ref_validation IS NULL) THEN
      newrec_.identifier_ref_validation := 'NONE';
   END IF; 
   IF (newrec_.one_time IS NULL) THEN
      newrec_.one_time := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (newrec_.b2b_supplier IS NULL) THEN
      newrec_.b2b_supplier := Fnd_Boolean_API.DB_FALSE;
   END IF;
END Set_Default_Value_Rec; 


PROCEDURE Validate_Update (
   newrec_ IN supplier_info_tab%ROWTYPE )
IS      
BEGIN      
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY', newrec_.party);
END Validate_Update;


PROCEDURE Validate_Common (
   oldrec_ IN supplier_info_tab%ROWTYPE,
   newrec_ IN supplier_info_tab%ROWTYPE )
IS
   exists_                VARCHAR2(5);
   supplier_              VARCHAR2(200);
BEGIN  
   IF ((oldrec_.association_no != newrec_.association_no) OR (oldrec_.association_no IS NULL)) THEN
      exists_ := Association_Info_API.Association_No_Exist(newrec_.association_no, 'SUPPLIER');
      IF (exists_ = 'TRUE') THEN
         IF (newrec_.supplier_id IS NULL) THEN
            supplier_ := newrec_.name;
         ELSE
            supplier_ := newrec_.supplier_id;
         END IF;
         Client_SYS.Add_Warning(lu_name_, 'WARNSAMEASCNO: Another business partner with the association number :P1 is already registered. Do you want to use the same Association No for :P2?', newrec_.association_no, supplier_);
      END IF;
   END IF;
   IF (oldrec_.country != newrec_.country) THEN
      IF ((newrec_.corporate_form IS NOT NULL) AND NOT (Corporate_Form_API.Exists(newrec_.country, newrec_.corporate_form))) THEN
         Error_SYS.Record_General(lu_name_, 'COPFORMNOTEXIST: The form of business ID :P1 is not valid for the country code :P2. Select a form of business that is connected to country code :P2 in the Form of Business field.', newrec_.corporate_form, newrec_.country);
      END IF;
   END IF;
   Attribute_Definition_API.Check_Value(newrec_.supplier_id, lu_name_, 'SUPPLIER_ID'); 
   IF (newrec_.identifier_reference IS NOT NULL AND newrec_.identifier_ref_validation != 'NONE') THEN
      Identifier_Ref_Validation_API.Check_Identifier_Reference(newrec_.identifier_reference, newrec_.identifier_ref_validation);
   END IF;
END Validate_Common;


PROCEDURE Validate_Create_Supplier 
IS   
BEGIN  
   IF (NOT Security_SYS.Is_Proj_Action_Available('SupplierHandling', 'CheckCreateCategorySupplier')) THEN
      Error_SYS.Record_General(lu_name_, 'NOACCESSTOCREATESUP: You have no permission to create suppliers of category :P1', Supplier_Info_Category_API.Decode(Supplier_Info_Category_API.DB_SUPPLIER));
   END IF;
END Validate_Create_Supplier;   


PROCEDURE Pre_Insert_Actions (
   newrec_ IN OUT supplier_info_tab%ROWTYPE,
   attr_   IN OUT VARCHAR2)
IS
BEGIN
   IF (newrec_.supplier_id IS NULL) THEN      
      newrec_.supplier_id := Get_Next_Identity();      
      IF (newrec_.supplier_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'SUPP_ERROR: Error while retrieving the next free identity. Check the identity series for supplier');
      END IF;
      Party_Identity_Series_API.Update_Next_Value(newrec_.supplier_id + 1, newrec_.party_type);
      Client_SYS.Set_Item_Value('SUPPLIER_ID', newrec_.supplier_id, attr_);
   END IF;   
   Get_Next_Party___(newrec_); 
END Pre_Insert_Actions;


PROCEDURE Post_Update_Actions (
   objid_  IN VARCHAR2,
   oldrec_ IN supplier_info_tab%ROWTYPE,
   newrec_ IN supplier_info_tab%ROWTYPE )
IS
   key_ref_      VARCHAR2(600);
   is_obj_con_   VARCHAR2(5);
BEGIN
   $IF Component_Docman_SYS.INSTALLED $THEN
      IF (newrec_.name != oldrec_.name) THEN
         Client_SYS.Get_Key_Reference(key_ref_, lu_name_, objid_);   
         is_obj_con_ :=  Doc_Reference_Object_API.Exist_Obj_Reference(lu_name_, key_ref_); 
         IF (is_obj_con_ = 'TRUE') THEN
            Doc_Reference_Object_API.Refresh_Object_Reference_Desc(lu_name_, key_ref_);
         END IF;         
      END IF;
   $ELSE
      NULL;
   $END
END Post_Update_Actions;

   
PROCEDURE Copy_Existing_Supplier_Inv (
   supplier_id_      IN VARCHAR2,
   new_id_           IN VARCHAR2,
   company_          IN VARCHAR2,
   new_name_         IN VARCHAR2,
   default_language_ IN VARCHAR2,
   country_          IN VARCHAR2,
   association_no_   IN VARCHAR2 DEFAULT NULL )
IS  
   supplier_exist_  VARCHAR2(5);
   newrec_          supplier_info_tab%ROWTYPE;
   oldrec_          supplier_info_tab%ROWTYPE;
   CURSOR get_attr IS
      SELECT *
      FROM   supplier_info_tab
      WHERE supplier_id = supplier_id_;
BEGIN
   supplier_exist_ := 'FALSE';
   FOR rec_ IN get_attr LOOP
      supplier_exist_          := 'TRUE';
      oldrec_                  := Lock_By_Keys___(supplier_id_);   
      newrec_                  := oldrec_ ;
      newrec_.supplier_id      := new_id_;
      newrec_.name             := new_name_;
      newrec_.creation_date    := TRUNC(SYSDATE);
      newrec_.default_domain   := 'TRUE';
      newrec_.association_no   := association_no_;
      newrec_.party            := NULL;
      newrec_.picture_id       := NULL;
      IF (default_language_ IS NOT NULL) THEN 
         newrec_.default_language := Iso_Language_API.Encode(default_language_);
      END IF;
      IF (country_ IS NOT NULL) THEN 
         newrec_.country := Iso_Country_API.Encode(country_);
      END IF;
      IF (newrec_.supplier_category = 'SUPPLIER') THEN
         Supplier_Info_API.New(newrec_);      
      ELSIF (newrec_.supplier_category = 'PROSPECT') THEN
         Supplier_Info_Prospect_API.New(newrec_);   
      END IF;   
      Copy_Details___(supplier_id_, newrec_.supplier_id, company_, newrec_.supplier_category, 'COPY', Fnd_Boolean_API.DB_FALSE);
   END LOOP;
   IF (supplier_exist_ = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'NOSUPP: Supplier :P1 does not exist', supplier_id_);
   END IF;
END Copy_Existing_Supplier_Inv;


@UncheckedAccess
FUNCTION Get_Picture_Id (
   supplier_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   rec_   supplier_info_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(supplier_id_);
   IF (rec_.supplier_category = 'SUPPLIER') THEN
      RETURN Supplier_Info_API.Get_Picture_Id(supplier_id_);
   ELSIF (rec_.supplier_category = 'PROSPECT') THEN
      RETURN Supplier_Info_Prospect_API.Get_Picture_Id(supplier_id_);
   ELSE
      RETURN NULL;   
   END IF;
END Get_Picture_Id;


@UncheckedAccess
FUNCTION Get (
   supplier_id_ IN VARCHAR2 ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (supplier_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT supplier_id,
          ROWID, rowversion, rowkey, supplier_category,
          name, 
          creation_date, 
          association_no, 
          party, 
          default_language, 
          country, 
          party_type, 
          suppliers_own_id, 
          corporate_form, 
          identifier_reference, 
          picture_id, 
          one_time, 
          supplier_category,
          b2b_supplier
      INTO temp_
      FROM supplier_info_tab
      WHERE supplier_id = supplier_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(supplier_id_, 'Get');
END Get;


