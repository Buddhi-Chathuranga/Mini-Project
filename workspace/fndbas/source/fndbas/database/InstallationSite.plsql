-----------------------------------------------------------------------------
--
--  Logical unit: InstallationSite
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000101  JhMa    Created.
--  000621  ROOD    Modified parameters in Get_Timezone_Difference_.
--  000628  ROOD    Changes in error handling.
--  000808  ROOD    Completed the upgrade to Yoshimura template (Bug#15811).
--  020128  ROOD    Modified view and business logic to handle
--                  attribute translations (ToDo#4070).
--  020702  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  100714  USRA    Moved ALL_DB_LINKS_LOV from BUSPER module and made minor changes to match the new template (Bug#91935)
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
   Client_SYS.Add_To_Attr('TIMEZONE_DIFFERENCE', 0, attr_);
   Client_SYS.Add_To_Attr('THIS_SITE', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INSTALLATION_SITE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF ( newrec_.timezone_difference IS NULL ) THEN
      newrec_.timezone_difference := 0;
   END IF;
   IF ( NVL(newrec_.this_site,'FALSE') NOT IN ('TRUE','FALSE') ) THEN
      newrec_.this_site := 'FALSE';
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     INSTALLATION_SITE_TAB%ROWTYPE,
   newrec_     IN OUT INSTALLATION_SITE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF ( newrec_.timezone_difference IS NULL ) THEN
      newrec_.timezone_difference := 0;
   END IF;
   IF ( NVL(newrec_.this_site,'FALSE') NOT IN ('TRUE','FALSE') ) THEN
      newrec_.this_site := 'FALSE';
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT installation_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   this_site_exist_ EXCEPTION;
BEGIN
   newrec_.timezone_difference := 0;
   IF ( (UPPER(NVL(newrec_.this_site, 'FALSE')) = 'TRUE') AND This_Site_Exist__ ) THEN
      RAISE this_site_exist_;
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN this_site_exist_ THEN
      Error_SYS.Appl_General(lu_name_, 'EXIST_INSERT: Only one replication site can be THIS_SITE.');
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     installation_site_tab%ROWTYPE,
   newrec_ IN OUT installation_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   this_site_exist_  EXCEPTION;
BEGIN
   IF ( (UPPER(NVL(newrec_.this_site, 'FALSE')) = 'TRUE') AND (oldrec_.this_site = 'FALSE') AND This_Site_Exist__ ) THEN
      RAISE this_site_exist_;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN this_site_exist_ THEN
      Error_SYS.Appl_General(lu_name_, 'EXIST_INSERT: Only one replication site can be THIS_SITE.');
END Check_Update___;

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   site_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(Installation_Site_API.lu_name_, p1_ => site_id_);
   super(site_id_);
END Raise_Record_Not_Exist___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION This_Site_Exist__ RETURN BOOLEAN
IS
   dummy_    NUMBER;
   CURSOR this_site_exist IS
      SELECT 1
      FROM   INSTALLATION_SITE_TAB
      WHERE  this_site = 'TRUE';
BEGIN
   OPEN this_site_exist;
   FETCH this_site_exist INTO dummy_;
   IF ( this_site_exist%FOUND ) THEN
      CLOSE this_site_exist;
      RETURN TRUE;
   ELSE
      CLOSE this_site_exist;
      RETURN FALSE;
   END IF;
END This_Site_Exist__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

FUNCTION Get_Timezone_Difference_ (
   site_id_ IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   timezone_difference_error_ EXCEPTION;
   timezone_difference_       INSTALLATION_SITE_TAB.timezone_difference%TYPE;
   CURSOR local_time IS
      SELECT timezone_difference
      FROM   INSTALLATION_SITE_TAB
      WHERE  this_site = 'TRUE';
   CURSOR remote_time IS
      SELECT timezone_difference
      FROM   INSTALLATION_SITE_TAB
      WHERE  site_id = site_id_;
BEGIN
   IF ( site_id_ IS NULL ) THEN
      OPEN local_time;
      FETCH local_time INTO timezone_difference_;
      IF ( local_time%NOTFOUND ) THEN
         timezone_difference_ := 0;
      END IF;
      CLOSE local_time;
   ELSE
      OPEN remote_time;
      FETCH remote_time INTO timezone_difference_;
      IF ( remote_time%NOTFOUND ) THEN
         timezone_difference_ := 0;
      END IF;
      CLOSE remote_time;
   END IF;
   IF ( ABS(timezone_difference_) > 24 ) THEN
      RAISE timezone_difference_error_;
   END IF;
   RETURN timezone_difference_;
EXCEPTION
   WHEN timezone_difference_error_ THEN
      Error_SYS.Appl_General(lu_name_, 'INVALIDTIMEZONEDIFF: Invalid timezone difference :P1.', timezone_difference_);
END Get_Timezone_Difference_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

