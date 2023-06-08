-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalSearchCriteria
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960909  JoRo  Created
--  961205  JoRo  Removed commit in method Create_Query_. Added DbTransaction...
--                in client instead
--  970219  frtv  Upgraded.
--  970410  frtv  Added restrictions on numeric data (added silent etc...)
--
--  020517  LeSvse Bug 27675, Added new column attrib_number in view TECHNICAL_SEARCH_CRITERIA, changed methods 'Unpack_Check_Insert___',
--                'Insert___','Unpack_Check_Update___', 'Update___'.
--  020917  ChBalk Merged the IceAge code with TakeOff code.
--  060801  UtGulk Rewrote Create_Query_() using bind variables to make code assert safe (Bug 58228). 
--  100324  PKULLK Updated Create_Query_() to make dynamic SQL statement 'assert safe' (Bug 84970).
--  --------------------------Eagle------------------------------------------
--  100422  Ajpelk Merge rose method documentatio
--  --------------------------- APPS 9 --------------------------------------
--  131128  NuKuLK  Hooks: Refactored and splitted code.
--  131203  NuKuLK  PBSA-2925, Modified Check_Update___().
--  151130  INMALK  STRSA-1454, Removed the check for Technical Attribute Text
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     technical_search_criteria_tab%ROWTYPE,
   newrec_ IN OUT technical_search_criteria_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'TECHNICAL_SEARCH_NO', newrec_.technical_search_no);
   Error_SYS.Check_Not_Null(lu_name_, 'TECHNICAL_CLASS', newrec_.technical_class);
   Error_SYS.Check_Not_Null(lu_name_, 'ATTRIBUTE', newrec_.attribute);
   Error_SYS.Check_Not_Null(lu_name_, 'SEARCH_TYPE', newrec_.search_type);
END Check_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Delete_Criteria__
--   Delete a temporary search criteria identified by TechnicalSearchNo
PROCEDURE Delete_Criteria__ (
   technical_search_no_ IN NUMBER )
IS
   info_       VARCHAR2(2000);

   CURSOR get_objid IS
      SELECT objid, objversion
      FROM TECHNICAL_SEARCH_CRITERIA
      WHERE technical_search_no = technical_search_no_;
BEGIN
   FOR item IN get_objid LOOP
      Remove__(info_, item.objid, item.objversion, 'DO');
   END LOOP;
END Delete_Criteria__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Create_Query_
--   Method for dynamically creating a PLSQL statement used
--   when executing the query
PROCEDURE Create_Query_ (
   technical_search_no_ IN NUMBER,
   technical_class_     IN VARCHAR2 )
IS
   cursor_name_           INTEGER;
   stmt_                  VARCHAR2(32000);
   stmt_where_            VARCHAR2(32000);
   attribute_             VARCHAR2(15);
   where_text_            VARCHAR2(2000);
   technical_spec_no_     NUMBER;
   technical_spec_no_out_ NUMBER;
   info_                  VARCHAR2(2000);
   attr_                  VARCHAR2(32000);
   objversion_            VARCHAR2(26000);
   objid_                 VARCHAR2(50);
   n_return_              INTEGER;

   TYPE var_Array_Type IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;
   part1_name_array_   var_Array_Type;
   part1_value_array_  var_Array_Type;
   part2_name_array_   var_Array_Type;
   part2_value_array_  var_Array_Type;
   value_name_array_ var_Array_Type;
   value_array_  var_Array_Type;
   index_  NUMBER := 0;
   part1_var_count_ NUMBER:=0;
   part2_var_count_ NUMBER:=0;

 -- Used temporarily until better suggestion :-)
   CURSOR get_alphanum_attribute IS
      SELECT attribute, value_text
      FROM technical_search_criteria
      WHERE technical_search_no = technical_search_no_
      AND value_text IS NOT NULL;

 -- Used to decode the where statement
   FUNCTION Get_Where_Expression___ (
      attribute2_ IN VARCHAR2,
      text2_ IN VARCHAR2) RETURN VARCHAR2
   IS
     text_copy_ VARCHAR2(2000);
     text_current_ VARCHAR2(2000);
     stmt2_ VARCHAR2(32000);
     part1_ VARCHAR2(32000);
     part2_ VARCHAR2(32000);
     done_ BOOLEAN;
     eval_ BOOLEAN;
     pos_ NUMBER;
     part1_index_  NUMBER := 0;
     part2_index_  NUMBER := 0;
   BEGIN
      part1_name_array_.DELETE;
      part1_value_array_.DELETE;
      part2_name_array_.DELETE;
      part2_value_array_.DELETE;

      text_copy_ := RTRIM(text2_,';');
      part1_ := NULL;
      part2_ := NULL;
      done_ := text_copy_ IS NULL;
      WHILE (NOT done_) LOOP
 -- get current part of string
         pos_ := INSTR(text_copy_,';',1);
         IF (pos_ = 0) THEN
            text_current_ := text_copy_;
            done_ := TRUE;
         ELSE
            text_current_ := SUBSTR(text_copy_,1,pos_ -1);
            text_copy_ := SUBSTR(text_copy_,pos_ +1);
         END IF;
 -- process current part of string
         eval_ := FALSE;
         -- process '!='
         IF (NOT eval_) THEN
            pos_ := INSTR(text_current_,'!=',1);
            IF (pos_ = 1) THEN
               -- Remove only the preceeding != sign
               text_current_ := SUBSTR(text_current_,3);
               IF (text_current_ IS NULL) THEN
                  IF (part2_ IS NULL) THEN
                     part2_ := ' AND (';
                  ELSE
                     part2_ := part2_ || ' OR ';
                  END IF;
                  part2_index_ := part2_index_+1;
                  part2_var_count_ := part2_var_count_ +1;

                  part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
                  part2_value_array_(part2_index_):= attribute2_;

                  part2_ := part2_ || ' (t2.attribute = :'|| part2_name_array_(part2_index_) ;
                  part2_ := part2_||' AND t2.value_text IS NOT NULL) ';
                  eval_ := TRUE;
               ELSE

                  part1_index_ := part1_index_+3;
                  part1_var_count_ := part1_var_count_ +3;

                  part1_name_array_(part1_index_-2) := 'a'|| (part1_var_count_-2);
                  part1_value_array_(part1_index_-2):= technical_class_;

                  part1_name_array_(part1_index_-1) := 'a'|| (part1_var_count_-1);
                  part1_value_array_(part1_index_-1):= attribute2_;

                  part1_name_array_(part1_index_) := 'a'|| part1_var_count_;
                  part1_value_array_(part1_index_):= text_current_;

                  part1_ := part1_||' AND NOT t1.technical_spec_no IN (
                             SELECT DISTINCT t3.technical_spec_no
                             FROM   technical_object_reference_tab t3, technical_specification_tab t4
                             WHERE  t3.technical_spec_no = t4.technical_spec_no (+)
                             AND t4.technical_class = :' || part1_name_array_(part1_index_-2) || '
                             AND t4.attribute = :' ||part1_name_array_(part1_index_-1) || '
                             AND t4.value_text LIKE :'||part1_name_array_(part1_index_)|| ') ';

                  eval_ := TRUE;
               END IF;
            END IF;
         END IF;
         -- process '='
         IF (NOT eval_) THEN
            pos_ := INSTR(text_current_,'=',1);
            IF (pos_ = 1) THEN
               -- Remove only the preceeding = sign
               text_current_ := SUBSTR(text_current_,2);
            END IF;
            IF (text_current_ IS NULL) THEN
               part1_index_ := part1_index_+2;
               part1_var_count_ := part1_var_count_ +2;

               part1_name_array_(part1_index_-1) := 'a'|| (part1_var_count_-1);
               part1_value_array_(part1_index_-1):= technical_class_;

               part1_name_array_(part1_index_) := 'a'|| part1_var_count_;
               part1_value_array_(part1_index_):= attribute2_;

               part1_ := part1_||' AND NOT t1.technical_spec_no IN (
                          SELECT DISTINCT t3.technical_spec_no
                          FROM   technical_search_result t3, technical_specification_tab t4
                          WHERE  t3.technical_spec_no = t4.technical_spec_no (+)
                          AND t4.technical_class =: ' || part1_name_array_(part1_index_-1) || '
                          AND t4.attribute = :' || part1_name_array_(part1_index_)|| '
                          AND NOT t4.value_text IS NULL) ';
            ELSE
               IF (part2_ IS NULL) THEN
                  part2_ := ' AND (';
               ELSE
                  part2_ := part2_ || ' OR ';
               END IF;
               part2_index_ := part2_index_+2;
               part2_var_count_ := part2_var_count_+2;

               part2_name_array_(part2_index_-1) := 'b'|| (part2_var_count_-1);
               part2_value_array_(part2_index_-1):= attribute2_;

               part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
               part2_value_array_(part2_index_):= text_current_;
               
               part2_ := part2_ || ' (t2.attribute = :' || part2_name_array_(part2_index_-1) ;
               part2_ := part2_||' AND t2.value_text LIKE :'||part2_name_array_(part2_index_)|| ') ';
            END IF;
            eval_ := TRUE;
         END IF;
      END LOOP;
      IF (part2_ IS NOT NULL) THEN
         part2_ := part2_ || ') ';
      END IF;
      stmt2_ := part1_ || part2_;
      RETURN stmt2_;
   END Get_Where_Expression___;

   PROCEDURE Copy_Part_Array___ IS
      obj_count_ NUMBER:= 0;
      index2_    NUMBER:=0 ;
   BEGIN
      obj_count_ := part1_value_array_.count;
      index2_ := value_array_.count;
      FOR i_ IN 1..obj_count_ LOOP
        index2_ := index2_  +1;
        value_name_array_(index2_) := part1_name_array_(i_);
        value_array_(index2_) := part1_value_array_(i_);
      END LOOP;
      obj_count_ := part2_value_array_.count;
      FOR i_ IN 1..obj_count_ LOOP
        index2_ := index2_  +1;
        value_name_array_(index2_) := part2_name_array_(i_);
        value_array_(index2_) := part2_value_array_(i_);
      END LOOP;
   END Copy_Part_Array___;

BEGIN
   value_name_array_.DELETE;
   value_array_.DELETE;
   stmt_ := NULL;
   OPEN get_alphanum_attribute;
   FETCH get_alphanum_attribute INTO attribute_, where_text_;
   WHILE(get_alphanum_attribute%FOUND) LOOP
      IF (stmt_ IS NOT NULL) THEN
         stmt_ := stmt_ || ' INTERSECT ';
      END IF;
      stmt_where_ :=Get_Where_Expression___(attribute_,where_text_);
      index_ := value_array_.count +1;
      value_name_array_(index_) := 'c'||index_;
      value_array_(index_) := technical_class_;
      Copy_Part_Array___;
      stmt_ :=  stmt_ || ' SELECT DISTINCT t1.technical_spec_no
                FROM   technical_object_reference_tab t1, technical_specification_tab t2
                WHERE  t1.technical_spec_no = t2.technical_spec_no (+)
                AND t1.technical_class = :' || value_name_array_(index_) ||  stmt_where_;
      FETCH get_alphanum_attribute INTO attribute_, where_text_;
   END LOOP;
   CLOSE get_alphanum_attribute;

   IF (stmt_ IS NULL) THEN
      value_name_array_(1) := 'c1';
      value_array_(1) := technical_class_;
      stmt_ := ' SELECT DISTINCT t1.technical_spec_no
               FROM   technical_object_reference_tab t1, technical_specification_tab t2
               WHERE  t1.technical_spec_no = t2.technical_spec_no (+)
               AND t1.technical_class = :'||value_name_array_(1) ;
   END IF;
   cursor_name_ := DBMS_SQL.OPEN_CURSOR;
   @ApproveDynamicStatement(2010-03-25,pkullk)
   DBMS_SQL.PARSE(cursor_name_, stmt_, DBMS_SQL.V7);

   index_ := value_array_.count;
   FOR i_ IN 1..index_ LOOP
     dbms_sql.bind_variable( cursor_name_, value_name_array_(i_),  value_array_(i_));
   END LOOP;

   DBMS_SQL.DEFINE_COLUMN( cursor_name_, 1, technical_spec_no_ );
   n_return_:= DBMS_SQL.EXECUTE( cursor_name_ );
   LOOP
      IF DBMS_SQL.FETCH_ROWS( cursor_name_ ) = 0 THEN
         EXIT;
      ELSE
         DBMS_SQL.COLUMN_VALUE( cursor_name_, 1, technical_spec_no_out_);
         Technical_Search_Result_API.New__( info_, objid_, objversion_, attr_, 'PREPARE' );
         Client_SYS.Add_To_Attr( 'TECHNICAL_SEARCH_NO', technical_search_no_, attr_ );
         Client_SYS.Add_To_Attr( 'TECHNICAL_SPEC_NO', technical_spec_no_out_, attr_ );
         Client_SYS.Add_To_Attr( 'SILENT', '0', attr_ );
--   insert into debug (text) values (attr_);
--   commit;
         Technical_Search_Result_API.New__( info_, objid_, objversion_, attr_, 'DO' );
      END IF;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(cursor_name_);
--   insert into debug (text) values (stmt_);
--   commit;
END Create_Query_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New_Search_No
--   Get a new search no from the predefined sequence
@UncheckedAccess
FUNCTION New_Search_No (
   dummy_ IN VARCHAR2 ) RETURN NUMBER
IS
   sequence_no_ NUMBER;
   CURSOR next_no IS
      SELECT technical_search_seq.nextval
      FROM DUAL;
BEGIN
   OPEN next_no;
   FETCH next_no INTO sequence_no_;
   CLOSE next_no;
   RETURN sequence_no_;
END New_Search_No;



