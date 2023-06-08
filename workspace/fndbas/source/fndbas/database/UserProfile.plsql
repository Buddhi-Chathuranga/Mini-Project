-----------------------------------------------------------------------------
--
--  Logical unit: UserProfile
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  951024  ERFO  Created.
--  951025  STLA  Added description to Get_Entry_Properties and removed
--                unused methods.
--  951107  ERFO  Added method Authorized and correct exception handling
--                in method Get_Description___.
--  951116  ERFO  Minor correction in method Authorized.
--  951130  ERFO  Replaced implementation method Get_Description___ with
--                a call to Decode for the IID domain UserGlobal.
--                Added public methods to manipulate the internal table
--                for User_Profile_SYS.
--  951218  ERFO  Added method Reset_Entry_Code to be used by other
--                security logical units in IFS APPLICATIONS (Idea #306).
--  960319  ERFO  Included logical unit UserGlobal within this system service
--                to support IFS/Deployment installation standards (Idea #456).
--  960426  ERFO  Added element COMPANY_ID for IFS Foundation/DEMO to the
--                IID UserGlobal. Replaced statement "start geniid.cre" with
--                actual code for package template.
--  960429  ERFO  Added method Get_Default to retrieve the default value for
--                a specific entry code and user id (Idea #537).
--  960429  ERFO  Corrected GENIID-handle for similar client values (Idea #543).
--  960507  ERFO  Added language translation tag for special cases.
--  960809  MADR  Added methods to store/retrieve user properties (Idea #760).
--  960820  MADR  Renamed USER_PROPERTY_SYS_TAB to USER_PROFILE_SYS_PROPERTY_TAB
--  960909  MADR  Convert USER_NAME to upper case in Get/Set_Properties
--  960913  ERFO  Upgraded new version of code for logical unit UserGlobal.
--  960918  ERFO  Changed use of Error_SYS for IFSLOC-compatible reasons.
--  961126  ERFO  Changed parameters from default user to default NULL and
--                communication towards the new package Utility_SYS and
--                added method Set_User to be called from Transaction_SYS.
--  970521  ERFO  Rewritten old API:s for user property information.
--  970725  ERFO  Replaced usage of obsolete method Utility_SYS.Get_User
--                with the new Fnd_Session_API.Get_Fnd_User (ToDo #1172).
--  970729  ERFO  Removed unused interfaces from package (ToDo #1533).
--  970825  ERFO  Added new method Get_All_Info_ (ToDo #1601).
--  971219  ERFO  Changed to use Fnd_User_Property_API.Set_Value instead
--                of the previous Fnd_User_API.Set_Property (ToDo #1785).
--  980303  ERFO  Removed tag for early translation support (ToDo #2184).
--  980728  ERFO  Optimized SQL in function Authorized (Bug #2583).
--  990222  ERFO  Yoshimura: Changes in Get_All_Info, Enumerate_Entry_Codes,
--                Get_Entry_Properties and Set/Get_Properties (ToDo #3160).
--  990623  ERFO  Removed methods Get/Set_Properties (ToDo #3449).
--  990920  STLA  Added view CLIENT_PROFILE and applied new table for
--                each modification to original table (ToDo #3586).
--  000226  ERFO  Correction in WHERE-clause in Authorized (Bug #13971).
--  000502  ERFO  Solved problem with duplicate values in New_Value (Bug #16000).
--  020701  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030220  ROOD  Changed hardcoded subcomponent names in messages (ToDo#4149).
--  030304  ROOD  Corrected corruption possibility in Remove_Value (Bug36055).
--  030313  ROOD  Corrected problem with duplicate values in value list (Bug#20397).
--  030324  ROOD  Added view USER_PROFILE (ToDo#4160).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  040601  ROOD  Removed usage of the column value_list in implementation.
--                Added method Get_Value_List__ (Bug#43588).
--  040709  ROOD  Added Micro Cache for method Authorized (F1PR404).
--  040805  HAAR  Clear the cache value, micro_cache_value_, in Update_Cache___ when no new value found.
--  060619  SUKM  Increased length of desc_ to 30 in Get_All_Info_(Bug #58210).
------------------------------------------------------------------------------
--
--  Dependencies: User_Profile_SYS base tables
--                Client_SYS
--                Message_SYS
--                UserGlobal
--
--  Contents:     Implementation methods for global settings
--                Public methods for retrieval of global settings.
--
-----------------------------------------------------------------------------
--
--  Tables:  CREATE TABLE USER_PROFILE_SYS_TAB (
--              USER_NAME       VARCHAR2(30)    NOT NULL,
--              ENTRY_CODE      VARCHAR2(30)    NOT NULL,
--              DEFAULT_VALUE   VARCHAR2(20)    NOT NULL,
--              ROWVERSION      DATE)
--
--           CREATE TABLE USER_PROFILE_ENTRY_SYS_TAB (
--              USER_NAME       VARCHAR2(30)    NOT NULL,
--              ENTRY_CODE      VARCHAR2(30)    NOT NULL,
--              ENTRY_VALUE     VARCHAR2(30)    NOT NULL
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

field_separator_ CONSTANT VARCHAR2(1)  := Client_SYS.field_separator_;
micro_cache_entry_code_  user_profile_entry_sys_tab.entry_code%TYPE;
micro_cache_entry_value_ user_profile_entry_sys_tab.entry_value%TYPE;
micro_cache_user_name_   user_profile_entry_sys_tab.user_name%TYPE;
micro_cache_value_       user_profile_entry_sys_tab.entry_value%TYPE;
micro_cache_time_        NUMBER := 0;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Invalidate_Cache___
IS
BEGIN
   micro_cache_entry_code_  := NULL;
   micro_cache_entry_value_ := NULL;
   micro_cache_user_name_   := NULL;
   micro_cache_value_       := NULL;
END Invalidate_Cache___;


PROCEDURE Update_Cache___ (
   entry_code_  IN VARCHAR2,
   entry_value_ IN VARCHAR2,
   user_name_   IN VARCHAR2 )
IS
   time_       NUMBER;
   expired_    BOOLEAN;
   CURSOR get_entry IS
      SELECT entry_value
      FROM  user_profile_entry_sys_tab
      WHERE entry_code = entry_code_
      AND   user_name  = user_name_
      AND   entry_value = entry_value_;
BEGIN
   -- Get best before offset time
   time_ := Database_SYS.Get_Time_Offset;
   -- Check if the time past more than 10 seconds.
   expired_ := (time_ - micro_cache_time_) > 10;
   -- Check if expired and that Primary Key is equal to the Cached Key
   IF NOT expired_ AND (micro_cache_entry_code_ = entry_code_) AND (micro_cache_entry_value_ = entry_value_) AND (micro_cache_user_name_ = user_name_) THEN
      NULL;
   ELSE
      OPEN get_entry;
      FETCH get_entry INTO micro_cache_value_;
      IF (get_entry%NOTFOUND) THEN
         micro_cache_value_ := NULL;
      END IF;
      CLOSE get_entry;
      -- Set fetched cached Primary Key.
      micro_cache_entry_code_  := entry_code_;
      micro_cache_entry_value_ := entry_value_;
      micro_cache_user_name_   := user_name_;
      -- Set new microcache best before offset time
      micro_cache_time_ := time_;
   END IF;
END Update_Cache___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Value_List__ (
   entry_code_ IN VARCHAR2,
   user_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_list_ VARCHAR2(32000);

   CURSOR get_entries (entry_code_ IN VARCHAR2, user_name_ IN VARCHAR2) IS
      SELECT entry_value
      FROM user_profile_entry_sys_tab
      WHERE user_name = user_name_
      AND   entry_code = entry_code_;
BEGIN
   FOR rec IN get_entries(entry_code_, user_name_) LOOP
      value_list_ := value_list_||rec.entry_value||'^';
   END LOOP;
   RETURN value_list_;
END Get_Value_List__;



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Get_All_Info_
--   Return a IFS message containing all info for current user.
@UncheckedAccess
PROCEDURE Get_All_Info_ (
   info_msg_ OUT VARCHAR2 )
IS
   fnduser_    VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   msg_        VARCHAR2(32000);
   desc_       VARCHAR2(30);
   CURSOR get_all_info IS
      SELECT entry_code, default_value
      FROM  user_profile_sys_tab
      WHERE user_name = fnduser_;
BEGIN
   msg_ := Message_SYS.Construct('FNDBAS.CENTURA.USERPROFILE');
   FOR rec IN get_all_info LOOP
      desc_ := User_Global_API.Decode(rec.entry_code);
      Message_SYS.Set_Attribute(msg_, rec.entry_code, desc_||field_separator_||rec.default_value||field_separator_||Get_Value_List__(rec.entry_code, fnduser_));
   END LOOP;
   info_msg_ := msg_;
END Get_All_Info_;



-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Enumerate_Entry_Codes
--   Return a list of available global entry codes in this system.
--   This value is not connected to any specific user.
@UncheckedAccess
PROCEDURE Enumerate_Entry_Codes (
   entry_list_ OUT VARCHAR2 )
IS
   list_    VARCHAR2(2000) := NULL;
   fnduser_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   CURSOR entries IS
      SELECT entry_code
      FROM   user_profile_sys_tab
      WHERE  user_name = fnduser_;
BEGIN
   FOR rec IN entries LOOP
      list_ := list_||rec.entry_code||field_separator_;
   END LOOP;
   entry_list_ := list_;
END Enumerate_Entry_Codes;



-- Get_Entry_Properties
--   Return available value list and default value for specific entry
--   code. The value is dependent of the current user setting.
PROCEDURE Get_Entry_Properties (
   value_list_    OUT VARCHAR2,
   default_value_ OUT VARCHAR2,
   description_   OUT VARCHAR2,
   entry_code_    IN  VARCHAR2 )
IS
   fnduser_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   User_Global_API.Exist_Db(entry_code_);
   SELECT default_value
      INTO default_value_
      FROM  user_profile_sys_tab
      WHERE entry_code = entry_code_
      AND   user_name  = fnduser_;
   description_ := User_Global_API.Decode(entry_code_);
   value_list_  := replace(Get_Value_List__(entry_code_, fnduser_), '^', field_separator_);
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Record_Not_Exist(service_, p1_ => entry_code_);
END Get_Entry_Properties;


@UncheckedAccess
FUNCTION Authorized (
   entry_code_ IN VARCHAR2,
   value_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   user_name_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   -- Use Micro Cache instead of selecting from table
   Update_Cache___(entry_code_, value_, user_name_);
   RETURN micro_cache_value_;
END Authorized;



-- New_Value
--   Add a new value to the value list for a specific entry code and user.
--   The optional parameter default_ may also be used to set the default
--   value for specific user. The method updates an existing record or
--   creates a new one if this is the first value.
PROCEDURE New_Value (
   entry_code_ IN VARCHAR2,
   user_name_  IN VARCHAR2,
   value_      IN VARCHAR2,
   default_    IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   User_Global_API.Exist_Db(entry_code_);
   -- Insert the actual entry
   BEGIN
      INSERT
         INTO user_profile_entry_sys_tab(user_name, entry_code, entry_value)
         VALUES (user_name_, entry_code_, value_);
   EXCEPTION
      WHEN dup_val_on_index THEN
         NULL; -- Accept duplicate values when calling this interface
   END;
   Invalidate_Cache___;
   -- Insert or update the default value
   BEGIN
      -- First time a value for this entry_code is inserted, else exception will be raised
      INSERT
         INTO user_profile_sys_tab
            (user_name, entry_code, default_value, rowversion)
         VALUES
            (user_name_, entry_code_, value_, sysdate);
   EXCEPTION
      WHEN dup_val_on_index THEN
         -- Set the default value if it should be modified
         IF default_ IS NOT NULL THEN
            Set_Default(entry_code_, user_name_, default_);
         END IF;
   END;
END New_Value;


-- Remove_Value
--   Remove a value from the value list for a specific entry code and user.
--   The method checks whether the entry code  exists and raise an exception
--   if the entry code does not exist. If the last value is removed, the
--   complete record is removed from the database by exception handling.
PROCEDURE Remove_Value (
   entry_code_ IN VARCHAR2,
   user_name_  IN VARCHAR2,
   value_      IN VARCHAR2,
   default_    IN VARCHAR2 DEFAULT NULL )
IS
   eq_                VARCHAR2(1) := '=';
   dummy_             NUMBER;
   entry_still_exist_ BOOLEAN;
   new_default_       VARCHAR2(30);

   CURSOR entry_exist(entry_code_ IN VARCHAR2, user_name_ IN VARCHAR2) IS
      SELECT 1
      FROM user_profile_entry_sys_tab
      WHERE entry_code = entry_code_
      AND user_name = user_name_;

BEGIN
   User_Global_API.Exist_Db(entry_code_);
   -- Remove the actual entry
   DELETE
      FROM  user_profile_entry_sys_tab
      WHERE user_name   = user_name_
      AND   entry_code  = entry_code_
      AND   entry_value = value_;
   IF (sql%NOTFOUND) THEN
      Error_SYS.Record_Not_Exist(service_, p1_ => entry_code_||eq_||value_);
   END IF;
   Invalidate_Cache___;

   -- Investigate the situation after the deletion
   OPEN entry_exist(entry_code_, user_name_);
   FETCH entry_exist INTO dummy_;
   entry_still_exist_ := entry_exist%FOUND;
   CLOSE entry_exist;

   -- Update with default value or delete the complete record.
   IF entry_still_exist_ THEN
      -- Find what value should be the default value
      IF default_ IS NOT NULL THEN
         new_default_ := default_;
      ELSE
         new_default_ := Get_Default(entry_code_, user_name_);
      END IF;
      Set_Default(entry_code_, user_name_, new_default_);
   ELSE
      DELETE FROM user_profile_sys_tab
         WHERE entry_code = entry_code_
         AND   user_name  = user_name_;
   END IF;
END Remove_Value;


-- Set_Default
--   Set default value for a specific entry code and user. The method checks
--   whether the entry code exists and raise an exception if the entry code
--   does not exist for the specific user or if the default value is not
--   included in the existing value list.
PROCEDURE Set_Default (
   entry_code_ IN VARCHAR2,
   user_name_  IN VARCHAR2,
   default_    IN VARCHAR2 )
IS
   eq_    VARCHAR2(1) := '=';
   dummy_ NUMBER;

   CURSOR value_exist(entry_code_ IN VARCHAR2, user_name_ IN VARCHAR2, entry_value_ IN VARCHAR2) IS
      SELECT 1
      FROM user_profile_entry_sys_tab
      WHERE entry_code = entry_code_
      AND user_name = user_name_
      AND entry_value = entry_value_;
BEGIN
   User_Global_API.Exist_Db(entry_code_);
   -- Check the existance of the entry value before setting it to default!
   OPEN value_exist(entry_code_, user_name_, default_);
   FETCH value_exist INTO dummy_;
   IF value_exist%NOTFOUND THEN
      CLOSE value_exist;
      Error_SYS.Record_Not_Exist(service_, p1_ => entry_code_||eq_||default_);
   END IF;
   CLOSE value_exist;
   UPDATE user_profile_sys_tab
      SET default_value = default_,
          rowversion    = sysdate
      WHERE entry_code = entry_code_
      AND   user_name  = user_name_;
END Set_Default;


-- Get_Default
--   Get the default value for a specific entry code and user. This method
--   returns null if the entry code does not exist for the specific user.
@UncheckedAccess
FUNCTION Get_Default (
   entry_code_ IN VARCHAR2,
   user_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ user_profile_sys_tab.default_value%TYPE;
   CURSOR get_rec IS
      SELECT default_value
      FROM  user_profile_sys_tab
      WHERE entry_code = entry_code_
      AND   user_name  = user_name_;
BEGIN
   OPEN get_rec;
   FETCH get_rec INTO temp_;
   CLOSE get_rec;
   RETURN(temp_);
END Get_Default;



-- Reset_Entry_Code
--   Reset entry by deleting the row connected to the specific user and
--   entry code. No exception will be raised even if no rows are found
--   in the table.
PROCEDURE Reset_Entry_Code (
   entry_code_ IN VARCHAR2,
   user_name_  IN VARCHAR2 )
IS
BEGIN
   DELETE
      FROM  user_profile_sys_tab
      WHERE entry_code = entry_code_
      AND   user_name  = user_name_;
   DELETE
      FROM  user_profile_entry_sys_tab
      WHERE user_name   = user_name_
      AND   entry_code  = entry_code_;
   Invalidate_Cache___;
END Reset_Entry_Code;



