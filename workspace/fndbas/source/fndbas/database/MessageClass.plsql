-----------------------------------------------------------------------------
--
--  Logical unit: MessageClass
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980324  JHMA    Added method Register_Action__
--  980325  JHMA    Attribute queue_id removed
--  980325  JHMA    Methods Set_Send_On__ and Set_Receive_On__ removed
--  980325  JHMA    Argument queue_id_ to Install_Class__ replaced by action_
--  980325  JHMA    Security check removed on methods called from Connectivity_SYS
--  000808  ROOD    Upgraded to Yoshimura template (Bug#15811).
--                  Removed unnecessary check in Unpack_Check_Update___.
--                  Removed last parameter 'TRUE' from all General_SYS.Init_Method.
--  000808  ROOD    Used new IID Transfer_Option_Enabled for receive and send (ToDo#3922).
--  000810  ROOD    Added values in Prepare_Pnsert___ for receive and send (ToDo#3922).
--  001103  ROOD    Corrected parameter names in Install_Class__ (Bug#18175).
--  020128  ROOD    Modified view and business logic to handle
--                  attribute translations (ToDo#4070).
--  021202  ROOD    Modified handling of basic data translations. Replaced usage of
--                  Module_Translate_Attr_Util_API with Basic_Data_Translation_API (GLOB04).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030218  ROOD    Changed hardcoded FNDCON to FNDBAS (ToDo#4149).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  080603  JHMA    Validate Action (Bug #74555)
--  100526  JHMA    No description of background job (Bug #90933
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Action___ ( action_ IN VARCHAR2)
IS
   package_    VARCHAR2(200) := SUBSTR(action_,1,INSTR(action_,'.')-1);
   procedure_  VARCHAR2(200) := SUBSTR(action_,INSTR(action_,'.')+1);
   exist_      NUMBER := 0;
BEGIN
   SELECT 1 INTO exist_
   FROM user_procedures
   WHERE object_name = UPPER(package_)
   AND procedure_name = UPPER(procedure_);
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'PROCNOTEXISTS: Procedure :P1 does not exist.', action_); 
END Check_Action___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
      Client_SYS.Add_To_Attr('RECEIVE_DB', 'FALSE', attr_);
      Client_SYS.Add_To_Attr('SEND_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT message_class_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   -- The value for module should be FNDBAS if message class is created from client.
   -- If message class is created through Install_Class__ then it is possible to state it.
   IF newrec_.module IS NULL THEN
      newrec_.module := 'FNDBAS';
   END IF;  
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     message_class_tab%ROWTYPE,
   newrec_ IN OUT message_class_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.action IS NOT NULL) THEN
      Check_Action___(newrec_.action);
   END IF;   
END Check_Common___;

@Override 
PROCEDURE Raise_Record_Not_Exist___ (
   class_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(Message_Class_API.lu_name_, p1_ => class_id_);
   super(class_id_);
END Raise_Record_Not_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Install_Class__ (
   class_id_ IN VARCHAR2,
   action_   IN VARCHAR2 DEFAULT NULL,
   notes_    IN VARCHAR2 DEFAULT NULL,
   module_   IN VARCHAR2 DEFAULT 'FNDBAS' )
IS
   lu_rec_       MESSAGE_CLASS_TAB%ROWTYPE;
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(2000);
   CURSOR message_class_ IS
      SELECT *
      FROM   message_class_tab
      WHERE  class_id = class_id_;
BEGIN
   OPEN message_class_;
   FETCH message_class_ INTO lu_rec_;
   IF (message_class_%NOTFOUND) THEN
      CLOSE message_class_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CLASS_ID', class_id_, attr_);
      Client_SYS.Add_To_Attr('RECEIVE_DB', 'FALSE', attr_);
      Client_SYS.Add_To_Attr('SEND_DB', 'FALSE', attr_);
      Client_SYS.Add_To_Attr('MODULE', module_, attr_);
      IF (action_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('ACTION', action_, attr_);
      END IF;
      IF (notes_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('NOTES', notes_, attr_);
      END IF;
      New__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      CLOSE message_class_;
      Get_Id_Version_By_Keys___(objid_, objversion_, class_id_);
      IF (action_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('ACTION', action_, attr_);
      END IF;
      IF (notes_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('NOTES', notes_, attr_);
      END IF;
      Client_SYS.Add_To_Attr('MODULE', module_, attr_);
      Modify__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      IF (message_class_%ISOPEN) THEN
         CLOSE message_class_;
      END IF;
      RAISE;
END Install_Class__;


PROCEDURE Register_Action__ (
   class_id_ IN VARCHAR2,
   action_   IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      MESSAGE_CLASS.objid%TYPE;
   objversion_ MESSAGE_CLASS.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, class_id_);
   Client_SYS.Add_To_Attr('ACTION', action_, attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Register_Action__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Get_Action (
   class_id_    IN  VARCHAR2,
   action_      OUT VARCHAR2,
   description_ OUT VARCHAR2 )
IS
   CURSOR get_attr IS
      SELECT action, notes
      FROM MESSAGE_CLASS_TAB
      WHERE class_id = class_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO action_, description_;
   CLOSE get_attr;
END Get_Action;

@UncheckedAccess
FUNCTION Get_Basic_Data_Translation (
   class_id_ IN VARCHAR2,
   action_ IN VARCHAR2,
   receive_ IN VARCHAR2,
   send_ IN VARCHAR2,
   notes_ IN VARCHAR2,
   module_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, 'MessageClass',class_id_);
END Get_Basic_Data_Translation;

PROCEDURE Insert_Basic_Data_Translation (
   newrec_ IN message_class_tab%ROWTYPE )
IS
BEGIN
   Basic_Data_Translation_API.Insert_Basic_Data_Translation( newrec_.module,'MessageClass',newrec_.class_id,NULL, newrec_.notes);  
END Insert_Basic_Data_Translation;


PROCEDURE Remove_Basic_Data_Translation (
   remrec_ IN message_class_tab%ROWTYPE )
IS
BEGIN
   Basic_Data_Translation_API.Remove_Basic_Data_Translation( remrec_.module ,'MessageClass',remrec_.class_id);  
END Remove_Basic_Data_Translation;

