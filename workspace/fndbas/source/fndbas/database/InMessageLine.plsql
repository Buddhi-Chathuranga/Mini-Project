-----------------------------------------------------------------------------
--
--  Logical unit: InMessageLine
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971117  JHMA    Created.
--  980309  ERFO    Decreased number of supported columns to 45/15/5.
--  981006  ERFO    Removed limitations on number of items (Bug #2215).
--  991119  ERFO    Solved cleanup problem by adding a CASCADE (Bug #3086).
--  000808  ROOD    Upgraded to Yoshimura template (Bug#15811).
--                  Removed unused states 'Normal' and 'StartState'.
--                  Removed unnecessary check in Unpack_Check_Update___.
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  040917  JHMA    Added new state functionality (Bug#47158).
--  100108  HAYA    Updated to new server template.
--  100707  MAMA    Aligned the code in Finite_State_Machine___ according to the generated code from the model.
--  100707          Added method Set_Error_Message___
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE New (
   newrec_ IN OUT NOCOPY in_message_line_tab%ROWTYPE )
IS
BEGIN
   New___(newrec_);
END New;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Set_Error_Message___ (
   rec_  IN OUT IN_MESSAGE_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   rec_.rowversion := sysdate;
   UPDATE in_message_line_tab
   SET    error_message = rec_.error_message,
          rowversion = rec_.rowversion
   WHERE  message_id = rec_.message_id
   AND    message_line = rec_.message_line;
END Set_Error_Message___;

@Override
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT IN_MESSAGE_LINE_TAB%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
BEGIN
   super(rec_, state_);
   UPDATE in_message_line_tab
      SET error_message = DECODE(state_,'Accepted',null,'Rejected',rec_.error_message,error_message)
      WHERE message_id = rec_.message_id
      AND    message_line = rec_.message_line;
END Finite_State_Set___;


@Override
PROCEDURE Finite_State_Machine___ (
   rec_   IN OUT IN_MESSAGE_LINE_TAB%ROWTYPE,
   event_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   rec_.error_message := Client_SYS.Get_Item_Value('ERROR_MESSAGE', attr_);
   super(rec_, event_, attr_);
END Finite_State_Machine___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Accept_ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      IN_MESSAGE_LINE.objid%TYPE;
   objversion_ IN_MESSAGE_LINE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   Accept__(info_, objid_, objversion_, attr_, 'DO');
END Accept_;


PROCEDURE Reject_ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER,
   error_        IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      IN_MESSAGE_LINE.objid%TYPE;
   objversion_ IN_MESSAGE_LINE.objversion%TYPE;
   error_msg_  IN_MESSAGE_LINE_TAB.error_message%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   error_msg_ := error_;
   Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_msg_, attr_);
   Reject__(info_, objid_, objversion_, attr_, 'DO');
END Reject_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
