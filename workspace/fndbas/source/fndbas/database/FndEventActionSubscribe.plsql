-----------------------------------------------------------------------------
--
--  Logical unit: FndEventActionSubscribe
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  010702  ROOD    Created (ToDo#4016).
--  011018  ROOD    Added cascade for action_number in the view.
--                  Modified Subscribe and Unsubscribe (ToDo#4016).
--  020624  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040223  ROOD    Replaced oracle_role with role everywhere (F1PR413).
--  110726  ChMu    Modified method Subscribe (Bug#97049)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Subscribe (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   action_number_ IN NUMBER,
   identity_      IN VARCHAR2 )
IS
   event_action_ Fnd_Event_Action_API.Public_Rec;
   attr_         VARCHAR2(2000);
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
BEGIN
   IF NOT Check_Exist___(event_lu_name_, event_id_, action_number_, identity_) THEN
      event_action_ := Fnd_Event_Action_API.Get(event_lu_name_, event_id_, action_number_);
      IF event_action_.subscribable = 'TRUE' THEN
         -- Only validate access right if a role is stated. IF no role is stated, everyone has access to subscribe.
         IF event_action_.role IS NULL THEN
            Fnd_User_API.Exist(identity_);
         ELSIF NOT Fnd_User_API.Is_User_Runtime_Role(identity_,event_action_.role) THEN
            Error_SYS.Appl_General(lu_name_, 'ROLENOTGRANTED: Cannot subscribe to Event Action since the Role ":P1" is not granted to User ":P2".', event_action_.role, identity_);  
         END IF;
      ELSE
         Error_SYS.Record_General(lu_name_, 'NOTSUBSCRIBABLE: This Event Action for Event :P1 is not subscribable!', event_id_);
      END IF;
      Client_SYS.Add_To_Attr('EVENT_LU_NAME', event_lu_name_, attr_);
      Client_SYS.Add_To_Attr('EVENT_ID', event_id_, attr_);
      Client_SYS.Add_To_Attr('ACTION_NUMBER', action_number_, attr_);
      Client_SYS.Add_To_Attr('IDENTITY', identity_, attr_);
      Client_SYS.Add_To_Attr('DESCRIPTION', event_action_.description, attr_);
      New__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
END Subscribe;


PROCEDURE Unsubscribe (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   action_number_ IN NUMBER,
   identity_      IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, event_lu_name_, event_id_, action_number_, identity_);
   IF Check_Exist___(event_lu_name_, event_id_, action_number_, identity_) THEN
      Remove__(info_, objid_, objversion_, 'DO');
   END IF;
END Unsubscribe;


@UncheckedAccess
FUNCTION Is_Subscribed (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   action_number_ IN NUMBER ) RETURN VARCHAR2
IS
   identity_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   IF Check_Exist___(event_lu_name_, event_id_, action_number_, identity_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Subscribed;



