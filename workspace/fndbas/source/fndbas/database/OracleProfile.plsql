-----------------------------------------------------------------------------
--
--  Logical unit: OracleProfile
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  010301  HAARSE  Created (ToDo#4000).
--  010424  ROOD    Removed restriction upon view (ToDo#4000).
--  010425  ROOD    Added handling of kernel parameters in Alter_Profile__ (ToDo#4000).
--  010620  ROOD    Corrected usage of General_SYS.Init_Method.
--  010911  ROOD    Added Get_Limit_Db, changed view ORACLE_PROFILE_LIMIT,
--                  modified Create_Profile__, Alter_Profile__ and Drop_Profile__(ToDo#4000).
--  010912  ROOD    Translated value for PASSWORD_VERIFY_FUNCTION (ToDo#4000).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040331  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  050323  JORASE   Added assertion for dynamic SQL.  (F1PR481)
--                   Remove Run_Ddl_Command___.
--  060105  UTGULK Annotated Sql injection
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_Profile__ (
   objid_ OUT    VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
   ptr_               NUMBER;
   name_              VARCHAR2(30);
   value_             VARCHAR2(200);
   profile_           VARCHAR2(30);
                      
   ddl_string_        VARCHAR2(2000);
   length_            NUMBER;
   conflicting_values EXCEPTION;
   PRAGMA             EXCEPTION_INIT(conflicting_values, -28006);
   function_not_exist EXCEPTION;
   PRAGMA             EXCEPTION_INIT(function_not_exist, -07443);
   invalid_limit      EXCEPTION;
   PRAGMA             EXCEPTION_INIT(invalid_limit, -02377);
BEGIN
   -- Retrieve parameters from the attribute string and build the ddl string
   profile_ := Client_SYS.Get_Item_Value('PROFILE', attr_);
   Assert_SYS.Assert_Is_Valid_Identifier(profile_);
   ddl_string_ := 'CREATE PROFILE "'|| profile_ ||'" LIMIT';
   length_ := length(ddl_string_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
	value_ := nvl(Oracle_Profile_Limits_API.Encode(value_),value_);
      IF (name_ = 'FAILED_LOGIN_ATTEMPTS') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_LIFE_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_REUSE_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_REUSE_MAX') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_LOCK_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_GRACE_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_VERIFY_FUNCTION') THEN
         -- Translation needed because of strange Oracle syntax
         IF value_ = 'UNLIMITED' THEN
            value_ := 'NULL';
         END IF;
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'COMPOSITE_LIMIT') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'SESSIONS_PER_USER') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'CPU_PER_SESSION') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'CPU_PER_CALL') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'LOGICAL_READS_PER_SESSION') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'LOGICAL_READS_PER_CALL') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'IDLE_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'CONNECT_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PRIVATE_SGA') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PROFILE') THEN
         NULL;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   Trace_SYS.Field('DDL string', ddl_string_);
   IF length_ = length(ddl_string_) THEN
      -- No limits has been added to the ddl string
      Error_SYS.Record_General(lu_name_, 'NO_PROFILE_LIMITS_C: Can not create the profile :P1 since no limits has been specified!', profile_);
   ELSE
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE ddl_string_;
      objid_ := profile_;
   END IF;
EXCEPTION
   WHEN conflicting_values THEN
      Error_SYS.Record_General(lu_name_, 'CONFLICTING_VALUES_A: Conflicting values for parameters PASSWORD_REUSE_TIME = :P1 and PASSWORD_REUSE_MAX = :P2!', Client_SYS.Get_Item_Value('PASSWORD_REUSE_TIME', attr_), Client_SYS.Get_Item_Value('PASSWORD_REUSE_MAX', attr_));
   WHEN function_not_exist THEN
      Error_SYS.Record_General(lu_name_, 'FUNCTION_NOT_EXIST_A: The function :P1 does not exist!', Client_SYS.Get_Item_Value('PASSWORD_VERIFY_FUNCTION', attr_));
   WHEN invalid_limit THEN
      IF profile_ = 'DEFAULT' THEN
         Error_SYS.Record_General(lu_name_, 'DEFAULT_INVALID_A: The default profile can not have invalid resource limit or limit DEFAULT!');
      ELSE
         Error_SYS.Record_General(lu_name_, 'INVALID_LIMIT_A: Invalid resource limit!');
      END IF;
END Create_Profile__;


PROCEDURE Drop_Profile__ (
   profile_ IN VARCHAR2,
   cascade_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   profile_not_found EXCEPTION;
   PRAGMA            EXCEPTION_INIT(profile_not_found, -02380);
   default_profile   EXCEPTION;
   PRAGMA            EXCEPTION_INIT(default_profile, -02381);
   users_assigned    EXCEPTION;
   PRAGMA            EXCEPTION_INIT(users_assigned, -02382);
BEGIN
   IF (cascade_ = 'TRUE') THEN
      Assert_SYS.Assert_Is_Profile(profile_);
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE 'DROP PROFILE "'||profile_||'" CASCADE';
   ELSE
      Assert_SYS.Assert_Is_Profile(profile_);
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE 'DROP PROFILE "'||profile_||'"';
   END IF;
EXCEPTION
   WHEN profile_not_found THEN
      Error_SYS.Record_General(lu_name_, 'PROFILE_NOT_FOUND: The profile :P1 does not exist!', profile_);
   WHEN default_profile THEN
      Error_SYS.Record_General(lu_name_, 'DEFAULT_PROFILE: This is the default profile and it can not be dropped!');
   WHEN users_assigned THEN
      Error_SYS.Record_General(lu_name_, 'USERS_ASSIGNED: There are users assigned to :P1 so this profile can not be dropped!', profile_);
END Drop_Profile__;


PROCEDURE Alter_Profile__ (
   attr_ IN VARCHAR2 )
IS
   ptr_               NUMBER;
   name_              VARCHAR2(30);
   value_             VARCHAR2(200);
   ddl_string_        VARCHAR2(2000);
   length_            NUMBER;

   profile_           VARCHAR2(30);
   conflicting_values EXCEPTION;
   PRAGMA             EXCEPTION_INIT(conflicting_values, -28006);
   function_not_exist EXCEPTION;
   PRAGMA             EXCEPTION_INIT(function_not_exist, -07443);
   invalid_limit      EXCEPTION;
   PRAGMA             EXCEPTION_INIT(invalid_limit, -02377);
BEGIN
   -- Retrieve parameters from the attribute string and build the ddl string
   profile_ := Client_SYS.Get_Item_Value('PROFILE', attr_);
   Assert_SYS.Assert_Is_profile(profile_);
   ddl_string_  := 'ALTER PROFILE "' || profile_ || '" LIMIT ';
   length_ := length(ddl_string_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
	value_ := nvl(Oracle_Profile_Limits_API.Encode(value_),value_);
      IF (name_ = 'FAILED_LOGIN_ATTEMPTS') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_LIFE_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_REUSE_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_REUSE_MAX') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_LOCK_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_GRACE_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PASSWORD_VERIFY_FUNCTION') THEN
         -- Translation needed because of strange Oracle syntax
         IF value_ = 'UNLIMITED' THEN
            value_ := 'NULL';
         END IF;
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'COMPOSITE_LIMIT') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'SESSIONS_PER_USER') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'CPU_PER_SESSION') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'CPU_PER_CALL') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'LOGICAL_READS_PER_SESSION') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'LOGICAL_READS_PER_CALL') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'IDLE_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'CONNECT_TIME') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PRIVATE_SGA') THEN
         ddl_string_ := ddl_string_ || ' ' || name_ || ' ' || value_;
      ELSIF (name_ = 'PROFILE') THEN
         NULL;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   Trace_SYS.Field('DDL string', ddl_string_);
   IF length_ = length(ddl_string_) THEN
      -- No limits has been added to the ddl string
      Error_SYS.Record_General(lu_name_, 'NO_PROFILE_LIMITS_A: Can not modify the profile :P1 since no limits has been specified!', profile_);
   ELSE
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE ddl_string_;
   END IF;
EXCEPTION
   WHEN conflicting_values THEN
      Error_SYS.Record_General(lu_name_, 'CONFLICTING_VALUES_A: Conflicting values for parameters PASSWORD_REUSE_TIME = :P1 and PASSWORD_REUSE_MAX = :P2!', Client_SYS.Get_Item_Value('PASSWORD_REUSE_TIME', attr_), Client_SYS.Get_Item_Value('PASSWORD_REUSE_MAX', attr_));
   WHEN function_not_exist THEN
      Error_SYS.Record_General(lu_name_, 'FUNCTION_NOT_EXIST_A: The function :P1 does not exist!', Client_SYS.Get_Item_Value('PASSWORD_VERIFY_FUNCTION', attr_));
      WHEN invalid_limit THEN
         IF profile_ = 'DEFAULT' THEN
            Error_SYS.Record_General(lu_name_, 'DEFAULT_INVALID_A: The default profile can not have invalid resource limit or limit DEFAULT!');
         ELSE
            Error_SYS.Record_General(lu_name_, 'INVALID_LIMIT_A: Invalid resource limit!');
         END IF;
END Alter_Profile__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Limit_Db (
   profile_       IN VARCHAR2,
   resource_name_ IN VARCHAR2,
   resource_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ sys.dba_profiles.limit%TYPE;
   CURSOR get_attr IS
      SELECT limit
      FROM sys.dba_profiles
      WHERE profile = profile_
      AND   resource_name = resource_name_
      AND   resource_type = resource_type_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Limit_Db;


@UncheckedAccess
FUNCTION Get_Limit (
   profile_       IN VARCHAR2,
   resource_name_ IN VARCHAR2,
   resource_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ sys.dba_profiles.limit%TYPE;
BEGIN
   temp_ := Get_Limit_Db(profile_,resource_name_,resource_type_);
   RETURN nvl(Oracle_Profile_Limits_API.Decode(temp_),temp_);
END Get_Limit;



