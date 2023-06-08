-----------------------------------------------------------------------------
--
--  Logical unit: PlsqlapRecord
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  010420  Ranase  Created
--  010820  ROOD    Changed module to FNDSER (ToDo#4021).
--  020212  JHMA    Modifications to comply with latest Connect framework (ToDo#4069).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  031005  ROOD    Merged changes earlier made only in FNDAS (DaJo 020829).
--  040219  jhmase  Bug #42591
--  040317  jhmase  New timestamp
--  041115  jhmase  Removed limitation of 2000 characters in TEXT_BODY.TEXT_VALUE
--                  and BINARY_BODY.BINARY_VALUE (Bug#46810).
--  050209  DOZE    Added XML serializations (F1PR477)
--  050309  HAAR    Added method security (F1PR477).
--  050105  jhmase  Save of modified record fails (Bug #48936).
--  051201  DOZE    Fails on void-methods
--  061026  jhmase  Bug #58241 - RecordName's limited to 30 characters.
--  061212  pemase  Bug #61975 - Limit PLSQL_BUFFER_TMP resource utilization.
--  061114  UTGULK  Added Procedure Get_Item_Value and To_Xml to support strings with length>32K and Get_Item_Value.(Bug#58694).
--  120127  UsRaLK  Added support for NULL item handling without raising exceptions (Bug#100970).
--  130321  JHMASE Bad performance in To_XML procedure (Bug #109026)
--  160804  CSarlk  Added CLOB Support
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

SUBTYPE type_buffer_   IS PLSQLAP_BUFFER_TMP.buffer%TYPE;
SUBTYPE type_item_     IS PLSQLAP_BUFFER_TMP.name%TYPE;
SUBTYPE type_name_     IS type_item_;
SUBTYPE type_value_    IS PLSQLAP_BUFFER_TMP.value%TYPE;
SUBTYPE type_clob_value_    IS PLSQLAP_BUFFER_TMP.clob_value%TYPE;
SUBTYPE type_blob_value_    IS PLSQLAP_BUFFER_TMP.blob_value%TYPE;
SUBTYPE type_typ_      IS PLSQLAP_BUFFER_TMP.typ%TYPE;
SUBTYPE type_status_   IS PLSQLAP_BUFFER_TMP.status%TYPE;
SUBTYPE type_domain_   IS VARCHAR2(100);

TYPE type_record_      IS RECORD
   ( name_             type_name_,
     buffer_           type_buffer_,
     type_             type_typ_,
     status_           type_status_,
     data_             type_buffer_,
     buff_             type_buffer_,
     position_         NUMBER  := 1,
     parent_name_      type_name_   DEFAULT NULL,
     parent_data_      type_buffer_ DEFAULT NULL );
TYPE type_item_record_ IS RECORD
   ( name_             type_name_,
     item_             type_buffer_,
     type_             type_typ_,
     value_            type_value_,
     status_           type_status_,
     compound_         BOOLEAN      DEFAULT FALSE,
     buffer_           type_buffer_,
     clob_value_       type_clob_value_,
     blob_value_       type_blob_value_ );
new_record_          CONSTANT VARCHAR2(6) := 'Create';
removed_record_      CONSTANT VARCHAR2(6) := 'Remove';
modified_record_     CONSTANT VARCHAR2(6) := 'Modify';
queried_record_      CONSTANT VARCHAR2(6) := 'Q';
DT_BOOLEAN           CONSTANT VARCHAR2(1) := 'B';
DT_INTEGER           CONSTANT VARCHAR2(1) := 'I';
DT_DECIMAL           CONSTANT VARCHAR2(3) := 'DEC';
DT_MONEY             CONSTANT VARCHAR2(3) := 'DEC';
DT_FLOAT             CONSTANT VARCHAR2(1) := 'N';
DT_TEXT              CONSTANT VARCHAR2(1) := 'T';
DT_TEXT_KEY          CONSTANT VARCHAR2(2) := 'TK';
DT_TEXT_REFERENCE    CONSTANT VARCHAR2(2) := 'TR';
DT_LONG_TEXT         CONSTANT VARCHAR2(2) := 'LT';
DT_CLOB              CONSTANT VARCHAR2(5) := 'CLOB';
DT_BLOB              CONSTANT VARCHAR2(5) := 'BLOB';
DT_DATE              CONSTANT VARCHAR2(1) := 'D';
DT_TIME              CONSTANT VARCHAR2(2) := 'DT';
DT_TIMESTAMP         CONSTANT VARCHAR2(3) := 'DTS';
DT_ALPHA             CONSTANT VARCHAR2(1) := 'A';
DT_BINARY            CONSTANT VARCHAR2(5) := 'R.B64';
DT_LONG_BINARY       CONSTANT VARCHAR2(5) := 'R.B64';
DT_ENUMERATION       CONSTANT VARCHAR2(4) := 'ENUM';
DT_AGGREGATE         CONSTANT VARCHAR2(9) := 'AGGREGATE';
DT_ARRAY             CONSTANT VARCHAR2(5) := 'ARRAY';
DT_REFERENCE         CONSTANT VARCHAR2(9) := 'REFERENCE';
format_time_stamp_   CONSTANT VARCHAR2(21) := 'yyyy-mm-dd-hh24.mi.ss';
format_date_         CONSTANT VARCHAR2(10) := 'yyyy-mm-dd';
format_time_         CONSTANT VARCHAR2(10) := 'hh24.mi.ss';

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Add_Element___ (
   master_record_  IN OUT type_record_,
   name_           IN     type_buffer_,
   type_           IN     type_typ_,
   record_         IN OUT type_record_ )
IS
   rec2_      type_buffer_ := record_.data_;
   name_rec2_ type_name_   := SUBSTR(record_.buff_, 1, INSTR(record_.buff_, '+') - 1);
   item_      type_item_   := Plsqlap_Buffer_API.Get_Item_By_Name(master_record_.data_, UPPER(name_));
BEGIN
   IF ( item_ IS NULL ) THEN
      item_ := Plsqlap_Buffer_API.New_Buffer('DATA');
      Plsqlap_Buffer_API.Add_Compound_Item (master_record_.data_, UPPER(name_), item_, type_);
   ELSE
      item_ := Plsqlap_Buffer_API.Get_Buffer(item_);
   END IF;
   record_.parent_name_ := master_record_.name_;
   record_.parent_data_ := master_record_.data_;
   Plsqlap_Buffer_API.Add_Compound_Item (item_, 'DATA', rec2_, name_rec2_, 'Create' );

   -- if record state is queried it should be changed into modified
   -- when a new attribute is added or an old attribute is changed
   IF ( NVL(Get_Status(master_record_),'Queried') IN (queried_record_,'Queried',' ') ) THEN
       Set_Record_Status___(master_record_, modified_record_, recursive_ => FALSE);
   END IF;
END Add_Element___;


PROCEDURE Add_XML_Array___(record_ IN OUT type_record_, name_ VARCHAR2, node_list_ dbms_xmldom.DOMNodeList) 
IS
   node_ dbms_xmldom.DOMNode;
   total_ NUMBER;
   child_record_ type_record_;
   item_      type_item_ ;
   value_      VARCHAR2(4000 BYTE);
   use_clob_   BOOLEAN;
   clob_value_ CLOB;
   node_name_  VARCHAR2(32000);
BEGIN
   total_ := dbms_xmldom.getLength(node_list_);
   FOR i_ IN 0..total_-1 LOOP
      node_ := dbms_xmldom.item(node_list_, i_);
      IF (dbms_xmldom.getLength(dbms_xmldom.getChildNodes(node_))=1 AND dbms_xmldom.getNodeType(dbms_xmldom.item(dbms_xmldom.getChildNodes(node_), 0)) = dbms_xmldom.TEXT_NODE)THEN
         item_ := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, UPPER(name_));
         IF(i_=0 AND item_ IS NOT NULL) THEN
               item_ := Plsqlap_Buffer_API.New_Buffer('DATA');
               Plsqlap_Buffer_API.Add_Compound_Item (record_.data_, UPPER(name_), item_, UPPER(name_),'Create');
         ELSIF ( item_ IS NULL ) THEN
               item_ := Plsqlap_Buffer_API.New_Buffer('DATA');
               Plsqlap_Buffer_API.Add_Compound_Item (record_.data_, UPPER(name_), item_, UPPER(name_),'Create');
         ELSE 
               item_ := Plsqlap_Buffer_API.Get_Item_By_Name_In_Max_Pos(record_.data_, UPPER(name_));
               item_ := Plsqlap_Buffer_API.Get_Buffer(item_);
         END IF;
         --IF ( item_ IS NULL ) THEN
         --   item_ := Plsqlap_Buffer_API.New_Buffer('DATA');
         --   Plsqlap_Buffer_API.Add_Compound_Item (record_.data_, UPPER(name_), item_, UPPER(name_),'Create');
         --ELSE
         --   item_ := Plsqlap_Buffer_API.Get_Buffer(item_);
         --END IF;
         value_    := NULL;
         use_clob_ := FALSE;
         BEGIN
            value_ := dbms_xmldom.getNodeValue(dbms_xmldom.getFirstChild(node_));
            EXCEPTION
               WHEN value_error THEN
                  clob_value_ := NULL;
                  DBMS_LOB.CreateTemporary(clob_value_, TRUE, DBMS_LOB.CALL);
                  DBMS_XMLDOM.writeToClob(dbms_xmldom.getFirstChild(node_), clob_value_);
                  use_clob_ := TRUE;
               END;
         IF(NOT use_clob_) THEN
            dbms_xmldom.getLocalName(node_,node_name_);
            Plsqlap_Buffer_API.Add_Item (item_, UPPER(node_name_), value_, DT_TEXT,'*' );
         ELSE
            dbms_xmldom.getLocalName(node_,node_name_);
            Plsqlap_Buffer_API.Add_Item(item_, UPPER(node_name_), clob_value_, DT_CLOB,'*' );
         END IF;
      ELSE
         dbms_xmldom.getLocalName(node_,node_name_);
         child_record_ := New_Record(node_name_);
         Add_XML_Nodes___(child_record_, dbms_xmldom.getChildNodes(node_));
         Add_Array(record_, name_, child_record_);
      END IF;
   END LOOP;
END Add_XML_Array___;


PROCEDURE Add_XML_Nodes___(record_ IN OUT type_record_, node_list_ dbms_xmldom.DOMNodeList) 
IS
   node_ dbms_xmldom.DOMNode;
   node_list_2_ dbms_xmldom.DOMNodeList;
   total_ NUMBER;
   --value_      VARCHAR2(32767);
   value_      VARCHAR2(4000 BYTE);
   clob_value_ CLOB;
   use_clob_   BOOLEAN;
   node_name_  VARCHAR2(32000);
BEGIN
   total_ := dbms_xmldom.getLength(node_list_);
   FOR i_ IN 0..total_-1 LOOP
      node_ := dbms_xmldom.item(node_list_, i_);
      IF (dbms_xmldom.getNodeType(node_)=dbms_xmldom.ELEMENT_NODE) THEN
         node_list_2_ := dbms_xmldom.getElementsByTagName(dbms_xmldom.makeElement(node_), '*');
         IF (dbms_xmldom.getLength(node_list_2_)>0) THEN
            dbms_xmldom.getLocalName(node_,node_name_);
            Add_XML_Array___(record_, node_name_, dbms_xmldom.getChildNodes(node_));
         ELSE
            value_    := NULL;
            use_clob_ := FALSE;
            BEGIN
               value_ := dbms_xmldom.getNodeValue(dbms_xmldom.getFirstChild(node_));
            EXCEPTION
               WHEN value_error THEN
                  clob_value_ := NULL;
                  DBMS_LOB.CreateTemporary(clob_value_, TRUE, DBMS_LOB.CALL);
                  DBMS_XMLDOM.writeToClob(dbms_xmldom.getFirstChild(node_), clob_value_);
                  use_clob_ := TRUE;
            END;

            IF (NOT use_clob_) THEN
               dbms_xmldom.getLocalName(node_,node_name_);
               Set_Value(record_, node_name_, value_);
            ELSE
               dbms_xmldom.getLocalName(node_,node_name_);
               Set_Value(record_, node_name_, clob_value_);
            END IF;
         END IF;
      END IF;
   END LOOP;
END Add_XML_Nodes___;


FUNCTION Get_Item_By_Recbuff___ (
   record_ IN type_record_ ) RETURN type_item_record_
IS
   item_rec_ type_item_record_;
   item_     type_item_   ;
BEGIN
   item_ := Plsqlap_Buffer_API.Get_Item_By_Position(record_.buff_, record_.position_);
   IF ( item_ IS NOT NULL ) THEN
      item_rec_.name_        := Plsqlap_Buffer_API.Get_Name(item_);
      item_rec_.item_        := item_;
      item_rec_.type_        := Plsqlap_Buffer_API.Get_Type(item_);
      item_rec_.value_       := Plsqlap_Buffer_API.Get_Value(item_ );
      item_rec_.clob_value_  := Plsqlap_Buffer_API.Get_Clob_Value(item_);
      item_rec_.status_      := Plsqlap_Buffer_API.Get_Status(item_);
      item_rec_.compound_    := Plsqlap_Buffer_API.is_Compound(item_);
      item_rec_.buffer_      := Plsqlap_Buffer_API.Get_Buffer(item_);
   ELSE
      item_rec_.item_        := NULL;
   END IF;
   RETURN item_rec_;
END Get_Item_By_Recbuff___;


FUNCTION Get_Item_By_Recdata___ (
   record_ IN type_record_ ) RETURN type_item_record_
IS
   item_rec_ type_item_record_;
   item_     type_item_   ;
BEGIN
   item_ := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, record_.name_);
   IF ( item_ IS NOT NULL ) THEN
      item_rec_.name_        := Plsqlap_Buffer_API.Get_Name(item_);
      item_rec_.item_        := item_;
      item_rec_.type_        := Plsqlap_Buffer_API.Get_Type(item_);
      item_rec_.value_       := Plsqlap_Buffer_API.Get_Value(item_ );
      item_rec_.clob_value_  := Plsqlap_Buffer_API.Get_Clob_Value(item_ );
      item_rec_.blob_value_  := Plsqlap_Buffer_API.Get_Blob_Value(item_ );
      item_rec_.status_      := Plsqlap_Buffer_API.Get_Status(item_);
      item_rec_.compound_    := Plsqlap_Buffer_API.is_Compound(item_);
      item_rec_.buffer_      := Plsqlap_Buffer_API.Get_Buffer(item_);
   ELSE
      item_rec_.item_        := NULL;
   END IF;
   RETURN item_rec_;
END Get_Item_By_Recdata___;


FUNCTION Get_Parent_Name___ (
   buffer_  IN  type_buffer_ ) RETURN type_item_record_
IS
   item_rec_out_ type_item_record_;
   compound_     type_name_;

   CURSOR get_parent_by_name_ IS
      SELECT a.buffer, a.name, a.value, a.clob_value, a.blob_value, a.typ, a.status, a.rowid, a.compound_item
      FROM   plsqlap_buffer_tmp a
      WHERE  a.value = buffer_
      AND    a.compound_item   IS NOT NULL;
BEGIN
   item_rec_out_.name_     := NULL;
   item_rec_out_.value_    := NULL;
   item_rec_out_.clob_value_ := NULL;
   item_rec_out_.blob_value_ := NULL;
   item_rec_out_.type_     := NULL;
   item_rec_out_.status_   := NULL;
   item_rec_out_.compound_ := FALSE;
   item_rec_out_.buffer_   := NULL;
   item_rec_out_.item_     := NULL;
   IF ( buffer_ IS NOT NULL ) THEN
      OPEN get_parent_by_name_;
      FETCH get_parent_by_name_ INTO item_rec_out_.buffer_,
                                     item_rec_out_.name_,
                                     item_rec_out_.value_,
                                     item_rec_out_.clob_value_,
                                     item_rec_out_.blob_value_,
                                     item_rec_out_.type_,
                                     item_rec_out_.status_,
                                     item_rec_out_.item_,
                                     compound_;
      IF ( get_parent_by_name_%NOTFOUND ) THEN
         CLOSE get_parent_by_name_;
         RETURN item_rec_out_;
      ELSE
         CLOSE get_parent_by_name_;
         IF ( compound_ = 'TRUE' ) THEN
            item_rec_out_.compound_ := TRUE;
         ELSE
            item_rec_out_.compound_ := FALSE;
         END IF;
      END IF;
   END IF;
   RETURN item_rec_out_;
END Get_Parent_Name___;


FUNCTION Get_Record_Item_By_Name___ (
   record_  IN type_record_,
   attr_    IN type_buffer_ ) RETURN type_item_record_
IS
   item_rec_ type_item_record_;
BEGIN
   item_rec_.item_     := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, UPPER(attr_));
   IF (item_rec_.item_ IS NOT NULL)  THEN
      item_rec_.name_     := Plsqlap_Buffer_API.Get_Name(item_rec_.item_);
      item_rec_.type_     := Plsqlap_Buffer_API.Get_Type(item_rec_.item_);
      item_rec_.value_    := Plsqlap_Buffer_API.Get_Value(item_rec_.item_);
      item_rec_.clob_value_    := Plsqlap_Buffer_API.Get_Clob_Value(item_rec_.item_);
      item_rec_.blob_value_    := Plsqlap_Buffer_API.Get_Blob_Value(item_rec_.item_);
      item_rec_.status_   := Plsqlap_Buffer_API.Get_Status(item_rec_.item_);
      item_rec_.compound_ := Plsqlap_Buffer_API.is_Compound(item_rec_.item_);
   ELSE
      IF(record_.buff_ IS NOT NULL)THEN
         item_rec_.item_ := Plsqlap_Buffer_API.Get_Item_By_Name(record_.buff_,UPPER(attr_));
         IF(item_rec_.item_ IS NOT NULL)THEN
            item_rec_.name_     := Plsqlap_Buffer_API.Get_Name(item_rec_.item_);
            item_rec_.type_     := Plsqlap_Buffer_API.Get_Type(item_rec_.item_);
            item_rec_.value_    := Plsqlap_Buffer_API.Get_Value(item_rec_.item_);
            item_rec_.clob_value_    := Plsqlap_Buffer_API.Get_Clob_Value(item_rec_.item_);
            item_rec_.blob_value_    := Plsqlap_Buffer_API.Get_Blob_Value(item_rec_.item_);
            item_rec_.status_   := Plsqlap_Buffer_API.Get_Status(item_rec_.item_);
            item_rec_.compound_ := Plsqlap_Buffer_API.is_Compound(item_rec_.item_);
         END IF;
      END IF;  
   END IF;
   RETURN item_rec_;
END Get_Record_Item_By_Name___;


FUNCTION Get_Record_Item_By_Pos___ (
   record_   IN type_record_,
   position_ IN NUMBER ) RETURN type_item_record_
IS
   item_rec_ type_item_record_;
BEGIN
   item_rec_.item_     := Plsqlap_Buffer_API.Get_Item_By_Position(record_.data_, position_);
   IF (item_rec_.item_ IS NOT NULL) THEN
      item_rec_.name_     := Plsqlap_Buffer_API.Get_Name(item_rec_.item_);
      item_rec_.type_     := Plsqlap_Buffer_API.Get_Type(item_rec_.item_);
      item_rec_.value_    := Plsqlap_Buffer_API.Get_Value(item_rec_.item_);
      item_rec_.clob_value_ := Plsqlap_Buffer_API.Get_Clob_Value(item_rec_.item_);
      item_rec_.status_   := Plsqlap_Buffer_API.Get_Status(item_rec_.item_);
      item_rec_.compound_ := Plsqlap_Buffer_API.is_Compound(item_rec_.item_);
   ELSE
      IF(record_.buff_ IS NOT NULL)THEN
         item_rec_.item_ := Plsqlap_Buffer_API.Get_Item_By_Position(record_.buff_,position_);
         IF(item_rec_.item_ IS NOT NULL)THEN
            item_rec_.name_     := Plsqlap_Buffer_API.Get_Name(item_rec_.item_);
            item_rec_.type_     := Plsqlap_Buffer_API.Get_Type(item_rec_.item_);
            item_rec_.value_    := Plsqlap_Buffer_API.Get_Value(item_rec_.item_);
            item_rec_.clob_value_    := Plsqlap_Buffer_API.Get_Clob_Value(item_rec_.item_);
            item_rec_.status_   := Plsqlap_Buffer_API.Get_Status(item_rec_.item_);
            item_rec_.compound_ := Plsqlap_Buffer_API.is_Compound(item_rec_.item_);
         END IF;
      END IF;  
   END IF;
   RETURN item_rec_;
END Get_Record_Item_By_Pos___;


PROCEDURE Raise_Error___ (
   lu_name_  IN VARCHAR2,
   err_text_ IN VARCHAR2,
   p1_       IN VARCHAR2 DEFAULT NULL,
   p2_       IN VARCHAR2 DEFAULT NULL,
   p3_       IN VARCHAR2 DEFAULT NULL )
IS
   temp_     VARCHAR2(500) := SUBSTR(err_text_,1,500);
BEGIN
   temp_ := REPLACE(temp_, ':P1', p1_);
   temp_ := REPLACE(temp_, ':P2', p2_);
   temp_ := REPLACE(temp_, ':P3', p3_);
   raise_application_error(-20105, lu_name_||'.'||temp_);
END Raise_Error___;


PROCEDURE Set_Record_Status___ (
   record_ IN OUT type_record_,
   status_         IN     type_status_,
   recursive_      IN     BOOLEAN := TRUE,
   recursive_call_ IN     BOOLEAN := FALSE )
IS
   item_rec_ type_item_record_;
   rec_      type_record_;

   CURSOR get_item (rowid_ VARCHAR2) IS
      SELECT a.buffer, a.name, a.value, a.status, a.typ
      FROM   plsqlap_buffer_tmp a
      WHERE  a.rowid = rowid_;
BEGIN
   record_.status_ := status_;
    IF ( recursive_call_ ) THEN
       item_rec_.item_ := record_.buffer_;
       item_rec_.type_ := record_.type_;
    ELSE
      -- This is only safe to do on the top level
      -- ----------------------------------------
      item_rec_ := Get_Parent_Name___(record_.data_);
   END IF;
   IF ( item_rec_.type_ <> 'ARRAY' ) THEN
      Plsqlap_Buffer_API.Set_Item_Status(item_rec_.item_, status_);
   END IF;
--
   IF ( recursive_ ) THEN
      FOR i IN 1..Count_Attributes(record_) LOOP
         item_rec_ := Get_Record_Item_By_Pos___(record_, i);
         IF ( item_rec_.compound_ ) THEN
            OPEN get_item(item_rec_.item_);
            FETCH get_item INTO rec_.buff_, rec_.name_, rec_.data_, rec_.status_, rec_.type_;
            IF ( get_item%FOUND ) THEN
               rec_.buffer_ := item_rec_.item_;
               CLOSE get_item;
               Set_Record_Status___(rec_, status_, TRUE, TRUE);
            ELSE
               CLOSE get_item;
            END IF;
         END IF;
      END LOOP;
   END IF;
END Set_Record_Status___;


PROCEDURE Set_Value___ (
   record_         IN OUT type_record_,
   name_           IN     type_name_,
   value_          IN     type_value_,
   type_           IN     type_typ_,
   dirty_          IN     BOOLEAN,
   case_sensitive_ IN     BOOLEAN DEFAULT FALSE )
IS
   item_    type_item_   := NULL;
   domain_  type_domain_ := NULL;
   status_  type_status_ := NULL;
   old_val_ type_value_;
BEGIN
   IF(case_sensitive_) THEN
      item_ := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, name_);
   ELSE
      item_ := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, UPPER(name_));
   END IF;
   IF (NVL(Get_Status(record_),'Queried') <> new_record_) THEN
      IF (dirty_) THEN
         status_ := '*';
      END IF;
   END IF;

   IF ( item_ IS NULL ) THEN
      IF(case_sensitive_) THEN
         Plsqlap_Buffer_API.Add_Item(record_.data_, name_, value_, type_, status_);
      ELSE
      Plsqlap_Buffer_API.Add_Item(record_.data_, UPPER(name_), value_, type_, status_);
      END IF;
   ELSE
      old_val_:= Plsqlap_Buffer_API.Get_Value(item_);
      IF (INSTR(old_val_, CHR(94)) > 0) THEN
         domain_ := SUBSTR(old_val_, INSTR(old_val_, CHR(94)));
      END IF;
      Plsqlap_Buffer_API.Set_Item(item_, value_ || domain_, type_, status_);
   END IF;
   -- if record state is queried it should be changed into modified
   -- when a new attribute is added or an old attribute is changed
   IF ((NVL(Get_Status(record_), 'Queried') IN (queried_record_, 'Queried',' ')) AND (status_ = '*')) THEN
       Set_Record_Status___(record_, modified_record_);
   END IF;
END Set_Value___;


PROCEDURE Set_Blob_Value___ (
   record_         IN OUT type_record_,
   name_           IN     type_name_,
   blob_value_     IN     type_blob_value_,
   type_           IN     type_typ_,
   dirty_          IN     BOOLEAN,
   case_sensitive_ IN     BOOLEAN DEFAULT FALSE )
IS
   item_          type_item_   := NULL;
--   domain_        type_domain_ := NULL;
   status_        type_status_ := NULL;
--   old_blob_val_  type_blob_value_;
BEGIN
   IF(case_sensitive_) THEN
      item_ := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, name_);
   ELSE
      item_ := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, UPPER(name_));
   END IF;
   IF ( NVL(Get_Status(record_),'Queried') <> new_record_ ) THEN
      IF ( dirty_ ) THEN
         status_ := '*';
      END IF;
   END IF;

   IF ( item_ IS NULL ) THEN
      IF(case_sensitive_) THEN
         Plsqlap_Buffer_API.Add_Blob_Item(record_.data_, name_, blob_value_, type_, status_);
      ELSE
      Plsqlap_Buffer_API.Add_Blob_Item(record_.data_, UPPER(name_), blob_value_, type_, status_);
      END IF;
   ELSE 
      Plsqlap_Buffer_API.Set_Blob_Item(item_, blob_value_, type_, status_);
   END IF;
   -- if record state is queried it should be changed into modified
   -- when a new attribute is added or an old attribute is changed
   IF ( ( NVL(Get_Status(record_),'Queried') IN (queried_record_,'Queried',' ') ) AND ( status_ = '*' ) ) THEN
       Set_Record_Status___(record_, modified_record_);
   END IF;
END Set_Blob_Value___;


PROCEDURE Set_Text_Value___ (
   record_         IN OUT NOCOPY type_record_,
   name_           IN     type_name_,
   value_          IN     VARCHAR2,
   type_           IN     type_typ_,
   dirty_          IN     BOOLEAN,
   case_sensitive_ IN     BOOLEAN DEFAULT FALSE )
IS
   start_at_   NUMBER := 1;
   index_      NUMBER := 1;
   length_     NUMBER;
   tmp_        VARCHAR2(4000);
   type_error_ EXCEPTION;
BEGIN
   IF ( type_ NOT IN (DT_BOOLEAN, DT_INTEGER, DT_DECIMAL, DT_MONEY, DT_FLOAT,
                      DT_TEXT, DT_TEXT_KEY, DT_TEXT_REFERENCE, DT_LONG_TEXT, DT_DATE, DT_TIME, DT_TIMESTAMP,
                      DT_ALPHA, DT_BINARY, DT_ENUMERATION, DT_AGGREGATE, DT_ARRAY, DT_REFERENCE) ) THEN
      RAISE type_error_;
   END IF;  
   length_ := LENGTHB(value_);  
   
   IF ( type_ IN (DT_TEXT, DT_LONG_TEXT) AND name_ = 'TEXT_VALUE' AND Get_Type(record_) = 'TEXT_BODY' AND length_ > 4000 ) THEN
      WHILE (start_at_ < length_) LOOP
         IF ( start_at_ + 4000 > length_ ) THEN
            tmp_ := SUBSTRB(value_, start_at_);
         ELSE
            tmp_ := SUBSTRB(value_, start_at_, 4000);
         END IF;
         Set_Value___(record_, 'TEXT_VALUE_' || TO_CHAR(index_), tmp_, type_, dirty_, case_sensitive_);
         start_at_ := start_at_ + 4000;
         index_    := index_    + 1;
      END LOOP;
   ELSIF ( type_ IN (DT_BINARY, DT_LONG_BINARY) AND name_ = 'BINARY_VALUE' AND Get_Type(record_) = 'BINARY_BODY' AND length_ > 4000 ) THEN
      WHILE (start_at_ < length_) LOOP
         IF ( start_at_ + 4000 > length_ ) THEN
            tmp_ := SUBSTRB(value_, start_at_);
         ELSE
            tmp_ := SUBSTRB(value_, start_at_, 4000);
         END IF;
         Set_Value___(record_, 'BINARY_VALUE_' || TO_CHAR(index_), tmp_, type_, dirty_, case_sensitive_);
         start_at_ := start_at_ + 4000;
         index_    := index_    + 1;
      END LOOP;
   ELSIF (length_ > 4000) THEN
         Error_SYS.Record_General(lu_name_, 'INVALID_LONG_STRUCT: The XML structure for values longer than 4000 characters is invalid for field :P1 in record :P2.', name_, Get_Type(record_));      
      -- If you have e. g. an tag <FILE_CONTENT>
      -- in your xml that contains a CLOB or large text the xml structure
      -- can be like the following
      -- <SAMPLE_XML>
      --    <FILE_NAME>dummy.txt</FILE_NAME>
      --    <FILE_SIZE>4711</FILE_SIZE>
      --    <FILE_CONTENT>
      --       <TEXT_BODY>
      --          <TEXT_VALUE>your clob text</TEXT_VALUE>
      --       </TEXT_BODY>
      --    </FILE_CONTENT>
      -- </SAMPLE_XML>
      --
      -- Or else you can use data type DT_CLOB which handles CLOBs
   ELSE
      Set_Value___(record_, name_, value_, type_, dirty_, case_sensitive_);
   END IF;
EXCEPTION
   WHEN type_error_ THEN
      Raise_Error___('PlsqlapRecord', 'Unknown type ":P1"', type_);
END Set_Text_Value___;

PROCEDURE Set_Clob_Value___ (
   record_         IN OUT NOCOPY type_record_,
   name_           IN     type_name_,
   clob_value_     IN     type_clob_value_,
   type_           IN     type_typ_,
   dirty_          IN     BOOLEAN,
   case_sensitive_ IN     BOOLEAN DEFAULT FALSE )
IS   
   item_          type_item_   := NULL;
   domain_        type_domain_ := NULL;
   status_        type_status_ := NULL;
   old_clob_val_  type_clob_value_;
   temp_clob_val_ type_clob_value_;
BEGIN
   IF (case_sensitive_) THEN
      item_ := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, name_);
   ELSE
      item_ := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, UPPER(name_));
   END IF;      
   IF ( NVL(Get_Status(record_),'Queried') <> new_record_ ) THEN
      IF ( dirty_ ) THEN
         status_ := '*';
      END IF;
   END IF;

   IF ( item_ IS NULL ) THEN
     --Add value to clob column
     IF(case_sensitive_) THEN
        Plsqlap_Buffer_API.Add_Item(record_.data_, name_, clob_value_, type_, status_);
     ELSE
      Plsqlap_Buffer_API.Add_Item(record_.data_, UPPER(name_), clob_value_, type_, status_);
     END IF;
   ELSE
     -- get old clob value
      old_clob_val_:= Plsqlap_Buffer_API.Get_Clob_Value(item_);
      IF ( INSTR(old_clob_val_, CHR(94)) > 0 ) THEN
         domain_ := SUBSTR(old_clob_val_, INSTR(old_clob_val_, CHR(94)));
      END IF;
      IF(clob_value_ IS NULL OR clob_value_ = empty_clob()) THEN
         dbms_lob.createtemporary(temp_clob_val_, TRUE);
      ELSE
         dbms_lob.createtemporary(temp_clob_val_, TRUE);
         temp_clob_val_ := clob_value_;
      END IF;
      IF (domain_ IS NOT NULL) THEN
         DBMS_LOB.WriteAppend(temp_clob_val_, LENGTH(domain_), domain_);
      END IF;
      Plsqlap_Buffer_API.Set_Item(item_,temp_clob_val_ , type_, status_);
      dbms_lob.freetemporary(temp_clob_val_);
   END IF;
   -- if record state is queried it should be changed into modified
   -- when a new attribute is added or an old attribute is changed
   IF ( ( NVL(Get_Status(record_),'Queried') IN (queried_record_,'Queried',' ') ) AND ( status_ = '*' ) ) THEN
       Set_Record_Status___(record_, modified_record_);
   END IF;
END Set_Clob_Value___;


FUNCTION Get_Value_Part___ (
   value_ IN type_value_ ) RETURN type_value_
IS
   p_ NUMBER := INSTR(value_, CHR(94));
BEGIN
   IF ( p_ > 0 ) THEN
      RETURN SUBSTR(value_, 1, (p_ - 1));
   ELSE
      RETURN value_;
   END IF;
END Get_Value_Part___;


FUNCTION Get_Value_Part___ (
   value_ IN type_clob_value_ ) RETURN type_clob_value_
IS
   p_ NUMBER := DBMS_LOB.INSTR(value_, CHR(94));
BEGIN
   IF ( p_ > 0 ) THEN
      RETURN DBMS_LOB.SUBSTR(value_, (p_ - 1), 1);
   ELSE
      RETURN value_;
   END IF;
END Get_Value_Part___;


FUNCTION Get_Domain_Part___ (
   value_ IN type_value_ ) RETURN type_domain_
IS
   p_ NUMBER := INSTR(value_, CHR(94));
BEGIN
   IF ( p_ > 0 ) THEN
      RETURN SUBSTR(value_, (p_ + 1));
   ELSE
      RETURN NULL;
   END IF;
END Get_Domain_Part___;


FUNCTION Get_Name___ (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN type_name_
IS
   item_rec_ type_item_record_ := Get_Record_Item_By_Name___(record_, name_);
BEGIN
   RETURN item_rec_.name_;
END Get_Name___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Debug (
   record_ IN type_record_,
   level_ IN NUMBER DEFAULT Log_SYS.debug_ )
IS
BEGIN
   Plsqlap_Buffer_API.Debug(record_.buff_, level_);
END Debug;


PROCEDURE Debug_Record (
   record_ IN type_record_,
   level_ IN NUMBER DEFAULT Log_SYS.debug_ )
IS
BEGIN
   Log_SYS.Fnd_Trace_(level_, ' Name     = ' || record_.name_);
   Log_SYS.Fnd_Trace_(level_, ' Buffer   = ' || record_.buffer_);
   Log_SYS.Fnd_Trace_(level_, ' Type     = ' || record_.type_);
   Log_SYS.Fnd_Trace_(level_, ' Status   = ' || record_.status_);
   Log_SYS.Fnd_Trace_(level_, ' Data     = ' || record_.data_);
   Log_SYS.Fnd_Trace_(level_, ' Buff     = ' || record_.buff_);
   Log_SYS.Fnd_Trace_(level_, ' Position = ' || TO_CHAR(record_.position_));
END Debug_Record;


PROCEDURE Debug_Item_Record (
   record_ IN type_item_record_,
   level_ IN NUMBER DEFAULT Log_SYS.debug_ )
IS
BEGIN
   Log_SYS.Fnd_Trace_(level_, ' Name     = '   || record_.name_);
   Log_SYS.Fnd_Trace_(level_, ' Item     = '   || record_.item_);
   Log_SYS.Fnd_Trace_(level_, ' Type     = '   || record_.type_);
   Log_SYS.Fnd_Trace_(level_, ' Value    = '   || record_.value_);
   Log_SYS.Fnd_Trace_(level_, ' Status   = '   || record_.status_);
   IF ( record_.compound_ ) THEN
      Log_SYS.Fnd_Trace_(level_, ' Compound = '|| 'TRUE');
   ELSE
      Log_SYS.Fnd_Trace_(level_, ' Compound = '|| 'FALSE');
   END IF;
   Log_SYS.Fnd_Trace_(level_, ' Buffer   = '   || record_.buffer_);
END Debug_Item_Record;

FUNCTION New_Record (
   name_      IN type_name_,
   status_    IN type_status_ DEFAULT new_record_ ) RETURN type_record_
IS
   array_of_records_ type_buffer_;
   data_buffer_      type_buffer_;
   rec_out_          type_record_;
BEGIN
   array_of_records_ := Plsqlap_Buffer_API.New_Buffer(UPPER(name_));
   data_buffer_      := Plsqlap_Buffer_API.New_Buffer('DATA');
   Plsqlap_Buffer_API.Add_Compound_Item(array_of_records_, 'DATA', data_buffer_, UPPER(name_), status_);

   rec_out_.name_   := UPPER(name_);
   rec_out_.buffer_ := data_buffer_ || ':' || array_of_records_;
   rec_out_.type_   := NULL;
   rec_out_.status_ := status_;
   rec_out_.data_   := data_buffer_;
   rec_out_.buff_   := array_of_records_;
   RETURN rec_out_;
END New_Record;


PROCEDURE Clear_Record (
   record_ IN type_record_ )
IS
BEGIN
   Plsqlap_Buffer_API.Clear_Buffer(record_.data_);
   Plsqlap_Buffer_API.Clear_Buffer(record_.buff_); -- Bug#61975, one line
END Clear_Record;


PROCEDURE Clear_Dirty (
   record_ IN OUT type_record_ )
IS
   --
   -- Clears the dirtyflag on the record and an all record attributes.
   --
   buff_item_rec_ type_item_record_;
   item_rec_      type_item_record_;
   comp_rec_      type_record_;
BEGIN
   buff_item_rec_ := Get_Item_By_Recbuff___(record_);                -- Fetch buff_ information
   IF ( buff_item_rec_.item_ IS NOT NULL ) THEN
      record_.status_ := NULL;                                       -- Clear Master Record Status
      Plsqlap_Buffer_API.Set_Item_Status(buff_item_rec_.item_, NULL);-- Clear Master Item Status
   END IF;
   FOR i IN 1..Count_Attributes(record_) LOOP
      item_rec_ := Get_Record_Item_By_Pos___(record_, i);
      IF ( item_rec_.compound_ ) THEN
         IF ( item_rec_.item_ IS NOT NULL ) THEN
            record_.status_ := NULL;                                   -- Clear Compound Record Status
            Plsqlap_Buffer_API.Set_Item_Status(item_rec_.item_, NULL); -- Clear Item Status
         END IF;
         comp_rec_.data_ := Plsqlap_Buffer_API.Get_Buffer(item_rec_.item_);
         Clear_Dirty(comp_rec_);                                       -- Compound attribute: do recursive Clear_Dirty!
      END IF;
      Clear_Dirty(record_, item_rec_.name_);                           -- Clear Attribute Status
   END LOOP;
END Clear_Dirty;


PROCEDURE Clear_Dirty (
   record_ IN OUT type_record_,
   name_   IN     type_name_ )
IS
   item_rec_ type_item_record_ := Get_Record_Item_By_Name___(record_, name_);
BEGIN
   Plsqlap_Buffer_API.Set_Item_Status(item_rec_.item_, NULL);
END Clear_Dirty;


PROCEDURE Add_Aggregate (
   master_record_  IN OUT type_record_,
   name_           IN     type_name_,
   record_         IN OUT type_record_ )
IS
BEGIN
   Add_Element___(master_record_, name_, DT_AGGREGATE, record_);
END Add_Aggregate;


PROCEDURE Add_Array (
   master_record_  IN OUT type_record_,
   name_           IN     type_name_,
   record_         IN OUT type_record_ )
IS
BEGIN
   Add_Element___(master_record_, name_, DT_ARRAY, record_);
END Add_Array;


FUNCTION Count_Attributes (
   record_ IN type_record_ ) RETURN NUMBER
IS
BEGIN
   RETURN Plsqlap_Buffer_API.Count_Items(record_.data_);
END Count_Attributes;


FUNCTION Count_Elements (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN NUMBER
IS
   count_    NUMBER     := 0;
   item_     type_item_ := NULL;
   buff_     type_buffer_;
BEGIN
   item_ := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, UPPER(name_));
   IF ( item_ IS NULL ) THEN
      RETURN 0;
   ELSE
      buff_  := Plsqlap_Buffer_API.Get_Buffer(item_);
      count_ := Plsqlap_Buffer_API.Count_Items(buff_);
      RETURN count_;
   END IF;
END Count_Elements;


FUNCTION Check_Elements (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN NUMBER
IS
   item_     type_item_ := NULL;
BEGIN
   item_ := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, UPPER(name_));
   IF ( item_ IS NULL ) THEN
      RETURN 0;
   ELSE
      RETURN 1;
   END IF;
END Check_Elements;


FUNCTION Get_Element (
   element_  OUT    type_record_,
   record_   IN     type_record_,
   array_    IN     type_name_,
   position_ IN     NUMBER,
   error_    IN     BOOLEAN DEFAULT FALSE) RETURN BOOLEAN
IS
   item_      type_item_  := NULL;
   buff_      type_buffer_;
   elem_item_ type_item_  := NULL;
   elem_buff_ type_buffer_;
   rec_out_   type_record_;
   count_  NUMBER;
   is_array_ BOOLEAN := TRUE;
      
   CURSOR is_array IS
      SELECT 1
      FROM   PLSQLAP_BUFFER_TMP a
      WHERE  a.buffer = record_.data_
      AND    a.name   = UPPER(array_)
      AND    a.typ    IN('ARRAY' , 'AGGREGATE')
      AND    a.name   IS NOT NULL;
BEGIN
   --check given record contains an array or not
   OPEN is_array;
   FETCH is_array INTO count_;
   IF(is_array%NOTFOUND) THEN
      is_array_ := FALSE;
   END IF; 
   CLOSE is_array;
   IF(is_array_) THEN 
      -- Fetch master_record_'s 'array' attribute.
      item_      := Plsqlap_Buffer_API.Get_Item_By_Name (record_.data_, UPPER(array_));
      buff_      := Plsqlap_Buffer_API.Get_Buffer(item_);

      -- Fetch the element by position
      elem_item_ := Plsqlap_Buffer_API.Get_Item_By_Position(buff_, position_);
      IF (elem_item_ IS NOT NULL OR error_) THEN
         elem_buff_ := Plsqlap_Buffer_API.Get_Buffer(elem_item_);
         -- Build and return output record
         rec_out_.name_        := Plsqlap_Buffer_API.Get_Type(elem_item_);
         rec_out_.buffer_      := elem_buff_|| ':' || buff_;
         rec_out_.type_        := 'ARRAY';
         rec_out_.status_      := NVL(Plsqlap_Buffer_API.Get_Status(elem_item_), 'Queried');
         rec_out_.data_        := elem_buff_;
         rec_out_.buff_        := buff_;
         rec_out_.position_    := position_;
         rec_out_.parent_name_ := record_.name_;
         rec_out_.parent_data_ := record_.data_;

         element_ := rec_out_;

         RETURN TRUE;
      ELSE
         element_ := rec_out_;

         RETURN FALSE;
      END IF; 
   ELSE
      item_      := Plsqlap_Buffer_API.Get_Item_By_Name_And_Position (record_.data_, UPPER(array_),position_);
      IF (item_ IS NOT NULL) THEN
         buff_      := Plsqlap_Buffer_API.Get_Buffer(item_);
         -- Fetch the element by position
         elem_item_ := Plsqlap_Buffer_API.Get_Item_By_Position(buff_, 1);
         IF (elem_item_ IS NOT NULL OR error_) THEN
            elem_buff_ := Plsqlap_Buffer_API.Get_Buffer(elem_item_);
            -- Build and return output record
            rec_out_.name_        := Plsqlap_Buffer_API.Get_Type(elem_item_);
            rec_out_.buffer_      := elem_buff_|| ':' || buff_;
            rec_out_.type_        := UPPER(array_);
            rec_out_.status_      := NVL(Plsqlap_Buffer_API.Get_Status(elem_item_), 'Queried');
            rec_out_.data_        := elem_buff_;
            rec_out_.buff_        := buff_;
            rec_out_.position_    := position_;
            rec_out_.parent_name_ := record_.name_;
            rec_out_.parent_data_ := record_.data_;

            element_ := rec_out_;    
            RETURN TRUE;
         ELSE
            element_ := rec_out_;

            RETURN FALSE;
         END IF;
      ELSE
         element_ := rec_out_;

         RETURN FALSE;
      END IF;
   END IF;
END Get_Element;
   

FUNCTION Get_Element (
   record_   IN     type_record_,
   array_    IN     type_name_,
   position_ IN     NUMBER ) RETURN type_record_
IS
   dummy_     BOOLEAN;
   rec_out_   type_record_;
BEGIN
   dummy_ := Get_Element(rec_out_, record_, array_, position_, TRUE);
   
   RETURN rec_out_;
END Get_Element;

   
FUNCTION Get_Next_Element (
   element_  OUT    type_record_,
   record_   IN     type_record_,
   array_    IN     type_name_,
   position_ IN OUT NUMBER) RETURN BOOLEAN
IS
BEGIN
   position_ := NVL(position_, 0)+1;
   
   RETURN Get_Element(element_, record_, array_, position_);   
END Get_Next_Element;


FUNCTION Get_Status (
   record_ IN type_record_ ) RETURN type_status_
IS
   item_ Plsqlap_Record_API.type_item_ := Plsqlap_Buffer_API.Get_Item_By_Position(record_.buff_, record_.position_);
BEGIN
   RETURN Plsqlap_Buffer_API.Get_Status(item_);
END Get_Status;


FUNCTION Get_Status (
   attr_ IN type_item_record_ ) RETURN type_status_
IS
BEGIN
   RETURN attr_.status_;
END Get_Status;


FUNCTION Get_Status (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN type_status_
IS
   item_rec_ type_item_record_ := Get_Record_Item_By_Name___(record_, name_);
BEGIN
   RETURN item_rec_.status_;
END Get_Status;


FUNCTION Get_Name (
   record_ IN type_record_ ) RETURN type_name_
IS
   item_ Plsqlap_Record_API.type_item_ := Plsqlap_Buffer_API.Get_Item_By_Position(record_.buff_, record_.position_);
BEGIN
   RETURN Plsqlap_Buffer_API.Get_Name(item_);
END Get_Name;


FUNCTION Get_Name (
   record_   IN type_record_,
   position_ IN NUMBER ) RETURN type_name_
IS
   attr_ type_item_record_ := Get_Attribute(record_, position_);
BEGIN
   RETURN attr_.name_;
END Get_Name;


FUNCTION Get_Name (
   attr_ IN type_item_record_ ) RETURN type_name_
IS
BEGIN
   RETURN attr_.name_;
END Get_Name;


FUNCTION Get_Type (
   record_ IN type_record_ ) RETURN type_typ_
IS
   item_ Plsqlap_Record_API.type_item_ := Plsqlap_Buffer_API.Get_Item_By_Position(record_.buff_, record_.position_);
BEGIN
   RETURN Plsqlap_Buffer_API.Get_Type(item_);
END Get_Type;


FUNCTION Get_Type (
   attr_ IN type_item_record_ ) RETURN type_typ_
IS
BEGIN
   RETURN attr_.type_;
END Get_Type;


FUNCTION Get_Type (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN type_typ_
IS
   item_rec_ type_item_record_ := Get_Record_Item_By_Name___(record_, name_);
BEGIN
   RETURN item_rec_.type_;
END Get_Type;


PROCEDURE Set_Domain (
   record_    IN OUT type_record_,
   domain_    IN     type_domain_,
   overwrite_ IN     BOOLEAN DEFAULT TRUE )
IS
   -- Recursively sets domain for all key-attribute and for all not-null reference-attribute.
   -- If Overwrite = False existing domain values will be untouched.
   --
   item_rec_ type_item_record_;
   comp_rec_ type_record_;
BEGIN
   IF ( overwrite_ ) THEN
      FOR i IN 1..Count_Attributes(record_) LOOP
         item_rec_ := Get_Record_Item_By_Pos___(record_ , i);
         IF ( item_rec_.compound_ ) THEN
            comp_rec_.data_ := Plsqlap_Buffer_API.Get_Buffer(item_rec_.item_);
            Set_Domain(comp_rec_, domain_, overwrite_);                  -- Compound attribute: do recursive Set_Domain!
         END IF;
         IF ( item_rec_.type_ IN (DT_TEXT_KEY,    DT_TEXT_REFERENCE) ) THEN     -- Reference/Key
            Set_Domain(record_, item_rec_.name_, domain_, overwrite_);
         END IF;
      END LOOP;
   END IF;
END Set_Domain;


PROCEDURE Set_Domain (
   record_    IN OUT type_record_,
   name_      IN     type_name_,
   domain_    IN     type_domain_,
   overwrite_ IN     BOOLEAN DEFAULT TRUE )
IS
   -- Sets domain on a specified reference attribute. It does change the attribute
   -- dirty flag. Called on a Non_Existent_Attribute creates the attribute and set
   -- its state to Query_Attribute with null Query_Condition.
   --
   item_       type_item_  := Plsqlap_Buffer_API.Get_Item_By_Name(record_.data_, UPPER(name_));
   new_domain_ type_value_ := chr(94) || domain_;
   value_      type_value_ := NULL;
   new_value_  type_value_ := NULL;
   old_domain_ type_value_ := NULL;
BEGIN
   IF ( item_ IS NULL ) THEN
      Set_Value___(record_, name_, new_domain_, 'S', TRUE);
   ELSE
      value_ := Plsqlap_Buffer_API.Get_Value(item_);
      IF ( INSTR(value_, CHR(94)) = 0 ) then
         new_value_  := value_;
      ELSE
         new_value_  := SUBSTR(value_, 1, INSTR(value_, CHR(94)) -1 );
         old_domain_ := SUBSTR(value_, INSTR(value_, CHR(94)));
      END IF;

      IF ( ( overwrite_ )           OR
           ( old_domain_ IS NULL ) )THEN
         Plsqlap_Buffer_API.Set_Item_Value(item_, new_value_ || new_domain_);
      END IF;
   END IF;
END Set_Domain;


PROCEDURE Set_New (
   record_ IN OUT type_record_ )
IS
BEGIN
   Set_Record_Status___(record_, new_record_);
END Set_New;


PROCEDURE Set_Queried (
   record_ IN OUT type_record_ )
IS
BEGIN
   Set_Record_Status___(record_, queried_record_);
END Set_Queried;


PROCEDURE Set_Removed (
   record_ IN OUT type_record_ )
IS
BEGIN
   Set_Record_Status___(record_, removed_record_);
END Set_Removed;


FUNCTION Is_Dirty (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN BOOLEAN
IS
   item_rec_ type_item_record_ := Get_Record_Item_By_Name___(record_, name_);
BEGIN
   IF ( item_rec_.status_ = '*' ) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Dirty;


PROCEDURE Make_Dirty (
   record_ IN type_record_,
   name_   IN type_name_ )
IS
   item_rec_ type_item_record_ := Get_Record_Item_By_Name___(record_, name_);
BEGIN
   Plsqlap_Buffer_API.Set_Item_Status(item_rec_.item_, '*');
END Make_Dirty;


FUNCTION Get_Attribute (
   record_   IN type_record_,
   position_ IN NUMBER ) RETURN type_item_record_
IS
BEGIN
   RETURN Get_Record_Item_By_Pos___(record_, position_);
END Get_Attribute;


FUNCTION Get_Attribute (
   record_   IN type_record_,
   name_     IN type_name_ ) RETURN type_item_record_
IS
BEGIN
   RETURN Get_Record_Item_By_Name___(record_, name_);
END Get_Attribute;


FUNCTION Get_Record_Attr (
   record_ IN type_record_) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32767);
   
   CURSOR get_attributes IS   
      SELECT name,
             value,
             typ
      FROM   plsqlap_buffer_tmp a
      WHERE  typ IN (DT_BOOLEAN, DT_INTEGER, DT_DECIMAL, DT_MONEY, DT_FLOAT,
                     DT_TEXT, DT_TEXT_KEY, DT_TEXT_REFERENCE, DT_LONG_TEXT, DT_DATE, DT_TIME, DT_TIMESTAMP,
                     DT_ALPHA, DT_ENUMERATION, DT_AGGREGATE, DT_REFERENCE)
      AND    buffer = record_.data_
      ORDER BY sequence_no;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   
   FOR rec_ IN get_attributes LOOP
      IF (rec_.typ IN (DT_TEXT_KEY, DT_TEXT_REFERENCE) ) THEN
         Client_SYS.Add_To_Attr(rec_.name, Get_Value_Part___(rec_.value), attr_);
      ELSE
         Client_SYS.Add_To_Attr(rec_.name, rec_.value, attr_);
      END IF;
   END LOOP;
   
   RETURN attr_;
END Get_Record_Attr;


FUNCTION Get_Value (
   attr_ IN type_item_record_ ) RETURN type_value_
IS
BEGIN
   IF ( attr_.type_ IN (DT_TEXT_KEY, DT_TEXT_REFERENCE) ) THEN
      RETURN Get_Value_Part___(attr_.value_);
   ELSE
     RETURN attr_.value_;
   END IF;
END Get_Value;


FUNCTION Get_Value (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN type_value_
IS
   item_rec_ type_item_record_ := Get_Record_Item_By_Name___(record_, name_);
BEGIN
   IF ( item_rec_.type_ IN (DT_TEXT_KEY, DT_TEXT_REFERENCE) ) THEN
      RETURN Get_Value_Part___(item_rec_.value_);
   ELSE
      RETURN item_rec_.value_;
   END IF;
END Get_Value;


FUNCTION Get_Clob_Value (
   attr_ IN type_item_record_ ) RETURN type_clob_value_
IS
BEGIN
   IF ( attr_.type_ IN (DT_TEXT_KEY, DT_TEXT_REFERENCE) ) THEN
      RETURN Get_Value_Part___(NVL(attr_.clob_value_, attr_.value_));
   ELSIF (attr_.type_ = DT_CLOB) THEN
      RETURN attr_.clob_value_;
   ELSE
     RETURN attr_.value_;
   END IF;
END Get_Clob_Value;


FUNCTION Get_Clob_Value (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN type_clob_value_
IS
   item_rec_ type_item_record_ := Get_Record_Item_By_Name___(record_, name_);
BEGIN
   IF ( item_rec_.type_ IN (DT_TEXT_KEY, DT_TEXT_REFERENCE) ) THEN
      RETURN Get_Value_Part___(NVL(item_rec_.clob_value_, item_rec_.value_));
   ELSIF (item_rec_.type_ = DT_CLOB) THEN
      RETURN item_rec_.clob_value_;
   ELSE
      -- When an incoming XML (not generated by IFS) is parsed into
      -- a PlsqlapRecord it cannot be determined if a given XML tag
      -- is supposed to be a CLOB or not. Therefore the value for 
      -- one and the same XML tag can either be stored in VALUE_ or
      -- in CLOB_VALUE_ depending on its actual size in the XML.
      -- Therfore we need to fallback to the text value.
      RETURN item_rec_.value_;
   END IF;
END Get_Clob_Value;


FUNCTION Get_Long_Text_Value (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN CLOB
IS
   append_buffer_    VARCHAR2(32767);
   value_            CLOB;
   count_main_       NUMBER;
   count_attributes_ NUMBER;
   body_             type_record_;
   attribute_        VARCHAR2(13);

   PROCEDURE Move_To_Clob
   IS
   BEGIN
      IF (append_buffer_ IS NOT NULL) THEN
         DBMS_LOB.WriteAppend(value_, LENGTH(append_buffer_), append_buffer_);
         append_buffer_ := '';
      END IF;
   END Move_To_Clob;

   PROCEDURE Append_Text (
      text_ IN VARCHAR2 )
   IS
   BEGIN
      append_buffer_ := append_buffer_ || text_;
   EXCEPTION
      WHEN value_error THEN
         Move_To_Clob;
         append_buffer_ := text_;
   END Append_Text;

   PROCEDURE Append_Text (
      text_ IN CLOB)
   IS
   BEGIN
      Move_To_Clob;
      IF (text_ IS NOT NULL AND DBMS_LOB.GetLength(text_) > 0) THEN
         DBMS_LOB.Append(value_, text_);
      END IF;
   END Append_Text;
BEGIN
   DBMS_LOB.CreateTemporary(value_, TRUE, DBMS_LOB.CALL);

   count_main_ := NVL(Count_Elements(record_, name_),0); -- should either be 1 or 0

   IF (count_main_ > 0) THEN -- no compound
      FOR i IN 1..count_main_ LOOP
         body_ := Get_Element(record_, name_, i);

         count_attributes_ := NVL(Count_Attributes(body_),0);
         
         IF (count_attributes_ > 0) THEN
            IF(count_attributes_ = 1) THEN
               -- text value less than 4000
               IF (body_.name_ = 'TEXT_BODY') THEN
                  attribute_ := 'TEXT_VALUE';
               ELSIF (body_.name_ = 'BINARY_BODY') THEN
                  attribute_ := 'BINARY_VALUE';
               END IF;
               
               Append_Text(Get_Clob_Value(body_, attribute_));
               
            ELSIF (count_attributes_ > 1)  THEN                
               IF (body_.name_ = 'TEXT_BODY') THEN
                  attribute_ := 'TEXT_VALUE_';
               ELSIF (body_.name_ = 'BINARY_BODY') THEN
                  attribute_ := 'BINARY_VALUE_';
               END IF;
               FOR j IN 1..count_attributes_ LOOP
                  Append_Text(Get_Value(body_, attribute_ || j));
               END LOOP;
            END IF;
         END IF;
      END LOOP;
   ELSE
      Append_Text(Get_Clob_Value(record_, name_));
   END IF;

   Move_To_Clob;

   RETURN value_;
END Get_Long_Text_Value;


FUNCTION Get_Blob_Value (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN type_blob_value_
IS
   item_rec_ type_item_record_ := Get_Record_Item_By_Name___(record_, name_);
BEGIN
   RETURN item_rec_.blob_value_;
END Get_Blob_Value;


FUNCTION Get_Binary_Value (
   record_ IN type_record_,
   name_   IN type_name_,
   base64_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN BLOB
IS
   clob_value_ CLOB;
   blob_value_ BLOB;
   total_length_ NUMBER;
   count_        NUMBER;
   -- buffer size has to be devisable by three for base64 encode
   -- For some reason 32763 and 32766 don't work? Oracle Bug?
   buffer_size_  NUMBER := 32760;

   buffer_     VARCHAR2(32767);
   pos_        NUMBER := 1;
   tmp_        RAW(32767);
BEGIN
   DBMS_LOB.CREATETEMPORARY(blob_value_, TRUE, DBMS_LOB.CALL);

   clob_value_   := Get_Long_Text_Value(record_, name_);
   IF base64_ = 'TRUE' THEN
      clob_value_ := REPLACE(clob_value_, CHR(10));
      clob_value_ := REPLACE(clob_value_, CHR(13));
   END IF;
   total_length_ := NVL(DBMS_LOB.GETLENGTH(clob_value_), 0);

   IF (total_length_ > 0) THEN
      count_        := CEIL(total_length_ / buffer_size_);
      FOR i IN 1..count_ LOOP
         DBMS_LOB.READ(clob_value_, buffer_size_, pos_, buffer_);
         IF (base64_ = 'TRUE') THEN
            tmp_ := UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(buffer_));
         ELSE
            tmp_ := UTL_RAW.CAST_TO_RAW(buffer_);
         END IF;
         DBMS_LOB.WRITEAPPEND(blob_value_, UTL_RAW.LENGTH(tmp_), tmp_);
         pos_ := pos_ + buffer_size_;
      END LOOP;
   END IF;

   RETURN blob_value_;
END Get_Binary_Value;


FUNCTION Get_Domain (
   attr_ IN type_item_record_ ) RETURN type_domain_
IS
BEGIN
   IF ( attr_.type_ IN (DT_TEXT_KEY, DT_TEXT_REFERENCE) ) THEN
      RETURN Get_Domain_Part___(attr_.value_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Domain;


FUNCTION Get_Domain (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN type_domain_
IS
   item_rec_ type_item_record_ := Get_Record_Item_By_Name___(record_, name_);
BEGIN
   IF ( item_rec_.type_ IN (DT_TEXT_KEY, DT_TEXT_REFERENCE) ) THEN
      RETURN Get_Domain_Part___(item_rec_.value_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Domain;


FUNCTION Get_Item_Value (
   record_ IN type_record_,
   name_   IN type_name_ ) RETURN type_value_
IS
   item_rec_ type_item_record_;
BEGIN
   item_rec_ := Get_Record_Item_By_Name___(record_, name_);
   IF ( item_rec_.type_ IN (DT_TEXT_KEY, DT_TEXT_REFERENCE) ) THEN
      RETURN Get_Value_Part___(item_rec_.value_);
   ELSE
      RETURN item_rec_.value_;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
END Get_Item_Value;


PROCEDURE Set_Value (
   record_         IN OUT type_record_,
   name_           IN     type_name_,
   value_          IN     NUMBER,
   type_           IN     type_typ_ DEFAULT DT_FLOAT,
   dirty_          IN     BOOLEAN DEFAULT TRUE,
   case_sensitive_ IN     BOOLEAN DEFAULT FALSE )
IS
   type_error_ EXCEPTION;
BEGIN
   IF ( type_ NOT IN (DT_INTEGER, DT_DECIMAL, DT_MONEY, DT_FLOAT) ) THEN
      RAISE type_error_;
   END IF;
   Set_Value___(record_, name_, REPLACE(TO_CHAR(value_),',','.'), type_, dirty_, case_sensitive_);
EXCEPTION
   WHEN type_error_ THEN
      Raise_Error___('PlsqlapRecord', 'Type is ":P1", must be dt_Integer, dt_Decimal, dt_Money or dt_Float', type_);
END Set_Value;


PROCEDURE Set_Value (
   record_         IN OUT type_record_,
   name_           IN     type_name_,
   value_          IN     DATE,
   type_           IN     type_typ_ DEFAULT DT_TIMESTAMP,
   dirty_          IN     BOOLEAN DEFAULT TRUE,
   case_sensitive_ IN     BOOLEAN DEFAULT FALSE )
IS
   type_error_ EXCEPTION;
BEGIN
   IF ( type_ NOT IN (DT_DATE, DT_TIME, DT_TIMESTAMP) ) THEN
      RAISE type_error_;
   END IF;
   IF (type_ = DT_TIMESTAMP) THEN
      Set_Value___(record_, name_, TO_CHAR(value_, format_time_stamp_), type_, dirty_, case_sensitive_);
   END IF;
   IF (type_ = DT_TIME) THEN
      Set_Value___(record_, name_, TO_CHAR(value_, format_time_), type_, dirty_, case_sensitive_);
   END IF;
   IF (type_ = DT_DATE) THEN
      Set_Value___(record_, name_, TO_CHAR(value_, format_date_), type_, dirty_, case_sensitive_);
   END IF;
EXCEPTION
   WHEN type_error_ THEN
      Raise_Error___('PlsqlapRecord', 'Type is ":P1", must be dt_Date, dt_Time or dt_TimeStamp', type_);
END Set_Value;


PROCEDURE Set_Value (
   record_         IN OUT type_record_,
   name_           IN     type_name_,
   value_          IN     BOOLEAN,
   type_           IN     type_typ_ DEFAULT DT_BOOLEAN,
   dirty_          IN     BOOLEAN DEFAULT TRUE,
   case_sensitive_ IN     BOOLEAN DEFAULT FALSE )
IS
   new_value_  type_value_  := NULL;
   type_error_ EXCEPTION;
BEGIN
   IF ( type_ <> DT_BOOLEAN ) THEN
      RAISE type_error_;
   END IF;
   IF ( value_ ) THEN
      new_value_ := 'TRUE';
   ELSE
      new_value_ := 'FALSE';
   END IF;
   Set_Value___(record_, name_, new_value_, type_, dirty_, case_sensitive_);
EXCEPTION
   WHEN type_error_ THEN
      Raise_Error___('PlsqlapRecord', 'Type is ":P1", must be dt_Boolean', type_);
END Set_Value;


PROCEDURE Set_Value (
   record_         IN OUT type_record_,
   name_           IN     type_name_,
   value_          IN     VARCHAR2,
   type_           IN     type_typ_ DEFAULT DT_TEXT,
   dirty_          IN     BOOLEAN DEFAULT TRUE,
   case_sensitive_ IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Set_Text_Value___(
      record_     => record_,
      name_       => name_,
      value_      => value_,
      type_       => type_,
      dirty_      => dirty_,
      case_sensitive_ => case_sensitive_);
END Set_Value;


PROCEDURE Set_Value (
   record_         IN OUT NOCOPY type_record_,
   name_           IN     type_name_,
   value_          IN     CLOB,
   type_           IN     type_typ_ DEFAULT DT_CLOB,
   dirty_          IN     BOOLEAN DEFAULT TRUE,
   case_sensitive_ IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Set_Clob_Value___(
      record_     => record_,
      name_       => name_,
      clob_value_ => value_,
      type_       => type_,
      dirty_      => dirty_,
      case_sensitive_ => case_sensitive_);
END Set_Value;

PROCEDURE Set_Value (
   record_         IN OUT NOCOPY type_record_,
   name_           IN     type_name_,
   value_          IN     BLOB,
   type_           IN     type_typ_ DEFAULT DT_BLOB,
   dirty_          IN     BOOLEAN DEFAULT TRUE,
   case_sensitive_ IN     BOOLEAN DEFAULT FALSE )
IS
   converted_clob_   CLOB := ' ';
BEGIN
   Utility_SYS.Convert_Blob_To_Base64(converted_clob_,value_);
   Set_Clob_Value___(
      record_     => record_,
      name_       => name_,
      clob_value_ => converted_clob_,
      type_       => type_,
      dirty_      => dirty_,
      case_sensitive_ => case_sensitive_);

END Set_Value;

PROCEDURE Set_Clob_Value (
   record_         IN OUT NOCOPY type_record_,
   name_           IN            type_name_,
   clob_value_     IN            type_clob_value_,
   type_           IN            type_typ_ DEFAULT DT_CLOB,
   dirty_          IN            BOOLEAN DEFAULT TRUE,
   case_sensitive_ IN            BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Set_Clob_Value___(
      record_     => record_,
      name_       => name_,
      clob_value_ => clob_value_,
      type_       => type_,
      dirty_      => dirty_,
      case_sensitive_ => case_sensitive_);
END Set_Clob_Value;


PROCEDURE Set_Blob_Value (
   record_         IN OUT NOCOPY type_record_,
   name_           IN            type_name_,
   blob_value_     IN            type_blob_value_,
   type_           IN            type_typ_ DEFAULT DT_BLOB,
   dirty_          IN            BOOLEAN  DEFAULT TRUE,
   case_sensitive_ IN            BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Set_Blob_Value___(
      record_     => record_,
      name_       => name_,
      blob_value_ => blob_value_,
      type_       => type_,
      dirty_      => dirty_,
      case_sensitive_ => case_sensitive_);
END Set_Blob_Value;


FUNCTION To_XML (
   record_    IN type_record_) RETURN VARCHAR2 
IS
   xml_ VARCHAR2(32767);
BEGIN
   xml_ := '<' || record_.name_ || '>';
   xml_ := xml_ || PLSQLAP_Buffer_API.To_XML(record_.data_);
   xml_ := xml_ || '</' || record_.name_ || '>';
   RETURN xml_;
END To_XML;


PROCEDURE To_Xml (
   xml_    OUT CLOB,
   record_ IN  type_record_,
   rest_   IN  BOOLEAN DEFAULT FALSE)
IS
   temp_ clob;
BEGIN
   xml_ := '<' || record_.name_ || '>';
   PLSQLAP_Buffer_API.To_XML( temp_, record_.data_, rest_);
   dbms_lob.append(xml_, temp_);
   dbms_lob.append(xml_, TO_CLOB('</' || record_.name_ || '>'));
END To_Xml;


FUNCTION From_XML (doc_ Xmltype) RETURN type_record_ 
IS
   record_ type_record_;
   nodename_ VARCHAR2(255);
   domdoc_ dbms_xmldom.DOMDocument;
BEGIN
   nodename_ := XMLType.getRootElement(doc_);
   record_ := New_Record(nodename_);
   domdoc_ := dbms_xmldom.newDOMDocument(doc_);
   Add_XML_Nodes___(record_, dbms_xmldom.getChildNodes(dbms_xmldom.makeNode(dbms_xmldom.getDocumentElement(domdoc_))));
   Dbms_Xmldom.Freedocument(domdoc_);
   RETURN record_;
END From_XML;


FUNCTION From_XML (
   doc_ CLOB,
   root_name_ VARCHAR2 DEFAULT NULL) RETURN type_record_
IS
   record_ type_record_;
BEGIN
   record_ := From_Xml(XMLTYPE(doc_));

   IF (root_name_ IS NOT NULL AND NVL(record_.name_, chr(2)) <> root_name_) THEN
      Error_SYS.Record_General(lu_name_, 'INV_FILE: Invalid XML! Root should be ":P1" but was ":P2".', root_name_, record_.name_);
   END IF;

   RETURN record_;
END From_XML;


FUNCTION From_XML (
   doc_ VARCHAR2,
   root_name_ VARCHAR2 DEFAULT NULL) RETURN type_record_
IS
   record_ type_record_;
BEGIN
   record_ := From_Xml(XMLTYPE(doc_));

   IF (root_name_ IS NOT NULL AND NVL(record_.name_, chr(2)) <> root_name_) THEN
      Error_SYS.Record_General(lu_name_, 'INV_FILE: Invalid XML! Root should be ":P1" but was ":P2".', root_name_, record_.name_);
   END IF;

   RETURN record_;
END From_XML;
