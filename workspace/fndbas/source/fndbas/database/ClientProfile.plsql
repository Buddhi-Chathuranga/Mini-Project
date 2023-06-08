-----------------------------------------------------------------------------
--
--  Logical unit: ClientProfile
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191028  ratslk  TSMI-66: Profiles
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FNDRR_CLIENT_PROFILE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.created_by   := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_date := sysdate;
   IF (newrec_.profile_id IS NULL) THEN
      newrec_.profile_id := sys_guid;
      Client_SYS.Add_To_Attr('PROFILE_ID', newrec_.profile_id, attr_);
   END IF;   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Generate_XML_Name_For_Profile(
   profile_id_ IN Fndrr_Client_profile_Tab.profile_id%TYPE) RETURN VARCHAR2
IS
   file_name_ VARCHAR2(100);
BEGIN
   file_name_ := 'Profile_' || Fndrr_Client_Profile_API.Get_Profile_Name(profile_id_) || ' - ' || to_char(sysdate, 'YYYY-MM-DD') || '.xml';
   RETURN file_name_;
END Generate_XML_Name_For_Profile;