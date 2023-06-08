-----------------------------------------------------------------------------
--
--  Logical unit: PlsqlapBuffer
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000710  JhMa    Created
--  000802  DaJo    Fixed bugg in Add_Item for numeric values (must always use
--                  period as decimal separator in buffers)
--  000803  ToBa    Changed module name to PLAP
--  000821  JhMa    Added support for Application Context
--  010820  ROOD    Changed module to FNDSER (ToDo#4021).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  031004  ROOD    Increased variable line_ in Print_Compound___ (Bug#37931).
--  031005  ROOD    Merged changes earlier made only in FNDAS (DaJo 020829).
--  040219  jhmase  Bug #42591
--  040317  jhmase  New timestamp
--  050210  DOZE    Added To_XML (F1PR477)
--  050309  HAAR    Added method security (F1PR477).
--  061114  UTGULK  Added Procedure To_Xml to support strings with length>32K.(Bug#58694).
--  070820  JHMASE  Added encoding of markup characters
--  091130  JHMASE  Added index hint. Removed Autonomous Transaction. (Bug #87430).
--  100428  JHMASE  Inefficient cleanup process of PLSQLAP_BUFFER_TMP table (Bug #90312).
--  120411  JHMASE  Clear_Buffer is not removing all records (Bug #102139/RDTERUNTIME-2800).
--  130321  JHMASE Bad performance in To_XML procedure (Bug #109026)
--  140205  ASWILK Improved performance in To_XML (Bug#112975 Merged).
--  160822  CSarlk  Modified for CLOB/BLOB support
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

SUBTYPE type_buffer_           IS PLSQLAP_BUFFER_TMP.buffer%TYPE;
SUBTYPE type_item_             IS PLSQLAP_BUFFER_TMP.name%TYPE;
SUBTYPE type_name_             IS type_item_;
SUBTYPE type_value_            IS PLSQLAP_BUFFER_TMP.value%TYPE;
SUBTYPE type_clob_value_       IS PLSQLAP_BUFFER_TMP.clob_value%TYPE;
SUBTYPE type_blob_value_       IS PLSQLAP_BUFFER_TMP.blob_value%TYPE;
SUBTYPE type_typ_              IS PLSQLAP_BUFFER_TMP.typ%TYPE;
SUBTYPE type_status_           IS PLSQLAP_BUFFER_TMP.status%TYPE;
SUBTYPE type_error_category_   IS type_value_;
SUBTYPE type_error_message_    IS type_value_;
SUBTYPE type_error_name_       IS type_value_;
SUBTYPE type_error_severity_   IS type_value_;
app_context_         CONSTANT type_buffer_ := '$$APP_CONTEXT$$';

-------------------- PRIVATE DECLARATIONS -----------------------------------

parameter_not_found_ EXCEPTION;
dont_change_         CONSTANT VARCHAR2(15) := '__DONT_CHANGE__';
TYPE buffer_record_type_ IS RECORD
  (rowid_            ROWID,
   buffer_           PLSQLAP_BUFFER_TMP.buffer%TYPE,
   sequence_no_      PLSQLAP_BUFFER_TMP.sequence_no%TYPE,
   name_             PLSQLAP_BUFFER_TMP.name%TYPE,
   value_            PLSQLAP_BUFFER_TMP.value%TYPE,
   typ_              PLSQLAP_BUFFER_TMP.typ%TYPE,
   status_           PLSQLAP_BUFFER_TMP.status%TYPE,
   compound_item_    PLSQLAP_BUFFER_TMP.compound_item%TYPE,
   clob_value_       PLSQLAP_BUFFER_TMP.clob_value%TYPE,
   blob_value_       PLSQLAP_BUFFER_TMP.blob_value%TYPE);
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Add_Item___ (
   buffer_      IN type_buffer_,
   name_        IN type_name_,
   value_       IN type_value_,
   typ_         IN type_typ_,
   status_      IN type_status_,
   is_compound_ IN VARCHAR2 )
IS
   sequence_no_ NUMBER;
BEGIN
   sequence_no_ := Get_Next_Seq_No___(buffer_);
   INSERT INTO PLSQLAP_BUFFER_TMP
      ( buffer,  sequence_no,  name,  value,  typ,  status,  compound_item )
   VALUES
      ( buffer_, sequence_no_, name_, value_, typ_, status_, is_compound_ );
END Add_Item___;

PROCEDURE Add_Item___ (
   buffer_      IN type_buffer_,
   name_        IN type_name_,
   clob_value_  IN type_clob_value_,
   typ_         IN type_typ_,
   status_      IN type_status_,
   is_compound_ IN VARCHAR2 )
IS
   sequence_no_ NUMBER;
BEGIN
   sequence_no_ := Get_Next_Seq_No___(buffer_);
   INSERT INTO PLSQLAP_BUFFER_TMP
      ( buffer,  sequence_no,  name,  clob_value, typ,  status,  compound_item )
   VALUES
      ( buffer_, sequence_no_, name_, clob_value_, typ_, status_, is_compound_ );
END Add_Item___;

PROCEDURE Add_Clob_Item___ (
   buffer_      IN type_buffer_,
   name_        IN type_name_,
   clob_value_  IN type_clob_value_,
   type_        IN type_typ_,
   status_      IN type_status_,
   is_compound_ IN VARCHAR2 )
IS
   sequence_no_ NUMBER;
BEGIN
   sequence_no_ := Get_Next_Seq_No___(buffer_);
   INSERT INTO PLSQLAP_BUFFER_TMP
      ( buffer,  sequence_no,  name,  value,  typ,  status,  compound_item, clob_value )
   VALUES
      ( buffer_, sequence_no_, name_, NULL, type_, status_, is_compound_, clob_value_ );
END Add_Clob_Item___;


PROCEDURE Add_Blob_Item___ (
   buffer_      IN type_buffer_,
   name_        IN type_name_,
   blob_value_  IN type_blob_value_,
   type_        IN type_typ_,
   status_      IN type_status_,
   is_compound_ IN VARCHAR2 )
IS
   sequence_no_ NUMBER;
BEGIN
   sequence_no_ := Get_Next_Seq_No___(buffer_);
   INSERT INTO PLSQLAP_BUFFER_TMP
      ( buffer,  sequence_no,  name,  value,  typ,  status,  compound_item, blob_value )
   VALUES
      ( buffer_, sequence_no_, name_, NULL, type_, status_, is_compound_, blob_value_ );
END Add_Blob_Item___;


PROCEDURE Get_Item___ (
   item_          IN  type_item_,
   buffer_record_ OUT buffer_record_type_ )
IS
   item_not_found_  EXCEPTION;
   CURSOR get_item_ IS
      SELECT rowid, a.buffer, a.sequence_no, a.name, a.value, a.typ, a.status, a.compound_item, a.clob_value, a.blob_value
      FROM   PLSQLAP_BUFFER_TMP a
      WHERE  a.rowid = item_;
BEGIN
   OPEN get_item_;
   FETCH get_item_ INTO buffer_record_;
   IF ( get_item_%NOTFOUND ) THEN
      CLOSE get_item_;
      RAISE item_not_found_;
   END IF;
   CLOSE get_item_;
EXCEPTION
   WHEN item_not_found_ THEN
      Error_SYS.Item_Not_Exist('PlsqlapBuffer', '', '', 'ERROR: Cant find item [:P1]', item_);
   WHEN OTHERS THEN
      RAISE;
END Get_Item___;

FUNCTION Get_Item___ (
   buffer_        IN  type_buffer_,
   name_          IN  type_name_,
   pos_           IN  NUMBER,
   buffer_record_ OUT buffer_record_type_ ) RETURN BOOLEAN
IS
   CURSOR get_item_by_name_ IS
      SELECT /*+ INDEX (a PLSQLAP_BUFFER_IX) */ rowid, a.buffer, a.sequence_no, a.name, a.value, a.typ, a.status, a.compound_item, a.clob_value, a.blob_value
      FROM   PLSQLAP_BUFFER_TMP a
      WHERE  a.buffer = buffer_
      AND    a.name   = name_
      AND    a.name   IS NOT NULL;
   CURSOR get_item_by_pos_ IS
      SELECT /*+ INDEX (a PLSQLAP_BUFFER_IX) */ rowid, a.buffer, a.sequence_no, a.name, a.value, a.typ, a.status, a.compound_item, a.clob_value, a.blob_value
      FROM   PLSQLAP_BUFFER_TMP a
      WHERE  a.buffer      = buffer_
      AND    a.sequence_no = pos_;
BEGIN
   IF ( name_ IS NOT NULL ) THEN
      OPEN get_item_by_name_;
      FETCH get_item_by_name_ INTO buffer_record_;
      IF ( get_item_by_name_%NOTFOUND ) THEN
         CLOSE get_item_by_name_;
         RETURN FALSE;
      END IF;
      CLOSE get_item_by_name_;
      RETURN TRUE;
   END IF;
   IF ( pos_ IS NOT NULL ) THEN
      OPEN get_item_by_pos_;
      FETCH get_item_by_pos_ INTO buffer_record_;
      IF ( get_item_by_pos_%NOTFOUND ) THEN
         CLOSE get_item_by_pos_;
         RETURN FALSE;
      END IF;
      CLOSE get_item_by_pos_;
      RETURN TRUE;
   END IF;
   RETURN FALSE;
END Get_Item___;

--This method is used to get element from composite element but which is not an array
FUNCTION Get_Item_From_Comp_Elem___ (
   buffer_        IN  type_buffer_,
   name_          IN  type_name_,
   pos_           IN  NUMBER,
   buffer_record_ OUT buffer_record_type_ ) RETURN BOOLEAN
IS
   CURSOR get_item_by_name_ IS
      SELECT /*+ INDEX (a PLSQLAP_BUFFER_IX) */ rowid, a.buffer, a.sequence_no, a.name, a.value, a.typ, a.status, a.compound_item, a.clob_value, a.blob_value
      FROM   PLSQLAP_BUFFER_TMP a
      WHERE  a.buffer = buffer_
      AND    a.name   = name_
      AND    a.name   IS NOT NULL;
      
   count_ NUMBER := 0;
BEGIN
   IF ( name_ IS NOT NULL AND pos_ IS NOT NULL ) THEN
      FOR item_by_name IN get_item_by_name_ LOOP
         count_ := count_+1;
         IF(count_ = pos_)THEN
            buffer_record_ := item_by_name;
         END IF;
      END LOOP;
      RETURN TRUE;
   END IF;
   RETURN FALSE;
END Get_Item_From_Comp_Elem___;

FUNCTION Get_Item_In_Max_Pos___ (
   buffer_        IN  type_buffer_,
   name_          IN  type_name_,
   buffer_record_ OUT buffer_record_type_) RETURN BOOLEAN
IS
   CURSOR get_item_by_name_in_max_pos_ IS
      SELECT /*+ INDEX (a PLSQLAP_BUFFER_IX) */ rowid, a.buffer, a.sequence_no, a.name, a.value, a.typ, a.status, a.compound_item, a.clob_value, a.blob_value
      FROM   PLSQLAP_BUFFER_TMP a
      WHERE  a.buffer = buffer_
      AND    a.name   = name_
      AND    a.name   IS NOT NULL
      AND    a.sequence_no =(SELECT MAX(t.sequence_no) FROM PLSQLAP_BUFFER_TMP t WHERE t.buffer = buffer_ AND t.name = name_ AND t.name IS NOT NULL);
BEGIN
   IF ( name_ IS NOT NULL ) THEN
      OPEN get_item_by_name_in_max_pos_;
      FETCH get_item_by_name_in_max_pos_ INTO buffer_record_;
      IF ( get_item_by_name_in_max_pos_%NOTFOUND ) THEN
         CLOSE get_item_by_name_in_max_pos_;
         RETURN FALSE;
      END IF;
      CLOSE get_item_by_name_in_max_pos_;
      RETURN TRUE;
   END IF;
   RETURN FALSE;
END Get_Item_In_Max_Pos___;

FUNCTION Get_Next_Seq_No___ (
   buffer_ IN type_buffer_ ) RETURN NUMBER
IS
   current_number_   NUMBER;
   CURSOR get_next_sequence_no_ IS
      SELECT /*+ INDEX (a PLSQLAP_BUFFER_IX) */ NVL(MAX(a.sequence_no) + 1, 1)
      FROM   PLSQLAP_BUFFER_TMP a
      WHERE  a.buffer = buffer_;
BEGIN
   OPEN get_next_sequence_no_;
   FETCH get_next_sequence_no_ INTO current_number_;
   IF ( get_next_sequence_no_%NOTFOUND ) THEN
      current_number_ := 1;
   END IF;
   CLOSE get_next_sequence_no_;
   RETURN current_number_;
END Get_Next_Seq_No___;


PROCEDURE Print_Compound___(buffer_      IN type_buffer_,
                            level_       IN OUT NUMBER,
                            debug_level_ IN NUMBER DEFAULT Log_SYS.debug_) IS
   line_     VARCHAR2(32767);
   item_     type_item_;
   value_    type_value_;
   clob_value_ type_clob_value_;
   blob_value_ type_blob_value_;
   typ_      type_typ_;
   status_   type_status_;
   compound_ BOOLEAN;
BEGIN
   FOR i IN 1 .. Count_Items(buffer_) LOOP
      item_     := Get_Item_By_Position(buffer_, i);
      line_     := TO_CHAR(i) || ':$' || Get_Name(item_);
      typ_      := Get_Type(item_);
      status_   := Get_Status(item_);
      compound_ := Is_Compound(item_);
      IF (typ_ IS NOT NULL) THEN
         line_ := line_ || ':' || typ_;
      END IF;
      IF (status_ IS NOT NULL) THEN
         line_ := line_ || '/' || status_;
      END IF;
      IF (compound_) THEN
         value_ := Get_Buffer(item_);
         line_  := line_ || '=';
      ELSE
         value_ := Get_Value(item_);
         IF (value_ IS NOT NULL) THEN
            line_ := line_ || '=' || value_;
         ELSE
            clob_value_ := Get_Clob_Value(item_);
            IF (clob_value_ IS NOT NULL) THEN 
               line_ := line_ || '=' || dbms_lob.substr(clob_value_, 255, 1) || '...';
            ELSE 
               blob_value_ := Get_Blob_Value(item_);
               IF (blob_value_ IS NOT NULL) THEN 
                  line_ := line_ || '=' || '...';
               ELSE 
                  line_ := line_ || '*';
               END IF;
            END IF;
         END IF;
      END IF;
      line_ := LPAD(line_, (level_ * 3 + LENGTH(line_)), '-');
      IF (LENGTH(line_) > 255) THEN
         line_ := SUBSTR(line_, 1, 230) || '... (' || TO_CHAR(LENGTH(line_)) || ' characters)';
      END IF;
      Log_SYS.Fnd_Trace_(debug_level_, line_);
      IF (compound_) THEN
         level_ := level_ + 1;
         Print_Compound___(value_, level_, debug_level_);
         level_ := level_ - 1;
      END IF;
   END LOOP;
END Print_Compound___;

      

FUNCTION Get_Context_Parameter___ (
   name_ IN type_name_ ) RETURN VARCHAR2
IS
   item_ type_item_;
BEGIN
   item_ := Get_Item_By_Name(app_context_, name_);
   IF ( item_ IS NULL ) THEN
      RAISE parameter_not_found_;
   END IF;
   RETURN Get_Value(item_);
END Get_Context_Parameter___;


PROCEDURE Set_Context_Parameter___ (
   name_   IN type_name_,
   value_  IN type_value_,
   typ_    IN type_typ_    DEFAULT NULL,
   status_ IN type_status_ DEFAULT NULL )
IS
   item_   type_item_;
BEGIN
   item_ := Get_Item_By_Name(app_context_, name_);
   IF ( item_ IS NULL ) THEN
      Add_Item___(app_context_, name_, value_, typ_, status_, 'FALSE');
   ELSE
      Set_Item___(item_, value_, typ_, status_);
   END IF;
END Set_Context_Parameter___;


PROCEDURE Set_Item___ (
   item_   IN type_item_,
   value_  IN type_value_,
   typ_    IN type_typ_,
   status_ IN type_status_ )
IS
BEGIN
   UPDATE PLSQLAP_BUFFER_TMP a
   SET a.value  = DECODE(value_,  dont_change_, a.value,  value_),
       a.typ    = DECODE(typ_,    dont_change_, a.typ,    typ_),
       a.status = DECODE(status_, dont_change_, a.status, status_)
   WHERE a.rowid = item_;
   IF ( SQL%NOTFOUND ) THEN
      RAISE No_Data_Found;
   END IF;
END Set_Item___;

PROCEDURE Set_Item___ (
   item_   IN type_item_,
   clob_value_  IN type_clob_value_,
   typ_    IN type_typ_,
   status_ IN type_status_ )
IS
BEGIN
   UPDATE PLSQLAP_BUFFER_TMP a
   SET a.clob_value  = (SELECT 
                           CASE
                             WHEN Dbms_Lob.instr(clob_value_, dont_change_) >0 THEN a.clob_value
                             ELSE clob_value_
                           END
                        FROM PLSQLAP_BUFFER_TMP b
                        WHERE b.rowid = a.rowid),
       a.typ    = DECODE(typ_,    dont_change_, a.typ,    typ_),
       a.status = DECODE(status_, dont_change_, a.status, status_)
   WHERE a.rowid = item_;
   IF ( SQL%NOTFOUND ) THEN
      RAISE No_Data_Found;
   END IF;
END Set_Item___;

PROCEDURE Set_Clob_Item___ (
   item_       IN type_item_,
   clob_value_ IN type_clob_value_,
   typ_        IN type_typ_,
   status_     IN type_status_ )
IS
BEGIN
   IF clob_value_ != dont_change_ THEN 
      UPDATE PLSQLAP_BUFFER_TMP a
      SET a.clob_value = clob_value_,
          a.typ    = DECODE(typ_,    dont_change_, a.typ,    typ_),
          a.status = DECODE(status_, dont_change_, a.status, status_)
      WHERE a.rowid = item_;
      IF ( SQL%NOTFOUND ) THEN
         RAISE No_Data_Found;
      END IF;
   END IF;
END Set_Clob_Item___;


PROCEDURE Set_Blob_Item___ (
   item_       IN type_item_,
   blob_value_ IN type_blob_value_,
   typ_        IN type_typ_,
   status_     IN type_status_ )
IS
BEGIN
--   IF blob_value_ != dont_change_ THEN 
      UPDATE PLSQLAP_BUFFER_TMP a
      SET a.blob_value = blob_value_,
          a.typ    = DECODE(typ_,    dont_change_, a.typ,    typ_),
          a.status = DECODE(status_, dont_change_, a.status, status_)
      WHERE a.rowid = item_;
      IF ( SQL%NOTFOUND ) THEN
         RAISE No_Data_Found;
      END IF;
--   END IF;
END Set_Blob_Item___;


PROCEDURE Remove_Context_Parameter___ (
   name_ IN type_name_ )
IS
   item_   type_item_;
   buffer_ type_buffer_;
   seq_no_ NUMBER;
BEGIN
   item_ := Get_Item_By_Name(app_context_, name_);
   IF ( item_ IS NOT NULL ) THEN
      SELECT a.sequence_no, a.buffer
      INTO   seq_no_, buffer_
      FROM   PLSQLAP_BUFFER_TMP a
      WHERE  a.rowid = item_;
      DELETE
      FROM   PLSQLAP_BUFFER_TMP a
      WHERE  a.rowid = item_;
      UPDATE PLSQLAP_BUFFER_TMP a
      SET    a.sequence_no = a.sequence_no - 1
      WHERE  a.buffer      = buffer_
      AND    a.sequence_no > seq_no_;
   END IF;
END Remove_Context_Parameter___;


FUNCTION To_Boolean___ (
   value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF ( value_ = 'TRUE' ) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END To_Boolean___;


FUNCTION To_String___ (
   value_ IN BOOLEAN ) RETURN VARCHAR2
IS
BEGIN
   IF ( value_ ) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END To_String___;


FUNCTION Encode_Markup_Characters___ (
   value_  IN VARCHAR2,
   type_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF ( type_ IN (Plsqlap_Record_API.dt_Text,
                  Plsqlap_Record_API.dt_Text_Key,
                  Plsqlap_Record_API.dt_Text_Reference,
                  Plsqlap_Record_API.dt_Long_Text,
                  Plsqlap_Record_API.dt_Alpha) ) THEN
      RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(value_,CHR(38),CHR(38)||'amp;'),'<',CHR(38)||'lt;'),'>',CHR(38)||'gt;'),'"',CHR(38)||'quot;'),'''',CHR(38)||'apos;');
   ELSE
      RETURN value_;
   END IF;
END Encode_Markup_Characters___; 

FUNCTION Encode_Markup_Characters___ (
   clob_value_  IN CLOB,
   type_   IN VARCHAR2 ) RETURN CLOB
IS
BEGIN
   IF ( type_ IN (Plsqlap_Record_API.dt_Text,
                  Plsqlap_Record_API.dt_Text_Key,
                  Plsqlap_Record_API.dt_Text_Reference,
                  Plsqlap_Record_API.dt_Long_Text,
                  Plsqlap_Record_API.dt_Alpha,
                  Plsqlap_Record_API.DT_CLOB,
                  Plsqlap_Record_API.DT_BLOB) ) THEN                  
      RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(clob_value_,CHR(38),CHR(38)||'amp;'),'<',CHR(38)||'lt;'),'>',CHR(38)||'gt;'),'"',CHR(38)||'quot;'),'''',CHR(38)||'apos;');
   ELSE
      RETURN clob_value_;
   END IF;
END Encode_Markup_Characters___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Is_Error__ (
   buffer_   IN  type_buffer_,
   category_ OUT type_error_category_,
   message_  OUT type_error_message_,
   name_     OUT type_error_name_,
   severity_ OUT type_error_severity_ ) RETURN BOOLEAN
IS
   error_     type_buffer_;
   status_    type_status_;
   item_      type_item_;
   item_name_ type_name_;
BEGIN
   status_ := Get_Item_By_Name(buffer_, 'STATUS');
   IF ( status_ IS NULL ) THEN
      RETURN FALSE;
   END IF;
   IF ( NVL(Get_Value(status_),'SUCCESS') != 'ERROR' ) THEN
      RETURN FALSE;
   END IF;
   error_ := Get_Buffer(Get_Item_By_Name(buffer_, 'ERROR'));
   FOR i IN 1 .. Count_Items(error_) LOOP
      item_      := Get_Item_By_Position(error_, i);
      item_name_ := Get_Name(item_);
      IF ( item_name_ IS NOT NULL ) THEN
         IF    ( item_name_ = 'CATEGORY' ) THEN  category_ := Get_Value(item_);
         ELSIF ( item_name_ = 'MESSAGE' )  THEN  message_  := Get_Value(item_);
         ELSIF ( item_name_ = 'NAME' )     THEN  name_     := Get_Value(item_);
         ELSIF ( item_name_ = 'SEVERITY' ) THEN  severity_ := Get_Value(item_);
         END IF;
      END IF;
   END LOOP;
   RETURN TRUE;
EXCEPTION
   WHEN others THEN
      RETURN FALSE;
END Is_Error__;


PROCEDURE Save_App_Context__ (
   buffer_ IN type_buffer_ )
IS
   buf_   type_buffer_;
   item_  type_item_;
   count_ NUMBER;
BEGIN
   Clear_Buffer(app_context_);
   buf_   := Get_Item_By_Name(buffer_, 'APP_CONTEXT');
   count_ := Count_Items(buf_);
   FOR pos_ IN 1 .. count_ LOOP
      item_ := Get_Item_By_Position(buf_, pos_);
      IF ( item_ IS NOT NULL ) THEN
         Add_Item___(app_context_, Get_Name(item_), Get_Value(item_), Get_Type(item_), Get_Status(item_), 'FALSE');
      END IF;
   END LOOP;
END Save_App_Context__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Debug (
   buffer_ IN type_buffer_,
   debug_level_ IN NUMBER DEFAULT Log_SYS.debug_ )
IS
   level_ NUMBER;
BEGIN
   level_ := 0;
   Print_Compound___(buffer_, level_, debug_level_);
END Debug;


FUNCTION New_Buffer (
   name_ IN type_name_ ) RETURN type_buffer_
IS
   buffer_id_   NUMBER;
   CURSOR buffer_seq_ IS
      SELECT PLSQLAP_BUFFER_SEQ.nextval
      FROM   dual;
BEGIN
   OPEN buffer_seq_;
   FETCH buffer_seq_ INTO buffer_id_;
   CLOSE buffer_seq_;
   RETURN name_ || '+' || TO_CHAR(buffer_id_);
END New_Buffer;


PROCEDURE Add_Item (
   buffer_ IN type_buffer_,
   name_   IN type_name_,
   value_  IN type_value_,
   typ_    IN type_typ_,
   status_ IN type_status_ )
IS
BEGIN
   Add_Item___(buffer_, name_, value_, typ_, status_, 'FALSE');
END Add_Item;


PROCEDURE Add_Item (
   buffer_ IN type_buffer_,
   name_   IN type_name_,
   value_  IN NUMBER,
   status_ IN type_status_ DEFAULT NULL )
IS
BEGIN
   Add_Item(buffer_, name_, replace(TO_CHAR(value_),',','.'), 'N', status_);
END Add_Item;


PROCEDURE Add_Item (
   buffer_ IN type_buffer_,
   name_   IN type_name_,
   value_  IN type_value_,
   status_ IN type_status_ DEFAULT NULL )
IS
BEGIN
   Add_Item(buffer_, name_, value_, 'S', status_);
END Add_Item;


PROCEDURE Add_Item (
   buffer_ IN type_buffer_,
   name_   IN type_name_,
   value_  IN DATE,
   status_ IN type_status_ DEFAULT NULL )
IS
BEGIN
   Add_Item(buffer_, name_, TO_CHAR(value_,Plsqlap_Record_API.format_time_stamp_), 'DTS', status_);
END Add_Item;

PROCEDURE Add_Item (
   buffer_     IN type_buffer_,
   name_       IN type_name_,
   clob_value_ IN type_clob_value_,
   typ_        IN type_typ_,
   status_     IN type_status_ )
IS
BEGIN
   Add_Item___(buffer_, name_, clob_value_, typ_, status_, 'FALSE');
END Add_Item;

PROCEDURE Add_Clob_Item (
   buffer_ IN type_buffer_,
   name_   IN type_name_,
   clob_value_  IN type_clob_value_,
   type_    IN type_typ_ DEFAULT 'CLOB',
   status_ IN type_status_ DEFAULT NULL )
IS
BEGIN
   Add_Clob_Item___(buffer_, name_, clob_value_, type_, status_, 'FALSE');
END Add_Clob_Item;


PROCEDURE Add_Blob_Item (
   buffer_ IN type_buffer_,
   name_   IN type_name_,
   blob_value_  IN type_blob_value_,
   type_    IN type_typ_ DEFAULT 'BLOB',
   status_ IN type_status_ DEFAULT NULL )
IS
BEGIN
   Add_Blob_Item___(buffer_, name_, blob_value_, type_, status_, 'FALSE');
END Add_Blob_Item;


PROCEDURE Add_Compound_Item (
   buffer_ IN type_buffer_,
   item_   IN type_item_,
   value_  IN type_buffer_,
   typ_    IN type_typ_    DEFAULT NULL,
   status_ IN type_status_ DEFAULT NULL )
IS
BEGIN
   Add_Item___(buffer_, item_, value_, typ_, status_, 'TRUE');
END Add_Compound_Item;


FUNCTION Count_Items (
   buffer_ IN type_buffer_ ) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR count_items_ IS
      SELECT /*+ INDEX (a PLSQLAP_BUFFER_IX) */ COUNT(*)
      FROM   PLSQLAP_BUFFER_TMP
      WHERE  buffer = buffer_;
BEGIN
   OPEN count_items_;
   FETCH count_items_ INTO count_;
   CLOSE count_items_;
   RETURN count_;
END Count_Items;


FUNCTION Is_Compound (
   item_ IN type_item_ ) RETURN BOOLEAN
IS
   buffer_record_  buffer_record_type_;
BEGIN
   Get_Item___(item_, buffer_record_);
   IF ( buffer_record_.compound_item_ = 'TRUE' ) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Compound;


FUNCTION Get_Item_Position (
   buffer_ IN type_buffer_,
   name_   IN type_name_ ) RETURN NUMBER
IS
   buffer_record_  buffer_record_type_;
BEGIN
   IF ( Get_Item___(buffer_, name_, NULL, buffer_record_) ) THEN
      RETURN buffer_record_.sequence_no_;
   ELSE
      RETURN -1;
   END IF;
END Get_Item_Position;

FUNCTION Get_Item_By_Name (
   buffer_ IN type_buffer_,
   name_   IN type_name_ ) RETURN type_item_
IS
   buffer_record_  buffer_record_type_;
BEGIN
   IF ( Get_Item___(buffer_, name_, NULL, buffer_record_) ) THEN
      RETURN buffer_record_.rowid_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Item_By_Name;

FUNCTION Get_Item_By_Name_And_Position (
   buffer_ IN type_buffer_,
   name_   IN type_name_,
   position_ IN NUMBER) RETURN type_item_
IS
   buffer_record_  buffer_record_type_;
BEGIN
   IF ( Get_Item_From_Comp_Elem___(buffer_, name_, position_, buffer_record_) ) THEN
      RETURN buffer_record_.rowid_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Item_By_Name_And_Position;

FUNCTION Get_Item_By_Position (
   buffer_ IN type_buffer_,
   pos_    IN NUMBER ) RETURN type_item_
IS
   buffer_record_  buffer_record_type_;
BEGIN
   IF ( Get_Item___(buffer_, NULL, pos_, buffer_record_) ) THEN
      RETURN buffer_record_.rowid_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Item_By_Position;

FUNCTION Get_Item_By_Name_In_Max_Pos (
   buffer_ IN type_buffer_,
   name_   IN type_name_) RETURN type_item_
IS
   
   FUNCTION Core (
      buffer_ IN type_buffer_,
      name_   IN type_name_) RETURN type_item_
   IS
      buffer_record_  buffer_record_type_;
   BEGIN
      IF ( Get_Item_In_Max_Pos___(buffer_, name_, buffer_record_) ) THEN
         RETURN buffer_record_.rowid_;
      ELSE
         RETURN NULL;
      END IF;
   END Core;

BEGIN
   RETURN Core(buffer_, name_);
END Get_Item_By_Name_In_Max_Pos;

FUNCTION Get_Name (
   item_ IN type_item_ ) RETURN type_name_
IS
   buffer_record_  buffer_record_type_;
BEGIN
   Get_Item___(item_, buffer_record_);
   RETURN buffer_record_.name_;
END Get_Name;


FUNCTION Get_Type (
   item_ IN type_item_ ) RETURN type_typ_
IS
   buffer_record_  buffer_record_type_;
BEGIN
   Get_Item___(item_, buffer_record_);
   RETURN buffer_record_.typ_;
END Get_Type;

FUNCTION Get_Type_Name (
   type_ IN type_typ_ ) RETURN VARCHAR2
IS
   name_ VARCHAR2(20);
BEGIN
      CASE type_
      WHEN 'B' THEN name_ := 'Boolean';
      WHEN 'I' THEN name_ := 'Integer';
      WHEN 'DEC' THEN name_ := 'Decimal';
      WHEN 'N' THEN name_ := 'Float';
      WHEN 'T' THEN name_ := 'Text';
      WHEN 'TK' THEN name_ := 'Text_Key';
      WHEN 'TR' THEN name_ := 'Text_Reference';
      WHEN 'LT' THEN name_ := 'Long_Text';
      WHEN 'CLOB' THEN name_ := 'CLOB';
      WHEN 'BLOB' THEN name_ := 'BLOB';
      WHEN 'D' THEN name_ := 'Date';
      WHEN 'DT' THEN name_ := 'Time';
      WHEN 'DTS' THEN name_ := 'TimeStamp';
      WHEN 'A' THEN name_ := 'Alpha';
      WHEN 'R.B64' THEN name_ := 'Binary';
      WHEN 'ENUM' THEN name_ := 'Enumeration';
      WHEN 'AGGREGATE' THEN name_ := 'Aggregate';
      WHEN 'ARRAY' THEN name_ := 'Array';
      WHEN 'REFERENCE' THEN name_ := 'Reference';
      ELSE name_ := '';
   END CASE;
   RETURN name_;
END Get_Type_Name;

FUNCTION Get_Status (
   item_ IN type_item_ ) RETURN type_status_
IS
   buffer_record_  buffer_record_type_;
BEGIN
   Get_Item___(item_, buffer_record_);
   RETURN buffer_record_.status_;
END Get_Status;


FUNCTION Get_Value (
   item_ IN type_item_ ) RETURN type_value_
IS
   buffer_record_  buffer_record_type_;
BEGIN
   Get_Item___(item_, buffer_record_);
   IF ( buffer_record_.compound_item_ = 'TRUE' ) THEN
      RETURN NULL;
   ELSE
      RETURN buffer_record_.value_;
   END IF;
END Get_Value;


FUNCTION Get_Clob_Value (
   item_ IN type_item_ ) RETURN type_clob_value_
IS
   buffer_record_  buffer_record_type_;
BEGIN
   Get_Item___(item_, buffer_record_);
   IF ( buffer_record_.compound_item_ = 'TRUE' ) THEN
      RETURN NULL;
   ELSE
      RETURN buffer_record_.clob_value_;
   END IF;
END Get_Clob_Value;


FUNCTION Get_Blob_Value (
   item_ IN type_item_ ) RETURN type_blob_value_
IS
   buffer_record_  buffer_record_type_;
BEGIN
   Get_Item___(item_, buffer_record_);
   IF ( buffer_record_.compound_item_ = 'TRUE' ) THEN
      RETURN NULL;
   ELSE
      RETURN buffer_record_.blob_value_;
   END IF;
END Get_Blob_Value;


FUNCTION Get_Buffer (
   item_ IN type_item_ ) RETURN type_buffer_
IS
   buffer_record_  buffer_record_type_;
BEGIN
   Get_Item___(item_, buffer_record_);
   IF ( buffer_record_.compound_item_ = 'TRUE' ) THEN
      RETURN buffer_record_.value_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Buffer;


PROCEDURE Clear_Buffer (
   buffer_ IN type_buffer_ )
IS
   -- --------------------------------------------------
   -- The procedure Clear_Buffer removes a buffer
   -- --------------------------------------------------
   CURSOR clear_buffer_ IS
      SELECT /*+ INDEX (a PLSQLAP_BUFFER_IX) */ a.value
      FROM   PLSQLAP_BUFFER_TMP a
      WHERE  a.buffer        = buffer_
      AND    a.compound_item = 'TRUE'
      AND    a.value         <> app_context_;
BEGIN
   FOR buffer_rec_ IN clear_buffer_ LOOP
      Clear_Buffer(buffer_rec_.value);
   END LOOP;
   DELETE /*+ INDEX (a PLSQLAP_BUFFER_IX) */ 
   FROM   PLSQLAP_BUFFER_TMP a
   WHERE  a.buffer = buffer_;
   DELETE /*+ INDEX (a PLSQLAP_BUFFER_IX2) */  
   FROM   PLSQLAP_BUFFER_TMP a
   WHERE  a.value = buffer_;
END Clear_Buffer;


FUNCTION Get_Context_Parameter (
   name_          IN type_name_,
   default_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Context_Parameter___(name_);
EXCEPTION
   WHEN parameter_not_found_ THEN
      RETURN default_value_;
   WHEN others THEN
      RAISE;
END Get_Context_Parameter;


FUNCTION Get_Context_Parameter (
   name_          IN type_name_,
   default_value_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN TO_NUMBER(Get_Context_Parameter___(REPLACE(name_, '.', ',')));
EXCEPTION
   WHEN parameter_not_found_ THEN
      RETURN default_value_;
   WHEN others THEN
      RAISE;
END Get_Context_Parameter;


FUNCTION Get_Context_Parameter (
   name_          IN type_name_,
   default_value_ IN DATE ) RETURN DATE
IS
BEGIN
   RETURN TO_DATE(Get_Context_Parameter___(name_),Plsqlap_Record_API.format_time_stamp_);
EXCEPTION
   WHEN parameter_not_found_ THEN
      RETURN default_value_;
   WHEN others THEN
      RAISE;
END Get_Context_Parameter;


FUNCTION Get_Context_Parameter (
   name_          IN type_name_,
   default_value_ IN BOOLEAN ) RETURN BOOLEAN
IS
BEGIN
   RETURN To_Boolean___(Get_Context_Parameter___(name_));
EXCEPTION
   WHEN parameter_not_found_ THEN
      RETURN default_value_;
   WHEN others THEN
      RAISE;
END Get_Context_Parameter;


PROCEDURE Set_Context_Parameter (
   name_   IN type_name_,
   value_  IN VARCHAR2,
   typ_    IN type_typ_    DEFAULT 'S',
   status_ IN type_status_ DEFAULT NULL )
IS
BEGIN
   Set_Context_Parameter___(name_, value_, typ_, status_);
END Set_Context_Parameter;


PROCEDURE Set_Context_Parameter (
   name_   IN type_name_,
   value_  IN NUMBER,
   typ_    IN type_typ_    DEFAULT 'N',
   status_ IN type_status_ DEFAULT NULL )
IS
BEGIN
   Set_Context_Parameter___(name_, REPLACE(TO_CHAR(value_),',','.'), typ_, status_);
END Set_Context_Parameter;


PROCEDURE Set_Context_Parameter (
   name_   IN type_name_,
   value_  IN DATE,
   typ_    IN type_typ_    DEFAULT 'D',
   status_ IN type_status_ DEFAULT NULL )
IS
BEGIN
   Set_Context_Parameter___(name_, TO_CHAR(value_,Plsqlap_Record_API.format_time_stamp_), typ_, status_);
END Set_Context_Parameter;


PROCEDURE Set_Context_Parameter (
   name_   IN type_name_,
   value_  IN BOOLEAN,
   typ_    IN type_typ_    DEFAULT 'B',
   status_ IN type_status_ DEFAULT NULL )
IS
BEGIN
   Set_Context_Parameter___(name_, To_String___(value_), typ_, status_);
END Set_Context_Parameter;


PROCEDURE Remove_Context_Parameter (
   name_ IN type_name_ )
IS
BEGIN
   Remove_Context_Parameter___(name_);
END Remove_Context_Parameter;


PROCEDURE Set_Item (
   item_   IN type_item_,
   value_  IN type_value_,
   typ_    IN type_typ_,
   status_ IN type_status_ )
IS
BEGIN
   Set_Item___(item_, value_, typ_, status_);
END Set_Item;

PROCEDURE Set_Item (
   item_   IN type_item_,
   clob_value_  IN type_clob_value_,
   typ_    IN type_typ_,
   status_ IN type_status_ )
IS
BEGIN
   Set_Item___(item_, clob_value_, typ_, status_);
END Set_Item;


PROCEDURE Set_Item_Value (
   item_   IN type_item_,
   value_  IN type_value_ )
IS
BEGIN
   Set_Item___(item_, value_, dont_change_, dont_change_);
END Set_Item_Value;


PROCEDURE Set_Clob_Item (
   item_   IN type_item_,
   clob_value_  IN type_clob_value_,
   type_   IN type_typ_,
   status_ IN type_status_ )
IS
BEGIN
   Set_Clob_Item___(item_, clob_value_, type_, status_);
END Set_Clob_Item;


PROCEDURE Set_Clob_Item_Value (
   item_   IN type_item_,
   clob_value_  IN type_clob_value_ )
IS
BEGIN
   Set_Clob_Item___(item_, clob_value_, dont_change_, dont_change_);
END Set_Clob_Item_Value;


PROCEDURE Set_Blob_Item (
   item_   IN type_item_,
   blob_value_  IN type_blob_value_,
   type_   IN type_typ_,
   status_ IN type_status_ )
IS
BEGIN
   Set_Blob_Item___(item_, blob_value_, type_, status_);
END Set_Blob_Item;


PROCEDURE Set_Blob_Item_Value (
   item_   IN type_item_,
   blob_value_  IN type_blob_value_ )
IS
BEGIN
   Set_Blob_Item___(item_, blob_value_, dont_change_, dont_change_);
END Set_Blob_Item_Value;


PROCEDURE Set_Item_Typ (
   item_   IN type_item_,
   typ_    IN type_typ_ )
IS
BEGIN
   Set_Item___(item_, dont_change_, typ_, dont_change_);
END Set_Item_Typ;


PROCEDURE Set_Item_Status (
   item_   IN type_item_,
   status_ IN type_status_ )
IS
BEGIN
   Set_Item___(item_, dont_change_, dont_change_, status_);
END Set_Item_Status;


FUNCTION To_XML (
   buffer_ IN type_buffer_ ) RETURN VARCHAR2
IS
   buffer_record_ buffer_record_type_;
   xml_ VARCHAR2(32767) := '';
   ok_ BOOLEAN;
BEGIN
   FOR i IN 1 .. Count_Items(buffer_) LOOP
      ok_ := Get_Item___(buffer_, NULL, i, buffer_record_);
      IF buffer_record_.name_ = 'DATA' THEN
         buffer_record_.name_ := buffer_record_.typ_;
      END IF;
      xml_ := xml_ || '<' || buffer_record_.name_ || '>';
      IF (buffer_record_.compound_item_ = 'TRUE') THEN
        xml_ := xml_ || To_XML(Get_Buffer(buffer_record_.rowid_));
--         ok_ := Get_Item___(buffer_record_.value_, 'DATA', NULL, buffer_record_2_);
--         xml_ := xml_ || To_XML(buffer_record_2_.value_);
      ELSE
         IF(buffer_record_.value_ IS NOT NULL)THEN
            xml_ := xml_ || Encode_Markup_Characters___(buffer_record_.value_,buffer_record_.typ_);
         ELSIF(buffer_record_.clob_value_ IS NOT NULL AND LENGTH(buffer_record_.clob_value_)<32000)THEN
            xml_ := xml_ || Encode_Markup_Characters___(buffer_record_.clob_value_,buffer_record_.typ_);
         ELSE
            xml_ := xml_ || Encode_Markup_Characters___(buffer_record_.value_,buffer_record_.typ_);
            Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'You need to use clob supported ''To_Xml'' method to return the xml');
         END IF;
      END IF;
      xml_ := xml_ || '</' || buffer_record_.name_ || '>';
   END LOOP;
   RETURN xml_;
END To_XML;

PROCEDURE To_Xml (
   xml_    OUT CLOB,
   buffer_ IN  type_buffer_ ,
   rest_ IN BOOLEAN DEFAULT False)
IS
   buffer_record_       buffer_record_type_;
   ok_                  BOOLEAN;
   temp_                CLOB;
   append_clob_buffer_  CLOB;
   append_buffer_       VARCHAR2(32767);
   record_type_name_    VARCHAR2(100);

   PROCEDURE Text_To_Clob_Buffer
   IS
   BEGIN
      IF ( append_buffer_ IS NOT NULL ) THEN
         DBMS_LOB.WriteAppend(append_clob_buffer_, LENGTH(append_buffer_), append_buffer_);
         append_buffer_ := '';
      END IF;
   END Text_To_Clob_Buffer;  
   
   
   PROCEDURE Move_To_Xml
   IS
   BEGIN
      Text_To_Clob_Buffer;
      IF ( dbms_lob.getlength(append_clob_buffer_) > 0 ) THEN
         Dbms_lob.append(xml_,append_clob_buffer_ );
         dbms_lob.freetemporary(append_clob_buffer_);
         DBMS_LOB.CreateTemporary(append_clob_buffer_, TRUE, DBMS_LOB.CALL);            
      END IF;         
   END Move_To_Xml; 

   PROCEDURE Append_Clob (
      clob_value_ IN CLOB )
   IS
      
   BEGIN
      Text_To_Clob_Buffer;
      IF (clob_value_ IS null) THEN
         Dbms_Lob.append(append_clob_buffer_, empty_clob());
      ELSE
         Dbms_Lob.append(append_clob_buffer_, clob_value_);
      END IF; 
   END Append_Clob;
   
   PROCEDURE Append_Text (
      text_ IN VARCHAR2 )
   IS
   BEGIN
      append_buffer_ := append_buffer_ || text_;
   EXCEPTION
      WHEN value_error THEN
         Text_To_Clob_Buffer;
         append_buffer_ := text_;
   END Append_Text;   

BEGIN
   DBMS_LOB.CreateTemporary(xml_, TRUE, DBMS_LOB.CALL);
   DBMS_LOB.CreateTemporary(append_clob_buffer_, TRUE, DBMS_LOB.CALL);
   FOR i IN 1 .. Count_Items(buffer_) LOOP
      ok_ := Get_Item___(buffer_, NULL, i, buffer_record_);
      IF buffer_record_.name_ = 'DATA' THEN
         buffer_record_.name_ := buffer_record_.typ_;
      END IF;
      IF(rest_) THEN
         record_type_name_ := Get_Type_Name(buffer_record_.typ_);
         IF LENGTH(record_type_name_) > 0 THEN
            record_type_name_ := ' type="' || record_type_name_ || '"';
         END IF;
         Append_Text('<' || buffer_record_.name_ || record_type_name_ || '>');
      ELSE
      Append_Text('<' || buffer_record_.name_ || '>');
      END IF;
      IF (buffer_record_.compound_item_ = 'TRUE') THEN
         DBMS_LOB.CreateTemporary(temp_, TRUE, DBMS_LOB.CALL);
         To_XML(temp_, Get_Buffer(buffer_record_.rowid_), rest_);
         Move_To_Xml;           
         DBMS_LOB.append(xml_, temp_);
         DBMS_LOB.Freetemporary(temp_);
      ELSE
         IF (buffer_record_.typ_ IN (plsqlap_record_api.DT_CLOB, plsqlap_record_api.DT_BLOB)) THEN
            Append_Clob(Encode_Markup_Characters___(buffer_record_.clob_value_,buffer_record_.typ_));
         ELSE
            Append_Text(Encode_Markup_Characters___(buffer_record_.value_,buffer_record_.typ_)); 
         END IF;                
      END IF;
      Append_Text('</' || buffer_record_.name_ || '>');
   END LOOP;
   Move_To_Xml;
   IF (dbms_lob.istemporary(append_clob_buffer_) =1) then
     Dbms_lob.freetemporary(append_clob_buffer_);
   END IF;      
END To_Xml;