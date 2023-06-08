-----------------------------------------------------------------------------
--
--  Logical unit: PartCopyEventParameter
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201222  SBalLK  Issue SC2020R1-11830, Modified New() method by removing attr_ functionality to optimize the performance.
--  201013  OsAllk  SC2020R1-10455, Replaced Component_Is_Installed with Component_Is_Active to check component ACTIVE/INACTIVE.
--  100913  Asawlk  Bug 92831, Modified New() method by adding a condition to only create
--  100913          new records if the particular module is installed. 
--  100423  KRPELK  Merge Rose Method Documentation.
--  090929  MaJalk  Removed unused variables.
--  ------------------------- 13.0.0 ------------------------------------------
--  050607  KeFelk  Added method Get_Latest_Event_No.
--  050606  KeFelk  Added User_id in order to introduced the default settings to the part copy dialog.
--  050110  KeFelk  Changes to Enabled___(), Site_Dependent_Enabled() and Site_Independent_Enabled().
--  050105  KeFelk  Added Enabled___(), Site_Dependent_Enabled() and Site_Independent_Enabled().
--  050104  KeFelk  Applied Code Review changes.
--  050103  KeFelk  Renamed the VIEW_JOIN as PART_COPY_EVENT_PARAMETER_EXT.
--  041217  KeFelk  Removed some columns in base view, added VIEW_JOIN and removed some
--  041217          parameters in New().
--  041216  SaRalk  Made attributes enabled, site_dependent, cancel_when_no_source and
--  041216          cancel_when_existing_copy Public.
--  041213  KeFelk  Added Cleanup_Part_Parameters & column date_created.
--  041213  SaRalk  Minor modification in base view.
--  041211  JaBalk  Modified method New.
--  041210  KeFelk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Enabled___
--   This method will loop over dataset_id's from all records having module
--   and event_no as sent in through the parameters. For each record compare
--   site_dependent attribute with the site_dependent parameter. As soon as
--   it finds a value that is equal then returns TRUE. Otherwise FALSE.
FUNCTION Enabled___ (
   event_no_          IN NUMBER,
   module_            IN VARCHAR2,
   site_dependent_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   result_      BOOLEAN := FALSE;
   dataset_rec_ Part_Copy_Module_Dataset_API.Public_Rec;

   CURSOR get_dataset_ids IS
      SELECT module, dataset_id
      FROM part_copy_event_parameter_tab
      WHERE event_no = event_no_
      AND ((module = module_) OR (module_ IS NULL));
BEGIN
   FOR rec_ IN get_dataset_ids LOOP
      dataset_rec_ := Part_Copy_Module_Dataset_API.Get(rec_.module, rec_.dataset_id);
      IF (dataset_rec_.site_dependent = site_dependent_db_) THEN
         result_ := TRUE;
         EXIT;
      END IF;
   END LOOP;
   RETURN result_;
END Enabled___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT part_copy_event_parameter_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.date_created := sysdate;
   newrec_.user_id      := Fnd_Session_Api.Get_Fnd_User;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   This method is used to insert a new record.
PROCEDURE New (
   event_no_                     IN NUMBER,
   module_                       IN VARCHAR2,
   dataset_id_                   IN VARCHAR2,
   enabled_db_                   IN VARCHAR2,
   cancel_when_no_source_db_     IN VARCHAR2,
   cancel_when_existing_copy_db_ IN VARCHAR2 )
IS
   newrec_     part_copy_event_parameter_tab%ROWTYPE;
BEGIN
   IF (Dictionary_SYS.Component_Is_Active(module_)) THEN
      newrec_.event_no                  := event_no_;
      newrec_.module                    := module_;
      newrec_.dataset_id                := dataset_id_;
      newrec_.enabled                   := enabled_db_;
      newrec_.cancel_when_no_source     := cancel_when_no_source_db_;
      newrec_.cancel_when_existing_copy := cancel_when_existing_copy_db_;
      New___(newrec_);
   END IF;
END New;


-- Cleanup_Part_Parameters
--   This method will deletes all records being older than one week or
--   records which have FALSE set to enabled flag.
--   Method  Part_Copy_Manager_Partca_Copy will makes a call to this method.
PROCEDURE Cleanup_Part_Parameters (
   event_no_ IN NUMBER )
IS
   CURSOR get_cleanup_data IS
      SELECT *
      FROM   part_copy_event_parameter_tab
      WHERE  date_created <= SYSDATE - 7
      OR     (event_no = event_no_ AND enabled = 'FALSE')
      FOR UPDATE;
BEGIN
   FOR cleanup_rec_ IN get_cleanup_data LOOP
      Remove___(cleanup_rec_);
   END LOOP;
END Cleanup_Part_Parameters;

-- Remove_Event
--   This method removes all records related to the event no
PROCEDURE Remove_Event (
   event_no_ IN NUMBER )
IS
   CURSOR get_event_records IS
      SELECT *
      FROM   part_copy_event_parameter_tab
      WHERE  event_no = event_no_
      FOR UPDATE;
BEGIN
   FOR record_ IN get_event_records LOOP
      Remove___(record_);
   END LOOP;
END Remove_Event;


-- Site_Dependent_Enabled
--   This method will be called before copying site dependant data, and
--   it will check if there are any site dependent |datasets enabled.
@UncheckedAccess
FUNCTION Site_Dependent_Enabled (
   event_no_ IN NUMBER,
   module_   IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Enabled___( event_no_, module_, 'TRUE' );
END Site_Dependent_Enabled;


-- Site_Independent_Enabled
--   This method will be called before copying site independant data, and
--   it will check if there are any site |independent datasets enabled.
@UncheckedAccess
FUNCTION Site_Independent_Enabled (
   event_no_ IN NUMBER,
   module_   IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Enabled___( event_no_, module_, 'FALSE' );
END Site_Independent_Enabled;


-- Get_Latest_Event_No
--   This method will returns the latest event no for a given user id.
@UncheckedAccess
FUNCTION Get_Latest_Event_No (
   user_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   event_no_ part_copy_event_parameter_tab.event_no%TYPE;
   CURSOR get_attr IS
      SELECT max(event_no)
        FROM part_copy_event_parameter_tab
       WHERE user_id = user_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO event_no_;
   CLOSE get_attr;
   RETURN event_no_;
END Get_Latest_Event_No;



