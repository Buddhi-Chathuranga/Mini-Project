-----------------------------------------------------------------------------
--
--  Logical unit: ReportResultGenConfig
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030630  RAKU  Created. (ToDo#4274)
--  040203  RAKU  Added default_layout_type. (Bug#41529)
--  040305  DOZE  Added method Create_Default (Bug#42823)
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  120215  LAKRLK RDTERUNTIME-1846
--  120620  LAKRLK TEREPORT-56
--  130123  ASIWLK LCS 107984 - Added method Remove_Result_Gen_Config_ 
-- 130509   CHAALK Feature to change the layout order of a report (Bug ID 109681
--  140129  AsiWLK   Merged LCS-111925
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate___ (
   newrec_ IN REPORT_RESULT_GEN_CONFIG_TAB%ROWTYPE )
IS
BEGIN
   IF (newrec_.generate_xml = 'TRUE') THEN
      IF (newrec_.create_result_set = 'FALSE' AND newrec_.default_layout_type = 'CRYSTAL') THEN
         ERROR_SYS.Record_General(lu_name_, 'WRONGCOMB1: IF the result set generation is switched off, the default layout type must be set to Report Designer.');
      END IF;
   ELSE
      IF (newrec_.default_layout_type = 'DESIGNER') THEN
         ERROR_SYS.Record_General(lu_name_, 'WRONGCOMB2: In order for Report Designer to be the default layout type, XML generation must be switch on.');
      END IF;
   END IF;
END Validate___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr( 'IN_USE_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr( 'GENERATE_XML_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr( 'CREATE_RESULT_SET_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr( 'DEFAULT_LAYOUT_TYPE_DB', 'DESIGNER', attr_);
   Client_SYS.Add_To_Attr( 'DEFAULT_LAYOUT_TYPE', Report_Layout_Type_API.Decode('DESIGNER'), attr_);
   Client_SYS.Add_To_Attr( 'ENABLE_CUSTOM_FIELDS','TRUE',attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     report_result_gen_config_tab%ROWTYPE,
   newrec_ IN OUT report_result_gen_config_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate___(newrec_);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Remove_Result_Gen_Config_ (
   report_id_  IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
   objid_ VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   IF (Check_Exist___(report_id_)) THEN
		Get_Id_Version_By_Keys___(objid_,objversion_,report_id_);
		Remove__ (info_,objid_,objversion_,'DO');
   END IF;
END Remove_Result_Gen_Config_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Create_Default (
   report_id_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(report_id_)) THEN
      INSERT
      INTO REPORT_RESULT_GEN_CONFIG_TAB (
         report_id,
         in_use,
         generate_xml,
         create_result_set,
         default_layout_type,
         enable_custom_fields,
         rowversion)
      VALUES (
         report_id_,
         'FALSE',
         'TRUE',
         'TRUE',
         'DESIGNER',
         'TRUE',
         SYSDATE);
   END IF;
END Create_Default;

@Override
FUNCTION Get_Enable_Custom_Fields_Db (
   report_id_ IN     VARCHAR2 ) RETURN report_result_gen_config_tab.enable_custom_fields%TYPE
IS
BEGIN
   RETURN Nvl(super(report_id_),'TRUE'); 
END Get_Enable_Custom_Fields_Db;

@Override
FUNCTION Get_Enable_Custom_Fields (
   report_id_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Nvl(super(report_id_),Fnd_Boolean_API.Decode('TRUE')); 
END Get_Enable_Custom_Fields;

