-----------------------------------------------------------------------------
--
--  Logical unit: FndrrUserClientProfile
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050307  RaKu  Created (F1PR482).
--  050414  RaKu  Continued unfinished work (F1PR482).
--  051110  RAKu  Removed obsolete column 'STORAGE' (F1PR482)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ENABLED', '1', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FNDRR_USER_CLIENT_PROFILE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_ordinal IS
      SELECT NVL(MAX(ordinal)+1, 0 )
      FROM FNDRR_USER_CLIENT_PROFILE_TAB
      WHERE user_id = newrec_.user_id;
BEGIN
   IF newrec_.ordinal IS NULL THEN
      OPEN get_ordinal;
      FETCH get_ordinal INTO newrec_.ordinal;
      CLOSE get_ordinal;
   END IF;
   newrec_.created_by := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_date := SYSDATE;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('ORDINAL', newrec_.ordinal, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Remove_User_Profiles__ (
   identity_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM FNDRR_USER_CLIENT_PROFILE_TAB
      WHERE user_id = identity_;
END Remove_User_Profiles__;


PROCEDURE Assign_Base_Profile__ (
   identity_ IN VARCHAR2,
   profile_id_ IN VARCHAR2,
   enabled_ IN VARCHAR2 )
IS
   remrec_   FNDRR_USER_CLIENT_PROFILE_TAB%ROWTYPE;
   newrec_   FNDRR_USER_CLIENT_PROFILE_TAB%ROWTYPE;
   oldrec_   FNDRR_USER_CLIENT_PROFILE_TAB%ROWTYPE;
   indrec_   Indicator_Rec;

   assigned_profile_id_ FNDRR_USER_CLIENT_PROFILE_TAB.PROFILE_ID%TYPE;
   attr_         VARCHAR2(2000);
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
BEGIN

   assigned_profile_id_ := Get_Base_Profile_Id(identity_);

   IF ( assigned_profile_id_ IS NOT NULL AND ( profile_id_ IS NULL OR assigned_profile_id_ != profile_id_ )) THEN
      -- Delete old one
      Get_Id_Version_By_Keys___(objid_, objversion_, assigned_profile_id_, identity_);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
      assigned_profile_id_ := NULL;
   END IF;

   IF profile_id_ IS NOT NULL THEN
      IF assigned_profile_id_ IS NULL THEN
         -- New
         Client_SYS.Add_To_Attr('PROFILE_ID', profile_id_, attr_);
         Client_SYS.Add_To_Attr('IDENTITY', identity_, attr_);
         Client_SYS.Add_To_Attr('ORDINAL', 1, attr_);
         IF enabled_ = 'FALSE' THEN
            Client_SYS.Add_To_Attr('ENABLED', 0, attr_);
         ELSE
            Client_SYS.Add_To_Attr('ENABLED', 1, attr_);
         END IF;
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      ELSIF assigned_profile_id_ = profile_id_ THEN
         -- Modify
         IF enabled_ = 'FALSE' THEN
            Client_SYS.Add_To_Attr('ENABLED', 0, attr_);
         ELSE
            Client_SYS.Add_To_Attr('ENABLED', 1, attr_);
         END IF;
         oldrec_ := Lock_By_Keys___(profile_id_, identity_);
         newrec_ := oldrec_;
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      END IF;
   END IF;

END Assign_Base_Profile__;


PROCEDURE Assign_Personal_Profile__ (
   profile_id_ IN VARCHAR2,
   identity_ IN VARCHAR2,
   enabled_ IN VARCHAR2 )
IS
   newrec_   FNDRR_USER_CLIENT_PROFILE_TAB%ROWTYPE;
   oldrec_   FNDRR_USER_CLIENT_PROFILE_TAB%ROWTYPE;
   remrec_   FNDRR_USER_CLIENT_PROFILE_TAB%ROWTYPE;
   indrec_   Indicator_Rec;

   assigned_profile_id_ FNDRR_USER_CLIENT_PROFILE_TAB.PROFILE_ID%TYPE;
   attr_         VARCHAR2(2000);
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
BEGIN

   assigned_profile_id_ := Get_Personal_Profile_Id(identity_);

   IF assigned_profile_id_ IS NOT NULL THEN
      -- One already assigned
      IF assigned_profile_id_ != profile_id_ THEN
         -- Delete old one
         Get_Id_Version_By_Keys___(objid_, objversion_, assigned_profile_id_, identity_);
         remrec_ := Lock_By_Id___(objid_, objversion_);
         Check_Delete___(remrec_);
         Delete___(objid_, remrec_);
         assigned_profile_id_ := NULL;
      END IF;
   END IF;

   IF assigned_profile_id_ IS NULL THEN
      -- New
      Client_SYS.Add_To_Attr('PROFILE_ID', profile_id_, attr_);
      Client_SYS.Add_To_Attr('IDENTITY', identity_, attr_);
      Client_SYS.Add_To_Attr('ORDINAL', 0, attr_);
      IF enabled_ = 'FALSE' THEN
         Client_SYS.Add_To_Attr('ENABLED', 0, attr_);
      ELSE
         Client_SYS.Add_To_Attr('ENABLED', 1, attr_);
      END IF;
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSIF assigned_profile_id_ = profile_id_ THEN
      -- Modify
      IF enabled_ = 'FALSE' THEN
         Client_SYS.Add_To_Attr('ENABLED', 0, attr_);
         Trace_SYS.FIeld('ENABLED', 0 );

      ELSE
         Client_SYS.Add_To_Attr('ENABLED', 1, attr_);
         Trace_SYS.FIeld('ENABLED', 1 );

      END IF;
      oldrec_ := Lock_By_Keys___(profile_id_, identity_);
      newrec_ := oldrec_;

      Trace_SYS.Field('ATTR', attr_ );
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;

END Assign_Personal_Profile__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Personal_Profile_Id (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ FNDRR_USER_CLIENT_PROFILE_TAB.profile_id%TYPE;
   CURSOR get_attr IS
      SELECT profile_id
      FROM FNDRR_USER_CLIENT_PROFILE_TAB
      WHERE user_id = identity_
      AND   ordinal = 0;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Personal_Profile_Id;


@UncheckedAccess
FUNCTION Get_Base_Profile_Id (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ FNDRR_USER_CLIENT_PROFILE_TAB.profile_id%TYPE;
   CURSOR get_attr IS
      SELECT profile_id
      FROM FNDRR_USER_CLIENT_PROFILE_TAB
      WHERE user_id = identity_
      AND   ordinal = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Base_Profile_Id;


@UncheckedAccess
FUNCTION Is_Personal_Profile_Enabled (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(5);
   CURSOR get_attr IS
      SELECT DECODE(enabled, 0, 'FALSE', 'TRUE')
      FROM FNDRR_USER_CLIENT_PROFILE_TAB
      WHERE user_id = identity_
      AND   ordinal = 0;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_ IS NULL THEN
      -- No personal record found -> Windows Registry is used and is enabled.
      RETURN 'TRUE';
   END IF;
   RETURN temp_;
END Is_Personal_Profile_Enabled;


@UncheckedAccess
FUNCTION Is_Base_Profile_Enabled (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(5);
   CURSOR get_attr IS
      SELECT DECODE(enabled, 0, 'FALSE', 'TRUE')
      FROM FNDRR_USER_CLIENT_PROFILE_TAB
      WHERE user_id = identity_
      AND   ordinal = 1;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_ IS NULL THEN
      -- No base record found -> No base profile used.
      RETURN 'FALSE';
   END IF;
   RETURN temp_;
END Is_Base_Profile_Enabled;



