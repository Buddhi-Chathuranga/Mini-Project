-----------------------------------------------------------------------------
--
--  Logical unit: ManufactWipPostingEvent
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210817  LEPESE  MF21R2-2533, Renamed from ManufWipBusinessEvent to ManufactWipPostingEvent.
--  210812  LEPESE  MF21R2-2533, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Exist (
   system_event_id_ IN VARCHAR2 )
IS
BEGIN
   IF NOT (Mpccom_System_Event_API.Exists(system_event_id_)) THEN
      Error_SYS.Record_General(lu_name_, 'NOTEXIST1: Posting Event :P1 does not exist', system_event_id_);
   END IF;
   IF NOT (Acc_Event_Posting_Type_API.Exists(event_code_ => system_event_id_, str_code_ => 'M40', booking_ => 1)) THEN
      Error_SYS.Record_General(lu_name_, 'NOTEXIST2: Posting Event :P1 does not exist for posting type M40', system_event_id_);
   END IF;
END Exist;

@UncheckedAccess
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   IF (Acc_Event_Posting_Type_API.Exists(event_code_ => value_, str_code_ => 'M40', booking_ => 1)) THEN
      description_ := Mpccom_System_Event_API.Get_Description(value_); 
   END IF;
END Get_Control_Type_Value_Desc;


-------------------- LU  NEW METHODS -------------------------------------
