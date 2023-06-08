-----------------------------------------------------------------------------
--
--  Logical unit: FndrrClientProfileUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050307  RaKu    Created (F1PR482).
--  050414  RaKu    Continued unfinished work (F1PR482).
--  050511  RaKu    Changed several cursors to access tables directly (F1PR482).
--  051110  RaKu    Removed column 'STORAGE' where used (F1PR482).
--  070108  RaKu    Removed objversion from Get_Centura_Profile__ (Bug#62809).
--  070201  RaKu    Added Find_Profile_Id_Used_As_Base__ (Bug#63296).
--  071105  DuWi    Modified Find_Profile_Id__ for converted profile name (Bug#68095).
--  071204  DuWi    Modified Get_Available_Profile_List__ in order to list more profiles (Bug#69346)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Init_Centura_Profile__ (
   msg_ OUT VARCHAR2 )
IS
BEGIN
   msg_ := Get_Centura_Profile__(Fnd_Session_API.Get_Fnd_User);
END Init_Centura_Profile__;


@UncheckedAccess
FUNCTION Find_Profile_Id__ (
   profile_name_ IN VARCHAR2,
   owner_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   profile_id_ VARCHAR2(100);

   CURSOR find_profile IS
      SELECT profile_id
      FROM FNDRR_CLIENT_PROFILE_TAB
      WHERE profile_name = owner_ ||' '|| profile_name_
      AND owner = owner_;
BEGIN
   OPEN find_profile;
   FETCH find_profile INTO profile_id_;
   CLOSE find_profile;

   RETURN profile_id_;
END Find_Profile_Id__;



@UncheckedAccess
FUNCTION Find_Profile_Id_Used_As_Base__ (
   user_name_ IN VARCHAR2,
   profile_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   profile_id_ VARCHAR2(100);

  -- The only way to, during the upgrade process, keep track on which "old"
  -- default profile is connected to which new base profile is using name convension
  -- on PROFILE_NAME. The 400.upg script and the following cursor
  -- will both use following syntax:
  -- Base profile (clone of "<USER_NAME>.<PROFILE_NAME>")
  --
  -- Once the profile_name is changed, after the upgrade, the connection is lost and
  -- the 400.upg script will (when being reexecuted) recreate new base profiles as it
  -- will not find an existing one (due to the profile_name being changed).
   CURSOR find_profile IS
      SELECT profile_id
      FROM FNDRR_CLIENT_PROFILE_TAB
      WHERE owner IS NULL
      AND profile_name = 'Base profile (clone of "' || user_name_ || '.' || profile_name_ || '")';
BEGIN
   OPEN find_profile;
   FETCH find_profile INTO profile_id_;
   CLOSE find_profile;

   RETURN profile_id_;
END Find_Profile_Id_Used_As_Base__;



PROCEDURE Get_Available_Profile_List__ (
   msg_ OUT VARCHAR2,
   base_profile_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   fnd_user_ VARCHAR2(30);
   message_  VARCHAR2(32000) := Message_SYS.Construct('CENTURA_PROFILE');

   CURSOR get_base_profiles IS
      SELECT profile_id, profile_name
      FROM fndrr_client_profile_tab
      WHERE owner IS NULL;

   CURSOR get_personal_profiles IS
      SELECT profile_id, profile_name
      FROM fndrr_client_profile_tab
      WHERE owner = fnd_user_;
BEGIN

   IF base_profile_ = 'TRUE' THEN
      FOR rec_ IN get_base_profiles LOOP
         Message_SYS.Add_Attribute(message_, rec_.profile_id, rec_.profile_name);
      END LOOP;
   ELSE
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      FOR rec_ IN get_personal_profiles LOOP
         Message_SYS.Add_Attribute(message_, rec_.profile_id, rec_.profile_name);
      END LOOP;
   END IF;

   msg_ := message_;
END Get_Available_Profile_List__;


PROCEDURE Check_Base_Profile_Used__ (
   profile_id_ IN VARCHAR2 )
IS
   profile_name_ VARCHAR2(200);
   identity_     VARCHAR2(30);
   count_        NUMBER;

   CURSOR is_used IS
      SELECT count(*)
      FROM fndrr_user_client_profile_tab
      WHERE profile_id = profile_id_
      AND ordinal = 1;

   CURSOR get_user IS
      SELECT user_id
      FROM fndrr_user_client_profile_tab
      WHERE profile_id = profile_id_
      AND ordinal = 1;

BEGIN


   OPEN is_used;
   FETCH is_used INTO count_;
   IF count_ >= 1 THEN
      CLOSE is_used;
      profile_name_ := Fndrr_Client_PRofile_API.Get_Profile_Name(profile_id_);
      IF count_ = 1 THEN
         OPEN get_user;
         FETCH get_user INTO identity_;
         CLOSE get_user;
         Error_SYS.Appl_General(lu_name_,
            'BASE_USED_BY_ONE: Type can not be changed for '':P1'' as the profile is currently used as Base Profile by '':P2''.',
            profile_name_, identity_ );
      ELSE
         Error_SYS.Appl_General(lu_name_,
            'BASE_USED_BY_MULTI: Type can not be changed for '':P1'' as the profile is currently used as Base Profile by :P2 users.',
            profile_name_, count_);
      END IF;
   ELSE
      CLOSE is_used;
   END IF;

END Check_Base_Profile_Used__;


PROCEDURE Check_Personal_Profile_Used__ (
   profile_id_ IN VARCHAR2 )
IS
   owner_        VARCHAR2(30) := Fndrr_Client_Profile_API.Get_Owner(profile_id_);
   profile_name_ VARCHAR2(200);
   count_        NUMBER;

   CURSOR is_used IS
      SELECT 1
      FROM fndrr_user_client_profile_tab
      WHERE profile_id = profile_id_
      AND user_id = owner_
      AND ordinal = 0;
BEGIN


   OPEN is_used;
   FETCH is_used INTO count_;
   IF is_used%FOUND THEN
      CLOSE is_used;
      profile_name_ := Fndrr_Client_Profile_API.Get_Profile_Name(profile_id_);
      Error_SYS.Appl_General(lu_name_,
         'USED_AS_PERSONAL: Owner/type can not be changed for '':P1'' as the profile is currently used as Personal Profile by '':P2''.',
         profile_name_, owner_);
   ELSE
      CLOSE is_used;
   END IF;

END Check_Personal_Profile_Used__;


@UncheckedAccess
FUNCTION Get_Centura_Profile__ (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   message_           VARCHAR2(2000) := Message_SYS.Construct('CENTURA_PROFILE');

   enabled_           NUMBER := 0;
   profile_id_        VARCHAR2(100);
   profile_name_      VARCHAR2(200);

   base_enabled_      NUMBER := 0;
   base_profile_id_   VARCHAR2(100);
   base_profile_name_ VARCHAR2(200);

-- The profile having ORDINAL = 0 is treated as "Personal"

   CURSOR get_profile IS
      SELECT p.profile_id, p.profile_name, u.enabled
      FROM fndrr_client_profile_tab p, fndrr_user_client_profile_tab u
      WHERE u.user_id    = identity_
      AND   u.profile_id = p.profile_id
      AND   u.ordinal = 0;

-- The profile having ORDINAL = 1 is treated as "Base"
-- This is a limitation for now as the base profile can be
-- conbination of several profiles with ORDINAL 1..x

   CURSOR get_base_profile IS
      SELECT p.profile_id, p.profile_name, u.enabled
      FROM fndrr_client_profile_tab p, fndrr_user_client_profile_tab u
      WHERE u.user_id    = identity_
      AND   u.profile_id = p.profile_id
      AND   u.ordinal = 1;

BEGIN
   OPEN  get_profile;
   FETCH get_profile INTO profile_id_, profile_name_,  enabled_;
   CLOSE get_profile;

   OPEN  get_base_profile;
   FETCH get_base_profile INTO base_profile_id_, base_profile_name_, base_enabled_;
   CLOSE get_base_profile;

   Message_SYS.Add_Attribute(message_, 'USER_DESC', Fnd_User_API.Get_Description(identity_));

   -- Personal
   IF enabled_ = 1 THEN
      Message_SYS.Add_Attribute(message_, 'ENABLED', 'TRUE');
   ELSE
      Message_SYS.Add_Attribute(message_, 'ENABLED', 'FALSE');
   END IF;
   Message_SYS.Add_Attribute(message_, 'PROFILE_ID', profile_id_);
   Message_SYS.Add_Attribute(message_, 'PROFILE_NAME', profile_name_);

   -- Base
   IF base_enabled_ = 1 THEN
      Message_SYS.Add_Attribute(message_, 'BASE_ENABLED', 'TRUE');
   ELSE
      Message_SYS.Add_Attribute(message_, 'BASE_ENABLED', 'FALSE');
   END IF;
   Message_SYS.Add_Attribute(message_, 'BASE_PROFILE_ID', base_profile_id_);
   Message_SYS.Add_Attribute(message_, 'BASE_PROFILE_NAME', base_profile_name_);

   RETURN message_;
END Get_Centura_Profile__;



@UncheckedAccess
FUNCTION Count_Profile_Items__ (
   profile_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_count IS
      SELECT count(*)
      FROM FNDRR_CLIENT_PROFILE_VALUE_TAB
      WHERE profile_id = profile_id_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO count_;
   CLOSE get_count;
   RETURN count_;
END Count_Profile_Items__;



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


