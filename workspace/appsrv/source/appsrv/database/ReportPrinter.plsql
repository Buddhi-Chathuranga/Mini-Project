-----------------------------------------------------------------------------
--
--  Logical unit: ReportPrinter
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131201  NuKuLK  Hooks: Refactored and splitted code.
--  --------------------------- APPS 9 --------------------------------------
--  130910  chanlk  Model errors corrected.
--  100422  Ajpelk  Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  120215  LAKRLK  RDTERUNTIME-1846
--  050704  UTGULK  Added attribute Language_code.Made available_printer mandatory.(F1PR861- Unicode Modifications).
--  981211  JoEd    Run through IFS/Design.
--  981106  HeNo    Changed column available_print to not mandatory.
--  970108  JaPa    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Default_Printer___
--   Sets the DefaultPrinter flag to FALSE for
--   all other printers per language if the argument DefaultPrinter is TRUE.
PROCEDURE Check_Default_Printer___ (
   default_printer_ IN VARCHAR2,
   report_id_       IN VARCHAR2,
   objid_           IN VARCHAR2,
   language_code_   IN VARCHAR2 )
IS
   CURSOR get_def_prt IS
      SELECT objid, objversion
      FROM REPORT_PRINTER
      WHERE default_printer = 'TRUE'
      AND report_id = report_id_
      AND language_code = nvl(language_code_ ,'*')
      AND objid || '' <> nvl(objid_, chr(0));
   dummy_ REPORT_PRINTER_TAB%ROWTYPE;
BEGIN
   IF (default_printer_ = 'TRUE') THEN
      FOR rec_ IN get_def_prt LOOP
         dummy_ := Lock_By_Id___(rec_.objid, rec_.objversion);
         UPDATE report_printer_tab
            SET default_printer = 'FALSE'
            WHERE rowid = rec_.objid;
      END LOOP;
   END IF;
END Check_Default_Printer___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DEFAULT_PRINTER', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REPORT_PRINTER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.language_code IS NULL) THEN
       newrec_.language_code:= '*';
   END IF;
   Check_Default_Printer___(newrec_.default_printer, newrec_.report_id, NULL,newrec_.language_code);
   IF (newrec_.available_printer IS NULL) THEN
      newrec_.available_printer := 'NULL';
   END IF;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     REPORT_PRINTER_TAB%ROWTYPE,
   newrec_     IN OUT REPORT_PRINTER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_Default_Printer___(newrec_.default_printer, newrec_.report_id, objid_,newrec_.language_code);
   IF (newrec_.available_printer IS NULL) THEN
      newrec_.available_printer := 'NULL';
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Is_Default_Printer
--   Returns TRUE if the printer is available for the report per language
--   and also is default one, NULL otherwise.
@UncheckedAccess
FUNCTION Is_Default_Printer (
   report_id_         IN VARCHAR2,
   available_printer_ IN VARCHAR2,
   language_code_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_  REPORT_PRINTER.default_printer%TYPE;
   CURSOR get_attr IS
      SELECT default_printer
      FROM REPORT_PRINTER
      WHERE report_id = report_id_
      AND available_printer = available_printer_
      AND language_code=  nvl(language_code_,'*');
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Is_Default_Printer;



