-----------------------------------------------------------------------------
--
--  Logical unit: SoxFunctionalArea
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  060627  UTGULK Created.(Bug Id 58699 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Import_XML_Data (
   data_                  IN  XMLTYPE,
   import_type_           IN  VARCHAR2 )
IS
   info_ VARCHAR2(100);
   objid_ VARCHAR2(100); 
   objversion_ VARCHAR2(100);
   attr_ VARCHAR2(32000);
   funct_rec_                  Sox_Functional_Area_Tab%ROWTYPE;
   mod_funct_rec_              Sox_Functional_Area_Tab%ROWTYPE;
   name_of_conf_               functional_area_conflict_tab.conflict_name%TYPE;
   CURSOR get_func_area_content(xml_ IN Xmltype) IS
      SELECT xt.*
      FROM dual,
         XMLTABLE('/FuncAreaFormatingArray/FuncAreaFormating'
            PASSING xml_
            COLUMNS
               FUNCTIONAL_AREA_ID    VARCHAR2(1000)  PATH 'FunctionalAreaId',
               DESCRIPTION           VARCHAR2(1000)  PATH 'Description'
            ) xt;
   CURSOR get_proj_content(xml_ IN Xmltype) IS
      SELECT xt.*
      FROM dual,
         XMLTABLE('/FuncAreaFormatingArray/FuncAreaFormating/Projections/FuncAreaProjection'
            PASSING xml_
            COLUMNS
               PROJECTION_NAME       VARCHAR2(1000)  PATH 'ProjectionName'
            ) xt;
   CURSOR get_proj_action_content(xml_ IN Xmltype) IS
      SELECT xt.*
      FROM dual,
         XMLTABLE('/FuncAreaFormatingArray/FuncAreaFormating/ProjectionActions/FuncAreaProjAction'
            PASSING xml_
            COLUMNS
               PROJECTION_NAME       VARCHAR2(1000)  PATH 'ProjectionName',
               PROJECTION_ACTION     VARCHAR2(1000)  PATH 'ProjectionAction'
            ) xt;
   CURSOR get_proj_entity_content(xml_ IN Xmltype) IS
      SELECT xt.*
      FROM dual,
         XMLTABLE('/FuncAreaFormatingArray/FuncAreaFormating/ProjectionEntities/FuncAreaProjEntity'
            PASSING xml_
            COLUMNS
               PROJECTION_NAME       VARCHAR2(1000)  PATH 'ProjectionName',
               PROJECTION_ENTITY     VARCHAR2(1000)  PATH 'ProjectionEntity'
            ) xt;
   CURSOR get_proj_entity_action_content(xml_ IN Xmltype) IS
      SELECT xt.*
      FROM dual,
         XMLTABLE('/FuncAreaFormatingArray/FuncAreaFormating/ProjecionEntityActions/FuncAreaProjEntAct'
            PASSING xml_
            COLUMNS
               PROJECTION_NAME       VARCHAR2(1000)  PATH 'ProjectionName',
               PROJECTION_ENTITY     VARCHAR2(1000)  PATH 'ProjectionEntity',
               ENTITY_ACTION         VARCHAR2(1000)  PATH 'EntityAction'
            ) xt;
   CURSOR get_func_conflict_content(xml_ IN Xmltype) IS
      SELECT xt.*
      FROM dual,
         XMLTABLE('/FuncAreaFormatingArray/FuncAreaFormating/ConflictAreas/ConflictArea'
            PASSING xml_
            COLUMNS
               CONFLICT_AREA         VARCHAR2(1000)  PATH 'FunctionalAreaId',
               CONFLICT_TYPE         VARCHAR2(1000)  PATH 'ConflictType',
               CONFLICT_NAME         VARCHAR2(1000)  PATH 'ConflictName'
            ) xt;
   CURSOR get_con_name_(conf_name_ varchar2) IS 
      SELECT conflict_name 
      FROM  functional_area_conflict_tab
      WHERE conflict_name = conf_name_;         
BEGIN
   FOR rec_ IN get_func_area_content(data_) LOOP
      funct_rec_.functional_area_id                   := rec_.FUNCTIONAL_AREA_ID;
      funct_rec_.description                          := rec_.DESCRIPTION;
      IF Check_Exist___(funct_rec_.functional_area_id) AND import_type_ = 'OVERWRITE' THEN         
         DELETE FROM functional_area_conflict_tab
         WHERE functional_area_id = funct_rec_.functional_area_id OR conflict_area_id = funct_rec_.functional_area_id;
         funct_rec_.rowkey := Get_Objkey(funct_rec_.functional_area_id );
         Delete___(funct_rec_);
         New___(funct_rec_); 
      ELSIF (Check_Exist___(funct_rec_.functional_area_id))AND (import_type_ = 'MERGE' AND Get_Description(funct_rec_.functional_area_id)='Not Imported')THEN 
         mod_funct_rec_:= Get_Object_By_Keys___(rec_.FUNCTIONAL_AREA_ID);
         mod_funct_rec_.description := rec_.DESCRIPTION;
         Modify___(mod_funct_rec_,TRUE);
      ELSIF NOT Check_Exist___(funct_rec_.functional_area_id) THEN 
         New___(funct_rec_);
      END IF;
   END LOOP;
   FOR rec_ IN get_proj_content(data_) LOOP
      IF Func_Area_Projection_API.Exists(funct_rec_.functional_area_id, rec_.PROJECTION_NAME) THEN CONTINUE; END IF;
      Client_SYS.Add_To_Attr('PROJECTION_NAME', rec_.PROJECTION_NAME, attr_);
      Client_SYS.Add_To_Attr('FUNCTIONAL_AREA_ID', funct_rec_.functional_area_id, attr_);
      Func_Area_Projection_API.New__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
   Client_SYS.Clear_Attr(attr_);
   FOR rec_ IN get_proj_action_content(data_) LOOP
      IF Func_Area_Proj_Action_API.Exists(funct_rec_.functional_area_id, rec_.PROJECTION_NAME, rec_.PROJECTION_ACTION) THEN CONTINUE; END IF;   
      Client_SYS.Add_To_Attr('FUNCTIONAL_AREA_ID', funct_rec_.functional_area_id, attr_);
      Client_SYS.Add_To_Attr('PROJECTION_NAME', rec_.PROJECTION_NAME, attr_);
      Client_SYS.Add_To_Attr('PROJECTION_ACTION', rec_.PROJECTION_ACTION, attr_);
      func_area_proj_action_API.New__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
   Client_SYS.Clear_Attr(attr_);
   FOR rec_ IN get_proj_entity_content(data_) LOOP
      IF Func_Area_Proj_Entity_API.Exists(funct_rec_.functional_area_id, rec_.PROJECTION_NAME, rec_.PROJECTION_ENTITY) THEN CONTINUE; END IF;   
      Client_SYS.Add_To_Attr('FUNCTIONAL_AREA_ID', funct_rec_.functional_area_id, attr_);
      Client_SYS.Add_To_Attr('PROJECTION_NAME', rec_.PROJECTION_NAME, attr_);
      Client_SYS.Add_To_Attr('PROJECTION_ENTITY', rec_.PROJECTION_ENTITY, attr_);
      Func_Area_Proj_Entity_API.New__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
   Client_SYS.Clear_Attr(attr_);
   FOR rec_ IN get_proj_entity_action_content(data_) LOOP
      IF func_area_proj_ent_act_API.Exists(funct_rec_.functional_area_id, rec_.PROJECTION_NAME, rec_.PROJECTION_ENTITY,rec_.ENTITY_ACTION) THEN CONTINUE; END IF;   
      Client_SYS.Add_To_Attr('FUNCTIONAL_AREA_ID', funct_rec_.functional_area_id, attr_);
      Client_SYS.Add_To_Attr('PROJECTION_NAME', rec_.PROJECTION_NAME, attr_);
      Client_SYS.Add_To_Attr('PROJECTION_ENTITY', rec_.PROJECTION_ENTITY, attr_); 
      Client_SYS.Add_To_Attr('ENTITY_ACTION', rec_.ENTITY_ACTION, attr_);
      func_area_proj_ent_act_API.New__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
   Client_SYS.Clear_Attr(attr_);
   FOR rec_ IN get_func_conflict_content(data_) LOOP
      OPEN get_con_name_(rec_.CONFLICT_NAME);
      FETCH get_con_name_ INTO name_of_conf_;
      CLOSE get_con_name_;
      IF name_of_conf_ IS NOT NULL THEN 
         Error_SYS.Record_General(lu_name_,'CONNAMERR: Conflict Name already existing.Please change the name of [:P1] of [:P2] functional area.',rec_.CONFLICT_NAME,funct_rec_.functional_area_id);
      END IF;   
      IF functional_area_conflict_API.Exists(funct_rec_.functional_area_id,rec_.CONFLICT_AREA)OR functional_area_conflict_API.Exists(rec_.CONFLICT_AREA,funct_rec_.functional_area_id) THEN CONTINUE; END IF;   
      IF NOT Check_Exist___(rec_.CONFLICT_AREA) THEN
         Client_SYS.Add_Warning(lu_name_,'${rec_.CONFLICT_AREA} Functional area temporary imported.You Have to import that manually.');
         Client_SYS.Add_To_Attr('FUNCTIONAL_AREA_ID', rec_.CONFLICT_AREA, attr_);
         Client_SYS.Add_To_Attr('DESCRIPTION', 'Not Imported', attr_);
         New__(info_, objid_, objversion_, attr_, 'DO');
         Client_SYS.Clear_Attr(attr_);
      END IF;
      Client_SYS.Add_To_Attr('FUNCTIONAL_AREA_ID', funct_rec_.functional_area_id, attr_);
      Client_SYS.Add_To_Attr('CONFLICT_AREA_ID', rec_.CONFLICT_AREA, attr_);
      Client_SYS.Add_To_Attr('CONFLICT_TYPE_DB', rec_.CONFLICT_TYPE, attr_); 
      Client_SYS.Add_To_Attr('CONFLICT_NAME', rec_.CONFLICT_NAME, attr_);
      functional_area_conflict_API.New__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
   Client_SYS.Clear_Attr(attr_);
END Import_XML_Data;