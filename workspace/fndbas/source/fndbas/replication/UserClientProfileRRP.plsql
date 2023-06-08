-----------------------------------------------------------------------------
--
--  Logical unit: UserClientProfile ReplReceive
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- REPLICATION RECEIVE IMPLEMENTATION METHODS ---------------------


-------------------- REPLICATION RECEIVE PRIVATE METHODS ----------------------------


-------------------- REPLICATION RECEIVE PROTECTED METHODS --------------------------


-------------------- REPLICATION RECEIVE PUBLIC METHODS -----------------------------
@Overtake Base
PROCEDURE NewModify (
   warning_      OUT VARCHAR2,
   old_attr_     IN  VARCHAR2,
   new_attr_     IN  VARCHAR2,
   lu_name_      IN  VARCHAR2,
   package_name_ IN  VARCHAR2,
   user_id_      IN  VARCHAR2) 
IS
   attr_  VARCHAR2(32000);
   objid_ VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   
   oldrec_   fndrr_user_client_profile_tab%ROWTYPE;
   newrec_   fndrr_user_client_profile_tab%ROWTYPE;
   indrec_   Indicator_Rec;
   
BEGIN
   $SEARCH
      oldrec_.user_id := Client_SYS.Get_Item_Value('USER_ID', old_attr_);
      oldrec_.profile_id := Client_SYS.Get_Item_Value('PROFILE_ID', old_attr_);
   $REPLACE
      oldrec_.user_id := NVL(Client_SYS.Get_Item_Value('USER_ID', old_attr_),Client_SYS.Get_Item_Value('USER_ID', new_attr_));
      oldrec_.profile_id := NVL(Client_SYS.Get_Item_Value('PROFILE_ID', old_attr_),Client_SYS.Get_Item_Value('PROFILE_ID', new_attr_));
   $END
END NewModify;

