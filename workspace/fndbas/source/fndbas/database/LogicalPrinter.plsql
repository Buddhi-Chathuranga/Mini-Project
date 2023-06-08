-----------------------------------------------------------------------------
--
--  Logical unit: LogicalPrinter
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961213  ERFO  First version created through IFS/Design.
--  961218  MANY  Changed column printer_id to be uppercase always
--  971008  ERFO  Removed upper-function in method Exist (Bug #1690).
--  971008  ERFO  Added validation that the printer name must
--                not include any comma-characters.
--  980728  ERFO  Review of English texts by US (ToDo #2497).
--  980803  MANY  Description field must not include comma-character (consequence of
--                ToDo #1806). Fixed in Unpack_Check_Insert and Unpack_Check_Update.
--  980826  MANY  Added methods Install_Pdf_Printer_ and Deinstall_Pdf_Printer_ (ToDo #2442)
--    001025   BVLI  (NIWILK) Changed the name of PDF_PRINTER to IFS PDF Archiver (ToDo #3951)
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  050530  UTGULK Modified Unpack_Check_Insert___ to check for (-) sign in printer_Id (Bug #47976).
--  050831  UTGULK Sorted printers by printer Id in Enumerate.(F1PR861,Bug#53029
--  140129  AsiWLK   Merged LCS-111925
--  140516  ASIWLK Not possible to define a general default printer (Bug#116780)
--  151022  MADILK Overloaded Enumerate_Printer_Id to cater large number of logical printers (Bug #125324)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Not_Exist___ (
   printer_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, p1_ => printer_id_);
   super(printer_id_);
   --Add post-processing code here
END Raise_Record_Not_Exist___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN LOGICAL_PRINTER_TAB%ROWTYPE )
IS
BEGIN
   IF (remrec_.printer_id = 'PDF_PRINTER') THEN
      Error_SYS.Appl_General(lu_name_, 'NOPDFDELETE: Pdf printer cannot be deleted in this way');
   END IF;
   super(remrec_);
END Check_Delete___;


FUNCTION Locate_Physical_Printer___ (
   logical_printer_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
 pos_     NUMBER;
 printer_ VARCHAR2(100);
BEGIN
   pos_ := instr(logical_printer_id_, ',SERVER,', 1); -- Make sure it isnt alrady a physical printer id
   IF (pos_ > 0) THEN
      printer_ := substr(logical_printer_id_, pos_ + 8);
   ELSE
      printer_ := logical_printer_id_;
   END IF;
   IF (printer_ IS NOT NULL) THEN
      Exist(printer_);
      RETURN (Get_Description(printer_)||',SERVER,'||printer_); -- Now only operates on logical printers by assuming a physical id.
   ELSE
      RETURN NULL;
   END IF;
END Locate_Physical_Printer___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT logical_printer_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   IF (instr(newrec_.printer_id, ',') > 0) THEN
      Error_SYS.Appl_General(lu_name_, 'NOCOMMA: The logical printer must not include any comma character');
   ELSIF (instr(newrec_.printer_id, '-') > 0) THEN
      Error_SYS.Appl_General(lu_name_, 'NOHYPHEN: The logical printer must not include any ''-'' character');
   ELSIF (newrec_.printer_id = 'PDF_PRINTER') THEN
      Error_SYS.Appl_General(lu_name_, 'NOPDFINSERT: Pdf printer is a reserved name');
   END IF;
   newrec_.printer_id := upper(newrec_.printer_id);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     logical_printer_tab%ROWTYPE,
   newrec_ IN OUT logical_printer_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (instr(newrec_.description , ',') > 0) THEN
      Error_SYS.Appl_General(lu_name_, 'NOCOMMADESC: The logical printer description must not include any comma character');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Is_Pdf_Printer_ (
   printer_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (printer_id_ = LOGICAL_PRINTER_API.Get_Pdf_Printer) THEN
      RETURN ('TRUE');
   ELSE
      RETURN ('FALSE');
   END IF;
END Is_Pdf_Printer_;


PROCEDURE Install_Pdf_Printer_
IS
BEGIN
   INSERT INTO logical_printer_tab (
      printer_id,
      description,
      rowversion ) 
   VALUES (
      'PDF_PRINTER',
      'IFS PDF Archiver',
      sysdate );
EXCEPTION
   WHEN dup_val_on_index THEN
      NULL;
END Install_Pdf_Printer_;


PROCEDURE Deinstall_Pdf_Printer_
IS
BEGIN
   DELETE FROM logical_printer_tab
      WHERE printer_id = 'PDF_PRINTER';
END Deinstall_Pdf_Printer_;


@UncheckedAccess
-- ## to be considered for CORE Security ##
PROCEDURE Enumerate_Printer_Id_ (
   list_ OUT VARCHAR2,
   continue_ OUT VARCHAR2,
   count_ IN NUMBER )
IS
   printer_list_ VARCHAR2(32000);
   from_         INTEGER;
   to_           INTEGER;
   printer_      VARCHAR2(200);
   tmp_list_     VARCHAR2(32000);
   data_       CLOB;
   length_      NUMBER;
BEGIN
   dbms_lob.createtemporary(data_, TRUE);
   dbms_lob.open(data_, dbms_lob.lob_readwrite);
   
      Enumerate(printer_list_);
      from_ := 1;
      to_ := instr(printer_list_, Client_SYS.field_separator_);
    IF (to_ > 0) THEN 
      WHILE (to_ > 0) LOOP
         printer_ := substr(printer_list_, from_, to_ - from_);
         tmp_list_ := Get_Description(printer_)||',SERVER,'||printer_ || Client_SYS.field_separator_; -- Now only operates on logical printers.
         from_ := to_ + 1;
         to_ := instr(printer_list_, Client_SYS.field_separator_, from_);
         dbms_lob.WriteAppend(data_,length(tmp_list_),tmp_list_);
        
      END LOOP;
      length_ := dbms_lob.getlength(data_)- count_;
      
      IF length_ > 3000 THEN  -- limit depends on the number of byte in a character, therefore limited to 3000.
         continue_ := 'TRUE';
         list_   := dbms_lob.substr(data_, 3000, count_ + 1);
      ELSE
         continue_ := 'FALSE';
         list_   := dbms_lob.substr(data_, length_, count_ + 1);
      END IF;
      dbms_lob.close(data_);
      
   ELSE
      list_ := NULL;
   END IF;
END Enumerate_Printer_Id_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Enumerate (
   printer_id_list_ OUT VARCHAR2 )
IS
   temp_  VARCHAR2(32000);
   CURSOR get_printers IS
      SELECT printer_id
      FROM   LOGICAL_PRINTER_TAB
      ORDER BY printer_id;
BEGIN
   FOR rec IN get_printers LOOP
      temp_ := temp_||rec.printer_id||Client_SYS.field_separator_;
   END  LOOP;
   printer_id_list_ := temp_;
END Enumerate;


@UncheckedAccess
PROCEDURE Enumerate_Printer_Id (
   list_ OUT VARCHAR2 )
IS
   printer_list_ VARCHAR2(32000);
   from_         INTEGER;
   to_           INTEGER;
   printer_      VARCHAR2(200);
   tmp_list_     VARCHAR2(32000);
   curr_size_    INTEGER;
   curr_text_    VARCHAR2(1000);
BEGIN
   Enumerate(printer_list_);
   from_ := 1;
   to_ := instr(printer_list_, Client_SYS.field_separator_);
   IF (to_ > 0) THEN
      WHILE (to_ > 0) LOOP
         printer_ := substr(printer_list_, from_, to_ - from_);
         curr_text_ := Get_Description(printer_) || ',SERVER,' || printer_ || Client_SYS.field_separator_;
         curr_size_ := curr_size_ + LENGTH(curr_text_);
         IF (curr_size_ > 31980) THEN
            curr_text_ := ' and more,...,...' || Client_SYS.field_separator_;
            tmp_list_ := tmp_list_ || curr_text_;
            EXIT;
         END IF;
         tmp_list_ := tmp_list_ || curr_text_;
         from_ := to_ + 1;
         to_ := instr(printer_list_, Client_SYS.field_separator_, from_);
         curr_size_ := LENGTH(tmp_list_);
      END LOOP;
      list_ := tmp_list_;
   ELSE
      list_ := NULL;
   END IF;
END Enumerate_Printer_Id;


@UncheckedAccess  
PROCEDURE Enumerate_Printer_Id (
   list_ OUT CLOB )
IS
   printer_list_ VARCHAR2(32000);
   from_         INTEGER;
   to_           INTEGER;
   printer_      VARCHAR2(200);
   tmp_list_     CLOB;
   BEGIN
      Enumerate(printer_list_);
      from_ := 1;
      to_ := instr(printer_list_, Client_SYS.field_separator_);
    IF (to_ > 0) THEN
      WHILE (to_ > 0) LOOP
         printer_ := substr(printer_list_, from_, to_ - from_);
         tmp_list_ := tmp_list_ || Get_Description(printer_) || ',SERVER,' || printer_ || Client_SYS.field_separator_;
         from_ := to_ + 1;
         to_ := instr(printer_list_, Client_SYS.field_separator_, from_);
      END LOOP;
      list_ := tmp_list_;
   ELSE
      list_ := NULL;
   END IF;
END Enumerate_Printer_Id;


PROCEDURE Convert_Logical_Printer (
   printer_id_  OUT VARCHAR2,
   printer_     IN  VARCHAR2 )
IS
   exist_err   EXCEPTION;
   PRAGMA      exception_init(exist_err, -20111);
BEGIN
   printer_id_ := Locate_Physical_Printer___(printer_); -- Now only operates on logical printers.
EXCEPTION
   WHEN exist_err THEN
      Error_SYS.Appl_General(lu_name_, 'NOPRINTERATALL: Printer ":P1" is not configured correctly.', printer_);
END Convert_Logical_Printer;


@UncheckedAccess
FUNCTION Get_Pdf_Printer RETURN VARCHAR2
IS
BEGIN
   RETURN (Get_Description('PDF_PRINTER')||',SERVER,'||'PDF_PRINTER');
EXCEPTION
   WHEN OTHERS THEN
      RETURN (NULL);
END Get_Pdf_Printer;

FUNCTION Is_Logical_Printer (
   printer_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN

   IF (Check_Exist___(printer_id_)) THEN
      RETURN TRUE;
   END IF;
   
   RETURN FALSE;   
END Is_Logical_Printer;


