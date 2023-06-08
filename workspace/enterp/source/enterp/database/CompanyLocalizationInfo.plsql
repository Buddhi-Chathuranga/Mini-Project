-----------------------------------------------------------------------------
--
--  Logical unit: CompanyLocalizationInfo
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191003   Nuudlk   gelr: Added to support Global Extension Functionalities
--  200602   Kagalk   GESPRING20-4691, Added changes for it_xml_invoice.
--  200729   Kabelk   Added clearing procedure for parameter ROUND_TAX_CUSTOMS_DOCUMENTS to Update_Parameter_Basic_Data___
--  210728   PraWlk   FI21R2-3290, Modified Update_Parameter_Basic_Data___() to set external tax calc method to default
--  210728            NOT USED when the lcc param br_external_tax_integration not enabled.
--  211022   PraWlk   FI21R2-6046, Modified Insert_Parameter_Basic_Data___() to set GENERATE_OFFICIAL_INV_NO_DB to 
--  211022            DB_AT_SEND_FISCAL_NOTE when the localization is BR.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

-- gelr:localization_control_center, begin
TYPE Micro_Cache_Rec IS RECORD
  (parameter_value   company_localization_info_tab.parameter_value%TYPE);

TYPE Micro_Cache_Type IS TABLE OF  Micro_Cache_Rec INDEX BY VARCHAR2(1000);

micro_cache_value_         Micro_Cache_Rec;
micro_cache_tab_           Micro_Cache_Type;
micro_cache_time_          NUMBER := 0;
micro_cache_user_          VARCHAR2(30);
micro_cache_company_       company_localization_info_tab.company%TYPE;
max_cached_element_life_   CONSTANT NUMBER := 100;
-- gelr:localization_control_center, end

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- gelr:localization_control_center, begin
PROCEDURE Invalidate_Cache___
IS
   null_value_ Micro_Cache_Rec;
BEGIN
   micro_cache_value_ := null_value_;
   micro_cache_time_  := 0;
   micro_cache_tab_.delete;
   micro_cache_company_:= NULL;
END Invalidate_Cache___;


PROCEDURE Fill_Cache___ (
   company_ IN VARCHAR2 ) 
IS 
   req_id_     VARCHAR2(1000);
   time_       NUMBER := Database_SYS.Get_Time_Offset;
   null_value_ Micro_Cache_Rec;
   TYPE Temp_Rec IS RECORD
      (company                         company_localization_info_tab.company%TYPE,
       parameter                       company_localization_info_tab.parameter%TYPE,
       parameter_value                 company_localization_info_tab.parameter_value%TYPE);
   TYPE Micro_Cache_Type2 IS TABLE OF  Temp_Rec INDEX BY PLS_INTEGER; 
   micro_cache_tab2_                   Micro_Cache_Type2;
   temp_micro_cache_rec_               Micro_Cache_Rec;
BEGIN
   micro_cache_company_ := company_;
   IF (Company_API.Get_Localization_Country_Db(company_) = Localization_Country_API.DB_NONE) THEN
      micro_cache_value_ := null_value_;
      micro_cache_tab_.delete;
   ELSE
      SELECT company,  
             parameter,
             parameter_value      
      BULK COLLECT INTO  micro_cache_tab2_
      FROM  company_localization_info_tab
      WHERE company = company_
      AND   parameter_value = Fnd_Boolean_API.DB_TRUE;
      FOR i_  IN 1..micro_cache_tab2_.COUNT LOOP
         req_id_:= micro_cache_tab2_(i_).company||'^'||micro_cache_tab2_(i_).parameter;
         temp_micro_cache_rec_.parameter_value :=  micro_cache_tab2_(i_).parameter_value;        
         micro_cache_tab_(req_id_) := temp_micro_cache_rec_;
      END LOOP;
   END IF;
   micro_cache_time_  := time_;
EXCEPTION
   WHEN no_data_found THEN
      micro_cache_value_ := null_value_;
      micro_cache_tab_.delete;
      micro_cache_time_  := time_;
      micro_cache_company_:= NULL;
   WHEN OTHERS THEN
      RAISE;
END Fill_Cache___;


PROCEDURE Update_Cache___ (
   company_      IN VARCHAR2,
   parameter_    IN VARCHAR2 )
IS
   req_id_     VARCHAR2(1000) := company_||'^'||parameter_;
   null_value_ Micro_Cache_Rec;
   time_       NUMBER;
   expired_    BOOLEAN;
   company_changed_ BOOLEAN;
BEGIN
   --handle company change
   IF (micro_cache_company_ IS NULL) THEN
      company_changed_ := TRUE;
   ELSE
      company_changed_ := (micro_cache_company_ != company_);
   END IF;
   time_    := Database_SYS.Get_Time_Offset;
   expired_ := ((time_ - micro_cache_time_) > max_cached_element_life_);
   IF (expired_ OR (micro_cache_user_ IS NULL) OR (micro_cache_user_ != Fnd_Session_API.Get_Fnd_User) OR (company_changed_)) THEN
      Invalidate_Cache___;
      micro_cache_user_ := Fnd_Session_API.Get_Fnd_User;
      Fill_Cache___(company_);
   END IF;
   IF (micro_cache_tab_.exists(req_id_)) THEN
      micro_cache_value_ := micro_cache_tab_(req_id_);
   ELSE
      micro_cache_value_ := null_value_;
   END IF;
END Update_Cache___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     company_localization_info_tab%ROWTYPE,
   newrec_     IN OUT company_localization_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);   
   Invalidate_Cache___;
   Update_Parameter_Basic_Data___(newrec_);
END Update___;


@Override
PROCEDURE Delete___ (
   remrec_ IN company_localization_info_tab%ROWTYPE )
IS
BEGIN
   super(remrec_);
   Invalidate_Cache___;
END Delete___;


-- Insert_Country_Basic_Data___
--    This method will insert country specific basic data
PROCEDURE Insert_Country_Basic_Data___ (
   company_                 IN VARCHAR2,
   localization_country_db_ IN VARCHAR2 )
IS 
BEGIN
   $IF Component_Invoic_SYS.INSTALLED $THEN
      -- gelr:it_xml_invoice, begin
      IF (localization_country_db_ = Localization_Country_API.DB_ITALY) THEN
         -- Set required values for Italian Localization.
         Company_Itxml_Sequence_API.Initiate_Sequence(company_);
      -- gelr:it_xml_invoice, end
      END IF;
   $ELSE
      NULL;
   $END
END Insert_Country_Basic_Data___;


-- Insert_Parameter_Basic_Data___
--    This method will insert localization parameter specific basic data
PROCEDURE Insert_Parameter_Basic_Data___ (
   newrec_               IN company_localization_info_tab%ROWTYPE,
   localization_country_ IN VARCHAR2 )
IS
BEGIN
   -- gelr:alt_invoice_no_per_branch, begin
   IF (newrec_.parameter = 'ALT_INVOICE_NO_PER_BRANCH') THEN
      $IF Component_Invoic_SYS.INSTALLED $THEN
         IF (localization_country_ = Localization_Country_API.DB_BRAZIL) THEN
            Company_Invoice_Info_API.Modify_Gen_Official_Inv_No(newrec_.company, Generate_Official_Inv_No_API.DB_AT_SEND_FISCAL_NOTE);
         END IF;
         Off_Inv_Num_Comp_Type_API.Insert_Default_Records(newrec_.company);
      $ELSE
         NULL;
      $END
   END IF;
   -- gelr:alt_invoice_no_per_branch, end
END Insert_Parameter_Basic_Data___;


-- Update_Parameter_Basic_Data___
--    This method will update localization parameter specific basic data setup when the enabled checkbox is cleared
PROCEDURE Update_Parameter_Basic_Data___ (
   newrec_ IN company_localization_info_tab%ROWTYPE )
IS
BEGIN
   -- gelr:round_tax_customs_documents, begin
   IF (newrec_.parameter = 'ROUND_TAX_CUSTOMS_DOCUMENTS' AND newrec_.parameter_value = Fnd_Boolean_API.DB_FALSE) THEN
      $IF Component_Accrul_SYS.INSTALLED $THEN 
         Statutory_Fee_API.Clear_Round_Zero_Decimal(newrec_.company);
      $ELSE
         NULL;
      $END
   END IF;      
   -- gelr:round_tax_customs_documents, end
   -- gelr:br_external_tax_integration, begin
   IF (newrec_.parameter = 'BR_EXTERNAL_TAX_INTEGRATION' AND newrec_.parameter_value = Fnd_Boolean_API.DB_FALSE) THEN
      $IF Component_Accrul_SYS.INSTALLED $THEN 
         Company_Tax_Control_API.Set_Tax_Cal_Method_To_Not_Used(newrec_.company);
      $ELSE
         NULL;
      $END
   END IF;      
   -- gelr:br_external_tax_integration, end
END Update_Parameter_Basic_Data___;
-- gelr:localization_control_center, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- gelr: localization_control_center, begin
PROCEDURE Insert_Lu_Data_Rec__ (
   company_          IN VARCHAR2,
   parameter_        IN VARCHAR2,
   parameter_value_  IN VARCHAR2 )
IS
   newrec_     company_localization_info_tab%ROWTYPE;
BEGIN
   IF (NOT Check_Exist___(company_, parameter_)) THEN
      newrec_.company         := company_;
      newrec_.parameter       := parameter_;
      newrec_.parameter_value := parameter_value_;
      newrec_.rowversion      := SYSDATE;
      New___(newrec_);
      Insert_Parameter_Basic_Data___(newrec_, Company_API.Get_Localization_Country_Db(company_));
   ELSE
      IF (parameter_value_ = Fnd_Boolean_API.Db_TRUE) THEN
         newrec_ := Get_Object_By_Keys___(company_, parameter_);
         newrec_.parameter_value := parameter_value_;
         newrec_.rowversion      := SYSDATE;
         Modify___(newrec_);
      END IF;
   END IF;
END Insert_Lu_Data_Rec__;
-- gelr: localization_control_center, end

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- gelr:localization_control_center, begin
-- Insert_Company_Loc_Parameters
--    Localization is set and default parameters are inserted
--    1. Country specific basic data setup
--    2. Localization parameter specific basic data setup
PROCEDURE Insert_Company_Loc_Parameters (
   company_                 IN VARCHAR2,
   localization_country_db_ IN VARCHAR2 )
IS
   newrec_       company_localization_info_tab%ROWTYPE;
   CURSOR get_loc_param IS
      SELECT *
      FROM   localization_country_param_tab
      WHERE  localization = localization_country_db_;
BEGIN
   -- Country specific basic data setup
   Insert_Country_Basic_Data___(company_, localization_country_db_);
   FOR rec_ IN get_loc_param LOOP
      newrec_.company         := company_;
      newrec_.parameter       := rec_.parameter;
      newrec_.parameter_value := rec_.mandatory;
      newrec_.rowversion      := SYSDATE;
      New___(newrec_);
      -- Localization parameter specific basic data setup
      Insert_Parameter_Basic_Data___(newrec_, localization_country_db_);
   END LOOP;
END Insert_Company_Loc_Parameters;


@Override
FUNCTION Get_Parameter_Value (
   company_   IN VARCHAR2,
   parameter_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN NVL(super(company_, parameter_), Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_FALSE));
END Get_Parameter_Value;


@Override
FUNCTION Get_Parameter_Value_Db (
   company_   IN VARCHAR2,
   parameter_ IN VARCHAR2 ) RETURN company_localization_info_tab.parameter_value%TYPE
IS
BEGIN
   IF (company_ IS NULL OR parameter_ IS NULL) THEN
      RETURN super(company_, parameter_);
   END IF;
   Update_Cache___(company_, parameter_);
   RETURN NVL(micro_cache_value_.parameter_value, Fnd_Boolean_API.DB_FALSE);
END Get_Parameter_Value_Db;


FUNCTION Get_Parameter_Val_From_Site (
   contract_  IN VARCHAR2,
   parameter_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   company_   VARCHAR2(20);
BEGIN
   $IF Component_Mpccom_SYS.INSTALLED $THEN
      company_ := Site_API.Get_Company(contract_);
   $END
   RETURN NVL(Get_Parameter_Value(company_, parameter_), Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_FALSE));
END Get_Parameter_Val_From_Site;


FUNCTION Get_Parameter_Val_From_Site_Db (
   contract_  IN VARCHAR2,
   parameter_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   company_   VARCHAR2(20);
BEGIN
   $IF Component_Mpccom_SYS.INSTALLED $THEN
      company_ := Site_API.Get_Company(contract_);
   $END
   RETURN NVL(Get_Parameter_Value_Db(company_, parameter_), Fnd_Boolean_API.DB_FALSE);
END Get_Parameter_Val_From_Site_Db;


FUNCTION Get_Enabled_Params_Per_Company (
   company_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   enabled_parameters_   VARCHAR2(4000);
BEGIN
   IF (company_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT LISTAGG(TRIM(parameter), ',') WITHIN GROUP (ORDER BY parameter) parameter
      INTO   enabled_parameters_
      FROM   company_localization_info_tab
      WHERE  company         = company_
      AND    parameter_value = 'TRUE';
   RETURN enabled_parameters_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Enabled_Params_Per_Company;


PROCEDURE Check_Parameter_Enabled (
   company_   IN VARCHAR2,
   parameter_ IN VARCHAR2 )
IS
BEGIN
   IF (Get_Parameter_Value_Db(company_, parameter_) = Fnd_Boolean_API.DB_FALSE) THEN
      Error_SYS.Appl_General(lu_name_, 'PARAMNOTENABLED: Company :P1 is not setup to use '':P2'' localization functionality.', company_, Localization_Parameter_API.Get_Parameter_Description(parameter_));
   END IF;
END Check_Parameter_Enabled;


PROCEDURE Check_Parameter_Enabled_Site (
   contract_  IN VARCHAR2,
   parameter_ IN VARCHAR2 )
IS
   company_   VARCHAR2(20);
BEGIN
   $IF Component_Mpccom_SYS.INSTALLED $THEN
      company_ := Site_API.Get_Company(contract_);
   $END
   IF (Get_Parameter_Value_Db(company_, parameter_) = Fnd_Boolean_API.DB_FALSE) THEN
      Error_SYS.Appl_General(lu_name_, 'PARAMNOTENABLEDSIT: Site :P1 is connected to Company :P2 which is not setup to use '':P3'' localization functionality.' ,contract_, company_, Localization_Parameter_API.Get_Parameter_Description(parameter_));
   END IF;   
END Check_Parameter_Enabled_Site;
-- gelr:localization_control_center, end