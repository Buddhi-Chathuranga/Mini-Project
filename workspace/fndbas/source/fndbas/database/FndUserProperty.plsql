-----------------------------------------------------------------------------
--
--  Logical unit: FndUserProperty
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970417  JaPa  Created
--  971014  TOWR  Added CASCADE
--  990705  ERFO  Applied usage of Language_SYS.Exist and rewrite
--                of method Set_Value (ToDo #3430).
--  990804  ERFO  Changed model property for column VALUE (ToDo #3481).
--  000525  ERFO  Added validation of property PRES_OBJECT_SEC_SETUP.
--  011207  ROOD  Added validation of property DEFAULT_PAPER_FORMAT (ToDo#4056).
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  050906  NiWi  Validate_User___: Added validation to new/modify to make it 
--                consistant with Fnd_User_API.Set_Property(Bug#52321).
--  200511  YATI  Added user sync support for maintenix
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
PROCEDURE Remove (
   identity_ IN VARCHAR2,
   name_     IN VARCHAR2)
IS
   info_ VARCHAR2(200);
   objid_ VARCHAR2(50);
   objversion_ VARCHAR2(40);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, identity_, name_);
   Remove__(info_, objid_, objversion_, 'DO');   
END Remove;

-------------------- PRIVATE DECLARATIONS -----------------------------------


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     fnd_user_property_tab%ROWTYPE,
   newrec_ IN OUT fnd_user_property_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate_User___(newrec_.identity);
   IF (newrec_.name = 'PREFERRED_LANGUAGE') THEN
      Language_SYS.Exist(newrec_.value);
   ELSIF (newrec_.name = 'DEFAULT_PAPER_FORMAT') THEN
      IF (newrec_.value != 'SYSTEM-DEFINED') OR (newrec_.value IS NULL) THEN
         Paper_Format_API.Exist_Db(newrec_.value);
      END IF;
   END IF;
END Check_Common___;




@Override
PROCEDURE Check_Delete___ (
   remrec_ IN FND_USER_PROPERTY_TAB%ROWTYPE )
IS
BEGIN
   Validate_User___(remrec_.identity);
   super(remrec_);
END Check_Delete___;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_User___ (
   identity_ IN VARCHAR2)
IS
BEGIN
   IF (identity_ != Fnd_Session_API.Get_Fnd_User AND NOT Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User)) THEN
      Error_SYS.Appl_General(lu_name_, 'NOUSRPRPUPDATE: You can not as user ":P1" change properties of user ":P2".', Fnd_Session_API.Get_Fnd_User, identity_);
   END IF;
END Validate_User___;

@Override
PROCEDURE Insert___ (
   objid_      OUT           VARCHAR2,
   objversion_ OUT           VARCHAR2,
   newrec_     IN OUT NOCOPY fnd_user_property_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   
   $IF Component_Mxcore_SYS.INSTALLED $THEN    
      Mx_User_Util_API.Perform_Update(lu_name_, NULL, Pack___(newrec_));
   $END
   
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN            VARCHAR2,
   oldrec_     IN            fnd_user_property_tab%ROWTYPE,
   newrec_     IN OUT NOCOPY fnd_user_property_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2,
   objversion_ IN OUT NOCOPY VARCHAR2,
   by_keys_    IN            BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_,oldrec_,newrec_,attr_,objversion_,by_keys_);
   
   $IF Component_Mxcore_SYS.INSTALLED $THEN    
      Mx_User_Util_API.Perform_Update(lu_name_, Pack___(oldrec_), Pack___(newrec_));
   $END
   
END Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN fnd_user_property_tab%ROWTYPE )
IS
BEGIN
   super(objid_,remrec_);
   
   $IF Component_Mxcore_SYS.INSTALLED $THEN    
      Mx_User_Util_API.Perform_Update(lu_name_, NULL, Pack___(remrec_));
   $END
   
END Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Value (
   identity_ IN VARCHAR2,
   name_     IN VARCHAR2,
   value_    IN VARCHAR2 )
IS
   objid_     VARCHAR2(2000);
   objv_      VARCHAR2(2000);
   attr_      VARCHAR2(2000);
   info_      VARCHAR2(2000);
   exist_err  EXCEPTION;
   PRAGMA     exception_init(exist_err, -20112);
BEGIN
   Client_SYS.Add_To_Attr('IDENTITY', identity_, attr_);
   Client_SYS.Add_To_Attr('NAME', name_, attr_);
   Client_SYS.Add_To_Attr('VALUE', value_, attr_);
   New__(info_, objid_, objv_, attr_, 'DO');
EXCEPTION
   WHEN exist_err THEN
      SELECT objid, objversion
         INTO objid_, objv_
      FROM fnd_user_property
      WHERE identity = identity_
      AND   name = name_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('VALUE', value_, attr_);
      Modify__(info_, objid_, objv_, attr_, 'DO');
END Set_Value;


@UncheckedAccess
FUNCTION Find_Value (
   identity_      IN VARCHAR2,
   name_          IN VARCHAR2,
   default_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_ FND_USER_PROPERTY.value%TYPE;
   CURSOR getvalue IS
      SELECT value
      FROM   FND_USER_PROPERTY
      WHERE  identity = identity_
      AND    name = name_;
BEGIN
   OPEN getvalue;
   FETCH getvalue INTO value_;
   IF (getvalue%NOTFOUND) THEN
      CLOSE getvalue;
      RETURN default_value_;
   END IF;
   CLOSE getvalue;
   RETURN value_;
END Find_Value;

