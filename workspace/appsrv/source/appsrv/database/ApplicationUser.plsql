-----------------------------------------------------------------------------
--
--  Logical unit: ApplicationUser
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960919  JaPa  Created
--  970108  JaPa  Added view
--  970418  JaPa  Changed to use FndUser
--  970904  JaPa  Added outer join to the new table APPLICATION_USER_TAB
--  040301  ThAblk  Removed substr from views.
--  ----------------------------Eagle------------------------------------------
--  100421  Ajpelk  Merge rose method documentation
--  ---------------------------- APPS 9 -------------------------------------
--  131202  jagrno  Hooks: Refactored and split code
--  131205  jagrno  Added overtake of method Check_Exist___.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Overtaken to check against joined view instead of base table
@Overtake Base
FUNCTION Check_Exist___ (
   identity_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1
      INTO  dummy_
      FROM  application_user
      WHERE identity = identity_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Check_Exist___');
END Check_Exist___;


-- Overtaken to provide special handling for update
@Overtake Base
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     APPLICATION_USER_TAB%ROWTYPE,
   newrec_     IN OUT APPLICATION_USER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   l_objid_ VARCHAR2(20);
BEGIN
   IF (newrec_.default_domain <> Application_Domain_API.Get_Default) THEN
      Insert___(l_objid_, objversion_, newrec_, attr_);
   ELSE
      Delete___(objid_, newrec_);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      newrec_.rowversion := newrec_.rowversion+1;
      IF by_keys_ THEN
         UPDATE application_user_tab
            SET ROW = newrec_
            WHERE identity = newrec_.identity;
      ELSE
         UPDATE application_user_tab
            SET ROW = newrec_
            WHERE rowid = objid_;
      END IF;
      objversion_ := to_char(newrec_.rowversion);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Objid_Pkg__
--   A private function used inside the LU to give the proper value of objid.
@UncheckedAccess
FUNCTION Get_Objid_Pkg__ (
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN substr(objversion_, 1, instr(objversion_,'~')-1);
END Get_Objid_Pkg__;


-- Get_Objversion_Pkg__
--   A private function used inside the LU to give the proper value of objversion.
@UncheckedAccess
FUNCTION Get_Objversion_Pkg__ (
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN substr(objversion_, instr(objversion_,'~',1,2)+1);
END Get_Objversion_Pkg__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Get_Web_User_Identity_ (
   web_user_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_User_API.Get_Web_User_Identity_(web_user_);
END Get_Web_User_Identity_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_User_API.Get_Description(identity_);
END Get_Description;


@UncheckedAccess
FUNCTION Get_Property (
   identity_ IN VARCHAR2,
   name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_User_API.Get_Property(identity_, name_);
END Get_Property;


@UncheckedAccess
FUNCTION Get_Current_User RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Session_API.Get_Fnd_User;
END Get_Current_User;
