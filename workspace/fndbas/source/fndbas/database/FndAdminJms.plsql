-----------------------------------------------------------------------------
--
--  Logical unit: FndAdminJms
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -----------------------------------------------------
--  2016-04-21  MADRSE  TEMWS-500: Recreating and starting JSF Admin JMS AQ queues
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Send_Jms_Message (
   method_   IN VARCHAR2,
   value_    IN VARCHAR2,
   app_name_ IN VARCHAR2)
IS
   --
   -- FndAdminTopic messages are sent to BatchProcessorQueue, to the INT node only!
   --
BEGIN
   Batch_Processor_Jms_API.Send_Jms_Message('FndAdminTopic', admin_method_ => method_, admin_value_ => value_);
END Send_Jms_Message;
