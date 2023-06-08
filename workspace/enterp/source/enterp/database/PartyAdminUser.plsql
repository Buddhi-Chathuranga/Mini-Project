-----------------------------------------------------------------------------
--
--  Logical unit: PartyAdminUser
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981203  Camk    Created
--  090320  MOHRLK  Bug 79377, Changed the column comment ref of the
--  090320          "user_id" in PARTY_ADMIN_USER view to FndUser
--  090320          Also modified Unpack_Check_Insert___ and Unpack_Check_Update___ methods.
--  130822  Jaralk  Bug 111218 Corrected the third parameter of General_SYS.Init_Method call to method name
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
   Client_SYS.Add_To_Attr('DOMAIN_ID', 'DEFAULT', attr_);
END Prepare_Insert___;
                    
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   domain_id_ IN VARCHAR2,
   user_id_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(domain_id_, user_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


@UncheckedAccess
FUNCTION Exist_Current_User RETURN BOOLEAN
IS
   temp_ NUMBER;
   CURSOR check_user IS
      SELECT 1 
      FROM   party_admin_user_tab
      WHERE  user_id = Fnd_Session_API.Get_Fnd_User;
BEGIN
   OPEN check_user;  
   FETCH check_user INTO temp_;
   IF (check_user%NOTFOUND) THEN
      CLOSE check_user;
      RETURN (FALSE);
   END IF;
   CLOSE check_user;
   RETURN (TRUE);
END Exist_Current_User;