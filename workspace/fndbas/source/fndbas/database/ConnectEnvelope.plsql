-----------------------------------------------------------------------------
--
--  Logical unit: ConnectEnvelope
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Connect_Envelopes IS TABLE OF connect_envelope_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT connect_envelope_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.customized := 1;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     connect_envelope_tab%ROWTYPE,
   newrec_ IN OUT connect_envelope_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.customized := 1;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT connect_envelope_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Connect_Runtime_API.Sync_Envelope_(newrec_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     connect_envelope_tab%ROWTYPE,
   newrec_     IN OUT connect_envelope_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Connect_Runtime_API.Sync_Envelope_(newrec_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN connect_envelope_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Connect_Runtime_API.Remove_Envelope_(remrec_.instance_name);
END Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
PROCEDURE Setup_Attributes__(
   attr_ OUT VARCHAR2,
   instance_name_ IN VARCHAR2,
   file_name_     IN VARCHAR2)
IS
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('INSTANCE_NAME', instance_name_, attr_);
   Client_SYS.Add_To_Attr('INSTANCE_TYPE_DB', 'Envelope', attr_);
   Client_SYS.Add_To_Attr('ENVELOPE_FILE', file_name_, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', 'Description of '||instance_name_, attr_);
END Setup_Attributes__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
--
-- Convert client entity columns to runtime config parameter rows
--
PROCEDURE To_Runtime_Params_ (
   params_    IN OUT Connect_Runtime_Params_Type,
   envelopes_ IN     Connect_Envelopes) IS
BEGIN
   SELECT Connect_Runtime_Param_Type(group_name, instance_name, instance_type, parameter_name, parameter_value)
   BULK COLLECT INTO params_ -- INTO replaces old rows, if any
   FROM
   (
      WITH client AS
      (
         SELECT -- list of all table columns without: DESCRIPTION, STATIC_CONFIG, ROWVERSION and ROWKEY
            'Envelopes'               group_name,
            instance_name,            -- primary key
            'Envelope'                instance_type,          -- enum corresponding to Aurena form
            envelope_file,
            route_parameters
         FROM
            TABLE(envelopes_)
      )
      SELECT *
      FROM client
      UNPIVOT
      (
         parameter_value
         FOR parameter_name IN
         (
            envelope_file,
            route_parameters
         )
      )
   );
END To_Runtime_Params_;


PROCEDURE Set_Customized_ (
   instance_name_ IN VARCHAR2,
   customized_    IN BOOLEAN)
IS
   rec_  connect_envelope_tab%ROWTYPE := Lock_By_Keys_Nowait___(instance_name_);
   flag_ NUMBER := CASE customized_ WHEN TRUE THEN 1 ELSE 0 END;
BEGIN
   UPDATE connect_envelope_tab
      SET customized = flag_, rowversion = rec_.rowversion + 1
    WHERE instance_name = instance_name_;
END Set_Customized_;


FUNCTION Check_Customizability_(instance_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   enabled_  BOOLEAN;
   temp_ NUMBER;
   CURSOR check_cuztomizability
IS
   SELECT customized
   FROM connect_envelope_tab
   WHERE instance_name = instance_name_;
BEGIN
   OPEN check_cuztomizability;
   FETCH check_cuztomizability INTO temp_;
   CLOSE check_cuztomizability;
   IF (temp_ = 1) THEN
      enabled_ := TRUE;
   ELSE
      enabled_ := FALSE;
   END IF;
   RETURN enabled_;
END Check_Customizability_;