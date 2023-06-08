-----------------------------------------------------------------------------
--
--  Logical unit: AttributeDefinition
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131123  NuKuLK  Hooks: Refactored and splitted code.
--  --------------------------- APPS 9 --------------------------------------
--  100421  Ajpelk Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  071126  SUMALK Added max_length to hold the max length of the attribute(Bug#69372)
--  060818  UsRaLK Added error message ROWCOUNT_ERROR and changed message VALUE_TOO_LONG (Bug#57839).
--  060530  UtGuLk Added method Upgrade_Length (Bug#58366).
--  050829  AsWiLk Added method Get_Length (Bug#52819).
--  020109  RaKo  IID 20002 Removed length check on base_lu = 'Company' and attribute_name = 'COMPANY'.
--  011025  LiSv  Added Info message when length > 2 and base_lu = 'Company' and attribute_name = 'COMPANY'.
--  990525  JoEd  New template.
--                Call id 16744: Changed error message in Check_Value.
--  961122  JaPa  New procedure to set up new or update existing definition
--  960902  JaPa  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Lines___
--   Checks number of lines and max line length of the attribute.
PROCEDURE Check_Lines___ (
   lines_cnt_ OUT NUMBER,
   max_len_   OUT NUMBER,
   str_       IN  VARCHAR2 )
IS
   cnt_ NUMBER := 0;
   len_ NUMBER := 0;
   max_ NUMBER := 0;
   nl_  NUMBER := 0;
BEGIN
   FOR n_ IN 1 .. length(str_) LOOP
      IF (substr(str_, n_, 1) = chr(10)) THEN
         cnt_ := cnt_ + 1;
         nl_ := n_;
         IF (len_ > max_) THEN
            max_ := len_;
         END IF;
         len_ := 0;
      ELSIF (substr(str_, n_, 1) != chr(13)) THEN
         len_ := len_ + 1;
      END IF;
   END LOOP;
   IF (length(str_) - nl_ > max_) THEN
      max_ := length(str_) - nl_;
   END IF;
   lines_cnt_ := cnt_ + 1;
   max_len_   := max_;
END Check_Lines___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PARAMETER_NAME', '*', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT attribute_definition_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   IF newrec_.length > newrec_.max_length THEN
      Error_SYS.Appl_General(lu_name_, 'WRONGLENGTH: Length cannot exceed the maximum allowed length :P1',newrec_.max_length);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     attribute_definition_tab%ROWTYPE,
   newrec_ IN OUT attribute_definition_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.length > newrec_.max_length THEN
      Error_SYS.Appl_General(lu_name_, 'WRONGLENGTH: Length cannot exceed the maximum allowed length :P1',newrec_.max_length);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Value
--   Checks current value of the attribute. Calls Error_SYS.Item_Format()
--   if length of the current value is greater then the definition.
--   Checks current value of the attribute. Calls Error_SYS.Item_Format()
--   if the total number of signs is greater then the definition.
PROCEDURE Check_Value (
   current_value_  IN VARCHAR2,
   base_lu_        IN VARCHAR2,
   attribute_name_ IN VARCHAR2,
   parameter_name_ IN VARCHAR2 DEFAULT NULL )
IS
   length_      NUMBER;
   rows_count_  NUMBER;
   lines_cnt_   NUMBER;
   max_len_     NUMBER;
   CURSOR get_attr IS
      SELECT length, nvl(rows_count, 1)
      FROM ATTRIBUTE_DEFINITION_TAB
      WHERE base_lu = base_lu_
      AND attribute_name = attribute_name_
      AND parameter_name = nvl(parameter_name_, '*');
BEGIN
   Trace_SYS.Field('current_value', current_value_);
   Trace_SYS.Field('base_lu_', base_lu_);
   Trace_SYS.Field('attribute_name_', attribute_name_);
   Trace_SYS.Field('parameter_name_', parameter_name_);
   IF (current_value_ IS NOT NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO length_, rows_count_;
      CLOSE get_attr;
      Trace_SYS.Field('length_', length_);
      Trace_SYS.Field('rows_count_', rows_count_);
      Check_Lines___(lines_cnt_, max_len_, current_value_);
      Trace_SYS.Field('max_len_', max_len_);
      Trace_SYS.Field('lines_cnt_', lines_cnt_);
      IF (max_len_ > length_) THEN
         Trace_SYS.Message('Value format error');
         Error_SYS.Item_General(lu_name_, attribute_name_, 'VALUE_TOO_LONG: The entered value for :NAME is longer than its defined length in Attribute Definition.');
      ELSIF (lines_cnt_ > rows_count_) THEN
         Error_SYS.Item_General(lu_name_, attribute_name_, 'ROWCOUNT_ERROR: The entered value for :NAME is longer than the row count specified in Attribute Definition.');
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Trace_SYS.Message('No data found');
END Check_Value;


-- Check_Value
--   Checks current value of the attribute. Calls Error_SYS.Item_Format()
--   if length of the current value is greater then the definition.
--   Checks current value of the attribute. Calls Error_SYS.Item_Format()
--   if the total number of signs is greater then the definition.
PROCEDURE Check_Value (
   current_value_  IN NUMBER,
   base_lu_        IN VARCHAR2,
   attribute_name_ IN VARCHAR2,
   parameter_name_ IN VARCHAR2 DEFAULT NULL )
IS
   length_      NUMBER;
   rows_count_  NUMBER;
   CURSOR get_attr IS
      SELECT length, nvl(rows_count, 0)
      FROM ATTRIBUTE_DEFINITION_TAB
      WHERE base_lu = base_lu_
      AND attribute_name = attribute_name_
      AND parameter_name = nvl(parameter_name_, '*');
BEGIN
   Trace_SYS.Field('current_value_', current_value_);
   Trace_SYS.Field('base_lu_', base_lu_);
   Trace_SYS.Field('attribute_name_', attribute_name_);
   Trace_SYS.Field('parameter_name_', parameter_name_);
   IF (current_value_ IS NOT NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO length_, rows_count_;
      CLOSE get_attr;
      Trace_SYS.Field('length_', length_);
      Trace_SYS.Field('rows_count_', rows_count_);
      IF (current_value_ > power(10, length_ - rows_count_) - 1) THEN
         Trace_SYS.Message('Value format error');
         Error_SYS.Item_General(lu_name_, attribute_name_, 'VALUE_TOO_LONG: The entered value for :NAME is longer than its defined length in Attribute Definition.');
      END IF;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      Trace_SYS.message('No data found');
END Check_Value;


-- Set_Length
--   Creates or updates definition of the attribute.
--   Should be called on module installation.
PROCEDURE Set_Length (
   base_lu_        IN VARCHAR2,
   attribute_name_ IN VARCHAR2,
   parameter_name_ IN VARCHAR2,
   length_         IN NUMBER,
   rows_count_     IN NUMBER DEFAULT NULL )
IS
   indrec_     Indicator_Rec;
   newrec_     ATTRIBUTE_DEFINITION_TAB%ROWTYPE;
   oldrec_     ATTRIBUTE_DEFINITION_TAB%ROWTYPE;
   attr_       VARCHAR2(200) := NULL;
   objid_      ATTRIBUTE_DEFINITION.objid%TYPE;
   objversion_ ATTRIBUTE_DEFINITION.objversion%TYPE;
BEGIN
   Trace_SYS.Field('length_', length_);
   Trace_SYS.Field('rows_count_', rows_count_);
   IF NOT Check_Exist___(base_lu_, attribute_name_, parameter_name_) THEN
      Client_SYS.Add_To_Attr('BASE_LU', base_lu_, attr_);
      Client_SYS.Add_To_Attr('ATTRIBUTE_NAME', attribute_name_, attr_);
      Client_SYS.Add_To_Attr('PARAMETER_NAME', parameter_name_, attr_);
      Client_SYS.Add_To_Attr('LENGTH', length_, attr_);
      Client_SYS.Add_To_Attr('MAX_LENGTH', length_, attr_);
      IF (rows_count_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('ROWS_COUNT', rows_count_, attr_);
      END IF;
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      Get_Id_Version_By_Keys___(objid_, objversion_, base_lu_, attribute_name_, parameter_name_);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      IF (length_ <= newrec_.max_length) THEN
         Client_SYS.Add_To_Attr('LENGTH', length_, attr_);
      END IF;
      IF (newrec_.rows_count IS NOT NULL) THEN
         IF ((rows_count_ IS NULL) OR (rows_count_ < newrec_.rows_count)) THEN
            Client_SYS.Add_To_Attr('ROWS_COUNT', rows_count_, attr_);
         END IF;
      END IF;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
END Set_Length;


PROCEDURE Get_Length (
   length_         OUT NUMBER,
   rows_count_     OUT NUMBER,
   base_lu_        IN  VARCHAR2,
   attribute_name_ IN  VARCHAR2,
   parameter_name_ IN  VARCHAR2 DEFAULT NULL )
IS
   CURSOR get_attr IS
      SELECT length, rows_count
      FROM ATTRIBUTE_DEFINITION_TAB
      WHERE base_lu = base_lu_
      AND attribute_name = attribute_name_
      AND parameter_name = NVL(parameter_name_, '*');
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO length_, rows_count_;
   CLOSE get_attr;
END Get_Length;


-- Upgrade_Length
--   use this only when increasing the lengh of the same attribute from the
--   same module is required in an upgrade.Use Set_Length() at all other times.
PROCEDURE Upgrade_Length (
   base_lu_        IN VARCHAR2,
   attribute_name_ IN VARCHAR2,
   parameter_name_ IN VARCHAR2,
   length_         IN NUMBER )
IS
   indrec_     Indicator_Rec;
   newrec_     ATTRIBUTE_DEFINITION_TAB%ROWTYPE;
   oldrec_     ATTRIBUTE_DEFINITION_TAB%ROWTYPE;
   attr_       VARCHAR2(200) := NULL;
   objid_      ATTRIBUTE_DEFINITION.objid%TYPE;
   objversion_ ATTRIBUTE_DEFINITION.objversion%TYPE;
BEGIN
   IF Check_Exist___(base_lu_, attribute_name_, parameter_name_) THEN
      oldrec_ := Lock_By_Keys___(base_lu_, attribute_name_, parameter_name_);
      newrec_ := oldrec_;
      IF (length_ <= newrec_.max_length) THEN
         Client_SYS.Add_To_Attr('LENGTH', length_, attr_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_,TRUE);
      END IF;
   END IF;
END Upgrade_Length;


PROCEDURE Set_Max_Length (
   base_lu_ IN VARCHAR2,
   attribute_name_ IN VARCHAR2,
   parameter_name_ IN VARCHAR2,
   max_length_     IN NUMBER)
IS
   indrec_     Indicator_Rec;
   newrec_     ATTRIBUTE_DEFINITION_TAB%ROWTYPE;
   oldrec_     ATTRIBUTE_DEFINITION_TAB%ROWTYPE;
   attr_       VARCHAR2(200) := NULL;
   objid_      ATTRIBUTE_DEFINITION.objid%TYPE;
   objversion_ ATTRIBUTE_DEFINITION.objversion%TYPE;
BEGIN
   Trace_SYS.Field('max_length_', max_length_);
   
   Get_Id_Version_By_Keys___(objid_, objversion_, base_lu_, attribute_name_, parameter_name_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   
   IF (max_length_ > newrec_.max_length) THEN
      Client_SYS.Add_To_Attr('MAX_LENGTH', max_length_, attr_);
   END IF;
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Max_Length;



