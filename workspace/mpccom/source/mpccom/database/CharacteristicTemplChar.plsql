-----------------------------------------------------------------------------
--
--  Logical unit: CharacteristicTemplChar
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100902  GayDLK Bug 92479, Added code to prevent creating records of type CharacteristicTemplChar.
--  060111  SeNslk Modified modified the PROCEDURE Insert___ according to the new template.
--  040121  NaWilk  Bug 40325, Added field rowtype into the view CHARACTERISTIC_TEMPL_CHAR_ALL.
--  040113  LaBolk  Removed public cursor get_attributes.
--  ------------------------------EDGE PKG GRP 2-----------------------------
--  001103  PERK  Added view CHARACTERISTIC_TEMPL_CHAR_ALL and added rowtype to CHARACTERISTIC_TEMPL_CHAR
--  000925  JOHESE  Added undefines.
--  990422  JOHW  General performance improvements.
--  990415  JOHW  Upgraded to performance optimized template.
--  971121  JOKE  Converted to Foundation1 2.0.0 (32-bit).
--  970910  PHDE  Changed Unit_Meas length to 10 and reference to IsoUnit.
--  970313  CHAN  Changed table name: MPC_CHARACTERISTIC_TEMPLATE is replace by
--                characteristic_templ_char_tab
--  970221  JOKE  Uses column rowversion as objversion (timestamp).
--  961213  JOKE  Modified with new workbench default templates.
--  961031  JOKE  Changed for compatibility with Workbench.
--  961011  AnAr  Changed Unpack_Check_Update___ for Unit_Meas.
--  961004  JOKE  Added format /UPPERCASE on column EngAttribute.
--  960813  SHVE  Moved procedure Insert_New_Char to
--                Characteristic_Templ_Char_api.
--  960701  JOED  Added public cursor Get_Attributes
--                Changed dbms_output to Trace_SYS calls. Added TABLE define.
--  960517  AnAr  Added purpose comment to file.
--  960307  JICE  Renamed from CharacteristicTemplate
--  951109  JOBR  Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CHARACTERISTIC_TEMPL_CHAR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_,'ROWTYPEERROR: Cannot create records of type :P1.','CharacteristicTemplChar');
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


