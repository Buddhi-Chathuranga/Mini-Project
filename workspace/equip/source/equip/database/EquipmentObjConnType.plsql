-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjConnType
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961005  TOWI  Recreated from Rose model using Developer's Workbench 1.2.2.
--  961219  ADBR  Merged with new templates.
--  970401  TOWI  Adjusted to new templates in Foundation1 1.2.2c.
--  970919  CAJO  Converted to F1 2.0. Changed table name to equipment_obj_conn_type_tab.
--                Changed column description to unformatted.
--  971001  STSU  Added methods Check_Exist and Create_Connection_Type.
--  980423  CAJO  Corrected call to Check_Exist.
--  990112  MIBO  SKY.0208 and SKY.0209 Performance issues in Maintenance 5.4.0.
--  981230  ANCE  Checked and updated 'Uppercase/Unformatted' (SKY.0206).
--  991215 PJONSE Changed template due to performance improvement
--  131121 NEKOLK PBSA-1808, Refactored and splitted.
--  ---------------------------- APPS 10 -------------------------------------
--  170830 sawalk STRSA-1044, Data Validity changes, Overridden method Raise_Record_Access_Blocked___ is added.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Access_Blocked___ (
    connection_type_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Access_Blocked(lu_name_, 'ACCESSBLOCKED: Connection Type :P1 is blocked for use.', connection_type_);
   super(connection_type_);
END Raise_Record_Access_Blocked___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Check_Exist (
   connection_type_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(connection_type_)) THEN
      Return(1);
   ELSE
      Return(0);
   END IF;

END Check_Exist;


PROCEDURE Create_Connection_Type (
   connection_type_ IN VARCHAR2,
   description_ IN VARCHAR2 )
IS
   newrec_       equipment_obj_conn_type_tab%ROWTYPE;
BEGIN
   newrec_.connection_type := connection_type_;
   newrec_.descr := description_;
   New___(newrec_);
END Create_Connection_Type;



