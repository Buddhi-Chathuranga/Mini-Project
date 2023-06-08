-----------------------------------------------------------------------------
--
--  Logical unit: MessageMedia
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971117  jhma    Created
--  000808  ROOD    Upgraded to Yoshimura template (Bug#15811).
--  020128  ROOD    Modified view and business logic to handle 
--                  attribute translations (ToDo#4070).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  051222  IsAn    Made description as a lov member in view MESSAGE_MEDIA
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Raise_Record_Not_Exist___ (
   media_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(Message_Media_API.lu_name_, p1_ => media_code_);
   super(media_code_);
END Raise_Record_Not_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

