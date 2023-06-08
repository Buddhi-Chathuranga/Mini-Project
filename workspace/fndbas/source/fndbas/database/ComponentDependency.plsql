-----------------------------------------------------------------------------
--
--  Logical unit: ComponentDependency
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961227  ERFO  Created prototype in IFS/Server 2.0
--  970304  ERFO  Corections regarding global record references.
--  970725  ERFO  Replaced usage of obsolete method Utility_SYS.Get_User
--                with the new Fnd_Session_API.Get_Fnd_User (ToDo #1172).
--  971020  JOCA  Minor changes to support client dependencies
--  001211  ERFO  Get use of new view FND_TAB_COMMENTS (Bug#18169).
--  011126  ROOD  Get use of new view FND_COL_COMMENTS (Bug#26328).
--                Removed some calls to Get_Dependency_Sequence___.
--  020620  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030209  ROOD  Updated to new server templates (ToDo#4117).
--                Modified Get_Method_From_Text___.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030218  ROOD  Changed hardcoded FNDSER to FNDBAS (ToDo#4149).
--  030227  ROOD  Avoid crashes when generating dependency info (Bug#36111).
--  030319  ROOD  Replaced method Get_Method_From_Text___ with recursive method
--                Extract_Method_From_Text___ that find several occurances (Bug#36094).
--                Most parts of this bug correction was made by earlier changes
--                in Get_Method_From_Text.
--  040331  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  040928  ROOD  Used Dictionary etc. for performance improvements (F1PR413).
--  041108  HEJO  Added functionality for retreiving method dependency information.
--  041111  ROOD  Changed order of columns and other minor improvements.
--  050310  HAAR  Made more fault tolerant by making LU name 30 characters (F1PR480)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE struct IS RECORD ( method_ VARCHAR2(205), dependent_upon_ VARCHAR2(205), level_ NUMBER );

TYPE array_of_structs IS TABLE OF struct INDEX BY BINARY_INTEGER;

TYPE parameters IS RECORD (
	module_  VARCHAR2(10),
	lu_      VARCHAR2(30),
	pkg_     VARCHAR2(30),
	view_    VARCHAR2(30),
	methods_ NUMBER,
	dynamic_ NUMBER );


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Dependency_Sequence___ RETURN NUMBER
IS
   temp_ NUMBER;
BEGIN
   SELECT component_dependency_seq.nextval
      INTO temp_
      FROM dual;
   RETURN(temp_);
END Get_Dependency_Sequence___;


FUNCTION Get_Lu_Module___ (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(6);
   --SOLSETFW
   CURSOR get_module IS
      SELECT module
      FROM dictionary_sys_lu_active
      WHERE lu_name = lu_name_;
BEGIN
   OPEN get_module;
   FETCH get_module INTO temp_;
   CLOSE get_module;
   IF temp_ IS NULL THEN
      temp_ := 'Undef';
   END IF;
   RETURN temp_;
END Get_Lu_Module___;


FUNCTION Get_Ref_Lu___ (
   reference_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(2000) := reference_;
BEGIN
   IF (temp_ IS NULL) THEN
      Error_SYS.System_General('Internal error in method :P1.', 'Get_Ref_Lu___');
   END IF;
   IF (instr(temp_, '(') > 0) THEN
      temp_ := substr(temp_, 1, instr(temp_, '(') - 1);
   END IF;
   IF (instr(temp_, '/') > 0) THEN
      temp_ := substr(temp_, 1, instr(temp_, '/') - 1);
   END IF;
   RETURN substr(temp_, 1, 25);
END Get_Ref_Lu___;


FUNCTION Get_Dependency_Type___ (
   name_     IN VARCHAR2,
   type_     IN VARCHAR2,
   ref_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (type_ = 'VIEW') THEN
      IF (substr(name_, -4) = '_REP') THEN
         RETURN '5';
      ELSE
         RETURN '3';
      END IF;
   ELSIF (ref_type_ = 'PACKAGE') THEN
      RETURN '1';       -- May also be an IID-domain
   ELSIF (ref_type_ = 'VIEW') THEN
      RETURN '4';
   ELSIF (ref_type_ = 'TABLE') THEN
      RETURN '6';
   ELSE
      RETURN '14';
   END IF;
END Get_Dependency_Type___;


FUNCTION Convert_Component_Type___ (
   name_        IN VARCHAR2,
   oracle_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(2);
BEGIN
   IF (substr(name_, -4) = '_REP' AND oracle_type_ = 'VIEW') THEN
      temp_ := '8';
   ELSIF (substr(name_, -4) = '_RPI' AND oracle_type_ = 'PACKAGE BODY') THEN
      temp_ := '8';
   ELSIF (substr(name_, -4)  = '_RPT' AND oracle_type_ = 'TABLE') THEN
      temp_ := '9';
   ELSE
      IF (oracle_type_ = 'PACKAGE BODY') THEN
         temp_ := '5';
      ELSIF (oracle_type_ = 'VIEW') THEN
         temp_ := '2';
      ELSIF (oracle_type_ = 'PACKAGE') THEN
         temp_ := '4';
      ELSIF (oracle_type_ = 'TABLE') THEN
         temp_ := '1';
      ELSIF (oracle_type_ = 'SEQUENCE') THEN
         temp_ := '3';
      ELSE
         temp_ := '11';
      END IF;
   END IF;
   RETURN temp_;
END Convert_Component_Type___;


FUNCTION Extract_Method_From_Text___ (
   name_ IN VARCHAR2,
   line_ IN NUMBER ) RETURN VARCHAR2
IS
   method_ VARCHAR2(2000);

   CURSOR get_methods ( name_ VARCHAR2, line_ NUMBER ) IS
      SELECT text
      FROM user_source
      WHERE name = name_                  -- package name
      AND   type = 'PACKAGE BODY'         -- look in .apy's only
      AND   line < line_                  -- search backwards
      AND   (text LIKE '%PROCEDURE %' OR text LIKE '%FUNCTION %') -- to catch the methodname.
      ORDER BY name,line DESC;

   CURSOR get_cursed ( name_ VARCHAR2, line_ NUMBER ) IS
      SELECT text
      FROM user_source
      WHERE name = name_                  -- package name
      AND   type = 'PACKAGE BODY'         -- look in .apy's only
      AND   line <= line_                 -- search backwards
      AND   (text LIKE '%CURSOR %' OR text LIKE '%g_%' OR text LIKE '%gl_%')-- to catch the cursors name or Global.
      ORDER BY name,line DESC;

BEGIN
   -- Get from database
   OPEN get_methods(upper(name_), line_);
      FETCH get_methods INTO method_ ;
   CLOSE get_methods;
   IF ( method_ IS NULL ) THEN             -- if no method name found,
      OPEN get_cursed(upper(name_), line_);--look for cursor instead
         FETCH get_cursed INTO method_ ;
      CLOSE get_cursed;
      IF (instr(method_, 'g_') > 0 or instr(method_, 'gl_') > 0) THEN
         RETURN 'Global';
      ELSIF (method_ IS NULL) THEN
         RETURN 'Method not found';
      END IF;
   END IF;
   -- Remove unwanted chars from data
   method_ := ltrim(method_);             -- Removes spaces from beginning of method_
   method_ := substr(method_,instr(method_,' ')+1); -- Removes the method type (function/procedure) from method_
   IF (instr(method_, '(') > 0) THEN      -- removes the '(' from the method call.
      method_ := rtrim(substr(method_, 1, instr(method_, '(') - 1));
   END IF;
   -- Remove newline i.e. chr(10) if found
   IF instr(method_,chr(10)) > 0 THEN
      method_ := substr(method_, 1, instr(method_, chr( 10 )) - 1);
   END IF;
   IF instr(method_,'--') > 0 THEN
      RETURN 'Method not found';
   END IF;
   RETURN substr(method_,1,30);
END Extract_Method_From_Text___;


PROCEDURE Extract_Ref_Meth_From_Text___ (
   name_     IN  VARCHAR2,
   ref_name_ IN  VARCHAR2,
   text_     IN  VARCHAR2,
   line_     IN  NUMBER,
   newrec_   IN  COMPONENT_DEPENDENCY_TAB%ROWTYPE )
IS
   objid_     COMPONENT_DEPENDENCY.objid%TYPE;
   objv_      COMPONENT_DEPENDENCY.objversion%TYPE;
   temp_rec_  COMPONENT_DEPENDENCY_TAB%ROWTYPE := newrec_;

   index_     NUMBER;
   temp_      VARCHAR2(2000);
   temp_attr_ VARCHAR2(32000);
BEGIN
   index_ := instr(upper(text_), ref_name_||'.');
   IF (index_ IS NULL OR index_ = 0) THEN
      temp_ := 'Undefined';
   ELSE
      temp_ := substr(text_, index_ + length(ref_name_) + 1);

      -- Recursively call this method again if there are more occurances in the text
      IF instr(upper(temp_), ref_name_||'.') > 0 THEN
         Extract_Ref_Meth_From_Text___( name_, ref_name_, temp_, line_, newrec_);
      END IF;

      IF (instr(temp_, '(') > 0) THEN                             -- Procedures
         temp_ := rtrim(substr(temp_, 1, instr(temp_, '(') - 1));
      END IF;
      IF (instr(temp_, ',') > 0) THEN                             -- Function arguments
         temp_ := rtrim(substr(temp_, 1, instr(temp_, ',') - 1));
      END IF;
      IF (instr(temp_, '.') > 0) THEN                             -- Global record
         temp_ := rtrim(substr(temp_, 1, instr(temp_, '.') - 1));
      END IF;
      IF (instr(temp_, ';') > 0) THEN                             -- No parameters
         temp_ := rtrim(substr(temp_, 1, instr(temp_, ';') - 1));
      END IF;
      IF (instr(temp_, ')') > 0) THEN                             -- Type parameters
         temp_ := rtrim(substr(temp_, 1, instr(temp_, ')') - 1));
      END IF;
      IF (instr(temp_, 'THEN') > 0) THEN                          -- Boolean in IF-statement
         temp_ := rtrim(substr(temp_, 1, instr(temp_, 'THEN') - 1));
      END IF;

      -- A method can not be more than 30 characters
      temp_ := rtrim(substr(temp_, 1, 30));

      -- Remove rest of line and possible whitespaces before continuing
      IF instr(temp_, ' ') > 0 THEN
         temp_ := substr(temp_, 1, instr(temp_, ' ') - 1);
      END IF;
   END IF;

   BEGIN
      -- Insert the result
      temp_rec_.ref_method := temp_;
      temp_rec_.method := Extract_Method_From_Text___ ( name_, line_ );
      Insert___(objid_, objv_, temp_rec_, temp_attr_);
   EXCEPTION
   WHEN OTHERS THEN
      Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Error when trying to insert method: '||temp_);
      client_sys.attr_to_dbms_output(temp_attr_);
      RAISE;
   END;
END Extract_Ref_Meth_From_Text___;


PROCEDURE Parse_Oracle_Dependencies___ (param_ parameters)
IS
   lu_        VARCHAR2(30);
   mod_       VARCHAR2(6);
   objid_     COMPONENT_DEPENDENCY.objid%TYPE;
   objv_      COMPONENT_DEPENDENCY.objversion%TYPE;
   attr_      VARCHAR2(32000);
   newrec_    COMPONENT_DEPENDENCY_TAB%ROWTYPE;
   temp_rec_  COMPONENT_DEPENDENCY_TAB%ROWTYPE;
   appowner_  VARCHAR2(30) := Fnd_Session_API.Get_App_Owner;
   temp_type_ VARCHAR2(7);

   CURSOR get_all_dependencies (owner_ VARCHAR2) IS
      SELECT name, type, referenced_name ref_name, referenced_type ref_type
      FROM   user_dependencies
      WHERE  referenced_owner = owner_
      AND    referenced_type <> 'NON-EXISTENT'
      AND    name NOT LIKE '%_SYS'
      AND    referenced_name NOT LIKE '%_SYS'
      AND    name <> referenced_name;

   CURSOR get_some_dependencies (owner_ VARCHAR2) IS
      SELECT name, type, referenced_name ref_name, referenced_type ref_type
      FROM   user_dependencies
      WHERE  referenced_owner = owner_
      AND    referenced_type <> 'NON-EXISTENT'
      AND    name NOT LIKE '%_SYS'
      AND    referenced_name NOT LIKE '%_SYS'
      AND    name <> referenced_name
      AND    name LIKE decode(substr(type, 1, 7), 'PACKAGE', param_.pkg_, 'VIEW', param_.view_, name);

   CURSOR get_methods (name_ VARCHAR2, ref_name_ VARCHAR2) IS
      SELECT text, line
      FROM   user_source
      WHERE  type = 'PACKAGE BODY'
      AND    name = name_
      AND    upper(text) LIKE '%'||ref_name_||'%'
      AND    upper(text) NOT LIKE '%'||name_||'%';

   TYPE dependencies IS TABLE OF get_all_dependencies%ROWTYPE INDEX BY BINARY_INTEGER;
   rec_ dependencies;

BEGIN
   IF param_.pkg_ = '%' AND param_.view_ = '%' THEN
      OPEN get_all_dependencies(appowner_);
      FETCH get_all_dependencies BULK COLLECT INTO rec_;
      CLOSE get_all_dependencies;
   ELSE
      OPEN get_some_dependencies(appowner_);
      FETCH get_some_dependencies BULK COLLECT INTO rec_;
      CLOSE get_some_dependencies;
   END IF;

   IF rec_.first IS NOT NULL THEN
      FOR i_ IN rec_.FIRST..rec_.LAST LOOP
         temp_type_ := substr(rec_(i_).type, 1, 7);
         mod_ := Dictionary_SYS.Get_Component(rec_(i_).name, temp_type_);
         lu_  := Dictionary_SYS.Get_Logical_Unit(rec_(i_).name, temp_type_);
         --
         -- Load standard dependency
         --
         IF (lu_ LIKE param_.lu_) AND (mod_ LIKE param_.module_) THEN
            Client_SYS.Clear_Attr(attr_);
            newrec_.dependency_date := sysdate;
            newrec_.dependency_type := Get_Dependency_Type___(rec_(i_).name, rec_(i_).type, rec_(i_).ref_type);
            newrec_.object := rec_(i_).name;
            newrec_.object_type := Convert_Component_Type___(rec_(i_).name, rec_(i_).type);
            newrec_.module := mod_;
            newrec_.lu_name := lu_;
            newrec_.ref_object := rec_(i_).ref_name;
            newrec_.ref_object_type := Convert_Component_Type___(rec_(i_).ref_name, rec_(i_).ref_type);
            temp_type_ := substr(rec_(i_).ref_type, 1, 7);
            newrec_.ref_module := Dictionary_SYS.Get_Component(rec_(i_).ref_name, temp_type_);
            newrec_.ref_lu_name := Dictionary_SYS.Get_Logical_Unit(rec_(i_).ref_name, temp_type_);

            temp_rec_ := newrec_;
            Insert___(objid_, objv_, newrec_, attr_);
            --
            -- Load dependencies on method level
            --
            IF (param_.methods_ = 1 AND rec_(i_).type = 'PACKAGE BODY' AND rec_(i_).ref_type = 'PACKAGE') THEN
               newrec_ := temp_rec_;
               newrec_.dependency_type := '2';
               newrec_.ref_object_type := '6';
               -- Find the source code lines that contain the referenced object
               FOR met IN get_methods(rec_(i_).name, rec_(i_).ref_name) LOOP
                  -- Extract and insert the methods that are found in the source code lines
                  Extract_Ref_Meth_From_Text___( rec_(i_).name, rec_(i_).ref_name, met.text, met.line, newrec_ );
               END LOOP;
            END IF;
         END IF;
      END LOOP;
   END IF;
   --
   -- Empty the record to release memory
   --
   rec_.DELETE;
   --
   -- Update info with different approach depending on search criterias
   --
   IF param_.pkg_ = '%' THEN
      --
      -- Update info on IID domains (for all packages)
      --
      UPDATE component_dependency_tab
         SET   dependency_type = '7'
         WHERE dependency_type = '1'
         AND   ref_object IN (SELECT name
                              FROM   user_source
                              WHERE  type = 'PACKAGE'
                              AND    text LIKE 'domain_%:=%'
                              AND    line BETWEEN 3 AND 5)
         AND   module   LIKE param_.module_
         AND   lu_name_ LIKE param_.lu_;
      --
      -- Update info on table references acccording to name conventions (for all packages)
      --
      UPDATE component_dependency_tab
         SET   ref_lu_name = lu_name,
               ref_module  = module
         WHERE ref_object_type IN ('1','9')
         AND   ref_lu_name IS NULL
         AND   ref_module  IS NULL
         AND   (substr(ref_object, 1, length(ref_object) - 4) = object OR
                substr(ref_object, 1, length(ref_object) - 4) = substr(object, 1, length(object) - 4))
         AND   module   LIKE param_.module_
         AND   lu_name_ LIKE param_.lu_;
   ELSE
      --
      -- Update info on IID domains (for some packages)
      --
      UPDATE component_dependency_tab
         SET   dependency_type = '7'
         WHERE dependency_type = '1'
         AND   ref_object IN (SELECT name
                              FROM   user_source
                              WHERE  type = 'PACKAGE'
                              AND    text LIKE 'domain_%:=%'
                              AND    line BETWEEN 3 AND 5)
         AND   module   LIKE param_.module_
         AND   lu_name_ LIKE param_.lu_
         AND   object   LIKE decode(object_type, '4', param_.pkg_, '5', param_.pkg_, object);
      --
      -- Update info on table references acccording to name conventions (for some packages)
      --
      UPDATE component_dependency_tab
         SET   ref_lu_name = lu_name,
               ref_module  = module
         WHERE ref_object_type IN ('1','9')
         AND   ref_lu_name IS NULL
         AND   ref_module  IS NULL
         AND   (substr(ref_object, 1, length(ref_object) - 4) = object OR
                substr(ref_object, 1, length(ref_object) - 4) = substr(object, 1, length(object) - 4))
         AND   module   LIKE param_.module_
         AND   lu_name_ LIKE param_.lu_
         AND   object   LIKE decode(object_type, '4', param_.pkg_, '5', param_.pkg_, object);
   END IF;

END Parse_Oracle_Dependencies___;


PROCEDURE Parse_View_Comments___ (param_ parameters)
IS
   lu_      VARCHAR2(30);
   objid_   COMPONENT_DEPENDENCY.objid%TYPE;
   objv_    COMPONENT_DEPENDENCY.objversion%TYPE;
   attr_    VARCHAR2(32000);
   newrec_  COMPONENT_DEPENDENCY_TAB%ROWTYPE;
   --SOLSETFW
   CURSOR get_view_info IS
      SELECT dsvc.view_name name, dsvc.column_reference, ds.module, ds.lu_name
      FROM   dictionary_sys_view_column_act dsvc, dictionary_sys_lu_active ds
      WHERE  ds.lu_name = dsvc.lu_name
      AND    ds.module LIKE param_.module_
      AND    ds.lu_name LIKE param_.lu_
      AND    dsvc.view_name LIKE param_.view_
      AND    dsvc.column_reference IS NOT NULL
      AND    substr(dsvc.view_name, -4) <> '_REP';

   TYPE view_struct IS TABLE OF get_view_info%ROWTYPE INDEX BY BINARY_INTEGER;
   view_info_ view_struct;
BEGIN
   OPEN get_view_info;
   FETCH get_view_info BULK COLLECT INTO view_info_;
   CLOSE get_view_info;

   IF view_info_.count > 0 THEN
      -- Static values
      newrec_.dependency_type := '8';
      newrec_.object_type := '2';
      newrec_.ref_object_type := '7';
      FOR i IN view_info_.first..view_info_.last LOOP
         Client_SYS.Clear_Attr(attr_);
         newrec_.dependency_date := SYSDATE;
         newrec_.object := view_info_(i).name;
         newrec_.module := view_info_(i).module;
         newrec_.lu_name := view_info_(i).lu_name;
         lu_ := Get_Ref_Lu___(view_info_(i).column_reference);
         newrec_.ref_object := lu_;
         newrec_.ref_lu_name := lu_;
         newrec_.ref_module := Get_Lu_Module___(lu_);
         Insert___(objid_, objv_, newrec_, attr_);
      END LOOP;
   END IF;
END Parse_View_Comments___;


PROCEDURE Parse_Dynamic_Calls___ (param_ parameters)
IS
   ref_pkg_ VARCHAR2(30);
   index1_  NUMBER;
   index2_  NUMBER;
   index3_  NUMBER;
   objid_   COMPONENT_DEPENDENCY.objid%TYPE;
   objv_    COMPONENT_DEPENDENCY.objversion%TYPE;
   attr_    VARCHAR2(32000);
   newrec_  COMPONENT_DEPENDENCY_TAB%ROWTYPE;

   -- Should be changed to include more things like 'EXECUTE IMMEDIATE' and Dbms_Sql.Execute and Dbms_Sql.Parse
   CURSOR get_dynamics IS
      SELECT name, text, line
      FROM   user_source
      WHERE  type = 'PACKAGE BODY'
      AND    upper(text) LIKE '%TRANSACTION_SYS.DYNAMIC_CALL%'
      AND    name LIKE param_.pkg_
      AND    name NOT LIKE 'COMPONENT_DEPENDENCY_API';

BEGIN
   -- Static values
   newrec_.dependency_type := '9';
   newrec_.object_type := '5';
   newrec_.ref_object_type := '6';
   FOR rec IN get_dynamics LOOP
      Client_SYS.Clear_Attr(attr_);
      newrec_.dependency_date := SYSDATE;
      newrec_.object := rec.name;
      newrec_.module := Dictionary_SYS.Get_Component(rec.name, 'PACKAGE');
      newrec_.lu_name := Dictionary_SYS.Get_Logical_Unit(rec.name, 'PACKAGE');
      index1_ := instr(rec.text, '''', 1, 1);
      index2_ := instr(rec.text, '''', 1, 2);
      index3_ := instr(rec.text, '.', 1, 2);
      ref_pkg_ := substr(substr(rec.text, index1_ + 1, index3_ - index1_ - 1), 1, 30);
      newrec_.method := Extract_Method_From_Text___ ( upper(rec.name), rec.line );
      newrec_.ref_method := substr(substr(rec.text, index3_ + 1, index2_ - index3_ - 1), 1, 30);
      newrec_.ref_object := ref_pkg_;
      newrec_.ref_module := Dictionary_SYS.Get_Component(ref_pkg_, 'PACKAGE');
      newrec_.ref_lu_name := Dictionary_SYS.Get_Logical_Unit(ref_pkg_, 'PACKAGE');
      Insert___(objid_, objv_, newrec_, attr_);
   END LOOP;
END Parse_Dynamic_Calls___;


PROCEDURE Up_Tree___ (
   method_call_ IN VARCHAR2,
   level_       IN NUMBER,
   final_array_ IN OUT NOCOPY array_of_structs,
   max_level_   IN NUMBER )
IS
   temp_           VARCHAR2(100);
   temp_array_     array_of_structs;
   object_         varchar2(30);
   method_         varchar2(30);

CURSOR get_Up_Dependencies ( object_ VARCHAR2, method_ VARCHAR2, level_ NUMBER ) IS
      SELECT DISTINCT object || '.' || method AS Caller, ref_object || '.' || ref_method AS Called, level_
      FROM   component_dependency_tab
      WHERE object = object_
      AND method = method_;

BEGIN
   IF (max_level_ IS NOT NULL) THEN
      IF level_ > max_level_ THEN
         RETURN;
      END IF;
   END IF;
   IF ( level_ = 2 AND final_array_.last IS NULL ) THEN
      final_array_(1).dependent_upon_ := method_call_;
      final_array_(1).level_ := 1;
   ELSIF ( level_ = 2 ) THEN
      final_array_(final_array_.last+1).dependent_upon_ := method_call_;
      final_array_(final_array_.last+1).level_ := 1;
   END IF;
   object_ := substr( method_call_, 1, instr( method_call_, '.' ) - 1 );
   method_ := substr( method_call_, instr( method_call_, '.' ) + 1 , length( method_call_ ));
   temp_array_.delete;                                        -- Truncate temporary array
   OPEN get_Up_Dependencies ( object_, method_, level_ );     -- Open database through cursor..
   FETCH get_Up_Dependencies BULK COLLECT INTO temp_array_;   -- stuff array with data...
   CLOSE get_Up_Dependencies;                                 -- close up and move on..
   -- check content of array.
   IF ( temp_array_.last IS NOT NULL ) THEN
      -- Array containing data.
      FOR j IN 1..temp_array_.count LOOP                         -- Loop for as long as new data exists
         IF (temp_array_( j ).Dependent_upon_ IS NOT NULL) THEN
            IF ( temp_array_( j ).method_ = temp_array_( j ).dependent_upon_ ) then
               final_array_(final_array_.last+1).level_ := temp_array_( j ).level_;
               final_array_(final_array_.last).method_:= temp_array_( j ).method_;
               final_array_(final_array_.last).dependent_upon_ := '*** RECURSIVE CALL ***';
            ELSIF ( Check_For_Loops___( final_array_, temp_array_( j )) = false ) then
               final_array_(final_array_.count+1) := temp_array_( j ); -- insert on first empty slot.
               temp_ := temp_array_( j ).Dependent_upon_;
               Up_Tree___( temp_, level_ + 1, final_array_, max_level_);
            ELSE
               final_array_(final_array_.last+1).level_ := temp_array_( j ).level_;
               final_array_(final_array_.last).method_:= temp_array_( j ).method_;
               final_array_(final_array_.last).dependent_upon_ := '*** LOOP - INDIRECT RECURSIVE CALL ***';
            END IF;
         END IF;
      END LOOP;
   END IF;
END Up_Tree___;


PROCEDURE Down_Tree___ (
   method_call_ IN VARCHAR2,
   level_       IN NUMBER,
   final_array_ IN OUT NOCOPY array_of_structs,
   max_level_ IN NUMBER )
IS
   temp_           VARCHAR2(100);
   temp_array_     array_of_structs;
   object_         varchar2(30);
   method_         varchar2(30);

CURSOR get_down_dependencies ( object_ VARCHAR2, method_ VARCHAR2, level_ NUMBER ) IS
      SELECT DISTINCT ref_object || '.' || ref_method AS Called, object || '.' || method AS Caller, level_
      FROM   component_dependency_tab
      WHERE ref_object = object_
      AND ref_method = method_;

BEGIN
   IF (max_level_ IS NOT NULL) THEN
      IF level_ > max_level_ THEN
         RETURN;
      END IF;
   END IF;
   IF ( level_ = 2 ) THEN
      final_array_(1).dependent_upon_ := method_call_;
      final_array_(1).level_ := 1;
   END IF;
   object_ := substr( method_call_, 1, instr( method_call_, '.' ) - 1 );
   method_ := substr( method_call_, instr( method_call_, '.' ) + 1 , length( method_call_ ));
   temp_array_.delete;                                          -- Truncate temporary array1
   OPEN get_down_dependencies ( object_, method_, level_ );     -- Open database through cursor..
   FETCH get_down_dependencies BULK COLLECT INTO temp_array_;   -- stuff array with data...
   CLOSE get_down_dependencies;                                 -- close up and move on..
   -- check content of array.
   IF ( temp_array_.last IS NOT NULL ) THEN
      -- Array containing data.
      FOR j IN 1..temp_array_.count LOOP                         -- Loop for as long as new data exists
         IF (temp_array_( j ).dependent_upon_ IS NOT NULL) THEN
            IF ( temp_array_( j ).method_ = temp_array_( j ).dependent_upon_ ) THEN
               --recursive call found....
               final_array_(final_array_.last+1).level_ := temp_array_( j ).level_;
               final_array_(final_array_.last).method_:= temp_array_( j ).method_;
               final_array_(final_array_.last).dependent_upon_ := '*** RECURSIVE CALL ***';
            --check for indirect recursive calls i.e. loops
            ELSIF ( Check_For_Loops___( final_array_, temp_array_( j )) = FALSE ) THEN
               -- no recursive call found,
               final_array_(final_array_.count+1) := temp_array_( j ); -- insert on first empty slot.
               temp_ := temp_array_( j ).dependent_upon_;
               Down_Tree___( temp_, level_ + 1, final_array_, max_level_);            -- move to the next level and find methods.
               Get_Calls_From_Window___( temp_, level_ + 1, final_array_);-- get calling windows.
            ELSE
               -- loop found....
               final_array_(final_array_.last+1).level_ := temp_array_( j ).level_;
               final_array_(final_array_.last).method_:= temp_array_( j ).method_;
               final_array_(final_array_.last).dependent_upon_ := '*** LOOP - INDIRECT RECURSIVE CALL ***';
            END IF;
         END IF;
      END LOOP;
   END IF;
END Down_Tree___;


FUNCTION Check_For_Loops___ (
   final_array_ IN OUT NOCOPY array_of_structs,
   temp_        IN OUT NOCOPY struct ) RETURN BOOLEAN
IS
   level_         NUMBER;
BEGIN
   level_ := final_array_(final_array_.last).level_;
   -- loop backwards from the last inserted element.
   FOR i IN REVERSE 1..final_array_.last-1 LOOP
      -- only check elements closer to root.. (by level_ value)
      IF ( final_array_(i).level_ < level_ ) THEN
         -- if both caller and called are the same in both final_array_(current element) and temp_ then return loop = true.
         IF ( final_array_( i ).method_ = temp_.method_ ) AND ( final_array_(i).dependent_upon_ = temp_.dependent_upon_) THEN
            RETURN TRUE;
         END IF;
         level_ := level_ - 1;
      END IF;
   END LOOP;
   -- no loop found
   RETURN FALSE;
END Check_For_Loops___;


PROCEDURE Send_To_Screen___ (
   final_array_ IN OUT NOCOPY array_of_structs )
IS
   output_        VARCHAR2(200);
-- Temporary output method. Will be replaced once a GUI is present.
BEGIN
   IF (final_array_.last IS NOT NULL) THEN
      FOR i IN 1..final_array_.last LOOP
         -- print only elements with valid 'dependent_upon_'-values i.e. Not NULL.
         IF (final_array_(i).dependent_upon_ IS NOT NULL) THEN
            -- generate indentation ("tab-style" tabsize: 3)
            output_ := '  ' || final_array_(i).dependent_upon_;
            FOR k IN 1.. final_array_(i).level_ -1 LOOP
               output_ := '   ' || output_;
            END LOOP;
            -- Print collected data
            Log_SYS.Fnd_Trace_(Log_SYS.info_, final_array_(i).level_ || ':' || output_ );
         END IF;
      END LOOP;
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'No data collected'); -- If no data is collected.
   END IF;
END Send_To_Screen___;


PROCEDURE Get_Calls_From_Window___ (
   method_call_ IN VARCHAR2,
   level_       IN NUMBER,
   final_array_ IN OUT NOCOPY array_of_structs )
IS
   temp_array_     array_of_structs;

CURSOR get_calling_windows( method_call_ VARCHAR2, level_ NUMBER ) IS
      SELECT DISTINCT method_call_ AS called, 'GUI - ' || po_id AS caller, level_ AS lev
      FROM   pres_object_security
      WHERE sec_object_type_db = 'METHOD'
      AND upper(sec_object) = upper(method_call_);
BEGIN
   temp_array_.delete;                                           -- Truncate temporary array
   OPEN get_calling_windows ( method_call_, level_ );            -- Open database through cursor..
   FETCH get_calling_windows BULK COLLECT INTO temp_array_;      -- stuff array with data
   CLOSE get_calling_windows;                                    -- close up and move on..
   IF ( temp_array_.last IS NOT NULL) THEN
      FOR i IN 1..temp_array_.count LOOP
         final_array_(final_array_.count+1) := temp_array_( i ); -- insert on first empty slot.
      END LOOP;
   END IF;
END Get_Calls_From_Window___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT component_dependency_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.dependency_id := Get_Dependency_Sequence___;   
   newrec_.object := upper(newrec_.object);
   newrec_.method := initcap(newrec_.method);
   newrec_.ref_object := upper(newrec_.ref_object);
   newrec_.ref_method := initcap(newrec_.ref_method);
   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     component_dependency_tab%ROWTYPE,
   newrec_     IN OUT component_dependency_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.object := upper(newrec_.object);
   newrec_.method := initcap(newrec_.method);
   newrec_.ref_object := upper(newrec_.ref_object);
   newrec_.ref_method := initcap(newrec_.ref_method);
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT component_dependency_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF newrec_.dependency_date IS NULL THEN
      newrec_.dependency_date := SYSDATE;
   END IF;

   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Generate_Dependency_Info__ (
   module_    IN VARCHAR2 DEFAULT '%',
   lu_name_   IN VARCHAR2 DEFAULT '%',
   pkg_name_  IN VARCHAR2 DEFAULT '%',
   view_name_ IN VARCHAR2 DEFAULT '%',
   methods_   IN NUMBER   DEFAULT 1,
   dynamic_   IN NUMBER   DEFAULT 1,
   commit_    IN NUMBER   DEFAULT 1 )
IS
   param_ parameters;
   row_locked EXCEPTION;
   PRAGMA     exception_init(row_locked, -0054);
   CURSOR get_lock IS
      SELECT 1
      FROM component_dependency_tab
      WHERE module  LIKE module_
      AND   lu_name LIKE lu_name_
      AND   (object LIKE pkg_name_ OR object LIKE view_name_)
      FOR UPDATE NOWAIT;
BEGIN
   --
   -- Make sure that dictionary information is up-to-date before starting
   --
   Dictionary_SYS.Rebuild_Dictionary_Storage_(1, 'COMPUTE');
   --
   -- Lock table before starting
   --
   OPEN get_lock;
   --
   -- Delete old information from the tables
   --
   DELETE FROM component_dependency_tab
      WHERE module  LIKE module_
      AND   lu_name LIKE lu_name_
      AND   (object LIKE pkg_name_ OR object LIKE view_name_);
   IF (commit_ = 1) THEN
@ApproveTransactionStatement(2014-04-02,mabose)
      COMMIT;
   END IF;
   --
   
   --Parameter structure passed to methods
   param_.module_	:= module_;
   param_.lu_ 		:= lu_name_;
   param_.pkg_     	:= pkg_name_;
   param_.view_    	:= view_name_;
   param_.methods_ 	:= methods_;
   param_.dynamic_ 	:= dynamic_;
   
   --
   -- Parse all source code
   --
   Parse_Oracle_Dependencies___ (param_);
   IF (commit_ = 1) THEN
@ApproveTransactionStatement(2014-04-02,mabose)
      COMMIT;
   END IF;
   Parse_View_Comments___ (param_);
   IF (commit_ = 1) THEN
@ApproveTransactionStatement(2014-04-02,mabose)
      COMMIT;
   END IF;
   IF (dynamic_ = 1) THEN
      Parse_Dynamic_Calls___ (param_);
   END IF;
   IF (commit_ = 1) THEN
@ApproveTransactionStatement(2014-04-02,mabose)
      COMMIT;
   END IF;
   --
   -- Unlock table
   --
   CLOSE get_lock;
EXCEPTION
   WHEN row_locked THEN
      Error_SYS.System_General('LOCKERR: The table for component dependencies is locked.');
END Generate_Dependency_Info__;


PROCEDURE Dependency_Tree__ (
   object_    IN VARCHAR2,
   method_    IN VARCHAR2,
   max_level_ IN NUMBER  )

IS
   up_array_ array_of_structs;
   down_array_ array_of_structs;
BEGIN
   -- Get methods called by inserted method.
   Up_Tree___( upper(object_) || '.' || initcap(method_), 2, up_array_, max_level_ );
   Log_SYS.Fnd_Trace_(Log_SYS.info_, '*** CALLED METHODS ***' || chr( 10 ) || '**********************');
   -- Print data on screen.
   Send_To_Screen___( up_array_ );
   -- Truncate final_array_
   up_array_.DELETE;
   -- And now, for something completely different....
   -- Get methods that calls inserted method.
   Down_Tree___( upper(object_) || '.' || initcap(method_), 2, down_array_, max_level_ );
   Log_SYS.Fnd_Trace_(Log_SYS.info_,  chr( 10 ) || '*** CALLING METHODS ***' || chr( 10 ) || '***********************');
   -- Print some more data on screen.
   Send_To_Screen___( down_array_ );
   -- THE END!!!
END Dependency_Tree__;


PROCEDURE Get_Called_Methods__ (
   pres_object_ IN VARCHAR2,
   max_level_   IN NUMBER )
IS
   TYPE array_type_ IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
   methods_     array_type_;
   final_array_ array_of_structs;

CURSOR get_methods( pres_object_ VARCHAR2) IS
   SELECT DISTINCT sec_object
   FROM   pres_object_security
   WHERE sec_object_type_db = 'METHOD'
   AND upper(po_id) = upper(pres_object_);

-- This is a start method that collects the methods used by any given presentation
-- object, collects them into an array and steps through it and calls the method Up_Tree___
-- for each found method, and by doing that creates a method tree with the presentation
-- object as root.
BEGIN
   OPEN get_methods ( pres_object_ );                      -- Open database through cursor..
   FETCH get_methods BULK COLLECT INTO methods_;           -- stuff array with data
   CLOSE get_methods;                                      -- Close and move on
   IF ( methods_.last IS NOT NULL ) THEN
      final_array_(1).dependent_upon_ := 'GUI - ' || pres_object_;
      final_array_(1).level_ := 1;
      FOR i IN 1..methods_.count LOOP
         final_array_( final_array_.last+1 ).method_ := pres_object_;
         final_array_( final_array_.last ).dependent_upon_ := methods_( i );
         final_array_( final_array_.last ).level_ := 2;
         Up_Tree___( methods_( i ), 3, final_array_, max_level_ );
      END LOOP;
   Send_To_Screen___( final_array_ );
   END IF;
END Get_Called_Methods__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

