-----------------------------------------------------------------------------
--
--  Logical unit: LoseWinReason
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160701  NiAslk  STRSC-1966, Removed BLOCKED_FOR_USE
--  131113  RoJalk  Hooks implementation - refactor files.
--  130826  MaRalk  PBR-1510, Handled Basic Data Translation for the LU. Make reason_description private.
--  121212  Maabse  Added BLOCKED_FOR_USE
--  121212  Maabse  Aligned to Template version 2.5
--  121017  MaRalk  Added method Exist_Reason_Type.
--  120202  MaRalk  Correcting model errors generated from PLSQL implementation test - 
--  120202          Increased length as 200 in LOSE_WIN_REASON-LOSE_WIN column.
--  060726  ThGulk  Added Objid instead of rowid in Procedure Insert__
--  060112  NaWalk  Changed 'SELECT OBJID INTO....' statement with RETURNING OBJID INTO objid_;.
--  040220  IsWilk  Removed the SUBSTRB for Unicode Changes.
----------------- Edge Package Group 3 Unicode Changes----------------------- 
--  000906  CaSt  Changed comment on reason_id to uppercase
--  000822  JakH  Changed default value to send client value (nomore check box)
--  000719  TFU   Merging from Chameleon
--  000404  TFU   Resson of Lose or Win
--                Add default Value to Prepare_Insert
------------------------ 12.1
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

   Client_SYS.Add_To_Attr('LOSE_WIN', Lose_Win_API.Decode('WIN'), attr_);
   Client_SYS.Add_To_Attr('USED_BY_ENTITY', Reason_Used_By_API.Decode('BO') || ';' || Reason_Used_By_API.Decode('SQ'), attr_);

END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Exist (
   reason_id_ IN VARCHAR2,
   entity_    IN VARCHAR2,
   lose_win_  IN VARCHAR2)
   
IS
   list_ VARCHAR2(500);
   find_ VARCHAR2(100);
BEGIN
   Exist(reason_id_, TRUE);
   
   IF ( Get_Lose_Win_Db( reason_id_ ) <> lose_win_ ) THEN
      Error_Sys.Record_General(lu_name_, 'USEDBYENTITY: Lose Win Reason :P1 is not valid for :P2.', 
        reason_id_, Reason_Used_By_Api.Decode( entity_ ));
   END IF;
   
   
   list_ :=  Get_Used_By_Entity_Db(reason_id_);
   find_ := '^' || entity_ || '^';
   
   IF ( list_ IS NULL OR INSTR( list_, find_ ) = 0 ) THEN
      Error_Sys.Record_General(lu_name_, 'USEDBYENTITY: Lose Win Reason :P1 is not valid for :P2.', 
        reason_id_, Reason_Used_By_Api.Decode( entity_ ));
   END IF;
   
END Exist;

@UncheckedAccess
FUNCTION Get_Reason_Description (
   reason_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ lose_win_reason_tab.reason_description%TYPE;
BEGIN
   IF (reason_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      reason_id_), 1, 100);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT reason_description
   INTO   temp_
   FROM   lose_win_reason_tab
   WHERE  reason_id = reason_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(reason_id_, 'Get_Reason_Description');
END Get_Reason_Description;


@UncheckedAccess
FUNCTION Exist_Reason_Type (
   reason_id_   IN VARCHAR2,
   reason_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   LOSE_WIN_REASON_TAB
      WHERE reason_id = reason_id_
      AND   lose_win = reason_type_;     
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO temp_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN ('TRUE');
   END IF;
   CLOSE exist_control;
   RETURN ('FALSE');
END Exist_Reason_Type;



