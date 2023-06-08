-----------------------------------------------------------------------------
--
--  Logical unit: DbScriptRegister
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120201  MaBo  Create
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
   Client_SYS.Add_To_Attr('NO_SUB_SECTIONS', 0, attr_);
   Client_SYS.Add_To_Attr('PROCESSED_OK_DB', 'FALSE', attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Register_Module_Action (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2,
   file_name_     IN VARCHAR2,
   description_   IN VARCHAR2 DEFAULT NULL,
   version_       IN VARCHAR2 DEFAULT NULL,
   status_info_   IN VARCHAR2 DEFAULT NULL )
IS
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     DB_SCRIPT_REGISTER_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   IF (NOT Check_Exist___(module_,register_id_)) THEN
      Prepare_Insert___(attr_);
      Client_SYS.Add_To_Attr('MODULE', module_, attr_);
      Client_SYS.Add_To_Attr('REGISTER_ID', register_id_, attr_);
      Client_SYS.Add_To_Attr('FILE_NAME', file_name_, attr_);
      IF description_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
      END IF;
      IF version_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('VERSION', version_, attr_);
      END IF;
      IF status_info_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('STATUS_INFO', status_info_, attr_);
      END IF;
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END Register_Module_Action;


@UncheckedAccess
FUNCTION Is_Module_Action_Registered (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR check_exist IS
      SELECT 1
      FROM DB_SCRIPT_REGISTER_TAB
      WHERE module = module_
      AND register_id = register_id_
      AND processed_ok = 'TRUE';
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF check_exist%FOUND THEN
      CLOSE check_exist;
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Module Db action '|| module_ ||' '||register_id_||' is already registred in the database');
      RETURN TRUE;
   ELSE
      CLOSE check_exist;
      RETURN FALSE;
   END IF;
END Is_Module_Action_Registered;


PROCEDURE Clear_Module_Action_Register (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2 DEFAULT NULL )
IS
   CURSOR get_recs IS
      SELECT *
      FROM db_script_register_tab
      WHERE module = module_
      AND register_id = NVL(register_id_, register_id);
BEGIN
   FOR rec_ IN get_recs LOOP
      Remove___(rec_);
   END LOOP;
END Clear_Module_Action_Register;


PROCEDURE Set_Module_Action_Process (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2,
   processed_ok_  IN VARCHAR2 DEFAULT 'TRUE' )
IS
   attr_   VARCHAR2(2000);
   oldrec_ DB_SCRIPT_REGISTER_TAB%ROWTYPE;
   newrec_ DB_SCRIPT_REGISTER_TAB%ROWTYPE;
   indrec_ Indicator_Rec;
   CURSOR get_recs IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM DB_SCRIPT_REGISTER_TAB
      WHERE module = module_
      AND register_id = register_id_;
BEGIN
   FOR rec_ IN get_recs LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('PROCESSED_OK_DB', processed_ok_, attr_);
      oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(rec_.objid, oldrec_, newrec_, attr_, rec_.objversion);
   END LOOP;
END Set_Module_Action_Process;


PROCEDURE Set_Module_Action_Status (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2,
   status_info_   IN VARCHAR2 )
IS
   attr_   VARCHAR2(2000);
   oldrec_ DB_SCRIPT_REGISTER_TAB%ROWTYPE;
   newrec_ DB_SCRIPT_REGISTER_TAB%ROWTYPE;
   indrec_ Indicator_Rec;
   CURSOR get_recs IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM DB_SCRIPT_REGISTER_TAB
      WHERE module = module_
      AND register_id = register_id_;
BEGIN
   FOR rec_ IN get_recs LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('STATUS_INFO', status_info_, attr_);
      oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(rec_.objid, oldrec_, newrec_, attr_, rec_.objversion);
   END LOOP;
END Set_Module_Action_Status;


PROCEDURE Add_Sub_Section (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2,
   reduce_        IN BOOLEAN DEFAULT FALSE )
IS
   CURSOR get_recs IS
      SELECT *
      FROM DB_SCRIPT_REGISTER_TAB
      WHERE module = module_
      AND register_id = register_id_;
BEGIN
   FOR rec_ IN get_recs LOOP
      IF reduce_ THEN
         rec_.no_sub_sections := GREATEST((NVL(rec_.no_sub_sections, 0) - 1), 0);
      ELSE
         rec_.no_sub_sections := NVL(rec_.no_sub_sections, 0) + 1;
      END IF;
      Modify___(rec_);
   END LOOP;
END Add_Sub_Section;


PROCEDURE Log_Execution_Errors (
   module_      IN VARCHAR2,
   register_id_ IN VARCHAR2,
   raise_       IN BOOLEAN DEFAULT FALSE )
IS
   error_counter_ NUMBER := 0;
   CURSOR check_if_error IS
      SELECT sub_section, status_info
        FROM db_script_register_detail_tab
       WHERE module = module_
         AND register_id = register_id_
         AND processed_ok <> 'TRUE'
      AND EXISTS (SELECT 1
                    FROM db_script_register_tab
                   WHERE module = module_
                     AND register_id = register_id_
                     AND processed_ok <> 'TRUE');
BEGIN
   FOR error_line_ IN check_if_error LOOP
      IF error_counter_ < 1 THEN
         dbms_output.put_line('Error when deploying script ['||module_||'] - ['||register_id_||']');
      END IF;
      error_counter_ := error_counter_ + 1;
      dbms_output.put_line('Sub Section: ' || error_line_.sub_section || ' ' || error_line_.status_info);
   END LOOP;
   IF (error_counter_ > 0) THEN
      IF raise_ THEN
         Error_SYS.Appl_General(lu_name_, 'SCRIPTERRRORS: :P1 error(s) occured when deploying script [:P2] - [:P3]. See installation log for more details', error_counter_, module_, register_id_);
      END IF;
   ELSE
      dbms_output.put_line('No errors when deploying script ['||module_||'] - ['||register_id_||']');
   END IF;
END Log_Execution_Errors;

