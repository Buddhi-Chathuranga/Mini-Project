-----------------------------------------------------------------------------
--
--  Logical unit: FndEventRestBlob
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
FUNCTION Get_Next_Attachment_No___ (
   event_lu_name_ IN VARCHAR2,
   event_id_      IN VARCHAR2,
   action_number_ IN NUMBER) RETURN NUMBER
IS
   attachment_no_ NUMBER;
BEGIN
   SELECT max(attachment_number) + 1 INTO attachment_no_
   FROM FND_EVENT_REST_BLOB_TAB
   WHERE event_lu_name = event_lu_name_
   AND event_id = event_id_
   AND action_number = action_number_;

   RETURN attachment_no_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 0;
END Get_Next_Attachment_No___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FND_EVENT_REST_BLOB_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   max_attachment_number_ NUMBER;
   msg_               VARCHAR2(4000);
BEGIN 
   IF (newrec_.attachment_number IS NULL) THEN 
      max_attachment_number_ := Get_Next_Attachment_No___(newrec_.event_lu_name, newrec_.event_id, newrec_.action_number);
      newrec_.attachment_number := nvl(max_attachment_number_, 0);
   END IF;
   super(objid_, objversion_, newrec_, attr_); 
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

