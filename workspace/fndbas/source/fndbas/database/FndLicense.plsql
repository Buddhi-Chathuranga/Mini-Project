-----------------------------------------------------------------------------
--
--  Logical unit: FndLicense
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
-- 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Value (
   parameter_ IN VARCHAR2,
   value_     IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      FND_LICENSE.objid%TYPE;
   objversion_ FND_LICENSE.objversion%TYPE;
   attr_       VARCHAR2(2000);
BEGIN
   IF (Check_Exist___(parameter_)) THEN
      --parameter exists, perform update.
      Client_SYS.Clear_Attr( attr_ );
      Client_SYS.Add_To_Attr( 'VALUE', value_, attr_ );
      Get_Id_Version_By_Keys___(objid_, objversion_, parameter_);
      Modify__(info_, objid_, objversion_, attr_, 'DO');
   ELSE     
         --parameter doesn't exist and shouldn't be created.
      Error_SYS.Record_Not_Exist(lu_name_);      
   END IF;
END Set_Value;


@UncheckedAccess
PROCEDURE Security_LTU_Impact
IS
      installation_start_date_ DATE;
      CURSOR Get_Start_Date IS
      SELECT LOGON_TIME
        FROM sys.v_$session
        WHERE  audsid = userenv('SESSIONID');
BEGIN
    -- To be used by installer
    OPEN Get_Start_Date;
    FETCH Get_Start_Date INTO installation_start_date_;
    CLOSE Get_Start_Date;

    Security_LTU_Impact(installation_start_date_);

END Security_LTU_Impact;


@UncheckedAccess
PROCEDURE Security_LTU_Impact(installation_start_date_ IN DATE)
IS
         CURSOR Exist_Modifications IS
                SELECT g.po_id,g.role,p.description,p.change_info FROM pres_object p,pres_object_grant g
                WHERE p.po_id = g.po_id
                --AND TO_CHAR(p.change_date,'YYYY-MM-DD') >= TO_CHAR(installation_start_date_,'YYYY-MM-DD')
                AND p.change_date >= installation_start_date_
                AND g.role IN (SELECT r.role FROM FND_ROLE_TAB r
                WHERE nvl(r.limited_task_user,'FALSE') = 'TRUE')
                ORDER BY g.role;
          role_ VARCHAR2(50) := 'no_role';

BEGIN
   FOR rec_ IN Exist_Modifications LOOP
        IF (rec_.role <> role_) THEN
                role_ := rec_.role;
               Log_SYS.Fnd_Trace_(Log_SYS.error_, '');
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Permission Set ' || rec_.role || ' contains presentation objects that has changed.');
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Verify the functionality for users using License for ' || rec_.role );
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Update the permission set accordingly. No new license is needed in order to just grant additional server methods or new dialogs. Only when granting new main window forms');
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Modified Presentation Objects are ');
               Log_SYS.Fnd_Trace_(Log_SYS.error_, '');

        END IF;

        Log_SYS.Fnd_Trace_(Log_SYS.error_, rec_.po_id || '          ' || rec_.description);
   END LOOP;
END Security_LTU_Impact;

@UncheckedAccess
FUNCTION Get_Expiration_Date RETURN DATE
IS
   date_ DATE;
BEGIN
   SELECT decode(value, '*', to_date(NULL), to_date(value, 'YYYYMMDD')) INTO date_ FROM fnd_license WHERE parameter = 'EXPIRE_DATE';
   RETURN date_;
END Get_Expiration_Date;


@UncheckedAccess
FUNCTION Get_Consumed_Full_Users RETURN NUMBER
IS
   count_ NUMBER;
BEGIN
   SELECT count(*) INTO count_ FROM fnd_full_user;
   RETURN count_;
END Get_Consumed_Full_Users;


@UncheckedAccess
FUNCTION Get_Licensed_Full_Users RETURN NUMBER
IS
   count_ NUMBER;
BEGIN
   SELECT decode(value, '*', NULL, to_number(value)) INTO count_ FROM fnd_license WHERE parameter = 'NUMBER_OF_FULL_USERS';
   RETURN count_;
END Get_Licensed_Full_Users;
