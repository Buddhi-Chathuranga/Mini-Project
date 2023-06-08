-----------------------------------------------------------------------------
--
--  Logical unit: DbScriptRegisterDetail
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
   Client_SYS.Add_To_Attr('PROCESSED_OK_DB', 'FALSE', attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Register_Sub_Section (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2,
   sub_section_   IN NUMBER  DEFAULT 1,
   processed_ok_  IN VARCHAR2,
   status_info_   IN VARCHAR2 DEFAULT NULL,
   file_name_     IN VARCHAR2 DEFAULT NULL,
   description_   IN VARCHAR2 DEFAULT NULL )
IS
   attr_        VARCHAR2(2000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
   oldrec_      DB_SCRIPT_REGISTER_DETAIL_TAB%ROWTYPE;
   newrec_      DB_SCRIPT_REGISTER_DETAIL_TAB%ROWTYPE;
   all_proc_ok_ DB_SCRIPT_REGISTER_DETAIL_TAB.processed_ok%TYPE;
   CURSOR get_rec IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM DB_SCRIPT_REGISTER_DETAIL_TAB
      WHERE module = module_
      AND register_id = register_id_
      AND sub_section = sub_section_;
   CURSOR check_all IS
      SELECT MIN(processed_ok)
      FROM DB_SCRIPT_REGISTER_DETAIL_TAB
      WHERE module = module_
      AND register_id = register_id_;

   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   OPEN get_rec;
   FETCH get_rec INTO objid_, objversion_;
   IF get_rec%FOUND THEN
      CLOSE get_rec;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('PROCESSED_OK_DB', processed_ok_, attr_);
      Client_SYS.Add_To_Attr('STATUS_INFO', status_info_, attr_);
      IF description_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
      END IF;
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
      IF description_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
      END IF;
      IF status_info_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('STATUS_INFO', status_info_, attr_);
      END IF;
   ELSE
      CLOSE get_rec;
      Db_Script_Register_API.Register_Module_Action(module_, register_id_, file_name_);
      Prepare_Insert___(attr_);
      Client_SYS.Add_To_Attr('MODULE', module_, attr_);
      Client_SYS.Add_To_Attr('REGISTER_ID', register_id_, attr_);
      Client_SYS.Add_To_Attr('SUB_SECTION', sub_section_, attr_);
      Client_SYS.Set_Item_Value('PROCESSED_OK_DB', processed_ok_, attr_);
      IF description_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
      END IF;
      IF status_info_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('STATUS_INFO', status_info_, attr_);
      END IF;
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      Db_Script_Register_API.Add_Sub_Section(module_, register_id_);
   END IF;
   OPEN check_all;
   FETCH check_all INTO all_proc_ok_;
   CLOSE check_all;
   Db_Script_Register_API.Set_Module_Action_Process(module_, register_id_, all_proc_ok_);
@ApproveTransactionStatement(2014-04-02,mabose)
   COMMIT;
END Register_Sub_Section;


@UncheckedAccess
FUNCTION Is_Sub_Section_Registered (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2,
   sub_section_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR check_exist IS
      SELECT 1
      FROM DB_SCRIPT_REGISTER_DETAIL_TAB
      WHERE module = module_
      AND register_id = register_id_
      AND sub_section = sub_section_
      AND processed_ok = 'TRUE';
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF check_exist%FOUND THEN
      CLOSE check_exist;
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Module Db sub action '|| module_ ||' '||register_id_||' '||sub_section_||' is already registred in the database');
      RETURN TRUE;
   ELSE
      CLOSE check_exist;
      RETURN FALSE;
   END IF;
END Is_Sub_Section_Registered;


PROCEDURE Set_Sub_Section_Process (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2,
   sub_section_   IN NUMBER,
   processed_ok_  IN VARCHAR2 DEFAULT 'TRUE' )
IS
   attr_        VARCHAR2(2000);
   indrec_      Indicator_Rec;
   oldrec_      DB_SCRIPT_REGISTER_DETAIL_TAB%ROWTYPE;
   newrec_      DB_SCRIPT_REGISTER_DETAIL_TAB%ROWTYPE;
   all_proc_ok_ DB_SCRIPT_REGISTER_DETAIL_TAB.processed_ok%TYPE;
   CURSOR get_recs IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM DB_SCRIPT_REGISTER_DETAIL_TAB
      WHERE module = module_
      AND register_id = register_id_
      AND sub_section = sub_section_;
   CURSOR check_all IS
      SELECT MIN(processed_ok)
      FROM DB_SCRIPT_REGISTER_DETAIL_TAB
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
   OPEN check_all;
   FETCH check_all INTO all_proc_ok_;
   CLOSE check_all;
   Db_Script_Register_API.Set_Module_Action_Process(module_, register_id_, all_proc_ok_);
END Set_Sub_Section_Process;


PROCEDURE Clear_Sub_Section (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2,
   sub_section_   IN NUMBER )
IS
   remrec_      db_script_register_detail_tab%ROWTYPE;
   all_proc_ok_ db_script_register_detail_tab.processed_ok%TYPE;
   CURSOR check_all IS
      SELECT MIN(processed_ok)
      FROM db_script_register_detail_tab
      WHERE module = module_
      AND register_id = register_id_;
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   IF (Check_Exist___(module_, register_id_, sub_section_)) THEN
      remrec_.module := module_;
      remrec_.register_id := register_id_;
      remrec_.sub_section := sub_section_;
      Remove___(remrec_);
      Db_Script_Register_API.Add_Sub_Section(module_, register_id_, TRUE);
   END IF;
   OPEN check_all;
   FETCH check_all INTO all_proc_ok_;
   CLOSE check_all;
   Db_Script_Register_API.Set_Module_Action_Process(module_, register_id_, NVL(all_proc_ok_, 'TRUE'));
@ApproveTransactionStatement(2015-03-26,mabose)
   COMMIT;
END Clear_Sub_Section;


