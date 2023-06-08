-----------------------------------------------------------------------------
--
--  Logical unit: SecCheckpointGate
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050927  RaKu  Added default value on ACTIVE in Prepare_Insert___
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

newline_    CONSTANT VARCHAR2(2) := chr(13)||chr(10);


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ACTIVE_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('ACTIVE', Fnd_Boolean_API.Decode('TRUE'), attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Create_Message__ (
   gate_id_ IN VARCHAR2,
   msg_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_message IS
      SELECT g.message
      FROM  SEC_CHECKPOINT_GATE_TAB g
      WHERE g.gate_id = gate_id_;
   --
   CURSOR get_param IS
      SELECT p.name, p.datatype
      FROM  sec_checkpoint_gate_param_tab p
      WHERE p.gate_id = gate_id_;
   --
   message_ VARCHAR2(32000);
   string_  VARCHAR2(32000);
   date_    DATE;
   number_  NUMBER;
BEGIN
   OPEN  get_message;
   FETCH get_message INTO message_;
   CLOSE get_message;
   FOR rec IN get_param LOOP
      CASE rec.datatype
         WHEN 'STRING' THEN
            string_ := Message_SYS.Find_Attribute(msg_, rec.name, '');
            message_ := replace(message_, '&' || rec.name, string_);
         WHEN 'DATE'   THEN
            date_ := Message_SYS.Find_Attribute(msg_, rec.name, '');
            message_ := replace(message_, '&' || rec.name, to_char(date_, Client_SYS.date_format_));
         WHEN 'NUMBER' THEN
            number_ := Message_SYS.Find_Attribute(msg_, rec.name, '');
           message_ := replace(message_, '&' || rec.name, to_char(number_));
         ELSE
            Error_SYS.Record_General(lu_name_, 'WRONG_DATATYPE: The datatype of parameter [:P1] must be STRING, DATE or NUMBER, it can not be [:P2].', rec.name, rec.datatype);
      END CASE;
   END LOOP;
   RETURN(message_);
END Create_Message__;


PROCEDURE Export__ (
   string_ OUT VARCHAR2,
   gate_id_ IN VARCHAR2 )
IS
   rec_ SEC_CHECKPOINT_GATE_TAB%ROWTYPE;
   CURSOR get_parameter IS
      SELECT name, datatype
      FROM   sec_checkpoint_gate_param_tab
      WHERE  gate_id = gate_id_;
BEGIN
   rec_     := Get_Object_By_Keys___(gate_id_);
   --
   -- Create Export file
   --
   string_ :=            '-------------------------------------------------------------------------------------------- ' || newline_;
   string_ := string_ || '-- Export file for Security Checkpoint Gate '||gate_id_||'.' || newline_;
   string_ := string_ || '-- ' || newline_;
   string_ := string_ || '--  Date    Sign    History' || newline_;
   string_ := string_ || '--  ------  ------  -----------------------------------------------------------' || newline_;
   string_ := string_ || '--  ' || to_char(sysdate, 'YYMMDD')||'  '||rpad(Fnd_Session_API.Get_Fnd_User, 6, ' ')||'  '||
                         'Export file for Security Checkpoint Gate '||gate_id_||'.' || newline_;
   string_ := string_ || '-------------------------------------------------------------------------------------------- ' || newline_;
   string_ := string_ || newline_;
   string_ := string_ || 'SET DEFINE ^' || newline_;
   string_ := string_ || 'PROMPT Register Security Checkpoint Gate "'||gate_id_||'"' || newline_;
   string_ := string_ || 'DECLARE' || newline_;
   string_ := string_ || '   gate_id_            VARCHAR2(30)    := '''||gate_id_||''';' || newline_;
   string_ := string_ || '   info_msg_           VARCHAR2(32000) := NULL;' || newline_;
   string_ := string_ || '   par_msg_            VARCHAR2(32000) := NULL;' || newline_;
   string_ := string_ || 'BEGIN' || newline_;
   --
   -- Create Main Message
   --
   string_ := string_ || '-- Construct Main Message' || newline_;
   string_ := string_ || '   info_msg_    := Message_SYS.Construct(''GATE'');' || newline_;
--   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''GATE_ID'', '''||gate_id_||''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''DESCRIPTION'', '''||rec_.description||''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''MESSAGE'', '''||rec_.message||''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''ACTIVE_DB'', '''||rec_.active||''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''UNRESTRICTED_VALIDATION_DB'', '''||rec_.unrestricted_validation||''');' || newline_;
   --
   -- Add parameters
   --
   string_ := string_ || '-- Adding parameters' || newline_;
   string_ := string_ || '-- Construct Parameter Message' || newline_;
   string_ := string_ || '   par_msg_     := Message_SYS.Construct(''PARAMETERS'');' || newline_;
   FOR rec2 IN get_parameter LOOP
      string_ := string_ || '   Message_SYS.Add_Attribute(par_msg_, '''||rec2.name||''', '''||rec2.datatype||''');' || newline_;
   END LOOP;
   string_ := string_ || '-- Add Parameters message to main message' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''PARAMETERS'', par_msg_);' || newline_;
   string_ := string_ || '-- Register Security Checkpoint Gate' || newline_;
   string_ := string_ || '   Sec_Checkpoint_Gate_API.Register(gate_id_, info_msg_);' || newline_;
   string_ := string_ || 'END;' || newline_;
   string_ := string_ || '/' || newline_;
   string_ := string_ || 'SET DEFINE &' || newline_;
END Export__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Register (
   gate_id_  IN VARCHAR2,
   info_msg_ IN VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(4000);
   par_attr_   VARCHAR2(32000);
   par_msg_    VARCHAR2(32000);
   count_      NUMBER;
   name_       Message_SYS.name_table;
   value_      Message_SYS.line_table;
BEGIN
   Client_SYS.Add_To_Attr('GATE_ID',                    gate_id_, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION',                Message_SYS.Find_Attribute(info_msg_, 'DESCRIPTION', ''), attr_);
   Client_SYS.Add_To_Attr('ACTIVE_DB',                  Message_SYS.Find_Attribute(info_msg_, 'ACTIVE_DB', ''), attr_);
   Client_SYS.Add_To_Attr('UNRESTRICTED_VALIDATION_DB', Message_SYS.Find_Attribute(info_msg_, 'UNRESTRICTED_VALIDATION_DB', ''), attr_);
   Client_SYS.Add_To_Attr('MESSAGE',                    Message_SYS.Find_Attribute(info_msg_, 'MESSAGE', ''), attr_);
   IF Check_Exist___ (gate_id_) THEN
      IF Installation_SYS.Get_Installation_Mode THEN
         --Since SecCheckpointGateParam has CASCADE reference to SecCheckpointGate, deleting records from both sec_checkpoint_gate_param_tab
         --and sec_checkpoint_gate_tab
         DELETE
            FROM sec_checkpoint_gate_param_tab
            WHERE gate_id = gate_id_;
            
         DELETE
            FROM sec_checkpoint_gate_tab
            WHERE gate_id = gate_id_;
      ELSE
         Get_Id_Version_By_Keys___ (objid_, objversion_, gate_id_);
         Remove__ (info_, objid_, objversion_, 'DO' );
      END IF;      
   END IF;
   Sec_Checkpoint_Gate_API.New__(info_, objid_, objversion_, attr_, 'DO');
   -- Security Checkpoint Gate parameters
   par_msg_ := Message_SYS.Find_Attribute(info_msg_, 'PARAMETERS', '');
   Message_SYS.Get_Attributes (par_msg_, count_, name_, value_ );
   FOR i IN 1..count_ LOOP
      Client_SYS.Add_To_Attr('GATE_ID',  gate_id_,  par_attr_);
      Client_SYS.Add_To_Attr('NAME',     name_(i),  par_attr_);
      Client_SYS.Add_To_Attr('DATATYPE', value_(i), par_attr_);
      Sec_Checkpoint_Gate_Param_API.New__(info_, objid_, objversion_, par_attr_, 'DO');
   END LOOP;
END Register;


PROCEDURE Unregister (
   gate_id_  IN VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, gate_id_);
   Remove__ (info_, objid_, objversion_, 'DO' );
END Unregister;

PROCEDURE Activate(
   gate_id_ IN VARCHAR2
)
IS
   newrec_ SEC_CHECKPOINT_GATE_TAB%ROWTYPE;
BEGIN
   IF Get_Active_Db(gate_id_) = 'FALSE' THEN 
      newrec_ := Get_Object_By_Keys___(gate_id_);
      newrec_.active := Fnd_Boolean_API.DB_TRUE;
      Modify___(newrec_);
   END IF;  
END Activate;

PROCEDURE Deactivate(
   gate_id_ IN VARCHAR2
)
IS
   newrec_ SEC_CHECKPOINT_GATE_TAB%ROWTYPE;
BEGIN
   IF Get_Active_Db(gate_id_) = 'TRUE' THEN 
      newrec_ := Get_Object_By_Keys___(gate_id_);
      newrec_.active := Fnd_Boolean_API.DB_FALSE;
      Modify___(newrec_);
   END IF;  
END Deactivate;