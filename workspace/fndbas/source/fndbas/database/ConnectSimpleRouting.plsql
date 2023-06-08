-----------------------------------------------------------------------------
--
--  Logical unit: ConnectSimpleRouting
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Connect_Routings IS TABLE OF connect_simple_routing_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT connect_simple_routing_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 ) IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Connect_Runtime_API.Sync_Routing_(newrec_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     connect_simple_routing_tab%ROWTYPE,
   newrec_     IN OUT connect_simple_routing_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE ) IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Connect_Runtime_API.Sync_Routing_(newrec_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN connect_simple_routing_tab%ROWTYPE ) IS
BEGIN
   super(objid_, remrec_);
   Connect_Runtime_API.Remove_Routing_(remrec_.instance_name);
END Delete___;

PROCEDURE Set_Default_Values___(
   attr_ OUT VARCHAR2,
   instance_name_ IN VARCHAR2)
IS
BEGIN
   Client_SYS.Add_To_Attr('ATTRIBUTE_DB', 'none', attr_);
   IF (instance_name_ = 'Inbound') THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', 'Simplified Routing of Inbound Messages', attr_);
   ELSIF (instance_name_ = 'Outbound') THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', 'Simplified Routing of Outbound Messages', attr_);
   END IF;
END Set_Default_Values___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Setup_Attributes__(
   attr_          OUT VARCHAR2,
   instance_name_ IN  VARCHAR2)
IS
BEGIN
   Prepare_Insert___(attr_);
   Set_Default_Values___(attr_, instance_name_);
   Client_SYS.Add_To_Attr('INSTANCE_NAME_DB', instance_name_, attr_);
END Setup_Attributes__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
-- Convert client entity columns to runtime config parameter rows
--
PROCEDURE To_Runtime_Params_ (
   params_  IN OUT Connect_Runtime_Params_Type,
   routing_ IN     Connect_Routings) IS
BEGIN
   SELECT Connect_Runtime_Param_Type(group_name, instance_name, instance_type, parameter_name, parameter_value)
   BULK COLLECT INTO params_ -- INTO replaces old rows, if any
   FROM
   (
      WITH client AS
      (
         SELECT -- list of all table columns without: DESCRIPTION, STATIC_CONFIG, ROWVERSION and ROWKEY
           'Routing'               group_name,
           instance_name,          -- primary key
           'SimplifiedRouting'     instance_type,          -- enum corresponding to Aurena form
            attribute
         FROM
            TABLE(routing_)
      )
      SELECT *
      FROM client
      UNPIVOT
      (
         parameter_value
         FOR parameter_name IN
         (
            attribute
         )
      )
   );
END To_Runtime_Params_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

