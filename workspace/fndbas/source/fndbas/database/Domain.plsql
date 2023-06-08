-----------------------------------------------------------------------------
--
--  Logical unit: Domain
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950504  STLA  Created for EVEREST Server as GENIID.CRE
--  950606  ERFO  Added header documentation examples.
--  950607  ERFO  Converted to new standards and renamed to GENIID.CRE.
--  950615  ERFO  Added support for null values in DB_VALUES-list.
--  950822  ERFO  Added methods Get_Db_Value and Get_Client_Value.
--  950825  STLA  Changed header examples for LU-definitions.
--  950905  ERFO  Set the separator_ variable from Client_SYS-definition.
--  950911  ERFO  Added initialization section with a translation call.
--  950912  ERFO  Re-organized the code, removed method Get_Description.
--  950913  ERFO  Changed separator, new definition and use of symbol PKG.
--  950914  ERFO  Limitation with 20 elements of maximum 5 characters for
--                db-values and 20 characters for client-values.
--  951025  ERFO  Removed all limitations. The limit for the client and db
--                value will now be 2000 bytes according to the SQL-language.
--  951130  ERFO  Error handle of null values in method Exist and added new
--                parameter when calling Error_SYS.Record_Not_Exist.
--  960111  ERFO  Added method Language_Refreshed to support language
--                setting changes on the fly (Idea #326).
--  960304  ERFO  Added module concept to the utility (Idea #431).
--  960426  ERFO  Changes due to new server template versions.
--  960429  ERFO  Corrected method Exist for similar client values (Bug #543).
--  960507  ERFO  Added language translation tag for special cases.
--  960913  ERFO  Re-design as system service Domain_SYS (Idea #796).
--  960913  ERFO  Added method Init to be compatible to server templates.
--  980303  ERFO  Removed tag for early translation support (ToDo #2184).
--  980429  ERFO  Changes when using instr to support Oracle8 (Bug #2409).
--  020628  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  091001  HAAR  Added support for changing language (EACS-123).
--  091126  HAAR  Added method Decode_Subset_ (EACS-204).
--  101022  MaBo  EACS-1170 Increased length of variable client_id in Get_Ctx_Values___
-----------------------------------------------------------------------------
--
--  Dependencies: Client_SYS
--                Language_SYS
--                Error_SYS
--
-----------------------------------------------------------------------------
--
--  Contents:     Object verification methods
--                Storage conversion methods
--                Object developing methods for compatibility in IFS APPLICATIONS
--                Translation methods connected to system service Language_SYS
--                IFS Foundation internal methods for performance reasons onl
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

separator_      CONSTANT VARCHAR2(1)  := Client_SYS.field_separator_;
suffix_         CONSTANT VARCHAR2(30) := '_CTX';
ctx_length_     CONSTANT NUMBER       := 4000;
list_separator_ CONSTANT VARCHAR2(1)  := ';';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Client_Value_Is_List___ (client_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
  RETURN (SUBSTR(client_value_,0,1) = Client_SYS.text_separator_); --value lists starts with ^
END Client_Value_Is_List___;


FUNCTION Get_First_Nonexistent_Item___ (
     client_list_ IN VARCHAR2,
     client_value_ IN VARCHAR2,
     delimiter_ IN VARCHAR2) RETURN VARCHAR2
IS
     split_str_ VARCHAR2(4000);
     count_ NUMBER;
     items_ Utility_SYS.STRING_TABLE;
BEGIN
     split_str_ := LTRIM(client_value_, delimiter_);
     IF (substr(split_str_, length(split_str_), 1) <> delimiter_ ) THEN
        split_str_ := split_str_ || delimiter_; 
     END IF;
     Utility_SYS.Tokenize(split_str_, delimiter_, items_, count_);
     
     FOR i_ IN 1..items_.COUNT LOOP
          IF NOT (Exist_Single___ (client_list_, items_(i_))) THEN
               RETURN items_(i_);
          END IF;
     END LOOP;
     
     RETURN NULL;
END Get_First_Nonexistent_Item___;


FUNCTION Exist_Single___ (
	client_list_ IN VARCHAR2,
	client_value_item_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (('^'||client_list_ NOT LIKE '%^'||client_value_item_||'^%') OR (client_value_item_ IS NULL)) THEN
      RETURN(FALSE);
   ELSE
      RETURN(TRUE);
   END IF;
END Exist_Single___;


FUNCTION Exist_Multi___ (
	client_list_ IN VARCHAR2,
	client_value_list_ IN VARCHAR2,
   delimiter_ IN VARCHAR2) RETURN BOOLEAN
IS  
BEGIN
     RETURN (Get_First_Nonexistent_Item___(client_list_, client_value_list_,delimiter_) IS NULL);
END Exist_Multi___;


FUNCTION Encode_Single___ (
   client_list_  IN VARCHAR2,
   db_list_      IN VARCHAR2,
   client_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_     NUMBER;
   client_ NUMBER;
   temp_   VARCHAR2(2000);
   index_  NUMBER;
BEGIN
   db_     := 1;
   client_ := 1;
   LOOP
      index_  := instr(client_list_, '^', client_);
      EXIT WHEN ( nvl(index_, 0) = 0 );
      temp_   := substr(client_list_, client_, index_-client_);
      client_ := index_+1;
      index_  := instr(db_list_, '^', db_);
      IF (temp_ = client_value_) THEN
         RETURN(substr(db_list_, db_, index_-db_));
      END IF;
      db_ := index_+1;
   END LOOP;
   RETURN(NULL);
END Encode_Single___;


FUNCTION Encode_Multi___ (
   client_list_  IN VARCHAR2,
   db_list_      IN VARCHAR2,
   client_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS  
   split_str_ VARCHAR2(4000);
   encoded_ VARCHAR2(4000);
   encoded_item_ VARCHAR2(4000);
   delimiter_ CONSTANT VARCHAR2(1) := Client_SYS.text_separator_;
   count_ NUMBER;
   items_ Utility_SYS.STRING_TABLE;
BEGIN
	split_str_ := LTRIM(client_value_, list_separator_);
	Utility_SYS.Tokenize(split_str_, list_separator_, items_, count_);
   
	FOR i_ IN 1..items_.COUNT LOOP
      encoded_item_ := Encode_Single___ (client_list_, db_list_, items_(i_));
      IF encoded_item_ IS NOT NULL THEN
         encoded_ := encoded_ || encoded_item_ || delimiter_;   
      END IF;
   END LOOP;
   
   IF LENGTH(encoded_) > 0 THEN
      encoded_ := delimiter_ || encoded_;
   END IF;
   
   RETURN(encoded_);
    
END Encode_Multi___;


FUNCTION Decode_Single___ (
   client_list_ IN VARCHAR2,
   db_list_     IN VARCHAR2,
   db_value_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_     NUMBER;
   client_ NUMBER;
   temp_   VARCHAR2(2000);
   index_  NUMBER;
BEGIN
   db_     := 1;
   client_ := 1;
   LOOP
      index_  := instr(db_list_, '^', db_);
      EXIT WHEN ( nvl(index_, 0) = 0);
      temp_   := substr(db_list_, db_, index_-db_);
      db_     := index_+1;
      index_  := instr(client_list_, '^', client_);
      IF (temp_ = db_value_ OR (temp_ IS NULL AND db_value_ IS NULL)) THEN
         RETURN(substr(client_list_, client_, index_-client_));
      END IF;
      client_ := index_+1;
   END LOOP;
   RETURN(NULL);
END Decode_Single___;


FUNCTION Decode_Multi___ (
   client_list_ IN VARCHAR2,
   db_list_     IN VARCHAR2,
   db_value_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   split_str_ VARCHAR2(4000);
   decoded_ VARCHAR2(4000);
   decoded_item_ VARCHAR2(4000);
   delimiter_ CONSTANT VARCHAR2(1) := Client_SYS.text_separator_;
   count_ NUMBER;
   items_ Utility_SYS.STRING_TABLE;
BEGIN
	split_str_ := LTRIM(db_value_, delimiter_);
	Utility_SYS.Tokenize(split_str_, delimiter_, items_, count_);
   
	FOR i_ IN 1..items_.COUNT LOOP
      decoded_item_ := Decode_Single___ (client_list_, db_list_, items_(i_));
      IF decoded_item_ IS NOT NULL THEN
         decoded_ := decoded_ || decoded_item_ || list_separator_;   
      END IF;
   END LOOP;
   
   decoded_ := RTRIM(decoded_,list_separator_);
   
   RETURN(decoded_);
END Decode_Multi___;


FUNCTION Get_Ctx_Values___ (
   domain_ IN VARCHAR2,
   value_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   client_id_     CONSTANT VARCHAR2(64) := Sys_Context('USERENV', 'CLIENT_IDENTIFIER');
   context_       CONSTANT VARCHAR2(30) := domain_ ||suffix_;
   context_value_          VARCHAR2(4000);
BEGIN
   -- We would like to have this check, but it is causing a lot of problems right now.
   -- Raise an error if the domain name is not in the Dictionary
   --IF (NOT Dictionary_SYS.Logical_Unit_Is_Installed(domain_)) THEN 
   --   Error_SYS.Appl_General(service_, 'NOT_A_LU: The domain [:P1] is not a LU in the Dictionary.', domain_);
   --END IF;
   -- The use of global context does not handle when Client Identifier is set, therefore we need to unset it when fetching from the context
   -- If client identifier is set
   IF (client_id_ IS NOT NULL) THEN
      -- Clear client identifier
      Dbms_Session.Clear_Identifier;
      context_value_ := Sys_Context(context_, nvl(value_, 'PROG'), ctx_length_); -- Use PROG if no language
      -- Set back Client identifier
      Dbms_Session.Set_Identifier(client_id_);
   ELSE
      context_value_ := Sys_Context(context_, nvl(value_, 'PROG'), ctx_length_);  -- Use PROG if no language
   END IF;
   RETURN(context_value_);
EXCEPTION
   -- What ever happens make sure that Client Identifier is set to its original value
   WHEN OTHERS THEN
      Dbms_Session.Set_Identifier(client_id_);
      RAISE;
END Get_Ctx_Values___;


PROCEDURE Set_Ctx_Values___ (
   context_    IN VARCHAR2,
   attribute_  IN VARCHAR2,
   value_      IN VARCHAR2 )
IS
   client_id_     CONSTANT VARCHAR2(64) := Sys_Context('USERENV', 'CLIENT_IDENTIFIER');
BEGIN
   IF (client_id_ IS NOT NULL) THEN
      -- Clear client identifier
      Dbms_Session.Clear_Identifier;
      Dbms_Session.Set_Context(namespace => context_,
                               attribute => attribute_,
                               VALUE     => value_);
      -- Set back Client identifier
      Dbms_Session.Set_Identifier(client_id_);
   ELSE
      Dbms_Session.Set_Context(namespace => context_,
                               attribute => attribute_,
                               VALUE     => value_);
   END IF;
END Set_Ctx_Values___;


FUNCTION Get_Client_Values___ (
   domain_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_Ctx_Values___(domain_, 'PROG'));
END Get_Client_Values___;


FUNCTION Is_Domain_Loaded___ (
   domain_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   loaded_        VARCHAR2(5):= nvl(Get_Ctx_Values___(domain_, 'LOADED'), Fnd_Boolean_API.Db_False);
   package_name_  VARCHAR2(30);
   no_enumeration EXCEPTION;
   PRAGMA EXCEPTION_INIT(no_enumeration, -6550);
BEGIN
   IF (loaded_ =  Fnd_Boolean_API.Db_False) THEN
      package_name_  := Dictionary_SYS.Get_Base_Package(domain_);
      Assert_SYS.Assert_Is_Package(package_name_);
      @ApproveDynamicStatement(2014-08-29,haarse)
      EXECUTE IMMEDIATE 'BEGIN '||package_name_||'.LANGUAGE_REFRESHED; END;';
      loaded_ := nvl(Get_Ctx_Values___(domain_, 'LOADED'), Fnd_Boolean_API.Db_False);
   END IF;
   RETURN(loaded_);
EXCEPTION
   WHEN no_enumeration THEN 
      RETURN(Fnd_Boolean_API.Db_False);
END Is_Domain_Loaded___;


PROCEDURE Load_Translations___ (
   domain_ IN VARCHAR2,
   type_   IN VARCHAR2 DEFAULT 'IID' ) IS

   context_       CONSTANT VARCHAR2(30) := domain_ ||suffix_;

   CURSOR get_translations IS
      SELECT lang_code
        FROM Language_Code_Tab
       WHERE installed = 'TRUE';
BEGIN
   FOR rec IN get_translations LOOP
      CASE type_
         WHEN 'IID' THEN
            Set_Ctx_Values___(context_,
                              rec.lang_code,
                              Language_SYS.Translate_Iid_ (domain_, Get_Client_Values___(domain_), rec.lang_code));
         WHEN 'STATE' THEN
            Set_Ctx_Values___(context_,
                              rec.lang_code,
                              Language_SYS.Translate_State_ (domain_, Get_Client_Values___(domain_), rec.lang_code));
         ELSE
            Error_SYS.Appl_General(service_, 'INVALID_TYPE: Domain_SYS can only handle IID OR STATE translations.');
      END CASE;
   END LOOP;
END Load_Translations___;

-- Note: The calling method of this Procedure should validate
--       that the stmt_ been executed is safe
PROCEDURE Run_Statement___ (
   stmt_ IN VARCHAR2 )
IS
BEGIN
   @ApproveDynamicStatement(2011-05-30,haarse)
   EXECUTE IMMEDIATE stmt_;
EXCEPTION 
   WHEN OTHERS THEN
      Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Error on statement: '||stmt_);
END Run_Statement___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
PROCEDURE Exist_ (
   lu_name_      IN VARCHAR2,
   client_list_  IN VARCHAR2,
   client_value_ IN VARCHAR2 )
IS
BEGIN
   IF NOT (Exist_(lu_name_, client_list_, client_value_)) THEN
     Error_SYS.Record_Not_Exist(lu_name_, p1_ => client_value_);
   END IF;
END Exist_;

@UncheckedAccess
PROCEDURE Exist_List_ (
   lu_name_      IN VARCHAR2,
   client_list_  IN VARCHAR2,
   client_value_ IN VARCHAR2 )
IS
BEGIN
   IF NOT (Exist_List_(lu_name_, client_list_, client_value_)) THEN
     Error_SYS.Record_Not_Exist(lu_name_, p1_ => Get_First_Nonexistent_Item___(client_list_,client_value_,list_separator_));
   END IF;
END Exist_List_;

@UncheckedAccess
PROCEDURE Exist_List_Db_ (
   lu_name_      IN VARCHAR2,
   client_list_  IN VARCHAR2,
   client_value_ IN VARCHAR2 )
IS
BEGIN
   IF NOT (Exist_List_Db_(lu_name_, client_list_, client_value_)) THEN
     Error_SYS.Record_Not_Exist(lu_name_, p1_ => Get_First_Nonexistent_Item___(client_list_,client_value_,Client_SYS.text_separator_));
   END IF;
END Exist_List_Db_;

@UncheckedAccess
FUNCTION Exist_ (
   lu_name_      IN VARCHAR2,
   client_list_  IN VARCHAR2,
   client_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Exist_Single___(client_list_, client_value_);
END Exist_;

@UncheckedAccess
FUNCTION Exist_List_ (
   lu_name_      IN VARCHAR2,
   client_list_  IN VARCHAR2,
   client_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Exist_Multi___(client_list_, client_value_,list_separator_);
END Exist_List_;

@UncheckedAccess
FUNCTION Exist_List_Db_ (
   lu_name_      IN VARCHAR2,
   client_list_  IN VARCHAR2,
   client_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Exist_Multi___(client_list_, client_value_,Client_SYS.text_separator_);
END Exist_List_Db_;


@UncheckedAccess
FUNCTION Enumerate_ (
   client_list_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(replace(client_list_, '^', separator_));
END Enumerate_;



@UncheckedAccess
FUNCTION Encode_ (
   client_list_  IN VARCHAR2,
   db_list_      IN VARCHAR2,
   client_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN   
   RETURN Encode_Single___(client_list_, db_list_, client_value_);
END Encode_;

@UncheckedAccess
FUNCTION Encode_List_ (
   client_list_  IN VARCHAR2,
   db_list_      IN VARCHAR2,
   client_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN   
   RETURN Encode_Multi___(client_list_, db_list_, client_value_);
END Encode_List_;

@UncheckedAccess
FUNCTION Decode_ (
   client_list_ IN VARCHAR2,
   db_list_     IN VARCHAR2,
   db_value_    IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Decode_Single___(client_list_, db_list_, db_value_);
END Decode_;

@UncheckedAccess
FUNCTION Decode_List_ (
   client_list_ IN VARCHAR2,
   db_list_     IN VARCHAR2,
   db_value_    IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Decode_Multi___(client_list_, db_list_, db_value_);
END Decode_List_;

@UncheckedAccess
FUNCTION Decode_Subset_ (
   client_list_ IN VARCHAR2,
   db_list_     IN VARCHAR2,
   db_sub_list_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_     NUMBER;
   db2_    NUMBER;
   client_ NUMBER;
   temp_   VARCHAR2(2000);
   temp2_  VARCHAR2(2000);
   index_  NUMBER;
   index2_ NUMBER;
   translated_list_ VARCHAR2(2000);
BEGIN
   db_     := 1;
   LOOP
      index_  := instr(db_sub_list_, '^', db_);
      EXIT WHEN (index_ = 0);

      temp_   := substr(db_sub_list_, db_, index_-db_);
      db_     := index_+1;

      db2_ := 1;
      client_ := 1;
      LOOP
         index2_ := instr(db_list_, '^', db2_);
         EXIT WHEN (index2_ = 0);
         temp2_ := substr(db_list_, db2_,index2_-db2_);
         db2_ := index2_ + 1;
         index2_  := instr(client_list_, '^', client_);
         IF (temp_ = temp2_) THEN
            IF (translated_list_ IS NULL) THEN
               translated_list_ := substr(client_list_, client_, index2_-client_)|| '^';
            ELSE
               translated_list_ := translated_list_ ||substr(client_list_, client_, index2_-client_)|| '^';
            END IF;
         END IF; 
         client_ := index2_+1;
      END LOOP;
   END LOOP;
   RETURN translated_list_;
END Decode_Subset_;



@UncheckedAccess
FUNCTION Get_Db_Value_ (
   db_list_ IN VARCHAR2,
   index_   IN NUMBER ) RETURN VARCHAR2
IS
   from_ NUMBER;
   to_   NUMBER;
BEGIN
   to_   := instr(db_list_, '^', 1, index_+1);
   IF (index_ = 0) THEN
      RETURN(substr(db_list_, 0, to_-1));
   ELSE
      from_ := instr(db_list_, '^', 1, index_);
      RETURN(substr(db_list_, from_+1, to_-from_-1));
   END IF;
END Get_Db_Value_;



@UncheckedAccess
FUNCTION Get_Client_Value_ (
   client_list_ IN VARCHAR2,
   index_       IN NUMBER ) RETURN VARCHAR2
IS
   from_ NUMBER;
   to_   NUMBER;
BEGIN
   to_   := instr(client_list_, '^', 1, index_+1);
   IF (index_ = 0) THEN
      RETURN(substr(client_list_, 0, to_-1));
   ELSE
      from_ := instr(client_list_, '^', 1, index_);
      RETURN(substr(client_list_, from_+1, to_-from_-1));
   END IF;
END Get_Client_Value_;



@UncheckedAccess
FUNCTION Get_Nls_Client_List_ (
   lu_name_     IN  VARCHAR2,
   client_list_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_Translated_Values(lu_name_));
END Get_Nls_Client_List_;


PROCEDURE Refresh_Language_
IS
--
-- Changed cursor only to include IID-domains
--
   stmt_                    VARCHAR2(1000);
   refresh_method_ CONSTANT VARCHAR2(20) := 'LANGUAGE_REFRESHED';

   CURSOR lang_ref IS
      SELECT object_name package_name
      FROM   user_procedures p
      WHERE  procedure_name = refresh_method_
      AND    object_name NOT IN ('DOMAIN_SYS', 'CUSTOM_FIELDS_SYS');
      
BEGIN
   General_SYS.Check_Security(service_, 'DOMAIN_SYS', 'Refresh_Language_');
   FOR pkg IN lang_ref LOOP
      stmt_ := 'BEGIN ' || pkg.package_name || '.' || refresh_method_||' ; END;';
      -- No need for Assert check as values are fetched from Oracle Dictionary
      -- Assert_SYS.Assert_Is_Package_Method(pkg.package_name, refresh_method_);
      Run_Statement___(stmt_);
   END LOOP;
END Refresh_Language_;


PROCEDURE Refresh_Language_ (
   lu_   IN VARCHAR2 )
IS
--
-- Changed cursor only to include IID-domains
--
   stmt_                    VARCHAR2(1000);
   refresh_method_ CONSTANT VARCHAR2(20) := 'LANGUAGE_REFRESHED';
   pkg_ VARCHAR2(30);
BEGIN
   General_SYS.Check_Security(service_, 'DOMAIN_SYS', 'Refresh_Language_');
   pkg_ := Dictionary_SYS.Get_Base_Package(lu_);
   stmt_ := 'BEGIN ' || pkg_ || '.' || refresh_method_||' ; END;';
   Assert_SYS.Assert_Is_Package_Method(pkg_, refresh_method_);
   Run_Statement___(stmt_);
END Refresh_Language_;

PROCEDURE Refresh_Component_Language_ (
   component_ IN VARCHAR2 ) 
IS
   stmt_                    VARCHAR2(1000);
   refresh_method_ CONSTANT VARCHAR2(20) := 'LANGUAGE_REFRESHED';
   --SOLSETFW
   CURSOR lang_ref IS
      SELECT p.object_name package_name
        FROM user_procedures p, dictionary_sys_package_active pkg, dictionary_sys_active m
       WHERE procedure_name = refresh_method_
         AND m.module       = component_
         AND m.lu_name      = pkg.lu_name
         AND pkg.package_name = p.object_name
         AND object_name NOT IN ('DOMAIN_SYS', 'CUSTOM_FIELDS_SYS');
   
BEGIN
   General_SYS.Check_Security(service_, 'DOMAIN_SYS', 'Refresh_Component_Language_');
   FOR pkg IN lang_ref LOOP
      stmt_ := 'BEGIN ' || pkg.package_name || '.' || refresh_method_||' ; END;';
      -- No need for Assert check as values are fetched against Oracle View
      Run_Statement___(stmt_);
   END LOOP;
END Refresh_Component_Language_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Db_Values (
   domain_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_Ctx_Values___(domain_, 'DB'));
END Get_Db_Values;



@UncheckedAccess
FUNCTION Get_Prog_Values (
   domain_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_Ctx_Values___(domain_, 'PROG'));
END Get_Prog_Values;



@UncheckedAccess
FUNCTION Get_Translated_Values (
   domain_ IN VARCHAR2,
   lang_code_ IN VARCHAR2 DEFAULT Fnd_Session_API.Get_Language) RETURN VARCHAR2
IS
BEGIN
   RETURN(nvl(Get_Ctx_Values___(domain_, lang_code_), Get_Client_Values___(domain_)));
END Get_Translated_Values;



@UncheckedAccess
PROCEDURE Debug (
   domain_ IN VARCHAR2 )
IS
   context_ CONSTANT VARCHAR2(30) := domain_ ||suffix_;
   CURSOR get_lang IS
      SELECT lang_code
        FROM Language_Code_Tab l
       WHERE installed = 'TRUE'
    ORDER BY lang_code;
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Check loaded: '||Is_Domain_Loaded___(domain_));
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, context_||': '||domain_);
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, '==========================================================');
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'LOADED: '||Get_Ctx_Values___(domain_, 'LOADED'));
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'DB: '||Get_Ctx_Values___(domain_, 'DB'));
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'PROG: '||Get_Ctx_Values___(domain_, 'PROG'));
   FOR rec IN get_lang LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, rec.lang_code||': '||Get_Ctx_Values___(domain_, rec.lang_code));
   END LOOP;
END Debug;


@UncheckedAccess
FUNCTION Get (
   domain_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(32767) := Message_SYS.Construct(domain_);
BEGIN
   IF (Is_Domain_Loaded___(domain_) = Fnd_Boolean_API.DB_TRUE) THEN 
      Message_SYS.Add_Attribute(msg_, 'DB_VALUES', Get_Db_Values(domain_));
      Message_SYS.Add_Attribute(msg_, 'CLIENT_VALUES', Get_Translated_Values(domain_));
   ELSE
      msg_ := NULL;
   END IF;
   RETURN(msg_);
END Get;


@UncheckedAccess
PROCEDURE Load_Iid (
   domain_ IN VARCHAR2,
   client_value_list_ IN VARCHAR2,
   db_value_list_ IN VARCHAR2 )
IS
BEGIN
   IF (Domain_SYS.Is_Domain_Loaded___(domain_) = 'FALSE') THEN
      Language_Refreshed(domain_, client_value_list_, db_value_list_, 'IID');
   END IF;
END Load_Iid;


@UncheckedAccess
PROCEDURE Load_State (
   domain_ IN VARCHAR2,
   client_value_list_ IN VARCHAR2,
   db_value_list_ IN VARCHAR2 )
IS
BEGIN
   IF (Domain_SYS.Is_Domain_Loaded___(domain_) = 'FALSE') THEN
      Language_Refreshed(domain_, client_value_list_, db_value_list_, 'STATE');
   END IF;
END Load_State;


@UncheckedAccess
PROCEDURE Language_Refreshed (
   domain_            IN VARCHAR2,
   client_value_list_ IN VARCHAR2,
   db_value_list_     IN VARCHAR2,
   type_              IN VARCHAR2 DEFAULT 'IID' )
IS
   context_       CONSTANT VARCHAR2(30) := domain_ || suffix_;
   
   no_context     EXCEPTION;
   PRAGMA EXCEPTION_INIT(no_context, -1031);
BEGIN
   -- Don't do refresh during installation
   Dbms_Session.Clear_All_Context(context_);
   Set_Ctx_Values___(context_, 'PROG', client_value_list_);
   Set_Ctx_Values___(context_, 'DB', db_value_list_);
   --
   IF (Installation_SYS.Get_Installation_Mode = FALSE) THEN
      --
      -- Load translations only if you are not in installation mode
      --
      Load_Translations___(domain_, type_);
      Set_Ctx_Values___(context_, 'LOADED', 'TRUE');
   END IF;
EXCEPTION
   WHEN no_context THEN
      Error_SYS.Appl_General(service_, 'NO_CONTEXT: Context [:P1] seems to be missing.', context_);
END Language_Refreshed;



