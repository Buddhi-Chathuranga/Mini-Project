-----------------------------------------------------------------------------
--
--  Logical unit: FndRoleImpExpUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Fnd_Role_Rec                                                      IS RECORD(
   role                                                                Fnd_Role_Tab.role%TYPE,
   description                                                         Fnd_Role_Tab.description%TYPE,
   fnd_role_type                                                       Fnd_Role_Tab.fnd_role_type%TYPE,
   limited_task_user                                                   Fnd_Role_Tab.limited_task_user%TYPE
);
TYPE System_Privilege_Grant_Rec                                        IS RECORD(
   role                                                                System_Privilege_Grant_Tab.role%TYPE,
   privilege_id                                                        System_Privilege_Grant_Tab.privilege_id%TYPE
);
TYPE Fnd_Projection_Grant_Rec                                          IS RECORD(
   role                                                                Fnd_Projection_Grant_Tab.role%TYPE,
   projection                                                          Fnd_Projection_Grant_Tab.projection%TYPE
);
TYPE Fnd_Proj_Entity_Grant_Rec                                         IS RECORD(
   role                                                                Fnd_Proj_Entity_Grant_Tab.role%TYPE,
   projection                                                          Fnd_Proj_Entity_Grant_Tab.projection%TYPE,
   entity                                                              Fnd_Proj_Entity_Grant_Tab.entity%TYPE,
   cud_allowed                                                         Fnd_Proj_Entity_Grant_Tab.cud_allowed%TYPE                                                     
);
TYPE Fnd_Proj_Ent_Action_Grant_Rec                                     IS RECORD(
   role                                                                Fnd_Proj_Ent_Action_Grant_Tab.role%TYPE,
   projection                                                          Fnd_Proj_Ent_Action_Grant_Tab.projection%TYPE,
   entity                                                              Fnd_Proj_Ent_Action_Grant_Tab.entity%TYPE,
   action                                                              Fnd_Proj_Ent_Action_Grant_Tab.action%TYPE                                               
);
TYPE Fnd_Proj_Action_Grant_Rec                                         IS RECORD(
   role                                                                Fnd_Proj_Action_Grant_Tab.role%TYPE,
   projection                                                          Fnd_Proj_Action_Grant_Tab.projection%TYPE,
   action                                                              Fnd_Proj_Action_Grant_Tab.action%TYPE                                               
);
TYPE Fnd_Role_Grant_Rec                                                IS RECORD(
   role                                                                Fnd_Role_Tab.role%TYPE,
   granted_role                                                        Fnd_User_Role_Tab.role%TYPE
);
TYPE Fnd_Workflow_Grant_Rec                                            IS RECORD(
   bpa_key                                                             VARCHAR2(250),
   deployed                                                            NUMBER
);
TYPE Pres_Object_Grant_Rec                                             IS RECORD(
   po_id                                                               Pres_Object_Grant_Tab.po_id%TYPE,
   role                                                                Pres_Object_Grant_Tab.role%TYPE
);
TYPE Fnd_User_Grant_Rec                                                IS RECORD(
   identity                                                            Fnd_User_Tab.identity%TYPE,
   role                                                                Fnd_Role_Tab.role%TYPE
);
TYPE Fnd_Role_Arr                                                      IS TABLE OF Fnd_Role_Rec;
TYPE System_Privilege_Grant_Arr                                        IS TABLE OF System_Privilege_Grant_Rec;
TYPE Fnd_Projection_Grant_Arr                                          IS TABLE OF Fnd_Projection_Grant_Rec;
TYPE Fnd_Proj_Entity_Grant_Arr                                         IS TABLE OF Fnd_Proj_Entity_Grant_Rec;
TYPE Fnd_Proj_Ent_Action_Grant_Arr                                     IS TABLE OF Fnd_Proj_Ent_Action_Grant_Rec;
TYPE Fnd_Proj_Action_Grant_Arr                                         IS TABLE OF Fnd_Proj_Action_Grant_Rec;
TYPE Fnd_Role_Grant_Arr                                                IS TABLE OF Fnd_Role_Grant_Rec;
TYPE Pres_Object_Grant_Arr                                             IS TABLE OF Pres_Object_Grant_Rec;
TYPE Fnd_User_Grant_Arr                                                IS TABLE OF Fnd_User_Grant_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
FUNCTION Get_System_Privilege_Grant_Arr___ (
   role_                       System_Privilege_Grant_Tab.role%TYPE) RETURN System_Privilege_Grant_Arr
IS
   system_privilege_grant_rec_ System_Privilege_Grant_Rec;
   system_privilege_grant_arr_ System_Privilege_Grant_Arr := System_Privilege_Grant_Arr();
   CURSOR get_system_privileges IS     
      SELECT
      role,
      privilege_id
      FROM System_Privilege_Grant
      WHERE role = role_;
BEGIN
   system_privilege_grant_rec_.role := role_;
   FOR rec_ IN get_system_privileges LOOP
      system_privilege_grant_rec_.privilege_id := rec_.privilege_id;
      system_privilege_grant_arr_.extend;
      system_privilege_grant_arr_(system_privilege_grant_arr_.last) := system_privilege_grant_rec_;
   END LOOP;
   RETURN system_privilege_grant_arr_;
END Get_System_Privilege_Grant_Arr___;

FUNCTION Get_Fnd_Projection_Grant_Arr___ (
   role_                         Fnd_Projection_Grant_Tab.role%TYPE) RETURN Fnd_Projection_Grant_Arr
IS
   fnd_projection_grant_rec_     Fnd_Projection_Grant_Rec;
   fnd_projection_grant_arr_     Fnd_Projection_Grant_Arr := Fnd_Projection_Grant_Arr();
   CURSOR get_fnd_projection_grants IS     
      SELECT
      role,
      projection
      FROM Fnd_Projection_Grant
      WHERE role = role_;
BEGIN
   fnd_projection_grant_rec_.role := role_;
   FOR rec_ IN get_fnd_projection_grants LOOP
      fnd_projection_grant_rec_.projection := rec_.projection;
      fnd_projection_grant_arr_.extend;
      fnd_projection_grant_arr_(fnd_projection_grant_arr_.last) := fnd_projection_grant_rec_;
   END LOOP;
   RETURN fnd_projection_grant_arr_;
END Get_Fnd_Projection_Grant_Arr___;

FUNCTION Get_Fnd_Proj_Entity_Grant_Arr___ (
   role_                         Fnd_Proj_Entity_Grant_Tab.role%TYPE) RETURN Fnd_Proj_Entity_Grant_Arr
IS
   fnd_proj_entity_grant_rec_    Fnd_Proj_Entity_Grant_Rec;
   fnd_proj_entity_grant_arr_    Fnd_Proj_Entity_Grant_Arr := Fnd_Proj_Entity_Grant_Arr();
   CURSOR get_fnd_proj_entitiy_grants IS     
      SELECT
      role,
      projection,
      entity,
      cud_allowed_db
      FROM Fnd_Proj_Entity_Grant
      WHERE role = role_;
BEGIN
   fnd_proj_entity_grant_rec_.role := role_;
   FOR rec_ IN get_fnd_proj_entitiy_grants LOOP
      fnd_proj_entity_grant_rec_.projection := rec_.projection;
      fnd_proj_entity_grant_rec_.entity := rec_.entity;
      fnd_proj_entity_grant_rec_.cud_allowed := rec_.cud_allowed_db;
      fnd_proj_entity_grant_arr_.extend;
      fnd_proj_entity_grant_arr_(fnd_proj_entity_grant_arr_.last) := fnd_proj_entity_grant_rec_;
   END LOOP;
   RETURN fnd_proj_entity_grant_arr_;
END Get_Fnd_Proj_Entity_Grant_Arr___;

FUNCTION Get_Fnd_Proj_Ent_Action_Grant_Arr___ (
   role_                             Fnd_Proj_Ent_Action_Grant_Tab.role%TYPE) RETURN Fnd_Proj_Ent_Action_Grant_Arr
IS
   fnd_proj_ent_action_grant_rec_    Fnd_Proj_Ent_Action_Grant_Rec;
   fnd_proj_ent_action_grant_arr_    Fnd_Proj_Ent_Action_Grant_Arr := Fnd_Proj_Ent_Action_Grant_Arr();
   CURSOR get_fnd_proj_ent_action_grants IS     
      SELECT
      role,
      projection,
      entity,
      action
      FROM Fnd_Proj_Ent_Action_Grant
      WHERE role = role_;
BEGIN
   fnd_proj_ent_action_grant_rec_.role := role_;
   FOR rec_ IN get_fnd_proj_ent_action_grants LOOP
      fnd_proj_ent_action_grant_rec_.projection := rec_.projection;
      fnd_proj_ent_action_grant_rec_.entity := rec_.entity;
      fnd_proj_ent_action_grant_rec_.action :=rec_.action;
      fnd_proj_ent_action_grant_arr_.extend;
      fnd_proj_ent_action_grant_arr_(fnd_proj_ent_action_grant_arr_.last) := fnd_proj_ent_action_grant_rec_;
   END LOOP;
   RETURN fnd_proj_ent_action_grant_arr_;
END Get_Fnd_Proj_Ent_Action_Grant_Arr___;

FUNCTION Get_Fnd_Proj_Action_Grant_Arr___ (
   role_                         Fnd_Proj_Action_Grant_Tab.role%TYPE) RETURN Fnd_Proj_Action_Grant_Arr
IS
   fnd_proj_action_grant_rec_    Fnd_Proj_Action_Grant_Rec;
   fnd_proj_action_grant_arr_    Fnd_Proj_Action_Grant_Arr := Fnd_Proj_Action_Grant_Arr();
   CURSOR get_fnd_proj_action_grants IS     
      SELECT
      role,
      projection,
      action
      FROM Fnd_Proj_Action_Grant
      WHERE role = role_;
BEGIN
   fnd_proj_action_grant_rec_.role := role_;
   FOR rec_ IN get_fnd_proj_action_grants LOOP
      fnd_proj_action_grant_rec_.projection := rec_.projection;
      fnd_proj_action_grant_rec_.action := rec_.action;
      fnd_proj_action_grant_arr_.extend;
      fnd_proj_action_grant_arr_(fnd_proj_action_grant_arr_.last) := fnd_proj_action_grant_rec_;
   END LOOP;
   RETURN fnd_proj_action_grant_arr_;
END Get_Fnd_Proj_Action_Grant_Arr___;

FUNCTION Get_Fnd_Role_Grant_Arr___ (
   grantee_                    Fnd_Role_Tab.role%TYPE) RETURN Fnd_Role_Grant_Arr
IS
   fnd_role_grant_rec_         Fnd_Role_Grant_Rec;
   fnd_role_grant_arr_         Fnd_Role_Grant_Arr := Fnd_Role_Grant_Arr();
   CURSOR get_role_grants IS     
      SELECT
      grantee role,
      granted_role
      FROM Fnd_Role_Role
      WHERE grantee = grantee_;
BEGIN
   fnd_role_grant_rec_.role := grantee_;
   FOR rec_ IN get_role_grants LOOP
      fnd_role_grant_rec_.granted_role := rec_.granted_role;
      fnd_role_grant_arr_.extend;
      fnd_role_grant_arr_(fnd_role_grant_arr_.last) := fnd_role_grant_rec_;
   END LOOP;
   RETURN fnd_role_grant_arr_;
END Get_Fnd_Role_Grant_Arr___;

FUNCTION Get_Pres_Object_Grant_Arr___ (
   role_                       Pres_Object_Grant_Tab.role%TYPE,
   po_id_                      Pres_Object_Grant_Tab.po_id%TYPE) RETURN Pres_Object_Grant_Arr
IS
   pres_object_grant_rec_      Pres_Object_Grant_Rec;
   pres_object_grant_arr_      Pres_Object_Grant_Arr := Pres_Object_Grant_Arr();
   CURSOR get_pres_object_grants IS
      SELECT 
      role,
      po_id 
      FROM Pres_Object_Grant
      WHERE po_id_ IN ('lobbyPage','lobbyElement','lobbyDataSource') AND role = role_ AND po_id LIKE po_id_||'%';
BEGIN
   pres_object_grant_rec_.role := role_;
   FOR rec_ IN get_pres_object_grants LOOP
      pres_object_grant_arr_.extend;
      pres_object_grant_rec_.po_id := rec_.po_id;
      pres_object_grant_arr_(pres_object_grant_arr_.last) := pres_object_grant_rec_;
   END LOOP;
   RETURN pres_object_grant_arr_;
END Get_Pres_Object_Grant_Arr___;

FUNCTION Fnd_Granted_Role_Exists___(
   grantee_                   Fnd_User_Role_Tab.identity%TYPE,
   granted_role_              Fnd_User_Role_Tab.role%TYPE) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (grantee_ IS NULL OR granted_role_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  fnd_role_role
      WHERE grantee = grantee_
      AND granted_role = granted_role_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      RETURN TRUE;
END Fnd_Granted_Role_Exists___;

FUNCTION Get_Fnd_User_Grant_Arr___ (
   role_                    Fnd_Role_Tab.role%TYPE) RETURN Fnd_User_Grant_Arr
IS
   fnd_user_grant_rec_         Fnd_User_Grant_Rec;
   fnd_user_grant_arr_         Fnd_User_Grant_Arr := Fnd_User_Grant_Arr();
   CURSOR get_user_grants IS     
      SELECT
      identity,
      role
      FROM Fnd_User_Role
      WHERE role = role_;
BEGIN
   fnd_user_grant_rec_.role := role_;
   FOR rec_ IN get_user_grants LOOP
      fnd_user_grant_rec_.identity := rec_.identity;
      fnd_user_grant_arr_.extend;
      fnd_user_grant_arr_(fnd_user_grant_arr_.last) := fnd_user_grant_rec_;
   END LOOP;
   RETURN fnd_user_grant_arr_;
END Get_Fnd_User_Grant_Arr___;

FUNCTION Fnd_User_Grant_Exists___(
   identity_          Fnd_User_Role_Tab.identity%TYPE,
   role_              Fnd_User_Role_Tab.role%TYPE) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (identity_ IS NULL OR role_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  fnd_user_role
      WHERE identity = identity_
      AND role = role_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      RETURN TRUE;
END Fnd_User_Grant_Exists___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_Aurena_Hash___(
   role_ IN VARCHAR2) RETURN VARCHAR2
IS
   hash_ VARCHAR2(2000);
   -- Corresponds to select from VIEW FND_ROLE_HASH w/o IEE objects given a Permission Set
   CURSOR get_hash IS
      -- Customized version of VIEW FND_ROLE_CONTENT excluding IEE objects
      SELECT sum(ora_hash(object_type || '^' || object)) FROM (
         SELECT b.grantee as role, 'ROLE' as object_type, b.granted_role as object FROM fnd_role_role b WHERE grantee_type = 'ROLE' 
         UNION 
/* 
         SELECT ROLE as role, 'PRES_OBJECT' as object_type, po_id as object FROM pres_object_grant 
         WHERE po_id LIKE 'cpg%' -- custom pages 
         OR po_id LIKE 'tbw%' -- table windows 
         OR po_id LIKE 'frm%' -- detail windows 
         UNION 
*/ 
         SELECT ROLE as role, 'PROJECTION' as object_type, projection as object FROM fnd_projection_grant 
      ) 
   WHERE role = role_ 
   GROUP BY role;

BEGIN
   OPEN get_hash;
   FETCH get_hash INTO hash_;
   CLOSE get_hash;
   RETURN hash_;
END Get_Aurena_Hash___;

FUNCTION Export_Xml_Clob__(
   role_ IN VARCHAR2, 
   user_grants_ IN BOOLEAN DEFAULT FALSE) RETURN CLOB
IS
   date_format_ VARCHAR2(100) := Client_SYS.date_format_;   
   stmt_ VARCHAR2(32000);
   stmt_select_ VARCHAR2(32000) := '
SELECT
   role,
   description,
   to_char(created, '''||date_format_||''') as created,
   fnd_role_type_db as fnd_role_type,
   nvl(limited_task_user, ''FALSE'') as limited_task_user,
   CURSOR(
      select
         privilege_id
      from system_privilege_grant spg
      where spg.role = f.role
   ) system_privilege_grants,
   CURSOR(
      select
         projection,
         CURSOR(
            select
               entity,
               cud_allowed_db as cud_allowed,
               CURSOR(
                  select
                     action
                  from fnd_proj_ent_action_grant peag
                  where peag.role = peg.role
                  and peag.projection = peg.projection
                  and peag.entity = peg.entity
               ) entity_action_grants
            from fnd_proj_entity_grant peg
            where peg.role = pg.role
            and peg.projection = pg.projection
         ) entity_grants,
         CURSOR(
            select
               action
            from fnd_proj_action_grant pag
            where pag.role = pg.role
            and pag.projection = pg.projection
         ) projection_action_grants
      from fnd_projection_grant pg
      where role = f.role
   ) projection_grants,
   CURSOR(
      select
         granted_role
      from fnd_role_role frr
      where frr.grantee = f.role
   ) role_grant, 
   CURSOR(
      select bpa_key
      from fnd_bpa_grant fbg
      where fbg.role = f.role
   ) workflow_grant,
   CURSOR(
      SELECT po_id 
      FROM pres_object_grant
      WHERE ROLE = f.role AND po_id like ''lobbyPage%'') lobby_page_grants ,
   CURSOR(
      SELECT po_id 
      FROM pres_object_grant
      WHERE ROLE = f.role AND po_id like ''lobbyElement%'') lobby_page_element_grants,
   CURSOR(
      SELECT po_id 
      FROM pres_object_grant
      WHERE ROLE = f.role AND po_id like ''lobbyDataSource%'') lobby_data_source_grants
      ';
   stmt_from_ VARCHAR2(32000) := 'FROM fnd_role f WHERE f.role = ''' || role_ || '''';
   ctx_ dbms_xmlgen.ctxHandle;
   xml_ XMLType;
   out_xml_ CLOB;
   hash_ VARCHAR2(2000);
BEGIN
   Fnd_Role_API.Exist(role_);
   
   hash_ := Get_Aurena_Hash___(role_);
   
   IF user_grants_ THEN
      stmt_select_ := stmt_select_ || ', CURSOR(
                                             select
                                                identity
                                             from fnd_user_role fur
                                             where fur.role = f.role
                                          ) user_grant ';
   END IF;
   
   stmt_ := stmt_select_ || ', ''' || hash_ || ''' hash ' || stmt_from_;
   
   Log_SYS.App_Trace(Log_SYS.debug_, 'XML Export Statement: ' || stmt_);

   ctx_ := Dbms_Xmlgen.newContext(stmt_);
   dbms_xmlgen.setNullHandling(ctx_, dbms_xmlgen.EMPTY_TAG);
   dbms_xmlgen.setRowSetTag(ctx_, 'PERMISSION_SET_EXPORT');
   dbms_xmlgen.setRowTag(ctx_, 'PERMISSION_SET');
   xml_ := dbms_xmlgen.getXMLType(ctx_);
   Dbms_Xmlgen.Closecontext(ctx_);
   Utility_SYS.Xmltype_To_Clob(out_xml_, xml_);
   RETURN out_xml_;
END Export_Xml_Clob__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Contains_Legacy_Grants (
   role_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   
   FUNCTION Check_Po_Grants (
      role_ IN VARCHAR2 ) RETURN BOOLEAN
   IS
      dummy_ NUMBER;
   BEGIN
      SELECT 1
         INTO  dummy_
         FROM  PRES_OBJECT_GRANT_TAB
         WHERE role = role_;
      RETURN TRUE;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN FALSE;
      WHEN too_many_rows THEN
        RETURN TRUE;
   END Check_Po_Grants;
   
   FUNCTION Check_Activity_Grants (
      role_ IN VARCHAR2 ) RETURN BOOLEAN
   IS
      dummy_ NUMBER;
   BEGIN
      SELECT 1
         INTO  dummy_
         FROM  ACTIVITY_GRANT_TAB
         WHERE role = role_;
      RETURN TRUE;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN FALSE;
      WHEN too_many_rows THEN
        RETURN TRUE;
   END Check_Activity_Grants;
   
   FUNCTION Check_Db_Object_Grants (
      role_ IN VARCHAR2 ) RETURN BOOLEAN
   IS
      dummy_ NUMBER;
   BEGIN
      --Checking for Db object grants except revoked methods
      SELECT 1
         INTO  dummy_
         FROM  security_sys_privs_tab
         WHERE grantee = role_;
      --Checking for revoked method grants
      SELECT 1
         INTO  dummy_
         FROM  SECURITY_SYS_TAB
         WHERE role = role_;
      RETURN TRUE;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN FALSE;
      WHEN too_many_rows THEN
        RETURN TRUE;
   END Check_Db_Object_Grants;
   
   FUNCTION Check_Ial_Object_Grants (
      role_ IN VARCHAR2 ) RETURN BOOLEAN
   IS
      dummy_ NUMBER;
   BEGIN
      SELECT 1
         INTO  dummy_
         FROM  all_tab_privs
         WHERE table_schema = Fnd_Setting_API.Get_Value('IAL_USER')
         AND grantee = role_;
         
      RETURN TRUE;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN FALSE;
      WHEN too_many_rows THEN
        RETURN TRUE;
   END Check_Ial_Object_Grants;

BEGIN
   IF Check_Po_Grants(role_) THEN
      RETURN 'TRUE';
   ELSIF Check_Activity_Grants(role_) THEN
      RETURN 'TRUE';
   ELSIF Check_Db_Object_Grants(role_) THEN
      RETURN 'TRUE';
   ELSIF Check_Ial_Object_Grants(role_) THEN
      RETURN 'TRUE';
   END IF;
   RETURN 'FALSE';
END Contains_Legacy_Grants;
   
FUNCTION Export_Roles_Zip(
   roles_ IN VARCHAR2, 
   user_grants_ IN BOOLEAN DEFAULT FALSE) RETURN BLOB
IS
   zip_ BLOB;
   roles_table_ Utility_SYS.STRING_TABLE;
   roles_count_ NUMBER;

   filename_arr_ Fnd_Zip_Util_String_Table := Fnd_Zip_Util_String_Table();
   filecontent_arr_ Fnd_Zip_Util_Blob_Table := Fnd_Zip_Util_Blob_Table();
BEGIN
   Dbms_lob.Createtemporary(zip_, FALSE);
   
   Utility_SYS.Tokenize(roles_, ';', roles_table_, roles_count_);
   FOR i_ IN 1..roles_count_ LOOP
      filename_arr_.extend(1);
      filecontent_arr_.extend(1);
      Fnd_Role_API.Exist(roles_table_(i_));
      filename_arr_(filename_arr_.last) := roles_table_(i_) || '.xml';
      filecontent_arr_(filecontent_arr_.last) := Export_Xml(roles_table_(i_), user_grants_);
   END LOOP;
   
   Fnd_Zip_Util_API.Compress_Files(zip_, filename_arr_, filecontent_arr_);
   
   RETURN zip_;
END Export_Roles_Zip;


FUNCTION Export_Xml(
   role_ IN VARCHAR2, 
   user_grants_ IN BOOLEAN DEFAULT FALSE) RETURN BLOB
IS
BEGIN
   RETURN Utility_SYS.Clob_To_Blob(Export_Xml_Clob__(role_, user_grants_));
END Export_Xml;


FUNCTION Get_Role_From_Xml(
   xml_ IN CLOB) RETURN VARCHAR2
IS
   role_ VARCHAR2(100);
BEGIN
   SELECT EXTRACTVALUE(XMLTYPE(xml_),'/*:PERMISSION_SET_EXPORT/*:PERMISSION_SET/*:ROLE')
   INTO   role_
   FROM   dual;
   RETURN role_;
END Get_Role_From_Xml;

PROCEDURE Import_Xml(  
   import_option_       IN VARCHAR2,
   permission_set_name_ IN VARCHAR2,
   xml_                 IN CLOB,
   raise_error_         IN BOOLEAN DEFAULT TRUE,
   include_user_grants_ IN VARCHAR2 DEFAULT 'NONE')
IS
   info_ VARCHAR2(2000);
   objid_ Fnd_Role.objid%TYPE;
   objversion_ Fnd_Role.objversion%TYPE;
   attr_ VARCHAR2(32000);
   role_name_before_   VARCHAR2(100);
   record_not_exists   EXCEPTION;
   PRAGMA EXCEPTION_INIT( record_not_exists, -20111);
   record_not_exists_  BOOLEAN;
     
   CURSOR get_permission_set IS
      SELECT * FROM xmltable(
         '/PERMISSION_SET_EXPORT/PERMISSION_SET'
         passing Xmltype(xml_) COLUMNS
         
           ROLE VARCHAR2(30) path 'ROLE',
           DESCRIPTION VARCHAR2(200) path 'DESCRIPTION',
           CREATED VARCHAR2(100) path 'CREATED', -- TODO: Client_SYS.date_format_
           FND_ROLE_TYPE_DB VARCHAR2(20) path 'FND_ROLE_TYPE',
           LIMITED_TASK_USER VARCHAR2(5) path 'LIMITED_TASK_USER' -- TODO: why include this??
      );

   CURSOR get_system_privilege_grant(
      role_ System_Privilege_Grant.role%TYPE
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/SYSTEM_PRIVILEGE_GRANTS/SYSTEM_PRIVILEGE_GRANTS_ROW')
        passing Xmltype(xml_) COLUMNS
        
          PRIVILEGE_ID VARCHAR2(30) path 'PRIVILEGE_ID'
      );

   CURSOR get_projection_grant(
      role_ Fnd_Projection_Grant.role%TYPE
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/PROJECTION_GRANTS/PROJECTION_GRANTS_ROW')
        passing Xmltype(xml_) COLUMNS
        
          PROJECTION VARCHAR2(100) path 'PROJECTION'
      );

   CURSOR get_entity_grant(
      role_ Fnd_Proj_Entity_Grant.role%TYPE,
      projection_ Fnd_Proj_Entity_Grant.projection%TYPE
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/PROJECTION_GRANTS/PROJECTION_GRANTS_ROW[PROJECTION = "' || projection_ || '"]/ENTITY_GRANTS/ENTITY_GRANTS_ROW')
        passing Xmltype(xml_) COLUMNS
        
          ENTITY VARCHAR2(100) path 'ENTITY',
          CUD_ALLOWED_DB VARCHAR2(5) path 'CUD_ALLOWED'
      );
      
   CURSOR get_entity_action_grant(
      role_ Fnd_Proj_Ent_Action_Grant.role%TYPE,
      projection_ Fnd_Proj_Ent_Action_Grant.projection%TYPE,
      entity_ Fnd_Proj_Ent_Action_Grant.entity%TYPE
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/PROJECTION_GRANTS/PROJECTION_GRANTS_ROW[PROJECTION = "' || projection_ || '"]/ENTITY_GRANTS/ENTITY_GRANTS_ROW[ENTITY = "' || entity_ || '"]/ENTITY_ACTION_GRANTS/ENTITY_ACTION_GRANTS_ROW')
        passing Xmltype(xml_) COLUMNS
        
          ACTION VARCHAR2(100) path 'ACTION'
      );
      
   CURSOR get_projection_action_grant(role_ Fnd_Proj_Action_Grant.role%TYPE, projection_ Fnd_Proj_Action_Grant.projection%TYPE) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/PROJECTION_GRANTS/PROJECTION_GRANTS_ROW[PROJECTION = "' || projection_ || '"]/PROJECTION_ACTION_GRANTS/PROJECTION_ACTION_GRANTS_ROW')
        passing Xmltype(xml_) COLUMNS
        
          ACTION VARCHAR2(100) path 'ACTION'
      );

   CURSOR get_role_grant(
      role_ VARCHAR2
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/ROLE_GRANT/ROLE_GRANT_ROW')
        passing Xmltype(xml_) COLUMNS
        
          GRANTED_ROLE VARCHAR2(30) path 'GRANTED_ROLE'
      );
   $IF Component_Fndwf_SYS.INSTALLED $THEN
   CURSOR get_workflow_grant(
      role_ VARCHAR2
   ) IS
      SELECT xml_.*, NVL2(fdb.id, 'Y', 'N') deployed 
      FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/WORKFLOW_GRANT/WORKFLOW_GRANT_ROW')
        passing Xmltype(xml_) COLUMNS
        BPA_KEY VARCHAR2(30) path 'BPA_KEY'
      ) xml_
      LEFT OUTER JOIN fnd_deployed_bpa fdb 
      ON fdb.id = xml_.bpa_key;
   $END
   CURSOR get_lobby_page_grant( 
      role_ VARCHAR2
   ) IS
      SELECT xml_.*
      FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/LOBBY_PAGE_GRANTS/LOBBY_PAGE_GRANTS_ROW')
        passing Xmltype(xml_) COLUMNS
        PO_ID VARCHAR2(100)
      ) xml_ ;
   
   CURSOR get_lobby_element_grant( 
      role_ VARCHAR2
   ) IS
      SELECT xml_.*
      FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/LOBBY_PAGE_ELEMENT_GRANTS/LOBBY_PAGE_ELEMENT_GRANTS_ROW')
        passing Xmltype(xml_) COLUMNS
        PO_ID VARCHAR2(100)
      ) xml_ ;
   
   CURSOR get_lobby_data_src_grant( 
      role_ VARCHAR2
   ) IS
      SELECT xml_.*
      FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/LOBBY_DATA_SOURCE_GRANTS/LOBBY_DATA_SOURCE_GRANTS_ROW')
        passing Xmltype(xml_) COLUMNS
        PO_ID VARCHAR2(100)
      ) xml_ ;

   -- Left for backward compability making it possible to upgrade Permissions Sets exported in 21R1 (or before) and imported to 21R2.
   -- (Abanding PoId's for QuickReports, replacing them with Projections) /Rakuse
   CURSOR get_quick_report_grant( 
      role_ VARCHAR2
   ) IS
      SELECT xml_.*
      FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/QUICK_REPORT_GRANTS/QUICK_REPORT_GRANTS_ROW')
        passing Xmltype(xml_) COLUMNS
        PO_ID VARCHAR2(100)
      ) xml_ ;
    
   CURSOR get_user_grant(
      role_ VARCHAR2
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/USER_GRANT/USER_GRANT_ROW')
        passing Xmltype(xml_) COLUMNS
        
          IDENTITY VARCHAR2(30) path 'IDENTITY'
      );

   -- Backward compability function: Resolving PoId for QuickRerpots into Projection Name.
   FUNCTION Qr_Po_Id_To_Projection (
      po_id_ IN VARCHAR2) RETURN VARCHAR2
   IS
   BEGIN
      RETURN CASE WHEN po_id_ LIKE 'repQUICK_REPORT%' THEN 'QuickReport' || SUBSTR(po_id_, 16) ELSE po_id_ END;
   END Qr_Po_Id_To_Projection;

   PROCEDURE AddNew (perm_set_rec_ get_permission_set%ROWTYPE,role_name_before_ VARCHAR2)
   IS
   BEGIN
      IF Fnd_Role_API.Exists(perm_set_rec_.ROLE) THEN
         
         SELECT objid,objversion
            INTO  objid_,objversion_
            FROM  FND_ROLE
            WHERE role = perm_set_rec_.ROLE;
         
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('DESCRIPTION', perm_set_rec_.DESCRIPTION, attr_);
         Fnd_Role_API.Modify__(info_, objid_,objversion_, attr_, 'DO');
      ELSE
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
         Client_SYS.Add_To_Attr('DESCRIPTION', perm_set_rec_.DESCRIPTION, attr_);
         Client_SYS.Add_To_Attr('FND_ROLE_TYPE_DB', perm_set_rec_.FND_ROLE_TYPE_DB, attr_);
         Client_SYS.Add_To_Attr('LIMITED_TASK_USER', perm_set_rec_.LIMITED_TASK_USER, attr_);
      
         Fnd_Role_API.New__(info_, objid_, objversion_, attr_, 'DO');
      END IF;
         
      FOR grant_ IN get_system_privilege_grant(role_name_before_) LOOP
            
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
         Client_SYS.Add_To_Attr('PRIVILEGE_ID', grant_.PRIVILEGE_ID, attr_);
            
         System_Privilege_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
               --New System privilage grant one added
      END LOOP;
         
      FOR grant_ IN get_projection_grant(role_name_before_) LOOP
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
         Client_SYS.Add_To_Attr('PROJECTION', grant_.PROJECTION, attr_);
            
         BEGIN
            Fnd_Projection_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
            --New Projection grant one added
         EXCEPTION
            WHEN record_not_exists THEN
               IF (raise_error_) THEN
                  RAISE;
               END IF;
               record_not_exists_ := TRUE;
               Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
         END;
                   
         FOR entity_grant_ in get_entity_grant(role_name_before_, grant_.PROJECTION) LOOP
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
            Client_SYS.Add_To_Attr('PROJECTION', grant_.PROJECTION, attr_);
            Client_SYS.Add_To_Attr('ENTITY', entity_grant_.ENTITY, attr_);
            Client_SYS.Add_To_Attr('CUD_ALLOWED_DB', entity_grant_.CUD_ALLOWED_DB, attr_);
               
            BEGIN
               Fnd_Proj_Entity_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
               --New Projection Entity grant one added
            EXCEPTION
               WHEN record_not_exists THEN
                  IF (raise_error_) THEN
                     RAISE;
                  END IF;
                  record_not_exists_ := TRUE;
                  Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
            END;
               
            FOR entity_action_grant_ IN get_entity_action_grant(role_name_before_, grant_.PROJECTION, entity_grant_.ENTITY) LOOP
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
               Client_SYS.Add_To_Attr('PROJECTION', grant_.PROJECTION, attr_);
               Client_SYS.Add_To_Attr('ENTITY', entity_grant_.ENTITY, attr_);
               Client_SYS.Add_To_Attr('ACTION', entity_action_grant_.ACTION, attr_);
                 
               BEGIN
                  Fnd_Proj_Ent_Action_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
                  --New Projection Entity Action grant one added
               EXCEPTION
                  WHEN record_not_exists THEN
                     IF (raise_error_) THEN
                        RAISE;
                     END IF;
                     record_not_exists_ := TRUE;
                     Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
               END;
            END LOOP;
         END LOOP;
         FOR action_grant_ IN get_projection_action_grant(role_name_before_, grant_.PROJECTION) LOOP
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
            Client_SYS.Add_To_Attr('PROJECTION', grant_.PROJECTION, attr_);
            Client_SYS.Add_To_Attr('ACTION', action_grant_.ACTION, attr_);
               
            BEGIN
               Fnd_Proj_Action_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
               --New Projection Action grant one added
            EXCEPTION
               WHEN record_not_exists THEN
                  IF (raise_error_) THEN
                     RAISE;
                  END IF;
                  record_not_exists_ := TRUE;
                  Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
            END;
         END LOOP;
      END LOOP;
      
      FOR ref_grant_ IN get_role_grant(role_name_before_) LOOP
         IF NOT Fnd_Role_API.Exists(ref_grant_.GRANTED_ROLE) THEN
            Fnd_Role_API.Create__(ref_grant_.GRANTED_ROLE, 'TEMPORARY PERMISSION SET CREATED ON IMPORT. THIS WILL BE REPLACED WITH IMPORT OF ORIGINAL PERMISSION SET.', fnd_role_type_api.DB_ENDUSERROLE, 'FALSE');
         END IF;
        security_sys.Grant_Role(ref_grant_.GRANTED_ROLE,perm_set_rec_.ROLE);

      END LOOP;
      $IF Component_Fndwf_SYS.INSTALLED $THEN
      FOR workflow_grant_ IN get_workflow_grant(role_name_before_) LOOP
         IF (workflow_grant_.DEPLOYED = 'Y') THEN 
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
            Client_SYS.Add_To_Attr('BPA_KEY', workflow_grant_.BPA_KEY, attr_);
            Fnd_Bpa_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
         ELSE 
            Error_SYS.Record_General(lu_name_, 'IMPORT_WORKFLOW_PERM_SET: Workflow :P1 is not deployed to Camunda. ', workflow_grant_.BPA_KEY);
         END IF;   
      END LOOP;
      $END
      FOR lobby_pages IN get_lobby_page_grant(role_name_before_) LOOP 
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
         Client_SYS.Add_To_Attr('PO_ID', lobby_pages.PO_ID, attr_);
         BEGIN
            Pres_Object_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
         EXCEPTION
            WHEN record_not_exists THEN
               IF (raise_error_) THEN
                  RAISE;
               END IF;
               record_not_exists_ := TRUE;
               Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
         END;
      END LOOP;
      
      FOR lobby_elements IN get_lobby_element_grant(role_name_before_) LOOP 
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
         Client_SYS.Add_To_Attr('PO_ID', lobby_elements.PO_ID, attr_);
         BEGIN
            Pres_Object_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
         EXCEPTION
            WHEN record_not_exists THEN
               IF (raise_error_) THEN
                  RAISE;
               END IF;
               record_not_exists_ := TRUE;
               Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
         END;
      END LOOP;
       
      FOR lobby_data_sources IN get_lobby_data_src_grant(role_name_before_) LOOP 
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
         Client_SYS.Add_To_Attr('PO_ID', lobby_data_sources.PO_ID, attr_);
         BEGIN
            Pres_Object_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
         EXCEPTION
            WHEN record_not_exists THEN
               IF (raise_error_) THEN
                  RAISE;
               END IF;
               record_not_exists_ := TRUE;
               Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
         END;
      END LOOP;

      -- Backward compability, importing "old" sets containing PoId's for Quick Reports.
      FOR rec_ IN get_quick_report_grant(role_name_before_) LOOP
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
         Client_SYS.Add_To_Attr('PROJECTION', Qr_Po_Id_To_Projection(rec_.PO_ID), attr_);
         BEGIN
            Fnd_Projection_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
         EXCEPTION
            WHEN record_not_exists THEN
               IF (raise_error_) THEN
                  RAISE;
               END IF;
               record_not_exists_ := TRUE;
               Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
         END;
      END LOOP;
      
      IF include_user_grants_ = 'YES' THEN
         FOR user_grant_ IN get_user_grant(role_name_before_) LOOP
            IF Fnd_User_API.Exists(user_grant_.IDENTITY) THEN
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('IDENTITY', user_grant_.IDENTITY, attr_);               
               Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);

               Fnd_User_Role_API.New__(info_, objid_, objversion_, attr_, 'DO');
            ELSE
               Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR, 'User '||user_grant_.IDENTITY||' does not exists. User grant not imported.');
            END IF;
         END LOOP;
      END IF;
   END;
      
   PROCEDURE Merge (perm_set_rec_ get_permission_set%ROWTYPE,role_name_before_ VARCHAR2)
   IS
   BEGIN

      SELECT objid,objversion
         INTO  objid_,objversion_
         FROM  FND_ROLE
         WHERE role = perm_set_rec_.ROLE;
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('DESCRIPTION', perm_set_rec_.DESCRIPTION, attr_);
      Fnd_Role_API.Modify__(info_, objid_,objversion_, attr_, 'DO');    
      
      FOR grant_ IN get_system_privilege_grant(role_name_before_) LOOP            
         IF NOT(System_Privilege_Grant_API.Exists(grant_.PRIVILEGE_ID,perm_set_rec_.ROLE)) THEN   
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
            Client_SYS.Add_To_Attr('PRIVILEGE_ID', grant_.PRIVILEGE_ID, attr_);
            System_Privilege_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
         END IF;
      END LOOP;
         
      FOR grant_ IN get_projection_grant(role_name_before_) LOOP
         IF NOT(Fnd_Projection_Grant_API.Exists(grant_.PROJECTION,perm_set_rec_.ROLE)) THEN   
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
            Client_SYS.Add_To_Attr('PROJECTION', grant_.PROJECTION, attr_);
            BEGIN
               Fnd_Projection_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
            EXCEPTION
               WHEN record_not_exists THEN
                  IF (raise_error_) THEN
                     RAISE;
                  END IF;
                  record_not_exists_ := TRUE;
                  Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
            END;
         END IF;
                   
         FOR entity_grant_ in get_entity_grant(role_name_before_, grant_.PROJECTION) LOOP            
            IF NOT(Fnd_Proj_Entity_Grant_API.Exists(grant_.PROJECTION,entity_grant_.ENTITY,perm_set_rec_.ROLE)) THEN
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
               Client_SYS.Add_To_Attr('PROJECTION', grant_.PROJECTION, attr_);
               Client_SYS.Add_To_Attr('ENTITY', entity_grant_.ENTITY, attr_);
               Client_SYS.Add_To_Attr('CUD_ALLOWED_DB', entity_grant_.CUD_ALLOWED_DB, attr_);
               BEGIN
                  Fnd_Proj_Entity_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
               EXCEPTION
                  WHEN record_not_exists THEN
                     IF (raise_error_) THEN
                        RAISE;
                     END IF;
                     record_not_exists_ := TRUE;
                     Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
               END;
            END IF;
               
            FOR entity_action_grant_ IN get_entity_action_grant(role_name_before_, grant_.PROJECTION, entity_grant_.ENTITY) LOOP              
               IF NOT(Fnd_Proj_Ent_Action_Grant_API.Exists(grant_.PROJECTION,entity_grant_.ENTITY,entity_action_grant_.ACTION,perm_set_rec_.ROLE)) THEN
                  Client_SYS.Clear_Attr(attr_);
                  Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
                  Client_SYS.Add_To_Attr('PROJECTION', grant_.PROJECTION, attr_);
                  Client_SYS.Add_To_Attr('ENTITY', entity_grant_.ENTITY, attr_);
                  Client_SYS.Add_To_Attr('ACTION', entity_action_grant_.ACTION, attr_);
                  BEGIN
                    Fnd_Proj_Ent_Action_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
                  EXCEPTION
                     WHEN record_not_exists THEN
                        IF (raise_error_) THEN
                           RAISE;
                        END IF;
                        record_not_exists_ := TRUE;
                        Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
                  END;
               END IF;
            END LOOP;
         END LOOP;
         FOR action_grant_ IN get_projection_action_grant(role_name_before_, grant_.PROJECTION) LOOP            
            IF NOT(Fnd_Proj_Action_Grant_API.Exists(grant_.PROJECTION,action_grant_.ACTION,perm_set_rec_.ROLE)) THEN
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
               Client_SYS.Add_To_Attr('PROJECTION', grant_.PROJECTION, attr_);
               Client_SYS.Add_To_Attr('ACTION', action_grant_.ACTION, attr_);
               BEGIN
                  Fnd_Proj_Action_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
               EXCEPTION
                  WHEN record_not_exists THEN
                     IF (raise_error_) THEN
                        RAISE;
                     END IF;
                     record_not_exists_ := TRUE;
                     Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
               END;
            END IF;
         END LOOP;
      END LOOP;
      
      FOR ref_grant_ IN get_role_grant(role_name_before_) LOOP
         IF NOT Fnd_Role_API.Exists(ref_grant_.GRANTED_ROLE) THEN
            Fnd_Role_API.Create__(ref_grant_.GRANTED_ROLE, 'TEMPORARY PERMISSION SET CREATED ON IMPORT. THIS WILL BE REPLACED WITH IMPORT OF ORIGINAL PERMISSION SET.', fnd_role_type_api.DB_ENDUSERROLE, 'FALSE');
         END IF;
        security_sys.Grant_Role(ref_grant_.GRANTED_ROLE,perm_set_rec_.ROLE);
      END LOOP;
      $IF Component_Fndwf_SYS.INSTALLED $THEN
      FOR workflow_grant_ IN get_workflow_grant(role_name_before_) LOOP
         IF (workflow_grant_.DEPLOYED = 'Y') THEN 
            IF NOT(Fnd_Bpa_Grant_API.Exists(workflow_grant_.BPA_KEY,perm_set_rec_.ROLE)) THEN   
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
               Client_SYS.Add_To_Attr('BPA_KEY', workflow_grant_.BPA_KEY, attr_);
               Fnd_Bpa_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
            END IF;
         ELSE 
            Error_SYS.Record_General(lu_name_, 'IMPORT_WORKFLOW_PERM_SET: Workflow :P1 is not deployed to Camunda. ', workflow_grant_.BPA_KEY);
         END IF;   

      END LOOP;
      $END
      FOR lobby_pages IN get_lobby_page_grant(role_name_before_) LOOP 
         IF NOT Pres_Object_Grant_API.Exists(lobby_pages.PO_ID, perm_set_rec_.ROLE) THEN 
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
            Client_SYS.Add_To_Attr('PO_ID', lobby_pages.PO_ID, attr_);
            BEGIN
               Pres_Object_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
            EXCEPTION
               WHEN record_not_exists THEN
                  IF (raise_error_) THEN
                     RAISE;
                  END IF;
                  record_not_exists_ := TRUE;
                  Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
            END;
         END IF;
      END LOOP;
      
      FOR lobby_elements IN get_lobby_element_grant(role_name_before_) LOOP 
         IF NOT Pres_Object_Grant_API.Exists(lobby_elements.PO_ID, perm_set_rec_.ROLE) THEN 
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
            Client_SYS.Add_To_Attr('PO_ID', lobby_elements.PO_ID, attr_);
            BEGIN
               Pres_Object_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
            EXCEPTION
               WHEN record_not_exists THEN
                  IF (raise_error_) THEN
                     RAISE;
                  END IF;
                  record_not_exists_ := TRUE;
                  Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
            END;
         END IF;
      END LOOP;
       
      FOR lobby_data_sources IN get_lobby_data_src_grant(role_name_before_) LOOP 
         IF NOT Pres_Object_Grant_API.Exists(lobby_data_sources.PO_ID, perm_set_rec_.ROLE) THEN 
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
            Client_SYS.Add_To_Attr('PO_ID', lobby_data_sources.PO_ID, attr_);
            BEGIN
               Pres_Object_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
            EXCEPTION
               WHEN record_not_exists THEN
                  IF (raise_error_) THEN
                     RAISE;
                  END IF;
                  record_not_exists_ := TRUE;
                  Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
            END;
         END IF;
      END LOOP;

      -- Backward compability, importing "old" permissions sets containing PoId's for Quick Reports.
      FOR rec_ IN get_quick_report_grant(role_name_before_) LOOP
         IF NOT Fnd_Projection_Grant_API.Exists(Qr_Po_Id_To_Projection(rec_.PO_ID), perm_set_rec_.ROLE) THEN 
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);
            Client_SYS.Add_To_Attr('PROJECTION', Qr_Po_Id_To_Projection(rec_.PO_ID), attr_); 
            BEGIN
               Fnd_Projection_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
            EXCEPTION
               WHEN record_not_exists THEN
                  IF (raise_error_) THEN
                     RAISE;
                  END IF;
                  record_not_exists_ := TRUE;
                  Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR,SQLERRM || ' -> ' || Fnd_Context_SYS.Get_Value('ERROR_FORMATTED_KEY'));
            END;
         END IF;
      END LOOP;
      
      IF include_user_grants_ = 'YES' THEN
         FOR user_grant_ IN get_user_grant(role_name_before_) LOOP
            IF Fnd_User_API.Exists(user_grant_.IDENTITY) THEN
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('IDENTITY', user_grant_.IDENTITY, attr_);               
               Client_SYS.Add_To_Attr('ROLE', perm_set_rec_.ROLE, attr_);

               Fnd_User_Role_API.New__(info_, objid_, objversion_, attr_, 'DO');
            ELSE
               Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_ERROR, 'User '||user_grant_.IDENTITY||' does not exists. User grant not imported.');
            END IF;
         END LOOP;
      END IF;
   END;
BEGIN
   role_name_before_ := NULL;
   record_not_exists_:= FALSE;
   FOR set_ in get_permission_set LOOP
      role_name_before_ := set_.ROLE;
      set_.ROLE := permission_set_name_;
      IF import_option_ = 'REPLACE' THEN
         Security_SYS.Revoke_Role_Grants(permission_set_name_);
         IF include_user_grants_ = 'YES' THEN
            Security_SYS.Revoke_User_Role_Grants(permission_set_name_);
         END IF;
         AddNew(set_,role_name_before_);
      ELSIF import_option_ = 'ADD' THEN
         --This is to Merge down temporaly added permission set 
         --during the import of the PS grant structure, with new actual PS.
         IF Fnd_Role_API.Exists(set_.ROLE) THEN
            Merge(set_,role_name_before_);
         ELSE
            AddNew(set_,role_name_before_);
         END IF;
         
      ELSIF import_option_ = 'MERGE' THEN
         Merge(set_,role_name_before_);
      END IF;
   END LOOP;
   IF (record_not_exists_) THEN
      Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_INFO,' ');
      Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_INFO,'****** WARINING! permission set/s imported ignoring above listed non existing object/s. ******');
      Application_Logger_API.Log('PERMISSION_SET_IMPORT',Application_Logger_API.CATEGORY_INFO,' ');
   END IF;
END Import_Xml;

PROCEDURE Get_Diff_From_Xml(
   fnd_role_arr_                             OUT                  Fnd_Role_Arr,
   system_privilege_grant_arr_               OUT                  System_Privilege_Grant_Arr,
   projection_grant_arr_                     OUT                  Fnd_Projection_Grant_Arr,
   entity_grant_arr_                         OUT                  Fnd_Proj_Entity_Grant_Arr,
   entity_action_grant_arr_                  OUT                  Fnd_Proj_Ent_Action_Grant_Arr,
   action_grant_arr_                         OUT                  Fnd_Proj_Action_Grant_Arr,
   role_grant_arr_                           OUT                  Fnd_Role_Grant_Arr,
   user_grant_arr_                           OUT                  Fnd_User_Grant_Arr,
   lobby_page_grant_arr_                     OUT                  Pres_Object_Grant_Arr,
   lobby_element_grant_arr_                  OUT                  Pres_Object_Grant_Arr,
   lobby_data_src_grant_arr_                 OUT                  Pres_Object_Grant_Arr,
   workflow_grant_rec_                       OUT                  Fnd_Workflow_Grant_Rec,
   missing_system_privilege_grant_arr_       OUT                  System_Privilege_Grant_Arr,
   missing_projection_grant_arr_             OUT                  Fnd_Projection_Grant_Arr,
   missing_entity_grant_arr_                 OUT                  Fnd_Proj_Entity_Grant_Arr,
   missing_entity_action_grant_arr_          OUT                  Fnd_Proj_Ent_Action_Grant_Arr,
   missing_action_grant_arr_                 OUT                  Fnd_Proj_Action_Grant_Arr,
   missing_role_grant_arr_                   OUT                  Fnd_Role_Grant_Arr,
   missing_user_grant_arr_                   OUT                  Fnd_User_Grant_Arr,
   missing_lobby_page_grant_arr_             OUT                  Pres_Object_Grant_Arr,
   missing_lobby_element_grant_arr_          OUT                  Pres_Object_Grant_Arr,
   missing_lobby_data_src_grant_arr_         OUT                  Pres_Object_Grant_Arr,
   import_xml_                               IN                   CLOB)
IS
   index_                                                         NUMBER;
   tmp_perm_set_rec_                                              Fnd_Role_Rec;
   old_perm_set_rec_                                              Fnd_Role_Rec;
   new_perm_set_rec_                                              Fnd_Role_Rec;
   new_system_privilege_grant_rec_                                System_Privilege_Grant_Rec;
   new_projection_grant_rec_                                      Fnd_Projection_Grant_Rec;
   tmp_entity_grant_rec_                                          Fnd_Proj_Entity_Grant_Rec;
   old_entity_grant_rec_                                          Fnd_Proj_Entity_Grant_Rec;
   new_entity_grant_rec_                                          Fnd_Proj_Entity_Grant_Rec;
   new_entity_action_grant_rec_                                   Fnd_Proj_Ent_Action_Grant_Rec;
   new_action_grant_rec_                                          Fnd_Proj_Action_Grant_Rec;
   tmp_role_grant_rec_                                            Fnd_Role_Grant_Rec;
   tmp_user_grant_rec_                                            Fnd_User_Grant_Rec;
   new_lobby_page_grant_rec_                                      Pres_Object_Grant_Rec;
   new_lobby_element_grant_rec_                                   Pres_Object_Grant_Rec;
   new_lobby_data_src_grant_rec_                                  Pres_Object_Grant_Rec;
   
   CURSOR get_permission_set IS
      SELECT * FROM xmltable(
         '/PERMISSION_SET_EXPORT/PERMISSION_SET'
         passing Xmltype(import_xml_) COLUMNS
         
           ROLE VARCHAR2(30) path 'ROLE',
           DESCRIPTION VARCHAR2(200) path 'DESCRIPTION',
           CREATED VARCHAR2(100) path 'CREATED',
           FND_ROLE_TYPE VARCHAR2(20) path 'FND_ROLE_TYPE',
           LIMITED_TASK_USER VARCHAR2(5) path 'LIMITED_TASK_USER'
      );

   CURSOR get_system_privilege_grant(
      role_ System_Privilege_Grant.role%TYPE
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/SYSTEM_PRIVILEGE_GRANTS/SYSTEM_PRIVILEGE_GRANTS_ROW')
        passing Xmltype(import_xml_) COLUMNS
        
          PRIVILEGE_ID VARCHAR2(30) path 'PRIVILEGE_ID'
      );

   CURSOR get_projection_grant(
      role_ Fnd_Projection_Grant.role%TYPE
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/PROJECTION_GRANTS/PROJECTION_GRANTS_ROW')
        passing Xmltype(import_xml_) COLUMNS
        
          PROJECTION VARCHAR2(100) path 'PROJECTION'
      );

   CURSOR get_entity_grant(
      role_ Fnd_Proj_Entity_Grant.role%TYPE,
      projection_ Fnd_Proj_Entity_Grant.projection%TYPE
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/PROJECTION_GRANTS/PROJECTION_GRANTS_ROW[PROJECTION = "' || projection_ || '"]/ENTITY_GRANTS/ENTITY_GRANTS_ROW')
        passing Xmltype(import_xml_) COLUMNS
        
          ENTITY VARCHAR2(100) path 'ENTITY',
          CUD_ALLOWED VARCHAR2(5) path 'CUD_ALLOWED'
      );
      
   CURSOR get_entity_action_grant(
      role_ Fnd_Proj_Ent_Action_Grant.role%TYPE,
      projection_ Fnd_Proj_Ent_Action_Grant.projection%TYPE,
      entity_ Fnd_Proj_Ent_Action_Grant.entity%TYPE
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/PROJECTION_GRANTS/PROJECTION_GRANTS_ROW[PROJECTION = "' || projection_ || '"]/ENTITY_GRANTS/ENTITY_GRANTS_ROW[ENTITY = "' || entity_ || '"]/ENTITY_ACTION_GRANTS/ENTITY_ACTION_GRANTS_ROW')
        passing Xmltype(import_xml_) COLUMNS
        
          ACTION VARCHAR2(100) path 'ACTION'
      );
      
   CURSOR get_projection_action_grant(role_ Fnd_Proj_Action_Grant.role%TYPE, projection_ Fnd_Proj_Action_Grant.projection%TYPE) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/PROJECTION_GRANTS/PROJECTION_GRANTS_ROW[PROJECTION = "' || projection_ || '"]/PROJECTION_ACTION_GRANTS/PROJECTION_ACTION_GRANTS_ROW')
        passing Xmltype(import_xml_) COLUMNS
        
          ACTION VARCHAR2(100) path 'ACTION'
      );

   CURSOR get_role_grant(
      role_ VARCHAR2
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/ROLE_GRANT/ROLE_GRANT_ROW')
        passing Xmltype(import_xml_) COLUMNS
        
          GRANTED_ROLE VARCHAR2(30) path 'GRANTED_ROLE'
      );
   
   CURSOR get_user_grant(
      role_ VARCHAR2
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/USER_GRANT/USER_GRANT_ROW')
        passing Xmltype(import_xml_) COLUMNS
        
          IDENTITY VARCHAR2(30) path 'IDENTITY'
      );
      
   $IF Component_Fndwf_SYS.INSTALLED $THEN
   CURSOR get_workflow_grant(
      role_ VARCHAR2
   ) IS
      SELECT xml_.*, (CASE WHEN fdb.id IS NOT NULL THEN 1 ELSE 0 END) deployed
      FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/WORKFLOW_GRANT/WORKFLOW_GRANT_ROW')
        passing Xmltype(import_xml_) COLUMNS
        BPA_KEY VARCHAR2(30) path 'BPA_KEY'
      ) xml_
      LEFT OUTER JOIN fnd_deployed_bpa fdb 
      ON fdb.id = xml_.bpa_key;
   $END 
   CURSOR get_cud_allowed(
      projection_ Fnd_Proj_Entity_Grant.projection%TYPE,
      entity_     Fnd_Proj_Entity_Grant.entity%TYPE,
      role_       Fnd_Proj_Entity_Grant.role%TYPE
   ) IS
      SELECT cud_allowed_db cud_allowed
      FROM Fnd_Proj_Entity_Grant
      WHERE projection=projection_ AND
      entity=entity_ AND
      role=role_;
      
   CURSOR get_lobby_page_grant( 
      role_ VARCHAR2
   ) IS
      SELECT xml_.*
      FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/LOBBY_PAGE_GRANTS/LOBBY_PAGE_GRANTS_ROW')
        passing Xmltype(import_xml_) COLUMNS
        PO_ID VARCHAR2(100)
      ) xml_ ;
      
   CURSOR get_lobby_element_grant( 
      role_ VARCHAR2
   ) IS
      SELECT xml_.*
      FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/LOBBY_PAGE_ELEMENT_GRANTS/LOBBY_PAGE_ELEMENT_GRANTS_ROW')
        passing Xmltype(import_xml_) COLUMNS
        PO_ID VARCHAR2(100)
      ) xml_ ;

   CURSOR get_lobby_data_src_grant( 
      role_ VARCHAR2
   ) IS
      SELECT xml_.*
      FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/LOBBY_DATA_SOURCE_GRANTS/LOBBY_DATA_SOURCE_GRANTS_ROW')
        passing Xmltype(import_xml_) COLUMNS
        PO_ID VARCHAR2(100)
      ) xml_ ;
BEGIN
   fnd_role_arr_                           := Fnd_Role_Arr();
   system_privilege_grant_arr_             := System_Privilege_Grant_Arr();
   projection_grant_arr_                   := Fnd_Projection_Grant_Arr();
   entity_grant_arr_                       := Fnd_Proj_Entity_Grant_Arr();
   entity_action_grant_arr_                := Fnd_Proj_Ent_Action_Grant_Arr();
   action_grant_arr_                       := Fnd_Proj_Action_Grant_Arr();
   role_grant_arr_                         := Fnd_Role_Grant_Arr();
   user_grant_arr_                         := Fnd_User_Grant_Arr();
   lobby_page_grant_arr_                   := Pres_Object_Grant_Arr();
   lobby_element_grant_arr_                := Pres_Object_Grant_Arr();
   lobby_data_src_grant_arr_               := Pres_Object_Grant_Arr();
   FOR perm_set_rec_ IN get_permission_set LOOP      
      IF Fnd_Role_API.Exists(perm_set_rec_.role) THEN
         new_perm_set_rec_ := NULL;
         old_perm_set_rec_.role := perm_set_rec_.role;
         tmp_perm_set_rec_.description := Fnd_Role_API.Get_Description(perm_set_rec_.role);
         tmp_perm_set_rec_.fnd_role_type := Fnd_Role_API.Get_Fnd_Role_Type_Db(perm_set_rec_.role);
         tmp_perm_set_rec_.description := Fnd_Role_API.Get_Description(perm_set_rec_.role);
         tmp_perm_set_rec_.limited_task_user := Fnd_Role_API.Get_Limited_Task_User(perm_set_rec_.role);
         IF (tmp_perm_set_rec_.description IS NULL AND perm_set_rec_.description IS NOT NULL) OR
            (perm_set_rec_.description IS NULL AND tmp_perm_set_rec_.description IS NOT NULL) OR
            tmp_perm_set_rec_.description != perm_set_rec_.description THEN
            old_perm_set_rec_.description := tmp_perm_set_rec_.description;
            new_perm_set_rec_.description := perm_set_rec_.description;
         END IF;
         IF tmp_perm_set_rec_.fnd_role_type != perm_set_rec_.fnd_role_type THEN
            old_perm_set_rec_.fnd_role_type := tmp_perm_set_rec_.fnd_role_type;
            new_perm_set_rec_.fnd_role_type := perm_set_rec_.fnd_role_type;
         END IF;
         IF NVL(tmp_perm_set_rec_.limited_task_user, 'FALSE') != perm_set_rec_.limited_task_user THEN
            old_perm_set_rec_.limited_task_user := tmp_perm_set_rec_.limited_task_user;
            new_perm_set_rec_.limited_task_user := perm_set_rec_.limited_task_user;
         END IF;
      ELSE
         old_perm_set_rec_ := NULL;
         new_perm_set_rec_.role := perm_set_rec_.role;
         new_perm_set_rec_.description := perm_set_rec_.description;
         new_perm_set_rec_.fnd_role_type := perm_set_rec_.fnd_role_type;
         new_perm_set_rec_.limited_task_user := perm_set_rec_.limited_task_user;
      END IF;
      fnd_role_arr_.extend;
      fnd_role_arr_(fnd_role_arr_.last) := new_perm_set_rec_; 
      fnd_role_arr_.extend;
      fnd_role_arr_(fnd_role_arr_.last) := old_perm_set_rec_;
      missing_system_privilege_grant_arr_ := Get_System_Privilege_Grant_Arr___(perm_set_rec_.role);
      FOR system_privilege_grant_rec_ IN get_system_privilege_grant(perm_set_rec_.role) LOOP
         new_system_privilege_grant_rec_.role := perm_set_rec_.role;
         new_system_privilege_grant_rec_.privilege_id := system_privilege_grant_rec_.privilege_id;
         IF NOT System_Privilege_Grant_API.Exists(new_system_privilege_grant_rec_.privilege_id, new_system_privilege_grant_rec_.role) THEN
            system_privilege_grant_arr_.extend;
            system_privilege_grant_arr_(system_privilege_grant_arr_.last) := new_system_privilege_grant_rec_;
         ELSIF missing_system_privilege_grant_arr_.count > 0 THEN
            index_ := missing_system_privilege_grant_arr_.first;
            WHILE(index_ IS NOT NULL) LOOP
               IF missing_system_privilege_grant_arr_(index_).privilege_id = new_system_privilege_grant_rec_.privilege_id THEN
                  missing_system_privilege_grant_arr_.delete(index_);
               END IF;
               index_ := missing_system_privilege_grant_arr_.next(index_);
            END LOOP;
         END IF;
      END LOOP;
      missing_projection_grant_arr_ := Get_Fnd_Projection_Grant_Arr___(perm_set_rec_.role);
      missing_entity_grant_arr_ := Get_Fnd_Proj_Entity_Grant_Arr___(perm_set_rec_.role);
      missing_entity_action_grant_arr_ := Get_Fnd_Proj_Ent_Action_Grant_Arr___(perm_set_rec_.role);
      missing_action_grant_arr_ := Get_Fnd_Proj_Action_Grant_Arr___(perm_set_rec_.role);
      FOR projection_grant_rec_ IN get_projection_grant(perm_set_rec_.role) LOOP
         new_projection_grant_rec_.role := perm_set_rec_.role;
         new_projection_grant_rec_.projection := projection_grant_rec_.projection;
         IF NOT Fnd_Projection_Grant_API.Exists(new_projection_grant_rec_.projection, new_projection_grant_rec_.role) THEN
            projection_grant_arr_.extend;
            projection_grant_arr_(projection_grant_arr_.last) := new_projection_grant_rec_;
         ELSIF missing_projection_grant_arr_.count > 0 THEN
            index_ := missing_projection_grant_arr_.first;
            WHILE(index_ IS NOT NULL) LOOP
               IF missing_projection_grant_arr_(index_).projection = new_projection_grant_rec_.projection THEN
                  missing_projection_grant_arr_.delete(index_);
               END IF;
               index_ := missing_projection_grant_arr_.next(index_);
            END LOOP;
         END IF;
         FOR entity_grant_rec_ in get_entity_grant(perm_set_rec_.role, projection_grant_rec_.projection) LOOP
            new_entity_grant_rec_.role := perm_set_rec_.role;
            new_entity_grant_rec_.projection := projection_grant_rec_.projection;
            new_entity_grant_rec_.entity := entity_grant_rec_.entity;
            new_entity_grant_rec_.cud_allowed := entity_grant_rec_.cud_allowed;
            IF Fnd_Proj_Entity_Grant_API.Exists(new_entity_grant_rec_.projection, new_entity_grant_rec_.entity, new_entity_grant_rec_.role) THEN
               OPEN get_cud_allowed(new_entity_grant_rec_.projection, new_entity_grant_rec_.entity, new_entity_grant_rec_.role);
               FETCH get_cud_allowed INTO tmp_entity_grant_rec_.cud_allowed;
               CLOSE get_cud_allowed;
               IF tmp_entity_grant_rec_.cud_allowed != new_entity_grant_rec_.cud_allowed THEN
                  old_entity_grant_rec_.role := new_entity_grant_rec_.role;
                  old_entity_grant_rec_.projection := new_entity_grant_rec_.projection;
                  old_entity_grant_rec_.entity := new_entity_grant_rec_.entity;
                  old_entity_grant_rec_.cud_allowed := tmp_entity_grant_rec_.cud_allowed;
                  entity_grant_arr_.extend;
                  entity_grant_arr_(entity_grant_arr_.last) := new_entity_grant_rec_;
                  entity_grant_arr_.extend;
                  entity_grant_arr_(entity_grant_arr_.last) := old_entity_grant_rec_;
               END IF;
               IF missing_entity_grant_arr_.count > 0 THEN
                  index_ := missing_entity_grant_arr_.first;
                  WHILE(index_ IS NOT NULL) LOOP
                     IF missing_entity_grant_arr_(index_).projection = new_entity_grant_rec_.projection AND
                        missing_entity_grant_arr_(index_).entity = new_entity_grant_rec_.entity THEN
                        missing_entity_grant_arr_.delete(index_);
                     END IF;
                     index_ := missing_entity_grant_arr_.next(index_);
                  END LOOP;
               END IF;
            ELSE
               entity_grant_arr_.extend;
               entity_grant_arr_(entity_grant_arr_.last) := new_entity_grant_rec_;
               entity_grant_arr_.extend;
               entity_grant_arr_(entity_grant_arr_.last) := NULL;
            END IF;
            FOR entity_action_grant_rec_ IN get_entity_action_grant(perm_set_rec_.role, projection_grant_rec_.projection, entity_grant_rec_.entity) LOOP
               new_entity_action_grant_rec_.role := perm_set_rec_.role;
               new_entity_action_grant_rec_.entity := entity_grant_rec_.entity;
               new_entity_action_grant_rec_.projection := projection_grant_rec_.projection;
               new_entity_action_grant_rec_.action := entity_action_grant_rec_.action;
               IF NOT Fnd_Proj_Ent_Action_Grant_API.Exists(new_entity_action_grant_rec_.projection, new_entity_action_grant_rec_.entity, new_entity_action_grant_rec_.action, new_entity_action_grant_rec_.role) THEN
                  entity_action_grant_arr_.extend;
                  entity_action_grant_arr_(entity_action_grant_arr_.last) := new_entity_action_grant_rec_;
               ELSIF missing_entity_action_grant_arr_.count > 0 THEN
                  index_ := missing_entity_action_grant_arr_.first;
                  WHILE(index_ IS NOT NULL) LOOP
                     IF missing_entity_action_grant_arr_(index_).projection = new_entity_action_grant_rec_.projection AND
                        missing_entity_action_grant_arr_(index_).entity = new_entity_action_grant_rec_.entity AND
                        missing_entity_action_grant_arr_(index_).action = new_entity_action_grant_rec_.action THEN
                        missing_entity_action_grant_arr_.delete(index_);
                     END IF;
                     index_ := missing_entity_action_grant_arr_.next(index_);
                  END LOOP;
               END IF;
            END LOOP;
         END LOOP;
         FOR action_grant_rec_ IN get_projection_action_grant(perm_set_rec_.role, projection_grant_rec_.projection) LOOP
            new_action_grant_rec_.role := perm_set_rec_.role;
            new_action_grant_rec_.projection := projection_grant_rec_.projection;
            new_action_grant_rec_.action := action_grant_rec_.action;
            IF NOT Fnd_Proj_Action_Grant_API.Exists(new_action_grant_rec_.projection, new_action_grant_rec_.action, new_action_grant_rec_.role) THEN
               action_grant_arr_.extend;
               action_grant_arr_(action_grant_arr_.last) := new_action_grant_rec_;
            ELSIF missing_action_grant_arr_.count > 0 THEN
               index_ := missing_action_grant_arr_.first;
               WHILE(index_ IS NOT NULL) LOOP
                  IF missing_action_grant_arr_(index_).projection = new_action_grant_rec_.projection AND
                     missing_action_grant_arr_(index_).action = new_action_grant_rec_.action THEN
                     missing_action_grant_arr_.delete(index_);
                  END IF;
                  index_ := missing_action_grant_arr_.next(index_);
               END LOOP;
            END IF;
         END LOOP;
      END LOOP;
      missing_role_grant_arr_ := Get_Fnd_Role_Grant_Arr___(perm_set_rec_.role);
      FOR role_grant_rec_ IN get_role_grant(perm_set_rec_.role) LOOP
         tmp_role_grant_rec_.granted_role := role_grant_rec_.granted_role;
         IF NOT Fnd_Granted_Role_Exists___(perm_set_rec_.role, tmp_role_grant_rec_.granted_role) THEN
            role_grant_arr_.extend;
            role_grant_arr_(role_grant_arr_.last) := tmp_role_grant_rec_;
         ELSIF missing_role_grant_arr_.count > 0 THEN
            index_ := missing_role_grant_arr_.first;
            WHILE(index_ IS NOT NULL) LOOP
               IF missing_role_grant_arr_(index_).granted_role = tmp_role_grant_rec_.granted_role THEN
                  missing_role_grant_arr_.delete(index_);
               END IF;
               index_ := missing_role_grant_arr_.next(index_);
            END LOOP;
         END IF;
      END LOOP;
      missing_user_grant_arr_ := Get_Fnd_User_Grant_Arr___(perm_set_rec_.role);
      FOR user_grant_rec_ IN get_user_grant(perm_set_rec_.role) LOOP
         tmp_user_grant_rec_.identity := user_grant_rec_.identity;
         IF NOT Fnd_User_Grant_Exists___(tmp_user_grant_rec_.identity, perm_set_rec_.role) THEN
            user_grant_arr_.extend;
            user_grant_arr_(user_grant_arr_.last) := tmp_user_grant_rec_;
         ELSIF missing_user_grant_arr_.count > 0 THEN
            index_ := missing_user_grant_arr_.first;
            WHILE(index_ IS NOT NULL) LOOP
               IF missing_user_grant_arr_(index_).identity = tmp_user_grant_rec_.identity THEN
                  missing_user_grant_arr_.delete(index_);
               END IF;
               index_ := missing_user_grant_arr_.next(index_);
            END LOOP;
         END IF;
      END LOOP;
      $IF Component_Fndwf_SYS.INSTALLED $THEN
      FOR new_workflow_grant_rec_ IN get_workflow_grant(perm_set_rec_.role) LOOP
         IF Fnd_Bpa_Grant_API.Exists(new_workflow_grant_rec_.bpa_key, perm_set_rec_.role) THEN
            workflow_grant_rec_.bpa_key := new_workflow_grant_rec_.bpa_key;
            workflow_grant_rec_.deployed := new_workflow_grant_rec_.deployed;
         END IF;
      END LOOP;
      $END
      missing_lobby_page_grant_arr_ := Get_Pres_Object_Grant_Arr___(perm_set_rec_.role, 'lobbyPage');
      new_lobby_page_grant_rec_.role := perm_set_rec_.role;
      FOR lobby_page_grant_rec_ IN get_lobby_page_grant(perm_set_rec_.role) LOOP
         new_lobby_page_grant_rec_.po_id := lobby_page_grant_rec_.po_id;
         IF NOT Pres_Object_Grant_API.Exists(new_lobby_page_grant_rec_.po_id, new_lobby_page_grant_rec_.role) THEN
            lobby_page_grant_arr_.extend;
            lobby_page_grant_arr_(lobby_page_grant_arr_.last) := new_lobby_page_grant_rec_;
         ELSIF missing_lobby_page_grant_arr_.count > 0 THEN
            index_ := missing_lobby_page_grant_arr_.first;
            WHILE(index_ IS NOT NULL) LOOP
               IF missing_lobby_page_grant_arr_(index_).po_id = new_lobby_page_grant_rec_.po_id THEN
                  missing_lobby_page_grant_arr_.delete(index_);
               END IF;
               index_ := missing_lobby_page_grant_arr_.next(index_);
            END LOOP;
         END IF;
      END LOOP;
      missing_lobby_element_grant_arr_ := Get_Pres_Object_Grant_Arr___(perm_set_rec_.role, 'lobbyElement');
      new_lobby_element_grant_rec_.role := perm_set_rec_.role;
      FOR lobby_element_grant_rec_ IN get_lobby_element_grant(perm_set_rec_.role) LOOP
         new_lobby_element_grant_rec_.po_id := lobby_element_grant_rec_.po_id;
         IF NOT Pres_Object_Grant_API.Exists(new_lobby_element_grant_rec_.po_id, new_lobby_element_grant_rec_.role) THEN
            lobby_element_grant_arr_.extend;
            lobby_element_grant_arr_(lobby_element_grant_arr_.last) := new_lobby_element_grant_rec_;
         ELSIF missing_lobby_element_grant_arr_.count > 0 THEN
            index_ := missing_lobby_element_grant_arr_.first;
            WHILE(index_ IS NOT NULL) LOOP
               IF missing_lobby_element_grant_arr_(index_).po_id = new_lobby_element_grant_rec_.po_id THEN
                  missing_lobby_element_grant_arr_.delete(index_);
               END IF;
               index_ := missing_lobby_element_grant_arr_.next(index_);
            END LOOP;
         END IF;
      END LOOP;
      missing_lobby_data_src_grant_arr_ := Get_Pres_Object_Grant_Arr___(perm_set_rec_.role, 'lobbyDataSource');
      new_lobby_data_src_grant_rec_.role := perm_set_rec_.role;
      FOR lobby_data_src_grant_rec_ IN get_lobby_data_src_grant(perm_set_rec_.role) LOOP
         new_lobby_data_src_grant_rec_.po_id := lobby_data_src_grant_rec_.po_id;
         IF NOT Pres_Object_Grant_API.Exists(new_lobby_page_grant_rec_.po_id, new_lobby_page_grant_rec_.role) THEN
            lobby_data_src_grant_arr_.extend;
            lobby_data_src_grant_arr_(lobby_data_src_grant_arr_.last) := new_lobby_data_src_grant_rec_;
         ELSIF missing_lobby_data_src_grant_arr_.count > 0 THEN
            index_ := missing_lobby_data_src_grant_arr_.first;
            WHILE(index_ IS NOT NULL) LOOP
               IF missing_lobby_data_src_grant_arr_(index_).po_id = new_lobby_data_src_grant_rec_.po_id THEN
                  missing_lobby_data_src_grant_arr_.delete(index_);
               END IF;
               index_ := missing_lobby_data_src_grant_arr_.next(index_);
            END LOOP;
         END IF;
      END LOOP;
   END LOOP;
END Get_Diff_From_Xml;

FUNCTION Export_User_Grants_Xml RETURN BLOB
IS
   ctx_ dbms_xmlgen.ctxHandle;
   xml_ XMLType;
   out_xml_ CLOB;
   stmt_ VARCHAR2(32000) := 'SELECT identity, role FROM fnd_user_role_tab ORDER BY identity';
BEGIN
   Log_SYS.App_Trace(Log_SYS.debug_, 'XML Export Statement: ' || stmt_);
   
   ctx_ := Dbms_Xmlgen.newContext(stmt_);
   dbms_xmlgen.setNullHandling(ctx_, dbms_xmlgen.EMPTY_TAG);
   
   dbms_xmlgen.setRowSetTag(ctx_, 'FND_USER_ROLE_LIST');
   dbms_xmlgen.setRowTag(ctx_, 'FND_USER_ROLE');
   
   xml_ := dbms_xmlgen.getXMLType(ctx_);
   Dbms_Xmlgen.Closecontext(ctx_);
   Utility_SYS.Xmltype_To_Clob(out_xml_, xml_);
   
   RETURN Utility_SYS.Clob_To_Blob(out_xml_);
END Export_User_Grants_Xml;

PROCEDURE Import_User_Grants_Xml(  
   user_option_         IN VARCHAR2,
   role_option_         IN VARCHAR2,
   xml_                 IN BLOB)
IS
   grants_xml_       CLOB;
   error_            BOOLEAN := FALSE;
   import_           BOOLEAN;
   error_line_       VARCHAR2(400);
   
   CURSOR get_user_grants IS
      SELECT * FROM xmltable(
         '/FND_USER_ROLE_LIST/FND_USER_ROLE'
         passing Xmltype(grants_xml_) COLUMNS
           IDENTITY VARCHAR2(30) path 'IDENTITY',
           ROLE VARCHAR2(30) path 'ROLE'
      );
BEGIN
   dbms_lob.Createtemporary(grants_xml_, TRUE);
   grants_xml_ := Utility_SYS.Blob_To_Clob(xml_);
   Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,'Import User Grants     '||TO_CHAR(sysdate) );
   Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,' ' );
   FOR rec_ IN get_user_grants LOOP
      import_ := TRUE;
      error_line_ := NULL;
      IF (NOT Fnd_User_API.Exists(rec_.identity)) THEN
         IF user_option_ = 'STOP' THEN
            Error_SYS.Appl_General(lu_name_,'IMPORT_ERROR_NO_USER: User (:P1) does not exist. Terminating import.', rec_.identity);
         END IF;
         error_ := TRUE;
         import_ := FALSE;
         IF (error_line_ IS NOT NULL) THEN
            error_line_ := error_line_ || ' / ';
         END IF;
         error_line_ := error_line_ || 'User (' || rec_.identity ||') does not exist.';
      END IF;
      IF (NOT Fnd_Role_API.Exists(rec_.role)) THEN
         IF role_option_ = 'STOP' THEN
            Error_SYS.Appl_General(lu_name_,'IMPORT_ERROR_NO_ROLE: Permission Set (:P1) does not exist. Terminating import.', rec_.role);
         ELSIF (role_option_ = 'CREATE_EMPTY') AND Fnd_User_API.Exists(rec_.identity) THEN
            Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,' ' );
            Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,'Permission Set (' || rec_.role ||') does not exist.' );
            Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,'Creating empty Permission Set (' || rec_.role ||')' );
            Fnd_Role_API.Create__(rec_.role, rec_.role, Fnd_Role_Type_API.DB_ENDUSERROLE, 'FALSE');
         ELSE
            error_ := TRUE;
            import_ := FALSE;
            IF (error_line_ IS NOT NULL) THEN
               error_line_ := error_line_ || ' / ';
            END IF;
            error_line_ := error_line_ || 'Permission Set (' || rec_.role ||') does not exist.';
         END IF;
      END IF;
      IF (error_line_ IS NOT NULL) THEN
         Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,' ' );
         Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO, 'ERROR: ' || error_line_ );
         Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,'User (' || rec_.identity ||') - Permission Set (' || rec_.role ||') not imported.' );
         Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,' ' );
      END IF;
      IF import_ THEN
         Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,'Importing User (' || rec_.identity ||') - Permission Set (' || rec_.role ||')' );
         Fnd_User_Role_API.Set_Role(rec_.identity, rec_.role, TRUE);
      END IF;
   END LOOP;
   Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,' ' );
   IF error_ THEN
      Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,'****** WARNING! User grants imported ignoring non existing object/s. ******' );
   ELSE
      Application_Logger_API.Log('USER_GRANTS_IMPORT',Application_Logger_API.CATEGORY_INFO,'****** User grants imported successfully. ******' );
   END IF;
   dbms_lob.freetemporary(grants_xml_);
END Import_User_Grants_Xml;

FUNCTION User_Grants_Exists_In_Xml(
   role_ IN VARCHAR2,
   xml_ IN CLOB) RETURN BOOLEAN
IS
   identity_ VARCHAR2(32000);
   CURSOR get_user_grant(
      role_ VARCHAR2
   ) IS
      SELECT * FROM xmltable(
        ('/PERMISSION_SET_EXPORT/PERMISSION_SET[ROLE = "' || role_ || '"]/USER_GRANT/USER_GRANT_ROW')
        passing Xmltype(xml_) COLUMNS
        
          IDENTITY VARCHAR2(30) path 'IDENTITY'
      );
BEGIN
   FOR rec_ IN  get_user_grant(role_) LOOP
      RETURN TRUE;
   END LOOP;
   RETURN FALSE;
END User_Grants_Exists_In_Xml;

-------------------- LU  NEW METHODS -------------------------------------
