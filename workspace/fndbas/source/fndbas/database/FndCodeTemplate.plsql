-----------------------------------------------------------------------------
--
--  Logical unit: FndCodeTemplate
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE List_Typ IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER ;
TYPE TwoD_List_Typ IS TABLE OF List_Typ INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------

TAG_START   CONSTANT VARCHAR2(3) := '<<<';
TAG_END     CONSTANT VARCHAR2(3) := '>>>';


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Export__ (
   info_ OUT CLOB,
   template_id_   IN VARCHAR2)
IS
   newline_ CONSTANT VARCHAR2(2) := chr(13)||chr(10);
   --
   CURSOR get_template IS
      SELECT *
      FROM   fnd_code_template_tab
      WHERE  template_id = template_id_;

FUNCTION Format___(
   value_  IN  VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN(''''||Replace(value_, '''', '''''')||'''');
END Format___;

FUNCTION Format___(
   value_  IN  CLOB) RETURN CLOB
IS
BEGIN
   RETURN(''''||Replace(value_, '''', '''''')||'''');
END Format___;

FUNCTION Format___(
   value_  IN  NUMBER) RETURN VARCHAR2
IS
BEGIN
   RETURN(value_);
END Format___;

FUNCTION Format___(
   value_  IN  DATE) RETURN VARCHAR2
IS
BEGIN
   IF (value_ IS NULL) THEN
      RETURN(Database_SYS.Get_Last_Calendar_Date);
   ELSE
      RETURN('To_Date('''||To_Char(value_,'YYYYMMDD HH24MISS')||''',''YYYYMMDD HH24MISS'')');
   END IF;
END Format___;

BEGIN
   info_ := info_ || 'DECLARE' || newline_;
   info_ := info_ || '   rec_ Fnd_Code_Template_TAB%ROWTYPE;' || newline_;
   info_ := info_ || 'BEGIN' || newline_;
   -- Templates
   FOR rec IN get_template LOOP
      info_ := info_ || '   rec_.template_id  := ' || Format___(template_id_) || ';'  || newline_;
      info_ := info_ || '   rec_.description  := ' || Format___(rec.description) || ';'  || newline_;
      info_ := info_ || '   rec_.rowkey       := ' || Format___(rec.rowkey) || ';'  || newline_;
      info_ := info_ || '   rec_.template     := ' || Format___(rec.template) ||';' || newline_;
      info_ := info_ || '   rec_.rowversion   := sysdate;' || newline_;
      info_ := info_ || '   Fnd_Code_Template_API.Register(rec_);' || newline_;
   END LOOP;
   info_ := info_ || 'END;' || newline_;
   info_ := info_ || '/' || newline_;
END Export__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Replace_Tag (
   tag_     IN VARCHAR2,
   value_   IN VARCHAR2,
   code_    IN OUT CLOB )
IS
BEGIN
   code_ := REPLACE(code_, TO_CLOB(TAG_START || tag_ || TAG_END), to_clob(value_));
END Replace_Tag;


PROCEDURE Replace_Tag (
   tag_     IN VARCHAR2,
   value_   IN CLOB,
   code_    IN OUT CLOB )
IS
BEGIN
   IF LENGTH(value_) > 32767 THEN
      Replace_Tag_Custom(tag_,value_,code_);
   ELSE
      code_ := REPLACE(code_, TO_CLOB(TAG_START || tag_ || TAG_END), value_);
   END IF;
END Replace_Tag;

PROCEDURE Replace_Tag_Custom(
   tag_     IN VARCHAR2,
   value_   IN CLOB,
   code_    IN OUT CLOB )
IS
   l_pos_ NUMBER := INSTR(code_,TAG_START || tag_ || TAG_END);
   r_pos_ NUMBER := l_pos_ + LENGTH(TAG_START || tag_ || TAG_END);
BEGIN
   WHILE l_pos_ > 0 LOOP
      --Tag Found
      code_ := SUBSTR(code_,1,l_pos_-1) || value_ || SUBSTR(code_,r_pos_,LENGTH(code_)-r_pos_+1);
      l_pos_ := INSTR(code_,TAG_START || tag_ || TAG_END);
      r_pos_ := l_pos_ + LENGTH(TAG_START || tag_ || TAG_END);
   END LOOP;
END Replace_Tag_Custom;

PROCEDURE Replace_Recurring_Tags (
   start_tag_ IN     VARCHAR2,
   end_tag_   IN     VARCHAR2,
   tags_      IN     List_Typ,
   tag_vals_  IN     TwoD_List_Typ,
   seperator_ IN     VARCHAR2,
   code_      IN OUT CLOB)
   
IS
   recurring_raplace_part_     CLOB;
   raw_recurring_replace_part_ CLOB;
   final_replace_block_ CLOB := to_clob(' ');
   block_before_        CLOB;
   block_after_         CLOB;
   start_tag_begin_idx_ PLS_INTEGER;
   end_tag_begin_idx_   PLS_INTEGER;
   full_start_tag_      VARCHAR2(100) := TAG_START || start_tag_ || TAG_END;
   full_end_tag_        VARCHAR2(100) := TAG_START || end_tag_ || TAG_END;
   
BEGIN
   
   start_tag_begin_idx_ := dbms_lob.instr(code_,full_start_tag_);
   end_tag_begin_idx_ := dbms_lob.instr(code_,full_end_tag_);
   raw_recurring_replace_part_ := dbms_lob.substr(code_,end_tag_begin_idx_-start_tag_begin_idx_-length(full_start_tag_),start_tag_begin_idx_+length(full_start_tag_));
   block_before_ := dbms_lob.substr(code_,start_tag_begin_idx_-1,1);
   block_after_ := dbms_lob.substr(code_,length(code_)-end_tag_begin_idx_-length(full_end_tag_),end_tag_begin_idx_+length(full_end_tag_));
   
   recurring_raplace_part_ := raw_recurring_replace_part_ ;
   FOR i IN 1..tag_vals_.COUNT LOOP
      FOR j IN tags_.FIRST..tags_.COUNT LOOP
         Replace_Tag(tag_ => tags_(j),value_ => tag_vals_(i)(j),code_ => recurring_raplace_part_);
      END LOOP;
      dbms_lob.append(recurring_raplace_part_,seperator_);
      dbms_lob.append(final_replace_block_,recurring_raplace_part_);
      recurring_raplace_part_ := raw_recurring_replace_part_;
   END LOOP;
   dbms_lob.append(block_before_,final_replace_block_);
   dbms_lob.append(block_before_,block_after_);
   code_ := block_before_ ;
END Replace_Recurring_Tags;

PROCEDURE Replace_Tags (
   tags_     IN     List_Typ,
   tag_vals_ IN     List_Typ,
   code_     IN OUT CLOB)
   
IS   
BEGIN
   FOR i IN 1..tag_vals_.COUNT LOOP
      Replace_Tag(tags_(i),tag_vals_(i),code_);
   END LOOP;
END Replace_Tags;

FUNCTION Create_Tag (
   tag_  IN VARCHAR2) RETURN CLOB
IS
BEGIN
   RETURN(TO_CLOB(TAG_START || tag_ || TAG_END));
END Create_Tag;


PROCEDURE Register (
   rec_  IN OUT Fnd_Code_Template_Tab%ROWTYPE )
IS
BEGIN
   INSERT INTO Fnd_Code_Template_Tab VALUES rec_;
EXCEPTION
   WHEN dup_val_on_index THEN -- Update if the record already exists
      SELECT rowkey
      INTO   rec_.rowkey
      FROM Fnd_Code_Template_Tab
      WHERE template_id = rec_.template_id;
      --
      UPDATE Fnd_Code_Template_Tab
      SET ROW = rec_
      WHERE template_id = rec_.template_id;
END Register;


