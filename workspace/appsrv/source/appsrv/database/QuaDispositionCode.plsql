-----------------------------------------------------------------------------
--
--  Logical unit: QuaDispositionCode
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131123  NuKuLK  Hooks: Refactored and splitted code.
--  --------------------------- APPS 9 --------------------------------------
--  130911  chanlk   Model errors corrected.
--  120713  LaRelk Added rowkey to allow custom fields.
--  030412  ArAmLk Moved from CHNGMT and Renamed from MrbDispositionCode as to facilitate both CHMGMT and QUANCR
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
   Client_SYS.Add_To_Attr('VERIFY_SCRAPPING_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('OBSOLETE_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN QUA_DISPOSITION_CODE_TAB%ROWTYPE )
IS
BEGIN
   IF (remrec_.disposition_code IN ('*', 'APPROVE', 'SCRAP')) THEN
      Error_SYS.Appl_General ( lu_name_, 'DISPCODEDELERR: Disposition code :P1 is a system-defined disposition code and is not allowed to be deleted.', remrec_.disposition_code);
   END IF;   
   super(remrec_);
END Check_Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Enumerate (
   client_values_ OUT VARCHAR2 )
IS
   CURSOR get_disp_code IS
      SELECT *
      FROM QUA_DISPOSITION_CODE_TAB;
   separator_ VARCHAR2(1) := Client_SYS.field_separator_;
BEGIN
   FOR rec_ IN get_disp_code LOOP
      client_values_ := client_values_ || rec_.disposition_code || separator_;
   END LOOP;
END Enumerate;



