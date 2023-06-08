-----------------------------------------------------------------------------
--
--  Logical unit: DynamicReferenceMetadata
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

TYPE View_Reference_Rec IS RECORD (
   entityset_    VARCHAR2(200),
   entity_       VARCHAR2(200),
   selector_     VARCHAR2(200),
   navigate_     VARCHAR2(200),
   view_name_    VARCHAR2(200),
   use_keyref_   BOOLEAN,
   key_count_    INTEGER,
   key_names_    DBMS_UTILITY.UNCL_ARRAY,
   filter_count_ INTEGER,
   filter_keys_  DBMS_UTILITY.UNCL_ARRAY,
   col_count_    INTEGER,
   col_names_    DBMS_UTILITY.UNCL_ARRAY,
   col_prompts_  DBMS_UTILITY.UNCL_ARRAY,
   col_types_    DBMS_UTILITY.UNCL_ARRAY,
   col_enums_    DBMS_UTILITY.UNCL_ARRAY,
   col_db_names_ DBMS_UTILITY.UNCL_ARRAY);
   
TYPE Attribute_Rec IS RECORD (
   name_         VARCHAR2(200),
   col_name_     VARCHAR2(200),
   def_col_name_ VARCHAR2(200),
   qflags_       VARCHAR2(200),
   qdatatype_    VARCHAR2(200),
   editable_     VARCHAR2(200),
   entity_       VARCHAR2(200),
   label_        VARCHAR2(200),
   type_         VARCHAR2(200),
   view_id_      VARCHAR2(200),
   enumerate_    VARCHAR2(200),
   select_       VARCHAR2(200),
   sql_type_     VARCHAR2(200),
   size_         VARCHAR2(200));
   
TYPE View_Reference_Arr IS TABLE OF View_Reference_Rec INDEX BY VARCHAR2(1000);
TYPE View_Code_Xref_Arr IS TABLE OF VARCHAR2(1000)     INDEX BY VARCHAR2(1000);
TYPE Attribute_Arr      IS TABLE OF Attribute_Rec;

TYPE Control_Rec IS RECORD (
   info_method_  VARCHAR2(200),
   service_      VARCHAR2(200),
   bindings_     VARCHAR2(200),
   switch_name_  VARCHAR2(200),
   switch_keys_  VARCHAR2(32000),
   wildcards_    VARCHAR2(32000),
   ref_name_     VARCHAR2(200),
   ref_column_   VARCHAR2(200),
   attributes_   Attribute_Arr,
   views_        View_Reference_Arr,
   xref_         View_Code_Xref_Arr);

TYPE Control_List_Rec IS RECORD (
   info_method_  VARCHAR2(200),
   service_      VARCHAR2(200),
   views_        View_Reference_Arr,
   xref_         View_Code_Xref_Arr);

-------------------- DEBUGGING HELPER ---------------------------------------

PROCEDURE Dbms_Output_Parsed_Control_(
   control_ IN VARCHAR2 )
IS
BEGIN
   Dbms_Output_Control___(Parse_Control_String___(control_));
END Dbms_Output_Parsed_Control_;


PROCEDURE Dbms_Output_Control___(
   ctrl_ IN Control_Rec )
IS
   view_id_ VARCHAR2(200);
   view_    View_Reference_Rec;
   attr_    Attribute_Rec;
   p_       VARCHAR2(2);
BEGIN
   Dbms_Output.Put_Line('Control_Rec');
   Dbms_Output.Put_Line('  info_method_ = '||ctrl_.info_method_);
   Dbms_Output.Put_Line('  service_     = '||ctrl_.service_);
   Dbms_Output.Put_Line('  bindings_    = '||ctrl_.bindings_);
   Dbms_Output.Put_Line('  switch_name_ = '||ctrl_.switch_name_);
   Dbms_Output.Put_Line('  switch_keys_ = '||ctrl_.switch_keys_);
   Dbms_Output.Put_Line('  ref_name_    = '||ctrl_.ref_name_);
   Dbms_Output.Put_Line('  ref_column_  = '||ctrl_.ref_column_);   
   Dbms_Output.Put_Line('  views_ (count = '|| ctrl_.views_.count || ')');   
   view_id_ := ctrl_.views_.first;
   WHILE view_id_ IS NOT NULL LOOP
      view_ := ctrl_.views_(view_id_);
      Dbms_Output.Put_Line('   View_Reference_Rec('||view_id_||')');
      Dbms_Output.Put_Line('     entityset_    = '||view_.entityset_);
      Dbms_Output.Put_Line('     entity_       = '||view_.entity_);
      Dbms_Output.Put_Line('     selector_     = '||view_.selector_);
      Dbms_Output.Put_Line('     navigate_     = '||view_.navigate_);
      Dbms_Output.Put_Line('     view_name_    = '||view_.view_name_);
      Dbms_Output.Put_Line('     use_keyref_   = '||CASE view_.use_keyref_ WHEN TRUE THEN 'TRUE' ELSE 'FALSE' END);
      IF (view_.key_count_ > 0) THEN
         Dbms_Output.Put_Line('     key_count_    = '||view_.key_count_);
         Dbms_Output.Put('     key_names_    = ');
         FOR j_ IN 1 .. view_.key_count_ LOOP
            IF (j_ > 1) THEN  
               Dbms_Output.Put(', ');
            END IF;
            Dbms_Output.Put(view_.key_names_(j_));
         END LOOP; 
         Dbms_Output.Put_Line('');
      END IF;
      
      IF (view_.filter_count_ > 0) THEN
         Dbms_Output.Put_Line('     filter_count_ = '||view_.filter_count_);
         Dbms_Output.Put('     filter_keys_  = ');
         FOR j_ IN 1 .. view_.filter_count_ LOOP
            IF (j_ > 1) THEN  
               Dbms_Output.Put(', ');
            END IF;
            Dbms_Output.Put(view_.filter_keys_(j_));
         END LOOP; 
         Dbms_Output.Put_Line('');
      END IF;
      
      IF (view_.col_count_ > 0) THEN
         Dbms_Output.Put_Line('     col_count_    = '||view_.col_count_);
         FOR j_ IN 1 .. view_.col_count_ LOOP
            p_ := ' ';
            IF (j_ > 9) THEN               
               p_ := '  ';
            END IF;
            Dbms_Output.Put_Line('       ' || j_ || '.col_names_    = ' || view_.col_names_(j_));
            Dbms_Output.Put_Line(p_ || '        col_prompts_  = ' || view_.col_prompts_(j_));
            Dbms_Output.Put_Line(p_ || '        col_types_    = ' || view_.col_types_(j_));
            Dbms_Output.Put_Line(p_ || '        col_db_names_ = ' || view_.col_db_names_(j_));
            Dbms_Output.Put_Line(p_ || '        col_enums_    = ' || view_.col_enums_(j_));
         END LOOP; 
      END IF;
      view_id_ := ctrl_.views_.next(view_id_);
   END LOOP;
   
   Dbms_Output.Put_Line('  attributes_ (count = '|| ctrl_.attributes_.count || ')');   
   IF (ctrl_.attributes_.count > 0) THEN
      FOR attr_no_ IN ctrl_.attributes_.first .. ctrl_.attributes_.last LOOP
         attr_    := ctrl_.attributes_(attr_no_);
         Dbms_Output.Put_Line('   Attribute_Rec('||attr_no_||')');
         Dbms_Output.Put_Line('     name_         = '||attr_.name_);
         Dbms_Output.Put_Line('     col_name_     = '||attr_.col_name_);
         Dbms_Output.Put_Line('     def_col_name_ = '||attr_.def_col_name_);
         Dbms_Output.Put_Line('     qflags_       = '||attr_.qflags_);
         Dbms_Output.Put_Line('       (mand)      = '||substr(attr_.qflags_,1,1));
         Dbms_Output.Put_Line('     qdatatype_    = '||attr_.qdatatype_);
         Dbms_Output.Put_Line('     entity_       = '||attr_.entity_);
         Dbms_Output.Put_Line('     label_        = '||attr_.label_);
         Dbms_Output.Put_Line('     type_         = '||attr_.type_);
         Dbms_Output.Put_Line('     view_id_      = '||attr_.view_id_);
         Dbms_Output.Put_Line('     select_       = '||attr_.select_);
         Dbms_Output.Put_Line('     sql_type_     = '||attr_.sql_type_);
         Dbms_Output.Put_Line('     size_         = '||attr_.size_);
      END LOOP;   
   END IF;
END Dbms_Output_Control___;

-------------------- CONTROL DATA FETCH AND PROCESSING ----------------------

FUNCTION Route_Callback_Content_ (
   method_ IN VARCHAR2,
   param_  IN VARCHAR2,
   clob_   OUT NOCOPY CLOB) RETURN BOOLEAN
IS
BEGIN
   CASE method_
   WHEN 'GET_SELECTORS_METADATA_' THEN
         clob_ := GET_SELECTORS_METADATA_(param_);
      WHEN 'GET_NAVIGATION_METADATA_' THEN
         clob_ := GET_NAVIGATION_METADATA_(param_);
      WHEN 'GET_FIELDS_METADATA_' THEN
         clob_ := GET_FIELDS_METADATA_(param_);
      WHEN 'GET_ENUMERATIONS_METADATA_' THEN
         clob_ := GET_ENUMERATIONS_METADATA_(param_);
      WHEN 'GET_ENTITYSET_METADATA_' THEN
         clob_ := GET_ENTITYSET_METADATA_(param_);
      WHEN 'GET_ENTITY_METADATA_' THEN
         clob_ := GET_ENTITY_METADATA_(param_);
      WHEN 'GET_CLIENT_ENTITY_METADATA_' THEN
         clob_ := GET_CLIENT_ENTITY_METADATA_(param_);
      WHEN 'GET_CLIENT_REFERENCE_METADATA_' THEN
         clob_ := GET_CLIENT_REFERENCE_METADATA_(param_);
      WHEN 'GET_CLIENT_ENUMS_METADATA_' THEN
         clob_ := GET_CLIENT_ENUMS_METADATA_(param_);
      WHEN 'GET_CLIENT_ENTITYSET_METADATA_' THEN
         clob_ := GET_CLIENT_ENTITYSET_METADATA_(param_);
      WHEN 'GET_CLIENT_ATTRIBS_METADATA_' THEN
         clob_ := GET_CLIENT_ATTRIBS_METADATA_(param_);
      WHEN 'GET_ATTRIBUTES_METADATA_' THEN
         clob_ := GET_ATTRIBUTES_METADATA_(param_);
      WHEN 'GET_LOVSWITCH_METADATA_' THEN
         clob_ := GET_LOVSWITCH_METADATA_(param_);
      ELSE
         clob_ := '';         
         RETURN FALSE;
   END CASE;
   
   RETURN TRUE;
END Route_Callback_Content_;

FUNCTION Parse_Control_String___(
   control_ IN VARCHAR2 ) RETURN Control_Rec
IS
   result_ Control_Rec;
   view_   View_Reference_Rec;
   data_   VARCHAR2(32000);
   attr_   VARCHAR2(32000);
   ptr_    NUMBER := NULL;
   name_   VARCHAR2(100);
   value_  VARCHAR2(32000);
BEGIN
   result_.info_method_ := Link_Name___(control_);
   result_.service_     := To_Mixed_Case___(Link_Name___(result_.info_method_,'_SVC.'))||'.svc';
   result_.bindings_    := Link_Name___(Link_Value___(control_));
   result_.switch_name_ := Link_Name___(Link_Value___(Link_Value___(control_)));
   result_.switch_keys_ := Link_Name___(Link_Value___(Link_Value___(Link_Value___(control_))));
   result_.wildcards_   := Link_Value___(Link_Value___(Link_Value___(Link_Value___(control_))));
   result_.ref_column_  := Get_Arguments___(result_.bindings_);
   result_.ref_name_    := Get_Main_Entry___(result_.bindings_);
   
   data_ := Fetch_List_Of_Data___(result_.info_method_);
   attr_ := Fetch_List_Of_Views___(data_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (NOT result_.views_.exists(value_)) THEN
         view_ := Parse_View_Setting___(value_,nvl(result_.ref_name_,name_));
         IF (view_.key_count_ IS NOT NULL AND view_.col_count_ IS NOT NULL) THEN
            result_.views_(value_) := view_;
         END IF;
      END IF;
      IF (result_.views_.exists(value_)) THEN
         result_.xref_(name_) := value_;
      END IF;
   END LOOP;
   
   Parse_Control_String_Attributes___(data_, result_);
   RETURN result_;
END Parse_Control_String___;

PROCEDURE Parse_Control_String_Attributes___(
   data_   IN            VARCHAR2,
   result_ IN OUT NOCOPY Control_Rec)
IS
   ptr_            NUMBER := NULL;
   name_           VARCHAR2(100);
   value_          VARCHAR2(32000);
   ref_            VARCHAR2(200);
   service_        VARCHAR2(128);
BEGIN
   result_.attributes_ := Attribute_Arr();
   IF (instr(data_,'^') = 0) THEN
      -- No attributes to parse!
      RETURN; 
   END IF;
   
   service_ := To_Mixed_Case___(Link_Name___(Link_Value___(result_.info_method_, '('), ')'));
   WHILE (Client_SYS.Get_Next_From_Attr(data_, ptr_, name_, value_)) LOOP
      DECLARE
         field_          Attribute_Rec;
      BEGIN
         result_.service_ := NVL(Client_SYS.Get_Key_Reference_Value(value_, 'SERVICE'), service_) || '.svc';
         field_.name_         := name_;
         field_.entity_       := Client_SYS.Get_Key_Reference_Value(value_, 'ENTITY');
         ref_                 := Client_SYS.Get_Key_Reference_Value(value_, 'REF');
         IF (ref_ IS NOT NULL) THEN
            field_.view_id_ := Get_Base_View___(ref_);
         END IF;
         field_.col_name_     := Client_SYS.Get_Key_Reference_Value(value_, 'COLUMN');
         field_.def_col_name_ := replace(field_.col_name_, 'PARAM$', '');
         field_.qflags_       := Client_SYS.Get_Key_Reference_Value(value_, 'QFLAGS');
         field_.qdatatype_    := To_Marble_Datatype___(Client_SYS.Get_Key_Reference_Value(value_, 'QTYPE'));
         field_.enumerate_    := Client_SYS.Get_Key_Reference_Value(value_, 'ENUMERATE');
         --NOTE: Should be a translation placeholder!
         field_.label_        := Client_SYS.Get_Key_Reference_Value(value_, 'TITLE');
         IF (field_.label_ IS NULL) THEN
            field_.label_     := replace(replace(initcap(field_.col_name_),'_',' '),'Param$','');
         END IF;
         field_.select_       := Client_SYS.Get_Key_Reference_Value(value_, 'FETCH');
         field_.type_         := Client_SYS.Get_Key_Reference_Value(value_, 'DATATYPE');
         field_.editable_     := Client_SYS.Get_Key_Reference_Value(value_, 'EDITABLE');
         field_.sql_type_     := To_Sql_Datatype___(field_.type_);
         field_.size_         := Get_Size___(field_.type_);
         field_.type_         := To_Marble_Datatype___(field_.type_);
         result_.attributes_.extend;
         result_.attributes_(result_.attributes_.last) := field_;
      END;
   END LOOP;
 END Parse_Control_String_Attributes___;


FUNCTION Parse_Control_List_String___(
   control_ IN VARCHAR2 ) RETURN Control_List_Rec
IS
   result_    Control_List_Rec;
   view_      View_Reference_Rec;
   remaining_ VARCHAR2(2000);
   data_      VARCHAR2(32000);
   attr_      VARCHAR2(32000);
   ptr_       NUMBER := NULL;
   name_      VARCHAR2(30);
   value_     VARCHAR2(32000);
BEGIN
   remaining_ := Link_Name___(control_);
   WHILE (remaining_ IS NOT NULL) LOOP
      result_.info_method_ := Link_Name___(remaining_);
      data_ := Fetch_List_Of_Data___(result_.info_method_);
      attr_ := Fetch_List_Of_Views___(data_);
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (NOT result_.views_.exists(value_)) THEN
            view_ := Parse_View_Setting___(value_, NULL);
            IF (view_.key_count_ IS NOT NULL AND view_.col_count_ IS NOT NULL) THEN
               result_.views_(value_) := view_;
            END IF;
         END IF;
      END LOOP;
      remaining_ := Link_Value___(remaining_);
   END LOOP;
   RETURN result_;
END Parse_Control_List_String___;


FUNCTION Fetch_List_Of_Data___ (
   info_method_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
   attr_   CLOB;
   method_ VARCHAR2(100);
   parent_ VARCHAR2(100);
BEGIN
   --Rewrite this to use micro cache if there are performance problems
   IF (instr(info_method_,'(') < 1) THEN
      Assert_SYS.Assert_Is_Package_Method(info_method_);
      @ApproveDynamicStatement(2017-10-02,stlase)
      EXECUTE IMMEDIATE 'BEGIN ' || info_method_ || '(:attr_); END;'
         USING IN OUT attr_;
   ELSE
      parent_  := Link_Name___(Link_Value___(info_method_, '('), ')');
      method_  := Link_Name___(info_method_, '(');
      Assert_SYS.Assert_Is_Package_Method(method_);
      @ApproveDynamicStatement(2019-03-21,stlase)
      EXECUTE IMMEDIATE 'BEGIN ' || method_ || '(:parent, :attr_); END;'
         USING IN parent_, IN OUT attr_;
   END IF;
   RETURN attr_;
END Fetch_List_Of_Data___;


FUNCTION Fetch_List_Of_Views___ (
   data_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   ptr_    NUMBER := NULL;
   name_   VARCHAR2(100);
   value_  VARCHAR2(32000);
   ref_    VARCHAR2(1000);
   view_   VARCHAR2(1000);
   result_ VARCHAR2(32000);
BEGIN
   IF (instr(data_,'^') < 1) THEN
      RETURN data_;
   ELSE
      WHILE (Client_SYS.Get_Next_From_Attr(data_, ptr_, name_, value_)) LOOP
         ref_ := Client_SYS.Get_Key_Reference_Value(value_, 'REF');
         IF (ref_ IS NOT NULL) THEN
            view_  := Get_Base_View___(ref_);
            Client_SYS.Add_To_Attr(name_, view_, result_);
         END IF;
      END LOOP;
      RETURN result_;
   END IF;
END Fetch_List_Of_Views___;


FUNCTION Get_Base_View___(
   ref_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   candidate_ VARCHAR2(1000) := Link_Name___(Get_Main_Entry___(ref_), '/');
BEGIN
   --SOLSETFW
   IF (Dictionary_SYS.View_Is_Active(candidate_)) THEN
      RETURN upper(candidate_);
   ELSE
      RETURN Dictionary_SYS.Get_Base_View(candidate_);
   END IF;
END Get_Base_View___;


FUNCTION Parse_View_Setting___(
   view_setting_ IN VARCHAR2 ,
   ref_name_     IN VARCHAR2 ) RETURN View_Reference_Rec
IS
   filter_key_string_ VARCHAR2(2000);
   view_name_         VARCHAR2(200);   
   result_            View_Reference_Rec;
   
   col_refs_          DBMS_UTILITY.UNCL_ARRAY;     -- UNUSED
BEGIN   
   IF (INSTR(view_setting_, '(') > 0 ) THEN
      filter_key_string_ := REPLACE(SUBSTR(view_setting_, INSTR(view_setting_, '(') + 1, INSTR(view_setting_, ')') - (INSTR(view_setting_, '(')+1)), ' ', ''); 
      IF (filter_key_string_ IS NULL) THEN
         Error_SYS.System_General('VIEWDATA: Basic data format is incorrect for the given LOV view. :P1 ', view_setting_);
      END IF;
      DBMS_UTILITY.COMMA_TO_TABLE(filter_key_string_, result_.filter_count_, result_.filter_keys_);      
   END IF;
   
   result_.view_name_   := Get_Main_Entry___(view_setting_);
   view_name_           := To_Mixed_Case___(result_.view_name_);
   result_.entityset_   := 'DynReference_' || Friendly_Name___(view_name_);
   result_.entity_      := 'DynLov_' || view_name_;
   result_.selector_    := view_name_ || '_DynSelector';
   IF ref_name_ IS NULL THEN
      result_.navigate_    := 'Dyn_' || view_name_;
   ELSE  
      result_.navigate_    := 'Dyn_' || ref_name_ || '_' || view_name_;
   END IF;
   result_.use_keyref_ := (view_setting_ LIKE '%(keyref)');
   
   Reference_SYS.Get_View_Properties_(
      result_.key_names_,
      result_.col_names_,
      result_.col_prompts_,
      result_.col_types_,
      col_refs_,
      result_.col_enums_,
      result_.col_db_names_,
      result_.view_name_);   
   
   IF (result_.key_names_.COUNT > 0) THEN
      result_.key_count_ := result_.key_names_.COUNT;
   END IF;

   IF (result_.col_names_.COUNT > 0) THEN
      result_.col_count_ := result_.col_names_.COUNT;
            
      FOR i IN 1..result_.col_count_ LOOP
         -- References used by BI uses an data type for enumerations that is not correct, namely ENUMERATION.
         -- This needs to be fixed in the model, to start with, having the data types be returned as STRINGs and with a complete Enumeration definition
         -- Once that is done, this "fix" can be removed or the dynamically created references will not be possible to view. /Rakuse
         IF (result_.col_types_(i) = 'ENUMERATION') THEN
            result_.col_types_(i) := 'STRING';
         END IF;
         
         -- Custom Fields defined as Enumeration that are used inside referenced Entity (LOV) are incorrectly defining its
         -- data format using ENUMERATION(length) but should be STRING(length) as the Enumeration info is defined in other part of the metadata.
         -- However, fixing that requires changes in the Custom Obj logic, the CF templates and upgrade scripts
         -- for why following "fix" is placed here for the time being, until it's properly corrected. /Rakuse
         IF (result_.col_names_(i) LIKE 'CF$_%' AND result_.col_types_(i) LIKE 'ENUMERATION(%') THEN
            -- For Custom Fields enumerations, reformat their data type ENUMERATION(x) as STRING(x).
            result_.col_types_(i) := REPLACE(result_.col_types_(i), 'ENUMERATION', 'STRING');
         END IF;
      END LOOP;
   END IF;
   
   RETURN result_;
END Parse_View_Setting___;

FUNCTION Friendly_Name___ (
   name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   IF (INSTR(name_, '$') > 0) THEN
      RETURN REPLACE(name_, '$', 'Dollar');
   END IF;
   RETURN name_;
END Friendly_Name___;

-------------------- CLIENT METADATA ----------------------------------------

FUNCTION Get_Lovswitch_Metadata_ (
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_     CLOB;
   ctrl_     Control_Rec;
   xref_id_  VARCHAR2(1000);
   view_ref_ View_Reference_Rec;
   switch_key_count_ INTEGER;
   switch_keys_   DBMS_UTILITY.UNCL_ARRAY;
   flag_ BOOLEAN := TRUE;
BEGIN
   ctrl_ := Parse_Control_String___(control_);
   xref_id_ := ctrl_.xref_.FIRST;
   Append_Clob___(json_, '"lovswitch": [');
   WHILE xref_id_ IS NOT NULL LOOP
      view_ref_ := ctrl_.views_(ctrl_.xref_(xref_id_));
      IF (xref_id_ != ctrl_.xref_.FIRST) THEN
         Append_Clob___(json_, ',');
      END IF;
      DECLARE
         lovswitch_ Aurena_Client_Metadata_SYS.LovSwitch_Rec;
         lov_       Aurena_Client_Metadata_SYS.Lov_Rec;
         update_    Aurena_Client_Metadata_SYS.AttributeUpdate_Rec;
         source_    VARCHAR2(2000);
      BEGIN
         Aurena_Client_Metadata_SYS.Set_Case(lovswitch_, 'record.'||To_Mixed_Case___(ctrl_.switch_name_)||' === '''||xref_id_||'''');
         Aurena_Client_Metadata_SYS.Set_Reference(lovswitch_, view_ref_.navigate_);
         Aurena_Client_Metadata_SYS.Set_Selector(lov_, view_ref_.selector_);
         source_ := ctrl_.service_||'/'||view_ref_.entityset_;
         IF (LENGTH(ctrl_.switch_keys_) > 0 AND NOT view_ref_.use_keyref_ AND view_ref_.key_count_ > 1) THEN
            DBMS_UTILITY.COMMA_TO_TABLE(ctrl_.switch_keys_, switch_key_count_, switch_keys_);
            source_ := source_||'?$filter=';
            FOR i_ IN 1 .. view_ref_.key_count_-1 LOOP
               flag_ := FALSE;
               IF (i_ > 1) THEN
                  source_ := source_||' and ';
               END IF;
               FOR j_ IN 1 .. switch_key_count_ LOOP
                  IF  ( switch_keys_(j_) = view_ref_.key_names_(i_) OR instr(switch_keys_(j_), view_ref_.key_names_(i_)) > 0) THEN
                     source_ := source_||To_Mixed_Case___(view_ref_.key_names_(i_))||' eq $['||To_Mixed_Case___(switch_keys_(j_))||']';
                     flag_ := TRUE;  
                     EXIT;    
                  END IF;         
               END LOOP;
               IF (NOT flag_) THEN
                  source_ := source_||To_Mixed_Case___(view_ref_.key_names_(i_))||' ne null';
               END IF;
            END LOOP;
         ELSIF (NOT view_ref_.use_keyref_ AND view_ref_.key_count_ > 1) THEN    
            source_ := source_||'?$filter=';
            FOR i_ IN 1 .. view_ref_.key_count_-1 LOOP                
               IF (i_ > 1 ) THEN
                  source_ := source_||' and ';
               END IF;
               IF (i_ <= view_ref_.filter_count_) THEN
                  source_ := source_||To_Mixed_Case___(view_ref_.key_names_(i_))||' eq $['||To_Mixed_Case___(view_ref_.filter_keys_(i_))||']';  
               ELSE 
                  source_ := source_||To_Mixed_Case___(view_ref_.key_names_(i_))||' ne null';
               END IF;                 
            END LOOP;
         END IF;
         Aurena_Client_Metadata_SYS.Set_Datasource(lov_, source_);
         IF (LENGTH(ctrl_.wildcards_) > 0) THEN
            lov_.wildcards_ := JSON_ARRAY_T(ctrl_.wildcards_);
         END IF;
         Aurena_Client_Metadata_SYS.Set_Lov(lovswitch_, lov_);
         IF (NOT view_ref_.use_keyref_ AND view_ref_.key_count_ > 1) THEN
            source_ := source_||' and ';
         ELSE
            source_ := source_||'?$filter=';
         END IF;
         IF (view_ref_.use_keyref_) THEN
            source_ := source_||'keyref'||' eq $['||To_Mixed_Case___(ctrl_.ref_column_)||']';
         ELSE
            source_ := source_||To_Mixed_Case___(view_ref_.key_names_(view_ref_.key_count_))||' eq $['||To_Mixed_Case___(ctrl_.ref_column_)||']';
         END IF;
         Aurena_Client_Metadata_SYS.Set_Datasource(update_, source_);
         IF (view_ref_.use_keyref_) THEN
            Aurena_Client_Metadata_SYS.Add_Copy(update_, To_Mixed_Case___(ctrl_.ref_column_), 'keyref');
         ELSE
            Aurena_Client_Metadata_SYS.Add_Copy(update_, To_Mixed_Case___(ctrl_.ref_column_), To_Mixed_Case___(view_ref_.key_names_(view_ref_.key_count_)));
         END IF;
         Aurena_Client_Metadata_SYS.Set_Item(update_, view_ref_.navigate_);
         Aurena_Client_Metadata_SYS.Set_Update(lovswitch_, update_);
         Append_Clob___(json_, Aurena_Client_Metadata_SYS.Build(lovswitch_));
      END;
      xref_id_ := ctrl_.xref_.next(xref_id_);
   END LOOP;
   Append_Clob___(json_, ']');
   RETURN json_;
END Get_Lovswitch_Metadata_;


FUNCTION Get_Selectors_Metadata_ (
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_        CLOB;
   ctrl_        Control_List_Rec;
   view_id_     VARCHAR2(1000);
   view_ref_    View_Reference_Rec;
   view_names_  DBMS_UTILITY.UNCL_ARRAY;     
   index_       NUMBER;
   index_temp_  NUMBER := 1;
   count_       NUMBER := 1;
   method_list_ VARCHAR2(32000) := control_;     
BEGIN
   --------------------Begin to handle duplicate view entries in json--------------------
   index_ := instr(control_,':');
   WHILE index_ >= 0 LOOP      
      Break_Method_Name___(control_, index_, index_temp_, method_list_);
      ctrl_ := Parse_Control_List_String___(method_list_);
      view_id_ := ctrl_.views_.FIRST;      
      <<viewloop>>
      WHILE view_id_ IS NOT NULL LOOP
         IF Is_List_View_Exist___(ctrl_,view_id_,count_,view_names_) THEN
           CONTINUE viewloop;
         END IF;
         ----------------------------------End handling duplicate view entries------------------
         view_ref_ := ctrl_.views_(view_id_);
         IF (view_id_ != ctrl_.views_.FIRST OR count_ > 2) THEN
            Append_Clob___(json_, ',');
         END IF;
         DECLARE
            selector_  Aurena_Client_Metadata_SYS.Selector_Rec;
            element_   Aurena_Client_Metadata_SYS.FieldElement_Rec;
            field_     Aurena_Client_Metadata_SYS.Field_Rec;
            type_      VARCHAR2(100);
            name_      VARCHAR2(100);
            prompt_    VARCHAR2(100);
            size_      VARCHAR2(100);
         BEGIN
            Aurena_Client_Metadata_SYS.Set_Name(selector_, view_ref_.selector_);
            Aurena_Client_Metadata_SYS.Set_Label(selector_, 'dynamic');
            Aurena_Client_Metadata_SYS.Set_Entity(selector_, view_ref_.entity_);
            FOR i_ IN 1 .. view_ref_.col_count_ LOOP
               name_ := To_Mixed_Case___(view_ref_.col_names_(i_));
               Aurena_Client_Metadata_SYS.Add_Select_Attributes(selector_, name_);
               Aurena_Client_Metadata_SYS.Set_Name(field_, name_);
               Aurena_Client_Metadata_SYS.Set_Entity(field_, view_ref_.entity_);
               Aurena_Client_Metadata_SYS.Set_Attribute(field_, name_);
               Aurena_Client_Metadata_SYS.Set_Control(field_, 'static');
               prompt_ := To_Mixed_Case___(view_ref_.col_prompts_(i_));
               Aurena_Client_Metadata_SYS.Set_Label(field_, prompt_);
               type_ := view_ref_.col_types_(i_);
               Aurena_Client_Metadata_SYS.Set_Datatype(field_, To_Marble_Datatype___(type_));
               size_ := Get_Size___(type_);
               IF (size_ IS NOT NULL) THEN
                  Aurena_Client_Metadata_SYS.Set_Maxlength(field_, size_);
               END IF;
               Aurena_Client_Metadata_SYS.Set_Array(field_, FALSE);
               Aurena_Client_Metadata_SYS.Set_Editable(field_, FALSE);
               Aurena_Client_Metadata_SYS.Set_Required(field_, FALSE);
               Aurena_Client_Metadata_SYS.Set_Field(element_, field_);
               Aurena_Client_Metadata_SYS.Add_Content(selector_, element_);
            END LOOP;
            Append_Clob___(json_, '"'||view_ref_.selector_||'":');
            Append_Clob___(json_, Aurena_Client_Metadata_SYS.Build(selector_));
         END;
         view_id_ := ctrl_.views_.next(view_id_);
      END LOOP;
   END LOOP;
   RETURN json_;
END Get_Selectors_Metadata_;


FUNCTION Get_Fields_Metadata_ (
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_    CLOB;
   ctrl_    Control_Rec;
   attr_    Attribute_Rec;
   is_ref_  BOOLEAN;
   view_    View_Reference_Rec;   
BEGIN
   ctrl_ := Parse_Control_String___(control_);
   IF (ctrl_.attributes_.count = 0) THEN
      RETURN json_;
   END IF;
   
   FOR attr_no_ IN ctrl_.attributes_.first .. ctrl_.attributes_.last LOOP
      attr_    := ctrl_.attributes_(attr_no_);
      is_ref_  := (attr_.view_id_ IS NOT NULL);
      IF (is_ref_) THEN
         view_ := ctrl_.views_(attr_.view_id_);
      ELSE
         view_ := NULL;
      END IF;
      DECLARE
         element_   Aurena_Client_Metadata_SYS.FieldElement_Rec;
         field_     Aurena_Client_Metadata_SYS.Field_Rec;
         qattr_     Aurena_Client_Metadata_SYS.QAttributes_Rec;
         lov_       Aurena_Client_Metadata_SYS.Lov_Rec;
         update_    Aurena_Client_Metadata_SYS.AttributeUpdate_Rec;
         source_    VARCHAR2(2000);
      BEGIN
         IF (is_ref_) THEN
            Aurena_Client_Metadata_SYS.Set_Name(field_, attr_.name_||'Ref');
            Aurena_Client_Metadata_SYS.Add_Select_Attributes(field_, attr_.name_);
         ELSE
            Aurena_Client_Metadata_SYS.Set_Name(field_, attr_.name_);
         END IF;
         Aurena_Client_Metadata_SYS.Set_Entity(field_, attr_.entity_);
         Aurena_Client_Metadata_SYS.Set_Attribute(field_, attr_.name_);
         Aurena_Client_Metadata_SYS.Set_Reference(field_, view_.navigate_);
         IF (is_ref_) THEN
            Aurena_Client_Metadata_SYS.Set_Control(field_, 'lookup');
            Aurena_Client_Metadata_SYS.Set_Selector(lov_, view_.selector_);
            --Aurena_Client_Metadata_SYS.Set_Advancedview(lov_, To_Mixed_Case___(attr_.view_id_)||'LovList');
            source_ := ctrl_.service_||'/'||view_.entityset_;
            Aurena_Client_Metadata_SYS.Set_Datasource(lov_, source_);
            Aurena_Client_Metadata_SYS.Set_Lov(field_, lov_);
            IF (view_.key_count_ > 1) THEN
               source_ := source_||' and ';
            ELSE
               source_ := source_||'?$filter=';
            END IF;
            source_ := source_||To_Mixed_Case___(view_.key_names_(view_.key_count_))||' eq $['||attr_.name_||']';
            Aurena_Client_Metadata_SYS.Set_Datasource(update_, source_);
            Aurena_Client_Metadata_SYS.Set_Item(update_, attr_.name_||'Ref');
            Aurena_Client_Metadata_SYS.Add_Copy(update_, attr_.name_, To_Mixed_Case___(view_.key_names_(view_.key_count_)));
            Aurena_Client_Metadata_SYS.Set_Update(field_, update_);
         ELSE
            Aurena_Client_Metadata_SYS.Set_Control(field_, 'field');
         END IF;
         Aurena_Client_Metadata_SYS.Set_Label(field_, attr_.label_);
         IF (attr_.enumerate_ IS NOT NULL) THEN
            Aurena_Client_Metadata_SYS.Set_Datatype(field_, 'Enumeration');
            Aurena_Client_Metadata_SYS.Set_Enumeration(field_, attr_.name_||'Enum');
         ELSE
            Aurena_Client_Metadata_SYS.Set_Datatype(field_, attr_.type_);
         END IF;
         IF (attr_.size_ IS NOT NULL) THEN
            Aurena_Client_Metadata_SYS.Set_Maxlength(field_, attr_.size_);
         END IF;
         Aurena_Client_Metadata_SYS.Set_Array(field_, FALSE);
         Aurena_Client_Metadata_SYS.Set_Editable(field_, attr_.editable_);
         Aurena_Client_Metadata_SYS.Set_Required(field_, substr(attr_.qflags_,1,1) = 'M');         
         qattr_.qflags_ := attr_.qflags_;
         qattr_.qdatatype_ := attr_.qdatatype_;
         Aurena_Client_Metadata_SYS.Set_QAttributes(field_, qattr_);
         Aurena_Client_Metadata_SYS.Set_Field(element_, field_);
         IF (attr_no_ != ctrl_.attributes_.first) THEN
            Append_Clob___(json_, ',');
         END IF;
         Append_Clob___(json_, Aurena_Client_Metadata_SYS.Build(element_));
      END;
   END LOOP;
   RETURN json_;
END Get_Fields_Metadata_;

-------------------- PROJECTION CLIENT METADATA -----------------------------

FUNCTION Get_Client_Entityset_Metadata_ (
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_        CLOB;
   ctrl_        Control_List_Rec;
   view_id_     VARCHAR2(1000);
   view_ref_    View_Reference_Rec;
   view_names_  DBMS_UTILITY.UNCL_ARRAY;     
   index_       NUMBER;
   index_temp_  NUMBER := 1;
   count_       NUMBER := 1;
   method_list_ VARCHAR2(32000) := control_;
BEGIN
   --------------------Begin to handle duplicate view entries in json--------------------
   index_ := instr(control_,':');
   WHILE index_ >= 0 LOOP      
      Break_Method_Name___(control_, index_, index_temp_, method_list_);
      ctrl_ := Parse_Control_List_String___(method_list_);
      view_id_ := ctrl_.views_.FIRST;      
      <<viewloop>>
      WHILE view_id_ IS NOT NULL LOOP
         IF Is_List_View_Exist___(ctrl_,view_id_,count_,view_names_) THEN
           CONTINUE viewloop;
         END IF;
         ----------------------------------End handling duplicate view entries------------------
         view_ref_ := ctrl_.views_(view_id_);
         IF (view_id_ != ctrl_.views_.FIRST OR count_ > 2) THEN
            Append_Clob___(json_, ',');
         END IF;
         DECLARE
            entityset_ Aurena_Client_Metadata_SYS.EntitySet_Rec;
         BEGIN
            Aurena_Client_Metadata_SYS.Set_Name(entityset_, view_ref_.entityset_);
            Aurena_Client_Metadata_SYS.Set_Entity(entityset_, view_ref_.entity_);
            Aurena_Client_Metadata_SYS.Set_Array(entityset_, TRUE);
            Append_Clob___(json_, '"'||view_ref_.entityset_||'":');
            Append_Clob___(json_, Aurena_Client_Metadata_SYS.Build(entityset_));
         END;
         view_id_ := ctrl_.views_.next(view_id_);
      END LOOP;
   END LOOP;
   RETURN json_;
END Get_Client_Entityset_Metadata_;


FUNCTION Get_Client_Entity_Metadata_ (
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_        CLOB;
   ctrl_        Control_List_Rec;
   view_id_     VARCHAR2(1000);
   view_ref_    View_Reference_Rec;
   view_names_  DBMS_UTILITY.UNCL_ARRAY;     
   index_       NUMBER;
   index_temp_  NUMBER := 1;
   count_       NUMBER := 1;
   method_list_ VARCHAR2(32000) := control_;
   key_index_   INTEGER;
BEGIN
   --------------------Begin to handle duplicate view entries in json--------------------
   index_ := instr(control_,':');
   WHILE index_ >= 0 LOOP      
      Break_Method_Name___(control_, index_, index_temp_, method_list_);
      ctrl_ := Parse_Control_List_String___(method_list_);
      view_id_ := ctrl_.views_.FIRST;      
      <<viewloop>>
      WHILE view_id_ IS NOT NULL LOOP
         IF Is_List_View_Exist___(ctrl_,view_id_,count_,view_names_) THEN
           CONTINUE viewloop;
         END IF;
         ----------------------------------End handling duplicate view entries------------------
         
         view_ref_ := ctrl_.views_(view_id_);
         IF (view_id_ != ctrl_.views_.FIRST OR count_ > 2) THEN
            Append_Clob___(json_, ',');
         END IF;
         DECLARE
            entity_    Aurena_Client_Metadata_SYS.Entity_Rec;
            attribute_ Aurena_Client_Metadata_SYS.Attribute_Rec;
            type_      VARCHAR2(100);
            BEGIN
            Aurena_Client_Metadata_SYS.Set_Name(entity_, view_ref_.entity_);
            Aurena_Client_Metadata_SYS.Set_Has_E_Tag(entity_, FALSE);
            Aurena_Client_Metadata_SYS.Set_C_R_U_D(entity_, 'Read');
            Aurena_Client_Metadata_SYS.Set_Luname(entity_, view_ref_.entity_);
            Aurena_Client_Metadata_SYS.Add_Ludependencies(entity_, view_ref_.entity_);
            FOR i_ IN 1 .. view_ref_.key_count_ LOOP
               Aurena_Client_Metadata_SYS.Set_Datatype(attribute_, 'Text');
               Aurena_Client_Metadata_SYS.Set_Keygeneration(attribute_, 'Server');
               key_index_ := Get_Index_By_Name___(view_ref_.col_names_, view_ref_.key_names_(i_));
               IF (key_index_ > 0) THEN
                  type_ := view_ref_.col_types_(key_index_);
                  Aurena_Client_Metadata_SYS.Set_Format(attribute_, Get_Format___(type_));
               END IF;
               Aurena_Client_Metadata_SYS.Add_Attributes(entity_, To_Mixed_Case___(view_ref_.key_names_(i_)), attribute_);               
               Aurena_Client_Metadata_SYS.Set_Has_Keys(entity_, TRUE);
               Aurena_Client_Metadata_SYS.Add_Keys(entity_, To_Mixed_Case___(view_ref_.key_names_(i_)));                           
            END LOOP;
            FOR i_ IN 1 .. view_ref_.col_count_ LOOP
               IF (NOT Contains___(view_ref_.key_names_, view_ref_.col_names_(i_))) THEN
                  type_ := view_ref_.col_types_(i_);
                  Aurena_Client_Metadata_SYS.Set_Datatype(attribute_, To_Marble_Datatype___(type_));
                  Aurena_Client_Metadata_SYS.Set_Format(attribute_, Get_Format___(type_));
                  Aurena_Client_Metadata_SYS.Set_Keygeneration(attribute_, 'User');
                  Aurena_Client_Metadata_SYS.Add_Attributes(entity_, To_Mixed_Case___(view_ref_.col_names_(i_)), attribute_);
               END IF;
            END LOOP;
            Append_Clob___(json_, '"'||view_ref_.entity_||'":');
            Append_Clob___(json_, Aurena_Client_Metadata_SYS.Build(entity_));
         END;
         view_id_ := ctrl_.views_.next(view_id_);
      END LOOP;
   END LOOP;
   RETURN json_;
END Get_Client_Entity_Metadata_;


FUNCTION Get_Client_Reference_Metadata_ (
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_     CLOB;
   ctrl_     Control_Rec;
   view_id_  VARCHAR2(1000);
   xref_id_  VARCHAR2(4000);
   case_     VARCHAR2(32000);
   view_ref_ View_Reference_Rec;
BEGIN
   ctrl_ := Parse_Control_String___(control_);
   view_id_ := ctrl_.views_.FIRST;
   WHILE view_id_ IS NOT NULL LOOP
      case_ := NULL;
      xref_id_ := ctrl_.xref_.FIRST;
      WHILE xref_id_ IS NOT NULL LOOP
         IF (view_id_ = ctrl_.xref_(xref_id_)) THEN
            IF (case_ IS NOT NULL) THEN
               case_ := case_||' || ';
            END IF;
            case_ := case_||'record.'||To_Mixed_Case___(ctrl_.switch_name_)||' === '''||xref_id_||'''';
         END IF;
         xref_id_ := ctrl_.xref_.next(xref_id_);
      END LOOP;
      view_ref_ := ctrl_.views_(view_id_);
      IF (view_id_ != ctrl_.views_.FIRST) THEN
         Append_Clob___(json_, ',');
      END IF;
      DECLARE
         reference_       Aurena_Client_Metadata_SYS.EntityReference_Rec;
         source_          VARCHAR2(32000);
         parent_attr_     VARCHAR2(200);
         
         proj_attributes_ DBMS_UTILITY.UNCL_ARRAY;
         view_attributes_ DBMS_UTILITY.UNCL_ARRAY;         
      BEGIN
         parent_attr_ := To_Mixed_Case___(ctrl_.ref_column_);
         IF (parent_attr_ IS NULL) THEN
            parent_attr_ := substr(view_ref_.navigate_, instr(view_ref_.navigate_,'_')+1, instr(view_ref_.navigate_,'_',1,2)-instr(view_ref_.navigate_,'_')-1);
         END IF;
         IF (ctrl_.ref_column_ IS NOT NULL AND case_ IS NOT NULL) THEN
            Aurena_Client_Metadata_SYS.Set_Case(reference_, case_);
         END IF;
         Aurena_Client_Metadata_SYS.Set_Target(reference_, view_ref_.entity_);
         source_ := ctrl_.service_||'/'||view_ref_.entityset_;

         -- Filter definitions...
         IF (view_ref_.use_keyref_) THEN
            -- Keyref
            view_attributes_(1) := 'keyref';
            proj_attributes_(1) := parent_attr_;
         ELSIF (ctrl_.ref_column_ IS NOT NULL) THEN                          
            -- Dynamic reference: Last key attribute is the one mapped to the ref column
            Aurena_Client_Metadata_SYS.Add_Mapping(reference_, To_Mixed_Case___(ctrl_.ref_column_), To_Mixed_Case___(view_ref_.key_names_(view_ref_.key_count_)));
            IF (view_ref_.filter_count_ > 0) THEN               
               FOR i_ IN 1 .. view_ref_.key_count_-1 LOOP                
                  view_attributes_(i_) := To_Mixed_Case___(view_ref_.key_names_(i_));
                  IF (i_ <= view_ref_.filter_count_) THEN
                     proj_attributes_(i_) := To_Mixed_Case___(view_ref_.filter_keys_(i_));
                  END IF;                 
               END LOOP;               
            END IF;
         ELSE
            -- Dynamic attributes (used in e.g. OrderReportTemplate)
            FOR i_ IN 1 .. view_ref_.key_count_ LOOP                               
               view_attributes_(i_) := To_Mixed_Case___(view_ref_.key_names_(i_));
               proj_attributes_(i_) := Resolve_Name___(view_ref_.key_names_(i_), ctrl_.attributes_);
            END LOOP;
         END IF;
         Append_Filter___(source_, reference_, view_attributes_, proj_attributes_);
         
         Aurena_Client_Metadata_SYS.Set_Datasource(reference_, source_);
         Append_Clob___(json_, '"'||view_ref_.navigate_||'":');
         Append_Clob___(json_, Aurena_Client_Metadata_SYS.Build(reference_));
      END;
      view_id_ := ctrl_.views_.next(view_id_);
   END LOOP;
   RETURN json_;
END Get_Client_Reference_Metadata_;

PROCEDURE Append_Filter___ (
   source_          IN OUT NOCOPY VARCHAR2,
   reference_       IN OUT NOCOPY Aurena_Client_Metadata_SYS.EntityReference_Rec,
   view_attributes_ IN DBMS_UTILITY.UNCL_ARRAY,
   proj_attributes_ IN DBMS_UTILITY.UNCL_ARRAY)
IS
BEGIN
   IF (view_attributes_.COUNT = 0) THEN
      RETURN;
   END IF;
   
   FOR i_ IN 1 .. view_attributes_.COUNT LOOP                
      IF (i_ = 1) THEN
         source_ := source_ || '?$filter=';
      ELSE
         source_ := source_ || ' and ';
      END IF;
      source_ := source_ || view_attributes_(i_);
      IF (i_ <= proj_attributes_.COUNT) THEN
         source_ := source_ || ' eq $[' || proj_attributes_(i_) || ']';
         Aurena_Client_Metadata_SYS.Add_Mapping(reference_, proj_attributes_(i_), view_attributes_(i_));
      ELSE 
         source_ := source_ || ' ne null';
      END IF;                 
   END LOOP;
   
END Append_Filter___;


FUNCTION Resolve_Name___ (
   def_col_name_ IN VARCHAR2,
   attributes_ IN Attribute_Arr) RETURN VARCHAR2
IS
BEGIN
   IF (attributes_.count > 0 ) THEN      
      FOR i_ IN 1 .. attributes_.count LOOP
         IF (attributes_(i_).def_col_name_ = def_col_name_) THEN  
            RETURN attributes_(i_).name_;
         END IF;
      END LOOP;             
   END IF;
   RETURN To_Mixed_Case___(def_col_name_);
END Resolve_Name___;


FUNCTION Get_Client_Enums_Metadata_ (
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_    CLOB;
   ctrl_    Control_Rec;
   attr_    Attribute_Rec;     
BEGIN
   ctrl_ := Parse_Control_String___(control_);
   IF (ctrl_.attributes_.count = 0) THEN
      RETURN json_;
   END IF;
   
   FOR attr_no_ IN ctrl_.attributes_.first .. ctrl_.attributes_.last LOOP
      attr_    := ctrl_.attributes_(attr_no_);
      IF (attr_.enumerate_ IS NOT NULL) THEN
         DECLARE
            enumeration_   Aurena_Client_Metadata_SYS.Enumeration_Rec;
            client_values_ VARCHAR2(32000);
            client_value_  VARCHAR2(2000);
         BEGIN
            client_values_ := Fetch_Enum_Client_Values_(attr_.enumerate_);
            Aurena_Client_Metadata_SYS.Set_Name(enumeration_, attr_.name_||'Enum');
            FOR i_ IN 0 .. 1000 LOOP
               client_value_ := Domain_SYS.Get_Client_Value_(client_values_, i_);
               EXIT WHEN client_value_ IS NULL;
               DECLARE
                  label_ Aurena_Client_Metadata_SYS.EnumLabel_Rec;
               BEGIN
                  Aurena_Client_Metadata_SYS.Add_Values(enumeration_, Get_Identifier___(i_));
                  Aurena_Client_Metadata_SYS.Set_Value(label_, Get_Identifier___(i_));
                  Aurena_Client_Metadata_SYS.Set_Label(label_, client_value_);
                  Aurena_Client_Metadata_SYS.Add_Labels(enumeration_, label_);
               END;
            END LOOP;
            IF (json_ IS NOT NULL) THEN
               Append_Clob___(json_, ',');
            END IF;
            Append_Clob___(json_, '"'||attr_.name_||'Enum":');
            Append_Clob___(json_, Aurena_Client_Metadata_SYS.Build(enumeration_));
         END;
      END IF;
   END LOOP;
   RETURN json_;
END Get_Client_Enums_Metadata_;


FUNCTION Get_Client_Attribs_Metadata_ (
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_    CLOB;
   ctrl_    Control_Rec;
   attr_    Attribute_Rec;     
BEGIN
   ctrl_ := Parse_Control_String___(control_);
   IF (ctrl_.attributes_.count = 0) THEN
      RETURN json_;
   END IF;
   
   FOR attr_no_ IN ctrl_.attributes_.first .. ctrl_.attributes_.last LOOP
      attr_    := ctrl_.attributes_(attr_no_);
      DECLARE
         attribute_ Aurena_Client_Metadata_SYS.Attribute_Rec;
      BEGIN
         IF (attr_.enumerate_ IS NOT NULL) THEN
            Aurena_Client_Metadata_SYS.Set_Datatype(attribute_, 'Enumeration');
            Aurena_Client_Metadata_SYS.Set_Subtype(attribute_, attr_.name_||'Enum');
         ELSE
            Aurena_Client_Metadata_SYS.Set_Datatype(attribute_, attr_.type_);
         END IF;
         IF (attr_.size_ IS NOT NULL) THEN
            Aurena_Client_Metadata_SYS.Set_Size(attribute_, attr_.size_);
         END IF;
         Aurena_Client_Metadata_SYS.Set_Keygeneration(attribute_, 'User');
         Aurena_Client_Metadata_SYS.Set_Required(attribute_, FALSE);
         Aurena_Client_Metadata_SYS.Set_Updatable(attribute_, TRUE);
         Aurena_Client_Metadata_SYS.Set_Insertable(attribute_, TRUE);
         IF (attr_no_ != ctrl_.attributes_.first) THEN
            Append_Clob___(json_, ',');
         END IF;
         Append_Clob___(json_, '"'||attr_.name_||'":');
         Append_Clob___(json_, Aurena_Client_Metadata_SYS.Build(attribute_));
      END;
   END LOOP;
   RETURN json_;
END Get_Client_Attribs_Metadata_;

-------------------- PROJECTION SERVER METADATA -----------------------------

FUNCTION Get_Entityset_Metadata_(
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_        CLOB;
   ctrl_        Control_Rec;
   view_id_     VARCHAR2(1000);
   view_ref_    View_Reference_Rec;
   view_names_  DBMS_UTILITY.UNCL_ARRAY;     
   index_       NUMBER;
   index_temp_  NUMBER := 1;
   count_       NUMBER := 1;
   method_list_ VARCHAR2(32000) := control_; 
BEGIN
   --------------------Begin to handle duplicate view entries in json--------------------
   index_ := instr(control_,':');
   WHILE index_ >= 0 LOOP      
      Break_Method_Name___(control_, index_, index_temp_, method_list_);
      ctrl_ := Parse_Control_String___(method_list_);
      view_id_ := ctrl_.views_.FIRST;      
      <<viewloop>>
      WHILE view_id_ IS NOT NULL LOOP
         IF Is_View_Exist___(ctrl_,view_id_,count_,view_names_) THEN
           CONTINUE viewloop;
         END IF;
         ----------------------------------End handling duplicate view entries------------------
         view_ref_ := ctrl_.views_(view_id_);
         IF (view_id_ != ctrl_.views_.FIRST OR count_ > 2) THEN
            Append_Clob___(json_, ',');
         END IF;
         DECLARE
            entityset_ Odata_Provider_Metadata_SYS.EntitySet_Rec;
         BEGIN
            Odata_Provider_Metadata_SYS.Set_Name(entityset_, view_ref_.entityset_);
            Odata_Provider_Metadata_SYS.Set_Entity_Type(entityset_, view_ref_.entity_);
            Append_Clob___(json_, Odata_Provider_Metadata_SYS.Build(entityset_));
         END;
         view_id_ := ctrl_.views_.next(view_id_);
      END LOOP;
   END LOOP;
   RETURN json_;
END Get_Entityset_Metadata_;


FUNCTION Get_Entity_Metadata_(
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_        CLOB;
   ctrl_        Control_Rec;
   view_id_     VARCHAR2(1000);
   view_ref_    View_Reference_Rec;      
   view_names_  DBMS_UTILITY.UNCL_ARRAY;     
   index_       NUMBER;
   index_temp_  NUMBER := 1;
   count_       NUMBER := 1;
   method_list_ VARCHAR2(32000) := control_;     
BEGIN
   --------------------Begin to handle duplicate view entries in json--------------------
   index_ := instr(control_,':');
   WHILE index_ >= 0 LOOP      
      Break_Method_Name___(control_, index_, index_temp_, method_list_);
      ctrl_ := Parse_Control_String___(method_list_);
      view_id_ := ctrl_.views_.FIRST;      
      <<viewloop>>
      WHILE view_id_ IS NOT NULL LOOP
         IF Is_View_Exist___(ctrl_,view_id_,count_,view_names_) THEN
           CONTINUE viewloop;
         END IF;
         ----------------------------------End handling duplicate view entries------------------
         view_ref_ := ctrl_.views_(view_id_);
         IF (view_id_ != ctrl_.views_.FIRST OR count_ > 2) THEN
            Append_Clob___(json_, ',');
         END IF;
         DECLARE
            entity_    Odata_Provider_Metadata_SYS.Entity_Rec;
            execute_   Odata_Provider_Metadata_SYS.EntityExecute_Rec;
            sql_       Odata_Provider_Metadata_SYS.EntityExecuteSQL_Rec;
            where_     VARCHAR2(2000);
            data_type_ VARCHAR2(100);
            j_         INTEGER;
         BEGIN
            Odata_Provider_Metadata_SYS.Set_Name(entity_, view_ref_.entity_);
            Odata_Provider_Metadata_SYS.Set_Support_Warnings(entity_, FALSE);
            Odata_Provider_Metadata_SYS.Set_From(sql_, view_ref_.view_name_);
            Odata_Provider_Metadata_SYS.Set_S_Q_L(execute_, sql_);
            Odata_Provider_Metadata_SYS.Set_Execute(entity_, execute_);
            where_ := '(';
            Add_Keyref_Attribute___(entity_, view_ref_);
            FOR i_ IN 1 .. view_ref_.key_count_ LOOP
               Odata_Provider_Metadata_SYS.Add_Keys(entity_, To_Mixed_Case___(view_ref_.key_names_(i_)));
               j_ := Get_Index_By_Name___(view_ref_.col_names_, view_ref_.key_names_(i_));
               IF ((j_ > 0) AND (view_ref_.col_types_(j_) IS NOT NULL)) THEN
                  data_type_ := view_ref_.col_types_(j_);
               ELSE
                  data_type_ := 'STRING(200)';
               END IF;              
               Add_Entity_Attribute___(entity_, view_ref_.key_names_(i_), data_type_);
               IF (i_ > 1) THEN
                  where_ := where_||' AND ';
               END IF;
               where_ := where_||lower(view_ref_.key_names_(i_))||' = :'||To_Mixed_Case___(view_ref_.key_names_(i_));
            END LOOP;
            where_ := where_||')';
            Odata_Provider_Metadata_SYS.Set_Keys_Where(entity_, where_);
            FOR i_ IN 1 .. view_ref_.col_count_ LOOP
               IF (NOT Contains___(view_ref_.key_names_, view_ref_.col_names_(i_))) THEN
                  Add_Entity_Attribute___(entity_, view_ref_.col_names_(i_), view_ref_.col_types_(i_), view_ref_.view_name_);
               END IF;
            END LOOP;
            Append_Clob___(json_, Odata_Provider_Metadata_SYS.Build(entity_));
         END;
         view_id_ := ctrl_.views_.next(view_id_);
      END LOOP;
   END LOOP;
   RETURN json_;
END Get_Entity_Metadata_;


PROCEDURE Add_Keyref_Attribute___ (
   entity_   IN OUT Odata_Provider_Metadata_SYS.Entity_Rec,
   view_ref_ IN     View_Reference_Rec )
IS
   attribute_ Odata_Provider_Metadata_SYS.Attribute_Rec;
   execute_   Odata_Provider_Metadata_SYS.AttributeExecute_Rec;
   sql_       Odata_Provider_Metadata_SYS.AttributeExecuteSQL_Rec;
   select_    VARCHAR2(32000);
   
   j_           INTEGER;
   keys_        DBMS_UTILITY.UNCL_ARRAY;
   sorted_keys_ DBMS_UTILITY.UNCL_ARRAY;
   
   CURSOR sort_keys IS
      SELECT * FROM table(keys_)
      ORDER BY 1;
BEGIN   
   FOR i_ IN 1 .. view_ref_.key_count_ LOOP
      -- Find the key index among the column definitions, to get the array index right.
      j_ := Get_Index_By_Name___(view_ref_.col_names_, view_ref_.key_names_(i_));
      IF ((j_ > 0) AND (view_ref_.col_db_names_(j_) IS NOT NULL)) THEN
         keys_(i_) := view_ref_.col_db_names_(j_);
      ELSE
         keys_(i_) := view_ref_.key_names_(i_);  
      END IF;
      -- TODO: If Key is not included as column is due to being a Parent Key.
      -- Still, it might be in need to become replaced using its correcponding _DB column. /Rakuse
   END LOOP;
   
   OPEN sort_keys;
   FETCH sort_keys BULK COLLECT INTO sorted_keys_;
   CLOSE sort_keys; 
   
   FOR i_ IN 1 .. view_ref_.key_count_ LOOP
      IF view_ref_.key_count_ > 1 AND i_ > 1 THEN
         select_ := select_ || '''^';
      ELSE
         select_ := select_ || '''';
      END IF;

      select_ := select_ || sorted_keys_(i_);
      select_ := select_ || '=''||';
         --TODO: This code does not yet handle the case of one key being a date
         --IF view_ref_.key_names_(i_) is a DATE type THEN
         --   select_ := select_||'to_char(';
         --   select_ := select_||view_ref_.key_names_(i_);
         --   select_ := select_||',''YYYY-MM-DD-HH24.MI.SS'')';
         --ELSE
         --   select_ := select_||view_ref_.key_names_(i_);
         --END IF;
      select_ := select_ || sorted_keys_(i_);
      IF view_ref_.key_count_ > 1 THEN
         select_ := select_ || '||';
      ELSE
         select_ := select_ || '||''^''';
      END IF;
      IF view_ref_.key_count_ = i_ AND  view_ref_.key_count_ > 1 THEN
         select_ := select_ || '''^''';
      END IF;
   END LOOP;     
   
   Odata_Provider_Metadata_SYS.Set_Name(attribute_, 'keyref');
   Odata_Provider_Metadata_SYS.Set_Data_Type(attribute_, 'Text');
   Odata_Provider_Metadata_SYS.Set_Size(attribute_, 4000);
   Odata_Provider_Metadata_SYS.Set_Collection(attribute_, FALSE);
   Odata_Provider_Metadata_SYS.Set_Nullable(attribute_, TRUE);
   Odata_Provider_Metadata_SYS.Set_Updatable(attribute_, FALSE);
   Odata_Provider_Metadata_SYS.Set_Select(sql_, select_);
   Odata_Provider_Metadata_SYS.Set_Implementation_Type(sql_, 'VARCHAR2');
   Odata_Provider_Metadata_SYS.Set_Alias(sql_, 'keyref');
   Odata_Provider_Metadata_SYS.Set_S_Q_L(execute_, sql_);
   Odata_Provider_Metadata_SYS.Set_Execute(attribute_, execute_);
   Odata_Provider_Metadata_SYS.Add_Attributes(entity_, attribute_);
END Add_Keyref_Attribute___;


PROCEDURE Add_Entity_Attribute___ (
   entity_     IN OUT Odata_Provider_Metadata_SYS.Entity_Rec,
   col_name_   IN VARCHAR2,
   col_type_   IN VARCHAR2,
   view_name_  IN VARCHAR2 DEFAULT NULL)
IS
   attribute_ Odata_Provider_Metadata_SYS.Attribute_Rec;
   execute_   Odata_Provider_Metadata_SYS.AttributeExecute_Rec;
   sql_       Odata_Provider_Metadata_SYS.AttributeExecuteSQL_Rec;
   size_      VARCHAR2(100) := Get_Size___(col_type_);
   is_custom_view_  BOOLEAN;
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      is_custom_view_ := Custom_Lus_API.Is_Custom_View(view_name_);
   $ELSE
      is_custom_view_ := FALSE;
   $END   

   IF is_custom_view_ THEN
      Odata_Provider_Metadata_SYS.Set_Name(attribute_, REPLACE(initcap(col_name_), '$'));
   ELSE
      Odata_Provider_Metadata_SYS.Set_Name(attribute_, To_Mixed_Case___(col_name_));
   END IF;
   
   Odata_Provider_Metadata_SYS.Set_Data_Type(attribute_, To_Marble_Datatype___(col_type_));
   IF (size_ IS NOT NULL) THEN
      Odata_Provider_Metadata_SYS.Set_Size(attribute_, size_);
   END IF;
   Odata_Provider_Metadata_SYS.Set_Collection(attribute_, FALSE);
   Odata_Provider_Metadata_SYS.Set_Nullable(attribute_, TRUE);
   Odata_Provider_Metadata_SYS.Set_Updatable(attribute_, FALSE);
   Odata_Provider_Metadata_SYS.Set_Attr_Name(attribute_, col_name_);
   Odata_Provider_Metadata_SYS.Set_Keygeneration(attribute_, 'User');
   Odata_Provider_Metadata_SYS.Set_Select(sql_, lower(col_name_));
   Odata_Provider_Metadata_SYS.Set_Implementation_Type(sql_, To_Sql_Datatype___(col_type_));
   Odata_Provider_Metadata_SYS.Set_Alias(sql_, lower(col_name_));
   Odata_Provider_Metadata_SYS.Set_S_Q_L(execute_, sql_);
   Odata_Provider_Metadata_SYS.Set_Execute(attribute_, execute_);
   Odata_Provider_Metadata_SYS.Add_Attributes(entity_, attribute_);
END Add_Entity_Attribute___;


FUNCTION Get_Navigation_Metadata_(
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_       CLOB;
   ctrl_       Control_Rec;
   view_id_    VARCHAR2(1000);
   view_ref_   View_Reference_Rec;
   view_names_ DBMS_UTILITY.UNCL_ARRAY;
   count_      NUMBER := 1;
BEGIN
   ctrl_ := Parse_Control_String___(control_);
   view_id_ := ctrl_.views_.FIRST;
   <<viewloop>>
   WHILE view_id_ IS NOT NULL LOOP
      IF Is_View_Exist___(ctrl_,view_id_,count_,view_names_) THEN
           CONTINUE viewloop;
      END IF;
      view_ref_ := ctrl_.views_(view_id_);
      IF (view_id_ != ctrl_.views_.FIRST) THEN
         Append_Clob___(json_, ',');
      END IF;
      DECLARE
         navigation_   Odata_Provider_Metadata_SYS.Navigation_Rec;
         key_mapping_  Odata_Provider_Metadata_SYS.KeyMapping_Rec;
         parent_col_   VARCHAR2(100);
         parent_attr_  VARCHAR2(100);
         child_attr_   VARCHAR2(100);
         where_clause_ VARCHAR2(2000);
         attr_id_      VARCHAR2(1000);
      BEGIN
         Odata_Provider_Metadata_SYS.Set_Name(navigation_, view_ref_.navigate_);
         Odata_Provider_Metadata_SYS.Set_Collection(navigation_, FALSE);
         Odata_Provider_Metadata_SYS.Set_Target(navigation_, view_ref_.entity_);
         parent_attr_ := To_Mixed_Case___(ctrl_.ref_column_);
         parent_col_  := ctrl_.ref_column_;
         IF (parent_attr_ IS NULL) THEN
            --Temporary workaround, only one key supported
            parent_attr_ := substr(view_ref_.navigate_, instr(view_ref_.navigate_,'_')+1, instr(view_ref_.navigate_,'_',1,2)-instr(view_ref_.navigate_,'_')-1);
            attr_id_ := ctrl_.attributes_.first;
            WHILE attr_id_ IS NOT NULL LOOP
               IF (ctrl_.attributes_(attr_id_).name_ = parent_attr_) THEN
                  parent_col_ := ctrl_.attributes_(attr_id_).col_name_;
               END IF;
               attr_id_ := ctrl_.attributes_.next(attr_id_);
            END LOOP;
         END IF;
         IF (view_ref_.use_keyref_) THEN
            child_attr_  := 'keyref';
         ELSE
            child_attr_  := To_Mixed_Case___(view_ref_.key_names_(view_ref_.key_count_));
         END IF;
         Odata_Provider_Metadata_SYS.Set_This_Attribute(key_mapping_, parent_attr_);
         Odata_Provider_Metadata_SYS.Add_Parent_Attributes(navigation_, parent_attr_);
         Odata_Provider_Metadata_SYS.Set_Target_Attribute(key_mapping_, child_attr_);
         Odata_Provider_Metadata_SYS.Add_Child_Attributes(navigation_, child_attr_);
         Odata_Provider_Metadata_SYS.Add_Keys(navigation_, key_mapping_);
         where_clause_ := where_clause_||'(';
         IF (view_ref_.use_keyref_) THEN
            where_clause_ := where_clause_||':parent.'||lower(parent_col_)||' = :child.'||'keyref';
         ELSE
            where_clause_ := where_clause_||':parent.'||lower(parent_col_)||' = :child.'||lower(view_ref_.key_names_(view_ref_.key_count_));
         END IF;
         where_clause_ := where_clause_||')';
         Odata_Provider_Metadata_SYS.Set_Where(navigation_, where_clause_);
         Append_Clob___(json_, Odata_Provider_Metadata_SYS.Build(navigation_));
      END;
      view_id_ := ctrl_.views_.next(view_id_);
   END LOOP;
   RETURN json_;
END Get_Navigation_Metadata_;


FUNCTION Get_Attributes_Metadata_ (
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_    CLOB;
   ctrl_    Control_Rec;
   attr_    Attribute_Rec;     
BEGIN
   ctrl_ := Parse_Control_String___(control_);
   IF (ctrl_.attributes_.count = 0) THEN
      RETURN json_;
   END IF;
   
   FOR attr_no_ IN ctrl_.attributes_.first .. ctrl_.attributes_.last LOOP
      attr_    := ctrl_.attributes_(attr_no_);
      DECLARE
         attribute_ Odata_Provider_Metadata_SYS.Attribute_Rec;
         execute_   Odata_Provider_Metadata_SYS.AttributeExecute_Rec;
         sql_       Odata_Provider_Metadata_SYS.AttributeExecuteSQL_Rec;
      BEGIN
         Odata_Provider_Metadata_SYS.Set_Name(attribute_, attr_.name_);
         IF (attr_.enumerate_ IS NOT NULL) THEN
            Odata_Provider_Metadata_SYS.Set_Data_Type(attribute_, 'Enumeration');
            Odata_Provider_Metadata_SYS.Set_Sub_Type(attribute_, attr_.name_||'Enum');
         ELSE
            Odata_Provider_Metadata_SYS.Set_Data_Type(attribute_, attr_.type_);
         END IF;
         IF (attr_.size_ IS NOT NULL) THEN
            Odata_Provider_Metadata_SYS.Set_Size(attribute_, attr_.size_);
         END IF;
         Odata_Provider_Metadata_SYS.Set_Collection(attribute_, FALSE);
         Odata_Provider_Metadata_SYS.Set_Nullable(attribute_, TRUE);
         Odata_Provider_Metadata_SYS.Set_Updatable(attribute_, TRUE);
         Odata_Provider_Metadata_SYS.Set_Attr_Name(attribute_, attr_.col_name_);
         Odata_Provider_Metadata_SYS.Set_Keygeneration(attribute_, 'User');
         Odata_Provider_Metadata_SYS.Set_Select(sql_, attr_.select_);
         Odata_Provider_Metadata_SYS.Set_Implementation_Type(sql_, attr_.sql_type_);
         Odata_Provider_Metadata_SYS.Set_Alias(sql_, lower(attr_.col_name_));
         Odata_Provider_Metadata_SYS.Set_S_Q_L(execute_, sql_);
         Odata_Provider_Metadata_SYS.Set_Execute(attribute_, execute_);
         IF (attr_no_ != ctrl_.attributes_.first) THEN
            Append_Clob___(json_, ',');
         END IF;
         Append_Clob___(json_, Odata_Provider_Metadata_SYS.Build(attribute_));
      END;
   END LOOP;
   RETURN json_;
END Get_Attributes_Metadata_;


FUNCTION Get_Enumerations_Metadata_ (
   control_ IN VARCHAR2 ) RETURN CLOB
IS
   json_    CLOB;
   ctrl_    Control_Rec;
   attr_    Attribute_Rec;     
BEGIN
   ctrl_ := Parse_Control_String___(control_);
   IF (ctrl_.attributes_.count = 0) THEN
      RETURN json_;
   END IF;
   
   FOR attr_no_ IN ctrl_.attributes_.first .. ctrl_.attributes_.last LOOP
      attr_    := ctrl_.attributes_(attr_no_);
      IF (attr_.enumerate_ IS NOT NULL) THEN
         DECLARE
            enumeration_   Odata_Provider_Metadata_SYS.Enumeration_Rec;
            client_values_ VARCHAR2(32000);
            client_value_  VARCHAR2(32000);
         BEGIN
            client_values_ := Fetch_Enum_Client_Values_(attr_.enumerate_);
            Odata_Provider_Metadata_SYS.Set_Name(enumeration_, attr_.name_||'Enum');
            FOR i_ IN 0 .. 1000 LOOP
               client_value_ := Domain_SYS.Get_Client_Value_(client_values_, i_);
               EXIT WHEN client_value_ IS NULL;
               DECLARE
                  value_ Odata_Provider_Metadata_SYS.Value_Rec;
               BEGIN
                  Odata_Provider_Metadata_SYS.Set_Identifier(value_, Get_Identifier___(i_));                                    
                  Odata_Provider_Metadata_SYS.Set_Db_Value(value_, Get_Db_Value___(i_));
                  Odata_Provider_Metadata_SYS.Add_Values(enumeration_, value_);
               END;
            END LOOP;
            IF (json_ IS NOT NULL) THEN
               Append_Clob___(json_, ',');
            END IF;
            Append_Clob___(json_, Odata_Provider_Metadata_SYS.Build(enumeration_));
         END;
      END IF;
   END LOOP;
   RETURN json_;
END Get_Enumerations_Metadata_;


FUNCTION Fetch_Enum_Client_Values_ (
   enum_method_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   result_        VARCHAR2(32000);
   client_values_ VARCHAR2(32000);
BEGIN
   @ApproveDynamicStatement(2021-06-14,rakuse)
   EXECUTE IMMEDIATE 'BEGIN ' || enum_method_name_ || '(:values); END;' USING OUT result_;
   
   client_values_ := REPLACE(result_, Client_SYS.field_separator_, '^');
   IF (SUBSTR(client_values_, LENGTH(client_values_), 1) = '^') THEN
      RETURN client_values_;
   END IF;
   RETURN CONCAT(client_values_, '^');
   
EXCEPTION
   WHEN OTHERS THEN
      RETURN 'N/A^';
END Fetch_Enum_Client_Values_;


FUNCTION Get_Item_ID___ (
   db_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (db_value_ < 'A') THEN
      RETURN 'Id'||db_value_;
   ELSE
      RETURN replace(replace(db_value_,'_',''),' ','_');
   END IF;
END Get_Item_ID___;


FUNCTION Get_Identifier___ (
   index_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN 'Id' || to_char(index_);
END Get_Identifier___;


FUNCTION Get_Db_Value___ (
   index_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN 'DB_' || to_char(index_);
END Get_Db_Value___;


-------------------- DATATYPE TO MARBLE TYPES ---------------------------

FUNCTION To_Marble_Datatype___ (
   full_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   main_type_ VARCHAR2(100) := UPPER(Get_Main_Entry___(full_type_));
BEGIN
   IF (main_type_ LIKE 'STRING%' OR
       main_type_ = 'REFERENCE') THEN
      RETURN 'Text';
   ELSIF (main_type_ = 'PERCENTAGE') THEN
      RETURN 'Number';
   ELSIF (main_type_ = 'DATE/DATE') THEN
      RETURN 'Date';
   ELSIF (main_type_ = 'DATE/TIME') THEN
      RETURN 'Time';
   ELSIF (main_type_ = 'DATE/DATETIME') THEN
      RETURN 'Timestamp';
   ELSIF (main_type_ LIKE '%/%') THEN
      RETURN To_Mixed_Case___(substr(main_type_, 1, instr(main_type_,'/')-1));
   ELSE
      RETURN To_Mixed_Case___(main_type_);
   END IF;
END To_Marble_Datatype___;


FUNCTION To_Sql_Datatype___ (
   full_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   main_type_ VARCHAR2(100) := UPPER(Get_Main_Entry___(full_type_));
BEGIN
   IF (main_type_ = 'STRING') THEN
      RETURN 'VARCHAR2';
   ELSIF (main_type_ = 'PERCENTAGE') THEN
      RETURN 'NUMBER';
   ELSIF (main_type_ = 'DATE/DATE') THEN
      RETURN 'DATE';
   ELSIF (main_type_ = 'DATE/TIME') THEN
      RETURN 'DATE';
   ELSIF (main_type_ = 'DATE/DATETIME') THEN
      RETURN 'DATE';
   ELSIF (main_type_ LIKE '%/%') THEN
      RETURN substr(main_type_, 1, instr(main_type_,'/')-1);
   ELSE
      RETURN main_type_;
   END IF;
END To_Sql_Datatype___;

-------------------- HELPER METHODS -------------------------------------

FUNCTION Link_Name___ (
   link_  IN VARCHAR2,
   delim_ IN VARCHAR2 DEFAULT ':') RETURN VARCHAR2
IS
BEGIN
   IF (instr(link_,delim_) > 0) THEN
      RETURN substr(link_, 1, instr(link_,delim_)-1);
   ELSE
      RETURN link_;
   END IF;
END Link_Name___;


FUNCTION Link_Value___ (
   link_  IN VARCHAR2,
   delim_ IN VARCHAR2 DEFAULT ':' ) RETURN VARCHAR2
IS
BEGIN
   IF (instr(link_,delim_) > 0) THEN
      RETURN substr(link_, instr(link_,delim_)+1);
   ELSE
      RETURN NULL;
   END IF;
END Link_Value___;


FUNCTION To_Mixed_Case___ (
   value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN replace(initcap(value_),'_','');
END To_Mixed_Case___;


FUNCTION Get_Main_Entry___(
   composite_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (composite_ LIKE '%(%') THEN
      RETURN substr(composite_,1,instr(composite_,'(')-1);
   ELSE
      RETURN composite_;
   END IF;
END Get_Main_Entry___;


FUNCTION Get_Arguments___(
   composite_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (composite_ LIKE '%(%') THEN
      RETURN substr(composite_,instr(composite_,'(')+1,instr(composite_,')')-instr(composite_,'(')-1);
   ELSE
      RETURN NULL;
   END IF;
END Get_Arguments___;


FUNCTION Get_Format___ (
   full_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
  IF (full_type_ LIKE 'STRING%/UPPERCASE') THEN
     RETURN 'uppercase';
  END IF;
  IF (full_type_ LIKE 'STRING%/LOWERCASE') THEN
     RETURN 'lowercase';
  END IF;

  RETURN '';
END Get_Format___;


FUNCTION Get_Size___(
   composite_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   --Ignore a lot of misformatted datatypes
   IF (composite_ LIKE '%("%') THEN
      RETURN NULL;
   ELSIF (composite_ LIKE '%(%/%)%') THEN
      RETURN NULL;
   ELSIF (composite_ LIKE '%(%,%)%') THEN
      RETURN substr(composite_,instr(composite_,'(')+1,instr(composite_,',')-instr(composite_,'(')-1);
   ELSIF (composite_ LIKE '%(%)%') THEN
      RETURN substr(composite_,instr(composite_,'(')+1,instr(composite_,')')-instr(composite_,'(')-1);
   ELSE
      RETURN NULL;
   END IF;
END Get_Size___;


PROCEDURE Append_Clob___ (
   clob_ IN OUT NOCOPY CLOB,
   text_ IN            VARCHAR2 )
IS
BEGIN
   IF (clob_ IS NULL AND text_ IS NOT NULL) THEN
      clob_ := to_clob(text_);
   ELSIF (text_ IS NOT NULL AND length(text_) > 0) THEN
      clob_ := clob_||to_clob(text_);
   END IF;
END Append_Clob___;


PROCEDURE Append_Clob___ (
   clob_ IN OUT NOCOPY CLOB,
   text_ IN            CLOB )
IS
BEGIN
   IF (clob_ IS NULL AND text_ IS NOT NULL) THEN
      clob_ := to_clob(text_);
   ELSIF (text_ IS NOT NULL AND length(text_) > 0) THEN
      clob_ := clob_||text_;
   END IF;
END Append_Clob___;


FUNCTION Get_Index_By_Name___ (
   list_  IN DBMS_UTILITY.UNCL_ARRAY,
   name_  IN VARCHAR2 ) RETURN INTEGER
IS
BEGIN
   FOR i_ IN 1 .. list_.count LOOP
      IF list_(i_) = name_ THEN  
         RETURN i_;
      END IF;              
   END LOOP;
   RETURN 0;
END Get_Index_By_Name___;


FUNCTION Contains___ (
   list_  IN DBMS_UTILITY.UNCL_ARRAY,
   name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   FOR i_ IN list_.first .. list_.last LOOP
      IF (name_ = list_(i_)) THEN
         RETURN TRUE;
      END IF;
   END LOOP;
   RETURN FALSE;
END Contains___;


FUNCTION Is_View_Exist___ (
   ctrl_       IN     Control_Rec,
   view_id_    IN OUT VARCHAR2,
   count_      IN OUT NUMBER,
   view_names_ IN OUT DBMS_UTILITY.UNCL_ARRAY) RETURN BOOLEAN
IS
BEGIN
   FOR j_ IN 1 .. view_names_.count LOOP
      IF instr(view_id_,'(') > 0 THEN
         IF view_names_(j_) = substr(view_id_,1,instr(view_id_,'(') -1) THEN  
            view_id_ := ctrl_.views_.next(view_id_); 
            RETURN TRUE;
         END IF;              
      ELSE
         IF view_names_(j_) = view_id_ THEN  
            view_id_ := ctrl_.views_.next(view_id_); 
            RETURN TRUE;
         END IF;
         
      END IF;
   END LOOP; 
   IF instr(view_id_,'(') > 0 THEN
      view_names_(count_) :=  substr(view_id_,1,instr(view_id_,'(') -1); 
   ELSE          
      view_names_(count_) :=  view_id_; 
   END IF;      
   count_ := count_ + 1;
   RETURN FALSE;
END Is_View_Exist___;


FUNCTION Is_List_View_Exist___ (
   ctrl_       IN     Control_List_Rec,
   view_id_    IN OUT VARCHAR2,
   count_      IN OUT NUMBER,
   view_names_ IN OUT DBMS_UTILITY.UNCL_ARRAY) RETURN BOOLEAN
IS
BEGIN
   FOR j_ IN 1 .. view_names_.count LOOP
      IF instr(view_id_,'(') > 0 THEN
         IF view_names_(j_) = substr(view_id_,1,instr(view_id_,'(') -1) THEN  
            view_id_ := ctrl_.views_.next(view_id_); 
            RETURN TRUE;
         END IF;              
      ELSE
         IF view_names_(j_) = view_id_ THEN  
            view_id_ := ctrl_.views_.next(view_id_); 
            RETURN TRUE;
         END IF;
         
      END IF;
   END LOOP; 
   IF instr(view_id_,'(') > 0 THEN
      view_names_(count_) :=  substr(view_id_,1,instr(view_id_,'(') -1); 
   ELSE          
      view_names_(count_) :=  view_id_; 
   END IF; 
   count_ := count_ + 1;
   RETURN FALSE;
END Is_List_View_Exist___;


PROCEDURE Break_Method_Name___ (
   control_       IN            VARCHAR2,
   index_         IN OUT NOCOPY NUMBER,
   current_index_ IN OUT NOCOPY NUMBER,  
   method_        IN OUT NOCOPY VARCHAR2)
IS
   index_temp_  NUMBER;
   method_list_ VARCHAR2(32000) := control_;         
BEGIN
   IF index_ = 0 THEN   
      IF current_index_ > 1 THEN
         method_list_ := substr(control_,current_index_);     
      ELSE
         method_list_ := control_;
      END IF;
      index_ := -1;
   ELSE           
      method_list_ := substr(control_,current_index_,index_- current_index_);
      current_index_ := index_ + 1;
   END IF;
   
   IF NOT index_ = -1 THEN        
      index_temp_ := instr(substr(control_,index_+length(':')),':');
      IF index_temp_ = 0 THEN
         index_ := 0;
      ELSE       
         index_ := index_ + index_temp_ ; 
      END IF;          
   END IF;
   method_ := method_list_;
END Break_Method_Name___;
