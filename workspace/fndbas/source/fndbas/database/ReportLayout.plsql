-----------------------------------------------------------------------------
--
--  Logical unit: ReportLayout
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050405  DOZE  Created (F1PR466)
--  060831  UTGULK  Added Add_Layout and Get_Layout methods.(Bug #59182).
--  060927  UTGULK Added method Remove_Layout_ to be used by EXCEL reports.(Bug #60820).
--  130905  MABALK QA Script Cleanup - PrivateInterfaces (Bug #112227
--  140129  AsiWLK   Merged LCS-111925
--  191002  PABNLK  TSMI-6: 'Write_Report_Layout' wrapper method created.
--  200218  CHAALK  Modifications to remove sta jar useage 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Write_Layout__ (
   objversion_ IN OUT VARCHAR2,
   rowid_      IN ROWID,
   lob_loc_    IN BLOB )
IS
BEGIN
   super(objversion_, rowid_, lob_loc_);
   UPDATE REPORT_LAYOUT_TAB
   SET layout_version = layout_version + 1
   WHERE rowid = rowid_;
END Write_Layout__;


PROCEDURE Get_Layout__ (
   objid_ OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   report_id_ IN VARCHAR2,
   layout_name_ IN VARCHAR2 )
IS
BEGIN
   IF Check_Exist___(report_id_, layout_name_) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, report_id_, layout_name_);
   ELSE
   INSERT
      INTO report_layout_tab (
         report_id,
         layout_name,
         layout,
         layout_version,
         data_size,
         rowversion)
      VALUES (
         report_id_,
         layout_name_,
         NULL,
         0,
         0,
         SYSDATE)
      RETURNING rowid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) INTO objid_, objversion_;
   END IF;
END Get_Layout__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Remove_Layout_ (
   report_id_   IN VARCHAR2,
   layout_name_ IN VARCHAR2 )
IS
   objid_ VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   remrec_ REPORT_LAYOUT_TAB%ROWTYPE;   
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, report_id_, layout_name_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_Layout_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Add_Layout (
   report_id_      IN VARCHAR2,
   layout_name_    IN VARCHAR2,
   layout_         IN BLOB,
   layout_version_ IN NUMBER DEFAULT 0,
   data_size_      IN NUMBER DEFAULT 0 )
IS
   attr_ VARCHAR2(32000);
   objid_ VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   info_ VARCHAR2(2000);
BEGIN

   IF Check_Exist___(report_id_, layout_name_) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, report_id_, layout_name_);
      Write_Layout__ (objversion_,objid_,layout_);
   ELSE
      Client_SYS.Add_To_Attr('REPORT_ID', report_id_, attr_ );
      Client_SYS.Add_To_Attr('LAYOUT_NAME', layout_name_, attr_ );
      Client_SYS.Add_To_Attr('LAYOUT_VERSION', layout_version_, attr_ );
      Client_SYS.Add_To_Attr('DATA_SIZE', data_size_, attr_ );
      New__ (info_,objid_, objversion_,attr_,'DO');
      IF length(layout_) > 0 THEN
         Write_Layout__ (objversion_,objid_,layout_);
      END IF;
   END IF;
END Add_Layout;

PROCEDURE Write_Report_Layout (
   objversion_ IN VARCHAR2,
   rowid_      IN ROWID,
   lob_loc_    IN BLOB )
IS
   new_objversion_   VARCHAR2(100);
BEGIN
   new_objversion_ := objversion_;
   Write_Layout__(new_objversion_, rowid_, lob_loc_);
END Write_Report_Layout;

PROCEDURE Update_Report_Layout(
   report_id_    IN VARCHAR2,
   layout_name_  IN VARCHAR2,
   lob_loc_      IN BLOB)
IS
   objid_        ROWID;
   objversion_   VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, report_id_,layout_name_);
   Write_Layout__(objversion_, objid_, lob_loc_);
END Update_Report_Layout;

PROCEDURE Remove_Layout (
   report_id_   IN VARCHAR2,
   layout_name_ IN VARCHAR2 )
IS

BEGIN
   Remove_Layout_(report_id_, layout_name_);
END Remove_Layout;

PROCEDURE Remove_Layout_Direct (
   layout_name_ IN VARCHAR2 )
IS

BEGIN
   IF (layout_name_ IS NOT NULL) THEN
      DELETE
         FROM  report_layout_tab
         WHERE UPPER(layout_name) = UPPER(layout_name_);
   END IF;   
END Remove_Layout_Direct;

PROCEDURE Get_Layout_Count (
   layout_name_ IN VARCHAR2,
   report_id_   IN VARCHAR2,
   layout_count_ OUT NUMBER)
IS

BEGIN
   IF (report_id_ IS NOT NULL) THEN
      SELECT count(layout_name)
         INTO layout_count_
         FROM report_layout_tab
         WHERE UPPER(layout_name) = UPPER(layout_name_)
         AND   UPPER(report_id) = UPPER(report_id_);
   ELSE
      SELECT count(layout_name)
         INTO layout_count_
         FROM report_layout_tab
         WHERE UPPER(layout_name) = UPPER(layout_name_);
   END IF;
END Get_Layout_Count;

PROCEDURE Import_Layout (
   report_id_         IN  VARCHAR2,
   layout_name_       IN  VARCHAR2,
   data_size_         IN  NUMBER,
   layout_            IN  BLOB,
   layout_version_    OUT NUMBER,
   ret_value_         OUT VARCHAR2) 
IS
   info_             VARCHAR2(2000);
   attr_             VARCHAR2(32000);
   objid_            VARCHAR2(100);
   objversion_       VARCHAR2(100);
   
   CURSOR layout_version IS
   SELECT layout_version
   INTO layout_version_
   FROM report_layout_tab
   WHERE UPPER(layout_name) = UPPER(layout_name_)
   AND UPPER(report_id) = UPPER(report_id_);
   
   
BEGIN
   
   IF (NOT Report_Layout_API.Exists(report_id_,layout_name_)) THEN
      New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      layout_version_ := 0;
      Client_SYS.Add_To_Attr('REPORT_ID',report_id_,attr_);
      Client_SYS.Add_To_Attr('LAYOUT_NAME',layout_name_,attr_);
      Client_SYS.Add_To_Attr('LAYOUT_VERSION',layout_version_,attr_);
      Client_SYS.Add_To_Attr('DATA_SIZE',data_size_,attr_);
      New__(info_, objid_, objversion_,attr_, 'DO');
      Write_Layout__(objversion_, objid_, layout_);
      ret_value_ := 'IMPORT';
   ELSE
      OPEN layout_version;
      FETCH layout_version INTO layout_version_;
      CLOSE layout_version;
      
      layout_version_ := layout_version_ + 1;
      Get_Id_Version_By_Keys___ (objid_,objversion_,report_id_,layout_name_);
      Client_SYS.Add_To_Attr('DATA_SIZE',data_size_,attr_);
      Modify__(info_, objid_, objversion_,attr_, 'DO');
      Write_Layout__(objversion_, objid_, layout_);         
      ret_value_ := 'MODIFY';
   END IF;
END Import_Layout;
