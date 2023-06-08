-----------------------------------------------------------------------------
--
--  Logical unit: CompositePageRepository
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

FUNCTION Get_Lobby_Xml___(
   id_ IN VARCHAR2) RETURN XMLType
IS
   datasource_ CLOB;
   CURSOR Lobby IS
   SELECT VALUE FROM composite_page
   WHERE id = id_;
BEGIN
   OPEN Lobby;
   FETCH Lobby INTO datasource_;
   CLOSE Lobby;
   RETURN XMLType(datasource_);
END Get_Lobby_Xml___;

FUNCTION Get_Lobby_Element_Xml___(
   id_ IN VARCHAR2) RETURN XMLType
IS
   datasource_ CLOB;
   CURSOR Lobby IS
      SELECT VALUE FROM composite_page_element
      WHERE id = id_;
BEGIN
   OPEN Lobby;
   FETCH Lobby INTO datasource_;
   CLOSE Lobby;
   RETURN XMLType(datasource_);
END Get_Lobby_Element_Xml___;

FUNCTION Get_Lobby_DataSource_Xml___(
   id_ IN VARCHAR2) RETURN XMLType
IS
   datasource_ CLOB;
   CURSOR Lobby IS
      SELECT VALUE FROM composite_page_data_source
      WHERE id = id_;
BEGIN
   OPEN Lobby;
   FETCH Lobby INTO datasource_;
   CLOSE Lobby;
   RETURN XMLType(datasource_);
END Get_Lobby_DataSource_Xml___;

FUNCTION Get_Lobby_Title__(
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   parsed_xml_ XMLType;
BEGIN
   parsed_xml_ := get_lobby_xml___(id_);   
   IF parsed_xml_.Extract('/*/PageTitle') IS NOT NULL THEN
      RETURN parsed_xml_.Extract('/*/PageTitle/text()').getStringVal();  
   END IF;
   RETURN '(No Title)';
END Get_Lobby_Title__;

FUNCTION Get_Lobby_Description__(
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   parsed_xml_ XMLType;
BEGIN
   parsed_xml_ := get_lobby_xml___(id_);   
   IF parsed_xml_.Extract('/*/DescriptiveText') IS NOT NULL THEN
      RETURN parsed_xml_.Extract('/*/DescriptiveText/text()').getStringVal();  
   END IF;
   RETURN '';
END Get_Lobby_Description__;

@UncheckedAccess
FUNCTION Get_Lobby_Client_Type__(
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   parsed_xml_ XMLType;
BEGIN
   parsed_xml_ := get_lobby_xml___(id_);   
   IF parsed_xml_.Extract('/*/ClientTypesPage') IS NOT NULL THEN
      RETURN parsed_xml_.Extract('/*/ClientTypesPage/text()').getStringVal();  
   END IF;
   RETURN '';
END Get_Lobby_Client_Type__;


FUNCTION Get_Lobby_Component__(
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   parsed_xml_ XMLType;
BEGIN
   parsed_xml_ := get_lobby_xml___(id_);   
   IF parsed_xml_.Extract('/*/Component') IS NOT NULL THEN
      RETURN parsed_xml_.Extract('/*/Component/text()').getStringVal();  
   END IF;
   RETURN 'CONFIG';
END Get_Lobby_Component__;

@UncheckedAccess
FUNCTION Get_Lobby_Ele_Client_Type__(
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   parsed_xml_ XMLType;
BEGIN
   parsed_xml_ := Get_Lobby_Element_Xml___(id_);   
   IF parsed_xml_.Extract('/*/ClientTypesPage') IS NOT NULL THEN
      RETURN parsed_xml_.Extract('/*/ClientTypesPage/text()').getStringVal();  
   END IF;
   RETURN '';
END Get_Lobby_Ele_Client_Type__;

FUNCTION Get_Lobby_Element_Title__(
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   parsed_xml_ XMLType;
BEGIN
   parsed_xml_ := Get_Lobby_Element_Xml___(id_);   
   IF parsed_xml_.Extract('/*/Name') IS NOT NULL THEN
      RETURN parsed_xml_.Extract('/*/Name/text()').getStringVal();  
   END IF;
   RETURN '(No Title)';
END Get_Lobby_Element_Title__;

FUNCTION Get_Lobby_Ele_Description__(
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   parsed_xml_ XMLType;
BEGIN
   parsed_xml_ := Get_Lobby_Element_Xml___(id_);   
   IF parsed_xml_.Extract('/*/DescriptiveText') IS NOT NULL THEN
      RETURN parsed_xml_.Extract('/*/DescriptiveText/text()').getStringVal();  
   END IF;
   RETURN '';
END Get_Lobby_Ele_Description__;

FUNCTION Get_Lobby_Ele_Component__(
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   parsed_xml_ XMLType;
BEGIN
   parsed_xml_ := Get_Lobby_Element_Xml___(id_);   
   IF parsed_xml_.Extract('/*/Component') IS NOT NULL THEN
      RETURN parsed_xml_.Extract('/*/Component/text()').getStringVal();  
   END IF;
   RETURN 'CONFIG';
END Get_Lobby_Ele_Component__;

FUNCTION Get_Lobby_Data_Source_Title__(
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   parsed_xml_ XMLType;
BEGIN
   parsed_xml_ := Get_Lobby_DataSource_Xml___(id_);   
   IF parsed_xml_.Extract('/*/Name') IS NOT NULL THEN
      RETURN parsed_xml_.Extract('/*/Name/text()').getStringVal();  
   END IF;
   RETURN '(No Title)';
END Get_Lobby_Data_Source_Title__;

FUNCTION Get_Lobby_Dat_Src_Component__(
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   parsed_xml_ XMLType;
BEGIN
   parsed_xml_ := Get_Lobby_DataSource_Xml___(id_);   
   IF parsed_xml_.Extract('/*/Component') IS NOT NULL THEN
      RETURN parsed_xml_.Extract('/*/Component/text()').getStringVal();  
   END IF;
   RETURN 'CONFIG';
END Get_Lobby_Dat_Src_Component__;

FUNCTION Get_Lobby_Dat_Src_KeyWords__(
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   parsed_xml_ XMLType;
BEGIN
   parsed_xml_ := Get_Lobby_DataSource_Xml___(id_);   
   IF parsed_xml_.Extract('/*/Keywords') IS NOT NULL THEN
      RETURN parsed_xml_.Extract('/*/Keywords/text()').getStringVal();  
   END IF;
   RETURN 'CONFIG';
END Get_Lobby_Dat_Src_KeyWords__;
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Create_Or_Replace_Element___ (
   id_      IN     VARCHAR2,
   element_ IN     CLOB) 
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   objid_          VARCHAR2(100);
   objversion_     VARCHAR2(100);
   component_           XMLType;
   component_name_      VARCHAR2(6);
   parsed_xml_          XMLType;
BEGIN
   parsed_xml_ := XMLType(element_);
   component_ := parsed_xml_.Extract('/*/Component/text()'); 
   
   IF (component_ IS NOT NULL) THEN
      component_name_ := component_.getStringVal();
      Client_SYS.Add_To_Attr('COMPONENT',component_name_,attr_);
   END IF;
   
   IF ( NOT Check_Element_Exist___(id_)) THEN
      composite_page_element_api.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('ID',id_,attr_);
      composite_page_element_api.New__(info_, objid_, objversion_,attr_, 'DO');
   ELSE 
      select objid,objversion into objid_,objversion_ from Composite_Page_Element t where id=id_;
   END IF;
   Composite_Page_Element_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   Composite_Page_Element_API.Write_Value__(objversion_, objid_, element_);
   Create_PO_For_Element___(id_,element_);
END Create_Or_Replace_Element___;

PROCEDURE Grant_PO___(
   po_id_ IN     VARCHAR2
   )
IS
   default_granted_role_ VARCHAR2(200);
BEGIN
   default_granted_role_ := Fnd_Setting_API.Get_Value('LOBBY_DEFAULT_GRANT');
   IF  (default_granted_role_ IS NULL) THEN
      default_granted_role_ := Fnd_Setting_API.Get_Value('HUD_DEFAULT_GRANT');
   END IF;
   IF  (default_granted_role_ IS NOT NULL AND default_granted_role_ != '*') THEN
      pres_object_util_api.grant_pres_object(po_id_, default_granted_role_,'QUERY','FALSE');
   END IF;
END Grant_PO___;

PROCEDURE Create_Or_Replace_DS___ (
   id_         IN     VARCHAR2,
   datasource_ IN     CLOB) 
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   objid_          VARCHAR2(100);
   objversion_     VARCHAR2(100);
   component_           XMLType;
   component_name_      VARCHAR2(6);
   parsed_xml_          XMLType;
BEGIN
   parsed_xml_ := XMLType(datasource_);
   component_ := parsed_xml_.Extract('/*/Component/text()'); 
   
   IF (component_ IS NOT NULL) THEN
      component_name_ := component_.getStringVal();
      Client_SYS.Add_To_Attr('COMPONENT',component_name_,attr_);
   END IF;
   IF ( NOT Check_Data_Source_Exist___(id_)) THEN
      composite_page_data_source_api.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('ID',id_,attr_);
      composite_page_data_source_api.New__(info_, objid_, objversion_,attr_, 'DO');
   ELSE 
      select objid,objversion into objid_,objversion_ from composite_page_data_source t where id=id_;
   END IF;
   Composite_Page_Data_Source_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   Composite_Page_Data_Source_API.Write_Value__(objversion_, objid_, datasource_);
  Create_PO_For_Data_Source___(id_,datasource_);
  
END Create_Or_Replace_DS___;

FUNCTION Check_Page_Exist___ (
   id_ IN     VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   COMPOSITE_PAGE_TAB
      WHERE  id = id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Page_Exist___;


FUNCTION Check_Data_Source_Exist___ (
   id_ IN     VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   COMPOSITE_PAGE_DATA_SOURCE_TAB
      WHERE  id = id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Data_Source_Exist___;


FUNCTION Check_Element_Exist___ (
   id_ IN     VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   COMPOSITE_PAGE_ELEMENT_TAB
      WHERE  id = id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Element_Exist___;

PROCEDURE Load_Page_Internal___ (
   id_                   IN  VARCHAR2,
   page_                 OUT NOCOPY CLOB,
   light_                IN  BOOLEAN,
   include_translations_ IN  BOOLEAN,
   objid_                OUT VARCHAR2,
   objversion_           OUT VARCHAR2)
IS 
   page2_ xmltype;
   data_source_ xmlType;
   data_source_node_ dbms_xmldom.DOMNODE;
   data_source_node_list_ DBMS_XMLDOM.DOMNodeList;
   element_ xmlType;
   element_node_ dbms_xmldom.DOMNODE;
   element_node_list_ DBMS_XMLDOM.DOMNodeList;
   nm_node_map_ DBMS_XMLDOM.DOMNamedNodeMap;
   node_ DBMS_XMLDOM.DOMNode;
   a_attr_ DBMS_XMLDOM.DOMAttr;
   s_data_source_id_ VARCHAR2(50);
   s_element_id_ VARCHAR2(50);
   doc_ xmldom.DOMDocument;
   column_index_     VARCHAR2(200);
   row_index_        VARCHAR2(200);
   column_span_      VARCHAR2(200);
   row_span_         VARCHAR2(200);
   translations_    XMLTYPE;
   path_condition_ VARCHAR2(32000);
   translation_query_ VARCHAR2(32000);
   element_component_ VARCHAR2(10) := '';
   element_title_ VARCHAR2(100);   
   element_count_ NUMBER := 0;
   element_title_xml_ xmlType;
   
   data_source_id_ VARCHAR2(100);
   disabled_component_ VARCHAR2(20);
   temp_obj_id_ VARCHAR2(50);
   temp_obj_version_ VARCHAR2(50);
   temp_clob_ CLOB; 
   e_disabled_component EXCEPTION;
   
BEGIN
   select Xmltype(value),objid,objversion into page2_,objid_, objversion_ from Composite_Page where Id = id_  ;
   doc_ := DBMS_XMLDOM.NEWDOMDOCUMENT(page2_);
   IF (NOT light_) THEN
      data_source_node_list_  :=
      DBMS_XMLDOM.GETELEMENTSBYTAGNAME(doc_, 'DataSource');
      -- Loop through the 'DataSource' nodes 
      FOR i_ IN 0..DBMS_XMLDOM.GETLENGTH(data_source_node_list_)-1 LOOP
         data_source_node_ := DBMS_XMLDOM.ITEM(data_source_node_list_, i_);
         -- Get the attributes of this node 
         nm_node_map_ := DBMS_XMLDOM.GETATTRIBUTES(data_source_node_);
         
         node_ := DBMS_XMLDOM.GETNAMEDITEM(nm_node_map_,'id');
         a_attr_ := DBMS_XMLDOM.MAKEATTR(node_);
         s_data_source_id_ := DBMS_XMLDOM.GETVALUE(a_attr_);
         BEGIN
             select Xmltype(value) into data_source_ from Composite_Page_Data_Source where Id=s_data_source_id_;
             select updateXml(page2_, '/Page/DataSources/DataSource[@id="' || s_data_source_id_ || '"]', data_source_.getClobVal()) into page2_ from dual ;
             -- Build condition to include translations for all elements
         path_condition_ := path_condition_ || 'OR path LIKE ''' || s_data_source_id_ || '.%''';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                   select updateXml(page2_, '/Page/DataSources/DataSource[@id="' || s_data_source_id_ || '"]', '') into page2_ from dual ;   
         END;
      END LOOP;
   ELSE
            select deleteXML(page2_,'/Page/DataSources') into page2_ from dual;
   END IF;
   
   element_node_list_ := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(doc_, 'Element');
   -- Loop through the 'Element' nodes 
   FOR i_ IN 0..DBMS_XMLDOM.GETLENGTH(element_node_list_)-1 LOOP
      element_node_ := DBMS_XMLDOM.ITEM(element_node_list_, i_);
      -- Get the attributes of this node 
      nm_node_map_ := DBMS_XMLDOM.GETATTRIBUTES(element_node_);
      
      node_ := DBMS_XMLDOM.GETNAMEDITEM(nm_node_map_,'id');
      a_attr_ := DBMS_XMLDOM.MAKEATTR(node_);
      s_element_id_ := DBMS_XMLDOM.GETVALUE(a_attr_);
      
      node_ := DBMS_XMLDOM.GETNAMEDITEM(nm_node_map_,'column');
      a_attr_ := DBMS_XMLDOM.MAKEATTR(node_);
      column_index_ := DBMS_XMLDOM.GETVALUE(a_attr_);
      
      node_ := DBMS_XMLDOM.GETNAMEDITEM(nm_node_map_,'row');
      a_attr_ := DBMS_XMLDOM.MAKEATTR(node_);
      row_index_ := DBMS_XMLDOM.GETVALUE(a_attr_);
      
      node_ := DBMS_XMLDOM.GETNAMEDITEM(nm_node_map_,'columnspan');
      a_attr_ := DBMS_XMLDOM.MAKEATTR(node_);
      column_span_ := DBMS_XMLDOM.GETVALUE(a_attr_);
      
      node_ := DBMS_XMLDOM.GETNAMEDITEM(nm_node_map_,'rowspan');
      a_attr_ := DBMS_XMLDOM.MAKEATTR(node_);
      row_span_ := DBMS_XMLDOM.GETVALUE(a_attr_);
      
      BEGIN
         Load_Element_Internal___(s_element_id_, temp_obj_id_, temp_obj_version_, temp_clob_, disabled_component_);
         
         IF(NVL(disabled_component_, 'NULL') != 'NULL') THEN 
            RAISE e_disabled_component;
         END IF;
         
         element_ := Xmltype(temp_clob_);
         
         IF (element_.existsNode('/*/Column') = 1) THEN
                   select updateXMl(element_,'/*/Column','<Column>'||column_index_||'</Column>') into element_ from dual;
         ELSE
                   select InsertChildXML(element_,'/*','Column',xmltype('<Column>'||column_index_||'</Column>')) into element_ from dual;
         END IF;
         
         IF (element_.existsNode('/*/Row') = 1) THEN
                   select updateXMl(element_,'/*/Row','<Row>'||row_index_||'</Row>') into element_ from dual;
         ELSE
                   select InsertChildXML(element_,'/*','Row',xmltype('<Row>'||row_index_||'</Row>')) into element_ from dual;
         END IF;
         
         IF (element_.existsNode('/*/ColumnSpan') = 1) THEN
                   select updateXMl(element_,'/*/ColumnSpan','<ColumnSpan>'||column_span_||'</ColumnSpan>') into element_ from dual;
         ELSE
                   select InsertChildXML(element_,'/*','ColumnSpan',xmltype('<ColumnSpan>'||column_span_||'</ColumnSpan>')) into element_ from dual;
         END IF;
         
         IF (element_.existsNode('/*/RowSpan') = 1) THEN
                   select updateXMl(element_,'/*/RowSpan','<RowSpan>'||row_span_||'</RowSpan>') into element_ from dual;
         ELSE
                   select InsertChildXML(element_,'/*','RowSpan',xmltype('<RowSpan>'||row_span_||'</RowSpan>')) into element_ from dual;
         END IF;
         
         --checking whether the DS or the view come from disabled component
         IF (element_.existsNode('/*/DataSourceId') = 1) THEN
            data_source_id_ := element_.extract('//DataSourceId/text()').getStringVal();  
            Load_Datasource_Internal___(data_source_id_, temp_obj_id_, temp_obj_version_, temp_clob_, disabled_component_);
            element_title_xml_ := element_.extract('//Title/text()');
            IF element_title_xml_ IS NOT NULL THEN
               element_title_ := element_title_xml_.getStringVal();
            ELSE
               element_title_ := '';
            END IF; 
            IF(NVL(disabled_component_, 'NULL') != 'NULL') THEN 
               RAISE e_disabled_component;
            END IF;                        
         END IF;
         
         select updateXml(page2_, '/Page/*/*/Group/Elements/Element[@id="' || s_element_id_ || '"]', element_.getClobVal()) into page2_ from dual ;
         
         -- Build condition to include translations for all elements
         path_condition_ := path_condition_ || 'OR path LIKE ''' || s_element_id_ || '.%''';
         
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               select count(id) INTO element_count_ from composite_page_element_tab where Id=s_element_id_;
               IF (element_count_ > 0) THEN
                  select component, Xmltype(value).extract('//Title/text()') into element_component_, element_title_xml_ from composite_page_element_tab where Id=s_element_id_;
                  IF element_title_xml_ IS NOT NULL THEN
                     element_title_ := element_title_xml_.getStringVal();
                  ELSE
                     element_title_ := '';
                  END IF; 
                  select updateXml(page2_, '/Page/*/*/Group/Elements/Element[@id="' || 
                  s_element_id_ || '"]','<Text><RowSpan>'||row_span_||'</RowSpan><ColumnSpan>'||column_span_||
                  '</ColumnSpan><Row>'||row_index_||'</Row><Column>'||column_index_||
                  '</Column><Title>'|| element_title_ ||'</Title><ID>'||s_element_id_||
                  '</ID><DisabledComponent>'||element_component_||'</DisabledComponent></Text>') into page2_ from dual ;
                 -- RAISE e_disabled_component;
               ELSE
                 select updateXml(page2_, '/Page/*/*/Group/Elements/Element[@id="' || s_element_id_ || '"]','<Text><RowSpan>'||row_span_||'</RowSpan><ColumnSpan>'||column_span_||'</ColumnSpan><Row>'||row_index_||'</Row><Column>'||column_index_||'</Column><Title>Element Missing</Title><ID>'||s_element_id_||'</ID></Text>') into page2_ from dual ;
               END IF;  
            WHEN e_disabled_component THEN
               select updateXml(page2_, '/Page/*/*/Group/Elements/Element[@id="' || 
               s_element_id_ || '"]','<Text><RowSpan>'||row_span_||'</RowSpan><ColumnSpan>'||column_span_||
               '</ColumnSpan><Row>'||row_index_||'</Row><Column>'||column_index_||
               '</Column><Title>'|| element_title_ ||'</Title><ID>'||s_element_id_||
               '</ID><DisabledComponent>'||disabled_component_||'</DisabledComponent></Text>') into page2_ from dual ;
      END;
   END LOOP;
   
   select InsertChildXML(page2_,'/Page','Objversion',xmltype('<Objversion>'||objversion_||'</Objversion>')) into page2_ from dual;
   select InsertChildXML(page2_,'/Page','Objid',xmltype('<Objid>'||objid_||'</Objid>')) into page2_ from dual;
   
   -- Get all translations for the Page (Title and DescriptiveText)
   -- and also all translations for all elements. 
   -- elementsPathCondition is a concatenated string of elements ID's 'ID.%'
   
   
   IF include_translations_ THEN
      translation_query_ := 'select XMLElement("Translations",
         XMLAgg(
            XMLElement("Translation",
               XMLElement("Path", lang.path),
               XMLElement("LanguageCode", lang.lang_code),
               XMLElement("Module", lang.module),   
               XMLElement("Text", lang.text)
            ) 
         ) 
      )
      FROM Language_Translation_Exp lang
      WHERE (path LIKE ''' || id_ || '.%''' || path_condition_ || ')
      AND text is not null';
   ELSE
      translation_query_ := 'select XMLElement("Translations",
         XMLAgg(
            XMLElement("Translation",
               XMLElement("Path", lang.path),
               XMLElement("Text", lang.text)
            ) 
         ) 
      )
      FROM Language_Translation_Exp lang
      WHERE (path LIKE ''' || id_ || '.%''' || path_condition_ || ')
      AND lang_code = Fnd_Session_API.Get_Language
      AND text is not null';
   END IF;
   
   @ApproveDynamicStatement(2014-07-10,mabose)
   EXECUTE IMMEDIATE translation_query_ INTO translations_;  
   
   select InsertChildXML(page2_,'/Page','Translations',translations_) into page2_ from dual;
   --select InsertChildXML(page2_,'/Page','Debug',xmltype('<Debug>'||path_condition_ ||'</Debug>')) into page2_ from dual;

   page_ := page2_.getClobVal();
   DBMS_XMLDOM.Freedocument(doc_);
END Load_Page_Internal___;

PROCEDURE Create_PO_For_Data_Source___(
   id_         IN     VARCHAR2,
   datasource_ IN     CLOB)
IS
   po_id_          VARCHAR2(200)  := 'lobbyDataSource'||id_;
   po_description_ VARCHAR2(70);
   parsed_xml_      XmlType;
   name_             XmlType;
   view_            XmlType;
   
   stmt_           VARCHAR2(8000);
   prefix_         VARCHAR2(31)   := Fnd_Session_API.Get_App_Owner||'.';
   pos_            NUMBER;
   to_pos_         NUMBER;
   char_number_    NUMBER;
   db_object_      VARCHAR2(2000);
   object_type_    VARCHAR2(6);
   sub_type_       VARCHAR2(1);
   
   TYPE rec_column IS RECORD (
   colName VARCHAR2(2000)
   );
   
   TYPE type_col IS TABLE OF rec_column INDEX BY BINARY_INTEGER;
   l_col_list_ type_col;
BEGIN
   parsed_xml_ := XMLType(datasource_);
   IF parsed_xml_.Extract('/*/Name') IS NOT NULL THEN
      name_ := parsed_xml_.Extract('/*/Name/text()');
   END IF;
   
   IF (name_ IS NOT NULL) THEN
      po_description_ := SUBSTR('Lobby - '|| name_.getStringVal(),0,70);
   END IF;
   Pres_Object_Util_API.Remove_Pres_Object(po_id_);
   Pres_Object_Util_API.New_Pres_Object(po_id_, 'FNDBAS', 'LOBBY',po_description_, 'Manual');      
   
   IF parsed_xml_.Extract('/*/View') IS NOT NULL THEN
      view_ := parsed_xml_.Extract('/*/View/text()');
      db_object_ := view_.getStringVal();
      db_object_ := UPPER(utl_i18n.unescape_reference(db_object_));
      -- Replace AO and APPOWNER with actual appowner
      db_object_ := REPLACE(db_object_,chr(38)||'AO.','');
      db_object_ := REPLACE(db_object_,chr(38)||'APPOWNER.','');
      IF (db_object_ != 'DUAL') THEN
         Pres_Object_Util_API.New_Pres_Object_Sec(po_id_, db_object_, 'VIEW', '4', 'Manual');
      END IF;
   END IF;
   
   stmt_ := XML_EXTRACT_NO_EXCEPTION___(parsed_xml_,'/*/View/text()') ||' ' 
   ||XML_EXTRACT_NO_EXCEPTION___(parsed_xml_,'/*/Where/text()')||' ' 
   ||XML_EXTRACT_NO_EXCEPTION___(parsed_xml_,'/*/OrderBy/text()')||' ' 
   ||XML_EXTRACT_NO_EXCEPTION___(parsed_xml_,'/*/GroupBy/text()');
   -- dbms_output.put_line('STMT::' ||stmt_);
   SELECT EXTRACTVALUE(VALUE(xml_list), '//Column') AS colName
      BULK COLLECT
      INTO l_col_list_
      FROM TABLE(XMLSEQUENCE(EXTRACT(parsed_xml_, '*/Select/DataColumn'))) xml_list;
   
   IF (l_col_list_.COUNT > 0) THEN
      FOR i_ IN l_col_list_.FIRST..l_col_list_.LAST LOOP
         stmt_ := stmt_||' ' || l_col_list_(i_).colName;
      END LOOP;
   END IF;
   
   stmt_ := UPPER(utl_i18n.unescape_reference(stmt_));
   
   IF (stmt_ IS NOT NULL) THEN
      -- Look for appowner prefixing function calls and views
      -- Replace AO and APPOWNER with actual appowner
      stmt_ := REPLACE(stmt_,chr(38)||'AO.',prefix_);
      stmt_ := REPLACE(stmt_,chr(38)||'APPOWNER.',prefix_);
      pos_ := instr(stmt_, prefix_);
      WHILE pos_ > 0 LOOP
         pos_ := pos_ + length(prefix_);
         
         to_pos_ := pos_;
         
         -- Look for the end of the db-object (characters in db-objects are ascii: 46, 48..57, 65..90, 95)
         char_number_ := ascii(substr(stmt_, to_pos_, 1));
         WHILE char_number_ = 46 OR (char_number_ BETWEEN 48 AND 57) OR (char_number_ BETWEEN 65 AND 90) OR char_number_ = 95  OR char_number_ = 36 LOOP
            to_pos_ := to_pos_ + 1;
            char_number_ := ascii(substr(stmt_, to_pos_, 1));
         END LOOP;
         -- Extract the db-object
         db_object_ := substr(stmt_, pos_, to_pos_ - pos_);
         
         -- Validate the db-object and insert it
         IF db_object_ IS NOT NULL THEN
            -- Define type
            IF instr(db_object_, '_API.') > 0 OR instr(db_object_, '_SYS.') > 0 OR instr(db_object_, '_RPI.') > 0
            OR instr(db_object_, '_CLP.') > 0 OR instr(db_object_, '_CFP.') > 0 OR instr(db_object_, '_ICP.') > 0
            OR instr(db_object_, '_SVC.') > 0 THEN
               object_type_ := 'METHOD';
               sub_type_    := '2';
            ELSE
               object_type_ := 'VIEW';
               sub_type_    := '4';
            END IF;
            -- Avoid incorrect objects
            IF object_type_ = 'VIEW' AND instr(db_object_, '.') > 0 THEN
               -- Discovered column prefixed with view, removing column name
               db_object_ := substr(db_object_, 1, instr(db_object_, '.') - 1 );
            END IF;
            -- Check lengths and if correct insert
            IF object_type_ = 'VIEW' AND length(db_object_) > 30 THEN
               -- Ignore if too long view name
               NULL;
            ELSIF object_type_ = 'METHOD' AND length(db_object_) > 61 THEN
               -- Ignore if too long method name
               NULL;
            ELSE
               Pres_Object_Util_API.New_Pres_Object_Sec(po_id_, db_object_, object_type_, sub_type_, 'Manual');
            END IF;
         END IF;
         -- Reinitiate variables
         db_object_ := NULL;
         -- Find next occurance of prefix, start from end of last occurance
         pos_ := instr(stmt_, prefix_, pos_);
      END LOOP;
   END IF;
   Grant_PO___(po_id_);
END Create_PO_For_Data_Source___;

FUNCTION XML_EXTRACT_NO_EXCEPTION___ ( 
   p_xml_       IN     XMLTYPE,
   p_xpath_     IN     VARCHAR2,
   p_namespace_ IN     VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 
IS
BEGIN
   RETURN  CASE WHEN p_xml_.extract(p_xpath_, p_namespace_) IS NOT NULL
               THEN p_xml_.extract(p_xpath_, p_namespace_).getstringval()
               ELSE NULL END;
 
END XML_EXTRACT_NO_EXCEPTION___;

PROCEDURE Create_PO_For_Element___(
   id_      IN     VARCHAR2,
   element_ IN     CLOB)
IS
   po_id_          VARCHAR2(200)  := 'lobbyElement'||id_;
   po_description_ VARCHAR2(70);
   parsed_xml_ XmlType;
   name_       XmlType;
   ds_         XmlType;
 
   TYPE rec_ds IS RECORD (
        ds_id VARCHAR2(50)
    );
 
    TYPE type_ds IS TABLE OF rec_ds INDEX BY BINARY_INTEGER;
    ds_list_ type_ds;
BEGIN
   parsed_xml_ := XMLType(element_);
   name_ := parsed_xml_.Extract('/*/Name/text()');
  

   IF (name_ IS NOT NULL) THEN
      po_description_ := SUBSTR('Lobby - '|| name_.getStringVal(),0,70);
   END IF;
   Pres_Object_Util_API.Remove_Pres_Object(po_id_);
   Pres_Object_Util_API.New_Pres_Object(po_id_, 'FNDBAS', 'LOBBY', po_description_, 'Manual');
   IF parsed_xml_.existsNode('/*/DataSourceId') > 0 THEN
      ds_ := parsed_xml_.Extract('/*/DataSourceId/text()');
      Pres_Object_Util_API.New_Pres_Object_Dependency(po_id_,'lobbyDataSource'||ds_.getStringVal(),4,'Manual');
   END IF;
   
   SELECT EXTRACTVALUE(VALUE(xml_list), '//DataSourceId') AS ds_id
   BULK COLLECT
   INTO ds_list_
   FROM TABLE(XMLSEQUENCE(EXTRACT(parsed_xml_, 'LinksList/Links/Link'))) xml_list;

   IF (ds_list_.COUNT > 0) THEN

      FOR i IN ds_list_.FIRST..ds_list_.LAST LOOP
         IF (length(ds_list_(i).ds_id)>0) THEN
            Pres_Object_Util_API.New_Pres_Object_Dependency(po_id_,'lobbyDataSource'||ds_list_(i).ds_id,4,'Manual');
         END IF;
      END LOOP;
   END IF;
   Grant_PO___(po_id_);
END Create_PO_For_Element___;

PROCEDURE Save_Page_Internal___(
   id_         IN     VARCHAR2,
   page_       IN     CLOB,
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   page_only_  IN     BOOLEAN)
IS
   nodename_                     VARCHAR2(200);
   
   is_idnode_                     BOOLEAN;
   is_compatiblenodetype_         BOOLEAN;
   
   parsed_xml_                    XMLType;
   updated_xml_                   XMLType;
   updated_xml_dom_               DBMS_XMLDOM.DOMDocument;
   element_list_xml_              XMLType;
   datasource_list_xml_           XMLType;
   
   -- Element DOM  
   element_list_dom_              DBMS_XMLDOM.DOMDocument;
   element_list_root_             DBMS_XMLDOM.DOMElement;
   element_list_current_          DBMS_XMLDOM.DOMNode;
   element_current_               DBMS_XMLDOM.DOMNode;
   
   element_curr_allproperties_    DBMS_XMLDOM.DOMNodeList;
   element_curr_property_         DBMS_XMLDOM.DOMNode;
   element_curr_propcount_        INTEGER;
   
   element_id_                    VARCHAR2(200);
   element_id_search_             VARCHAR2(200);
   element_id_replace_            VARCHAR2(200);
   
   -- Data Source DOM
   datasource_list_dom_           DBMS_XMLDOM.DOMDocument;
   datasource_list_root_          DBMS_XMLDOM.DOMElement;
   datasource_list_current_       DBMS_XMLDOM.DOMNode;
   datasource_current_            DBMS_XMLDOM.DOMNode;
   
   datasource_curr_allproperties_ DBMS_XMLDOM.DOMNodeList;
   datasource_curr_property_      DBMS_XMLDOM.DOMNode;
   datasource_curr_propcount_     INTEGER;
   
   datasource_id_                 VARCHAR2(200);
   datasource_id_search_          VARCHAR2(200);
   datasource_id_replace_         VARCHAR2(200);
   info_             VARCHAR2(2000);
   attr_             VARCHAR2(32000);
   
   column_index_     VARCHAR2(200);
   row_index_        VARCHAR2(200);
   column_span_      VARCHAR2(200);
   row_span_         VARCHAR2(200);
   
   po_id_            VARCHAR2(200)  := 'lobbyPage'||id_;
   po_description_   VARCHAR2(70);
   page_title_       XMLType;

   element_node_list_ DBMS_XMLDOM.DOMNodeList;
   nm_node_map_ DBMS_XMLDOM.DOMNamedNodeMap;
   node_ DBMS_XMLDOM.DOMNode;
   a_attr_ DBMS_XMLDOM.DOMAttr;
   s_element_id_ VARCHAR2(50);
   element_node_ dbms_xmldom.DOMNODE;
   component_         XMLType;
   component_name_    VARCHAR2(6);
BEGIN
   
   -- convert to XMLType and extract a list of all the Data Sources and all the Elements
   -- dbms_output.put_line(page_);
   -- dbms_output.put_line( XMLType.createXML(page_).getStringVal());
   parsed_xml_ := XMLType(page_);
   datasource_list_xml_ := XMLType.Extract(parsed_xml_, '/Page/DataSources/*');
   element_list_xml_ := XMLType.Extract(parsed_xml_, '/Page/*/*/Group/Elements/*');
   page_title_ := parsed_xml_.Extract('/Page/PageTitle/text()');
   component_ := parsed_xml_.Extract('/Page/Component/text()');
   IF (component_ IS NOT NULL) THEN
      component_name_ := component_.getStringVal();
      Client_SYS.Add_To_Attr('COMPONENT',component_name_,attr_);
   END IF;
   IF (page_title_ IS NOT NULL) THEN
      po_description_ := 'Lobby - '|| page_title_.getStringVal();
   ELSE
      po_description_ := 'Lobby - No title'; 
   END IF;
   Pres_Object_Util_API.Remove_Pres_Object(po_id_);
   Pres_Object_Util_API.New_Pres_Object(po_id_, 'FNDBAS', 'LOBBY', po_description_, 'Manual');
   
   -- the resulting XML starts as a copy of the input
   updated_xml_ := parsed_xml_;
   
   -- convert the data source list into a DOM so we can navigate through them
   datasource_list_dom_ := DBMS_XMLDOM.NewDOMDocument(datasource_list_xml_);
   datasource_list_root_ := DBMS_XMLDOM.GetDocumentElement(datasource_list_dom_);
   datasource_list_current_ := DBMS_XMLDOM.MakeNode(datasource_list_root_);
   datasource_current_ := datasource_list_current_; 
   
   -- loop through all the datasources, get each's datasource ID and replace the datasource definition
   -- with a reference to the datasource ID
   WHILE (NOT DBMS_XMLDOM.IsNull(datasource_current_))
   LOOP
      datasource_curr_allproperties_ := DBMS_XMLDOM.GetChildNodes(datasource_current_);
      datasource_curr_propcount_ := DBMS_XMLDOM.GetLength(datasource_curr_allproperties_);
      
      FOR i_ IN 0 .. datasource_curr_propcount_ - 1 LOOP
         -- we're looking for the datasourceID tag
         datasource_curr_property_ := DBMS_XMLDOM.Item(datasource_curr_allproperties_, i_);
         nodename_ := DBMS_XMLDOM.GetNodeName(datasource_curr_property_);
         is_idnode_ := (nodename_ = 'ID');
         is_compatiblenodetype_ := (DBMS_XMLDOM.GetNodeType(DBMS_XMLDOM.GetFirstChild(datasource_curr_property_)) IN (DBMS_XMLDOM.TEXT_NODE, DBMS_XMLDOM.CDATA_SECTION_NODE));
         
         IF is_idnode_ AND is_compatiblenodetype_ THEN
            -- found it, now replace the entire datasource definition with a reference
            datasource_id_ := DBMS_XMLDOM.GetNodeValue(DBMS_XMLDOM.GetFirstChild(datasource_curr_property_));
            datasource_id_search_ := '/Page/DataSources/*[ID="' || datasource_id_ || '"]';
            datasource_id_replace_ := '<DataSource id="' || datasource_id_ || '" />';
            IF (NOT page_only_) THEN
               Create_Or_Replace_DS___(datasource_id_,xmltype.extract(updated_xml_, datasource_id_search_,'xmlns=""').getclobval());
            END IF;
            -- in the result XML, do the replace
                select updateXml((updated_xml_), datasource_id_search_, datasource_id_replace_)
                into updated_xml_
                from dual;
            
         END IF;
      END LOOP;
      
      datasource_current_ := DBMS_XMLDOM.GetNextSibling(datasource_current_);
   END LOOP;
   
   -- convert the element list into a DOM so we can navigate through them
   element_list_dom_ := DBMS_XMLDOM.NewDOMDocument(element_list_xml_);
   element_list_root_ := DBMS_XMLDOM.GetDocumentElement(element_list_dom_);
   element_list_current_ := DBMS_XMLDOM.MakeNode(element_list_root_);
   element_current_ := element_list_current_; 
   
   -- loop through all the elements, get each's element ID and replace the element definition
   -- with a reference to the Element ID
   WHILE (NOT DBMS_XMLDOM.IsNull(element_current_))
   LOOP
      element_curr_allproperties_ := DBMS_XMLDOM.GetChildNodes(element_current_);
      element_curr_propcount_ := DBMS_XMLDOM.GetLength(element_curr_allproperties_);
      column_index_ := '0';
      row_index_ := '0';
      column_span_ := '1';
      row_span_ := '1';
      FOR i_ IN 0 .. element_curr_propcount_ - 1 LOOP
         -- we're looking for the ElementID tag
         element_curr_property_ := DBMS_XMLDOM.Item(element_curr_allproperties_, i_);
         nodename_ := DBMS_XMLDOM.GetNodeName(element_curr_property_);
         is_idnode_ := (nodename_ = 'ID');
         IF (nodename_ = 'ID') THEN
            element_id_ := DBMS_XMLDOM.GetNodeValue(DBMS_XMLDOM.GetFirstChild(element_curr_property_));
         END IF;
         IF (nodename_ = 'Column') THEN
            column_index_ := DBMS_XMLDOM.GetNodeValue(DBMS_XMLDOM.GetFirstChild(element_curr_property_));
         END IF;
         IF (nodename_ = 'Row') THEN
            row_index_ := DBMS_XMLDOM.GetNodeValue(DBMS_XMLDOM.GetFirstChild(element_curr_property_));
         END IF;
         IF (nodename_ = 'ColumnSpan') THEN
            column_span_ := DBMS_XMLDOM.GetNodeValue(DBMS_XMLDOM.GetFirstChild(element_curr_property_));
         END IF;
         IF (nodename_ = 'RowSpan') THEN
            row_span_ := DBMS_XMLDOM.GetNodeValue(DBMS_XMLDOM.GetFirstChild(element_curr_property_));
         END IF;
      END LOOP;
      
      element_id_search_ := '/Page/*/*/Group/Elements/*[ID="' || element_id_ || '"]';
      element_id_replace_ := '<Element id="' || element_id_ || '" column="'||column_index_||'" row="'||row_index_||'" columnspan="'||column_span_||'" rowspan="'||row_span_|| '" />';
      IF (NOT page_only_) THEN
         Create_Or_Replace_Element___(element_id_,xmltype.extract(updated_xml_, element_id_search_,'xmlns=""').getclobval());
      END IF;
      -- in the result XML, do the replace
         select updateXml((updated_xml_), element_id_search_, element_id_replace_)
         into updated_xml_
         from dual;
     
      element_current_ := DBMS_XMLDOM.GetNextSibling(element_current_);
   END LOOP;
   -- loop through elements and create the PO hierarchy
   updated_xml_dom_ := DBMS_XMLDOM.NewDOMDocument(updated_xml_);
   element_node_list_ := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(updated_xml_dom_, 'Element');
   FOR i_ IN 0..DBMS_XMLDOM.GETLENGTH(element_node_list_)-1 LOOP
      element_node_ := DBMS_XMLDOM.ITEM(element_node_list_, i_);
      -- Get the attributes of this node 
      nm_node_map_ := DBMS_XMLDOM.GETATTRIBUTES(element_node_);
      node_ := DBMS_XMLDOM.GETNAMEDITEM(nm_node_map_,'id');
      a_attr_ := DBMS_XMLDOM.MAKEATTR(node_);
      s_element_id_ := DBMS_XMLDOM.GETVALUE(a_attr_);
      Pres_Object_Util_API.New_Pres_Object_Dependency(po_id_,'lobbyElement'||s_element_id_,4,'Manual');
   END LOOP;
   
   IF ( NOT Check_Page_Exist___(id_)) THEN
      Client_SYS.Add_To_Attr('ID',id_,attr_);
      composite_page_api.New__(info_, objid_, objversion_,attr_, 'DO');
   ELSIF page_only_ THEN
      composite_page_api.Modify__(info_,objid_,objversion_,attr_,'DO');
   ELSIF (objid_ IS NULL OR objversion_ IS NULL ) THEN -- page is imported 
      SELECT objid,objversion INTO objid_,objversion_ FROM Composite_Page WHERE id=id_;
   END IF;

   Composite_Page_API.Write_Value__(objversion_, objid_, updated_xml_.getClobVal());
   Grant_PO___(po_id_);   
   Fnd_Admin_Jms_API.Send_Jms_Message('CLEAR_LOBBY_CACHE', id_ , 'ifsapp-int');
   DBMS_XMLDOM.Freedocument(datasource_list_dom_);
   DBMS_XMLDOM.Freedocument(element_list_dom_);
   DBMS_XMLDOM.Freedocument(updated_xml_dom_);
END Save_Page_Internal___;


PROCEDURE Load_Datasource_Internal___ (
   id_   IN     VARCHAR2,
   objid_ OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   datasource_    OUT NOCOPY CLOB,
   disabled_component_ OUT VARCHAR2)
IS
   CURSOR get_data_source_ IS
   SELECT value, objid, objversion
   FROM  COMPOSITE_PAGE_DATA_SOURCE
   WHERE id  =  id_;
   temp_view_name_ VARCHAR2(50);
   temp_count_ NUMBER := 0;
   e_disabled_component EXCEPTION;
   temp_ds_name_ VARCHAR2(100);
   data_source_root_ VARCHAR2(100);
BEGIN
   disabled_component_ := NULL;
   OPEN get_data_source_;
   FETCH get_data_source_ INTO datasource_, objid_, objversion_;
   CLOSE get_data_source_;
   
   IF(NVL(datasource_, 'NULL') != 'NULL') THEN
      IF(XmlType(datasource_).existsNode('/GraphDataSource') = 1) THEN
         data_source_root_ := 'GraphDataSource';
      ELSIF(XmlType(datasource_).existsNode('/ProjectionDataSource') = 1) THEN
         data_source_root_ := 'ProjectionDataSource';
      ELSE
         data_source_root_ := 'SQLDataSource';
      END IF;
   END IF;
   IF(NVL(objid_, 'NULL') = 'NULL') THEN
      select value,component into datasource_,disabled_component_ from COMPOSITE_PAGE_DATA_SOURCE_TAB where Id = id_; -- ds in table
      IF(NVL(disabled_component_, 'NULL') = 'NULL') THEN
         disabled_component_ := NULL;  -- not in table (no such ds)
      ELSE
         temp_ds_name_ := Xmltype(datasource_).extract('/' || data_source_root_ ||  '/Name/text()').getStringVal();
         RAISE e_disabled_component;
      END IF;
   ELSE 
      IF(XmlType(datasource_).existsNode('/*/View') = 1) THEN
         temp_view_name_ := Xmltype(datasource_).extract('//View/text()').getStringVal();
         temp_view_name_ := SUBSTR(temp_view_name_, INSTR(temp_view_name_, '.') + 1);
         SELECT COUNT(*) INTO temp_count_ FROM DICTIONARY_SYS_VIEW_ACTIVE WHERE UPPER(VIEW_NAME) = UPPER(temp_view_name_);
         IF (temp_count_ = 0) THEN 
            SELECT MODULE INTO disabled_component_ FROM DICTIONARY_SYS_TAB WHERE UPPER(LU_NAME) IN (SELECT UPPER(LU_NAME) from DICTIONARY_SYS_VIEW_TAB  WHERE UPPER(VIEW_NAME) = UPPER(temp_view_name_));
            IF(NVL(disabled_component_, 'NULL') != 'NULL') THEN
               RAISE e_disabled_component; 
            END IF;
         END IF;
      END IF;
          
      temp_ds_name_ := Xmltype(datasource_).extract('/' || data_source_root_ || '/Name/text()').getStringVal();           
   END IF;   
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
      WHEN e_disabled_component THEN
         objid_ := NULL;
         objversion_ := NULL;
         disabled_component_ := disabled_component_;
         SELECT ('<' || data_source_root_ ||'><Name>'|| temp_ds_name_ ||'</Name><ID>'||id_||
               '</ID><DisabledComponent>'||disabled_component_||'</DisabledComponent></' || data_source_root_ || '>') INTO datasource_ FROM dual;
END Load_Datasource_Internal___;
   
PROCEDURE Load_Element_Internal___ (
   id_   IN     VARCHAR2,
   objid_ OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   element_    OUT NOCOPY CLOB,
   disabled_component_ OUT VARCHAR2)
IS
   CURSOR get_element_ IS
   SELECT value, objid, objversion
   FROM  COMPOSITE_PAGE_ELEMENT
   WHERE id  =  id_;
   disabled_component_ds_ VARCHAR2(20);
   temp_obj_id_ds_ VARCHAR2(50);
   temp_obj_version_ds_ VARCHAR2(50);
   temp_datasource_ds_ CLOB;
   temp_element_name_ VARCHAR2(100);
   data_source_id_ VARCHAR2(100);
   e_disabled_component EXCEPTION;
   element_title_xml_ xmlType;   
   element_xml_ xmlType;
BEGIN
   disabled_component_ := NULL;
   OPEN get_element_;
   FETCH get_element_ INTO element_, objid_, objversion_;
   CLOSE get_element_;
   
   IF(NVL(objid_, 'NULL') = 'NULL') THEN
      select value,component into element_,disabled_component_ from COMPOSITE_PAGE_ELEMENT_TAB where Id = id_;      
      IF(NVL(disabled_component_, 'NULL') = 'NULL') THEN
         disabled_component_ := NULL;
      ELSE
         element_title_xml_ := element_xml_.extract('//Title/text()');
         IF element_title_xml_ IS NOT NULL THEN
            temp_element_name_ := element_title_xml_.getStringVal();
         ELSE
            temp_element_name_ := '';
         END IF;
        
         RAISE e_disabled_component;
      END IF;
   ELSE 
      element_xml_ := Xmltype(element_);
   END IF;
   IF (element_xml_.existsNode('/*/DataSourceId') = 1) THEN
      data_source_id_ := element_xml_.extract('//DataSourceId/text()').getStringVal();  
      Load_Datasource_Internal___(data_source_id_, temp_obj_id_ds_, temp_obj_version_ds_, temp_datasource_ds_, disabled_component_ds_);
      
      IF(NVL(temp_datasource_ds_, 'NULL') != 'NULL' AND XmlType(temp_datasource_ds_).existsNode('/ProjectionDataSource') = 1) THEN
         select InsertChildXML(element_xml_,'/*','ProjectionDataSource', XmlType(temp_datasource_ds_)) into element_xml_ from dual;
         element_ := element_xml_.getClobVal();
      END IF;
      
      IF(NVL(disabled_component_ds_, 'NULL') = 'NULL') THEN
         disabled_component_ := NULL;
      ELSE
         element_title_xml_ := Xmltype(element_).extract('//Title/text()');
         IF element_title_xml_ IS NOT NULL THEN
            temp_element_name_ := element_title_xml_.getStringVal();
         ELSE
            temp_element_name_ := '';
         END IF;
         disabled_component_ := disabled_component_ds_;

         RAISE e_disabled_component;
      END IF;    

   END IF;
   
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         NULL;
      WHEN e_disabled_component THEN
         objid_ := NULL;
         objversion_ := NULL;
         SELECT ('<Text><Title>'|| temp_element_name_ ||'</Title><ID>'||id_||
               '</ID><DisabledComponent>'||disabled_component_||'</DisabledComponent></Text>') INTO element_ FROM dual;
END Load_Element_Internal___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Load_Element (
   id_         IN     VARCHAR2,
   element_       OUT NOCOPY CLOB,
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2
   )
IS
BEGIN
    select value,objid,objversion into element_,objid_,objversion_ from composite_page_element where id=id_;
END Load_Element;

PROCEDURE Load_Page (
   id_   IN     VARCHAR2,
   page_    OUT NOCOPY CLOB)
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(100);
BEGIN
   Load_Page(id_,page_,objid_,objversion_);
END Load_Page;

PROCEDURE Load_Page_Light(
   id_         IN     VARCHAR2,
   page_          OUT NOCOPY CLOB,
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2)
IS
BEGIN
   Load_Page_Internal___(id_, page_, TRUE, FALSE, objid_, objversion_);
END Load_Page_Light;

PROCEDURE Load_Page (
   id_         IN     VARCHAR2,
   page_          OUT NOCOPY CLOB,
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2)
IS
BEGIN
   Load_Page_Internal___(id_, page_, FALSE, FALSE, objid_, objversion_);
END Load_Page;

PROCEDURE Load_Page_With_Translations (
   id_         IN     VARCHAR2,
   page_          OUT NOCOPY CLOB,
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2)
IS
BEGIN
   Load_Page_Internal___(id_, page_, FALSE, TRUE, objid_, objversion_);
END Load_Page_With_Translations;

PROCEDURE Import_Page(
   id_   IN     VARCHAR2,
   page_ IN     CLOB)
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(100);
   
BEGIN
   IF (Check_Page_Exist___(id_)) THEN
    select rowid,to_char(rowversion,'YYYYMMDDHH24MISS') into objid_,objversion_ from composite_page_tab t where id=id_;
   END IF;
   Save_Page_Internal___(id_,page_,objid_,objversion_,TRUE);
END Import_Page;

PROCEDURE Save_Page(
   id_         IN     VARCHAR2,
   page_       IN     CLOB,
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2
   )
IS
BEGIN
   Save_Page_Internal___(id_,page_,objid_,objversion_,TRUE);
END Save_Page;

PROCEDURE Save_Page(
   id_         IN     VARCHAR2,
   page_       IN     CLOB,
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   clienttype_ IN VARCHAR2
   )
IS
BEGIN
   Save_Page_Internal___(id_,page_,objid_,objversion_,TRUE);
   update composite_page_tab set client_type = clienttype_ WHERE id=id_;
END Save_Page;  

PROCEDURE Save_Complete_Page(
   id_         IN     VARCHAR2,
   page_       IN     CLOB,
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2
   )
IS
BEGIN
   Save_Page_Internal___(id_,page_,objid_,objversion_,FALSE);
END Save_Complete_Page;

PROCEDURE Save_Complete_Page(
   id_         IN     VARCHAR2,
   page_       IN     CLOB,
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   clienttype_ IN     VARCHAR2
   )
IS
BEGIN
   Save_Page_Internal___(id_,page_,objid_,objversion_,FALSE);
   update composite_page_tab set client_type = clienttype_ WHERE id=id_;
END Save_Complete_Page;

PROCEDURE Remove_Page(
   id_         IN     VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN     VARCHAR2 
   )
IS
   info_        VARCHAR2(100);
   
BEGIN
   composite_page_api.Remove__(info_,objid_,objversion_,'DO');
END Remove_Page;

PROCEDURE Import_Data_Source (
   id_         IN     VARCHAR2,
   datasource_ IN     CLOB ) 
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(100);
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   component_           XMLType;
   component_name_      VARCHAR2(6);
   parsed_xml_          XMLType;
BEGIN
   parsed_xml_ := XMLType(datasource_);
   component_ := parsed_xml_.Extract('/*/Component/text()'); 
   IF (component_ IS NOT NULL) THEN
      component_name_ := component_.getStringVal();
      Client_SYS.Add_To_Attr('COMPONENT',component_name_,attr_);
   END IF;
   IF ( NOT Check_Data_Source_Exist___(id_)) THEN
      composite_page_data_source_api.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('ID',id_,attr_);
      composite_page_data_source_api.New__(info_, objid_, objversion_,attr_, 'DO');
   ELSE 
      select rowid,to_char(rowversion,'YYYYMMDDHH24MISS') into objid_,objversion_ from composite_page_data_source_tab t where id=id_;
   END IF;
   Composite_Page_Data_Source_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   Composite_Page_Data_Source_API.Write_Value__(objversion_, objid_, datasource_);
   Create_PO_For_Data_Source___(id_,datasource_);
END Import_Data_Source;

PROCEDURE Save_Data_Source (
   id_         IN     VARCHAR2,
   datasource_ IN     CLOB,
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2 
   ) 
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   component_           XMLType;
   component_name_      VARCHAR2(6);
   parsed_xml_          XMLType;
BEGIN
   parsed_xml_ := XMLType(datasource_);
   component_ := parsed_xml_.Extract('/*/Component/text()'); 
   IF (component_ IS NOT NULL) THEN
      component_name_ := component_.getStringVal();
      Client_SYS.Add_To_Attr('COMPONENT',component_name_,attr_);
   END IF;
   IF ( NOT Check_Data_Source_Exist___(id_)) THEN
      composite_page_data_source_api.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('ID',id_,attr_);
      Client_SYS.Add_To_Attr('COMPONENT',component_name_,attr_);
      composite_page_data_source_api.New__(info_, objid_, objversion_,attr_, 'DO');
   END IF;
   composite_page_data_source_api.Modify__(info_,objid_,objversion_,attr_,'DO');
   Composite_Page_Data_Source_API.Write_Value__(objversion_, objid_, datasource_);
   Create_PO_For_Data_Source___(id_,datasource_);
   Fnd_Admin_Jms_API.Send_Jms_Message('CLEAR_LOBBY_CACHE', 'ALL' , 'ifsapp-int');
END Save_Data_Source;


PROCEDURE Save_Element (
   id_         IN     VARCHAR2,
   element_    IN     CLOB,
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2
   ) 
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   component_           XMLType;
   component_name_      VARCHAR2(6);
   parsed_xml_          XMLType;
BEGIN
   parsed_xml_ := XMLType(element_);
   component_ := parsed_xml_.Extract('/*/Component/text()'); 
   IF (component_ IS NOT NULL) THEN
      component_name_ := component_.getStringVal();
      Client_SYS.Add_To_Attr('COMPONENT',component_name_,attr_);
   END IF;
   IF ( NOT Check_Element_Exist___(id_)) THEN
      composite_page_element_api.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('ID',id_,attr_);
      Client_SYS.Add_To_Attr('COMPONENT',component_name_,attr_);
      composite_page_element_api.New__(info_, objid_, objversion_,attr_, 'DO');
   ELSE 
      select objid,objversion into objid_,objversion_ from composite_page_element t where id=id_;
   END IF;
   composite_page_element_api.Modify__(info_,objid_,objversion_,attr_,'DO');
   Composite_Page_Element_API.Write_Value__(objversion_, objid_, element_);
   Create_PO_For_Element___(id_,element_);
   Fnd_Admin_Jms_API.Send_Jms_Message('CLEAR_LOBBY_CACHE', 'ALL' , 'ifsapp-int');
END Save_Element;

PROCEDURE Save_Element (
   id_         IN     VARCHAR2,
   element_    IN     CLOB,
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   clienttype_ IN     VARCHAR2
   ) 
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   component_           XMLType;
   component_name_      VARCHAR2(6);
   parsed_xml_          XMLType;
BEGIN
   parsed_xml_ := XMLType(element_);
   component_ := parsed_xml_.Extract('/*/Component/text()'); 
   IF (component_ IS NOT NULL) THEN
      component_name_ := component_.getStringVal();
      Client_SYS.Add_To_Attr('COMPONENT',component_name_,attr_);
   END IF;
   IF ( NOT Check_Element_Exist___(id_)) THEN
      composite_page_element_api.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('ID',id_,attr_);
      composite_page_element_api.New__(info_, objid_, objversion_,attr_, 'DO');
   END IF;
   composite_page_element_api.Modify__(info_,objid_,objversion_,attr_,'DO');
   Composite_Page_Element_API.Write_Value__(objversion_, objid_, element_);
   update composite_page_element_tab set client_type = clienttype_ WHERE id=id_;
   Create_PO_For_Element___(id_,element_);
   Fnd_Admin_Jms_API.Send_Jms_Message('CLEAR_LOBBY_CACHE', 'ALL' , 'ifsapp-int');
END Save_Element;

PROCEDURE Import_Element (
   id_      IN     VARCHAR2,
   element_ IN     CLOB
   ) 
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   objid_          VARCHAR2(100);
   objversion_     VARCHAR2(100);
   component_           XMLType;
   component_name_      VARCHAR2(6);
   parsed_xml_          XMLType;
BEGIN
   parsed_xml_ := XMLType(element_);
   component_ := parsed_xml_.Extract('/*/Component/text()'); 
   IF (component_ IS NOT NULL) THEN
      component_name_ := component_.getStringVal();
      Client_SYS.Add_To_Attr('COMPONENT',component_name_,attr_);
   END IF;
   IF ( NOT Check_Element_Exist___(id_)) THEN
      composite_page_element_api.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr('ID',id_,attr_);
      composite_page_element_api.New__(info_, objid_, objversion_,attr_, 'DO');
   ELSE 
      select rowid,to_char(rowversion,'YYYYMMDDHH24MISS') into objid_,objversion_ from composite_page_element_tab t where id=id_;
   END IF;
   Composite_page_element_api.Modify__(info_,objid_,objversion_,attr_,'DO');
   Composite_Page_Element_API.Write_Value__(objversion_, objid_, element_);
   Create_PO_For_Element___(id_,element_);
   Set_Client_Type(id_);
END Import_Element;

PROCEDURE Set_Client_Type(
   id_         IN VARCHAR2)
IS
   clienttype_ VARCHAR2(20);
   settype_    VARCHAR2(20);
BEGIN
   SELECT (extractvalue(xmltype(value), '/*/ClientType')) INTO clienttype_
   FROM composite_page_element_tab
   WHERE id = id_;
   settype_ := '';
   IF clienttype_ = CLIENT_TYPE_API.DB_WEB THEN
      settype_ := CLIENT_TYPE_API.DB_WEB;
   END IF;
   IF clienttype_ = CLIENT_TYPE_API.DB_WEB_B2B THEN
      settype_ := CLIENT_TYPE_API.DB_WEB_B2B;
   END IF;
   -- if other/no client type in clob - leave blank
   UPDATE composite_page_element_tab SET client_type = settype_ WHERE id = id_;
  END Set_Client_Type;


PROCEDURE Remove_Data_Source(
   id_         IN     VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN     VARCHAR2
   )
IS
   info_        VARCHAR2(100);
BEGIN
   composite_page_data_source_api.Remove__(info_,objid_,objversion_,'DO');
END Remove_Data_Source;


PROCEDURE Remove_Element(
   id_         IN     VARCHAR2, 
   objid_      IN     VARCHAR2,
   objversion_ IN     VARCHAR2
   )
IS
   info_        VARCHAR2(100);
BEGIN
   composite_page_element_api.Remove__(info_,objid_,objversion_,'DO');
END Remove_Element;

PROCEDURE Remove_Lobby_Objects(
   component_         IN     VARCHAR2
   )
IS
BEGIN
   DELETE FROM composite_page_tab WHERE component = component_;
   DELETE FROM composite_page_data_source_tab WHERE component = component_;
   DELETE FROM composite_page_element_tab WHERE component = component_;
END Remove_Lobby_Objects;

PROCEDURE Load_Datasource (
   id_   IN     VARCHAR2,
   objid_ OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   datasource_    OUT NOCOPY CLOB,
   disabled_component_ OUT VARCHAR2)
IS
   
BEGIN
   Load_Datasource_Internal___(id_, objid_, objversion_, datasource_, disabled_component_);
END Load_Datasource;

PROCEDURE Load_Element (
   id_   IN     VARCHAR2,
   objid_ OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   element_    OUT NOCOPY CLOB,
   disabled_component_ OUT VARCHAR2)
IS
   
BEGIN
   Load_Element_Internal___(id_, objid_, objversion_, element_, disabled_component_);
END Load_Element;
