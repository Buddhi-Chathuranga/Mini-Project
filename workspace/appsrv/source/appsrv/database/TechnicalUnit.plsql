-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalUnit
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960617  JoRo  Created
--  960904  RoHi  Changed Description to unformatted
--  970219  frtv  Upgraded.
--  970417  JaPa  Changed to use IsoUnit
--  980330  JaPa  Added option /NOCHECK on view column unit due to reference
--                problem.
--  040301  ThAblk Removed substr from views.
--  070508  UtGulk Changed description to use basic data translation in view TECHNICAL_UNIT.(Bug#65239)
--  130925  chanlk Corrected model file errors
--  ---------------------------- APPS 9 -------------------------------------
--  131129  jagrno  Hooks: Refactored and split code. This LU is referenced from multiple
--                  other LU's, and can thus not be changed into a Utility LU even though 
--                  that would be best. All base methods have been re-introduced, but all
--                  editing is prevented through error messages. All attributes are made 
--                  not insertable and not updateable
--  131205  jagrno  Made the entity read-only.
--  131211  jagrno  Made the entity abstract. Re-introduced methods Lock__, New__, Modify__
--                  and Remove__ for backward compatibility.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Lock__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTISOUNIT: Action not allowed in this LU');
END Lock__;


PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTISOUNIT: Action not allowed in this LU');
END New__;


PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTISOUNIT: Action not allowed in this LU');
END Modify__;


PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTISOUNIT: Action not allowed in this LU');
END Remove__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Exist (
   unit_ IN VARCHAR2 )
IS
BEGIN
   Iso_Unit_API.Exist(unit_);
END Exist;


@UncheckedAccess
FUNCTION Get_Description (
   unit_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Iso_Unit_API.Get_Description(unit_);
END Get_Description;
