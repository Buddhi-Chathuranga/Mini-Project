-----------------------------------------------------------------------------
--
--  Logical unit: DistributionGroupMember
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960414  MANY  Base Table to Logical Unit Generator 1.0A
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  020703  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--                Minor performance improvement in Is_Member__.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  0500628 UTGULK Added cascade reference to FndUser.(Bug#48562
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

field_separator_ CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Is_Member__ (
   group_name_ IN VARCHAR2,
   user_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   found_ BOOLEAN;
   CURSOR get_member IS
      SELECT 1
      FROM  distribution_group_member
      WHERE group_name = group_name_
      AND   member = user_name_;
BEGIN
   OPEN get_member;
   FETCH get_member INTO dummy_;
   found_ := get_member%FOUND;
   CLOSE get_member;
   RETURN found_;
END Is_Member__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Get_Members (
   user_list_  OUT VARCHAR2,
   group_name_ IN VARCHAR2 )
IS
   users_ VARCHAR2(2000);
   CURSOR group_members IS
      SELECT *
      FROM  DISTRIBUTION_GROUP_MEMBER_TAB
      WHERE group_name = upper(group_name_);
BEGIN
   FOR group_rec IN group_members LOOP
      users_ := users_ || group_rec.member || field_separator_;
   END LOOP;
   user_list_ := users_;
END Get_Members;


@UncheckedAccess
FUNCTION Get_Members (
   group_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   users_ VARCHAR2(2000);
   CURSOR group_members IS
      SELECT *
      FROM  DISTRIBUTION_GROUP_MEMBER_TAB
      WHERE group_name = upper(group_name_);
BEGIN
   FOR group_rec IN group_members LOOP
      users_ := users_ || group_rec.member || field_separator_;
   END LOOP;
   RETURN (users_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END Get_Members;


PROCEDURE Modify_Members (
   group_name_ IN VARCHAR2,
   user_list_  IN VARCHAR2 )
IS
   CURSOR get_members IS
      SELECT member, description
      FROM   DISTRIBUTION_GROUP_MEMBER_TAB
      WHERE  group_name = group_name_
      FOR UPDATE;
   users_ VARCHAR2(2000);
   from_   NUMBER;
   to_     NUMBER;
   member_ VARCHAR2(30);
BEGIN
   users_ := field_separator_ || user_list_;
   FOR members IN get_members LOOP
      IF (instr(users_, field_separator_ || members.member || field_separator_) > 0) THEN
         users_ := replace(users_, field_separator_ || members.member || field_separator_, field_separator_);
      ELSE
         DELETE FROM distribution_group_member_tab
            WHERE group_name = group_name_
            AND   member = members.member;
      END IF;
   END LOOP;
   users_ := ltrim(users_, field_separator_);
   from_ := 1;
   to_ := instr(users_, field_separator_, from_);
   WHILE (to_ > 0) LOOP
      member_ := substr(users_, from_, to_ - from_);
      INSERT INTO distribution_group_member_tab (group_name, member, description, rowversion)
         VALUES (group_name_, member_, NULL, sysdate);
      from_ := to_ + 1;
      to_ := instr(users_, field_separator_, from_);
   END LOOP;
END Modify_Members;


PROCEDURE New_Members (
   group_name_ IN VARCHAR2,
   user_list_  IN VARCHAR2 )
IS
   from_ NUMBER;
   to_   NUMBER;
BEGIN
   from_ := 1;
   to_ := instr(user_list_, field_separator_, from_);
   WHILE (to_ > 0) LOOP
      INSERT INTO DISTRIBUTION_GROUP_MEMBER_TAB (group_name, member, description, rowversion)
         VALUES (group_name_, substr(user_list_, from_, to_ - from_), NULL, sysdate);
      from_ := to_ + 1;
      to_ := instr(user_list_, field_separator_, from_);
   END LOOP;
END New_Members;


PROCEDURE Remove_Members (
   group_name_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM DISTRIBUTION_GROUP_MEMBER_TAB
      WHERE group_name = group_name_;
END Remove_Members;



