-----------------------------------------------------------------------------
--
--  Logical unit: CampaignHistory
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210108  RavDlk  SC2020R1-11995, Modified New by removing unnecessary packing and unpacking of attrubute string
--  160111  JeeJlk  Bug 125118, Modified Insert___ to assign hist_state column campaign objstate value.
--  131029  RoJalk  Modified CAMPAIGN_HISTORY and increased the length of user_id to 100 and made message_text mandatory. 
--  111116  ChJalk  Modified the view CAMPAIGN_HISTORY to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111026  ChJalk  Modified the base view CAMPAIGN_HISTORY to use the user allowed company filter.
--  091228  MaHplk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CAMPAIGN_HISTORY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.history_no:= Get_Next_History_No__(newrec_.campaign_id );
   IF newrec_.hist_state IS NULL THEN
      newrec_.hist_state := Campaign_API.Get_Objstate(newrec_.campaign_id);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_Next_History_No__ (
   campaign_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_history_no IS
      SELECT max(to_number(history_no))
      FROM   CAMPAIGN_HISTORY_TAB
      WHERE  campaign_id = campaign_id_;

   history_no_     NUMBER;
BEGIN
   OPEN get_history_no;
   FETCH get_history_no INTO history_no_;
   IF history_no_ IS NULL THEN
      history_no_ := 1;
   ELSE
      history_no_ := to_number(history_no_) +1;
   END IF;
   CLOSE get_history_no;
   RETURN history_no_;
END Get_Next_History_No__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   campaign_id_   IN NUMBER,
   message_text_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_     Campaign_History_Tab%ROWTYPE;
BEGIN
   newrec_.campaign_id := campaign_id_;
   newrec_.date_entered := Site_API.Get_Site_Date(Campaign_API.Get_Reference_Site(campaign_id_));
   newrec_.user_id := Fnd_Session_API.Get_Fnd_User;
   IF (message_text_ IS NULL) THEN
      newrec_.message_text :=  Campaign_API.Get_State(campaign_id_);
   ELSE
      newrec_.message_text := message_text_;
   END IF;
   newrec_.hist_state := Campaign_API.Get_Objstate(campaign_id_);
   New___(newrec_);
END New;

@UncheckedAccess
FUNCTION Get_Hist_State (
   campaign_id_ IN VARCHAR2,
   history_no_     NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_hist_state IS
      SELECT hist_state
      FROM   CAMPAIGN_HISTORY_TAB
      WHERE  campaign_id = campaign_id_
      AND    history_no = history_no_;

   hist_state_     VARCHAR2(20);
BEGIN
   OPEN get_hist_state;
   FETCH get_hist_state INTO hist_state_;
   CLOSE get_hist_state;
   RETURN Campaign_API.Finite_State_Decode__(hist_state_);
END Get_Hist_State;



