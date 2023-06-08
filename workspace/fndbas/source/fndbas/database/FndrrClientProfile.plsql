-----------------------------------------------------------------------------
--
--  Logical unit: FndrrClientProfile
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050307  RaKu  Created (F1PR482).
--  050414  RaKu  Continued unfinished work (F1PR482).
--  070108  RaKu  Removed obsolete parameters/code from Update_Profile__(Bug#62809)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Create_Profile___ (
   profile_id_ OUT VARCHAR2,
   profile_name_ IN VARCHAR2,
   owner_ IN VARCHAR2 DEFAULT NULL )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   newrec_     FNDRR_CLIENT_PROFILE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('PROFILE_NAME', profile_name_, attr_);

   IF owner_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('OWNER', owner_, attr_);
   END IF;

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   profile_id_ := Client_SYS.Get_Item_Value('PROFILE_ID', attr_);
END Create_Profile___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('OWNER', Fnd_Session_API.Get_Fnd_User, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FNDRR_CLIENT_PROFILE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Column 'created_by' and 'created_date' are
   -- needed for the ENDEXT framework.
   newrec_.profile_id := Sys_Guid;
   newrec_.creator := Fnd_Session_API.Get_Fnd_User;
   newrec_.date_created := SYSDATE;
   newrec_.created_by := newrec_.creator;
   newrec_.created_date := newrec_.date_created;
   newrec_.modified_by := newrec_.creator;
   newrec_.modified_date := newrec_.date_created;   
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('PROFILE_ID', newrec_.profile_id, attr_);
   Client_SYS.Add_To_Attr('CREATOR', newrec_.creator, attr_);
   Client_SYS.Add_To_Attr('DATE_CREATED', newrec_.date_created, attr_);
   Client_SYS.Add_To_Attr('CREATED_BY', newrec_.created_by, attr_);
   Client_SYS.Add_To_Attr('CREATED_DATE', newrec_.created_date, attr_);
   Client_SYS.Add_To_Attr('MODIFIED_BY', newrec_.modified_by, attr_);
   Client_SYS.Add_To_Attr('MODIFIED_DATE', newrec_.modified_date, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FNDRR_CLIENT_PROFILE_TAB%ROWTYPE,
   newrec_     IN OUT FNDRR_CLIENT_PROFILE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.modified_by := Fnd_Session_API.Get_Fnd_User;
   newrec_.modified_date := SYSDATE;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr('MODIFIED_BY', newrec_.modified_by, attr_);
   Client_SYS.Add_To_Attr('MODIFIED_DATE', newrec_.modified_date, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_Base__ (
   profile_id_ OUT VARCHAR2,
   profile_name_ IN VARCHAR2 )
IS
BEGIN
   Create_Profile___(profile_id_, profile_name_);
END Create_Base__;


PROCEDURE Update_Profile__ (
   profile_id_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   oldrec_     FNDRR_CLIENT_PROFILE_TAB%ROWTYPE;
   newrec_     FNDRR_CLIENT_PROFILE_TAB%ROWTYPE;
BEGIN

   IF NOT Check_Exist___(profile_id_) THEN
      Error_SYS.Appl_General(lu_name_, 'PROFILE_REMOVED: The Personal Profile that was assigned to you has been removed by the Administrator. As result, profile changes that were about to be saved will be lost.');
   END IF;

   oldrec_ := Lock_By_Keys___(profile_id_);
   newrec_ := oldrec_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Update_Profile__;


PROCEDURE Delete_Values__ (
   profile_id_ IN VARCHAR2,
   list_       IN VARCHAR2 )
IS
   from_            NUMBER := 1;
   to_              NUMBER;
   -- The last charater in the list is used as separator
   separator_       VARCHAR2(1) := SUBSTR(list_, LENGTH(list_), 1);
   profile_section_ VARCHAR2(1000);
   profile_entry_   VARCHAR2(200);
BEGIN

   LOOP
      to_ := INSTR(list_, separator_, from_);
      IF (to_ > 0) THEN

         profile_section_ := substr(list_, from_, to_ - from_);
         from_ := to_ + 1;

         to_ := INSTR(list_, separator_, from_);
         profile_entry_ := substr(list_, from_, to_ - from_);
         from_ := to_ + 1;

         Fndrr_Client_Profile_Value_API.Delete_Value__(profile_id_, profile_section_, profile_entry_);

         IF from_ >= LENGTH(list_) THEN
            EXIT;
         END IF;

      ELSE
         EXIT;
      END IF;
   END LOOP;
END Delete_Values__;


PROCEDURE Set_Values__ (
   profile_id_ IN VARCHAR2,
   list_       IN VARCHAR2 )
IS
   from_            NUMBER := 1;
   to_              NUMBER;
   -- The last charater in the list is used as separator
   separator_       VARCHAR2(1) := SUBSTR(list_, LENGTH(list_), 1);
   profile_section_ VARCHAR2(1000);
   profile_entry_   VARCHAR2(200);
   profile_value_   VARCHAR2(4000);
BEGIN

   LOOP
      to_ := INSTR(list_, separator_, from_);
      IF (to_ > 0) THEN

         profile_section_ := substr(list_, from_, to_ - from_);
         from_ := to_ + 1;

         to_ := INSTR(list_, separator_, from_);
         profile_entry_ := substr(list_, from_, to_ - from_);
         from_ := to_ + 1;

         to_ := INSTR(list_, separator_, from_);
         profile_value_ := substr(list_, from_, to_ - from_);
         from_ := to_ + 1;

         Fndrr_Client_Profile_Value_API.Set_Value__(profile_id_, profile_section_, profile_entry_, profile_value_);

         IF from_ >= LENGTH(list_) THEN
            EXIT;
         END IF;

      ELSE
         EXIT;
      END IF;
   END LOOP;
END Set_Values__;


PROCEDURE Remove_Owner_Profiles__ (
   owner_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM FNDRR_CLIENT_PROFILE_TAB
      WHERE owner = owner_;
END Remove_Owner_Profiles__;


PROCEDURE Create_Personal__ (
   profile_id_ OUT VARCHAR2,
   profile_name_ IN VARCHAR2,
   owner_ IN VARCHAR2 )
IS
BEGIN
   Create_Profile___(profile_id_, profile_name_, owner_);
END Create_Personal__;


PROCEDURE Make_Profile_Base__ (
   profile_id_ IN VARCHAR2 )
IS
   oldrec_     FNDRR_CLIENT_PROFILE_TAB%ROWTYPE;
   newrec_     FNDRR_CLIENT_PROFILE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN

   -- Check if the profile is already a base profile.
   IF Get_Owner(profile_id_) IS NOT NULL THEN
      -- The profile is a personal profile. Check if it's not used by any user.
      Fndrr_Client_Profile_UtiL_API.Check_Personal_Profile_Used__(profile_id_);

      -- Profile can be used as a Base Profile -> Clear the OWNER attribute
      Client_SYS.Add_To_Attr('OWNER', '', attr_);
      oldrec_ := Lock_By_Keys___(profile_id_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Make_Profile_Base__;


PROCEDURE Make_Profile_Personal__ (
   profile_id_ IN VARCHAR2,
   owner_ IN VARCHAR2 )
IS
   indrec_        Indicator_Rec;
   oldrec_        FNDRR_CLIENT_PROFILE_TAB%ROWTYPE;
   newrec_        FNDRR_CLIENT_PROFILE_TAB%ROWTYPE;
   attr_          VARCHAR2(2000);
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   current_owner_ FNDRR_CLIENT_PROFILE_TAB.owner%TYPE := Get_Owner(profile_id_);
BEGIN

   IF (current_owner_ IS NULL) OR (current_owner_ != owner_) THEN
      -- Check if the owner is different from the current one.
      IF (current_owner_ IS NULL) THEN
         -- The profile is a base profile. Check if it's not used by any user.
         Fndrr_Client_Profile_UtiL_API.Check_Base_Profile_Used__(profile_id_);
      ELSE
         -- The profile is a personal profile. Check if it's not used by any user.
         Fndrr_Client_Profile_UtiL_API.Check_Personal_Profile_Used__(profile_id_);
      END IF;

      -- Profile should be used as a Personal Profile.
      Client_SYS.Add_To_Attr('OWNER', owner_, attr_);
      oldrec_ := Lock_By_Keys___(profile_id_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;

END Make_Profile_Personal__;

PROCEDURE Insert_New_Profile__ (objid_      OUT    VARCHAR2,
                                objversion_ OUT    VARCHAR2,
                                newrec_  IN OUT FNDRR_CLIENT_PROFILE_TAB%ROWTYPE)
IS  
BEGIN
   newrec_.rowversion := 1;
   newrec_.rowkey := sys_guid();   
   INSERT
         INTO fndrr_client_profile_tab
         VALUES newrec_
         RETURNING rowid INTO objid_;
      objversion_ := to_char(newrec_.rowversion);
   EXCEPTION
      WHEN dup_val_on_index THEN
         DECLARE
            constraint_ VARCHAR2(4000) := Utility_SYS.Between_Str(Utility_SYS.Between_Str(sqlerrm, '(', ')'), '.', ')', 'FALSE');
         BEGIN
            IF (constraint_ = 'FNDRR_CLIENT_PROFILE_RK') THEN
               Error_SYS.Rowkey_Exist(lu_name_, newrec_.rowkey);
            ELSE
               Raise_Record_Exist___(newrec_);
            END IF;
         END;
END Insert_New_Profile__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Objversion (
   profile_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ FNDRR_CLIENT_PROFILE_TAB.rowversion%TYPE;
   CURSOR get_attr IS
      SELECT rowversion
      FROM FNDRR_CLIENT_PROFILE_TAB
      WHERE profile_id = profile_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Objversion;


