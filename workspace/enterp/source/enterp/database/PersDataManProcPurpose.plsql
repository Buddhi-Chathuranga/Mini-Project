-----------------------------------------------------------------------------
--
--  Logical unit: PersDataManProcessPurpose
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171221  Piwrpl  Created, LCS 139441, GDPR implemented 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT pers_data_man_proc_purpose_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   personal_data_ personal_data_management_tab.personal_data%TYPE;
   purpose_name_ pers_data_process_purpose_tab.purpose_name%TYPE;
BEGIN
   IF (Client_SYS.Item_Exist('PERSONAL_DATA', attr_)) THEN
      personal_data_ := Client_SYS.Get_Item_Value('PERSONAL_DATA', attr_);
      newrec_.pers_data_management_id := Personal_Data_Management_Api.Encode(personal_data_);
      indrec_.pers_data_management_id := TRUE;
   END IF;
   IF (Client_SYS.Item_Exist('PURPOSE_NAME', attr_)) THEN
      purpose_name_ := Client_SYS.Get_Item_Value('PURPOSE_NAME', attr_);
      newrec_.purpose_id := Pers_Data_Process_Purpose_API.Encode(purpose_name_);
      indrec_.purpose_id := TRUE;
   END IF;
   super(newrec_, indrec_, attr_);      
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Any_Not_Connected_Data_Exists (
   data_subject_ IN VARCHAR2) RETURN VARCHAR2
IS
   temp_ VARCHAR2(10);
   CURSOR check_exists IS
   SELECT 1
   FROM  pers_data_man_proc_purp_all 
   WHERE data_subject = data_subject_
   AND   purpose_id = 0;
BEGIN
   OPEN check_exists;
   FETCH check_exists INTO temp_;
   IF check_exists%FOUND THEN
      CLOSE check_exists;
      RETURN 'TRUE';
   ELSE
      CLOSE check_exists;
      RETURN 'FALSE';
   END IF;
END Any_Not_Connected_Data_Exists;

PROCEDURE New_Data_Proc_Purpose (
   purpose_id_              IN NUMBER,
   pers_data_management_id_ IN NUMBER,
   data_subject_            IN VARCHAR2)
IS
   newrec_ pers_data_man_proc_purpose_tab%ROWTYPE;
BEGIN
   IF NOT(Check_Exist___ (purpose_id_, pers_data_management_id_, Data_Subject_Api.Encode(data_subject_))) THEN
      newrec_.pers_data_management_id := pers_data_management_id_;
      newrec_.data_subject := Data_Subject_Api.Encode(data_subject_);
      newrec_.purpose_id := purpose_id_;
      New___(newrec_);
   END IF; 
END New_Data_Proc_Purpose;

PROCEDURE Remove_Data_Proc_Purpose (
   purpose_id_              IN NUMBER,
   pers_data_management_id_ IN NUMBER,
   data_subject_            IN VARCHAR2)
IS
   remrec_ pers_data_man_proc_purpose_tab%ROWTYPE;
BEGIN
   remrec_ := Get_Object_By_Keys___ (purpose_id_, pers_data_management_id_, Data_Subject_Api.Encode(data_subject_));
   Remove___(remrec_);
END Remove_Data_Proc_Purpose;

FUNCTION Is_Pers_Data_Purpose_Selected (
   pers_data_management_id_        IN NUMBER,
   data_subject_         IN VARCHAR2,
   purpose_id_           IN NUMBER) RETURN VARCHAR2
IS
   tmp_ NUMBER;
   CURSOR get_pers_data_purp IS
   SELECT 1
   FROM   pers_data_man_proc_purpose_tab
   WHERE  pers_data_management_id = pers_data_management_id_
   AND    Data_Subject_Api.Decode(data_subject) = data_subject_
   AND    purpose_id = purpose_id_;
BEGIN
   OPEN get_pers_data_purp;
   FETCH get_pers_data_purp INTO tmp_;
   IF get_pers_data_purp%FOUND THEN
      CLOSE get_pers_data_purp;
      RETURN 'TRUE';
   ELSE
      CLOSE get_pers_data_purp;
      RETURN 'FALSE';
   END IF;
END Is_Pers_Data_Purpose_Selected;

@UncheckedAccess
FUNCTION Get_Purpose_Personal_Data_List (
   data_subject_ IN VARCHAR2,
   purpose_id_   IN NUMBER) RETURN VARCHAR2
IS
   ret_val_ VARCHAR2(2000);
   CURSOR get_pers_data_purp IS
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('ENTERP', 'PersonalDataManagement',
          m.pers_data_management_id), m.personal_data), 1, 30) personal_data
   FROM   pers_data_man_proc_purpose_tab p, personal_data_management_tab m
   WHERE  p.data_subject = data_subject_
   AND    p.purpose_id = purpose_id_
   AND    p.pers_data_management_id = m.pers_data_management_id;
BEGIN
   FOR rec_ IN get_pers_data_purp LOOP
      IF ret_val_ IS NULL THEN
         ret_val_ := rec_.personal_data;
      ELSE
         ret_val_ := ret_val_ ||' '|| chr(10) || rec_.personal_data;
      END IF;
   END LOOP;
   RETURN ret_val_;
END Get_Purpose_Personal_Data_List;

