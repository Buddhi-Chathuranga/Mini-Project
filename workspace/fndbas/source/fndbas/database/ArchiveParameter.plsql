-----------------------------------------------------------------------------
--
--  Logical unit: ArchiveParameter
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960409  MANY  Base Table to Logical Unit Generator 1.0A
--  960526  MANY  Fixed bug with empty parameter set in New_Entry_Parameter__().
--  960930  MANY  Added method Get_Parameter_Attr().
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  000912  ROOD  Added restriction on the view (ToDo #3935).
--  001008  ROOD  Updated template version to 2.2.
--  020702  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  020925  ROOD  Used table instead of view in some get_methods (Bug#33077).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  100215  ChMu  Bug 88742, Changed parameter_value_ in New_Entry_Parameter__,
--                parameter_attr_ in Get_Parameter_Query_List and Get_Parameter_Query_List, 
--                value_ in Unpack_Check_Insert___ and Unpack_Check_Update___ to VARCHAR2(4000
--  170309  CHAALK  Character string buffer too small error when ordering a report (BugID#134696)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

field_separator_  CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;

record_separator_ CONSTANT VARCHAR2(1) := Client_SYS.record_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE New_Entry_Parameter__ (
   result_key_       IN NUMBER,
   parameter_values_ IN VARCHAR2 )
IS
   ptr_             NUMBER;
   parameter_name_  VARCHAR2(30);
   parameter_value_ VARCHAR2(4000);
   parameter_temp_value_    VARCHAR2(32000);
BEGIN
   IF (parameter_values_ IS NOT NULL) THEN
      WHILE (Client_SYS.Get_Next_From_Attr(parameter_values_, ptr_, parameter_name_, parameter_temp_value_)) LOOP
         parameter_value_ := NULL;
         -- Truncating the parameter att to 4000 as the maximum character limit for a varchar filed in Oracle is 4000 characters
         parameter_value_ := substr(parameter_temp_value_, 0, 4000);
         INSERT INTO ARCHIVE_PARAMETER_TAB (result_key, parameter_name, parameter_value, rowversion)
            VALUES (result_key_, parameter_name_, parameter_value_, sysdate);
      END LOOP;
   END IF;
END New_Entry_Parameter__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Clear (
   result_key_ IN NUMBER )
IS
BEGIN
   DELETE FROM ARCHIVE_PARAMETER_TAB
      WHERE result_key = result_key_;
END Clear;


@UncheckedAccess
PROCEDURE Get_Parameter_Attr (
   parameter_attr_ OUT VARCHAR2,
   result_key_     IN  NUMBER )
IS
   attr_ VARCHAR2(32000);
   CURSOR get_parms IS
      SELECT *
      FROM   ARCHIVE_PARAMETER_TAB
      WHERE  result_key = result_key_;
BEGIN
   FOR parm IN get_parms LOOP
      Client_SYS.Add_To_Attr(parm.parameter_name, parm.parameter_value, attr_);
   END LOOP;
   parameter_attr_ := attr_;
END Get_Parameter_Attr;


@UncheckedAccess
PROCEDURE Get_Parameter_Query_List (
   parameter_query_list_ OUT VARCHAR2,
   parameter_value_list_ OUT VARCHAR2,
   report_id_            IN  VARCHAR2,
   result_key_           IN  VARCHAR2 )
IS
   CURSOR parameter_values IS
      SELECT parameter_value, parameter_name
      FROM   ARCHIVE_PARAMETER_TAB
      WHERE  result_key = result_key_;
   parameter_attr_   VARCHAR2(10000);
BEGIN
   FOR parameter IN parameter_values LOOP
      Client_SYS.Add_To_Attr(parameter.parameter_name, parameter.parameter_value, parameter_attr_);
   END LOOP;
   Report_Definition_API.Format_Query_Lists(parameter_query_list_, parameter_value_list_, parameter_attr_, report_id_);
END Get_Parameter_Query_List;


@UncheckedAccess
PROCEDURE Get_Parameters (
   parameter_values_ OUT VARCHAR2,
   result_key_       IN  VARCHAR2 )
IS
   CURSOR parameter_values IS
      SELECT parameter_value, parameter_name
      FROM   ARCHIVE_PARAMETER_TAB
      WHERE  result_key = result_key_;
   parameter_attr_ VARCHAR2(10000);
BEGIN
   FOR parameter IN parameter_values LOOP
      parameter_attr_ := parameter_attr_ || parameter.parameter_name || field_separator_ ||
                                            parameter.parameter_value || record_separator_;
   END LOOP;
   parameter_values_ := parameter_attr_;
END Get_Parameters;



