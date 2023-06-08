-----------------------------------------------------------------------------
--
--  Logical unit: ArchiveVariable
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980923  MANY   Changed Unpack_Check_Insert___ to allow NULL values for attribute
--                 VALUE (Bug #2725)
--  981019  MANY   Fixed some translations to better conform with US (ToDo #2746).
--  991020  ERFO   Solved problem in public method Clear (Bug #3619).
--  000912  ROOD   Added restriction on the view (ToDo #3935).
--  001008  ROOD   Updated template version to 2.2.
--  020702  ROOD   Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD   Changed module to FNDBAS (ToDo#4149).
--  100215  ChMu   Bug 88742, value_ in Unpack_Check_Insert___ Unpack_Check_Update___ to VARCHAR2(4000) 
--  130905  MABALK QA Script Cleanup - PrivateInterfaces (Bug #112227
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Variable (
   result_key_    IN NUMBER,
   variable_name_ IN VARCHAR2,
   value_         IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     ARCHIVE_VARIABLE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, attr_);
   Client_SYS.Add_To_Attr('VARIABLE_NAME', variable_name_, attr_);
   Client_SYS.Add_To_Attr('VALUE', value_, attr_);
   Client_SYS.Add_To_Attr('DATA_TYPE', 'S', attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Set_Variable;


PROCEDURE Set_Variable (
   result_key_    IN NUMBER,
   variable_name_ IN VARCHAR2,
   value_         IN NUMBER )
IS
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     ARCHIVE_VARIABLE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, attr_);
   Client_SYS.Add_To_Attr('VARIABLE_NAME', variable_name_, attr_);
   Client_SYS.Add_To_Attr('VALUE', value_, attr_);
   Client_SYS.Add_To_Attr('DATA_TYPE', 'N', attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Set_Variable;


PROCEDURE Set_Variable (
   result_key_    IN NUMBER,
   variable_name_ IN VARCHAR2,
   value_         IN DATE )
IS
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     ARCHIVE_VARIABLE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, attr_);
   Client_SYS.Add_To_Attr('VARIABLE_NAME', variable_name_, attr_);
   Client_SYS.Add_To_Attr('VALUE', value_, attr_);
   Client_SYS.Add_To_Attr('DATA_TYPE', 'D', attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Set_Variable;


PROCEDURE Set_Object (
   result_key_    IN NUMBER,
   variable_name_ IN VARCHAR2,
   value_         IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     ARCHIVE_VARIABLE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, attr_);
   Client_SYS.Add_To_Attr('VARIABLE_NAME', variable_name_, attr_);
   Client_SYS.Add_To_Attr('VALUE', value_, attr_);
   Client_SYS.Add_To_Attr('DATA_TYPE', 'O', attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Set_Object;


PROCEDURE Clear (
   result_key_ IN NUMBER )
IS
BEGIN
   DELETE
      FROM ARCHIVE_VARIABLE_TAB
      WHERE result_key = result_key_;
END Clear;


@UncheckedAccess
PROCEDURE Enumerate_String (
   attr_ OUT VARCHAR2,
   result_key_ IN NUMBER )
IS
   tmp_attr_ VARCHAR2(32000);
   CURSOR get_vars IS
      SELECT * 
      FROM ARCHIVE_VARIABLE_TAB
      WHERE  data_type = 'S'
      AND    result_key = result_key_;
BEGIN
   Client_SYS.Clear_Attr(tmp_attr_);
   FOR rec_ IN get_vars LOOP
      Client_SYS.Add_To_Attr(rec_.variable_name, rec_.value, tmp_attr_);
   END LOOP;
   attr_ := tmp_attr_;
END Enumerate_String;


@UncheckedAccess
PROCEDURE Enumerate_Number (
   attr_ OUT VARCHAR2,
   result_key_ IN NUMBER )
IS
   tmp_attr_ VARCHAR2(32000);
   CURSOR get_vars IS
      SELECT * 
      FROM ARCHIVE_VARIABLE_TAB
      WHERE  data_type = 'N'
      AND    result_key = result_key_;
BEGIN
   Client_SYS.Clear_Attr(tmp_attr_);
   FOR rec_ IN get_vars LOOP
      Client_SYS.Add_To_Attr(rec_.variable_name, rec_.value, tmp_attr_);
   END LOOP;
   attr_ := tmp_attr_;
END Enumerate_Number;


@UncheckedAccess
PROCEDURE Enumerate_Date (
   attr_ OUT VARCHAR2,
   result_key_ IN NUMBER )
IS
   tmp_attr_ VARCHAR2(32000);
   CURSOR get_vars IS
      SELECT * 
      FROM ARCHIVE_VARIABLE_TAB
      WHERE  data_type = 'D'
      AND    result_key = result_key_;
BEGIN
   Client_SYS.Clear_Attr(tmp_attr_);
   FOR rec_ IN get_vars LOOP
      Client_SYS.Add_To_Attr(rec_.variable_name, rec_.value, tmp_attr_);
   END LOOP;
   attr_ := tmp_attr_;
END Enumerate_Date;


@UncheckedAccess
PROCEDURE Enumerate_Object (
   attr_ OUT VARCHAR2,
   result_key_ IN NUMBER )
IS
   tmp_attr_ VARCHAR2(32000);
   CURSOR get_vars IS
      SELECT * 
      FROM ARCHIVE_VARIABLE_TAB
      WHERE  data_type = 'O'
      AND    result_key = result_key_;
BEGIN
   Client_SYS.Clear_Attr(tmp_attr_);
   FOR rec_ IN get_vars LOOP
      Client_SYS.Add_To_Attr(rec_.variable_name, rec_.value, tmp_attr_);
   END LOOP;
   attr_ := tmp_attr_;
END Enumerate_Object;



