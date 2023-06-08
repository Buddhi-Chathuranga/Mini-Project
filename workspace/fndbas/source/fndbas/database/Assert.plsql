-----------------------------------------------------------------------------
--
--  Logical unit: Assert
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050208  PEMA  Created
--  050225  PEMA  Added Assert_Is_Logical_Unit.
--  050309  JORA  Added Assert_Is_Number.
--  050304  JORA  Added Assert_Is_Tablespace, Assert_Is_Profile.
--  050309  JORA  Added Assert_Is_Number.
--  050309  JORA  Added Assert_Is_Vaild_Identifier and Assert_Is_Number
--  050314  JORA  Added Assert_Is_Vaild_Constraint, Assert_Is_Vaild_Tablespace
--                and Assert_Is_Profile
--  050315  JORA  Added Assert_Is_DB_Link
--  050323  JORA  Changed implementation of assert_is_index to use user_indexes.
--  050323  JORA  Changed default value of
--                check_suffix_ to FALSE in Assert_Is_Table.
--  050323  JORA  Rewrite of assert_is_alphanumeric, assert_is_number
--                assert_is_valid_password and assert_is_valid_identifier.
--  050404  JORA  Made Assert_Is_User_Object public and added an overloaded method.
--  050405  JORA  Improved error messages.
--  050408  JORA  Added Assert_Is_Procedure and Assert_Is_Function.
--  050408  JORA  Re-write exception handling.
--  050411  JORA  Correction of Assert_Is_Procedure.
--  050420  JORA  Correction of Assert_Is_Function.
--  050426  JORA  Added Assert_Is_View_Column and Assert_Is_Table_Column.
--  050503  JORA  Added Assert_Is_IAL_View.
--  050525  JORA  Correction of performace problem with Assert_Is_Package_Method.
--  050527  HAAR  Assert_Is_Db_Link uses All_Db_Links (Bug#51491).
--  050613  ASWILK Assert_Is_Logical_Unit contains an unwanted upper case convertion. (Bug#51337)
--  050810  ASWILK Allowed passwords to start with a number and contain spaces. Max PW length restricted to 30 (Bug#52531).
--  050818  JORA  Assert_Is_Package_Method made case-insenstive check of LU.
--  060515  HENJSE Assert_Match_Regexp added on request from PEMASE
--  060515  HAAR  Added function Encode_Single_Quote_String (F1PR447).
--  060726  NiWi  Added Assert_Is_Sysdate_Expression(Bug#58975).
--  060927  RaRuLk Added Assert_Is_Valid_New_User(Bug#60819).
--  070125  pemase Removed unnecessary exec imm generating warnings (Bug #63155)
--  070205  PEMASE Added Assert_Is_Exec_Plan (F1PR447 Bug#63158).
--  071105  UtGuLK Modified Assert_Is_Number to allow (-)ve numbers(Bug#67867).
--  080505  DUWILK Modified Assert_Is_Number to allow decimal numbers(Bug#70978).
--  080923  HASPLK  Added Assert_Is_Java_Class (Bug#76585).
--  090810  NABALK Certified the assert safe for dynamic SQLs in Is_Datefunc___ (Bug#84218)
--  130911  MADDLK Error_SYS calls re-wrote using Positional Notation.(Bug#112305
--  131129  HAARSE Assert_Is_Db_Object added using Dbms_Assert
--  140524  CHMULK TEBASE-203/Bug#112863 A new method in Assert_SYS to check the opposite of Assert_Match_Regexp
--  141128  CHMULK Using USER_PROCEDURES for method exist checks. (Bug#119168/TEBASE-768)
--  191204  RAKUSE Minor performance enhancement in Assert_Is_Package_Method. (EADS-8847)
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE cache_type                     IS TABLE OF VARCHAR2(128) INDEX BY VARCHAR2(1000);
TYPE cache_category_type            IS TABLE OF cache_type INDEX BY VARCHAR2(1000);
TYPE micro_cache_time_type          IS TABLE OF NUMBER INDEX BY VARCHAR2(1000);
TYPE micro_cache_max_id_type        IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(1000);
micro_cache_tab_                    cache_category_type;
micro_cache_time_                   micro_cache_time_type;
micro_cache_max_id_                 micro_cache_max_id_type ;
max_cached_element_count_           CONSTANT NUMBER := 100;
max_cached_element_life_            CONSTANT NUMBER := 100;
micro_cache_user_                   VARCHAR2(128) := Fnd_Session_API.Get_Fnd_User;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


FUNCTION Get_Cache_Value___ (
   cache_category_ IN VARCHAR2,
   object_id_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   time_       NUMBER := Database_SYS.Get_Time_Offset;
   expired_    BOOLEAN;
   
   FUNCTION Get_Micro_Cache_Time___ (
      cache_category_ IN VARCHAR2,
      time_           IN NUMBER ) RETURN NUMBER 
   IS
      cache_time_ NUMBER;
   BEGIN
      BEGIN 
         cache_time_ := micro_cache_time_(cache_category_);
      EXCEPTION
         WHEN no_data_found THEN
            cache_time_ := time_;
      END;
      RETURN(cache_time_);
   END Get_Micro_Cache_Time___;
   
BEGIN
   expired_ := (time_ - Get_Micro_Cache_Time___(cache_category_, time_) > max_cached_element_life_);
   IF (expired_ OR (micro_cache_user_ IS NULL) OR (micro_cache_user_ != Fnd_Session_API.Get_Fnd_User)) THEN
      micro_cache_tab_(cache_category_).delete;
      micro_cache_max_id_(cache_category_) := 0;
      micro_cache_time_(cache_category_)  := 0;
      micro_cache_user_ := Fnd_Session_API.Get_Fnd_User;
   END IF;
   RETURN(micro_cache_tab_(cache_category_)(object_id_));
EXCEPTION
   WHEN value_error THEN
      RETURN(NULL);
   WHEN no_data_found THEN
      RETURN(NULL);
END Get_Cache_Value___;

PROCEDURE Set_Cache_Value___ (
   cache_category_ IN VARCHAR2,
   object_id_    IN VARCHAR2, 
   object_value_ IN VARCHAR2 )
IS
   time_       NUMBER := Database_SYS.Get_Time_Offset;
   random_  NUMBER := NULL;

   FUNCTION Get_Micro_Cache_Max_Id___ (
      cache_category_ IN VARCHAR2 ) RETURN PLS_INTEGER 
   IS
      max_id_ PLS_INTEGER;
   BEGIN
      BEGIN 
         max_id_ := micro_cache_max_id_(cache_category_);
      EXCEPTION
         WHEN no_data_found THEN
            max_id_ := 1;
      END;
      RETURN(max_id_);
   END Get_Micro_Cache_Max_Id___;

BEGIN
   micro_cache_tab_(cache_category_)(object_id_) := object_value_;
   micro_cache_time_(cache_category_) := time_;
   IF (micro_cache_tab_(cache_category_).count >= max_cached_element_count_) THEN
      random_ := round(dbms_random.value(1, max_cached_element_count_), 0);
      micro_cache_tab_(cache_category_).delete(random_);
   ELSE
      micro_cache_max_id_(cache_category_) := Get_Micro_Cache_Max_Id___(cache_category_) + 1;
   END IF;
EXCEPTION
   WHEN value_error THEN
      NULL;
END Set_Cache_Value___;




-- Assert_Helper_Log___
--   Wraps Assert_Helper_Log_Imp___ which implements logging of exceptions
--   1) is disabled/enabled by configuration/constant
--   2) catches any exception
PROCEDURE Assert_Helper_Log___ (
   assert_check_ IN VARCHAR2,
   assert_param_ IN VARCHAR2,
   call_stack_   IN VARCHAR2 )
IS
   security_assert_do_log_       CONSTANT BOOLEAN       := TRUE;
BEGIN
   IF security_assert_do_log_ THEN
      Assert_Helper_Log_Imp___( assert_check_, assert_param_, call_stack_ );
   END IF;
EXCEPTION
   -- Fault in log routine should not cause problems for Security Asserts
   WHEN OTHERS THEN
      NULL;
END Assert_Helper_Log___;


-- Assert_Helper_Log_Imp___
--   Implements logging of exceptions
PROCEDURE Assert_Helper_Log_Imp___ (
   assert_check_ IN VARCHAR2,
   assert_param_ IN VARCHAR2,
   call_stack_   IN VARCHAR2 )
IS
   security_assert_log_category_ CONSTANT VARCHAR2(100) := 'SQL Injections';
   
   line_curr_   VARCHAR2(2000);
   line_left_   VARCHAR2(2000);
   line_right_  VARCHAR2(2000);
   discard_     VARCHAR2(2000);
   line_nan_    VARCHAR2(2000); -- line# and object name
   line_no_     VARCHAR2(2000);
   name_        VARCHAR2(2000);
   report_str_  VARCHAR2(2000) := NULL;
   strlen_      NUMBER ;
   i_           NUMBER := 0;
   log_value_   NUMBER;
BEGIN
   line_curr_ := TRIM(call_stack_) ;
   WHILE NOT line_curr_ IS NULL LOOP
      strlen_ := length( line_curr_ );
      i_ := i_ + 1;
      --
      -- Get first line into left side, the rest into right side
      --
      Assert_Helper_Split___(line_left_, line_right_, line_curr_, chr(10));
      line_curr_ := trim(line_right_);
      --
      -- Process lines 3 and beyond (contains information)
      --
      IF i_ > 3 THEN
         --
         -- Lightweigh parsing of call stack, obtains
         -- package name and package body line number from output
         --
         Assert_Helper_Split___(discard_, line_nan_, line_left_, ' ');
         line_nan_ := trim( line_nan_ );
         Assert_Helper_Split___(line_no_, name_, line_nan_, ' ');
         name_ := trim( name_ );
         --
         -- package body is most common, remove to make log shorter
         --
         IF substr(name_,1,13) = 'package body ' THEN
            name_ := substr(name_, 14);
         END IF;
         --
         -- Build report line string
         --
         IF i_ > 4 THEN
            report_str_ := report_str_ || ', ';
         END IF;
         report_str_ := report_str_ || name_||':'||line_no_;
      END IF;
   END LOOP;
   log_value_ := Server_Log_API.Log_Autonomous( NULL, security_assert_log_category_, assert_check_ || ' ' || report_str_, assert_param_ );
END Assert_Helper_Log_Imp___;


-- Assert_Helper_Split___
--   Implements a simple split functions
PROCEDURE Assert_Helper_Split___ (
   left_      OUT VARCHAR2,
   right_     OUT VARCHAR2,
   input_      IN VARCHAR2,
   separator_  IN VARCHAR2 )
IS
   index_ INTEGER;
BEGIN
   index_ := instr( input_, separator_ );
   left_  := substr( input_, 1, index_ - 1 );
   right_ := substr( input_, index_ + 1 );
END Assert_Helper_Split___ ;


PROCEDURE Splitter___ (
   before_   OUT   VARCHAR2,
   string_   IN OUT VARCHAR2,
   key_word_ IN  VARCHAR2 
) 
IS
   pos_ NUMBER;
BEGIN
   pos_ := instr(string_, key_word_);

   IF string_ IS NOT NULL AND pos_ >0 THEN
      before_ := ltrim(rtrim(substr(string_, 1, pos_ - 1)));
      string_ := ltrim(rtrim(substr(string_, pos_ + length(key_word_))));
      
      IF length(string_) = 0 THEN
         string_ := null;
      END IF;
   ELSE
      before_ := string_;
      string_ := null;
   END IF;
   
END Splitter___;


FUNCTION Is_Datefunc___( 
   pkg_func_ IN VARCHAR2 ) RETURN BOOLEAN
IS

   p_  VARCHAR2(92) := null;
   p1_ VARCHAR2(92) := null;
   p2_ VARCHAR2(92) := null;
   p3_ VARCHAR2(92) := null;
   

   TYPE get_datefunc_refcursor_ IS REF CURSOR;
   get_datefunc_ get_datefunc_refcursor_ ;
    
   get_datefunc_stmt_ VARCHAR2(200) :=
      'SELECT * FROM user_arguments u ' ||
      'WHERE                          ' ||
      '  u.package_name = :pkg AND    ' ||
      '  u.object_name = :func AND    ' ||
      '  u.argument_name IS NULL      ' ||
      '  ORDER BY overload, position  ' ;

   get_datefunc_stmt_null_ VARCHAR2(200) :=
      'SELECT * FROM user_arguments u ' ||
      'WHERE                          ' ||
      '  u.package_name IS NULL AND   ' ||
      '  u.object_name = :func AND    ' ||
      '  u.argument_name IS NULL      ' ||
      '  ORDER BY overload, position  ' ;
      
      
   pos0ok_      BOOLEAN := FALSE; -- return type is correct
   noextraargs_ BOOLEAN := FALSE; -- function has no arguments
   
   rec_   user_arguments%ROWTYPE;
   ovl_   NUMBER;         -- the current overloaded version of the function
   ovl_p_ NUMBER := -2;   -- the previous overloaded version of the function
BEGIN

   p_ := upper( pkg_func_ );
   
   Splitter___(p1_, p_, '.') ;
   Splitter___(p2_, p_, '.') ;
   Splitter___(p3_, p_, '.') ;
   
   IF p_ IS NOT NULL THEN
      -- illegal form: schema.pkg.func.SOMETHING
      RETURN FALSE;
   END IF;
   
   IF p1_ = Fnd_Session_Api.Get_App_Owner OR 
      p1_ = CHR(38)||'AO' OR p1_ = CHR(38)||'APPOWNER'
   THEN
     p1_ := p2_ ;
     p2_ := p3_ ;
     p3_ := null;
   END IF;

   IF p3_ IS NOT NULL THEN
     -- illegal form, neither of
     --    IFSAPP.PKG.FUNC, IFSAPP.FUNC, PKG.FUNC, FUNC
     RETURN FALSE;
   END IF;
   
   IF p2_ IS NOT NULL THEN
      @ApproveDynamicStatement(2009-08-10,nabalk)
      OPEN get_datefunc_ FOR get_datefunc_stmt_ USING IN p1_, p2_;    
   ELSE
      @ApproveDynamicStatement(2009-08-10,nabalk)
      OPEN get_datefunc_ FOR get_datefunc_stmt_null_ USING IN p1_; 
   END IF;
   
   BEGIN
   LOOP
      FETCH get_datefunc_ INTO rec_ ;
      EXIT WHEN get_datefunc_%NOTFOUND ;

      ovl_ := NVL(rec_.overload,-1);
     
      IF ovl_p_ != ovl_ THEN -- new overload 
         EXIT WHEN pos0ok_ AND noextraargs_ ; -- previous overload was OK!
         pos0ok_      := FALSE;
         noextraargs_ := TRUE;
      END IF;       
       
      IF rec_.position > 0 THEN
         noextraargs_ := FALSE; -- BAD! Too many arguments!
      END IF;

      IF rec_.position = 0 AND rec_.IN_OUT = 'OUT' AND rec_.data_type = 'DATE' THEN
         pos0ok_ := TRUE; -- return type is OK!
      END IF;
  
   END LOOP;
   EXCEPTION
     WHEN OTHERS THEN NULL;
   END;
   
   IF get_datefunc_%ISOPEN THEN
     CLOSE get_datefunc_;
   END IF;
   
   -- SUCCESS (return true) if and only if
   --   => return type is ok
   --   => no extra arguments
   -- otherwise FAILURE (return false)
   
   RETURN pos0ok_ AND noextraargs_ ;
   
END Is_Datefunc___;  


FUNCTION Is_Equal___ (
   string1_    IN VARCHAR2,
   string2_    IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN ((string1_ IS NULL AND string2_ IS NULL)
        OR (string1_ IS NOT NULL AND string2_ IS NOT NULL AND (string1_ = string2_)));
END Is_Equal___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Assert_Is_Alphanumeric (
   alphanumeric_ IN VARCHAR2 )
IS
   status_   VARCHAR2(10) := NULL;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Alphanumeric', TRUE);
   IF alphanumeric_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   SELECT 'APPROVED' INTO status_ FROM dual WHERE regexp_like(alphanumeric_,'[[:alnum:]]{'||length(alphanumeric_)||',}','i');
   IF  status_ != 'APPROVED' THEN
      RAISE no_data_found;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Alphanumeric', alphanumeric_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_ALPHANUMERIC: ":P1" is not a valid alphanumeric string.', alphanumeric_ );
END Assert_Is_Alphanumeric;


PROCEDURE Assert_Is_Number (
   numeric_ IN VARCHAR2 )
IS
   status_   VARCHAR2(10) := NULL;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Number', TRUE);
   IF numeric_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   IF instr(numeric_, ' ') > 0 THEN
      RAISE no_data_found;
   END IF;
   SELECT 'APPROVED' INTO status_ FROM dual WHERE regexp_like(numeric_,'[([:digit:].,)]{'||decode(substr((numeric_),1,1),'-',nvl(length(numeric_)-1,0),length(numeric_))||',}','i');
   IF  status_ != 'APPROVED' THEN
      RAISE no_data_found;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Number', numeric_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_NUMBER: ":P1" is not a valid number.', numeric_ );
END Assert_Is_Number;


PROCEDURE Assert_Is_In_Whitelist (
   input_ IN VARCHAR2,
   whitelist_ IN VARCHAR2,
   whitelist_sep_ IN VARCHAR2 DEFAULT ',' )
IS
   list_  VARCHAR2(150) := whitelist_;
   word_  VARCHAR2(75);
   index_ INTEGER;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_In_Whitelist', TRUE);
   IF (input_ IS NULL) OR (whitelist_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   index_ := instr(list_, whitelist_sep_);
   -- while not last word in whitelist
   WHILE index_ > 0 LOOP
      word_ := substr( list_, 1, index_ - 1);
      list_ := substr( list_, index_ + 1);
      IF input_ = word_ THEN
         RETURN; -- return if word in whitelist
      END IF;
      index_ := instr( list_, whitelist_sep_ );
   END LOOP;
   -- process last (or only) word
   word_ := list_;
   IF input_ = word_ THEN
      RETURN; -- return if word in whitelist
   END IF;
   RAISE no_data_found;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_In_Whitelist', input_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IN_WHITELIST: ":P1" is not an allowed value.', input_);
END Assert_Is_In_Whitelist;


PROCEDURE Assert_Is_User_Object (
   object_name_ IN VARCHAR2 )
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'USER_OBJECT';
   test_             NUMBER := 0;
   CURSOR c1 IS
      SELECT 1 FROM user_objects
      WHERE object_name = upper( object_name_ );
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_User_Object', TRUE);
   IF (object_name_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   IF (Get_Cache_Value___(cache_category_, upper(object_name_)) IS NULL) THEN 
      OPEN c1;
      FETCH c1 INTO test_;
      IF c1%NOTFOUND THEN
         CLOSE c1;
         RAISE no_data_found;
      ELSE
         Set_Cache_Value___(cache_category_, upper(object_name_), upper(object_name_));
         CLOSE c1;
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_User_Object', object_name_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_USER_OBJECT: ":P1" is non existing user object.', object_name_ );
END Assert_Is_User_Object;


PROCEDURE Assert_Is_User_Object (
   object_name_ IN VARCHAR2,
   object_type_ IN VARCHAR2 )
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'USER_OBJECT_TYPE';
   test_ NUMBER := 0;
   CURSOR c1 IS
      SELECT 1 FROM user_objects
      WHERE object_name = upper( object_name_ )
       AND  object_type = upper( object_type_ );
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_User_Object', TRUE);
   IF (object_name_ IS NULL OR object_type_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   IF (Get_Cache_Value___(cache_category_, upper(object_name_)||' '||upper(object_type_)) IS NULL) THEN 
      OPEN c1;
      FETCH c1 INTO test_;
      IF c1%NOTFOUND THEN
         CLOSE c1;
         RAISE no_data_found;
      ELSE
         Set_Cache_Value___(cache_category_, upper(object_name_)||' '||upper(object_type_), upper(object_name_)||' '||upper(object_type_));
         CLOSE c1;
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_User_Object', object_type_||' '||object_name_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(lu_name_ => service_, err_text_ => 'IS_USER_OBJECT_TYPE: ":P1" is non existing user object of type :P2.', p1_ => object_name_ );
END Assert_Is_User_Object;


PROCEDURE Assert_Is_Index (
   index_ IN VARCHAR2 )
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'INDEX';
   test_             NUMBER := 0;
   
   CURSOR c1 IS
      SELECT 1 FROM user_indexes
      WHERE index_name = upper(index_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Index', TRUE);
   IF index_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   IF (Get_Cache_Value___(cache_category_, upper(index_)) IS NULL) THEN 
      OPEN c1;
      FETCH c1 INTO test_;
      IF c1%NOTFOUND THEN
         CLOSE c1;
         RAISE no_data_found;
      ELSE
         Set_Cache_Value___(cache_category_, upper(index_), upper(index_));
         CLOSE c1;
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Index', index_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_INDEX: ":P1" is non existing index.', index_ );
END Assert_Is_Index;


-- Assert_Is_Package
PROCEDURE Assert_Is_Package (
   package_ IN VARCHAR2 )
IS
   result_ VARCHAR2(30);
   no_object EXCEPTION;
   PRAGMA exception_init(no_object,-44002);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Package', TRUE);
   result_ := Dbms_Assert.Sql_Object_Name(package_);
EXCEPTION
   WHEN no_object THEN
      -- Extra check since we have seen problem where Dbms_Assert.Sql_Object_Name gives error even though the package exists
      IF NOT Installation_SYS.Package_Exist(package_) THEN
         Assert_Helper_Log___( 'Assert_Is_Package', package_, dbms_utility.format_call_stack() );
         Error_SYS.Appl_General(service_, 'IS_PACKAGE: ":P1" is non existing package.', package_ );
      END IF;
END Assert_Is_Package;


PROCEDURE Assert_Is_Java_Class (
   class_name_ IN VARCHAR2 )
IS
   test_ NUMBER := 0;
   CURSOR c1 IS
      SELECT 1 FROM user_objects
      WHERE object_name = class_name_
      AND object_type = 'JAVA CLASS';
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Java_Class', TRUE);
   IF class_name_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN c1;
   FETCH c1 INTO test_;
   IF c1%NOTFOUND THEN
      CLOSE c1;
      RAISE no_data_found;
   ELSE
      CLOSE c1;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Java_Class', class_name_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_JAVA_CLASS: ":P1" is non existing java class.', class_name_ );
END Assert_Is_Java_Class;


--   Assert_Is_Package_Method ( package_, method_ )
PROCEDURE Assert_Is_Package_Method (
   package_ IN VARCHAR2,
   method_  IN VARCHAR2 )
IS
   test_ NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Package_Method', TRUE);
   IF (package_ IS NULL) OR (method_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   
   SELECT 1
   INTO test_
   FROM user_procedures
   WHERE  object_name    = upper(package_)
      AND procedure_name = upper(method_)
      AND rownum = 1;   
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Package_Method P2', package_||'.'||method_,
                            dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_,
                             'IS_PKG_METHOD: ":P1.:P2" is non existing package method.',
                             package_,
                             method_ );
END Assert_Is_Package_Method;


--   Assert_Is_Package_Method ( package_method_ )
PROCEDURE Assert_Is_Package_Method (
   package_method_ IN VARCHAR2 )
IS
   package_ user_procedures.object_name%TYPE;
   method_ user_procedures.procedure_name%TYPE;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Package_Method', TRUE);
   IF package_method_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   Assert_Helper_Split___(package_, method_, package_method_, '.');
   Assert_Is_Package_Method( package_, method_ );
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Package_Method P1', package_method_,
                            dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_,
                             'IS_PKG_METHOD2: ":P1" is non existing package method.',
                             package_method_ );
END Assert_Is_Package_Method;


PROCEDURE Assert_Is_Package_Method_Args (
   package_method_ IN VARCHAR2 )
IS
   package_ user_arguments.package_name%TYPE;
   method_ user_arguments.object_name%TYPE;
   no_args_       user_arguments.position%TYPE;
   args_          VARCHAR2(2000);
   pkg_method_    VARCHAR2(2000);
   CURSOR c1 IS
      SELECT max(position)
      FROM   user_arguments u, user_objects ub
      WHERE package_name = upper(package_)
         AND u.object_name = upper(method_)
         AND u.object_id = ub.object_id
         AND ub.object_name = upper(package_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Package_Method_Args', TRUE);
   IF package_method_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   pkg_method_ := substr(package_method_,1,instr(package_method_,'(')-1);
   args_ := substr(package_method_,instr(package_method_,'('));
   Assert_Helper_Split___(package_, method_, pkg_method_, '.');
   IF (package_ IS NULL) OR (method_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   OPEN c1;
   FETCH c1 INTO no_args_;
   IF c1%NOTFOUND THEN
      CLOSE c1;
      RAISE no_data_found;
   ELSE
      CLOSE c1;
   END IF;
   -- Check no of arguments
   --IF instr(args_,',',1,no_args_+1) <> 0 THEN
   --   RAISE no_data_found;
   --END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Package_Method_Args P1', package_method_,
                            dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_,
                             'IS_PKG_METHOD2: ":P1" is non existing package method.',
                             pkg_method_ );
END Assert_Is_Package_Method_Args;


PROCEDURE Assert_Is_Procedure (
   proc_ IN VARCHAR2 )
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'PROCEDURE';
   test_             NUMBER := 0;
   
   CURSOR c1 IS
      SELECT 1
      FROM   user_procedures
      WHERE object_name = substr( upper(proc_), 1, instr( upper(proc_), '.' ) - 1 )
         AND procedure_name = substr( upper(proc_), instr( upper(proc_), '.' ) + 1 );
   
   CURSOR c2 IS
      SELECT 1
      FROM user_objects
      WHERE object_name = upper(proc_)
        AND object_type = 'PROCEDURE';
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Procedure', TRUE);
   IF proc_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   IF (Get_Cache_Value___(cache_category_, upper(proc_)) IS NULL) THEN 
      OPEN c1;
      FETCH c1 INTO test_;
      IF c1%NOTFOUND THEN
         CLOSE c1;
         OPEN c2;
         FETCH c2 INTO test_;
         IF c2%NOTFOUND THEN
            CLOSE c2;
            RAISE no_data_found;
         ELSE
            Set_Cache_Value___(cache_category_, upper(proc_), upper(proc_));
            CLOSE c2;
         END IF;
      ELSE
         Set_Cache_Value___(cache_category_, upper(proc_), upper(proc_));
         CLOSE c1;
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Procedure', proc_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_,
                             'IS_PROCEDURE: ":P1" is non existing procedure.', proc_);
END Assert_Is_Procedure;


PROCEDURE Assert_Is_Function (
   func_ IN VARCHAR2 )
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'FUNCTION';
   test_             NUMBER := 0;
   
   CURSOR c1 IS
      SELECT 1
      FROM   user_procedures
      WHERE object_name = substr( upper(func_), 1, instr( upper(func_), '.' ) - 1 )
         AND procedure_name = substr( upper(func_), instr( upper(func_), '.' ) + 1 )
      UNION
      SELECT 1
      FROM user_objects
      WHERE object_name = upper(func_)
        AND object_type = 'FUNCTION';
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Function', TRUE);
   IF func_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   IF (Get_Cache_Value___(cache_category_, upper(func_)) IS NULL) THEN 
      OPEN c1;
      FETCH c1 INTO test_;
      IF c1%NOTFOUND THEN
         CLOSE c1;
         RAISE no_data_found;
      ELSE
         Set_Cache_Value___(cache_category_, upper(func_), upper(func_));
         CLOSE c1;
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Function', func_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_,
                             'IS_FUNCTION: ":P1" is non existing function.', func_ );
END Assert_Is_Function;


PROCEDURE Assert_Is_Role (
   role_ IN VARCHAR2 )
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'ROLE';
   test_             NUMBER := 0;
   
   CURSOR c1 IS
      SELECT 1
      FROM fnd_role
      WHERE role = upper(role_) ;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Role', TRUE);
   IF role_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   IF (Get_Cache_Value___(cache_category_, upper(role_)) IS NULL) THEN 
      OPEN c1;
      FETCH c1 INTO test_;
      IF c1%NOTFOUND THEN
         CLOSE c1;
         RAISE no_data_found;
      ELSE
         Set_Cache_Value___(cache_category_, upper(role_), upper(role_));
         CLOSE c1;
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Role', role_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_ROLE: ":P1" is non existing role.', role_ );
END Assert_Is_Role;


PROCEDURE Assert_Is_Sequence (
   sequence_ IN VARCHAR2 )
IS
   test_ NUMBER := 0;
   CURSOR c1 IS
      SELECT 1 FROM user_sequences
      WHERE sequence_name = upper(sequence_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Sequence', TRUE);
   IF sequence_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN c1;
   FETCH c1 INTO test_;
   IF c1%NOTFOUND THEN
      CLOSE c1;
      RAISE no_data_found;
   ELSE
      CLOSE c1;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Sequence', sequence_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_SEQUENCE: ":P1" is non existing sequence.', sequence_ );
END Assert_Is_Sequence;


PROCEDURE Assert_Is_Table (
   table_        IN VARCHAR2,
   check_suffix_ IN BOOLEAN DEFAULT FALSE,
   suffix_       IN VARCHAR2 DEFAULT '_TAB' )
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'TABLE';
   test_             NUMBER := 0;
   
   CURSOR c1 IS
      SELECT 1 FROM user_tables
      WHERE table_name = upper(table_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Table', TRUE);
   IF table_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   IF (Get_Cache_Value___(cache_category_, upper(table_)) IS NULL) THEN 
      OPEN c1;
      FETCH c1 INTO test_;
      IF c1%NOTFOUND THEN
         CLOSE c1;
         RAISE no_data_found;
      ELSE
         Set_Cache_Value___(cache_category_, upper(table_), upper(table_));
         CLOSE c1;
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Table', table_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_TABLE: ":P1" is non existing table.', table_ );
END Assert_Is_Table;


PROCEDURE Assert_Is_Table_Column (
   table_    IN VARCHAR2,
   col_name_ IN VARCHAR2)
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'TABLE_COLUMN';
   test_             NUMBER := 0;
   
   CURSOR c1 IS
      SELECT 1
      FROM  user_tab_columns
      WHERE table_name = upper(table_)
       AND  column_name = upper(col_name_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Table_Column', TRUE);
   IF table_ IS NULL OR col_name_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   IF (Get_Cache_Value___(cache_category_, upper(table_)||'.'||upper(col_name_)) IS NULL) THEN 
      OPEN c1;
      FETCH c1 INTO test_;
      IF c1%NOTFOUND THEN
         CLOSE c1;
         RAISE no_data_found;
      ELSE
         Set_Cache_Value___(cache_category_, upper(table_)||'.'||upper(col_name_), upper(table_)||'.'||upper(col_name_));
         CLOSE c1;
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Table_Column', table_||'.'||col_name_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_VIEW_COL: ":P1" is non existing table column.', table_||'.'||col_name_ );
END Assert_Is_Table_Column;


PROCEDURE Assert_Is_Grantee (
   grantee_ IN VARCHAR2 )
IS
   test_ NUMBER := 0;

   CURSOR c1 IS
      SELECT 1 FROM fnd_user
      WHERE identity = upper(grantee_)
      UNION
      SELECT 1
      FROM fnd_role
      WHERE role = upper(grantee_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Grantee', TRUE);
   IF grantee_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN c1;
   FETCH c1 INTO test_;
   IF c1%NOTFOUND THEN
      CLOSE c1;
      RAISE no_data_found;
   ELSE
      CLOSE c1;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Grantee', grantee_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_GRANTEE: ":P1" is non existing grantee.', grantee_ );
END Assert_Is_Grantee;


-- Assert_Is_User
--   Simple word/text asserts
PROCEDURE Assert_Is_User (
   user_ IN VARCHAR2 )
IS
   test_ NUMBER := 0;
   CURSOR c1 IS
      SELECT 1 FROM fnd_user
      WHERE identity = upper(user_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_User', TRUE);
   IF user_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN c1;
   FETCH c1 INTO test_;
   IF c1%NOTFOUND THEN
      CLOSE c1;
      RAISE no_data_found;
   ELSE
      CLOSE c1;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_User', user_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_USER: ":P1" is non existing user.', user_ );
END Assert_Is_User;


-- Assert_Is_View
--   Special cases and examples:
--   Assert_Is_In_WhiteList( word_, whitelist_ )
--   Throws an exception if word_ is not in whitelist_, otherwise does nothing.
--   whitelist_ should be a hard coded string, or originate from a source
--   end users cannot control.
--   Example: Assert_Is_In_WhiteList(word_,'Cat,Cow,Crocodile')
--   if word_ is Cat, Cow or Crocodile, nothing happens.
--   if word_ is e.g. Zebra, a security exception occurs
--   Assert_Is_Table( table_, check_suffix_, suffix_ )
--   Thows an exception if:
--   * table_ does not exist,
--   * check_suffix_ (default TRUE) is TRUE and
--   table_ does not end with suffix_ (default '_TAB')
--   otherwise does nothing.
PROCEDURE Assert_Is_View (
   view_ IN VARCHAR2 )
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'VIEW';
   test_             NUMBER := 0;
   
   CURSOR c1 IS
      SELECT 1 FROM user_views
      WHERE view_name = upper(view_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_View', TRUE);
   IF view_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   IF (Get_Cache_Value___(cache_category_, upper(view_)) IS NULL) THEN 
      OPEN c1;
      FETCH c1 INTO test_;
      IF c1%NOTFOUND THEN
         CLOSE c1;
         RAISE no_data_found;
      ELSE
         Set_Cache_Value___(cache_category_, upper(view_), upper(view_));
         CLOSE c1;
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_View', view_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General( service_, 'IS_VIEW: ":P1" is non existing view.', view_ );
END Assert_Is_View;


PROCEDURE Assert_Is_IAL_View (
   view_ IN VARCHAR2 )
IS
   test_             NUMBER := 0;   
   ial_user_ VARCHAR2(30) := FND_SETTING_API.Get_Value('IAL_USER');
   ial_ VARCHAR2(30) := REPLACE(upper(view_), upper(ial_user_)||'.');
   CURSOR c1 IS
      SELECT 1
      FROM all_views
      WHERE view_name = upper(ial_)
        AND owner = upper(ial_user_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_IAL_View', TRUE);
   IF view_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN c1;
   FETCH c1 INTO test_;
   IF c1%NOTFOUND THEN
      CLOSE c1;
      RAISE no_data_found;
   ELSE
      CLOSE c1;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_View', view_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_VIEW: ":P1" is non existing view.', view_ );
END Assert_Is_IAL_View;


PROCEDURE Assert_Is_View_Column (
   view_ IN VARCHAR2,
   col_name_ IN VARCHAR2)
IS
   test_ NUMBER := 0;
   CURSOR c1 IS
      SELECT 1
      FROM user_tab_columns
      WHERE table_name = upper(view_)
       AND  column_name = upper(col_name_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_View_Column', TRUE);
   IF view_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN c1;
   FETCH c1 INTO test_;
   IF c1%NOTFOUND THEN
      CLOSE c1;
      RAISE no_data_found;
   ELSE
      CLOSE c1;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_View_Column', view_||'.'||col_name_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_VIEW_COL2: ":P1" is non existing view column.', view_||'.'||col_name_ );
END Assert_Is_View_Column;


PROCEDURE Assert_Is_Trigger (
   trigger_ IN VARCHAR2 )
IS
   test_ NUMBER := 0;
   CURSOR c1 IS
      SELECT 1 FROM user_triggers
      WHERE trigger_name = upper(trigger_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Trigger', TRUE);
   IF trigger_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN c1;
   FETCH c1 INTO test_;
   IF c1%NOTFOUND THEN
      CLOSE c1;
      RAISE no_data_found;
   ELSE
      CLOSE c1;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Trigger', trigger_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_TRIGGER: ":P1" is non existing trigger.', trigger_ );
END Assert_Is_Trigger;


PROCEDURE Assert_Is_Logical_Unit (
   lu_ IN VARCHAR2 )
IS
   test_ NUMBER := 0;
   CURSOR c1 IS
      SELECT 1
      FROM dictionary_sys_tab
      WHERE upper(lu_name) = upper(lu_);
   
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Logical_Unit', TRUE);
   IF lu_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN c1;
   FETCH c1 INTO test_;
   IF c1%NOTFOUND THEN
      CLOSE c1;
      IF Installation_SYS.Get_Installation_Mode THEN
         IF Dictionary_SYS.Get_Base_Package(lu_) IS NULL THEN 
            RAISE no_data_found;
         END IF;
      ELSE
         RAISE no_data_found;
      END IF;
   ELSE
      CLOSE c1;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Logical_Unit', lu_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_LOGICAL_UNIT: ":P1" is non existing logical unit.', lu_ );
END Assert_Is_Logical_Unit;


PROCEDURE Assert_Is_Valid_Password (
   password_ IN VARCHAR2 )
IS
   status_   VARCHAR2(10) := NULL;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Valid_Password', TRUE);
   IF password_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   IF length(password_) > 30 THEN
      RAISE no_data_found;
   END IF;
   IF regexp_like(password_,'["]') THEN
     RAISE no_data_found;
   END IF;
   SELECT 'APPROVED' INTO status_ FROM dual WHERE regexp_like(password_,'[[:alnum:]|[:punct:]|[:blank:]]{'||nvl(length(password_)-1,0)||',}','i');
   IF  status_ != 'APPROVED' THEN
      RAISE no_data_found;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Valid_Password', password_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_VALID_PASSWORD: Not a valid password.');
END Assert_Is_Valid_Password;


PROCEDURE Assert_Is_Valid_Identifier (
   identifier_ IN VARCHAR2 )
IS
   status_   VARCHAR2(10) := NULL;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Valid_Identifier', TRUE);
   IF identifier_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   SELECT 'APPROVED' INTO status_ FROM dual WHERE regexp_like(identifier_,'[a-zA-Z][[:alnum:]|[:punct:]]{'||nvl(length(identifier_)-1,0)||',}','i');
   IF  status_ != 'APPROVED' THEN
      RAISE no_data_found;
   END IF;

EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Valid_Identifier', identifier_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_VALID_IDENTIFIER: ":P1" is not a valid identifier.', identifier_ );
END Assert_Is_Valid_Identifier;


PROCEDURE Assert_Is_Tablespace(
   tblspc_name_  VARCHAR2)
IS
   test_ NUMBER := 0;
   CURSOR curIsTablespace_  IS
      SELECT 1
      FROM dba_tablespaces
      WHERE tablespace_name = upper(tblspc_name_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Tablespace', TRUE);
   IF tblspc_name_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN curIsTablespace_;
   FETCH curIsTablespace_ INTO test_;
   IF curIsTablespace_%NOTFOUND THEN
      CLOSE curIsTablespace_;
      RAISE no_data_found;
   ELSE
      CLOSE curIsTablespace_;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___('Assert_Is_Profile',tblspc_name_,dbms_utility.format_call_stack());
      Error_SYS.Appl_General(service_, 'IS_TABLESPACE: ":P1" is non existing tablespace.', tblspc_name_ );
END Assert_Is_Tablespace;


PROCEDURE Assert_Is_Constraint(
   constraint_ VARCHAR2)
IS
   test_ NUMBER := 0;
   CURSOR curIsConstraint_ IS
      SELECT 1
      FROM user_constraints
      WHERE constraint_name = upper(constraint_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Constraint', TRUE);
   IF constraint_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN curIsConstraint_;
   FETCH curIsConstraint_ INTO test_;
   IF curIsConstraint_%NOTFOUND THEN
      CLOSE curIsConstraint_;
      RAISE no_data_found;
   ELSE
      CLOSE curIsConstraint_;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___('Assert_Is_Constraint',constraint_,dbms_utility.format_call_stack());
      Error_SYS.Appl_General(service_, 'IS_CONSTRAINT: ":P1" is non existing constraint.', constraint_ );
END Assert_Is_Constraint;


PROCEDURE Assert_Is_Profile(
   profile_  VARCHAR2)
IS
   test_     dba_profiles.profile%TYPE;
   CURSOR curIsProfile_ IS
      SELECT DISTINCT profile
      FROM dba_profiles
      WHERE profile = upper(profile_);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Profile', TRUE);
   IF profile_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN curIsProfile_;
   FETCH curIsProfile_ INTO test_;
   IF curIsProfile_%NOTFOUND THEN
      CLOSE curIsProfile_;
      RAISE no_data_found;
   ELSE
      CLOSE curIsProfile_;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___('Assert_Is_Profile',profile_,dbms_utility.format_call_stack());
      Error_SYS.Appl_General(service_, 'IS_PROFILE: ":P1" is non existing profile.', profile_ );
END Assert_Is_Profile;


PROCEDURE Assert_Is_DB_Link(
   db_link_  VARCHAR2)
IS
   test_ NUMBER := 0;
   CURSOR curIsDBLink_ IS
      SELECT 1
      FROM All_Db_Links
      WHERE (db_link = upper(db_link_)
             OR
             Substr(db_link, 1, instr(db_link, '.')-1) = upper(db_link_));
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_DB_Link', TRUE);
   IF db_link_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   OPEN curIsDBLink_;
   FETCH curIsDBLink_ INTO test_;
   IF curIsDBLink_%NOTFOUND THEN
      CLOSE curIsDBLink_;
      RAISE no_data_found;
   ELSE
      CLOSE curIsDBLink_;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___('Assert_Is_DB_Link',db_link_,dbms_utility.format_call_stack());
      Error_SYS.Appl_General(service_, 'IS_DB_LINK: ":P1" is non existing database link.', db_link_ );
END Assert_Is_DB_Link;


PROCEDURE Assert_Match_Regexp(
   text_in_   VARCHAR2,
   pattern_   VARCHAR2)
IS
   no_match   EXCEPTION;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Match_Regexp', TRUE);
   IF NOT REGEXP_LIKE(text_in_, pattern_) THEN
      RAISE no_match;
   END IF;
   RETURN;
EXCEPTION
   WHEN no_match THEN
      Assert_Helper_Log___( 'Assert_Match_Regexp', text_in_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'MATCH_REGEXP: Input ":P1" did not match regular expression.', text_in_);
END Assert_Match_Regexp;


FUNCTION Encode_Single_Quote_String (
    value_               IN VARCHAR2,
    add_prefix_sufix_    IN BOOLEAN DEFAULT FALSE) RETURN VARCHAR2
IS
    low_ascii_remove_    CONSTANT BOOLEAN := TRUE;
    low_ascii_replace_   CONSTANT BOOLEAN := FALSE;
    low_ascii_threshold_ CONSTANT NUMBER  := 32;
    low_ascii_lf_is_ok_  CONSTANT BOOLEAN := TRUE;

    tmp_     VARCHAR2(32000);
    result_  VARCHAR2(32000) := '';
    char_    VARCHAR2(1);
    ascii_   NUMBER;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Encode_Single_Quote_String', TRUE);
   tmp_ := NVL( value_, '' );
   WHILE LENGTH(tmp_) > 0 LOOP
      char_ := SUBSTR( tmp_, 1, 1 );
      tmp_ := SUBSTR( tmp_, 2 );
      ascii_ := ASCII(char_);

      -- ' is encoded to '' in single qoute strings.
      IF (char_ = CHR(39)) THEN
         result_ := result_ || CHR(39) || CHR(39) ;

      -- line feed is OK
      ELSIF (char_ = CHR(10)) AND low_ascii_lf_is_ok_ THEN
         result_ := result_ || CHR(10) ;

      -- chr(0) etc are dangerous - remove them from string
      ELSIF ascii_ < low_ascii_threshold_ AND low_ascii_remove_ THEN
         NULL ;

      -- chr(0) etc are dangerous - replace them with a space
      ELSIF ascii_ < low_ascii_threshold_ AND low_ascii_replace_ THEN
         result_ := result_ || ' ';

      -- default: just append character
      ELSE
         result_ := result_ || char_ ;
      END IF;
   END LOOP; -- WHILE

   -- change str into 'str'
   IF add_prefix_sufix_ THEN
      result_ := CHR(39) || result_ || CHR(39) ;
   END IF;

   RETURN result_;
END Encode_Single_Quote_String;


PROCEDURE Assert_Is_Sysdate_Expression (
   sysdate_exp_  IN  VARCHAR2)
IS
   weekdays_  VARCHAR2(400) := ''''||Fnd_Week_Day_API.Decode('SUNDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('MONDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('TUESDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('WEDNESDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('THURSDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('FRIDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('SATURDAY')||'''';

   date_fmt_models_  VARCHAR2(400)  := '''SYYYY'''||'|'||'''YYYY'''||'|'||'''YEAR'''||'|'||'''SYEAR'''||'|'||'''YYY'''||'|'||'''YY'''||'|'||'''Y'''||'|'||'''IYYY'''||'|'||'''IY'''||'|'||'''I'''||'|'||
                                       '''Q'''||'|'||'''MONTH'''||'|'||'''MON'''||'|'||'''MM'''||'|'||'''RM'''||'|'||'''WW'''||'|'||'''IW'''||'|'||'''W'''||'|'||
                                       '''DDD'''||'|'||'''DD'''||'|'||'''J'''||'|'||'''DAY'''||'|'||'''DY'''||'|'||'''D'''||'|'||'''HH'''||'|'||'''HH12'''||'|'||'''HH24'''||'|'||'''MI''';

   sysdate_exp_pattern_ CONSTANT VARCHAR2(1000) := '^[ ]*[-]?[ ]*((([0-9]+(\.[0-9]+)?)|SYSDATE|NEXT_DAY|LAST_DAY|TRUNC|ROUND|ADD_MONTHS|'||weekdays_||'|'||date_fmt_models_||')[- +*,/\(\)'']*)+$';

   -- Examples of valid expressions
   -- =============================
   --   7 days forward: sysadte + 7
   --   next Monday: next_day(sysdate,'monday')
   --   First day of this quarter: TRUNC(sysdate, 'Q')
   --   Last day of this quarter: ADD_MONTHS(TRUNC(sysdate, 'Q'),3)-1

BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Sysdate_Expression', TRUE);
   IF NOT REGEXP_LIKE(sysdate_exp_, sysdate_exp_pattern_, 'i') THEN
      RAISE no_data_found;

--   the exec imm was there to check if input was useable, not if it
--   was secure to use; assert_sys is not designed for that purpose
--   and we really want assert_sys to be free of dynamic sql.
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      Assert_Helper_Log___('Assert_Is_Sysdate_Expression',sysdate_exp_,dbms_utility.format_call_stack());
      Error_SYS.Appl_General(service_, 'IS_SYSDATE_EXP: ":P1" is not a valid date expression.', sysdate_exp_ );
END Assert_Is_Sysdate_Expression;


PROCEDURE Assert_Is_Valid_New_User (
   identifier_ IN VARCHAR2 )
IS
   status_   VARCHAR2(10) := NULL;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Valid_New_User', TRUE);
   IF identifier_ IS NULL THEN
      RAISE no_data_found;
   END IF;
   SELECT 'APPROVED' INTO status_ FROM dual WHERE regexp_like(identifier_,'[a-zA-Z0-9][[:alnum:]|[:punct:]]{'||nvl(length(identifier_)-1,0)||',}','i');
   IF  status_ != 'APPROVED' THEN
      RAISE no_data_found;
   END IF;

EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Valid_New_User', identifier_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_VALID_IDENTIFIER: ":P1" is not a valid identifier.', identifier_ );
END Assert_Is_Valid_New_User;


PROCEDURE Assert_Is_Equal (
   string1_    IN VARCHAR2,
   string2_    IN VARCHAR2)
IS
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Equal', TRUE);
   IF(NOT Is_Equal___(string1_, string2_)) THEN
      Error_SYS.Appl_General(service_, 'IS_EQUAL: ":P1" is not equal to ":P2".', string1_, string2_ );      
   END IF;
END Assert_Is_Equal;


PROCEDURE Assert_Is_Not_Equal (
   string1_    IN VARCHAR2,
   string2_    IN VARCHAR2)
IS
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Not_Equal', TRUE);
   IF (Is_Equal___(string1_, string2_)) THEN
      Error_SYS.Appl_General(service_, 'IS_NOT_EQUAL: ":P1" is equal to ":P2".', string1_, string2_ );      
   END IF;
END Assert_Is_Not_Equal;


PROCEDURE Assert_Is_Not_Null (
   non_null_string_    IN VARCHAR2,
   identifier_         IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Not_Null', TRUE);
   IF (non_null_string_ IS NULL) THEN
      Error_SYS.Appl_General(service_, 'IS_NOT_NULL: An unexpected NULL string :P1 was encountered.', identifier_);
   END IF;
END Assert_Is_Not_Null;


PROCEDURE Assert_Is_Not_Null (
   non_null_clob_ IN CLOB,
   identifier_    IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Not_Null', TRUE);
   IF (non_null_clob_ IS NULL) THEN
      Error_SYS.Appl_General(service_, 'IS_NOT_NULL: An unexpected NULL string :P1 was encountered.', identifier_);
   END IF;
END Assert_Is_Not_Null;


PROCEDURE Assert_Is_Null (
   null_string_   IN VARCHAR2,
   identifier_    IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Null', TRUE);
   IF (NOT (null_string_ IS NULL)) THEN
      Error_SYS.Appl_General(service_, 'IS_NULL: An unexpected non-NULL string :P1 was encountered.', identifier_);
   END IF;
END Assert_Is_Null;


PROCEDURE Assert_Is_Null (
   null_clob_     IN CLOB,
   identifier_    IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Null', TRUE);
   IF (NOT (null_clob_ IS NULL)) THEN
      Error_SYS.Appl_General(service_, 'IS_NULL: An unexpected non-NULL string :P1 was encountered.', identifier_);
   END IF;
END Assert_Is_Null;


PROCEDURE Assert_Is_True (
   true_statement_   IN BOOLEAN,
   identifier_       IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_True', TRUE);
   IF(NOT (true_statement_)) THEN
      Error_SYS.Appl_General(service_, 'IS_TRUE: An unexpected FALSE statement :P1 was encountered.', identifier_);
   END IF;
END Assert_Is_True;


PROCEDURE Assert_Is_Exec_Plan (
   exec_plan_  IN  VARCHAR2)
IS
   weekdays_  VARCHAR2(400) := ''''||Fnd_Week_Day_API.Decode('SUNDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('MONDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('TUESDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('WEDNESDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('THURSDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('FRIDAY')||''''||'|'||
                               ''''||Fnd_Week_Day_API.Decode('SATURDAY')||'''';

   date_fmt_models_  VARCHAR2(400)  := '''SYYYY'''||'|'||'''YYYY'''||'|'||'''YEAR'''||'|'||'''SYEAR'''||'|'||'''YYY'''||'|'||'''YY'''||'|'||'''Y'''||'|'||'''IYYY'''||'|'||'''IY'''||'|'||'''I'''||'|'||
                                       '''Q'''||'|'||'''MONTH'''||'|'||'''MON'''||'|'||'''MM'''||'|'||'''RM'''||'|'||'''WW'''||'|'||'''IW'''||'|'||'''W'''||'|'||
                                       '''DDD'''||'|'||'''DD'''||'|'||'''J'''||'|'||'''DAY'''||'|'||'''DY'''||'|'||'''D'''||'|'||'''HH'''||'|'||'''HH12'''||'|'||'''HH24'''||'|'||'''MI''';


   -- Examples of valid sysdate expressions
   -- =====================================
   --   7 days forward: sysadte + 7
   --   next Monday: next_day(sysdate,'monday')
   --   First day of this quarter: TRUNC(sysdate, 'Q')
   --   Last day of this quarter: ADD_MONTHS(TRUNC(sysdate, 'Q'),3)-1

   --date_        DATE;
   --stmt_        VARCHAR2(2000);
   
   sysdate_exp_pattern_ CONSTANT VARCHAR2(1000) := '^[ ]*[-]?[ ]*((([0-9]+(\.[0-9]+)?)|SYSDATE|NEXT_DAY|LAST_DAY|TRUNC|ROUND|ADD_MONTHS|'||weekdays_||'|'||date_fmt_models_||')[- +*,/\(\)'']*)+$';
   
   time_                CONSTANT VARCHAR2(100) :=  '[0-9]{2}:[0-9]{2}';
   time_list_           CONSTANT VARCHAR2(100) :=  '('||time_||'(;'||time_||')*)';
   at_                  CONSTANT VARCHAR2(100) := '(AT[ _]+'||time_list_||')';
   date_                CONSTANT VARCHAR2(100) := '([0-9]+[-/:;.][0-9]+[-/:;.]+[0-9]+)';
   shortwdays_          CONSTANT VARCHAR2(100) := '(MON|TUE|WED|THU|FRI|SAT|SUN)';
   shortwdays_list_     CONSTANT VARCHAR2(100) := '(WEEKDAYS|('||shortwdays_||'(;'||shortwdays_||')*))';

   input_ VARCHAR2(4000);
   
   
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Exec_Plan', TRUE);
   IF exec_plan_ IS NULL THEN
      RETURN;
   END IF;

   input_ := upper(trim(exec_plan_));

   -- consume ASAP AND and NOW AND execution plan modifiers
   input_ := REGEXP_REPLACE(input_, '^(ASAP|NOW) AND ', '' );

   -- 'NOW', 'WEEKLY', 'DAILY AT 14:00', '...', 'BROKEN'   
   IF REGEXP_LIKE(input_,'^(NOW|ASAP|TOMORROW|DAILY|WEEKLY|BROKEN|\.\.\.)?[ ]*('||at_||')?$') THEN
     RETURN;
   END IF;

   -- 'ON 1996-03-10 AT 11:30', 'ON tue AT 11:30' 
   IF REGEXP_LIKE(input_,'^ON[ ]+('|| date_ || '|' || shortwdays_list_ ||')[ ]*('||at_||')?$') THEN
     RETURN;
   END IF;

   -- 'WEEKLY ON mon;thu AT_11:00;16:00', 'WEEKLY ON weekdays'
   IF REGEXP_LIKE(input_, '^WEEKLY[ ]+ON[ ]+'||shortwdays_list_||'([ ]+'||at_||')?$') THEN
     RETURN;
   END IF;

   -- 'MONTHLY ON DAY <day_number> AT <time>'
   IF REGEXP_LIKE(input_, '^MONTHLY[ ]+ON[ ]+DAY[ ]+[0-9]+(;[0-9]+)*[ ]+'||at_||'$') THEN
     RETURN;
   END IF;

   -- 'EVERY_00:30'  
   IF REGEXP_LIKE(input_, '^EVERY[ _]+[0-9]{2}:[0-9]{2}$') THEN
     RETURN;
   END IF;

   -- 'SYSDATE', 'sysdate + 60/86400'
   IF REGEXP_LIKE(input_, sysdate_exp_pattern_, 'i') THEN
     RETURN;
   END IF;

   IF Is_Datefunc___(input_) THEN
     RETURN;
   END IF;

   RAISE no_data_found;
EXCEPTION
   WHEN OTHERS THEN
      Assert_Helper_Log___('Assert_Is_Exec_Plan',exec_plan_,dbms_utility.format_call_stack());
      Error_SYS.Appl_General(service_, 'IS_EXEC_PLAN_EXP: ":P1" is not a valid execution plan.', exec_plan_ );
END Assert_Is_Exec_Plan;

-- Assert_Is_Db_Object
--   Assert_Is_Db_Object ( object_name_ )
PROCEDURE Assert_Is_Db_Object (
   object_name_ IN VARCHAR2 )
IS
   result_ VARCHAR2(30);
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Db_Object', TRUE);
   result_ := Dbms_Assert.Sql_Object_Name(object_name_);
EXCEPTION
   WHEN OTHERS THEN
      Assert_Helper_Log___( 'Assert_Is_Db_Object', object_name_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'IS_DB_OBJECT: ":P1" is non existing database object.', object_name_ );
END Assert_Is_Db_Object;
   
PROCEDURE Assert_No_Regexp_Match(
   text_in_   VARCHAR2,
   pattern_   VARCHAR2)
IS
   match   EXCEPTION;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_No_Regexp_Match', TRUE);
   IF REGEXP_LIKE(text_in_, pattern_) THEN
      RAISE match;
   END IF;
   RETURN;
EXCEPTION
   WHEN match THEN
      Assert_Helper_Log___( 'Assert_No_Regexp_Match', text_in_, dbms_utility.format_call_stack() );
      Error_SYS.Appl_General(service_, 'NO_MATCH_REGEXP: Input ":P1" matches the regular expression.', text_in_);
END Assert_No_Regexp_Match;

PROCEDURE Assert_Is_Projection (
   projection_name_ IN VARCHAR2)
IS
   test_ NUMBER := 0;
BEGIN
   General_SYS.Check_Security(service_, 'ASSERT_SYS', 'Assert_Is_Projection', TRUE);
   SELECT 1
   INTO  test_
   FROM  fnd_projection_tab
   WHERE projection_name = projection_name_;
EXCEPTION
   WHEN no_data_found THEN
      Assert_Helper_Log___( 'Assert_Is_Projection', projection_name_,
      dbms_utility.format_call_stack() );
      Error_SYS.Projection_Not_Exist(service_, projection_name_);
END Assert_Is_Projection;
