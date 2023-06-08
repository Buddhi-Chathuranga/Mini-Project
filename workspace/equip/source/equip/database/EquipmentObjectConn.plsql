-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjectConn
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950802  SLKO    Created.
--  950831  NILA    Added EXIT at end of file and modified procedure Exist not
--                  to validate NULL values.
--  950907  TOWI    Added viewbody and view comments.
--                  Added buisness logic in insert___ and a new procedure for
--                  validation Validate_Column.
--  950914  NILA    Added procedure Count_Connections. Enabled EXIT at end of
--                  file.
--  951020  NILA    Recreated using Base Table to Logical Unit Generator 1.0.
--                  Added call to procedure Remove_Cross_Connection in
--                  procedure Delete___.
--  960521  JOSC    Removed SYS4 dependencies and added call to Init_Method.
--  960923  CAJO    Generated from Rose-model using Developer's Workbench.
--  960927  JOBI    Removed Validate_Column.
--  960930  MANI    Removed procedures New_Cross_Connection__ and
--                  Remove_Cross_Connection__. Modified procedures Insert___
--                  and Delete___.
--  961006  TOWI    Generated from Rose-model using Developer's Workbench 1.2.2.
--  961219  ADBR    Merged with new templates.
--  970402  TOWI    Adjusted to new templates in Foundation 1.2.2c.
--  970919  CAJO    Converted to F1 2.0. Changed table name to equipment_object_conn_tab.
--  971001  STSU    Added methods Check_Exist and Create_Connection.
--  971102  CAJO    Changed references to EquipmentAllObject.
--  971112  ERJA    Made correction in Check_Exist.
--  971120  ERJA    Added Contract
--  971127  HAST    Made correction in Create_Connection.
--  971204  TOWI    Changed paraemeter order for exist against Equipment_Object_Api.
--  971218  ERJA    Corrections in insert cross connection
--  980108  ERJA    Added Contract_consist in Prepare_insert
--  980303  ERJA    Added PROCEDURE PROCEDURE Remove_Obj_Conn.
--  980403  TOWI    Removed General_SYS.Init_Method in check_exist
--  980405  MNYS    Support Id: 2840. Changed reference in view to EquipmentObject
--                  for columns mch_code and mch_code_consist.
--  981230  ANCE    Checked and updated 'Uppercase/Unformatted' (SKY.0206).
--  990312  RAFA    Call 10835.Modified unpack_check_insert.It is not possible to connect an object that has status scrapped.
--  990614  ERJA    Removed commas in errormesages.
--  991222  RECASE  Changed template due to performance improvement.
--  010426  SISALK  Fixed General_SYS.Init_Method in Remove_Obj_Conn
--  ************************************* AD 2002-3 BASELINE ********************************************
--  020604  CHAMLK  Modified the length of the MCH_CODE from 40 to 100
--  040518  HIWELK  Bug 44785 Modified Unpack_Check_Insert___
--  040622  DIAMLK  Merged bug corrections.
--  081016  arnilk  Bug Id 77768.Replace the Utility_SYS.Get_user methode into Fnd_Session_API.Get_Fnd_User methode
--  -------------------------Project Eagle-----------------------------------
--  091106  SaFalk  IID - ME310: Removed bug comment tags.
--  -------------------------Project Eagle-----------------------------------
--  091019  LoPrlk  EAME-182: Remove unused internal variables in EQUIP.
--  101021  NIFRSE  Bug 93384, Updated view column prompts to 'Object Site'.
--  110127  NeKolk  EANE-3710 added User_Allowed_Site_API.Authorized filte to View EQUIPMENT_OBJECT_CONN .
--  110221  SaFalk  EANE-4424, Modified Remove_Obj_Conn, to use &TABLE.
--  -------------------------Project Black Pearl---------------------------------------------------------------
--  130613 MADGLK BLACK-65 , Removed MAINTENANCE_OBJECT_API method calls
--  131121 NEKOLK  PBSA-1818, Refactored and splitted.
--  131216 HASTSE  PBSA-3288, Review fix
--  140812 HASTSE  Code Clean up
-----------------------------------------------------------------------------
--  150728 CLEKLK  Bug 123214, Modified Has_Connection().
--  181018 CLEKLK  SAUXXW4-1248, Added Get_Connection_Count
--  220111  KrRaLK  AM21R2-2950, Equipment object is given a sequence number as the primary key (while keeping the old Object ID 
--                  and Site as a unique constraint), so inlined the business logic to handle the new design of the EquipmentObject.

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr( 'CONTRACT_CONSIST',User_Default_API.Get_Contract,attr_); 
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT EQUIPMENT_OBJECT_CONN_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS

   cross_objid_        VARCHAR2(80);
   cross_objversion_   VARCHAR2(2000);
   cross_newrec_       EQUIPMENT_OBJECT_CONN_TAB%ROWTYPE;
   cross_attr_         VARCHAR2(2000);

BEGIN
   -- Insert of FIRST Connection record
   super(objid_, objversion_, newrec_, attr_);
          
   -- Insert if SECOND record for Cross reference       
--   cross_newrec_.contract_consist  := newrec_.contract;
--   cross_newrec_.mch_code_consist  := newrec_.mch_code;
--   cross_newrec_.contract          := newrec_.contract_consist;
--   cross_newrec_.mch_code          := newrec_.mch_code_consist;
   cross_newrec_.consist_equ_object_seq := newrec_.equipment_object_seq;
   cross_newrec_.equipment_object_seq := newrec_.consist_equ_object_seq;
   cross_newrec_.connection_type   := newrec_.connection_type;
   super(cross_objid_, cross_objversion_, cross_newrec_, cross_attr_);
      
END Insert___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN EQUIPMENT_OBJECT_CONN_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
-- Removal of cross connection is made.
   DELETE
      FROM  equipment_object_conn_tab
      WHERE equipment_object_seq = remrec_.consist_equ_object_seq
      AND   consist_equ_object_seq = remrec_.equipment_object_seq
      AND   connection_type = remrec_.connection_type;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT equipment_object_conn_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   contract_          equipment_object_tab.contract%TYPE;
   mch_code_ equipment_object_tab.mch_code%TYPE;
   contract_consist_ equipment_object_tab.contract%TYPE;
   mch_code_consist_ equipment_object_tab.mch_code%TYPE;
   
BEGIN  
   super(newrec_, indrec_, attr_);
   
   contract_ := Equipment_Object_API.Get_Contract(newrec_.equipment_object_seq);
   mch_code_  := Equipment_Object_API.Get_Mch_code(newrec_.equipment_object_seq);
   contract_consist_ := Equipment_Object_API.Get_Contract(newrec_.consist_equ_object_seq);
   mch_code_consist_  := Equipment_Object_API.Get_Mch_code(newrec_.consist_equ_object_seq);

   -- start:check for scrapped objects
   IF Equipment_Object_Api.Is_Scrapped(contract_, mch_code_)='TRUE' THEN
      Error_SYS.Appl_General(lu_name_,'NEWCONNFORSCRAPOBJ: Object (:P1) cannot be connected to scrapped object (:P2).',contract_consist_,mch_code_);
   END IF;   
   -- Object status control
   IF (EQUIPMENT_OBJECT_API.Get_Operational_Status_Db(contract_consist_,mch_code_consist_) = 'SCRAPPED') THEN
      Error_SYS.Appl_General(lu_name_, 'NOCONOBJ: It is not possible to connect a scrapped object :P1.',mch_code_consist_);
   END IF;
   -- Object status control
   IF (EQUIPMENT_OBJECT_API.Get_Operational_Status_Db(contract_, mch_code_) = 'SCRAPPED') THEN
      Error_SYS.Appl_General(lu_name_, 'NOCONOBJ: It is not possible to connect a scrapped object :P1.',mch_code_);
   END IF;
   
   IF ((contract_consist_ = contract_) AND (mch_code_consist_ = mch_code_)) THEN
      Error_SYS.Appl_General(lu_name_, 'NOSELFCONN: You cannot connect a machine to itself. (:P1 - :P2)', contract_, mch_code_);
   END IF;
   
END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Count_Connections (
   number_of_connections_ IN OUT NUMBER,
   contract_consist_      IN OUT VARCHAR2,
   mch_code_consist_      IN OUT VARCHAR2,
   contract_              IN     VARCHAR2,
   mch_code_              IN     VARCHAR2 )
IS

CURSOR mch_connections_count IS
   SELECT COUNT(*)
   FROM   EQUIPMENT_OBJECT_CONN_TAB equ_con, equipment_object_tab equ_obj
   WHERE  equ_obj.contract = contract_
   AND    equ_obj.mch_code = mch_code_
   AND equ_con.equipment_object_seq = equ_obj.equipment_object_seq;

CURSOR mch_connections_get IS
   SELECT Equipment_Object_API.Get_Contract(consist_equ_object_seq) contract_consist, Equipment_Object_API.Get_Mch_Code(consist_equ_object_seq)  mch_code_consist
   FROM   EQUIPMENT_OBJECT_CONN_TAB equ_con, equipment_object_tab equ_obj
   WHERE  equ_obj.contract = contract_
   AND    equ_obj.mch_code = mch_code_
   AND equ_con.consist_equ_object_seq = equ_obj.equipment_object_seq;

BEGIN
   OPEN  mch_connections_count;
   FETCH mch_connections_count INTO number_of_connections_;
   CLOSE mch_connections_count;
   IF ( number_of_connections_ = 1 ) THEN
      OPEN  mch_connections_get;
      FETCH mch_connections_get INTO contract_consist_, mch_code_consist_;
      CLOSE mch_connections_get;
   END IF;
END Count_Connections;

@UncheckedAccess
FUNCTION Has_Connection (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS 
   has_connection_ NUMBER;
   is_available_   NUMBER;
   
   CURSOR mch_connections IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_CONN_TAB equ_con, equipment_object_tab equ_obj
   WHERE  equ_obj.contract = contract_
   AND    equ_obj.mch_code = mch_code_
   AND equ_con.equipment_object_seq = equ_obj.equipment_object_seq
   AND (SELECT nvl(a.operational_status, b.operational_status) from equipment_object_tab a, part_serial_catalog_tab b
      WHERE  a.part_no = b.part_no(+)
      AND    a.mch_serial_no = b.serial_no(+)
      AND    equ_con.consist_equ_object_seq = a.equipment_object_seq)!= 'SCRAPPED';
   
   CURSOR equipment_object_availability IS
   SELECT 1
   FROM   EQUIPMENT_OBJECT_CONN_TAB equ_con, equipment_object_tab equ_obj
   WHERE  equ_obj.contract = contract_
   AND    equ_obj.mch_code = mch_code_
   AND equ_con.equipment_object_seq = equ_obj.equipment_object_seq
   AND    (SELECT nvl(a.operational_status, b.operational_status) from equipment_object_tab a, part_serial_catalog_tab b
      WHERE  a.part_no = b.part_no(+)
      AND    a.mch_serial_no = b.serial_no(+)
      AND    equ_con.equipment_object_seq = a.equipment_object_seq)!= 'SCRAPPED';

BEGIN
   OPEN  equipment_object_availability;
   FETCH equipment_object_availability INTO is_available_;
   CLOSE equipment_object_availability;
   IF (is_available_ = 1 ) THEN
      OPEN mch_connections;
      FETCH mch_connections INTO has_connection_;
      CLOSE mch_connections;
      IF (has_connection_ = 1) THEN
         RETURN('TRUE');
      ELSE
         RETURN('FALSE');
      END IF;
   END IF;   
   RETURN ('FALSE');
END Has_Connection;

FUNCTION Get_Connection_Count (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2 ) RETURN NUMBER
IS 
   connection_count_ NUMBER;

   CURSOR mch_connections_count IS
   SELECT COUNT(*)
   FROM   EQUIPMENT_OBJECT_CONN_TAB equ_con, equipment_object_tab equ_obj
   WHERE  equ_obj.contract = contract_
   AND    equ_obj.mch_code = mch_code_
   AND equ_con.equipment_object_seq = equ_obj.equipment_object_seq;
   
   BEGIN
      OPEN mch_connections_count;
      FETCH mch_connections_count INTO connection_count_;
      CLOSE mch_connections_count;
      
      RETURN connection_count_;
END Get_Connection_Count;

@UncheckedAccess
FUNCTION Check_Exist (
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   contract_consist_ IN VARCHAR2,
   mch_code_consist_ IN VARCHAR2,
   connection_type_  IN VARCHAR2 ) RETURN NUMBER
IS
   equipment_object_seq_ equipment_object_conn_tab.equipment_object_seq%TYPE;
   consist_equ_object_seq_ equipment_object_conn_tab.consist_equ_object_seq%TYPE;
   
      CURSOR get_equipment_object_seq IS
   SELECT equipment_object_seq
   FROM   equipment_object_tab
   WHERE  contract = contract_
   AND    mch_code = mch_code_;
   
   CURSOR get_consist_object_seq IS
   SELECT equipment_object_seq
   FROM   equipment_object_tab
   WHERE  contract = contract_consist_
   AND    mch_code = mch_code_consist_;
BEGIN
      OPEN get_equipment_object_seq;
      FETCH get_equipment_object_seq INTO equipment_object_seq_;
      CLOSE get_equipment_object_seq;
      
            OPEN get_consist_object_seq;
      FETCH get_consist_object_seq INTO consist_equ_object_seq_;
      CLOSE get_consist_object_seq;
   IF (NOT Check_Exist___(equipment_object_seq_, consist_equ_object_seq_, connection_type_)) THEN
      Return(1);
   ELSE
      Return(0);
   END IF;
END Check_Exist;


PROCEDURE Create_Connection (
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   contract_consist_ IN VARCHAR2,
   mch_code_consist_ IN VARCHAR2,
   connection_type_  IN VARCHAR2 )
IS
   newrec_       equipment_object_conn_tab%ROWTYPE;
   equipment_object_seq_ equipment_object_conn_tab.equipment_object_seq%TYPE;
   consist_equ_object_seq_ equipment_object_conn_tab.consist_equ_object_seq%TYPE;
   
   CURSOR get_equipment_object_seq IS
   SELECT equipment_object_seq
   FROM   equipment_object_tab
   WHERE  contract = contract_
   AND    mch_code = mch_code_;
   
   CURSOR get_consist_object_seq IS
   SELECT equipment_object_seq
   FROM   equipment_object_tab
   WHERE  contract = contract_consist_
   AND    mch_code = mch_code_consist_;
BEGIN
   OPEN get_equipment_object_seq;
   FETCH get_equipment_object_seq INTO equipment_object_seq_;
   CLOSE get_equipment_object_seq;
   
   OPEN get_consist_object_seq;
   FETCH get_consist_object_seq INTO consist_equ_object_seq_;
   CLOSE get_consist_object_seq;
   newrec_.equipment_object_seq           := equipment_object_seq_;
   newrec_.consist_equ_object_seq   := consist_equ_object_seq_;
   newrec_.connection_type    := connection_type_;
   New___(newrec_);
END Create_Connection;


PROCEDURE Remove_Obj_Conn (
   contract_ IN VARCHAR2,
   mch_code_ IN VARCHAR2)
IS
   CURSOR getrec IS
      SELECT equ_con.*, equ_con.rowid objid
      FROM   EQUIPMENT_OBJECT_CONN_TAB  equ_con, equipment_object_tab equ_obj
   WHERE  equ_obj.contract = contract_
   AND    equ_obj.mch_code = mch_code_
   AND equ_con.equipment_object_seq = equ_obj.equipment_object_seq;
   
   equipment_object_seq_ equipment_object_conn_tab.equipment_object_seq%TYPE;
   consist_equ_object_seq_ equipment_object_conn_tab.consist_equ_object_seq%TYPE;
   
   CURSOR get_equipment_object_seq(contract_ IN VARCHAR2, mch_code_ IN VARCHAR2) IS
   SELECT equipment_object_seq
   FROM   equipment_object_tab
   WHERE  contract = contract_
   AND    mch_code = mch_code_;
   
   CURSOR get_consist_object_seq(contract_consist_ IN VARCHAR2, mch_code_consist_ IN VARCHAR2) IS
   SELECT equipment_object_seq
   FROM   equipment_object_tab
   WHERE  contract = contract_consist_
   AND    mch_code = mch_code_consist_;
BEGIN
   FOR lurec_ IN getrec LOOP
   DELETE
      FROM  equipment_object_conn_tab
      WHERE rowid = lurec_.objid;

      IF (lurec_.equipment_object_seq IS NOT NULL AND lurec_.consist_equ_object_seq IS NOT NULL) THEN
         -- Removal of cross connection is made.
   DELETE
      FROM  equipment_object_conn_tab
      WHERE equipment_object_seq = lurec_.equipment_object_seq
      AND   consist_equ_object_seq = lurec_.consist_equ_object_seq
      AND   connection_type = lurec_.connection_type;
      END IF;
   END LOOP;
END Remove_Obj_Conn;



