-----------------------------------------------------------------------------
--
--  Logical unit: DataSubject
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180621  Krwipl  Bug 141992, Planned Cleanup of Unauthorized Data
--  171221  Piwrpl  Created, LCS 139441, GDPR implemented 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PERSONAL_DATA_MANAGEMENT', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('NO_HISTORY_DATA_CLEANUP', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     data_subject_tab%ROWTYPE,
   newrec_ IN OUT data_subject_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   param_name_ VARCHAR2(20);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF indrec_.no_history_data_cleanup AND newrec_.no_history_data_cleanup = 'TRUE' THEN
      IF (newrec_.data_subject_id = 'PERSON_DEPENDENT') THEN
         param_name_ := 'DEPENDENTS';
      ELSE
         param_name_ := newrec_.data_subject_id;
      END IF;
      IF NVL(Personal_Data_Man_Util_API.Get_Schedule_Method_Flag('PERSONAL_DATA_MAN_UTIL_API.REMOVE_WITHOUT_CONSENT_HISTORY', param_name_),'FALSE') != 'TRUE' THEN
         Error_SYS.Appl_General(lu_name_, 'PARAMDISABLEED: The cleanup of unlawfully processed data cannot be scheduled, if the data subject is excluded from the automatic data cleanup procedure.');
      END IF;
   END IF;
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Enumerate_Active (
   client_values_ OUT VARCHAR2 )
IS
   temp_ VARCHAR2(32000);
   CURSOR get_client_values IS
      SELECT SUBSTR(NVL(Basic_Data_Translation_API.Get_Basic_Data_Translation('ENTERP', 'DataSubject', data_subject_id), data_subject), 1, 50) data_subject
      FROM   data_subject_tab
      WHERE  personal_data_management = 'TRUE'
      AND    data_subject_id NOT IN ('USER','DEPENDENTS','BUSINESS_CONTACTS')
      ORDER  BY data_subject_id ASC;
BEGIN
   FOR rec_ IN get_client_values LOOP
      temp_ := temp_||rec_.data_subject||Client_SYS.field_separator_;
   END LOOP;
   client_values_ := temp_;
END Enumerate_Active;


PROCEDURE Enumerate_Pers_Data_Management (
   client_values_           IN OUT VARCHAR2,
   pers_data_management_id_ IN     NUMBER )
IS
   temp_ VARCHAR2(32000);
   CURSOR get_client_values IS
      SELECT SUBSTR(NVL(Basic_Data_Translation_API.Get_Basic_Data_Translation('ENTERP', 'DataSubject', d.data_subject_id), d.data_subject), 1, 50) data_subject, data_subject_id
      FROM   data_subject_tab d
      WHERE  d.personal_data_management = 'TRUE'      
      AND    EXISTS (SELECT 1
                     FROM   personal_data_man_det_tab p
                     WHERE  p.pers_data_management_id = pers_data_management_id_
                     AND    p.exclude_from_cleanup = 'FALSE'
                     AND    Report_Sys.Parse_Parameter(d.data_subject_id, Personal_Data_Man_Util_api.Get_Related_Data_Subjects(p.data_subject, 'REVERSE')) = 'TRUE')
      ORDER  BY data_subject_id ASC;
BEGIN
   FOR rec_ IN get_client_values LOOP
      IF NOT(rec_.data_subject_id = 'USER' OR rec_.data_subject_id = 'DEPENDENTS' OR rec_.data_subject_id = 'BUSINESS_CONTACTS') THEN
         temp_ := temp_||rec_.data_subject||Client_SYS.field_separator_;
      END IF;
   END LOOP;
   client_values_ := temp_;
END Enumerate_Pers_Data_Management;


PROCEDURE Enumerate_Active_Db (
   db_values_ OUT VARCHAR2 )
IS
   temp_ VARCHAR2(32000);
   CURSOR get_db_values IS
      SELECT data_subject_id
      FROM   data_subject_tab
      WHERE  personal_data_management = 'TRUE'      
      ORDER  BY data_subject_id ASC;
BEGIN
   FOR rec_ IN get_db_values LOOP
      temp_ := temp_||rec_.data_subject_id||Client_SYS.field_separator_;
   END LOOP;
   db_values_ := temp_;
END Enumerate_Active_Db;


PROCEDURE Clear_Clean_Up_Flag (
   data_subject_id_ IN VARCHAR2 )
IS
   newrec_ data_subject_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(data_subject_id_);
   newrec_.no_history_data_cleanup := 'FALSE';
   Modify___(newrec_);
END Clear_Clean_Up_Flag;


PROCEDURE Insert_Data_Subject (
   data_subject_id_             IN VARCHAR2,
   data_subject_                IN VARCHAR2,
   personal_data_management_    IN VARCHAR2,
   no_history_data_cleanup_     IN VARCHAR2 )
IS
   newrec_ data_subject_tab%ROWTYPE;
BEGIN
   IF NOT Data_Subject_API.Exists(data_subject_id_) THEN   
      newrec_.data_subject_id := data_subject_id_;
      newrec_.data_subject := data_subject_;
      newrec_.personal_data_management := personal_data_management_;
      newrec_.no_history_data_cleanup := no_history_data_cleanup_;
      New___(newrec_);
   END IF;
END Insert_Data_Subject;