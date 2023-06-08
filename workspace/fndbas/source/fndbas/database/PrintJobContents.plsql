-----------------------------------------------------------------------------
--
--  Logical unit: PrintJobContents
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961022  MANY  Created
--  970806  MANY  Chenges concerning upgrade in Rose model
--  980728  MANY  Fixed erro message when retrieveing empty print job (Bug #2576)
--  980817  MANY  New method Check_Empty() (ToDo #2633)
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  990222  ERFO  Yoshimura: Changes in base view and Is_Distributed (ToDo #3160).
--  990320  ERFO  Changes in method Get_Report_Title and Check_Empty (Bug #3236).
--  000509  ROOD  Performance improvements in Is_Distributed (Bug #16093)
--  001002  BVLI  (NIWILK) Added 'PLUGIN_OPTIONS' for Orion II project (ToDo #3951)
--  020225  ROOD  Removed some unnecessary calls in New_Instance and Modify_Instance (ToDo#4088).
--  020226  ROOD  Updated template. Removed unused attribute printed (ToDo#4088).
--  020703  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--                Minor performance improvement in Check_Empty.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030704  RAKU  Added check upon Insert making report instances being "owned" by servers
--                of different kind not possible to insert (ToDo#4276).
--  041118  DOZE  Prevention of printjobs without layout and language (Bug #48079)
--  041123  DOZE  Previewing report with RepDes layout (Bug#48176)
--  050516  UTGULK  Added method Get_No_Of_Result_Keys (Bug#48789)
--  050722  NiWi  Prevention of printjobs without layout and language (Bug #52554)
--  051130  DOZE  Case checking on layout name
--  060214  UTGULK Moved Check_Layout___ method to Report_Layout_Definition.
--  060508  RARULK  Bug 57342 New method Get_Instance_Attr() added
--  080108  UTGULK Added error message if there no active layouts in Get_Layout_Type_Owner___(Bug #70440).
--  080129  VOHELK Bug 69330, Modified method Get_Layout_Type_Owner___
--  080514  SUBSLK Added new procedure Get_Instance_Attr (Bug#73722)
--  080904  UsRaLK Added new procedure Check_Already_Working___ (Bug#76521)
--  080910  UsRaLK Modified Check_Already_Working___ to include Waiting states also. (Bug#76521)
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK Merged Rose Documentation.
--  120104  ASIWLK Merged Modified Get_Report_Title to return report title when print job
--                 only contains the instances of same report (Bug#99253
--  160211  ASIWLK Unable to register new print jobs with different parameter combinations
--  160503  ASIWLK Error when using swedish language and print reports running as Other Plugin (LCS -128964)
--  170516  CHAALK Patch Merge (Bug#135854)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

field_separator_ CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;

record_separator_ CONSTANT VARCHAR2(1) := Client_SYS.record_separator_;

group_separator_ CONSTANT VARCHAR2(1) := Client_SYS.group_separator_;

TYPE row_type IS TABLE OF VARCHAR2(32000) INDEX BY BINARY_INTEGER;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Instance_Seq___ (
   print_job_id_ IN  NUMBER ) RETURN NUMBER
IS
   this_ NUMBER;
BEGIN
   SELECT nvl(max(instance_seq), -1) + 1
      INTO this_
      FROM print_job_contents_tab
      WHERE print_job_id = print_job_id_;
   RETURN (this_);
END Get_Instance_Seq___;


PROCEDURE Check_Already_Working___ (
   rec_       IN PRINT_JOB_CONTENTS_TAB%ROWTYPE,
   user_name_ IN VARCHAR2 )
IS   
   print_job_id_ NUMBER := Get_Already_Working_Print_Job___(rec_, user_name_, NULL);
BEGIN
   IF print_job_id_ IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'ALREADYIN: Unable to register new print job. The same report is already being processed in print job [ :P1 ]. Please allow more time for it to finish.', print_job_id_);
   END IF;
END Check_Already_Working___;

-- Get_Already_Working_Print_Job___
--   This procedure checks for already ruining print jobs with the identical
--   parameters for the current report been ordered. (An additional check is
--   included to see whether the job is in print queue)
FUNCTION Get_Already_Working_Print_Job___ (
   rec_                 IN PRINT_JOB_CONTENTS_TAB%ROWTYPE,
   user_name_           IN VARCHAR2,
   printer_id_to_check_ IN VARCHAR2) RETURN VARCHAR2
IS
   printer_id_   VARCHAR2(250);
   job_running_  BOOLEAN;

   CURSOR jobs_in_progress IS
      SELECT pj.print_job_id, pjc.result_key
        FROM print_job_tab pj, print_job_contents_tab pjc, print_queue_tab pq
       WHERE pj.print_job_id   = pjc.print_job_id
         AND pj.print_job_id   = pq.print_job_id
         AND pj.user_name      = user_name_
         AND pj.printer_id     = printer_id_
         AND pjc.instance_attr = rec_.instance_attr
         AND pj.status IN ('WAITING', 'REMOTE WAITING', 'WORKING', 'REMOTE WORKING');

   CURSOR job_check(
      main_result_key_    VARCHAR2,
      target_result_key_  VARCHAR2 )
   IS
   (
      SELECT ap.parameter_name, ap.parameter_value, ar.report_id
        FROM archive_parameter_tab ap, archive_tab ar
       WHERE ap.result_key = main_result_key_
         AND ar.result_key = main_result_key_
       MINUS
      SELECT ap.parameter_name, ap.parameter_value, ar.report_id
        FROM archive_parameter_tab ap, archive_tab ar
       WHERE ap.result_key  = target_result_key_
         AND ar.result_key  = target_result_key_
   )
   UNION ALL
   (
      SELECT ap.parameter_name, ap.parameter_value, ar.report_id
        FROM archive_parameter_tab ap, archive_tab ar
       WHERE ap.result_key  = target_result_key_
         AND ar.result_key  = target_result_key_
       MINUS
      SELECT ap.parameter_name, ap.parameter_value, ar.report_id
        FROM archive_parameter_tab ap, archive_tab ar
       WHERE ap.result_key  = main_result_key_
         AND ar.result_key  = main_result_key_
   );

   dummy_ job_check%ROWTYPE;
BEGIN

   printer_id_ := NVL(printer_id_to_check_, Print_Job_API.Get_Printer_Id(rec_.print_job_id));
   FOR job_ IN jobs_in_progress LOOP
      OPEN  job_check(rec_.result_key, job_.result_key);
      FETCH job_check INTO dummy_;
      job_running_ := job_check%NOTFOUND;
      CLOSE job_check;
      IF job_running_ THEN
         RETURN job_.print_job_id;
      END IF;
   END LOOP;
   RETURN NULL;
END Get_Already_Working_Print_Job___;

PROCEDURE Set_Print_Job_Owner___ (
   print_job_id_  IN  NUMBER,
   result_key_    IN NUMBER,
   instance_attr_ IN VARCHAR2 )
IS
   print_job_owner_   VARCHAR2(10):= Print_Job_API.Get_Print_Job_Owner_Db(print_job_id_);
   layout_type_owner_ VARCHAR2(10):= Get_Layout_Type_Owner___(result_key_, instance_attr_);
   attr_              VARCHAR2(2000);
BEGIN
   -- The print job contents can only be added if Print Job (header) has its print_job_owner set to either
   -- 1. 'UNDEFINED', meaning that no contents has been added yet.
   -- 2. The same as the current record being added, mening that the Print Job owner has already been defined by the first record and
   --    the rest must be of the same type (PRINTSRV or AGENT)

   IF layout_type_owner_ IS NULL THEN
      -- This might be a result of the fact the layout names are stored mixed and in uppercase and no match is then found.
      Error_SYS.Record_General(lu_name_, 'MISSINGOWNER: The report layout has no layout type owner (printing solution) defined.');
   END IF;

   IF ((print_job_owner_ != 'UNDEFINED') AND (print_job_owner_ != layout_type_owner_ )) THEN
      Error_SYS.Record_General(lu_name_,
'MIXEDOWNERS: A print job can not be executed if it contains reports that are about to be printed using different printing solutions (having different layout type owners).');
   END IF;

   Client_SYS.Add_To_Attr('PRINT_JOB_OWNER_DB', layout_type_owner_, attr_);
   Print_Job_API.Modify_Job(print_job_id_,  attr_);
END Set_Print_Job_Owner___;


FUNCTION Get_Layout_Type_Owner___ (
   result_key_    IN NUMBER,
   instance_attr_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   archive_instance_attr_  VARCHAR2(32000);
   archive_parameter_attr_ VARCHAR2(32000);
   report_id_              VARCHAR2(30);
   layout_name_            VARCHAR2(100);
   layout_type_            VARCHAR2(20);
   layout_type_owner_      VARCHAR2(10);

BEGIN
   Archive_API.Get_Info(archive_instance_attr_, archive_parameter_attr_, result_key_);
   report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', archive_instance_attr_);
   -- Get the LAYOUT_NAME from the instance parameter.
   layout_name_ := Get_Item_Value___( 'LAYOUT_NAME', instance_attr_);

   IF (layout_name_ IS NULL) THEN
      -- IF no LAYOUT_NAME is included in the instance parameter, get it from the Archive instead.
      layout_name_ := Client_SYS.Get_Item_Value('LAYOUT_NAME', archive_instance_attr_);
   END IF;

   IF (layout_name_ IS NULL) THEN
      -- IF no LAYOUT_NAME is included in the Archive either, fetch the default layout name for current report.
      layout_name_ := Report_Layout_Definition_API.Get_Default_Layout(report_id_);
      IF layout_name_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOLAYOUTDEFINED: The report (:P1) has no active layouts.', report_id_ );
      END IF;
   END IF;

   layout_type_         := Report_Layout_Definition_API.Get_Layout_Type_Encode(report_id_, layout_name_);
   layout_type_owner_   := Report_Layout_Type_Config_API.Get_Layout_Type_Owner_Db(Report_Layout_Type_API.Decode(layout_type_));
   -- IF layout type owner not defined for the EXCEL reports,
   IF (layout_type_owner_ IS NULL AND 'EXCEL' = layout_type_) THEN
      layout_type_owner_ := 'UNDEFINED';
   END IF;

   RETURN layout_type_owner_;
END Get_Layout_Type_Owner___;


FUNCTION Get_Item_Value___ (
   name_ IN VARCHAR2,
   attr_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   from_ NUMBER;
   len_  NUMBER;
   to_   NUMBER;
BEGIN
   len_ := length(name_);
   from_ := instr('^' || attr_, '^' || name_ || '=');
   IF (from_ > 0) THEN
      to_ := instr(attr_, '^', from_ + 1);
      IF (to_ > 0) THEN
         RETURN (substr(attr_, from_ + len_ + 1, to_ - from_ - len_ - 1));
      END IF;
   END IF;
   RETURN (NULL);
END Get_Item_Value___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PRINT_JOB_CONTENTS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Set_Print_Job_Owner___(newrec_.print_job_id, newrec_.result_key, newrec_.instance_attr);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT print_job_contents_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   archive_instance_attr_  VARCHAR2(32000);
   archive_parameter_attr_ VARCHAR2(32000);
   report_id_              VARCHAR2(30);
   lang_code_              VARCHAR2(2000);
   layout_name_            VARCHAR2(2000);
   options_                VARCHAR2(2000);
   plugin_options_         VARCHAR2(2000);
   language_               VARCHAR2(2000);
   country_                VARCHAR2(2000);
   rre_                    VARCHAR2(30);
BEGIN
   lang_code_ := Client_SYS.Get_Item_Value('LANG_CODE', attr_);
   layout_name_ := Client_SYS.Get_Item_Value('LAYOUT_NAME', attr_);
   options_ := Client_SYS.Get_Item_Value('OPTIONS', attr_);
   plugin_options_ := Client_SYS.Get_Item_Value('PLUGIN_OPTIONS', attr_);
   language_ := Client_SYS.Get_Item_Value('LOCALE_COUNTRY', attr_);
   country_ := Client_SYS.Get_Item_Value('LOCALE_LANGUAGE', attr_);
   rre_ := Client_SYS.Get_Item_Value('RRE', attr_);
   IF (layout_name_ IS NOT NULL) THEN
      Report_Layout_Definition_API.Check_Layout(layout_name_);
   END IF;
   super(newrec_, indrec_, attr_);
   
   newrec_.instance_seq := Get_Instance_Seq___(newrec_.print_job_id);
   Client_SYS.Add_To_Attr('INSTANCE_SEQ', newrec_.instance_seq, attr_);
   
   IF (newrec_.instance_attr IS NOT NULL) THEN
      layout_name_ := Client_SYS.Get_Item_Value('LAYOUT_NAME', newrec_.instance_attr);
      IF (layout_name_ IS NOT NULL) THEN
         Report_Layout_Definition_API.Check_Layout(layout_name_);
      END IF;
      newrec_.instance_attr := translate(newrec_.instance_attr, field_separator_||record_separator_, '=^');
   END IF;
   IF (lang_code_ IS NOT NULL) THEN
      newrec_.instance_attr := newrec_.instance_attr||'LANG_CODE'||'='||lang_code_||'^';
   END IF;
   IF (layout_name_ IS NOT NULL) THEN
      newrec_.instance_attr := newrec_.instance_attr||'LAYOUT_NAME'||'='||layout_name_||'^';
   END IF;
   IF (options_ IS NOT NULL) THEN
      newrec_.instance_attr := newrec_.instance_attr||'OPTIONS'||'='||options_||'^';
   END IF;
   IF (plugin_options_ IS NOT NULL) THEN
      newrec_.instance_attr := newrec_.instance_attr||'PLUGIN_OPTIONS'||'='||plugin_options_||'^';
   END IF;
   IF (language_ IS NOT NULL) THEN
      newrec_.instance_attr := newrec_.instance_attr||'LOCALE_COUNTRY'||'='||language_||'^';
   END IF;
   IF (country_ IS NOT NULL) THEN
      newrec_.instance_attr := newrec_.instance_attr||'LOCALE_LANGUAGE'||'='||country_||'^';
   END IF;
   IF (rre_ IS NOT NULL) THEN
      newrec_.instance_attr := newrec_.instance_attr||'RRE'||'='||rre_||'^';
   END IF;
   IF (newrec_.instance_attr IS NULL) THEN
      Archive_API.Get_Info(archive_instance_attr_, archive_parameter_attr_, newrec_.result_key);
      layout_name_ := Archive_API.Get_Layout_Name__;
      report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', archive_instance_attr_);
      IF (Report_Layout_Type_Config_API.Get_Layout_Type_Owner_Db(Report_Layout_Definition_API.Get_Layout_Type(report_id_, layout_name_)) = 'AGENT') THEN
         newrec_.instance_attr := newrec_.instance_attr||'LAYOUT_NAME'||'='||layout_name_||'^';
         newrec_.instance_attr := newrec_.instance_attr||'LANG_CODE'||'='||Archive_API.Get_Language__||'^';
      END IF;
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     print_job_contents_tab%ROWTYPE,
   newrec_ IN OUT print_job_contents_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   instance_attr_  VARCHAR2(2000);
   lang_code_      VARCHAR2(2000);
   layout_name_    VARCHAR2(2000);
   options_        VARCHAR2(2000);
   plugin_options_ VARCHAR2(2000);
   language_       VARCHAR2(2000);
   country_        VARCHAR2(2000);
   rre_            VARCHAR2(30);
BEGIN
   instance_attr_ := translate(newrec_.instance_attr, '=^', field_separator_||record_separator_);
   lang_code_ := Client_SYS.Cut_Item_Value('LANG_CODE', instance_attr_);
   layout_name_ := Client_SYS.Cut_Item_Value('LAYOUT_NAME', instance_attr_);
   options_ := Client_SYS.Cut_Item_Value('OPTIONS', instance_attr_);
   plugin_options_ := Client_SYS.Cut_Item_Value('PLUGIN_OPTIONS', instance_attr_);
   country_ := Client_SYS.Cut_Item_Value('LOCALE_COUNTRY', instance_attr_);
   language_ := Client_SYS.Cut_Item_Value('LOCALE_LANGUAGE', instance_attr_);
   rre_ := Client_SYS.Get_Item_Value('RRE', attr_);
   indrec_.print_job_id := FALSE;
   indrec_.instance_seq := FALSE;
   indrec_.result_key := FALSE;
   super(oldrec_, newrec_, indrec_, attr_);
   Client_SYS.Clear_Attr(instance_attr_);
   Client_SYS.Add_To_Attr('LANG_CODE', lang_code_, instance_attr_);
   Client_SYS.Add_To_Attr('LAYOUT_NAME', layout_name_, instance_attr_);
   Client_SYS.Add_To_Attr('OPTIONS', options_, instance_attr_);
   Client_SYS.Add_To_Attr('PLUGIN_OPTIONS', plugin_options_, instance_attr_);
   Client_SYS.Add_To_Attr('LOCALE_COUNTRY', country_, instance_attr_);
   Client_SYS.Add_To_Attr('LOCALE_LANGUAGE', language_, instance_attr_);
   Client_SYS.Add_To_Attr('RRE', rre_, instance_attr_);
   newrec_.instance_attr := translate(instance_attr_, field_separator_||record_separator_, '=^');
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Is_Already_Working (
   result_key_           IN NUMBER,
   printer_id_to_check_  IN VARCHAR2,
   instance_attr_        IN VARCHAR2,
   user_name_            IN VARCHAR2) RETURN VARCHAR2
IS
   rec_ PRINT_JOB_CONTENTS_TAB%ROWTYPE;
BEGIN
   rec_.result_key    := result_key_;
   rec_.instance_attr := instance_attr_;
   IF Get_Already_Working_Print_Job___(rec_, user_name_, printer_id_to_check_) IS NOT NULL THEN
      RETURN 'TRUE';
   END IF;
   RETURN 'FALSE';
END Is_Already_Working;
   

PROCEDURE Get_Instance_Attr (
   attr_         OUT VARCHAR2,
   print_job_id_ IN  NUMBER )
IS
   new_attr_ VARCHAR2(32000);
   limit_    NUMBER  := 31000;
   inside_   BOOLEAN := FALSE;
   CURSOR get_instances IS
      SELECT *
      FROM   PRINT_JOB_CONTENTS
      WHERE  print_job_id = print_job_id_;
BEGIN
   FOR rec_ IN get_instances LOOP
      inside_ := TRUE;
      Client_SYS.Add_To_Attr('INSTANCE_SEQ', rec_.instance_seq, new_attr_);
      Client_SYS.Add_To_Attr('RESULT_KEY', rec_.result_key, new_attr_);
      IF (length(new_attr_)> limit_) THEN
         EXIT;
      ELSE
         new_attr_ := new_attr_ || translate(rec_.instance_attr, '=^', field_separator_||record_separator_) || group_separator_;
      END IF;
   END LOOP;
   IF (NOT inside_) THEN
      Error_SYS.Appl_General(lu_name_, 'PRTJOBEMPTY: Printjob #:P1 is invalid (empty)', print_job_id_);
   END IF;
   attr_ := new_attr_;
END Get_Instance_Attr;


PROCEDURE Get_Instance_Attr (
   attr_         OUT VARCHAR2,
   print_job_id_ IN  NUMBER,
   instance_seq_ IN  NUMBER)
IS
   new_attr_ VARCHAR2(32000);
   inside_   BOOLEAN := FALSE;
   CURSOR get_instances IS
      SELECT *
      FROM   PRINT_JOB_CONTENTS
      WHERE  print_job_id = print_job_id_
      AND    instance_seq = instance_seq_;
BEGIN

   FOR rec_ IN get_instances LOOP
      inside_ := TRUE;
      new_attr_ := translate(rec_.instance_attr, '=^', field_separator_||record_separator_) || group_separator_;
   END LOOP;

   IF (NOT inside_) THEN
      Error_SYS.Appl_General(lu_name_, 'PRTJOBEMPTY: Printjob #:P1 is invalid (empty)', print_job_id_);
   END IF;
   attr_ := new_attr_;
END Get_Instance_Attr;


PROCEDURE Get_Instance_Attr (
   attr_         OUT VARCHAR2,
   print_job_id_ IN  NUMBER,
   row_total_    IN  OUT NUMBER,
   row_          IN  NUMBER )
IS
   attr_temp_     row_type;
   inside_        BOOLEAN        := FALSE;
   limit_         NUMBER         := 31000;
   i_              BINARY_INTEGER := 1;
   new_attr_      VARCHAR2(32000);

   CURSOR get_instances IS
      SELECT *
      FROM   print_job_contents_tab
      WHERE  print_job_id = print_job_id_;
BEGIN


   IF (row_ = 1) THEN
      attr_temp_.DELETE;
      attr_temp_(i_) := NULL;


      FOR rec_ IN get_instances LOOP
        inside_ := TRUE;

        Client_SYS.Add_To_Attr('INSTANCE_SEQ', rec_.instance_seq, new_attr_);
        Client_SYS.Add_To_Attr('RESULT_KEY', rec_.result_key, new_attr_);
        new_attr_ := new_attr_ || translate(rec_.instance_attr, '=^', field_separator_||record_separator_) || group_separator_;
        attr_temp_(i_) := new_attr_;

        IF (length(attr_temp_(i_))> limit_) THEN
            i_ := i_ + 1;
            attr_temp_(i_) := NULL;
            client_sys.Clear_Attr(new_attr_);
        END IF;

      END LOOP;

      IF (NOT inside_) THEN
         Error_SYS.Appl_General(lu_name_, 'PRTJOBEMPTY: Printjob #:P1 is invalid (empty)', print_job_id_);
      END IF;

      -- Return one cell at the time
      attr_ := attr_temp_(1);
      row_total_   := i_;
   ELSE
      attr_ := attr_temp_(row_);
      row_total_   := row_total_;
   END IF;
END Get_Instance_Attr;


PROCEDURE Set_Instance_Attr (
   attr_         IN VARCHAR2,
   print_job_id_ IN  NUMBER, 
   result_key_    IN NUMBER)
IS
   inside_   BOOLEAN := FALSE;
   newrec_ PRINT_JOB_CONTENTS_TAB%ROWTYPE;
   CURSOR get_instances IS
      SELECT instance_seq
      FROM   PRINT_JOB_CONTENTS
      WHERE  print_job_id = print_job_id_ AND result_key = result_key_;
BEGIN
   FOR rec_ IN get_instances LOOP
      inside_ := TRUE;
      newrec_ := Lock_By_Keys___(print_job_id_, rec_.instance_seq);
      UPDATE print_job_contents_tab
         SET instance_attr = attr_,
             rowversion = sysdate
         WHERE print_job_id = print_job_id_
         AND   instance_seq = rec_.instance_seq;
   END LOOP;
   IF (NOT inside_) THEN
      Error_SYS.Appl_General(lu_name_, 'COULDNOTUPDATEPRINTJOB: Printjob #:P1 with result key #:P2 does not exist.', print_job_id_, result_key_);
   END IF;
END Set_Instance_Attr;


@UncheckedAccess
FUNCTION Is_Distributed (
   result_key_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   found_ BOOLEAN;
   CURSOR get_distribution IS
      SELECT 1
      FROM print_job_contents_tab
      WHERE result_key = result_key_;
BEGIN
   OPEN get_distribution;
   FETCH get_distribution INTO dummy_;
   found_ := get_distribution%FOUND;
   CLOSE get_distribution;
   RETURN found_;
END Is_Distributed;


PROCEDURE Modify_Instance (
   attr_  IN VARCHAR2 )
IS
   print_job_id_ NUMBER;
   instance_seq_ NUMBER;
   newrec_       PRINT_JOB_CONTENTS_TAB%ROWTYPE;
   oldrec_       PRINT_JOB_CONTENTS_TAB%ROWTYPE;
   objid_        PRINT_JOB_CONTENTS.objid%TYPE;
   objversion_   PRINT_JOB_CONTENTS.objversion%TYPE;
   tmp_attr_     VARCHAR2(32000) := attr_;
   indrec_       Indicator_Rec;
BEGIN
   print_job_id_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('PRINT_JOB_ID', tmp_attr_));
   Error_SYS.Check_Not_Null(lu_name_, 'PRINT_JOB_ID', print_job_id_);
   instance_seq_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('INSTANCE_SEQ', tmp_attr_));
   Error_SYS.Check_Not_Null(lu_name_, 'INSTANCE_SEQ', instance_seq_);
   newrec_ := Lock_By_Keys___(print_job_id_, instance_seq_);
   oldrec_ := newrec_;
   Unpack___(newrec_, indrec_, tmp_attr_);
   Check_Update___(oldrec_, newrec_, indrec_, tmp_attr_);
   Update___(objid_, oldrec_, newrec_, tmp_attr_, objversion_, TRUE); -- Update by keys
END Modify_Instance;


PROCEDURE New_Instance (
   attr_ IN VARCHAR2 )
IS
   new_rec_       PRINT_JOB_CONTENTS_TAB%ROWTYPE;
   new_attr_      VARCHAR2(2000) := attr_;
   user_name_     VARCHAR2(30);
   objid_         PRINT_JOB_CONTENTS.objid%TYPE;
   objversion_    PRINT_JOB_CONTENTS.objversion%TYPE;
   indrec_        Indicator_Rec;
BEGIN
   Unpack___(new_rec_, indrec_, new_attr_);
   Check_Insert___(new_rec_, indrec_, new_attr_);   
   user_name_ := Print_Job_API.Get_User_Name(new_rec_.print_job_id);
   Check_Already_Working___(new_rec_, user_name_);
   Insert___(objid_, objversion_, new_rec_, new_attr_);
   Archive_API.Connect_Instance(new_rec_.result_key, user_name_);
END New_Instance;


PROCEDURE Remove_Print_Job_Instances (
   print_job_id_ IN NUMBER )
IS
BEGIN
   DELETE FROM print_job_contents_tab
      WHERE print_job_id = print_job_id_;
END Remove_Print_Job_Instances;


-- Set_Printed
--   Set the report to printed. This status is actually stored in the
--   ArchiveDistribution and not in this LU.
PROCEDURE Set_Printed (
   print_job_id_ IN NUMBER,
   result_key_   IN NUMBER )
IS
BEGIN
   Print_Job_API.Exist(print_job_id_);
   Archive_Distribution_API.Set_Printed(result_key_, Print_Job_API.Get_User_Name(print_job_id_));
END Set_Printed;


@UncheckedAccess
FUNCTION Get_Report_Title (
   print_job_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_rows IS
      SELECT DISTINCT a.report_id
        FROM ARCHIVE_TAB a, PRINT_JOB_CONTENTS_TAB p
       WHERE a.result_key = p.result_key
         AND p.print_job_id = print_job_id_;
   report_id1_ ARCHIVE_TAB.report_id%TYPE;
   report_id2_ ARCHIVE_TAB.report_id%TYPE;
BEGIN
   OPEN get_rows;
   FETCH get_rows INTO report_id1_;
   IF (get_rows%FOUND) THEN
      FETCH get_rows INTO report_id2_;
      IF (get_rows%NOTFOUND) THEN
         CLOSE get_rows;
         RETURN substr(Report_Definition_API.Get_Translated_Report_Title(report_id1_),1,50);
      END IF;
   END IF;
   CLOSE get_rows;
   RETURN NULL;
END Get_Report_Title;


PROCEDURE Check_Empty (
   print_job_id_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   found_ BOOLEAN;
   CURSOR find_contents IS
      SELECT 1
      FROM  print_job_contents_tab
      WHERE print_job_id = print_job_id_;
BEGIN
   OPEN find_contents;
   FETCH find_contents INTO dummy_;
   found_ := find_contents%FOUND;
   CLOSE find_contents;
   IF NOT found_ THEN
      Error_SYS.Appl_General(lu_name_, 'PRTJOBEMPTY1: Print Job must have contents');
   END IF;
END Check_Empty;


@UncheckedAccess
FUNCTION Get_No_Of_Result_Keys (
   print_job_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ NUMBER :=0 ;
   CURSOR get_attr IS
      SELECT count(result_key)
      FROM PRINT_JOB_CONTENTS_TAB
      WHERE print_job_id = print_job_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_No_Of_Result_Keys;

-- Testing purposes - For exposing PrintJobId via API calls

FUNCTION Get_Result_Key(
   print_job_id_ IN NUMBER)  RETURN NUMBER
IS
   result_key_ NUMBER;
   CURSOR get_key IS
      SELECT p.result_key 
      FROM PRINT_JOB_CONTENTS_TAB p, ARCHIVE c
      WHERE p.result_key = c.result_key AND  print_job_id = print_job_id_;
BEGIN
   OPEN get_key;
   FETCH get_key INTO result_key_;
   CLOSE get_key;
   RETURN result_key_;
END Get_Result_Key;

