-----------------------------------------------------------------------------
--
--  Logical unit: UserAllowedSite
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210302  LaDelk  PR21R2-31, Added parameter userid_ for Get_Default_Site and added function Get_Default_Site_In_Company.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  190506  Rakuse  TEUXXCC-2149, Added procedure Is_Authorized.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.--  141203  ErFelk  PRSC-4525, override method Raise_Record_Not_Exist___() so that customize message RECNOTEXIST 
--  141203          is raised instead of the generic message.
--  140619  DaZase  PRSC-1207, Changed Create_Data_Capture_Lov so it now only uses ORDER BY ASC.
--  130812  MaIklk  TIBE-940, Renamed cache global variables to use prefix micro_cache_.
--  121011  DaZase  Added method Create_Data_Capture_Lov.
--  110610  LEPESE  Created method New. Called method New from Connect_All_Sites_In_Company.
--  100430  Ajpelk  Merge rose method documentation
--- --------------------------Eagle------------------------------------------
--  071026  MaEelk  Bug 68104, Added procedure Exist_With_Wildcard
--  071015  MarSlk  Bug 68047, Removed the error message in method Copy_Part_To_Site.
--  070810  RoJalk  Bug 66272, Modified method Unpack_Check_Insert___ and removed unnecessary code
--  070810          which checks if default site exist for a user.
--  070404  AmPalk  Added Connect_Sites_In_Site_Cluster.
--  061023  RaKalk  Added procedure Connect_All_Sites_In_Company
--  ---------------------------- 13.4.0 -------------------------------------
--  060211  KanGlk  Modified the PROCEDURE Copy_Part_To_Site - added a new error msg "SAME_PART_SITE".
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  051208  JaBalk  Added a view USER_SITE_COMPANY_LOV in order to select user allowed sites for a company.
--  050919  NaLrlk  Removed unused variables.
--  050323  KeFelk  Added if condition of to the body of Copy_Part_To_Site.
--  050216  KeFelk  Changed the where condition of get_user_allowed_sites in Copy_Part_To_Site.
--  041209  KanGlk  Added procedure Copy_Part_To_Site
--  040225  SaNalk  Removed SUBSTRB.
--  040210  ErSolk  Bug 40350, Added procedure Remove_User_Allowed_Site.
--  -----------------------Version 13.3.0-------------------------- ---------
--  040128  LaBolk  Added methods Update_Cache___ and Invalidate_Cache___ to implement LU micro-cache.
--  040128          Modified methods Update___, Init and Authorized.
--  ------------------------------EDGE PKG GRP 2-----------------------------
--  200803  MaEelk  Performed CR Merge.
--  030528  SeKalk  Added the Enumerate Procedure
--  ************************* CR Merge **************************************
--  011003  PuIllk  Bug fix 24658, Modify Company length to VARCHAR(20) in Procedure Unpack_Check_Insert.
--  010525  JSAnse  Bug 21463, Added call to General_SYS.Init_Method in Procedures Check_Remove__, Do_Remove__
--                  and changed name in the General_SYS.Init_Method call in Procedure Check_Default_Site.
--  000925  JOHESE  Added undefines.
--  000425  ANHO  Added methods Get_User_Site_Type, Get_Default_Site, Check_Default_Site
--                and Check_User_Default_Site and removed New_User__.
--  000203  LEPE  Changes in view USER_ALLOWED_SITE_LOV to avoid
--                PL/SQL in the WHERE clause.
--  991112  LEPE  Improved Bug fix 12538, Removed non-template code from Check_Delete___.
--  991111  JOHW  Bug fix 12538, Added cascade on userid in view User_Allowed_Site.
--  990919  ROOD  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990426  DAZA  General performance improvements.
--  990413  JOHW  Upgraded to performance optimized template.
--  980921  JOKE  Moved "Close Cursor" in Authorized above return-statements.
--  980527  LEPE  Added new function Is_Authorized for better performance.
--  971208  JOKE  Converted to Foundation1 2.0.0 (32-bit).
--  970610  PELA  Removed call to New__ in procedure New_User.
--  970605  PEKR  Added public Check_Exist.
--  970508  LEPE  Added comment on Site Description in LOV view.
--  970313  MAGN  Changed tablename from mpc_user_contract to user_allowed_site_tab.
--  970226  MAGN  Uses column rowversion as objversion(timestamp).
--  961214  JOKE  Modified with new workbench default templates.
--  961210  JOHNI Removed function Authorized_Batch_User.
--  961210  JOHNI Replaced USER by Utility_SYS.Get_User.
--  961119  JOKE  Modified for workbench.
--  961014  MAOR  Added function Authorized_Batch_User.
--  960814  LEPE  Removed all functionality for UserProfileSys.
--  960813  LEPE  Removed illegal exist check against own view on insert
--  960726  AnAr  Added procedure Enumerate_User_Site.
--  960610  JOBE  Added functionality to CONTRACT.
--  960603  RaKu  Removed call to User_Default_API.Refresh_User_Profile
--  960603  RaKu  Added a LOV view and function Authorized (copy from ver 10.02)
--                Changed error message in procedure Exist (also copied)
--  960517  AnAr  Added purpose comment to file.
--  960506  SHVE  Added function Set_Contract.
--  960307  SHVE  Changed LU Name GenUserContract.
--  951205  JN    Created procedure Remove_All. Deletes all sites for user.
--                Created procedure New. Used to create site for user.
--                Added call for Refresh_user_profile when inserting or
--                deleting.
--                Check if site is used as default site for user. Then
--                remove is not allowed.
--  951128  xxxx  Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


separator_       CONSTANT  VARCHAR2(1)  := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('USER_SITE_TYPE_DB','NOT DEFAULT SITE',attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT USER_ALLOWED_SITE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (Check_User_Default_Site(newrec_.userid)) THEN
      IF (newrec_.user_site_type = 'DEFAULT SITE') THEN
         UPDATE user_allowed_site_tab
            SET user_site_type = 'NOT DEFAULT SITE',
                rowversion = sysdate
            WHERE userid = newrec_.userid
              AND user_site_type = 'DEFAULT SITE';
      END IF;
   ELSE
      newrec_.user_site_type := 'DEFAULT SITE';
   END IF;

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     USER_ALLOWED_SITE_TAB%ROWTYPE,
   newrec_     IN OUT USER_ALLOWED_SITE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.user_site_type = 'DEFAULT SITE') THEN
      UPDATE user_allowed_site_tab
         SET user_site_type = 'NOT DEFAULT SITE',
             rowversion = sysdate
         WHERE userid = newrec_.userid
           AND user_site_type = 'DEFAULT SITE';
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN USER_ALLOWED_SITE_TAB%ROWTYPE )
IS
BEGIN
   IF (Check_Not_Default_Site(remrec_.userid)) AND (remrec_.user_site_type = 'DEFAULT SITE') THEN
      Error_SYS.Record_General(lu_name_ , 'DELETEDEFAULTSITE: It is not possible to remove the default site when other sites exists for the user.');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT user_allowed_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   company_ VARCHAR2(20);
BEGIN
   super(newrec_, indrec_, attr_);

   company_ := Site_API.Get_Company(newrec_.contract);

   IF NOT (User_Finance_API.Check_User(company_, newrec_.userid)) THEN
      Error_SYS.Record_General(lu_name_ , 'CHECKUSER: User :P1 is not connected to company :P2.', newrec_.userid, company_);
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   userid_   IN VARCHAR2,
   contract_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, 'RECNOTEXIST: Site :P1 is not allowed for User :P2',contract_, userid_);
   super(userid_, contract_);   
END Raise_Record_Not_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Remove__
--   This is used to check whether the sites are allowed to be removed
--   from the connected user.
PROCEDURE Check_Remove__ (
   userid_ IN VARCHAR2 )
IS
   key_        VARCHAR2(2000);
   CURSOR get_rec IS
      SELECT *
      FROM USER_ALLOWED_SITE_TAB
      WHERE userid = userid_;
BEGIN
   FOR remrec_ IN get_rec LOOP
      key_ := remrec_.userid || '^' || remrec_.contract || '^';
      Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
   END LOOP;
END Check_Remove__;


-- Do_Remove__
--   This will remove all sites connected to a given user.
PROCEDURE Do_Remove__ (
   userid_ IN VARCHAR2 )
IS
   key_        VARCHAR2(2000);
   objid_      USER_ALLOWED_SITE.objid%TYPE;
   objversion_ USER_ALLOWED_SITE.objversion%TYPE;

   CURSOR get_rec IS
      SELECT *
      FROM USER_ALLOWED_SITE_TAB
      WHERE userid = userid_;
BEGIN
   FOR remrec_ IN get_rec LOOP
      key_ := remrec_.userid || '^' || remrec_.contract || '^';
      Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
      Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.userid, remrec_.contract);
      DELETE
         FROM  user_allowed_site_tab
         WHERE rowid = objid_;
   END LOOP;
END Do_Remove__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Authorized
--   Check if user is authorized for this site.
--   If user is authorized then return contract sent in else return null.
@UncheckedAccess
FUNCTION Authorized (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   user_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   Update_Cache___(user_, contract_);
   RETURN micro_cache_value_.contract;
END Authorized;


-- Check_Exist
--   Public check exist. Used in batches where
--   Fnd_Session_API.Get_Fnd_User isn't correctly reachable.
@UncheckedAccess
FUNCTION Check_Exist (
   userid_ IN VARCHAR2,
   contract_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Check_Exist___(userid_, contract_));
END Check_Exist;


-- Is_Authorized
--   Check if user is authorized for this site.
--   If user is authorized return numeric value 1 else return
--   numeric value 0.
@UncheckedAccess
FUNCTION Is_Authorized (
   contract_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ = Authorized(contract_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Authorized;


-- Is_Authorized
--   Check if user is authorized for this site.
--   Raises Appl_Failure if user is not authorized.
@UncheckedAccess
PROCEDURE Is_Authorized (
   contract_ IN VARCHAR2)
IS
BEGIN
   IF (NOT (Is_Authorized(contract_) = 1)) THEN
      Error_SYS.Appl_Failure(lu_name_, err_source_ => 'User_Allowed_Site_API.Is_Authorized(contract_) = 1');
   END IF;
END Is_Authorized;


@UncheckedAccess
FUNCTION Get_Default_Site(
   userid_ IN VARCHAR2 DEFAULT Fnd_Session_API.Get_Fnd_User ) RETURN VARCHAR2
IS
--
   temp_ USER_ALLOWED_SITE_TAB.contract%TYPE;
   CURSOR get_attr IS
      SELECT contract
      FROM USER_ALLOWED_SITE_TAB
      WHERE userid = userid_
      AND   user_site_type = 'DEFAULT SITE';
BEGIN
    --
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Default_Site;

-- Get_Default_Site_In_Company
--   Get default site for the company and user.
@UncheckedAccess
FUNCTION Get_Default_Site_In_Company (
   company_ IN VARCHAR2,
   userid_  IN VARCHAR2 ) RETURN VARCHAR2
IS
    default_site_  USER_ALLOWED_SITE_TAB.contract%TYPE := Get_Default_Site(userid_);
BEGIN
   IF (company_ != Site_API.Get_Company(default_site_)) THEN
      default_site_ := NULL;
   END IF;
   RETURN(default_site_);
END Get_Default_Site_In_Company;

-- Check_Default_Site
--   Checks if the site is the default site for the user.
FUNCTION Check_Default_Site (
   userid_ IN VARCHAR2,
   contract_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_     varchar2(1);
   CURSOR check_contract IS
      SELECT 'x'
      FROM   USER_ALLOWED_SITE_TAB
      WHERE  userid   = userid_
      AND    contract = contract_
      AND    user_site_type = 'DEFAULT SITE';
BEGIN
   OPEN check_contract;
   FETCH check_contract INTO dummy_;
   IF check_contract%FOUND THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
   CLOSE check_contract;
END Check_Default_Site;


-- Check_User_Default_Site
--   Checks if the user has a default site or not.
FUNCTION Check_User_Default_Site (
   userid_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   USER_ALLOWED_SITE_TAB
      WHERE userid = userid_
      AND   user_site_type = 'DEFAULT SITE';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_User_Default_Site;


-- Check_Not_Default_Site
--   Checks if the user has sites that are not default or not.
FUNCTION Check_Not_Default_Site (
   userid_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   USER_ALLOWED_SITE_TAB
      WHERE userid = userid_
      AND   user_site_type = 'NOT DEFAULT SITE';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Not_Default_Site;


-- Enumerate
--   This will list out all sites connected to the foundation user.
@UncheckedAccess
PROCEDURE Enumerate (
   desc_list_ OUT VARCHAR2 )
IS
   descriptions_ VARCHAR2(32000);
   CURSOR get_value IS
       SELECT contract
       FROM   USER_ALLOWED_SITE_TAB
       WHERE  userid = (SELECT fnd_user FROM fnd_session);
BEGIN
   FOR rec_ IN get_value LOOP
      descriptions_ := descriptions_ || rec_.contract || separator_;
   END LOOP;
   desc_list_ := descriptions_;
END Enumerate;


-- Remove_User_Allowed_Site
--   Removes sites belonging to user.
PROCEDURE Remove_User_Allowed_Site (
   userid_  IN VARCHAR2,
   company_ IN VARCHAR2 )
IS
   site_company_ VARCHAR2(20);
   remrec_       USER_ALLOWED_SITE_TAB%ROWTYPE;
   objid_        USER_ALLOWED_SITE.objid%TYPE;
   objversion_   USER_ALLOWED_SITE.objversion%TYPE;

   CURSOR get_sites IS
   SELECT contract
   FROM   USER_ALLOWED_SITE_TAB
   WHERE  userid = userid_;
BEGIN
   FOR rec_ IN get_sites LOOP
      site_company_ := Site_API.Get_Company(rec_.contract);
      IF (site_company_ = company_) THEN
         Get_Id_Version_By_Keys___ (objid_, objversion_, userid_, rec_.contract);
         remrec_ := Lock_By_Id___(objid_, objversion_);
         Check_Delete___(remrec_);
         Delete___(objid_, remrec_);
      END IF;
   END LOOP;
END Remove_User_Allowed_Site;


-- Copy_Part_To_Site
--   This method calls the method Copy_To_Site in
--   Part_Copy_Manager_Partca_API for site in to_contract_ or
--   for all user allowed sites if to_contract_ is null.
PROCEDURE Copy_Part_To_Site (
   from_contract_     IN VARCHAR2,
   from_part_no_      IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   to_part_no_        IN VARCHAR2,
   to_part_desc_      IN VARCHAR2,
   is_background_job_ IN VARCHAR2,
   event_no_          IN NUMBER )
IS
   userid_   VARCHAR2(30);
   CURSOR get_user_allowed_sites IS
      SELECT contract
        FROM USER_ALLOWED_SITE_TAB
       WHERE userid = userid_
         AND (contract LIKE to_contract_ OR to_contract_ IS NULL);
BEGIN

   userid_ := Fnd_Session_API.Get_Fnd_User;

   FOR site_rec_ IN  get_user_allowed_sites LOOP
      IF (from_part_no_ = to_part_no_) THEN
         IF (from_contract_ != site_rec_.contract) THEN
            Part_Copy_Manager_Partca_API.Copy_To_Site(from_contract_,
                                                      from_part_no_,
                                                      site_rec_.contract,
                                                      to_part_no_,
                                                      to_part_desc_,
                                                      is_background_job_,
                                                      event_no_);         
         END IF;
      ELSE
         Part_Copy_Manager_Partca_API.Copy_To_Site(from_contract_,
                                                      from_part_no_,
                                                      site_rec_.contract,
                                                      to_part_no_,
                                                      to_part_desc_,
                                                      is_background_job_,
                                                      event_no_);
      END IF;
   END LOOP;
END Copy_Part_To_Site;


-- Connect_All_Sites_In_Company
--   Connects all the sites of the given company to the given user.
PROCEDURE Connect_All_Sites_In_Company (
   company_id_ IN VARCHAR2,
   user_id_    IN VARCHAR2 )
IS
   CURSOR get_sites IS
      SELECT contract
      FROM   site_public
      WHERE  company = company_id_;
BEGIN

   Company_Finance_API.Exist(company_id_);

   FOR site_rec_ IN get_sites LOOP
      
      NEW(user_id_, site_rec_.contract);

   END LOOP;

END Connect_All_Sites_In_Company;


-- Connect_Sites_In_Site_Cluster
--   Connects all the allowed sites of the given site cluster to the
--   given user.
PROCEDURE Connect_Sites_In_Site_Cluster (
   info_ OUT VARCHAR2,
   site_cluster_id_ IN VARCHAR2,
   user_id_ IN VARCHAR2 )
IS
      
      has_warning_msg_  BOOLEAN := FALSE;
      info_msg_         VARCHAR2(2000);
      info_msg2_        VARCHAR2(2000);
      delim_            VARCHAR2(2);
      has_default_site_ BOOLEAN;
      attr_             VARCHAR2(2000);
      newrec_           USER_ALLOWED_SITE_TAB%ROWTYPE;
      oldrec_           USER_ALLOWED_SITE_TAB%ROWTYPE;
      objid_            USER_ALLOWED_SITE.objid%TYPE;
      objversion_       USER_ALLOWED_SITE.objversion%TYPE;
      contract_         USER_ALLOWED_SITE_TAB.contract%TYPE;
      indrec_           Indicator_Rec;
      CURSOR get_sites IS
         SELECT contract
         FROM Site_Cluster_Node_Tab
         WHERE contract IS NOT NULL
         AND site_cluster_id = site_cluster_id_
         AND User_Finance_Api.Check_Exist(Site_api.Get_Company(contract),user_id_) = 'TRUE';
      CURSOR get_not_allowed_company IS
         SELECT DISTINCT(Site_api.Get_Company(contract)) comp
         FROM Site_Cluster_Node_Tab
         WHERE contract IS NOT NULL
         AND site_cluster_id = site_cluster_id_
         AND User_Finance_Api.Check_Exist(Site_api.Get_Company(contract),user_id_) != 'TRUE'
         ORDER BY comp;
      CURSOR get_sites_for_company (company_ IN VARCHAR2)IS 
         SELECT contract
         FROM Site_Cluster_Node_Tab
         WHERE contract IS NOT NULL
         AND site_cluster_id = site_cluster_id_
         AND User_Finance_Api.Check_Exist(Site_api.Get_Company(contract),user_id_) != 'TRUE'
         AND Site_api.Get_Company(contract) = company_
         ORDER BY contract;
BEGIN
   FOR site_rec_ IN get_sites LOOP
      -- Create record only if it is not there
      IF (NOT Check_Exist___(user_id_, site_rec_.contract)) THEN
         Client_SYS.Clear_Attr(attr_);
         Prepare_Insert___(attr_);
         Client_SYS.Add_To_Attr('USERID',             user_id_,            attr_);
         Client_SYS.Add_To_Attr('CONTRACT',           site_rec_.contract,  attr_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END IF;
   END LOOP;
   -- Set the first record as the default
   -- if the default is not defined
   has_default_site_ := Check_User_Default_Site(user_id_);
   IF (NOT has_default_site_) THEN
      OPEN get_sites;
      FETCH get_sites INTO contract_;
      IF get_sites%FOUND THEN
         Get_Id_Version_By_Keys___(objid_, objversion_, user_id_, contract_);
         oldrec_ := Lock_By_Id___(objid_, objversion_);
         newrec_ := oldrec_;
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('USER_SITE_TYPE_DB',  'DEFAULT SITE',   attr_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_);
      END IF;
      CLOSE get_sites;
   END IF;
   Client_SYS.Clear_Info();
   info_msg_ := NULL;
   FOR comps_not_allowed_ IN get_not_allowed_company LOOP
       info_msg2_ := NULL;
       FOR sites_not_added_ IN get_sites_for_company(comps_not_allowed_.comp) LOOP
           info_msg2_ := info_msg2_ || delim_ || sites_not_added_.contract;
           delim_ := ', ';
           has_warning_msg_ := TRUE;
       END LOOP;
       delim_ := NULL;
       info_msg2_ := info_msg2_ || ' from company ' || comps_not_allowed_.comp || '. ';
       info_msg_  := info_msg_ || info_msg2_;
   END LOOP;
   
   IF (has_warning_msg_) THEN
      Client_SYS.Add_Info(lu_name_, 'SITESNOTCONNECTED: Since the user :P1 is not connected to the following companies, these sites have not been connected. :P2', user_id_, info_msg_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Connect_Sites_In_Site_Cluster;


-- Exist_With_Wildcard
--   Give an error if the given contract is not allowed for given site.
--   Contract parameter support wildcards
PROCEDURE Exist_With_Wildcard (
   contract_ IN VARCHAR2,
   userid_   IN VARCHAR2 DEFAULT Fnd_Session_API.Get_Fnd_User )
IS
   dummy_ NUMBER;
   exist_ BOOLEAN;

   CURSOR exist_control IS
      SELECT 1
        FROM USER_ALLOWED_SITE_TAB
       WHERE userid   = userid_
         AND contract LIKE NVL(contract_,'%');
BEGIN
   
   IF (INSTR(NVL(contract_,'%'), '%') = 0) THEN
      --No wildcard
      Site_API.Exist(contract_);
      Exist(userid_, contract_);
   ELSE
      --Wildcard
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      exist_ := exist_control%FOUND;
      CLOSE exist_control;

      IF (NOT exist_) THEN
         Error_SYS.Record_Not_Exist(lu_name_, 'WILDNOTEXIST: Search criteria :P1 does not match any of the sites allowed for user :P2.',
                                    contract_, userid_);
      END IF;

   END IF;
END Exist_With_Wildcard;


PROCEDURE New (
   userid_   IN VARCHAR2,
   contract_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   newrec_     USER_ALLOWED_SITE_TAB%ROWTYPE;
   objid_      USER_ALLOWED_SITE.objid%TYPE;
   objversion_ USER_ALLOWED_SITE.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN

   IF (NOT Check_Exist___(userid_, contract_)) THEN

      Client_SYS.Add_To_Attr('USERID',   userid_,  attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);

      IF (Check_User_Default_Site(userid_)) THEN
         Client_SYS.Add_To_Attr('USER_SITE_TYPE_DB', User_Site_Type_API.DB_NOT_DEFAULT_SITE, attr_);
      ELSE
         Client_SYS.Add_To_Attr('USER_SITE_TYPE_DB', User_Site_Type_API.DB_DEFAULT_SITE, attr_);
      END IF;

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);

   END IF; 
END New;


PROCEDURE Remove (
   userid_     IN VARCHAR2,
   contract_   IN VARCHAR2 )
IS
   remrec_     user_allowed_site_tab%ROWTYPE;
BEGIN
   IF (Check_Exist___(userid_, contract_)) THEN
      remrec_ := Lock_By_Keys___(userid_, contract_);
      Check_Delete___(remrec_);
      Delete___(remrec_);
   END IF;
END Remove;


-- This method is used by DataCaptMoveHandlUnit, DataCaptureInventUtil, DataCaptureMovePart and DataCaptUnplanIssueWo
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   capture_session_id_ IN NUMBER )
IS
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;

   CURSOR get_list_of_values IS
      SELECT contract, contract_desc
      FROM   USER_ALLOWED_SITE_LOV
      ORDER BY Utility_SYS.String_To_Number(contract) ASC, contract ASC;

BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      FOR lov_rec_ IN get_list_of_values LOOP
         Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                          capture_session_id_    => capture_session_id_,
                                          lov_item_value_        => lov_rec_.contract,
                                          lov_item_description_  => lov_rec_.contract_desc,
                                          lov_row_limitation_    => lov_row_limitation_,    
                                          session_rec_           => session_rec_);
         EXIT WHEN exit_lov_;
      END LOOP;
   $ELSE
      NULL;  
   $END

END Create_Data_Capture_Lov;



