-----------------------------------------------------------------------------
--
--  Logical unit: ClientProfileNode
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191202  ratslk  TSMI-65: Profile Details
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Delete_All_Values (
   profile_id_  IN Client_Profile_Node_Tab.profile_id%TYPE)
IS
BEGIN
   DELETE
   FROM  Client_Profile_Node_Tab
   WHERE profile_id = profile_id_;
END Delete_All_Values;

FUNCTION Generate_XML_Name_For_Node(
   profile_id_  IN Client_Profile_Node_Tab.profile_id%TYPE,
   parent_      IN Client_Profile_Node_Tab.parent%TYPE) RETURN VARCHAR2
IS
   file_name_ VARCHAR2(100);
BEGIN
   file_name_ := 'Profile_' || Fndrr_Client_Profile_API.Get_Profile_Name(profile_id_) || '-Folder_' 
                            || parent_                                                || '-' 
                            || to_char(sysdate, 'YYYY-MM-DD')                         || '.xml';
                           
   RETURN file_name_;
END Generate_XML_Name_For_Node;

FUNCTION Generate_XML_Data_For_Node (
	profile_id_      IN Client_Profile_Node_Tab.profile_id%TYPE,
   current_section_ IN Client_Profile_Node_Tab.parent_section%TYPE,
   profile_section_ IN Client_Profile_Node_Tab.parent_section%TYPE DEFAULT NULL) RETURN BLOB
IS
   parent_            Client_Profile_Node_Tab.parent%TYPE;
   xml_type_          XMLTYPE;
   file_data_         BLOB;
   newrec_            Fndrr_Client_Profile_Tab%ROWTYPE;
BEGIN
   FOR mainrec_  IN  (SELECT * 
                        FROM CLIENT_PROFILE_NODE_FULL
                        WHERE profile_id=profile_id_ 
                        AND  (profile_section_ IS  NULL OR profile_section LIKE 
                                 (SELECT parent_section || '%' FROM CLIENT_PROFILE_NODE_FULL 
                                  WHERE profile_id=profile_id_
                                  AND profile_section=profile_section_
                                  AND depth=(SELECT MAX(depth) FROM CLIENT_PROFILE_NODE_FULL 
                                             WHERE profile_id=profile_id_
                                             AND   profile_section=profile_section_)
                                             AND ROWNUM=1))
                        AND   (current_section_   IS  NULL OR profile_section LIKE current_section_ || '%')
                      ) LOOP
      SELECT  
         xmlconcat(xml_type_,
            xmlelement("CLIENT_PROFILE_NODE", 
               xmlattributes('queried'                     AS "state",  
                              mainrec_.value_objversion    AS "OBJ_VERSION"
               ),
               xmlconcat(   
                   xmlelement("PARENT_SECTION",       xmlattributes('Text'        AS "datatype"),   mainrec_.parent_section),
                   xmlelement("PROFILE_SECTION",      xmlattributes('Text'        AS "datatype"),   mainrec_.profile_section),
                   xmlelement("PROFILE_ENTRY",        xmlattributes('Text'        AS "datatype"),   mainrec_.profile_entry),
                   xmlelement("PROFILE_VALUE",        xmlattributes('Text'        AS "datatype"),   mainrec_.profile_value),
                   xmlelement("CATEGORY",             xmlattributes('Text'        AS "datatype"),   mainrec_.category),
                   xmlelement("OVERRIDE_ALLOWED",     xmlattributes('Boolean'     AS "datatype"),   mainrec_.override_allowed),
                   xmlelement("MODIFIED_DATE",        xmlattributes('Timestamp'   AS "datatype"),   mainrec_.modified_date),
                   xmlelement("DEPTH",                xmlattributes('Number'      AS "datatype"),   mainrec_.depth),
                   xmlelement("PARENT",               xmlattributes('Text'        AS "datatype"),   mainrec_.parent), 
                   xmlelement("CHILD",                xmlattributes('Text'        AS "datatype"),   mainrec_.child) 
               )
            )
         )
      INTO xml_type_
      FROM dual; 
         
      newrec_.rowversion    := mainrec_.profile_objversion;
      newrec_.profile_name  := mainrec_.profile_name;
      newrec_.owner         := mainrec_.owner;
      parent_               := mainrec_.parent;
   END LOOP;
      
   SELECT xmlelement("CLIENT_PROFILE_NODE_LIST",
                        xmlattributes('queried'                                                          AS "state",  
                                      newrec_.rowversion                                                 AS "OBJ_VERSION",
                                      profile_id_                                                        AS "PROFILE_ID",
                                      newrec_.profile_name                                               AS "PROFILE_NAME",
                                      newrec_.owner                                                      AS "OWNER",
                                      (SELECT NVL(profile_section_, current_section_) FROM dual)         AS "CURRENT_SECTION",
                                      parent_                                                            AS "PARENT"
                                      ),
                        xml_type_)
   INTO xml_type_
   FROM dual;
      
   file_data_ := xml_type_.getBlobVal(873);
   
   RETURN file_data_;
END Generate_XML_Data_For_Node;

FUNCTION Generate_XML_Name_For_Leaf(
   profile_id_           IN Client_Profile_Node_Tab.profile_id%TYPE,
   profile_section_      IN Client_Profile_Node_Tab.profile_section%TYPE) RETURN VARCHAR2
IS
   file_name_ VARCHAR2(100);
BEGIN
   file_name_ := 'Profile_' || Fndrr_Client_Profile_API.Get_Profile_Name(profile_id_) || '-Folder_' 
                            || REGEXP_SUBSTR(profile_section_, '[^/]\w+$', 1)         || '-' 
                            || to_char(sysdate, 'YYYY-MM-DD')                         || '.xml';
   RETURN file_name_;
END Generate_XML_Name_For_Leaf;

FUNCTION Generate_XML_Data_For_Leaf (
	profile_id_      IN Client_Profile_Node_Tab.profile_id%TYPE,
   profile_section_ IN Client_Profile_Node_Tab.parent_section%TYPE) RETURN BLOB
IS
BEGIN
   RETURN Generate_XML_Data_For_Node(profile_id_, NULL, profile_section_);
END Generate_XML_Data_For_Leaf;

FUNCTION Generate_XML_Data (
	profile_id_      IN Client_Profile_Node_Tab.profile_id%TYPE) RETURN BLOB
IS
BEGIN
   RETURN Generate_XML_Data_For_Node(profile_id_, NULL);
END Generate_XML_Data;

PROCEDURE Import_XML_Data (
   profile_id_            IN  VARCHAR2,
   data_                  IN  XMLTYPE)
IS
   node_rec_                  client_profile_node_tab%ROWTYPE;
   profile_value_rec_         fndrr_client_profile_value_tab%ROWTYPE;

   CURSOR get_profile_content(xml_ IN Xmltype) IS
       SELECT xt.*
        FROM dual,
             XMLTABLE('/CLIENT_PROFILE_NODE_LIST/CLIENT_PROFILE_NODE'
                     PASSING xml_
                     COLUMNS
                       PARENT_SECTION       VARCHAR2(1000)  PATH 'PARENT_SECTION',
                       PROFILE_SECTION      VARCHAR2(1000)  PATH 'PROFILE_SECTION',
                       PROFILE_ENTRY        VARCHAR2(200)   PATH 'PROFILE_ENTRY',
                       PROFILE_VALUE        VARCHAR2(4000)  PATH 'PROFILE_VALUE',
                       CATEGORY             VARCHAR2(200)   PATH 'CATEGORY',
                       OVERRIDE_ALLOWED     NUMBER          PATH 'OVERRIDE_ALLOWED', 
                       MODIFIED_DATE        DATE            PATH 'MODIFIED_DATE',
                       DEPTH                NUMBER          PATH 'DEPTH',
                       PARENT               VARCHAR2(200)   PATH 'PARENT',
                       CHILD                VARCHAR2(200)   PATH 'CHILD'
                    ) xt;
BEGIN
   profile_value_rec_.profile_id := profile_id_;
   node_rec_.profile_id          := profile_id_;
  
   FOR rec_ IN get_profile_content(data_) LOOP
         node_rec_.parent_section                   := rec_.PARENT_SECTION;
         node_rec_.profile_section                  := rec_.PROFILE_SECTION;
         node_rec_.depth                            := rec_.DEPTH;
         node_rec_.parent                           := rec_.PARENT;
         node_rec_.child                            := rec_.CHILD;

         IF NOT Check_Exist___(node_rec_.profile_id, node_rec_.profile_section, node_rec_.parent, node_rec_.depth) THEN
            New___(node_rec_);
         END IF;   

         profile_value_rec_.profile_section         := rec_.PROFILE_SECTION;
         profile_value_rec_.profile_entry           := rec_.PROFILE_ENTRY;
         profile_value_rec_.profile_value           := rec_.PROFILE_VALUE;
         profile_value_rec_.category                := rec_.CATEGORY;
         profile_value_rec_.override_allowed        := rec_.OVERRIDE_ALLOWED;
         profile_value_rec_.modified_date           := rec_.MODIFIED_DATE;

         Client_Profile_Value_API.Import_Values(profile_value_rec_);
   END LOOP;
END Import_XML_Data;


FUNCTION Is_Leaf_Node (
   profile_id_        IN  Client_Profile_Node_Tab.profile_id%TYPE,
   parent_            IN  Client_Profile_Node_Tab.parent%TYPE,
   depth_             IN  Client_Profile_Node_Tab.depth%TYPE) RETURN VARCHAR2
IS
   is_leaf_               VARCHAR2(5);
BEGIN
	SELECT 
      (CASE 
         WHEN count(child) = 0 THEN 'TRUE'
         ELSE                       'FALSE'
      END)
      INTO is_leaf_
      FROM Client_Profile_Node
      WHERE 
      profile_id   = profile_id_ 
      AND   parent = parent_ 
      AND   depth  = depth_;
	RETURN is_leaf_;
END Is_Leaf_Node;
