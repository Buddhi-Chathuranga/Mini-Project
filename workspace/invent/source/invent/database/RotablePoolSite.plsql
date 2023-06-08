-----------------------------------------------------------------------------
--
--  Logical unit: RotablePoolSite
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180809  ShPrlk   Bug 143390, Added UncheckedAccess annotation to method Check_Exist to avoid populate error
--  180809           for read only users.
--  120106  NaLrlk   Added methods New and Remove.
--  110715  MaEelk   Added user allowed site filter to ROTABLE_POOL_SITE.
--  100505  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  080130  HoInlk   Bug 70231, Added method Get_Default_Contract to return the contract when
--  080130           only one record exists for a rotable_part_pool_id.
--  060119  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060119           and added UNDEFINE according to the new template.
--  --------------------------------- 13.3.0 --------------------------------
--  031014  PrJalk   Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  030514  MaGulk   Added validations for Fixed Asset pools in Unpack_Check_Insert___
--  030429  MaGulk   Added validations to check user is alowed for site added or removed
--  030424  MaGulk   Added Check_Exist public method
--  030423  MaGulk   Rearranged columns
--  030410  MaGulk   Created
--  030522  Nithlk   WP 204 Rotables -  Create FA Object.Added Get_Company
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN ROTABLE_POOL_SITE_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   IF (User_Allowed_Site_API.Is_Authorized(remrec_.contract) = 0) THEN
      Error_SYS.Record_General('RotablePoolSite', 'SITENOTALLOWED: Site :P1 is not allowed for the user.', remrec_.contract);
   END IF;
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT rotable_pool_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   poolrec_  Rotable_Part_Pool_API.Public_Rec;
   site_     VARCHAR2(5);
   company_  VARCHAR2(20);

   CURSOR get_contract IS
      SELECT contract
      FROM   ROTABLE_POOL_SITE_TAB
      WHERE  rotable_part_pool_id = newrec_.rotable_part_pool_id;
BEGIN
   super(newrec_, indrec_, attr_);

   -- Check user is allowed to select the site
   IF (User_Allowed_Site_API.Is_Authorized(newrec_.contract) = 0) THEN
      Error_SYS.Record_General('RotablePoolSite', 'SITENOTALLOWED: Site :P1 is not allowed for the user.', newrec_.contract);
   END IF;

   -- Specific validations for Fixed Asset rotable pools
   poolrec_ := Rotable_Part_Pool_API.Get(newrec_.rotable_part_pool_id);

   -- Check site is connected to the same company
   IF (poolrec_.rotable_pool_asset_type = 'FIXED ASSET') THEN
      OPEN get_contract;
      FETCH get_contract INTO site_;
      IF (get_contract%FOUND) THEN
         company_ := Site_API.Get_Company(site_);
         CLOSE get_contract;
         IF (Site_API.Get_Company(newrec_.contract) != company_) THEN
            Error_SYS.Record_General('RotablePoolSite', 'COMPANYDIFFERENT: Only sites connected with company :P1 may be selected for Fixed Asset rotable part pool', company_);
         END IF;
      ELSE
         CLOSE get_contract;
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Company
--   This method is called in Fixed Assets to get the company to create the FA Objects.
FUNCTION Get_Company (
   rotable_part_pool_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR Get_Sites IS
      SELECT contract
      FROM   ROTABLE_POOL_SITE_TAB
      WHERE  rotable_part_pool_id = rotable_part_pool_id_;
   company_ VARCHAR2(20);
BEGIN
   FOR sites_ IN Get_Sites LOOP
      company_ := Site_Api.Get_Company(sites_.contract);
      RETURN company_;
   END LOOP;
   RETURN NULL;
END Get_Company;


-- users with read only access.
-- Check_Exist
--   Checks whether a record exists in the RotablePoolSite.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_             IN VARCHAR2,
   rotable_part_pool_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(contract_, rotable_part_pool_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


@UncheckedAccess
FUNCTION Get_Default_Contract (
   rotable_part_pool_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_  ROTABLE_POOL_SITE_TAB.contract%TYPE;
   CURSOR get_contract IS
      SELECT contract
      FROM   ROTABLE_POOL_SITE_TAB
      WHERE  rotable_part_pool_id = rotable_part_pool_id_;   
BEGIN
   OPEN get_contract;
   LOOP
      FETCH get_contract INTO contract_;
      EXIT WHEN (get_contract%NOTFOUND);
      IF (get_contract%ROWCOUNT > 1) THEN
         contract_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_contract;
   RETURN contract_;
END Get_Default_Contract;


-- New
--   Public interface for create new Rotable Pool Site.
PROCEDURE New (
   contract_             IN  VARCHAR2,
   rotable_part_pool_id_ IN  VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   newrec_     ROTABLE_POOL_SITE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   objid_      ROTABLE_POOL_SITE.objid%TYPE;
   objversion_ ROTABLE_POOL_SITE.objversion%TYPE;
BEGIN
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('ROTABLE_PART_POOL_ID', rotable_part_pool_id_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Remove
--   Removes specified record.
PROCEDURE Remove (
   contract_             IN VARCHAR2,
   rotable_part_pool_id_ IN VARCHAR2 )
IS
   remrec_     ROTABLE_POOL_SITE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, contract_, rotable_part_pool_id_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;



