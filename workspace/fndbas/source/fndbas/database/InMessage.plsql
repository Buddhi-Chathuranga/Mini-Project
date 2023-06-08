-----------------------------------------------------------------------------
--
--  Logical unit: InMessage
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971117  JHMA    Created
--  980325  JHMA    Security check removed on methods called from Connectivity_SYS.
--  990705  ERFO    Added reference to MessageReceiver (Bug #3325).
--  000808  ROOD    Upgraded to Yoshimura template (Bug#15811).
--                  Removed unused methods Receive__ and Check_New__.
--  010611  ROOD    Added Reprocess as possible event on Rejected (ToDo#3999).
--  010917  ROOD    Removed mandatory check on application_message_id (Bug#22735).
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040923  JHMA    Added new state PartlyAccepted and methods to handle it (Bug#47158).
--  080603  JHMA    Removed posibility to Reprocess of Transferred messages (Bug #74551).
--  100108  HAYA    Updated to new server template.
--  120904  WAWI    Modified Finite_State_Machine___ to remove Reprocess of Transferred messages (Bug#102889
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE New (
   newrec_ IN OUT NOCOPY in_message_tab%ROWTYPE )
IS
BEGIN
   New___(newrec_);
END New;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT IN_MESSAGE_TAB%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
BEGIN
   super(rec_, state_);
   UPDATE in_message_tab
      SET error_message = rec_.error_message
      WHERE message_id = rec_.message_id;
END Finite_State_Set___;


@Override
PROCEDURE Finite_State_Machine___ (
   rec_   IN OUT IN_MESSAGE_TAB%ROWTYPE,
   event_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   rec_.error_message := Client_SYS.Get_Item_Value('ERROR_MESSAGE', attr_);
   super(rec_, event_, attr_);
END Finite_State_Machine___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_Next_Message_Id__ RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR get_in_message_id_seq IS
      SELECT in_message_id_seq.NEXTVAL
      FROM   dual;
BEGIN
   OPEN get_in_message_id_seq;
   FETCH get_in_message_id_seq INTO temp_;
   CLOSE  get_in_message_id_seq;
   RETURN(temp_);
END Get_Next_Message_Id__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Accept_ (
   message_id_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      IN_MESSAGE.objid%TYPE;
   objversion_ IN_MESSAGE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Accept__(info_, objid_, objversion_, attr_, 'DO');
END Accept_;


PROCEDURE Reject_ (
   message_id_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      IN_MESSAGE.objid%TYPE;
   objversion_ IN_MESSAGE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Reject__(info_, objid_, objversion_, attr_, 'DO');
END Reject_;


PROCEDURE Post_ (
   message_id_ IN NUMBER )
IS
   attr_   VARCHAR2(32000);
   lu_rec_ IN_MESSAGE_TAB%ROWTYPE;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(message_id_);
   Finite_State_Init___(lu_rec_, attr_);
END Post_;


PROCEDURE Set_State_ (
   message_id_ IN NUMBER )
IS
   attr_               VARCHAR2(2000);
   info_               VARCHAR2(2000);
   objid_              IN_MESSAGE.objid%TYPE;
   objversion_         IN_MESSAGE.objversion%TYPE;

   accepted_found_     BOOLEAN := FALSE;
   rejected_found_     BOOLEAN := FALSE;
   posted_found_       BOOLEAN := FALSE;
   no_of_accepted_     NUMBER := 0;
   no_of_rejected_     NUMBER := 0;
   error_message_      IN_MESSAGE_TAB.error_message%TYPE;

   no_states_found_    EXCEPTION;
   posted_state_found_ EXCEPTION;
   CURSOR get_rowstate IS
      SELECT rowstate, count(*) no
      FROM   in_message_line_tab
      WHERE  message_id = message_id_
      GROUP BY rowstate;

   FUNCTION Create_Error_Message RETURN VARCHAR2 IS
      text_           VARCHAR2(10);
      error_msg_      IN_MESSAGE_TAB.error_message%TYPE;
   BEGIN
      IF ( no_of_accepted_ = 1 ) THEN
         text_ := ' line ';
      ELSE
         text_ := ' lines ';
      END IF;
      error_msg_ := TO_CHAR(no_of_accepted_) || text_ || 'Accepted and '; 
      IF ( no_of_rejected_ = 1 ) THEN
         text_ := ' line ';
      ELSE
         text_ := ' lines ';
      END IF;
      error_msg_ := error_msg_ || TO_CHAR(no_of_rejected_) || text_ || 'Rejected'; 
      RETURN error_msg_;
   END Create_Error_Message;
      
BEGIN
   FOR rec_ IN get_rowstate LOOP
      IF rec_.rowstate = 'Accepted' THEN
         accepted_found_ := TRUE;
         no_of_accepted_ := rec_.no;
      ELSIF rec_.rowstate = 'Rejected' THEN
         rejected_found_ := TRUE;
         no_of_rejected_ := rec_.no;
      ELSIF rec_.rowstate = 'Posted' THEN
         posted_found_ := TRUE;
      END IF;
      IF accepted_found_ AND rejected_found_ AND posted_found_ THEN
         RAISE posted_state_found_;
      END IF;
   END LOOP;
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   IF accepted_found_ AND rejected_found_ THEN
      error_message_ := Create_Error_Message;
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
      Partly_Accept__(info_, objid_, objversion_, attr_, 'DO');
   ELSIF accepted_found_ THEN
      Accept__(info_, objid_, objversion_, attr_, 'DO');
   ELSIF rejected_found_ THEN
      Reject__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      RAISE no_states_found_;
   END IF;
EXCEPTION
   WHEN no_states_found_ THEN
      Error_SYS.Appl_General(lu_name_, 'LINESTATESMISSING: Line states must be set prior to execution of Set_State_');
   WHEN posted_state_found_ THEN
      Error_SYS.Appl_General(lu_name_, 'LINESTATESPOSTED: All lines must processed prior to execution of Set_State_');
END Set_State_;


PROCEDURE Reprocess_ (
   message_id_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      IN_MESSAGE.objid%TYPE;
   objversion_ IN_MESSAGE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Reprocess__(info_, objid_, objversion_, attr_, 'DO');
END Reprocess_;

PROCEDURE Reactive_ (
   message_id_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      IN_MESSAGE.objid%TYPE;
   objversion_ IN_MESSAGE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Reactivate__(info_, objid_, objversion_, attr_, 'DO');
END Reactive_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Get_ReceivedTime (
   message_id_ IN NUMBER ) RETURN DATE
   IS
      temp_ in_message_tab.received_time%TYPE;
   BEGIN
      IF (message_id_ IS NULL) THEN
         RETURN NULL;
      END IF;
      SELECT received_time
         INTO  temp_
         FROM  in_message_tab
         WHERE message_id = message_id_;
      RETURN temp_;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;      
END Get_ReceivedTime;

