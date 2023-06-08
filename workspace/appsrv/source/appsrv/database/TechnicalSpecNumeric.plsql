-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalSpecNumeric
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960620  JoRo    Created
--  960906  JoRo    Modified method Get_Summary to just return a summary of all
--                  attributes that has a value and is marked as 'Include' in
--                  TechnicalAttrib
--  960910  JoRo    Modified Ref on attribute
--  960911  JoRo    Added method Copy_Values_ and column Unit. Interchanged some
--                  columns in view
--  960925  PeSe    Removed unit
--  961205  JoRo    Removed commit in method Copy_Values_. Added DbTransaction...
--                  in client instead
--  970219  frtv    Upgraded.
--  970225  JoRo    Added method Delete_Specifications
--  970306  frtv    Added Refresh_Order
--  970312  JoRo    Added MODULE = APPSRV
--  970314  frtv    Added calls to Check_Approve...
--  980320  JaPa    Changes in Copy_Values_(), added new function Try_Lock___().
--  001029  LEIV    Added new method Get_Summary_All for PDM CAD interface
--  001216  MDAHSE  Moved view definition from this file to tspcnum.api
--  010612  Larelk  Added General_SYS.Init_Method in Check_Tech_Exist,Refresh_Order,
--                  Recalculate_Value,Get_Summary_All.
--  030620  NaSalk  Added Modify public method.
--  110701  INMALK  Bug Id 97858, Added validation for inability to allow the updation of 
--                  fields UPPER_LIMIT, LOWER_LIMIT and INFO when technical specification is Approved.
--  ----------------------------Eagle------------------------------------------
--  100422  Ajpelk  Merge rose method documentation
--  120604  NIFRSE  Bug Id 102287, Changed the referal from VIEW to TABLE in the cursor in Try_Lock__
--  120712  INMALK  Bug Id 103830, Added the possibility to even copy the values for UPPER_LIMIT 
--                  and LOWER_LIMIT when copying technical data
--  121012  UdGnlk  Bug 102701, Added new PROCEDURE Sync_Values_
--  -------------------------- APPS 9 ---------------------------------------
--  131130  paskno  Hooks: refactoring and splitting.
--  131202  paskno  PBSA-2914. Fixed in Replace_Values_.
--  131107  INMALK  CAR-1380, Added the method Acknowledge_Object___() to handle events when an attribute value is changed
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Try_Lock___ (
   lu_rec_            OUT TECHNICAL_SPECIFICATION_TAB%ROWTYPE,
   technical_spec_no_ IN  NUMBER,
   technical_class_   IN  VARCHAR2,
   attribute_         IN  VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR lock_control IS
      SELECT *
      FROM   TECHNICAL_SPECIFICATION_TAB
      WHERE  technical_spec_no = technical_spec_no_
      AND    technical_class = technical_class_
      AND    attribute = attribute_
      AND    rowtype like 'TechnicalSpecNumeric'
      FOR UPDATE NOWAIT;
BEGIN
   Trace_SYS.message('TECHNICAL_SPEC_NUMERIC_API.Try_Lock___('||technical_spec_no_||','||technical_class_||','||attribute_||')');
   OPEN lock_control;
   FETCH lock_control INTO lu_rec_;
   IF (lock_control%FOUND) THEN
      CLOSE lock_control;
      RETURN TRUE;
   END IF;
   CLOSE lock_control;
   RETURN FALSE;
END Try_Lock___;

-- Purpose: When values are modified in the technical attributes, carry out some operation according to the LU
-- If this is Linear Asset Segments, enter a history record for the Linear Asset.
PROCEDURE Acknowledge_Object___ (
   technical_spec_no_   IN NUMBER,
   attribute_           IN VARCHAR2,
   new_value_           IN NUMBER,
   old_value_           IN NUMBER )
IS
   tech_obj_ref_rec_    Technical_Object_Reference_API.Public_Rec;
BEGIN
   Log_SYS.Stack_Trace_(Log_SYS.info_, 'Technical_Spec_Numeric_API.Acknowledge_Object___');
   tech_obj_ref_rec_ := Technical_Object_Reference_API.Get(technical_spec_no_);

   $IF Component_Linast_SYS.INSTALLED $THEN
      IF (tech_obj_ref_rec_.lu_name = 'LinastLinearAsset') THEN
         Linast_Linear_Asset_API.Add_History_Journal_Entry(Client_SYS.Get_Key_Reference_Value(tech_obj_ref_rec_.key_ref, 'LINEAR_ASSET_SQ'),
                                                           Client_SYS.Get_Key_Reference_Value(tech_obj_ref_rec_.key_ref, 'LINEAR_ASSET_REVISION_NO'),
                                                           attribute_, to_char(old_value_), to_char(new_value_));
      ELSIF (tech_obj_ref_rec_.lu_name = 'LinastSegment') THEN
         Linast_Segment_API.Add_History_Journal_Entry(Client_SYS.Get_Key_Reference_Value(tech_obj_ref_rec_.key_ref, 'SEGMENT_SQ'),
                                                      Client_SYS.Get_Key_Reference_Value(tech_obj_ref_rec_.key_ref, 'REVISION_NO'),
                                                      attribute_, to_char(old_value_), to_char(new_value_));
      END IF;
   $END
END Acknowledge_Object___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN TECHNICAL_SPECIFICATION_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   IF (TECHNICAL_OBJECT_REFERENCE_API.Check_Approved(remrec_.technical_spec_no)) THEN
      Error_SYS.Record_General( 'TechnicalSpecNumeric',
         'NODELWHENAPPROVED: Not allowed to delete attribute when the specification is approved');
   END IF;
END Check_Delete___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     technical_specification_tab%ROWTYPE,
   newrec_ IN OUT technical_specification_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (indrec_.value_no = TRUE OR indrec_.lower_limit = TRUE OR indrec_.upper_limit = TRUE OR indrec_.info = TRUE) THEN
        IF (TECHNICAL_OBJECT_REFERENCE_API.Check_Approved(newrec_.technical_spec_no)) THEN
                Error_SYS.Record_General( 'TechnicalSpecNumeric', 'NOUPDATEWHENAPPROVED: Not allowed to update attribute when the specification is approved');
        END IF;      
   END IF;
END Check_Update___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     technical_specification_tab%ROWTYPE,
   newrec_     IN OUT technical_specification_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   tech_obj_ref_rec_  Technical_Object_Reference_API.Public_Rec;
BEGIN
   --Add pre-processing code here
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   --Add post-processing code here
   IF (nvl(to_char(newrec_.value_no), 'NULL') <> nvl(to_char(oldrec_.value_no), 'NULL')) THEN
      Acknowledge_Object___(newrec_.technical_spec_no, newrec_.attribute, newrec_.value_no, oldrec_.value_no);
   END IF; 
 
   tech_obj_ref_rec_ := Technical_Object_Reference_API.Get(newrec_.technical_spec_no);
   $IF Component_Plades_SYS.INSTALLED $THEN
      IF ((tech_obj_ref_rec_.lu_name = 'PlantObject') AND (nvl(newrec_.value_no,0) != nvl(oldrec_.value_no, 0))) THEN
         Plant_Sync_Cross_Ref_Attr_API.Set_Sync_Record(tech_obj_ref_rec_.lu_name, tech_obj_ref_rec_.key_ref, newrec_.attribute);
      END IF;
   $END
END Update___;

@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT technical_specification_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   tech_obj_ref_rec_  Technical_Object_Reference_API.Public_Rec;
BEGIN
   --Add pre-processing code here
   super(objid_, objversion_, newrec_, attr_);

   tech_obj_ref_rec_ := Technical_Object_Reference_API.Get(newrec_.technical_spec_no);
   $IF Component_Plades_SYS.INSTALLED $THEN
      IF ((tech_obj_ref_rec_.lu_name = 'PlantObject') AND (newrec_.value_no IS NOT NULL)) THEN
         Plant_Sync_Cross_Ref_Attr_API.Set_Sync_Record(tech_obj_ref_rec_.lu_name, tech_obj_ref_rec_.key_ref, newrec_.attribute);
      END IF;
   $END
END Insert___;





-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Copy_Values_ (
   technical_spec_no_old_ IN NUMBER,
   technical_spec_no_new_ IN NUMBER )
IS
   CURSOR tech_values IS
      SELECT attribute, technical_class,
             attrib_number, value_no,
             lower_limit, upper_limit,
             alt_value_no, alt_unit, info
      FROM TECHNICAL_SPEC_NUMERIC
      WHERE technical_spec_no = technical_spec_no_old_;
   lu_rec_     TECHNICAL_SPECIFICATION_TAB%ROWTYPE;
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   objversion_ VARCHAR2(26000);
   objid_      VARCHAR2(50);
BEGIN
   Trace_SYS.message('TECHNICAL_SPEC_NUMERIC_API.Copy_Values_('||technical_spec_no_old_||','||technical_spec_no_new_||')');
   FOR rec_ IN tech_values LOOP
      IF Try_Lock___(lu_rec_, technical_spec_no_new_, rec_.technical_class, rec_.attribute) THEN
         IF lu_rec_.value_no     IS not null OR
            lu_rec_.lower_limit  IS not null OR
            lu_rec_.upper_limit  IS not null OR
            lu_rec_.alt_value_no IS not null OR
            lu_rec_.alt_unit     IS not null OR
            lu_rec_.info         IS not null
         THEN
            Error_SYS.Record_General( lu_name_, 'VALUEXISTS: Not allowed to copy values when target exist.');
         END IF;

         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr( 'VALUE_NO', rec_.value_no, attr_ );
         Client_SYS.Add_To_Attr( 'LOWER_LIMIT', rec_.lower_limit, attr_ );
         Client_SYS.Add_To_Attr( 'UPPER_LIMIT', rec_.upper_limit, attr_ );
         Client_SYS.Add_To_Attr( 'ALT_VALUE_NO', rec_.alt_value_no, attr_ );
         Client_SYS.Add_To_Attr( 'ALT_UNIT', rec_.alt_unit, attr_ );
         Client_SYS.Add_To_Attr( 'INFO', rec_.info, attr_ );
         Get_Id_Version_By_Keys___(objid_, objversion_, lu_rec_.technical_spec_no, lu_rec_.technical_class, lu_rec_.attribute);
         Modify__ (info_, objid_, objversion_, attr_, 'DO');
      ELSE
         New__ (info_, objid_, objversion_, attr_, 'PREPARE');
         Client_SYS.Add_To_Attr( 'TECHNICAL_SPEC_NO', technical_spec_no_new_, attr_ );
         Client_SYS.Add_To_Attr( 'TECHNICAL_CLASS', rec_.technical_class, attr_ );
         Client_SYS.Add_To_Attr( 'ATTRIBUTE', rec_.attribute, attr_ );
         Client_SYS.Add_To_Attr( 'ATTRIB_NUMBER', rec_.attrib_number, attr_ );
         Client_SYS.Add_To_Attr( 'VALUE_NO', rec_.value_no, attr_ );
         Client_SYS.Add_To_Attr( 'LOWER_LIMIT', rec_.lower_limit, attr_ );
         Client_SYS.Add_To_Attr( 'UPPER_LIMIT', rec_.upper_limit, attr_ );
         Client_SYS.Add_To_Attr( 'ALT_VALUE_NO', rec_.alt_value_no, attr_ );
         Client_SYS.Add_To_Attr( 'ALT_UNIT', rec_.alt_unit, attr_ );
         Client_SYS.Add_To_Attr( 'INFO', rec_.info, attr_ );
         New__ (info_, objid_, objversion_, attr_, 'DO');
      END IF;

   END LOOP;
END Copy_Values_;


PROCEDURE Replace_Values_ (
   technical_spec_no_from_ IN NUMBER,
   technical_spec_no_to_ IN NUMBER,
   option_key_ IN NUMBER,
   group_name_ IN VARCHAR2 )
IS
   CURSOR tech_values IS
      SELECT t1.attribute, t1.technical_class class_from, t2.technical_class class_to,
             t1.attrib_number, t1.value_no, t1.ALT_VALUE_NO, t1.lower_limit, t1.upper_limit, t1.alt_unit,
             t1.info, t2.objid,t2.objversion
      FROM TECHNICAL_SPEC_NUMERIC t1, TECHNICAL_SPEC_NUMERIC t2
      WHERE t1.technical_spec_no = technical_spec_no_from_
        AND t2.technical_spec_no = technical_spec_no_to_
        AND t1.attribute = t2.attribute;

   CURSOR exist_in_group(technical_class_ IN VARCHAR2,
                         group_name_ IN VARCHAR2,
                         attribute_ IN VARCHAR2) IS
      SELECT 1
      FROM TECHNICAL_GROUP_SPEC_TAB
      WHERE technical_class = technical_class_
      AND group_name = group_name_
      AND attribute = attribute_;

   CURSOR get_unit(technical_class_ IN VARCHAR2, attribute_ IN VARCHAR2) IS
      SELECT unit
         FROM   technical_attrib_tab
         WHERE  rowtype LIKE '%TechnicalAttribNumeric'
         AND technical_class = technical_class_
         AND   attribute       = attribute_;
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   dummy_      NUMBER;
   from_unit_  VARCHAR2(10);
   to_unit_    VARCHAR2(10);
   conv_factor_ NUMBER;
BEGIN
   IF (group_name_ IS NOT NULL) THEN
      FOR rec_ IN tech_values LOOP

         OPEN  get_unit(rec_.class_from,rec_.attribute);
         FETCH get_unit INTO from_unit_;
         CLOSE get_unit;

         OPEN get_unit(rec_.class_to,rec_.attribute);
         FETCH get_unit INTO to_unit_;
         CLOSE get_unit;
         conv_factor_ := TECHNICAL_UNIT_CONV_API.Get_Conv_Factor(from_unit_, to_unit_);

         OPEN exist_in_group(rec_.class_from,group_name_,rec_.attribute);
         FETCH exist_in_group INTO dummy_;
         IF (exist_in_group%FOUND) THEN
            CLOSE exist_in_group;
            IF (option_key_ = 0) THEN
               Client_SYS.Clear_Attr(attr_);
               IF (rec_.value_no IS NOT NULL) THEN
                  IF (conv_factor_ IS NOT NULL) THEN
                     Client_SYS.Add_To_Attr( 'VALUE_NO', rec_.value_no*conv_factor_, attr_ );
                  ELSE
                     Client_SYS.Add_To_Attr( 'VALUE_NO', rec_.value_no, attr_ );
                  END IF;
               END IF;
               IF ( rec_.alt_value_no IS NOT NULL) THEN
                  IF (conv_factor_ IS NOT NULL) THEN
                     Client_SYS.Add_To_Attr( 'ALT_VALUE_NO', rec_.alt_value_no*conv_factor_, attr_ );
                  ELSE
                     Client_SYS.Add_To_Attr( 'ALT_VALUE_NO', rec_.alt_value_no, attr_ );
                  END IF;
               END IF;
               IF (rec_.lower_limit IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'LOWER_LIMIT', rec_.lower_limit, attr_ );
               END IF;
               IF (rec_.upper_limit IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'UPPER_LIMIT', rec_.upper_limit, attr_ );
               END IF;
               IF (rec_.alt_unit IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'ALT_UNIT', rec_.alt_unit, attr_ );
               END IF;
               IF (rec_.info IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'INFO', rec_.info, attr_ );
               END IF;
            ELSE
               Client_SYS.Clear_Attr(attr_);
               IF (conv_factor_ IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'VALUE_NO', rec_.value_no*conv_factor_, attr_ );
               ELSE
                  Client_SYS.Add_To_Attr( 'VALUE_NO', rec_.value_no, attr_ );
               END IF;
               IF (conv_factor_ IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'ALT_VALUE_NO', rec_.alt_value_no*conv_factor_, attr_ );
               ELSE
                  Client_SYS.Add_To_Attr( 'ALT_VALUE_NO', rec_.alt_value_no, attr_ );
               END IF;
               Client_SYS.Add_To_Attr( 'UPPER_LIMIT', rec_.upper_limit, attr_ );
               Client_SYS.Add_To_Attr( 'LOWER_LIMIT', rec_.lower_limit, attr_ );
               Client_SYS.Add_To_Attr( 'ALT_UNIT', rec_.alt_unit, attr_ );
               Client_SYS.Add_To_Attr( 'INFO', rec_.info, attr_ );               
            END IF;
            IF (attr_ IS NOT NULL) THEN
               Modify__ (info_, rec_.objid, rec_.objversion, attr_, 'DO');
            END IF;
         ELSE
            CLOSE exist_in_group;
         END IF;
      END LOOP;
   ELSE
      FOR rec_ IN tech_values LOOP
        OPEN  get_unit(rec_.class_from,rec_.attribute);
        FETCH get_unit INTO from_unit_;
        CLOSE get_unit;

        OPEN get_unit(rec_.class_to,rec_.attribute);
        FETCH get_unit INTO to_unit_;
        CLOSE get_unit;
        conv_factor_ := TECHNICAL_UNIT_CONV_API.Get_Conv_Factor(from_unit_, to_unit_);
        IF (option_key_ = 0) THEN
            Client_SYS.Clear_Attr(attr_);
            IF (rec_.value_no IS NOT NULL) THEN
               IF (conv_factor_ IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'VALUE_NO', rec_.value_no*conv_factor_, attr_ );
               ELSE
                  Client_SYS.Add_To_Attr( 'VALUE_NO', rec_.value_no, attr_ );
               END IF;
            END IF;
            IF (rec_.alt_value_no IS NOT NULL) THEN
               IF (conv_factor_ IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'ALT_VALUE_NO', rec_.alt_value_no*conv_factor_, attr_ );
               ELSE
                  Client_SYS.Add_To_Attr( 'ALT_VALUE_NO', rec_.alt_value_no, attr_ );
               END IF;
            END IF;
            IF (rec_.lower_limit IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'LOWER_LIMIT', rec_.lower_limit, attr_ );
            END IF;
            IF (rec_.upper_limit IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'UPPER_LIMIT', rec_.upper_limit, attr_ );
            END IF;
            IF (rec_.alt_unit IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'ALT_UNIT', rec_.alt_unit, attr_ );
            END IF;
            IF (rec_.info IS NOT NULL) THEN
               Client_SYS.Add_To_Attr( 'INFO', rec_.info, attr_ );
            END IF;
         ELSE
            Client_SYS.Clear_Attr(attr_);
            IF (conv_factor_ IS NOT NULL) THEN
               Client_SYS.Add_To_Attr( 'VALUE_NO', rec_.value_no*conv_factor_, attr_ );
            ELSE
               Client_SYS.Add_To_Attr( 'VALUE_NO', rec_.value_no, attr_ );
            END IF;
            IF (conv_factor_ IS NOT NULL) THEN
               Client_SYS.Add_To_Attr( 'ALT_VALUE_NO', rec_.alt_value_no*conv_factor_, attr_ );
            ELSE
               Client_SYS.Add_To_Attr( 'ALT_VALUE_NO', rec_.alt_value_no, attr_ );
            END IF;
            Client_SYS.Add_To_Attr( 'UPPER_LIMIT', rec_.upper_limit, attr_ );
            Client_SYS.Add_To_Attr( 'LOWER_LIMIT', rec_.lower_limit, attr_ );
            Client_SYS.Add_To_Attr( 'ALT_UNIT', rec_.alt_unit, attr_ );
            Client_SYS.Add_To_Attr( 'INFO', rec_.info, attr_ );
         END IF;
         IF (attr_ IS NOT NULL) THEN
            Modify__ (info_, rec_.objid, rec_.objversion, attr_, 'DO');
         END IF;
      END LOOP;
   END IF;
END Replace_Values_;


-- Sync_Values_
--   Deletes technical spec values with rowtype TechnicalSpecNumeric
--   of technical_spec_no_new_ if they are missing for technical_spec_no_old_.
PROCEDURE Sync_Values_ (
   technical_spec_no_old_ IN NUMBER,
   technical_spec_no_new_ IN NUMBER )
IS
   objversion_ VARCHAR2(26000);
   objid_      VARCHAR2(50);            
   remrec_     technical_specification_tab%ROWTYPE;
   --
   CURSOR obsolete_values IS
      SELECT *
      FROM TECHNICAL_SPEC_NUMERIC
      WHERE technical_spec_no = technical_spec_no_new_
      AND attribute NOT IN (SELECT attribute
                            FROM TECHNICAL_SPEC_NUMERIC
                            WHERE technical_spec_no = technical_spec_no_old_);
BEGIN

   FOR rec_ IN obsolete_values LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.technical_spec_no, rec_.technical_class, rec_.attribute);   
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Delete___ (objid_, remrec_);   
   END LOOP;
END Sync_Values_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Select_Statement (
   technical_class_ IN VARCHAR2,
   table_prefix_    IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Technical_Specification_API.Get_Select_Statement(technical_class_, table_prefix_);
END Get_Select_Statement;


@UncheckedAccess
FUNCTION Get_Defined_Count (
   technical_spec_no_ IN NUMBER,
   technical_class_   IN VARCHAR2 ) RETURN NUMBER
IS
   numer_count_ NUMBER;
BEGIN
   SELECT
             Count(*)
      INTO numer_count_
      FROM TECHNICAL_SPEC_NUMERIC
      WHERE technical_spec_no = technical_spec_no_ AND
            technical_class = technical_class_ AND
            value_no IS NOT NULL;
   RETURN numer_count_ ;
END Get_Defined_Count;


@UncheckedAccess
FUNCTION Get_Summary (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
   summary_ VARCHAR2(32000);
   CURSOR get_summary IS
      SELECT nvl(ta.summary_prefix, ta.attribute||'=') prefix,
             ts.value_no,
             Technical_Attrib_Numeric_API.Get_Technical_Unit_(ts.technical_class, ts.attribute) unit
      FROM  TECHNICAL_SPEC_NUMERIC ts, technical_attrib_tab ta
      WHERE ts.technical_spec_no = technical_spec_no_
      AND   ta.technical_class = ts.technical_class
      AND   ta.attribute       = ts.attribute
      AND   ts.value_no IS NOT NULL
      AND   ta.summary = '2'
      ORDER BY ta.attrib_number;
BEGIN
   summary_ := '';
   FOR item IN get_summary LOOP
      summary_:= summary_ || item.prefix || item.value_no || item.unit ||', ';
   END LOOP;
   RETURN summary_;
END Get_Summary;


FUNCTION Check_Tech_Exist (
   technical_spec_no_ IN NUMBER,
   technical_class_   IN VARCHAR2,
   attribute_         IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   NULL;
   --   RETURN Technical_Specification_API.Check_Tech_Exist(technical_spec_no_, technical_class_, attribute_);
END Check_Tech_Exist;


PROCEDURE Delete_Specifications (
   technical_spec_no_ IN NUMBER )
IS
   objversion_ VARCHAR2(26000);
   objid_      VARCHAR2(50);            
   remrec_     technical_specification_tab%ROWTYPE;
   CURSOR get_specification IS
      SELECT *
      FROM TECHNICAL_SPEC_NUMERIC
      WHERE technical_spec_no = technical_spec_no_;
BEGIN
   FOR rec_ IN get_specification LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.technical_spec_no, rec_.technical_class, rec_.attribute);   
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Delete___ (objid_, remrec_);
   END LOOP;
END Delete_Specifications;


PROCEDURE Refresh_Order (
   technical_class_ IN VARCHAR2,
   attribute_       IN VARCHAR2,
   order_           IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   objversion_ VARCHAR2(26000);
   objid_      VARCHAR2(50);
   --
   CURSOR all_attributes (tech_class_ VARCHAR2,
   attribute2_ VARCHAR2) IS
      SELECT objid, objversion
      FROM TECHNICAL_SPEC_NUMERIC
      WHERE technical_class = tech_class_
      AND attribute = attribute2_;
BEGIN
   FOR rec_ IN all_attributes(technical_class_,
      attribute_) LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ATTRIB_NUMBER', order_, attr_ );
      objid_ := rec_.objid;
      objversion_ := rec_.objversion;
      Modify__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
END Refresh_Order;


PROCEDURE Set_Value_No (
   technical_spec_no_ IN NUMBER,
   attribute_ IN VARCHAR2,
   value_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(2000);
   CURSOR get_id_version IS
      SELECT rowid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS')
      FROM  technical_specification_tab
      WHERE technical_spec_no = technical_spec_no_
      AND attribute = attribute_;
BEGIN
   OPEN get_id_version;
   FETCH get_id_version INTO objid_, objversion_ ;
   IF get_id_version%NOTFOUND THEN
      CLOSE get_id_version;
      Error_SYS.Record_Removed(lu_name_);
   END IF;
   CLOSE get_id_version;
   Client_SYS.Add_To_Attr('VALUE_NO',value_, attr_);
   Modify__(info_,objid_,objversion_,attr_,'DO');
END Set_Value_No;


-- Recalculate_Value
--   This function will recalculate the value when the unit is changed.
FUNCTION Recalculate_Value (
   value_    IN NUMBER,
   old_unit_ IN VARCHAR2,
   new_unit_ IN VARCHAR2 ) RETURN VARCHAR2
IS
  base_unit_ Iso_Unit.Base_Unit%type;
  old_factor_ Iso_Unit_Def.Multi_Factor%type;
  new_factor_ Iso_Unit_Def.Multi_Factor%type;
  new_value_ VARCHAR2(100);

  CURSOR BaseUnitCur IS
    SELECT Base_Unit
      FROM Iso_Unit
      WHERE Unit_Code = Old_Unit_;

  CURSOR UnitInfoCur IS
    SELECT Ten_Power, Unit_Code, Multi_Factor, Div_Factor,
           power(10, ten_power)*multi_factor m_factor,
           1/(power(10, ten_power)*div_factor) d_factor
      FROM Iso_Unit
      WHERE Base_Unit = base_unit_
        AND Unit_Code IN (Old_Unit_, New_Unit_)
      ORDER BY m_factor, d_factor desc;

BEGIN
  FOR GetBaseUnit IN BaseUnitCur LOOP
    base_unit_ := GetBaseUnit.Base_Unit;
  END LOOP;
  FOR GetUnitInfo IN UnitInfoCur LOOP
    IF old_unit_ = new_unit_ THEN
      IF GetUnitInfo.m_Factor != 1 THEN
        old_factor_ := GetUnitInfo.m_Factor;
      ELSIF GetUnitInfo.d_Factor != 1 THEN
        old_factor_ := GetUnitInfo.d_Factor;
      ELSE
        old_factor_ := GetUnitInfo.m_Factor;
      END IF;
      new_factor_ := old_factor_;
    ELSIF GetUnitInfo.Unit_Code = old_unit_ THEN
      IF GetUnitInfo.m_Factor != 1 THEN
        old_factor_ := GetUnitInfo.m_Factor;
      ELSIF GetUnitInfo.d_Factor != 1 THEN
        old_factor_ := GetUnitInfo.d_Factor;
      ELSE
        old_factor_ := GetUnitInfo.m_Factor;
      END IF;
    ELSIF GetUnitInfo.Unit_Code = new_unit_ THEN
      IF GetUnitInfo.m_Factor != 1 THEN
        new_factor_ := GetUnitInfo.m_Factor;
      ELSIF GetUnitInfo.d_Factor != 1 THEN
        new_factor_ := GetUnitInfo.d_Factor;
      ELSE
        new_factor_ := GetUnitInfo.m_Factor;
      END IF;
    END IF;
  END LOOP;
  IF old_factor_ = new_factor_ THEN
    RETURN value_;
  ELSE
    new_value_ := TO_CHAR(value_*1/(new_factor_/old_factor_));
  END IF;
  RETURN new_value_;
EXCEPTION
  WHEN others THEN
    IF BaseUnitCur%ISOPEN THEN
      CLOSE BaseUnitCur;
    END IF;
    IF UnitInfoCur%ISOPEN THEN
      CLOSE UnitInfoCur;
    END IF;
    RETURN value_;
END Recalculate_Value;


-- Get_Summary_All
--   Return a string with all attributes with
--   ( Alphanumeric : { [ Attribute ] || Value Text ) }
--   ( Numeric : { [ Attribute ] || Value No || Unit }
FUNCTION Get_Summary_All (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
   summary_ VARCHAR2(32000);
   CURSOR get_summary IS
      SELECT ta.attribute||'=' prefix,
             ts.value_no,
             Technical_Attrib_Numeric_API.Get_Technical_Unit_(ts.technical_class, ts.attribute) unit
      FROM  TECHNICAL_SPEC_NUMERIC ts, technical_attrib_tab ta
      WHERE ts.technical_spec_no = technical_spec_no_
      AND   ta.technical_class = ts.technical_class
      AND   ta.attribute       = ts.attribute
      ORDER BY ta.attrib_number;
BEGIN
   summary_ := '';
   FOR item IN get_summary LOOP
      summary_:= summary_ || item.prefix || item.value_no || item.unit ||'^';
   END LOOP;
   RETURN summary_;
END Get_Summary_All;


-- Modify
--   Public method that wraps the private modify method.
PROCEDURE Modify (
   technical_spec_no_ IN NUMBER,
   technical_class_ IN VARCHAR2,
   attribute_ IN VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objversion_ VARCHAR2(26000);
   objid_      VARCHAR2(50);            
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, technical_spec_no_, technical_class_, attribute_);
   Modify__ (info_, objid_, objversion_, attr_, 'DO');
END Modify;



