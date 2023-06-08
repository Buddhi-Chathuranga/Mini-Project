-----------------------------------------------------------------------------
--
--  Logical unit: ReportDataServiceUtil
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
TYPE Node_Array              IS VARRAY (100) OF Dbms_Xmldom.DOMNode;
TYPE Complex_Addresses_Array IS VARRAY (500) OF VARCHAR2(1000);
TYPE Xml_Row_Item            IS RECORD(
   complex_path    VARCHAR2(1000),
   column_name     VARCHAR2(100),
   data_type       VARCHAR2(100) );
TYPE Xml_Row_Items           IS VARRAY (1000) OF Xml_Row_Item;
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
FUNCTION Get_Xpath_Address_Id___(
   node_ IN  Dbms_Xmldom.DOMNode) RETURN VARCHAR2
IS 
   parent_node_     Dbms_Xmldom.DOMNode;
   xpath_address_   VARCHAR2(4000);
BEGIN
   BEGIN
      parent_node_ := Dbms_Xmldom.Getparentnode(node_);
      IF(Dbms_Xmldom.Isnull(parent_node_))THEN
         RETURN '/' || Dbms_Xmldom.Getnodename(node_);
      END IF;
      xpath_address_ := Get_Xpath_Address_Id___(parent_node_) || '/' || Dbms_Xmldom.Getnodename(parent_node_);
      Free_Xml_Dom_Construct___(node_ => parent_node_);      
      RETURN xpath_address_;
   EXCEPTION 
      WHEN OTHERS THEN
         Free_Xml_Dom_Construct___(node_ => parent_node_);
         RAISE;
   END;
END Get_Xpath_Address_Id___;

PROCEDURE Add_Data___(
   xml_row_item_array_  IN OUT   Xml_Row_Items,
   complex_path_        IN       VARCHAR2,
   column_name_         IN       VARCHAR2,
   data_type_           IN       VARCHAR2)
IS
   xml_row_item_        Xml_Row_Item;
   count_               NUMBER ;
   data_type_local_     VARCHAR2(1000);
BEGIN
   data_type_local_ := data_type_;
   IF data_type_ IS null THEN
      data_type_local_ := 'xs:string';
   END IF;
   count_                           := xml_row_item_array_.COUNT;
   xml_row_item_.complex_path       := complex_path_;
   xml_row_item_.column_name        := column_name_;
   xml_row_item_.data_type          := data_type_local_;
   xml_row_item_array_.extend;
   xml_row_item_array_(count_ + 1)  := xml_row_item_; 
END Add_Data___;

PROCEDURE Append_Doc_Segment___(
   out_doc_             IN OUT   Dbms_Xmldom.DOMDocument,
   root_node_           IN OUT   Dbms_Xmldom.DOMNode,
   report_id_           IN       VARCHAR2,
   report_archive_doc_  IN       Dbms_Xmldom.DOMDocument, 
   node_name_           IN       VARCHAR2)
IS  
   node_list_           Dbms_Xmldom.DOMNodeList;
   segment_             Dbms_Xmldom.DOMNode;
   segment_clone_       Dbms_Xmldom.DOMNode;
   return_node_         Dbms_Xmldom.DOMNode;
   node_name_concat_    VARCHAR2(2000);
   element_             Dbms_Xmldom.DOMElement;
BEGIN  
   BEGIN
      IF(UPPER(node_name_) = 'PROCESSING_INFO') THEN 
         node_name_concat_ := node_name_;       
      ELSE 
         node_name_concat_ := report_id_ || node_name_;
      END IF;
      node_list_ := Dbms_Xmldom.Getelementsbytagname(report_archive_doc_, node_name_concat_);
      segment_ := Dbms_Xmldom.item(node_list_, 0);
      segment_clone_ := Dbms_Xmldom.Clonenode(segment_, true);
      segment_clone_ := Dbms_Xmldom.Adoptnode(out_doc_, segment_clone_);   
      element_ := Dbms_Xmldom.Makeelement(segment_clone_);
      Dbms_Xmldom.Removeattribute(element_,'xmlns');
      return_node_ := Dbms_Xmldom.Makenode(element_);   
      return_node_ := Dbms_Xmldom.Appendchild(root_node_, return_node_);

      Free_Xml_Dom_Construct___(node_ => segment_);
      Free_Xml_Dom_Construct___(node_ => segment_clone_);
      Free_Xml_Dom_Construct___(node_ => return_node_);
      Free_Xml_Dom_Construct___(element_ => element_);
      Free_Xml_Dom_Construct___(list_ => node_list_);
   EXCEPTION 
      WHEN OTHERS THEN
         Free_Xml_Dom_Construct___(node_ => segment_);
         Free_Xml_Dom_Construct___(node_ => segment_clone_);
         Free_Xml_Dom_Construct___(node_ => return_node_);
         Free_Xml_Dom_Construct___(element_ => element_);
         Free_Xml_Dom_Construct___(list_ => node_list_);
         RAISE;
   END;
   
END Append_Doc_Segment___;

   
PROCEDURE Append_Data_Block_Segment___(
   row_index_              IN OUT   NUMBER,
   xml_row_item_array_     IN OUT   Xml_Row_Items,
   out_doc_                IN OUT   Dbms_Xmldom.DOMDocument,
   from_parent_node_map_   IN       Node_Array,
   current_complex_node_   IN       Dbms_Xmldom.DOMNode,
   complex_node_           IN       Dbms_Xmldom.DOMNode,
   report_id_              IN       VARCHAR2)
IS  
   node_                   Dbms_Xmldom.DOMNode;
   complex_node_map_       Node_Array := Node_Array();
   simple_node_map_        Node_Array := Node_Array();
   local_parent_node_map_  Node_Array := Node_Array();
   document_               Dbms_Xmldom.DOMDocument;
   element_                Dbms_Xmldom.DOMElement;
   element_node_           Dbms_Xmldom.DOMNode;
   element_node_type_      PLS_INTEGER :=1;
   temp_node_              Dbms_Xmldom.DOMNode;
   complex_node_local_     Dbms_Xmldom.DOMNode;
   counter1_               INTEGER := 0; 
   counter2_               INTEGER := 0; 
   counter3_               INTEGER;
   complex_addresses_      Complex_Addresses_Array := Complex_Addresses_Array();
   found_count_            NUMBER;
      
BEGIN  
   BEGIN
      local_parent_node_map_ := from_parent_node_map_;
      counter3_              := from_parent_node_map_.COUNT;
      complex_node_local_    := complex_node_;
      FOR cur_node IN 0 .. Dbms_Xmldom.Getlength(Dbms_Xmldom.Getchildnodes(current_complex_node_)) - 1 LOOP
         node_ := Dbms_Xmldom.item(Dbms_Xmldom.Getchildnodes(current_complex_node_), cur_node);
         IF(Dbms_Xmldom.Getnodetype(node_) = element_node_type_) THEN
            IF(  (Dbms_Xmldom.Getlength(Dbms_Xmldom.Getchildnodes(node_)) <= 1) AND 
                 (
                     (Dbms_Xmldom.Isnull(Dbms_Xmldom.Getfirstchild(node_)) = TRUE )
                      OR 
                     (Dbms_Xmldom.Getnodetype(Dbms_Xmldom.Getfirstchild(node_)) = 3))) THEN
               counter1_                   := counter1_ + 1;
               simple_node_map_.extend; 
               simple_node_map_(counter1_) := node_;
            ELSE 
               IF(   (Dbms_Xmldom.Isnull(Dbms_Xmldom.Getfirstchild(node_)) = FALSE) AND
                     (  (  (Dbms_Xmldom.Isnull(Dbms_Xmldom.Getattributes(Dbms_Xmldom.Getfirstchild(node_))) = FALSE ) AND
                           (Dbms_Xmldom.Isnull(Dbms_Xmldom.Getnameditem(Dbms_Xmldom.Getattributes(Dbms_Xmldom.Getfirstchild(node_)),'xsi:nil')) = FALSE ))
                        OR
                        (  (Dbms_Xmldom.Isnull(Dbms_Xmldom.Getfirstchild(Dbms_Xmldom.Getfirstchild(node_))) = FALSE ) AND
                           (Dbms_Xmldom.Getnodetype(Dbms_Xmldom.Getfirstchild(Dbms_Xmldom.Getfirstchild(node_))) = 3))))THEN
                  document_      := Dbms_Xmldom.Getownerdocument(node_);
                  element_       := Dbms_Xmldom.Createelement(document_, '_' || Dbms_Xmldom.Getnodename(node_));
                  element_node_  := Dbms_Xmldom.Makenode(element_);
                  Get_Address_Id___(found_count_, complex_addresses_, node_);
                  temp_node_     := Dbms_Xmldom.Appendchild(element_node_, Dbms_Xmldom.Makenode(Dbms_Xmldom.Createtextnode(document_, to_char(found_count_))));
                  found_count_   := 0;
                  temp_node_     := Dbms_Xmldom.Insertbefore(node_,element_node_,Dbms_Xmldom.Getfirstchild(node_));
               END IF;
               counter2_         := counter2_ + 1;
               complex_node_map_.extend; 
               complex_node_map_(counter2_) := node_;
            END IF; 
         END IF;   
      END LOOP;
      FOR i_ IN 1..simple_node_map_.COUNT LOOP
         local_parent_node_map_.extend;
         local_parent_node_map_(counter3_ + i_) := simple_node_map_(i_);
      END LOOP;
      IF(simple_node_map_.COUNT>0)THEN
         Xml_Out___(row_index_, xml_row_item_array_, complex_node_local_, out_doc_, local_parent_node_map_);
      END IF;

      FOR i_ IN 1..complex_node_map_.COUNT LOOP
         Append_Data_Block_Segment___(row_index_, xml_row_item_array_, out_doc_, local_parent_node_map_, complex_node_map_(i_), complex_node_, report_id_);
      END LOOP;
      Free_Xml_Dom_Construct___(node_ => node_);
      Free_Xml_Dom_Construct___(node_ => element_node_);
      Free_Xml_Dom_Construct___(node_ => temp_node_);
      Free_Xml_Dom_Construct___(element_ => element_);
   EXCEPTION 
      WHEN OTHERS THEN
         Free_Xml_Dom_Construct___(node_ => node_);
         Free_Xml_Dom_Construct___(node_ => element_node_);
         Free_Xml_Dom_Construct___(node_ => temp_node_);
         Free_Xml_Dom_Construct___(element_ => element_);
         Free_Xml_Dom_Construct___(doc_ => document_);
         Free_Xml_Dom_Construct___(node_ => complex_node_local_);
         RAISE;
   END;
END Append_Data_Block_Segment___;

PROCEDURE Append_Translation_Segment___(
   root_node_           IN OUT   Dbms_Xmldom.DOMNode,
   out_doc_             IN OUT   Dbms_Xmldom.DOMDocument,
   report_archive_doc_  IN       Dbms_Xmldom.DOMDocument,
   report_id_           IN       VARCHAR2,
   node_name_           IN       VARCHAR2)
IS  
   node_list_           Dbms_Xmldom.DOMNodeList;
   rt_node_             Dbms_Xmldom.DOMNode;
   adt_node_            Dbms_Xmldom.DOMNode;
   segment_             Dbms_Xmldom.DOMNode;
   return_node_         Dbms_Xmldom.DOMNode;
   node_name_concat_    VARCHAR2(2000);
   element_             Dbms_Xmldom.DOMElement;
   element_node_        Dbms_Xmldom.DOMNode;
   child_element_       Dbms_Xmldom.DOMElement;
   child_element_node_  Dbms_Xmldom.DOMNode;   
BEGIN
   BEGIN
      node_name_concat_ := report_id_ || node_name_;  
      node_list_        := Dbms_Xmldom.Getelementsbytagname(report_archive_doc_, node_name_concat_);
      segment_          := Dbms_Xmldom.item(node_list_, 0); 
      element_          := Dbms_Xmldom.Createelement(out_doc_, node_name_concat_);
      element_node_     := Dbms_Xmldom.Makenode(element_);

      FOR i_ IN 0..Dbms_Xmldom.Getlength(Dbms_Xmldom.Getchildnodes(segment_))-1 LOOP      
         IF(UPPER(Dbms_Xmldom.Getnodename(Dbms_Xmldom.Item(Dbms_Xmldom.Getchildnodes(segment_), i_))) = 'REPORT_TEXTS') THEN
            rt_node_              := Dbms_Xmldom.Item(Dbms_Xmldom.Getchildnodes(segment_), i_);
            FOR j_ IN 0..Dbms_Xmldom.Getlength(Dbms_Xmldom.Getchildnodes(rt_node_))-1 LOOP
              child_element_      := Dbms_Xmldom.Createelement(out_doc_, 'REPORT_TEXTS_' || Dbms_Xmldom.Getnodename(Dbms_Xmldom.Item(Dbms_Xmldom.Getchildnodes(rt_node_), j_)));
              child_element_node_ := Dbms_Xmldom.Makenode(child_element_);
              return_node_        := Dbms_Xmldom.Appendchild(child_element_node_, Dbms_Xmldom.Makenode(Dbms_Xmldom.Createtextnode(out_doc_,Dbms_Xmldom.Getnodename(Dbms_Xmldom.Getfirstchild(Dbms_Xmldom.Item(Dbms_Xmldom.Getchildnodes(rt_node_), j_))))));
              return_node_        := Dbms_Xmldom.Appendchild(element_node_, child_element_node_);
            END LOOP;    
         ELSIF(UPPER(Dbms_Xmldom.Getnodename(Dbms_Xmldom.Item(Dbms_Xmldom.Getchildnodes(segment_), i_))) = 'ATTRIBUTE_DISPLAY_TEXTS') THEN
            adt_node_             := Dbms_Xmldom.Item(Dbms_Xmldom.Getchildnodes(segment_), i_);
            Translation_Flat___(element_node_, out_doc_, adt_node_);
         END IF;      
      END LOOP;
      return_node_ := Dbms_Xmldom.Appendchild(root_node_, element_node_);
      Free_Xml_Dom_Construct___(node_ => rt_node_);
      Free_Xml_Dom_Construct___(node_ => adt_node_);
      Free_Xml_Dom_Construct___(node_ => segment_);
      Free_Xml_Dom_Construct___(node_ => return_node_);
      Free_Xml_Dom_Construct___(node_ => element_node_);
      Free_Xml_Dom_Construct___(node_ => child_element_node_);
      Free_Xml_Dom_Construct___(element_ => element_);
      Free_Xml_Dom_Construct___(element_ => child_element_);
      Free_Xml_Dom_Construct___(list_ => node_list_);
   EXCEPTION 
      WHEN OTHERS THEN
         Free_Xml_Dom_Construct___(node_ => rt_node_);
         Free_Xml_Dom_Construct___(node_ => adt_node_);
         Free_Xml_Dom_Construct___(node_ => segment_);
         Free_Xml_Dom_Construct___(node_ => return_node_);
         Free_Xml_Dom_Construct___(node_ => element_node_);
         Free_Xml_Dom_Construct___(node_ => child_element_node_);
         Free_Xml_Dom_Construct___(element_ => element_);
         Free_Xml_Dom_Construct___(element_ => child_element_);
         Free_Xml_Dom_Construct___(list_ => node_list_);
         RAISE;
   END;
END Append_Translation_Segment___;

FUNCTION Cleanup_Address___(
   address_          IN  VARCHAR2) RETURN VARCHAR2
IS 
   cleanned_address_  VARCHAR2(1000);
BEGIN
   cleanned_address_ := REPLACE(address_ , '/#document');
   RETURN cleanned_address_;
END Cleanup_Address___;

PROCEDURE Find_Rep_Id_Node___(
   current_column_name_ IN OUT   VARCHAR2,
   current_data_type_   IN OUT   VARCHAR2,
   xml_row_item_array_  IN OUT   Xml_Row_Items,
   current_node_        IN       Dbms_Xmldom.DOMNode,
   flag_attr_           IN       BOOLEAN,
   rep_id_              IN       VARCHAR2)
IS
   node_                Dbms_Xmldom.DOMNode;
   child_nodes_         Dbms_Xmldom.DOMNodeList;
   length_              NUMBER;
   x_                   NUMBER;
   l_attrs_             Dbms_Xmldom.DOMNamedNodeMap;
   l_attr_              Dbms_Xmldom.DOMNode;
   flag_                BOOLEAN;    
BEGIN
   BEGIN
      flag_ := flag_attr_;
      IF (flag_ = FALSE OR (Dbms_Xmldom.Getnodename(current_node_) != 'report'))THEN
         child_nodes_ := Dbms_Xmldom.Getchildnodes(current_node_);
         length_      := Dbms_Xmldom.Getlength(child_nodes_);
         l_attrs_     := Dbms_Xmldom.getattributes(current_node_);
         FOR cur_attr IN 0 .. Dbms_Xmldom.getLength(l_attrs_) - 1 LOOP
            l_attr_   := Dbms_Xmldom.item(l_attrs_, cur_attr);
            IF(Dbms_Xmldom.getNodeValue(l_attr_) = rep_id_) THEN
               flag_  := true;
               Schema_Process___(current_column_name_, current_data_type_, xml_row_item_array_, '', current_node_, FALSE);  
            END IF;
         END LOOP;
         IF(length_ = 0 OR Dbms_Xmldom.Getnodename(Dbms_Xmldom.Item(child_nodes_, 0)) = 'xs:simpleType') THEN
            flag_     := true;
         END IF;
         x_           := 0;
         LOOP
            node_     := Dbms_Xmldom.Item(child_nodes_,x_);
            Find_Rep_Id_Node___(current_column_name_, current_data_type_, xml_row_item_array_, node_ , flag_, rep_id_);
            x_        := x_ + 1;
            EXIT WHEN (x_ = length_ OR flag_);
         END LOOP;
      END IF;
      Free_Xml_Dom_Construct___(node_ => node_);
      Free_Xml_Dom_Construct___(node_ => l_attr_);
      Free_Xml_Dom_Construct___(list_ => child_nodes_);
   EXCEPTION 
      WHEN OTHERS THEN
         Free_Xml_Dom_Construct___(node_ => node_);
         Free_Xml_Dom_Construct___(node_ => l_attr_);
         Free_Xml_Dom_Construct___(list_ => child_nodes_);
         RAISE;
   END;
END Find_Rep_Id_Node___;

PROCEDURE Get_Address_Id___(
   found_count_         OUT NUMBER,
   complex_addresses_   IN OUT   Complex_Addresses_Array,
   node_                IN       Dbms_Xmldom.DOMNode)
IS 
   address_             VARCHAR2(10000);
   count_               NUMBER;
BEGIN
   found_count_ := 0;
   count_       := complex_addresses_.COUNT;
   address_     := Get_Xpath_Address_Id___(node_);
   FOR i_ IN 1 .. count_  LOOP
      IF(UPPER(complex_addresses_(i_)) = UPPER(address_))THEN
         found_count_ := found_count_ + 1;
      END IF;
   END LOOP;
   complex_addresses_.extend; 
   complex_addresses_(count_ + 1):= address_;
END Get_Address_Id___;

FUNCTION Get_Column_Name___(
   node_                IN    Dbms_Xmldom.DOMNode,
   xml_row_item_array_  IN    Xml_Row_Items)RETURN VARCHAR2
IS 
   address_             VARCHAR2(1000);
   column_name_         VARCHAR2(1000):= null;
   count_               NUMBER;
   rec_                 Xml_Row_Item;
BEGIN
   count_ := xml_row_item_array_.COUNT;
   address_ := Get_Xpath_Address_Id___(node_);
   address_ := Cleanup_Address___(address_);
   FOR i_ IN 1 .. count_  LOOP
      rec_ := xml_row_item_array_(i_);
      IF(UPPER(rec_.complex_path) = UPPER(address_))THEN
         column_name_ := rec_.column_name;
      END IF;
   END LOOP;
   RETURN column_name_;
END Get_Column_Name___;

FUNCTION Get_Data_Type_Info___(
   node_                IN    Dbms_Xmldom.DOMNode,
   xml_row_item_array_  IN    Xml_Row_Items)RETURN VARCHAR2
IS 
   address_             VARCHAR2(1000);
   data_type_           VARCHAR2(1000):= null;
   count_               NUMBER;
   rec_                 Xml_Row_Item;
BEGIN
   count_   := xml_row_item_array_.COUNT;
   address_ := Get_Xpath_Address_Id___(node_);
   address_ := Cleanup_Address___(address_);
   FOR i_ IN 1 .. count_  LOOP
      rec_  := xml_row_item_array_(i_);
      IF(UPPER(rec_.complex_path) = UPPER(address_))THEN
         data_type_ := rec_.data_type;
      END IF;
   END LOOP;
   IF data_type_ IS NULL THEN
      data_type_    := 'xs:string';
   END IF;
   RETURN data_type_;
END Get_Data_Type_Info___;

FUNCTION Get_Schema___(
   report_id_        IN VARCHAR2 )RETURN Dbms_Xmldom.DOMDocument
IS
   doc_              Dbms_Xmldom.DOMDocument;
   schema_           BLOB;
   clob_             CLOB;
   CURSOR get_schema IS
      SELECT schema
      FROM   report_schema
      WHERE  Report_Id = report_id_ ;   
BEGIN
   OPEN  get_schema;
	FETCH get_schema INTO schema_;
	CLOSE get_schema;
	IF(schema_ IS NULL)THEN 
	   Error_SYS.Appl_General(lu_name_, 'ERRSCHEMA: Could not get schema for this report.');
	END IF;
   clob_      := Utility_SYS.Blob_To_Clob(schema_);
   doc_       := Dbms_Xmldom.newDOMDocument(clob_);
   RETURN doc_; 
END Get_Schema___;

PROCEDURE Schema_Process___(
   current_column_name_ IN OUT   VARCHAR2,
   current_data_type_   IN OUT   VARCHAR2,
   xml_row_item_array_  IN OUT   Xml_Row_Items,
   current_path_        IN       VARCHAR2,
   current_node_        IN       Dbms_Xmldom.DOMNode,
   flag_attr_           IN       BOOLEAN)
IS
   next_path_           VARCHAR2(10000);
   node_                Dbms_Xmldom.DOMNode;
   child_nodes_         Dbms_Xmldom.DOMNodeList;
   length_              NUMBER;
   x_                   NUMBER;
   l_attrs_             Dbms_Xmldom.DOMNamedNodeMap;
   l_attr_              Dbms_Xmldom.DOMNode;
   flag_                BOOLEAN;
    
BEGIN
   BEGIN
      flag_ := flag_attr_;
      IF (flag_ = FALSE )THEN
         child_nodes_ := Dbms_Xmldom.Getchildnodes(current_node_);
         length_      := Dbms_Xmldom.Getlength(child_nodes_);
         l_attrs_     := Dbms_Xmldom.getattributes(current_node_);
         next_path_   := current_path_;
         IF(Dbms_Xmldom.Getnodename(current_node_) = 'xs:element')THEN
            FOR cur_attr IN 0 .. Dbms_Xmldom.getLength(l_attrs_) - 1 LOOP
               l_attr_       := Dbms_Xmldom.item(l_attrs_, cur_attr);
               IF(Dbms_Xmldom.getNodeName(l_attr_) = 'name') THEN
                  next_path_ := next_path_ || '/' || Dbms_Xmldom.getNodeValue(l_attr_);
               END IF;
               IF(Dbms_Xmldom.getNodeName(l_attr_) = 'type') THEN
                  current_data_type_   := Dbms_Xmldom.getNodeValue(l_attr_);
               END IF;

               IF(Dbms_Xmldom.getNodeName(l_attr_) = 'dbColumnName') THEN
                  current_column_name_ := Dbms_Xmldom.getNodeValue(l_attr_);
               END IF;
            END LOOP;

            IF(Dbms_Xmldom.getNodeName(Dbms_Xmldom.Getfirstchild(current_node_)) != 'xs:simpleType')THEN
               Add_Data___(xml_row_item_array_,next_path_,current_column_name_,current_data_type_);
               current_data_type_   := NULL;
               current_column_name_ := NULL;
            END IF;               
         ELSIF(Dbms_Xmldom.Getnodename(current_node_) = 'xs:restriction')THEN         
            FOR cur_attr IN 0 .. Dbms_Xmldom.getLength(l_attrs_) - 1 LOOP
               l_attr_ := Dbms_Xmldom.item(l_attrs_, cur_attr);
               IF(Dbms_Xmldom.getNodeName(l_attr_) = 'base') THEN
                  current_data_type_ := Dbms_Xmldom.getNodeValue(l_attr_);
               END IF;
            END LOOP;
            Add_Data___(xml_row_item_array_,next_path_,current_column_name_,current_data_type_);
            current_data_type_   := NULL;
            current_column_name_ := NULL;         
         END IF;     
         IF(length_=0) THEN
             flag_ := true;
         END IF;
         x_ := 0;
         LOOP
            node_ := Dbms_Xmldom.Item(child_nodes_, x_);
            Schema_Process___(current_column_name_, current_data_type_, xml_row_item_array_, next_path_ , node_, flag_);
            x_ := x_ + 1;
            EXIT WHEN (x_ = length_ OR flag_);
         END LOOP;
      END IF;
      Free_Xml_Dom_Construct___(node_ => node_);
      Free_Xml_Dom_Construct___(node_ => l_attr_);
      Free_Xml_Dom_Construct___(list_ => child_nodes_);
   EXCEPTION 
      WHEN OTHERS THEN
         Free_Xml_Dom_Construct___(node_ => node_);
         Free_Xml_Dom_Construct___(node_ => l_attr_);
         Free_Xml_Dom_Construct___(list_ => child_nodes_);
         RAISE;
   END;
END Schema_Process___;

PROCEDURE Translation_Flat___(
   element_node_        IN OUT   Dbms_Xmldom.DOMNode,
   out_doc_             IN OUT   Dbms_Xmldom.DOMDocument,
   current_node_        IN       Dbms_Xmldom.DOMNode)
IS
  child_nodes_          Dbms_Xmldom.DOMNodeList;
  node_                 Dbms_Xmldom.DOMNode;
  length_               NUMBER;
  x_                    NUMBER;
  temp_node_            Dbms_Xmldom.DOMNode;
  clone_node_           Dbms_Xmldom.DOMNode;
  element_              Dbms_Xmldom.DOMElement;
BEGIN
   BEGIN
      IF(Dbms_Xmldom.Isnull(Dbms_Xmldom.Getfirstchild(current_node_)) = TRUE OR 
         Dbms_Xmldom.Getnodetype(Dbms_Xmldom.Getfirstchild(current_node_)) = 3)THEN  
         clone_node_  := current_node_;
         clone_node_  := Dbms_Xmldom.Adoptnode(out_doc_, clone_node_); 
         element_     := Dbms_Xmldom.Makeelement(clone_node_);
         Dbms_Xmldom.Removeattribute(element_,'xmlns');
         temp_node_   := Dbms_Xmldom.Makenode(element_);
         temp_node_   := Dbms_Xmldom.Appendchild(element_node_, temp_node_);
      ELSE
         child_nodes_ := Dbms_Xmldom.Getchildnodes(current_node_);
         length_      := Dbms_Xmldom.Getlength(child_nodes_);
         x_           := 0;
         LOOP
            node_ := Dbms_Xmldom.Item(child_nodes_, x_);
            Translation_Flat___(element_node_, out_doc_, node_ );
            x_        := x_ + 1;
            EXIT WHEN (x_ = length_ );
         END LOOP;
      END IF;
      Free_Xml_Dom_Construct___(node_ => node_);
      Free_Xml_Dom_Construct___(node_ => temp_node_);
      Free_Xml_Dom_Construct___(node_ => clone_node_);
      Free_Xml_Dom_Construct___(element_ => element_);
      Free_Xml_Dom_Construct___(list_ => child_nodes_);
   EXCEPTION 
      WHEN OTHERS THEN
         Free_Xml_Dom_Construct___(node_ => node_);
         Free_Xml_Dom_Construct___(node_ => temp_node_);
         Free_Xml_Dom_Construct___(node_ => clone_node_);
         Free_Xml_Dom_Construct___(element_ => element_);
         Free_Xml_Dom_Construct___(list_ => child_nodes_);
         RAISE;
   END;
END Translation_Flat___;

PROCEDURE Xml_Out___(
   row_index_               IN OUT  NUMBER,
   xml_row_item_array_      IN OUT  Xml_Row_Items,
   complex_node_            IN OUT  Dbms_Xmldom.DOMNode,
   out_doc_                 IN OUT  Dbms_Xmldom.DOMDocument,
   node_map_                IN      Node_Array) 
IS
   row_                     Dbms_Xmldom.DOMElement;
   row_node_                Dbms_Xmldom.DOMNode;
   length_                  NUMBER;
   debug_node_              Dbms_Xmldom.DOMNode;
   block_                   BOOLEAN := TRUE;
   blok_type_node_          Dbms_Xmldom.DOMNode;
   blok_type_element_       Dbms_Xmldom.DOMElement;
   blok_type_element_node_  Dbms_Xmldom.DOMNode;
   text_node_               Dbms_Xmldom.DOMNode;
   temp_node_               Dbms_Xmldom.DOMNode;
   column_name_             VARCHAR2(2000);
   first_data_              Dbms_Xmldom.DOMNode := NULL;
   element_                 Dbms_Xmldom.DOMElement;
   node_                    Dbms_Xmldom.DOMNode;
BEGIN 
   BEGIN
      row_        := Dbms_Xmldom.Createelement(out_doc_, 'Row');
      Dbms_Xmldom.Setattribute(row_, 'Id', TO_CHAR(row_index_));
      row_node_   := Dbms_Xmldom.Makenode(row_); 
      row_index_  := row_index_ + 1;
      length_     := node_map_.COUNT;

      FOR cur_node IN 1 .. length_  LOOP
         debug_node_ := node_map_(cur_node);
         IF(block_) THEN
            block_ := FALSE;
            blok_type_node_         := node_map_ (length_);
            blok_type_node_         := Dbms_Xmldom.Getparentnode(blok_type_node_);
            blok_type_element_      := Dbms_Xmldom.Createelement(out_doc_,'_BLOCK_TYPE');
            blok_type_element_node_ := Dbms_Xmldom.Makenode(blok_type_element_);

            IF(UPPER(Dbms_Xmldom.Getnodename(blok_type_node_)) = 'PAGE_FOOTER_ROW') THEN
               text_node_ := Dbms_Xmldom.Makenode(Dbms_Xmldom.Createtextnode(out_doc_, Dbms_Xmldom.Getnodename(Dbms_Xmldom.Getparentnode(blok_type_node_))));
               temp_node_ := Dbms_Xmldom.Appendchild(blok_type_element_node_,text_node_);
            ELSE
               text_node_ := Dbms_Xmldom.Makenode(Dbms_Xmldom.Createtextnode(out_doc_, Dbms_Xmldom.Getnodename(blok_type_node_)));
               temp_node_ := Dbms_Xmldom.Appendchild(blok_type_element_node_,text_node_);
            END IF;
            temp_node_    := Dbms_Xmldom.Appendchild(row_node_,blok_type_element_node_);
         END IF;

         column_name_     := Get_Column_Name___(debug_node_,xml_row_item_array_);
         IF column_name_ IS NULL THEN
            column_name_  := Dbms_Xmldom.Getnodename(debug_node_);
         END IF;
         element_         := Dbms_Xmldom.Createelement(out_doc_,column_name_);
         Dbms_Xmldom.Setattribute(element_,'type',Get_Data_Type_Info___(debug_node_,xml_row_item_array_)); 
         node_            := Dbms_Xmldom.Makenode(element_);
         temp_node_       := Dbms_Xmldom.Appendchild(node_, Dbms_Xmldom.Makenode(Dbms_Xmldom.Createtextnode(out_doc_, Dbms_Xmldom.Getnodevalue(Dbms_Xmldom.Getfirstchild(debug_node_) ))));
         temp_node_       := Dbms_Xmldom.Appendchild(row_node_,node_); 
         IF(cur_node = 0) THEN
            first_data_ := node_;
            first_data_ := Dbms_Xmldom.Adoptnode(out_doc_,first_data_);
            temp_node_:= Dbms_Xmldom.Appendchild(row_node_,node_);
         ELSIF(INSTR(Dbms_Xmldom.Getnodename(node_),'_',1,1)=1 AND 
            Dbms_Xmldom.Isnull(first_data_) = FALSE) THEN
            temp_node_:= Dbms_Xmldom.Insertbefore(row_node_,node_,first_data_); 
         ELSE
            temp_node_:= Dbms_Xmldom.Appendchild(row_node_,node_); 
         END IF;

      END LOOP;
      temp_node_ := Dbms_Xmldom.Appendchild(complex_node_,row_node_);
      Free_Xml_Dom_Construct___(node_ => blok_type_node_);
      Free_Xml_Dom_Construct___(element_ => blok_type_element_);
      Free_Xml_Dom_Construct___(node_ => blok_type_element_node_);
      Free_Xml_Dom_Construct___(node_ => text_node_);
      Free_Xml_Dom_Construct___(node_ => row_node_);
      Free_Xml_Dom_Construct___(node_ => temp_node_);
      Free_Xml_Dom_Construct___(node_ => first_data_);
      Free_Xml_Dom_Construct___(node_ => node_);
      Dbms_XmlDom.Freeelement(element_);
      Free_Xml_Dom_Construct___(element_ => row_);
   EXCEPTION 
      WHEN OTHERS THEN
         Free_Xml_Dom_Construct___(node_ => blok_type_node_);
         Free_Xml_Dom_Construct___(element_ => blok_type_element_);
         Free_Xml_Dom_Construct___(node_ => blok_type_element_node_);
         Free_Xml_Dom_Construct___(node_ => text_node_);
         Free_Xml_Dom_Construct___(node_ => row_node_);
         Free_Xml_Dom_Construct___(node_ => temp_node_);
         Free_Xml_Dom_Construct___(node_ => first_data_);
         Free_Xml_Dom_Construct___(node_ => node_);
         Dbms_XmlDom.Freeelement(element_);
         Free_Xml_Dom_Construct___(element_ => row_);
         RAISE;
   END;   
END Xml_Out___;

PROCEDURE Free_Xml_Dom_Construct___(
   node_     IN  Dbms_Xmldom.DOMNode     DEFAULT NULL,
   doc_      IN  Dbms_Xmldom.DOMDocument DEFAULT NULL,
   element_  IN  Dbms_Xmldom.DOMElement  DEFAULT NULL,
   list_     IN  Dbms_Xmldom.DOMNodeList DEFAULT NULL)
IS
BEGIN
   BEGIN
      Dbms_Xmldom.Freenode(node_);
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;
   BEGIN
      Dbms_Xmldom.Freedocument(doc_);         
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;
   BEGIN
      Dbms_Xmldom.Freeelement(element_);
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;  
   BEGIN
      Dbms_Xmldom.Freenodelist(list_);
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;  
END Free_Xml_Dom_Construct___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Flattened_Data (
   clob_                      OUT CLOB,
   report_id_                 IN  VARCHAR2,
   result_key_                IN  VARCHAR2,
   token_                     IN  VARCHAR2)
IS
   report_data_doc_           Dbms_Xmldom.DOMDocument;
   report_archive_doc_        Dbms_Xmldom.DOMDocument;
   out_doc_                   Dbms_Xmldom.DOMDocument;
   report_schema_doc_         Dbms_Xmldom.DOMDocument;
   schema_id_node_            Dbms_Xmldom.DOMNode;
   flat_root_                 Dbms_Xmldom.DOMElement;
   flat_root_node_            Dbms_Xmldom.DOMNode;
   root_node_                 Dbms_Xmldom.DOMNode;
   node_list_                 Dbms_Xmldom.DOMNodeList;
   complex_node_              Dbms_Xmldom.DOMNode;
   from_parent_node_map_      Node_Array    := Node_Array();
   row_index_                 NUMBER        := 0;
   current_column_name_       VARCHAR2(1000);
   current_data_type_         VARCHAR2(1000);
   xml_row_item_array_        Xml_Row_Items := Xml_Row_Items();   
   clob_data_                 CLOB;
   clob_header_               CLOB;
   clob_temp_                 CLOB;
   clob_out_                  CLOB;
   blob_header_               BLOB;
   blob_footer_               BLOB;
   blob_temp_                 BLOB;
   result_key_value_          NUMBER := result_key_;
   report_id_val_             VARCHAR2(100) := report_id_;
   
   CURSOR get_xml_report_data IS
      SELECT   data, result_key
      FROM     xml_report_data_tab t
      WHERE   (        report_id = NVL(report_id_val_, report_id) 
               AND    (   result_key_ IS NULL
                       OR result_key = result_key_value_)
                      ) 
               AND   ( ( token_ IS NOT NULL 
                           AND EXISTS  (SELECT 1 FROM xml_report_access_tab a WHERE id = token_ AND t.result_key = a.result_key)
                        )
                        OR (token_ IS NULL 
                            AND (    Fnd_Session_API.Get_Fnd_User IN ('IFSPRINT') 
                                 OR  EXISTS (SELECT 1 FROM ARCHIVE_DISTRIBUTION d WHERE t.result_key = d.result_key))))
      ORDER BY result_key DESC;
   
   CURSOR get_xml_report_archive IS
      SELECT   xml_header,xml_footer
      FROM     xml_report_archive_tab
      WHERE    result_key = result_key_value_
      ORDER BY result_key DESC;
   
BEGIN
   BEGIN
      IF(report_id_val_ IS NULL) THEN
         IF(result_key_ IS NULL)THEN
            Error_SYS.Appl_General(lu_name_, 'ERRPARAM: Either Result Key or Report ID should be specified');
         END IF;
         report_id_val_ := Archive_API.Get_Report_Id(result_key_);
      END IF;
      report_schema_doc_   := Get_Schema___(report_id_val_);
      schema_id_node_      := Dbms_Xmldom.Makenode(report_schema_doc_);
      Find_Rep_Id_Node___(current_column_name_,current_data_type_, xml_row_item_array_, schema_id_node_, FALSE, report_id_val_);
      Free_Xml_Dom_Construct___(node_ => schema_id_node_);
      OPEN get_xml_report_data;
      FETCH get_xml_report_data INTO clob_data_,result_key_value_;
      CLOSE get_xml_report_data;
      
      IF(clob_data_ IS NULL)THEN 
         Error_SYS.Appl_General(lu_name_, 'ERRACCESS: Report with given result key (:P1) does not exists or the user does not have access to it.',result_key_ );
      END IF;
      
      OPEN get_xml_report_archive;
      FETCH get_xml_report_archive INTO clob_header_,clob_temp_;
      CLOSE get_xml_report_archive;
      
      IF(clob_header_ IS NULL OR clob_temp_ IS NULL)THEN 
         Error_SYS.Appl_General(lu_name_, 'ERRNOENTRY: No entries in Report Archive for the given Report Id');
      END IF;
      blob_header_         := Utility_SYS.Clob_To_Blob(clob_header_);
      blob_footer_         := Utility_SYS.Clob_To_Blob(clob_temp_);
      dbms_lob.createtemporary(blob_temp_, TRUE);
      DBMS_LOB.APPEND(blob_temp_, blob_header_);
      DBMS_LOB.APPEND(blob_temp_, blob_footer_);
      clob_temp_           := Utility_SYS.Blob_To_Clob(blob_temp_);   
      out_doc_             := Dbms_Xmldom.Newdomdocument;
      root_node_           := Dbms_Xmldom.Makenode(out_doc_);
      flat_root_           := Dbms_Xmldom.Createelement(out_doc_,report_id_val_ || '_REQUEST');
      flat_root_node_      := Dbms_Xmldom.Makenode(flat_root_);
      root_node_           := Dbms_Xmldom.Appendchild(root_node_,flat_root_node_);
      report_archive_doc_  := Dbms_Xmldom.newDOMDocument(clob_temp_);
      report_data_doc_     := Dbms_Xmldom.newDOMDocument(clob_data_);

      Append_Doc_Segment___(out_doc_, root_node_, report_id_val_, report_archive_doc_, 'PROCESSING_INFO');
      Append_Doc_Segment___(out_doc_, root_node_, report_id_val_, report_archive_doc_, '_DATA_ASSEMBLY_PARAMETERS');
      Append_Doc_Segment___(out_doc_, root_node_, report_id_val_, report_archive_doc_, '_ARCHIVE_VARIABLES');
      Append_Translation_Segment___(root_node_, out_doc_, report_archive_doc_, report_id_val_, '_TRANSLATIONS');

      node_list_           := Dbms_Xmldom.Getelementsbytagname(report_data_doc_, report_id_val_);
      complex_node_        := Dbms_Xmldom.item(node_list_,0);
      Append_Data_Block_Segment___(row_index_, xml_row_item_array_, out_doc_, from_parent_node_map_, complex_node_, root_node_, report_id_val_);   
      clob_out_            := ' ';
      Dbms_Xmldom.Writetoclob(out_doc_, clob_out_);
      clob_                := clob_out_;
      Xml_Report_Access_API.Clear__(result_key_,token_);
      Free_Xml_Dom_Construct___(node_ => flat_root_node_);
      Free_Xml_Dom_Construct___(node_ => root_node_);
      Free_Xml_Dom_Construct___(node_ => complex_node_);
      Free_Xml_Dom_Construct___(list_ => node_list_);
      Free_Xml_Dom_Construct___(element_ => flat_root_);
      Free_Xml_Dom_Construct___(doc_ => report_data_doc_);
      Free_Xml_Dom_Construct___(doc_ => report_archive_doc_);
      Free_Xml_Dom_Construct___(doc_ => report_schema_doc_);
      Free_Xml_Dom_Construct___(doc_ => out_doc_);      
   EXCEPTION 
      WHEN OTHERS THEN
         Free_Xml_Dom_Construct___(node_ => flat_root_node_);
         Free_Xml_Dom_Construct___(node_ => root_node_);
         Free_Xml_Dom_Construct___(node_ => complex_node_);
         Free_Xml_Dom_Construct___(list_ => node_list_);
         Free_Xml_Dom_Construct___(element_ => flat_root_);
         Free_Xml_Dom_Construct___(doc_ => report_data_doc_);
         Free_Xml_Dom_Construct___(doc_ => report_archive_doc_);
         Free_Xml_Dom_Construct___(doc_ => report_schema_doc_);
         Free_Xml_Dom_Construct___(doc_ => out_doc_);
         RAISE;
   END;
END Get_Flattened_Data;

-------------------- LU  NEW METHODS -------------------------------------
