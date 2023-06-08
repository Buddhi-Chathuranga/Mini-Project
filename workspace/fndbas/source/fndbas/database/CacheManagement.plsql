-----------------------------------------------------------------------------
--
--  Logical unit: CacheManagement
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  080208  HAAR  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Refresh_Cache (
   cache_id_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, cache_id_);
   Client_SYS.Add_To_Attr('REFRESHED', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('REFRESHED_BY', FND_SESSION_API.Get_Fnd_User, attr_);
   Client_SYS.Add_To_Attr('INVALIDATED', TO_DATE(NULL), attr_);
   Client_SYS.Add_To_Attr('INVALIDATED_BY', TO_CHAR(NULL), attr_);
   IF (objid_ IS NULL) THEN
      Client_SYS.Add_To_Attr('CACHE_ID', cache_id_, attr_);
      New__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Modify__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
END Refresh_Cache;


PROCEDURE Invalidate_Cache (
   cache_id_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, cache_id_);
   Client_SYS.Add_To_Attr('INVALIDATED', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('INVALIDATED_BY', FND_SESSION_API.Get_Fnd_User, attr_);
   IF (objid_ IS NULL) THEN
      Client_SYS.Add_To_Attr('CACHE_ID', cache_id_, attr_);
      New__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Modify__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
END Invalidate_Cache;



