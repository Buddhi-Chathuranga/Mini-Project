-----------------------------------------------------------------------------
--
--  Logical unit: InvPartConfigCondition
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  111216  MalLlk Modified view INV_PART_CONFIG_CONDITION_LOV to not to fetch the data from condition_code_tab directly. 
--  111209  MalLlk Modified view INV_PART_CONFIG_CONDITION_LOV by adding UNION to condition_code_tab 
--  111209         and removing the column configuration_id.
--  111028  MalLlk Added view INV_PART_CONFIG_CONDITION_LOV.
--  110720  MaEelk Added used allowed site filter to INV_PART_CONFIG_CONDITION
--  110525  THIMLK Enable LOV flag on some fields of the view, INV_PART_CONFIG_CONDITION.
--  100505  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  060118  SuJalk Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  ---------------------------------------13.3.0----------------------------
--  031014  PrJalk  Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  030812  SuAmlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Inserts a new record
--   Inserts a new record.
PROCEDURE New (
   info_ OUT VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   newrec_     INV_PART_CONFIG_CONDITION_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   info_ := Client_SYS.Get_All_Info;
END New;


-- Modify_Estimated_Cost
--   Updates the Estimated Cost per Condition Code
--   Updates the Estimated Cost per Condition Code.
PROCEDURE Modify_Estimated_Cost (
   info_ OUT VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_              NUMBER := NULL;
   newrec_           INV_PART_CONFIG_CONDITION_TAB%ROWTYPE;
   oldrec_           INV_PART_CONFIG_CONDITION_TAB%ROWTYPE;
   name_             VARCHAR2(30);
   value_            VARCHAR2(2000);
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   condition_code_   VARCHAR2(10);
   contract_         VARCHAR2(5);
   part_no_          VARCHAR2(25);
   configuration_id_ VARCHAR2(50);
   estimated_cost_   NUMBER;
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONDITION_CODE') THEN
         condition_code_ := value_;
      ELSIF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
      ELSIF (name_ = 'CONFIGURATION_ID') THEN
         configuration_id_ := value_;
      ELSIF (name_ = 'ESTIMATED_COST') THEN
         estimated_cost_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
   END LOOP;

   oldrec_ := Lock_By_Keys___(condition_code_, contract_, part_no_, configuration_id_);
   newrec_ := oldrec_ ;
   newrec_.estimated_cost := estimated_cost_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   info_ := Client_SYS.Get_All_Info;
END Modify_Estimated_Cost;


-- Check_Exist
--   Checks whether there is an existing record for the given inventory part,
--   contract, configuration id and condition code
--   Checks whether there is an existing record for the given inventory part,
--   contract, condition code and configuration Id.
FUNCTION Check_Exist (
   condition_code_   IN VARCHAR2,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Check_Exist___(condition_code_, contract_, part_no_, configuration_id_) THEN 
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;



