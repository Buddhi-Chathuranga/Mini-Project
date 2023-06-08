-----------------------------------------------------------------------------
--
--  Logical unit: ReportRuleCondition
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date      Sign    History
--  --------  ------  ---------------------------------------------------------
--  20160203  CHALLK  Invalid value format error is shown when importing rules (Bug #	127074)
--  20160328  ASIWLK  Export Report Rules as ins files (Bug #	128276)
--  20190725  MABALK  Remove login language dependent Boolean client values from export report rules functionality (BUG ID:149331)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   next_val_ NUMBER;
   ordinal_ NUMBER;
   rule_id_ NUMBER;
   
   CURSOR get_ordinal (rule_id_ NUMBER)IS
      SELECT MAX(ORDINAL)
      FROM report_rule_condition WHERE
      rule_id = rule_id_;
   
  
   CURSOR get_row_no IS
      SELECT REPORT_RULE_CONDITION_SEQ.NEXTVAL
      FROM dual;
   
BEGIN
   OPEN get_row_no;
   FETCH get_row_no INTO next_val_;
   CLOSE get_row_no;
   
   rule_id_ := Client_SYS.Get_Item_Value('RULE_ID', attr_);
    
   IF rule_id_ IS NOT NULL THEN
      OPEN get_ordinal(rule_id_);
      FETCH get_ordinal  INTO ordinal_;
      IF get_ordinal%notfound THEN
         ordinal_ := 0;
      END IF;
      CLOSE get_ordinal;
   ELSE
      ordinal_ := 0;
   END IF;
   IF ordinal_ IS NULL THEN
      ordinal_:=0;
   END IF;
    
    
   super(attr_);
   Client_SYS.Add_To_Attr('ROW_NO',To_Char(next_val_),attr_);
   Client_SYS.Add_To_Attr('ORDINAL',To_Char(ordinal_+10),attr_);
   Client_SYS.Add_To_Attr('START_PARENT_DB','FALSE',attr_);
   Client_SYS.Add_To_Attr('END_PARENT_DB','FALSE',attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Parse_Xml_String__ (
   check_string_ IN VARCHAR2) RETURN VARCHAR2
IS  
BEGIN
    return REPORT_RULE_DEFINITION_API.parse_xml_string_(check_string_);
END Parse_Xml_String__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Import_Report_Rule_Condition (
	report_rule_id_ IN NUMBER,
	report_rule_condition_ IN XMLTYPE )
IS
	rec_                    REPORT_RULE_CONDITION_TAB%ROWTYPE;		
	objid_                  REPORT_RULE_CONDITION.OBJID%TYPE;
	objversion_             REPORT_RULE_CONDITION.OBJVERSION%TYPE;
	attr_                   VARCHAR2(32000);
   indrec_                 Indicator_Rec;
	next_val_               NUMBER;

	CURSOR get_row_no IS
		SELECT REPORT_RULE_CONDITION_SEQ.NEXTVAL
		FROM dual;
BEGIN
	FOR con_ IN
		(SELECT
			XMLTYPE.EXTRACT (VALUE (b),
			'/REPORT_RULE_CONDITION/ORDINAL/text()').getstringval () AS ordinal,
			XMLTYPE.EXTRACT (VALUE (b),
			'/REPORT_RULE_CONDITION/START_PARENT_DB/text()').getstringval () AS start_parent,
			XMLTYPE.EXTRACT (VALUE (b),
			'/REPORT_RULE_CONDITION/LOGICAL_OP/text()').getstringval () AS logical_op,
			XMLTYPE.EXTRACT (VALUE (b),
			'/REPORT_RULE_CONDITION/EXPR1/text()' ).getstringval () AS expr1,
			XMLTYPE.EXTRACT (VALUE (b),
			'/REPORT_RULE_CONDITION/OPERATOR/text()' ).getstringval () AS operator,
			XMLTYPE.EXTRACT (VALUE (b),
			'/REPORT_RULE_CONDITION/EXPR2/text()' ).getstringval () AS expr2,
			XMLTYPE.EXTRACT (VALUE (b),
			'/REPORT_RULE_CONDITION/END_PARENT_DB/text()' ).getstringval () AS end_parent
		 
		FROM TABLE (XMLSEQUENCE (report_rule_condition_)) b)
	LOOP
		OPEN get_row_no;
		FETCH get_row_no INTO next_val_;
		CLOSE get_row_no;

		Client_SYS.Clear_Attr(attr_);
		Client_SYS.Add_To_Attr('RULE_ID', To_Char(report_rule_id_), attr_);
		Client_SYS.Add_To_Attr('ROW_NO', To_Char(next_val_), attr_);
		Client_SYS.Add_To_Attr('ORDINAL', con_.ordinal, attr_);
		Client_SYS.Add_To_Attr('START_PARENT', Fnd_Boolean_API.Decode(con_.start_parent), attr_);
		Client_SYS.Add_To_Attr('LOGICAL_OP', con_.logical_op, attr_);
		Client_SYS.Add_To_Attr('EXPR1', con_.expr1, attr_);
		Client_SYS.Add_To_Attr('OPERATOR', con_.operator, attr_);
		Client_SYS.Add_To_Attr('EXPR2', con_.expr2, attr_);
		Client_SYS.Add_To_Attr('END_PARENT', Fnd_Boolean_API.Decode(con_.end_parent), attr_);
                attr_ := parse_xml_string__(attr_);
		Unpack___(rec_, indrec_, attr_);
      Check_Insert___(rec_, indrec_, attr_);
		Insert___(objid_, objversion_, rec_, attr_);
	END LOOP;
END Import_Report_Rule_Condition;

PROCEDURE Add_Report_Condition(
   new_rule_id_ NUMBER,
   condition_attr_ IN VARCHAR2
   )
IS
   indrec_                 Indicator_Rec;
   rec_                    REPORT_RULE_CONDITION_TAB%ROWTYPE;		
	objid_                  REPORT_RULE_CONDITION.OBJID%TYPE;
	objversion_             REPORT_RULE_CONDITION.OBJVERSION%TYPE;
   attr_                   VARCHAR2(32000);
   next_val_               NUMBER;
   CURSOR get_row_no IS
   SELECT REPORT_RULE_CONDITION_SEQ.NEXTVAL
   FROM dual;
BEGIN
   attr_:=condition_attr_;
   OPEN get_row_no;
   FETCH get_row_no INTO next_val_;
   CLOSE get_row_no;
   Client_SYS.Add_To_Attr('RULE_ID', new_rule_id_, attr_);
   Client_SYS.Add_To_Attr('ROW_NO', To_Char(next_val_), attr_);
   Unpack___(rec_, indrec_, attr_);
   Check_Insert___(rec_, indrec_, attr_);
	Insert___(objid_, objversion_, rec_, attr_);
END Add_Report_Condition;

PROCEDURE Update_Condition( 
   rule_id_ IN NUMBER,
   ordinal_ IN NUMBER,
   expr1_ IN VARCHAR2,
   expr2_ IN VARCHAR2)
IS
   report_rule_condition_rec_   report_rule_condition_tab%ROWTYPE;
   attr_   VARCHAR2(32000);
   old_rec_ report_rule_condition_tab%ROWTYPE;
   objid_        ROWID;
   objversion_   VARCHAR2(2000);
   indrec_     Indicator_rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_,objversion_,rule_id_,ordinal_);
   old_rec_ := Lock_By_Keys___(rule_id_, ordinal_);
   report_rule_condition_rec_ := old_rec_;
   report_rule_condition_rec_.expr1 := expr1_;
   report_rule_condition_rec_.expr2 := expr2_;
   
   indrec_ := Get_Indicator_Rec___(old_rec_, report_rule_condition_rec_);
   Check_Update___(old_rec_, report_rule_condition_rec_, indrec_, attr_);
   Update___(objid_, old_rec_, report_rule_condition_rec_, attr_, objversion_, TRUE);
   
END Update_Condition;

PROCEDURE Insert_Condition(
   new_rule_id_ NUMBER,
   condition_attr_ IN VARCHAR2
   )
IS
   rec_                    REPORT_RULE_CONDITION_TAB%ROWTYPE;		
   objid_                  REPORT_RULE_CONDITION.OBJID%TYPE;
   objversion_             REPORT_RULE_CONDITION.OBJVERSION%TYPE;
   attr_                   VARCHAR2(32000);
   indrec_                 Indicator_Rec;
   next_val_               NUMBER;
   ordinal_                NUMBER;
 
   CURSOR get_row_no IS
   SELECT REPORT_RULE_CONDITION_SEQ.NEXTVAL
   FROM dual;
      
   CURSOR get_ordinal (rule_id_ NUMBER)IS
   SELECT MAX(ORDINAL)
   FROM report_rule_condition WHERE
   rule_id = rule_id_;
BEGIN
   OPEN get_row_no;
   FETCH get_row_no INTO next_val_;
   CLOSE get_row_no;
   
   OPEN get_ordinal(new_rule_id_);
   FETCH get_ordinal  INTO ordinal_;
   ordinal_ := NVL(ordinal_, 0);
   CLOSE get_ordinal;
   
   attr_ := condition_attr_;
   Client_SYS.Add_To_Attr('RULE_ID', new_rule_id_, attr_);
   Client_SYS.Add_To_Attr('ROW_NO', To_Char(next_val_), attr_);
   Client_SYS.Add_To_Attr('ORDINAL',To_Char(ordinal_+10),attr_);
   Unpack___(rec_, indrec_, attr_);
   Check_Insert___(rec_, indrec_, attr_);
   Insert___(objid_, objversion_, rec_, attr_);
END Insert_Condition;