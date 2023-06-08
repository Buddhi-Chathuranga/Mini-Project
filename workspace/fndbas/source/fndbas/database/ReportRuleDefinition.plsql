-----------------------------------------------------------------------------
--
--  Logical unit: ReportRuleDefinition
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date      Sign    History
--  -------   ------  ---------------------------------------------------------
--  20140429  NaBaLK  Multiple root elements issue (TEREPORT-1169)
--  20160203  CHALLK  Invalid value format error is shown when importing rules (Bug #	127074)
--  20160328  ASIWLK  Export Report Rules as ins files (Bug #	128276)
--  20180907  ddeslk  Added freeDocument() for each DOMDocument instance (BUG ID:143824)
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
   CURSOR get_rule_id IS
      SELECT MAX(RULE_ID)
      FROM report_rule_definition;
   
   next_rule_id_ NUMBER;
   
BEGIN
   super(attr_);
   OPEN get_rule_id;
   FETCH get_rule_id INTO next_rule_id_;  
   IF get_rule_id%notfound THEN
      next_rule_id_ := 0;
    END IF;
   CLOSE get_rule_id;
   IF next_rule_id_ IS NULL THEN
       next_rule_id_:=0;
   END IF;
    
    
   Client_SYS.Add_To_Attr('RULE_ID', next_rule_id_ + 10 - REMAINDER(next_rule_id_, 10),attr_);
   Client_SYS.Add_To_Attr('ENABLED_DB','TRUE',attr_);
   Client_SYS.Add_To_Attr('PRIORITY','1',attr_);
   Client_SYS.Add_To_Attr('NO_MULTI_DB','TRUE',attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
@UncheckedAccess
FUNCTION Parse_Xml_String_ (
   check_string_ IN VARCHAR2) RETURN VARCHAR2
IS  
   attr_ VARCHAR2(32000);
BEGIN
    Client_SYS.Clear_Attr(attr_);
    attr_ := REPLACE(check_string_,chr(38)||'lt;','<');
    attr_ := REPLACE(attr_,chr(38)||'gt;','>');
    attr_ := REPLACE(attr_,chr(38)||'amp;', chr(38));
    attr_ := REPLACE(attr_,chr(38)||'apos;','''');
    attr_ := REPLACE(attr_,chr(38)||'quot;','"');
    return attr_;
END Parse_Xml_String_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Import_Report_Rule_Definition(
	import_rule_id_ OUT VARCHAR2,
	import_rule_xml_ IN CLOB )
IS
	domdoc_                  DBMS_XMLDOM.DOMDocument;
	root_                    XMLTYPE;
	report_rule_definition_  XMLTYPE;
	report_rule_condition_   XMLTYPE;
	report_rule_action_      XMLTYPE;

	CURSOR get_rule_id IS
		SELECT MAX(RULE_ID)
		FROM REPORT_RULE_DEFINITION;

	rec_                    REPORT_RULE_DEFINITION_TAB%ROWTYPE;
	objid_                  REPORT_RULE_DEFINITION.OBJID%TYPE;
	objversion_             REPORT_RULE_DEFINITION.OBJVERSION%TYPE;
	attr_                   VARCHAR2(32000);
	next_rule_id_           NUMBER;
	report_rule_id_         NUMBER;
   indrec_                 Indicator_Rec;
BEGIN
	domdoc_ := DBMS_XMLDOM.newDOMDocument(import_rule_xml_);
	root_ := DBMS_XMLDOM.getXmlType(domdoc_);
	import_rule_id_ := NULL;
	  
	FOR def_ IN
		(SELECT
			XMLTYPE.EXTRACT (VALUE (a),
			'/REPORT_RULE_DEFINITION/@RULE_ID').getstringval () AS rule_id,     
			XMLTYPE.EXTRACT (VALUE (a),
			'/REPORT_RULE_DEFINITION/DESCRIPTION/text()').getstringval () AS description,
			XMLTYPE.EXTRACT (VALUE (a),
			'/REPORT_RULE_DEFINITION/REPORT_ID/text()').getstringval () AS report_id,
			XMLTYPE.EXTRACT (VALUE (a),
			'/REPORT_RULE_DEFINITION/ENABLED_DB/text()').getstringval () AS enabled,
			XMLTYPE.EXTRACT (VALUE (a),
			'/REPORT_RULE_DEFINITION/PRIORITY/text()').getstringval () AS priority,
			XMLTYPE.EXTRACT (VALUE (a),
			'/REPORT_RULE_DEFINITION/NO_MULTI_DB/text()').getstringval () AS no_multi
		FROM TABLE (XMLSEQUENCE (root_.EXTRACT ('/DEFINITIONS/REPORT_RULE_DEFINITION'))) a)
	LOOP

		OPEN get_rule_id;
		FETCH get_rule_id INTO next_rule_id_;  
		IF get_rule_id%notfound THEN
			next_rule_id_ := 0;
		END IF;
		CLOSE get_rule_id;
		IF next_rule_id_ IS NULL THEN
			next_rule_id_:= 0;
		END IF;

		report_rule_id_ := ( next_rule_id_ + 10 ) - remainder ( next_rule_id_, 10 );
		IF import_rule_id_ IS NULL THEN
			import_rule_id_ := To_Char(report_rule_id_);
		ELSE		
			import_rule_id_ := import_rule_id_ || ',' || report_rule_id_;
		END IF;
		
		Client_SYS.Clear_Attr(attr_);
		Client_SYS.Add_To_Attr('RULE_ID', To_Char(report_rule_id_), attr_);
		Client_SYS.Add_To_Attr('DESCRIPTION', def_.description, attr_);
		Client_SYS.Add_To_Attr('REPORT_ID', def_.report_id, attr_);
		Client_SYS.Add_To_Attr('ENABLED', Fnd_Boolean_API.Decode(def_.enabled), attr_);
		Client_SYS.Add_To_Attr('PRIORITY', def_.priority, attr_);
		Client_SYS.Add_To_Attr('NO_MULTI', Fnd_Boolean_API.Decode(def_.no_multi), attr_);

      attr_ := parse_xml_string_(attr_);
      Unpack___(rec_, indrec_, attr_);
      Check_Insert___(rec_, indrec_, attr_);
		Insert___(objid_, objversion_, rec_, attr_);

		report_rule_definition_:= root_.EXTRACT('/DEFINITIONS/REPORT_RULE_DEFINITION[@RULE_ID="'||def_.rule_id||'"]');
		
		-- Create report rule condition records with the report id as attribute.
		report_rule_condition_ := report_rule_definition_.EXTRACT('/REPORT_RULE_DEFINITION/CONDITIONS/REPORT_RULE_CONDITION');
		REPORT_RULE_CONDITION_API.Import_Report_Rule_Condition( report_rule_id_, report_rule_condition_ );
 
		-- Create report rule action records with the report id as attribute.
		report_rule_action_ := report_rule_definition_.EXTRACT('/REPORT_RULE_DEFINITION/ACTIONS/REPORT_RULE_ACTION');
		REPORT_RULE_ACTION_API.Import_Report_Rule_Action( report_rule_id_, report_rule_action_ );
      END LOOP;

      DBMS_XMLDOM.freeDocument ( domdoc_ );
      
END Import_Report_Rule_Definition;


PROCEDURE Export_Rule_Definition_Ins (
	export_rule_ins_ OUT CLOB,
	export_rule_id_ IN VARCHAR2)
IS
   ins_out_file_        CLOB;
   new_line_            VARCHAR2(2);
   array_               DBMS_UTILITY.uncl_array;
	count_               NUMBER;
BEGIN
   new_line_:=chr(13) || chr(10);
   ins_out_file_:='SET SERVEROUTPUT ON'||new_line_;
   ins_out_file_:=ins_out_file_||new_line_;
   ins_out_file_:=ins_out_file_||'DECLARE'||new_line_;
   ins_out_file_:=ins_out_file_||'   New_Rule_Id_  NUMBER;'||new_line_;
   ins_out_file_:=ins_out_file_||'BEGIN'||new_line_;
   
   
   --LOOP for the comma seperated list of Rule Ids
   dbms_utility.comma_to_table(export_rule_id_, count_, array_);
   FOR i IN 1 .. count_
   LOOP
      ins_out_file_:=ins_out_file_||new_line_;
      ins_out_file_:=ins_out_file_||'   New_Rule_Id_:=Report_Rule_Definition_API.Get_Next_Rule_Id;'||new_line_;
      Export_Rule_Definition_Ins___(ins_out_file_,replace(array_(i),'"',''));
      Export_Rule_Condition_Ins___(ins_out_file_, replace(array_(i),'"',''));
      Export_Rule_Action_Ins___(ins_out_file_, replace(array_(i),'"',''));
   END LOOP;
   ins_out_file_:=ins_out_file_||new_line_;
   ins_out_file_:=ins_out_file_||'END;'||new_line_;
   ins_out_file_:=ins_out_file_||'/'||new_line_;
   ins_out_file_:=ins_out_file_||'COMMIT'||new_line_;
   ins_out_file_:=ins_out_file_||'/'||new_line_;
   --return
   export_rule_ins_:=ins_out_file_;
END Export_Rule_Definition_Ins;



FUNCTION Encode_Ins___  ( original_ IN VARCHAR2) RETURN VARCHAR2

IS 
 original_value_ VARCHAR2(32000);
 
BEGIN
   
   original_value_:=original_;
   
   original_value_ := REPLACE (original_value_, chr(13)||chr(10) , '''|| chr(13) || chr(10) ||'''); -- windows
   original_value_ := REPLACE (original_value_, chr(10) , '''|| chr(10) ||'''); -- other windows
   original_value_ := REPLACE (original_value_, '''', '''|| chr(39) ||''');
   original_value_ := REPLACE (original_value_, '&', '''|| chr(38) ||''');
   original_value_ := REPLACE (original_value_, ',', '''|| chr(44) ||''');

   original_value_ := REPLACE (original_value_, '||''||', '||');
   original_value_ := REPLACE (original_value_, '||''''||', '||');
   original_value_ := REPLACE (original_value_, 'chr(39) || chr(13) || chr(10) || chr(39)', 'chr(13) || chr(10)');

   RETURN original_value_;   

END Encode_Ins___;


PROCEDURE Export_Rule_Definition_Ins___ (
	rule_ IN OUT CLOB,
	export_rule_id_ IN VARCHAR2)
IS
   attr_                   VARCHAR2(32000);
   def_                    REPORT_RULE_DEFINITION%ROWTYPE;
BEGIN
     
      SELECT * INTO def_
      FROM REPORT_RULE_DEFINITION 
      WHERE RULE_ID = export_rule_id_; 
      
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('DESCRIPTION', def_.description, attr_);
         Client_SYS.Add_To_Attr('REPORT_ID', def_.report_id, attr_);
         Client_SYS.Add_To_Attr('ENABLED_DB', def_.enabled_db, attr_);
         Client_SYS.Add_To_Attr('PRIORITY', def_.priority, attr_);
         Client_SYS.Add_To_Attr('NO_MULTI_DB', def_.no_multi_db, attr_);
         attr_ := Encode_Ins___(attr_);
         rule_ := rule_||'   Report_Rule_Definition_Api.Add_Report_Rule(New_Rule_Id_,'''||attr_||''');'|| chr(13) || chr(10);
         
END Export_Rule_Definition_Ins___;

PROCEDURE Export_Rule_Condition_Ins___ (
	rule_ IN OUT CLOB,
	export_rule_id_ IN VARCHAR2)
IS
   attr_                   VARCHAR2(32000);
BEGIN
   FOR con_ IN ( SELECT ROW_NO, ORDINAL, START_PARENT, LOGICAL_OP, EXPR1, OPERATOR, EXPR2, END_PARENT 
								FROM REPORT_RULE_CONDITION 
								WHERE RULE_ID = export_rule_id_)
	LOOP
      Client_SYS.Clear_Attr(attr_);
		Client_SYS.Add_To_Attr('ORDINAL', con_.ordinal, attr_);
		Client_SYS.Add_To_Attr('START_PARENT', con_.start_parent, attr_);
		Client_SYS.Add_To_Attr('LOGICAL_OP', con_.logical_op, attr_);
		Client_SYS.Add_To_Attr('EXPR1', con_.expr1, attr_);
		Client_SYS.Add_To_Attr('OPERATOR', con_.operator, attr_);
		Client_SYS.Add_To_Attr('EXPR2', con_.expr2, attr_);
		Client_SYS.Add_To_Attr('END_PARENT', con_.end_parent, attr_);
      attr_ := Encode_Ins___(attr_);
      rule_ := rule_|| '   Report_Rule_Condition_API.Add_Report_Condition(New_Rule_Id_,'''||attr_||''');'|| chr(13) || chr(10);

   END LOOP;

END Export_Rule_Condition_Ins___;

PROCEDURE Export_Rule_Action_Ins___ (
	rule_ IN OUT CLOB,
	export_rule_id_ IN VARCHAR2)
IS
   attr_                   VARCHAR2(32000);
BEGIN
   FOR act_ IN ( SELECT ROW_NO, ORDINAL, PROPERTY_LIST, TYPE, ENABLED_DB 
								FROM REPORT_RULE_ACTION 
								WHERE RULE_ID = export_rule_id_ )
   LOOP
      Client_SYS.Clear_Attr(attr_);
		
		Client_SYS.Add_To_Attr('ORDINAL', act_.ordinal, attr_);
		Client_SYS.Add_To_Attr('PROPERTY_LIST', act_.property_list, attr_);
		Client_SYS.Add_To_Attr('TYPE', act_.type, attr_);
		Client_SYS.Add_To_Attr('ENABLED_DB', act_.enabled_db, attr_);
      attr_ := Encode_Ins___(attr_);
      rule_ := rule_|| '   Report_Rule_Action_API.Add_Report_Action(New_Rule_Id_,'''||attr_||''');'|| chr(13) || chr(10);

   END LOOP;
END Export_Rule_Action_Ins___;

FUNCTION Get_Next_Rule_Id  RETURN NUMBER
IS
   next_rule_id_ NUMBER;
   CURSOR get_rule_id IS
   SELECT MAX(RULE_ID)
   FROM REPORT_RULE_DEFINITION;
BEGIN
   OPEN get_rule_id;
   FETCH get_rule_id INTO next_rule_id_;  
   IF get_rule_id%notfound THEN
      next_rule_id_ := 0;
   END IF;
   CLOSE get_rule_id;
   IF next_rule_id_ IS NULL THEN
      next_rule_id_:= 0;
   END IF;
   next_rule_id_ := ( next_rule_id_ + 10 ) - remainder ( next_rule_id_, 10 );
   RETURN next_rule_id_;
END Get_Next_Rule_Id;

PROCEDURE Add_Report_rule(
   new_rule_id_ NUMBER,
   rule_attr_ IN VARCHAR2
   )
IS
   
   indrec_                 Indicator_Rec;
   rec_                    REPORT_RULE_DEFINITION_TAB%ROWTYPE;
   objid_                  REPORT_RULE_DEFINITION.OBJID%TYPE;
	objversion_             REPORT_RULE_DEFINITION.OBJVERSION%TYPE;
   attr_                   VARCHAR2(32000);
BEGIN
   attr_:=rule_attr_;
   Client_SYS.Add_To_Attr('RULE_ID', new_rule_id_, attr_);
   Unpack___(rec_, indrec_, attr_);
   Check_Insert___(rec_, indrec_, attr_);
	Insert___(objid_, objversion_, rec_, attr_);
END Add_Report_rule;


PROCEDURE Export_Report_Rule_Definition (
	export_rule_xml_ OUT CLOB,
	export_rule_id_ IN VARCHAR2)
IS
	domdoc_ DBMS_XMLDOM.DOMDocument;
	root_node_ DBMS_XMLDOM.DOMNode;
	name_node_ DBMS_XMLDOM.DOMNode;
	name_textnode_ DBMS_XMLDOM.DOMNode;
	
	parent_array_ DBMS_XMLDOM.DOMNode;
	parent_element_ DBMS_XMLDOM.DOMElement;
	parent_node_ DBMS_XMLDOM.DOMNode;

	child_array_ DBMS_XMLDOM.DOMNode;
	child_element_ DBMS_XMLDOM.DOMElement;
	child_node_ DBMS_XMLDOM.DOMNode;

	array_ DBMS_UTILITY.uncl_array;
	count_ BINARY_INTEGER;
BEGIN
	-- Create an empty XML document
	domdoc_ := DBMS_XMLDOM.newDomDocument;
	DBMS_XMLDOM.setVersion(domdoc_, '1.0');
	DBMS_XMLDOM.setCharset(domdoc_ , 'UTF-8');

	-- Create a root node
	root_node_ := DBMS_XMLDOM.makeNode(domdoc_);

	DBMS_UTILITY.COMMA_TO_TABLE( LIST => export_rule_id_, TABLEN => count_, TAB => array_);
	
	-- Create a new node definitions and add it to the root node
	parent_array_ := DBMS_XMLDOM.appendChild ( root_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'DEFINITIONS' ) ) );
   
		
   FOR i IN 1 .. count_
   LOOP

		FOR def_ IN ( SELECT  def.RULE_ID, def.DESCRIPTION, def.REPORT_ID, def.ENABLED_DB, def.PRIORITY, def.NO_MULTI_DB 
							FROM REPORT_RULE_DEFINITION def 
							WHERE def.RULE_ID IN ( replace(array_(i),'"','') ) )
		LOOP
			-- For each record, create a new report rule definition element with the rule id as attribute.
			-- and add this new report rule definition element to the definitions node
			parent_element_ := DBMS_XMLDOM.createElement ( domdoc_, 'REPORT_RULE_DEFINITION' );
			DBMS_XMLDOM.setAttribute ( parent_element_, 'RULE_ID', def_.RULE_ID );
			parent_node_ := DBMS_XMLDOM.appendChild ( parent_array_, DBMS_XMLDOM.makeNode ( parent_element_ ) );

			-- Each report rule definition node will get a description node which contains the description as text
			name_node_ := DBMS_XMLDOM.appendChild ( parent_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'DESCRIPTION' ) ) );
			name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, def_.DESCRIPTION ) ) );

			-- Each report rule definition node will aslo get a report id node which contains the report id as text
			name_node_ := DBMS_XMLDOM.appendChild ( parent_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'REPORT_ID' ) ) );
			name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode(domdoc_, def_.REPORT_ID )));

			-- Each report rule definition node will get a enabled node which contains the enabled as text
			name_node_ := DBMS_XMLDOM.appendChild ( parent_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'ENABLED_DB' ) ) );
			name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, def_.ENABLED_DB ) ) );

			-- Each report rule definition node will aslo get a priority node which contains the priority as text
			name_node_ := DBMS_XMLDOM.appendChild ( parent_node_, DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement ( domdoc_, 'PRIORITY' ) ) );
			name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, def_.PRIORITY ) ) );

			-- Each report rule definition node will aslo get a no multi node which contains the location no multi as text
			name_node_ := DBMS_XMLDOM.appendChild ( parent_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'NO_MULTI_DB' ) ) );
			name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, def_.NO_MULTI_DB ) ) );
														
			-- For each rule, add an conditions node
			child_array_ := DBMS_XMLDOM.appendChild ( parent_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'CONDITIONS' ) ) );

			FOR con_ IN ( SELECT ROW_NO, ORDINAL, START_PARENT_DB, LOGICAL_OP, EXPR1, OPERATOR, EXPR2, END_PARENT_DB 
								FROM REPORT_RULE_CONDITION 
								WHERE RULE_ID = def_.RULE_ID)
			LOOP
				-- For each record, create a new report rule condition element with the row no as attribute.
				-- and add this new report rule condition element to the conditions node
				child_element_ := DBMS_XMLDOM.createElement ( domdoc_, 'REPORT_RULE_CONDITION' );
				DBMS_XMLDOM.setAttribute ( child_element_, 'ROW_NO', con_.ROW_NO );
				child_node_ := DBMS_XMLDOM.appendChild ( child_array_, DBMS_XMLDOM.makeNode ( child_element_ ) );

				-- Each report rule condition node will get a ordinal node which contains the ordinal as text
				name_node_ := DBMS_XMLDOM.appendChild ( child_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'ORDINAL' ) ) );
				name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, con_.ORDINAL ) ) );

				name_node_ := DBMS_XMLDOM.appendChild ( child_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'START_PARENT_DB' ) ) );
				name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, con_.START_PARENT_DB ) ) );
															
				-- Each report rule condition node will get a logical op node which contains the logical op as text
				name_node_ := DBMS_XMLDOM.appendChild ( child_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'LOGICAL_OP' ) ) );
				name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, con_.LOGICAL_OP ) ) );

				name_node_ := DBMS_XMLDOM.appendChild ( child_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'EXPR1' ) ) );
				name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, con_.EXPR1 ) ) );

				-- Each report rule condition node will get a operator node which contains the operator as text
				name_node_ := DBMS_XMLDOM.appendChild ( child_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'OPERATOR' ) ) );
				name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, con_.OPERATOR ) ) );

				name_node_ := DBMS_XMLDOM.appendChild ( child_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'EXPR2' ) ) );
				name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, con_.EXPR2 ) ) );

				name_node_ := DBMS_XMLDOM.appendChild ( child_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'END_PARENT_DB' ) ) );
				name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, con_.END_PARENT_DB ) ) );															
			END LOOP;
	  
			-- For each rule, add an actions node
			child_array_ := DBMS_XMLDOM.appendChild ( parent_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'ACTIONS' ) ) );

			FOR act_ IN ( SELECT ROW_NO, ORDINAL, PROPERTY_LIST, TYPE, ENABLED_DB 
								FROM REPORT_RULE_ACTION 
								WHERE RULE_ID = def_.RULE_ID )
			LOOP
				-- For each record, create a new report rule action element with the row no as attribute.
				-- and add this new report rule action element to the actions node
				child_element_ := DBMS_XMLDOM.createElement ( domdoc_, 'REPORT_RULE_ACTION' );
				DBMS_XMLDOM.setAttribute ( child_element_, 'ROW_NO', act_.ROW_NO );
				child_node_ := DBMS_XMLDOM.appendChild ( child_array_, DBMS_XMLDOM.makeNode ( child_element_ ) );

				-- Each report rule action node will get a ordinal node which contains the ordinal as text
				name_node_ := DBMS_XMLDOM.appendChild ( child_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'ORDINAL' ) )	);
				name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, act_.ORDINAL ) ) );

				name_node_ := DBMS_XMLDOM.appendChild ( child_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'PROPERTY_LIST' ) ) );
				name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, act_.PROPERTY_LIST ) ) );
															
				-- Each report rule action node will get a type node which contains the type as text
				name_node_ := DBMS_XMLDOM.appendChild ( child_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'TYPE' ) ) );
				name_textnode_ := DBMS_XMLDOM.appendChild ( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, act_.TYPE ) ) );

				name_node_ := DBMS_XMLDOM.appendChild ( child_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createElement ( domdoc_, 'ENABLED_DB' ) ) );
				name_textnode_ := DBMS_XMLDOM.appendChild( name_node_, DBMS_XMLDOM.makeNode ( DBMS_XMLDOM.createTextNode ( domdoc_, act_.ENABLED_DB ) ) );
			END LOOP;
		END LOOP;
	END LOOP;

	DBMS_LOB.CreateTemporary( export_rule_xml_, TRUE );
	DBMS_XMLDOM.writeToCLOB( domdoc_, export_rule_xml_);
   DBMS_XMLDOM.freeDocument ( domdoc_ );
	
END Export_Report_Rule_Definition;



