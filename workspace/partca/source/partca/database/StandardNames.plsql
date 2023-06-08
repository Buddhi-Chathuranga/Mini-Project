-----------------------------------------------------------------------------
--
--  Logical unit: StandardNames
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190131  ErFelk  Bug 146207(SCZ-2615), Modified Check_Update___() by adding a condition to check the std_name is changed. 
--  100423  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  060601  MiErlk  Enlarge Identity - Changed view comments Description.
----------------------------- 12.4.0 ---------------------------------------------
--  060110  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  040224  LoPrlk  Removed substrb from code. &VIEW2 were altered.
--  -----------------------------12.3.0-------------------------
--  031222  ISANLK   Merged lines in the Close Cursor.
--  -----------------------EDGE - Package Group 2----------------------------
--  011129  BEHA  Change std_name Format to unformat.
--  001030  PERK  Changed substr to substrb in STANDARD_NAMES_LOV
--  000925  JOHESE  Added undefines.
--  990419  FRDI  General performance improvements
--  990414  FRDI  Upgraded to performance optimized template.
--  971124  TOOS  Upgrade to F1 2.0
--  970410  NIHE/ANLI  Created new for StandardNames
--  970527  JoRo   Added LOV-view
--  970616  NiHe  Changed format on std_name to uppercase.
--  970617  NiHe  Did some fixing on method Get_Standard_Name_I
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Std_Name___
--   Check if standard name exists. Duplicates not allowed.
PROCEDURE Check_Std_Name___ (
   std_name_ IN VARCHAR2 )
IS
   CURSOR Get_Standard_Name IS
      SELECT 1
      FROM STANDARD_NAMES_TAB
      WHERE std_name = std_name_;
   dummy_   VARCHAR2(1);
BEGIN
   OPEN Get_Standard_Name;
   FETCH Get_Standard_Name INTO dummy_;
   IF (Get_Standard_Name%FOUND) THEN
      CLOSE Get_Standard_Name;
      Error_Sys.Record_General(lu_name_, 'STDNAME: Standard Name already exist.');
   ELSE
      CLOSE Get_Standard_Name;
   END IF;
END Check_Std_Name___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT STANDARD_NAMES_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT STD_NAME_SEQ.nextval
      INTO newrec_.std_name_id
      FROM DUAL;
   Client_SYS.Add_To_Attr('STD_NAME_ID', newrec_.std_name_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT standard_names_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);

   Check_Std_Name___(newrec_.std_name);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     standard_names_tab%ROWTYPE,
   newrec_ IN OUT standard_names_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (Validate_SYS.Is_Changed(oldrec_.std_name, newrec_.std_name)) THEN
      Check_Std_Name___(newrec_.std_name);
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Standard_Name_Id
--   A function which return the standard name id.
@UncheckedAccess
FUNCTION Get_Standard_Name_Id (
   std_name_    IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ STANDARD_NAMES_TAB.std_name_id%TYPE;
   CURSOR get_attr IS
      SELECT std_name_id
      FROM STANDARD_NAMES_TAB
      WHERE std_name = std_name_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF (get_attr%FOUND) THEN
      CLOSE get_attr;
      RETURN(temp_);
   else
      CLOSE get_attr;
      RETURN 0;
   END IF;
END Get_Standard_Name_Id;



