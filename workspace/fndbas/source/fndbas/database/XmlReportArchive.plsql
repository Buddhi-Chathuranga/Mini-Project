-----------------------------------------------------------------------------
--
--  Logical unit: XmlReportArchive
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140919  NaBaLK  Added a commit when New__ is completed (TEREPORT-1418)
-----------------------------------------------------------------------------

layer Core;

-------------------- BASE METHODS ------------------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT NOCOPY VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   @ApproveTransactionStatement(2014-09-19,NaBaLK)
   COMMIT;
END New__;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE New_Entry__ (
   result_key_  IN     NUMBER,
   id_          IN     VARCHAR2,
   xml_header_  IN     CLOB,
   xml_footer_  IN     CLOB)
IS   
   newrec_   xml_report_archive_tab%ROWTYPE;
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(200);
BEGIN
   newrec_.result_key := result_key_;
   newrec_.id := id_;
   newrec_.xml_header := xml_header_;
   newrec_.xml_footer := xml_footer_;
        
   Insert___(objid_, objversion_, newrec_, attr_);
      
   @ApproveTransactionStatement(2014-12-04,NaBaLK)
   COMMIT;
END New_Entry__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Clear (
   result_key_ IN NUMBER )
IS
BEGIN
   DELETE
      FROM XML_REPORT_ARCHIVE_TAB
      WHERE result_key = result_key_;
END Clear;
