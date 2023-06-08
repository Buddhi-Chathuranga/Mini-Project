-----------------------------------------------------------------------------
--
--  Logical unit: CustomerInfo
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981116  Camk    Created
--  981126  Camk    Method Check_If_Null added
--  981202  Camk    Check on Association No added.
--  990111  Camk    Method Get_Control_Type_Value_Desc added.
--  990125  Camk    Our_Id removed.
--  990415  Maruse  New template.
--  990429  Maruse  New template corr.
--  990811  Lisv    Rewrighted the procedure Copy_Details___. Added company as parameter.
--                  Now check in a table which procedures to run when copying a customer.
--                  Added company as parameter in procedure Copy_Existing_Customer.
--  990820  BmEk    Removed Error_SYS.Check_Not_Null in Unpack_Check_Insert___ for customer_id.
--                  Added a control in Insert___ instead, to check if customer_id is null. This
--                  because it should be possible to fetch an automatic generated customer_id
--                  from LU PartyIdentitySeries. Also added the procedure Get_Identity___.
--  990830  Camk    Substr_b instead of substr.
--  000128  Mnisse  Check on capital letters for ID, bug #30596.
--  000306  Camk    Bug# 14896 Corrected.
--  000525  LiSv    Removed call to Check_If_Null___ (this is an old solution).
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  001003  Camk    Call #49359 Corrected. Fetch automatic customer_id when copy customer.
--  010308  JeGu    Bug #20475, New functions: Get_Default_Language_Code, Get_Country_Code
--  010502  Inkase  Bug #20229, Added check if entered country or language is 2 characters,
--                  then save it, else encode it. Also set uppercase on country.
--  021121  hecolk  IID ITFI135N. Added Calls to VALIDATION_PER_COMPANY_API.Validate_Association_Number in Unpack_Check_Insert___ and Unpack_Check_Update___
--  030123  GEPELK  IID BEFI102E - Added corporate_form column
--  030123          Comments are added to top following programing standards.
--  030409  NiKaLK  Added new view Multi_Customer_Info
--  030411  NiKaLK  Removed View Multi_Customer_Info
--  040226  Thsrlk  FIPR404A2 - Introduced Micro Cash to improve performance
--  040301  Gawilk  FIPR404A2 - Corrected the error in function Get_Default_Language.
--  040804  LOKrLK  B116242 - Modified Update_Cache___
--  040804  Jeguse  IID FIJP335. Added column Identifier_Reference and functions for this column.
--  040930  SAAHLK  LCS Patch Merge, Bug 37877.
--  050411  Prdilk  LCS Patch Merge-Bug 48971, Modified get_copying_info cursor with ORDER BY
--  050919  Hecolk  LCS Merge - Bug 52720, Added FUNCTION Get_Next_Identity and Removed PROCEDURE Get_Identity___
--  060209  MAWELK  Call Id 133062 added a parameter key to corporate_form in CUSTOMER_INFO view.
--  060824  Csenlk  LCS Merge 57393,Corrected.Modified Insert__ to increase the next value in Identity Series by one.
--  070404  ToBeSe  Added column picture_id.
--  070709  Shsalk  B146478 Corrected accoding to a request from SDMAN module.
--  090512  Kanslk  Bug 82240, Modified Update__() and introduced constant 'inst_docman_'.
--  091204  Kanslk  Reverse-Engineering, removed country_db from view comment ofcorporate_form.
--  100415  Bmekse  EAFH-2700 Removed unneeded view comments from CUSTOMER_INFO
--  100701  Kanslk  EANE-2759, modified view CUSTOMER_INFO by adding default_language_db and country_db to view comments.
--  100716  Paralk  EANE-EANE-2930, Corrected in Copy_Details___()
--  101111  Mohrlk  DF-492 , Created new 'SUPPLY_COUNTRY_LOV' View
--  101116  Mohrlk  DF-492, Added Enumerate Method to Support Inclusion of Aestrix.
--  110120  RUFELK  RAVEN-1493, Removed use of Validation_Per_Company_API.
--  110506  Mohrlk  EASTONE-17550, Modified View SUPPLY_COUNTRY_LOV. 
--  120322  KRWIPL  EASTRTM-5691 Copy Customer - does not copy Project Report Parameters Tab
--  120706  MaRalk  PBR-8, Added public attribute customer_category and updated relevant methods.
--  130118  SALIDE  EDEL-1994, Added One_Time column and Validate_One_Time_Customer__() and modified Copy_Existing_Customer(), Copy_Details___()
--  120713  Maiklk  PBR-298, Inlcuded Customer category when Copy existing customer.
--  120906  MaRalk  PBR-446, Avoided setting default value 'Customer' for new customer records.
--  120906          Added parameter new_category_ to Copy_Existing_Customer function.
--  120918  MaRalk  PBR-340, Added method Validate_Customer_Category___ to address validations for customer category changes.
--  120919  MaRalk  PBR-446, Modified function Copy_Existing_Customer to copy customer data depending on the customer category. 
--  120919          Renamed method Copy_Details___ as Copy_Customer_Details___. Added new methods Copy_Prospect_Details___ and     
--  120919          Copy_Enduser_Details___. Modified method Unpack_Check_Update___.
--  121019  MaRalk  PBR-591, Modified cursor definitions in Copy_Prospect_Details___, Copy_Enduser_Details___ methods.
--  121019          Added parameter customer_category_ to the New method.
--  121121  MaRalk  PBR-749, Renamed Copy_Enduser_Details___ method as Copy_End_Customer_Details___ and modified Copy_Existing_Customer. 
--  121121          Modified method Validate_Customer_Category___ to reflect the change End User as End Customer.
--  121214  MaRalk  PBR-681, Added method Get_Customer_Category_Db.
--  130128  MaRalk  PBR-1206, Added method Check_Customer_Type_Exist___ and modified methods Exist, Check_Exist 
--  1301028         in order to check the existence of specific category type customers. 
--  130311  MaIklk  Implemented to update the custmer id in connected maintenance orders when converting prospect to customer.
--  131016  Isuklk  CAHOOK-2746 Refactoring in CustomerInfo.entity
--  131120  MaIklk  Added the customer id to attr after insert.
--  140307  MaRalk  PBSC-6360, Modified Validate_Customer_Category___ to add extra conditions when converting Propect customers to
--  140307          End Customer category.
--  140415  JanWse  PBSC-8056, Copy some INVOIC parts in Copy_Prospect_Details___
--  140710  MaIklk  PRSC-1761, Added Change_Customer_Category().
--  140725  Hecolk  PRFI-41, Moved code that generates Customer Id from Check_Insert___ to Insert___ 
--  141107  MaRalk  PRSC-3112, Modified methods Copy_Customer_Details___, Copy_Prospect_Details___ to support 
--  141107          the copy_convert_option parameter. Modified methods Copy_Existing_Customer, Change_Customer_Category
--  141107          accordingly. 
--  150427  SudJlk  ORA-108, Modified Check_Delete___ to manually validate existence of Business Activity for the customer.
--  150519  MaIklk  BLU-666, Added Fetch_Customer_By_Name().
--  150706  Wahelk  BLU-956, Added transfer_addr_data parameter to Change_Customer_Category(), Copy_Customer_Details___ and modified Copy_Existing_Customer, Copy_Prospect_Details___
--  150706  JeeJlk  Bug 123400, Modified Copy_Prospect_Details___ and Copy_Customer_Details___.
--  150709  Maabse  BLU-983, Added permission check against Create_Category_Customer__
--  150708  Wahelk  BLU-956, Added new method Tranfer_Addr_Info_From_Temp___, Modified Copy_Customer_Details___, Copy_Prospect_Details___, Copy_Existing_Customer and Change_Customer_Category
--  150708  Wahelk  BLU-958, Modified method Tranfer_Addr_Info_From_Temp___
--  150713  Wahelk  BLU-959, Renamed method Tranfer_Addr_Info_From_Temp___ to Transfer_Template_Addr_Info___
--  150722  Wahelk  BLU-961, Modified Transfer_Template_Addr_Info___ to pass company_id to copy address method
--  150812  Wahelk  BLU-1191, Removed tranfer address call from Change_Customer_Category and method  Transfer_Template_Addr_Info___
--  150812  Wahelk  BLU-1192, Added parameter transfer_addr_data_ to Copy_Customer_Details___ and modified Copy_Customer_Details___ to send required parameters as record type
--                  Added transfer_addr_data_ parameter and modified method Copy_Prospect_Details___ 
--  150811  Wahelk  BLU-1192, Modified methods  Copy_Customer_Details___ and Copy_Prospect_Details___
--  150818  Wahelk  BLU-1192, Modified methods  Copy_Customer_Details___ and Copy_Prospect_Details___
--  150831  Wahelk  AFT-1434, Modified method Copy_End_Customer_Details___ to support new Copy_Param_Info parameter
--  160622  AmThLK  STRFI-2061, merged 129648, Added new method Copy_Prospect_Details___ with parameter overwrite_order_data_ to fetch order related data correctly when converting a lead to a prospect.
--  161207  IzShlk  VAULT-2202, Added logic to insert data for CRM info (Set main representative) when a new customer created.
--  180119  niedlk  SCUXX-1233, Added functionality to log CRM related history and interactions for Customer.
--  180624  JanWse  SCUXX-3748, Added public version of Pack_Table___ (Pack_Table)
--  180724  AwWelk  SCUXX-4048, Added conditional compilation for duplication logic in rmcom.
--  181008  JanWse  SCUXX-4712, Re-arranged code used for duplication check
--  190112  NiDalk  SCUXX-5085, Modified Rm_Dup_Update___ to update contact records in rm_dup_search_tab when changing customer information.
--  190206  ThJilk  Removed check for Fndab1.
--  200327  JanWse  SCXTEND-1815, Modified Rm_Dup_Update___ to include all values for CustomerInfoContact
--  200824  Hairlk  SCTA-8074, Replaced Security_SYS.Is_Method_Available with projection specific Is_Proj_Action_Available. Removed Create_Category_Customer__ since its not used anymore.
--  200909  misibr  GEFALL20-3013, added business_classification to the methods Check_Common___, New and Change_Customer_Category. 
--  210202  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in methods Write_Customer_Logo__, New, Modify and Change_Customer_Category
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Copy_Param_Info IS RECORD (
   temp_del_addr          VARCHAR2(50),
   new_del_address        VARCHAR2(50),
   copy_convert_option    VARCHAR2(14),
   overwrite_order_data   VARCHAR2(20),
   company                VARCHAR2(20),
   new_address_id         VARCHAR2(50),
   customer_category      VARCHAR2(20));

-------------------- PRIVATE DECLARATIONS -----------------------------------

separator_             CONSTANT VARCHAR2(1)  := Client_SYS.field_separator_;
no_description_        CONSTANT VARCHAR2(50) := 'NO DESCRIPTION';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Update_Cache___ (
   customer_id_ IN VARCHAR2 )
IS
BEGIN
   IF (micro_cache_value_.name IS NULL) THEN
      Invalidate_Cache___;
   END IF;
   super(customer_id_);
END Update_Cache___;


-- Copy_Customer_Details___
--   Copying all the customer data available in the existing customer.
--   In other words all the methods defined in copying_info_tab depnding on
--   module availability must be called for customer category 'CUSTOMER'.
--   copy_convert_option_ parameter is used to facilitate both functionalities 
--   change customer category and copy customer.
--   Data will be copied from a template when changing the custoemr category.
PROCEDURE Copy_Customer_Details___ (
   customer_id_          IN VARCHAR2,
   new_id_               IN VARCHAR2,
   company_              IN VARCHAR2,
   copy_convert_option_  IN VARCHAR2, 
   overwrite_order_data_ IN VARCHAR2,
   transfer_addr_data_   IN VARCHAR2 )
IS
   pkg_method_name_   VARCHAR2(200);
   module_            VARCHAR2(6);
   stmt_              VARCHAR2(200);
   new_del_address_   customer_info_address_tab.address_id%TYPE;
   temp_del_addr_     customer_info_address_tab.address_id%TYPE;
   copy_info_         Copy_Param_Info;
   new_addr_id_       customer_info_address_tab.address_id%TYPE;
   CURSOR get_copying_customer_info IS
      SELECT pkg_and_method_name, module
      FROM   copying_info_tab
      WHERE  party_type = 'CUSTOMER'
      AND    INSTR(copy_for_category, 'CUSTOMER') != 0
      AND    INSTR(copy_convert_option, copy_convert_option_) != 0
      ORDER BY exec_order;    
BEGIN     
   IF (transfer_addr_data_ = Fnd_Boolean_API.DB_TRUE) THEN
      --temp_del_addr_ has value only when transfer address data is checked
      temp_del_addr_ := Customer_Info_Address_API.Get_Default_Address(customer_id_, Address_Type_Code_API.Decode('DELIVERY'), SYSDATE); 
      new_del_address_ := Customer_Info_Address_API.Get_Default_Address(new_id_, Address_Type_Code_API.Decode('DELIVERY'), SYSDATE);      
   END IF;
   -- template address has a value only when transfer address data is checked
   copy_info_.temp_del_addr := temp_del_addr_;
   copy_info_.new_del_address := new_del_address_;
   copy_info_.copy_convert_option := copy_convert_option_;
   copy_info_.overwrite_order_data := overwrite_order_data_;
   OPEN get_copying_customer_info;
   WHILE (TRUE) LOOP
      FETCH get_copying_customer_info INTO pkg_method_name_, module_;
      EXIT WHEN get_copying_customer_info%NOTFOUND;
      Assert_SYS.Assert_Is_Package_Method(pkg_method_name_);
      IF (module_ = 'INVOIC') THEN
         IF (Dictionary_SYS.Component_Is_Active('INVOIC')) THEN
            IF (new_del_address_ IS NULL) THEN
               --use created new delivery address id if address id already exist
               copy_info_.new_del_address := NVL(copy_info_.new_address_id,temp_del_addr_);
            END IF;
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_, :company_, :copy_info_); END;';
            @ApproveDynamicStatement(2005-11-10,ovjose)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_, company_, copy_info_; 
         END IF;
      ELSIF (module_ = 'PAYLED') THEN
         IF (Dictionary_SYS.Component_Is_Active('PAYLED')) THEN
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_, :company_); END;';
            @ApproveDynamicStatement(2005-11-10,ovjose)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_, company_;
         END IF;                                          
      ELSIF (module_ = 'PRJREP') THEN
         IF (Dictionary_SYS.Component_Is_Active('PRJREP')) THEN
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_, :company_); END;';
            @ApproveDynamicStatement(2012-03-22,krwipl)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_, company_;
         END IF;                                          
      ELSIF (module_ = 'ENTERP') THEN
         IF (pkg_method_name_ = 'Comm_Method_API.Copy_Identity_Info') THEN
            IF (Customer_Info_API.Get_One_Time_Db(customer_id_) = 'FALSE') THEN
               IF (copy_convert_option_ = 'CONVERT') THEN
                  IF (temp_del_addr_ IS NOT NULL AND new_del_address_ IS NULL) THEN
                     Comm_Method_API.Copy_Identity_Info('CUSTOMER', customer_id_, new_id_, temp_del_addr_, NVL(copy_info_.new_address_id,temp_del_addr_));
                  END IF;
               ELSE
                  Comm_Method_API.Copy_Identity_Info('CUSTOMER', customer_id_, new_id_);
               END IF;
            END IF;
         ELSIF (pkg_method_name_ = 'Customer_Info_Address_API.Copy_Customer') THEN
            copy_info_.company := company_;
            Customer_Info_Address_API.Copy_Customer(new_addr_id_, customer_id_, new_id_, copy_info_);
            copy_info_.new_address_id := new_addr_id_;
         ELSE           
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_, :copy_info_); END;';
            @ApproveDynamicStatement(2015-08-13,wahelk)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_, copy_info_;
         END IF;
      ELSIF (module_ = 'ORDER') THEN
         IF (Dictionary_SYS.Component_Is_Active('ORDER')) THEN
            IF (new_del_address_ IS NULL) THEN
               --use created new delivery address id if address id already exist
               copy_info_.new_del_address := NVL(copy_info_.new_address_id,temp_del_addr_);
            END IF;
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_, :copy_info_); END;';
            @ApproveDynamicStatement(2013-12-13,chhulk)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_, copy_info_;
         END IF; 
      ELSIF (module_ = 'CRM') THEN
         IF (Dictionary_SYS.Component_Is_Active('CRM')) THEN
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_); END;';
            @ApproveDynamicStatement(2014-04-22,chhulk)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_;
         END IF;         
      END IF;
   END LOOP;
   CLOSE get_copying_customer_info;
END Copy_Customer_Details___;


-- Copy_Prospect_Details___
--   Copying customer data which are allowed for the customer category 'PROSPECT'.
--   In other words if 'PROSPECT' is included in the copy_for_category
--   column in copying_info_tab, only the corresponding methods are
--   called to copy existing customer data to a 'PROSPECT' customer.
--   copy_convert_option_ parameter is used to facilitate both functionalities 
--   change customer category and copy customer.
--   Data will be copied from a template when changing the custoemr category.
PROCEDURE Copy_Prospect_Details___ (
   customer_id_          IN VARCHAR2,
   new_id_               IN VARCHAR2,
   company_              IN VARCHAR2,
   copy_convert_option_  IN VARCHAR2,
   transfer_addr_data_   IN VARCHAR2,
   customer_category_    IN VARCHAR2,
   overwrite_order_data_ IN VARCHAR2 )
IS
   pkg_method_name_   VARCHAR2(200);
   module_            VARCHAR2(6);
   stmt_              VARCHAR2(200);
   new_del_address_   customer_info_address_tab.address_id%TYPE;
   temp_del_addr_     customer_info_address_tab.address_id%TYPE;
   copy_info_         Copy_Param_Info;
   new_addr_id_       customer_info_address_tab.address_id%TYPE;
   CURSOR get_copying_prospect_info IS
      SELECT pkg_and_method_name, module
      FROM   copying_info_tab
      WHERE  party_type = 'CUSTOMER'
      AND    INSTR(copy_for_category, 'PROSPECT') != 0
      AND    INSTR(copy_convert_option, copy_convert_option_) != 0
      ORDER BY exec_order;
BEGIN
   IF (transfer_addr_data_ = Fnd_Boolean_API.DB_TRUE) THEN
      --temp_del_addr_ has value only when transfer address data is checked
      temp_del_addr_ := Customer_Info_Address_API.Get_Default_Address(customer_id_, Address_Type_Code_API.Decode('DELIVERY'), SYSDATE); 
      new_del_address_ := Customer_Info_Address_API.Get_Default_Address(new_id_, Address_Type_Code_API.Decode('DELIVERY'), SYSDATE);      
   END IF;
   --template address has a value only when transfer address data is checked
   copy_info_.temp_del_addr := temp_del_addr_;
   copy_info_.new_del_address := new_del_address_;
   copy_info_.copy_convert_option := copy_convert_option_;
   copy_info_.customer_category := customer_category_;
   copy_info_.overwrite_order_data := overwrite_order_data_;     
   OPEN get_copying_prospect_info;
   WHILE (TRUE) LOOP
      FETCH get_copying_prospect_info INTO pkg_method_name_, module_;
      EXIT WHEN get_copying_prospect_info%NOTFOUND;
      Assert_SYS.Assert_Is_Package_Method(pkg_method_name_);
      IF (module_ = 'INVOIC') THEN
         IF (Dictionary_SYS.Component_Is_Active('INVOIC')) THEN
            IF (new_del_address_ IS NULL) THEN
               --use created new delivery address id if address id already exist
               copy_info_.new_del_address := NVL(copy_info_.new_address_id,temp_del_addr_);
            END IF;
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_, :company_, :copy_info_); END;';
            @ApproveDynamicStatement(2014-04-11,janwse)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_, company_, copy_info_;        
         END IF;
      ELSIF (module_ = 'ENTERP' ) THEN
         IF (pkg_method_name_ = 'Comm_Method_API.Copy_Identity_Info') THEN
            IF (copy_convert_option_ = 'CONVERT') THEN
               IF (temp_del_addr_ IS NOT NULL AND new_del_address_ IS NULL) THEN
                  Comm_Method_API.Copy_Identity_Info('CUSTOMER', customer_id_, new_id_, NVL(copy_info_.new_address_id,temp_del_addr_), temp_del_addr_);
               END IF;
            ELSE
               Comm_Method_API.Copy_Identity_Info('CUSTOMER', customer_id_, new_id_);
            END IF; 
         ELSIF (pkg_method_name_ = 'Customer_Info_Address_API.Copy_Customer') THEN
            copy_info_.company := company_;
            Customer_Info_Address_API.Copy_Customer(new_addr_id_, customer_id_, new_id_, copy_info_);
            copy_info_.new_address_id := new_addr_id_;                              
         ELSE
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_, :copy_info_); END;';
            @ApproveDynamicStatement(2015-08-13,wahelk)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_, copy_info_;
         END IF;
      ELSIF (module_ = 'ORDER') THEN
         IF (Dictionary_SYS.Component_Is_Active('ORDER')) THEN
            IF (new_del_address_ IS NULL) THEN
               --use created new delivery address id if address id already exist
               copy_info_.new_del_address := NVL(copy_info_.new_address_id,temp_del_addr_);
            END IF;
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_, :copy_info_); END;';
            @ApproveDynamicStatement(2013-12-13,chhulk)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_, copy_info_;
         END IF;          
      ELSIF (module_ = 'CRM') THEN
         IF (Dictionary_SYS.Component_Is_Active('CRM')) THEN
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_); END;';
            @ApproveDynamicStatement(2014-04-22,chhulk)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_;
         END IF;         
      END IF;
   END LOOP;
   CLOSE get_copying_prospect_info;
END Copy_Prospect_Details___;


-- Copy_End_Customer_Details___
--   Copying customer data which are allowed for the customer category 'END_CUSTOMER'.
--   In other words if 'END_CUSTOMER' is included in the copy_for_category column
--   in copying_info_tab, only the corresponding methods are called to copy
--   existing customer data to a 'END_CUSTOMER' customer.
PROCEDURE Copy_End_Customer_Details___ (
   customer_id_         IN VARCHAR2,
   new_id_              IN VARCHAR2,
   copy_convert_option_ IN VARCHAR2 )
IS
   pkg_method_name_   VARCHAR2(200);
   module_            VARCHAR2(6);
   stmt_              VARCHAR2(100);
   copy_info_         Copy_Param_Info;
   new_addr_id_       customer_info_address_tab.address_id%TYPE;
   CURSOR get_copying_end_customer_info IS
      SELECT pkg_and_method_name, module
      FROM   copying_info_tab
      WHERE  party_type = 'CUSTOMER'
      AND    INSTR(copy_for_category, 'END_CUSTOMER') != 0
      ORDER BY exec_order;
BEGIN
   copy_info_.copy_convert_option := copy_convert_option_;
   OPEN get_copying_end_customer_info;
   WHILE (TRUE) LOOP
      FETCH get_copying_end_customer_info INTO pkg_method_name_, module_;
      EXIT WHEN get_copying_end_customer_info%NOTFOUND;
      Assert_SYS.Assert_Is_Package_Method(pkg_method_name_);
      IF (module_ = 'ENTERP') THEN
         IF (pkg_method_name_ = 'Comm_Method_API.Copy_Identity_Info') THEN   
            Comm_Method_API.Copy_Identity_Info('CUSTOMER', customer_id_, new_id_);     
         ELSIF (pkg_method_name_ = 'Customer_Info_Address_API.Copy_Customer') THEN
            Customer_Info_Address_API.Copy_Customer(new_addr_id_, customer_id_, new_id_, copy_info_);
         ELSE
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_, :copy_info_); END;';
            @ApproveDynamicStatement(2015-08-31,wahelk)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_, copy_info_;
         END IF;
      ELSIF (module_ = 'CRM') THEN
         IF (Dictionary_SYS.Component_Is_Active('CRM')) THEN
            stmt_ := 'BEGIN '||pkg_method_name_||'(:customer_id_, :new_id_); END;';
            @ApproveDynamicStatement(2014-04-22,chhulk)
            EXECUTE IMMEDIATE stmt_ USING customer_id_, new_id_;
         END IF;         
      END IF;
   END LOOP;
   CLOSE get_copying_end_customer_info;
END Copy_End_Customer_Details___;


PROCEDURE Get_Next_Party___ (
   newrec_ IN OUT customer_info_tab%ROWTYPE )
IS
BEGIN
   Party_Id_API.Get_Next_Party('DEFAULT', newrec_.party);   
END Get_Next_Party___;


-- Validate_Customer_Category___
--   Performs validation when Customer Category changes.
PROCEDURE Validate_Customer_Category___ (
   oldrec_ IN customer_info_tab%ROWTYPE,
   newrec_ IN customer_info_tab%ROWTYPE )
IS
BEGIN
   IF (oldrec_.customer_category = Customer_Category_API.DB_CUSTOMER) THEN
      Error_SYS.Record_General(lu_name_, 'CUSCATEGORYNOTALLOWED: It is not possible to change the category of the customer from Customer to :P1.', Customer_Category_API.Decode(newrec_.customer_category));
   END IF;  
   -- Changing a Prospect to End Customer is not allowed if opportunities have been created.
   IF ((oldrec_.customer_category = Customer_Category_API.DB_PROSPECT) AND (newrec_.customer_category = Customer_Category_API.DB_END_CUSTOMER)) THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         IF (Business_Opportunity_API.Exist_Cust_Opportunities(newrec_.customer_id)) THEN
            Error_SYS.Record_General(lu_name_, 'OPPORTUNITIESEXIST: It is not possible to change the category to :P1 when opportunities have been created.',Customer_Category_API.Decode(Customer_Category_API.DB_END_CUSTOMER));   
         END IF;         
      $END
      $IF Component_Order_SYS.INSTALLED $THEN
         IF (Order_Quotation_API.Exist_Sales_Quotations(newrec_.customer_id)) THEN
            Error_SYS.Record_General(lu_name_, 'SALESQUOTATIONSEXIST: It is not possible to change the category to :P1 when sales quotations have been created.',Customer_Category_API.Decode(Customer_Category_API.DB_END_CUSTOMER));   
         END IF;             
      $END  
      $IF Component_Srvquo_SYS.INSTALLED $THEN
         IF (Service_Quotation_API.Exist_Service_Quotations(newrec_.customer_id)) THEN
            Error_SYS.Record_General(lu_name_, 'SERVICEQUOTATIONSEXIST: It is not possible to change the category to :P1 when service quotations have been created.',Customer_Category_API.Decode(Customer_Category_API.DB_END_CUSTOMER));   
         END IF;         
      $END
      $IF Component_Conmgt_SYS.INSTALLED $THEN
         IF (Sales_Contract_API.Exist_Sales_Contracts(newrec_.customer_id)) THEN
            Error_SYS.Record_General(lu_name_, 'SALESCONTRACTSEXISTS: It is not possible to change the category to :P1 when sales contracts have been created.',Customer_Category_API.Decode(Customer_Category_API.DB_END_CUSTOMER));   
         END IF;  
         IF (Contract_Customer_API.Is_Contract_Customer(newrec_.customer_id)) THEN
            Error_SYS.Record_General(lu_name_, 'EXISTSASCONTRACTCUSTOMER: It is not possible to change the category to :P1 when connected as a sales contract customer.',Customer_Category_API.Decode(Customer_Category_API.DB_END_CUSTOMER));   
         END IF; 
      $END 
      NULL;
   END IF;     
END Validate_Customer_Category___;   


FUNCTION Check_Customer_Type_Exist___ (
   customer_id_       IN VARCHAR2,
   customer_category_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   customer_info_tab
      WHERE  customer_id = customer_id_
      AND    customer_category = customer_category_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Customer_Type_Exist___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_info_tab%ROWTYPE,
   newrec_ IN OUT customer_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   exists_                VARCHAR2(5);
   customer_              VARCHAR2(200);
BEGIN
   IF ((oldrec_.association_no != newrec_.association_no) OR (oldrec_.association_no IS NULL)) THEN
      exists_ := Association_Info_API.Association_No_Exist(newrec_.association_no, 'CUSTOMER');
      IF (exists_ = 'TRUE') THEN
         IF (newrec_.customer_id IS NULL) THEN
            customer_ := newrec_.name;
         ELSE
            customer_ := newrec_.customer_id;
         END IF;
         Client_SYS.Add_Warning(lu_name_, 'WARNSAMEASCNO: Another business partner with the association number :P1 is already registered. Do you want to use the same Association No for :P2?', newrec_.association_no, customer_);
      END IF;
   END IF;
   IF (oldrec_.country != newrec_.country) THEN
      IF ((newrec_.corporate_form IS NOT NULL) AND NOT (Corporate_Form_API.Exists(newrec_.country, newrec_.corporate_form))) THEN
         Error_SYS.Record_General(lu_name_, 'COPFORMNOTEXIST: The form of business ID :P1 is not valid for the country code :P2. Select a form of business that is connected to country code :P2 in the Form of Business field.', newrec_.corporate_form, newrec_.country);
      END IF;
      IF ((newrec_.business_classification IS NOT NULL) AND NOT (Business_Classification_API.Exists(newrec_.country, newrec_.business_classification))) THEN
         Error_SYS.Record_General(lu_name_, 'BUSINESSCLASSIFNOTEXIST: The classification of business ID :P1 is not valid for the country code :P2. Select a classification of business that is connected to country code :P2 in the Classification of Business field.', newrec_.business_classification, newrec_.country);
      END IF;      
   END IF;
   IF (oldrec_.one_time != newrec_.one_time) THEN
      Validate_One_Time_Customer__(newrec_.customer_id);
   END IF;
   Attribute_Definition_API.Check_Value(newrec_.customer_id, lu_name_, 'CUSTOMER_ID');   
   IF (newrec_.identifier_ref_validation IS NULL) THEN
      newrec_.identifier_ref_validation := 'NONE';
   END IF;
   IF (newrec_.one_time IS NULL) THEN
      newrec_.one_time := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (newrec_.identifier_reference IS NOT NULL AND newrec_.identifier_ref_validation != 'NONE') THEN
      Identifier_Ref_Validation_API.Check_Identifier_Reference(newrec_.identifier_reference, newrec_.identifier_ref_validation);
   END IF;
   $IF NOT Component_Payled_SYS.INSTALLED $THEN
      IF (newrec_.one_time = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'ONETIMENTALLWDPAY: The One-Time check box for customer :P1 cannot be set because the component PAYLED is not active.', newrec_.customer_id);
      END IF;
   $END
   IF (newrec_.customer_category IN (Customer_Category_API.DB_PROSPECT, Customer_Category_API.DB_END_CUSTOMER)) THEN
      IF (newrec_.one_time = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'ONETIMECUSTCTGRY: The One-Time check box cannot be set for a customer with category :P1 and :P2.', 
                                  Customer_Category_API.Decode(Customer_Category_API.DB_PROSPECT), Customer_Category_API.Decode(Customer_Category_API.DB_END_CUSTOMER));
      END IF;
      IF (newrec_.b2b_customer = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'CATEGORYB2BCUST: The B2BCustomer check box cannot be set for a customer with category :P1 and :P2.', 
                                  Customer_Category_API.Decode(Customer_Category_API.DB_PROSPECT), Customer_Category_API.Decode(Customer_Category_API.DB_END_CUSTOMER));
      END IF;
   END IF;
   IF (newrec_.one_time = 'TRUE' AND newrec_.b2b_customer = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'ONETIMEB2BCUST: A One-Time customer cannot be a B2B customer.');
   END IF;
   -- default value for b2b_customer is FALSE
   IF (newrec_.b2b_customer IS NULL) THEN
      newrec_.b2b_customer := 'FALSE';
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CREATION_DATE', TRUNC(SYSDATE), attr_);
   Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode('CUSTOMER'), attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('IDENTIFIER_REF_VALIDATION', Identifier_Ref_Validation_API.Decode('NONE'), attr_);   
   Client_SYS.Add_To_Attr('ONE_TIME_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('B2B_CUSTOMER_DB', Fnd_Boolean_API.DB_FALSE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT customer_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.customer_id IS NULL) THEN
      newrec_.customer_id := Get_Next_Identity;      
      IF (newrec_.customer_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CUST_ERROR: Error while retrieving the next free identity. Check the identity series for customer');
      END IF;
      Party_Identity_Series_API.Update_Next_Value(newrec_.customer_id + 1, newrec_.party_type);
      Client_SYS.Set_Item_Value('CUSTOMER_ID', newrec_.customer_id, attr_);
   END IF;    
   Get_Next_Party___(newrec_);   
   super(objid_, objversion_, newrec_, attr_);   
   Client_SYS.Add_To_Attr('CUSTOMER_ID', newrec_.customer_id, attr_);
   $IF Component_Crm_SYS.INSTALLED $THEN
      Rm_Acc_Representative_API.Add_Default_Representative(newrec_.customer_id);
   $END
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Insert___(newrec_);
      Rm_Dup_Check_For_Duplicate___(attr_, newrec_);
   $ELSE
      NULL;
   $END
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     customer_info_tab%ROWTYPE,
   newrec_     IN OUT customer_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   key_ref_          VARCHAR2(600);
   is_obj_con_       VARCHAR2(5);
BEGIN   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   $IF Component_Docman_SYS.INSTALLED $THEN
      IF (newrec_.name != oldrec_.name) THEN
         Client_SYS.Get_Key_Reference( key_ref_, lu_name_, objid_);         
         is_obj_con_ :=  Doc_Reference_Object_API.Exist_Obj_Reference(lu_name_, key_ref_);
         IF (is_obj_con_ = 'TRUE') THEN
            Doc_Reference_Object_API.Refresh_Object_Reference_Desc(lu_name_, key_ref_);
         END IF;                  
      END IF;
   $END
   IF ((oldrec_.customer_category = Customer_Category_API.DB_PROSPECT) AND (newrec_.customer_category = Customer_Category_API.DB_CUSTOMER)) THEN
      $IF Component_Srvquo_SYS.INSTALLED $THEN
         Service_Quotation_Conn_API.Modify_Connected_Customer(newrec_.customer_id);
      $ELSE
         NULL;
      $END
   END IF;
   $IF Component_Crm_SYS.INSTALLED $THEN
      Log_Column_Changes___(oldrec_, newrec_);
   $END
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Update___(newrec_);
      Rm_Dup_Check_For_Duplicate___(attr_, newrec_);
   $ELSE
      NULL;
   $END
   Invalidate_Cache___;
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.customer_category = Customer_Category_API.DB_CUSTOMER) THEN
      IF NOT (Security_SYS.Is_Proj_Action_Available('CustomerHandling', 'CheckCreateCategoryCustomer')) THEN
         Error_SYS.Record_General(lu_name_, 'NOACCESSTOCREATECUSTOMER: You have no permission to create customers of category :P1', Customer_Category_API.Decode(newrec_.customer_category));
      END IF;
   END IF;
   IF (indrec_.customer_id = TRUE) THEN
      IF (UPPER(newrec_.customer_id) != newrec_.customer_id) THEN
         Error_SYS.Record_General(lu_name_, 'CAPCHECK: Only capital letters are allowed in the ID.');
      END IF;
   END IF;   
   super(newrec_, indrec_, attr_); 
END Check_Insert___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN customer_info_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   -- Delete any referenced binary object
   IF (NOT remrec_.picture_id IS NULL) AND (remrec_.picture_id != 0) THEN
      Binary_Object_API.Do_Delete(remrec_.picture_id);
   END IF;
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Delete___(remrec_);
   $ELSE
      NULL;
   $END
END Delete___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_info_tab%ROWTYPE,
   newrec_ IN OUT customer_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN         
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY', newrec_.party);         
   IF (oldrec_.customer_category != newrec_.customer_category) THEN
      IF (newrec_.customer_category = Customer_Category_API.DB_CUSTOMER) THEN
         IF NOT (Security_SYS.Is_Proj_Action_Available('CustomerHandling', 'CheckCreateCategoryCustomer')) THEN
            Error_SYS.Record_General(lu_name_, 'NOACCESSTOCREATECUSTOMER: You have no permission to create customers of category :P1', Customer_Category_API.Decode(newrec_.customer_category));
         END IF;
      END IF;
      Validate_Customer_Category___(oldrec_, newrec_);
   END IF;
   IF (oldrec_.b2b_customer = 'TRUE' AND newrec_.b2b_customer = 'FALSE' AND B2b_User_Util_API.Customer_Users_Exists(newrec_.customer_id)) THEN
      Error_SYS.Record_General(lu_name_, 'B2BCUUSERXIST: There are Users connected to Customer :P1. B2B Customer must not be unchecked.', newrec_.customer_id);
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN customer_info_tab%ROWTYPE )
IS
BEGIN
   $IF Component_Crm_SYS.INSTALLED $THEN
      Business_Activity_API.Check_Business_Activity(remrec_.customer_id, remrec_.party_type);                  
   $END
   super(remrec_);
END Check_Delete___;


PROCEDURE Log_Column_Changes___ (
   oldrec_     IN customer_info_tab%ROWTYPE,
   newrec_     IN customer_info_tab%ROWTYPE )
IS
   old_attr_  VARCHAR2(32000):= Pack_Table___(oldrec_);
   new_attr_  VARCHAR2(32000):= Pack_Table___(newrec_);
   name_      VARCHAR2(50);
   new_value_ VARCHAR2(4000);
   old_value_ VARCHAR2(4000);
   ptr_       NUMBER;
BEGIN
   $IF Component_Crm_SYS.INSTALLED $THEN      
      WHILE (Client_SYS.Get_Next_From_Attr(new_attr_, ptr_, name_, new_value_)) LOOP
         IF (Business_Object_Columns_API.Exists_Customer_Info_Db(name_)) THEN
            old_value_ := Client_SYS.Get_Item_Value(name_, old_attr_);
            IF (Validate_SYS.Is_Different(old_value_, new_value_)) THEN               
               Crm_Cust_Info_History_API.Log_History(oldrec_, newrec_, name_, old_value_, new_value_);
            END IF;
         END IF;
      END LOOP;
   $ELSE
      NULL;
   $END
END Log_Column_Changes___;


PROCEDURE Rm_Dup_Insert___ (
   rec_  IN customer_info_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Insert(lu_name_, attr_);
   $ELSE
      NULL;
   $END
END Rm_Dup_Insert___;


PROCEDURE Rm_Dup_Update___ (
   rec_  IN customer_info_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Update(lu_name_, attr_);
      -- Update contact information
      FOR contact_rec_ IN (SELECT * FROM customer_info_contact_tab WHERE customer_id = rec_.customer_id) LOOP
         attr_ := Customer_Info_Contact_API.Pack_Table(contact_rec_);
         Rm_Dup_Util_API.Search_Table_Update('CustomerInfoContact', attr_);
      END LOOP;
   $ELSE 
      NULL;
   $END
END Rm_Dup_Update___;


PROCEDURE Rm_Dup_Delete___ (
   rec_  IN customer_info_tab%ROWTYPE )
IS
   attr_ VARCHAR2(32000) := Pack_Table___(rec_);
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      Rm_Dup_Util_API.Search_Table_Delete(lu_name_, attr_);
   $ELSE 
      NULL;
   $END
END Rm_Dup_Delete___;


PROCEDURE Rm_Dup_Check_For_Duplicate___ (
   attr_ IN OUT VARCHAR2,
   rec_  IN     customer_info_tab%ROWTYPE )
IS
   dup_attr_   VARCHAR2(32000);
   dup_action_ VARCHAR2(50) := 'DUPLICATE_ACTION';
   dup_keys_   VARCHAR2(50) := 'DUPLICATE_KEYS';
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      dup_attr_ := Pack_Table___(rec_);
      Rm_Dup_Util_API.Check_For_Duplicate(dup_attr_, lu_name_);
      IF (Client_SYS.Item_Exist(dup_action_, dup_attr_)) THEN 
         Client_SYS.Add_To_Attr(dup_action_, Client_SYS.Get_Item_Value(dup_action_, dup_attr_), attr_);
      END IF;
      IF (Client_SYS.Item_Exist(dup_keys_, dup_attr_)) THEN 
         Client_SYS.Add_To_Attr(dup_keys_, Client_SYS.Get_Item_Value(dup_keys_, dup_attr_), attr_);
      END IF;
   $ELSE
      NULL;
   $END
END Rm_Dup_Check_For_Duplicate___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Validate_One_Time_Customer__ (
   customer_id_ IN VARCHAR2 )
IS
   one_time_not_allowed EXCEPTION;
   temp_                VARCHAR2(1000);
   error_info_          VARCHAR2(100);
   $IF Component_Invoic_SYS.INSTALLED $THEN
      CURSOR is_exist_inv IS
         SELECT 1
         FROM   invoice 
         WHERE  identity = customer_id_
         AND    party_type_db = 'CUSTOMER';
   $END
   $IF Component_Payled_SYS.INSTALLED $THEN
      CURSOR is_exist_ledg IS
         SELECT 1
         FROM   ledger_item 
         WHERE  identity = customer_id_
         AND    party_type_db = 'CUSTOMER';
      CURSOR is_exist_pay IS
         SELECT other_payee_identity || deduction_group || corporation_id || member_id
         FROM   identity_pay_info 
         WHERE  identity = customer_id_
         AND    party_type_db = 'CUSTOMER';
   $END
   $IF Component_Order_SYS.INSTALLED $THEN
      CURSOR is_exist_ord IS
         SELECT 1
         FROM   cust_ord_customer_ent
         WHERE  customer_id = customer_id_;
      CURSOR is_exist_ord_addr IS
         SELECT 1
         FROM   cust_ord_customer_address_ent
         WHERE  customer_id = customer_id_;
   $END
   $IF Component_Prjrep_SYS.INSTALLED $THEN
      CURSOR is_exist_prj IS
         SELECT 1
         FROM   customer_prjrep_params
         WHERE  identity = customer_id_;
   $END
   $IF Component_Proj_SYS.INSTALLED $THEN
      CURSOR is_exist_proj IS
         SELECT 1
         FROM   project_base
         WHERE  customer_id = customer_id_;
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
      -- on account ledger item
      OPEN  is_exist_ledg;
      FETCH is_exist_ledg INTO temp_;
      IF (is_exist_ledg%FOUND) THEN
         error_info_ := Language_SYS.Translate_Constant(lu_name_, 'ONEERRLEDG: Ledger Item');
         RAISE one_time_not_allowed;
      END IF;
      CLOSE is_exist_ledg;
      temp_ := NULL;
      OPEN  is_exist_pay;
      FETCH is_exist_pay INTO temp_;
      IF (temp_ IS NOT NULL) THEN
         error_info_ := Language_SYS.Translate_Constant(lu_name_, 'ONEERRPAY: Payment');
         RAISE one_time_not_allowed;
      END IF;
      CLOSE is_exist_pay;
   $ELSE
      NULL;
   $END
   $IF Component_Order_SYS.INSTALLED $THEN
      OPEN  is_exist_ord;
      FETCH is_exist_ord INTO temp_;
      IF (is_exist_ord%FOUND) THEN
         error_info_ := Language_SYS.Translate_Constant(lu_name_, 'ONEERRORD: Order');
         RAISE one_time_not_allowed;
      END IF;
      CLOSE is_exist_ord;
      OPEN  is_exist_ord_addr;
      FETCH is_exist_ord_addr INTO temp_;
      IF (is_exist_ord_addr%FOUND) THEN
         error_info_ := Language_SYS.Translate_Constant(lu_name_, 'ONEERRORDADDR: Order Address Info');
         RAISE one_time_not_allowed;
      END IF;
      CLOSE is_exist_ord_addr;
   $ELSE
      NULL;
   $END
   $IF Component_Prjrep_SYS.INSTALLED $THEN
      OPEN  is_exist_prj;
      FETCH is_exist_prj INTO temp_;
      IF (is_exist_prj%FOUND) THEN
         error_info_ := Language_SYS.Translate_Constant(lu_name_, 'ONEERRPRJREP: Project Reporting');
         RAISE one_time_not_allowed;
      END IF;
      CLOSE is_exist_prj;
   $ELSE
      NULL;
   $END
   $IF Component_Proj_SYS.INSTALLED $THEN
      OPEN  is_exist_proj;
      FETCH is_exist_proj INTO temp_;
      IF (is_exist_proj%FOUND) THEN
         error_info_ := Language_SYS.Translate_Constant(lu_name_, 'ONEERRPRJ: Project');
         RAISE one_time_not_allowed;
      END IF;
      CLOSE is_exist_proj;
   $ELSE
      NULL;
   $END
EXCEPTION
   WHEN one_time_not_allowed THEN
      Error_SYS.Record_General(lu_name_, 'ONETIMENTALLWD: The One-Time check box for customer :P1 cannot be modified due to the existing information in :P2.', customer_id_, error_info_);
END Validate_One_Time_Customer__;


-- This method is to be used by Aurena
PROCEDURE Write_Customer_Logo__ (
   objversion_      IN VARCHAR2,
   objid_           IN VARCHAR2,
   customer_logo##  IN BLOB )
IS  
   rec_            customer_info_tab%ROWTYPE;
   picture_id_     customer_info.picture_id%TYPE;
   pic_objversion_ binary_object_data_block.objversion%TYPE;
   pic_objid_      binary_object_data_block.objid%TYPE;
   customer_id_    customer_info.customer_id%TYPE;
BEGIN
   rec_         := Get_Object_By_Id___(objid_);  
   customer_id_ := rec_.customer_id;
   picture_id_  := Customer_Info_API.Get_Picture_Id(customer_id_);
   IF (customer_logo## IS NOT NULL) THEN
      Binary_Object_API.Create_Or_Replace(picture_id_, customer_id_ , '' , '' , 'FALSE' , 0 , 'PICTURE' , '' );
      Binary_Object_Data_Block_API.New__(pic_objversion_, pic_objid_, picture_id_, NULL);
      Binary_Object_Data_Block_API.Write_Data__(pic_objversion_, pic_objid_, customer_logo##); 
   ELSE
      Binary_Object_API.Do_Delete(picture_id_);
      picture_id_ := NULL;
   END IF;
   rec_.picture_id := picture_id_;
   Modify___(rec_);
END Write_Customer_Logo__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override 
@UncheckedAccess
PROCEDURE Exist (
   customer_id_       IN VARCHAR2,
   customer_category_ IN VARCHAR2 DEFAULT 'CUSTOMER')
IS
BEGIN
   super(customer_id_);
   IF (NOT Check_Customer_Type_Exist___(customer_id_, customer_category_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_, 'NOTEXIST: Customer :P1 is not of category :P2.', customer_id_, Customer_Category_API.Decode(customer_category_)); 
   END IF;   
END Exist;


FUNCTION Get_Id_From_Reference (
   identifier_reference_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   customer_id_   customer_info_tab.customer_id%TYPE;
   CURSOR get_id IS
      SELECT customer_id
      FROM   customer_info_tab
      WHERE  identifier_reference = identifier_reference_;
BEGIN
   OPEN  get_id;
   FETCH get_id INTO customer_id_;
   IF (get_id%NOTFOUND) THEN
      customer_id_ := NULL;
   END IF;
   CLOSE get_id;
   RETURN customer_id_;
END Get_Id_From_Reference;


FUNCTION Get_Id_From_Association_No (
   association_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   customer_id_       customer_info_tab.customer_id%TYPE;
   CURSOR get_id IS
      SELECT customer_id
      FROM   customer_info_tab
      WHERE  association_no = association_no_;
BEGIN
   OPEN  get_id;
   FETCH get_id INTO customer_id_;
   IF (get_id%NOTFOUND) THEN
      customer_id_ := NULL;
   END IF;
   CLOSE get_id;
   RETURN customer_id_;
END Get_Id_From_Association_No;


@UncheckedAccess
FUNCTION Check_Exist (
   customer_id_       IN VARCHAR2, 
   customer_category_ IN VARCHAR2 DEFAULT 'CUSTOMER' ) RETURN VARCHAR2
IS
BEGIN
   IF NOT Check_Exist___(customer_id_) THEN
      RETURN 'FALSE';
   ELSIF (Check_Customer_Type_Exist___(customer_id_, customer_category_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;      
END Check_Exist;


@ObjectConnectionMethod
@UncheckedAccess
FUNCTION Get_Doc_Object_Description (
   customer_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_description_    VARCHAR2(122);
   CURSOR get_obj_description IS
      SELECT customer_id||'-'||name description
      FROM   customer_info_tab
      WHERE  customer_id = customer_id_;
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


PROCEDURE New (
   customer_id_               IN VARCHAR2,
   name_                      IN VARCHAR2,
   customer_category_         IN VARCHAR2,
   association_no_            IN VARCHAR2 DEFAULT NULL,
   country_                   IN VARCHAR2 DEFAULT NULL,
   default_language_          IN VARCHAR2 DEFAULT NULL,
   corporate_form_            IN VARCHAR2 DEFAULT NULL,
   business_classification_   IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       customer_info_tab%ROWTYPE;
BEGIN
   newrec_.creation_date             := TRUNC(SYSDATE);
   newrec_.party_type                := Party_Type_API.DB_CUSTOMER;
   newrec_.default_domain            := 'TRUE';
   newrec_.identifier_ref_validation := 'NONE';
   newrec_.one_time                  := Fnd_Boolean_API.DB_FALSE;
   newrec_.b2b_customer              := Fnd_Boolean_API.DB_FALSE;
   newrec_.customer_id               := customer_id_;
   newrec_.name                      := name_;
   newrec_.customer_category         := customer_category_;
   newrec_.association_no            := association_no_;
   newrec_.country                   := Iso_Country_API.Encode(country_);
   newrec_.default_language          := Iso_Language_API.Encode(default_language_);
   newrec_.corporate_form            := corporate_form_;
   newrec_.business_classification   := business_classification_;
   New___(newrec_);
END New;


PROCEDURE Modify (
   customer_id_      IN VARCHAR2,
   name_             IN VARCHAR2 DEFAULT NULL,
   association_no_   IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_       customer_info_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(customer_id_);
   newrec_.name               := name_;
   newrec_.association_no     := association_no_;
   newrec_.country            := Iso_Country_API.Encode(country_);
   newrec_.default_language   := Iso_Language_API.Encode(default_language_);
   Modify___(newrec_);
END Modify;


PROCEDURE Remove (
   customer_id_ IN VARCHAR2 )
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(200);
   remrec_      customer_info_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, customer_id_);
   remrec_ := Lock_By_Keys___(customer_id_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


PROCEDURE Get_Control_Type_Value_Desc (
   desc_    IN OUT VARCHAR2,
   company_ IN     VARCHAR2,
   value_   IN     VARCHAR2 )
IS
BEGIN
   desc_ := SUBSTR(Get_Name(value_), 1, 35);
END Get_Control_Type_Value_Desc;


PROCEDURE Copy_Existing_Customer (
   customer_id_    IN VARCHAR2,
   new_id_         IN VARCHAR2,
   company_        IN VARCHAR2,
   new_name_       IN VARCHAR2,
   new_category_   IN VARCHAR2,
   association_no_ IN VARCHAR2 DEFAULT NULL )
IS   
   customer_exist_    VARCHAR2(5); 
   new_category_db_   VARCHAR2(20);
   newrec_            customer_info_tab%ROWTYPE;
   oldrec_            customer_info_tab%ROWTYPE;
   CURSOR get_attr IS
      SELECT *
      FROM customer_info_tab
      WHERE customer_id = customer_id_;
BEGIN   
   customer_exist_ := 'FALSE';
   new_category_db_ := Customer_Category_API.Encode(new_category_);
   FOR rec_ IN get_attr LOOP
      customer_exist_ := 'TRUE';
      oldrec_ := Lock_By_Keys___(customer_id_);   
      newrec_ := oldrec_ ;
      newrec_.customer_id := new_id_;
      newrec_.name := new_name_;
      newrec_.creation_date := TRUNC(SYSDATE);
      newrec_.default_domain := 'TRUE';
      newrec_.association_no := association_no_;
      newrec_.customer_category := new_category_db_;
      newrec_.party := NULL;
      newrec_.picture_id := NULL;
      New___(newrec_);
      IF (new_category_db_ = Customer_Category_API.DB_CUSTOMER) THEN         
         Copy_Customer_Details___(customer_id_, newrec_.customer_id, company_, 'COPY', Fnd_Boolean_API.DB_FALSE, Fnd_Boolean_API.DB_FALSE);           
      ELSIF (new_category_db_ = Customer_Category_API.DB_PROSPECT) THEN         
         Copy_Prospect_Details___(customer_id_, newrec_.customer_id, company_, 'COPY', Fnd_Boolean_API.DB_FALSE, new_category_db_, Fnd_Boolean_API.DB_FALSE);          
      ELSIF (new_category_db_ = Customer_Category_API.DB_END_CUSTOMER) THEN            
         Copy_End_Customer_Details___(customer_id_, newrec_.customer_id, 'COPY');            
      END IF; 
   END LOOP;
   IF (customer_exist_ = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'NOCUST: Customer :P1 does not exist', customer_id_);
   END IF;         
END Copy_Existing_Customer;


PROCEDURE Change_Customer_Category (
   customer_id_          IN VARCHAR2,
   customer_name_        IN VARCHAR2,
   association_no_       IN VARCHAR2,
   customer_category_    IN VARCHAR2,
   template_cust_id_     IN VARCHAR2,
   template_company_     IN VARCHAR2,
   overwrite_order_data_ IN VARCHAR2,
   transfer_addr_data_   IN VARCHAR2 )
IS     
   oldrec_                  customer_info_tab%ROWTYPE;
   newrec_                  customer_info_tab%ROWTYPE;
   newtemprec_              customer_info_tab%ROWTYPE;
   tempattr_                VARCHAR2(2000);
   attr_                    VARCHAR2(2000);
   objid_                   VARCHAR2(100);
   objversion_              VARCHAR2(200);
   customer_category_db_    VARCHAR2(20);
   indrec_                  Indicator_Rec;
   ptr_                     NUMBER;
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(2000);
   CURSOR get_attr IS
      SELECT *
      FROM   customer_info_tab
      WHERE  customer_id = template_cust_id_;
BEGIN   
   customer_category_db_ := Customer_Category_API.Encode(customer_category_); 
   IF (template_cust_id_ IS NOT NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO newtemprec_;     
      IF (get_attr%FOUND) THEN    
         CLOSE get_attr;
         newtemprec_.customer_id := NULL;
         newtemprec_.creation_date := NULL;
         tempattr_ := Pack___(newtemprec_);
         oldrec_ := Lock_By_Keys___(customer_id_);
         Get_Id_Version_By_Keys___(objid_, objversion_, customer_id_);             
         newrec_ := oldrec_;
         attr_ := Pack___(newrec_);
         attr_ := Client_SYS.Remove_Attr('CUSTOMER_ID', attr_);
         attr_ := Client_SYS.Remove_Attr('CREATION_DATE', attr_);
         Client_SYS.Set_Item_Value('NAME',                 customer_name_,      attr_);
         Client_SYS.Set_Item_Value('ASSOCIATION_NO',       association_no_,     attr_);
         Client_SYS.Set_Item_Value('CUSTOMER_CATEGORY',    customer_category_,  attr_);
         Client_SYS.Set_Item_Value('CUSTOMER_CATEGORY_DB', customer_category_db_,  attr_);
         --Replace the template attribute values with the ones with original rec values.
         ptr_ := NULL;
         WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
            IF (value_ IS NOT NULL) THEN
               Client_SYS.Set_Item_Value(name_, value_, tempattr_);
            END IF;
         END LOOP;
         Unpack___(newrec_, indrec_, tempattr_);
         IF (NOT Corporate_Form_API.Exists(newrec_.country, newrec_.corporate_form)) THEN
            newrec_.corporate_form := NULL;
         END IF;
         IF (NOT Business_Classification_API.Exists(newrec_.country, newrec_.business_classification)) THEN
            newrec_.business_classification := NULL;
         END IF;
         Check_Update___(oldrec_, newrec_, indrec_, tempattr_);
         Update___(objid_, oldrec_, newrec_, tempattr_, objversion_);
         IF (template_company_ IS NOT NULL) THEN 
            $IF Component_Accrul_SYS.INSTALLED $THEN
               Company_Finance_API.Exist(template_company_);
            $END
            NULL;
         END IF;
         IF (customer_category_db_ = Customer_Category_API.DB_CUSTOMER) THEN         
            Copy_Customer_Details___(template_cust_id_, customer_id_, template_company_, 'CONVERT', overwrite_order_data_, transfer_addr_data_);           
         ELSIF (customer_category_db_ = Customer_Category_API.DB_PROSPECT) THEN         
            Copy_Prospect_Details___(template_cust_id_, customer_id_, template_company_, 'CONVERT', transfer_addr_data_, customer_category_db_, overwrite_order_data_);                    
         END IF; 
      ELSE
         CLOSE get_attr;
      END IF;
   ELSE
      newrec_ := Get_Object_By_Keys___(customer_id_);
      newrec_.name               := customer_name_;
      newrec_.association_no     := association_no_;
      newrec_.customer_category  := customer_category_db_;
      Modify___(newrec_);
   END IF;  
END Change_Customer_Category;


FUNCTION Get_Next_Identity RETURN NUMBER
IS
   next_id_             NUMBER;
   party_type_db_       customer_info_tab.party_type%TYPE := 'CUSTOMER';
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


-- This will be used to fetch the customer using the name
-- in CCTI integration.
FUNCTION Fetch_Customer_By_Name (
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   customer_id_ customer_info_tab.customer_id%TYPE;   
   CURSOR get_cust IS
      SELECT customer_id 
      FROM   customer_info_tab
      WHERE  name = name_;  
BEGIN
   OPEN get_cust;
   FETCH get_cust INTO customer_id_;
   CLOSE get_cust;
   RETURN customer_id_;
END Fetch_Customer_By_Name;


-- This will be used to fetch the rowversion
-- in CCTI integration.
@UncheckedAccess
FUNCTION Get_Last_Modified (
   customer_id_ IN VARCHAR2) RETURN DATE
IS
   last_modified_    DATE;
   CURSOR get_last_modified IS
      SELECT rowversion
      FROM   customer_info_tab
      WHERE  customer_id = customer_id_;
BEGIN
   OPEN get_last_modified;
   FETCH get_last_modified INTO last_modified_;
   CLOSE get_last_modified;   
   RETURN last_modified_; 
END Get_Last_Modified;


@UncheckedAccess
FUNCTION Is_B2b_Customer (
   customer_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   is_b2b_ customer_info_tab.b2b_customer%TYPE;
   CURSOR get_b2b(id_ IN VARCHAR2) IS
      SELECT b2b_customer 
      FROM   customer_info_tab
      WHERE  customer_id = id_;    
BEGIN
   OPEN get_b2b(customer_id_);
   FETCH get_b2b INTO is_b2b_;
   CLOSE get_b2b;
   RETURN NVL(is_b2b_,'FALSE') = 'TRUE';
END Is_B2b_Customer;


-- This functions is used when pumping data for duplication check
FUNCTION Pack_Table (
   rec_  IN customer_info_tab%ROWTYPE ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      RETURN Pack_Table___(rec_);
   $ELSE
      RETURN NULL;
   $END
END Pack_Table;


-- Don't remove this method
-- The method is used from the basic data related to tax logic where we have LOOKUP(CustomerInfo) to include asterisk in the LOV for countries
@UncheckedAccess
PROCEDURE Enumerate (
   desc_list_ OUT VARCHAR2 )
IS    
   descriptions_ VARCHAR2(32000);
   enum_len_     INTEGER   := NULL;
   CURSOR get_value IS
      SELECT SUBSTR(NVL(description, no_description_), 1, enum_len_) description
      FROM   supply_country_lov
      ORDER BY description;
BEGIN
   IF (enum_len_ IS NULL) THEN
      IF (NVL(Object_Property_API.Get_Value(lu_name_, '*', 'LONG_ENUM'), 'FALSE') = 'TRUE') THEN
         enum_len_ := 50;
      ELSE
         enum_len_ := 20;
      END IF;
   END IF;
   FOR v IN get_value LOOP
      descriptions_ := descriptions_ || v.description || separator_;
   END LOOP;
   desc_list_ := descriptions_;
END Enumerate;


-- Don't remove this method
-- The method is used from the basic data related to tax logic where we have LOOKUP(CustomerInfo) to include asterisk in the LOV for countries
@UncheckedAccess
PROCEDURE Enumerate_Db (
   db_list_ OUT VARCHAR )
IS
   codes_ VARCHAR2(32000);
   enum_len_     INTEGER := NULL;
   CURSOR get_value IS
      SELECT SUBSTR(NVL(country_code, no_description_), 1, enum_len_) country_code
      FROM   supply_country_lov
      ORDER BY description;
BEGIN
   IF (enum_len_ IS NULL) THEN
      IF (NVL(Object_Property_API.Get_Value(lu_name_,'*', 'LONG_ENUM'), 'FALSE') = 'TRUE') THEN
         enum_len_ := 50;
      ELSE
         enum_len_ := 20;
      END IF;
   END IF;
   FOR v IN get_value LOOP
      codes_ := codes_ ||v.country_code || separator_ ;
   END LOOP;
   db_list_ := codes_;
END Enumerate_Db;


-- This method to be used in Aurena
-- This method is added to solve an issue related to Lookup's and wildcard (*) in Aurena. 
-- Please do not use this method for any other purpose!
FUNCTION Encode (
   client_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_   VARCHAR2(5);
BEGIN
   IF (client_value_ = '*') THEN
      db_value_ := '*';
   ELSE
      db_value_ := Iso_Country_API.Encode(client_value_);
   END IF;
   RETURN db_value_;
END Encode;

