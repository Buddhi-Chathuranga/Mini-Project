-----------------------------------------------------------------------------
--
--  Logical unit: LanguageContext
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020703  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030130  NIPAFI  Changed REF for attribute module in VIEW from LanguageModule
--                  to Module.
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  040419  STDA    Added call to Database_SYS.Unistr to support unicode (F1PR408B).
--  050318  STDA    F1PR480 - Localize changes due to Term Binding.
--  060323  STDA    F1PR480 - Changed update of sub_type in refresh_, condition JAVA.
--  060928  STDA    Translation Simplification (BUG#58618).
--  061023  STDA    Remove of property when making context obsolete (BUG#61351).
--  061121  STDA    Context exist error (BUG#61953).
--  071119  UTGULK  Merged Get() method from BA changes (Bug#69111)
--  090331  JOWISE  Added functionality for Copying Translations from SO to RWC
--  100907  JOWISE  Added parameter rwc_sub_type_ to Copy_Term_
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK  Merged Rose Documentation.
--  110218  TOBESE  Modified Copy_Translations_ to handle updates in APF (Bug#95860).
--  110601  TOBESE  Enhancements in Term application of Copy Translation algorithm for APF (Bug#97390).
--  110629  JOWISE  Removed add_constants_ If clause because it should always run
--  150408  PGANLK  Changed get_contexts cursor in Remove_Module_Language_ to remove EN translations during LNG import. (Bug#121929)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE context_rectype IS RECORD (
   context_id        NUMBER,
   name              VARCHAR2(200),
   parent            NUMBER,
   main_type         VARCHAR2(50),
   sub_type          VARCHAR2(50),
   module            VARCHAR2(50),
   path              VARCHAR2(500),
   customer_fitting  VARCHAR2(1),
   write_protect     VARCHAR2(1),
   obsolete          VARCHAR2(1),
   Bulk              NUMBER);


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Generate_Sequence_Id___ RETURN NUMBER
IS
   context_id_ NUMBER;
   CURSOR get_seq IS
      SELECT Language_Context_SEQ.nextval
      FROM   dual;
BEGIN
   OPEN get_seq;
   FETCH get_seq INTO context_id_;
   CLOSE get_seq;
   RETURN(context_id_);
END Generate_Sequence_Id___;


FUNCTION Get_Parent___ (
   context_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ LANGUAGE_CONTEXT_TAB.parent%TYPE;
   CURSOR get_attr IS
      SELECT parent
      FROM LANGUAGE_CONTEXT_TAB
      WHERE context_id = context_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN nvl(temp_, 0);
END Get_Parent___;


-- Move___
--   Moves a top-level context and all sub-contexts to another module
PROCEDURE Move___ (
   context_id_ IN NUMBER,
   new_module_ IN VARCHAR2 )
IS
   CURSOR children IS
      SELECT context_id
      FROM LANGUAGE_CONTEXT_TAB
      WHERE parent = context_id_;
BEGIN
   --
   -- Move this context
   UPDATE LANGUAGE_CONTEXT_TAB
      SET module = new_module_,
          rowversion = sysdate
      WHERE context_id = context_id_;
   --
   -- Recursively move all child contexts
   FOR child IN children LOOP
      Move___( child.context_id, new_module_ );
   END LOOP;
END Move___;

FUNCTION Is_Context_Exist___ (
   module_       IN VARCHAR2,
   main_type_    IN VARCHAR2,
   layer_        IN VARCHAR2,
   context_path_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   BEGIN
      SELECT t.context_id
      INTO   dummy_
      FROM   language_context_tab t
      WHERE  t.module=module_
      AND    t.main_type=main_type_  
   	AND    t.path=context_path_
      AND    t.obsolete = 'N'
      AND    t.layer IN (SELECT l1.layer_id
                         FROM   fnd_layer_tab l1,fnd_layer_tab l2
                         WHERE  l1.ordinal<l2.ordinal
                         AND    l2.layer_id=layer_);
      RETURN TRUE;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN FALSE;
      WHEN too_many_rows THEN
         RETURN TRUE;
END Is_Context_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Get_Menu_Path__ (
   menu_path_  OUT VARCHAR2,
   context_id_ IN  NUMBER,
   path_       IN  VARCHAR2 )
IS
   id_        NUMBER;
   position_  NUMBER;
   temp_      VARCHAR2(501);
   name_      LANGUAGE_CONTEXT_TAB.name%TYPE;
   sub_type_  LANGUAGE_CONTEXT_TAB.sub_type%TYPE;
   parent_    LANGUAGE_CONTEXT_TAB.parent%TYPE;
   CURSOR get_parent_ IS
      SELECT name, sub_type, parent
      FROM LANGUAGE_CONTEXT_TAB
      WHERE context_id = id_;
BEGIN
   --
   -- Get information about the first parent
   --
   id_ := context_id_;
   temp_ := NULL;

   WHILE ( id_ > 0 ) LOOP
      OPEN get_parent_;
      FETCH get_parent_ INTO name_, sub_type_, parent_;
      IF (get_parent_%FOUND) THEN
         -- Add name for named menus, add position for menu items and popup menus
         IF (sub_type_ = 'Menu Item') OR (sub_type_ = 'Popup Menu') THEN
            position_ := Language_Property_API.Get_Value( id_, 'Position' );
            IF temp_ IS NOT NULL THEN
               temp_ := TO_CHAR( position_ ) || '.' || temp_;
            ELSE
               temp_ := TO_CHAR( position_ );
            END IF;
         ELSE
            temp_ := name_ || '.' || temp_;
         END IF;
         --Advance to next element
         id_ := parent_;
      END IF;
      CLOSE get_parent_;

   END LOOP;
   menu_path_ := temp_;

END Get_Menu_Path__;


PROCEDURE Move_Top_Level__ (
   context_id_ IN NUMBER,
   new_module_ IN VARCHAR2 )
IS
   CURSOR children IS
      SELECT context_id
      FROM LANGUAGE_CONTEXT_TAB
      WHERE parent = context_id_;
BEGIN
   --
   -- Validate that context is top-level
   IF Get_Parent___( context_id_ ) != 0 THEN
      Error_SYS.Appl_General( lu_name_, 'NOTTOP: Context is not top-level');
   END IF;
   --
   -- Move this context
   UPDATE LANGUAGE_CONTEXT_TAB
      SET module = new_module_,
          rowversion = sysdate
      WHERE context_id = context_id_;
   --
   -- Recursively move all child contexts
   FOR child IN children LOOP
      Move___( child.context_id, new_module_ );
   END LOOP;
END Move_Top_Level__;


PROCEDURE Remove_Context__ (
   context_id_ IN NUMBER )
IS
   CURSOR children IS
      SELECT context_id
      FROM LANGUAGE_CONTEXT_TAB
      WHERE parent = context_id_;
BEGIN
   --
   -- Remove attributes and properties
   Language_Attribute_API.Remove_Context_( context_id_ );
   Language_Property_API.Remove_Context_( context_id_ );
   --
   -- Recursively remove all children
   FOR child IN children LOOP
      Remove_Context__( child.context_id );
   END LOOP;
   DELETE FROM LANGUAGE_CONTEXT_TAB
      WHERE context_id = context_id_;
END Remove_Context__;


@UncheckedAccess
PROCEDURE Get_Attribute_Translation__ (
   translation_ OUT VARCHAR2,
   context_id_  IN  NUMBER,
   name_        IN  VARCHAR2,
   lang_code_   IN  VARCHAR2 )
IS
BEGIN
   translation_ := Get_Attribute_Translation( context_id_, name_, lang_code_ );
END Get_Attribute_Translation__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Get_Id_ (
   parent_    IN NUMBER,
   name_      IN VARCHAR2,
   main_type_ IN VARCHAR2,
   layer_     IN VARCHAR2) RETURN NUMBER
IS
   context_id_ LANGUAGE_CONTEXT_TAB.context_id%TYPE;
   CURSOR get_id IS
      SELECT context_id
      FROM LANGUAGE_CONTEXT_TAB
      WHERE name = Database_SYS.Unistr(name_)
      AND parent = parent_
      AND (main_type = nvl(main_type_, main_type) OR parent_ != 0 )
      AND layer = layer_;
BEGIN
   OPEN get_id;
   FETCH get_id INTO context_id_;
   IF ( get_id%FOUND ) THEN
      CLOSE get_id;
      RETURN ( context_id_ );
   END IF;
   CLOSE get_id;
   RETURN ( 0 );
END Get_Id_;


FUNCTION Get_Id_ (
   path_      IN VARCHAR2,
   main_type_ IN VARCHAR2,
   layer_     IN VARCHAR2) RETURN NUMBER
IS
   context_id_ LANGUAGE_CONTEXT_TAB.context_id%TYPE;       
BEGIN
   SELECT context_id
     INTO context_id_
     FROM LANGUAGE_CONTEXT_TAB
    WHERE path = path_
      AND main_type = main_type_
      AND layer = layer_;
   RETURN context_id_;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN 0;
END Get_Id_;

PROCEDURE Make_Child_Of_ (
   context_        IN OUT context_rectype,
   parent_context_ IN     context_rectype )
IS
BEGIN
   context_.parent               := parent_context_.context_id;
   context_.main_type            := parent_context_.main_type;
   context_.module               := parent_context_.module;
   context_.customer_fitting     := parent_context_.customer_fitting;
   context_.obsolete             := parent_context_.obsolete;
   context_.bulk                 := parent_context_.bulk;
   context_.path                 := parent_context_.path || '.' || context_.name;
   IF substr( context_.path, 1, 1 ) = '.' THEN
      context_.path := substr( context_.path, 2, length( context_.path ) - 1 );
   END IF;
END Make_Child_Of_;


PROCEDURE Make_Obsolete_ (
   context_id_                      IN NUMBER,
   layer_                           IN VARCHAR2,
   skip_obsolete_if_support_scan_   IN VARCHAR2 DEFAULT 'FALSE')
IS
   CURSOR children IS
      SELECT context_id, layer
      FROM LANGUAGE_CONTEXT_TAB
      WHERE parent = context_id_
      AND layer = layer_
      and sub_type not in('Report', 'Report Message');
BEGIN   
   IF (context_id_ > 0 AND NOT (skip_obsolete_if_support_scan_ = 'TRUE' AND Fnd_Setting_API.Get_Value('TRANS_SCANNER_MODE') = 'SUPP')) THEN
      --
      -- First mark this context and all it's attributes as obsolete
      UPDATE LANGUAGE_CONTEXT_TAB
         SET obsolete = 'Y',
             rowversion = sysdate
         WHERE context_id = context_id_
         AND layer = layer_;
      Language_Attribute_API.Make_Obsolete_( context_id_ );
      -- Remove property.
      Language_Property_API.Remove_Context_( context_id_ );
      --
      -- Recursively make all children obsolete
      FOR child IN children LOOP
         Make_Obsolete_( child.context_id, child.layer );
      END LOOP;
   END IF;
END Make_Obsolete_;

PROCEDURE Make_Usage_Obsolete_ (
   context_id_ IN NUMBER,
   layer_      IN VARCHAR2)
IS
   CURSOR children IS
      SELECT context_id, layer
      FROM LANGUAGE_CONTEXT_TAB
      WHERE parent = context_id_
      AND layer = layer_
      and sub_type not in('Report', 'Report Message');
BEGIN
   IF ( context_id_ > 0 ) THEN
      Language_Attribute_API.Make_Usage_Obsolete_( context_id_ );
      -- Recursively make all children obsolete
      FOR child IN children LOOP
         Make_Usage_Obsolete_( child.context_id, child.layer );
      END LOOP;
   END IF;
END Make_Usage_Obsolete_;

PROCEDURE Make_Report_Obsolete_ (
   context_id_ IN NUMBER,
   layer_      IN VARCHAR2)
IS
   CURSOR reports IS
      SELECT context_id, layer
      FROM LANGUAGE_CONTEXT_TAB
      WHERE parent = context_id_
      AND layer = layer_
      and sub_type = 'Report';
BEGIN
      FOR report IN reports LOOP
         Make_Obsolete_( report.context_id, report.layer );
      END LOOP;
END Make_Report_Obsolete_;

PROCEDURE Make_Obsolete_Lng_ (
   context_id_ IN NUMBER,
   layer_      IN VARCHAR2)
IS
   CURSOR children IS
      SELECT context_id, layer
      FROM LANGUAGE_CONTEXT_TAB
      WHERE parent = context_id_
      AND layer = layer_;
BEGIN
   IF ( context_id_ > 0 ) THEN
      --
      -- First mark this context and all it's attributes as obsolete
      UPDATE LANGUAGE_CONTEXT_TAB
         SET obsolete = 'Y',
             rowversion = sysdate
         WHERE context_id = context_id_
         AND layer = layer_;
      Language_Attribute_API.Make_Obsolete_( context_id_ );
      -- Remove property.
      Language_Property_API.Remove_Context_( context_id_ );
      --
      -- Recursively make all children obsolete
      FOR child IN children LOOP
         Make_Obsolete_Lng_( child.context_id, child.layer );
      END LOOP;
   END IF;
END Make_Obsolete_Lng_;


PROCEDURE Refresh_ (
   id_              OUT NUMBER,
   customer_fitting_ IN VARCHAR2,
   name_             IN VARCHAR2,
   parent_           IN NUMBER,
   main_type_        IN VARCHAR2,
   sub_type_         IN VARCHAR2,
   module_           IN VARCHAR2,
   path_             IN VARCHAR2,
   layer_            IN VARCHAR2,
   bulk_             IN NUMBER DEFAULT 0,
   origin_           IN VARCHAR2 DEFAULT NULL )
IS
   context_id_          LANGUAGE_CONTEXT_TAB.context_id%TYPE;
   existing_module_     LANGUAGE_CONTEXT_TAB.module%TYPE;
   existing_obsolete_   LANGUAGE_CONTEXT_TAB.obsolete%TYPE;
   existing_path_       LANGUAGE_CONTEXT_TAB.path%TYPE;
   existing_sub_type_   LANGUAGE_CONTEXT_TAB.sub_type%TYPE;
   existing_bulk_       LANGUAGE_CONTEXT_TAB.bulk%TYPE;
   existing_origin_     LANGUAGE_CONTEXT_TAB.origin%TYPE;

   CURSOR get_existing IS
      SELECT module, path, obsolete, sub_type, nvl(bulk,'0'), origin
      FROM language_context_tab
      WHERE context_id = context_id_
      AND layer = layer_;
BEGIN
   -- Validate parameters
   Error_SYS.Check_Not_Null(lu_name_, 'NAME', name_);
   Error_SYS.Check_Not_Null(lu_name_, 'MAIN_TYPE', main_type_);
   Error_SYS.Check_Not_Null(lu_name_, 'SUB_TYPE', sub_type_);
   Error_SYS.Check_Not_Null(lu_name_, 'MODULE', module_);
   Error_SYS.Check_Not_Null(lu_name_, 'PATH', path_);
   --Language_Content_Type_API.Exist( main_type_);
   IF length( Database_SYS.Unistr(name_) ) > 500 THEN
      Error_SYS.Record_General(lu_name_, 'ITEMTOLONG: The context name is too long' );
   END IF;
   -- Update the context if it exist, or intert a new context if it does not.
   context_id_ := Get_Id_( parent_, name_, main_type_, layer_ );
   OPEN get_existing;
   FETCH get_existing INTO  existing_module_, existing_path_, existing_obsolete_, existing_sub_type_, existing_bulk_, existing_origin_;
   IF (context_id_ != 0 AND get_existing%FOUND) THEN
      IF existing_obsolete_ = 'Y' THEN
         UPDATE LANGUAGE_CONTEXT_TAB
         SET obsolete = 'N', 
             module = module_, 
             sub_type = sub_type_, 
             bulk = nvl(bulk_,0),
             origin = origin_,
             rowversion = sysdate
         WHERE context_id = context_id_;
      ELSE
         IF ((existing_sub_type_ != sub_type_) AND ((main_type_ != 'JAVA') OR ((main_type_ = 'JAVA') AND (existing_sub_type_ != 'Data Field')))) THEN
            UPDATE LANGUAGE_CONTEXT_TAB
             SET sub_type = sub_type_,
             rowversion = sysdate
             WHERE context_id = context_id_;
         END IF;
         IF (bulk_ = '1' AND existing_bulk_ = '0') THEN
            UPDATE LANGUAGE_CONTEXT_TAB
            SET bulk = bulk_,
            rowversion = sysdate
            WHERE context_id = context_id_;
         END IF;
         IF (module_ != existing_module_) THEN
            UPDATE LANGUAGE_CONTEXT_TAB
            SET module = module_,
                rowversion = sysdate
            WHERE context_id = context_id_;
         END IF;
         IF (origin_ IS NOT NULL AND origin_ != existing_origin_) THEN
            UPDATE LANGUAGE_CONTEXT_TAB
            SET origin = origin_,
                rowversion = sysdate
            WHERE context_id = context_id_;
         END IF;
      END IF;
   ELSE
      context_id_ := Generate_Sequence_Id___;
      INSERT INTO LANGUAGE_CONTEXT_TAB
               (context_id, name, parent, main_type, sub_type, module,
               path, origin, write_protect, obsolete, bulk, layer, rowversion)
         VALUES
            (context_id_, Database_SYS.Unistr(name_), parent_, main_type_, sub_type_,
             module_, Database_SYS.Unistr(path_), origin_, 'R', 'N', nvl(bulk_,0), layer_, sysdate);
   END IF;
   CLOSE get_existing;
   -- return context id
   id_ := context_id_;
END Refresh_;


PROCEDURE Remove_Module_ (
   module_     IN VARCHAR2 )
IS
   CURSOR contexts IS
      SELECT context_id
      FROM LANGUAGE_CONTEXT
      WHERE module = module_;
BEGIN
   --
   -- Remove all attributes and properties
   FOR context IN contexts LOOP
      Language_Attribute_API.Remove_Context_( context.context_id );
      Language_Property_API.Remove_Context_( context.context_id );
   END LOOP;
   --
   -- Remove the contexts themselves from the module
   DELETE FROM LANGUAGE_CONTEXT_TAB
      WHERE module = module_;
END Remove_Module_;


-- Count_Sub_Contexts_
--   Count the number of child contexts
@UncheckedAccess
FUNCTION Count_Sub_Contexts_ (
   context_id_ IN NUMBER ) RETURN NUMBER
IS
   count_ NUMBER;
BEGIN
   SELECT count(*)
      INTO count_
      FROM LANGUAGE_CONTEXT
      WHERE parent = context_id_;
   RETURN count_;
END Count_Sub_Contexts_;


@UncheckedAccess
FUNCTION Count_Attributes_ (
   context_id_ IN NUMBER ) RETURN NUMBER
IS
   count_ NUMBER;
BEGIN
   SELECT count(*)
      INTO count_
      FROM Language_Attribute
      WHERE context_id = context_id_;
   RETURN count_;
END Count_Attributes_;


@UncheckedAccess
FUNCTION Count_Properties_ (
   context_id_ IN NUMBER ) RETURN NUMBER
IS
   count_ NUMBER;
BEGIN
   SELECT count(*)
      INTO count_
      FROM Language_Property
      WHERE context_id = context_id_;
   RETURN count_;
END Count_Properties_;


-- Get_Parent_Of_Type_
--   The GetParentOfType finds the nearest parent context of a specified main- and sub type
@UncheckedAccess
FUNCTION Get_Parent_Of_Type_ (
   context_id_ IN NUMBER,
   main_type_  IN VARCHAR2,
   sub_type_   IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN NULL;
END Get_Parent_Of_Type_;

PROCEDURE Remove_Module_Language_ (
   module_    IN VARCHAR2,
   layer_     IN VARCHAR2,
   lang_code_ IN VARCHAR2 )
IS
   CURSOR contexts IS
      SELECT context_id
      FROM LANGUAGE_CONTEXT
      WHERE module = module_
      AND layer = layer_;
BEGIN
   -- Remove all attributes
   FOR context IN contexts LOOP
      Language_Attribute_API.Remove_Context_Language_( context.context_id, lang_code_ );
   END LOOP;
END Remove_Module_Language_;

PROCEDURE Remove_Module_Language_ (
   module_    IN VARCHAR2,
   layer_     IN VARCHAR2,
   main_type_ IN VARCHAR2,
   sub_type_  IN VARCHAR2,
   lang_code_ IN VARCHAR2)
IS
    CURSOR contexts IS
       SELECT context_id
       FROM LANGUAGE_CONTEXT
       WHERE module = module_
       AND layer = layer_
       AND main_type_db = main_type_
       AND sub_type like sub_type_;
BEGIN
      -- Remove all attributes
   FOR context IN contexts LOOP
      Language_Attribute_API.Remove_Context_Language_( context.context_id, lang_code_ );
   END LOOP;
END Remove_Module_Language_;

PROCEDURE Remove_Module_Language_ (
   module_    IN VARCHAR2,
   layer_     IN VARCHAR2,
   main_type_ IN VARCHAR2,
   sub_type_  IN VARCHAR2,
   lang_code_ IN VARCHAR2,
   content_   IN VARCHAR2)
IS
    CURSOR contexts IS
       SELECT context_id, sub_type, path
       FROM LANGUAGE_CONTEXT
       WHERE module = module_
       AND layer = layer_
       AND main_type_db = main_type_
       AND sub_type like sub_type_;
       
    CURSOR contexts_LU_enumeration IS
       SELECT context_id
       FROM LANGUAGE_CONTEXT
       WHERE module = module_
       AND layer = layer_
       AND main_type_db = main_type_
       AND sub_type in ('Iid Element','State');
     
BEGIN
   -- Remove all attributes
   IF (main_type_ = 'LU' AND content_ = 'Enumeration') THEN
      FOR context IN contexts_LU_enumeration LOOP
         Language_Attribute_API.Remove_Context_Language_( context.context_id, lang_code_ );
      END LOOP;
   ELSE
      FOR context IN contexts LOOP
         IF (main_type_ = 'LU' AND context.sub_type IN ('Iid Element','State')) THEN
            CONTINUE;
         END IF;
         Language_Attribute_API.Remove_Context_Language_( context.context_id, lang_code_ );
      END LOOP;
   END IF;      
END Remove_Module_Language_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Attribute_Translation (
   context_id_ IN NUMBER,
   name_       IN VARCHAR2,
   lang_code_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   attribute_id_ NUMBER;
BEGIN
   attribute_id_ := Language_Attribute_API.Get_Id_( context_id_, name_ );
   RETURN Language_Translation_API.Get_Text( attribute_id_, lang_code_ );
END Get_Attribute_Translation;

FUNCTION Is_Context_Exist (
   module_       IN VARCHAR2,
   main_type_    IN VARCHAR2,
   layer_        IN VARCHAR2,
   context_path_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
      CASE (Is_Context_Exist___(module_,main_type_,layer_,context_path_))
         WHEN TRUE THEN
            RETURN('TRUE');
         WHEN FALSE THEN
            RETURN('FALSE');
         ELSE
            RETURN(NULL);
      END CASE;
END Is_Context_Exist;

FUNCTION Get_Context_Id (
   module_       IN VARCHAR2,
   main_type_    IN VARCHAR2,
   layer_        IN VARCHAR2,
   context_path_ IN VARCHAR2 ) RETURN NUMBER
IS
   context_id_ NUMBER;
BEGIN
      SELECT t.context_id
      INTO   context_id_
      FROM   language_context_tab t
      WHERE  t.module=module_
      AND    t.main_type=main_type_  
   	AND    t.path=context_path_
      AND    t.obsolete = 'N'
      AND t.layer =layer_;
   RETURN context_id_;
EXCEPTION
   WHEN OTHERS THEN
      RETURN 0;
END Get_Context_Id;