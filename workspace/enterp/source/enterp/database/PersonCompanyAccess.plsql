-----------------------------------------------------------------------------
--
--  Logical unit: PersonCompanyAccess
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  080910  Hiralk  Created for bug 76755.
--  100819  Hiralk  Bug 92534, Modified PERSON_COMPANY_ACCESS to allow cascade delete
--  110519  AsHelk  EASTONE-19202, Corrected Invalid References in view PERSON_COMPANY_ACCESS.
--  110718  Shdilk  FIDEAGLE-347, Merged bug 94972, added several methods to support cascade delete
--  130614  DipeLK  TIBE-726, Removed global variable which is used to check the exsistance of ACCRUL component
--  151012  chiblk  STRFI-233  Creating records using New___ method
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Do_Cascade___ (
   person_id_    IN VARCHAR2,
   action_       IN VARCHAR2 )
IS
   info_            VARCHAR2(2000);   
   CURSOR get_records IS
      SELECT ROWID objid, 
             TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM   person_company_access_tab
      WHERE  person_id = person_id_;
BEGIN
   FOR comp_ IN get_records LOOP
      Remove__(info_, comp_.objid, comp_.objversion, action_);
   END LOOP;   
END Do_Cascade___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT person_company_access_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.person_id IS NOT NULL) THEN
      Person_Info_API.Exist(newrec_.person_id);
   END IF;   
   super(newrec_, indrec_, attr_);   
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cascade_Check_Delete__ (
   attr_ IN VARCHAR2 )
IS
   person_id_   VARCHAR2(20);   
BEGIN
   person_id_ := SUBSTR(attr_, 1 , INSTR(attr_, '^', 1, 1) -1);
   Do_Cascade___(person_id_, 'CHECK');
END Cascade_Check_Delete__;


PROCEDURE Cascade_Do_Delete__ (
   attr_ IN VARCHAR2 )
IS
   person_id_   VARCHAR2(20);   
BEGIN
   person_id_ := SUBSTR(attr_, 1, INSTR(attr_, '^', 1, 1) -1);
   Do_Cascade___(person_id_, 'DO');
END Cascade_Do_Delete__;
          
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Person_Access (
   user_id_   IN VARCHAR2,
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
  user_companies_ VARCHAR2(32000);
  company_        VARCHAR2(20);
  instr_          NUMBER;
  temp_           NUMBER;
  CURSOR check_exist_person IS
     SELECT 1
     FROM   person_company_access_tab
     WHERE  company  = company_
     AND    person_id = person_id_;
BEGIN
   -- No limitation for access a person if the global parameter is not TRUE
   IF (NVL(Object_Property_API.Get_Value('PersonCompanyAccess', '*', 'RESTRICT_PERSON'), 'FALSE') != 'TRUE') THEN
       RETURN 'TRUE';
   END IF;
   -- No limitation for access a person to appowner
   IF (user_id_ = Fnd_Session_API.Get_App_Owner) THEN
      RETURN 'TRUE';
   END IF;
   -- No limitation for access a person if the user_id is same as person user
   IF (user_id_ = PERSON_INFO_API.Get_User_Id(person_id_)) THEN
      RETURN 'TRUE';
   END IF;
   $IF Component_Accrul_SYS.INSTALLED $THEN 
      user_companies_ := User_Finance_API.Get_Company_List(user_id_);
      instr_  := INSTR(user_companies_, '^');
      WHILE (instr_ != 0) AND (user_companies_ IS NOT NULL ) AND (user_companies_ != '^') LOOP
         company_          := SUBSTR(user_companies_, 1, instr_-1);
         user_companies_   := SUBSTR(user_companies_, instr_+1);
         OPEN check_exist_person;
         FETCH check_exist_person INTO temp_;
         IF (check_exist_person%FOUND) THEN
            CLOSE check_exist_person;
            RETURN 'TRUE';
         END IF;
         CLOSE check_exist_person;
         instr_ := INSTR(user_companies_, '^');
      END LOOP;
      RETURN 'FALSE';
   $ELSE
      RETURN 'TRUE';
   $END
END Check_Person_Access;


PROCEDURE New (
   company_   IN VARCHAR2,
   person_id_ IN VARCHAR2 )
IS
   newrec_    person_company_access_tab%ROWTYPE;
BEGIN
   newrec_.company   := company_;
   newrec_.person_id := person_id_;
   New___(newrec_);
END New;


@UncheckedAccess
FUNCTION Check_Exist (
   company_   IN VARCHAR2,
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(company_, person_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE Validate_Parameter (
   object_lu_      IN VARCHAR2,
   object_key_     IN VARCHAR2,
   property_name_  IN VARCHAR2,
   property_value_ IN VARCHAR2 )
IS
BEGIN
   IF (object_lu_ = 'PersonCompanyAccess') THEN
      IF (object_key_ = '*') THEN
         IF (property_name_ = 'RESTRICT_PERSON') THEN
            IF (NVL(property_value_, ' ') NOT IN ('TRUE', 'FALSE')) THEN
               Error_SYS.Record_General(lu_name_, 'NOTVALIDEVENT: Valid values for property (:P1) are (:P2).', object_lu_||','||object_key_||','||property_name_, 'TRUE/FALSE');
            END IF;
         END IF;
      END IF;
   END IF; 
END Validate_Parameter;



