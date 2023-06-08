-----------------------------------------------------------------------------
--
--  Logical unit: PartyIdentitySeries
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990820  BmEk    Created
--  000505  Camk    Get_Next_Identity is modified. NULL is returned if the given 
--                  party_type does not exist in the identity series table
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  041209  Kagalk  LCS Merge (45424)
--  050919  Hecolk  LCS Merge - Bug 52720, Added PROCEDURE Update_Next_Value
--  100816  Hiralk  Bug 92395, Added PROCEDURE Get_Next_Value
--  130724  SudJlk  Bug 110388, Modified Update_Next_Identity() and Update_Next_Value(
--  140728  Hecolk  PRFI-41, Removed method Update_Next_Identity() 
--  140922  MaIklk  Added Insert_Next_Value().
--  210212  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in methods Insert_Next_Value and Update_Next_Value
-----------------------------------------------------------------------------

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
   Client_SYS.Add_To_Attr('NEXT_VALUE', '1', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     party_identity_series_tab%ROWTYPE,
   newrec_ IN OUT party_identity_series_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS      
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   IF (oldrec_.next_value > newrec_.next_value) THEN
      Error_SYS.Record_General(lu_name_, 'VALUE_ERROR: You are not allowed to register a lower value then before');
   END IF;
END Check_Update___;
 
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Next_Identity (
   next_value_ OUT VARCHAR2,
   party_type_ IN VARCHAR2 )
IS
   oldrec_        party_identity_series_tab%ROWTYPE;
   newrec_        party_identity_series_tab%ROWTYPE;
   attr_          VARCHAR2(500);
   objid_         party_identity_series.objid%TYPE;
   objversion_    party_identity_series.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, party_type_);
   -- NULL is returned if the given party_type does not exist in the identity series table
   IF (objid_ IS NULL) THEN
      next_value_ := NULL;
   ELSE
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      IF (oldrec_.next_value IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOTIDSERIES: No identity series defined for party type :P1.', Party_Type_API.Decode(party_type_));
      END IF;
      newrec_ := oldrec_;
      newrec_.next_value := oldrec_.next_value + 1;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('NEXT_VALUE', newrec_.next_value, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
      next_value_ := TO_CHAR(oldrec_.next_value);
   END IF;
END Get_Next_Identity;


PROCEDURE Update_Next_Value (
   next_value_ IN NUMBER,
   party_type_ IN VARCHAR2 )
IS
   newrec_        party_identity_series_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(party_type_);
   newrec_.next_value := next_value_;   
   Modify___(newrec_);
END Update_Next_Value;


PROCEDURE Insert_Next_Value (
   next_value_ IN NUMBER,
   party_type_ IN VARCHAR2 )
IS   
   newrec_        party_identity_series_tab%ROWTYPE;
BEGIN
   newrec_.party_type := party_type_;  
   newrec_.next_value := next_value_;   
   New___(newrec_);   
END Insert_Next_Value;


PROCEDURE Get_Next_Value (
   next_value_    OUT NUMBER,
   party_type_db_ IN  VARCHAR2 )
IS
   CURSOR get_attr IS
      SELECT next_value
      FROM   party_identity_series_tab
      WHERE  party_type = party_type_db_
      FOR UPDATE;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO next_value_;
   CLOSE get_attr;
END Get_Next_Value;



