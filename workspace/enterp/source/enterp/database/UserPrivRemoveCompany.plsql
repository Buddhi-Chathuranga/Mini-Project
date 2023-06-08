-----------------------------------------------------------------------------
--
--  Logical unit: UserPrivRemoveCompany
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050713  ovjose  Created
--  080331  Samwlk  Bug 70469, Corrected. Remvoed the General_sys statment 
--  080331          and added pragma to function Remove_Company_Allowed
--  210914  Sacnlk  FI21R2-4065, LCS Bug Merged 160775, Added Remove_Company.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Changes_Allowed___(
   company_    IN VARCHAR2,
   identity_   IN VARCHAR2)
IS
   fnd_user_      VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   IF (NOT Company_API.Get_Created_By(company_) = fnd_user_) THEN
      IF (NOT Check_Exist___(company_, fnd_user_)) THEN
         Error_SYS.Appl_General(lu_name_, 'NOTALLOWED: User: :P1 are not allowed to Insert/Remove User: :P2 to/from company: :P3 in Users Privileged To Remove Company', fnd_user_, identity_, company_);
      END IF;
   END IF;
END Changes_Allowed___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN user_priv_remove_company_tab%ROWTYPE )
IS   
BEGIN
   Changes_Allowed___(remrec_.company, remrec_.identity);
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT user_priv_remove_company_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(newrec_, indrec_, attr_);
   Changes_Allowed___(newrec_.company, newrec_.identity);
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Remove_Company_Allowed (
   company_  IN VARCHAR2,
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(company_, identity_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Remove_Company_Allowed;


-- DO NOT CHANGE OR USE THIS METHOD FOR OTHER PURPOSES. 
-- Note: This method only used from Remove Company functionality in Remove_Company_API.Start_Remove_Company__.
@ServerOnlyAccess 
PROCEDURE Remove_Company (
   company_  IN VARCHAR2 )
IS
BEGIN 
   IF (Company_API.Remove_Company_Allowed(company_) = 'TRUE') THEN  
      DELETE 
      FROM user_priv_remove_company_tab
      WHERE company = company_;
   END IF;   
END Remove_Company;

