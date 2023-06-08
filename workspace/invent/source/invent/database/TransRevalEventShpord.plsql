-----------------------------------------------------------------------------
--
--  Logical unit: TransRevalEventShpord
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150825  AyAmlk  Bug 114937, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   event_id_           IN NUMBER,
   shpord_order_no_    IN VARCHAR2,
   shpord_release_no_  IN VARCHAR2,
   shpord_sequence_no_ IN VARCHAR2,
   site_date_          IN DATE )
IS
   newrec_       trans_reval_event_shpord_tab%ROWTYPE;
BEGIN
   newrec_.event_id           := event_id_;
   newrec_.shpord_order_no    := shpord_order_no_;
   newrec_.shpord_release_no  := shpord_release_no_;
   newrec_.shpord_sequence_no := shpord_sequence_no_;
   newrec_.date_time_created  := site_date_;
   
   New___(newrec_);
END New;

FUNCTION Check_Exist (
   event_id_           IN NUMBER,
   shpord_order_no_    IN VARCHAR2,
   shpord_release_no_  IN VARCHAR2,
   shpord_sequence_no_ IN VARCHAR2) RETURN BOOLEAN
IS   
BEGIN
   RETURN Check_Exist___(event_id_, shpord_order_no_, shpord_release_no_, shpord_sequence_no_);
END Check_Exist;