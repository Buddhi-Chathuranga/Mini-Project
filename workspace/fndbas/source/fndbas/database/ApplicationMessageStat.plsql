-----------------------------------------------------------------------------
--
--  Logical unit: ApplicationMessageStat
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  ---------------------------------------------------------
--  2019-03-26  madrse  LCS-145612: Created
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Security___ (
   method_ IN VARCHAR2) IS
BEGIN
   General_SYS.Check_Security(lu_name_, 'APPLICATION_MESSAGE_STAT_API', method_);
END Check_Security___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE New_ (
   application_message_id_ IN NUMBER,
   stat_type_              IN VARCHAR2,
   stat_category_          IN VARCHAR2,
   start_timestamp_        IN TIMESTAMP)
IS
   PRAGMA autonomous_transaction;
BEGIN
   Check_Security___('New_');
   INSERT INTO application_message_stat_tab(application_message_id, stat_type, stat_category, start_timestamp, end_timestamp, rowversion)
   VALUES (application_message_id_, stat_type_, stat_category_, start_timestamp_ AT TIME ZONE 'UTC', SYSTIMESTAMP AT TIME ZONE 'UTC', 1);
   @ApproveTransactionStatement(2019-03-26,madrse)
   COMMIT;
END New_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

