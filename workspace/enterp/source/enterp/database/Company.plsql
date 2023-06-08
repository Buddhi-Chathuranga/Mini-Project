-----------------------------------------------------------------------------
--
--  Logical unit: Company
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980930  ANHO   Created.
--  981005  Camk   New procedure. Create new company
--  981019  Camk   New function. Get_min_company()
--  981112  Camk   Call to Company_Per_User added
--  981113  Camk   EDI added
--  981127  Camk   Domain_Id added for backward comp reason
--  981202  Camk   Check on Association No added.
--  990125  Camk   OurId removed.
--  990301  Camk   Drop_Company added.
--  990412  Maruse New templates
--  990428  Maruse Additional updates for new templates.
--  990820  BmEk   Removed Error_SYS.Check_Not_Null in Unpack_Check_Insert___ for company.
--                 Added a control in Insert___ instead, to check if company is null. This
--                 because it should be possible to fetch an automatic generated company
--                 from LU PartyIdentitySeries. Also added the procedure Get_Identity___.
--  000128  Mnisse Check on capital letters for ID, bug #30596.
--  000306  Camk   Bug# 14896 Corrected.
--  001205  BmEk   Bug #18212.
--  001221  BmEk   Bug #18823. Changed call from Association_Info_API.Check_Association_No
--                 Association_Info_API.Check_Ass_No_Company
--  010401  LiSv   For new Create Company concept. Added procedure Update_Company. Added attribut template_company,
--                 from_template_id, from_company.
--  010521  LiSv   Added check in Unpack_Check_Update and Unpack_Check_Insert that company id and source company id is not the same.
--  010607  LiSV   Added where statement for export_view in cursor get_active in procedure Prepare_Export_Company__.
--  010627  Gawilk Fixed bug # 15677. Checked General_SYS.Init_Method.
--  020111  rakolk IID 20002 Removed attribute definition check for COMPANY and NAME.
--  020117  LiSv   Added procedure Ge_Country_Db.
--  020201  Jakalk Added corporate_form to Company_Tab
--  020208  ovjose Changed calls from create_company_reg_api to crecomp_component_api
--  020826  Roralk Bug # 32005 ,Added new line to Update___ function to get country changes
--  021121  hecolk IID ITFI135N. Added Calls to VALIDATION_PER_COMPANY_API.Validate_Association_Number in Unpack_Check_Insert___ and Unpack_Check_Update___
--  030127  chajlk IID ARFI124N Added sysdate as default for activity_start date in unpack_check_insert
--  030127  chajlk IID ARFI124N - Removed income_type_id and income_type_desc from company
--  040920  Jeguse IID FIJP335. Added column Identifier_Reference and functions for this column. 
--  050711  ovjose Added column Created_By.
--  050919  Hecolk LCS Merge - Bug 52720, Added FUNCTION Get_Next_Identity and Removed PROCEDURE Get_Identity___ 
--  060208  Jakalk B123484 Removed EDI Receiver from views and methods.
--  060209  Iswalk B132481 Changed Get method to reflect the correct declaration of Pulic_Rec
--                 (The Public_Rec had earlier been changed without changing the select list in the Get method).
--  060306  Gadalk B133575 Changes in COMPANY view, Restriction added for coporate_form (Form Of Business)
--  060726  CsAmlk Persian Calendar Modifications.
--  080331  Samwlk Bug 70469, Corrected. Removeed General_sys statment and added pragma to function Remove_Company_Allowed.
--  090212  Shdilk Bug 80014, Added a function to get default language db.
--  090409  Jofise Bug 81196, Added column doc_recip_address_pos.
--  100807  Shsalk Bug 92323, Modified an error for transalation problems.
--  091203  Kanslk Reverse-Engineering, added reference to 'created_by' in view 'COMPANY' 
--  100113  Kanslk Reverse-Engineering, added exist check for 'created_by' attribute.
--  100311  Nsillk EAFH-2442, Added method Get_Cal_Data
--  100701  Kanslk EANE-2760, modified view COMPANY by adding default_language_db and country_db to the view comments.
--  101111  ovjose RAVEN-1239. Added private attribute creation_parameters, stores parameters used when creating the company.
--  101208  jofise DF-584, Changed Default_Language and Country in Company_Tab to mandatory.
--  110120  RUFELK RAVEN-1493, Removed use of Validation_Per_Company_API.
--  110907  Sacalk EASTTWO-9535 , Modified in PROCEDURE Get_Cal_Data
--  120229  Janblk EDEL-548, Added column Print_Senders_Address
--  121129  Pratlk DANU-111, Added column Master_Company
--  121221  Pratlk DANU-111, Added method Get_Master_Company_Db
--  131014  Isuklk CAHOOK-2705 Refactoring in Company.entity
--  140703  Hawalk Bug 116673 (merged via PRFI-287), Added Is_Company_Finance_Auth() to check whether current user is allowed
--  140703         on company concerned.
--  150630  Chgulk ANFIN-264 Added localization_country.
--  191206  Hecolk Bug 150899, Corrected in function Remove_Company_Allowed
--  200624  jagrno Added ObjectConnectionMethod annotation for method Get_Doc_Object_Description
--  200826  Bmekse Replaced call to Security_SYS.Is_Method_Available('Crecomp_Component_API.Start_Remove_Company (added in bug 150899) with 
--  200826         Security_SYS.Is_Proj_Entity_Act_Available('CompaniesHandling', 'Company', 'DeleteCompany')
--  200909  misibr GEFALL20-3013, added validation of business_classification to the method Check_Common___.
--  210127  Hecolk FISPRING20-8730, Get rid of string manipulations in db - Modified in methods Set_Name and Modify_Name
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Obj_Info___ (
   company_    IN  VARCHAR2,
   objid_      OUT VARCHAR2,
   objversion_ OUT VARCHAR2 )
IS
   CURSOR get_obj IS
      SELECT ROWID, rowversion
      FROM   company_tab
      WHERE  company = company_;
BEGIN
   OPEN get_obj;
   FETCH get_obj INTO objid_, objversion_;
   CLOSE get_obj;
END Get_Obj_Info___;


PROCEDURE Get_Next_Party___ (
   newrec_ IN OUT company_tab%ROWTYPE,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Party_Id_API.Get_Next_Party('DEFAULT', newrec_.party);
   Client_SYS.Add_To_Attr('PARTY', newrec_.party, attr_);
END Get_Next_Party___;


PROCEDURE Check_If_Company_Exist___ (
   company_ IN VARCHAR2 )
IS
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      IF NOT (Company_Finance_API.Check_Exist(company_)) THEN
         Error_SYS.Appl_General(lu_name_, 'REMOVECOMPANY: Not allowed to remove company :P1 - already created in Accounting rules', company_);
      END IF;  
   $ELSE
      NULL;
   $END
END Check_If_Company_Exist___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     company_tab%ROWTYPE,
   newrec_ IN OUT company_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   exists_                VARCHAR2(5);
BEGIN
   Association_Info_API.Check_Ass_No_Company(newrec_.association_no, 'COMPANY', newrec_.company);
   IF ((oldrec_.association_no != newrec_.association_no) OR (oldrec_.association_no IS NULL)) THEN
      exists_ := Association_Info_API.Association_No_Exist(newrec_.association_no, 'COMPANY');
      IF (exists_ = 'TRUE') THEN
         Client_SYS.Add_Warning(lu_name_, 'WARNSAMEASCNO: Another business partner with the association number :P1 is already registered. Do you want to use the same Association No for :P2?', newrec_.association_no, newrec_.company);
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
   IF (newrec_.identifier_reference IS NOT NULL AND newrec_.identifier_ref_validation != 'NONE') THEN 
      Identifier_Ref_Validation_API.Check_Identifier_Reference(newrec_.identifier_reference, newrec_.identifier_ref_validation);
   END IF;
   IF (newrec_.from_company IS NOT NULL) THEN
      IF (newrec_.from_company = newrec_.company) THEN
         Error_SYS.Record_General(lu_name_, 'SAME_COMPANY: It is not allowed to use the same Company Id on Source Company Id as on New Company Id.');
      END IF;
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
   Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode('COMPANY'), attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('DOMAIN_ID', 'DEFAULT', attr_);
   Client_SYS.Add_To_Attr('TEMPLATE_COMPANY', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ACTIVITY_START_DATE', TRUNC(SYSDATE), attr_);
   Client_SYS.Add_To_Attr('IDENTIFIER_REF_VALIDATION', Identifier_Ref_Validation_API.Decode('NONE'), attr_);
   Client_SYS.Add_To_Attr('DOC_RECIP_ADDRESS_POS', Positioning_Type_API.Decode('RIGHT'), attr_);
   Client_SYS.Add_To_Attr('CREATED_BY', Fnd_Session_API.Get_Fnd_User, attr_);
   Client_SYS.Add_To_Attr('PRINT_SENDERS_ADDRESS_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('LOCALIZATION_COUNTRY_DB', 'NONE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT company_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS   
BEGIN
   IF (newrec_.company IS NULL) THEN
      newrec_.company := Get_Next_Identity;
      Client_SYS.Add_To_Attr('COMPANY', newrec_.company, attr_);
      IF (newrec_.company IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'COMP_ERROR: Error while retrieving the next free identity. Check the identity series for company');
      END IF;
   END IF;
   Get_Next_Party___(newrec_, attr_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     company_tab%ROWTYPE,
   newrec_     IN OUT company_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS   
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr('COUNTRY_DB', newrec_.country, attr_);
   -- gelr:localization_control_center, begin
   IF (Validate_SYS.Is_Changed(oldrec_.localization_country, newrec_.localization_country)) THEN
      IF (oldrec_.localization_country = Localization_Country_API.DB_NONE) THEN
         -- Localization is set and default parameters are inserted
         Company_Localization_Info_API.Insert_Company_Loc_Parameters(newrec_.company, newrec_.localization_country);
      ELSE
         Error_SYS.Record_General(lu_name_, 'LOC_NO_CHANGE_ALLOWED: It is not allowed to change the localization once it is defined.');
      END IF;
   END IF;
   -- gelr:localization_control_center, end
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT company_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   IF (newrec_.print_senders_address IS NULL) THEN
      newrec_.print_senders_address := 'FALSE';      
   END IF;
   IF (newrec_.localization_country IS NULL) THEN
      newrec_.localization_country := 'NONE';      
   END IF;
   super(newrec_, indrec_, attr_);   
   IF (UPPER(newrec_.company) != newrec_.company) THEN
      Error_SYS.Record_General(lu_name_, 'CAPCHECK: Only capital letters are allowed in the ID.');
   END IF;   
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     company_tab%ROWTYPE,
   newrec_ IN OUT company_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY', newrec_.party);      
END Check_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ company_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Check_If_Company_Exist___(remrec_.company);
   END IF;   
   super(info_, objid_, objversion_, action_);
END Remove__;


PROCEDURE Prepare_Export_Company__ (
   company_ IN VARCHAR2,
   attr_    IN VARCHAR2 )
IS
   stmt_                   VARCHAR2(300);
   bindinpar_              VARCHAR2(2000) ;
   proc_name_              VARCHAR2(100) := 'Make_Company';
   master_rec_             Create_Company_Tem_API.Public_Rec_Templ;
   old_component_          VARCHAR2(30);
   rec_                    Crecomp_Component_Process%ROWTYPE;
   key_master_created_     BOOLEAN := FALSE;
   special_lu_             BOOLEAN;
   dummy_                  NUMBER;
   error_text_             VARCHAR2(2000);
   CURSOR get_active IS
      SELECT *
      FROM   crecomp_component_process
      WHERE Dictionary_SYS.Component_Is_Active_Num(module) = 1
      ORDER BY module;
   CURSOR get_special_lu(lu_ IN VARCHAR2) IS
      SELECT 1
      FROM   crecomp_special_lu_tab
      WHERE  lu = lu_;
BEGIN
   master_rec_.template_id := Client_SYS.Get_Item_Value('TEMPLATE_ID', attr_);
   master_rec_.description := Client_SYS.Get_Item_Value('DESCRIPTION', attr_);
   master_rec_.valid := 'TRUE';
   Create_Company_API.Exist_Wildcard(master_rec_.template_id);
   Create_Company_API.Exist_Illegal_Character(master_rec_.template_id);
   IF (NOT Create_Company_Tem_API.Check_Exist(master_rec_.template_id)) THEN
      -- Check if the template to be created is a system company template
      -- Some names is used by the system to recognize system company templates
      -- IF it is a system company template verify that the user are allowed to create such template.
      IF (Create_Company_API.Is_System_Company_Template(master_rec_.template_id) = 'TRUE') THEN
         IF NOT (Create_Company_API.Is_Template_Super_User = 'TRUE') AND NOT (Fnd_Session_API.Get_Fnd_User = Fnd_Session_API.Get_App_Owner) THEN
            Error_SYS.Appl_General(lu_name_,
                                   'NOTALLOWED: Company Template Id :P1 is a reserved Template Id for System '||
                                   'Company Templates and only Template Super Users or Application Owner can '||
                                   'create System Company Templates',
                                   master_rec_.template_id);
         END IF;
      END IF;
      Enterp_Comp_Connect_V170_API.Initiate_Template_Log;
      bindinpar_ := attr_;
      Client_SYS.Add_To_Attr('NEW_COMPANY', company_, bindinpar_);
      OPEN get_active;
      FETCH get_active INTO rec_;
      WHILE get_active%FOUND LOOP
         old_component_ := rec_.module;
         master_rec_.component := rec_.module;
         master_rec_.version := rec_.version;
         Create_Company_Tem_API.Insert_Data(master_rec_);
         WHILE ( get_active%FOUND AND old_component_ = rec_.module ) LOOP
            BEGIN
               IF (rec_.export_view IS NOT NULL) THEN
                  Assert_SYS.Assert_Is_Package_Method(rec_.package, proc_name_);
                  -- Make sure that the template is created on lu level although no details exist.
                  master_rec_.lu := rec_.lu;
                  Create_Company_Tem_API.Insert_Detail_Data(master_rec_);
                  stmt_ := 'BEGIN ' || rec_.package || '.' || proc_name_ || '(:bindingpar_); END;';
                  @ApproveDynamicStatement(2005-11-10,ovjose)
                  EXECUTE IMMEDIATE stmt_ USING bindinpar_;
                  IF (Client_SYS.Get_Item_Value('MAKE_COMPANY', attr_) = 'EXPORT') THEN
                     IF (NOT key_master_created_) THEN
                        Enterp_Comp_Connect_V170_API.Insert_Key_Master__('TemplKeyLu', master_rec_.template_id);
                        key_master_created_ := TRUE;
                     END IF;
                     OPEN get_special_lu(rec_.lu);
                     FETCH get_special_lu INTO dummy_;
                     IF (get_special_lu%FOUND) THEN
                        special_lu_ := TRUE;
                     ELSE
                        special_lu_ := FALSE;
                     END IF;
                     CLOSE get_special_lu;
                     IF (NOT special_lu_) THEN
                        Enterp_Comp_Connect_V170_API.Copy_Comp_To_Templ_Trans(company_, master_rec_.template_id, rec_.module, rec_.lu, rec_.lu);
                     END IF;
                  END IF;
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  error_text_ := SQLERRM;
                  Create_Company_Tem_Log_API.Log_Error__(error_text_, master_rec_.template_id, rec_.module, rec_.lu);
            END;
            FETCH get_active INTO rec_;
         END LOOP;
      END LOOP;
      CLOSE get_active;
      Enterp_Comp_Connect_V170_API.Reset_Template_Log;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'TEMPLATEEXIST: Company Template :P1 already exists', master_rec_.template_id);
   END IF;
END Prepare_Export_Company__;


FUNCTION Get_Creation_Parameters__ (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   creation_parameters_    company_tab.creation_parameters%TYPE;
   count_                  NUMBER;
   name_                   Message_SYS.name_table;
   value_                  Message_SYS.line_table;
   attr_                   VARCHAR2(2000);
   CURSOR get_attr IS
      SELECT creation_parameters
      FROM   company_tab
      WHERE  company = company_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO creation_parameters_;
   CLOSE get_attr;
   IF (creation_parameters_ IS NOT NULL) THEN
      Message_SYS.Get_Attributes(creation_parameters_, count_, name_, value_);
      IF (count_ > 0) THEN
         FOR i_ IN name_.FIRST..name_.LAST LOOP
            Client_SYS.Add_To_Attr(name_(i_), value_(i_), attr_);
         END LOOP;
      END IF;
   END IF;
   RETURN attr_;
END Get_Creation_Parameters__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
  IF (Check_Exist___(company_)) THEN
     RETURN 'TRUE';
  ELSE
     RETURN 'FALSE';
  END IF;
END Check_Exist;


PROCEDURE New_Company (
   attr_ IN VARCHAR2 )
IS   
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   temp_attr_   VARCHAR2(4000);
   newrec_      company_tab%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   temp_attr_ := attr_;
   Client_SYS.Add_To_Attr('CREATION_DATE', TRUNC(SYSDATE), temp_attr_);
   Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode('COMPANY'), temp_attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', 'TRUE', temp_attr_);
   Client_SYS.Add_To_Attr('DOMAIN_ID', 'DEFAULT', temp_attr_);
   Client_SYS.Add_To_Attr('IDENTIFIER_REF_VALIDATION', Identifier_Ref_Validation_API.Decode('NONE'), temp_attr_);
   Client_SYS.Add_To_Attr('DOC_RECIP_ADDRESS_POS', Positioning_Type_API.Decode('RIGHT'), temp_attr_);
   Client_SYS.Add_To_Attr('CREATED_BY', Fnd_Session_API.Get_Fnd_User, temp_attr_);
   Unpack___(newrec_, indrec_, temp_attr_);
   Check_Insert___(newrec_, indrec_, temp_attr_);   
   Insert___(objid_, objversion_, newrec_, temp_attr_);
END New_Company;


@ObjectConnectionMethod
@UncheckedAccess
FUNCTION Get_Doc_Object_Description (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_description_    VARCHAR2(122);
   CURSOR get_obj_description IS
      SELECT company||'-'||name description
      FROM   company_tab
      WHERE  company = company_;
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


PROCEDURE Update_Company (
   company_    IN VARCHAR2,
   attr_       IN VARCHAR2 )
IS
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   temp_attr_   VARCHAR2(2000);
   newrec_      company_tab%ROWTYPE;
   oldrec_      company_tab%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   temp_attr_ := attr_;
   Get_Obj_Info___(company_, objid_, objversion_);
   oldrec_ := Lock_By_Keys___(company_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, temp_attr_);
   Check_Update___(oldrec_, newrec_, indrec_, temp_attr_);      
   Update___(objid_, oldrec_, newrec_, temp_attr_, objversion_);
END Update_Company;


FUNCTION Get_Next_Identity RETURN NUMBER
IS
   next_id_             NUMBER;
   party_type_db_       company_tab.party_type%TYPE := 'COMPANY';
   update_next_value_   BOOLEAN := FALSE;    
BEGIN
   next_id_ := Party_Identity_Series_API.Get_Next_Value(Party_Type_API.Decode(party_type_db_));  
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
FUNCTION Remove_Company_Allowed (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   fnd_user_    VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   created_by_  company_tab.created_by%TYPE;
BEGIN
   IF NOT (Security_SYS.Is_Proj_Entity_Act_Available('CompaniesHandling', 'Company', 'DeleteCompany')) THEN
      RETURN 'FALSE';
   END IF;
   created_by_ := Get_Created_By(company_);
   IF (created_by_ = fnd_user_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN User_Priv_Remove_Company_API.Remove_Company_Allowed(company_, fnd_user_);
   END IF;
END Remove_Company_Allowed;


PROCEDURE Get_Cal_Data (
   acc_year_        OUT NUMBER,
   start_year_      OUT NUMBER,
   start_month_     OUT NUMBER,
   no_of_years_     OUT NUMBER,
   source_company_  IN  VARCHAR2,
   source_template_ IN  VARCHAR2 )
IS
   TYPE CUR_TYPE        IS REF CURSOR;
   get_comp_year_       CUR_TYPE;
   get_comp_start_date_ CUR_TYPE;
   max_year_            NUMBER;
   min_year_            NUMBER;
   first_date_          DATE;
   stmt1_               VARCHAR2(200);
   stmt2_               VARCHAR2(200);
   CURSOR get_temp_year IS
      SELECT MAX(N1), MIN(N1)
        FROM create_company_tem_detail_tab
       WHERE template_id = source_template_
         AND component   = 'ACCRUL'
         AND lu          = 'AccountingYear';
   CURSOR get_tmpl_start_date(acc_year_ NUMBER) IS
      SELECT D1
        FROM create_company_tem_detail_tab
       WHERE template_id = source_template_
         AND component   = 'ACCRUL'
         AND lu          = 'AccountingPeriod'
         AND N1          = acc_year_
         AND N2          = 1;
BEGIN
   stmt1_ := 'SELECT MAX(accounting_year),MIN(accounting_year)'
             ||' FROM accounting_year_tab'
             ||' WHERE company =:p_source_company';
   stmt2_ := 'SELECT date_from' 
             ||' FROM accounting_period_tab'
             ||' WHERE company =:p_source_company'
             ||' AND accounting_year =:p_acc_year' 
             ||' AND accounting_period = 1';
   IF (source_company_ IS NULL) THEN
      OPEN get_temp_year;
      FETCH get_temp_year INTO max_year_,min_year_;
      CLOSE get_temp_year;
      OPEN get_tmpl_start_date(min_year_);
      FETCH get_tmpl_start_date INTO first_date_;
      CLOSE get_tmpl_start_date;
   ELSE
      @ApproveDynamicStatement(2010-10-05,shhelk)
      OPEN get_comp_year_ FOR stmt1_ USING source_company_ ;
      FETCH get_comp_year_ INTO max_year_,min_year_;  
      CLOSE get_comp_year_;
      @ApproveDynamicStatement(2010-10-05,shhelk)
      OPEN get_comp_start_date_ FOR stmt2_ USING source_company_, min_year_ ;
      FETCH get_comp_start_date_ INTO first_date_; 
      CLOSE get_comp_start_date_;
   END IF;
   acc_year_ := min_year_;
   start_year_ := TO_NUMBER(TO_CHAR(first_date_,'yyyy'));
   start_month_ := TO_NUMBER(TO_CHAR(first_date_,'mm'));
   no_of_years_ := (max_year_ - min_year_) + 1 ;
END Get_Cal_Data;


@UncheckedAccess
FUNCTION Get_Positioning_Type (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ company_tab.doc_recip_address_pos%TYPE;
   CURSOR get_attr IS
      SELECT doc_recip_address_pos
      FROM   company_tab
      WHERE  company = company_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Positioning_Type;


@UncheckedAccess
FUNCTION Is_Company_Finance_Auth (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- Note: Performs user authorization available in ACCRUL. This is useful if the same needs to be done in ENTERP, 
   --       which gets installed before ACCRUL, but which wouldn't function without the latter. 
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      IF (Company_Finance_API.Is_User_Authorized(company_)) THEN
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;  
   $ELSE
      RETURN 'FALSE';
   $END
END Is_Company_Finance_Auth;


@UncheckedAccess   
FUNCTION Get_Currency_Code (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      RETURN Company_Finance_API.Get_Currency_Code(company_);
   $ELSE
      RETURN NULL;
   $END
END Get_Currency_Code;


@UncheckedAccess
FUNCTION Get_Parallel_Acc_Currency (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      RETURN Company_Finance_API.Get_Parallel_Acc_Currency(company_);
   $ELSE
      RETURN NULL;
   $END
END Get_Parallel_Acc_Currency;