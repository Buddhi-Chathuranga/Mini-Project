-----------------------------------------------------------------------------
--
--  Logical unit: IncomeType
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030121  machlk  Created.
--  030123  GEPELK  Added View INCOME_CUST_LOV
--  030130  mgutse  Bug 93452. Changed order of LOV-fields.
--  030221  mgutse  Bug 94305. New key in LU IncomeType.
--  030403  Bmekse  Bug 95721. Description should mandatory.
--  080118  Sjaylk  Bug 66199, Added Get_Tax_Withhold_Code, Get_Tax_Withhold_Db
--  080215  Nsillk  Bug 71385, Modified method Insert_Lu_Data_Rec__
--  080808  Raablk  Bug 70833, Added Get_Tax_Withhold_Code_Db
--  081020  Shdilk  Bug 77872, Modified the correction done for 70833 to use dynamic call
--  100830  Shhelk  Bug 91784, Insert___(),Update___(), Delete___() to facilitate proper translations. Used Basic_Data_Translation_API with
--                  new translation key to retrive correct income type description. 
--  130308  AjPelk  Bug 102660, Merged , Added new view INCOME_TYPE_COUNTRY_LOV
--  130614  DipeLK  TIBE-726, Removed golbal variable which used to check exsistance of ACCRUL component.
--  131111  Isuklk  PBFI-2164 Refactoring and Split IncomeType.entity
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
 
-------------------- PRIVATE DECLARATIONS -----------------------------------
 
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_New_Id___ RETURN NUMBER
IS
   internal_income_type_ NUMBER;
   CURSOR nextid IS
      SELECT internal_income_type_seq.NEXTVAL
      FROM dual;
BEGIN
   OPEN nextid;
   FETCH nextid INTO internal_income_type_;
   CLOSE nextid;
   RETURN(internal_income_type_);
END Get_New_Id___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('BLOCKED','FALSE',attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT income_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Basic_Data_Translation_API.Insert_Basic_Data_Translation(module_,
                                                            lu_name_,
                                                            newrec_.income_type_id||'^'||newrec_.currency_code||'^'||newrec_.country_code,
                                                            NULL,
                                                            newrec_.description,
                                                            NULL);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     income_type_tab%ROWTYPE,
   newrec_     IN OUT income_type_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Basic_Data_Translation_API.Insert_Basic_Data_Translation(module_,
                                                            lu_name_,
                                                            newrec_.income_type_id||'^'||newrec_.currency_code||'^'||newrec_.country_code,
                                                            NULL,
                                                            newrec_.description,
                                                            oldrec_.description);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN income_type_tab%ROWTYPE )
IS
BEGIN
   super(remrec_);
   IF (remrec_.blocked = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'DELTYPE: Income Type :P1 cannot be deleted', remrec_.income_type_id);
   END IF;
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN income_type_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Basic_Data_Translation_API.Remove_Basic_Data_Translation(module_,
                                                            lu_name_,
                                                            remrec_.income_type_id||'^'||remrec_.currency_code||'^'||remrec_.country_code);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT income_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.internal_income_type := Get_New_Id___;
   super(newrec_, indrec_, attr_);
   IF (Get_Internal_Income_Type(newrec_.income_type_id, newrec_.currency_code, newrec_.country_code) IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ALREADYEXIST: Income Type :P1 already exist for country :P2 and currency :P3. ', newrec_.income_type_id, newrec_.country_code, newrec_.currency_code);
   END IF;      
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN income_type_tab%ROWTYPE )
IS
   internal_income_type_ NUMBER;
   new_id_               NUMBER;
   CURSOR exist IS
      SELECT internal_income_type
      FROM   income_type_tab
      WHERE  income_type_id = newrec_.income_type_id
      AND    currency_code  = newrec_.currency_code
      AND    country_code   = newrec_.country_code;
BEGIN
   OPEN exist;
   FETCH exist INTO internal_income_type_;
   IF (exist%NOTFOUND) THEN
      new_id_ := Get_New_Id___;
      INSERT
         INTO income_type_tab (
            internal_income_type,
            income_type_id,
            currency_code,
            description,
            threshold_amount,
            income_reporting_code,
            country_code,
            blocked,
            rowversion,
            tax_withhold_code)
         VALUES (
            new_id_,
            newrec_.income_type_id,
            newrec_.currency_code,
            newrec_.description,
            newrec_.threshold_amount,
            newrec_.income_reporting_code,
            newrec_.country_code,
            newrec_.blocked,
            newrec_.rowversion,
            newrec_.tax_withhold_code);
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP',
                                                          lu_name_,
                                                          newrec_.income_type_id||'^'||newrec_.currency_code||'^'||newrec_.country_code,
                                                          newrec_.description);
   ELSE
      Basic_Data_Translation_API.Insert_Prog_Translation('ENTERP',
                                                          lu_name_,
                                                          newrec_.income_type_id||'^'||newrec_.currency_code||'^'||newrec_.country_code,
                                                          newrec_.description);
      UPDATE income_type_tab
         SET description = newrec_.description
         WHERE internal_income_type = internal_income_type_;
   END IF;
   CLOSE exist;
END Insert_Lu_Data_Rec__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Internal_Income_Type (
   income_type_id_   IN VARCHAR2,
   currency_code_    IN VARCHAR2,
   country_code_     IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ income_type_tab.internal_income_type%TYPE;
   CURSOR get_attr IS
      SELECT internal_income_type
      FROM   income_type_tab
      WHERE  income_type_id = income_type_id_
      AND    currency_code  = currency_code_
      AND    country_code   = country_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Internal_Income_Type;


@UncheckedAccess
FUNCTION Get_Tax_Withhold_Code_Db (
   company_           IN VARCHAR2,
   income_type_id_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   tax_withhold_code_  income_type_tab.tax_withhold_code%TYPE;
   currency_code_      income_type_tab.currency_code%TYPE;
   country_code_       income_type_tab.country_code%TYPE;
   CURSOR get_withhold_code IS
      SELECT tax_withhold_code
      FROM   income_type_tab
      WHERE  income_type_id = income_type_id_
      AND    currency_code  = currency_code_
      AND    country_code   = country_code_;
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      currency_code_:= Company_Finance_API.Get_Currency_Code(company_);
   $ELSE
      NULL;
   $END
   country_code_  := Company_API.Get_Country_Db(company_);
   OPEN   get_withhold_code;
   FETCH  get_withhold_code INTO tax_withhold_code_;
   CLOSE  get_withhold_code;
   RETURN tax_withhold_code_;
END Get_Tax_Withhold_Code_Db;


-- This method is to be used by Aurena
FUNCTION Check_Income_Type_Id_Mandatory ( 
   internal_income_type_     IN NUMBER,
   income_type_id_           IN VARCHAR2 ) RETURN VARCHAR2
IS       
   exist_                  NUMBER;
   CURSOR check_mandatory_type_exist(internal_income_type_ NUMBER, income_type_id_ VARCHAR2) IS
      SELECT 1
      FROM   income_type 
      WHERE  internal_income_type = internal_income_type_
      AND    income_type_id         = income_type_id_
      AND    tax_withhold_code      = Tax_Withhold_Code_API.Decode(Tax_Withhold_Code_API.DB_MANDATORY); 
BEGIN         
   OPEN  check_mandatory_type_exist(internal_income_type_, income_type_id_);
   FETCH check_mandatory_type_exist INTO exist_;
   IF (check_mandatory_type_exist%FOUND) THEN  
      CLOSE check_mandatory_type_exist;
      RETURN 'TRUE';   
   END IF;
   CLOSE check_mandatory_type_exist;
   RETURN 'FALSE'; 
END Check_Income_Type_Id_Mandatory;

