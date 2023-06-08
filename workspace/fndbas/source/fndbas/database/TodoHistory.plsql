-----------------------------------------------------------------------------
--
--  Logical unit: TodoHistory
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

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Add_History_Item__(
   todo_item_id_ VARCHAR2,
   sender_ VARCHAR2,
   reciever_ VARCHAR2 )
IS
   newrec_ todo_history_tab%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);   
BEGIN   
   newrec_.item_id := todo_item_id_;
   newrec_.history_id := sys_guid();
   $IF Component_Enterp_SYS.INSTALLED $THEN
      newrec_.receiver := Person_Info_API.Get_Name(reciever_);
      newrec_.sender := Person_Info_API.Get_Name(sender_);
   $ELSE
      newrec_.receiver := reciever_;
      newrec_.sender := sender_;
   $END
   newrec_.sent := sysdate;
   Insert___(objid_, objversion_, newrec_, attr_);
END Add_History_Item__;

