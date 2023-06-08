-----------------------------------------------------------------------------
--
--  Logical unit: PrinterConnection
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131123  NuKuLK  Hooks: Refactored and splitted code.
--  --------------------------- APPS 9 --------------------------------------
--  100422  Ajpelk Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  070423  UTGULK Modified Get_Default_Printer___ and Get_Report_User_Printer to get session lang.(Bug 64357).
--  060706  UTGULK Added methods Get_Default_Logical_Printer() ,Get_Default_Printer___.(Bug 59203)
--  051004  ASWILK Get_Default_Printer changed to reflect Get_Logical_Printers__ (Bug#52688).
--  010905  UTGULK Sorted printers by printer_id in Get_Logical_Printers__(F1PR861,Bug#53029).
--  050708  UTGULK Added lang. code to method to Get_Report_User_Printer,Get_Default_Printer.
--                Removed Get_User_Printer___,Report_Exists___.Added Get_Logical_Printers__ (F1PR861- Unicode Modifications).
--  040121  RuRa  Bug 41732, Added Get_Report_User_Printer() public method.
--  981211  JoEd  Run through IFS/Design.
--  980929  Serise  Rewritten Get_Default_Printer.
--  970623  JaPa  Get_Default_Printer() returns NULL instead of generating
--                an exception if no physical printer found.
--  970515  JaPa  Added posibility to return both logical and phisical
--                printer from function Get_Default_Printer()
--  970108  JaPa  Create
--  140508  ASIWLK Added REP_DEF_LOGI_PRNTR parameter (Bug#116780)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Default_Printer___
--   Gets printer id for the given user and report.
--   If argument PhysicalPrinter is TRUE the string that describes
--   the physical printer is returned, logical printer id otherwise.
FUNCTION Get_Default_Printer___ (
   user_id_          IN VARCHAR2,
   report_id_        IN VARCHAR2,
   language_code_    IN VARCHAR2 DEFAULT NULL,
   physical_printer_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN VARCHAR2
IS
   printer_ REPORT_USER_PRINTER.available_printer%TYPE;
   appl_general_error EXCEPTION;
   PRAGMA exception_init(appl_general_error , -20105);
   session_lang_code_  VARCHAR2(2):= Fnd_Session_Api.Get_Language();

   CURSOR get_report_user_printer IS
      SELECT available_printer
      FROM REPORT_USER_PRINTER
      WHERE user_id = user_id_
      AND report_id = report_id_
      AND default_printer = 'TRUE'
      AND ( language_code = nvl(language_code_,session_lang_code_)
      OR  language_code = '*' )
      ORDER BY language_code DESC;

   CURSOR get_report_printer IS
      SELECT available_printer
      FROM REPORT_PRINTER
      WHERE report_id = report_id_
      AND default_printer = 'TRUE'
      AND ( language_code = nvl(language_code_,session_lang_code_)
      OR  language_code = '*' )
      ORDER BY language_code DESC;

   CURSOR get_user_printer IS
      SELECT available_printer
      FROM USER_PRINTER
      WHERE user_id = user_id_
      AND default_printer = 'TRUE'
      AND ( language_code = nvl(language_code_,session_lang_code_)
      OR  language_code = '*' )
      ORDER BY language_code DESC;

   CURSOR get_printers IS
      SELECT available_printer
      FROM REPORT_USER_PRINTER
      WHERE user_id = user_id_
      AND report_id = report_id_
      AND ( language_code = nvl(language_code_,session_lang_code_)
      OR  language_code = '*' )
      UNION
      SELECT available_printer
      FROM REPORT_PRINTER
      WHERE report_id = report_id_
      AND ( language_code = nvl(language_code_,session_lang_code_)
      OR  language_code = '*' )
      UNION
      SELECT available_printer
      FROM USER_PRINTER
      WHERE user_id = user_id_
      AND ( language_code = nvl(language_code_,session_lang_code_)
      OR  language_code = '*' )
      ORDER BY available_printer;

   FUNCTION Convert_Printer___ (printer_id_ IN VARCHAR2) RETURN VARCHAR2
   IS
      ret_printer_ VARCHAR2(250);
   BEGIN
      IF physical_printer_  = 'TRUE' THEN
         LOGICAL_PRINTER_API.Convert_Logical_Printer(ret_printer_, printer_id_);
         RETURN ret_printer_;
      ELSE
         RETURN printer_id_;
      END IF;
   END Convert_Printer___;

BEGIN
   OPEN get_report_user_printer;
   FETCH get_report_user_printer INTO printer_;
   IF (get_report_user_printer%FOUND) THEN
      CLOSE get_report_user_printer;
      RETURN Convert_Printer___(printer_);
   ELSE
      CLOSE get_report_user_printer;

      OPEN get_report_printer;
      FETCH get_report_printer INTO printer_;
      IF (get_report_printer%FOUND) THEN
         CLOSE get_report_printer;
         RETURN Convert_Printer___(printer_);
      ELSE
         CLOSE get_report_printer;

         OPEN get_user_printer;
         FETCH get_user_printer INTO printer_;
         IF (get_user_printer%FOUND) THEN
            CLOSE get_user_printer;
            RETURN Convert_Printer___(printer_);
         ELSE
            CLOSE get_user_printer;

            IF (Object_Property_API.Get_Value('UserPrinter', '*', 'USER_MAND') = 'TRUE') THEN
               RETURN NULL;
            ELSE
               OPEN get_printers;
               FETCH get_printers INTO printer_;
               CLOSE get_printers;

               IF printer_ IS NOT NULL THEN
                  RETURN Convert_Printer___(printer_);
               END IF;

               printer_ := NVL(Fnd_Setting_API.Get_Value('REP_DEF_LOGI_PRNTR'),'NO_PRINTOUT');
               IF printer_!='NO_PRINTOUT' AND Logical_Printer_Api.Is_Logical_Printer(printer_) THEN
                  RETURN Convert_Printer___(printer_);
               ELSE
                  RETURN NULL;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN appl_general_error THEN
      RETURN NULL;
END Get_Default_Printer___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Logical_Printers__
--   Returns a list of all configured printers for a certain report and user.
--   If no printers are defined, this returns all logical printers.
FUNCTION Get_Logical_Printers__ (
   user_id_       IN VARCHAR2,
   report_id_     IN VARCHAR2,
   language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   printer_list_ VARCHAR2(32000);
   ret_printer_ VARCHAR2(250);

   CURSOR get_printers IS
      SELECT available_printer
      FROM REPORT_USER_PRINTER
      WHERE user_id = user_id_
      AND report_id = report_id_
      AND ( language_code = nvl(language_code_,'*')
      OR  language_code = '*' )
      UNION
      SELECT available_printer
      FROM REPORT_PRINTER
      WHERE report_id = report_id_
      AND ( language_code = nvl(language_code_,'*')
      OR  language_code = '*' )
      UNION
      SELECT available_printer
      FROM USER_PRINTER
      WHERE user_id = user_id_
      AND ( language_code = nvl(language_code_,'*')
      OR  language_code = '*' )
      ORDER BY available_printer;
BEGIN
      FOR printer_ IN get_printers LOOP
         LOGICAL_PRINTER_API.Convert_Logical_Printer(ret_printer_, printer_.available_printer);
         IF (ret_printer_ IS NOT NULL) THEN
            printer_list_ := printer_list_ ||ret_printer_ ||Client_SYS.field_separator_;
         END IF;
      END LOOP;

      RETURN printer_list_;
END Get_Logical_Printers__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Default_Printer
--   Gets printer id for the given user and report.
--   If argument PhysicalPrinter is TRUE the string that describes
--   the physical printer is returned, logical printer id otherwise.
FUNCTION Get_Default_Printer (
   user_id_          IN VARCHAR2,
   report_id_        IN VARCHAR2,
   physical_printer_ IN BOOLEAN DEFAULT TRUE,
   language_code_    IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   is_physical_printer_ VARCHAR2(5):= 'TRUE';
BEGIN
   IF NOT physical_printer_ THEN
     is_physical_printer_ := 'FALSE';
   END IF;
   RETURN Get_Default_Printer___(user_id_,report_id_,language_code_,is_physical_printer_);
END Get_Default_Printer;


-- Get_Report_User_Printer
--   Gets printer id for the given user and report.
--   If a logical printer is declared for a given user
--   and a report that logical printer is returned.
--   Otherwise default logical printer for the given report is returned.
--   If that also is null, default printer of the user is returned.
--   Otherwise null returned.
FUNCTION Get_Report_User_Printer (
   user_id_       IN VARCHAR2,
   report_id_     IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   session_lang_code_  VARCHAR2(2):= Fnd_Session_Api.Get_Language();
   CURSOR get_report_user_printer IS
      SELECT available_printer
      FROM REPORT_USER_PRINTER
      WHERE user_id = user_id_
      AND report_id = report_id_
      AND default_printer = 'TRUE'
      AND ( language_code = nvl(language_code_,session_lang_code_)
      OR  language_code = '*' )
      ORDER BY language_code DESC;
   CURSOR get_report_printer IS
      SELECT available_printer
      FROM REPORT_PRINTER
      WHERE report_id = report_id_
      AND default_printer = 'TRUE'
      AND ( language_code = nvl(language_code_,session_lang_code_)
      OR  language_code = '*' )
      ORDER BY language_code DESC;
   CURSOR get_user_printer IS
      SELECT available_printer
      FROM USER_PRINTER
      WHERE user_id = user_id_
      AND default_printer = 'TRUE'
      AND ( language_code = nvl(language_code_,session_lang_code_)
      OR  language_code = '*' )
      ORDER BY language_code DESC;
   printer_ REPORT_USER_PRINTER.available_printer%TYPE;
   appl_general_error EXCEPTION;
   PRAGMA exception_init(appl_general_error , -20105);

   FUNCTION Convert_Printer___ (printer_id_ IN VARCHAR2) RETURN VARCHAR2 IS
      ret_printer_ VARCHAR2(250);
   BEGIN
      LOGICAL_PRINTER_API.Convert_Logical_Printer(ret_printer_, printer_id_);
      RETURN ret_printer_;
   END Convert_Printer___;

BEGIN
   OPEN get_report_user_printer;
   FETCH get_report_user_printer INTO printer_;
   IF (get_report_user_printer%FOUND) THEN
      CLOSE get_report_user_printer;
      RETURN Convert_Printer___(printer_);
   ELSE
      CLOSE get_report_user_printer;

      OPEN get_report_printer;
      FETCH get_report_printer INTO printer_;
      IF (get_report_printer%FOUND) THEN
         CLOSE get_report_printer;
         RETURN Convert_Printer___(printer_);
      ELSE
         CLOSE get_report_printer;

         OPEN get_user_printer;
         FETCH get_user_printer INTO printer_;
         IF (get_user_printer%FOUND) THEN
            CLOSE get_user_printer;
            RETURN Convert_Printer___(printer_);
         ELSE
            CLOSE get_user_printer;
            RETURN NULL;
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN appl_general_error THEN
      RETURN NULL;
END Get_Report_User_Printer;


-- Get_Default_Logical_Printer
--   Gets printer id for the given user and report.
--   If argument PhysicalPrinter is TRUE the string that describes
--   the physical printer is returned, logical printer id otherwise.
FUNCTION Get_Default_Logical_Printer (
   user_id_          IN VARCHAR2,
   report_id_        IN VARCHAR2,
   language_code_    IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Default_Printer___(user_id_,report_id_,language_code_,'TRUE');
END Get_Default_Logical_Printer;



