-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalSearchResult
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  9608xx  JoRo   Created
--  960811  JoRo   Modified algorithm in Calculate_Hit_Ratio__
--  970219  frtv   Upgraded.
--  970410  frtv   Added dropdown list + more where statements...
--  970119  JaPa   Procedures Decrypt_Search_No__() and Encrypt_Search_No__()
--                 changed to be implementations and declared in the package body
--  010612  Larelk Bug 22173,Added General_SYS.Init_Method in Calculate_Hit_Ratio__ .
--  030917  Larelk Bug 35733 corrected in PROCEDURE Encrypt_Search_No___. 
--  031016  NaSalk Patched bug 35733. 
--  040227  Raselk Modified to make compliant with Unicode standards.
--  ************************ 2004-1 sp1 merge **********************************
--  040310  SuThlk Bug 38933, Added the hard coded '-' sign to validate negative values in 
--                 the internal function Get_Where_Expression_ declared in Encrypt_Search_No___.
--                 Changed the formula used for best fit search in Calculate_Hit_Ratio__.
--  040325  DHSELK Merged 2004-1 Sp1
--  060725 UtGulk Rewrote Encrypt_Search_No___() using bind variables to make code assert safe (Bug 58228). 
--  100324 PKULLK Updated Encrypt_Search_No___ to make dynamic SQL statement 'assert safe' (Bug 84970).
--  --------------------------Eagle------------------------------------------
--  100422  Ajpelk Merge rose method documentatio
--  --------------------------- APPS 9 --------------------------------------
--  131128  NuKuLK  Hooks: Refactored and splitted code.
--  131203  NuKuLK  PBSA-2924, Check_Update___().
--  140417  Joolse  TEFH-1318 Correct red marked code from Developer Studio, changed reserved word object to object_
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Decrypt_Search_No___ (
   technical_search_no_ IN NUMBER )
IS
   info_   VARCHAR2(2000);
   attr_   VARCHAR2(32000);
   CURSOR get_object IS
      SELECT objid, objversion
      FROM   TECHNICAL_SEARCH_RESULT
      WHERE  technical_search_no = technical_search_no_
      AND    silent = 0;
BEGIN
   FOR object_ IN get_object LOOP
      Modify__(info_, object_.objid, object_.objversion, attr_, 'CHECK');
      Client_SYS.Add_To_Attr( 'HIT_RATIO','', attr_ );
      Client_SYS.Add_To_Attr( 'SILENT','1', attr_ );
      Modify__(info_, object_.objid, object_.objversion, attr_, 'DO');
   END LOOP;
END Decrypt_Search_No___;


PROCEDURE Encrypt_Search_No___ (
   technical_search_no_ IN NUMBER )
IS
   cursor_name_      INTEGER;
   stmt_             VARCHAR2(32000);
   stmt_where_       VARCHAR2(32000);
   attribute_        VARCHAR2(15);
   where_text_       VARCHAR2(2000);
   technical_class_  VARCHAR2(10);
   info_             VARCHAR2(2000);
   attr_             VARCHAR2(32000);
   objversion_       VARCHAR2(26000);
   objid_            VARCHAR2(50);
   n_return_         INTEGER;

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

   CURSOR get_numeric_attribute IS
      SELECT technical_class, attribute, where_text
      FROM   technical_search_criteria
      WHERE  technical_search_no = technical_search_no_
      AND    where_text IS NOT NULL;

   --.check comma and replace it with dot in every operators. 
   -- Used to decode the where statement
   FUNCTION Get_Where_Expression___ (
      technical_class_     IN VARCHAR2,
      attribute_           IN VARCHAR2,
      text_                IN VARCHAR2 ) RETURN VARCHAR2
   IS
      text_copy_     VARCHAR2(2000);
      text_current_  VARCHAR2(2000);
      text_current2_ VARCHAR2(2000);
      stmt2_         VARCHAR2(32000);
      part1_         VARCHAR2(32000);
      part2_         VARCHAR2(32000);
      done_          BOOLEAN;
      eval_          BOOLEAN;
      text_error_    VARCHAR2(2000);
      pos_           NUMBER;
      res_           VARCHAR2(2000);
      res2_          VARCHAR2(2000);
      part1_index_   NUMBER := 0;
      part2_index_   NUMBER := 0;
   BEGIN
      part1_name_array_.DELETE;
      part1_value_array_.DELETE;
      part2_name_array_.DELETE;
      part2_value_array_.DELETE;

      text_copy_ := text_;
      done_ := text_copy_ IS NULL;
      part1_ := NULL;
      part2_ := NULL;
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
         text_error_ := text_current_;
         eval_ := FALSE;
         -- process '!=' and '!' not equal to or null
         IF (NOT eval_) THEN
            pos_ := INSTR(text_current_,'!',1);
            IF (pos_ != 0) THEN
               text_current_ := REPLACE(text_current_,'!=');
               text_current_ := REPLACE(text_current_,'!');
               IF (text_current_ = '.' OR text_current_ = ',') THEN
                  text_current_ := '0';
               END IF;
               res_ := LTRIM(RTRIM(text_current_,' 0123456789'),' 0123456789');
               IF (text_current_ IS NULL) THEN
                  IF (part2_ IS NULL) THEN
                     part2_ := ' AND (';
                  ELSE
                     part2_ := part2_ || ' OR ';
                  END IF;

                  part2_index_ := part2_index_+1;
                  part2_var_count_ := part2_var_count_ +1;

                  part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
                  part2_value_array_(part2_index_):= attribute_;

                  part2_ := part2_ || ' (t2.attribute = :' || part2_name_array_(part2_index_);
                  part2_ := part2_||' AND t2.value_no IS NOT NULL) ';


               ELSIF (text_current_ IS NOT NULL AND (res_ IS NULL OR NVL(res_,'x') = '.' OR NVL(res_,'x') IN (',', '-'))) THEN
                  IF(res_=',') THEN
                     text_current_ := REPLACE(text_current_,',','.');                     
                  END IF;

                  part1_index_ := part1_index_+3;
                  part1_var_count_ := part1_var_count_ +3;

                  part1_name_array_(part1_index_-2) := 'a'|| (part1_var_count_-2);
                  part1_value_array_(part1_index_-2):= technical_search_no_;

                  part1_name_array_(part1_index_-1) := 'a'|| (part1_var_count_-1);
                  part1_value_array_(part1_index_-1):= attribute_;

                  part1_name_array_(part1_index_) := 'a'|| part1_var_count_;
                  part1_value_array_(part1_index_):= text_current_;

                  part1_ := part1_||' AND NOT t1.technical_spec_no IN ('
                                    ||' SELECT DISTINCT t3.technical_spec_no'
                                    ||' FROM   technical_search_result t3, technical_specification_tab t4'
                                    ||' WHERE  t3.technical_spec_no = t4.technical_spec_no'
                                    ||' AND    t3.technical_search_no = :'||part1_name_array_(part1_index_-2)
                                    ||' AND    t4.attribute = :'|| part1_name_array_(part1_index_-1) 
                                    ||' AND    t4.value_no = :'||part1_name_array_(part1_index_)|| ' ) ';
               ELSE
                  Error_SYS.Record_General(lu_name_,
                     'TSRESULTWHERENUM: Invalid entry for number (:P1).',text_error_,NULL,NULL);
               END IF;
               eval_ := TRUE;
            END IF;
         END IF;
         -- process '..' between
         IF (NOT eval_) THEN
            pos_ := INSTR(text_current_,'..',1);
            IF (pos_ != 0) THEN
               text_current2_ := substr(text_current_,pos_+2);
               text_current_  := substr(text_current_,1,pos_-1);
               IF (NVL(text_current_,'x') = '.' OR NVL(text_current_,'x') = ',') THEN
                  text_current_ := '0';
               END IF;
               IF (NVL(text_current2_,'x') = '.' OR NVL(text_current2_,'x') = ',') THEN
                  text_current2_ := '0';
               END IF;
               -- check if number
               res_  := LTRIM(RTRIM(text_current_,' 0123456789'),' 0123456789');
               res2_ := LTRIM(RTRIM(text_current2_,' 0123456789'),' 0123456789');
               IF ((text_current_ IS NOT NULL AND (res_ IS NULL OR NVL(res_,'x') = '.' OR NVL(res_,'x') IN (',', '-'))) OR
                   (text_current2_ IS NOT NULL AND (res2_ IS NULL OR NVL(res2_,'x') = '.' OR NVL(res2_,'x') IN (',', '-')))) THEN
                  IF (part2_ IS NULL) THEN
                     part2_ := ' AND (';
                  ELSE
                     part2_ := part2_ || ' OR ';
                  END IF;

                  part2_index_ := part2_index_+1;
                  part2_var_count_ := part2_var_count_+1;

                  part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
                  part2_value_array_(part2_index_):= attribute_;

                  part2_ := part2_ || ' (t2.attribute = :' || part2_name_array_(part2_index_) ;

                  IF (text_current_ IS NOT NULL AND (res_ IS NULL OR NVL(res_,'x') = '.' OR NVL(res_,'x') IN (',', '-'))) THEN
                     IF(res_=',') THEN
                        text_current_:= REPLACE(text_current_,',','.');                     
                     END IF;

                     part2_index_ := part2_index_+1;
                     part2_var_count_ := part2_var_count_+1;

                     part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
                     part2_value_array_(part2_index_):= text_current_;
                     part2_ := part2_||' AND t2.value_no >=:'||part2_name_array_(part2_index_);
                  END IF;
                  IF (text_current2_ IS NOT NULL AND (res2_ IS NULL OR NVL(res2_,'x') = '.' OR NVL(res2_,'x') IN (',', '-'))) THEN
                     IF(res_=',') THEN
                        text_current2_:= REPLACE(text_current2_,',','.');                     
                     END IF;

                     part2_index_ := part2_index_+1;
                     part2_var_count_ := part2_var_count_+1;

                     part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
                     part2_value_array_(part2_index_):= text_current2_;
                     part2_ := part2_||' AND t2.value_no <=:'||part2_name_array_(part2_index_);
                  END IF;
                  part2_ := part2_||') ';
               ELSE
                  Error_SYS.Record_General(lu_name_,
                     'TSRESULTWHERENUM: Invalid entry for number (:P1).',text_error_,NULL,NULL);
               END IF;
               eval_ := TRUE;
            END IF;
         END IF;
         -- process '<=' less than
         IF (NOT eval_) THEN
            pos_ := INSTR(text_current_,'<=',1);
            IF (pos_ != 0) THEN
               text_current_ := REPLACE(text_current_,'<=');
               -- check if number
               IF (NVL(text_current_,'x') = '.' OR NVL(text_current_,'x') = ','  OR text_current_ IS NULL) THEN
                  text_current_ := '0';
               END IF;
               res_ := LTRIM(RTRIM(text_current_,' 0123456789'),' 0123456789');
               IF (text_current_ IS NOT NULL AND (res_ IS NULL OR NVL(res_,'x') = '.' OR NVL(res_,'x') IN (',', '-'))) THEN
                  IF(res_=',') THEN
                     text_current_:= REPLACE(text_current_,',','.');                     
                  END IF;
                  IF (part2_ IS NULL) THEN
                     part2_ := ' AND (';
                  ELSE
                     part2_ := part2_ || ' OR ';
                  END IF;

                  part2_index_ := part2_index_+2;
                  part2_var_count_ := part2_var_count_+2;

                  part2_name_array_(part2_index_-1) := 'b'|| (part2_var_count_-1);
                  part2_value_array_(part2_index_-1):= attribute_;

                  part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
                  part2_value_array_(part2_index_):= text_current_;

                  part2_ := part2_ || ' (t2.attribute = :' || part2_name_array_(part2_index_-1) ;
                  part2_ := part2_||' AND t2.value_no <= :'|| part2_name_array_(part2_index_)|| ') ';
               ELSE
                  Error_SYS.Record_General(lu_name_,
                     'TSRESULTWHERENUM: Invalid entry for number (:P1).',text_error_,NULL,NULL);
               END IF;
               eval_ := TRUE;
            END IF;
         END IF;
         -- process '<' less than
         IF (NOT eval_) THEN
            pos_ := INSTR(text_current_,'<',1);
            IF (pos_ != 0) THEN
               text_current_ := REPLACE(text_current_,'<');
               -- check if number
               IF (NVL(text_current_,'x') = '.' OR NVL(text_current_,'x') = ',' OR text_current_ IS NULL) THEN
                  text_current_ := '0';
               END IF;
               res_ := LTRIM(RTRIM(text_current_,' 0123456789'),' 0123456789');
               IF (text_current_ IS NOT NULL AND (res_ IS NULL OR NVL(res_,'x') = '.' OR NVL(res_,'x') IN (',', '-'))) THEN
                  IF(res_=',') THEN
                     text_current_:= REPLACE(text_current_,',','.');                     
                  END IF;
                  IF (part2_ IS NULL) THEN
                     part2_ := ' AND (';
                  ELSE
                     part2_ := part2_ || ' OR ';
                  END IF;

                  part2_index_ := part2_index_+2;
                  part2_var_count_ := part2_var_count_+2;

                  part2_name_array_(part2_index_-1) := 'b'|| (part2_var_count_-1);
                  part2_value_array_(part2_index_-1):= attribute_;

                  part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
                  part2_value_array_(part2_index_):= text_current_;

                  part2_ := part2_ || ' (t2.attribute = :' || part2_name_array_(part2_index_-1) ;
                  part2_ := part2_||' AND t2.value_no < :'|| part2_name_array_(part2_index_)|| ') ';
               ELSE
                  Error_SYS.Record_General(lu_name_,
                     'TSRESULTWHERENUM: Invalid entry for number (:P1).',text_error_,NULL,NULL);
               END IF;
               eval_ := TRUE;
            END IF;
         END IF;
         -- process '>=' less than
         IF (NOT eval_) THEN
            pos_ := INSTR(text_current_,'>=',1);
            IF (pos_ != 0) THEN
               text_current_ := REPLACE(text_current_,'>=');
               -- check if number
               IF (NVL(text_current_,'x') = '.' OR NVL(text_current_,'x') = ',' OR text_current_ IS NULL) THEN
                  text_current_ := '0';
               END IF;
               res_ := LTRIM(RTRIM(text_current_,' 0123456789'),' 0123456789');
               IF (text_current_ IS NOT NULL AND (res_ IS NULL OR NVL(res_,'x') = '.' OR NVL(res_,'x') IN (',', '-'))) THEN
                  IF(res_=',') THEN
                     text_current_:= REPLACE(text_current_,',','.');                     
                  END IF;
                  IF (part2_ IS NULL) THEN
                     part2_ := ' AND (';
                  ELSE
                     part2_ := part2_ || ' OR ';
                  END IF;

                  part2_index_ := part2_index_+2;
                  part2_var_count_ := part2_var_count_+2;

                  part2_name_array_(part2_index_-1) := 'b'|| (part2_var_count_-1);
                  part2_value_array_(part2_index_-1):= attribute_;

                  part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
                  part2_value_array_(part2_index_):= text_current_;

                  part2_ := part2_ || ' (t2.attribute = :' || part2_name_array_(part2_index_-1) ;
                  part2_ := part2_||' AND t2.value_no >= :'||part2_name_array_(part2_index_)|| ') ';
               ELSE
                  Error_SYS.Record_General(lu_name_,
                     'TSRESULTWHERENUM: Invalid entry for number (:P1).',text_error_,NULL,NULL);
               END IF;
               eval_ := TRUE;
           END IF;
         END IF;
         -- process '>' greater than
         IF (NOT eval_) THEN
            pos_ := INSTR(text_current_,'>',1);
            IF (pos_ != 0) THEN
               text_current_ := REPLACE(text_current_,'>');
               -- check if number
               IF (NVL(text_current_,'x') = '.' OR NVL(text_current_,'x') = ',' OR text_current_ IS NULL) THEN
                  text_current_ := '0';
               END IF;
               res_ := LTRIM(RTRIM(text_current_,' 0123456789'),' 0123456789');
               IF (text_current_ IS NOT NULL AND (res_ IS NULL OR NVL(res_,'x') = '.' OR NVL(res_,'x') IN (',', '-'))) THEN
                  IF(res_=',') THEN
                        text_current_:= REPLACE(text_current_,',','.');                     
                  END IF;
                  IF (part2_ IS NULL) THEN
                     part2_ := ' AND (';
                  ELSE
                     part2_ := part2_ || ' OR ';
                  END IF;

                  part2_index_ := part2_index_+2;
                  part2_var_count_ := part2_var_count_+2;

                  part2_name_array_(part2_index_-1) := 'b'|| (part2_var_count_-1);
                  part2_value_array_(part2_index_-1):= attribute_;

                  part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
                  part2_value_array_(part2_index_):= text_current_;

                  part2_ := part2_ || ' (t2.attribute = :' || part2_name_array_(part2_index_-1) ;
                  part2_ := part2_||' AND t2.value_no > :'||part2_name_array_(part2_index_)|| ') ';
               ELSE
                  Error_SYS.Record_General(lu_name_,
                     'TSRESULTWHERENUM: Invalid entry for number (:P1).',text_error_,NULL,NULL);
               END IF;
               eval_ := TRUE;
            END IF;
         END IF;
         -- process '='
         IF (NOT eval_) THEN
            pos_ := INSTR(text_current_,'=',1);
            IF (pos_ != 0) THEN
               text_current_ := REPLACE(text_current_,'=');
            END IF;
            IF (text_current_ IS NULL) THEN
               IF (part2_ IS NULL) THEN
                  part2_ := ' AND ( ';
               ELSE
                  part2_ := part2_ || ' OR ';
               END IF;

               part2_index_ := part2_index_+2;
               part2_var_count_ := part2_var_count_+2;

               part2_name_array_(part2_index_-1) := 'b'|| (part2_var_count_-1);
               part2_value_array_(part2_index_-1):= technical_search_no_;

               part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
               part2_value_array_(part2_index_):= attribute_;

               part2_ := part2_||'NOT t1.technical_spec_no IN (
                   SELECT DISTINCT t3.technical_spec_no
                   FROM   technical_search_result t3, technical_specification_tab t4
                   WHERE  t3.technical_spec_no = t4.technical_spec_no
                          AND t3.technical_search_no = :' || part2_name_array_(part2_index_-1) || '
                          AND t4.attribute = :' || part2_name_array_(part2_index_) || '
                          AND t4.value_no IS NOT NULL) ';
            ELSE
               IF (NVL(text_current_,'x') = '.' OR NVL(text_current_,'x') = ',' ) THEN
                  text_current_ := '0';
               END IF;
               res_ := LTRIM(RTRIM(text_current_,' 0123456789'),' 0123456789');
               IF (text_current_ IS NOT NULL AND (res_ IS NULL OR NVL(res_,'x') = '.' OR NVL(res_,'x') IN (',', '-'))) THEN
                  IF(res_=',') THEN
                     text_current_:= REPLACE(text_current_,',','.');                     
                  END IF;
                  IF (part2_ IS NULL) THEN
                     part2_ := ' AND ( ';
                  ELSE
                     part2_ := part2_ || ' OR ';
                  END IF;

                  part2_index_ := part2_index_+2;
                  part2_var_count_ := part2_var_count_+2;

                  part2_name_array_(part2_index_-1) := 'b'|| (part2_var_count_-1);
                  part2_value_array_(part2_index_-1):= attribute_;

                  part2_name_array_(part2_index_) := 'b'|| part2_var_count_;
                  part2_value_array_(part2_index_):= text_current_;

                  part2_ := part2_ || ' (t2.attribute = :' || part2_name_array_(part2_index_-1) ;
                  part2_ := part2_||' AND t2.value_no = :'||part2_name_array_(part2_index_)|| ') ';
               ELSE
                  Error_SYS.Record_General(lu_name_,
                     'TSRESULTWHERENUM: Invalid entry for number (:P1).',text_error_,NULL,NULL);
               END IF;
            END IF;
            eval_ := TRUE;
         END IF;
      END LOOP;
      IF (part2_ IS NOT NULL) THEN
         part2_ := part2_ || ' ) ';
      END IF;
      stmt2_ := part1_ || part2_;
      RETURN stmt2_;
   END Get_Where_Expression___;

   PROCEDURE Copy_Part_Array___ IS
      obj_count_ NUMBER:= 0;
      index2_     NUMBER:=0 ;
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
   OPEN get_numeric_attribute;
   FETCH get_numeric_attribute INTO technical_class_, attribute_, where_text_;
   WHILE(get_numeric_attribute%FOUND) LOOP
      stmt_where_ :=Get_Where_Expression___(technical_class_,attribute_,where_text_);
      IF (stmt_ IS NOT NULL) THEN
         stmt_ := stmt_ || ' INTERSECT ';
      END IF;
      index_ := value_array_.count +1;
      value_name_array_(index_) := 'c'||index_;
      value_array_(index_) := technical_search_no_;
      Copy_Part_Array___;
      stmt_ := stmt_ ||' SELECT DISTINCT t1.objid, t1.objversion'
                     ||' FROM   technical_search_result t1, technical_specification_tab t2'
                     ||' WHERE  t1.technical_spec_no = t2.technical_spec_no (+)'
                     ||' AND    t1.technical_search_no = :' || value_name_array_(index_) ||stmt_where_;
      FETCH get_numeric_attribute INTO technical_class_, attribute_, where_text_;
   END LOOP;
   CLOSE get_numeric_attribute;

   IF (stmt_ IS NULL) THEN
      value_name_array_(1) := 'c1';
      value_array_(1) := technical_search_no_;
      stmt_ := 'SELECT DISTINCT t1.objid, t1.objversion'
            ||' FROM   technical_search_result t1'
            ||' WHERE  t1.technical_search_no = :' || value_name_array_(1) ;
   END IF;

   cursor_name_ := DBMS_SQL.OPEN_CURSOR;
   @ApproveDynamicStatement(2010-03-25,pkullk)
   DBMS_SQL.PARSE(cursor_name_, stmt_, DBMS_SQL.V7);
   index_ := value_array_.count;
   FOR i_ IN 1..index_ LOOP
     dbms_sql.bind_variable( cursor_name_, value_name_array_(i_),  value_array_(i_));
   END LOOP;

   -- Now initialize the dynamic select statement
   DBMS_SQL.DEFINE_COLUMN( cursor_name_, 1, objid_, 500);
   DBMS_SQL.DEFINE_COLUMN( cursor_name_, 2, objversion_, 26000);
   n_return_:= DBMS_SQL.EXECUTE( cursor_name_ );
   LOOP
      IF DBMS_SQL.FETCH_ROWS( cursor_name_ ) = 0 THEN
         EXIT;
      ELSE
         DBMS_SQL.COLUMN_VALUE( cursor_name_, 1, objid_);
         DBMS_SQL.COLUMN_VALUE( cursor_name_, 2, objversion_);
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr( 'SILENT','0', attr_ );
         Technical_Search_Result_API.Modify__( info_, objid_, objversion_, attr_, 'DO' );
      END IF;
   END LOOP;
   DBMS_SQL.CLOSE_CURSOR(cursor_name_);
END Encrypt_Search_No___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     technical_search_result_tab%ROWTYPE,
   newrec_ IN OUT technical_search_result_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'TECHNICAL_SPEC_NO', newrec_.technical_spec_no);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Delete_Result__
--   Delete a search result given the TechnicalSearcNo identifying the
--   specific instance
PROCEDURE Delete_Result__ (
   technical_search_no_ IN NUMBER )
IS
   info_       VARCHAR2(2000);

   CURSOR get_objid IS
      SELECT objid, objversion
      FROM TECHNICAL_SEARCH_RESULT
      WHERE ABS(technical_search_no) = technical_search_no_;
BEGIN
   FOR item IN get_objid LOOP
      Remove__(info_, item.objid, item.objversion, 'DO');
   END LOOP;
END Delete_Result__;


-- Calculate_Hit_Ratio__
--   Calculate hit ratio for a given technical_spec_no
--   and technical_search_no and update TECHNICAL_SEARCH_RESULT
PROCEDURE Calculate_Hit_Ratio__ (
   technical_search_no_ IN NUMBER )
IS
   hit_ratio_      NUMBER;
   hit_ratio_temp_ NUMBER;
   numerator_      NUMBER;
   denominator_    NUMBER;
   value_count_    NUMBER;
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   CURSOR get_values (technical_spec_no_ IN NUMBER) IS
      SELECT NVL(s.value_no, 0) spec_value, c.value_no criteria_value
      FROM   technical_specification_tab s, technical_search_criteria_tab c
      WHERE  s.technical_class = c.technical_class
      AND    s.attribute       = c.attribute
      AND    s.technical_spec_no = technical_spec_no_
      AND    c.technical_search_no = technical_search_no_
      AND    c.search_type = '2'
      AND    c.value_no IS NOT NULL;
   CURSOR get_object IS
      SELECT objid, objversion, technical_spec_no
      FROM   TECHNICAL_SEARCH_RESULT
      WHERE  technical_search_no = technical_search_no_
         AND silent = 0;
   CURSOR number_of_values IS
      SELECT COUNT(*)
      FROM   technical_search_criteria_tab
      WHERE  technical_search_no = technical_search_no_
      AND    search_type = '2'
      AND    value_no IS NOT NULL;
   -- search_type = '2' means only numeric values
BEGIN
  

   Decrypt_Search_No___ (technical_search_no_);

   Encrypt_Search_No___ (technical_search_no_);

   OPEN number_of_values;
   FETCH number_of_values INTO value_count_;
   CLOSE number_of_values;
   FOR object_ IN get_object LOOP
      hit_ratio_ := 0;
      FOR value IN get_values( object_.technical_spec_no ) LOOP
         hit_ratio_temp_ := 0;
         IF (value.spec_value = 0) AND (value.criteria_value = 0) THEN
            hit_ratio_temp_ := 1;
         ELSE
            numerator_      := ABS(value.criteria_value - value.spec_value);
            denominator_    := ABS(value.criteria_value) + ABS(value.spec_value);
            hit_ratio_temp_ := 1 - (numerator_/denominator_);
         END IF;
         hit_ratio_ := hit_ratio_ + hit_ratio_temp_;
      END LOOP;
      IF value_count_ = 0 THEN
         hit_ratio_ := 1;
      ELSE
         hit_ratio_ := (hit_ratio_ / value_count_);
      END IF;
      Modify__(info_, object_.objid, object_.objversion, attr_, 'CHECK');
      Client_SYS.Add_To_Attr( 'HIT_RATIO', hit_ratio_, attr_ );
      Modify__(info_, object_.objid, object_.objversion, attr_, 'DO');
   END LOOP;

END Calculate_Hit_Ratio__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Get_Instance_
--   Returns the key_value for a specific technical_spec_no
@UncheckedAccess
FUNCTION Get_Instance_ (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Technical_Object_Reference_API.Get_Key_Value(technical_spec_no_);
END Get_Instance_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Instance_Description
--   Gets the description of an instance (here: the Object with technical attributes)
@UncheckedAccess
FUNCTION Get_Instance_Description (
   technical_search_no_ IN NUMBER,
   technical_spec_no_   IN NUMBER,
   lu_name_             IN VARCHAR2,
   key_value_           IN VARCHAR2,
   view_name_           IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   -- should accept both key_value_ and key_ref_
   RETURN NULL;
END Get_Instance_Description;


-- Selection_Count
--   Return count for a given technical_search_no
@UncheckedAccess
FUNCTION Selection_Count (
   technical_search_no_ IN NUMBER ) RETURN NUMBER
IS
   no_of_records_ NUMBER;
   CURSOR get_count IS
   SELECT COUNT(*)
   FROM TECHNICAL_SEARCH_RESULT
   WHERE technical_search_no = technical_search_no_
   AND silent = 0;
BEGIN
   OPEN get_count;
   FETCH get_count INTO no_of_records_;
   CLOSE get_count;
   RETURN no_of_records_;
END Selection_Count;



