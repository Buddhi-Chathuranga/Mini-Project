-----------------------------------------------------------------------------
--
--  Logical unit: PlanningNetworkSite
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160215  ManWlk STRMF-2656, Overridden Insert___ to insert corresponding network part attributes.
--  040608  MAKULK Added PLANNING_NETWORK_SITE_LOV and function (i.e. User_Allowed_Planning_Network).
--  040304  NALWLK Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN PLANNING_NETWORK_SITE_TAB%ROWTYPE )
IS
BEGIN
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,remrec_.contract);

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT planning_network_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,newrec_.contract);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT NOCOPY planning_network_site_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   $IF Component_Mfgstd_SYS.INSTALLED $THEN
      Network_Part_Attributes_API.Insert_Attributes_Network_Site(newrec_.network_id, newrec_.contract);
   $END
END Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION User_Allowed_Planning_Network (
   network_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_counter_           NUMBER:=0;
   user_allowed_counter_       NUMBER:=0;
   value_                      VARCHAR2(5);

   CURSOR count_contract IS  
     SELECT   COUNT(contract)
     FROM     PLANNING_NETWORK_SITE_TAB  
     WHERE    network_id = network_id_                    
     GROUP BY network_id;

   CURSOR count_user_allowed_contract IS 
     SELECT   COUNT(contract)
     FROM     PLANNING_NETWORK_SITE_TAB 
     WHERE    contract IN (SELECT contract
                           FROM   user_allowed_site_tab
                           WHERE  userid IN (SELECT fnd_user
                                             FROM   fnd_session)
                           )
     AND      network_id = network_id_
     GROUP BY network_id; 
BEGIN
   
   OPEN  count_contract;
   FETCH count_contract INTO contract_counter_;
   CLOSE count_contract;

   OPEN  count_user_allowed_contract;
   FETCH count_user_allowed_contract INTO user_allowed_counter_;
   CLOSE count_user_allowed_contract;
   
   IF ((contract_counter_ = user_allowed_counter_) AND (contract_counter_ != 0 )) THEN
     value_ := 'TRUE';
   ELSE
     value_ := 'FALSE';
   END IF; 
   RETURN value_;
END User_Allowed_Planning_Network;



