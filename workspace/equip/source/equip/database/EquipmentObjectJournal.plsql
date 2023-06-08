-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjectJournal
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130116  HaRuLK  Created
--  131121  NEKOLK  PBSA-1812, Refactored and splitted.
--  131217  HASTSE  PBSA-3296, Missing parent reference
--  141027  HASTSE  PRSA-2446, added /CASCADE to reference in model
--  171031  SHEPLK  STRSA-31671, increased the length of the variable "info_" to 2000.
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Date___  (
      contract_ IN VARCHAR2) RETURN DATE
IS 
   site_date_  DATE;   
BEGIN       
   site_date_ := Maintenance_Site_Utility_API.Get_Site_Date(contract_);
   RETURN site_date_ ;   
END Get_Date___;


FUNCTION Generate_Line_No___(
      equipment_object_seq_  NUMBER ) RETURN NUMBER 
IS 
   temp_    NUMBER;
   CURSOR get_lineno IS
      SELECT NVL(max(LINE_NO),0)
      FROM equipment_object_journal_tab
      WHERE  equipment_object_seq = equipment_object_seq_;   
BEGIN 
   OPEN get_lineno;
   FETCH get_lineno INTO temp_;
   CLOSE get_lineno;   
   RETURN temp_+1;
END Generate_Line_No___;   


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT EQUIPMENT_OBJECT_JOURNAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.line_no := Generate_Line_No___(newrec_.equipment_object_seq);
   newrec_.created_by := Fnd_Session_API.Get_Fnd_User();   
   newrec_.journal_date := Get_Date___(Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq));
   newrec_.modify_date := newrec_.journal_date;
   newrec_.modified_by := newrec_.created_by;
   --
   super(objid_, objversion_, newrec_, attr_);
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     EQUIPMENT_OBJECT_JOURNAL_TAB%ROWTYPE,
   newrec_     IN OUT EQUIPMENT_OBJECT_JOURNAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.modify_date := Get_Date___(Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq));
   newrec_.modified_by := Fnd_Session_API.Get_Fnd_User();
   --  
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
    
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Move_Func_obj(
  mch_code_ IN VARCHAR2,
  contract_ IN VARCHAR2,
  sup_mch_code_ IN VARCHAR2,
  sup_contract_ IN VARCHAR2,
  old_sup_mch_code_ IN VARCHAR2,
  old_sup_contract_ IN VARCHAR2,
  note_ IN VARCHAR2)
  
  IS
  dummy_      NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   equipment_object_tab
      WHERE  equipment_object_seq = Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_) 
      and functional_object_seq = Equipment_Object_API.Get_Equipment_Object_Seq(sup_contract_, sup_mch_code_);
 
  BEGIN
    
  OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      
      CLOSE exist_control;
      IF(note_ IS NULL) THEN
         Add_Journal_Entry(mch_code_,contract_,old_sup_mch_code_||' , '||old_sup_contract_,sup_mch_code_||' , '||sup_contract_,NULL,'MOVE');
      ELSE
         Add_Journal_Entry(mch_code_,contract_,old_sup_mch_code_||' , '||old_sup_contract_,sup_mch_code_||' , '||sup_contract_,note_|| ' : '|| Fnd_Session_API.Get_Fnd_User || ' '||TO_CHAR(Get_Date___(contract_), 'YYYY-MM-DD HH24:MI:SS'),'MOVE');
      END IF;
     
   END IF;

  END Move_Func_obj;


PROCEDURE Add_Journal_Entry (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   old_value_ IN VARCHAR2,
   new_value_ IN VARCHAR2,
   note_  IN VARCHAR2,
   event_type_ IN VARCHAR2)
IS
   newrec_ equipment_object_journal_tab%ROWTYPE;
BEGIN
   newrec_.equipment_object_seq := Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_);
   newrec_.new_value    := new_value_;
   newrec_.old_value    := old_value_;
   newrec_.journal_text := note_;
   newrec_.event_type   := event_type_;   
   New___(newrec_);   
END Add_Journal_Entry;   


PROCEDURE Add_Note (
   mch_code_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   note_  IN VARCHAR2,
   line_no_ IN NUMBER)
IS 
   new_note_      VARCHAR2(4000);
   newrec_ equipment_object_journal_tab%ROWTYPE;
BEGIN 
   newrec_ := Get_Object_By_Keys___(Equipment_Object_API.Get_Equipment_Object_Seq(contract_, mch_code_), line_no_);
   new_note_ := note_ || ' : '|| Fnd_Session_API.Get_Fnd_User || ' '||TO_CHAR(Get_Date___(contract_), 'YYYY-MM-DD HH24:MI:SS');
   newrec_.note := new_note_;
   Modify___(newrec_);
END Add_Note;



