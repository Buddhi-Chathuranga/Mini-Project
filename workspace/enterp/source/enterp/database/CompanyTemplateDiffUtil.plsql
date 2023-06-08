-----------------------------------------------------------------------------
--
--  Logical unit: CompanyTemplateDiffUtil
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  040804  Thsrlk  LCS Merge (44196)
--  060127  GaDalk  B131841 changed t_data_rec.
--  130614  DipeLK  TIBE-726, Removed global variable which used to check exsistance of ACCRUL component
--  190417  Ajpelk  Bug 147536, Corrected
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE t_data_rec IS RECORD (
   company                   company_tab.company%TYPE,
   valid_from                DATE,
   source_company            company_tab.company%TYPE,
   source_template           VARCHAR2(30),
   old_source_template       VARCHAR2(30),
   temp_source_template      VARCHAR2(30),
   temp_target_template      VARCHAR2(30),
   diff_template             VARCHAR2(30),
   key_attr                  VARCHAR2(100),
   update_id                 VARCHAR2(30));

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_New_Id_And_Descr___ (
   new_template_id_ OUT VARCHAR2,
   new_description_ OUT VARCHAR2 )
IS
   new_id_   VARCHAR2(30);
BEGIN
   new_id_ := Create_Company_Tem_API.Get_Temporary_Id__;
   new_description_ := 'Temporary Difference Template';
   new_template_id_ := new_id_;
END Get_New_Id_And_Descr___;


PROCEDURE Unpack_Attr___ (
   rec_  OUT t_data_rec,
   attr_ IN  VARCHAR2 )
IS
   ptr_         NUMBER;
   name_        VARCHAR2(30);
   value_       VARCHAR2(2000);
BEGIN
   Trace_SYS.Message('UNPACK: '|| attr_);
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'COMPANY') THEN
         rec_.company := value_;
      ELSIF (name_ = 'VALID_FROM') THEN
         rec_.valid_from := TRUNC(Client_SYS.Attr_Value_To_Date(value_));
      ELSIF (name_ = 'SOURCE_COMPANY') THEN
         rec_.source_company := value_;
      ELSIF (name_ = 'SOURCE_TEMPLATE') THEN
         rec_.source_template := value_;
      ELSIF (name_ = 'OLD_SOURCE_TEMPLATE') THEN
         rec_.old_source_template := value_;
      ELSIF (name_ = 'TEMP_SOURCE_TEMPLATE') THEN
         rec_.temp_source_template := value_;
      ELSIF (name_ = 'TEMP_TARGET_TEMPLATE') THEN
         rec_.temp_target_template := value_;
      ELSIF (name_ = 'DIFF_TEMPLATE') THEN
         rec_.diff_template := value_;
      ELSIF (name_ = 'UPDATE_ID') THEN
         rec_.update_id := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   -- make sure that the valid form date for the company is set if not sent
   IF (rec_.company IS NOT NULL AND rec_.valid_from IS NULL) THEN
      $IF Component_Accrul_SYS.INSTALLED $THEN
         rec_.valid_from := Company_Finance_API.Get_Valid_From(rec_.company);
      $ELSE
         NULL;
      $END   
   END IF;
END Unpack_Attr___;


PROCEDURE Pack_Attr___ (
   attr_ IN OUT VARCHAR2,
   rec_  IN     t_data_rec )
IS
BEGIN
   attr_ := NULL;
   Client_SYS.Add_To_Attr('COMPANY',              rec_.company, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM',           rec_.valid_from, attr_);
   Client_SYS.Add_To_Attr('SOURCE_COMPANY',       rec_.source_company, attr_);
   Client_SYS.Add_To_Attr('SOURCE_TEMPLATE',      rec_.source_template, attr_);
   Client_SYS.Add_To_Attr('OLD_SOURCE_TEMPLATE',  rec_.old_source_template, attr_);
   Client_SYS.Add_To_Attr('TEMP_SOURCE_TEMPLATE', rec_.temp_source_template, attr_);
   Client_SYS.Add_To_Attr('TEMP_TARGET_TEMPLATE', rec_.temp_target_template, attr_);
   Client_SYS.Add_To_Attr('DIFF_TEMPLATE',        rec_.diff_template, attr_);
   Client_SYS.Add_To_Attr('UPDATE_ID',            rec_.update_id, attr_);
   Trace_SYS.Message('PACK: '|| rec_.source_company||'|'||rec_.source_template||
                            '|'|| rec_.old_source_template);
   Trace_SYS.Message(rec_.temp_source_template||'|'||rec_.temp_target_template||'|'||
                     rec_.diff_template||'|'|| rec_.update_id);
END Pack_Attr___;


PROCEDURE Remove_Template___ (
   template_id_ IN VARCHAR2 )
IS
BEGIN
   IF (template_id_ IS NOT NULL) THEN
      Create_Company_Tem_API.Remove_Template__(template_id_, FALSE);
   END IF;
END Remove_Template___;


PROCEDURE Remove_Template_Transl___ (
   template_id_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM key_lu_tab
      WHERE key_name   = 'TemplKeyLu'
      AND   key_value  = template_id_;
   DELETE FROM key_lu_translation_tab
      WHERE key_name   = 'TemplKeyLu'
      AND   key_value  = template_id_;
END  Remove_Template_Transl___;


PROCEDURE Call_Make_Company___ (
   pkg_name_  IN VARCHAR2,
   proc_name_ IN VARCHAR2,
   attr_      IN VARCHAR2 )
IS
   stmt_        VARCHAR2(2000);
   bindinpar_   VARCHAR2(2000) := attr_;
BEGIN
   Assert_SYS.Assert_Is_Package_Method(pkg_name_,proc_name_);
   stmt_ := 'BEGIN ' || pkg_name_ || '.' || proc_name_ || '(:bindinpar_); END;';
   @ApproveDynamicStatement(2005-11-10,ovjose)
   EXECUTE IMMEDIATE stmt_ USING bindinpar_;
END Call_Make_Company___;


PROCEDURE Copy_Template___ (
   new_template_id_    OUT VARCHAR2,
   source_template_id_ IN  VARCHAR2 )
IS
   new_id_     VARCHAR2(30);
   new_descr_  VARCHAR2(50);
BEGIN
   IF (source_template_id_ IS NULL) THEN
      Error_SYS.Appl_General(lu_name_, 'NOTEMPLFORCOPY: Cannot copy template. Source template is not supplied');
   END IF;
   Get_New_Id_And_Descr___(new_id_, new_descr_);
   Create_Company_Tem_API.Copy_Template__(source_template_id_, new_id_, new_descr_);
   -- Set template as STANDARD template to avoid user access during this process
   new_template_id_ := new_id_;
   -- Now make sure that only active logical units are represented in the copy
   -- Active components/LU are found via view Crecomp_Component_Process
   DELETE FROM create_company_tem_comp_tab
      WHERE  template_id = new_id_
      AND    component NOT IN (SELECT DISTINCT module
                               FROM   crecomp_component_process);
   DELETE FROM create_company_tem_lu_tab c1
      WHERE template_id = new_id_
      AND   (component, lu) NOT IN (SELECT module, lu
                                    FROM   crecomp_component_process c2
                                    WHERE  c2.module = c1.component
                                    AND    c2.lu     = c1.lu);
   DELETE FROM create_company_tem_detail_tab c1
      WHERE  template_id = new_id_
      AND    (component, lu) NOT IN (SELECT module, lu
                                     FROM   crecomp_component_process c2
                                     WHERE  c2.module = c1.component
                                     AND    c2.lu     = c1.lu);
   -- remove all created translations
   Remove_Template_Transl___(new_template_id_);
END Copy_Template___;


PROCEDURE Mod_Key_Date___ (
   rec_ IN OUT t_data_rec )
IS
   exist_in_template_  BOOLEAN;
   mc_attr_            VARCHAR2(200);
   mc_attr2_           VARCHAR2(200);
   CURSOR get_lu_process IS
      SELECT *
      FROM   crecomp_component_process;
BEGIN
   -- Build attribute string with values for Make_Company, modify key date
   Build_Make_Company_Attr___(mc_attr_, rec_);
   -- Start loop of components and LU:s according to Registration settings
   FOR lu_rec_ IN get_lu_process LOOP
      -- If Lu exists in source template then continue
      exist_in_template_ := Lu_Exist_In_Template___(rec_.temp_source_template,
                                                    lu_rec_.module,
                                                    lu_rec_.lu);
      IF (exist_in_template_) THEN
         -- Perform dynamic call to Make_Company method in each LU that handles modification
         -- of dates being part of the key
         mc_attr2_ := mc_attr_;
         Call_Make_Company___(lu_rec_.package, 'MAKE_COMPANY', mc_attr2_);
      END IF;
   END LOOP;
END Mod_Key_Date___;


PROCEDURE Create_Temp_Template___ (
   new_template_id_ OUT VARCHAR2,
   company_         IN  VARCHAR2 )
IS
   attr_        VARCHAR2(500);
   new_id_      VARCHAR2(30);
   new_descr_   VARCHAR2(50);
BEGIN
   IF (company_ IS NULL ) THEN
      Error_SYS.Appl_General(lu_name_, 'NOCOMPANYFORCRE: Cannot create a new template. No company supplied');
   END IF;
   attr_ := NULL;
   Get_New_Id_And_Descr___(new_id_, new_descr_);
   Client_SYS.Add_To_Attr('TEMPLATE_ID', new_id_, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', new_descr_, attr_);
   Client_SYS.Add_To_Attr('METHOD_TYPE', Method_TYPE_API.Decode('OVERWRITE'), attr_);
   Client_SYS.Add_To_Attr('MAKE_COMPANY', 'EXPORT', attr_);
   Client_SYS.Add_To_Attr('USER_TEMPLATE_ID', '', attr_);
   Company_API.Prepare_Export_Company__(company_, attr_);
   -- Set template as STANDARD template to avoid user access during this process
   new_template_id_ := new_id_;
   -- remove all created transations
   Remove_Template_Transl___(new_template_id_);
END  Create_Temp_Template___;


FUNCTION Lu_Exist_In_Template___ (
   template_id_ IN VARCHAR2,
   module_      IN VARCHAR2,
   lu_          IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   Create_Company_Tem_Lu_API.Exist(template_id_,module_,lu_);
   RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN FALSE;
END Lu_Exist_In_Template___;


PROCEDURE Get_Key_Attr___ (
   key_attr_ OUT VARCHAR2,
   module_   IN  VARCHAR2,
   lu_       IN  VARCHAR2 )
IS
   suffix_attr_        VARCHAR2(100);
   value_attr_         VARCHAR2(100);
   bdum_               BOOLEAN;
   srec_               crecomp_special_lu_tab%ROWTYPE;
   CURSOR get_special_lu IS
      SELECT *
      FROM   crecomp_special_lu_tab
      WHERE  lu     = lu_
      AND    type   = 'DIFF';
BEGIN
   -- try to find lu among special lu:s, else use basic create company reg data
   OPEN get_special_lu;
   FETCH  get_special_lu INTO srec_;
   IF (get_special_lu%FOUND) THEN
      key_attr_ := srec_.type_data;
   ELSE
      bdum_ := Crecomp_Component_API.Get_Translation_Reg_Info__(key_attr_, suffix_attr_, value_attr_, module_, lu_);
   END IF;
   CLOSE get_special_lu;
END Get_Key_Attr___;


PROCEDURE Process_Diff___ (
   rec_ IN OUT t_data_rec )
IS
   exist_in_source_    BOOLEAN;
   key_attr_           VARCHAR2(50);
   CURSOR get_lu_process IS
      SELECT *
      FROM   crecomp_component_process;
BEGIN
   -- Start loop of components and LU:s according to Registration settings
   FOR lu_rec_ IN get_lu_process LOOP
      -- If Lu exists in Source template then continue
      exist_in_source_ := Lu_Exist_In_Template___(rec_.temp_source_template, lu_rec_.module, lu_rec_.lu);
      IF (exist_in_source_) THEN
         Get_Key_Attr___(key_attr_, lu_rec_.module, lu_rec_.lu);
         rec_.key_attr := key_attr_;
         Generate_Lu_Diff___(rec_, lu_rec_.module, lu_rec_.lu);
      END IF;
   END LOOP;
END Process_Diff___;


PROCEDURE Build_Key_String___ (
   key_str_  OUT VARCHAR2,
   key_attr_ IN  VARCHAR2,
   alias_    IN  VARCHAR2,
   replace_  IN  BOOLEAN )
IS
   -- Builds the key string as the string "<alias>.<column>||'~'||<alias>.<column>||'~'||..."
   -- E.g. 'T1.C1||~||T1.C2||~'
   -- IF replace_ is TRUE then a replace statement will be added that replaces <FNDUSER> with the current user.
   -- This since the templates value <FNDUSER> is replaced during company creation and should therefore not be diff
   -- when comparing the company and the template.
   --
   i1_               PLS_INTEGER  := 1;
   i2_               PLS_INTEGER  := 0;
   s1_               VARCHAR2(10) := alias_ || '.';
   l_                PLS_INTEGER  := LENGTH(key_attr_);
   replace_string1_  VARCHAR2(15);
   replace_string2_  VARCHAR2(50);
BEGIN
   IF (replace_) THEN
      replace_string1_  := 'REPLACE(';
      replace_string2_  := ',''<FNDUSER>'', ''' || Fnd_Session_API.Get_Fnd_User||''')';
   END IF;
   IF (key_attr_ IS NULL) THEN
      Error_SYS.Appl_General(lu_name_, 'NULLKEYATTR: Internal error. The key attribute string is empty');
   END IF;
   i2_ := INSTR(key_attr_, '^');
   WHILE (i2_ != 0) LOOP
      IF (key_str_ IS NOT NULL) THEN
         key_str_ := key_str_ || '||';
      END IF;
      key_str_ := key_str_ || replace_string1_ ||s1_ || SUBSTR(key_attr_, i1_, i2_-i1_) || replace_string2_ || '||''~''';
      i1_ := i2_ + 1;
      i2_ := INSTR(key_attr_, '^', i1_);
   END LOOP;
   IF (i1_ <= l_) THEN
      IF (key_str_ IS NOT NULL) THEN
         key_str_ := key_str_ || '||';
      END IF;
      i2_ := l_;
      key_str_ := key_str_ || replace_string1_ || s1_ || SUBSTR(key_attr_, i1_, i2_-i1_+1) || replace_string2_ || '||''~''';
   END IF;
END Build_Key_String___;


PROCEDURE Generate_Lu_Diff___ (
   rec_    IN OUT t_data_rec,
   module_ IN     VARCHAR2,
   lu_     IN     VARCHAR2 )
IS
   diff_template_id_   VARCHAR2(30);   
   key_str_source_     VARCHAR2(2000);
   key_str_target_     VARCHAR2(2000);
   type RecordType     IS REF CURSOR; -- RETURN create_company_tem_detail_tab%ROWTYPE;
   get_details_        RecordType;
   detail_rec_         create_company_tem_detail_tab%ROWTYPE;
   levels_created_     BOOLEAN := FALSE;
   stmt_               VARCHAR2(2000) :=
      'SELECT * FROM create_company_tem_detail_tab t1 ' ||
      'WHERE template_id = :temp_source_template_ ' ||
      'AND component     = :module_ ' ||
      'AND lu            = :lu_ ' ||
      'AND NOT EXISTS ( ' ||
      'SELECT 1 ' ||
      'FROM create_company_tem_detail_tab t2 ' ||
      'WHERE t2.template_id = :temp_target_template_ ' ||
      'AND t2.component     = t1.component ' ||
      'AND t2.lu            = t1.lu ';
   stmt2_              VARCHAR2(100) :=
      'AND <TARGET_KEY>     = <SOURCE_KEY> )';
BEGIN
   Assert_SYS.Assert_Is_Logical_Unit(lu_);
   -- replace key words in the statement with values
   IF (rec_.key_attr IS NOT NULL) THEN
      -- Build complete statement, build key string for source and target template parts in select
      -- and replace values in statement
      stmt_ := stmt_ || stmt2_;
      Build_Key_String___(key_str_source_, rec_.key_attr, 'T1', TRUE);
      Build_Key_String___(key_str_target_, rec_.key_attr, 'T2', FALSE);
      stmt_ := REPLACE(stmt_, '<TARGET_KEY>', key_str_target_);
      stmt_ := REPLACE(stmt_, '<SOURCE_KEY>', key_str_source_);
   ELSE
      stmt_ := stmt_ || ')';
   END IF;
   -- print statement
   Print_Stmt___(stmt_);
   -- open cursor
   @ApproveDynamicStatement(2006-01-30,jeguse)
   OPEN  get_details_ FOR stmt_ USING rec_.temp_source_template,module_,lu_,rec_.temp_target_template;
   FETCH get_details_ INTO detail_rec_;
   WHILE get_details_%FOUND LOOP
      -- a detail found, create diff template if not yet performed
      IF (rec_.diff_template IS NULL) THEN
         Create_Template_Head___(diff_template_id_, rec_.temp_source_template);
         rec_.diff_template := diff_template_id_;
         Trace_SYS.Message('Diff template ' || diff_template_id_ || ' created');
      END IF;
      -- if not component and lu level in template structure has been created then create them
      IF (NOT levels_created_) THEN
         Create_Template_Comp_Lu___(rec_.diff_template, module_, lu_, rec_.temp_source_template);
         levels_created_ := TRUE;
      END IF;
      detail_rec_.template_id := rec_.diff_template;
      -- save template detail values
      Create_Company_Tem_Detail_API.Insert_New_Data__(detail_rec_);
      FETCH get_details_ INTO detail_rec_;
   END LOOP;
   CLOSE get_details_;
END Generate_Lu_Diff___;


PROCEDURE Create_Template_Head___ (
   new_template_id_    OUT VARCHAR2,
   source_template_id_ IN  VARCHAR2 )
IS
   new_id_      VARCHAR2(30);
   new_descr_   VARCHAR2(50);
   fnd_user_    VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   Get_New_Id_And_Descr___(new_id_, new_descr_);
   INSERT INTO create_company_tem_tab
       (  template_id,
          description,
          default_template,
          template_type,
          method_type,
          valid,
          creation_date,
          created_by_user,
          rowversion)
   SELECT new_id_,
          new_descr_,
          'FALSE',
          'USERDEFINED',
          method_type,
          valid,
          SYSDATE,
          fnd_user_,
          SYSDATE
   FROM create_company_tem_tab
   WHERE template_id = source_template_id_;
   new_template_id_ := new_id_;
END Create_Template_Head___;


PROCEDURE Create_Template_Comp_Lu___ (
   template_id_        IN VARCHAR2,
   module_             IN VARCHAR2,
   lu_                 IN VARCHAR2,
   source_template_id_ IN VARCHAR2 )
IS
BEGIN
   BEGIN
      INSERT INTO create_company_tem_comp_tab
          (  template_id,
             component,
             version,
             rowversion)
      SELECT template_id_,
             component,
             version,
             SYSDATE
      FROM create_company_tem_comp_tab
      WHERE template_id = source_template_id_
      AND   component   = module_;
   EXCEPTION
      WHEN dup_val_on_index THEN
         NULL;
   END;
   INSERT INTO create_company_tem_lu_tab
       (  template_id,
          component,
          lu,
          rowversion)
   VALUES
       (  template_id_,
          module_,
          lu_,
          SYSDATE);
END Create_Template_Comp_Lu___;


PROCEDURE Print_Stmt___ (
   stmt_ IN VARCHAR2 )
IS
   n_   PLS_INTEGER;
   s1_  PLS_INTEGER;
   s2_  PLS_INTEGER;
   l_   PLS_INTEGER := LENGTH(stmt_);
BEGIN
   IF (Trace_SYS.Get_Main_Switch) THEN
      n_ := TRUNC((l_ - 1)/40) + 1;
      FOR i_ IN 1..n_ LOOP
         s1_ := (i_ - 1) * 40 + 1;
         s2_ := LEAST((s1_ + 39), l_) - s1_ + 1;
         Trace_SYS.Message(SUBSTR(stmt_, s1_, s2_));
      END LOOP;
   END IF;
END Print_Stmt___;


PROCEDURE Build_Make_Company_Attr___ (
   mc_attr_    OUT VARCHAR2,
   rec_     IN OUT t_data_rec )
IS
BEGIN
   mc_attr_ := NULL;
   Client_SYS.Add_To_Attr('MAKE_COMPANY', 'MODIFY_KEY_DATE', mc_attr_);
   Client_SYS.Add_To_Attr('TEMPLATE_ID',  rec_.temp_source_template, mc_attr_);
   Client_SYS.Add_To_Attr('COMPANY',  rec_.company, mc_attr_);
   Client_SYS.Add_To_Attr('VALID_FROM',   rec_.valid_from, mc_attr_);
   Client_SYS.Add_To_Attr('SOURCE_TEMPLATE', rec_.source_template, mc_attr_);
   Client_SYS.Add_To_Attr('SOURCE_COMPANY', rec_.source_company, mc_attr_);
   Trace_SYS.Message('Build MC Attr:'|| mc_attr_);
END Build_Make_Company_Attr___;
                                
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Return_Diff_Steps__ (
   step_msg_ OUT VARCHAR2,
   attr_     IN  VARCHAR2 )
IS
   step_text_   VARCHAR2(500);
   data_rec_    t_data_rec;
   sub_msg_     VARCHAR2(100);
   step_        VARCHAR2(5);
   i_           PLS_INTEGER := 0;
BEGIN
   Unpack_Attr___(data_rec_, attr_);
   -- Define name=DIFF_STEPS for header message
   step_msg_ := Message_SYS.Construct('DIFF_STEPS');
   -- STEP 1: Create temporary template via company
   i_ := i_ + 1;
   step_text_ := Language_SYS.Translate_Constant('CompanyTemplateDiffUtil', 'STEP1: Creating temporary template from company :P1...', NULL, data_rec_.company);
   sub_msg_ := Message_SYS.Construct('SUB_MSG');
   -- Add attributes STEP and STEP_TXT to sub message
   Message_SYS.Add_Attribute(sub_msg_, 'STEP', '1');
   Message_SYS.Add_Attribute(sub_msg_, 'STEP_TXT', step_text_);
   -- Add submessage to message
   Message_SYS.Add_Attribute(step_msg_, TO_CHAR(i_), sub_msg_);
   -- STEP 2
   i_ := i_ + 1;
   IF (data_rec_.source_company IS NOT NULL) THEN
      step_ := '2_1';
      step_text_ := Language_SYS.Translate_Constant('CompanyTemplateDiffUtil', 'STEP2_1: Creating temporary template from source company :P1...', NULL, data_rec_.source_company);
   ELSE
      step_ := '2_2';
      step_text_ := Language_SYS.Translate_Constant('CompanyTemplateDiffUtil', 'STEP2_2: Copying source template :P1...', NULL, data_rec_.source_template);
   END IF;
   sub_msg_ := NULL;
   sub_msg_ := Message_SYS.Construct('SUB_MSG');
   -- Add attributes STEP and STEP_TXT to sub message
   Message_SYS.Add_Attribute(sub_msg_, 'STEP', step_);
   Message_SYS.Add_Attribute(sub_msg_, 'STEP_TXT', step_text_);
   -- Add submessage to message
   Message_SYS.Add_Attribute(step_msg_, TO_CHAR(i_), sub_msg_);
   -- STEP 3
   i_ := i_ + 1;
   step_ := '3';
   step_text_ := Language_SYS.Translate_Constant('CompanyTemplateDiffUtil', 'STEP3: Creating template differences...', NULL, data_rec_.source_company);
   sub_msg_ := NULL;
   sub_msg_ := Message_SYS.Construct('SUB_MSG');
   -- Add attributes STEP and STEP_TXT to sub message
   Message_SYS.Add_Attribute(sub_msg_, 'STEP', step_);
   Message_SYS.Add_Attribute(sub_msg_, 'STEP_TXT', step_text_);
   -- Add submessage to message
   Message_SYS.Add_Attribute(step_msg_, TO_CHAR(i_), sub_msg_);
END Return_Diff_Steps__;


PROCEDURE Generate_Diff_Template__ (
   attr_ IN OUT VARCHAR2,
   step_ IN     VARCHAR2 )
IS
   data_rec_       t_data_rec;
   temp_template_  VARCHAR2(30);
BEGIN
   Unpack_Attr___(data_rec_, attr_);
   IF (step_ = '1') THEN
   -- STEP 1
   -- Create a temporary template from current company
      IF (data_rec_.company IS NULL) THEN
         Error_SYS.Appl_General(lu_name_, 'NOCOMPANY: Cannot create diff template.'|| 'Company to be updated is not supplied');
      END IF;
      -- only create target template if not yet created
      IF (data_rec_.temp_target_template IS NULL) THEN
         Create_Temp_Template___(temp_template_, data_rec_.company);
         data_rec_.temp_target_template := temp_template_;
         Trace_SYS.Message('Created target template '|| temp_template_ || ' from company '|| data_rec_.company);
      END IF;
      Client_SYS.Add_To_Attr('TEMP_TARGET_TEMPLATE', temp_template_, attr_);
   ELSIF (step_ = '2_1') THEN
   -- STEP 2_1
   -- Create a temporary template from the source company
      IF (data_rec_.source_company IS NULL) THEN
         Error_SYS.Appl_General(lu_name_, 'NOSOURCECOMPANY: Cannot create diff template.'|| 'Source company is not supplied');
      END IF;
      IF (data_rec_.source_template IS NOT NULL OR data_rec_.old_source_template IS NOT NULL) THEN
         Remove_Template___(data_rec_.temp_source_template);
         data_rec_.source_template      := NULL;
         data_rec_.old_source_template  := NULL;
         data_rec_.temp_source_template := NULL;
      END IF;
      -- only create source template if not yet created
      IF (data_rec_.temp_source_template IS NULL) THEN
         Create_Temp_Template___(temp_template_, data_rec_.source_company);
         data_rec_.temp_source_template := temp_template_;
         Trace_SYS.Message('Created source template '|| temp_template_ || ' from source company '|| data_rec_.source_company);
         -- modify key dates in appropriate Logical Units
         Mod_Key_Date___(data_rec_);
         Trace_SYS.Message('Key dates modified in template '||temp_template_);
      END IF;
   ELSIF (step_ = '2_2') THEN
   -- STEP 2_2
   -- The source is a template. Copy this template to a temporary one
      IF (data_rec_.source_template IS NULL) THEN
         Error_SYS.Appl_General(lu_name_, 'NOSOURCETEMPLATE: Cannot create diff template.'|| 'Source template is not supplied');
      END IF;
      IF (NVL(data_rec_.source_template,'~') != NVL(data_rec_.old_source_template,'~')) THEN
         Remove_Template___(data_rec_.temp_source_template);
         data_rec_.old_source_template  := data_rec_.source_template;
         data_rec_.temp_source_template := NULL;
      END IF;
      -- only copy template if not yet created
      IF (data_rec_.temp_source_template IS NULL) THEN
         Copy_Template___(temp_template_,  data_rec_.source_template);
         data_rec_.temp_source_template := temp_template_;
         Trace_SYS.Message('Created source template '|| temp_template_ || ' from source template '|| data_rec_.source_template);
         -- modify key dates in appropriate Logical Units
         Mod_Key_Date___(data_rec_);
         Trace_SYS.Message('Key dates modified in template '||temp_template_);
      END IF;
   ELSIF (step_ = '3') THEN
      NULL;
      -- STEP 3
      -- Create template differences. Remove diff template if existing.
      IF (data_rec_.diff_template IS NOT NULL) THEN
         Remove_Template___(data_rec_.diff_template);
         data_rec_.diff_template := NULL;
      END IF;
      Trace_SYS.Message('Now processing differences');
      Process_Diff___(data_rec_);
      -- always make sure that Lu UpdateCompanySelectLu has values initiated
      IF (data_rec_.update_id IS NULL) THEN
         Update_Company_Select_Lu_API.Initiate_Values__(data_rec_.update_id);
      END IF;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'INVSTEP: Invalid step :P1', step_);
   END IF;
   Pack_Attr___(attr_ , data_rec_);
END Generate_Diff_Template__;


PROCEDURE Remove_Temorary_Templats__ (
   attr_ IN VARCHAR2 )
IS
   data_rec_       t_data_rec;
BEGIN
   Unpack_Attr___(data_rec_, attr_);
   Remove_Template___(data_rec_.temp_target_template);
   Remove_Template___(data_rec_.temp_source_template);
   Remove_Template___(data_rec_.diff_template);
END Remove_Temorary_Templats__;
                                             
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


