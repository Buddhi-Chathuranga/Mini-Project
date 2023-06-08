-----------------------------------------------------------------------------
--
--  Logical unit: InternalDestination2
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--    Procedure to get description for accounting rules.
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
   local_description_         INTERNAL_DESTINATION_TAB.description%TYPE;   
   user_default_site_         INTERNAL_DESTINATION_TAB.contract%TYPE;
   user_default_site_company_ VARCHAR2(20);

   -- Get any site that belongs to the company and user.
   CURSOR get_company_allowed_site is
      SELECT contract
        FROM site_public, user_allowed_site_pub
       WHERE contract = site
         AND company = company_;
BEGIN
   user_default_site_         := User_Allowed_Site_API.Get_Default_Site();
   user_default_site_company_ := Site_API.Get_Company(user_default_site_);

   IF (company_ = user_default_site_company_) THEN
      local_description_ := Internal_Destination_API.Get_Description(user_default_site_, value_);
   END IF;

   IF (local_description_ IS NULL) THEN
      FOR company_allowed_site_ IN get_company_allowed_site LOOP
          local_description_ := Internal_Destination_API.Get_Description(company_allowed_site_.contract, value_); 
          IF (local_description_ IS NOT NULL) THEN
             EXIT;
          END IF; 
      END LOOP;   
   END IF;

   description_ := local_description_; 
END Get_Control_Type_Value_Desc;


-- Exist
--    This method is especially designed to be used from ACCRUL that needs
--    this method since Internal Destination is used for control type C99.
@UncheckedAccess
PROCEDURE Exist (
   company_        IN VARCHAR2,
   destination_id_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM INTERNAL_DESTINATION_TAB id, site_public sp, user_allowed_site_pub uas
      WHERE id.contract = sp.contract
      AND id.contract = uas.site
      AND sp.company = company_
      AND id.destination_id = destination_id_;

BEGIN
   Log_SYS.Stack_Trace_(Log_SYS.info_, 'Internal_Destination2_API.Exist');
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%NOTFOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
   CLOSE exist_control;
END Exist;
