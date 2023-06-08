-----------------------------------------------------------------------------
--
--  Logical unit: RoutingRule
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -------------------------------------------------------
--  2019-12-09  madrse  PACZDATA-1881: Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT routing_rule_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 ) IS
BEGIN
   newrec_.customized := 1;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     routing_rule_tab%ROWTYPE,
   newrec_ IN OUT routing_rule_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 ) IS
BEGIN
   newrec_.customized := 1;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 ) IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ENABLED', 1, attr_);
END Prepare_Insert___;

@Overtake Base (approved: 2022-01-06, udlelk)
PROCEDURE Unpack___ (
   newrec_   IN OUT NOCOPY routing_rule_tab%ROWTYPE,
   indrec_   IN OUT NOCOPY Indicator_Rec,
   attr_     IN OUT NOCOPY VARCHAR2 )
IS
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(32000);
   msg_   VARCHAR2(32000);   
BEGIN
   $SEARCH
      IF (value_ IS NOT NULL AND newrec_.direction IS NULL) THEN
         RAISE value_error;
      END IF;
      
   $REPLACE
      IF (value_ IS NOT NULL AND newrec_.direction IS NULL) THEN
         IF (value_ = 'Outbound' OR value_ = 'Inbound') THEN
            newrec_.direction := value_;
         ELSE
            RAISE value_error;
         END IF;         
      END IF;   
   $END
END Unpack___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Set_Customized_ (
   rule_name_  IN VARCHAR2,
   customized_ IN BOOLEAN)
IS
  rec_  routing_rule_tab%ROWTYPE := Lock_By_Keys_Nowait___(rule_name_);
   flag_ NUMBER := CASE customized_ WHEN TRUE THEN 1 ELSE 0 END;
BEGIN
   UPDATE routing_rule_tab
      SET customized = flag_, rowversion = rec_.rowversion + 1
    WHERE rule_name = rule_name_;
END Set_Customized_;

PROCEDURE Set_Enabled_ (
   rule_name_ IN VARCHAR2,
   enabled_   IN BOOLEAN)
IS
   rec_  routing_rule_tab%ROWTYPE := Lock_By_Keys_Nowait___(rule_name_);
   flag_ NUMBER := CASE enabled_ WHEN TRUE THEN 1 ELSE 0 END;
BEGIN
   UPDATE routing_rule_tab
      SET enabled = flag_, rowversion = rec_.rowversion + 1
    WHERE rule_name = rule_name_;
END Set_Enabled_;

FUNCTION Check_Enability_(rule_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   enabled_  BOOLEAN;
   temp_ NUMBER;
   CURSOR check_enability
IS
   SELECT enabled
   FROM routing_rule_tab
   WHERE rule_name = rule_name_;
BEGIN
   OPEN check_enability;
   FETCH check_enability INTO temp_;
   CLOSE check_enability;
   IF (temp_ = 1) THEN
      enabled_ := TRUE;
   ELSE
      enabled_ := FALSE;
   END IF;
   RETURN enabled_;
END Check_Enability_;

FUNCTION Check_Customizability_(rule_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   enabled_  BOOLEAN;
   temp_ NUMBER;
   CURSOR check_cuztomizability
IS
   SELECT customized
   FROM routing_rule_tab
   WHERE rule_name = rule_name_;
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
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

