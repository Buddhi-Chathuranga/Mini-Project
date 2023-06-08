-----------------------------------------------------------------------------
--
--  Logical unit: OutMessage
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971117  JHMA    Created
--  980325  JHMA    Security check removed on methods called from Connectivity_SYS
--  990705  ERFO    Added reference to MessageReceiver (Bug #3325).
--  990920  ERFO    Added methods Activate_, Skip_, Transfer_ for co-operation
--                  between Foundation1 and IFS Connect (ToDo #3573).
--  000808  ROOD    Upgraded to Yoshimura template (Bug#15811).
--                  Removed last parameter 'TRUE' from all General_SYS.Init_Method.
--                  Removed unused method Send_.
--  000818  ROOD    Removed reference to MessageFormat (ToDo#3927).
--  010504  DOZE    Wrong status on COnnect messages (Bug#21704)
--  010917  ROOD    Changed return value for message_id in Unpack_Check_Insert (Bug#22806).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030317  ROOD    Replaced General_SYS.Get_Database_Properties with
--                  Database_SYS.Get_Database_Properties (ToDo#4143).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  100108  HAYA    Updated to new server template
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE New (
   newrec_ IN OUT NOCOPY out_message_tab%ROWTYPE )
IS
BEGIN
   New___(newrec_);
END New;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Next_Message_Id___ RETURN NUMBER
IS
   CURSOR get_out_message_id_seq IS
      SELECT out_message_id_seq.NEXTVAL
      FROM   dual;
   current_message_id_  NUMBER;
BEGIN
   OPEN get_out_message_id_seq;
   FETCH get_out_message_id_seq INTO current_message_id_;
   CLOSE  get_out_message_id_seq;
   RETURN(current_message_id_);
END Next_Message_Id___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT out_message_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.connectivity_version := Connectivity_SYS.Connectivity_Version_;
   Client_SYS.Set_Item_Value('CONNECTIVITY_VERSION', newrec_.connectivity_version, attr_);
   IF (newrec_.message_id IS NULL) THEN
      newrec_.message_id := Next_Message_Id___;
      Client_SYS.Set_Item_Value('MESSAGE_ID', newrec_.message_id, attr_);
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;



@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     out_message_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY out_message_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   dummy1_ VARCHAR2(2000);
   dummy2_ VARCHAR2(2000);
BEGIN
   IF (newrec_.exec_time IS NULL) THEN
      newrec_.exec_time := sysdate;
      Client_SYS.Set_Item_Value('EXEC_TIME', newrec_.exec_time, attr_);
   END IF;
   IF (newrec_.sender IS NULL) THEN
      Database_SYS.Get_Database_Properties(newrec_.sender, dummy1_, dummy2_);
      Client_SYS.Set_Item_Value('SENDER', newrec_.sender, attr_);
   END IF;
   IF (newrec_.version IS NULL) THEN
      newrec_.version := 'N/A';
      Client_SYS.Set_Item_Value('VERSION', newrec_.version, attr_);
   END IF;
   IF (newrec_.application_message_id IS NULL) THEN
      newrec_.application_message_id := 'N/A';
      Client_SYS.Set_Item_Value('APPLICATION_MESSAGE_ID', newrec_.application_message_id, attr_);
   END IF;
   IF (newrec_.application_receiver_id IS NULL) THEN
      newrec_.application_receiver_id := 'N/A';
      Client_SYS.Set_Item_Value('APPLICATION_RECEIVER_ID', newrec_.application_receiver_id, attr_);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Release_ (
   message_id_ IN NUMBER )
IS
   attr_               VARCHAR2(2000);
   info_               VARCHAR2(2000);
   objid_              OUT_MESSAGE.objid%TYPE;
   objversion_         OUT_MESSAGE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Release__(info_, objid_, objversion_, attr_, 'DO');
END Release_;


FUNCTION Get_Next_Message_Id_ RETURN NUMBER
IS
BEGIN
   RETURN(Next_Message_Id___);
END Get_Next_Message_Id_;


PROCEDURE Activate_ (
   message_id_ IN NUMBER )
IS
   attr_               VARCHAR2(2000);
   info_               VARCHAR2(2000);
   objid_              OUT_MESSAGE.objid%TYPE;
   objversion_         OUT_MESSAGE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Activate__(info_, objid_, objversion_, attr_, 'DO');
END Activate_;


PROCEDURE Skip_ (
   message_id_ IN NUMBER )
IS
   attr_               VARCHAR2(2000);
   info_               VARCHAR2(2000);
   objid_              OUT_MESSAGE.objid%TYPE;
   objversion_         OUT_MESSAGE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Skip__(info_, objid_, objversion_, attr_, 'DO');
END Skip_;


PROCEDURE Transfer_ (
   message_id_ IN NUMBER )
IS
   attr_               VARCHAR2(2000);
   info_               VARCHAR2(2000);
   objid_              OUT_MESSAGE.objid%TYPE;
   objversion_         OUT_MESSAGE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Transfer__(info_, objid_, objversion_, attr_, 'DO');
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Accept__(info_, objid_, objversion_, attr_, 'DO');
END Transfer_;

PROCEDURE Reprocess_ (
   message_id_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      OUT_MESSAGE.objid%TYPE;
   objversion_ OUT_MESSAGE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Reprocess__(info_, objid_, objversion_, attr_, 'DO');
END Reprocess_;

PROCEDURE Reactive_ (
   message_id_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      OUT_MESSAGE.objid%TYPE;
   objversion_ OUT_MESSAGE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Reactivate__(info_, objid_, objversion_, attr_, 'DO');
END Reactive_;
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

