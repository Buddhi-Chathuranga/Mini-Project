-----------------------------------------------------------------------------
--
--  Logical unit: QuickReportReplSend
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
@Override
PROCEDURE Replicate (
   site_     IN VARCHAR2,
   old_attr_ IN VARCHAR2,
   new_attr_ IN VARCHAR2)
IS
   new_changed_attr_ VARCHAR2(32000);
   old_changed_attr_ VARCHAR2(32000);
BEGIN
   new_changed_attr_ := Client_SYS.Remove_Attr('PO_ID',new_attr_);
   old_changed_attr_ := Client_SYS.Remove_Attr('PO_ID',old_attr_);
   super(site_, old_changed_attr_, new_changed_attr_);
END Replicate;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- REPLICATION SEND IMPLEMENTATION METHODS ---------------------


-------------------- REPLICATION SEND PRIVATE METHODS ----------------------------


-------------------- REPLICATION SEND PROTECTED METHODS --------------------------


-------------------- REPLICATION SEND PUBLIC METHODS -----------------------------

