-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartRevision
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140314  MaEdlk   Bug 115505, Added Pragma to the methods Get_Eng_Chg_Level.
--  130805  UdGnlk  TIBE-883, Removed the dynamic code and modify to conditional compilation.
--  120315  MaEelk  Removed the last parameter TRUE in call General_SYS.Init_Method from  non-implementation methods.
--  111117  AndDse  SMA-727, Removed General_SYS.Init from Get_Latest_Eng_Chg_Level since pragma was added.
--  111027  NISMLK  SMA-285, Increased eng_chg_level and latest_eng_chg_level_ length to VARCHAR2(6).
--  100507  KRPELK  Merge Rose Method Documentation.
--  100118  MaMalk  Replaced inst_PartRevisionInt_ with inst_PartRevision_.
--  100113  MaMalk  Replaced calls to Part_Revision_Int_API with Part_Revision_API.
------------------------------------------ 14.0.0 ---------------------------
--  090622  HoInlk  Bug 83802, Added parameter replace_revision_ to Get_Matched_Eng_Chg_Level.
--  090602  HoInlk  Bug 82024, Added method Get_Matched_Eng_Chg_Level.
--  080314  NiBalk  Bug 72159, Added new public method, Check_Exist.
--  060124  NiDalk  Added Assert safe annotation. 
--  060119  SeNslk  Modified the template version as 2.3 and added UNDEFINE 
--  060119          according to the new template.
--  -------------------------------------- 13.3.0 ---------------------------
--  040129  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  010410  DaJoLK  Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and
--                  TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  000925  JOHESE  Added undefines.
--  000417  NISOSE  Added General_SYS.Init_Method in Get_Eng_Chg_Level and Get_Latest_Eng_Chg_Level.
--  990421  JOHW    General performance improvements.
--  990409  JOHW    Upgraded to performance optimized template.
--  980904  SHVE    Corrected dynamic sql bind variable statements.
--  980826  LEPE    Correction to method Exist. Should only approve
--                  eng_chg_level = 1 when PartRevisionInt is not installed.
--  980813  SHVE    Recreated as a Utility L
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Exist
--   Checks the existence of a  revision.
@UncheckedAccess
PROCEDURE Exist (
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   eng_chg_level_ IN VARCHAR2 )
IS   
BEGIN
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      Part_Revision_API.Exist(contract_, part_no_, eng_chg_level_); 
   $ELSE
      Inventory_Part_API.Exist(contract_, part_no_);
      IF (eng_chg_level_ != '1') THEN
         Error_SYS.Record_General(lu_name_,'INVALIDREVISION: EC must be equal to 1');
      END IF;
   $END
END Exist;


-- Get_Latest_Eng_Chg_Level
--   Returns Latest Eng_Chg_Level.
@UncheckedAccess
FUNCTION Get_Latest_Eng_Chg_Level (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS    
    latest_eng_chg_level_  VARCHAR2(6);
BEGIN
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      latest_eng_chg_level_ := Part_Revision_API.Get_Latest_Revision(contract_, part_no_); 
   $ELSE
      latest_eng_chg_level_ := '1';
   $END
  RETURN latest_eng_chg_level_;
END Get_Latest_Eng_Chg_Level;



-- Get_Eng_Chg_Level
--   Returns Eng_Chg_Level.
@UncheckedAccess
FUNCTION Get_Eng_Chg_Level (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   eff_phase_in_date_ IN DATE ) RETURN VARCHAR2
IS    
    eng_chg_level_         VARCHAR2(6);
BEGIN
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      eng_chg_level_ := Part_Revision_API.Get_Revision_By_Date(contract_, part_no_, eff_phase_in_date_); 
   $ELSE
      eng_chg_level_ := '1';
   $END
  RETURN eng_chg_level_;

END Get_Eng_Chg_Level;


FUNCTION Check_Exist (
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   eng_chg_level_ IN VARCHAR2 ) RETURN BOOLEAN
IS    
    revision_exist_        NUMBER;
    temp_                  BOOLEAN := FALSE;
BEGIN
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      revision_exist_ := Part_Revision_API.Revision_Exists(contract_, part_no_, eng_chg_level_);      
      IF (revision_exist_ = 1) THEN
         temp_ := TRUE;
      END IF;
   $ELSE
      IF (eng_chg_level_ = '1') THEN
         temp_ := TRUE;
      END IF;
   $END
   RETURN temp_;
END Check_Exist;


PROCEDURE Get_Matched_Eng_Chg_Level (
   to_eng_chg_level_   IN OUT VARCHAR2, 
   from_contract_      IN     VARCHAR2,
   to_contract_        IN     VARCHAR2,
   part_no_            IN     VARCHAR2,
   from_eng_chg_level_ IN     VARCHAR2,
   replace_revision_   IN     BOOLEAN )
IS
   rep_revision_  NUMBER := 0;
BEGIN

   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      IF replace_revision_ THEN
         rep_revision_ := 1;
      END IF;
      Part_Revision_API.Get_Matched_Eng_Chg_Level(to_eng_chg_level_,
                                                  from_contract_,
                                                  to_contract_,
                                                  part_no_,
                                                  from_eng_chg_level_,
                                                  rep_revision_ = 1);      
   $ELSE
     to_eng_chg_level_ := NVL(to_eng_chg_level_, '1');
   $END
END Get_Matched_Eng_Chg_Level;



