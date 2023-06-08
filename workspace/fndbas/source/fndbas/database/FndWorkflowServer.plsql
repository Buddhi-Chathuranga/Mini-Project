-----------------------------------------------------------------------------
--
--  Logical unit: FndWorkflowServer
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


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Set_Default___
IS
   dummy_ NUMBER;
   CURSOR default_control IS
      SELECT 1
      FROM   FND_WORKFLOW_SERVER_TAB
      WHERE  default_server = 'TRUE';
BEGIN
   OPEN default_control;
   FETCH default_control INTO dummy_;
   IF (default_control%FOUND) THEN
      CLOSE default_control;
      Error_SYS.Record_General(lu_name_,'ONLY_ONE_DEFAULT_SERVER_ALLOWED: You can only have one workflow server set as the default' );
   END IF;
   CLOSE default_control;
END Check_Set_Default___;


PROCEDURE Check_URL___(
   url_ IN VARCHAR2,
   id_  IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR url_control IS
      SELECT 1
      FROM   FND_WORKFLOW_SERVER_TAB
      WHERE  url = url_
      AND id <> id_;
BEGIN
   OPEN url_control;
   FETCH url_control INTO dummy_;
   IF (url_control%FOUND) THEN
      CLOSE url_control;
      Error_SYS.Record_General(lu_name_,'SAME_URL: The same Url can only be registered once' );
   END IF;
   CLOSE url_control;  
END Check_URL___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT fnd_workflow_server_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   newrec_.id := Sys_Guid;
   super(newrec_, indrec_, attr_);
   Client_SYS.Add_To_Attr('ID', newrec_.id,attr_);
   Check_URL___(newrec_.url,'new');
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     fnd_workflow_server_tab%ROWTYPE,
   newrec_ IN OUT fnd_workflow_server_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Check_URL___(newrec_.url,newrec_.id);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     fnd_workflow_server_tab%ROWTYPE,
   newrec_ IN OUT fnd_workflow_server_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF indrec_.default_server = TRUE THEN
      IF (newrec_.default_server = 'TRUE') THEN
         Check_Set_Default___;
      END IF;   
   END IF;   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Default_Workflow_Server RETURN VARCHAR2
IS
   url_ VARCHAR2(500);
   CURSOR default_server IS
      SELECT url
      FROM   FND_WORKFLOW_SERVER_TAB
      WHERE  default_server = 'TRUE';
BEGIN
   OPEN default_server;
   FETCH default_server INTO url_;
   CLOSE default_server;
   RETURN url_;
END Get_Default_Workflow_Server;



