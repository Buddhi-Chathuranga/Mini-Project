-----------------------------------------------------------------------------
--
--  Logical unit: ReplicationObjectDef
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000101  JhMa    Created.
--  000621  ROOD    Modified parameters in Check_Module___, Create_Export___ and Export__.
--  000628  ROOD    Changes in error handling.
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030702  ROOD    Used db-values in Create_Attribute_Group___ (Bug#38054).
--  040707  ROOD    Modified fndrpl_lu_names according to modified dictionary_sys (F1PR413).
--  040906  ROOD    Changed condition in fndrpl_lu_names to go for base views (F1PR413).
--  050105  ROOD    Modified condition in fndrpl_lu_names after review (F1PR413)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE TextTabType IS TABLE OF VARCHAR2(300)
   INDEX BY BINARY_INTEGER;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Add_Text___ (
   index_    IN OUT BINARY_INTEGER,
   text_tab_ IN OUT TextTabType,
   text_     IN VARCHAR2 )
IS
BEGIN
   index_ := index_ + 1;
   text_tab_(index_) := text_;
END Add_Text___;


PROCEDURE Create_Attribute_Group___ (
   newrec_     IN OUT REPLICATION_OBJECT_DEF_TAB%ROWTYPE )
IS
   attr_        VARCHAR2(2000);
   info_        VARCHAR2(2000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   name_list_   VARCHAR2(32000);
   value_list_  VARCHAR2(2000);
   separator_   VARCHAR2(1) := Client_SYS.text_separator_;
BEGIN
   Replication_Attr_Group_Def_API.New__(info_, objid_, objversion_, attr_, 'PREPARE');
   Client_SYS.Add_To_Attr('BUSINESS_OBJECT', newrec_.business_object, attr_);
   Client_SYS.Add_To_Attr('LU_NAME', newrec_.master_lu, attr_);
   Client_SYS.Add_To_Attr('MASTER_COMPONENT', newrec_.master_component, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', Dictionary_SYS.Get_Lu_Prompt_(newrec_.master_lu), attr_);
   Dictionary_SYS.Get_Logical_Unit_Keys_(name_list_, value_list_, newrec_.master_lu);
   IF ( INSTR(separator_ || name_list_, separator_ || 'CONTRACT' || separator_) > 0 ) THEN
      Client_SYS.Add_To_Attr('CONTEXT_DB', 'SITE', attr_);
      Client_SYS.Add_To_Attr('CONTEXT_KEY', 'CONTRACT', attr_);
   ELSIF ( INSTR(separator_ || name_list_, separator_ || 'COMPANY' || separator_) > 0 ) THEN
      Client_SYS.Add_To_Attr('CONTEXT_DB', 'COMPANY', attr_);
      Client_SYS.Add_To_Attr('CONTEXT_KEY', 'COMPANY', attr_);
   ELSIF ( INSTR(separator_ || name_list_, separator_ || 'COMPANY_ID' || separator_) > 0 ) THEN
      Client_SYS.Add_To_Attr('CONTEXT_DB', 'COMPANY', attr_);
      Client_SYS.Add_To_Attr('CONTEXT_KEY', 'COMPANY_ID', attr_);
   ELSIF ( INSTR(separator_ || name_list_, separator_ || 'COMPANY_NO' || separator_) > 0 ) THEN
      Client_SYS.Add_To_Attr('CONTEXT_DB', 'COMPANY', attr_);
      Client_SYS.Add_To_Attr('CONTEXT_KEY', 'COMPANY_NO', attr_);
   ELSE
      Client_SYS.Add_To_Attr('CONTEXT_DB', 'INSTANCE', attr_);
   END IF;
   Replication_Attr_Group_Def_API.New__(info_, objid_, objversion_, attr_, 'DO');
END Create_Attribute_Group___;


PROCEDURE Create_Export___ (
   index_           IN OUT BINARY_INTEGER,
   text_tab_        IN OUT TextTabType,
   business_object_ IN     VARCHAR2 )
IS
   CURSOR c_business_object (object_ replication_object_def_tab.business_object%TYPE) IS
      SELECT *
      FROM   replication_object_def_tab
      WHERE  business_object = object_;
   CURSOR c_attribute_group (object_ replication_object_def_tab.business_object%TYPE) IS
      SELECT *
      FROM   replication_attr_group_def_tab
      WHERE  business_object = object_
      ORDER BY business_object, lu_name;
   CURSOR c_attribute (object_ replication_object_def_tab.business_object%TYPE) IS
      SELECT *
      FROM   replication_attr_def_tab
      WHERE  business_object = object_
      ORDER BY business_object, lu_name, sequence_no;
BEGIN
   index_ := 0;
   Add_Text___(index_, text_tab_, '--');
   Add_Text___(index_, text_tab_, '-- Installation file for Replication Object configuration information');
   Add_Text___(index_, text_tab_, '--');
   Add_Text___(index_, text_tab_, '--     Replication Object = ' || business_object_);
   Add_Text___(index_, text_tab_, '-- ');
   Add_Text___(index_, text_tab_, '--     Created ' || TO_CHAR(sysdate,Client_SYS.Date_Format_));
   Add_Text___(index_, text_tab_, '--');
   Add_Text___(index_, text_tab_, ' ');
   Add_Text___(index_, text_tab_, 'DELETE FROM replication_attr_def_tab ');
   Add_Text___(index_, text_tab_, '       WHERE business_object = ' || CHR(39) || business_object_ || CHR(39) || ';');
   Add_Text___(index_, text_tab_, 'DELETE FROM replication_attr_group_def_tab ');
   Add_Text___(index_, text_tab_, '       WHERE business_object = ' || CHR(39) || business_object_ || CHR(39) || ';');
   Add_Text___(index_, text_tab_, 'DELETE FROM replication_object_def_tab ');
   Add_Text___(index_, text_tab_, '       WHERE business_object = ' || CHR(39) || business_object_ || CHR(39) || ';');
   Add_Text___(index_, text_tab_, 'COMMIT;');
   Add_Text___(index_, text_tab_, ' ');
   --
   Add_Text___(index_, text_tab_, 'DECLARE');
   Add_Text___(index_, text_tab_, '   PROCEDURE NewBusinessObject (');
   Add_Text___(index_, text_tab_, '      business_object_  IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      master_lu_        IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      master_component_ IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      new_modify_error_ IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      description_      IN VARCHAR2) IS');
   Add_Text___(index_, text_tab_, '   BEGIN');
   Add_Text___(index_, text_tab_, '      INSERT INTO replication_object_def_tab (business_object, master_lu, master_component,');
   Add_Text___(index_, text_tab_, '         new_modify_error, description, rowversion, last_cfg_time)');
   Add_Text___(index_, text_tab_, '      VALUES (business_object_, master_lu_,');
   Add_Text___(index_, text_tab_, '         master_component_, new_modify_error_,');
   Add_Text___(index_, text_tab_, '         description_, sysdate, sysdate);');
   Add_Text___(index_, text_tab_, '   END NewBusinessObject;');
   --
   Add_Text___(index_, text_tab_, '   PROCEDURE NewAttributeGroup (');
   Add_Text___(index_, text_tab_, '      business_object_  IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      lu_name_           IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      context_key_       IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      master_component_  IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      description_       IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      trigger_table_     IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      view_name_         IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      trigger_condition_ IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      context_           IN VARCHAR2) IS');
   Add_Text___(index_, text_tab_, '   BEGIN');
   Add_Text___(index_, text_tab_, '      INSERT INTO replication_attr_group_def_tab (business_object, lu_name,');
   Add_Text___(index_, text_tab_, '         context_key, master_component, description, trigger_table,');
   Add_Text___(index_, text_tab_, '         view_name, context, trigger_condition, rowversion)');
   Add_Text___(index_, text_tab_, '      VALUES (business_object_, lu_name_,');
   Add_Text___(index_, text_tab_, '         context_key_, master_component_, description_,');
   Add_Text___(index_, text_tab_, '         trigger_table_, view_name_, context_, trigger_condition_, sysdate);');
   Add_Text___(index_, text_tab_, '   END NewAttributeGroup;');
   --
   Add_Text___(index_, text_tab_, '   PROCEDURE NewAttribute (');
   Add_Text___(index_, text_tab_, '      business_object_  IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      lu_name_          IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      column_name_      IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      table_name_       IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      key_              IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      description_      IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      bo_key_name_      IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      on_new_           IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      on_modify_        IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      table_key_name_   IN VARCHAR2,');
   Add_Text___(index_, text_tab_, '      sequence_no_      IN NUMBER) IS');
   Add_Text___(index_, text_tab_, '   BEGIN');
   Add_Text___(index_, text_tab_, '      INSERT INTO replication_attr_def_tab (business_object, lu_name,');
   Add_Text___(index_, text_tab_, '         column_name, table_name, key, description, bo_key_name,');
   Add_Text___(index_, text_tab_, '         on_new, on_modify, sequence_no, table_key_name, rowversion)');
   Add_Text___(index_, text_tab_, '      VALUES (business_object_, lu_name_, column_name_,');
   Add_Text___(index_, text_tab_, '         table_name_, key_, description_, bo_key_name_,');
   Add_Text___(index_, text_tab_, '         on_new_, on_modify_, sequence_no_, table_key_name_, sysdate);');
   Add_Text___(index_, text_tab_, '   END NewAttribute;');
   Add_Text___(index_, text_tab_, 'BEGIN');
   --
   Add_Text___(index_, text_tab_, '-- Insert into REPLICATION_OBJECT_DEF_TAB');
   Add_Text___(index_, text_tab_, '-- --------------------------------------');
   Add_Text___(index_, text_tab_, ' ');
   FOR bo_rec_ IN c_business_object (business_object_) LOOP
      Add_Text___(index_, text_tab_, '   NewBusinessObject (' ||
         CHR(39) || bo_rec_.business_object  || CHR(39) || ',' ||
         CHR(39) || bo_rec_.master_lu        || CHR(39) || ',' ||
         CHR(39) || bo_rec_.master_component || CHR(39) || ',' ||
         CHR(39) || bo_rec_.new_modify_error || CHR(39) || ',');
      Add_Text___(index_, text_tab_, '      '   ||
         CHR(39) || bo_rec_.description      || CHR(39) || ');');
   END LOOP;
   Add_Text___(index_, text_tab_, ' ');
   Add_Text___(index_, text_tab_, '-- Insert into REPLICATION_ATTR_GROUP_DEF_TAB');
   Add_Text___(index_, text_tab_, '-- ------------------------------------------');
   Add_Text___(index_, text_tab_, ' ');
   FOR ag_rec_ IN c_attribute_group (business_object_) LOOP
      Add_Text___(index_, text_tab_, '   NewAttributeGroup (' ||
         CHR(39) || ag_rec_.business_object   || CHR(39) || ',' ||
         CHR(39) || ag_rec_.lu_name           || CHR(39) || ',' ||
         CHR(39) || ag_rec_.context_key       || CHR(39) || ',' ||
         CHR(39) || ag_rec_.master_component  || CHR(39) || ',');
      Add_Text___(index_, text_tab_, '      '   ||
         CHR(39) || ag_rec_.description       || CHR(39) || ',');
      Add_Text___(index_, text_tab_, '      '   ||
         CHR(39) || ag_rec_.trigger_table     || CHR(39) || ',' ||
         CHR(39) || ag_rec_.view_name         || CHR(39) || ',');
      Add_Text___(index_, text_tab_, '      '   ||
         CHR(39) || REPLACE(ag_rec_.trigger_condition,'''','''''') || CHR(39) || ',');
      Add_Text___(index_, text_tab_, '      '   ||
         CHR(39) || ag_rec_.context           || CHR(39) || ');');
   END LOOP;
   Add_Text___(index_, text_tab_, ' ');
   Add_Text___(index_, text_tab_, '-- Insert into REPLICATION_ATTR_DEF_TAB');
   Add_Text___(index_, text_tab_, '-- ------------------------------------');
   Add_Text___(index_, text_tab_, ' ');
   FOR a_rec_ IN c_attribute (business_object_) LOOP
      Add_Text___(index_, text_tab_, '   NewAttribute (' ||
         CHR(39) || a_rec_.business_object || CHR(39) || ',' ||
         CHR(39) || a_rec_.lu_name         || CHR(39) || ',' ||
         CHR(39) || a_rec_.column_name     || CHR(39) || ',');
      Add_Text___(index_, text_tab_, '      '   ||
         CHR(39) || a_rec_.table_name      || CHR(39) || ',' ||
         CHR(39) || a_rec_.key             || CHR(39) || ',');
      Add_Text___(index_, text_tab_, '      '   ||
         CHR(39) || a_rec_.description     || CHR(39) || ',');
      Add_Text___(index_, text_tab_, '      '   ||
         CHR(39) || a_rec_.bo_key_name     || CHR(39) || ',' ||
         CHR(39) || a_rec_.on_new          || CHR(39) || ',' ||
         CHR(39) || a_rec_.on_modify       || CHR(39) || ',' ||
         CHR(39) || a_rec_.table_key_name  || CHR(39) || ',' ||
         TO_CHAR(a_rec_.sequence_no)       || ');');
   END LOOP;
   Add_Text___(index_, text_tab_, 'END;');
   Add_Text___(index_, text_tab_, '/');
   Add_Text___(index_, text_tab_, 'COMMIT;');
   Add_Text___(index_, text_tab_, ' ');
END Create_Export___;


PROCEDURE Check_Module___ (
   lu_name_          IN VARCHAR2,
   master_component_ IN VARCHAR2 )
IS
   --SOLSETFW
   CURSOR cModule (module_ VARCHAR2,
                   lu_     VARCHAR2) IS
      SELECT 1
      FROM   dictionary_sys_active a
      WHERE  a.lu_name = lu_
      AND    a.module  = module_;
   dummy_        NUMBER;
   module_error_ EXCEPTION;
BEGIN
   OPEN cModule(master_component_, lu_name_);
   FETCH cModule INTO dummy_;
   IF ( cModule%NOTFOUND ) THEN
      CLOSE cModule;
      RAISE module_error_;
   END IF;
   CLOSE cModule;
EXCEPTION
   WHEN module_error_ THEN
      Error_SYS.Record_general(lu_name_,'MISMATCH: The logical unit :P1 and the master component :P2 mismatch.', lu_name_, master_component_);
END Check_Module___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REPLICATION_OBJECT_DEF_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Create_Attribute_Group___(newrec_); 
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT replication_object_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   newrec_.new_modify_error := 'FALSE';
   super(newrec_, indrec_, attr_);
   newrec_.business_object := UPPER(TRANSLATE(newrec_.business_object, ' ', '_'));
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     replication_object_def_tab%ROWTYPE,
   newrec_ IN OUT replication_object_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Check_Module___(newrec_.master_lu, newrec_.master_component);
END Check_Common___;

PROCEDURE Export___ (
   business_objects_ IN OUT   VARCHAR2,
   text_file_        OUT      CLOB,
   clob_output_      VARCHAR2 DEFAULT 'FALSE' )
IS
   text_out_         CLOB := NULL;
   text_line_        VARCHAR2(300);
   cr_               VARCHAR2(1)     := CHR(13);
   nl_               VARCHAR2(1)     := CHR(10);
   to_much_          EXCEPTION;
   text_tab_         TextTabType;
   index_            BINARY_INTEGER;
BEGIN
   IF ( business_objects_ IS NOT NULL ) THEN
      Create_Export___(index_, text_tab_, business_objects_);
      business_objects_ := NULL;
      index_ := 1;
      BEGIN
         LOOP
            text_line_ := text_tab_(index_);
            IF ( clob_output_ = 'FALSE' AND (LENGTH(text_out_) + LENGTH(text_line_)) > 31990 ) THEN
               RAISE to_much_;
            END IF;
            text_out_ := text_out_ || text_line_ || cr_ || nl_;
            index_    := index_ + 1;
         END LOOP;
      EXCEPTION
         WHEN to_much_ THEN
            business_objects_ := NULL;
            text_file_        := text_out_;
         WHEN no_data_found THEN
            business_objects_ := NULL;
            text_file_        := text_out_;
      END;
   END IF;
END Export___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Export__ (
   business_objects_ IN OUT NOCOPY VARCHAR2,
   text_file_        OUT    VARCHAR2 )
IS
BEGIN
   Export___(business_objects_, text_file_, 'FALSE' );
END Export__;

FUNCTION Export__ (
   business_objects_ IN OUT NOCOPY VARCHAR2) RETURN CLOB
IS
   clob_text_file_ CLOB := NULL;
BEGIN
   Export___(business_objects_, clob_text_file_, 'TRUE' );
   RETURN clob_text_file_;
END Export__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Set_Last_Cfg_Time_ (
   business_object_ IN VARCHAR2 )
IS
BEGIN
   UPDATE replication_object_def_tab
   SET    last_cfg_time = sysdate
   WHERE  business_object = business_object_;
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END Set_Last_Cfg_Time_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


