-----------------------------------------------------------------------------
--
--  Logical unit: ReportRuleAction
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date      Sign    History
--  --------  ------  ---------------------------------------------------------
--  20160203  CHALLK  Invalid value format error is shown when importing rules (Bug #	127074)
--  20160328  ASIWLK  Export Report Rules as ins files (Bug #	128276)
--  20180109  HADOLK  Changing the data type of property_list from VARCHAR to CLOB
--  20180621  MABALK  Trying to enable/disable a report action (modify), without opening the action list, gives an error (Bug #	142665)
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
      FROM report_rule_action WHERE
      rule_id = rule_id_;
   
   CURSOR get_row_no IS
      SELECT REPORT_RULE_ACTION_SEQ.NEXTVAL
      FROM dual;
   
BEGIN
   OPEN get_row_no;
   FETCH get_row_no INTO next_val_;
   CLOSE get_row_no;
   rule_id_ := Client_SYS.Get_Item_Value('RULE_ID', attr_);
   IF rule_id_ IS NOT NULL THEN
      OPEN get_ordinal(rule_id_);
      FETCH get_ordinal INTO ordinal_;
      IF get_ordinal%NOTFOUND THEN
         ordinal_ := 0;
      END IF;
      CLOSE get_ordinal;
   ELSE
      ordinal_ := 0;
   END IF;
   IF ordinal_ IS NULL THEN
      ordinal_ := 0;
   END IF;
    
   super(attr_);

   Client_SYS.Add_To_Attr('ROW_NO',To_Char(next_val_),attr_);
   Client_SYS.Add_To_Attr('ORDINAL',To_Char(ordinal_+10),attr_);
   Client_SYS.Add_To_Attr('ENABLED_DB','TRUE',attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Parse_Xml_String__ (
   check_string_ IN VARCHAR2) RETURN VARCHAR2
IS  
BEGIN
    return REPORT_RULE_DEFINITION_API.parse_xml_string_(check_string_);
END Parse_Xml_String__;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT report_rule_action_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   from_ NUMBER;
   len_  NUMBER;
   to_   NUMBER;
   name_ VARCHAR2(30);
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   name_ := 'PROPERTY_LIST';
   len_ := length(name_);
   from_ := instr(Client_SYS.record_separator_ || attr_, Client_SYS.record_separator_ || name_ || Client_SYS.field_separator_);
   IF (from_ > 0) THEN
      to_ := instr(attr_, Client_SYS.record_separator_, from_ + 1);
      IF (to_ > 0) THEN
         attr_ := dbms_lob.Substr(attr_, to_ - from_ - len_ - 1, from_ + len_ + 1);
      END IF;
   END IF;
   Write_Property_List__(objversion_, objid_, attr_);
END Insert___;

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2)
IS
   from_ NUMBER;
   len_  NUMBER;
   to_   NUMBER;
   name_ VARCHAR2(30):= 'PROPERTY_LIST';
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      IF (Client_Sys.Item_Exist(name_, attr_)) THEN
         len_ := length(name_); 
         from_ := instr(Client_SYS.record_separator_ || attr_, Client_SYS.record_separator_ || name_ || Client_SYS.field_separator_);
         IF (from_ > 0) THEN
            to_ := instr(attr_, Client_SYS.record_separator_, from_ + 1);
            IF (to_ > 0) THEN
               attr_ := dbms_lob.Substr(attr_, to_ - from_ - len_ - 1, from_ + len_ + 1);
            END IF;
         END IF;
         Error_SYS.Check_Not_Null(lu_name_, 'PROPERTY_LIST', attr_);
         Write_Property_List__(objversion_, objid_, attr_);
      END IF;
   END IF;
END Modify__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Import_Report_Rule_Action (
	report_rule_id_ IN NUMBER,
	report_rule_action_ IN XMLTYPE )
IS
	rec_                    REPORT_RULE_ACTION_TAB%ROWTYPE;
	objid_                  REPORT_RULE_ACTION.OBJID%TYPE;
	objversion_             REPORT_RULE_ACTION.OBJVERSION%TYPE;
	attr_                   VARCHAR2(32000);
   indrec_                 Indicator_Rec;
	next_val_               NUMBER;
   
	CURSOR get_row_no IS
		SELECT REPORT_RULE_ACTION_SEQ.NEXTVAL
		FROM dual;
BEGIN
	FOR act_ IN
		(SELECT
			XMLTYPE.EXTRACT (VALUE (c),
			'/REPORT_RULE_ACTION/ORDINAL/text()').getstringval () AS ordinal,
			XMLTYPE.EXTRACT (VALUE (c),
			'/REPORT_RULE_ACTION/PROPERTY_LIST/text()').getclobval () AS property_list,
			XMLTYPE.EXTRACT (VALUE (c),
			'/REPORT_RULE_ACTION/TYPE/text()').getstringval () AS type,
			XMLTYPE.EXTRACT (VALUE (c),
			'/REPORT_RULE_ACTION/ENABLED_DB/text()' ).getstringval () AS enabled

		FROM TABLE (XMLSEQUENCE (report_rule_action_)) c)
	LOOP
		OPEN get_row_no;
		FETCH get_row_no INTO next_val_;
		CLOSE get_row_no;

		Client_SYS.Clear_Attr(attr_);
		Client_SYS.Add_To_Attr('RULE_ID', To_Char(report_rule_id_), attr_);
		Client_SYS.Add_To_Attr('ROW_NO', To_Char(next_val_), attr_);
		Client_SYS.Add_To_Attr('ORDINAL', act_.ordinal, attr_);
		Client_SYS.Add_To_Attr('PROPERTY_LIST', act_.property_list, attr_);
		Client_SYS.Add_To_Attr('TYPE', act_.type, attr_);
		Client_SYS.Add_To_Attr('ENABLED', Fnd_Boolean_API.Decode(act_.enabled), attr_);
      attr_ := parse_xml_string__(attr_);
		Unpack___(rec_, indrec_, attr_);
      Check_Insert___(rec_, indrec_, attr_); 
		Insert___(objid_, objversion_, rec_, attr_);
	END LOOP;
END Import_Report_Rule_Action;

PROCEDURE Add_Report_Action(
   new_rule_id_ NUMBER,
   action_attr_ IN VARCHAR2
   )
IS
   indrec_                 Indicator_Rec;
   rec_                    REPORT_RULE_ACTION_TAB%ROWTYPE;
	objid_                  REPORT_RULE_ACTION.OBJID%TYPE;
	objversion_             REPORT_RULE_ACTION.OBJVERSION%TYPE;
   attr_                   VARCHAR2(32000);
   next_val_               NUMBER;
   CURSOR get_row_no IS
   SELECT REPORT_RULE_ACTION_SEQ.NEXTVAL
	FROM dual;
BEGIN
   attr_:=action_attr_;
   OPEN get_row_no;
   FETCH get_row_no INTO next_val_;
   CLOSE get_row_no;
   Client_SYS.Add_To_Attr('RULE_ID', new_rule_id_, attr_);
   Client_SYS.Add_To_Attr('ROW_NO', To_Char(next_val_), attr_);
   Unpack___(rec_, indrec_, attr_);
   Check_Insert___(rec_, indrec_, attr_);
	Insert___(objid_, objversion_, rec_, attr_);
END Add_Report_Action;

PROCEDURE Update_Rule_Action(
   rule_id_ IN NUMBER,
   ordinal_ IN NUMBER,
   property_list_ IN VARCHAR2) 
IS
   new_rec_   report_rule_action_tab%ROWTYPE;
   attr_   VARCHAR2(32000);
   old_rec_ report_rule_action_tab%ROWTYPE;
   indrec_     Indicator_rec;
   objid_        ROWID;
   objversion_   VARCHAR2(2000);
   
BEGIN
   Get_Id_Version_By_Keys___(objid_,objversion_,rule_id_,ordinal_);
   old_rec_ := Lock_By_Keys___(rule_id_, ordinal_);
   new_rec_ := old_rec_;
   new_rec_.property_list := property_list_;
   
   indrec_ := Get_Indicator_Rec___(old_rec_, new_rec_);
   Check_Update___(old_rec_, new_rec_, indrec_, attr_);
   Update___(objid_, old_rec_, new_rec_, attr_, objversion_, TRUE);
END Update_Rule_Action;

PROCEDURE Insert_Rule_Action(
   rule_id_ NUMBER,
   action_attr_ IN VARCHAR)
IS
   indrec_               Indicator_Rec;
   rec_                  REPORT_RULE_ACTION_TAB%ROWTYPE;
   objid_                REPORT_RULE_ACTION.OBJID%TYPE;
   objversion_           REPORT_RULE_ACTION.OBJVERSION%TYPE;
   attr_                 VARCHAR2(32000);
   next_val_             NUMBER;
   ordinal_              NUMBER;
   CURSOR  get_row_no IS
   SELECT  REPORT_RULE_ACTION_SEQ.NEXTVAL
   FROM    dual;
   
   CURSOR get_ordinal (rule_id_ NUMBER)IS
   SELECT MAX(ORDINAL)
   FROM report_rule_action WHERE
   rule_id = rule_id_;
BEGIN
   attr_ := action_attr_;
   OPEN get_row_no;
   FETCH get_row_no INTO next_val_;
   CLOSE get_row_no;
  
   OPEN get_ordinal(rule_id_);
   FETCH get_ordinal INTO ordinal_;
   ordinal_ := NVL(ordinal_, 0);
   CLOSE get_ordinal;
 
   Client_SYS.Add_To_Attr('RULE_ID', rule_id_, attr_);
   Client_SYS.Add_To_Attr('ROW_NO', To_Char(next_val_), attr_);
   Client_SYS.Add_To_Attr('ORDINAL',To_Char(ordinal_+10),attr_);
   Client_SYS.Add_To_Attr('ENABLED_DB','TRUE',attr_);
   Unpack___(rec_, indrec_, attr_);
   Check_Insert___(rec_, indrec_, attr_);
   Insert___(objid_, objversion_, rec_, attr_);
END Insert_Rule_Action;