-----------------------------------------------------------------------------
--
--  Logical unit: FndUserPin
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

PROCEDURE Validate_Pin___ (
   user_pin_ IN NUMBER )
IS
   pin_code_length_ NUMBER;
BEGIN
   pin_code_length_ := LENGTH(TO_CHAR(user_pin_));
   IF pin_code_length_ != 6 THEN
      Error_SYS.Record_General(lu_name_, 'BADPINCODE: A PIN code must consist of 6 digits.');
   END IF;
END Validate_Pin___;

FUNCTION Pin_Enabled___ RETURN BOOLEAN
IS
BEGIN
   RETURN Fnd_Setting_API.Get_Value('AUR_CHKPT_TYPE') = 'PIN';
END;

FUNCTION Get_Hashed_User_Pin_Code___ ( 
   user_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   user_pin_ VARCHAR2(100);
   
   CURSOR get_pin IS
   SELECT hashed_user_pin
   FROM FND_USER_PIN_TAB
   WHERE user_identity = user_name_;
BEGIN
   OPEN get_pin;
   FETCH get_pin INTO user_pin_;
   CLOSE get_pin;
   
   RETURN user_pin_;
END Get_Hashed_User_Pin_Code___;

FUNCTION Get_User_Salt___ (
   user_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   user_salt_ VARCHAR2(100);
   
   CURSOR get_salt IS
   SELECT salt
   FROM FND_USER_PIN_TAB
   WHERE user_identity = user_name_;
BEGIN
   OPEN get_salt;
   FETCH get_salt INTO user_salt_;
   CLOSE get_salt;
   
   RETURN user_salt_;
END Get_User_Salt___;

FUNCTION User_Has_Pin_Code___ (
   user_name_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN NOT Get_Hashed_User_Pin_Code___(user_name_) IS NULL;
END User_Has_Pin_Code___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION User_Has_Pin_Code (
   user_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   IF User_Has_Pin_Code___(user_name_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END User_Has_Pin_Code;

FUNCTION Check_User_Pin_Code (
   user_identity_ IN VARCHAR2,
   user_pin_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   hashed_user_pin_ VARCHAR2(100);
   user_salt_ VARCHAR2(100);
   hashed_and_salted_input_ VARCHAR2(100);
BEGIN
   IF NOT User_Has_Pin_Code___(user_identity_) THEN
      Error_SYS.Record_General(lu_name_, 'PINNOTSET: PIN not set');
   END IF;
   
   IF FND_USER_PIN_MONITOR_API.Is_User_Pin_Suspended(user_identity_) THEN
      Error_SYS.Record_General(lu_name_, 'USERPINSUSPENDED: User PIN suspended');
   END IF;
   
   hashed_user_pin_ := Get_Hashed_User_Pin_Code___(user_identity_);
   user_salt_ := Get_User_Salt___(user_identity_);
   SELECT STANDARD_HASH(CONCAT(user_salt_, user_pin_), 'SHA256') INTO hashed_and_salted_input_ FROM dual;
   
   IF hashed_and_salted_input_ = hashed_user_pin_ THEN
      FND_USER_PIN_MONITOR_API.Clear_Failed_Attempts(user_identity_);
   RETURN 'TRUE';
   ELSE
      IF (Fnd_Setting_API.Get_Value('AUR_CHKPT_PIN_SUSP') = 'ON') THEN
         IF (Fnd_Setting_API.Get_Value('AUR_CHKPT_ALLUSERS') = 'ON') OR
            ((Fnd_Setting_API.Get_Value('AUR_CHKPT_ALLUSERS') = 'OFF') AND
            (Fnd_Session_API.Get_Fnd_User = user_identity_ )) THEN
               FND_USER_PIN_MONITOR_API.Wrong_Pin_Entered(user_identity_);
         END IF;
      END IF; 
      RETURN 'FALSE';
   END IF;
END Check_User_Pin_Code;

PROCEDURE Set_User_Pin (
   user_identity_ IN VARCHAR2,
   user_pin_ IN NUMBER)
IS
   info_ VARCHAR2(32000);
   objid_ Fnd_User_Pin.objid%TYPE;
   objversion_ Fnd_User_Pin.objversion%TYPE;
   attr_ VARCHAR2(2000);
   salt_ VARCHAR2(100);
   hashed_and_salted_user_pin_ VARCHAR2(100); 
   
BEGIN
   IF NOT Pin_Enabled___ THEN
       Error_SYS.Record_General(lu_name_, 'PINDISABLED: PIN code functionality is disabled.');
   ELSIF Fnd_User_Pin_API.Exists(user_identity_) THEN
      Error_SYS.Record_General(lu_name_, 'USERALREADYHASPINCODE: User already has a PIN code.');
   ELSE
      Validate_Pin___(user_pin_);
      
      salt_ := dbms_crypto.randombytes(32);
      SELECT STANDARD_HASH(CONCAT(salt_, user_pin_), 'SHA256') INTO hashed_and_salted_user_pin_ FROM dual;
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('USER_IDENTITY', user_identity_, attr_);
      Client_SYS.Add_To_Attr('HASHED_USER_PIN', hashed_and_salted_user_pin_, attr_);
      Client_SYS.Add_To_Attr('SALT', salt_, attr_);

      New__(info_, objid_, objversion_, attr_, 'DO');
      
      -- Add user to pin monitor tab:
      FND_USER_PIN_MONITOR_API.Add_User_To_Monitor_Tab(user_identity_);
      
   END IF;
END Set_User_Pin;

PROCEDURE Change_User_Pin (
   user_identity_ IN VARCHAR2,
   old_user_pin_ IN NUMBER,
   new_user_pin_ IN NUMBER)
IS
   info_ VARCHAR2(32000);
   objid_ Fnd_User_Pin.objid%TYPE;
   objversion_ Fnd_User_Pin.objversion%TYPE;
   attr_ VARCHAR2(2000);
   old_salt_ VARCHAR2(100);
   new_salt_ VARCHAR2(100);
   hashed_and_salted_old_user_pin_ VARCHAR2(100);
   hashed_and_salted_new_user_pin_ VARCHAR2(100);
   
BEGIN
   old_salt_ := Get_User_Salt___(user_identity_);
   SELECT STANDARD_HASH(CONCAT(old_salt_, old_user_pin_), 'SHA256') INTO hashed_and_salted_old_user_pin_ FROM dual;
   
   new_salt_ := dbms_crypto.randombytes(32);
   SELECT STANDARD_HASH(CONCAT(new_salt_, new_user_pin_), 'SHA256') INTO hashed_and_salted_new_user_pin_ FROM dual;
   
   IF NOT Pin_Enabled___ THEN
       Error_SYS.Record_General(lu_name_, 'PINDISABLED: PIN code functionality is disabled.');
   ELSIF Fnd_User_Pin_API.Exists(user_identity_) THEN
      IF old_user_pin_ = new_user_pin_ THEN
         Error_SYS.Record_General(lu_name_, 'SAMEPIN: The new PIN code must differ from the old.');
              
      ELSIF Get_Hashed_User_Pin_Code___(user_identity_) = hashed_and_salted_old_user_pin_ THEN   
         Validate_Pin___(new_user_pin_);
         
         Get_Id_Version_By_Keys___(objid_, objversion_, user_identity_);
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('HASHED_USER_PIN', hashed_and_salted_new_user_pin_, attr_);
         Client_SYS.Add_To_Attr('SALT', new_salt_, attr_);
         Modify__(info_, objid_, objversion_, attr_, 'DO');
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECTPINCODE: Incorrect PIN code.');
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, 'USERHASNOPINCODE: User has no PIN code.');
   END IF;
END Change_User_Pin;

PROCEDURE Remove (
   user_identity_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
   objid_ Fnd_User_Pin.objid%TYPE;
   objversion_ Fnd_User_Pin.objversion%TYPE;
   
   CURSOR get_rec IS
     SELECT objid, objversion
     FROM Fnd_User_Pin
     WHERE user_identity = user_identity_;
BEGIN
   OPEN get_rec;
   FETCH get_rec INTO objid_, objversion_;
   CLOSE get_rec;
	Fnd_User_Pin_API.Remove__(info_, objid_, objversion_, 'DO');
END Remove;
