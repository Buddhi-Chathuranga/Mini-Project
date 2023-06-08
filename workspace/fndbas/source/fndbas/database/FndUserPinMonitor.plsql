-----------------------------------------------------------------------------
--
--  Logical unit: FndUserPinMonitor
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

PROCEDURE Release_User_Pin___ (
   user_identity_ IN VARCHAR2)
IS
   PRAGMA autonomous_transaction;
   objid_ Fnd_User_Pin_Monitor.objid%TYPE;
   objversion_ Fnd_User_Pin_Monitor.objversion%TYPE;
   attr_ VARCHAR2(2000);
   info_ VARCHAR2(32000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, user_identity_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FAILED_ATTEMPTS', 0, attr_);
   Client_SYS.Add_To_Attr('PIN_SUSPENDED', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ROWVERSION', SYSDATE, attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
   @ApproveTransactionStatement(2019-11-25,taorse)
   COMMIT;
END Release_User_Pin___;

FUNCTION Get_Failed_Attempts___ (
   user_identity_ IN VARCHAR2) RETURN NUMBER

IS
   failed_attempts_ NUMBER;
   
   CURSOR get_failed_attempts IS
   SELECT failed_attempts 
   FROM FND_USER_PIN_MONITOR_TAB
   WHERE user_identity = user_identity_;
BEGIN
   OPEN get_failed_attempts;
   FETCH get_failed_attempts
   INTO failed_attempts_;
   CLOSE get_failed_attempts;
   RETURN failed_attempts_;
END Get_Failed_Attempts___;

PROCEDURE Register_Failed_Attempt___ (
   user_identity_ IN VARCHAR2,
   failed_attempts_ IN NUMBER)
   
IS
   PRAGMA autonomous_transaction;
   
   objid_ Fnd_User_Pin_Monitor.objid%TYPE;
   objversion_ Fnd_User_Pin_Monitor.objversion%TYPE;
   attr_ VARCHAR2(2000);
   info_ VARCHAR2(32000);
   
BEGIN 
   Get_Id_Version_By_Keys___(objid_, objversion_, user_identity_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FAILED_ATTEMPTS', failed_attempts_, attr_);
   Client_SYS.Add_To_Attr('ROWVERSION', SYSDATE, attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
   @ApproveTransactionStatement(2019-11-25,taorse)
   COMMIT;

END Register_Failed_Attempt___;

PROCEDURE Suspend_User_Pin___ (
   user_identity_ IN VARCHAR2)
IS
   PRAGMA autonomous_transaction;
   
   objid_ Fnd_User_Pin_Monitor.objid%TYPE;
   objversion_ Fnd_User_Pin_Monitor.objversion%TYPE;
   attr_ VARCHAR2(2000);
   info_ VARCHAR2(32000);
   
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, user_identity_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FAILED_ATTEMPTS', 3, attr_);
   Client_SYS.Add_To_Attr('PIN_SUSPENDED', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('ROWVERSION', SYSDATE, attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
   @ApproveTransactionStatement(2019-11-25,taorse)
   COMMIT;
END Suspend_User_Pin___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Add_User_To_Monitor_Tab (
   user_identity_ IN VARCHAR2 )
IS
   info_ VARCHAR2(32000);
   objid_ Fnd_User_Pin.objid%TYPE;
   objversion_ Fnd_User_Pin.objversion%TYPE;
   attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('USER_IDENTITY', user_identity_, attr_);
   Client_SYS.Add_To_Attr('FAILED_ATTEMPTS', 0, attr_);
   Client_SYS.Add_To_Attr('PIN_SUSPENDED', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ROWVERSION', SYSDATE, attr_);
      
   New__(info_, objid_, objversion_, attr_, 'DO');
END Add_User_To_Monitor_Tab;
   

FUNCTION Is_User_Pin_Suspended (
 user_identity_ IN VARCHAR2  ) RETURN BOOLEAN
   
IS
   pin_suspended_ VARCHAR2(10);
   rowversion_ DATE;
   timestamp_age_ NUMBER;

   CURSOR check_suspended_pin IS
   SELECT pin_suspended, rowversion
   FROM FND_USER_PIN_MONITOR_TAB
   WHERE user_identity = user_identity_;
   
BEGIN
   OPEN check_suspended_pin;
   FETCH check_suspended_pin
   INTO pin_suspended_, rowversion_;
   CLOSE check_suspended_pin;
   
   timestamp_age_ := (SYSDATE- rowversion_)*1440;
   
   IF pin_suspended_ IS NULL THEN
      RETURN FALSE; -- user not in table
   ELSIF pin_suspended_ = 'TRUE' AND timestamp_age_ < 15 THEN
      RETURN TRUE;
   ELSIF pin_suspended_ = 'FALSE' THEN
      RETURN FALSE;
   ELSIF pin_suspended_ = 'TRUE' AND timestamp_age_ >= 15 THEN
      Release_User_Pin___(user_identity_);
   RETURN FALSE;
   END IF;
END Is_User_Pin_Suspended;

PROCEDURE Wrong_Pin_Entered (
   user_identity_ IN VARCHAR2 )
IS
   failed_attempts_ NUMBER;
BEGIN
   failed_attempts_ := Get_Failed_Attempts___(user_identity_) +1;
   Register_Failed_Attempt___(user_identity_, failed_attempts_);
   
   IF failed_attempts_ = 3 THEN
      Suspend_User_Pin___(user_identity_);
   END IF;
  
END Wrong_Pin_Entered; 

 
PROCEDURE Clear_Failed_Attempts (
   user_identity_ IN VARCHAR2)
IS
   objid_ Fnd_User_Pin_Monitor.objid%TYPE;
   objversion_ Fnd_User_Pin_Monitor.objversion%TYPE;
   attr_ VARCHAR2(2000);
   info_ VARCHAR2(32000);
BEGIN   
   Get_Id_Version_By_Keys___(objid_, objversion_, user_identity_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('FAILED_ATTEMPTS', 0, attr_);
   Client_SYS.Add_To_Attr('ROWVERSION', SYSDATE, attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Clear_Failed_Attempts;
