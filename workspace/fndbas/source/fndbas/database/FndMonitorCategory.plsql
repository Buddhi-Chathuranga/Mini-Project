-----------------------------------------------------------------------------
--
--  Logical unit: FndMonitorCategory
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000830  ROOD    Created for Foundation1 3.0.1 (ToDo#3932).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Import (
   category_id_ IN VARCHAR2,
   description_ IN VARCHAR2,
   order_seq_   IN VARCHAR2 DEFAULT NULL
   )
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(32000);
BEGIN
   IF Fnd_Monitor_Category_API.Exists(category_id_) THEN
      SELECT objid, objversion
         INTO objid_, objversion_
         FROM fnd_monitor_category
         WHERE category_id = category_id_;
      Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
      Client_SYS.Add_To_Attr('ORDER_SEQ', order_seq_, attr_);
      Fnd_Monitor_Category_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Client_SYS.Add_To_Attr('CATEGORY_ID', category_id_, attr_);
      Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
      Client_SYS.Add_To_Attr('ORDER_SEQ', order_seq_, attr_);
      Fnd_Monitor_Category_API.New__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
END Import;