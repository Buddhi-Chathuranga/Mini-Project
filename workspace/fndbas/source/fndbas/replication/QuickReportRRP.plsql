-----------------------------------------------------------------------------
--
--  Logical unit: QuickReport ReplReceive
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
FUNCTION Create_Presentation_Object (
   quick_report_id_ IN NUMBER,
   description_     IN VARCHAR2,
   sql_expression_  IN CLOB,
   recreate_        IN BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   
   po_id_          VARCHAR2(200)  := 'repQUICK_REPORT'||quick_report_id_;
   po_description_ VARCHAR2(70)   := 'Quick Report - '||description_;
   stmt_           CLOB           := sql_expression_;
   prefix_         VARCHAR2(31)   := Fnd_Session_API.Get_App_Owner||'.';
   ial_prefix_     VARCHAR2(31)   := Fnd_Setting_API.Get_Value('IAL_USER')||'.';
   pos_            NUMBER;
   to_pos_         NUMBER;
   char_number_    NUMBER;
   db_object_      VARCHAR2(2000);
   object_type_    VARCHAR2(6);
   sub_type_       VARCHAR2(1);
     
   BEGIN   
      IF recreate_ THEN
         Pres_Object_Util_API.Remove_Pres_Object(po_id_);
      END IF;
   
      Pres_Object_Util_API.New_Pres_Object(po_id_, 'FNDBAS', 'REP', po_description_, 'Manual');
   
      IF stmt_ IS NOT NULL THEN
                     
         stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'AO\.\.', prefix_,1,0,'i');
         stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'APPOWNER\.\.', prefix_,1,0,'i');
         stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'IAL\.\.', ial_prefix_,1,0,'i');
         stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'AO\.', prefix_,1,0,'i');
         stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'APPOWNER\.', prefix_,1,0,'i');
         stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'IAL\.', ial_prefix_,1,0,'i');
         --
         pos_ := instr(stmt_, prefix_);
         WHILE pos_ > 0 LOOP
            pos_ := pos_ + length(prefix_);
            to_pos_ := pos_;
            char_number_ := ascii(substr(stmt_, to_pos_, 1));
            WHILE char_number_ = 46 OR (char_number_ BETWEEN 48 AND 57) OR (char_number_ between 65 and 90) OR char_number_ = 95 LOOP
               to_pos_ := to_pos_ + 1;
               char_number_ := ascii(substr(stmt_, to_pos_, 1));
            END LOOP;
            db_object_ := substr(stmt_, pos_, to_pos_ - pos_);
            IF db_object_ IS NOT NULL THEN
               IF instr(db_object_, '_API.') > 0 OR instr(db_object_, '_SYS.') > 0 OR instr(db_object_, '_RPI.') > 0 OR instr(db_object_, '_CFP.') > 0 THEN
                  db_object_   := upper(substr(db_object_, 1, instr(db_object_, '.') - 1))||InitCap(substr(db_object_, instr(db_object_, '.')));
                  object_type_ := 'METHOD';
                  sub_type_    := '2';
               ELSE
                  object_type_ := 'VIEW';
                  sub_type_    := '4';
               END IF;
               IF object_type_ = 'VIEW' AND instr(db_object_, '.') > 0 THEN
                  db_object_ := substr(db_object_, 1, instr(db_object_, '.') - 1 );
               END IF;
               Pres_Object_Util_API.New_Pres_Object_Sec(po_id_, db_object_, object_type_, sub_type_, 'Manual');
            END IF;
            db_object_ := NULL;
            pos_ := instr(stmt_, prefix_, pos_);
         END LOOP;
      END IF;      
   RETURN po_id_;  
END Create_Presentation_Object;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- REPLICATION RECEIVE IMPLEMENTATION METHODS ---------------------


-------------------- REPLICATION RECEIVE PRIVATE METHODS ----------------------------
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT quick_report_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.po_id := Create_Presentation_Object(newrec_.quick_report_id, newrec_.description, newrec_.sql_expression);
   Client_SYS.Add_To_Attr('PO_ID', newrec_.po_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     quick_report_tab%ROWTYPE,
   newrec_     IN OUT quick_report_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF nvl(oldrec_.sql_expression, ' ') != nvl(newrec_.sql_expression, ' ') THEN
      newrec_.po_id := Create_Presentation_Object(newrec_.quick_report_id, newrec_.description, newrec_.sql_expression, TRUE);
   ELSIF (oldrec_.description != newrec_.description)  THEN
      Pres_Object_Description_Api.Modify_Description(Quick_Report_API.Get_Po_Id(newrec_.quick_report_id),'en','Quick Report - '||newrec_.description);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;

@Override
PROCEDURE Delete___ (
   remrec_ IN quick_report_tab%ROWTYPE )
IS
BEGIN
   super(remrec_);
   Pres_Object_Util_API.Remove_Pres_Object(remrec_.po_id);
END Delete___;
-------------------- REPLICATION RECEIVE PROTECTED METHODS --------------------------


-------------------- REPLICATION RECEIVE PUBLIC METHODS -----------------------------

