-----------------------------------------------------------------------------
--
--  Logical unit: CreatePartsPerSiteHist
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210203  SBalLK   Issue SC2020R1-12253, Modified Set_Error() method by fetching objid, objversion on updated record before call for Set_Error__().
--  210118  SBalLK   Issue SC2020R1-11830, Modified Set_Error() method by removing attr_ functionality to optimize the performance.
--  111215  GanNLK   In the insert__ procedure, moved objversion_ to the bottom of the procedure.
--  100511  KRPELK   Merge Rose Method Documentation.
--  090930  ChFolk   Removed unused variables in the package.
--  -------------------------------- 14.0.0 ---------------------------------
--  070123  MiErlk   Added create_supp_part column.
--  061214  IsWilk   Modified the PROCEDURE Set_Error.
--  061213  IsWilk   Removed the FUNCTION Get_No_Of_Sites.
--  061213  KeFelk   Removed create_supp_part column.
--  061211  IsWilk   Added the FUNCTION Get_No_Of_Sites.
--  061130  IsWilk   Added FUNCTION Get_Next_Run_Id__.
--  061127  IsWilk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Part_Creation_Hist_Rec IS RECORD (
   history_no           NUMBER,
   assortment_id        VARCHAR2(50),
   assortment_node_id   VARCHAR2(50),
   contract             VARCHAR2(5),
   create_sales_part    VARCHAR2(5),
   create_supp_part     VARCHAR2(5));

TYPE Part_Creation_Hist_Tab IS TABLE OF Part_Creation_Hist_Rec
INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_History_No___ RETURN NUMBER
IS
   ret_val_ NUMBER;

   CURSOR get_next_history_no IS
      SELECT MAX(history_no) + 1
      FROM   CREATE_PARTS_PER_SITE_HIST_TAB;
BEGIN
   OPEN get_next_history_no;
   FETCH get_next_history_no INTO ret_val_;
   CLOSE get_next_history_no;
   RETURN NVL(ret_val_, 1);
END Get_Next_History_No___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CREATE_SALES_PART_DB', 'TRUE' , attr_);
   Client_SYS.Add_To_Attr('CREATE_SUPP_PART_DB',  'TRUE' , attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CREATE_PARTS_PER_SITE_HIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.history_no   := Get_Next_History_No___;
   newrec_.date_created := Site_API.Get_Site_Date(newrec_.contract);
   newrec_.user_id      := Fnd_Session_API.Get_Fnd_User();

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Records_To_Execute__
--   Returns the set of record to be executed.
@UncheckedAccess
FUNCTION Get_Records_To_Execute__ (
   run_id_ IN NUMBER ) RETURN Part_Creation_Hist_Tab
IS
   part_creation_hist_tab_ Part_Creation_Hist_Tab;

   CURSOR get_records IS
      SELECT history_no,
             assortment_id,
             assortment_node_id,
             contract,
             create_sales_part,
             create_supp_part
      FROM   CREATE_PARTS_PER_SITE_HIST_TAB
      WHERE  run_id = run_id_;

BEGIN
   OPEN get_records;
   FETCH get_records BULK COLLECT INTO part_creation_hist_tab_;
   CLOSE get_records;
   RETURN part_creation_hist_tab_;
END Get_Records_To_Execute__;


@UncheckedAccess
FUNCTION Get_Next_Run_Id__ RETURN NUMBER
IS
   run_id_     NUMBER;

   CURSOR get_next_run_id IS
      SELECT Create_Parts_Per_Site_Run_Id.nextval
      FROM dual;
BEGIN
   OPEN get_next_run_id;
   FETCH get_next_run_id INTO run_id_;
   CLOSE get_next_run_id;
   RETURN(run_id_);
END Get_Next_Run_Id__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Set_Error
--   Sets the state to 'Error' with the error description.
PROCEDURE Set_Error (
   history_no_        IN NUMBER,
   error_description_ IN VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   error_attr_ VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     CREATE_PARTS_PER_SITE_HIST_TAB%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(history_no_);
   newrec_.error_description := error_description_;
   Modify___(newrec_);
   Get_Id_Version_By_Keys___(objid_, objversion_, history_no_);
   Set_Error__(info_, objid_, objversion_, error_attr_, 'DO');
END Set_Error;


-- Set_Executed
--   Sets the state to 'Executed'.
PROCEDURE Set_Executed (
   history_no_ IN NUMBER )
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, history_no_);
   Set_Executed__(info_, objid_, objversion_, attr_, 'DO');
END Set_Executed;


