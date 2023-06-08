-----------------------------------------------------------------------------
--
--  Logical unit: RoutingRuleCondition
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION  Get_Next_Seq_No__(
   rule_name_ IN VARCHAR2) RETURN NUMBER
IS 
   seq_no_ NUMBER;
   
   CURSOR count_rows IS
      SELECT COUNT(*)
      FROM routing_rule_condition_tab
      WHERE rule_name = rule_name_;
BEGIN
   OPEN count_rows;
   FETCH count_rows INTO seq_no_;
   CLOSE count_rows;
   RETURN seq_no_ + 1;
END Get_Next_Seq_No__;

FUNCTION Rule_Exist__ (rule_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   temp_ VARCHAR2(100);
   CURSOR check_for_rule 
IS
   SELECT rule_name
   FROM routing_rule_condition
   WHERE rule_name = rule_name_;
BEGIN
   OPEN check_for_rule;
   FETCH check_for_rule INTO temp_;
   CLOSE check_for_rule;  
   IF temp_ IS NOT NULL THEN
      RETURN TRUE;     
   END IF;
   RETURN FALSE;
END Rule_Exist__;
