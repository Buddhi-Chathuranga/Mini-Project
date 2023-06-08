-----------------------------------------------------------------------------
--
--  Logical unit: FndClientUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
ifssys_                 CONSTANT VARCHAR2(30)  := 'IFSSYS';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Reset_Session___
IS
BEGIN
   IF (User != ifssys_) THEN
      Error_SYS.Appl_General(service_, 'NOT_IFSSYS_USER2: Only IFS Applications System user is allowed to run this method.');
   END IF;
   Fnd_Session_Util_API.Clear_User_Properties_(TRUE);
   Dbms_Application_Info.Set_Module(NULL, NULL); 
   Dbms_Session.Set_Identifier(NULL);      
END Reset_Session___;

FUNCTION Get_Client_Metadata___ (
   client_name_ IN VARCHAR2,
   scope_id_    IN VARCHAR2) RETURN CLOB
IS   
BEGIN
   --Validate_Client_Metadata___(client_name_, allowed_categories_);
   RETURN Model_Design_SYS.Get_Data_Content_(Model_Design_SYS.CLIENT_METADATA, 'client', client_name_, language_ => Fnd_Session_API.Get_Language, scope_id_ => scope_id_);
END Get_Client_Metadata___;

FUNCTION Get_Client_Metadata_Version___ (
   client_name_    IN VARCHAR2) RETURN CLOB
IS
BEGIN
   RETURN Model_Design_SYS.Get_Data_Version_(Model_Design_SYS.CLIENT_METADATA, 'client', client_name_);
END Get_Client_Metadata_Version___;


FUNCTION Get_Metadata_Category___ (
   client_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   client_pkg_ VARCHAR2(200) := Utility_SYS.Pascal_To_Underscore(client_name_) || '_cpi';
   pkg_method_ VARCHAR2(200) := 'Get_Metadata_Category_';
   stmt_ VARCHAR2(4000) := 'BEGIN :category_:=' || client_pkg_ || '.' || pkg_method_ || '; END;';
   category_ VARCHAR2(100);
BEGIN
   -- Calling procedure "Validate_Projection_Metadata___" does the is_projection assertion.
   @ApproveDynamicStatement(2018-01-26,kratlk)
   EXECUTE IMMEDIATE stmt_ USING OUT category_;
   RETURN category_;
END Get_Metadata_Category___;


PROCEDURE Validate_Client_Metadata___ (
   client_name_    IN VARCHAR2,
   allowed_categories_ IN VARCHAR2)
IS
   categories_    VARCHAR2(200);
   category_list_ DBMS_UTILITY.UNCL_ARRAY;
   category_count_ INTEGER;
BEGIN 
   Assert_SYS.Assert_Is_Projection(client_name_);
   categories_ := Get_Metadata_Category___(client_name_);
   IF categories_ IS NULL THEN 
      IF INSTR(allowed_categories_, 'Empty', 1) = 0 THEN 
         Error_SYS.Projection_Category(lu_name_, client_name_);
      END IF;        
   ELSE
      DBMS_UTILITY.COMMA_TO_TABLE (categories_, category_count_, category_list_);
      FOR category_id_ IN 1 .. category_count_
      LOOP
         IF INSTR(allowed_categories_, category_list_(category_id_), 1) = 0 THEN
            Error_SYS.Projection_Category(lu_name_, client_name_, category_list_(category_id_));
         END IF;
      END LOOP;
   END IF;
END Validate_Client_Metadata___;

PROCEDURE Set_Language___ (
   lang_code_rfc3066_ IN VARCHAR2)
IS
   lang_code_ VARCHAR2(5); 
BEGIN
   Fnd_Session_API.Set_Rfc3066__(lang_code_rfc3066_);
   lang_code_ := Language_Code_API.Get_Lang_Code_From_Rfc3066(lang_code_rfc3066_);
   IF lang_code_ IS NULL THEN
      Error_SYS.Appl_General(service_, 'INVALID_LANG_CODE: Invalid laguage code (:P1).',lang_code_rfc3066_);
   END IF;
   Fnd_Session_API.Set_Language(lang_code_);
END Set_Language___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
-- Init_ifsweb_Sys_Session_
--   This method is to be called from ifsweb service providers to initialize a System database session
@UncheckedAccess
PROCEDURE Init_Ifsweb_Sys_Session_ (
   lang_code_rfc3066_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   IF (User != ifssys_) THEN
      Error_SYS.Appl_General(service_, 'NOT_IFSSYS_USER: Only IFS Applications System user is allowed to run initiate sessions.');
   END IF;
   Reset_Session___;
   Fnd_Context_SYS.Set_Value('LOGIN_SYS.method_security_', FALSE);
   Dbms_Session.Set_Identifier('IFSWEB-Internal');
   IF lang_code_rfc3066_ IS NOT NULL THEN
      Set_Language___(lang_code_rfc3066_);
   END IF;
END Init_Ifsweb_Sys_Session_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Get_Client_Metadata_ (
   client_name_        IN VARCHAR2,
   allowed_categories_ IN VARCHAR2,
   scope_id_           IN VARCHAR2 DEFAULT 'global') RETURN CLOB
IS
BEGIN
   RETURN Get_Client_Metadata___(client_name_, scope_id_);
END Get_Client_Metadata_;


FUNCTION Get_Client_Metadata_Version_ (
   client_name_ IN VARCHAR2,
   allowed_categories_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Client_Metadata_Version___(client_name_);
END Get_Client_Metadata_Version_;
-------------------- LU  NEW METHODS -------------------------------------
