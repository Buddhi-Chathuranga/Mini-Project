-----------------------------------------------------------------------------
--
--  Logical unit: FndObjSubscription
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150907  WAWILK  Changed Enable_Subscription to do a refresh for the LU in object tracking runtime(Bug#124389)
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
   Client_SYS.Add_To_Attr('SUBSCRIPTION_ID', fnd_obj_subscrip_id_seq.nextval, attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT fnd_obj_subscription_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   IF ( Is_Already_Subscribed___(newrec_.username,newrec_.sub_objkey) ) THEN 
      Error_SYS.Appl_General(lu_name_, 'DUPLICATE: You already have a subscription for this record');
   END IF;
END Check_Insert___;

@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT fnd_obj_subscription_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.disabled := Fnd_Boolean_API.DB_FALSE;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

FUNCTION Is_Already_Subscribed___ (
   user_name_ IN VARCHAR2,
   objkey_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_ NUMBER;
BEGIN
   select 1 into temp_ from fnd_obj_subscription_tab where username = user_name_ and sub_objkey = objkey_;
   RETURN TRUE;
EXCEPTION 
   WHEN no_data_found THEN
      RETURN FALSE;
END Is_Already_Subscribed___;

@Override
PROCEDURE Unpack___ (
newrec_   IN OUT fnd_obj_subscription_tab%ROWTYPE,
indrec_   IN OUT Indicator_Rec,
attr_     IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   IF (Client_SYS.Get_Item_Value('SUB_OBJID', attr_) IS NOT NULL) THEN
      newrec_.sub_objkey := Fnd_Obj_Subscription_Util_API.Get_Objkey_From_Objid_(newrec_.lu_name,
                                Client_SYS.Cut_Item_Value('SUB_OBJID', attr_), newrec_.client_view);
   END IF;
END Unpack___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     fnd_obj_subscription_tab%ROWTYPE,
   newrec_ IN OUT fnd_obj_subscription_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.username <> Fnd_Session_API.Get_Fnd_User AND Security_SYS.Has_System_Privilege('ADMINISTRATOR') = 'FALSE' THEN
      Error_SYS.Appl_General(lu_name_, 'NOPRIV: You do not have the priviledge to modify this subscription');
   END IF;
   IF NVL(Fnd_Obj_Tracking_Runtime_API.Get_Active_Db(lu_name_),Fnd_Boolean_API.DB_TRUE) = Fnd_Boolean_API.DB_FALSE THEN 
      Error_SYS.Appl_General(lu_name_, 'LUDISABLED: Subscriptions for this logical unit is disabled by the Administrator');
   END IF;
   
   IF(newrec_.self_notify IS NULL)THEN
      newrec_.self_notify := 'FALSE';
   END IF;
   IF(newrec_.one_time IS NULL)THEN
      newrec_.one_time := 'FALSE'; 
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Common___;

@Override
PROCEDURE Delete___ (
   objid_  IN     VARCHAR2,
   remrec_ IN     fnd_obj_subscription_tab%ROWTYPE )
IS
   temp_ NUMBER;
BEGIN
   super(objid_, remrec_);
   
   SELECT 1 INTO temp_
   FROM dual
   WHERE EXISTS ( SELECT 1 
      FROM fnd_obj_subscription_tab t
      WHERE t.lu_name  = remrec_.lu_name); 
EXCEPTION
   WHEN no_data_found THEN
      Fnd_Obj_Tracking_Runtime_API.Discontinue_Tracking_(remrec_.lu_name);
END Delete___;
   
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Remove_Subscription_Cols__ (
   subscription_id_ IN VARCHAR2
   )
IS
BEGIN
   DELETE
      FROM fnd_obj_subscrip_column_tab 
      WHERE subscription_id = subscription_id_;
END Remove_Subscription_Cols__;

PROCEDURE Remove_Subscription__ (
   subscription_id_ IN VARCHAR2)
IS
   newrec_  fnd_obj_subscription_tab%ROWTYPE;
BEGIN
   IF Get_Username(subscription_id_) <> Fnd_Session_API.Get_Fnd_User AND Security_SYS.Has_System_Privilege('ADMINISTRATOR') = 'FALSE' THEN
      Error_SYS.Appl_General(lu_name_, 'NOPRIV: You do not have the priviledge to modify this subscription');
   END IF;
   newrec_.subscription_id := subscription_id_;
   Remove___(newrec_);
END Remove_Subscription__;

PROCEDURE Disable_Subscription__ (
   subscription_id_ IN VARCHAR2
   )
IS
   rec_ fnd_obj_subscription_tab%ROWTYPE;
BEGIN
   IF Security_SYS.Has_System_Privilege('ADMINISTRATOR') = 'FALSE' THEN
      Error_SYS.Appl_General(lu_name_, 'NOPRIV: You do not have the priviledge to modify this subscription');
   END IF;
   rec_ := Get_Object_By_Keys___(subscription_id_);
   rec_.disabled := Fnd_Boolean_API.DB_TRUE;
   Modify___(rec_);
END Disable_Subscription__;

PROCEDURE Enable_Subscription__ (
   subscription_id_ IN VARCHAR2
   )
IS
   rec_ fnd_obj_subscription_tab%ROWTYPE;
BEGIN
   IF Security_SYS.Has_System_Privilege('ADMINISTRATOR') = 'FALSE' THEN
      Error_SYS.Appl_General(lu_name_, 'NOPRIV: You do not have the priviledge to modify this subscription');
   END IF;
   rec_ := Get_Object_By_Keys___(subscription_id_);
   rec_.disabled := Fnd_Boolean_API.DB_FALSE;
   Modify___(rec_);
   Fnd_Obj_Tracking_Runtime_API.Refresh_Lu_(rec_.lu_name);
END Enable_Subscription__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
   
PROCEDURE Remove_ (rec_ IN OUT fnd_obj_subscription_tab%ROWTYPE)
IS
BEGIN
   Remove___(rec_);
END Remove_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

