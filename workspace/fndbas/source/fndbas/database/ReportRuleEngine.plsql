-----------------------------------------------------------------------------
--
--  Logical unit: ReportRuleEngine
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140211  ASIWLK  Condition evaluation logic translated to PLSQL.
--  020414  MADILK  Added Distribution users and groups list
--  290715  MADILK  Added #variable support for SetArchiveProperty
--  201115  SAWELK  Fix problem in evaluating #variables in SetArchiveProperty
--  060217  MADILK  TEREPORT-2579 - RRE : Issue with the Patch 135808 Merge to Strike
--  230620  MABALK  DUXZREP-301 - G2133890-A - 100: Inconsistency in sending an email using a report rule when parameters contain square brackets
--  210616  NALTLK  OR21R2-222 - "set property" report rule not working properly
--  190821  MABALK  RRE Set Default Property is not working on Aurena
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
FUNCTION Evaluate_Conditions(
   rule_id_ IN NUMBER,
   result_key_ IN NUMBER,
   formatter_properties_ IN VARCHAR2 ) RETURN VARCHAR2
IS
    result_ BOOLEAN;
BEGIN
   Evaluate_Conditions___(rule_id_,result_key_,formatter_properties_,result_);
   Log_Condition___(NULL,rule_id_,result_key_,FALSE, result_);
   IF result_ THEN
      RETURN 'TRUE';
   END IF;
      RETURN 'FALSE';
EXCEPTION 
   WHEN OTHERS THEN
      Log_Condition___(SQLCODE,rule_id_,result_key_,FALSE, FALSE);
END Evaluate_Conditions;

FUNCTION Evaluate_Expression(
   expression_in_ IN VARCHAR2,
   result_key_ IN NUMBER,
   formatter_properties_ VARCHAR2,
   rule_id_ NUMBER ) RETURN VARCHAR2
IS
BEGIN
      RETURN Evaluate_Expression___(expression_in_,result_key_,formatter_properties_,rule_id_);
EXCEPTION 
 WHEN OTHERS THEN
  Log_Evaluate_Expression___(SQLCODE,expression_in_,result_key_,formatter_properties_,rule_id_);
END Evaluate_Expression;


-----------------Execute report rules for print dialog-------------------------
PROCEDURE ExecuteRulesPrintDialog(result_key_ IN NUMBER ,
                                  report_format_rec_  IN OUT REPORT_FORMAT_TAB%ROWTYPE,
                                  field_info_ IN OUT VARCHAR2)
IS
  report_id_ ARCHIVE.report_id%TYPE;
  rule_id_ report_rule_definition.rule_id%TYPE;
  action_type_ REPORT_RULE_ACTION.type%TYPE;
  action_property_list_ REPORT_RULE_ACTION.property_list%TYPE;
  current_conditon_evaluated_ BOOLEAN; -- for tracking the result for multiple qualifying actions in the same rule
  current_conditon_result_ BOOLEAN;
  action_list_ VARCHAR2(32000);
  set_property_fields_ VARCHAR2(2000);
 
  --Print_dialog_attr_ VARCHAR2(32000);
  rre_rec_  REPORT_FORMAT_TAB%ROWTYPE;
    CURSOR fetchActions_cur (rule_id_ REPORT_RULE_DEFINITION.rule_id%TYPE)
      IS
        select RRA.type,RRA.property_list 
        from REPORT_RULE_ACTION RRA
        where RRA.enabled_db = 'TRUE'  AND RRA.rule_id = rule_id_
        order by RRA.ordinal ;
    CURSOR fetchRules_cur (report_id_ ARCHIVE.report_id%TYPE) 
      IS
        select RRD.rule_id
        from REPORT_RULE_DEFINITION RRD
        where (RRD.enabled_db = 'TRUE')AND 
        (RRD.report_id IS NULL OR RRD.report_id = report_id_)
        order by RRD.priority DESC,
                 RRD.rule_id;
          
BEGIN
   --1.get ReportID
   report_id_ := archive_api.Get_Report_Id(result_key_);
   rre_rec_ := report_format_rec_;
   set_property_fields_ := field_info_;
    OPEN  fetchRules_cur(report_id_);
      LOOP
       FETCH fetchRules_cur INTO  rule_id_;
       EXIT WHEN fetchRules_cur%NOTFOUND;
        current_conditon_evaluated_ :=FALSE;
        current_conditon_result_ :=FALSE;
        action_list_:=NULL;
       --3.check for rules with DB executable actions and execute.
       OPEN  fetchActions_cur(rule_id_);
         LOOP
            FETCH fetchActions_cur INTO action_type_,action_property_list_;
            EXIT WHEN fetchActions_cur%NOTFOUND;
            
            CASE (action_type_) 
            WHEN 'PRESELECT_PROPERTY' THEN
                 
                  IF NOT current_conditon_evaluated_ THEN
                     Evaluate_Conditions___(rule_id_,result_key_,Get_Current_Context___(result_key_),current_conditon_result_);
                     current_conditon_evaluated_ :=TRUE;
                  END IF;
                  
                  IF current_conditon_result_ THEN
                    --Action_SetArchiveProperty___(result_key_,action_property_list_,rule_id_);
                    --fire action preselectpropert
                    Action_PreSelectProperty___(action_property_list_, rre_rec_);
                    action_list_:=action_list_||'|PRESELECT_PROPERTY|'; 
                  END IF;
                       
            WHEN 'SET_PROPERTY' THEN -- ref
               IF NOT current_conditon_evaluated_ THEN
                     Evaluate_Conditions___(rule_id_,result_key_,Get_Current_Context___(result_key_),current_conditon_result_);
                     current_conditon_evaluated_ :=TRUE;
                  END IF;
                  
                  IF current_conditon_result_ THEN
                     Action_SetProperty___(action_property_list_, rre_rec_, set_property_fields_);
                     action_list_:=action_list_||'|SET_PROPERTY|'; -- ref
                  END IF;
            WHEN 'SET_DEFAULT' THEN 
                 
                  IF NOT current_conditon_evaluated_ THEN
                     Evaluate_Conditions___(rule_id_,result_key_,Get_Current_Context___(result_key_),current_conditon_result_);
                     current_conditon_evaluated_ :=TRUE;
                  END IF;
                  
                  IF current_conditon_result_ THEN
                      Action_SetDefault___(action_property_list_, rre_rec_);
                     action_list_:= action_list_||'|SET_DEFAULT|'; -- ref
                  END IF;
                     
            ELSE NULL;
                     
          END CASE; 
       END LOOP;
        
        
        CLOSE fetchActions_cur;
        report_format_rec_ :=  rre_rec_;
        Log_executeRules___(NULL,rule_id_,result_key_,action_list_);
    END LOOP; 
    
      field_info_ :=  set_property_fields_ ;
    CLOSE fetchRules_cur;
    
--    RETURN report_format_rec_;
END ExecuteRulesPrintDialog;
-------------------------------End execute rules for print dialog  end --------------------------

 PROCEDURE ExecuteRules(result_key_ IN NUMBER)
 IS
  report_id_ ARCHIVE.report_id%TYPE;
  rule_id_ report_rule_definition.rule_id%TYPE;
  action_type_ REPORT_RULE_ACTION.type%TYPE;
  action_property_list_ REPORT_RULE_ACTION.property_list%TYPE;
  
  current_conditon_evaluated_ BOOLEAN; -- for tracking the result for multiple qualifying actions in the same rule
  current_conditon_result_ BOOLEAN;
  action_list_ VARCHAR2(32000);
  
  CURSOR fetchRules_cur (report_id_ ARCHIVE.report_id%TYPE) 
      IS
        select RRD.rule_id
        from REPORT_RULE_DEFINITION RRD
        where (RRD.enabled_db = 'TRUE')AND 
        (RRD.report_id IS NULL OR RRD.report_id = report_id_)
        order by RRD.priority DESC;
   
   CURSOR fetchActions_cur (rule_id_ REPORT_RULE_DEFINITION.rule_id%TYPE)
      IS
        select RRA.type,RRA.property_list 
        from REPORT_RULE_ACTION RRA
        where RRA.enabled_db = 'TRUE'  AND RRA.rule_id = rule_id_
        order by RRA.ordinal ;
          
  
  
 BEGIN 
   --1.get ReportID
   report_id_ := archive_api.Get_Report_Id(result_key_);
   
   
   --2.Fetch Rules.
   OPEN  fetchRules_cur(report_id_);
      LOOP
       FETCH fetchRules_cur INTO  rule_id_;
       EXIT WHEN fetchRules_cur%NOTFOUND;
        current_conditon_evaluated_ :=FALSE;
        current_conditon_result_ :=FALSE;
        action_list_:=NULL;
       --3.check for rules with DB executable actions and execute.
       OPEN  fetchActions_cur(rule_id_);
         LOOP
            FETCH fetchActions_cur INTO action_type_,action_property_list_;
            EXIT WHEN fetchActions_cur%NOTFOUND;
            
            CASE (action_type_) 
            WHEN 'SET_ARCHIVE_PROPERTY' THEN
                 
                  IF NOT current_conditon_evaluated_ THEN
                     Evaluate_Conditions___(rule_id_,result_key_,Get_Current_Context___(result_key_),current_conditon_result_);
                     current_conditon_evaluated_ :=TRUE;
                  END IF;
                  
                  IF current_conditon_result_ THEN
                    Action_SetArchiveProperty___(result_key_,action_property_list_,rule_id_);
                    action_list_:=action_list_||'|SET_ARCHIVE_PROPERTY|'; 
                  END IF;
                       
            WHEN 'NEXT_PRE_FORMATTER_ACTION' THEN -- ref
               IF NOT current_conditon_evaluated_ THEN
                     Evaluate_Conditions___(rule_id_,result_key_,Get_Current_Context___(result_key_),current_conditon_result_);
                     current_conditon_evaluated_ :=TRUE;
                  END IF;
                  
                  IF current_conditon_result_ THEN
                     --fire the action.
                     action_list_:=action_list_||'|NEXT_PRE_FORMATTER_ACTION|'; -- ref
                  END IF;
            ELSE NULL;   
          END CASE; 
        END LOOP;
        CLOSE fetchActions_cur;
        Log_executeRules___(NULL,rule_id_,result_key_,action_list_);
    END LOOP; 
    CLOSE fetchRules_cur;
EXCEPTION 
   WHEN OTHERS THEN
      Log_executeRules___(SQLCODE,rule_id_,result_key_,action_list_);
END ExecuteRules; 
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Evaluate_Conditions___(
   rule_id_ IN NUMBER,
   result_key_ IN NUMBER,
   formatter_properties_ VARCHAR2 ,
   result_ OUT BOOLEAN) 
IS
   
   CURSOR get_conditions_cur (rule_id_in_ IN NUMBER) 
   IS
     select RC.*
     from REPORT_RULE_CONDITION RC
     where RC.rule_id = rule_id_in_ 
     order by RC.ordinal;
   

    condition_counter_   NUMBER;
    logic_string_buffer_ VARCHAR2(32000);
   
    rec_condition_   REPORT_RULE_CONDITION%ROWTYPE;  
    
BEGIN
   OPEN  get_conditions_cur(rule_id_);
   condition_counter_:=0;
   LOOP
    FETCH get_conditions_cur INTO  rec_condition_;
    EXIT WHEN get_conditions_cur%NOTFOUND;
    condition_counter_:=condition_counter_+1;
         
    -- consider logical ops among the conditions     
      IF condition_counter_ > 1 THEN
         IF rec_condition_.logical_op IS NOT NULL AND rec_condition_.logical_op = 'OR' THEN
            logic_string_buffer_ := logic_string_buffer_ || '|';
         ELSE 
            logic_string_buffer_ := logic_string_buffer_ || '&';
         END IF;
      END IF;
      
     -- start parent 
      IF rec_condition_.start_parent_db IS NOT NULL AND rec_condition_.start_parent_db = 'TRUE' THEN
            logic_string_buffer_ := logic_string_buffer_ || '(';
      END IF;     
   
     --Evaluate the condition and add the results
      IF (Evaluate_Condition___(rec_condition_,result_key_,formatter_properties_,rule_id_)) THEN   
            logic_string_buffer_ := logic_string_buffer_ || '1';
      ELSE
            logic_string_buffer_ := logic_string_buffer_ || '0';
      END IF;
   
     -- end parent
     IF rec_condition_.end_parent_db IS NOT NULL AND rec_condition_.end_parent_db = 'TRUE' THEN
            logic_string_buffer_ := logic_string_buffer_ || ')';
     END IF;
  
  END LOOP;
  CLOSE  get_conditions_cur;
     
  IF(logic_string_buffer_ IS NULL ) THEN
   result_ := TRUE;
  ELSE
   result_ := Evaluate_MergedCondition___(logic_string_buffer_);
  END IF;
    
END Evaluate_Conditions___;


FUNCTION Evaluate_MergedCondition___(
   merged_condition_in_ VARCHAR2) RETURN BOOLEAN
IS
      merged_condition_  VARCHAR2(32000);  
      curr_string_       VARCHAR2(32000);
      curr_mode_         VARCHAR2(1);
      curr_value_        VARCHAR2(1);
      parenthesis_found_ BOOLEAN;
      memory_value_      NUMBER;

      parenthesis_level_         NUMBER;
      max_parenthesis_level_     NUMBER;
      max_parenthesis_open_pos_  NUMBER;
      max_parenthesis_close_pos_ NUMBER;
      latest_open_parenthesis_   NUMBER;
      look_for_max_close_        BOOLEAN;


BEGIN 
/* ASIWLK: Original commnet from Java
  Search string and evaluate innermost operators first
  and make recursive calls for result strings

  FIX 'or' operators need to be handled after 'and',
  simulate by adding parenthesises, ie (0 and 0) or ((1 and 0) or (1 and 1))?*/

 memory_value_ :=0;
 merged_condition_:=merged_condition_in_;
 LOOP
   parenthesis_level_ := 0;
   max_parenthesis_level_ := 0;
   max_parenthesis_open_pos_ := -1;
   max_parenthesis_close_pos_ := -1;
   latest_open_parenthesis_ := -1;
   look_for_max_close_ := FALSE;
   parenthesis_found_ := FALSE;
   
   FOR loop_counter IN 0..LENGTH(merged_condition_)
   LOOP       
         IF SUBSTR(merged_condition_,(loop_counter+1),1) = '(' THEN
            parenthesis_found_ := TRUE;
            parenthesis_level_ := parenthesis_level_+1;
         
            IF (parenthesis_level_ > max_parenthesis_level_) THEN
                  max_parenthesis_open_pos_ := (loop_counter+1);
                  max_parenthesis_level_ := parenthesis_level_;
                  look_for_max_close_ := TRUE;
            END IF;
         
            latest_open_parenthesis_ := loop_counter;
            
         ELSIF SUBSTR(merged_condition_,(loop_counter+1),1) = ')' THEN
            parenthesis_level_ := parenthesis_level_-1;
         
              IF (look_for_max_close_) THEN
                  max_parenthesis_close_pos_ := (loop_counter+1);
                  look_for_max_close_ := FALSE;
               END IF;
         END IF;
    END LOOP;

    IF (parenthesis_found_) THEN
     curr_string_ := SUBSTR(merged_condition_,(max_parenthesis_open_pos_ + 1),(max_parenthesis_close_pos_-(max_parenthesis_open_pos_ + 1)));
    ELSE
     curr_string_ := merged_condition_;
    END IF;

    curr_mode_ := '&';
    curr_value_ := '1';
    memory_value_ := 0;
    
     
     FOR loop_counter_2 IN 0..LENGTH(curr_string_)
     LOOP
       CASE (SUBSTR(curr_string_,(loop_counter_2+1),1)) 
         WHEN '0' THEN
            IF (curr_mode_ = '&') THEN
                curr_value_ := '0';
            END IF;
         WHEN '1' THEN
            IF (curr_mode_ = '|') THEN
                curr_value_ := '1';
            END IF;
         WHEN '&' THEN
            curr_mode_ := '&';
         WHEN '|' THEN
            curr_mode_ := '|';
            memory_value_ := memory_value_ + TO_NUMBER(curr_value_);
         ELSE NULL;   
        END CASE;          
     END LOOP;   
     
     memory_value_ := memory_value_ + TO_NUMBER(curr_value_); 
     
     IF (parenthesis_found_) THEN
        IF (memory_value_ > 0) THEN
         merged_condition_ := SUBSTR(merged_condition_,0,(max_parenthesis_open_pos_-1)) || '1' || SUBSTR(merged_condition_,(max_parenthesis_close_pos_ + 1),(LENGTH(merged_condition_)));
        ELSE
         merged_condition_ := SUBSTR(merged_condition_,0,(max_parenthesis_open_pos_-1)) || '0' || SUBSTR(merged_condition_,(max_parenthesis_close_pos_ + 1),(LENGTH(merged_condition_)));
        END IF;
     END IF;
     
 EXIT  WHEN (NOT parenthesis_found_);
 END LOOP;

 IF (memory_value_ > 0) THEN
    RETURN TRUE;
 ELSE
    RETURN FALSE;
 END IF;

END Evaluate_MergedCondition___;
   
   
   
FUNCTION Evaluate_Condition___ (
   rec_condition_   REPORT_RULE_CONDITION%ROWTYPE,
   result_key_ IN NUMBER,
   formatter_properties_ VARCHAR2,
   rule_id_ NUMBER ) RETURN BOOLEAN
IS
   

    string_value1_    VARCHAR2(32000);
    string_value2_    VARCHAR2(32000);
    condition_result_ BOOLEAN;
    op_               VARCHAR2(32000);
BEGIN

         IF rec_condition_.expr1 IS NOT NULL AND rec_condition_.expr2 IS NOT NULL THEN
            
            --doit
            string_value1_ := Evaluate_Expression___(rec_condition_.expr1,result_key_,formatter_properties_,rule_id_ );  --check and replace xpaths, props and sql
            string_value2_ := Evaluate_Expression___(rec_condition_.expr2,result_key_,formatter_properties_,rule_id_ );  --check and replace xpaths, props and sql
         
         -- ASIWLK:Strings can to all of the  comparisons- NUMBER block is omitted
            -- Check if the resulting values are Numeric values NULL if Numeric
/*            compareStrings :=TRUE;
            IF LENGTH(TRIM(TRANSLATE(stringValue1, ' +-.0123456789',' '))) IS NULL AND LENGTH(TRIM(TRANSLATE(stringValue2, ' +-.0123456789',' '))) IS NULL THEN
               numberValue1 :=to_number(stringValue1);
               numberValue2 :=to_number(stringValue2);
               compareStrings :=FALSE;
            END IF;*/
         
            -- Perform evaluation
            condition_result_:=FALSE;
            op_ := rec_condition_.operator;
            
            
            
            -- ASIWLK:Strings can to all of the  comparisons- NUMBER block is omitted 
            IF TRIM(op_) = '=' THEN
               IF string_value1_ = string_value2_ THEN
                     condition_result_ := TRUE;
               END IF;   
            ELSIF TRIM(op_) = '<>' THEN 
                  IF string_value1_ <> string_value2_ THEN
                     condition_result_ := TRUE;
                  END IF;   
            ELSIF TRIM(op_) = '<' THEN
                  IF string_value1_ < string_value2_ THEN
                     condition_result_ := TRUE;
                  END IF;   
            ELSIF TRIM(op_) = '>' THEN 
               IF string_value1_ > string_value2_ THEN
                     condition_result_ := TRUE;
                  END IF;
            ELSIF TRIM(op_) = '<=' THEN
               IF string_value1_ <= string_value2_ THEN
                     condition_result_ := TRUE;
                  END IF;
            ELSIF TRIM(op_) = '>=' THEN 
               IF string_value1_ >= string_value2_ THEN
                     condition_result_ := TRUE;
               END IF;
            END IF;
         
           RETURN condition_result_; 
         ELSE
           RETURN FALSE; 
         END IF;
      
END Evaluate_Condition___;


FUNCTION Evaluate_Expression___(
   expression_in_ IN VARCHAR2,
   result_key_ IN NUMBER,
   formatter_properties_ VARCHAR2,
   rule_id_ NUMBER) RETURN VARCHAR2
IS
  next_pos_   NUMBER;
  expression_ VARCHAR2(32000);
BEGIN
  expression_:= REPLACE(expression_in_,'[#','[$rEpLaCe$');  -- fix RRE variables since it confuses the CSV check
  expression_:= CONTEXT_SUBSTITUTION_VAR_API.Replace_Variable(expression_); -- evaluate CSV
  expression_:= REPLACE(expression_,'[$rEpLaCe$','[#');  -- fix back
  next_pos_ :=  Next_tag_pos___(expression_);
   WHILE next_pos_ > 0 LOOP
      expression_ := Evaluate_NextTag___(expression_,result_key_,formatter_properties_,rule_id_,next_pos_);
      next_pos_ :=  Next_tag_pos___(expression_);
   END LOOP;
  RETURN expression_; 
END Evaluate_Expression___;

FUNCTION Next_tag_pos___(expression_ VARCHAR2) RETURN NUMBER
IS
   next_pos_   NUMBER;
BEGIN
   next_pos_:=-1;
   
     next_pos_ :=  INSTR(expression_, '[#'); 
     
     IF next_pos_ <= 0 THEN
        next_pos_ :=  INSTR(expression_, '[@');
     END IF;
     
     IF next_pos_ <= 0 THEN
        next_pos_ :=  INSTR(expression_, '[&'); 
     END IF;
     
   RETURN next_pos_;
   
END Next_tag_pos___;
   
FUNCTION Evaluate_NextTag___(
   expression_ VARCHAR2,
   result_key_ NUMBER,
   formatter_properties_ VARCHAR2,
   rule_id_ NUMBER,
   next_pos_ NUMBER DEFAULT 1)RETURN VARCHAR2 
IS
   pos_ NUMBER;
   endpos_ NUMBER;
   tag_ VARCHAR2(32000);
   
BEGIN
   
   pos_ :=  INSTR(expression_, '[', next_pos_);
   
   IF pos_ > 0 THEN
    tag_ := get_TagAt___(pos_,expression_);
    endpos_ := pos_ + LENGTH(tag_);
      IF pos_ < LENGTH(expression_) THEN 
         IF SUBSTR(tag_, 1, 2) = '[#' THEN
           tag_ := Evaluate_Property___(tag_,result_key_,formatter_properties_,rule_id_);
         ELSIF  SUBSTR(tag_, 1, 2) = '[@' THEN
            tag_ := Evaluate_XPath___(tag_,result_key_,formatter_properties_,rule_id_);
         ELSIF  SUBSTR(tag_, 1, 2) = '[&' THEN
           tag_ := Evaluate_SQL___(tag_,result_key_,formatter_properties_,rule_id_) ;
         END IF;
        RETURN SUBSTR(expression_, 1, (pos_-1) ) || tag_ || SUBSTR(expression_,endpos_);
      END IF;
  END IF;
  RETURN  expression_;
END Evaluate_NextTag___;


FUNCTION get_TagAt___(
   start_index_ NUMBER,
   str_ VARCHAR2) RETURN VARCHAR2
IS
     i_   NUMBER;
     lvl_ NUMBER;
     char_count_ NUMBER;
BEGIN
   
   IF SUBSTR(str_,start_index_,1) != '[' THEN
      RETURN NULL;
   END IF;

   i_ := start_index_;
   lvl_ := 0;
   char_count_:= 0;

   WHILE i_ < LENGTH(str_) LOOP
      IF SUBSTR(str_,i_,1)= '['  THEN
         lvl_:=lvl_+1;
      END IF;
      
      IF SUBSTR(str_,i_,1)= ']'  THEN
         lvl_:=lvl_-1;
      END IF;
   
      EXIT WHEN lvl_ = 0;
         
      i_:=i_+1;
      char_count_:=char_count_+1;
   END LOOP;
   
   IF(char_count_ >= 0)THEN
        RETURN SUBSTR(str_,start_index_,char_count_+1);
      ELSE
        RETURN str_;
   END IF;
   
END get_TagAt___;

FUNCTION Get_Current_Context___(result_key_ NUMBER) RETURN VARCHAR2
IS
   property_list_ VARCHAR2(32000);
BEGIN
   Client_Sys.Clear_Attr(property_list_);
   Client_Sys.Add_To_Attr('ReportId',       Archive_Api.Get_Report_Id(result_key_), property_list_);
   Client_Sys.Add_To_Attr('CurrentUser',    Fnd_Session_API.Get_Fnd_User, property_list_);
   Client_Sys.Add_To_Attr('CurrentLanguage',Fnd_Session_API.Get_Language, property_list_);
   Client_Sys.Add_To_Attr('ResultKey',      result_key_, property_list_);
   Client_Sys.Add_To_Attr('ReportTitle',    Archive_Api.Get_Report_Title(result_key_), property_list_);
   RETURN property_list_;
END Get_Current_Context___;
   
FUNCTION Evaluate_Property___(
   property_ VARCHAR2,
   result_key_ NUMBER, 
   formatter_properties_ IN VARCHAR2,
   rule_id_ NUMBER) RETURN VARCHAR2
IS
   property_trim_ VARCHAR2(32000);
   return_ VARCHAR2(32000);
BEGIN
    IF SUBSTR(property_, 1, 2) = '[#' THEN
        property_trim_:= SUBSTR(property_,3,LENGTH(property_));
        property_trim_:= SUBSTR(property_trim_,0,(LENGTH(property_trim_)-1));
    END IF;
    
    property_trim_ := Evaluate_Expression___(property_trim_,result_key_,formatter_properties_,rule_id_);

   BEGIN
       return_:= CLIENT_SYS.Get_Item_Value(property_trim_,formatter_properties_);
   EXCEPTION 
         WHEN OTHERS
             THEN 
               return_ :=property_trim_ ;
               Log_Evaluate_Expression___(SQLCODE,property_,result_key_,formatter_properties_,rule_id_);
   END; 
   
 RETURN return_;

END Evaluate_Property___;
 
FUNCTION Evaluate_SQL___(
   statement_in_ VARCHAR2,
   result_key_ NUMBER,
   formatter_properties_ IN VARCHAR2,
   rule_id_ NUMBER) RETURN VARCHAR2
IS
   printjobuser_    VARCHAR2(100);
   is_impersonated_ BOOLEAN;
   sql_result_      VARCHAR2(32000);
   trim_statement_  VARCHAR2(32000);
   
BEGIN
      IF SUBSTR(statement_in_, 1, 2) = '[&' THEN
           trim_statement_:= SUBSTR(statement_in_,3,LENGTH(statement_in_));
           trim_statement_:= SUBSTR(trim_statement_,0,(LENGTH(trim_statement_)-1));
       END IF;
       
       trim_statement_ := Evaluate_Expression___(trim_statement_,result_key_,formatter_properties_,rule_id_);
       printjobuser_ := CLIENT_SYS.Get_Item_Value('PrintJobOwner',formatter_properties_);
       
       IF printjobuser_ IS NOT NULL AND LENGTH(printjobuser_)>0 THEN
          BEGIN
          Fnd_Session_Api.Impersonate_Fnd_User(printjobuser_);
          is_impersonated_ := TRUE;
          EXCEPTION 
           WHEN OTHERS 
           THEN is_impersonated_ := FALSE; --TODO WRITE TO THE LOG 
          END;
       ELSE
          is_impersonated_ := FALSE;
       END IF;
          
       BEGIN
         IF UPPER(SUBSTR(trim_statement_, 1, 6)) = 'SELECT' THEN
          @ApproveDynamicStatement(2014-10-07,DASVSE)
          EXECUTE IMMEDIATE trim_statement_ INTO sql_result_;
         ELSE
          @ApproveDynamicStatement(2014-10-07,DASVSE)
          EXECUTE IMMEDIATE 'begin :result := ' || trim_statement_ || '; end;'
          USING OUT sql_result_;
         END IF;      
      EXCEPTION 
             WHEN NO_DATA_FOUND THEN
               sql_result_ :='NO_DATA_FOUND';
             WHEN OTHERS
             THEN 
               sql_result_ :=trim_statement_ ;
               Log_Evaluate_Expression___(SQLCODE,statement_in_,result_key_,formatter_properties_,rule_id_);
       END;     
                   
       IF  is_impersonated_ THEN
          Fnd_Session_Api.Reset_Fnd_User;
       END IF;
    
       RETURN sql_result_;
    
END Evaluate_SQL___; 
    
FUNCTION Evaluate_XPath___(
   statement_in_ VARCHAR2,
   result_key_ NUMBER,
   formatter_properties_ IN VARCHAR2,
   rule_id_ NUMBER) RETURN VARCHAR2
IS
   xpath_result_ VARCHAR2(32000);
   xpath_        VARCHAR2(32000);
   
   CURSOR Fetch_Xpath_Value (result_key_ IN NUMBER, xpath_ IN VARCHAR2)
       IS
         SELECT EXTRACTVALUE(VALUE(p), SUBSTR(xpath_, INSTR(xpath_, '/', -1, 1) + 1))
         FROM TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE(Xml_Report_Data_API.Get_Xml_Data(result_key_)), xpath_))) p;
BEGIN
       IF SUBSTR(statement_in_, 1, 2) = '[@' THEN
           xpath_:= SUBSTR(statement_in_,3,LENGTH(statement_in_));
           xpath_:= SUBSTR(xpath_,0,(LENGTH(xpath_)-1));
       END IF;
       
       xpath_ := Evaluate_Expression___(xpath_,result_key_,formatter_properties_,rule_id_);

       BEGIN
          
       OPEN  Fetch_Xpath_Value(result_key_, xpath_);
       FETCH Fetch_Xpath_Value INTO xpath_result_;
       CLOSE Fetch_Xpath_Value;
       
       EXCEPTION 
         WHEN OTHERS
            THEN 
               xpath_result_ :=xpath_;
               Log_Evaluate_Expression___(SQLCODE,statement_in_,result_key_,formatter_properties_,rule_id_);
         END;
      RETURN xpath_result_;
    
      END Evaluate_XPath___;  
      
     -- SetProperty used in Aurena 
     -- This should lock fields
      PROCEDURE Action_SetProperty___( 
         action_property_list_ IN VARCHAR2,
         report_format_rec_    IN OUT REPORT_FORMAT_TAB%ROWTYPE,
         flag_field_           IN OUT VARCHAR2)
      IS
         property_list_ REPORT_RULE_ACTION.property_list%TYPE;
         tmp_attr_ VARCHAR2(3200):= 'name=value';
         tmp_name_ VARCHAR2(1000);
         tmp_value_ VARCHAR2(1000);
         local_language_ VARCHAR2(3):= NULL;
         local_country_ VARCHAR2(3):= NULL;         
      BEGIN
         property_list_ := action_property_list_;
         WHILE(tmp_attr_ IS NOT NULL) LOOP
            Get_First_NVP___(property_list_ ,tmp_name_,tmp_value_,tmp_attr_);
            
            --set a property to lock fields
            flag_field_ := flag_field_||tmp_name_||',';
            CASE (tmp_name_)
                  WHEN 'PrinterId' THEN
                       report_format_rec_.printer_id := tmp_value_;                       
                  WHEN 'LayoutFile' THEN
                      report_format_rec_.layout_name := tmp_value_;
                  WHEN 'LangCode' THEN
                      report_format_rec_.lang_code := SUBSTR(tmp_value_,1,2);
                  WHEN 'Copies' THEN
                      report_format_rec_.copies := to_number(tmp_value_,'9999');
                  WHEN 'Email' THEN
                      report_format_rec_.address := tmp_value_;
                  WHEN 'ToPage' THEN
                      report_format_rec_.to_page := to_number(tmp_value_,'9999');
                  WHEN 'FromPage' THEN
                      report_format_rec_.from_page := to_number(tmp_value_,'9999');
                  WHEN 'LocaleLanguage' THEN
                      local_language_ := trim(tmp_value_);
                  WHEN 'LocaleCountry' THEN
                      local_country_ := trim(tmp_value_);
                       
                  ELSE NULL;
                  
               END CASE;
               property_list_ := tmp_attr_;
                IF local_language_ IS NOT NULL AND local_country_ IS NOT NULL THEN 
                  report_format_rec_.lang_code_rfc3066 := local_language_ ||'-'||local_country_;
                END IF;
                IF report_format_rec_.from_page IS NOT NULL THEN
                report_format_rec_.pages :=report_format_rec_.from_page;
                   IF report_format_rec_.to_page IS NOT NULL THEN
                      report_format_rec_.pages := report_format_rec_.pages||'-'|| report_format_rec_.to_page;
                   ELSE
                      report_format_rec_.pages := report_format_rec_.pages||'-0';
                   END IF;
                END IF;
         END LOOP;
      END Action_SetProperty___;
      
     -- SetDefault Property in aurena 
      PROCEDURE Action_SetDefault___( 
         action_property_list_ IN VARCHAR2,
         report_format_rec_ IN OUT REPORT_FORMAT_TAB%ROWTYPE)
      IS
         property_list_ REPORT_RULE_ACTION.property_list%TYPE;
         tmp_attr_ VARCHAR2(3200):= 'name=value';
         tmp_name_ VARCHAR2(1000);
         tmp_value_ VARCHAR2(1000);
         local_language_ VARCHAR2(3):= NULL;
         local_country_ VARCHAR2(3):= NULL;         
      BEGIN
         property_list_ := action_property_list_;
         WHILE(tmp_attr_ IS NOT NULL) LOOP
            Get_First_NVP___(property_list_ ,tmp_name_,tmp_value_,tmp_attr_);
            
            -- change only if no value exists
            CASE (tmp_name_)
                  WHEN 'PrinterId' THEN
                       report_format_rec_.printer_id := nvl(tmp_value_ , report_format_rec_.printer_id);
                  WHEN 'LayoutFile' THEN
                      report_format_rec_.layout_name := nvl(tmp_value_, report_format_rec_.layout_name);
                  WHEN 'LangCode' THEN
                      report_format_rec_.lang_code := nvl(SUBSTR(tmp_value_,1,2), report_format_rec_.lang_code);
                  WHEN 'Copies' THEN
                      report_format_rec_.copies := nvl(to_number(tmp_value_,'9999'), report_format_rec_.copies);
                  WHEN 'Email' THEN
                      report_format_rec_.address := nvl(tmp_value_, report_format_rec_.address);
                  WHEN 'ToPage' THEN
                      report_format_rec_.to_page := nvl(to_number(tmp_value_,'9999'), report_format_rec_.to_page);
                  WHEN 'FromPage' THEN
                      report_format_rec_.from_page :=nvl(to_number(tmp_value_,'9999'), report_format_rec_.from_page);
                  WHEN 'LocaleLanguage' THEN
                      local_language_ := trim(tmp_value_);
                  WHEN 'LocaleCountry' THEN
                      local_country_ := trim(tmp_value_);                       
                  ELSE NULL;
                  
               END CASE;
               property_list_ := tmp_attr_;
                IF local_language_ IS NOT NULL AND local_country_ IS NOT NULL THEN 
                  report_format_rec_.lang_code_rfc3066 := nvl(local_language_ ||'-'|| local_country_, report_format_rec_.lang_code_rfc3066);
                ELSE
                  report_format_rec_.lang_code_rfc3066 := Language_Code_Api.Get_Lang_Code_Rfc3066(report_format_rec_.lang_code);
                END IF;
                IF report_format_rec_.from_page IS NOT NULL THEN
                report_format_rec_.pages :=report_format_rec_.from_page;
                   IF report_format_rec_.to_page IS NOT NULL THEN
                      report_format_rec_.pages := report_format_rec_.pages||'-'|| report_format_rec_.to_page;
                   ELSE
                      report_format_rec_.pages := report_format_rec_.pages||'-0';
                   END IF;
                END IF;
         END LOOP;
      END Action_SetDefault___;
      
      
     -- preselect property will work for aurena client
      PROCEDURE Action_PreSelectProperty___(
         action_property_list_ IN VARCHAR2,
         report_format_rec_    IN OUT REPORT_FORMAT_TAB%ROWTYPE)
      IS
         property_list_ REPORT_RULE_ACTION.property_list%TYPE;
         
         tmp_name_ VARCHAR2(1000);
         tmp_value_ VARCHAR2(1000);
         tmp_attr_ VARCHAR2(3200):= 'name=value';
         
         local_language_ VARCHAR2(3):= NULL;
         local_country_ VARCHAR2(3):= NULL;         
         
      BEGIN
         property_list_ := action_property_list_;
            WHILE (tmp_attr_ IS NOT NULL) LOOP
               Get_First_NVP___(property_list_,tmp_name_,tmp_value_, tmp_attr_);

               --check if not Set Property has not locked any fields 
               CASE (tmp_name_)
                  WHEN 'PrinterId' THEN
                       report_format_rec_.printer_id := tmp_value_;
                  WHEN 'LayoutFile' THEN
                      report_format_rec_.layout_name := tmp_value_;
                  WHEN 'LangCode' THEN
                      report_format_rec_.lang_code := SUBSTR(tmp_value_,1,2);
                  WHEN 'Copies' THEN
                      report_format_rec_.copies := to_number(tmp_value_,'9999');
                  WHEN 'Email' THEN
                      report_format_rec_.address := tmp_value_;
                  WHEN 'ToPage' THEN
                      report_format_rec_.to_page := to_number(tmp_value_,'9999');
                  WHEN 'FromPage' THEN
                      report_format_rec_.from_page := to_number(tmp_value_,'9999');
                  WHEN 'LocaleLanguage' THEN
                      local_language_ := trim(tmp_value_);
                  WHEN 'LocaleCountry' THEN
                      local_country_ := trim(tmp_value_);
                       
                  ELSE NULL;
                  
               END CASE;
               property_list_ := tmp_attr_;

            END LOOP;
              IF local_language_ IS NOT NULL AND local_country_ IS NOT NULL THEN 
              report_format_rec_.lang_code_rfc3066 := local_language_ ||'-'||local_country_;
              END IF;
                IF report_format_rec_.from_page IS NOT NULL THEN
                report_format_rec_.pages :=report_format_rec_.from_page;
                   IF report_format_rec_.to_page IS NOT NULL THEN
                      report_format_rec_.pages := report_format_rec_.pages||'-'|| report_format_rec_.to_page;
                   ELSE
                      report_format_rec_.pages := report_format_rec_.pages||'-0';
                   END IF;
                END IF;
      END Action_PreSelectProperty___;
      
      PROCEDURE Get_First_NVP___( --get first name value pair
        attr_ IN VARCHAR2 ,
        first_name_ OUT VARCHAR2,
        first_value_ OUT VARCHAR2,
        rest_attr_ OUT VARCHAR2) 
      IS
         attrin_ VARCHAR2(3200);
         nvp_    VARCHAR2(100);
                  
      BEGIN
         attrin_ := attr_;
         IF INSTR(attrin_,'=') > 0 THEN
            
            IF INSTR(attrin_, ';')>0 THEN             
               
               nvp_ := SUBSTR(attrin_,1, (INSTR(attrin_,';')-1));
               first_name_ := SUBSTR(nvp_,1,(INSTR(nvp_,'=')-1));
               first_value_ :=SUBSTR(nvp_,(INSTR(nvp_,'=')+1),(LENGTH(nvp_)-(INSTR(nvp_,'='))));
               IF LENGTH(attrin_) != INSTR(attrin_,';') THEN 
                  rest_attr_ := SUBSTR(attrin_,(INSTR(attrin_,';')+1),(LENGTH(attrin_)-(INSTR(attrin_,';'))));              
               ELSE
                  rest_attr_ :=NULL;
               END IF;
            ELSE
               nvp_ := attr_;
               first_name_ := SUBSTR(nvp_,1,(INSTR(nvp_,'=')-1));
               first_value_ :=SUBSTR(nvp_,(INSTR(nvp_,'=')+1),(LENGTH(nvp_)-(INSTR(nvp_,'=')+1)));
               rest_attr_ := NULL;
               
            END IF;
         
         ELSE
            first_name_ := NULL;
            first_value_ := NULL;            
            rest_attr_ := NULL;
         END IF;
         
         
      END Get_First_NVP___;
       
 
      
PROCEDURE Action_SetArchiveProperty___(
   result_key_ NUMBER,
   action_property_list_ VARCHAR2,
   rule_id_ NUMBER)
IS
     property_list_  REPORT_RULE_ACTION.property_list%TYPE;
     property_ REPORT_RULE_ACTION.property_list%TYPE;
     key_p_  REPORT_RULE_ACTION.property_list%TYPE;
     value_p_ REPORT_RULE_ACTION.property_list%TYPE;
     pos_     number :=0;
     keypos_  number :=0; 

     distibution_list_       VARCHAR2(32000);
     distribute_to_users_    VARCHAR2(32000);
     distribute_to_groups_   VARCHAR2(32000);
     archive_variables_      VARCHAR2(32000);
     archive_variable_       VARCHAR2(32000);
     archive_variable_name_  VARCHAR2(32000);
     archive_variable_value_ VARCHAR2(32000);

     expire_date_     DATE;
     user_name_  archive_distribution_tab.user_name%TYPE;
     field_separator_ VARCHAR2(1) := Client_SYS.field_separator_;
     user_list_       VARCHAR2(32000);
     life_span_       VARCHAR2(100);
     attr_            VARCHAR2(32000);

     archive_info_      VARCHAR2(32000);

     archive_rec_ archive%ROWTYPE;

     CURSOR Fetch_Distributed_users (result_key_p_ IN NUMBER)
         IS
           SELECT AD.user_name 
           FROM ARCHIVE_DISTRIBUTION AD
           WHERE AD.result_key = result_key_p_;

     CURSOR Get_archive_row (result_key_p_ IN NUMBER)
     IS  
        SELECT * 
        FROM ARCHIVE A
        WHERE A.result_key = result_key_p_; 
            
BEGIN              
            
     property_list_ := action_property_list_;
     pos_ := instr(property_list_,';',1,1);
     IF(pos_ = 0 ) THEN
        pos_ := LENGTH(property_list_);
     END IF;

     Client_SYS.Clear_Attr(attr_);

     WHILE ( pos_ != 0) LOOP 
      -- get next 
      property_:=substr(property_list_,1,pos_);
      -- remove chunk from string 
      property_list_ := substr(property_list_,pos_+1,length(property_list_));

      -- check the property
         keypos_ := instr(property_,'=',1,1);
         key_p_:=substr(property_,1,(keypos_-1));
         value_p_:=substr(property_,(keypos_+1),length(property_));

         --if avail clean trailering ';'
         IF instr(value_p_,';',1,1) > 0 THEN
           value_p_:=substr(value_p_,1, ((instr(value_p_,';',1,1))-1) );
         END IF;

         -- Remove %3d encoding
         value_p_ := REPLACE(value_p_ , '%3D' , ';');
         
         -- value_p could be complex;
         value_p_ := Evaluate_Expression___(value_p_,result_key_ ,Get_Current_Context___(result_key_),rule_id_);

         -- save property values  
         IF key_p_ = 'LayoutName' THEN
          Client_SYS.Add_To_Attr('LAYOUT_NAME',value_p_,attr_);
         ELSIF key_p_ = 'LangCode' THEN  
          Client_SYS.Add_To_Attr('LANG_CODE',value_p_,attr_);
         ELSIF key_p_ = 'Notes' THEN
          Client_SYS.Add_To_Attr('NOTES',value_p_,attr_);
         ELSIF key_p_ = 'LifeSpan' THEN 
          life_span_ := value_p_;   
		 ELSIF key_p_ = 'DistributeToUsers' THEN  
		  distribute_to_users_ := value_p_;
		 ELSIF key_p_ = 'DistributeToGroups' THEN  
		  distribute_to_groups_ := value_p_;
         ELSIF key_p_ = 'ArchiveVariables' THEN  
          archive_variables_ := value_p_;
         END IF;

		 -- Set all the destrinution users and groups to one variable
		 IF distribute_to_users_ IS NOT NULL THEN
		  IF distribute_to_groups_ IS NOT NULL THEN
		   distibution_list_ := distribute_to_users_ || ',' || distribute_to_groups_;
		  ELSE
		   distibution_list_ := distribute_to_users_;
		  END IF;
		 ELSE
		  IF distribute_to_groups_ IS NOT NULL THEN
		   distibution_list_ := distribute_to_groups_;
		  END IF;
		 END IF;
       pos_ := instr(property_list_,';',1,1);
       IF(pos_ = 0 ) THEN
          pos_ := LENGTH(property_list_);
       END IF; 
      END LOOP;
   --------------------------------------
   -- Action implementation -------------
   -------------------------------------- 
    BEGIN

    --1.update Archive
     OPEN  Get_archive_row(result_key_);
     FETCH Get_archive_row INTO archive_rec_;
     CLOSE Get_archive_row; 


     /*archive_objid_      :=archive_rec.objid;
     archive_objversion_ :=archive_rec.objversion;*/

     archive_api.Modify__(archive_info_ ,archive_rec_.objid,archive_rec_.objversion,attr_,'DO');
     --TODO Write the archive_info_ to LOG                                     

    --2.update Archive Destribution
     pos_ := 0;
     pos_ := instr(distibution_list_,',',1,1);
     IF(pos_ = 0 ) THEN
        pos_ := LENGTH(distibution_list_) + 1;
     END IF;
     WHILE ( pos_ != 0) LOOP
      user_name_:=substr(distibution_list_,1,(pos_-1));
      distibution_list_ := substr(distibution_list_,pos_+1,length(distibution_list_));

      --build user List

      user_list_ := user_list_ || user_name_ || field_separator_;

     pos_ := instr(distibution_list_,',',1,1);
     IF(pos_ = 0 ) THEN
        pos_ := LENGTH(distibution_list_) + 1;
     END IF;
     END LOOP;

     --add new users.
     IF(LENGTH(user_list_)>0) THEN
      expire_date_ := SYSDATE+Report_Definition_API.Get_Life_Default(archive_api.Get_Report_Id(result_key_));
      archive_distribution_api.New_Entry_Distribution__(result_key_,user_list_,expire_date_);
     END IF;
   --3.update Archive Destribution Life span
     IF(life_span_ IS NOT NULL AND life_span_ > 0)
     THEN
       user_name_ := NULL;
       expire_date_ := SYSDATE+life_span_;
       OPEN  Fetch_Distributed_users(result_key_);
        LOOP 
         FETCH Fetch_Distributed_users INTO user_name_;
         EXIT WHEN Fetch_Distributed_users%NOTFOUND;

         archive_distribution_api.Set_Expire_Date(result_key_,user_name_,expire_date_);

        END LOOP;
       CLOSE Fetch_Distributed_users; 
     END IF;
   --4.Add Archive variables
     IF(archive_variables_ IS NOT NULL ) THEN

       pos_ := 0;
       pos_ := instr(archive_variables_,',',1,1);
       IF(pos_ = 0 ) THEN
          pos_ := LENGTH(archive_variables_);
       END IF;
       WHILE ( pos_ != 0) LOOP
        archive_variable_:=substr(archive_variables_,1,pos_);
        archive_variables_ := substr(archive_variables_,pos_+1,length(archive_variables_));

        --Split the Archive_Variable and find  
        --1.name
        --2.value
        --3.type
        -- and insert them.
        keypos_:=0;

        keypos_ := instr(archive_variable_,':',1,1);
        IF(keypos_ = 0 ) THEN
          keypos_ := LENGTH(archive_variable_)+1;
        END IF;
        archive_variable_name_:=substr(archive_variable_,1,keypos_-1);
        archive_variable_ := substr(archive_variable_,keypos_+1,length(archive_variable_));

        keypos_ := instr(archive_variable_,':',1,1);
        IF(keypos_ = 0 ) THEN
          keypos_ := LENGTH(archive_variable_)+1;
        END IF;
        archive_variable_value_:=substr(archive_variable_,1,keypos_-1);
        archive_variable_ := substr(archive_variable_,keypos_+1,length(archive_variable_));            
        
        IF (REGEXP_COUNT(archive_variable_, 'N', 1, 'i') = 1) THEN
           Archive_Variable_Api.Set_Variable(result_key_,archive_variable_name_,TO_NUMBER(archive_variable_value_));
        ELSIF (REGEXP_COUNT(archive_variable_, 'D', 1, 'i') = 1) THEN
           Archive_Variable_Api.Set_Variable(result_key_,archive_variable_name_,TO_DATE(archive_variable_value_,CLIENT_SYS.date_format_)); 
        ELSE  
           --S varchar.
           Archive_Variable_Api.Set_Variable(result_key_,archive_variable_name_,archive_variable_value_);
        END IF;   

         pos_ := instr(archive_variables_,',',1,1);
         IF(pos_ = 0 ) THEN
            pos_ := LENGTH(archive_variables_);
         END IF;
      END LOOP;
     END IF;

    EXCEPTION
    WHEN OTHERS THEN
          report_rule_log_api.Log('Rule ID='||rule_id_||' ERROR Executing Action_SetArchiveProperty___: ERROR= '||SQLCODE||' result_key='||result_key_|| ' ActionProperty_list:='||action_property_list_,'ERROR',NULL);
   END;
END Action_SetArchiveProperty___;

PROCEDURE Log_executeRules___(
   exception_txt_ VARCHAR2,
   rule_id_ IN NUMBER,
   result_key_ IN NUMBER,
   action_list_ VARCHAR2)
IS 
   message_ VARCHAR2(32000);
   message_type_ VARCHAR2(20);
BEGIN 
  IF (exception_txt_ IS NULL AND Log_Is_Enabled___) THEN 
   message_type_ := 'INFO';
     IF (action_list_ IS NULL) THEN 
       message_:='Rule ID='||rule_id_||' No Archive Actions were executed For Rule rule_id='||rule_id_||' result_key='||result_key_;
     ELSE
       message_:='Rule ID='||rule_id_||' SUCCESS Execute Rule rule_id='||rule_id_||' result_key='||result_key_||' ACTIONS='||action_list_; 
     END IF; 
   report_rule_log_api.Log(message_,message_type_,NULL);
  ELSE
   message_type_ := 'ERROR';
   IF exception_txt_ IS NOT NULL THEN
      message_:='Rule ID='||rule_id_||' ORA'||exception_txt_||'ERROR Executing Rule: Rule ID='||rule_id_||' Result Key='||result_key_;
      report_rule_log_api.Log(message_,message_type_,NULL);
   END IF;
  END IF;
  
END Log_executeRules___;
  
   
PROCEDURE Log_Condition___(
   exception_txt_ VARCHAR2,
   rule_id_ IN NUMBER,
   result_key_ IN NUMBER,
   is_begin_ BOOLEAN, 
   condition_result_ BOOLEAN)
IS
   message_ VARCHAR2(32000);
   message_type_ VARCHAR2(20);
BEGIN
  IF(exception_txt_ IS NULL AND Log_Is_Enabled___) THEN
    message_type_ := 'INFO';
    IF (is_begin_) THEN
       message_:='Rule ID='||rule_id_||' BEGIN Evaluating Conditions for rule_id='||rule_id_||' result_key='||result_key_;
    ELSE
       message_:='Rule ID='||rule_id_||' END Evaluating Conditions for rule_id='||TO_CHAR(rule_id_)||' result_key='||TO_CHAR(result_key_);
       IF(condition_result_) THEN
           message_ := message_||' result=TRUE';  
       ELSE
           message_ := message_||' result=FALSE';
       END IF;
    END IF;
    report_rule_log_api.Log(message_,message_type_,NULL);
  ELSE
     message_type_ := 'ERROR';
     IF exception_txt_ IS NOT NULL THEN
         message_:='Rule ID='||rule_id_||' ORA'||exception_txt_||' ERROR Evaluating Conditions, Result Key='||result_key_;
         report_rule_log_api.Log(message_,message_type_,NULL);
     END IF;
  END IF;
END Log_Condition___;

PROCEDURE Log_Evaluate_Expression___(
   exception_txt_ VARCHAR2,
   expression_in_ IN VARCHAR2,
   result_key_ IN NUMBER,
   formatter_properties_ VARCHAR2,
   rule_id_ NUMBER)
IS 
   message_      VARCHAR2(32000);
   message_type_ VARCHAR2(20);
BEGIN
  IF (exception_txt_ IS NOT NULL) THEN 
     message_type_ := 'ERROR';
     message_:='Rule ID='||rule_id_||' ORA'||exception_txt_||':ERROR Evaluating Expression='''''||expression_in_||''''' result_key='||result_key_||'formatter_properties='||formatter_properties_;
  END IF;  
  report_rule_log_api.Log(message_,message_type_,NULL);
END Log_Evaluate_Expression___;    

FUNCTION Log_Is_Enabled___ RETURN BOOLEAN
  IS
  BEGIN 
    IF ('OFF' = fnd_setting_api.Get_Value('REP_RULE_LOG')) THEN
      RETURN FALSE;
    END IF;  
  RETURN TRUE;    
END Log_Is_Enabled___;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

