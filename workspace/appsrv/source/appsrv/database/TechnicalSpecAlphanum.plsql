-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalSpecAlphanum
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960620  JoRo  Created
--  960906  JoRo  Modified method Get_Summary to just return a summary of all
--                attributes that has a value and is marked as 'Include' in
--                TechnicalAttrib
--  960910  JoRo  Modified Ref on attribute
--  960911  JoRo  Added method Copy_Values_ and interchanged some columns in view
--  961205  JoRo  Removed commit in method Copy_Values_. Added DbTransaction...
--                in client instead
--  970219  frtv  Upgraded.
--  970225  JoRo  Added method Delete_Specifications
--  970312  JoRo  Added MODULE = APPSRV
--  970314  frtv  Added calls to Check_Approve...
--  980320  JaPa  Changes in Copy_Values_(), added new function Try_Lock___().
--  001029  LEIV  Added new method Get_Summary_All for PDM CAD interface
--  001031  LEIV  Added new public method Modify
--  010612  Larelk Added General_SYS.Init_Method in Get_Select_Statement,
--                 Check_Tech_Exist,Refresh_Order ,Get_Summary_All.
--  050914  NeKolk B 127059 Added View TECH_SPEC_GRP_ALPHANUM .
--  051022  SukMlk Merged into Edge new methods Compare_And_Modify() and Build_Table() to store
--                 attribute values from Premevera and compare with the values saved. (Bug#53201)
--  110701  INMALK Bug Id 97858, Added validation for inability to allow the updation of 
--                 field INFO when technical specification is Approved.
--  --------------------------Eagle------------------------------------------
--  100422  Ajpelk Merge rose method documentation
--  120604  NIFRSE Bug Id 102287, Changed the referal from VIEW to TABLE in the cursor in Try_Lock__
--  121012  UdGnlk Bug 102701, Added new PROCEDURE Sync_Values_.
--  --------------------------- APPS 9 --------------------------------------
--  130619  heralk  Scalability Changes - removed global variables
--  --------------------------- APPS 9 --------------------------------------
--  131128  NuKuLK  Hooks: Refactored and splitted code.
--  131203  NuKuLK  PBSA-2923, Modified Check_Update___()
--  131107  INMALK  CAR-1380, Added the method Acknowledge_Object___() to handle events when an attribute value is changed
--  140721  KrRaLK  PRSA-1618, Added Set_Value_Text().
-----------------------------------------------------------------------------
--  170420  SaDeLK  STRSA-23051, Modified Check_Update__().
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
      AND    rowtype like 'TechnicalSpecAlphanum'
      FOR UPDATE NOWAIT;
BEGIN
   Trace_SYS.message('TECHNICAL_SPEC_ALPHANUM_API.Try_Lock___('||technical_spec_no_||','||technical_class_||','||attribute_||')');
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
--  IF Linear Asset, enter a history record mentioning the change of the attribute value
--  IF Linear Asset Segments, enter a history record mentioning the change of the attribute value
PROCEDURE Acknowledge_Object___ (
   technical_spec_no_   IN NUMBER,
   attribute_           IN VARCHAR2,
   new_value_           IN VARCHAR2,
   old_value_           IN VARCHAR2   )
IS
   tech_obj_ref_rec_    Technical_Object_Reference_API.Public_Rec;
BEGIN
   Log_SYS.Stack_Trace_(Log_SYS.info_, 'Technical_Spec_Alphanum_API.Acknowledge_Object___');
   tech_obj_ref_rec_ := Technical_Object_Reference_API.Get(technical_spec_no_);
   
   $IF Component_Linast_SYS.INSTALLED $THEN
      IF (tech_obj_ref_rec_.lu_name = 'LinastLinearAsset') THEN
         Linast_Linear_Asset_API.Add_History_Journal_Entry(Client_SYS.Get_Key_Reference_Value(tech_obj_ref_rec_.key_ref, 'LINEAR_ASSET_SQ'),
                  Client_SYS.Get_Key_Reference_Value(tech_obj_ref_rec_.key_ref, 'LINEAR_ASSET_REVISION_NO'),
                  attribute_, old_value_, new_value_);
      ELSIF (tech_obj_ref_rec_.lu_name = 'LinastSegment') THEN
         Linast_Segment_API.Add_History_Journal_Entry(Client_SYS.Get_Key_Reference_Value(tech_obj_ref_rec_.key_ref, 'SEGMENT_SQ'),
                  Client_SYS.Get_Key_Reference_Value(tech_obj_ref_rec_.key_ref, 'REVISION_NO'),
                  attribute_, old_value_, new_value_);
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
      Error_SYS.Record_General( 'TechnicalSpecAlphanum',
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
   Error_SYS.Check_Not_Null(lu_name_, 'TECHNICAL_SPEC_NO', newrec_.technical_spec_no);
   Error_SYS.Check_Not_Null(lu_name_, 'TECHNICAL_CLASS', newrec_.technical_class);
   Error_SYS.Check_Not_Null(lu_name_, 'ATTRIBUTE', newrec_.attribute);
   IF (indrec_.value_text OR indrec_.info) THEN
       IF (TECHNICAL_OBJECT_REFERENCE_API.Check_Approved(newrec_.technical_spec_no)) THEN
           Error_SYS.Record_General( 'TechnicalSpecAlphanum', 'NOUPDATEWHENAPPROVED: Not allowed to update attribute when the specification is approved');
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
   IF (nvl(newrec_.value_text, 'NULL') <> nvl(oldrec_.value_text, 'NULL')) THEN
      Acknowledge_Object___(newrec_.technical_spec_no, newrec_.attribute, newrec_.value_text, oldrec_.value_text);
   END IF;

   tech_obj_ref_rec_ := Technical_Object_Reference_API.Get(newrec_.technical_spec_no);
   $IF Component_Plades_SYS.INSTALLED $THEN
      IF ((tech_obj_ref_rec_.lu_name = 'PlantObject') AND (nvl(newrec_.value_text,chr(30)) != nvl(oldrec_.value_text, chr(30)))) THEN
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
      IF ((tech_obj_ref_rec_.lu_name = 'PlantObject') AND (newrec_.value_text IS NOT NULL)) THEN
         Plant_Sync_Cross_Ref_Attr_API.Set_Sync_Record(tech_obj_ref_rec_.lu_name, tech_obj_ref_rec_.key_ref, newrec_.attribute);
      END IF;
   $END
END Insert___;




PROCEDURE Check_Value_Text_Ref___ (
   newrec_ IN OUT technical_specification_tab%ROWTYPE )
IS
BEGIN
   Technical_Attrib_Text_API.Validate_Text(newrec_.technical_class, newrec_.attribute, newrec_.value_text);
END Check_Value_Text_Ref___;






-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Copy_Values_ (
   technical_spec_no_old_ IN NUMBER,
   technical_spec_no_new_ IN NUMBER )
IS
   CURSOR tech_values IS
      SELECT attribute, technical_class,
             attrib_number, value_text,
             info
      FROM TECHNICAL_SPEC_ALPHANUM
      WHERE technical_spec_no = technical_spec_no_old_;
   lu_rec_     TECHNICAL_SPECIFICATION_TAB%ROWTYPE;
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   objversion_ VARCHAR2(26000);
   objid_      VARCHAR2(50);
BEGIN
   Trace_SYS.message('TECHNICAL_SPEC_ALPHANUM_API.Copy_Values_('||technical_spec_no_old_||','||technical_spec_no_new_||')');
   FOR rec_ IN tech_values LOOP
      IF Try_Lock___(lu_rec_, technical_spec_no_new_, rec_.technical_class, rec_.attribute) THEN
         IF lu_rec_.value_text IS not null OR lu_rec_.info IS not null THEN
            Error_SYS.Record_General( lu_name_, 'VALUEXISTS: Not allowed to copy values when target exist.');
         END IF;
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr( 'VALUE_TEXT', rec_.value_text, attr_ );
         Client_SYS.Add_To_Attr( 'INFO', rec_.info, attr_ );
         Get_Id_Version_By_Keys___ (objid_, objversion_, lu_rec_.technical_spec_no, lu_rec_.technical_class, lu_rec_.attribute);
         Modify__ (info_, objid_, objversion_, attr_, 'DO');
      ELSE
         New__ (info_, objid_, objversion_, attr_, 'PREPARE');
         Client_SYS.Add_To_Attr( 'TECHNICAL_SPEC_NO', technical_spec_no_new_, attr_ );
         Client_SYS.Add_To_Attr( 'TECHNICAL_CLASS', rec_.technical_class, attr_ );
         Client_SYS.Add_To_Attr( 'ATTRIBUTE', rec_.attribute, attr_ );
         Client_SYS.Add_To_Attr( 'ATTRIB_NUMBER', rec_.attrib_number, attr_ );
         Client_SYS.Add_To_Attr( 'VALUE_TEXT', rec_.value_text, attr_ );
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
      SELECT t1.attribute, t1.technical_class,
             t1.attrib_number, t1.value_text,
             t1.info, t2.objid,t2.objversion
      FROM TECHNICAL_SPEC_ALPHANUM t1, TECHNICAL_SPEC_ALPHANUM t2
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
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   dummy_      NUMBER;
BEGIN
   IF (group_name_ IS NOT NULL) THEN
      FOR rec_ IN tech_values LOOP
         OPEN exist_in_group(rec_.technical_class,group_name_,rec_.attribute);
         FETCH exist_in_group INTO dummy_;
         IF (exist_in_group%FOUND) THEN
            CLOSE exist_in_group;
            IF (option_key_ = 0) THEN
               Client_SYS.Clear_Attr(attr_);
               IF (rec_.value_text IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'VALUE_TEXT', rec_.value_text, attr_ );
               END IF;
               IF (rec_.info IS NOT NULL) THEN
                  Client_SYS.Add_To_Attr( 'INFO', rec_.info, attr_ );
               END IF;
            ELSE
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr( 'VALUE_TEXT', rec_.value_text, attr_ );
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
         IF (option_key_ = 0) THEN
            Client_SYS.Clear_Attr(attr_);
            IF (rec_.value_text IS NOT NULL) THEN
               Client_SYS.Add_To_Attr( 'VALUE_TEXT', rec_.value_text, attr_ );
            END IF;
            IF (rec_.info IS NOT NULL) THEN
               Client_SYS.Add_To_Attr( 'INFO', rec_.info, attr_ );
            END IF;
         ELSE
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr( 'VALUE_TEXT', rec_.value_text, attr_ );
            Client_SYS.Add_To_Attr( 'INFO', rec_.info, attr_ );
         END IF;
         IF (attr_ IS NOT NULL) THEN
            Modify__ (info_, rec_.objid, rec_.objversion, attr_, 'DO');
         END IF;
      END LOOP;
   END IF;
END Replace_Values_;


-- Sync_Values_
--   Deletes technical spec values with rowtype TechnicalSpecAlphanum
--   of technical_spec_no_new_ if they are missing for technical_spec_no_old_.
PROCEDURE Sync_Values_ (
   technical_spec_no_old_ IN NUMBER,
   technical_spec_no_new_ IN NUMBER )
IS
   CURSOR obsolete_values IS
      SELECT *
      FROM TECHNICAL_SPEC_ALPHANUM
      WHERE technical_spec_no = technical_spec_no_new_
      AND attribute NOT IN (SELECT attribute
                            FROM TECHNICAL_SPEC_ALPHANUM
                            WHERE technical_spec_no = technical_spec_no_old_);
   remrec_ technical_specification_tab%ROWTYPE;
BEGIN
   FOR specrec_ IN obsolete_values LOOP
      remrec_ := Get_Object_By_Id___(specrec_.objid);
      Delete___ (specrec_.objid, remrec_);
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
   alpha_count_ NUMBER;
BEGIN
   SELECT
             Count(*)
      INTO alpha_count_
      FROM TECHNICAL_SPEC_ALPHANUM
      WHERE technical_spec_no = technical_spec_no_ AND
            technical_class = technical_class_ AND
            value_text IS NOT NULL;
   RETURN alpha_count_ ;
END Get_Defined_Count;


@UncheckedAccess
FUNCTION Get_Summary (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
   summary_ VARCHAR2(32000);
   CURSOR get_summary IS
      SELECT nvl(ta.summary_prefix, ta.attribute||'=') prefix,
             ts.value_text
      FROM TECHNICAL_SPEC_ALPHANUM ts, technical_attrib_tab ta
      WHERE ts.technical_spec_no = technical_spec_no_
      and   ta.technical_class = ts.technical_class
      and   ta.attribute       = ts.attribute
      AND   ts.value_text IS NOT NULL
      AND   ta.summary = '2'
      ORDER BY ta.attrib_number;
BEGIN
   summary_ := '';
   FOR item IN get_summary LOOP
      summary_:= summary_ || item.prefix || item.value_text || ', ';
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
   CURSOR get_specification IS
      SELECT *
      FROM TECHNICAL_SPEC_ALPHANUM
      WHERE technical_spec_no = technical_spec_no_;
   remrec_ technical_specification_tab%ROWTYPE;
BEGIN
   FOR techspec_ IN get_specification LOOP
      remrec_ := Get_Object_By_Id___(techspec_.objid);
      Delete___ (techspec_.objid, remrec_);
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
      FROM TECHNICAL_SPEC_ALPHANUM
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


FUNCTION Get_Summary_All (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
   summary_ VARCHAR2(32000);
   CURSOR get_summary IS
      SELECT ta.attribute||'=' prefix,
             ts.value_text
      FROM TECHNICAL_SPEC_ALPHANUM ts, technical_attrib_tab ta
      WHERE ts.technical_spec_no = technical_spec_no_
      and   ta.technical_class = ts.technical_class
      and   ta.attribute       = ts.attribute
      ORDER BY ta.attrib_number;
BEGIN
   summary_ := '';
   FOR item IN get_summary LOOP
      summary_:= summary_ || item.prefix || item.value_text || '^';
   END LOOP;
   RETURN summary_;
END Get_Summary_All;


-- Modify
--   Public method that wraps around private Modify-method
--   fllowing methods are used in Premevera import
--   Used this concept to increase prformance by reducing database calls from VB client.
PROCEDURE Modify (
   technical_spec_no_ IN NUMBER,
   technical_class_ IN VARCHAR2,
   attribute_ IN VARCHAR2,
   attr_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   new_attr_   VARCHAR2(32000);
   CURSOR get_object IS
      SELECT objid, objversion
      FROM   TECHNICAL_SPEC_ALPHANUM
      WHERE  technical_spec_no = technical_spec_no_
      AND    technical_class = technical_class_
      AND    attribute = attribute_;
BEGIN
   FOR object_ IN get_object LOOP
      Modify__(info_, object_.objid, object_.objversion, new_attr_, 'CHECK');
      new_attr_ := new_attr_ || attr_;
      Modify__(info_, object_.objid, object_.objversion, new_attr_, 'DO');
   END LOOP;
END Modify;


PROCEDURE Build_Table (
   attribute_  IN VARCHAR2,
   count_      IN NUMBER )
IS 
BEGIN
   App_Context_SYS.Set_Value('TechnicalSpecAlphanum.Attributes - '||count_, attribute_); 
END Build_Table;  


PROCEDURE Compare_And_Modify (
   technical_spec_no_ IN NUMBER,
   count_             IN NUMBER )
IS
  CURSOR get_all_attr IS 
     SELECT attribute,technical_class,objid,objversion
     FROM   TECHNICAL_SPEC_ALPHANUM
     WHERE  technical_spec_no = technical_spec_no_;
  existsinp3_      BOOLEAN ; 
  attr_            VARCHAR2(32000);
  info_            VARCHAR2(2000);
BEGIN

   existsinp3_ := TRUE;
   FOR all_attributes IN get_all_attr LOOP
      FOR i_ IN 1..count_ LOOP
         IF (App_Context_SYS.Exists('TechnicalSpecAlphanum.Attributes - '||i_)) THEN
            IF all_attributes.attribute = App_Context_SYS.Get_Value('TechnicalSpecAlphanum.Attributes - '||i_) THEN
               existsinp3_ := TRUE;
               EXIT;
            ELSE
               existsinp3_ := FALSE;
            END IF;
         ELSE
            existsinp3_ := FALSE;
         END IF;
      END LOOP; 
      
      IF NOT existsinp3_  THEN
         Client_Sys.Clear_Attr(attr_);
         Client_Sys.Add_To_Attr('VALUE_TEXT','',attr_);
         Modify__(info_,all_attributes.objid,all_attributes.objversion,attr_,'DO');
      END IF;     
   END LOOP; 

END Compare_And_Modify;

PROCEDURE Set_Value_Text (
   technical_spec_no_ IN NUMBER,
   attribute_ IN VARCHAR2,
   value_ IN VARCHAR2 )
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
   Client_SYS.Add_To_Attr('VALUE_TEXT',value_, attr_);
   Modify__(info_,objid_,objversion_,attr_,'DO');
END Set_Value_Text;



