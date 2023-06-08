-----------------------------------------------------------------------------
--
--  Logical unit: OutputType
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  110725  utguuk   BB09 Quotations and Invoicing : Added New_Output_Type().
--  120129  tofjno   Merged BB09.
--  ------------------------------- Defcon/Blackbird ----------------------------------
--  060117  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060117           and added UNDEFINE according to the new template.
--  ------------------------------- 13.3.0 ----------------------------------
--  000925  JOHESE   Added undefines.
--  990413  FRDI     Upgraded to performance optimized template.
--  971121  TOOS     Upgrade to F1 2.0
--  970918  JICE     Bug 97-0102: Created LOV-view which excludes internal type PURCHASE.
--  970313  CHAN     Changed table name: output is replaced by output_type_tab
--  970227  PELA     Uses column rowversion as objversion (timestamp).
--  961214  JOKE     Modified with new workbench default templates.
--  961107  JOBE     Additional changes for compatibility with workbench.
--  961029  JOKE     Changed for compatibility with Workbench.
--  960517  AnAr     Added purpose comment to file.
--  960415  SHVE     Corrected the LU name(Output_Type).
--  960307  SHVE     Changed LU Name GenOutput.
--  951120  OYME     Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN OUTPUT_TYPE_TAB%ROWTYPE )
IS
BEGIN
   IF (remrec_.output_type = 'PURCHASE') THEN
      Error_SYS.Record_General(lu_name_, 'DELNOTALLOWED: Deletion of Output Type PURCHASE is not allowed');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     output_type_tab%ROWTYPE,
   newrec_ IN OUT output_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.output_type = 'PURCHASE') THEN
      Error_SYS.Record_General(lu_name_, 'UPDNOTALLOWED: Changes are not allowed on Output Type PURCHASE');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New_Output_Type (
   output_type_ IN VARCHAR2,
   description_ IN VARCHAR2 )
IS
   newrec_       OUTPUT_TYPE_TAB%ROWTYPE;
   attr_         VARCHAR2(2000);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   indrec_       Indicator_Rec;
BEGIN
   IF NOT Check_Exist___(output_type_) THEN
      Client_SYS.Add_To_Attr('OUTPUT_TYPE', output_type_, attr_);
      Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END New_Output_Type;



