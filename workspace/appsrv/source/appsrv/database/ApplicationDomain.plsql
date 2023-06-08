-----------------------------------------------------------------------------
--
--  Logical unit: ApplicationDomain
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961121  JaPa  Created
--  961212  JaPa  Changed LU-name and short name due to conflict with FNDSRV
--  970506  JaPa  New function GetDefault()
--  970904  JaPa  Not possible to update def_domain flag
--  971125  JaPa  Possible to update def_domain flag from FALSE till TRUE
--  971203  JaPa  Added call to Init_Method() in Set_Current()
--  --------------------------Eagle------------------------------------------
--  100421  Ajpe  Merge rose method documentation
--  ---------------------------- APPS 9 -------------------------------------
--  130618  heralk  Scalability Changes - removed global variables.
--  130906  chanlk  Corrected model file errors.
--  131126  jagrno  Hooks: Refactored and split code. Converted from very old design 
--                  template which means that all generated methods have been updated
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
   Client_SYS.Add_To_Attr('DEF_DOMAIN', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT APPLICATION_DOMAIN_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Check_Def_Domain___(newrec_.def_domain, null, null);
   --
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     APPLICATION_DOMAIN_TAB%ROWTYPE,
   newrec_     IN OUT APPLICATION_DOMAIN_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_Def_Domain___(newrec_.def_domain, oldrec_.def_domain, objid_);
   --
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


PROCEDURE Check_Def_Domain___ (
   def_domain_  IN VARCHAR2,
   old_default_ IN VARCHAR2,
   objid_       IN VARCHAR2 )
IS
   CURSOR def_dom IS
      SELECT   rowid objid, TO_CHAR(rowversion) objversion
         FROM  APPLICATION_DOMAIN_TAB
         WHERE def_domain  = 'TRUE'
         AND   rowid||'' <> nvl(objid_,chr(0));
BEGIN
   Trace_SYS.message('APPLICATION_DOMAIN_API.Check_Def_Domain___('||def_domain_||','||old_default_||')');
   IF def_domain_ = 'TRUE' THEN
      FOR d IN def_dom LOOP
         Error_SYS.Record_General(lu_name_, 'DEFDOMEX: Default domain already exists.');
      END LOOP;
   ELSIF nvl(old_default_,'FALSE') = 'TRUE' THEN
      Error_SYS.Item_Update(lu_name_, 'DEF_DOMAIN');
   END IF;
END Check_Def_Domain___;


FUNCTION Get_Domain_Id___  RETURN VARCHAR2
IS
   current_domain_id_   APPLICATION_DOMAIN_TAB.DOMAIN_ID%type;
BEGIN
   SELECT   min(domain_id)
      INTO  current_domain_id_
      FROM  APPLICATION_DOMAIN_TAB
      WHERE def_domain = 'TRUE';
   RETURN current_domain_id_;
END Get_Domain_Id___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Is_Default
--   Returns TRUE if the domain is the default one.
@UncheckedAccess
FUNCTION Is_Default (
   domain_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   lu_rec_ APPLICATION_DOMAIN_TAB%ROWTYPE;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(domain_id_);
   RETURN lu_rec_.def_domain;
END Is_Default;


-- Set_Current
--   Sets server cache variable to the value of the domain id.
--   Works with GetCurrent().
PROCEDURE Set_Current (
   domain_id_ IN VARCHAR2 )
IS
BEGIN
   App_Context_SYS.Set_Value('Application_Domain_api.Current_Domain_Id',domain_id_);
END Set_Current;


@UncheckedAccess
FUNCTION Get_Current RETURN VARCHAR2
IS
   current_domain_id_  APPLICATION_DOMAIN_TAB.DOMAIN_ID%type;
BEGIN
   IF(App_Context_SYS.Exists('Application_Domain_api.Current_Domain_Id')) THEN
      current_domain_id_ := App_Context_SYS.Get_Value('Application_Domain_api.Current_Domain_Id');
   ELSE
      current_domain_id_ := Get_Domain_Id___;
   END IF;
   RETURN current_domain_id_;
END Get_Current;


@UncheckedAccess
FUNCTION Get_Default RETURN VARCHAR2
IS
   domain_id_  APPLICATION_DOMAIN_TAB.domain_id%TYPE;
   CURSOR get_dom IS
      SELECT   domain_id
         FROM  APPLICATION_DOMAIN_TAB
         WHERE def_domain = 'TRUE';
BEGIN
   OPEN get_dom;
   FETCH get_dom INTO domain_id_;
   IF (get_dom%NOTFOUND) THEN
      CLOSE get_dom;
      RETURN null;
   END IF;
   CLOSE get_dom;
   RETURN domain_id_;
END Get_Default;
