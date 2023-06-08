-----------------------------------------------------------------------------
--
--  Logical unit: FndFavorite
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
      super(attr_);
      Client_SYS.Add_To_Attr('ID', FND_FAVORITE_SEQ.NEXTVAL, attr_);
      Client_SYS.Add_To_Attr('PROFILE_ID', FNDRR_USER_CLIENT_PROFILE_API.GET_PERSONAL_PROFILE_ID(fnd_session_api.Get_Fnd_User), attr_);
      Client_SYS.Add_To_Attr('ADDED', sysdate , attr_);
      Client_SYS.Add_To_Attr('IS_PINNED', 0 , attr_);
END Prepare_Insert___; 
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

