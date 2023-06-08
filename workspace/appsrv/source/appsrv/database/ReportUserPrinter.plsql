-----------------------------------------------------------------------------
--
--  Logical unit: ReportUserPrinter
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120215  LAKRLK RDTERUNTIME-1846
--  981211  JoEd  Run through IFS/Design.
--  981106  HeNo  Changed column available_printer to not mandatory.
--  980928  Serise  Created.
--  010612  Larelk Bud 22173, Added General_SYS.Init_Method in Is_Default_Printer.
--  050704  UTGULK Added column Language_code.Made available_printer mandatory. (F1PR861- Unicode Modifications).
--  --------------------------Eagle------------------------------------------
--  100422  Ajpelk Merge rose method documentation
--  130911  chanlk   Model errors corrected.
--  ---------------------------- APPS 9 -------------------------------------
--  131202  jagrno  Hooks: Refactored and split code
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
   Client_SYS.Add_To_Attr('DEFAULT_PRINTER', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REPORT_USER_PRINTER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- server defaults
   newrec_.language_code := nvl(newrec_.language_code, '*');
   newrec_.available_printer := nvl(newrec_.available_printer, 'NULL');
   Check_Default_Printer___(newrec_.default_printer, newrec_.report_id, newrec_.user_id, NULL,newrec_.language_code);
   --
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     REPORT_USER_PRINTER_TAB%ROWTYPE,
   newrec_     IN OUT REPORT_USER_PRINTER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_Default_Printer___(newrec_.default_printer, newrec_.report_id, newrec_.user_id, objid_, newrec_.language_code);
   --
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


-- Check_Default_Printer___
--   Sets the DefaultPrinter flag to FALSE for all
--   other printers if the argument DefaultPrinter is TRUE.
PROCEDURE Check_Default_Printer___ (
   default_printer_ IN VARCHAR2,
   report_id_       IN VARCHAR2,
   user_id_         IN VARCHAR2,
   objid_           IN VARCHAR2,
   language_code_   IN VARCHAR2 )
IS
   CURSOR get_def_prt IS
      SELECT objid, objversion
      FROM   REPORT_USER_PRINTER
      WHERE  default_printer = 'TRUE'
      AND    report_id = report_id_
      AND    user_id = user_id_
      AND    language_code = nvl(language_code_ ,'*')
      AND    objid || '' <> nvl(objid_, chr(0));
   --
   dummy_ report_user_printer_tab%ROWTYPE;
BEGIN
   IF (default_printer_ = 'TRUE') THEN
      FOR rec_ IN get_def_prt LOOP
         dummy_ := Lock_By_Id___(rec_.objid, rec_.objversion);
         UPDATE report_user_printer_tab
            SET    default_printer = 'FALSE'
            WHERE  rowid = rec_.objid;
      END LOOP;
   END IF;
END Check_Default_Printer___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Is_Default_Printer
--   Returns TRUE if the printer is available for the report
--   and user per language, and is also default one, NULL otherwise.
FUNCTION Is_Default_Printer (
   report_id_         IN VARCHAR2,
   available_printer_ IN VARCHAR2,
   user_id_           IN VARCHAR2,
   language_code_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_  REPORT_USER_PRINTER_TAB.default_printer%TYPE;
   CURSOR get_attr IS
      SELECT default_printer
      FROM   REPORT_USER_PRINTER_TAB
      WHERE  report_id = report_id_
      AND    available_printer = available_printer_
      AND    user_id = user_id_
      AND    language_code =  nvl(language_code_, '*');
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Is_Default_Printer;



