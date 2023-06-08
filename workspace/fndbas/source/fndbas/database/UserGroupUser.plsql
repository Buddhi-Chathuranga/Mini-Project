-----------------------------------------------------------------------------
--
--  Logical unit: UserGroupUser
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  051101  JEHUSE Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT user_group_user_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Clear_Client_Cache___();
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     user_group_user_tab%ROWTYPE,
   newrec_     IN OUT user_group_user_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Clear_Client_Cache___();
END Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN user_group_user_tab%ROWTYPE )
IS
BEGIN
   --Add pre-processing code here
   super(objid_, remrec_);
   Clear_Client_Cache___();
END Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Clear_Client_Cache___
IS
   PRAGMA autonomous_transaction;
BEGIN
   Fnd_Admin_Jms_API.Send_Jms_Message('CLEAR_USERGROUPS_CACHE', '' , 'ifsapp-int');
   @ApproveTransactionStatement(2020-03-03, tofuse)
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line('Error occured while requesting refresh of middle-tier client usergroup cache.');
      dbms_output.put_line('Error was: '||SUBSTR(SQLERRM, 1, 200));
END Clear_Client_Cache___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
