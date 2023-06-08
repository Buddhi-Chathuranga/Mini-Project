-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalSpecification
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  9608xx  JoRo  Created
--  960908  JoRo  Corrected error in Get_Summary
--  960911  JoRo  Added method Copy_Values_
--  970219  frtv  Upgraded.
--  970225  JoRo  Added method Delete_Specifications
--  970306  JoRo  Added rowtype in view TECHNICAL_SPECIFICATION_BOTH
--  970410  frtv  Added Get_Select_Statement...
--  970530  JaPa  Direct table access replaced by view TECHNICAL_ATTRIB_BOTH
--                (defined in TechnicalAttrib LU) in Get_Select_Statement()
--  970624  JaPa  Table prefix added to procedure call in Get_Select_Statement()
--  980320  JaPa  Added support for both key_ref and key_value.
--                New view TECHNICAL_SPECIFICATION_ATTR2.
--  001030  LEIV  Added method Get_Summary_All for PDM CAD interface
--  010612  Larelk Bug 22173,Added General_SYS.Init_Method in Copy_Values_,
--                 Refresh_Order,Get_Summary_All.
--  020902  LeSvse Bug 31945, Added 2 new methods,Get_Summary1 and Get_Summary_Alpha_Num
--  021212  ZAHALK Did the SP3 - Merge for Take-off.
--  030627 Larelk Bug 36731  corrected in Get_Select_Statement()
--  030829 Larelk Bug 37561  corrected in Get_Select_Statement() use
--                Language_Sys.Translate_Constant() for object id and object description.
--  030901 Larelk Bug 37561 remove constant key  defined earlier and increased the variable length 
--  030919 Larelk Bug 37103 write a function inside method Get_Select_Statement() to reduce the buffer length.
--                if the length of the unitcode is greater than 18 chars it is only display with .. and without 
--                the attrubute description.There is a limitation for length of field name in centura for 
--                dynamically created tables.
--  031002 Larelk Bug 37103 limited adding values to the buffer_ up to length 2000 ,Cursor is not closed when 
--                exit from for loop so change the code;         
--  031029 ErHoUS Added a Call to General_SYS.Init_Method in Get_Summary1 and Get_Summary_Alpha_Num.
--  031103 AtSilk Call 109666, changed the length of buffer_ to 32000 in Get_Select_Statement.
--  050907 NeKolk AMUT 115:Isolation and Permits: Added VIEW3,VIEW4,VIEW5.
--  050914 NeKolk B 127059 Removed TECH_SPEC_GRP_ALPHANUM and TECHNICAL_SPEC_GRP_NUM.
--  081216 CHALLK Increase buffer length of some variables inside Get_Select_Statement function (Bug#79300)
--  090415 CHALLK Modified Get_Select_Statement, added procedures All_Attributes___, Summery_Included_Attributes___
--                to achieve filtering for summery included Technical class attributes.(Bug#82011)
--  090901 NABALK Certified the assert safe for dynamic SQLs (Bug#84218)
--  --------------------------Eagle------------------------------------------
--  100422 Ajpelk Merge rose method documentation 
--  110517 Nifrse Added a new view TECHNICAL_SPEC_GRP_EXT_DETAILS for Middle_tier (lu-wrapper)
--  110520 Nifrse EASTONE-16022: Removed the filter on the BASE view "WHERE rowtype like '%&LU'"
--  120605 MAZPSE Bug Id 102603, Increased the length of the alias for attribute description shown in Get_Select_Statement().
--  121012 KiSalk Bug 102701, Added new PROCEDURE Sync_Values
--  -------------------------- APPS 9 ---------------------------------------
--  131129 paskno Hooks: refactoring and splitting.
--  140721 KrRaLK PRSA-1618, Added Modify_Attribute_Value().
--  171127 BAKALK STRSA-30007, Changed some variable type to clobe from varchar2 for better capacity
--  -------------------------- APPS 10 ---------------------------------------
--  190517 SSILLK Bug ID 148328, Changed unit1_ variable value conditionally in  Make_Select_Statement
--  190617 SSILLK Bug ID 144019, Modified Make_Select_Statement().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE All_Attributes___ (
   technical_class_    VARCHAR2,
   p_cursor_          OUT SYS_REFCURSOR )
IS
BEGIN
   @ApproveDynamicStatement(2009-09-01,nabalk)
   OPEN p_cursor_ FOR
   SELECT T1.attribute, T2.unit, T2.attrib_number, T2.rowtype
      FROM technical_specification_both T1, technical_attrib_both T2
      WHERE T1.technical_class = technical_class_ AND
            T1.technical_class = T2.technical_class (+) AND
            T1.attribute = T2.attribute (+) AND
            (T1.value_no IS NOT NULL OR T1.value_text IS NOT NULL)
      GROUP BY T1.attribute, T2.unit, T2.attrib_number, T2.rowtype
      ORDER BY T2.attrib_number, T2.rowtype DESC;
END All_Attributes___;


PROCEDURE Summery_Included_Attributes___ (
   technical_class_    VARCHAR2,
   p_cursor_          OUT SYS_REFCURSOR )
IS
BEGIN
   @ApproveDynamicStatement(2009-09-01,nabalk)
   OPEN p_cursor_ FOR
   SELECT T1.attribute, T2.unit, T2.attrib_number, T2.rowtype
      FROM technical_specification_both T1, technical_attrib_both T2
      WHERE T1.technical_class = technical_class_ AND
            T1.technical_class = T2.technical_class (+) AND
            T1.attribute = T2.attribute (+) AND
            (T1.value_no IS NOT NULL OR T1.value_text IS NOT NULL) AND
            T2.summary_db = '2'
      GROUP BY T1.attribute, T2.unit, T2.attrib_number, T2.rowtype
      ORDER BY T2.attrib_number, T2.rowtype DESC;
END Summery_Included_Attributes___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT technical_specification_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   indrec_.attribute := FALSE;
   super(newrec_, indrec_, attr_);
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Copy_Values_ (
   technical_spec_no_old_ IN NUMBER,
   technical_spec_no_new_ IN NUMBER )
IS
BEGIN

   Trace_SYS.message('TECHNICAL_SPECIFICATION_API.Copy_Values_('||technical_spec_no_old_||','||technical_spec_no_new_||')');
   Technical_Spec_Numeric_API.Copy_Values_(technical_spec_no_old_, technical_spec_no_new_);
   Technical_Spec_Alphanum_API.Copy_Values_(technical_spec_no_old_, technical_spec_no_new_);
END Copy_Values_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Select_Statement (
   technical_class_ IN VARCHAR2,
   table_prefix_    IN VARCHAR2) RETURN VARCHAR2
IS
   truncated_ VARCHAR2(10);
   select_statment_ CLOB;
BEGIN
   
   TECHNICAL_SPECIFICATION_API.Make_Select_Statement(technical_class_,table_prefix_,truncated_,select_statment_);
   RETURN select_statment_;
END Get_Select_Statement;

PROCEDURE Make_Select_Statement (
   technical_class_ IN VARCHAR2,
   table_prefix_    IN VARCHAR2,
   truncated_       IN OUT VARCHAR2,
   select_statment_ IN OUT CLOB) 
IS
   result_      CLOB;
   buffer_      CLOB;
   part1_       CLOB;
   part2_       CLOB;
   part3_       CLOB;
   part4_       CLOB;
   part5_       CLOB;
   count_       NUMBER;
   id_          VARCHAR2(100);
   id0_         VARCHAR2(100);
   desc_        VARCHAR2(2000);
   desc1_       VARCHAR2(2000); 
   unit1_       VARCHAR2(30);
   attribute1_  VARCHAR2(20);
   attr_num1_   NUMBER;
   row_type1_   VARCHAR2(30);
   alpha_attr_ VARCHAR2(1000);
   value_      NUMBER;
   bitecount_  NUMBER;
   startchr_   NUMBER;
   endchr_     NUMBER;
   parta1_     VARCHAR2(1000);
   objtypecons_     VARCHAR2(80):= Language_SYS.Translate_Constant(lu_name_, 'OBJTYPE: Object Type');
   objectkeycons_   VARCHAR2(80):= Language_SYS.Translate_Constant(lu_name_, 'OBJEKEY: Object Key');
   objectdesccons_   VARCHAR2(80):= Language_SYS.Translate_Constant(lu_name_, 'OBJEDES: Object Description');
   TYPE r_cursor_    IS REF CURSOR;
   all_attributes_   r_cursor_;  
   attr_limit_ NUMBER := 30000;

   FUNCTION STRID_(count_ IN NUMBER) RETURN VARCHAR2
   IS
      result2_ VARCHAR2(2000);
   BEGIN
      result2_ := 'T' || TO_CHAR(count_);
      RETURN result2_;
   END STRID_;

   FUNCTION Get_Field_Name(
      attribute_ IN VARCHAR2,
      unit_code_ IN VARCHAR2) RETURN VARCHAR2
   IS
      part_one_  VARCHAR2(2000);
      a1_     NUMBER;
      b1_     NUMBER;
      c1_     NUMBER;
      d1_     NUMBER;
      startchr2_  NUMBER;
      endchr2_    NUMBER;
      bitecount2_ NUMBER;
      val1_       NUMBER;
      counter_    NUMBER;
   BEGIN
      a1_ := lengthb(attribute_);
      b1_ := lengthb(unit_code_)+2;
      c1_ := a1_+ b1_;
      d1_ := 28 - b1_;  
      val1_ :=0;
      endchr2_ :=1;
      startchr2_ :=1;
      counter_ :=0;
      bitecount2_:=0;
      
      IF(c1_ > 30)THEN 
         IF( b1_>= 30) THEN
           
                  WHILE val1_ = 0 LOOP
       
                     bitecount2_ := bitecount2_ + lengthb(substr(unit_code_,startchr2_,endchr2_));
                     startchr2_ := startchr2_ +1;

                      if(bitecount2_ >=30)THEN
                       part_one_ := '"'||substr(unit_code_,1,startchr2_-2)||'.."';
                        startchr2_:=1;
                        val1_ := 1;

                      end if;
                  END LOOP;
                  val1_ :=0;
                  bitecount2_ :=0;
         ELSE  
            IF(c1_ >=30) THEN

                WHILE val1_ = 0 LOOP
                    counter_ := counter_+1;
                     bitecount2_ := bitecount2_ + lengthb(substr(attribute_,startchr2_,endchr2_));
                     startchr2_ := startchr2_ +1;

                      if(bitecount2_ >=26-(lengthb(unit_code_)))THEN

                         part_one_ := substr(attribute_,1,startchr2_-2)||'..';
                         part_one_ := '"'||part_one_ || '('||unit_code_||')"';
                         
                         startchr2_:=1;
                        val1_ := 1;
                      end if;
                END LOOP;
                val1_ :=0;
                bitecount2_ :=0;
                counter_ := 0;
              ELSE
                 
                 part_one_ := part_one_ || ' "' || SUBSTR(attribute_, 1, (d1_-2))||'..';
                  part_one_ := part_one_ ||SUBSTR('('||unit_code_||')' , 1, b1_)|| '"'; 

              END IF;
        END IF;
      ELSE
         part_one_ := part_one_ || ' "' || SUBSTR(attribute_, 1, (30-b1_))||SUBSTR('('||unit_code_||')' , 1, b1_)|| '"';
      END IF;
      RETURN part_one_;
   END Get_Field_Name;     
   BEGIN
   
   
   value_ := 0;
   bitecount_ := 0;
   startchr_ := 1;
   endchr_ := 1;
   result_ := NULL;
   count_ := 0;
   id0_ := STRID_(count_);
   part1_ := 'SELECT ' || id0_
   || '.lu_name ' || '"'|| objtypecons_ ||'"' || ','
   || table_prefix_ || 'Technical_Object_Reference_API.Get_Object_Keys('
   || id0_ || '.technical_spec_no) ' || '"' || objectkeycons_ ||'"' ||' '|| ','
   || table_prefix_ || 'Technical_Object_Reference_API.Get_Object_Description('
   || id0_ || '.technical_spec_no) ' || '"' || objectdesccons_ ||'"' ||' '; 
   part2_ := ' FROM ' || table_prefix_ || 'technical_object_reference ' || id0_;
   part3_ := ' WHERE ' || id0_ || '.technical_class = ''' || technical_class_ || '''';
   part4_ := ' ';
   part5_ := ' ORDER BY ' || id0_ || '.lu_name, replace(' ||
   id0_ || '.key_value, chr(94),chr(31))';  
   --
   result_ := substr(part1_ || part2_ || part3_ || part4_ || part5_, 1, 32000) ;
   IF (Object_Property_Api.Get_Value('TechnicalClass','SUMMARY','SHOW_ALL_SUMMARY') = 'NO' ) THEN
      Summery_Included_Attributes___(technical_class_ , all_attributes_);
   ELSE
      All_Attributes___(technical_class_ , all_attributes_);
   END IF;
   LOOP 
      FETCH all_attributes_ INTO attribute1_,unit1_ ,attr_num1_,row_type1_;    
      EXIT WHEN (all_attributes_%NOTFOUND OR length(buffer_) > attr_limit_);
      count_ := count_ +1;
      id_ := STRID_(count_);     
      
      IF (row_type1_ = 'TechnicalAttribNumeric') THEN
         part1_ := part1_ || ', ' ||
         id_ || '.value_no';
      ELSE
         part1_ := part1_ || ', ' ||
         id_ || '.value_text';
      END IF;
      IF (row_type1_ = 'TechnicalAttribNumeric') THEN
         desc_:=Technical_Attrib_Std_API.Get_Attrib_Desc(attribute1_);
          -- Using  double quote (") character in an alias for  a table column will break the outer quotes and eventually the SQL statement.
         -- Replacing the double quote with two single quotes will look similar and won't brake the statement.
         desc1_ := Get_Field_Name(desc_,REPLACE(unit1_,'"',''''||''''));
         part1_ := part1_ ||desc1_;    
      ELSE 
         alpha_attr_ := Technical_Attrib_Std_API.Get_Attrib_Desc(attribute1_);
         if lengthb(alpha_attr_) >= 30 then
          WHILE value_ = 0 LOOP
       
                     bitecount_ := bitecount_ + lengthb(substr(alpha_attr_,startchr_,endchr_));
                     startchr_ := startchr_ +1;

                      if(bitecount_ >=27)THEN
                       parta1_ := substr(alpha_attr_,1,startchr_-2)||'..';
                        startchr_:=1;
                        value_ := 1;

                      end if;
                      
           END LOOP;
           
           else
            parta1_ :=  alpha_attr_;
           END IF;
                  value_ :=0;
                  bitecount_ :=0;
          part1_ := part1_ || ' "'||parta1_|| '"';
      END IF;
      part2_ := part2_ || ', ' || table_prefix_ || 'technical_specification_both ' || id_;
      part3_ := part3_ || ' AND ' || id0_ || '.technical_spec_no = ' ||
      id_ || '.technical_spec_no (+)';
      part4_ := part4_ || ' AND ''' || attribute1_  || ''' = ' || id_ || '.attribute (+)';
      buffer_ := part1_ || part2_ || part3_ || part4_ || part5_;
      
      IF (length(buffer_) < attr_limit_) THEN
         result_ := buffer_;
      ELSE
         NULL;
         -- add warning, select is truncated...
      END IF;
   END LOOP;
      CLOSE all_attributes_;
   IF (length(buffer_) > attr_limit_) THEN
      truncated_ := 'TRUE';
   ELSE
      truncated_ := 'FALSE';
   END IF;
   
   select_statment_ := result_;
END Make_Select_Statement;


@UncheckedAccess
FUNCTION Get_Defined_Count (
   technical_spec_no_ IN NUMBER,
   technical_class_   IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN NULL;
END Get_Defined_Count;


-- Get_Summary
--   Return a string with included attributes with
--   ( Alphanumeric : { [Summary Prefix | Attribute ] || Value Text ) }
--   ( Numeric : { [ Summary Prefix | Attribute ] || Value No || Unit }
@UncheckedAccess
FUNCTION Get_Summary (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
   summary_ VARCHAR2(32000);
BEGIN
   summary_ := Technical_Spec_Alphanum_API.Get_Summary( technical_spec_no_ );
   summary_ := summary_ || Technical_Spec_Numeric_API.Get_Summary( technical_spec_no_ );
   RETURN summary_;
END Get_Summary;


-- Check_Tech_Exist
--   Returns 'TRUE' if there exists technical data for a given technical_spec_no,
--   'FALSE' otherwise
@UncheckedAccess
FUNCTION Check_Tech_Exist (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_ VARCHAR2(1);
   CURSOR exist IS
      SELECT 'x'
      FROM TECHNICAL_SPECIFICATION
      WHERE technical_spec_no = technical_spec_no_;
BEGIN
   OPEN exist;
   FETCH exist INTO dummy_;
   IF (exist%FOUND) THEN
      CLOSE exist;
      RETURN 'TRUE';
   END IF;
   CLOSE exist;
   RETURN 'FALSE';
END Check_Tech_Exist;


PROCEDURE Delete_Specifications (
   technical_spec_no_ IN NUMBER )
IS
BEGIN
   Technical_Spec_Alphanum_API.Delete_Specifications( technical_spec_no_ );
   Technical_Spec_Numeric_API.Delete_Specifications( technical_spec_no_ );
END Delete_Specifications;


PROCEDURE Refresh_Order (
   technical_class_ IN VARCHAR2,
   attribute_       IN VARCHAR2,
   order_           IN NUMBER )
IS
BEGIN
   NULL;
END Refresh_Order;


-- Get_Summary_All
--   Return a string with all attributes with
--   ( Alphanumeric : { [Attribute ] || Value Text ) }
--   ( Numeric : { [Attribute ] || Value No || Unit }
FUNCTION Get_Summary_All (
   technical_spec_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   summary_ VARCHAR2(32000);
BEGIN

   summary_ := Technical_Spec_Alphanum_API.Get_Summary_All( technical_spec_no_ );
   summary_ := summary_ || Technical_Spec_Numeric_API.Get_Summary_All( technical_spec_no_ );
   RETURN summary_;
END Get_Summary_All;


FUNCTION Get_Summary1 (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
   summary_ VARCHAR2(32000);
BEGIN
   summary_ := Get_Summary_Alpha_Num( technical_spec_no_ );
   RETURN summary_;
END Get_Summary1;


FUNCTION Get_Summary_Alpha_Num (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
   summary_ VARCHAR2(32000);
   CURSOR get_summary_alpha_num IS
      SELECT nvl(ta.summary_prefix, ta.attribute||'=') prefix,ta.attrib_number attrib , 
             Technical_Attrib_Numeric_API.Get_Technical_Unit_(ts.technical_class,ts.attribute) unit,
             ts.value_text value_text, ts.value_no value_no
      FROM technical_specification_tab ts, technical_attrib_tab ta
      WHERE ts.technical_spec_no = technical_spec_no_
      AND   (ts.ROWTYPE = 'TechnicalSpecAlphanum' OR ts.ROWTYPE = 'TechnicalSpecNumeric')
      AND   ta.technical_class = ts.technical_class
      AND   ta.attribute       = ts.attribute
      AND   (ts.value_text IS NOT NULL OR ts.value_no IS NOT NULL)
      AND   ta.summary = '2'
      ORDER BY attrib;
BEGIN
   summary_ := '';
   FOR item IN get_summary_alpha_num LOOP
      summary_:= summary_ || item.prefix || item.value_no|| item.value_text|| item.unit ||', ';
   END LOOP;
   RETURN summary_;
END Get_Summary_Alpha_Num;


-- Sync_Values
--   Deletes technical spec values of technical_spec_no_new_ if
--   they are missing for technical_spec_no_old_.
PROCEDURE Sync_Values (
   technical_spec_no_old_ IN NUMBER,
   technical_spec_no_new_ IN NUMBER )
IS
BEGIN

   Technical_Spec_Numeric_API.Sync_Values_(technical_spec_no_old_, technical_spec_no_new_);
   Technical_Spec_Alphanum_API.Sync_Values_(technical_spec_no_old_, technical_spec_no_new_);

END Sync_Values;

PROCEDURE Modify_Attribute_Value (
   attr_         IN VARCHAR2)
IS
   key_ref_           VARCHAR2(600);
   technical_spec_no_ Technical_Specification_Tab.technical_spec_no%TYPE;
   technical_class_   Technical_Specification_Tab.technical_class%TYPE;
   attribute_         Technical_Specification_Tab.attribute%TYPE;
   lu_name_           Technical_Object_Reference_Tab.lu_name%TYPE;
BEGIN
   key_ref_           := Client_Sys.Get_Item_Value('KEY_REF', attr_);
   attribute_         := Client_Sys.Get_Item_Value('ATTRIBUTE', attr_);
   lu_name_           := Client_Sys.Get_Item_Value('LU_NAME', attr_);
   
   technical_spec_no_ := Technical_Object_Reference_Api.Get_Technical_Spec_No(lu_name_, key_ref_);
   technical_class_   := Technical_Object_Reference_Api.Get_Technical_Class_With_Key(lu_name_, key_ref_);
   
   IF (Client_Sys.Item_Exist('VALUE_TEXT', attr_)) THEN
      Technical_Spec_Alphanum_API.Set_Value_Text(technical_spec_no_, attribute_, Client_Sys.Get_Item_Value('VALUE_TEXT', attr_));
   END IF;
   IF (Client_Sys.Item_Exist('VALUE_NUMBER', attr_)) THEN
      Technical_Spec_Numeric_API.Set_Value_No(technical_spec_no_, attribute_, Client_Sys.Get_Item_Value_To_Number('VALUE_NUMBER', attr_, lu_name_));
   END IF;
END Modify_Attribute_Value;

@UncheckedAccess
FUNCTION Get_Technical_Group_Name(
   technical_class_ IN VARCHAR2,
   attribute_       IN VARCHAR2,
   row_type_        IN VARCHAR2) RETURN VARCHAR2
IS
   group_name_ technical_group_spec_tab.group_name%TYPE;
   CURSOR get_group_name IS
      SELECT tec_group.group_name
        FROM Technical_Specification_Tab tech_spec,
             Technical_Group_Spec_Tab tec_group
       WHERE tech_spec.technical_class = technical_class_
         AND tech_spec.attribute = attribute_
         AND tech_spec.technical_class = tec_group.technical_class
         AND tech_spec.ATTRIBUTE = tec_group.ATTRIBUTE
         AND tech_spec.rowtype LIKE row_type_;
BEGIN
   OPEN get_group_name;
   FETCH get_group_name
      INTO group_name_;
   CLOSE get_group_name;
   RETURN group_name_;
END Get_Technical_Group_Name;

