-----------------------------------------------------------------------------
--
--  Logical unit: DistributionGroup
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960414  MANY  Base Table to Logical Unit Generator 1.0A
--  970212  MANY  Changed list lengths from 2000 to 32000 characters.
--  970806  MANY  Chenges concerning new user concept FndUser
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  020703  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

field_separator_ CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DISTRIBUTION_GROUP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.owner := Fnd_Session_API.Get_Fnd_User;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Get_Protection__ (
   protection_  OUT VARCHAR2,
   group_name_  IN  VARCHAR2 )
IS
BEGIN
   SELECT Distribution_Group_Prot_API.Encode(protection)
      INTO  protection_
      FROM  distribution_group
      WHERE group_name = group_name_;
END Get_Protection__;


PROCEDURE Get_User_List__ (
   user_list_         OUT VARCHAR2,
   distribution_list_ IN  VARCHAR2 )
IS
   from_    NUMBER;
   to_      NUMBER;
   member_  VARCHAR2(30);
   users_   VARCHAR2(32000);
BEGIN
   from_ := 1;
   to_ := instr(distribution_list_, field_separator_);
   WHILE (to_ > 0) LOOP
      member_ := substr(distribution_list_, from_, to_ - from_);
      IF (Is_User(member_)) THEN
         users_ := users_ || member_ || field_separator_;
      ELSIF (Is_Group(member_)) THEN
         users_ := users_ || Distribution_Group_Member_API.Get_Members(member_) || field_separator_;
      END IF;
      from_ := to_ + 1;
      to_ := instr(distribution_list_, field_separator_, from_);
   END LOOP;
   user_list_ := users_;
END Get_User_List__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New_Group (
   group_name_  IN VARCHAR2,
   description_ IN VARCHAR2,
   protection_  IN VARCHAR2,
   user_list_   IN VARCHAR2 )
IS
BEGIN
   IF (Check_Exist___(group_name_)) THEN
      Error_SYS.Appl_General(DISTRIBUTION_GROUP_API.lu_name_, 'GRPEXIST: Distribution Group [:P1] already exist', group_name_);
   END IF;
   INSERT INTO distribution_group_tab(group_name, protection, owner, description, rowversion) VALUES
      (group_name_, protection_, Fnd_Session_API.Get_Fnd_User, description_, sysdate);
   Distribution_Group_Member_API.New_Members(group_name_, user_list_);
END New_Group;


PROCEDURE Modify_Group (
   group_name_  IN VARCHAR2,
   description_ IN VARCHAR2,
   protection_  IN VARCHAR2,
   user_list_   IN VARCHAR2 )
IS
BEGIN
   IF (Check_Exist___(group_name_)) THEN
      UPDATE distribution_group_tab
         SET   description = description_,
               protection = protection_
         WHERE group_name = group_name_;
      Distribution_Group_Member_API.Modify_Members(group_name_, user_list_);
   ELSE
      Error_SYS.Appl_General(DISTRIBUTION_GROUP_API.lu_name_, 'GRPREM: Distribution Group [:P1] has been removed', group_name_);
   END IF;
END Modify_Group;


PROCEDURE Remove_Group (
   group_name_ IN VARCHAR2 )
IS
BEGIN
   IF (Check_Exist___(group_name_)) THEN
      Distribution_Group_Member_API.Remove_Members(group_name_);
      DELETE FROM distribution_group_tab
         WHERE group_name = group_name_;
   ELSE
      Error_SYS.Appl_General(DISTRIBUTION_GROUP_API.lu_name_, 'GRPREM: Distribution Group [:P1] has been removed', group_name_);
   END IF;
END Remove_Group;


@UncheckedAccess
PROCEDURE Enumerate_Group (
   group_list_ OUT VARCHAR2 )
IS
   groups_ VARCHAR2(32000);
   CURSOR distr_groups IS
      SELECT group_name, description
      FROM   distribution_group
      ORDER BY group_name;
BEGIN
   FOR current_group IN distr_groups LOOP
      groups_ := groups_ || current_group.group_name || field_separator_;
   END LOOP;
   group_list_ := groups_;
END Enumerate_Group;


@UncheckedAccess
FUNCTION Is_Group (
   group_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_  NUMBER;
   CURSOR exist_group IS
      SELECT 1
      FROM  distribution_group
      WHERE group_name = group_name_;
BEGIN
   OPEN exist_group;
   FETCH exist_group INTO dummy_;
   IF (exist_group%FOUND) THEN
      CLOSE exist_group;
      RETURN (TRUE);
   END IF;
   CLOSE exist_group;
   RETURN(FALSE);
END Is_Group;


FUNCTION Is_User (
   user_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   Fnd_User_API.Exist(user_name_);
   RETURN (TRUE);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (FALSE);
END Is_User;


PROCEDURE Validate_Distribution_List (
   distribution_list_ IN VARCHAR2)
IS
   from_        NUMBER;
   to_          NUMBER;
   member_      VARCHAR2(30);
   user_name_   VARCHAR2(30);
   group_list_  VARCHAR2(32000);
   group_from_  NUMBER;
   group_to_    NUMBER;
   any_success_ BOOLEAN := FALSE;
   any_error_   BOOLEAN := FALSE;
BEGIN
   from_ := 1;
   to_ := instr(distribution_list_, field_separator_, from_);
   WHILE (to_ > 0) LOOP
      member_ := substr(distribution_list_, from_, to_ - from_);
      IF (Distribution_Group_API.Is_Group(member_)) THEN
         Distribution_Group_Member_API.Get_Members(group_list_, member_);
         group_from_ := 1;
         group_to_ := instr(group_list_, field_separator_, group_from_);
         WHILE (group_to_ > 0)LOOP
            user_name_ := substr(group_list_, group_from_, group_to_ - group_from_);
            IF (Distribution_Group_API.Is_User(user_name_)) THEN
               any_success_ := TRUE;
            ELSE
               any_error_ := TRUE;
            END IF;
            group_from_ := group_to_ + 1;
            group_to_ := instr(group_list_, field_separator_, group_from_);
         END LOOP;
      ELSIF (Distribution_Group_API.Is_User(member_)) THEN
         any_success_ := TRUE;
      ELSE
         any_error_ := TRUE;
      END IF;
      from_ := to_ + 1;
      to_ := instr(distribution_list_, field_separator_, from_);
   END LOOP;
   IF any_error_ THEN
      Error_SYS.Appl_General(DISTRIBUTION_GROUP_API.lu_name_, 'VALDISTR: Invalid distributionlist ":P1".',
                             distribution_list_);
   END IF;
END Validate_Distribution_List;


@UncheckedAccess
PROCEDURE Get_Membership (
   is_member_   OUT NUMBER,
   group_name_  IN  VARCHAR2 )
IS
BEGIN
   IF (Distribution_Group_Member_API.Is_Member__(group_name_, Fnd_Session_API.Get_Fnd_User)) THEN
      is_member_ := 1;
   ELSE
      is_member_ := 0;
   END IF;
END Get_Membership;


@UncheckedAccess
PROCEDURE Get_Owner (
   owner_       OUT VARCHAR2,
   group_name_  IN  VARCHAR2 )
IS
BEGIN
   owner_ := Distribution_Group_API.Get_Owner(group_name_);
END Get_Owner;


PROCEDURE Get_Description (
   description_ OUT VARCHAR2,
   group_name_  IN  VARCHAR2 )
IS
BEGIN
   Exist(group_name_);
   description_ := Distribution_Group_API.Get_Description(group_name_);
END Get_Description;



