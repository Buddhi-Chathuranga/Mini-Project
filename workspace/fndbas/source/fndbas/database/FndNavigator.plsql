-----------------------------------------------------------------------------
--
--  Logical unit: FndNavigator
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Entry_Rec IS RECORD
  (entry_name                fnd_navigator_entry_tab.entry_name%TYPE,
   label                     fnd_navigator_entry_tab.label%TYPE,
   entry_type                fnd_navigator_entry_tab.entry_type%TYPE,
   entry_command             fnd_navigator_entry_tab.entry_command%TYPE,
   client_origin             fnd_navigator_entry_tab.client_origin%TYPE,
   projection                fnd_navigator_entry_tab.projection%TYPE,
   selector                  fnd_navigator_entry_tab.selector%TYPE,
   action                    fnd_navigator_entry_tab.action%TYPE,
   filter                    fnd_navigator_entry_tab.filter%TYPE,
   layer_no                  fnd_navigator_entry_tab.layer_no%TYPE,
   context                   fnd_navigator_entry_tab.context%TYPE,
   home_for_entity           fnd_navigator_entry_tab.home_for_entity%TYPE,
   scope_id                  fnd_navigator_entry_tab.scope_id%TYPE,
   visibility                fnd_navigator_entry_tab.visibility%TYPE,
   rowkey                    fnd_navigator_entry_tab.rowkey%TYPE,
   "rowid"                   rowid);


TYPE Structure_Rec IS RECORD
  (parent_entry_name         fnd_navigator_structure_tab.parent_entry_name%TYPE,
   child_entry_name          fnd_navigator_structure_tab.child_entry_name%TYPE,
   client_origin             fnd_navigator_structure_tab.client_origin%TYPE,
   ordinal                   fnd_navigator_structure_tab.ordinal%TYPE,
   layer_no                  fnd_navigator_structure_tab.layer_no%TYPE,
   scope_id                  fnd_navigator_structure_tab.scope_id%TYPE,
   visibility                fnd_navigator_structure_tab.visibility%TYPE,
   hidden                    fnd_navigator_structure_tab.hidden%TYPE,
   rowkey                    fnd_navigator_structure_tab.rowkey%TYPE,
   "rowid"                   rowid);


TYPE Navigator_Rec IS RECORD
  (projection                VARCHAR2(200),
   client                    VARCHAR2(200),
   id                        NUMBER,
   scope_id                  VARCHAR2(100),
   name                      VARCHAR2(250),
   parent_id                 NUMBER,
   label                     VARCHAR2(250),
   page_type                 VARCHAR2(250),
   page                      VARCHAR2(250),
   dynamic_records           VARCHAR2(250),
   filter                    VARCHAR2(2000),
   sort_order                NUMBER,
   selector                  VARCHAR2(250),
   action                    VARCHAR2(250),
   entry_granted             VARCHAR2(5),
   context                   VARCHAR2(100),
   home_for_entity           VARCHAR2(30),
   entityset_context         VARCHAR2(2000),
   hidden                    VARCHAR2(5)
 );


TYPE Navigator_Rec_Set IS TABLE OF Navigator_Rec;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- NOTE! Temporary solution, retrieveing the Context within the Navigator structure to keep backward compability.
-- This needs to be moved, letting the client FW use the dedicated FrameworkServices.GetHomePageList() information. /Rakuse
PROCEDURE Append_Homepage_Info___(
   rec_ IN OUT NOCOPY Navigator_Rec)
IS
   homepage_ fnd_client_homepage_tab%ROWTYPE;
   
   CURSOR get_context IS
      SELECT *
      FROM   fnd_client_homepage_tab
      WHERE  client = rec_.client
      AND    page = rec_.page;
      
   CURSOR get_logical_unit IS
      SELECT used_lu
      FROM  fnd_proj_entity
      WHERE projection_name = rec_.projection
      AND   entity_name     = homepage_.home_for_entity;
BEGIN
   OPEN get_context;
   FETCH get_context INTO homepage_;
   IF (get_context%NOTFOUND) THEN
      CLOSE get_context;
      RETURN;   
   END IF;
   CLOSE get_context;
   
   rec_.entityset_context := homepage_.context;
   
   IF (rec_.home_for_entity IS NOT NULL AND
       Dictionary_Sys.Logical_Unit_Is_Active_Num(rec_.home_for_entity) = 1) THEN
      -- Explicitly defined home_for_entity for the navigator entry. It it's a valid entity, use it!
      RETURN;
   END IF;

   -- Otherwise, check (and use) the home_for_entity from the homepage registration.   
   OPEN get_logical_unit;
   FETCH get_logical_unit INTO rec_.home_for_entity;
   CLOSE get_logical_unit;            
END Append_Homepage_Info___;

FUNCTION Get_Navigation_Rec___ (
   entry_name_ IN VARCHAR2,
   scope_id_   IN VARCHAR2,
   layer_no_   IN NUMBER ) RETURN Entry_Rec
IS
   rec_ Entry_Rec;
BEGIN
   IF entry_name_ IS NULL
      OR scope_id_ IS NULL
      OR layer_no_ IS NULL THEN
      RETURN NULL;
   END IF;
   SELECT
      entry_name,
      label,
      entry_type,
      entry_command,
      client_origin,
      projection,
      selector,
      action,
      filter,
      layer_no,
      context,
      home_for_entity,
      scope_id,
      visibility,
      rowkey,
      rowid
    INTO rec_
    FROM fnd_navigator_entry_tab
   WHERE entry_name = entry_name_
     AND scope_id = scope_id_
     AND layer_no = layer_no_;
   RETURN rec_;
END Get_Navigation_Rec___;


FUNCTION Get_Structure_Rec___ (
   parent_entry_name_ IN VARCHAR2,
   child_entry_name_ IN VARCHAR2,
   scope_id_   IN VARCHAR2,
   layer_no_   IN NUMBER ) RETURN Structure_Rec
IS
   rec_ Structure_Rec;
BEGIN
   IF parent_entry_name_ IS NULL
      OR child_entry_name_ IS NULL
      OR scope_id_ IS NULL
      OR layer_no_ IS NULL THEN
      RETURN NULL;
   END IF;
   SELECT
      parent_entry_name,
      child_entry_name,
      client_origin,
      ordinal,
      layer_no,
      scope_id,
      visibility,
      hidden,
      rowkey,
      rowid
    INTO rec_
    FROM fnd_navigator_structure_tab
   WHERE parent_entry_name = parent_entry_name_
     AND child_entry_name = child_entry_name_
     AND scope_id = scope_id_
     AND layer_no = layer_no_;
   RETURN rec_;
END Get_Structure_Rec___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


PROCEDURE Edit_Navigation_ (
   entry_type_ IN VARCHAR2,
   new_rec_ Entry_Rec )
IS
   entry_ fnd_navigator_entry_tab%ROWTYPE;
   old_rec_ Entry_Rec;
BEGIN
   old_rec_ := Get_Navigation_Rec___(new_rec_.entry_name, new_rec_.scope_id, new_rec_.layer_no );
   entry_.entry_type      := entry_type_;
   entry_.entry_name      := new_rec_.entry_name;
   entry_.label           := new_rec_.label;
   entry_.entry_command   := new_rec_.entry_command;
   entry_.selector        := new_rec_.selector;
   entry_.filter          := new_rec_.filter;
   entry_.action          := new_rec_.action;
   entry_.client_origin   := new_rec_.client_origin;
   entry_.projection      := new_rec_.projection;
   entry_.layer_no        := new_rec_.layer_no;
   entry_.scope_id        := new_rec_.scope_id;
   entry_.visibility      := NVL(new_rec_.visibility, 'DRAFT');
   entry_.rowkey          := old_rec_.rowkey;
   entry_.rowversion      := sysdate;
   UPDATE fnd_navigator_entry_tab
      SET ROW = entry_
    WHERE entry_name = new_rec_.entry_name
      AND scope_id = new_rec_.scope_id
      AND layer_no = new_rec_.layer_no;
END Edit_Navigation_;


PROCEDURE Edit_Menu_Structure_Item_ (
   new_rec_ Structure_Rec )
IS
   struct_  fnd_navigator_structure_tab%ROWTYPE;
   old_rec_ Structure_Rec;
BEGIN
   old_rec_ := Get_Structure_Rec___(new_rec_.parent_entry_name, new_rec_.child_entry_name, new_rec_.scope_id, new_rec_.layer_no );
   struct_.parent_entry_name := new_rec_.parent_entry_name;
   struct_.child_entry_name  := new_rec_.child_entry_name;
   struct_.client_origin     := new_rec_.client_origin;
   struct_.ordinal           := NVL(new_rec_.ordinal, old_rec_.ordinal);
   struct_.layer_no          := new_rec_.layer_no;
   struct_.scope_id          := NVL(new_rec_.scope_id,'global');
   struct_.visibility        := NVL(new_rec_.visibility, 'DRAFT');
   struct_.hidden            := NVL(new_rec_.hidden, Fnd_Boolean_API.DB_FALSE);
   struct_.rowversion        := sysdate;
   struct_.rowkey            := old_rec_.rowkey;
   UPDATE fnd_navigator_structure_tab
      SET ROW = struct_
    WHERE parent_entry_name = new_rec_.parent_entry_name
      AND child_entry_name = new_rec_.child_entry_name
      AND scope_id = NVL(new_rec_.scope_id,'global')
      AND layer_no = new_rec_.layer_no;
END Edit_Menu_Structure_Item_;


FUNCTION Get_Navigation_ (
   entry_name_ IN VARCHAR2,
   scope_id_   IN VARCHAR2,
   layer_no_   IN NUMBER ) RETURN Entry_Rec
IS
BEGIN
   RETURN Get_Navigation_Rec___(entry_name_, scope_id_, layer_no_);
END Get_Navigation_;


FUNCTION Get_Menu_Structure_Item_ (
   parent_entry_name_ IN VARCHAR2,
   child_entry_name_  IN VARCHAR2,
   scope_id_          IN VARCHAR2,
   layer_no_          IN NUMBER ) RETURN Structure_Rec
IS
BEGIN
   RETURN Get_Structure_Rec___(parent_entry_name_, child_entry_name_, scope_id_, layer_no_);
END Get_Menu_Structure_Item_;


PROCEDURE Delete_Navigation_ (
   rec_ Entry_Rec )
IS
BEGIN
   DELETE
     FROM fnd_navigator_entry_tab
    WHERE entry_name = rec_.entry_name
      AND scope_id = rec_.scope_id
      AND layer_no = rec_.layer_no;
END Delete_Navigation_;


PROCEDURE Delete_Menu_Structure_Item_ (
   rec_ Structure_Rec )
IS
BEGIN
   DELETE
     FROM fnd_navigator_structure_tab
    WHERE parent_entry_name = rec_.parent_entry_name
      AND child_entry_name = rec_.child_entry_name
      AND scope_id = rec_.scope_id
      AND layer_no = rec_.layer_no;
END Delete_Menu_Structure_Item_;

PROCEDURE Remove_Draft_Configurations_ (
   scope_id_        IN VARCHAR2)
IS
BEGIN

   DELETE FROM FND_NAVIGATOR_ENTRY_TAB
   WHERE scope_id = scope_id_ AND layer_no = 90;

   DELETE FROM FND_NAVIGATOR_STRUCTURE_TAB
   WHERE scope_id = scope_id_ AND layer_no = 90;

END Remove_Draft_Configurations_;


FUNCTION Load_Navigator_(navigator_type_ IN VARCHAR2 DEFAULT NULL,
                         scope_id_       IN VARCHAR2 DEFAULT NULL) RETURN Navigator_Rec_Set PIPELINED
IS
   CURSOR get_rows_global IS
      SELECT
            projection                projection,
            client                    client,
            id                        id,
            scope_id                  scope_id,
            NAME                      name,
            parent_id                 parent_id,
            label                     label,
            page_type                 page_type,
            page                      page,
            entry_type                entry_type,
            dynamic_records           dynamic_records,
            filter                    filter,
            sort_order                sort_order,
            selector                  selector,
            action                    action,
            context                   context,
            home_for_entity           home_for_entity,
            hidden                    hidden,
            rowkey                    objkey,
            TO_CHAR(rowversion,'YYYYMMDDHH24MISS')
                                      objversion,
            rowid                     objid
        FROM fnd_navigator_tab
       WHERE scope_id = 'global'
       ORDER BY parent_id, sort_order, SUBSTR(label, INSTR(label, ':', -1));

   CURSOR get_rows_scope IS
      SELECT
            NVL(a.projection, b.projection)            projection,
            NVL(a.client, b.client)                    client,
            NVL(a.id, b.id)                            id,
            NVL(a.scope_id, b.scope_id)                scope_id,
            NVL(a.name, b.name)                        name,
            NVL(a.parent_id, b.parent_id)              parent_id,
            NVL(a.label, b.label)                      label,
            NVL(a.page_type, b.page_type)              page_type,
            NVL(a.page, b.page)                        page,
            NVL(a.entry_type, b.entry_type)            entry_type,
            NVL(a.dynamic_records, b.dynamic_records)  dynamic_records,
            NVL(a.filter, b.filter)                    filter,
            NVL(a.sort_order, b.sort_order)            sort_order,
            NVL(a.selector, b.selector)                selector,
            NVL(a.action, b.action)                    action,
            NVL(a.context, b.context)                  context,
            NVL(a.home_for_entity, b.home_for_entity)  home_for_entity,
            NVL(a.hidden, b.hidden)                    hidden,
            NVL(a.rowkey, b.rowkey)                    objkey,
            TO_CHAR(NVL(a.rowversion, b.rowversion),'YYYYMMDDHH24MISS') objversion,
            NVL(a.rowid, b.rowid)                      objid
        FROM
            (SELECT projection, client, id, scope_id, name, parent_id, label, page_type, page, entry_type, dynamic_records,
                    filter, sort_order, selector, action, context, home_for_entity, hidden, rowkey, rowversion, rowid
               FROM fnd_navigator_tab
              WHERE scope_id = scope_id_) a
        FULL OUTER JOIN
            (SELECT projection, client, id, scope_id, name, parent_id, label, page_type, page, entry_type, dynamic_records,
                    filter, sort_order, selector, action, context, home_for_entity, hidden, rowkey, rowversion, rowid
               FROM fnd_navigator_tab c
              WHERE scope_id = 'global' AND NOT EXISTS (SELECT 1
                                                          FROM fnd_navigator_tab d
                                                         WHERE c.id = d.id AND d.scope_id = scope_id_)) b
          ON a.id = b.id
       ORDER BY parent_id, sort_order, SUBSTR(label, INSTR(label, ':', -1));

   TYPE result_set IS TABLE OF get_rows_global%ROWTYPE;
   result_set_         result_set;
   navigator_rec_      Navigator_Rec;
   select_record_      BOOLEAN:=FALSE;
BEGIN
   IF scope_id_ IS NULL OR scope_id_ = 'global' THEN
      OPEN get_rows_global;
      FETCH get_rows_global BULK COLLECT INTO result_set_;
      CLOSE get_rows_global;
   ELSE
      OPEN get_rows_scope;
      FETCH get_rows_scope BULK COLLECT INTO result_set_;
      CLOSE get_rows_scope;
   END IF;

   FOR index_ IN result_set_.FIRST .. result_set_.LAST
   LOOP
      IF Fnd_Projection_Grant_API.Is_Available(result_set_(index_).projection) = 'TRUE' OR
          result_set_(index_).projection IS NULL OR
          result_set_(index_).entry_type IN ('MENU','LOBBY') THEN
      select_record_ := FALSE;
      --SOLSETFW
      IF NOT Fnd_Projection_API.Is_Active(result_set_(index_).projection) THEN
         select_record_ := FALSE;
      ELSIF (navigator_type_ = 'Main' AND INSTR(NVL(Fnd_Projection_API.Get_Categories(result_set_(index_).projection),'Users'), 'Users') > 0) THEN
         select_record_ := TRUE;
      ELSIF (navigator_type_ = 'B2B' AND INSTR(NVL(Fnd_Projection_API.Get_Categories(result_set_(index_).projection),'ExternalB2B'), 'ExternalB2B') > 0) THEN
         select_record_ := TRUE;
      ELSIF (navigator_type_ IS NULL) THEN
         select_record_ := TRUE;
      ELSE
         select_record_ := FALSE;
      END IF;

      IF select_record_ THEN
         navigator_rec_ := null;
         navigator_rec_.projection := result_set_(index_).projection;
         navigator_rec_.client := result_set_(index_).client;
         navigator_rec_.id := result_set_(index_).id;
         navigator_rec_.scope_id := result_set_(index_).scope_id;
         navigator_rec_.name := result_set_(index_).name;
         navigator_rec_.parent_id := result_set_(index_).parent_id;
         navigator_rec_.label := Model_Design_SYS.Get_Client_Translated_Text_(result_set_(index_).label);
         navigator_rec_.page_type := result_set_(index_).page_type;
         navigator_rec_.page := result_set_(index_).page;
         CASE
            WHEN result_set_(index_).entry_type = 'LOBBY' THEN
               navigator_rec_.entry_granted := Security_SYS.Is_Po_Available('lobbyPage'||result_set_(index_).page);
            WHEN result_set_(index_).entry_type IN ('ASSISTANT','PAGE','TREE','INTERNAL','EXTERNAL') THEN
               navigator_rec_.entry_granted := Fnd_Boolean_API.DB_TRUE;
            WHEN result_set_(index_).entry_type = 'MENU'
               THEN NULL;
            ELSE
               navigator_rec_.entry_granted := Fnd_Boolean_API.DB_FALSE;
         END CASE;
         navigator_rec_.dynamic_records := result_set_(index_).dynamic_records;
         navigator_rec_.filter := result_set_(index_).filter;
         navigator_rec_.sort_order := result_set_(index_).sort_order;
         navigator_rec_.selector := result_set_(index_).selector;
         navigator_rec_.action := result_set_(index_).action;
         navigator_rec_.context := result_set_(index_).context;
         navigator_rec_.hidden := result_set_(index_).hidden;
         navigator_rec_.home_for_entity := result_set_(index_).home_for_entity;
         Append_Homepage_Info___(navigator_rec_);
         PIPE ROW(navigator_rec_);
      END IF;
      END IF;
   END LOOP;
   RETURN;
END Load_Navigator_;

PROCEDURE Deploy_Navigator_Config_ (
   scope_id_    IN VARCHAR2,
   published_   IN VARCHAR2 DEFAULT 'TRUE')
IS
   TYPE draft_entries IS TABLE OF fnd_navigator_entry_tab%ROWTYPE INDEX BY PLS_INTEGER;
   TYPE draft_structs IS TABLE OF fnd_navigator_structure_tab%ROWTYPE INDEX BY PLS_INTEGER;
   draft_entries_ draft_entries;
   draft_structs_ draft_structs;

   CURSOR get_entries IS
      SELECT *
        FROM fnd_navigator_entry_tab
       WHERE scope_id = scope_id_
         AND layer_no = 90
         AND visibility = 'DRAFT';

   CURSOR get_structs IS
      SELECT *
        FROM fnd_navigator_structure_tab
       WHERE scope_id = scope_id_
         AND layer_no = 90
         AND visibility = 'DRAFT';

   PROCEDURE Clean_Published_ (
      synchronize_ IN VARCHAR2)
   IS
   BEGIN
      DELETE FROM fnd_navigator_entry_tab a
       WHERE scope_id = scope_id_
         AND layer_no = 2
         AND (synchronize_ = 'FALSE'
          OR EXISTS (SELECT 1
                       FROM fnd_navigator_entry_tab b
                      WHERE b.entry_name = a.entry_name
                        AND b.scope_id = a.scope_id
                        AND b.layer_no = 90
                        AND b.visibility IN ('DRAFT', 'REVERTED', 'DELETED')));

      DELETE FROM fnd_navigator_structure_tab a
       WHERE scope_id = scope_id_
         AND layer_no = 2
         AND (synchronize_ = 'FALSE'
          OR EXISTS (SELECT 1
                       FROM fnd_navigator_structure_tab b
                      WHERE b.parent_entry_name = a.parent_entry_name
                        AND b.child_entry_name = a.child_entry_name
                        AND b.scope_id = a.scope_id
                        AND b.layer_no = 90
                        AND b.visibility IN ('DRAFT', 'REVERTED', 'DELETED')));
   END Clean_Published_;
BEGIN
   -- General operation
   -- delete corresponding layer 2 items (if any) of the items
   -- in layer 90 that are to be published/unpublished
   Clean_Published_(published_);

   -- Remove all the shadowing rows from layer 90 that is now becoming obsolete
   DELETE FROM fnd_navigator_entry_tab
     WHERE scope_id = scope_id_
       AND layer_no = 90
       AND visibility in ('REVERTED', 'DELETED');

   DELETE FROM fnd_navigator_structure_tab
    WHERE scope_id = scope_id_
      AND layer_no = 90
      AND visibility in ('REVERTED', 'DELETED');

   -- Publish items, check for not FALSE as TRUE is default.
   -- This way anything but 'FALSE' will give a publish
   IF published_ != Fnd_Boolean_API.DB_FALSE THEN

      OPEN get_entries;
      FETCH get_entries BULK COLLECT INTO draft_entries_;
      CLOSE get_entries;

      OPEN get_structs;
      FETCH get_structs BULK COLLECT INTO draft_structs_;
      CLOSE get_structs;

      -- Update all DRAFT records to PUBLIC
      UPDATE fnd_navigator_entry_tab
         SET visibility = 'PUBLIC'
       WHERE scope_id = scope_id_
         AND layer_no = 90
         AND visibility = 'DRAFT';

      UPDATE fnd_navigator_structure_tab
         SET visibility = 'PUBLIC'
       WHERE scope_id = scope_id_
         AND layer_no = 90
         AND visibility = 'DRAFT';

      -- Copy items to layer 2 which was set to Visibility PUBLIC above
      FORALL index_ IN draft_entries_.FIRST..draft_entries_.LAST
         INSERT INTO fnd_navigator_entry_tab (
                entry_name,
                scope_id,
                layer_no,
                label,
                entry_type,
                entry_command,
                client_origin,
                projection,
                selector,
                filter,
                action,
                context,
                home_for_entity,
                visibility,
                rowversion,
                rowkey)
         VALUES (
                draft_entries_(index_).entry_name,
                draft_entries_(index_).scope_id,
                2,
                draft_entries_(index_).label,
                draft_entries_(index_).entry_type,
                draft_entries_(index_).entry_command,
                draft_entries_(index_).client_origin,
                draft_entries_(index_).projection,
                draft_entries_(index_).selector,
                draft_entries_(index_).filter,
                draft_entries_(index_).action,
                draft_entries_(index_).context,
                draft_entries_(index_).home_for_entity,
                'PUBLIC',
                draft_entries_(index_).rowversion,
                sys_guid()
                );

      FORALL index_ IN draft_structs_.FIRST..draft_structs_.LAST
         INSERT INTO fnd_navigator_structure_tab (
                parent_entry_name,
                child_entry_name,
                scope_id,
                layer_no,
                ordinal,
                client_origin,
                visibility,
                hidden,
                rowversion,
                rowkey)
         VALUES (
                draft_structs_(index_).parent_entry_name,
                draft_structs_(index_).child_entry_name,
                draft_structs_(index_).scope_id,
                2,
                draft_structs_(index_).ordinal,
                draft_structs_(index_).client_origin,
                'PUBLIC',
                draft_structs_(index_).hidden,
                draft_structs_(index_).rowversion,
                sys_guid()
                );

   -- Unpublish items
   ELSE
      -- Update all PUBLIC records to DRAFT
      UPDATE fnd_navigator_entry_tab
         SET visibility = 'DRAFT'
       WHERE scope_id = scope_id_
         AND layer_no = 90
         AND visibility = 'PUBLIC';

      UPDATE fnd_navigator_structure_tab
         SET visibility = 'DRAFT'
       WHERE scope_id = scope_id_
         AND layer_no = 90
         AND visibility = 'PUBLIC';
   END IF;

   Insert_Navigator_Entries();

END Deploy_Navigator_Config_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Insert_Navigator_Entries
IS
   entry_  fnd_navigator_tab%ROWTYPE;
   marker_ DATE := to_date('1901-01-01','YYYY-MM-DD');
   CURSOR Generate_Navigator_Records IS
      SELECT DISTINCT decode(s.parent_entry_name,'0',0,ora_hash(sys_connect_by_path(s.parent_entry_name, '/'),2147483647)) parent_id,
             ora_hash('/0'||sys_connect_by_path(s.child_entry_name, '/'),2147483647) id,
             s.ordinal,
             c.entry_name,
             c.scope_id,
             c.label,
             c.entry_type,
             c.entry_command,
             c.client_origin,
             c.projection,
             c.selector,
             c.rowversion,
             c.action,
             c.filter,
             c.context,
             c.home_for_entity,
             s.hidden
        FROM fnd_navigator_structure_tab s,
             fnd_navigator_entry_tab c
       WHERE c.entry_name = s.child_entry_name
         AND s.scope_id = c.scope_id
         AND s.layer_no = (SELECT max(a.layer_no)
                             FROM fnd_navigator_structure_tab a
                            WHERE a.parent_entry_name = s.parent_entry_name
                              AND a.child_entry_name = s.child_entry_name
                              AND a.scope_id = s.scope_id
                              AND a.layer_no <> 90
                              AND a.visibility = 'PUBLIC')
         AND c.layer_no = (SELECT max(b.layer_no)
                             FROM fnd_navigator_entry_tab b
                            WHERE b.entry_name = c.entry_name
                              AND b.scope_id = s.scope_id
                              AND b.layer_no <> 90
                              AND b.visibility = 'PUBLIC')
     CONNECT BY s.parent_entry_name = PRIOR s.child_entry_name
       START WITH s.parent_entry_name = '0';
BEGIN
   DELETE FROM fnd_navigator_tab
   WHERE rowversion = marker_;
   -- Generate new entries from all loaded clients
   FOR rec_ IN Generate_Navigator_Records LOOP
      entry_.id              := rec_.id;
      entry_.scope_id        := rec_.scope_id;
      entry_.name            := rec_.entry_name;
      entry_.parent_id       := rec_.parent_id;
      entry_.label           := rec_.label;
      entry_.dynamic_records := NULL;
      entry_.page_type       := CASE rec_.entry_type WHEN 'MENU' THEN NULL ELSE '/'||initcap(rec_.entry_type) END;
      entry_.entry_type      := rec_.entry_type;
      entry_.projection      := rec_.projection;
      entry_.client          := rec_.client_origin;
      entry_.page            := rec_.entry_command;
      entry_.sort_order      := rec_.ordinal;
      entry_.selector        := rec_.selector;
      entry_.filter          := rec_.filter;
      entry_.action          := rec_.action;
      entry_.context         := rec_.context;
      entry_.home_for_entity := rec_.home_for_entity;
      entry_.hidden          := rec_.hidden;
      entry_.rowversion      := marker_;
      INSERT INTO fnd_navigator_tab VALUES entry_;
    END LOOP;
 END Insert_Navigator_Entries;


PROCEDURE Clean_Navigation_For_Client (
   client_ IN VARCHAR2,
   layer_no_ IN NUMBER DEFAULT 1 )
IS
BEGIN
   DELETE FROM fnd_navigator_entry_tab
      WHERE client_origin = client_
      AND   layer_no = layer_no_;
   
   DELETE FROM fnd_navigator_structure_tab
      WHERE client_origin = client_
      AND   layer_no = layer_no_;
      
   DELETE FROM fnd_client_homepage_tab
      WHERE client = client_;

END Clean_Navigation_For_Client;


PROCEDURE Add_Menu (
   client_              IN VARCHAR2,
   item_                IN VARCHAR2,
   projection_          IN VARCHAR2,
   label_               IN VARCHAR2,
   layer_no_            IN NUMBER DEFAULT 1,
   scope_id_            IN VARCHAR2 DEFAULT 'global',
   visibility_          IN VARCHAR2 DEFAULT NULL,
   def_modified_date_   IN DATE DEFAULT NULL)
IS
   entry_ fnd_navigator_entry_tab%ROWTYPE;
BEGIN
   entry_.entry_type      := 'MENU';
   entry_.entry_name      := client_||'.'||item_;
   entry_.label           := label_;
   entry_.client_origin   := client_;
   entry_.projection      := projection_;
   entry_.layer_no        := layer_no_;
   entry_.scope_id        := NVL(scope_id_,'global');
   IF (layer_no_ = 1) THEN
      entry_.visibility   := 'PUBLIC';
   ELSE
      entry_.visibility   := NVL(visibility_, 'DRAFT');
   END IF;
   entry_.rowversion      :=  NVL(def_modified_date_,sysdate);
   INSERT INTO fnd_navigator_entry_tab VALUES entry_;
END Add_Menu;


PROCEDURE Add_Page_Navigation (
   client_              IN VARCHAR2,
   item_                IN VARCHAR2,
   projection_          IN VARCHAR2,
   label_               IN VARCHAR2,
   page_name_           IN VARCHAR2,
   selector_            IN VARCHAR2 DEFAULT NULL,
   filter_              IN VARCHAR2 DEFAULT NULL,
   action_              IN VARCHAR2 DEFAULT NULL,
   layer_no_            IN NUMBER DEFAULT 1,
   home_for_entity_     IN VARCHAR2 DEFAULT NULL,
   scope_id_            IN VARCHAR2 DEFAULT 'global',
   visibility_          IN VARCHAR2 DEFAULT NULL,
   def_modified_date_   IN DATE DEFAULT NULL)
IS
   entry_ fnd_navigator_entry_tab%ROWTYPE;
BEGIN
   entry_.entry_type      := 'PAGE';
   entry_.entry_name      := client_||'.'||item_;
   entry_.label           := label_;
   entry_.entry_command   := page_name_;
   entry_.selector        := selector_;
   entry_.filter          := filter_;
   entry_.action          := action_;
   entry_.client_origin   := client_;
   entry_.projection      := projection_;
   entry_.layer_no        := layer_no_;
   entry_.home_for_entity := home_for_entity_;
   entry_.scope_id        := NVL(scope_id_,'global');
   IF (layer_no_ = 1) THEN
      entry_.visibility   := 'PUBLIC';
   ELSE
      entry_.visibility   := NVL(visibility_, 'DRAFT');
   END IF;
   entry_.rowversion      := NVL(def_modified_date_,sysdate);
   INSERT INTO fnd_navigator_entry_tab VALUES entry_;
END Add_Page_Navigation;


PROCEDURE Add_Lobby_Navigation (
   client_              IN VARCHAR2,
   item_                IN VARCHAR2,
   projection_          IN VARCHAR2,
   label_               IN VARCHAR2,
   lobby_guid_          IN VARCHAR2,
   layer_no_            IN NUMBER DEFAULT 1,
   scope_id_            IN VARCHAR2 DEFAULT 'global',
   visibility_          IN VARCHAR2 DEFAULT NULL,
   def_modified_date_   IN DATE DEFAULT NULL)
IS
   entry_ fnd_navigator_entry_tab%ROWTYPE;
BEGIN
   entry_.entry_type      := 'LOBBY';
   entry_.entry_name      := client_||'.'||item_;
   entry_.label           := label_;
   entry_.entry_command   := lobby_guid_;
   entry_.client_origin   := client_;
   entry_.projection      := projection_;
   entry_.layer_no        := layer_no_;
   entry_.scope_id        := NVL(scope_id_,'global');
   IF (layer_no_ = 1) THEN
      entry_.visibility   := 'PUBLIC';
   ELSE
      entry_.visibility   := NVL(visibility_, 'DRAFT');
   END IF;
   entry_.rowversion      := NVL(def_modified_date_,sysdate);
   INSERT INTO fnd_navigator_entry_tab VALUES entry_;
END Add_Lobby_Navigation;


PROCEDURE Add_Assistant_Navigation (
   client_              IN VARCHAR2,
   item_                IN VARCHAR2,
   projection_          IN VARCHAR2,
   label_               IN VARCHAR2,
   assistant_name_      IN VARCHAR2,
   action_              IN VARCHAR2 DEFAULT NULL,
   layer_no_            IN NUMBER DEFAULT 1,
   scope_id_            IN VARCHAR2 DEFAULT 'global',
   visibility_          IN VARCHAR2 DEFAULT NULL,
   def_modified_date_   IN DATE DEFAULT NULL)
IS
   entry_ fnd_navigator_entry_tab%ROWTYPE;
BEGIN
   entry_.entry_type      := 'ASSISTANT';
   entry_.entry_name      := client_||'.'||item_;
   entry_.label           := label_;
   entry_.entry_command   := assistant_name_;
   entry_.client_origin   := client_;
   entry_.action          := action_;
   entry_.projection      := projection_;
   entry_.layer_no        := layer_no_;
   entry_.scope_id        := NVL(scope_id_,'global');
   IF (layer_no_ = 1) THEN
      entry_.visibility   := 'PUBLIC';
   ELSE
      entry_.visibility   := NVL(visibility_, 'DRAFT');
   END IF;
   entry_.rowversion      := NVL(def_modified_date_,sysdate);
   INSERT INTO fnd_navigator_entry_tab VALUES entry_;
END Add_Assistant_Navigation;


PROCEDURE Add_External_Navigation (
   client_              IN VARCHAR2,
   item_                IN VARCHAR2,
   projection_          IN VARCHAR2,
   label_               IN VARCHAR2,
   url_                 IN VARCHAR2,
   layer_no_            IN NUMBER DEFAULT 1,
   scope_id_            IN VARCHAR2 DEFAULT 'global',
   visibility_          IN VARCHAR2 DEFAULT NULL,
   def_modified_date_   IN DATE DEFAULT NULL)
IS
   entry_ fnd_navigator_entry_tab%ROWTYPE;
BEGIN
   entry_.entry_type      := 'EXTERNAL';
   entry_.entry_name      := client_||'.'||item_;
   entry_.label           := label_;
   entry_.entry_command   := url_;
   entry_.client_origin   := client_;
   entry_.projection      := projection_;
   entry_.layer_no        := layer_no_;
   entry_.scope_id        := NVL(scope_id_,'global');
   IF (layer_no_ = 1) THEN
      entry_.visibility   := 'PUBLIC';
   ELSE
      entry_.visibility   := NVL(visibility_, 'DRAFT');
   END IF;
   entry_.rowversion      := NVL(def_modified_date_,sysdate);
   INSERT INTO fnd_navigator_entry_tab VALUES entry_;
END Add_External_Navigation;



PROCEDURE Add_Internal_Navigation (
   client_              IN VARCHAR2,
   item_                IN VARCHAR2,
   projection_          IN VARCHAR2,
   label_               IN VARCHAR2,
   url_                 IN VARCHAR2,
   layer_no_            IN NUMBER DEFAULT 1,
   scope_id_            IN VARCHAR2 DEFAULT 'global',
   visibility_          IN VARCHAR2 DEFAULT NULL,
   def_modified_date_   IN DATE DEFAULT NULL )
IS
   entry_ fnd_navigator_entry_tab%ROWTYPE;
BEGIN
   entry_.entry_type      := 'INTERNAL';
   entry_.entry_name      := client_||'.'||item_;
   entry_.label           := label_;
   entry_.entry_command   := url_;
   entry_.client_origin   := client_;
   entry_.projection      := projection_;
   entry_.layer_no        := layer_no_;
   entry_.scope_id        := NVL(scope_id_,'global');
   IF (layer_no_ = 1) THEN
      entry_.visibility   := 'PUBLIC';
   ELSE
      entry_.visibility   := NVL(visibility_, 'DRAFT');
   END IF;
   entry_.rowversion      := NVL(def_modified_date_,sysdate);
   INSERT INTO fnd_navigator_entry_tab VALUES entry_;
END Add_Internal_Navigation;


PROCEDURE Add_Report_Navigation (
   client_              IN VARCHAR2,
   item_                IN VARCHAR2,
   projection_          IN VARCHAR2,
   label_               IN VARCHAR2,
   report_name_         IN VARCHAR2,
   layer_no_            IN NUMBER DEFAULT 1,
   scope_id_            IN VARCHAR2 DEFAULT 'global',
   visibility_          IN VARCHAR2 DEFAULT NULL,
   def_modified_date_   IN DATE DEFAULT NULL)
IS
   entry_ fnd_navigator_entry_tab%ROWTYPE;
BEGIN
   entry_.entry_type      := 'REPORT';
   entry_.entry_name      := client_||'.'||item_;
   entry_.label           := label_;
   entry_.entry_command   := report_name_;
   entry_.client_origin   := client_;
   entry_.projection      := projection_;
   entry_.layer_no        := layer_no_;
   entry_.scope_id        := NVL(scope_id_,'global');
   IF (layer_no_ = 1) THEN
      entry_.visibility   := 'PUBLIC';
   ELSE
      entry_.visibility   := NVL(visibility_, 'DRAFT');
   END IF;
   entry_.rowversion      := NVL(def_modified_date_,sysdate);
   INSERT INTO fnd_navigator_entry_tab VALUES entry_;
END Add_Report_Navigation;


PROCEDURE Add_Top_Menu_Item (
   client_              IN VARCHAR2,
   child_               IN VARCHAR2,
   child_item_          IN VARCHAR2,
   ordinal_             IN NUMBER,
   layer_no_            IN NUMBER DEFAULT 1,
   scope_id_            IN VARCHAR2 DEFAULT 'global',
   visibility_          IN VARCHAR2 DEFAULT NULL,
   hidden_              IN VARCHAR2 DEFAULT NULL,
   def_modified_date_   IN DATE DEFAULT NULL)
IS
   struct_  fnd_navigator_structure_tab%ROWTYPE;
BEGIN
   struct_.parent_entry_name := '0';
   struct_.child_entry_name  := child_||'.'||child_item_;
   struct_.client_origin     := client_;
   struct_.ordinal           := ordinal_;
   struct_.layer_no          := layer_no_;
   struct_.scope_id          := NVL(scope_id_,'global');
   IF (layer_no_ = 1) THEN
      struct_.visibility     := 'PUBLIC';
   ELSE
      struct_.visibility     := NVL(visibility_, 'DRAFT');
   END IF;
   IF (layer_no_ = 1) THEN
      struct_.hidden         := Fnd_Boolean_API.DB_FALSE;
   ELSE
      struct_.hidden         := NVL(hidden_, Fnd_Boolean_API.DB_FALSE);
   END IF;
   struct_.rowversion        := NVL(def_modified_date_,sysdate);
   INSERT INTO fnd_navigator_structure_tab VALUES struct_;
END Add_Top_Menu_Item;


PROCEDURE Add_Menu_Structure_Item (
   client_              IN VARCHAR2,
   parent_              IN VARCHAR2,
   parent_item_         IN VARCHAR2,
   child_               IN VARCHAR2,
   child_item_          IN VARCHAR2,
   ordinal_             IN NUMBER,
   layer_no_            IN NUMBER DEFAULT 1,
   scope_id_            IN VARCHAR2 DEFAULT 'global',
   visibility_          IN VARCHAR2 DEFAULT NULL,
   hidden_              IN VARCHAR2 DEFAULT NULL,
   def_modified_date_   IN DATE DEFAULT NULL)
IS
   struct_  fnd_navigator_structure_tab%ROWTYPE;
BEGIN
   struct_.parent_entry_name := parent_||'.'||parent_item_;
   struct_.child_entry_name  := child_||'.'||child_item_;
   struct_.client_origin     := client_;
   struct_.ordinal           := ordinal_;
   struct_.layer_no          := layer_no_;
   struct_.scope_id          := NVL(scope_id_,'global');
   IF (layer_no_ = 1) THEN
      struct_.visibility     := 'PUBLIC';
   ELSE
      struct_.visibility     := NVL(visibility_, 'DRAFT');
   END IF;
   struct_.hidden            := NVL(hidden_, Fnd_Boolean_API.DB_FALSE);
   struct_.rowversion        := NVL(def_modified_date_,sysdate);
   INSERT INTO fnd_navigator_structure_tab VALUES struct_;
END Add_Menu_Structure_Item;


PROCEDURE Add_Tree_Navigation (
   client_              IN VARCHAR2,
   item_                IN VARCHAR2,
   projection_          IN VARCHAR2,
   label_               IN VARCHAR2,
   tree_name_           IN VARCHAR2,
   context_             IN VARCHAR2 DEFAULT NULL,
   layer_no_            IN NUMBER DEFAULT 1,
   scope_id_            IN VARCHAR2 DEFAULT 'global',
   visibility_          IN VARCHAR2 DEFAULT NULL,
   def_modified_date_   IN DATE DEFAULT NULL,
   home_for_entity_     IN VARCHAR2 DEFAULT NULL)
IS
   entry_ fnd_navigator_entry_tab%ROWTYPE;
BEGIN
   entry_.entry_type      := 'TREE';
   entry_.entry_name      := client_||'.'||item_;
   entry_.label           := label_;
   entry_.entry_command   := tree_name_;
   entry_.client_origin   := client_;
   entry_.projection      := projection_;
   entry_.context         := context_;
   entry_.layer_no        := layer_no_;
   entry_.scope_id        := NVL(scope_id_,'global');
   IF (layer_no_ = 1) THEN
      entry_.visibility   := 'PUBLIC';
   ELSE
      entry_.visibility   := NVL(visibility_, 'DRAFT');
   END IF;
   entry_.rowversion      := NVL(def_modified_date_,sysdate);
   entry_.home_for_entity := home_for_entity_;
   INSERT INTO fnd_navigator_entry_tab VALUES entry_;
END Add_Tree_Navigation;


PROCEDURE Register_Homepage (
   client_          IN VARCHAR2,
   page_            IN VARCHAR2,
   home_for_entity_ IN VARCHAR2,
   context_         IN VARCHAR2 DEFAULT NULL)
IS
   homepage_ fnd_client_homepage_tab%ROWTYPE;
BEGIN
   homepage_.client          := client_;
   homepage_.page            := page_;
   homepage_.home_for_entity := home_for_entity_;
   homepage_.context         := context_;
   homepage_.rowversion      := sysdate;   
   INSERT INTO fnd_client_homepage_tab VALUES homepage_;
END Register_Homepage;


FUNCTION Get_Next_Child_Ordinal (
   origin_ IN VARCHAR2,
   name_ IN VARCHAR2,
   layer_no_ IN NUMBER ) RETURN VARCHAR2
IS
   max_child_ordinal_ NUMBER;
BEGIN
   SELECT nvl(max(ordinal),0)+1 INTO max_child_ordinal_ FROM fnd_navigator_structure_tab WHERE parent_entry_name = origin_ || '.' || name_ AND layer_no = layer_no_;
   RETURN max_child_ordinal_;
END Get_Next_Child_Ordinal;


PROCEDURE Validate_Parent_Menu(
   parent_name_ IN VARCHAR2,
   parent_origin_ IN VARCHAR2 )
IS
   navigator_entry_count_ NUMBER;
   navigator_structure_count_ NUMBER;

BEGIN
   SELECT  count(*) INTO navigator_entry_count_ FROM fnd_navigator_entry_tab WHERE entry_name = parent_origin_ || '.' || parent_name_ AND entry_type = 'MENU';
   IF(navigator_entry_count_ = 0) THEN
      Error_SYS.Appl_General(lu_name_, 'MENU_NOT_EXIST: Parent menu does not exist.');
   END IF;

   SELECT count(*) INTO navigator_structure_count_ FROM fnd_navigator_structure_tab WHERE parent_entry_name = parent_origin_ || '.' || parent_name_;
   IF(navigator_structure_count_ = 0) THEN
      Error_SYS.Appl_General(lu_name_, 'MENU_NOT_REACHABLE: Parent menu is not available in the navigator.');
   END IF;
END Validate_Parent_Menu;
