-----------------------------------------------------------------------------
--
--  Logical unit: XmlRecordWriter
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030818  DOZE    Created
--  040115  DOZE    Added freeing temporary LOB before each report
--  040907  MAOL    Added Replace_Separator function that replaces chr(28) to
--                  chr(31) with a white space.
--  070903  UTGULK  Initialised write_buffer in Create_Report_Header (Bug 67572).
--  120612  ASIWLK  Added get_Custom_Field_View,Add_Custom_Fields
--  120904  ASIWLK  Custom Field control (TEREPORT-75)
--  121017  ASIWLK  remove report level check for add custom fields. (TEREPORT-247)
--  130218  ASIWLK  Data type specific formatting for custom fields (bug 108321)
--  130313  ASIWLK  unpublished custom fields fails the report execution(bug 108865)
--  130729  NaBaLK  NaBaLK Certified assert safe for dynamic SQLs (Bug#111361
--  140129  AsiWLK  Merged LCS-111925
--  140521  NaBaLK  Removed Report ID search in adding custom fields (TEREPORT-1256)
--  150223  CHAALK  Patch Merge (Bug Id:120748)
--  170312  MADILK  Custom Fields of format DATE_TIME eliminate time factor when added to reports (TEREPORT-2457)
--  210201  NALTLK  Change of "Enabled on Reports" for Custom Fields is activated without Synchronizing (Bug ID 157689)
--  210219  NALTLK  creating large number of custom fields cause to give an errors(Bug ID 157945)
--  210228  MABALK  General_SYS.Init_Method call cause performance reduction in very large reports(Bug ID 158160)
--  210825  CHAALK  Remove General_SYS.Init_Method to improve performance (BugID:160620)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

format_xml_time_stamp_ CONSTANT VARCHAR2(21) := 'yyyy-mm-ddThh24:mi:ss';
format_xml_date_       CONSTANT VARCHAR2(10) := 'yyyy-mm-dd';
format_xml_time_       CONSTANT VARCHAR2(10) := 'hh24:mi:ss';

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Add_Custom_Fields_impl__ (
   xml_stream_ IN OUT NOCOPY CLOB,
   lu_name_    IN VARCHAR2,
   row_key_    IN VARCHAR2,
   report_id_  IN VARCHAR2,
   lang_code_  IN VARCHAR2 DEFAULT NULL)
IS
   col_name_ VARCHAR2(1000);
$IF Component_Fndcob_SYS.INSTALLED $THEN
   field_stmt_select_            VARCHAR2(32000);
   field_data_type_attr_         VARCHAR2(32000);
   enum_field_lu_name_attr_      VARCHAR2(32000);
   field_stmt_del_               VARCHAR2(1);
   cf_view_                      custom_fields.view_name%TYPE;
   field_name_from_select_       custom_field_attributes.attribute_name%TYPE;
   field_type_from_select_       custom_field_attributes.data_type_db%TYPE;

   stmt_txt_                     VARCHAR2(32000);
   column_cnt_                   NUMBER;
   result_set_                   CF_Result_set_Type;
   pos_                          NUMBER :=0;

   enum_lu_name_                 VARCHAR2(50);
   enum_db_vlaues_               VARCHAR2(32000);
   current_enum_db_vlaue_        VARCHAR2(100);   
   translated_enum_client_value_ VARCHAR2(100);
   lang_                         VARCHAR2(30) := nvl(lang_code_, Archive_API.Get_Language__);

   CURSOR get_custom_field_attributes (lu_name_   VARCHAR2) IS
        SELECT
           cfa.column_name column_name,
           cfa.attribute_name,
           cfa.lu_type,
           cfa.enabled_on_reports_db,
           cfa.data_type_db,
           cfa.lu_reference
        FROM cf_attribute_runtime  cfa
        WHERE cfa.lu = lu_name_ AND cfa.lu_type = 'CUSTOM_FIELD' AND cfa.published_db = 'TRUE' AND cfa.enabled_on_reports_db = 'TRUE';
$END
     
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
   IF 'TRUE' = Report_Result_Gen_Config_Api.Get_Enable_Custom_Fields_Db(report_id_)  THEN
      cf_view_:= get_Custom_Field_View__(lu_name_);

      IF cf_view_ IS NOT NULL THEN
         field_stmt_del_:=',';
         column_cnt_:=0;
         --creation of the select statment
         FOR the_record IN get_custom_field_attributes (lu_name_) LOOP
               IF the_record.data_type_db = Custom_Field_Data_Types_API.DB_ENUMERATION THEN
                  Client_SYS.Add_To_Attr(the_record.attribute_name,the_record.data_type_db,field_data_type_attr_);
                  Client_SYS.Add_To_Attr(the_record.attribute_name,the_record.lu_reference,enum_field_lu_name_attr_);
               ELSE
                  Client_SYS.Add_To_Attr(the_record.attribute_name,the_record.data_type_db,field_data_type_attr_);
               END IF;   

               --Formatting the DATE type custom fields with appropriate mask
               col_name_ := the_record.column_name;
               IF the_record.data_type_db = 'DATE' THEN            
                 col_name_ := 'TO_CHAR(' || col_name_ || ',''' || 'yyyy-mm-dd"T"hh24:mi:ss' || ''')';
               END IF;

               --Generation of the custom field column list
               IF field_stmt_select_ IS NOT NULL THEN
                  field_stmt_select_:=field_stmt_select_||field_stmt_del_||col_name_;
               ELSE 
                  field_stmt_select_:= col_name_;
               END IF;
			   
               column_cnt_:=column_cnt_+1;  
         END LOOP;     
         -- creation of the cast select 
         stmt_txt_ := 'select CF_Result_Type('||field_stmt_select_||') from ' || cf_view_||' WHERE OBJKEY =:P1';

         -- execute dynamic
         -- Safe as parameter values are validated
         @ApproveDynamicStatement(2013-07-24,NaBaLK)
         execute immediate stmt_txt_ bulk collect 
            into result_set_
            using row_key_;

         -- adding the CF_ elemets 
         IF result_set_.count = 1 THEN
            pos_:=1;
            FOR i IN 1 .. column_cnt_ LOOP
               IF (Client_SYS.Get_Next_From_Attr(field_data_type_attr_,pos_,field_name_from_select_,field_type_from_select_)) THEN
                  IF Custom_Field_Data_Types_API.DB_DATE = field_type_from_select_ THEN
                     Add_Element(xml_stream_,'CF_'||field_name_from_select_,result_set_(1)(i));
                  ELSIF  Custom_Field_Data_Types_API.DB_NUMBER = field_type_from_select_ THEN
                     Add_Element(xml_stream_,'CF_'||field_name_from_select_,to_number(result_set_(1)(i)));
                  ELSIF   Custom_Field_Data_Types_API.DB_BINARY = field_type_from_select_ THEN
                     IF 'TRUE' = UPPER(result_set_(1)(i)) THEN
                        Add_Element(xml_stream_,'CF_'||field_name_from_select_,true);
                     ELSE
                        Add_Element(xml_stream_,'CF_'||field_name_from_select_,false);
                     END IF; 
                  ELSIF   Custom_Field_Data_Types_API.DB_ENUMERATION = field_type_from_select_ THEN                   

                     enum_lu_name_ := Client_SYS.Get_Item_Value(field_name_from_select_,enum_field_lu_name_attr_);
                     enum_db_vlaues_ := Domain_SYS.Get_Db_Values(enum_lu_name_);

                     -- We need to have this to make sure that the enum vlaues are loaded in to the context
                     -- if not we could have just run only the commented line
                     -- Start
                     -- current_enum_db_vlaue_ := Domain_SYS.Encode_(Domain_SYS.Get_Translated_Values(enum_lu_name_), enum_db_vlaues_, result_set_(1)(i));
                     stmt_txt_ := '';
                     stmt_txt_ := 'begin :P1 := '|| Dictionary_Sys.Get_Base_Package(enum_lu_name_) ||  '.Encode(:P2); end;';
                     -- Safe as parameter values are generated
                     @ApproveDynamicStatement(2015-01-23,CHAALK)
                     execute immediate stmt_txt_ using in out current_enum_db_vlaue_, result_set_(1)(i);
                     -- End
                     -- if the archive language is also null
                     lang_ := nvl(lang_, Fnd_Session_API.Get_Language);
                     translated_enum_client_value_ := Domain_SYS.Decode_(Domain_SYS.Get_Translated_Values(enum_lu_name_,lang_), enum_db_vlaues_, current_enum_db_vlaue_);                   
                     Add_Element(xml_stream_,'CF_'||field_name_from_select_, translated_enum_client_value_);
                  ELSE
                     Add_Element(xml_stream_,'CF_'||field_name_from_select_,result_set_(1)(i));
                  END IF;
               END IF;
            END LOOP;
         END IF; 
      END IF;
   END IF;   
   $END
   NULL;
END Add_Custom_Fields_impl__;


@UncheckedAccess
FUNCTION get_Custom_Field_View__ (
  lu_name_ IN VARCHAR2) RETURN VARCHAR2
IS  
$IF Component_Fndcob_SYS.INSTALLED $THEN
   temp_ custom_fields.view_name%TYPE;
   CURSOR get_view IS
      SELECT t.view_name
      FROM custom_fields t
      WHERE t.lu=lu_name_ AND t.published_db = 'TRUE';
$END
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
      OPEN get_view;
      FETCH get_view INTO temp_;
      CLOSE get_view;
      RETURN temp_;
$ELSE
      RETURN NULL;
$END      

END get_Custom_Field_View__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Start_Element (
   xml_stream_   IN OUT NOCOPY CLOB,
   element_name_ IN VARCHAR2,
   attr_name1_   IN VARCHAR2 DEFAULT NULL,
   attr_value1_  IN VARCHAR2 DEFAULT NULL,
   attr_name2_   IN VARCHAR2 DEFAULT NULL,
   attr_value2_  IN VARCHAR2 DEFAULT NULL,
   attr_name3_   IN VARCHAR2 DEFAULT NULL,
   attr_value3_  IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
    Xml_Text_Writer_API.Write_Start_Element(xml_stream_, NULL, element_name_, NULL,
                                        attr_name1_, attr_value1_,
                                        attr_name2_, attr_value2_,
                                        attr_name3_, attr_value3_);
END Start_Element;

@UncheckedAccess
PROCEDURE End_Element (
   xml_stream_   IN OUT NOCOPY CLOB,
   element_name_ IN VARCHAR2 )
IS
BEGIN
   Xml_Text_Writer_API.Write_End_element(xml_stream_, element_name_);
END End_Element;

@UncheckedAccess
PROCEDURE Add_Element (
   xml_stream_    IN OUT NOCOPY CLOB,
   element_name_  IN VARCHAR2,
   element_value_ IN VARCHAR2,
   attr_name_     IN VARCHAR2 DEFAULT NULL,
   attr_value_    IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Xml_Text_Writer_API.Write_Simple_Element(xml_stream_, element_name_, element_value_, attr_name_, attr_value_);
END Add_Element;

@UncheckedAccess
PROCEDURE Add_Element (
   xml_stream_    IN OUT NOCOPY CLOB,
   element_name_  IN VARCHAR2,
   element_value_ IN NUMBER,
   attr_name_     IN VARCHAR2 DEFAULT NULL,
   attr_value_    IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   IF (element_value_ IS NULL) THEN
      Xml_Text_Writer_API.Write_Simple_Element(xml_stream_, element_name_, NULL, attr_name_, attr_value_);
   ELSE
      Xml_Text_Writer_API.Write_Simple_Element(xml_stream_, element_name_, REPLACE(TO_CHAR(element_value_), ',', '.'), attr_name_, attr_value_);
   END IF;
END Add_Element;

@UncheckedAccess
PROCEDURE Add_Element (
   xml_stream_    IN OUT NOCOPY CLOB,
   element_name_  IN VARCHAR2,
   element_value_ IN DATE,
   attr_name_     IN VARCHAR2 DEFAULT NULL,
   attr_value_    IN VARCHAR2 DEFAULT NULL,
   format_date_   IN BOOLEAN DEFAULT TRUE,
   format_time_   IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   IF (element_value_ IS NULL) THEN
      Xml_Text_Writer_API.Write_Simple_Element(xml_stream_, element_name_, NULL, attr_name_, attr_value_);
   ELSE
      IF (format_date_ AND format_time_) THEN
         Xml_Text_Writer_API.Write_Simple_Element(xml_stream_, element_name_, REPLACE(TO_CHAR(element_value_,format_xml_date_,'NLS_CALENDAR=GREGORIAN'), ',', '.') ||
                                              'T' || REPLACE(TO_CHAR(element_value_,format_xml_time_,'NLS_CALENDAR=GREGORIAN'), ',', '.'), attr_name_, attr_value_);
      ELSIF (format_time_) THEN
         Xml_Text_Writer_API.Write_Simple_Element(xml_stream_, element_name_, REPLACE(TO_CHAR(element_value_,format_xml_time_,'NLS_CALENDAR=GREGORIAN'), ',', '.'), attr_name_, attr_value_);
      ELSIF (format_date_) THEN
         Xml_Text_Writer_API.Write_Simple_Element(xml_stream_, element_name_, REPLACE(TO_CHAR(element_value_,format_xml_date_,'NLS_CALENDAR=GREGORIAN'), ',', '.'), attr_name_, attr_value_);
      END IF;
   END IF;
END Add_Element;

@UncheckedAccess
PROCEDURE Add_Element (
   xml_stream_    IN OUT NOCOPY CLOB,
   element_name_  IN VARCHAR2,
   element_value_ IN BOOLEAN,
   attr_name_     IN VARCHAR2 DEFAULT NULL,
   attr_value_    IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   IF (element_value_ IS NULL) THEN
      Xml_Text_Writer_API.Write_Simple_Element(xml_stream_, element_name_, NULL, attr_name_, attr_value_);
   ELSE
      IF (element_value_) THEN
         -- Write '1' for true, this might not be the way to do it...
         Xml_Text_Writer_API.Write_Simple_Element(xml_stream_, element_name_, 1, attr_name_, attr_value_);
      ELSE
         -- Write '0' for false, this might not be the way to do it...
         Xml_Text_Writer_API.Write_Simple_Element(xml_stream_, element_name_, 0, attr_name_, attr_value_);
      END IF;
   END IF;
END Add_Element;

@UncheckedAccess
PROCEDURE Create_Report_Header (
   xml_stream_    IN OUT NOCOPY CLOB,
   report_id_     IN VARCHAR2,
   model_package_ IN VARCHAR2 )
IS
BEGIN
   IF (DBMS_LOB.istemporary(xml_stream_)=1) THEN
       DBMS_LOB.freetemporary(xml_stream_);
   END IF;
   DBMS_LOB.createtemporary(xml_stream_, TRUE);
   Xml_Text_Writer_API.Init_Write_Buffer;
   --Start_Element(xml_stream_, report_id_);
   Start_Element(xml_stream_, report_id_,
                     'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema');
END Create_Report_Header;


@UncheckedAccess
FUNCTION Replace_Separators (
   value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   return replace(replace(replace(replace(value_, chr(28), ' '), chr(29), ' '), chr(30), ' '), chr(31), ' ');
END Replace_Separators;

@UncheckedAccess
PROCEDURE Add_Custom_Fields (
   xml_stream_ IN OUT NOCOPY CLOB,
   lu_name_    IN VARCHAR2,
   row_key_    IN VARCHAR2)
IS
BEGIN
   Add_Custom_Fields(xml_stream_, lu_name_, row_key_, NULL); 
END Add_Custom_Fields;

@UncheckedAccess
PROCEDURE Add_Custom_Fields (
   xml_stream_ IN OUT NOCOPY CLOB,
   lu_name_    IN VARCHAR2,
   row_key_    IN VARCHAR2,
   report_id_  IN VARCHAR2)
IS
BEGIN
    Add_Custom_Fields(xml_stream_,lu_name_,row_key_,report_id_,null);
END Add_Custom_Fields;

@UncheckedAccess
PROCEDURE Add_Custom_Fields (
   xml_stream_  IN OUT NOCOPY CLOB,
   lu_name_     IN VARCHAR2,
   row_key_     IN VARCHAR2,
   report_id_   IN VARCHAR2,
   lang_code_   IN VARCHAR2)
IS
BEGIN
   Xml_Record_Writer_SYS.Add_Custom_Fields_impl__(xml_stream_,lu_name_,row_key_,report_id_,lang_code_);
END Add_Custom_Fields;


