-----------------------------------------------------------------------------
--
--  Logical unit: PhraseConnectionRule
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-- 200923   Ambslk  MF2020R1-7310, Overrided Check_Delete___() and Check_Update___() methods.
-- 200615   Ambslk  MF2020R1-6017, Removed phrase_revision_no in get_connection CURSOR to avoid creating duplicate records.
-- 200109   MuShlk  MFSPRING20-650, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT PHRASE_CONNECTION_RULE_TAB%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF Check_Connection_Exist(newrec_.phrase_id, newrec_.contract, newrec_.part_no, newrec_.second_commodity, newrec_.vendor_no, newrec_.project_id, newrec_.sub_project_id, newrec_.activity_no) = 1 THEN
       Error_SYS.Record_General(lu_name_, 'PHRASECONNRULEXIST: Phrase connection rule already exists.');
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT phrase_connection_rule_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT connection_rule_id_seq.nextval INTO newrec_.connection_rule_id FROM dual;
   super(objid_, objversion_, newrec_, attr_);
   --Add post-processing code here
END Insert___;

FUNCTION Check_Connection_Exist(
   phrase_id_           IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   second_commodity_    IN VARCHAR2,
   vendor_no_           IN VARCHAR2,
   project_id_          IN VARCHAR2,
   sub_project_id_      IN VARCHAR2,
   activity_no_         IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_connection IS
      SELECT 1
        FROM phrase_connection_rule_tab
       WHERE phrase_id = phrase_id_
         AND NVL(contract, Database_SYS.string_null_)  = NVL(contract_, Database_SYS.string_null_)
         AND NVL(part_no, Database_SYS.string_null_) = NVL(part_no_, Database_SYS.string_null_)
         AND NVL(second_commodity, Database_SYS.string_null_) = NVL(second_commodity_, Database_SYS.string_null_)
         AND NVL(vendor_no, Database_SYS.string_null_) = NVL(vendor_no_, Database_SYS.string_null_)
         AND NVL(project_id, Database_SYS.string_null_) = NVL(project_id_, Database_SYS.string_null_)
         AND NVL(sub_project_id, Database_SYS.string_null_) = NVL(sub_project_id_, Database_SYS.string_null_)
         AND NVL(activity_no, Database_SYS.string_null_) = NVL(activity_no_, Database_SYS.string_null_);
   
   dummy_    NUMBER := 0;
BEGIN
   OPEN get_connection;
   FETCH get_connection INTO dummy_;
   CLOSE get_connection;
   RETURN dummy_;
END Check_Connection_Exist;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN PHRASE_CONNECTION_RULE_TAB%ROWTYPE )
IS
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      Connected_Phrase_API.Check_Phrase_Connection_Exist(remrec_.connection_rule_id);
   $END
   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     phrase_connection_rule_tab%ROWTYPE,
   newrec_ IN OUT phrase_connection_rule_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      Connected_Phrase_API.Check_Phrase_Connection_Exist(newrec_.connection_rule_id);
   $END
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- Get_Connection_Rule_Id
--   Gets the connection rule id for the given params.
@UncheckedAccess
FUNCTION Get_Connection_Rule_Id(
   phrase_id_           IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   second_commodity_    IN VARCHAR2,
   vendor_no_           IN VARCHAR2,
   project_id_          IN VARCHAR2,
   sub_project_id_      IN VARCHAR2,
   activity_no_         IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_connection_rule_id IS
      SELECT connection_rule_id
        FROM phrase_connection_rule_tab
       WHERE phrase_id = phrase_id_
         AND NVL(contract, Database_SYS.string_null_)  = NVL(contract_, Database_SYS.string_null_)
         AND NVL(part_no, Database_SYS.string_null_) = NVL(part_no_, Database_SYS.string_null_)
         AND NVL(second_commodity, Database_SYS.string_null_) = NVL(second_commodity_, Database_SYS.string_null_)
         AND NVL(vendor_no, Database_SYS.string_null_) = NVL(vendor_no_, Database_SYS.string_null_)
         AND NVL(project_id, Database_SYS.string_null_) = NVL(project_id_, Database_SYS.string_null_)
         AND NVL(sub_project_id, Database_SYS.string_null_) = NVL(sub_project_id_, Database_SYS.string_null_)
         AND NVL(activity_no, Database_SYS.string_null_) = NVL(activity_no_, Database_SYS.string_null_);
       
   connection_rule_id_    NUMBER := 0;
BEGIN
   OPEN get_connection_rule_id;
   FETCH get_connection_rule_id INTO connection_rule_id_;
   CLOSE get_connection_rule_id;
   RETURN connection_rule_id_;
END Get_Connection_Rule_Id;
